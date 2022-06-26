;;;; John Haman's Emacs configuration  -*- lexical-binding: t; -*-

;;; Optimizations
(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)
(setq bidi-inhibit-bpa t)
(setq-default cursor-in-non-selected-windows nil)
(setq fast-but-imprecise-scrolling t)
(setq jit-lock-defer-time 0)
(setq auto-window-vscroll nil)
(setq frame-inhibit-implied-resize t)
(setq ffap-machine-p-known 'reject)
(setq inhibit-compacting-font-caches t)

;; scroll settings
(setq scroll-margin 1
      scroll-step 1
      scroll-conservatively 10000
      scroll-preserve-screen-position 1)

;; Misc. Windows settings
(when (eq system-type 'windows-nt)
  (setq w32-get-true-file-attributes nil
        w32-pipe-read-delay 0
        w32-pipe-buffer-size (* 64 1024)))

;; C variables
(setq-default cursor-in-non-selected-windows nil)
(setq redisplay-dont-pause t)
(prefer-coding-system 'utf-8)
(setq-default buffer-file-coding-system 'utf-8-unix) ;; this seems required w/ straight.

;; Fix magit, but only on native windows
(when (eq system-type 'windows-nt)
  (setenv "SSH_ASKPASS" "git-gui--askpass"))

(setq ring-bell-function 'ignore)
(setq confirm-kill-processes nil)
(setq delete-by-moving-to-trash t)
(fset 'yes-or-no-p 'y-or-n-p)
(define-key key-translation-map (kbd "ESC") (kbd "C-g"))
(setq-default indent-tabs-mode nil)
(setq save-interprogram-paste-before-kill t
      apropos-do-all t
      visible-bell t
      load-prefer-newer t)
(setq recenter-positions '(middle top bottom))
(setq-default frame-title-format '("%b — Emacs "emacs-version""))
(setq cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)
(setq sentence-end-double-space nil)
(setq header-line-format nil)
(setq-default fill-column 80)
(setq x-stretch-cursor nil)

;; allow narrowing
(put 'narrow-to-defun  'disabled nil)
(put 'narrow-to-page   'disabled nil)
(put 'narrow-to-region 'disabled nil)

;; start up
(setq inhibit-startup-message t
      inhibit-startup-echo-area-message user-login-name
      inhibit-default-init t)


;; Maximize on startup
(add-hook 'window-setup-hook 'toggle-frame-maximized t)

;; UI. These two settings cannot go into early-init.el
(blink-cursor-mode -1)
(tooltip-mode -1)

;; function to make emacs quiet
(defun suppress-messages (func &rest args)
  "Suppress message output from FUNC."
  ;; Some packages are too noisy.
  ;; https://superuser.com/questions/669701/emacs-disable-some-minibuffer-messages
  (cl-flet ((silence (&rest args1) (ignore)))
    (advice-add 'message :around #'silence)
    (unwind-protect
        (apply func args)
      (advice-remove 'message #'silence))))

(defun no-msg (func &rest args)
  "Prevent FUNCTION from showing `Wrote <FILE>' messages.
\(The messages are still logged to `*Messages*'.)"
  (let ((inhibit-message  t))
    (funcall func)))

;; Straight settings
(setq straight-recipes-gnu-elpa-use-mirror t)

;; todo: switch back to straight stable after emacs 28 is stable.
(setq straight-repository-branch "develop")

;;(when (eq system-type 'gnu/linux)
;; (setq straight-vc-git-default-protocol "ssh"))

;; bootstrap straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Install use-package
(straight-use-package 'use-package)
(setq use-package-verbose t)
(setq use-package-compute-statistics t)

(use-package gcmh
  :straight t
  :init
  (gcmh-mode 1))

(use-package paren
  :custom
  (show-paren-delay 0)
  :config
  (show-paren-mode 1))

;; No-littering should come first
(use-package no-littering
  :straight t
  :config
  (setq create-lockfiles nil)
  (setq auto-save-file-name-transforms
        `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
  (setq backup-directory-alist
        `((".*" . , (concat no-littering-var-directory "backup/")))))

(use-package minions
  :straight t
  :custom
  (minions-mode-line-lighter "·")
  :config
  (minions-mode 1))

(use-package modus-themes
  :straight t
  :init
  (modus-themes-load-themes)
  :custom
  (modus-themes-fringes nil)
  (modus-themes-bold-constructs t)
  (modus-themes-italic-constructs t)
  (modus-themes-org-agenda
   '((header-block . (variable-pitch 1.5 semibold))
     (header-date . (grayscale workaholic bold-today 1.2))
     (event . (accented italic varied))
     (scheduled . rainbow)
     (habit . traffic-light)))
  (modus-themes-completions
   '((matches . (background))
     (selection . nil)
     (popup . nil)))
  (modus-themes-links '(faint neutral-underline))
  (modus-themes-subtle-line-numbers t)
  (modus-themes-prompts '(bold background))
  (modus-themes-hl-line nil)
  (modus-themes-paren-match nil)
  (modus-themes-variable-pitch-ui nil)
  (modus-themes-mode-line '(borderless))
  (modus-themes-hl-line nil)
  (modus-themes-intense-mouseovers t)
  (modus-themes-org-blocks 'gray-background)
  (modus-themes-region nil)
  (modus-themes-headings
   '((1 . (variable-pitch rainbow 1.25))
     (2 . (rainbow 1.125))
     (t . (rainbow 1.0))))
  :config
  (setq x-underline-at-descent-line t)
  (modus-themes-load-operandi))

(straight-use-package
 '(blackout :host github :repo "raxod502/blackout"))

(use-package blackout
  :blackout (fundamental-mode . "φ"))

(use-package undo-tree
  ;; We don't need this now, but persistent undo is pretty sweet.
  :straight t
  :custom
  (undo-tree-enable-undo-in-region t)
  (undo-tree-auto-save-history t)
  :config
  (advice-add 'undo-tree-save-history :around #'suppress-messages)
  (global-undo-tree-mode))

(use-package evil
  :after (minions)
  :straight t
  :init
  (setq evil-undo-system 'undo-tree)
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-Y-yank-to-eol t) ; t, but doesn't work?

  ;; I noticed some settings do not work in :custom
  :config
  (setq evil-show-paren-range 0)
  (setq evil-move-beyond-eol t)
  (setq evil-echo-state nil)
  (setq evil-want-C-u-scroll nil)
  (setq evil-want-minibuffer nil)

  (setq evil-default-state 'normal)
  (setq evil-visual-state-cursor 'hollow)
  (setq evil-insert-state-cursor '(bar . 3))
  (evil-mode 1))

(use-package evil-collection
  :straight t
  :after evil
  :init
  (evil-collection-init)
  :custom
  (evil-collection-outline-bind-tab-p t)) ;; may need to revisit

(use-package general
  :after evil-collection
  :straight t
  :config

  ;; remap some useless keys in Normal state
  (general-define-key
   :states 'normal
   "C-S-<backspace>" 'restart-emacs
   "C-1" 'delete-other-windows
   "C-2" 'split-and-follow-horizontally
   "C-3" 'split-and-follow-vertically
   "C-0" 'delete-window
   "0" 'jth/goto-scratch
   "f" 'avy-goto-char-timer
   "q" 'bury-buffer
   "Q" 'evil-record-macro
   "U" 'evil-redo
   "s" 'consult-line
   "/" 'consult-line
   "C-r" 'isearch-backward
   "\\" 'other-window
   "DEL" 'winner-undo
   "C-<up>" '(lambda() (interactive) (scroll-other-window -1))
   "C-<down>" '(lambda() (interactive) (scroll-other-window 1))
   "S-<backspace>" 'winner-redo
   "S-<left>" 'previous-buffer
   "S-<right>" 'next-buffer
   ";" 'er/expand-region)

  ;; Make good use for the Fn keys.
  (general-define-key
   "<f1>" 'eval-expression
   "<f5>" 'modus-themes-toggle
   "<f10>" 'menu-bar-open ; default, just to remind me to not bind this key
   "<f11>" 'toggle-frame-fullscreen) ; default

  ;; Better way to move by parens
  (general-define-key
   :states '(normal visual)
   "u" 'undo ;; should be in visual mode too, for undo w/i region
   "<" 'jth-backward-left-bracket
   ">" 'jth-forward-right-bracket)

  ;; quick motions that work in visual lines
  (general-define-key
   :states '(normal visual motion)
   "H" 'evil-first-non-blank-of-visual-line
   "L" 'end-of-visual-line
   "<up>" 'evil-previous-visual-line
   "<down>" 'evil-next-visual-line
   "j" 'evil-next-visual-line
   "k" 'evil-previous-visual-line)

  ;; I want to have a hotkey for date and time insertion.
  (general-define-key
   :keymaps '(minibuffer-mode-map)
   "C-d" 'date
   "C-S-d" 'timestamp)

  (general-define-key
   :states 'insert
   "C-d" 'date
   "C-S-d" 'timestamp)

  ;; ctrl-keys in Normal state
  (general-define-key
   :keymaps 'override
   :states '(normal visual motion)
   "C-l" 'recenter-top-bottom
   "C-j" 'jth/go-down
   "C-k" 'jth/go-up
   "C-o" 'other-window)

  ;; ctrl-keys in insert state
  (general-define-key
   :keymaps 'override
   :states '(insert emacs)
   "C-o" 'other-window)

  ;; Hippie Expand
  (general-define-key
   :defer 5
   :states '(normal insert)
   :keymaps 'override
   "C-<tab>" 'hippie-expand)

  ;; my personal Spacemacs
  (general-define-key
   :prefix "SPC"
   :keymaps 'override
   :states '(normal visual motion)

   "<left>" 'previous-buffer
   "<right>" 'next-buffer

   "1" 'delete-other-windows
   "2" 'split-and-follow-horizontally
   "3" 'split-and-follow-vertically
   "4" 'olivetti-mode
   "5" 'variable-pitch-mode
   "6" 'display-line-numbers-mode
   "7" 'toggle-truncate-lines
   "0" 'delete-window

   "a" 'org-agenda                         "A" 'emacs-devel
   "b" 'consult-buffer                     "B" 'ibuffer
   "c" 'org-capture
   "d" 'kill-buffer-and-window             "D" 'kill-buffer
   "e" 'consult-imenu                      "E" 'mu4e
   "f" 'find-file                          "F" 'find-file-other-window
   "g" 'magit-status                       "G" 'proced
   "h" 'mark-whole-buffer
   "i" 'goto-last-change                   "I" 'goto-last-change-reverse
   "j" 'dired-jump                         "J" 'dired
   "k" 'consult-ripgrep
   "l" 'jth-consult-find
   "m" 'langtool-goto-next-error           "M" 'langtool-check-buffer
   "n" 'bookmark-jump                      "N" 'jth/bookmark-set-and-save
   "o" 'other-window                       "O" 'ace-swap-window
   "p" 'project-find-file                  "P" 'project-switch-project
   "q" 'fill-paragraph                     "Q" 'unfill-paragraph
   "r" 'consult-register-load              "R" 'window-configuration-to-register
   "s" 'consult-line                       "S" 'query-replace
   "t" 'frame-pop                          "T" 'make-frame
   "u" 'comint-clear-buffer                "U" 'elfeed
   "v" 'flyspell-correct-word-before-point "V" 'flyspell-buffer
   "w" 'write-file                         "W" 'pandoc-main-hydra/body
   "x" 'execute-extended-command
   "y" 'consult-yank-pop
   "z" 'vertico-repeat

   "`" 'popper-toggle-latest
   "~" 'popper-cycle

   "\\" 'window-split-toggle
   "SPC" 'jth/save-all
   "RET" 'eshell
   "S-<return>" 'vterm
   ";" 'comment-dwim
   ":" 'comment-box
   "-" 'calendar
   "=" 'quick-calc
   "+" 'calc
   "," 'eww)

  ;; improved help management
  (general-create-definer help-leader
    :prefix "-")

  (help-leader
    :states 'normal
    :keymaps 'override
    "b" 'embark-bindings
    "a" 'consult-apropos
    "l" 'find-library
    "o" 'describe-symbol
    "m" 'describe-mode
    "c" 'describe-command
    "f" 'describe-function
    "k" 'describe-key
    "v" 'describe-variable)

  ;; better navigation with mouse buttons
  (if (eq system-type 'windows-nt)
      (general-define-key
       :states '(normal insert)
       "<mouse-4>" 'previous-buffer
       "<mouse-5>" 'next-buffer))

  (if (eq system-type 'gnu/linux)
      (general-define-key
       :states '(normal insert)
       "<mouse-8>" 'previous-buffer
       "<mouse-9>" 'next-buffer)))

;; Built-in Emacs packages:
(use-package hippie-exp
  :defer t)

(use-package ispell
  :after flyspell
  :custom
  (ispell-local-dictionary "en_US")
  (ispell-dictionary "english")
  (ispell-local-dictionary-alist
   '(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US") nil utf-8)))
  (ispell-hunspell-dictionary-alist ispell-local-dictionary-alist)
  :config
  (if (eq system-type 'windows-nt)
      (setq ispell-program-name "C:/msys64/mingw64/bin/hunspell.exe")))

(use-package comp
  :if (and (fboundp 'native-comp-available-p)
           (native-comp-available-p))
  :custom
  (native-comp-async-report-warnings-errors nil))

(use-package abbrev
  :defer 10
  :custom
  (abbrev-file-name (concat no-littering-etc-directory "abbrev/abbrev_defs.txt"))
  :config
  (if (file-exists-p abbrev-file-name)
      (quietly-read-abbrev-file))
  (setq-default abbrev-mode t))

(use-package custom
  :no-require t
  :init
  (setq custom-file
        (concat no-littering-var-directory "custom.el")))

(use-package face-remap
  :bind
  ("C-=" . text-scale-increase)
  ("C-+" . text-scale-increase)
  ("C--" . text-scale-decrease))

(use-package files
  :custom
  (require-final-newline t)
  (save-abbrevs 'silently)
  (delete-old-versions t)
  :config
  (cd "~/"))

(use-package info
  :hook
  (info-mode . olivetti-mode))

(use-package gnus
  :defer t
  :hook
  (gnus-article-mode . olivetti-mode)
  :config
  (setq gnus-secondary-select-methods
        '((nntp "news.gmane.io"))))

(use-package eww
  :defer t
  :custom
  (eww-auto-rename-buffer t)
  :hook
  (eww-mode . olivetti-mode))

(use-package mouse
  :after evil-collection
  :custom
  (mouse-yank-at-point t)
  :config
  ;; I think the mouse keys on the modeline are backwards...
  (global-set-key [mode-line mouse-3] 'mouse-delete-other-windows)
  (global-set-key [mode-line mouse-2] 'mouse-delete-window))

(use-package mwheel
  :custom
  (mouse-wheel-progressive-speed nil)
  (mouse-wheel-scroll-amount '(1 ((shift) . 5))))

(use-package whitespace
  :hook
  (before-save . whitespace-cleanup))

(use-package desktop
  :if (eq system-type 'gnu/linux)
  :init
  (desktop-save-mode 1))

(use-package help
  :custom
  (help-window-select t))

(use-package image-mode
  :defer t
  :custom
  (image-transform-resize 'fit-height))

(use-package autorevert
  :after dired
  :custom
  (auto-revert-verbose nil)
  :config
  (global-auto-revert-mode 1))

(use-package dired
  :defer 5
  :blackout (dired-mode . "δ")
  :custom
  (ls-lisp-use-insert-directory-program nil)
  (ls-lisp-dirs-first t)
  (dired-clean-confirm-killing-deleted-buffers nil)
  (dired-kill-when-opening-new-dired-buffer t)
  (dired-auto-revert-buffer t)
  (dired-listing-switches "-alhXA")
  (dired-recursive-copies 'always)
  (dired-recursive-deletes 'always)
  (dired-make-directory-clickable t) ; Emacs 29.1
  (dired-dwim-target t)

  :hook
  (dired-mode . auto-revert-mode)

  :init
  (put 'dired-find-alternate-file 'disabled nil)

  :config
  (add-hook 'dired-mode-hook #'hl-line-mode)
  (general-define-key
   :states 'normal
   :keymaps 'dired-mode-map
   "h" 'dired-up-directory
   "RET" 'dired-find-alternate-file
   "l" 'dired-find-alternate-file))

(use-package dired-x
  :defer 5
  :commands dired-jump)

(use-package dired-du
  :straight t
  :defer t
  :custom
  (dired-du-size-format t))

(use-package ediff
  ;; rm? I don't use ediff
  :defer t
  :custom
  (ediff-window-setup-function #'ediff-setup-windows-plain))

(use-package uniquify
  :after vertico
  :custom
  (uniquify-strip-common-suffix t)
  (uniquify-after-kill-buffer-p t)
  ;;(uniquify-min-dir-content 1)
  (uniquify-buffer-name-style 'forward))

(use-package flyspell
  ;; need hunspell on windows
  :hook
  (text-mode . flyspell-mode)
  (prog-mode . flyspell-prog-mode)
  :custom
  (flyspell-abbrev-p t)
  (flyspell-issue-welcome-flag nil)
  (flyspell-issue-message-flag nil)
  :config
  ;; Makes flyspell-prog-mode work with comments, but not strings.
  (setq flyspell-prog-text-faces
        (delq 'font-lock-string-face
              flyspell-prog-text-faces))
  (advice-add 'flyspell-prog-mode :around #'suppress-messages)
  (advice-add 'flyspell-mode :around #'suppress-messages))

(use-package flyspell-correct
  :after flyspell
  :straight t
  :custom
  (flyspell-correct--cr-key "`")
  :bind
  (:map flyspell-mode-map
        ("C-;" . flyspell-correct-wrapper)))

(use-package saveplace
  :hook
  (text-mode . save-place-mode)
  (prog-mode . save-place-mode))

(use-package simple
  :init
  (global-unset-key (kbd "C-x C-z"))
  (global-unset-key (kbd "C-x C-c"))
  :custom
  (save-interprogram-paste-before-kill t)
  :hook
  (before-save . delete-trailing-whitespace))

(use-package winner
  :config
  (winner-mode 1))

(use-package comint
  :custom
  (scroll-down-aggressively 1)
  (comint-scroll-to-bottom-on-input t)
  (comint-scroll-to-bottom-on-output t)
  (comint-move-point-for-output t)
  :hook
  (comint-mode . evil-insert-state)
  :config
  (general-define-key
   :states 'insert
   :keymaps 'comint-mode-map
   "C-k" 'comint-previous-input
   "C-j" 'comint-next-input))

(use-package recentf
  :custom
  (recentf-max-saved-items 250)
  :config
  (run-at-time nil (* 15 60) 'recentf-save-list) ; save files every 15 minutes
  (add-to-list 'recentf-exclude no-littering-var-directory)
  (add-to-list 'recentf-exclude no-littering-etc-directory)
  (advice-add 'recentf-cleanup :around #'no-msg)
  (advice-add 'recentf-mode :around #'no-msg)
  (advice-add 'recentf-save-list :around #'no-msg)
  (recentf-mode 1))

(use-package elec-pair
  :config
  (electric-pair-mode))

(use-package bibtex
  :hook
  (bibtex-mode . flyspell-mode)
  (bibtex-mode . turn-on-smartparens-mode))

(use-package slime-autoloads
  :disabled t
  :load-path "straight/build/slime/")

(use-package slime
  :disabled t
  :straight t
  :defer t
  :blackout (lisp-mode . "λ")
  :blackout (slime-repl-mode . "Λ")
  :blackout (slime-mrepl-mode . "Λ")

  :init
  (setq inferior-lisp-program "sbcl")

  :config

  ;; Emulate ESS eval in Slime
  (defun slime-eval-buffer-from-beg-to-here ()
    "Send region from beginning to point to the inferior SLIME process.
VIS has same meaning as for `slime-eval-region'."
    (interactive)
    (slime-eval-region (point-min) (point)))

  (defun slime-eval-buffer-from-here-to-end ()
    "Send region from point to end of buffer to the inferior SLIME process.
VIS has same meaning as for `slime-eval-region'."
    (interactive)
    (slime-eval-region (point) (point-max)))

  ;; connect to SLIME automatically
  (add-hook 'slime-mode-hook
            (lambda ()
              (unless (slime-connected-p)
                (save-excursion (slime)))))


  (general-define-key
   :states 'visual
   :keymaps 'slime-mode-map
   :prefix ","
   "," 'slime-eval-region)

  (general-define-key
   :states 'visual
   :keymaps '(slime-mode-map)
   "C-<return>" 'slime-eval-region)

  (general-define-key
   :states 'normal
   :keymaps '(slime-mode-map)
   :prefix ","
   "1" 'slime-eval-buffer-from-beg-to-here
   "0" 'slime-eval-buffer-from-here-to-end
   "b" 'slime-eval-buffer
   "f" 'slime-eval-defun
   "," 'slime-eval-last-expression
   "." 'slime-pprint-eval-last-expression
   "h" 'slime-hyperspec-lookup)

  (general-define-key
   :states 'normal
   :keymaps '(slime-mode-map)
   "C-<return>" 'slime-eval-defun
   "C-S-<return>" 'slime-eval-last-expression))

(use-package sly
  ;; Sly seems to be buggy compared to Slime.
  ;; :disabled t
  :straight t
  :defer t
  :blackout (lisp-mode . "λ")
  :blackout (sly-mrepl-mode . "Λ")
  :custom

  (inferior-lisp-program "sbcl")
  (sly-auto-connect t) ;; Does not work??
  ;; I just take the following from portacle
  (sly-auto-select-connection 'always)
  (sly-kill-without-query-p t)
  (sly-description-autofocus nil)
  ;; (sly-inhibit-pipelining nil) ;; not like R behavior...
  (sly-load-failed-fasl 'always)

  :config

  ;;; swap parens and brackets, at least in lisp modes
  ;; (keyboard-translate ?\( ?\[)
  ;; (keyboard-translate ?\[ ?\()
  ;; (keyboard-translate ?\) ?\])
  ;; (keyboard-translate ?\] ?\))

  ;; Emulate ESS eval in Sly
  (defun sly-eval-buffer-from-beg-to-here ()
    "Send region from beginning to point to the inferior SLY process.
VIS has same meaning as for `sly-eval-region'."
    (interactive)
    (sly-eval-region (point-min) (point)))

  (defun sly-eval-buffer-from-here-to-end ()
    "Send region from point to end of buffer to the inferior SLY process.
VIS has same meaning as for `sly-eval-region'."
    (interactive)
    (sly-eval-region (point) (point-max)))

  ;; connect to SLY automatically
  (add-hook 'sly-mode-hook
            (lambda ()
              (unless (sly-connected-p)
                (save-excursion (sly)))))

  (when (eq system-type 'windows-nt)
    (setq sly-lisp-implementations
          '((sbcl ("c:/Users/jhaman/Desktop/portacle/win/bin/sbcl.exe")))))

  (general-define-key
   :states 'visual
   :keymaps 'sly-mode-map
   :prefix ","
   "," 'sly-eval-region)

  (general-define-key
   :states 'visual
   :keymaps '(sly-mode-map)
   "C-<return>" 'sly-eval-region)

  (general-define-key
   :states 'normal
   :keymaps '(sly-mode-map)
   :prefix ","
   "1" 'sly-eval-buffer-from-beg-to-here
   "0" 'sly-eval-buffer-from-here-to-end
   "b" 'sly-eval-buffer
   "f" 'sly-eval-defun
   "," 'sly-eval-last-expression
   "." 'sly-pprint-eval-last-expression
   "h" 'sly-hyperspec-lookup)

  (general-define-key
   :states 'normal
   :keymaps '(sly-mode-map)
   "C-<return>" 'sly-eval-defun
   "C-S-<return>" 'sly-eval-last-expression))

(use-package julia-mode
  :defer t
  :mode ("\\.jl\\'" . julia-mode)
  :hook
  (julia-mode . (lambda () (set-input-method "TeX")))
  (julia-repl-mode . (lambda () (set-input-method "TeX")))
  :straight t)

(use-package julia-repl
  :defer t
  :straight t
  :hook
  (julia-mode . julia-repl-mode))

(use-package ess
  :defer 5
  :straight t
  :hook
  (ess-help-mode . evil-normal-state)
  :custom
  (ess-auto-width 'window)
  (ess-eldoc-show-on-symbol t)
  (ess-gen-proc-buffer-name-function 'ess-gen-proc-buffer-name:projectile-or-directory)
  (ess-eval-visibly 'nil)
  (ess-style 'RStudio)
  ;;(ess-use-flymake nil)
  (ess-tab-complete-in-script nil)
  (ess-use-ido nil)
  (ess-history-directory (expand-file-name "ESS-history/" no-littering-var-directory))
  (ess-ask-for-ess-directory nil)
  ;;(ess-smart-S-assign-key nil)
  (ess-indent-with-fancy-comments nil))

(use-package sql-mode
  :defer t)

(use-package calc
  :defer t)

(use-package ess-r-mode
  :defer 5
  ;; :blackout (ess-r-mode . "θ")

  ;; # This is my .Rprofile
  ;;
  ;; # set the default help type
  ;; options(help_type="html")
  ;; options(max.print=10000)
  ;; options(nwarnings = 1000)
  ;; options(width=100)
  ;;
  ;; # set a CRAN mirror
  ;; local({
  ;;       r <- getOption("repos")
  ;;       r["CRAN"] <- "https://cloud.r-project.org/"
  ;;       options(repos = r)
  ;;       })


  ;; My Vimium mappings:
  ;;
  ;; # Insert your preferred key mappings here.
  ;; map d removeTab
  ;; map u restoreTab
  ;; map x goBack
  ;; map c goForward
  ;; map L nextTab
  ;; map H previousTab

  ;; Change scroll px to 120
  ;; Uncheck use smooth scrolling

  :custom
  (inferior-R-args "--no-save" "Do not save R session")
  (ess-R-font-lock-keywords
   (quote
    ((ess-R-fl-keyword:keywords . t)
     (ess-R-fl-keyword:constants . t)
     (ess-R-fl-keyword:modifiers . t)
     (ess-R-fl-keyword:fun-defs . t)
     (ess-R-fl-keyword:assign-ops . t)
     (ess-R-fl-keyword:%op% . t)
     (ess-fl-keyword:fun-calls . t)
     (ess-fl-keyword:numbers . t)
     (ess-fl-keyword:operators)
     (ess-fl-keyword:delimiters)
     (ess-fl-keyword:=)
     (ess-R-fl-keyword:F&T))))
  :config

  ;; (when (eq system-type 'windows-nt)
  ;;   (setq ess-use-eldoc nil))

  (defun my/add-pipe ()
    "Add a pipe operator %>% at the end of the current line.
Don't add one if the end of line already has one.  Ensure one
space to the left and start a newline with indentation."
    (interactive)
    (end-of-line)
    (unless (looking-back "%>%" nil)
      (just-one-space 1)
      (insert "%>%")))

  (general-define-key
   :states '(normal visual)
   :prefix ","
   :keymaps '(ess-r-mode-map inferior-ess-mode-map)
   "z" 'ess-switch-to-inferior-or-script-buffer
   "s" 'ess-switch-process
   "C" 'comint-interrupt-subjob
   "b" 'ess-eval-buffer
   "1" 'ess-eval-buffer-from-beg-to-here
   "0" 'ess-eval-buffer-from-here-to-end
   "f" 'ess-eval-function
   "h" 'ess-help
   "d" 'ess-describe-object-at-point
   "m" 'my/add-pipe
   "R" 'inferior-ess-reload
   "," 'ess-eval-region-or-function-or-paragraph-and-step
   "." 'ess-eval-region-or-function-or-paragraph
   "a" 'ess-display-help-apropos
   "i" 'ess-install-library
   "n" 'ess-eval-region-or-line-and-step))

(use-package ess-julia
  ;;:mode ("\\.jl\\'" . ess-Julian-mode)
  :disabled t
  :hook
  (ess-julia-mode . (lambda () (set-input-method "TeX")))
  (inferior-ess-julia-mode . (lambda () (set-input-method "TeX")))
  (inferior-ess-julia-mode . (lambda () (corfu-mode -1)))
  :config
  (setq inferior-julia-args "-i --color=yes")
  (general-define-key
   :states 'normal
   :keymaps 'ess-julia-mode-map
   :prefix ","
   "z" 'ess-switch-to-inferior-or-script-buffer
   "b" 'ess-eval-buffer
   "1" 'ess-eval-buffer-from-beg-to-here
   "0" 'ess-eval-buffer-from-here-to-end
   "h" 'ess-help
   "f" 'ess-eval-function-and-go
   "n" 'ess-eval-region-or-line-and-step
   "a" 'ess-display-help-apropos
   "." 'ess-eval-region-or-function-or-paragraph
   "," 'ess-eval-region-or-function-or-paragraph-and-step))

(use-package hungry-delete
  :straight t
  :config
  (global-hungry-delete-mode))

(use-package elisp-mode
  :blackout (emacs-lisp-mode . "ε")
  :blackout (lisp-interaction-mode . "ι")
  :defer 5
  :config

  (general-define-key
   :keymaps 'lisp-mode-shared-map
   :states '(normal insert)
   "C-<return>" 'eval-defun
   "C-RET" 'eval-defun)

  (general-define-key
   :keymaps 'lisp-mode-shared-map
   :prefix ","
   :states 'normal
   "b" 'eval-buffer
   "f" 'eval-defun
   "." 'eval-print-last-sexp
   "m" 'eval-defun
   "," 'eval-last-sexp))

(use-package vertico
  :straight t
  :custom
  (vertico-resize nil)
  (vertico-cycle t)
  :config
  (general-define-key
   :keymaps 'vertico-map
   "C-j" 'vertico-next
   "C-k" 'vertico-previous
   "C-l" 'vertico-insert
   "C-h" 'backward-kill-word
   "C-c C-o" 'embark-export
   "<tab>" 'vertico-next
   "<backtab>" 'vertico-previous)
  (vertico-mode 1))

(use-package vertico-mouse
  :after vertico
  :load-path "straight/build/vertico/extensions/"
  :config
  (vertico-mouse-mode))

(use-package vertico-repeat
  :after vertico
  :hook (minibuffer-setup . vertico-repeat-save)
  :load-path "straight/build/vertico/extensions/")

(use-package vertico-directory
  :after vertico
  :load-path "straight/build/vertico/extensions/"
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("C-l" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("C-h" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word)))

(use-package orderless
  :straight t
  :init
  (defun just-one-face (fn &rest args)
    (let ((orderless-match-faces [completions-common-part]))
      (apply fn args)))

  (advice-add 'company-capf--candidates :around #'just-one-face)
  (setq orderless-component-separator "[ &]")
  (setq completion-styles '(orderless basic)
        completion-category-overrides '((file (styles basic partial-completion))))

  :config
  ;; Disable the *Completions* buffer, which is meaningless with Vertico.
  (advice-add #'ffap-menu-ask :around (lambda (&rest args)
                                        (cl-letf (((symbol-function #'minibuffer-completion-help)
                                                   #'ignore))
                                          (apply args))))
  ;; Alternative 1: Use the basic completion style for org-refile
  (setq org-refile-use-outline-path 'file
        org-outline-path-complete-in-steps t)
  (advice-add #'org-olpath-completing-read :around
              (lambda (&rest args)
                (minibuffer-with-setup-hook
                    (lambda () (setq-local completion-styles '(basic)))
                  (apply args)))))

(use-package marginalia
  :straight t
  :init
  (marginalia-mode))

(use-package consult-everything
  :if (eq system-type 'windows-nt)
  :defer t
  :load-path "~/lisp/consult-everything/"
  :config
  (general-define-key
   :states 'normal
   "SPC L" 'consult-everything))

(use-package savehist
  :custom
  (history-length 10000)
  (history-delete-duplicates t)
  (savehist-save-minibuffer-history t)
  :init
  (savehist-mode))

(use-package emacs
  :config
  (defun stop-using-minibuffer ()
    "kill the minibuffer"
    (when (and (>= (recursion-depth) 1) (active-minibuffer-window))
      (abort-recursive-edit)))

  (add-hook 'mouse-leave-buffer-hook 'stop-using-minibuffer))

(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; Alternatively try `consult-completing-read-multiple'.
  (defun crm-indicator (args)
    (cons (concat "[CRM] " (car args)) (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Enable recursive minibuffers
  ;; disable for me...
  (setq enable-recursive-minibuffers nil))

(use-package embark
  :defer t
  :straight t
  :after vertico
  :custom
  (embark-collect-initial-view-alist '((t . list))) ;; what's this do??
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-," . embark-act)
   ("C-RET" . embark-act)
   ("C-c C-o" . embark-collect) ;; only use this in minibuffer
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'
  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :straight t
  :after embark
  :demand t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package so-long
  :config
  (global-so-long-mode 1))

(use-package company
  ;; Works better with ESS on Windows.
  :if (eq system-type 'windows-nt)
  :straight t
  :custom
  (company-minimum-prefix-length 2)
  (company-require-match 'never)
  (company-async-timeout 15)
  (company-tooltip-align-annotations t)
  (company-selection-wrap-around t)
  (company-tooltip-limit 6)
  (company-idle-delay 0.05)
  (company-echo-delay 0.05)
  (company-dabbrev-ignore-case nil)
  (company-dabbrev-downcase nil)
  :config
  (global-company-mode 1)
  (company-tng-mode 1))

(use-package company-box
  ;; appears to have a bad interaction with Sly
  ;; https://github.com/joaotavora/sly/issues/478
  :straight t
  :after company
  :custom
  (company-box-doc-enable nil)
  (company-box-scrollbar nil)
  (company-box-enable-icon nil)
  :hook
  (company-mode . company-box-mode))

(use-package prescient
  :straight t)

(use-package company-prescient
  :straight t
  :after company
  :config
  (company-prescient-mode 1)
  (prescient-persist-mode 1))

(use-package corfu
  ;; does not work w/ ESS on windows
  :if (eq system-type 'gnu/linux)
  :straight (corfu :host github :repo "minad/corfu")
  :custom
  (corfu-cycle t)
  (corfu-count 5)
  (corfu-preselect-first nil) ; Recommended for tng style
  (corfu-auto t)
  (corfu-auto-delay 0.0) ; Could be too fast
  (corfu-quit-at-boundary t) ; Easier to use, but disables Orderless
  (corfu-quit-no-match t)
  (corfu-auto-prefix 2)

  :init
  (global-corfu-mode)

  :config
  ;; Pop open corfu completions in the minibuffer.
  (defun corfu-move-to-minibuffer ()
    (interactive)
    (let (completion-cycle-threshold completion-cycling)
      (apply #'consult-completion-in-region completion-in-region--data)))

  (define-key corfu-map (kbd "C-k") nil)
  (define-key corfu-map (kbd "RET") nil)
  (define-key corfu-map (kbd "<return>") nil)

  (general-define-key
   :keymaps 'corfu-map
   "<tab>" 'corfu-next
   "RET" 'evil-ret
   "<return>" 'evil-ret
   "C-j" 'corfu-next
   "C-k" 'corfu-previous
   "<backtab>" 'corfu-previous
   "C-m" 'corfu-move-to-minibuffer))

(use-package cape
  :after corfu
  :straight (cape :host github :repo "minad/cape")
  :custom
  (cape-dabbrev-min-length 3)
  :init
  ;; Add `completion-at-point-functions', used by `completion-at-point'.
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-history)
  ;;(add-to-list 'completion-at-point-functions #'cape-keyword)
  (add-to-list 'completion-at-point-functions #'cape-tex)
  ;;(add-to-list 'completion-at-point-functions #'cape-sgml)
  ;;(add-to-list 'completion-at-point-functions #'cape-rfc1345)
  ;;(add-to-list 'completion-at-point-functions #'cape-abbrev)
  (add-to-list 'completion-at-point-functions #'cape-ispell)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  ;; (add-to-list 'completion-at-point-functions #'cape-dict)
  ;; (add-to-list 'completion-at-point-functions #'cape-symbol)
  ;;(add-to-list 'completion-at-point-functions #'cape-line)
  )

(use-package popper
  ;; I think this should be on at startup
  :straight t
  :init
  (setq popper-mode-line-position 0)
  (setq popper-display-control nil)
  (setq popper-reference-buffers
        '(sly-mrepl-mode
          slime-repl-mode
          slime-mrepl-mode
          inferior-ess-mode
          "\\*sly-description\\*"
          inferior-ess-r-mode
          inferior-python-mode
          help-mode))
  (popper-mode 1))

(use-package emacs
  :init
  (setq completion-cycle-threshold 2)
  (setq tab-always-indent 'complete))

(use-package consult
  ;; install find and rg on windows.
  :straight t
  ;; :hook
  ;; (completion-list-mode . consult-preview-at-point-mode)

  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Optionally replace `completing-read-multiple' with an enhanced version.
  (advice-add #'completing-read-multiple :override #'consult-completing-read-multiple)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  :custom
  (consult-line-start-from-top t)
  ;;(consult-preview-key nil)
  (consult-line-numbers-widen t)
  (consult-async-min-input 3)
  (consult-async-input-debounce 0.5)
  (consult-async-input-throttle 0.8)
  (consult-narrow-key ">")

  :config

  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   ;; Add a command to this list to delay automatic preview
   consult-theme
   :preview-key '(:debounce 0.2 any)
   ;; Add a command to this list to disable automatic preview
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-recent-file
   consult--source-project-recent-file
   consult-buffer
   :preview-key (kbd "M-."))

  (defun test-consult-find ()
    (interactive)
    (let ((w32-quote-process-args ?\\)
          (consult-find-args "C:\\msys64\\usr\\bin\\find.exe . -not ( -wholename */.* -prune )"))
      (call-interactively 'consult-find)))

  (defun jth-consult-find ()
    (interactive)
    (if (eq system-type 'windows-nt)
        (test-consult-find)
      (consult-find))))

(use-package restart-emacs
  :defer t
  :straight t)

(use-package writegood-mode
  :straight t
  :defer t)

(use-package eldoc
  :custom
  (eldoc-idle-delay 0.1)
  (eldoc-echo-area-use-multiline-p nil))

(use-package python
  ;; need to install (py)readline on windows
  ;; test:
  ;; >>> import readline, rlcompleter
  :defer t
  :blackout (python-mode . "π")
  :custom
  (python-indent-guess-indent-offset-verbose nil)
  (python-indent-offset 4)
  (python-eldoc-function-timeout-permanent nil)
  (python-shell-interpreter-args "-i")
  :config
  (when (eq system-type 'windows-nt)
    (setq python-shell-interpreter "python"))
  (when (eq system-type 'gnu/linux)
    (setq python-shell-interpreter "python3"))
  (when (executable-find "ipython")
    (setq python-shell-interpreter "ipython")
    (setq python-shell-interpreter-args "-i --simple-prompt"))

  (general-define-key
   :states '(normal visual)
   :keymaps 'python-mode-map
   "<C-return>" 'python-shell-send-line-and-step)

  (general-define-key
   :prefix ","
   :states '(normal visual)
   :keymaps 'python-mode-map
   "n" 'python-shell-send-buffer
   "." 'python-shell-send-line-and-step
   ">" 'python-shell-send-line
   "f" 'python-shell-send-defun
   "," 'python-shell-send-paragraph-and-step
   "<" 'python-shell-send-dwim
   "r" 'python-shell-restart-process
   "p" 'python-shell-print-region-or-symbol
   "z" 'python-shell-switch-to-shell-or-buffer
   "h" 'eldoc ;; use eglot for documentation
   ))

(use-package python-x
  :defer t
  :straight t
  :after python
  :custom
  (python-section-delimiter "##")
  :config
  (python-x-setup))

(use-package org
  :straight t
  :defer 5
  :blackout (org-mode . "ω")

  :hook
  (org-mode . visual-line-mode)
  (org-mode . prettify-symbols-mode)
  (org-mode . flyspell-mode)
  (org-mode . variable-pitch-mode)
  (org-mode . olivetti-mode)

  :custom
  (org-M-RET-may-split-line nil)
  (org-fontify-quote-and-verse-blocks t)
  (org-confirm-babel-evaluate nil)
  (org-pretty-entities t)
  (org-hide-emphasis-markers t)
  (org-ellipsis "…")

  :config
  (general-define-key
   :states '(insert)
   :keymaps 'org-mode-map
   "<return>" 'org-return-and-maybe-indent))

(use-package org-agenda
  :after org
  :blackout (org-agenda-mode . "Ω")
  :custom
  (org-agenda-span 'day)
  (org-agenda-window-setup 'current-window))

(use-package org-capture
  :after org
  :hook
  (org-capture-mode . evil-insert-state)
  (org-capture-mode . delete-other-windows)
  :custom
  ;; Cannot use no-littering-etc-directory directory in my capture setup?
  (org-capture-templates
   '(("r" "Research Idea" entry
      (file "~/.emacs.d/etc/org/research_ideas.org")
      "* %T %^{Title of Research Idea}\n%?")

     ("e" "Email" entry
      (file "~/Documents/org/email.org")
      "* %?" :empty-lines 1)

     ("E" "Emacs Package Idea" entry
      (file "~/Documents/org/emacs.org")
      "* %?" :empty-lines 1)

     ("p" "Personal Todo" entry
      (file+headline "~/.emacs.d/etc/org/personal_todo.org" "Tasks")
      "* TODO %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n"))))

(use-package org-indent
  :after org
  :hook
  (org-mode . org-indent-mode))

(use-package evil-org
  :straight t
  :after org
  :config
  (evil-org-set-key-theme)
  (use-package evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package evil-surround
  :straight t
  :after evil
  :config
  (global-evil-surround-mode 1))

(use-package ace-window
  :defer t
  :straight t
  :custom
  (aw-scope 'frame)
  (aw-keys '(?a ?s ?d ?f)))

(use-package avy
  :defer t
  :straight t
  :custom
  (avy-all-windows nil)
  (avy-timeout-seconds 0.5))

(use-package transient
  :defer t
  :config
  (general-define-key
   :keymaps 'transient-base-map
   "<escape>" 'transient-quit-one))

(use-package magit
  :defer 10
  :blackout (magit-status-mode . "μ")
  :straight t
  :custom
  (magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1)
  :hook
  (with-editor-mode . evil-insert-state))

(use-package forge
  :straight t
  :after magit)

(use-package git-identity
  :straight t
  :after magit
  :config
  (git-identity-magit-mode 1)
  ;; Bind I to git-identity-info in magit-status
  (define-key magit-status-mode-map (kbd "I") 'git-identity-info)
  :custom
  (git-identity-verify t))

(use-package git-timemachine
  :defer t
  :straight t
  :config
  (general-define-key
   :states 'normal
   :prefix ","
   :keymaps 'git-timemachine-mode-map
   "h" 'git-timemachine-show-previous-revision
   "l" 'git-timemachine-show-next-revision))

(use-package expand-region
  :straight t
  :commands expand-region
  :config
  (general-define-key
   :states 'visual
   ";" 'er/expand-region
   ":" 'er/contract-region))

(use-package stan-mode
  :defer t
  :blackout (stan-mode . "σ")
  :straight t)

(use-package company-stan
  ;; Do I need this?
  :defer t
  :straight t
  :after stan-mode
  :hook (stan-mode . company-stan-setup))

(use-package eglot
  :straight t
  :defer t

  :custom
  (eglot-ignored-server-capabilites '(:documentHighlightProvider))
  (eglot-autoshutdown t)

  :hook
  (python-mode . eglot-ensure)

  :config
  ;; no flymake.
  (add-hook 'eglot--managed-mode-hook (lambda () (flymake-mode -1)))
  (defvar ddavis-default-pyls "~/.local/bin/pyls"
    "define a default pyls to be used")
  (add-to-list 'eglot-server-programs
               `(python-mode ,ddavis-default-pyls)))

(use-package eldoc-stan
  :straight t
  :after stan-mode
  :hook (stan-mode . eldoc-stan-setup))

(use-package markdown-mode
  :straight t
  :blackout (markdown-mode . "ϻ")
  :custom
  (markdown-enable-math t)
  (markdown-hide-urls t)
  :mode
  ("\\.md\\'" . markdown-mode)
  :hook
  (markdown-mode . flyspell-mode)
  (LaTeX-mode . writegood-mode)
  (markdown-mode . visual-line-mode)
  (markdown-mode . olivetti-mode)
  :config

  (defun insert-eqn ()
    (interactive)
    (insert "$$\n\n$$")
    (goto-char (+ pos 2)))

  (defun insert-new-chunk (arg)
    "Insert R chunk delimiters for Rmd buffers"
    (interactive "*P")
    ;; no region, and blank line
    (if (and (not (region-active-p))
             (looking-at "[ \t]*$"))
        (let ((pos (point)))
          (save-excursion
            (insert "```{r}\n\n```")
            (goto-char (+ pos 3))))) ; does NOT move forward.  Why?
    ;; region active
    (if (region-active-p)
        (let ((beg (region-beginning))
              (end (region-end))
              (pos (point)))
          (save-excursion
            (goto-char end)
            (forward-line) ; region-end seems to be at start of previous line ???
            (insert "```\n")
            (goto-char beg)
            (insert "```{r}\n")))))

  (defun ess-insert-inverse-rmd-chunk (arg)
    "Insert inverse R chunk delimiters for Rmd buffers"
    (interactive "*P")
    (insert "```\n\n```{r}")
    (goto-char (- pos 3)))

  (defun insert-yaml ()
    "Insert yaml header for .Rmd files"
    (interactive)
    (insert
     "---
author: John Haman
title:
date: \"`r format(Sys.time(), '%d %B, %Y')`\"
output:
  html_document:
    toc: true
    toc_depth: 2
    number_sections: true
    toc_float:
      collapsed: false
      smooth_scroll: false
    code_folding: show
    fig_width: 12
    fig_height: 8
    fig_caption: true
    df_print: paged
---
    "))

  (defun jth/insert-image ()
    (interactive)
    (insert "![](/post/pics/ \"AuthorCredit\")"))

  (general-define-key
   :states 'normal
   :keymaps 'markdown-mode-map
   "<tab>" 'markdown-cycle))

(use-package polymode
  :defer t
  :straight t
  :config
  (general-define-key
   :states '(normal visual)
   :prefix ","
   :keymaps '(poly-markdown+r-mode-map)
   "z" 'ess-switch-to-inferior-or-script-buffer
   "s" 'ess-switch-process
   "C" 'comint-interrupt-subjob
   "j" 'polymode-next-chunk-same-type
   "k" 'polymode-previous-chunk-same-type
   "i" 'insert-new-chunk
   "u" 'ess-insert-inverse-rmd-chunk
   "I" 'jth/insert-image
   "c" 'polymode-mark-or-extend-chunk
   "o" 'insert-yaml
   "p" 'insert-eqn
   "d" 'polymode-kill-chunk
   "." 'ess-eval-region-or-line-visibly-and-step
   "m" 'my/add-pipe
   "e" 'polymode-export
   "E" 'polymode-set-exporter
   "w" 'polymode-weave
   "W" 'polymode-set-weaver
   "$" 'polymode-show-process-buffer
   "n" 'polymode-eval-region-or-chunk
   "," 'ess-eval-region-or-function-or-paragraph-and-step
   "N" 'polymode-eval-buffer
   "1" 'polymode-eval-buffer-from-beg-to-point
   "0" 'polymode-eval-buffer-from-point-to-end))

(use-package poly-markdown
  :after polymode
  :straight t)

(use-package poly-R
  :after polymode-markdown
  :straight t)

(use-package auctex
  :defer 5
  :straight t

  :hook
  (LaTeX-mode . visual-line-mode) ;; Do we need this _and_ Olivetti?
  (LaTeX-mode . variable-pitch-mode)
  (LaTeX-mode . writegood-mode)
  (LaTeX-mode . pandoc-mode)
  (LaTeX-mode . flyspell-mode)
  (LaTeX-mode . olivetti-mode)
  (LaTeX-mode . reftex-mode)
  (LaTeX-mode . prettify-symbols-mode)
  (LaTeX-mode . TeX-PDF-mode)

  :custom
  (TeX-engine 'xetex) ;; Do this for IDA memo class. Could be LuaTeX instead.
  (TeX-electric-math (cons "$" "$"))
  (TeX-save-query nil)
  (LaTeX-electric-left-right-brace t)
  (TeX-master nil) ;; ?
  (TeX-auto-save t)
  (TeX-parse-self t)

  :init
  ;; bug? These don't work in :config
  (defun jth-insert-bold ()
    (interactive)
    (just-one-space)
    (TeX-font nil 2))
  (defun jth-insert-italics ()
    (interactive)
    (just-one-space)
    (TeX-font nil 9))
  (defun jth-insert-tt ()
    (interactive)
    (just-one-space)
    (TeX-font nil 20))

  (general-define-key
   :prefix ","
   :states 'normal
   :keymaps 'LaTeX-mode-map
   "b" 'jth-insert-bold
   "t" 'jth-insert-tt
   "i" 'jth-insert-italics
   "r" 'TeX-normal-mode ;; reset buffer
   "=" 'reftex-toc
   "," 'TeX-command-run-all
   "j" 'LaTeX-insert-item
   "e" 'LaTeX-environment
   "m" 'TeX-insert-macro
   "s" 'LaTeX-section
   "n" 'TeX-next-error))

(use-package cdlatex
  :after auctex
  :straight (cdlatex :host github :repo "cdominik/cdlatex")
  :hook
  (LaTeX-mode . cdlatex-mode))

(use-package reftex
  :defer t)

(use-package ahk-mode
  :defer t
  :straight t)

(use-package electric-operator
  :after ess
  :straight t
  :hook
  ((ess-mode python-mode stan-mode julia-mode) . electric-operator-mode)
  :custom
  (electric-operator-R-named-argument-style 'spaced)
  :config
  (electric-operator-add-rules-for-mode 'python-mode
                                        (cons ":=" " := ")
                                        (cons "," ", ")
                                        (cons "=" " = "))
  (electric-operator-add-rules-for-mode 'stan-mode
                                        (cons "," ", ")
                                        (cons "~" " ~ "))
  (electric-operator-add-rules-for-mode 'julia-mode
                                        (cons "=>" " => "))
  (electric-operator-add-rules-for-mode 'ess-r-mode
                                        (cons ".+" " . + ")
                                        (cons "? " "?")
                                        (cons "){" ") {")
                                        (cons "}else{" "} else {")
                                        (cons "for(" "for (")
                                        (cons "if(" "if (")
                                        (cons "runif ()" "runif()")
                                        (cons "while(" "while (")
                                        (cons "::" "::")
                                        (cons "|>" " |> ")
                                        (cons "<<-" "<<-")
                                        (cons ":=" " := ")))

(use-package csv-mode
  :defer t
  :straight t)

(use-package aggressive-indent
  :straight t
  :custom
  (aggressive-indent-mode-map (make-sparse-keymap))
  :config
  (global-aggressive-indent-mode))

(use-package sudo-edit
  :defer t
  :straight t)

(use-package google-this
  :defer t
  :straight t)

(use-package wgrep
  :defer t
  :straight t)

(use-package olivetti
  :defer t
  :straight t
  :custom
  (olivetti-body-width 80))

(use-package langtool
  :defer t
  :straight t)

(use-package unfill
  :defer t
  :straight t)

(use-package edit-indirect
  :defer t
  :straight t)

(use-package org-download
  :defer t
  :straight t
  :hook
  (dired-mode . org-download-enable))

(use-package pandoc-mode
  :defer t
  :straight t
  :hook
  (pandoc-mode . pandoc-load-default-settings))

(use-package rainbow-mode
  :defer t
  :straight t)

(use-package pdf-tools
  :defer t
  :straight t
  :config
  (pdf-loader-install))

(use-package centered-cursor-mode
  :straight t
  :hook
  (elfeed-show-mode . centered-cursor-mode)
  (eww-mode . centered-cursor-mode))

;; John's misc. custom functions
(defun jth/save-all ()
  "Save all unsaved buffers, and don't ask permission"
  (interactive)
  (save-some-buffers t))

(defun jth/go-down ()
  "Scroll Down 10 lines"
  (interactive)
  (evil-scroll-down 10))

(defun jth/go-up ()
  "Scroll up 10 lines"
  (interactive)
  (evil-scroll-up 10))

(defun jth/bookmark-set-and-save ()
  "Create a new bookmark and save the bookmark file in one go"
  (interactive)
  (bookmark-set)
  (bookmark-save))

(use-package bookmark
  :custom
  (bookmark-set-fringe-mark nil))

(defun frame-pop ()
  "Promote current window to its own frame"
  (interactive)
  (let ((buffer (current-buffer)))
    (unless (one-window-p)
      (delete-window))
    (display-buffer-pop-up-frame buffer nil)))

(defun split-and-follow-horizontally ()
  "Create new split and move point to the new window"
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1)
  (switch-to-buffer "*scratch*"))

(defun split-and-follow-vertically ()
  "Create new split and move point to the new window"
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1)
  (switch-to-buffer "*scratch*"))

(defun window-split-toggle ()
  "Convert a horizontal split to a vertical split, or a vertical
split to a horizontal split"
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))

(defun jth/goto-scratch ()
  "Open the scratch buffer"
  (interactive)
  (switch-to-buffer "*scratch*"))


;; Suppress the new frame message
(add-hook 'server-after-make-frame-hook
          (lambda ()
            (setq inhibit-message t)
            (run-with-idle-timer 0 nil (lambda () (setq inhibit-message nil)))))

;; Couple functions for structural editing
(defvar jth-left-brackets '("(" "{" "[") "List of left bracket chars.")
(defvar jth-right-brackets '(")" "]" "}") "list of right bracket chars.")

(use-package emms
  :defer t
  :straight t)

(use-package elfeed
  :straight t
  :defer t
  :if (eq system-type 'gnu/linux)
  :hook
  (elfeed-show-mode . olivetti-mode)
  :custom
  (shr-max-image-proportion 0.35)

  :config

  (defun elfeed-search-format-date (date)
    (format-time-string "%Y-%m-%d %H:%M" (seconds-to-time date)))
  ;; star articles
  ;; From http://pragmaticemacs.com/emacs/star-and-unstar-articles-in-elfeed/
  (defalias 'elfeed-toggle-star
    (elfeed-expose #'elfeed-search-toggle-all 'star))

  (eval-after-load 'elfeed-search
    '(define-key elfeed-search-mode-map (kbd "m") 'elfeed-toggle-star))

  ;; face for starred articles
  (defface elfeed-search-star-title-face
    '((t :foreground "#f77"))
    "Marks a starred Elfeed entry.")

  (push '(star elfeed-search-star-title-face) elfeed-search-face-alist)

  ;; keybindings
  (general-define-key
   :keymaps 'elfeed-show-mode-map
   :states 'normal
   "l" 'elfeed-show-next
   "h" 'elfeed-show-prev)

  ;; star articles
  (defalias 'elfeed-toggle-star
    (elfeed-expose #'elfeed-search-toggle-all 'star)))

(use-package elfeed-org
  ;; Bug: this installs the whole upstream org, doesn't use the one packaged with emacs.
  :after elfeed
  :straight t
  :defer t)

(use-package simple
  :custom
  (mail-user-agent 'mu4e-useragent))

(use-package message
  :defer t
  :custom
  (message-send-mail-function 'smtpmail-send-it)
  (message-kill-buffer-on-exit t))

(use-package sendmail
  :defer t
  :custom
  (send-mail-function 'smtpmail-send-it))

(use-package mu4e
  :defer 10
  :if (string-equal system-type "gnu/linux")
  :load-path "/usr/share/emacs/site-lisp/mu4e/"
  :custom
  (mu4e-attachment-dir "~/Downloads")
  (mu4e-maildir "~/Maildir")
  (mu4e-sent-folder "/Sent")
  (mu4e-drafts-folder "/Drafts")
  (mu4e-trash-folder "/Trash")
  (mu4e-confirm-quit nil)
  (mu4e-compose-dont-reply-to-self t)
  (mu4e-update-interval 300)
  (mu4e-compose-format-flowed t)
  (mu4e-headers-date-format "%Y-%m-%d %H:%M")
  (mu4e-view-show-addresses t)
  (mu4e-compose-signature-auto-include nil)
  (mu4e-view-show-images t)
  (mu4e-completing-read-function 'completing-read)
  (mu4e-get-mail-command "mbsync -V fastmail"))

(use-package smtpmail
  :after mu4e
  :if (string-equal system-type "gnu/linux")
  :custom
  ;;(smtpmail-stream-type 'starttls)
  (smtpmail-smtp-service 587))


(defun dcaps-to-scaps ()
  "Convert word in DOuble CApitals to Single Capitals."
  (interactive)
  (and (= ?w (char-syntax (char-before)))
       (save-excursion
         (let ((end (point)))
           (and (if (called-interactively-p)
                    (skip-syntax-backward "w")
                  (= -3 (skip-syntax-backward "w")))
                (let (case-fold-search)
                  (looking-at "\\b[[:upper:]]\\{2\\}[[:lower:]]"))
                (capitalize-region (point) end))))))

(add-hook 'post-self-insert-hook #'dcaps-to-scaps nil 'local)

(define-minor-mode dubcaps-mode
  "Toggle `dubcaps-mode'.  Converts words in DOuble CApitals to
Single Capitals as you type."
  :init-value nil
  :lighter (" DC")
  (if dubcaps-mode
      (add-hook 'post-self-insert-hook #'dcaps-to-scaps nil 'local)
    (remove-hook 'post-self-insert-hook #'dcaps-to-scaps 'local)))

;; (use-package browse-url
;;   :defer t
;;   :custom
;;   (browse-url-browser-function 'eww-browse-url))

(use-package emacs
  :hook
  (text-mode . dubcaps-mode))

;; Seems to work okay-ish
(defun emacs-devel ()
  "Read the Emacs-devel mailing list."
  (interactive)
  (setq last-command-event 121)
  (gnus nil)
  (setq last-command-event 121)
  (execute-extended-command nil "gnus" "gnus")
  (setq last-command-event 13)
  (gnus-group-browse-foreign-server
   `(nntp "news.gmane.io"))
  (setq last-command-event 13)
  (consult-line)
  (setq last-command-event 13)
  (gnus-browse-select-group nil))

(defun jth-backward-left-bracket ()
  (interactive)
  (re-search-backward (regexp-opt jth-left-brackets) nil t))

(defun jth-forward-right-bracket ()
  (interactive)
  (re-search-forward (regexp-opt jth-right-brackets) nil t))

(defun date (arg)
  (interactive "P")
  (insert (if arg
              (format-time-string "%d.%m.%Y")
            (format-time-string "%Y-%m-%d"))))

(defun timestamp ()
  (interactive)
  (insert (format-time-string "%Y-%m-%dT%H:%M:%S")))

(use-package keyfreq
  :straight t
  :config
  (keyfreq-mode 1)
  (keyfreq-autosave-mode 1))

(org-agenda-list)


;; Tell me if we have native-comp
(if (and (fboundp 'native-comp-available-p)
         (native-comp-available-p))
    (message "Native compilation is available")
  (message "Native compilation is *not* available"))

;; Startup time
(message (concat "Emacs has been successfully configured in "
                 (emacs-init-time)
                 " with "
                 (format "%d" gcs-done)
                 " garbage collection(s)."))

;; Reset garbage collection threshold
(run-with-idle-timer 5 nil
                     (lambda ()
                       (setq gc-cons-threshold 16777216
                             gc-cons-percentage 0.1)
                       (setq file-name-handler-alist doom--file-name-handler-alist)))
