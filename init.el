;;; init.el --- Emacs configurations -*- coding: utf-8; lexical-binding: t -*-

;; Copyright (C) 2026 Mihails <mihails.dn@gmail.com>

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:

(setq user-full-name "Mihails <mihails.dn@gmail.com>")

(add-to-list 'default-frame-alist '(height . 33))
(add-to-list 'default-frame-alist '(width . 110))
;;(add-to-list 'default-frame-alist '(alpha-background . 98))

(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

(set-face-attribute 'default nil :family "IBM Plex Mono" :height 140 :weight 'regular)
(set-face-attribute 'fixed-pitch nil :family "IBM Plex Mono" :height 140 :weight 'regular)
(set-face-attribute 'variable-pitch nil :family "IBM Plex Mono" :height 140 :weight 'regular)

;; Minimal UI
(tool-bar-mode 0)
(menu-bar-mode 0)
(set-scroll-bar-mode nil)

(setq frame-title-format "%f"
      inhibit-splash-screen t ;; disable startup screen
      scroll-conservatively 101
      scroll-margin 0
      use-short-answers t ;; enable y/n
      make-backup-files nil)

(setq gc-cons-threshold 50000000 ;; 50mb
      read-process-output-max (* 1024 1024)) ;; 1mb

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(global-display-line-numbers-mode t)
(column-number-mode t)
(electric-pair-mode t)
(show-paren-mode t)
(cua-mode t) ;; Copy and Paste - Ctrl+C, Ctrl+V

;; Automatically remove trailing whitespace when file is saved
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(keymap-global-set "<f2>" 'bs-show)
(keymap-global-set "<f3>" 'kill-buffer)
(keymap-global-set "<f5>" 'save-buffer)

(keymap-global-set "<f6>" 'shell-command)
(keymap-global-set "<f7>" 'undo)
(keymap-global-set "<f8>" 'flyspell-prog-mode)

(keymap-global-set "C-b" 'bookmark-set)
(keymap-global-set "M-b" 'bookmark-jump)
(keymap-global-set "<f4>" 'bookmark-bmenu-list)

(setq major-mode-remap-alist
      '((c-mode . c-ts-mode)
        (c++-mode . c++-ts-mode)
        (json-mode . json-ts-mode)))

(add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))
(add-to-list 'auto-mode-alist '("CMakeLists\\.txt\\'" . cmake-ts-mode))

;; M-x treesit-install-language-grammar
(setq treesit-language-source-alist
      '((c "https://github.com/tree-sitter/tree-sitter-c")
        (go "https://github.com/tree-sitter/tree-sitter-go")
        (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
        (json "https://github.com/tree-sitter/tree-sitter-json")
        (cmake "https://github.com/uyha/tree-sitter-cmake")))

;; Melpa
(require 'package)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;; Settings for use-package
(require 'use-package)
(setq use-package-always-ensure t)

;; Color themes
(use-package tokyo-night
  :vc (:url "https://github.com/bbatsov/tokyo-night-emacs" :rev :newest)
  :config
  (setq tokyo-night-scale-headings nil)
  (load-theme 'tokyo-night t))

;; A Library for Nerd Font icons
;; M-x nerd-icons-install-fonts
(use-package nerd-icons
  :pin melpa)

;; A fancy and fast mode-line inspired by minimalism design
(use-package doom-modeline
  :pin melpa
  :init (doom-modeline-mode 1))

;; Operations on the current project
(use-package project
  :pin gnu
  :bind (("C-c k" . project-kill-buffers)
         ("C-x f" . find-file)
         ("C-c f" . project-find-file)
         ([f12]   . project-shell-command)
         ("C-c F" . project-switch-project)))

;; VERTical Interactive Completion
(use-package vertico
  :pin gnu
  :init
  (vertico-mode)
  (vertico-mouse-mode)
  (vertico-indexed-mode)
  :config
  (setq vertico-count 12
        vertico-resize t))

;; A Git porcelain inside Emacs
(use-package magit
  :pin melpa)

;; Major mode for Markdown-formatted text
(use-package markdown-mode
  :pin melpa
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))

;; Eglot
(use-package eglot
  :pin gnu
  :hook ((c-ts-mode . eglot-ensure)
         (go-ts-mode . eglot-ensure)
         (c++-ts-mode . eglot-ensure))
  :config (add-to-list 'eglot-server-programs '((c-ts-mode c++-ts-mode) "clangd")))

;; fmt
(defun eglot-format-buffer-before-save ()
  (add-hook 'before-save-hook #'eglot-format-buffer -10 t))
(add-hook 'go-ts-mode-hook #'eglot-format-buffer-before-save)
(add-hook 'c++-ts-mode-hook #'eglot-format-buffer-before-save)

;; Completion in Region FUnction
(use-package corfu
  :pin gnu
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 1)
  (corfu-quit-no-match 'separator))

;; Completion At Point Extensions
(use-package cape
  :pin gnu
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))

(defun my-insert-spdx-license ()
  "SPDX-License."
  (interactive)
  (let ((year (format-time-string "%Y"))
        (user user-full-name))
    (save-excursion
      (goto-char (point-min))
      (insert "// SPDX-License-Identifier: MIT\n")
      (insert (format "// SPDX-FileCopyrightText: %s %s\n\n" year user)))))

(defun my-insert-cpp-guards ()
  "C++ include guards."
  (interactive)
  (let* ((file-name (file-name-nondirectory (file-name-sans-extension (buffer-file-name))))
         (guard (concat (upcase file-name) "_H")))
    (save-excursion
      (goto-char (point-min))
      (while (looking-at "^//") (forward-line 1))
      (insert (format "#ifndef %s\n#define %s\n\n" guard guard))
      (goto-char (point-max))
      (insert (format "\n#endif // %s\n" guard)))))

(defun my-insert-pragma-once ()
  "pragma once"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (looking-at "^//") (forward-line 1))
    (insert "#pragma once\n\n")))

(defun my-cpp-header-init ()
  "SPDX-License + Guard."
  (interactive)
  (my-insert-spdx-license)
  (my-insert-cpp-guards))

(provide 'init)

;;; init.el ends here
