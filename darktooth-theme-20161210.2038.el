;;; darktooth-theme.el --- A color theme for Emacs, from the darkness... it watches

;; Copyright (c) 2015-2016 Jason Milkins (GNU/GPL Licence)

;; Authors: Jason Milkins <jasonm23@gmail.com>
;; URL: http://github.com/emacsfodder/emacs-theme-darktooth
;; Package-Version: 20161210.2038
;; Version: 0.1.62

;;; Commentary:
;;  A color theme for Emacs, from the darkness... it watches

;;  Since 0.1.60 : includes `darktooth-modeline'

;;; Code:

(unless (>= emacs-major-version 24)
  (error "Requires Emacs 24 or later"))

(deftheme darktooth "A color theme for Emacs, from the darkness... it watches")

(let (
      (darktooth-dark0_hard      (if (display-graphic-p) "#1D2021" "color-234"))
      (darktooth-dark0           (if (display-graphic-p) "#282828" "color-235"))
      (darktooth-dark0_soft      (if (display-graphic-p) "#32302F" "color-236"))
      (darktooth-dark1           (if (display-graphic-p) "#3C3836" "color-237"))
      (darktooth-dark2           (if (display-graphic-p) "#504945" "color-239"))
      (darktooth-dark3           (if (display-graphic-p) "#665C54" "color-241"))
      (darktooth-dark4           (if (display-graphic-p) "#7C6F64" "color-243"))

      (darktooth-medium          (if (display-graphic-p) "#928374" "color-245")) ;; or 244

      (darktooth-light0_hard     (if (display-graphic-p) "#FFFFC8" "color-230"))
      (darktooth-light0          (if (display-graphic-p) "#FDF4C1" "color-229"))
      (darktooth-light0_soft     (if (display-graphic-p) "#F4E8BA" "color-228"))
      (darktooth-light1          (if (display-graphic-p) "#EBDBB2" "color-223"))
      (darktooth-light2          (if (display-graphic-p) "#D5C4A1" "color-250"))
      (darktooth-light3          (if (display-graphic-p) "#BDAE93" "color-248"))
      (darktooth-light4          (if (display-graphic-p) "#A89984" "color-246"))

      (darktooth-bright_red      (if (display-graphic-p) "#FB4933" "color-167"))
      (darktooth-bright_green    (if (display-graphic-p) "#B8BB26" "color-142"))
      (darktooth-bright_yellow   (if (display-graphic-p) "#FABD2F" "color-214"))
      (darktooth-bright_blue     (if (display-graphic-p) "#83A598" "color-109"))
      (darktooth-bright_purple   (if (display-graphic-p) "#D3869B" "color-175"))
      (darktooth-bright_aqua     (if (display-graphic-p) "#8EC07C" "color-108"))
      (darktooth-bright_orange   (if (display-graphic-p) "#FE8019" "color-208"))
      (darktooth-bright_cyan     (if (display-graphic-p) "#3FD7E5" "color-45"))

      ;; neutral, no 256-color code, requested, nice work-around meanwhile
      (darktooth-neutral_red     (if (display-graphic-p) "#FB4934" "#D75F5F"))
      (darktooth-neutral_green   (if (display-graphic-p) "#B8BB26" "#73AF00"))
      (darktooth-neutral_yellow  (if (display-graphic-p) "#FABD2F" "#FFAF00"))
      (darktooth-neutral_blue    (if (display-graphic-p) "#83A598" "#87AFAF"))
      (darktooth-neutral_purple  (if (display-graphic-p) "#D3869B" "#D787AF"))
      (darktooth-neutral_aqua    (if (display-graphic-p) "#8EC07C" "#87AF87"))
      (darktooth-neutral_orange  (if (display-graphic-p) "#FE8019" "#FF8700"))
      (darktooth-neutral_cyan    (if (display-graphic-p) "#17CCD5" "#17CCD5"))

      (darktooth-faded_red       (if (display-graphic-p) "#9D0006" "color-88"))
      (darktooth-faded_green     (if (display-graphic-p) "#79740E" "color-100"))
      (darktooth-faded_yellow    (if (display-graphic-p) "#B57614" "color-136"))
      (darktooth-faded_blue      (if (display-graphic-p) "#076678" "color-24"))
      (darktooth-faded_purple    (if (display-graphic-p) "#8F3F71" "color-96"))
      (darktooth-faded_aqua      (if (display-graphic-p) "#427B58" "color-66"))
      (darktooth-faded_orange    (if (display-graphic-p) "#AF3A03" "color-130"))
      (darktooth-faded_cyan      (if (display-graphic-p) "#00A7AF" "color-37"))

      (darktooth-muted_red       (if (display-graphic-p) "#901A1E" "color-88"))
      (darktooth-muted_green     (if (display-graphic-p) "#556C21" "color-100"))
      (darktooth-muted_yellow    (if (display-graphic-p) "#A87933" "color-136"))
      (darktooth-muted_blue      (if (display-graphic-p) "#1B5C6B" "color-24"))
      (darktooth-muted_purple    (if (display-graphic-p) "#82526E" "color-96"))
      (darktooth-muted_aqua      (if (display-graphic-p) "#506E59" "color-66"))
      (darktooth-muted_orange    (if (display-graphic-p) "#A24921" "color-130"))
      (darktooth-muted_cyan      (if (display-graphic-p) "#18A7AF" "color-37"))

      (darktooth-dark_red        (if (display-graphic-p) "#421E1E" "color-52"))
      (darktooth-dark_green      (if (display-graphic-p) "#232B0F" "color-22"))
      (darktooth-dark_yellow     (if (display-graphic-p) "#4D3B27" "color-3"))
      (darktooth-dark_blue       (if (display-graphic-p) "#2B3C44" "color-4"))
      (darktooth-dark_purple     (if (display-graphic-p) "#4E3D45" "color-57"))
      (darktooth-dark_aqua       (if (display-graphic-p) "#36473A" "color-23"))
      (darktooth-dark_orange     (if (display-graphic-p) "#613620" "color-130"))
      (darktooth-dark_cyan       (if (display-graphic-p) "#205161" "color-24"))

      (darktooth-mid_red         (if (display-graphic-p) "#3F1B1B" "color-52"))
      (darktooth-mid_green       (if (display-graphic-p) "#1F321C" "color-22"))
      (darktooth-mid_yellow      (if (display-graphic-p) "#4C3A25" "color-3"))
      (darktooth-mid_blue        (if (display-graphic-p) "#30434C" "color-4"))
      (darktooth-mid_purple      (if (display-graphic-p) "#4C3B43" "color-57"))
      (darktooth-mid_aqua        (if (display-graphic-p) "#394C3D" "color-23"))
      (darktooth-mid_orange      (if (display-graphic-p) "#603000" "color-130"))
      (darktooth-mid_cyan        (if (display-graphic-p) "#005560" "color-24"))

      (darktooth-delimiter-one   (if (display-graphic-p) "#5C7E81" "color-66"))
      (darktooth-delimiter-two   (if (display-graphic-p) "#837486" "color-102"))
      (darktooth-delimiter-three (if (display-graphic-p) "#9C6F68" "color-94"))
      (darktooth-delimiter-four  (if (display-graphic-p) "#7B665C" "color-137"))

      ;; 24 bit has tints from light0 and terminal cycles through
      ;; the 4 darktooth-delimiter colors
      (darktooth-identifiers-1   (if (display-graphic-p) "#E5D5C5" "color-66"))
      (darktooth-identifiers-2   (if (display-graphic-p) "#DFE5C5" "color-102"))
      (darktooth-identifiers-3   (if (display-graphic-p) "#D5E5C5" "color-94"))
      (darktooth-identifiers-4   (if (display-graphic-p) "#CAE5C5" "color-137"))
      (darktooth-identifiers-5   (if (display-graphic-p) "#C5E5CA" "color-66"))
      (darktooth-identifiers-6   (if (display-graphic-p) "#C5E5D5" "color-102"))
      (darktooth-identifiers-7   (if (display-graphic-p) "#C5E5DF" "color-94"))
      (darktooth-identifiers-8   (if (display-graphic-p) "#C5DFE5" "color-137"))
      (darktooth-identifiers-9   (if (display-graphic-p) "#C5D5E5" "color-66"))
      (darktooth-identifiers-10  (if (display-graphic-p) "#C5CAE5" "color-102"))
      (darktooth-identifiers-11  (if (display-graphic-p) "#CAC5E5" "color-94"))
      (darktooth-identifiers-12  (if (display-graphic-p) "#D5C5E5" "color-137"))
      (darktooth-identifiers-13  (if (display-graphic-p) "#DFC5E5" "color-66"))
      (darktooth-identifiers-14  (if (display-graphic-p) "#E5C5DF" "color-102"))
      (darktooth-identifiers-15  (if (display-graphic-p) "#E5C5D5" "color-94"))

      (darktooth-white           (if (display-graphic-p) "#FFFFFF" "white"))
      (darktooth-black           (if (display-graphic-p) "#000000" "black"))
      (darktooth-sienna          (if (display-graphic-p) "#DD6F48" "sienna"))
      (darktooth-darkslategray4  (if (display-graphic-p) "#528B8B" "DarkSlateGray4"))
      (darktooth-lightblue4      (if (display-graphic-p) "#66999D" "LightBlue4"))
      (darktooth-burlywood4      (if (display-graphic-p) "#BBAA97" "burlywood4"))
      (darktooth-aquamarine4     (if (display-graphic-p) "#83A598" "aquamarine4"))
      (darktooth-turquoise4      (if (display-graphic-p) "#61ACBB" "turquoise4"))
      )

  (custom-theme-set-faces
   'darktooth

   ;; UI
   `(default                                   ((t (:foreground ,darktooth-light0 :background ,darktooth-dark0))))
   `(cursor                                    ((t (:background ,darktooth-light0))))
   `(link                                      ((t (:foreground ,darktooth-bright_blue :underline t))))
   `(link-visited                              ((t (:foreground ,darktooth-bright_blue :underline nil))))

   `(mode-line                                 ((t (:foreground ,darktooth-light1 :background ,darktooth-dark0_hard :box nil))))
   `(mode-line-inactive                        ((t (:foreground ,darktooth-light4 :background ,darktooth-dark2 :box nil))))
   `(fringe                                    ((t (:background ,darktooth-dark0))))
   `(linum                                     ((t (:foreground ,darktooth-dark4))))
   `(hl-line                                   ((t (:background ,darktooth-dark_purple))))
   `(region                                    ((t (:background ,darktooth-mid_blue :distant-foreground ,darktooth-light0))))
   `(secondary-selection                       ((t (:background ,darktooth-dark_blue))))
   `(cua-rectangle                             ((t (:background ,darktooth-mid_blue))))
   `(header-line                               ((t (:foreground ,darktooth-turquoise4 :background ,darktooth-dark0 :bold nil))))
   `(minibuffer-prompt                         ((t (:foreground ,darktooth-bright_cyan :background ,darktooth-dark0 :bold nil))))

   ;; compilation messages (also used by several other modes)
   `(compilation-info                          ((t (:foreground ,darktooth-neutral_green))))
   `(compilation-mode-line-fail                ((t (:foreground ,darktooth-neutral_red))))
   `(error                                     ((t (:foreground ,darktooth-bright_orange :bold t))))
   `(success                                   ((t (:foreground ,darktooth-neutral_green :bold t))))
   `(warning                                   ((t (:foreground ,darktooth-bright_red :bold t))))

   ;; Built-in syntax
   `(font-lock-builtin-face                    ((t (:foreground ,darktooth-bright_orange))))
   `(font-lock-constant-face                   ((t (:foreground ,darktooth-burlywood4))))
   `(font-lock-comment-face                    ((t (:foreground ,darktooth-dark4))))
   `(font-lock-function-name-face              ((t (:foreground ,darktooth-light4))))
   `(font-lock-keyword-face                    ((t (:foreground ,darktooth-sienna))))
   `(font-lock-string-face                     ((t (:foreground ,darktooth-darkslategray4))))
   `(font-lock-variable-name-face              ((t (:foreground ,darktooth-aquamarine4))))
   `(font-lock-type-face                       ((t (:foreground ,darktooth-lightblue4))))
   `(font-lock-warning-face                    ((t (:foreground ,darktooth-neutral_red :bold t))))

   ;; MODE SUPPORT: elixir-mode
   `(elixir-atom-face                          ((t (:foreground ,darktooth-lightblue4))))
   `(elixir-attribute-face                     ((t (:foreground ,darktooth-burlywood4))))

   ;; MODE SUPPORT: whitespace-mode
   `(whitespace-space                          ((t (:foreground ,darktooth-dark4 :background ,darktooth-dark0))))
   `(whitespace-hspace                         ((t (:foreground ,darktooth-dark4 :background ,darktooth-dark0))))
   `(whitespace-tab                            ((t (:foreground ,darktooth-dark4 :background ,darktooth-dark0))))
   `(whitespace-newline                        ((t (:foreground ,darktooth-dark4 :background ,darktooth-dark0))))
   `(whitespace-trailing                       ((t (:foreground ,darktooth-neutral_red :background ,darktooth-dark1))))
   `(whitespace-line                           ((t (:foreground ,darktooth-neutral_red :background ,darktooth-dark1))))
   `(whitespace-space-before-tab               ((t (:foreground ,darktooth-dark4 :background ,darktooth-dark0))))
   `(whitespace-indentation                    ((t (:foreground ,darktooth-dark4 :background ,darktooth-dark0))))
   `(whitespace-empty                          ((t (:foreground nil :background nil))))
   `(whitespace-space-after-tab                ((t (:foreground ,darktooth-dark4 :background ,darktooth-dark0))))

   ;; MODE SUPPORT: rainbow-delimiters
   `(rainbow-delimiters-depth-1-face           ((t (:foreground ,darktooth-delimiter-one))))
   `(rainbow-delimiters-depth-2-face           ((t (:foreground ,darktooth-delimiter-two))))
   `(rainbow-delimiters-depth-3-face           ((t (:foreground ,darktooth-delimiter-three))))
   `(rainbow-delimiters-depth-4-face           ((t (:foreground ,darktooth-delimiter-four))))
   `(rainbow-delimiters-depth-5-face           ((t (:foreground ,darktooth-delimiter-one))))
   `(rainbow-delimiters-depth-6-face           ((t (:foreground ,darktooth-delimiter-two))))
   `(rainbow-delimiters-depth-7-face           ((t (:foreground ,darktooth-delimiter-three))))
   `(rainbow-delimiters-depth-8-face           ((t (:foreground ,darktooth-delimiter-four))))
   `(rainbow-delimiters-depth-9-face           ((t (:foreground ,darktooth-delimiter-one))))
   `(rainbow-delimiters-depth-10-face          ((t (:foreground ,darktooth-delimiter-two))))
   `(rainbow-delimiters-depth-11-face          ((t (:foreground ,darktooth-delimiter-three))))
   `(rainbow-delimiters-depth-12-face          ((t (:foreground ,darktooth-delimiter-four))))
   `(rainbow-delimiters-unmatched-face         ((t (:foreground ,darktooth-light0 :background nil))))

   ;; MODE SUPPORT: rainbow-identifiers
   `(rainbow-identifiers-identifier-1          ((t (:foreground ,darktooth-identifiers-1))))
   `(rainbow-identifiers-identifier-2          ((t (:foreground ,darktooth-identifiers-2))))
   `(rainbow-identifiers-identifier-3          ((t (:foreground ,darktooth-identifiers-3))))
   `(rainbow-identifiers-identifier-4          ((t (:foreground ,darktooth-identifiers-4))))
   `(rainbow-identifiers-identifier-5          ((t (:foreground ,darktooth-identifiers-5))))
   `(rainbow-identifiers-identifier-6          ((t (:foreground ,darktooth-identifiers-6))))
   `(rainbow-identifiers-identifier-7          ((t (:foreground ,darktooth-identifiers-7))))
   `(rainbow-identifiers-identifier-8          ((t (:foreground ,darktooth-identifiers-8))))
   `(rainbow-identifiers-identifier-9          ((t (:foreground ,darktooth-identifiers-9))))
   `(rainbow-identifiers-identifier-10         ((t (:foreground ,darktooth-identifiers-10))))
   `(rainbow-identifiers-identifier-11         ((t (:foreground ,darktooth-identifiers-11))))
   `(rainbow-identifiers-identifier-12         ((t (:foreground ,darktooth-identifiers-12))))
   `(rainbow-identifiers-identifier-13         ((t (:foreground ,darktooth-identifiers-13))))
   `(rainbow-identifiers-identifier-14         ((t (:foreground ,darktooth-identifiers-14))))
   `(rainbow-identifiers-identifier-15         ((t (:foreground ,darktooth-identifiers-15))))

   ;; MODE SUPPORT: ido
   `(ido-indicator                             ((t (:background ,darktooth-bright_red :foreground ,darktooth-bright_yellow))))
   `(ido-subdir                                ((t (:foreground ,darktooth-light3))))
   `(ido-first-match                           ((t (:foreground ,darktooth-faded_cyan :background ,darktooth-dark0_hard))))
   `(ido-only-match                            ((t (:foreground ,darktooth-darkslategray4))))
   `(ido-vertical-match-face                   ((t (:bold t))))
   `(ido-vertical-only-match-face              ((t (:foreground ,darktooth-bright_cyan))))
   `(ido-vertical-first-match-face             ((t (:foreground ,darktooth-bright_cyan :background ,darktooth-dark_blue))))

   ;; MODE SUPPORT: linum-relative
   `(linum-relative-current-face               ((t (:foreground ,darktooth-light4 :background ,darktooth-dark1))))

   ;; MODE SUPPORT: highlight-indentation-mode
   `(highlight-indentation-current-column-face ((t (:background ,darktooth-dark4))))
   `(highlight-indentation-face                ((t (:background ,darktooth-dark1))))

   ;; MODE SUPPORT: highlight-numbers
   `(highlight-numbers-number                  ((t (:foreground ,darktooth-bright_purple :bold nil))))

   ;; MODE SUPPORT: highlight-symbol
   `(highlight-symbol-face                     ((t (:foreground ,darktooth-neutral_purple))))

   ;; MODE SUPPORT: hi-lock
   `(hi-blue                                   ((t (:foreground ,darktooth-dark0_hard :background ,darktooth-bright_blue ))))
   `(hi-green                                  ((t (:foreground ,darktooth-dark0_hard :background ,darktooth-bright_green ))))
   `(hi-pink                                   ((t (:foreground ,darktooth-dark0_hard :background ,darktooth-bright_purple ))))
   `(hi-yellow                                 ((t (:foreground ,darktooth-dark0_hard :background ,darktooth-bright_yellow ))))
   `(hi-blue-b                                 ((t (:foreground ,darktooth-bright_blue :bold t ))))
   `(hi-green-b                                ((t (:foreground ,darktooth-bright_green :bold t ))))
   `(hi-red-b                                  ((t (:foreground ,darktooth-bright_red :bold t  ))))
   `(hi-black-b                                ((t (:foreground ,darktooth-bright_orange :background ,darktooth-dark0_hard :bold t  ))))
   `(hi-black-hb                               ((t (:foreground ,darktooth-bright_cyan :background ,darktooth-dark0_hard :bold t  ))))

   ;; MODE SUPPORT: smartparens
   `(sp-pair-overlay-face                      ((t (:background ,darktooth-dark2))))
   `(sp-show-pair-match-face                   ((t (:background ,darktooth-dark2)))) ;; Pair tags highlight
   `(sp-show-pair-mismatch-face                ((t (:background ,darktooth-neutral_red)))) ;; Highlight for bracket without pair

   ;; MODE SUPPORT: auctex
   `(font-latex-math-face                      ((t (:foreground ,darktooth-lightblue4))))
   `(font-latex-sectioning-5-face              ((t (:foreground ,darktooth-neutral_green))))
   `(font-latex-string-face                    ((t (:inherit font-lock-string-face))))
   `(font-latex-warning-face                   ((t (:inherit warning))))

   ;; MODE SUPPORT: elscreen
   `(elscreen-tab-background-face              ((t (:background ,darktooth-dark0 :box nil)))) ;; Tab bar, not the tabs
   `(elscreen-tab-control-face                 ((t (:foreground ,darktooth-neutral_red :background ,darktooth-dark2 :box nil :underline nil)))) ;; The controls
   `(elscreen-tab-current-screen-face          ((t (:foreground ,darktooth-dark0 :background ,darktooth-dark4 :box nil)))) ;; Current tab
   `(elscreen-tab-other-screen-face            ((t (:foreground ,darktooth-light4 :background ,darktooth-dark2 :box nil :underline nil)))) ;; Inactive tab

   ;; MODE SUPPORT: embrace
   `(embrace-help-pair-face                    ((t (:foreground ,darktooth-bright_blue))))
   `(embrace-help-separator-face               ((t (:foreground ,darktooth-bright_orange))))
   `(embrace-help-key-face                     ((t (:weight bold ,darktooth-bright_green))))
   `(embrace-help-mark-func-face               ((t (:foreground ,darktooth-bright_cyan))))

   ;; MODE SUPPORT: ag (The Silver Searcher)
   `(ag-hit-face                               ((t (:foreground ,darktooth-neutral_blue))))
   `(ag-match-face                             ((t (:foreground ,darktooth-neutral_red))))

   ;; MODE SUPPORT: RipGrep
   `(ripgrep-hit-face                          ((t (:inherit ag-hit-face))))
   `(ripgrep-match-face                        ((t (:inherit ag-match-face))))

   ;; MODE SUPPORT: diff
   `(diff-changed                              ((t (:foreground ,darktooth-light1 :background nil))))
   `(diff-added                                ((t (:foreground ,darktooth-neutral_green :background nil))))
   `(diff-removed                              ((t (:foreground ,darktooth-neutral_red :background nil))))

   ;; MODE SUPPORT: diff-indicator
   `(diff-indicator-changed                    ((t (:inherit diff-changed))))
   `(diff-indicator-added                      ((t (:inherit diff-added))))
   `(diff-indicator-removed                    ((t (:inherit diff-removed))))

   ;; MODE SUPPORT: diff-hl
   `(diff-hl-change                            ((t (:inherit diff-changed))))
   `(diff-hl-delete                            ((t (:inherit diff-removed))))
   `(diff-hl-insert                            ((t (:inherit diff-added))))

   `(js2-warning                               ((t (:underline (:color ,darktooth-bright_yellow :style wave)))))
   `(js2-error                                 ((t (:underline (:color ,darktooth-bright_red :style wave)))))
   `(js2-external-variable                     ((t (:underline (:color ,darktooth-bright_aqua :style wave)))))
   `(js2-jsdoc-tag                             ((t (:foreground ,darktooth-medium :background nil))))
   `(js2-jsdoc-type                            ((t (:foreground ,darktooth-light4 :background nil))))
   `(js2-jsdoc-value                           ((t (:foreground ,darktooth-light3 :background nil))))
   `(js2-function-param                        ((t (:foreground ,darktooth-bright_aqua :background nil))))
   `(js2-function-call                         ((t (:foreground ,darktooth-bright_blue :background nil))))
   `(js2-instance-member                       ((t (:foreground ,darktooth-bright_orange :background nil))))
   `(js2-private-member                        ((t (:foreground ,darktooth-faded_yellow :background nil))))
   `(js2-private-function-call                 ((t (:foreground ,darktooth-faded_aqua :background nil))))
   `(js2-jsdoc-html-tag-name                   ((t (:foreground ,darktooth-light4 :background nil))))
   `(js2-jsdoc-html-tag-delimiter              ((t (:foreground ,darktooth-light3 :background nil))))

   ;; MODE SUPPORT: haskell
   `(haskell-interactive-face-compile-warning  ((t (:underline (:color ,darktooth-bright_yellow :style wave)))))
   `(haskell-interactive-face-compile-error    ((t (:underline (:color ,darktooth-bright_red :style wave)))))
   `(haskell-interactive-face-garbage          ((t (:foreground ,darktooth-dark4 :background nil))))
   `(haskell-interactive-face-prompt           ((t (:foreground ,darktooth-light0 :background nil))))
   `(haskell-interactive-face-result           ((t (:foreground ,darktooth-light3 :background nil))))
   `(haskell-literate-comment-face             ((t (:foreground ,darktooth-light0 :background nil))))
   `(haskell-pragma-face                       ((t (:foreground ,darktooth-medium :background nil))))
   `(haskell-constructor-face                  ((t (:foreground ,darktooth-neutral_aqua :background nil))))

   ;; MODE SUPPORT: org-mode
   `(org-agenda-date-today                     ((t (:foreground ,darktooth-light2 :slant italic :weight bold))) t)
   `(org-agenda-structure                      ((t (:inherit font-lock-comment-face))))
   `(org-archived                              ((t (:foreground ,darktooth-light0 :weight bold))))
   `(org-checkbox                              ((t (:foreground ,darktooth-light2 :background ,darktooth-dark0 :box (:line-width 1 :style released-button)))))
   `(org-date                                  ((t (:foreground ,darktooth-faded_blue :underline t))))
   `(org-deadline-announce                     ((t (:foreground ,darktooth-faded_red))))
   `(org-done                                  ((t (:foreground ,darktooth-bright_green :bold t :weight bold))))
   `(org-formula                               ((t (:foreground ,darktooth-bright_yellow))))
   `(org-headline-done                         ((t (:foreground ,darktooth-bright_green))))
   `(org-hide                                  ((t (:foreground ,darktooth-dark0))))
   `(org-level-1                               ((t (:foreground ,darktooth-bright_orange))))
   `(org-level-2                               ((t (:foreground ,darktooth-bright_green))))
   `(org-level-3                               ((t (:foreground ,darktooth-bright_blue))))
   `(org-level-4                               ((t (:foreground ,darktooth-bright_yellow))))
   `(org-level-5                               ((t (:foreground ,darktooth-faded_aqua))))
   `(org-level-6                               ((t (:foreground ,darktooth-bright_green))))
   `(org-level-7                               ((t (:foreground ,darktooth-bright_red))))
   `(org-level-8                               ((t (:foreground ,darktooth-bright_blue))))
   `(org-link                                  ((t (:foreground ,darktooth-bright_yellow :underline t))))
   `(org-scheduled                             ((t (:foreground ,darktooth-bright_green))))
   `(org-scheduled-previously                  ((t (:foreground ,darktooth-bright_red))))
   `(org-scheduled-today                       ((t (:foreground ,darktooth-bright_blue))))
   `(org-sexp-date                             ((t (:foreground ,darktooth-bright_blue :underline t))))
   `(org-special-keyword                       ((t (:inherit font-lock-comment-face))))
   `(org-table                                 ((t (:foreground ,darktooth-bright_green))))
   `(org-tag                                   ((t (:bold t :weight bold))))
   `(org-time-grid                             ((t (:foreground ,darktooth-bright_orange))))
   `(org-todo                                  ((t (:foreground ,darktooth-bright_red :weight bold :bold t))))
   `(org-upcoming-deadline                     ((t (:inherit font-lock-keyword-face))))
   `(org-warning                               ((t (:foreground ,darktooth-bright_red :weight bold :underline nil :bold t))))
   `(org-column                                ((t (:background ,darktooth-dark0))))
   `(org-column-title                          ((t (:background ,darktooth-dark0_hard :underline t :weight bold))))
   `(org-mode-line-clock                       ((t (:foreground ,darktooth-light2 :background ,darktooth-dark0))))
   `(org-mode-line-clock-overrun               ((t (:foreground ,darktooth-black :background ,darktooth-bright_red))))
   `(org-ellipsis                              ((t (:foreground ,darktooth-bright_yellow :underline t))))
   `(org-footnote                              ((t (:foreground ,darktooth-faded_aqua :underline t))))

   ;; MODE SUPPORT: powerline
   `(powerline-active1                         ((t (:background ,darktooth-dark2 :inherit mode-line))))
   `(powerline-active2                         ((t (:background ,darktooth-dark1 :inherit mode-line))))
   `(powerline-inactive1                       ((t (:background ,darktooth-medium :inherit mode-line-inactive))))
   `(powerline-inactive2                       ((t (:background ,darktooth-dark2 :inherit mode-line-inactive))))

   ;; MODE SUPPORT: smart-mode-line
   `(sml/modes                                 ((t (:foreground ,darktooth-light0_hard :weight bold :bold t))))
   `(sml/minor-modes                           ((t (:foreground ,darktooth-neutral_orange))))
   `(sml/filename                              ((t (:foreground ,darktooth-light0_hard :weight bold :bold t))))
   `(sml/prefix                                ((t (:foreground ,darktooth-neutral_blue))))
   `(sml/git                                   ((t (:inherit sml/prefix))))
   `(sml/process                               ((t (:inherit sml/prefix))))
   `(sml/sudo                                  ((t (:foreground ,darktooth-dark_orange :weight bold))))
   `(sml/read-only                             ((t (:foreground ,darktooth-neutral_blue))))
   `(sml/outside-modified                      ((t (:foreground ,darktooth-neutral_blue))))
   `(sml/modified                              ((t (:foreground ,darktooth-neutral_blue))))
   `(sml/vc                                    ((t (:foreground ,darktooth-faded_green))))
   `(sml/vc-edited                             ((t (:foreground ,darktooth-bright_green))))
   `(sml/charging                              ((t (:foreground ,darktooth-faded_aqua))))
   `(sml/discharging                           ((t (:foreground ,darktooth-faded_aqua :weight bold))))
   `(sml/col-number                            ((t (:foreground ,darktooth-neutral_orange))))
   `(sml/position-percentage                   ((t (:foreground ,darktooth-faded_aqua))))

   ;; Matches and Isearch
   `(lazy-highlight                            ((t (:foreground ,darktooth-light0 :background ,darktooth-dark2))))
   `(highlight                                 ((t (:foreground ,darktooth-light0_hard :background ,darktooth-faded_blue))))
   `(match                                     ((t (:foreground ,darktooth-light0 :background ,darktooth-dark2))))

   ;; MODE SUPPORT: isearch
   `(isearch                                   ((t (:foreground ,darktooth-light0 :background ,darktooth-faded_aqua))))
   `(isearch-fail                              ((t (:foreground ,darktooth-light0_hard :background ,darktooth-faded_red))))

   ;; MODE SUPPORT: show-paren
   `(show-paren-match                          ((t (:foreground ,darktooth-light0 :background ,darktooth-faded_blue))))
   `(show-paren-mismatch                       ((t (:foreground ,darktooth-light0_hard :background ,darktooth-faded_red))))

   ;; MODE SUPPORT: anzu
   `(anzu-mode-line                            ((t (:foreground ,darktooth-light0 :height 100 :background ,darktooth-faded_blue))))
   `(anzu-match-1                              ((t (:foreground ,darktooth-dark0 :background ,darktooth-bright_green))))
   `(anzu-match-2                              ((t (:foreground ,darktooth-dark0 :background ,darktooth-bright_yellow))))
   `(anzu-match-3                              ((t (:foreground ,darktooth-dark0 :background ,darktooth-bright_cyan))))
   `(anzu-replace-highlight                    ((t (:background ,darktooth-dark_aqua))))
   `(anzu-replace-to                           ((t (:background ,darktooth-dark_cyan))))

   ;; MODE SUPPORT: el-search
   `(el-search-match                           ((t (:background ,darktooth-dark_cyan))))
   `(el-search-other-match                     ((t (:background ,darktooth-dark_blue))))

   ;; MODE SUPPORT: avy
   `(avy-lead-face-0                           ((t (:foreground ,darktooth-bright_blue ))))
   `(avy-lead-face-1                           ((t (:foreground ,darktooth-bright_aqua ))))
   `(avy-lead-face-2                           ((t (:foreground ,darktooth-bright_purple ))))
   `(avy-lead-face                             ((t (:foreground ,darktooth-bright_red ))))
   `(avy-background-face                       ((t (:foreground ,darktooth-dark3 ))))
   `(avy-goto-char-timer-face                  ((t (:inherit    highlight ))))

   ;; MODE SUPPORT: popup
   `(popup-face                                ((t (:foreground ,darktooth-light0 :background ,darktooth-dark1))))
   `(popup-menu-mouse-face                     ((t (:foreground ,darktooth-light0 :background ,darktooth-faded_blue))))
   `(popup-menu-selection-face                 ((t (:foreground ,darktooth-light0 :background ,darktooth-faded_blue))))
   `(popup-tip-face                            ((t (:foreground ,darktooth-light0_hard :background ,darktooth-dark_aqua))))
   ;; Use tip colors for the pos-tip color vars (see below)

   ;; Inherit ac-dabbrev from popup menu face
   ;; MODE SUPPORT: ac-dabbrev
   `(ac-dabbrev-menu-face                      ((t (:inherit popup-face))))
   `(ac-dabbrev-selection-face                 ((t (:inherit popup-menu-selection-face))))

   ;; MODE SUPPORT: sh mode
   `(sh-heredoc                                ((t (:foreground ,darktooth-darkslategray4 :background nil))))
   `(sh-quoted-exec                            ((t (:foreground ,darktooth-darkslategray4 :background nil))))

   ;; MODE SUPPORT: company
   `(company-echo                              ((t (:inherit company-echo-common))))
   `(company-echo-common                       ((t (:foreground ,darktooth-bright_blue :background nil))))
   `(company-preview-common                    ((t (:underline ,darktooth-light1))))
   `(company-preview                           ((t (:inherit company-preview-common))))
   `(company-preview-search                    ((t (:inherit company-preview-common))))
   `(company-template-field                    ((t (:foreground ,darktooth-bright_blue :background nil :underline ,darktooth-dark_blue))))
   `(company-scrollbar-fg                      ((t (:foreground nil :background ,darktooth-dark2))))
   `(company-scrollbar-bg                      ((t (:foreground nil :background ,darktooth-dark3))))
   `(company-tooltip                           ((t (:foreground ,darktooth-light0_hard :background ,darktooth-dark1))))
   `(company-preview-common                    ((t (:inherit font-lock-comment-face))))
   `(company-tooltip-common                    ((t (:foreground ,darktooth-light0 :background ,darktooth-dark1))))
   `(company-tooltip-annotation                ((t (:foreground ,darktooth-bright_blue :background ,darktooth-dark1))))
   `(company-tooltip-common-selection          ((t (:foreground ,darktooth-light0 :background ,darktooth-faded_blue))))
   `(company-tooltip-mouse                     ((t (:foreground ,darktooth-dark0 :background ,darktooth-bright_blue))))
   `(company-tooltip-selection                 ((t (:foreground ,darktooth-light0 :background ,darktooth-faded_blue))))

   ;; MODE SUPPORT: dired+
   `(diredp-file-name                          ((t (:foreground ,darktooth-light2 ))))
   `(diredp-file-suffix                        ((t (:foreground ,darktooth-light4 ))))
   `(diredp-compressed-file-suffix             ((t (:foreground ,darktooth-faded_cyan ))))
   `(diredp-dir-name                           ((t (:foreground ,darktooth-faded_cyan ))))
   `(diredp-dir-heading                        ((t (:foreground ,darktooth-bright_cyan ))))
   `(diredp-symlink                            ((t (:foreground ,darktooth-bright_orange ))))
   `(diredp-date-time                          ((t (:foreground ,darktooth-light3 ))))
   `(diredp-number                             ((t (:foreground ,darktooth-faded_cyan ))))
   `(diredp-no-priv                            ((t (:foreground ,darktooth-dark4 ))))
   `(diredp-other-priv                         ((t (:foreground ,darktooth-dark2 ))))
   `(diredp-rare-priv                          ((t (:foreground ,darktooth-dark4 ))))
   `(diredp-ignored-file-name                  ((t (:foreground ,darktooth-dark4 ))))

   `(diredp-dir-priv                           ((t (:foreground ,darktooth-faded_cyan  :background ,darktooth-dark_blue))))
   `(diredp-exec-priv                          ((t (:foreground ,darktooth-faded_cyan  :background ,darktooth-dark_blue))))
   `(diredp-link-priv                          ((t (:foreground ,darktooth-faded_aqua  :background ,darktooth-dark_aqua))))
   `(diredp-read-priv                          ((t (:foreground ,darktooth-bright_red  :background ,darktooth-dark_red))))
   `(diredp-write-priv                         ((t (:foreground ,darktooth-bright_aqua :background ,darktooth-dark_aqua))))

   ;; MODE SUPPORT: helm
   `(helm-M-x-key                              ((t (:foreground ,darktooth-neutral_orange))))
   `(helm-action                               ((t (:foreground ,darktooth-white :underline t))))
   `(helm-bookmark-addressbook                 ((t (:foreground ,darktooth-neutral_red))))
   `(helm-bookmark-directory                   ((t (:foreground ,darktooth-bright_purple))))
   `(helm-bookmark-file                        ((t (:foreground ,darktooth-faded_blue))))
   `(helm-bookmark-gnus                        ((t (:foreground ,darktooth-faded_purple))))
   `(helm-bookmark-info                        ((t (:foreground ,darktooth-turquoise4))))
   `(helm-bookmark-man                         ((t (:foreground ,darktooth-sienna))))
   `(helm-bookmark-w3m                         ((t (:foreground ,darktooth-neutral_yellow))))
   `(helm-buffer-directory                     ((t (:foreground ,darktooth-white :background ,darktooth-bright_blue))))
   `(helm-buffer-not-saved                     ((t (:foreground ,darktooth-faded_red))))
   `(helm-buffer-process                       ((t (:foreground ,darktooth-burlywood4))))
   `(helm-buffer-saved-out                     ((t (:foreground ,darktooth-bright_red))))
   `(helm-buffer-size                          ((t (:foreground ,darktooth-bright_purple))))
   `(helm-candidate-number                     ((t (:foreground ,darktooth-neutral_green))))
   `(helm-ff-directory                         ((t (:foreground ,darktooth-neutral_purple))))
   `(helm-ff-executable                        ((t (:foreground ,darktooth-turquoise4))))
   `(helm-ff-file                              ((t (:foreground ,darktooth-sienna))))
   `(helm-ff-invalid-symlink                   ((t (:foreground ,darktooth-white :background ,darktooth-bright_red))))
   `(helm-ff-prefix                            ((t (:foreground ,darktooth-black :background ,darktooth-neutral_yellow))))
   `(helm-ff-symlink                           ((t (:foreground ,darktooth-neutral_orange))))
   `(helm-grep-cmd-line                        ((t (:foreground ,darktooth-neutral_green))))
   `(helm-grep-file                            ((t (:foreground ,darktooth-faded_purple))))
   `(helm-grep-finish                          ((t (:foreground ,darktooth-turquoise4))))
   `(helm-grep-lineno                          ((t (:foreground ,darktooth-neutral_orange))))
   `(helm-grep-match                           ((t (:foreground ,darktooth-neutral_yellow))))
   `(helm-grep-running                         ((t (:foreground ,darktooth-neutral_red))))
   `(helm-header                               ((t (:foreground ,darktooth-aquamarine4))))
   `(helm-helper                               ((t (:foreground ,darktooth-aquamarine4))))
   `(helm-history-deleted                      ((t (:foreground ,darktooth-black :background ,darktooth-bright_red))))
   `(helm-history-remote                       ((t (:foreground ,darktooth-faded_red))))
   `(helm-lisp-completion-info                 ((t (:foreground ,darktooth-faded_orange))))
   `(helm-lisp-show-completion                 ((t (:foreground ,darktooth-bright_red))))
   `(helm-locate-finish                        ((t (:foreground ,darktooth-white :background ,darktooth-aquamarine4))))
   `(helm-match                                ((t (:foreground ,darktooth-neutral_orange))))
   `(helm-moccur-buffer                        ((t (:foreground ,darktooth-bright_aqua :underline t))))
   `(helm-prefarg                              ((t (:foreground ,darktooth-turquoise4))))
   `(helm-selection                            ((t (:foreground ,darktooth-white :background ,darktooth-dark2))))
   `(helm-selection-line                       ((t (:foreground ,darktooth-white :background ,darktooth-dark2))))
   `(helm-separator                            ((t (:foreground ,darktooth-faded_red))))
   `(helm-source-header                        ((t (:foreground ,darktooth-light2 :background ,darktooth-dark1))))
   `(helm-visible-mark                         ((t (:foreground ,darktooth-black :background ,darktooth-light3))))

   ;; MODE SUPPORT: column-marker
   `(column-marker-1                           ((t (:background ,darktooth-faded_blue))))
   `(column-marker-2                           ((t (:background ,darktooth-faded_purple))))
   `(column-marker-3                           ((t (:background ,darktooth-faded_cyan))))

   ;; MODE SUPPORT: vline
   `(vline                                     ((t (:background ,darktooth-dark_aqua))))
   `(vline-visual                              ((t (:background ,darktooth-dark_aqua))))

   ;; MODE SUPPORT: col-highlight
   `(col-highlight                             ((t (:inherit vline))))

   ;; MODE SUPPORT: column-enforce-mode
   `(column-enforce-face                       ((t (:foreground ,darktooth-dark4 :background ,darktooth-dark_red))))

   ;; MODE SUPPORT: hydra
   `(hydra-face-red                            ((t (:foreground ,darktooth-bright_red))))
   `(hydra-face-blue                           ((t (:foreground ,darktooth-bright_blue))))
   `(hydra-face-pink                           ((t (:foreground ,darktooth-identifiers-15))))
   `(hydra-face-amaranth                       ((t (:foreground ,darktooth-faded_purple))))
   `(hydra-face-teal                           ((t (:foreground ,darktooth-faded_cyan))))

   ;; MODE SUPPORT: ivy
   `(ivy-current-match                         ((t (:foreground ,darktooth-light0 :background ,darktooth-faded_blue))))
   `(ivy-minibuffer-match-face-1               ((t (:background ,darktooth-dark1))))
   `(ivy-minibuffer-match-face-2               ((t (:background ,darktooth-dark2))))
   `(ivy-minibuffer-match-face-3               ((t (:background ,darktooth-faded_aqua))))
   `(ivy-minibuffer-match-face-4               ((t (:background ,darktooth-faded_purple))))
   `(ivy-confirm-face                          ((t (:foreground ,darktooth-bright_green))))
   `(ivy-match-required-face                   ((t (:foreground ,darktooth-bright_red))))
   `(ivy-remote                                ((t (:foreground ,darktooth-neutral_blue))))

   ;; MODE SUPPORT: smerge
   ;; TODO: smerge-base, smerge-refined-changed
   `(smerge-mine                               ((t (:background ,darktooth-mid_purple))))
   `(smerge-other                              ((t (:background ,darktooth-mid_blue))))
   `(smerge-markers                            ((t (:background ,darktooth-dark0_soft))))
   `(smerge-refined-added                      ((t (:background ,darktooth-dark_green))))
   `(smerge-refined-removed                    ((t (:background ,darktooth-dark_red))))

   ;; MODE SUPPORT: git-gutter
   `(git-gutter:separator                      ((t (:inherit git-gutter+-separator ))))
   `(git-gutter:modified                       ((t (:inherit git-gutter+-modified ))))
   `(git-gutter:added                          ((t (:inherit git-gutter+-added ))))
   `(git-gutter:deleted                        ((t (:inherit git-gutter+-deleted ))))
   `(git-gutter:unchanged                      ((t (:inherit git-gutter+-unchanged ))))

   ;; MODE SUPPORT: git-gutter+
   `(git-gutter+-commit-header-face            ((t (:inherit font-lock-comment-face))))
   `(git-gutter+-added                         ((t (:foreground ,darktooth-faded_green :background ,darktooth-muted_green ))))
   `(git-gutter+-deleted                       ((t (:foreground ,darktooth-faded_red :background ,darktooth-muted_red ))))
   `(git-gutter+-modified                      ((t (:foreground ,darktooth-faded_purple :background ,darktooth-muted_purple ))))
   `(git-gutter+-separator                     ((t (:foreground ,darktooth-faded_cyan :background ,darktooth-muted_cyan ))))
   `(git-gutter+-unchanged                     ((t (:foreground ,darktooth-faded_yellow :background ,darktooth-muted_yellow ))))


   ;; MODE SUPPORT: git-gutter-fr+
   `(git-gutter-fr+-added                      ((t (:inherit git-gutter+-added))))
   `(git-gutter-fr+-deleted                    ((t (:inherit git-gutter+-deleted))))
   `(git-gutter-fr+-modified                   ((t (:inherit git-gutter+-modified))))

   ;; MODE SUPPORT: magit
   `(magit-branch                              ((t (:foreground ,darktooth-turquoise4 :background nil))))
   `(magit-branch-local                        ((t (:foreground ,darktooth-turquoise4 :background nil))))
   `(magit-branch-remote                       ((t (:foreground ,darktooth-aquamarine4 :background nil))))
   `(magit-cherry-equivalent                   ((t (:foreground ,darktooth-neutral_orange))))
   `(magit-cherry-unmatched                    ((t (:foreground ,darktooth-neutral_purple))))
   `(magit-diff-context                        ((t (:foreground ,darktooth-dark3 :background nil))))
   `(magit-diff-context-highlight              ((t (:foreground ,darktooth-dark4 :background ,darktooth-dark0_soft))))
   `(magit-diff-added                          ((t (:foreground ,darktooth-bright_green :background ,darktooth-mid_green))))
   `(magit-diff-added-highlight                ((t (:foreground ,darktooth-bright_green :background ,darktooth-mid_green))))
   `(magit-diff-removed                        ((t (:foreground ,darktooth-bright_red :background ,darktooth-mid_red))))
   `(magit-diff-removed-highlight              ((t (:foreground ,darktooth-bright_red :background ,darktooth-mid_red))))
   `(magit-diff-add                            ((t (:foreground ,darktooth-bright_green))))
   `(magit-diff-del                            ((t (:foreground ,darktooth-bright_red))))
   `(magit-diff-file-header                    ((t (:foreground ,darktooth-bright_blue))))
   `(magit-diff-hunk-header                    ((t (:foreground ,darktooth-neutral_aqua))))
   `(magit-diff-merge-current                  ((t (:background ,darktooth-dark_yellow))))
   `(magit-diff-merge-diff3-separator          ((t (:foreground ,darktooth-neutral_orange :weight bold))))
   `(magit-diff-merge-proposed                 ((t (:background ,darktooth-dark_green))))
   `(magit-diff-merge-separator                ((t (:foreground ,darktooth-neutral_orange))))
   `(magit-diff-none                           ((t (:foreground ,darktooth-medium))))
   `(magit-item-highlight                      ((t (:background ,darktooth-dark1 :weight normal))))
   `(magit-item-mark                           ((t (:background ,darktooth-dark0))))
   `(magit-key-mode-args-face                  ((t (:foreground ,darktooth-light4))))
   `(magit-key-mode-button-face                ((t (:foreground ,darktooth-neutral_orange :weight bold))))
   `(magit-key-mode-header-face                ((t (:foreground ,darktooth-light4 :weight bold))))
   `(magit-key-mode-switch-face                ((t (:foreground ,darktooth-turquoise4 :weight bold))))
   `(magit-log-author                          ((t (:foreground ,darktooth-neutral_aqua))))
   `(magit-log-date                            ((t (:foreground ,darktooth-faded_orange))))
   `(magit-log-graph                           ((t (:foreground ,darktooth-light1))))
   `(magit-log-head-label-bisect-bad           ((t (:foreground ,darktooth-bright_red))))
   `(magit-log-head-label-bisect-good          ((t (:foreground ,darktooth-bright_green))))
   `(magit-log-head-label-bisect-skip          ((t (:foreground ,darktooth-neutral_yellow))))
   `(magit-log-head-label-default              ((t (:foreground ,darktooth-neutral_blue))))
   `(magit-log-head-label-head                 ((t (:foreground ,darktooth-light0 :background ,darktooth-dark_aqua))))
   `(magit-log-head-label-local                ((t (:foreground ,darktooth-faded_blue :weight bold))))
   `(magit-log-head-label-patches              ((t (:foreground ,darktooth-faded_orange))))
   `(magit-log-head-label-remote               ((t (:foreground ,darktooth-neutral_blue :weight bold))))
   `(magit-log-head-label-tags                 ((t (:foreground ,darktooth-neutral_aqua))))
   `(magit-log-head-label-wip                  ((t (:foreground ,darktooth-neutral_red))))
   `(magit-log-message                         ((t (:foreground ,darktooth-light1))))
   `(magit-log-reflog-label-amend              ((t (:foreground ,darktooth-bright_blue))))
   `(magit-log-reflog-label-checkout           ((t (:foreground ,darktooth-bright_yellow))))
   `(magit-log-reflog-label-cherry-pick        ((t (:foreground ,darktooth-neutral_red))))
   `(magit-log-reflog-label-commit             ((t (:foreground ,darktooth-neutral_green))))
   `(magit-log-reflog-label-merge              ((t (:foreground ,darktooth-bright_green))))
   `(magit-log-reflog-label-other              ((t (:foreground ,darktooth-faded_red))))
   `(magit-log-reflog-label-rebase             ((t (:foreground ,darktooth-bright_blue))))
   `(magit-log-reflog-label-remote             ((t (:foreground ,darktooth-neutral_orange))))
   `(magit-log-reflog-label-reset              ((t (:foreground ,darktooth-neutral_yellow))))
   `(magit-log-sha1                            ((t (:foreground ,darktooth-bright_orange))))
   `(magit-process-ng                          ((t (:foreground ,darktooth-bright_red :weight bold))))
   `(magit-process-ok                          ((t (:foreground ,darktooth-bright_green :weight bold))))
   `(magit-section-heading                     ((t (:foreground ,darktooth-light2 :background ,darktooth-dark_blue))))
   `(magit-signature-bad                       ((t (:foreground ,darktooth-bright_red :weight bold))))
   `(magit-signature-good                      ((t (:foreground ,darktooth-bright_green :weight bold))))
   `(magit-signature-none                      ((t (:foreground ,darktooth-faded_red))))
   `(magit-signature-untrusted                 ((t (:foreground ,darktooth-bright_purple :weight bold))))
   `(magit-tag                                 ((t (:foreground ,darktooth-darkslategray4))))
   `(magit-whitespace-warning-face             ((t (:background ,darktooth-faded_red))))
   `(magit-bisect-bad                          ((t (:foreground ,darktooth-faded_red))))
   `(magit-bisect-good                         ((t (:foreground ,darktooth-neutral_green))))
   `(magit-bisect-skip                         ((t (:foreground ,darktooth-light2))))
   `(magit-blame-date                          ((t (:inherit magit-blame-heading))))
   `(magit-blame-name                          ((t (:inherit magit-blame-heading))))
   `(magit-blame-hash                          ((t (:inherit magit-blame-heading))))
   `(magit-blame-summary                       ((t (:inherit magit-blame-heading))))
   `(magit-blame-heading                       ((t (:background ,darktooth-dark1 :foreground ,darktooth-light0))))
   `(magit-sequence-onto                       ((t (:inherit magit-sequence-done))))
   `(magit-sequence-done                       ((t (:inherit magit-hash))))
   `(magit-sequence-drop                       ((t (:foreground ,darktooth-faded_red))))
   `(magit-sequence-head                       ((t (:foreground ,darktooth-faded_cyan))))
   `(magit-sequence-part                       ((t (:foreground ,darktooth-bright_yellow))))
   `(magit-sequence-stop                       ((t (:foreground ,darktooth-bright_aqua))))
   `(magit-sequence-pick                       ((t (:inherit default))))
   `(magit-filename                            ((t (:weight normal))))
   `(magit-refname-wip                         ((t (:inherit magit-refname))))
   `(magit-refname-stash                       ((t (:inherit magit-refname))))
   `(magit-refname                             ((t (:foreground ,darktooth-light2))))
   `(magit-head                                ((t (:inherit magit-branch-local))))
   `(magit-popup-disabled-argument             ((t (:foreground ,darktooth-light4))))

   ;; MODE SUPPORT: term
   `(term-color-black                          ((t (:foreground ,darktooth-dark1))))
   `(term-color-blue                           ((t (:foreground ,darktooth-neutral_blue))))
   `(term-color-cyan                           ((t (:foreground ,darktooth-neutral_cyan))))
   `(term-color-green                          ((t (:foreground ,darktooth-neutral_green))))
   `(term-color-magenta                        ((t (:foreground ,darktooth-neutral_purple))))
   `(term-color-red                            ((t (:foreground ,darktooth-neutral_red))))
   `(term-color-white                          ((t (:foreground ,darktooth-light1))))
   `(term-color-yellow                         ((t (:foreground ,darktooth-neutral_yellow))))
   `(term-default-fg-color                     ((t (:foreground ,darktooth-light0))))
   `(term-default-bg-color                     ((t (:background ,darktooth-dark0))))

   ;; MODE SUPPORT: Elfeed
   `(elfeed-search-date-face                    ((t (:foreground ,darktooth-muted_cyan))))
   `(elfeed-search-feed-face                    ((t (:foreground ,darktooth-faded_cyan))))
   `(elfeed-search-tag-face                     ((t (:foreground ,darktooth-light3))))
   `(elfeed-search-title-face                   ((t (:foreground ,darktooth-light3 :bold nil))))
   `(elfeed-search-unread-title-face            ((t (:foreground ,darktooth-light0_hard :bold nil))))

   ;; MODE SUPPORT: message
   `(message-header-to                          ((t (:foreground ,darktooth-bright_cyan ))))
   `(message-header-cc                          ((t (:foreground ,darktooth-bright_cyan ))))
   `(message-header-subject                     ((t (:foreground ,darktooth-light2 ))))
   `(message-header-newsgroups                  ((t (:foreground ,darktooth-bright_cyan ))))
   `(message-header-other                       ((t (:foreground ,darktooth-muted_cyan  ))))
   `(message-header-name                        ((t (:foreground ,darktooth-bright_cyan ))))
   `(message-header-xheader                     ((t (:foreground ,darktooth-faded_cyan ))))
   `(message-separator                          ((t (:foreground ,darktooth-faded_cyan ))))
   `(message-cited-text                         ((t (:foreground ,darktooth-light3 ))))
   `(message-mml                                ((t (:foreground ,darktooth-faded_aqua )))))

  (custom-theme-set-variables
   'darktooth

   `(pos-tip-foreground-color ,darktooth-light0_hard)
   `(pos-tip-background-color ,darktooth-dark_aqua)

   `(ansi-color-names-vector ["#3C3836"
                              "#FB4934"
                              "#84BB26"
                              "#FABD2F"
                              "#83A598"
                              "#D3869B"
                              "#3FD7E5"
                              "#EBDBB2"])))

;;;###autoload
(and load-file-name
     (boundp 'custom-theme-load-path)
     (add-to-list 'custom-theme-load-path
                  (file-name-as-directory
                   (file-name-directory load-file-name))))

(defun darktooth-modeline ()
  "Optional modeline styling for darktooth."
  (interactive)
  (set-face-attribute 'mode-line nil
                      :inherit 'mode-line-face
                      :foreground "#BDAE93"
                      :background "#1D2021"
                      :height 120
                      :inverse-video nil
                      :box '(:line-width 6 :color "#1D2021" :style nil))
  (set-face-attribute 'mode-line-inactive nil
                      :inherit 'mode-line-face
                      :foreground "#504945"
                      :background "#32302F"
                      :height 120
                      :inverse-video nil
                      :box '(:line-width 6 :color "#32302F" :style nil)))

(provide-theme 'darktooth)

;; Local Variables:
;; eval: (when (fboundp 'rainbow-mode) (rainbow-mode 1))
;; End:

;;; darktooth-theme.el ends here
