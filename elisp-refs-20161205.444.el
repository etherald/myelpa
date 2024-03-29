;;; elisp-refs.el --- find callers of elisp functions or macros -*- lexical-binding: t; -*-

;; Copyright (C) 2016  

;; Author: Wilfred Hughes <me@wilfred.me.uk>
;; Version: 1.2
;; Package-Version: 20161205.444
;; Keywords: lisp
;; Package-Requires: ((dash "2.12.0") (f "0.18.2") (list-utils "0.4.4") (loop "2.1") (s "1.11.0"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; elisp-refs.el is an Emacs package for finding references to
;; functions, macros or variables. Unlike a dumb text search,
;; elisp-refs.el actually parses the code, so it's never confused by
;; comments or `foo-bar' matching `foo'.
;;
;; See https://github.com/Wilfred/refs.el/blob/master/README.md for
;; more information.

;;; Code:

(require 'list-utils)
(require 'dash)
(require 'f)
(require 'loop)
(require 's)
(eval-when-compile (require 'cl-lib))

(defun elisp-refs--format-int (integer)
  "Format INTEGER as a string, with , separating thousands."
  (let* ((number (abs integer))
         (parts nil))
    (while (> number 999)
      (push (format "%03d" (mod number 1000))
            parts)
      (setq number (/ number 1000)))
    (push (format "%d" number) parts)
    (concat
     (if (< integer 0) "-" "")
     (s-join "," parts))))

(defsubst elisp-refs--start-pos (end-pos)
  "Find the start position of form ending at END-POS
in the current buffer."
  (scan-sexps end-pos -1))

(defun elisp-refs--sexp-positions (buffer start-pos end-pos)
  "Return a list of start and end positions of all the sexps
between START-POS and END-POS (inclusive) in BUFFER.

Positions exclude quote characters, so given 'foo or `foo, we
report the position of the f.

Not recursive, so we don't consider subelements of nested sexps."
  (let ((positions nil))
    (with-current-buffer buffer
      (condition-case _err
          ;; Loop until we can't read any more.
          (loop-while t
            (let* ((sexp-end-pos (let ((parse-sexp-ignore-comments t))
                                   (scan-sexps start-pos 1))))
              ;; If we've reached a sexp beyond the range requested,
              ;; or if there are no sexps left, we're done.
              (when (or (null sexp-end-pos) (> sexp-end-pos end-pos))
                (loop-break))
              ;; Otherwise, this sexp is in the range requested.
              (push (list (elisp-refs--start-pos sexp-end-pos) sexp-end-pos)
                    positions)
              (setq start-pos sexp-end-pos)))
        ;; Terminate when we see "Containing expression ends prematurely"
        (scan-error nil)))
    (nreverse positions)))

(defun elisp-refs--read-buffer-form ()
  "Read a form from the current buffer, starting at point.
Returns a list:
\(form form-start-pos form-end-pos symbol-positions read-start-pos)

SYMBOL-POSITIONS are 0-indexed, relative to READ-START-POS."
  (let* ((read-with-symbol-positions t)
         (read-start-pos (point))
         (form (read (current-buffer)))
         (end-pos (point))
         (start-pos (elisp-refs--start-pos end-pos)))
    (list form start-pos end-pos read-symbol-positions-list read-start-pos)))

(defvar elisp-refs--path nil
  "A buffer-local variable used by `elisp-refs--contents-buffer'.
Internal implementation detail.")

(defun elisp-refs--read-all-buffer-forms (buffer)
  "Read all the forms in BUFFER, along with their positions."
  (with-current-buffer buffer
    (goto-char (point-min))
    (let ((forms nil))
      (condition-case err
          (while t
            (push (elisp-refs--read-buffer-form) forms))
        (error
         (if (or (equal (car err) 'end-of-file)
                 ;; TODO: this shouldn't occur in valid elisp files,
                 ;; but it's happening in helm-utils.el.
                 (equal (car err) 'scan-error))
             ;; Reached end of file, we're done.
             (nreverse forms)
           ;; Some unexpected error, propagate.
           (error "Unexpected error whilst reading %s position %s: %s"
                  (f-abbrev elisp-refs--path) (point) err)))))))

(defun elisp-refs--walk (buffer form start-pos end-pos symbol match-p &optional path)
  "Walk FORM, a nested list, and return a list of sublists (with
their positions) where MATCH-P returns t. FORM is traversed
depth-first (pre-order traversal, left-to-right).

MATCH-P is called with three arguments:
\(SYMBOL CURRENT-FORM PATH).

PATH is the first element of all the enclosing forms of
CURRENT-FORM, innermost first, along with the index of the
current form.

For example if we are looking at h in (e f (g h)), PATH takes the
value ((g . 1) (e . 2)).

START-POS and END-POS should be the position of FORM within BUFFER."
  (cond
   ((funcall match-p symbol form path)
    ;; If this form matches, just return it, along with the position.
    (list (list form start-pos end-pos)))
   ;; Otherwise, recurse on the subforms.
   ((consp form)
    (let ((matches nil)
          ;; Find the positions of the subforms.
          (subforms-positions
           (if (eq (car-safe form) '\`)
               ;; Kludge: `elisp-refs--sexp-positions' excludes the ` when
               ;; calculating positions. So, to find the inner
               ;; positions when walking from `(...) to (...), we
               ;; don't need to increment the start posion.
               (cons nil (elisp-refs--sexp-positions buffer start-pos end-pos))
             ;; Calculate the positions after the opening paren.
             (elisp-refs--sexp-positions buffer (1+ start-pos) end-pos))))
      ;; For each subform, recurse if it's a list, or a matching symbol.
      (--each (-zip form subforms-positions)
        (-let [(subform subform-start subform-end) it]
          (when (or
                 (and (consp subform) (not (list-utils-improper-p subform)))
                 (and (symbolp subform) (eq subform symbol)))
            (-when-let (subform-matches
                        (elisp-refs--walk
                         buffer subform
                         subform-start subform-end
                         symbol match-p
                         (cons (cons (car-safe form) it-index) path)))
              (push subform-matches matches)))))

      ;; Concat the results from all the subforms.
      (apply #'append (nreverse matches))))))

;; TODO: condition-case (condition-case ... (error ...)) is not a call
;; TODO: (cl-destructuring-bind (foo &rest bar) ...) is not a call
;; TODO: letf, cl-letf, -let, -let*
(defun elisp-refs--function-p (symbol form path)
  "Return t if FORM looks like a function call to SYMBOL."
  (cond
   ((not (consp form))
    nil)
   ;; Ignore (defun _ (SYMBOL ...) ...)
   ((or (equal (car path) '(defsubst . 2))
        (equal (car path) '(defun . 2))
        (equal (car path) '(defmacro . 2))
        (equal (car path) '(cl-defun . 2)))
    nil)
   ;; Ignore (lambda (SYMBOL ...) ...)
   ((equal (car path) '(lambda . 1))
    nil)
   ;; Ignore (let (SYMBOL ...) ...)
   ;; and (let* (SYMBOL ...) ...)
   ((or
     (equal (car path) '(let . 1))
     (equal (car path) '(let* . 1)))
    nil)
   ;; Ignore (let ((SYMBOL ...)) ...)
   ((or
     (equal (cl-second path) '(let . 1))
     (equal (cl-second path) '(let* . 1)))
    nil)
   ;; (SYMBOL ...)
   ((eq (car form) symbol)
    t)
   ;; (foo ... #'SYMBOL ...)
   ((--any-p (equal it (list 'function symbol)) form)
    t)
   ;; (funcall 'SYMBOL ...)
   ((and (eq (car form) 'funcall)
         (equal `',symbol (cl-second form)))
    t)
   ;; (apply 'SYMBOL ...)
   ((and (eq (car form) 'apply)
         (equal `',symbol (cl-second form)))
    t)))

(defun elisp-refs--macro-p (symbol form path)
  "Return t if FORM looks like a macro call to SYMBOL."
  (cond
   ((not (consp form))
    nil)
   ;; Ignore (defun _ (SYMBOL ...) ...)
   ((or (equal (car path) '(defsubst . 2))
        (equal (car path) '(defun . 2))
        (equal (car path) '(defmacro . 2)))
    nil)
   ;; Ignore (lambda (SYMBOL ...) ...)
   ((equal (car path) '(lambda . 1))
    nil)
   ;; Ignore (let (SYMBOL ...) ...)
   ;; and (let* (SYMBOL ...) ...)
   ((or
     (equal (car path) '(let . 1))
     (equal (car path) '(let* . 1)))
    nil)
   ;; Ignore (let ((SYMBOL ...)) ...)
   ((or
     (equal (cl-second path) '(let . 1))
     (equal (cl-second path) '(let* . 1)))
    nil)
   ;; (SYMBOL ...)
   ((eq (car form) symbol)
    t)))

;; Looking for a special form is exactly the same as looking for a
;; macro.
(defalias 'elisp-refs--special-p 'elisp-refs--macro-p)

(defun elisp-refs--variable-p (symbol form path)
  "Return t if this looks like a variable reference to SYMBOL.
We consider parameters to be variables too."
  (cond
   ((consp form)
    nil)
   ;; Ignore (defun _ (SYMBOL ...) ...)
   ((or (equal (car path) '(defsubst . 1))
        (equal (car path) '(defun . 1))
        (equal (car path) '(defmacro . 1))
        (equal (car path) '(cl-defun . 1)))
    nil)
   ;; (let (SYMBOL ...) ...) is a variable, not a function call.
   ((or
     (equal (cl-second path) '(let . 1))
     (equal (cl-second path) '(let* . 1)))
    t)
   ;; (lambda (SYMBOL ...) ...) is a variable
   ((equal (cl-second path) '(lambda . 1))
    t)
   ;; (let ((SYMBOL ...)) ...) is also a variable.
   ((or
     (equal (cl-third path) '(let . 1))
     (equal (cl-third path) '(let* . 1)))
    t)
   ;; Ignore (SYMBOL ...) otherwise, we assume it's a function/macro
   ;; call.
   ((equal (car path) (cons symbol 0))
    nil)
   ((eq form symbol)
    t)))

;; TODO: benchmark building a list with `push' rather than using
;; mapcat.
(defun elisp-refs--read-and-find (buffer symbol match-p)
  "Read all the forms in BUFFER, and return a list of all forms that
contain SYMBOL where MATCH-P returns t.

For every matching form found, we return the form itself along
with its start and end position."
  (-non-nil
   (--mapcat
    (-let [(form start-pos end-pos symbol-positions _read-start-pos) it]
      ;; Optimisation: don't bother walking a form if contains no
      ;; references to the symbol we're looking for.
      (when (assq symbol symbol-positions)
        (elisp-refs--walk buffer form start-pos end-pos symbol match-p)))
    (elisp-refs--read-all-buffer-forms buffer))))

(defun elisp-refs--read-and-find-symbol (buffer symbol)
  "Read all the forms in BUFFER, and return a list of all
positions of SYMBOL."
  (-non-nil
   (--mapcat
    (-let [(_ _ _ symbol-positions read-start-pos) it]
      (--map
       (-let [(sym . offset) it]
         (when (eq sym symbol)
           (-let* ((start-pos (+ read-start-pos offset))
                   (end-pos (+ start-pos (length (symbol-name sym)))))
             (list sym start-pos end-pos))))
       symbol-positions))

    (elisp-refs--read-all-buffer-forms buffer))))

(defun elisp-refs--filter-obarray (pred)
  "Return a list of all the items in `obarray' where PRED returns t."
  (let (symbols)
    (mapatoms (lambda (symbol)
                (when (and (funcall pred symbol)
                           (not (equal (symbol-name symbol) "")))
                  (push symbol symbols))))
    symbols))

(defun elisp-refs--loaded-files ()
  "Return a list of all files that have been loaded in Emacs.
Where the file was a .elc, return the path to the .el file instead."
  (let ((elc-paths (-non-nil (mapcar #'-first-item load-history))))
    (-non-nil
     (--map
      (let ((el-name (format "%s.el" (f-no-ext it)))
            (el-gz-name (format "%s.el.gz" (f-no-ext it))))
        (cond ((f-exists? el-name) el-name)
              ((f-exists? el-gz-name) el-gz-name)
              ;; Ignore files where we can't find a .el file.
              (t nil)))
      elc-paths))))

(defun elisp-refs--contents-buffer (path)
  "Read PATH into a disposable buffer, and return it.
Works around the fact that Emacs won't allow multiple buffers
visiting the same file."
  (let ((fresh-buffer (generate-new-buffer (format "refs-%s" path))))
    (with-current-buffer fresh-buffer
      (setq-local elisp-refs--path path)
      (insert-file-contents path)
      ;; We don't enable emacs-lisp-mode because it slows down this
      ;; function significantly. We just need the syntax table for
      ;; scan-sexps to do the right thing with comments.
      (set-syntax-table emacs-lisp-mode-syntax-table))
    fresh-buffer))

(defvar elisp-refs--highlighting-buffer
  nil
  "A temporary buffer used for highlighting.
Since `elisp-refs--syntax-highlight' is a hot function, we
don't want to create lots of temporary buffers.")

(defun elisp-refs--syntax-highlight (str)
  "Apply font-lock properties to a string STR of Emacs lisp code."
  ;; Ensure we have a highlighting buffer to work with.
  (unless (and elisp-refs--highlighting-buffer
               (buffer-live-p elisp-refs--highlighting-buffer))
    (setq elisp-refs--highlighting-buffer
          (generate-new-buffer " *refs-highlighting*"))
    (with-current-buffer elisp-refs--highlighting-buffer
      (delay-mode-hooks (emacs-lisp-mode))))
  
  (with-current-buffer elisp-refs--highlighting-buffer
    (erase-buffer)
    (insert str)
    (if (fboundp 'font-lock-ensure)
        (font-lock-ensure)
      (with-no-warnings
        (font-lock-fontify-buffer)))
    (buffer-string)))

(defun elisp-refs--replace-tabs (string)
  "Replace tabs in STRING with spaces."
  ;; This is important for unindenting, as we may unindent by less
  ;; than one whole tab.
  (s-replace "\t" (s-repeat tab-width " ") string))

(defun elisp-refs--lines (string)
  "Return a list of all the lines in STRING.
'a\nb' -> ('a\n' 'b')"
  (let ((lines nil))
    (while (> (length string) 0)
      (let ((index (s-index-of "\n" string)))
        (if index
            (progn
              (push (substring string 0 (1+ index)) lines)
              (setq string (substring string (1+ index))))
          (push string lines)
          (setq string ""))))
    (nreverse lines)))

(defun elisp-refs--map-lines (string fn)
  "Execute FN for each line in string, and join the result together."
  (let ((result nil))
    (dolist (line (elisp-refs--lines string))
      (push (funcall fn line) result))
    (apply #'concat (nreverse result))))

(defun elisp-refs--unindent-rigidly (string)
  "Given an indented STRING, unindent rigidly until
at least one line has no indent.

STRING should have a 'elisp-refs-start-pos property. The returned
string will have this property updated to reflect the unindent."
  (let* ((lines (s-lines string))
         ;; Get the leading whitespace for each line.
         (indents (--map (car (s-match (rx bos (+ whitespace)) it))
                         lines))
         (min-indent (-min (--map (length it) indents))))
    (propertize
     (elisp-refs--map-lines
      string
      (lambda (line) (substring line min-indent)))
     'elisp-refs-unindented min-indent)))

(defun elisp-refs--containing-lines (buffer start-pos end-pos)
  "Return a string, all the lines in BUFFER that are between
START-POS and END-POS (inclusive).

For the characters that are between START-POS and END-POS,
propertize them."
  (let (expanded-start-pos expanded-end-pos)
    (with-current-buffer buffer
      ;; Expand START-POS and END-POS to line boundaries.
      (goto-char start-pos)
      (beginning-of-line)
      (setq expanded-start-pos (point))
      (goto-char end-pos)
      (end-of-line)
      (setq expanded-end-pos (point))

      ;; Extract the rest of the line before and after the section we're interested in.
      (let* ((before-match (buffer-substring expanded-start-pos start-pos))
             (after-match (buffer-substring end-pos expanded-end-pos))
             ;; Concat the extra text with the actual match, ensuring we
             ;; highlight the match as code, but highlight the rest as as
             ;; comments.
             (text (concat
                    (propertize before-match
                                'face 'font-lock-comment-face)
                    (elisp-refs--syntax-highlight (buffer-substring start-pos end-pos))
                    (propertize after-match
                                'face 'font-lock-comment-face))))
        (-> text
            (elisp-refs--replace-tabs)
            (elisp-refs--unindent-rigidly)
            (propertize 'elisp-refs-start-pos expanded-start-pos
                        'elisp-refs-path elisp-refs--path))))))

(defun elisp-refs--find-file (button)
  "Open the file referenced by BUTTON."
  (find-file (button-get button 'path))
  (goto-char (point-min)))

(define-button-type 'elisp-refs-path-button
  'action 'elisp-refs--find-file
  'follow-link t
  'help-echo "Open file")

(defun elisp-refs--path-button (path)
  "Return a button that navigates to PATH."
  (with-temp-buffer
    (insert-text-button
     (f-abbrev path)
     :type 'elisp-refs-path-button
     'path path)
    (buffer-string)))

(defun elisp-refs--describe (button)
  "Show *Help* for the symbol referenced by BUTTON."
  (let ((symbol (button-get button 'symbol))
        (kind (button-get button 'kind)))
    (cond ((eq kind 'symbol)
           (describe-symbol symbol))
          ((eq kind 'variable)
           (describe-variable symbol))
          (t
           ;; Emacs uses `describe-function' for functions, macros and
           ;; special forms.
           (describe-function symbol)))))

(define-button-type 'elisp-refs-describe-button
  'action 'elisp-refs--describe
  'follow-link t
  'help-echo "Describe")

(defun elisp-refs--describe-button (symbol kind)
  "Return a button that shows *Help* for SYMBOL.
KIND should be 'function, 'macro, 'variable, 'special or 'symbol."
  (with-temp-buffer
    (insert (symbol-name kind) " ")
    (insert-text-button
     (symbol-name symbol)
     :type 'elisp-refs-describe-button
     'symbol symbol
     'kind kind)
    (buffer-string)))

(defun elisp-refs--pluralize (number thing)
  "Human-friendly description of NUMBER occurrences of THING."
  (format "%s %s%s"
          (elisp-refs--format-int number)
          thing
          (if (equal number 1) "" "s")))

(defun elisp-refs--format-count (symbol ref-count file-count
                                        searched-file-count prefix)
  (let* ((file-str (if (zerop file-count)
                       ""
                     (format " in %s" (elisp-refs--pluralize file-count "file"))))
         (found-str (format "Found %s to %s%s."
                            (elisp-refs--pluralize ref-count "reference")
                            symbol
                            file-str))
         (searched-str (if prefix
                           (format "Searched %s in %s."
                                   (elisp-refs--pluralize searched-file-count "loaded file")
                                   (elisp-refs--path-button (file-name-as-directory prefix)))
                         (format "Searched all %s loaded in Emacs."
                                 (elisp-refs--pluralize searched-file-count "file")))))
    (s-word-wrap 70 (format "%s %s" found-str searched-str))))

;; TODO: if we have multiple matches on one line, we repeatedly show
;; that line. That's slightly confusing.
(defun elisp-refs--show-results (symbol description results
                                        searched-file-count prefix)
  "Given a RESULTS list where each element takes the form \(forms . buffer\),
render a friendly results buffer."
  (let ((buf (get-buffer-create (format "*refs: %s*" symbol))))
    (switch-to-buffer buf)
    (setq buffer-read-only nil)
    (erase-buffer)
    ;; Insert the header.
    (insert
     (elisp-refs--format-count
      description
      (-sum (--map (length (car it)) results))
      (length results)
      searched-file-count
      prefix)
     "\n\n")
    ;; Insert the results.
    (--each results
      (-let* (((forms . buf) it)
              (path (with-current-buffer buf elisp-refs--path)))
        (insert
         (propertize "File: " 'face 'bold)
         (elisp-refs--path-button path) "\n")
        (--each forms
          (-let [(_ start-pos end-pos) it]
            (insert (elisp-refs--containing-lines buf start-pos end-pos)
                    "\n")))
        (insert "\n")))
    ;; Prepare the buffer for the user.
    (goto-char (point-min))
    (elisp-refs-mode)
    (setq buffer-read-only t)
    ;; Cleanup buffers created when highlighting results.
    (kill-buffer elisp-refs--highlighting-buffer)))

(defun elisp-refs--search (symbol description match-fn &optional path-prefix)
  "Search for references to SYMBOL in all loaded files, by calling MATCH-FN on each buffer.
If PATH-PREFIX is given, limit to loaded files whose path starts with that prefix.

Display the results in a hyperlinked buffer.

MATCH-FN should return a list where each element takes the form:
\(form start-pos end-pos)."
  (let* (;; Our benchmark suggests we spend a lot of time in GC, and
         ;; performance improves if we GC less frequently.
         (gc-cons-percentage 0.8)
         (loaded-paths (elisp-refs--loaded-files))
         (matching-paths (if path-prefix
                             (--filter (s-starts-with? path-prefix it) loaded-paths)
                           loaded-paths))
         (total-paths (length matching-paths))
         (loaded-src-bufs (mapcar #'elisp-refs--contents-buffer matching-paths)))
    ;; Use unwind-protect to ensure we always cleanup temporary
    ;; buffers, even if the user hits C-g.
    (unwind-protect
        (let ((searched 0)
              (forms-and-bufs nil))
          (dolist (buf loaded-src-bufs)
            (let* ((matching-forms (funcall match-fn buf)))
              ;; If there were any matches in this buffer, push the
              ;; matches along with the buffer into our results
              ;; list.
              (when matching-forms
                (push (cons matching-forms buf) forms-and-bufs))
              ;; Give feedback to the user on our progress, because
              ;; searching takes several seconds.
              (when (zerop (mod searched 10))
                (message "Searched %s/%s files" searched total-paths))
              (cl-incf searched)))
          (message "Searched %s/%s files" total-paths total-paths)
          (elisp-refs--show-results symbol description forms-and-bufs
                                    total-paths path-prefix))
      ;; Clean up temporary buffers.
      (--each loaded-src-bufs (kill-buffer it)))))

(defun elisp-refs--completing-read-symbol (prompt &optional filter)
  "Read an interned symbol from the minibuffer,
defaulting to the symbol at point. PROMPT is the string to prompt
with.

If FILTER is given, only offer symbols where (FILTER sym) returns
t."
  (let ((filter (or filter (lambda (_) t))))
    (read
     (completing-read prompt
                      (elisp-refs--filter-obarray filter)
                      nil nil nil nil
                      (-if-let (sym (thing-at-point 'symbol))
                          (when (funcall filter (read sym))
                            sym))))))

;;;###autoload
(defun elisp-refs-function (symbol &optional path-prefix)
  "Display all the references to function SYMBOL, in all loaded
elisp files.

If called with a prefix, prompt for a directory to limit the search."
  (interactive
   (list (elisp-refs--completing-read-symbol "Function: " #'functionp)
         (when current-prefix-arg
           (read-directory-name "Limit search to loaded files in: "))))
  (elisp-refs--search symbol
                      (elisp-refs--describe-button symbol 'function)
                      (lambda (buf)
                        (elisp-refs--read-and-find buf symbol #'elisp-refs--function-p))
                      path-prefix))

;;;###autoload
(defun elisp-refs-macro (symbol &optional path-prefix)
  "Display all the references to macro SYMBOL, in all loaded
elisp files.

If called with a prefix, prompt for a directory to limit the search."
  (interactive
   (list (elisp-refs--completing-read-symbol "Macro: " #'macrop)
         (when current-prefix-arg
           (read-directory-name "Limit search to loaded files in: "))))
  (elisp-refs--search symbol
                      (elisp-refs--describe-button symbol 'macro)
                      (lambda (buf)
                        (elisp-refs--read-and-find buf symbol #'elisp-refs--macro-p))
                      path-prefix))

;;;###autoload
(defun elisp-refs-special (symbol &optional path-prefix)
  "Display all the references to special form SYMBOL, in all loaded
elisp files.

If called with a prefix, prompt for a directory to limit the search."
  (interactive
   (list (elisp-refs--completing-read-symbol "Special form: " #'special-form-p)
         (when current-prefix-arg
           (read-directory-name "Limit search to loaded files in: "))))
  (elisp-refs--search symbol
                      (elisp-refs--describe-button symbol 'special-form)
                      (lambda (buf)
                        (elisp-refs--read-and-find buf symbol #'elisp-refs--special-p))
                      path-prefix))

;;;###autoload
(defun elisp-refs-variable (symbol &optional path-prefix)
  "Display all the references to variable SYMBOL, in all loaded
elisp files."
  (interactive
   ;; This is awkward. We don't want to just offer defvar variables,
   ;; because then we can't search for code which uses `let' to bind
   ;; symbols. There doesn't seem to be a good way to only offer
   ;; variables that have been bound at some point.
   (list (elisp-refs--completing-read-symbol "Variable: " )))
  (elisp-refs--search symbol
                      (elisp-refs--describe-button symbol 'variable)
                      (lambda (buf)
                        (elisp-refs--read-and-find buf symbol #'elisp-refs--variable-p))
                      path-prefix))

;;;###autoload
(defun elisp-refs-symbol (symbol &optional path-prefix)
  "Display all the references to SYMBOL in all loaded elisp files."
  (interactive
   (list (elisp-refs--completing-read-symbol "Symbol: " )))
  (elisp-refs--search symbol
                      (elisp-refs--describe-button symbol 'symbol)
                      (lambda (buf)
                        (elisp-refs--read-and-find-symbol buf symbol))
                      path-prefix))

(define-derived-mode elisp-refs-mode special-mode "Refs"
  "Major mode for refs results buffers.")

(defun elisp-refs-visit-match ()
  "Go to the search result at point."
  (interactive)
  (let* ((path (get-text-property (point) 'elisp-refs-path))
         (pos (get-text-property (point) 'elisp-refs-start-pos))
         (unindent (get-text-property (point) 'elisp-refs-unindented))
         (column-offset (current-column))
         (target-offset (+ column-offset unindent))
         (line-offset -1))
    (when (null path)
      (user-error "No match here"))

    ;; If point is not on the first line of the match, work out how
    ;; far away the first line is.
    (save-excursion
      (while (equal pos (get-text-property (point) 'elisp-refs-start-pos))
        (forward-line -1)
        (cl-incf line-offset)))

    (find-file path)
    (goto-char pos)
    ;; Move point so we're on the same char in the buffer that we were
    ;; on in the results buffer.
    (forward-line line-offset)
    (beginning-of-line)
    (let ((i 0))
      (while (< i target-offset)
        (if (looking-at "\t")
            (cl-incf i tab-width)
          (cl-incf i))
        (forward-char 1)))))

(defun elisp-refs--move-to-match (direction)
  "Move point one match forwards.
If DIRECTION is -1, moves backwards instead."
  (let* ((start-pos (point))
         (match-pos (get-text-property start-pos 'elisp-refs-start-pos))
         current-match-pos)
    (condition-case _err
        (progn
          ;; Move forward/backwards until we're on the next/previous match.
          (loop-while t
            (setq current-match-pos
                  (get-text-property (point) 'elisp-refs-start-pos))
            (when (and current-match-pos
                       (not (equal match-pos current-match-pos)))
              (loop-break))
            (forward-char direction))
          ;; Move to the beginning of that match.
          (while (equal (get-text-property (point) 'elisp-refs-start-pos)
                        (get-text-property (1- (point)) 'elisp-refs-start-pos))
            (forward-char -1))
          ;; Move forward until we're on the first char of match within that
          ;; line.
          (while (or
                  (looking-at " ")
                  (eq (get-text-property (point) 'face)
                      'font-lock-comment-face))
            (forward-char 1)))
      ;; If we're at the last result, don't move point.
      (end-of-buffer
       (progn
         (goto-char start-pos)
         (signal 'end-of-buffer nil))))))

(defun elisp-refs-prev-match ()
  "Move to the previous search result in the Refs buffer."
  (interactive)
  (elisp-refs--move-to-match -1))

(defun elisp-refs-next-match ()
  "Move to the next search result in the Refs buffer."
  (interactive)
  (elisp-refs--move-to-match 1))

;; TODO: it would be nice for TAB to navigate to file buttons too,
;; like *Help* does.
(define-key elisp-refs-mode-map (kbd "<tab>") #'elisp-refs-next-match)
(define-key elisp-refs-mode-map (kbd "<backtab>") #'elisp-refs-prev-match)
(define-key elisp-refs-mode-map (kbd "n") #'elisp-refs-next-match)
(define-key elisp-refs-mode-map (kbd "p") #'elisp-refs-prev-match)
(define-key elisp-refs-mode-map (kbd "q") #'kill-this-buffer)
(define-key elisp-refs-mode-map (kbd "RET") #'elisp-refs-visit-match)

(provide 'elisp-refs)
;;; elisp-refs.el ends here
