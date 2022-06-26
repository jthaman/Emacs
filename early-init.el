;; John Haman's Emacs configuration  -*- lexical-binding: t; -*-

;; Temporarily raise the gc threshold
(defvar doom--file-name-handler-alist file-name-handler-alist)
(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6
      file-name-handler-alist nil)

;; Misc Doom optimizations
(setq load-prefer-newer noninteractive)

;; ensure compatibility with straight
(setq package-enable-at-startup nil)

;; UI
(when (fboundp 'menu-bar-mode)
  (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;; Do not resize the frame
(setq frame-inhibit-implied-resize t)

;; Set fonts
(cond
 ;; Set Windows fonts
 ((string-equal (system-name) "Win")
  (add-to-list 'default-frame-alist '(font . "Consolas-14"))
  (set-face-attribute 'fixed-pitch nil
                      :family "Consolas"
                      :height 130)
  (set-face-attribute 'variable-pitch nil
                      :family "Calibri"
                      :height 150))

 ;; Debian laptop fonts
 ((string-equal (system-name) "debian")
  (add-to-list 'default-frame-alist '(font . "Fira Code-13"))
  (set-face-attribute 'fixed-pitch nil
                      :family "Fira Code"
                      :height 130))

 ;; Otherwise
 (t
  nil))
