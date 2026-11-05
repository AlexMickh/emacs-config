(setq inhibit-startup-message t)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)

(menu-bar-mode -1)

(setq-default display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

(modify-all-frames-parameters '((fullscreen . maximized)))

;; Включить глобальное автозакрытие скобок и кавычек
(electric-pair-mode 1)

(set-face-attribute 'default nil
                    :font "JetBrainsMono Nerd Font Mono"
                    :height 110   ; 120 means 12pt font size
                    :weight 'normal)

(load-theme 'wombat)

(require 'package)

(setq package-archives
      '(("gnu"          . "https://elpa.gnu.org/packages/")
        ("melpa"        . "https://melpa.org/packages/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")
        ("org"          . "https://orgmode.org")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(autothemer company counsel doom-modeline evil-collection
		github-emacs-theme lsp-mode lsp-ui magit
		solarized-theme zenburn-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(dolist (mode '(org-mode-hook
		term-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package counsel
  :config
  (counsel-mode 1))

(use-package doom-modeline
  :init (doom-modeline-mode 1))

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status))
  :custom
  (magit-completing-read-function 'ivy-completing-read))

(which-key-mode 1)

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l"
	read-process-output-max (* 1024 1024)
	lsp-completion-provider :capf)
  :hook ((c-mode . lsp-deferred)
         (c++-mode . lsp-deferred))
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode)
  :config
  ;; Настройки интерфейса (опционально)
  (setq lsp-ui-doc-enable t          ; Показывать документацию при наведении
        lsp-ui-peek-enable t         ; Быстрый просмотр определений
        lsp-ui-sideline-enable t))

(use-package company
  :ensure t
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  :config
  (setq company-minimum-prefix-length 1      ; Начинать дополнение после 1 введённого символа
        company-idle-delay 0.0               ; Показывать варианты мгновенно, без задержки
        company-selection-wrap-around t      ; Циклическая прокрутка списка
        company-tooltip-align-annotations t) ; Выравнивать подсказки типов по правому краю
  
  ;; Горячие клавиши внутри меню автодополнения
  :bind (:map company-active-map
              ("C-n" . company-select-next)     ; Следующий элемент (вместо стрелочек)
              ("C-p" . company-select-previous) ; Предыдущий элемент
              ("<tab>" . company-complete-common-or-cycle)
              ("<escape>" . company-abort)))
