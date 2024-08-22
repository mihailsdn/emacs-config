;;; init.el --- Emacs configurations -*- coding: utf-8; lexical-binding: t -*-

;; Copyright (C) 2024 Mihails <mihails.dn@gmail.com>

;; Author: Mihails <mihails.dn@gmail.com>
;; Repository: https://github.com/mihailsdn/emacs-config
;; Package-Requires: ((emacs "29.1"))

;; This file is not part of GNU Emacs.

;;; License:

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

;; Minimal UI
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

(setq frame-title-format "%f"
      inhibit-splash-screen t
      make-backup-files nil
      warning-minimum-level :error)

(setq read-process-output-max (* 1024 1024)) ;; 1mb

;; Window
(add-to-list 'default-frame-alist '(height . 36))
(add-to-list 'default-frame-alist '(width . 120))
(add-to-list 'default-frame-alist '(alpha-background . 98))

(set-face-attribute 'default nil :family "DejaVu Sans Mono" :height 130 :weight 'book)
(set-face-attribute 'variable-pitch nil :family "DejaVu Serif" :height 130 :weight 'book)
(set-face-attribute 'fixed-pitch nil :family "DejaVu Sans Mono" :height 130 :weight 'book)

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)
(set-default-coding-systems 'utf-8)

(column-number-mode t)
(electric-pair-mode t)
(show-paren-mode t)
(cua-mode t) ;; Copy and Paste - Ctrl+C, Ctrl+V

(setq-default tab-width 4
              indent-tabs-mode nil)

;; Automatically remove trailing whitespace when file is saved
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Scrolling
(setq scroll-margin 3
      pixel-scroll-mode t
      pixel-scroll-precision-mode t)

;; Yes and No
(defalias 'yes-or-no-p 'y-or-n-p)

;; Built-in buffer
(require 'bs)
(setq bs-configurations
      '(("files" "^\\*scratch\\*" nil nil bs-visits-non-file bs-sort-buffer-interns-are-last)))

(global-set-key (kbd "<f2>") 'bs-show)
(global-set-key (kbd "<f3>") 'kill-buffer)
(global-set-key (kbd "<f5>") 'save-buffer)

(global-set-key (kbd "<f6>") 'shell-command)
(global-set-key (kbd "<f7>") 'undo)
(global-set-key (kbd "<f8>") 'flyspell-prog-mode)

(global-set-key (kbd "C-b") 'bookmark-set)
(global-set-key (kbd "M-b") 'bookmark-jump)
(global-set-key (kbd "<f4>") 'bookmark-bmenu-list)

;; Org-mode
(setq org-log-done t ;; Time
      org-src-fontify-natively t)

;; Melpa
(require 'package)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;; Settings for use-package
(require 'use-package)
(setq use-package-always-ensure t)

;; A low contrast color theme for Emacs
(use-package zenburn-theme
  :pin melpa
  :config
  (setq zenburn-scale-org-headlines t
        zenburn-use-variable-pitch t
        zenburn-scale-outline-headlines t)
  (load-theme 'zenburn t)
  (set-cursor-color "#D0BF8F"))

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

;; On-the-fly syntax checking
(use-package flycheck
  :pin melpa-stable
  :init (global-flycheck-mode))

;; A Git porcelain inside Emacs
(use-package magit
  :pin melpa)

;; Major mode for editing JSON files
(use-package json-mode
  :pin melpa)

;; Major mode for Markdown-formatted text
(use-package markdown-mode
  :pin melpa
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))

;; Major mode for editing YAML files
(use-package yaml-mode
  :pin melpa
  :mode ("\\.yml\\'" . yaml-mode))

;; Improved JavaScript editing mode
(use-package js2-mode
  :pin melpa
  :mode
  ("node" . js2-mode)
  ("\\.js\\'" . js2-mode))

;; Major mode for the Go programming language
(use-package go-mode
  :pin melpa
  :mode ("\\.go\\'" . go-mode))

;; Major mode for editing web templates
(use-package web-mode
  :pin melpa
  :mode
  ("\\.html\\'" . web-mode)
  ("\\.phtml\\'" . web-mode)
  ("\\.tpl\\.php\\'" . web-mode)
  :init
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-enable-auto-pairing t
        web-mode-enable-current-element-highlight t))

;; LSP
(use-package lsp-mode
  :pin melpa-stable
  :config (setq lsp-modeline-code-action-fallback-icon "?!")
  :commands (lsp lsp-deferred)
  :hook (go-mode . lsp-deferred))

;; Set up before-save hooks to format buffer and add/delete imports
;; Make sure you don't have other gofmt/goimports hooks enabled
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; Modular text completion framework
(use-package company
  :pin melpa
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0
        company-minimum-prefix-length 1
        company-format-margin-function #'company-text-icons-margin))

(provide 'init)

;;; init.el ends here
