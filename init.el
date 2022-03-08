;; Crie uma variável para indicar onde a configuração do Emacs está instalada
(setq EMACS_DIR "~/.emacs.d/")

;; Atenção: init.el é agora gerado a partir de Emacs.org.
;; Por favor, edite esse ficheiro em Emacs e init.el serão gerados automaticamente!

;; Provavelmente terá de ajustar este tamanho de fonte para o seu sistema!
(defvar default-font-size 100)
(defvar default-variable-font-size 100)

;; Torna transparente
(defvar frame-transparency '(90 . 90))

;; O valor por padrão é de 800 kilobytes.  Medido em bytes.
;; (setq gc-cons-threshold (* 50 1000 1000))

;; Evite a coleta de lixo no statup
(setq gc-cons-threshold most-positive-fixnum ; 2^61 bytes
      gc-cons-percentagem 0.6)

(defun efs/display-startup-time ()
  (message "Emacs carregados em %s com %d de recolhas de lixo."
           (format "%.2f segundos"
                   (float-time
                    (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'efs/display-startup-time)

;; Inicializar fontes de pacotes
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                          ("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)

;; Buscar a lista de pacotes disponíveis
(unless package-archive-contents (package-refresh-contents))

;; Inicializar o pacote-utilização em plataformas não-Linux
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; (use-package exec-path-from-shell :ensure t)
;; (exec-path-from-shell-initialize)

;; Carregar variáveis específicas da plataforma usando arquivos específicos.
;; Por exemplo, linux.el. Fazer as mudanças conforme a necessidade
(cond ((eq system-type 'windows-nt) (load (concat EMACS_DIR "windows")))
((eq system-type 'gnu/linux) (load (concat EMACS_DIR "linux")))
((eq system-type 'darwin) (load (concat EMACS_DIR "mac")))
(t (load-library "default")))

(setq inhibit-startup-message t)

  (scroll-bar-mode -1)        ; desabilitar a barra de rolagem
  (tool-bar-mode -1)          ; desabilitar a barra de ferramentas
  (tooltip-mode -1)           ; desabilitar dicas de ferramentas
  (set-fringe-mode 10)        ; um espaço para respirar
  ;;(menu-bar-mode -1)        ; desabilitar a bara de menu

;; Definir o ambiente de linguagem para UTF-8
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

;; Espaço em branco mais longo, caso contrário o destaque da sintaxe é limitado à coluna padrão
(setq whitespace-line-column 1000) 

  ;; Colocar a campainha visível
  (setq visible-bell t)

  (column-number-mode)
  (global-display-line-numbers-mode t)

  ;; Transparência do quadro definido
  (set-frame-parameter (selected-frame) 'alpha frame-transparency)
  (add-to-list 'default-frame-alist `(alpha . ,frame-transparency))
  (set-frame-parameter (selected-frame) 'fullscreen 'maximized)
  (add-to-list 'default-frame-alist '(fullscreen . maximized))

  ;; Disabilitar números de linha para alguns modos
  (dolist (mode '(org-mode-hook
                  term-mode-hook
                  shell-mode-hook
                  treemacs-mode-hook
                  eshell-mode-hook))
    (add-hook mode (lambda () (display-line-numbers-mode 0))))

  ;; Dicas de ferramentas na área de eco
  (setq tooltip-use-echo-area t)

  (defalias 'yes-or-no-p 'y-or-n-p)

;; Habilitar o envoltório macio
(global-visual-line-mode 1)

  (show-paren-mode 1)

  (recentf-mode 1)

  ;; Salve um histórico das buscas que você inserir no minibuffer
  (setq history-length 25)
  (savehist-mode 1)

;; Codificação de configuração específica

;; Acrescentar automaticamente parênteses e suportes de fim
(electric-pair-mode 1)

;; Certifique-se de que a largura da aba seja 4 e não 8
(setq-default tab-width 4)

  ;; Lembrando o último lugar que você visitou em um arquivo
  (save-place-mode 1)

  ;; Evite o uso de diálogos de interface do usuário para obter solicitações
  (setq use-dialog-box nil)

  ;; Reverter automaticamente buffers para arquivos alterados
  (global-auto-revert-mode 1)

  ;; os buffers dired serão atualizados automaticamente quando os arquivos forem adicionados ou excluídos
  (setq global-auto-revert-non-file-buffers t)

(setq ispell-program-name "C:/ProgramData/ezwinports/bin/hunspell")

(defun my/ansi-colorize-buffer ()
(let ((buffer-read-only nil))
(ansi-color-apply-on-region (point-min) (point-max))))

(use-package ansi-color
:ensure t
:config
(add-hook 'compilation-filter-hook 'my/ansi-colorize-buffer))

(use-package use-package-chords
:ensure t
:init 
:config (key-chord-mode 1)
(setq key-chord-two-keys-delay 0.4)
(setq key-chord-one-key-delay 0.5)) ; default 0.2
;; Aqui, mudamos o atraso para que a chave consecutiva fosse pouco maior do que o padrão. Ajuste isto para o que você se sentir confortável.

(use-package auto-package-update
  :custom
  (auto-package-update-interval 7)
  (auto-package-update-prompt-before-update t)
  (auto-package-update-hide-results t)
  :config
  (auto-package-update-maybe)
  (auto-package-update-at-time "09:00"))

(use-package try :ensure t)

(use-package auto-complete
  :ensure t
  :init
  (ac-config-default)
  (global-auto-complete-mode t))

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)

  ;; Edits
  (setq dashboard-banner-logo-title "Bem vindo ao Emacs, Bruno!")
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-items '((recents   . 5)
                          (bookmarks . 5)
                          (agenda    . 5))))

;; NOTA: Se quiser mover tudo para fora da pasta ~/.emacs.d
;; definir de forma segura "user-emacs-directory" antes de carregar o no-littering!
;(setq user-emacs-directory "~/.cache/emacs")

(use-package no-littering)

;; o "no-littering" não define isto por padrão, por isso temos de colocar
;; guardar arquivos automaticamente no mesmo caminho que utiliza para as sessões
(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

(set-face-attribute 'default nil :font "Fira Code Retina" :height default-font-size)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Fira Code Retina" :height default-font-size)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Cantarell" :height default-variable-font-size :weight 'regular)

;; Fazer ESC desistir instruções
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package general
  :after evil
  :config
  (general-create-definer efs/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (efs/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")
    "fde" '(lambda () (interactive) (find-file (expand-file-name "~/.emacs.d/config.org")))))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Usar movimentos de linha visual mesmo fora do buffer do visual-line-mode
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;;(use-package ergoemacs-mode
  ;;:ensure t
  ;;:config
  ;;(progn
    ;;(setq ergoemacs-theme nil)
    ;;(setq ergoemacs-keyboard-layout "us")
    ;;(ergoemacs-mode 1)))

(use-package ace-window
  :ensure t
  :bind (("C-x w" . ace-window)))

(use-package command-log-mode
  :commands command-log-mode)

(use-package doom-themes
  :init (load-theme 'doom-palenight t))

(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 1))

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
  :chords
  ;; Avy permite que você salte rapidamente para determinado personagem, palavra ou linha dentro do arquivo, use jc, jw ou jl.
  ("jc" . avy-goto-char)
  ("jw" . avy-goto-word-1)
  ("jl" . avy-goto-line)
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :after ivy
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("C-M-j" . 'counsel-switch-buffer)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :custom
  (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
  :config
  (counsel-mode 1))

(use-package ivy-prescient
  :after counsel
  :custom
  (ivy-prescient-enable-filtering nil)
  :config
  ;; A seguinte linha para ter a ordenação lembrada ao longo das sessões!
  (prescient-persist-mode 1)
  (ivy-prescient-mode 1))

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package hydra
  :defer t)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(efs/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))

(defun efs/org-font-setup ()
  ;; Substituir o hífen da lista por ponto
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Definir características para níveis de cabeçalho
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Assegurar que tudo o que deve ser fixado nos arquivos da Org aparece dessa forma
  (set-face-attribute 'org-block nil    :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil    :inherit 'fixed-pitch)
  (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil     :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil    :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil  :inherit 'fixed-pitch)
  (set-face-attribute 'line-number nil :inherit 'fixed-pitch)
  (set-face-attribute 'line-number-current-line nil :inherit 'fixed-pitch))

(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(use-package org
  :pin org
  :commands (org-capture org-agenda)
  :hook (org-mode . efs/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")

  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)

  (setq org-agenda-files
        '("~/Projects/OrgFiles/Tasks.org"
          "~/Projects/OrgFiles/Habits.org"
          "~/Projects/OrgFiles/Birthdays.org"))

  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 60)

  (setq org-todo-keywords
    '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
      (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))

  (setq org-refile-targets
    '(("Archive.org" :maxlevel . 1)
      ("Tasks.org" :maxlevel . 1)))

  ;;  Salve os Org buffers depois de preencher de novo!
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  (setq org-tag-alist
    '((:startgroup)
       ; Colocar aqui etiquetas de identificação exclusivas
       (:endgroup)
       ("@errand" . ?E)
       ("@home" . ?H)
       ("@work" . ?W)
       ("agenda" . ?a)
       ("planning" . ?p)
       ("publish" . ?P)
       ("batch" . ?b)
       ("note" . ?n)
       ("idea" . ?i)))

  ;; Configurar vistas personalizadas da agenda
  (setq org-agenda-custom-commands
   '(("d" "Dashboard"
     ((agenda "" ((org-deadline-warning-days 7)))
      (todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))
      (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

    ("n" "Next Tasks"
     ((todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))))

    ("W" "Work Tasks" tags-todo "+work-email")

    ;; As ações seguintes de baixo esforço
    ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
     ((org-agenda-overriding-header "Low Effort Tasks")
      (org-agenda-max-todos 20)
      (org-agenda-files org-agenda-files)))

    ("w" "Workflow Status"
     ((todo "WAIT"
            ((org-agenda-overriding-header "Waiting on External")
             (org-agenda-files org-agenda-files)))
      (todo "REVIEW"
            ((org-agenda-overriding-header "In Review")
             (org-agenda-files org-agenda-files)))
      (todo "PLAN"
            ((org-agenda-overriding-header "In Planning")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "BACKLOG"
            ((org-agenda-overriding-header "Project Backlog")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "READY"
            ((org-agenda-overriding-header "Ready for Work")
             (org-agenda-files org-agenda-files)))
      (todo "ACTIVE"
            ((org-agenda-overriding-header "Active Projects")
             (org-agenda-files org-agenda-files)))
      (todo "COMPLETED"
            ((org-agenda-overriding-header "Completed Projects")
             (org-agenda-files org-agenda-files)))
      (todo "CANC"
            ((org-agenda-overriding-header "Cancelled Projects")
             (org-agenda-files org-agenda-files)))))))

  (setq org-capture-templates
    `(("t" "Tasks / Projects")
      ("tt" "Task" entry (file+olp "~/Projects/OrgFiles/Tasks.org" "Inbox")
           "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)

      ("j" "Journal Entries")
      ("jj" "Journal" entry
           (file+olp+datetree "~/Projects/OrgFiles/Journal.org")
           "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
           ;; ,(dw/read-file-as-string "~/Notes/Templates/Daily.org")
           :clock-in :clock-resume
           :empty-lines 1)
      ("jm" "Meeting" entry
           (file+olp+datetree "~/Projects/OrgFiles/Journal.org")
           "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
           :clock-in :clock-resume
           :empty-lines 1)

      ("w" "Workflows")
      ("we" "Checking Email" entry (file+olp+datetree "~/Projects/OrgFiles/Journal.org")
           "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)

      ("m" "Metrics Capture")
      ("mw" "Weight" table-line (file+headline "~/Projects/OrgFiles/Metrics.org" "Weight")
       "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t)))

  (define-key global-map (kbd "C-c j")
    (lambda () (interactive) (org-capture nil "jj")))

  (efs/org-font-setup))

;; (use-package org-bullets
;;   :hook (org-mode . org-bullets-mode)
;;   :custom
;;   (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

;; Org-Roam basic configuration
;; O "(getenv "HOME")" substitui o uso do "~/"
  (setq org-directory (concat (getenv "HOME") "/MenteExterna"))

  (use-package org-roam
      :ensure t
      :init
      (setq org-roam-v2-ack t)
      :custom
      (org-roam-directory (file-truename org-directory))
      (org-roam-completion-everywhere t)
      (org-roam-capture-templates
       '(("d" "default" plain
          "%?"
          :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+date: %U\n")
          :unnarrowed t)
         ("l" "programming language" plain
          "* Characteristics\n\n- Family: %?\n- Inspired by: \n\n* Reference:\n\n"
          :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
          :unnarrowed t)
         ("b" "book notes" plain
          "\n* Source\n\nAuthor: %^{Author}\nTitle: ${title}\nYear: %^{Year}\n\n* Summary\n\n%?"
          :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
          :unnarrowed t)
         ("p" "project" plain
          "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
          :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: Project")
          :unnarrowed t)
         ("b" "book notes" plain
          (file "~/MenteExterna/Templates/BookNoteTemplate.org")
          :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
          :unnarrowed t)))  
      :bind (("C-c n l" . org-roam-buffer-toggle)
             ("C-c n f" . org-roam-node-find)

             ("C-c n i" . org-roam-node-insert)
             :map org-mode-map
             ("C-M-i" . completion-at-point))
      :config
      (org-roam-setup))

(use-package quickrun 
:ensure t
:bind ("C-c r" . quickrun))

(use-package company-posframe
          :config
          (company-posframe-mode 1))

        ;; Melhorar a aparência do modo org
        (setq org-startup-indented t
                org-pretty-entities t
                org-hide-emphasis-markers t
                org-startup-with-inline-images t
                org-image-actual-width '(300))

        (use-package org-appear
          :hook (org-mode . org-appear-mode))

      (use-package org-superstar
            :config
            (setq org-superstar-special-todo-items t)
            (add-hook 'org-mode-hook (lambda ()
                                       (org-superstar-mode 1))))

    (plist-put org-format-latex-options :scale 2)

  (use-package olivetti
      :init
      (setq olivetti-body-width .67)
      :config
      (defun distraction-free ()
        "Distraction-free writing environment"
        (interactive)
        (if (equal olivetti-mode nil)
            (progn
              (window-configuration-to-register 1)
              (delete-other-windows)
              (text-scale-increase 2)
              (olivetti-mode t))
          (progn
            (jump-to-register 1)
            (olivetti-mode 0)
            (text-scale-decrease 2))))
      :bind
      (("<f9>" . distraction-free)))

(use-package deft
    :config
    (setq deft-directory org-directory
          deft-recursive t
          deft-strip-summary-regexp ":PROPERTIES:\n\\(.+\n\\)+:END:\n"
          deft-use-filename-as-title t)
    :bind
    ("C-c n d" . deft))

(use-package hide-mode-line)

  (defun efs/presentation-setup ()
    ;; Hide the mode line
    (hide-mode-line-mode 1)

    ;; Display images inline
    (org-display-inline-images) ;; Can also use org-startup-with-inline-images

    ;; Scale the text.  The next line is for basic scaling:
    (setq text-scale-mode-amount 2)
    (text-scale-mode 1))

    ;; This option is more advanced, allows you to scale other faces too
    ;; (setq-local face-remapping-alist '((default (:height 2.0) variable-pitch)
    ;;                                    (org-verbatim (:height 1.75) org-verbatim)
    ;;                                    (org-block (:height 1.25) org-block))))

  (defun efs/presentation-end ()
    ;; Show the mode line again
    (hide-mode-line-mode 0)

    ;; Turn off text scale mode (or use the next line if you didn't use text-scale-mode)
    ;; (text-scale-mode 0))

    ;; If you use face-remapping-alist, this clears the scaling:
    (setq-local face-remapping-alist '((default variable-pitch default))))

  (use-package org-tree-slide
    :hook ((org-tree-slide-play . efs/presentation-setup)
           (org-tree-slide-stop . efs/presentation-end))
    :custom
    (org-tree-slide-slide-in-effect t)
    (org-tree-slide-activate-message "Presentation started!")
    (org-tree-slide-deactivate-message "Presentation finished!")
    (org-tree-slide-header t)
    (org-tree-slide-breadcrumbs " > ")
    (org-tree-slide-skip-outline-level 0)
    (org-image-actual-width nil))

(use-package ox-reveal
  :custom
  (org-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js")
  (org-reveal-mathjax t)

)
;; for syntax highlightng
(use-package htmlize)

(defun org-present-prepare-slide ()
  "Prepare slide."
  (org-overview)
  (org-show-entry)
  (org-show-children))

(defun org-present-prev ()
  "Previous slide."
  (interactive)
  (org-present-prev)
  (org-present-prepare-slide))

(defun org-present-next ()
  "Next slide."
  (interactive)
  (org-present-next)
  (org-present-prepare-slide))

(use-package org-present
  :bind (:map org-present-mode-keymap
         ("C-c C-j" . org-present-next)
         ("C-c C-k" . org-present-prev))
  :hook (
	 (org-present-mode . (lambda ()
                 (org-present-big)
                 (org-display-inline-images)
                 (org-present-hide-cursor)
                 (org-present-read-only)))
         (org-present-mode-quit . (lambda ()
                 (org-present-small)
                 (org-remove-inline-images)
                 (org-present-show-cursor)
                 (org-present-read-write)))
	))

(with-eval-after-load 'org
  (org-babel-do-load-languages
      'org-babel-load-languages
      '((emacs-lisp . t)
          (plantuml . t)
        (python . t)
        (java . t)))

  (push '("conf-unix" . conf-unix) org-src-lang-modes))

(require 'ob-java)

;; (setq org-babel-default-header-args:java
;;        '((:dir . nil)
;;          (:results . value)))

(use-package plantuml-mode
  :config
  (setq org-plantuml-jar-path "~/plantuml.jar"))

;; Problema do Org-mode com o bloco src não se expandindo
;; Esta é uma correção para erros no modo org-mode onde <s TAB não expande o bloco SRC
;; (when (version<= "9.2" (org-version))
;;   (require 'org-tempo))

  (with-eval-after-load 'org
    ;; Isto é necessário a partir do Org 9.2
    (require 'org-tempo)

    (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
    (add-to-list 'org-structure-template-alist '("pl" . "src plantuml"))
    (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
    (add-to-list 'org-structure-template-alist '("py" . "src python"))
    (add-to-list 'org-structure-template-alist '("jv" . "src java")))


  ;; Configuração para ativar o destaque da sintaxe para os blocos de código
  (setf org-src-fontify-natively t)

;; Resolver automaticamente o nosso arquivo de configuração config.org quando o salvarmos
(defun efs/org-babel-tangle-config ()
  (when (string-equal (file-name-directory (buffer-file-name))
                      (expand-file-name user-emacs-directory))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

(use-package org-pomodoro
      :ensure t
      :config
      ;; Persistent Clocking
      (setq org-clock-persist 'history)
      (org-clock-persistence-insinuate)

      ;; Default Table Params
      (setq org-clock-clocktable-default-properties '(:maxlevel 3 :scope subtree :tags "-Lunch"))


      ;; Org Pomodoro ;;
      ;; Setup pomodoro timer keybind
      (global-set-key (kbd "C-S-c C-S-p") 'org-pomodoro)
      (global-set-key (kbd "C-S-c C-S-e") 'org-pomodoro-extend-last-clock)

      (defun org-pomodoro-get-times ()
        (interactive)
        (message "work length: %s  short break: %s  long break: %s"
                 org-pomodoro-length
                 org-pomodoro-short-break-length
                 org-pomodoro-long-break-length))

      (defun org-pomodoro-set-pomodoro ()
        (interactive)
        (setf org-pomodoro-length 35)
        (setf org-pomodoro-short-break-length 9)
        (setf org-pomodoro-long-break-length 15))


      (org-pomodoro-set-pomodoro)

      (defun org-pomodoro-set-52-17 ()
        (interactive)
        (setf org-pomodoro-length 52)
        (setf org-pomodoro-short-break-length 17)
        (setf org-pomodoro-long-break-length 17)))

(defun efs/lsp-mode-setup ()
    (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
    (lsp-headerline-breadcrumb-mode))

  ;; (use-package lsp-mode
  ;;   :commands (lsp lsp-deferred)
  ;;   :hook (lsp-mode . efs/lsp-mode-setup)
  ;;   :init
  ;;   (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  ;;   :config
  ;;   (lsp-enable-which-key-integration t)
  ;;   ;; Estou testando
  ;;   ;; (setq lsp-completion-enable-additional-text-edit nil)
  ;;   )

(use-package lsp-mode
:ensure t
:hook (
   (lsp-mode . lsp-enable-which-key-integration)
   (java-mode . #'lsp-deferred)
)
:init (setq 
    lsp-keymap-prefix "C-c l" ; isto é para a documentação de integração de which-key, necessidade de usar lsp-mode-map
    lsp-enable-file-watchers nil
    read-process-output-max (* 1024 1024)  ; 1 mb
    lsp-completion-provider :capf
    lsp-idle-delay 0.500
)
:config 
    (setq lsp-intelephense-multi-root nil) ; não escaneie projetos desnecessários
    (with-eval-after-load 'lsp-intelephense
    (setf (lsp--client-multi-root (gethash 'iph lsp-clients)) nil))
      (define-key lsp-mode-map (kbd "C-c l") lsp-command-map)
)

(use-package lsp-ui
  :ensure t
  :after (lsp-mode)
  :bind (:map lsp-ui-mode-map
              ([remap xref-find-definitions] . lsp-ui-peek-find-definitions)
              ([remap xref-find-references] . lsp-ui-peek-find-references))
  :init (setq lsp-ui-doc-delay 1.5
              lsp-ui-doc-position 'bottom
              lsp-ui-doc-max-width 100))

(use-package lsp-treemacs
:after (lsp-mode treemacs)
:ensure t
:commands lsp-treemacs-errors-list
:bind (:map lsp-mode-map
       ("M-9" . lsp-treemacs-errors-list)))

(use-package treemacs
  :ensure t
  :commands (treemacs)
  :after (lsp-mode)
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay        0.5
          treemacs-directory-name-transformer      #'identity
          treemacs-display-in-side-window          t
          treemacs-eldoc-display                   'simple
          treemacs-file-event-delay                5000
          treemacs-file-extension-regex            treemacs-last-period-regex-value
          treemacs-file-follow-delay               0.2
          treemacs-file-name-transformer           #'identity
          treemacs-follow-after-init               t
          treemacs-expand-after-init               t
          treemacs-find-workspace-method           'find-for-file-or-pick-first
          treemacs-git-command-pipe                ""
          treemacs-goto-tag-strategy               'refetch-index
          treemacs-indentation                     2
          treemacs-indentation-string              " "
          treemacs-is-never-other-window           nil
          treemacs-max-git-entries                 5000
          treemacs-missing-project-action          'ask
          treemacs-move-forward-on-expand          nil
          treemacs-no-png-images                   nil
          treemacs-no-delete-other-windows         t
          treemacs-project-follow-cleanup          nil
          treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                        'left
          treemacs-read-string-input               'from-child-frame
          treemacs-recenter-distance               0.1
          treemacs-recenter-after-file-follow      nil
          treemacs-recenter-after-tag-follow       nil
          treemacs-recenter-after-project-jump     'always
          treemacs-recenter-after-project-expand   'on-distance
          treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
          treemacs-show-cursor                     nil
          treemacs-show-hidden-files               t
          treemacs-silent-filewatch                nil
          treemacs-silent-refresh                  nil
          treemacs-sorting                         'alphabetic-asc
          treemacs-select-when-already-in-treemacs 'move-back
          treemacs-space-between-root-nodes        t
          treemacs-tag-follow-cleanup              t
          treemacs-tag-follow-delay                1.5
          treemacs-text-scale                      nil
          treemacs-user-mode-line-format           nil
          treemacs-user-header-line-format         nil
          treemacs-wide-toggle-width               70
          treemacs-width                           35
          treemacs-width-increment                 1
          treemacs-width-is-initially-locked       t
          treemacs-workspace-switch-cleanup        nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

(use-package treemacs-persp ;;treemacs-perspective if you use perspective.el vs. persp-mode
  :after (treemacs persp-mode) ;;or perspective vs. persp-mode
  :ensure t
  :config (treemacs-set-scope-type 'Perspectives))

(use-package treemacs-tab-bar ;;treemacs-tab-bar if you use tab-bar-mode
  :after (treemacs)
  :ensure t
  :config (treemacs-set-scope-type 'Tabs))

(use-package lsp-ivy
  :after lsp)

(use-package dap-mode
  ;; Descomente a configuração abaixo se você quiser
  ;; que todas as janelas de IU sejam escondidas por padrão!
  ;; :custom
  ;; (lsp-enable-dap-auto-configure nil)
  ;; :config
  ;; (dap-ui-mode 1)
  :commands dap-debug
  :config
  ;; Configurar a depuração do nó
  (require 'dap-node)
  (dap-node-setup) ;; Instala automaticamente o adaptador de depuração do nó, se necessário

  ;; Ligar `C-c l d` a `dap-hydra` para fácil acesso
  (general-define-key
    :keymaps 'lsp-mode-map
    :prefix lsp-keymap-prefix
    "d" '(dap-hydra t :wk "debugger")))

;; (use-package dap-mode
;;   :ensure t
;;   :after (lsp-mode)
;;   :functions dap-hydra/nil
;;   :config
;;   ;; (require 'dap-java)
;;   (dap-auto-configure-mode)
;;   :bind (:map lsp-mode-map
;;          ("<f5>" . dap-debug)
;;          ("M-<f5>" . dap-hydra))
;;   :hook ((dap-mode . dap-ui-mode)
;;     (dap-session-created . (lambda (&_rest) (dap-hydra)))
;;     (dap-terminated . (lambda (&_rest) (dap-hydra/nil)))))

(use-package dap-java :ensure nil)

(use-package lsp-java
  :ensure t
  :config (add-hook 'java-mode-hook 'lsp))

(use-package helm-lsp
  :ensure t
  :after (lsp-mode)
  :commands (helm-lsp-workspace-symbol)
  :init (define-key lsp-mode-map [remap xref-find-apropos] #'helm-lsp-workspace-symbol))

(defun helm-or-evil-escape ()
  "Escape from anything."
  (interactive)
  (cond ((minibuffer-window-active-p (minibuffer-window))
         ;; quit the minibuffer if open.
         (abort-recursive-edit))
        ;; Run all escape hooks. If any returns non-nil, then stop there.
        ;; ((cl-find-if #'funcall doom-escape-hook))
        ;; don't abort macros
        ((or defining-kbd-macro executing-kbd-macro) nil)
        ;; Back to the default
        ((keyboard-quit))))

(use-package helm-rg
  :ensure t)

(use-package helm-projectile
  :ensure t
  :config
  (setq helm-bookmark-show-location t)
  (helm-projectile-on))

;; Torna a fuga do helm (e outros buffers) MUITO melhor
(global-set-key [escape] #'helm-or-evil-escape)

;; (use-package helm
  ;;   :ensure t
  ;;   :bind (([remap apropos]                     . helm-apropos)
  ;;          ([remap find-library]                . helm-locate-library)
  ;;          ([remap bookmark-jump]               . helm-bookmarks)
  ;;          ([remap execute-extended-command]    . helm-M-x)
  ;;          ([remap find-file]                   . helm-find-files)
  ;;          ([remap imenu-anywhere]              . helm-imenu-anywhere)
  ;;          ([remap imenu]                       . helm-semantic-or-imenu)
  ;;          ([remap noop-show-kill-ring]         . helm-show-kill-ring)
  ;;          ([remap persp-switch-to-buffer]      . helm-mini)
  ;;          ([remap switch-to-buffer]            . helm-buffers-list)
  ;;          ([remap projectile-find-file]        . helm-projectile-find-file)
  ;;          ([remap projectile-recentf]          . helm-projectile-recentf)
  ;;          ([remap projectile-switch-project]   . helm-projectile-switch-project)
  ;;          ([remap projectile-switch-to-buffer] . helm-projectile-switch-to-buffer)
  ;;          ([remap recentf-open-files]          . helm-recentf)
  ;;          :map helm-map
  ;;          ("C-h a"                             . helm-apropos)
  ;;          ("C-j"                               . helm-next-line)
  ;;          ("C-k"                               . helm-previous-line)
  ;;          ("<tab>"                             . helm-execute-persistent-action)
  ;;          ("C-i"                               . helm-execute-persistent-action)
  ;;          ("C-z"                               . helm-select-action)
  ;;          ("C-w"                               . backward-kill-word)
  ;;          ("C-a"                               . move-beginning-of-line)
  ;;          ("C-u"                               . backward-kill-sentence)
  ;;          ("C-b"                               . backward-word)
  ;;          ("C-f"                               . forward-word)
  ;;          ("C-r"                               . evil-paste-from-register)
  ;;          ("ESC"                               . abort-recursive-edit)
  ;;          ("C-S-j"                             . scroll-up-command)
  ;;          ("C-S-k"                             . scroll-down-command))

  ;;   :init
  ;;   (helm-mode 1)
  ;;   (setq
  ;;    helm-M-x-fuzzy-match                  t
  ;;    helm-ag-fuzzy-match                   t
  ;;    helm-apropos-fuzzy-match              t
  ;;    helm-apropos-fuzzy-match              t
  ;;    helm-bookmark-show-location           t
  ;;    helm-buffers-fuzzy-matching           t
  ;;    helm-completion-in-region-fuzzy-match t
  ;;    helm-completion-in-region-fuzzy-match t
  ;;    helm-ff-fuzzy-matching                t
  ;;    helm-file-cache-fuzzy-match           t
  ;;    helm-flx-for-helm-locate              t
  ;;    helm-imenu-fuzzy-match                t
  ;;    helm-lisp-fuzzy-completion            t
  ;;    helm-locate-fuzzy-match               t
  ;;    helm-mode-fuzzy-match                 t
  ;;    helm-projectile-fuzzy-match           t
  ;;    helm-recentf-fuzzy-match              t
  ;;    helm-semantic-fuzzy-match             t)
  ;;   :preface
  ;;   (add-hook 'helm-after-initialize-hook (lambda () (display-line-numbers-mode -1)))
  ;;   (setq helm-split-window-in-side-p nil         ; buffer de helm aberto dentro da janela atual
  ;;         helm-move-to-line-cycle-in-source t     ; mover-se para o fim ou início da fonte ao chegar ao topo ou ao fundo
  ;;         helm-ff-search-library-in-sexp t        ; busca de biblioteca em `require' e `declare-function' sexp
  ;;         helm-scroll-amount 8                    ; rolar 8 linhas em outra janela usando M-<next>/M-<prior>
  ;;         helm-ff-file-name-history-use-recentf t
  ;;         helm-echo-input-in-header-line t
  ;;         helm-candidate-number-limit 50
  ;;         helm-display-header-line nil
  ;;         helm-mode-line-string nil
  ;;         helm-ff-auto-update-initial-value nil
  ;;         helm-find-files-doc-header nil
  ;;         helm-display-buffer-default-width nil
  ;;         helm-display-buffer-default-height 0.25
  ;;         helm-split-window-default-side 'below)
  ;;   :config
  ;;   (require 'helm-config)
  ;;   (set-face-attribute 'helm-selection nil :foreground "black" :background "#9c91e4")
  ;;   (set-face-attribute 'helm-header-line-left-margin nil :background "unspecified")
  ;;   (set-face-attribute 'helm-candidate-number nil :background "unspecified" :foreground "white")
  ;;   (global-set-key (kbd "C-c h")   #'helm-command-prefix)
  ;;   (global-set-key (kbd "M-x")     #'helm-M-x)
  ;;   (global-set-key (kbd "C-s")     #'helm-swoop)
  ;;   (global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
  ;;   (global-set-key (kbd "C-x C-f") #'helm-find-files)
  ;;   (helm-mode +1))

(use-package helm
:ensure t
:init 
(helm-mode 1)
(progn (setq helm-buffers-fuzzy-matching t))
:bind
(("C-c h" . helm-command-prefix))
(("M-x" . helm-M-x))
(("C-x C-f" . helm-find-files))
(("C-x b" . helm-buffers-list))
(("C-c b" . helm-bookmarks))
(("C-c f" . helm-recentf))   ;; Add new key to recentf
(("C-c g" . helm-grep-do-git-grep)))  ;; Search using grep in a git project

(use-package helm-descbinds
:ensure t
:bind ("C-h b" . helm-descbinds))

(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))

(use-package python-mode
  :ensure t
  :hook (python-mode . lsp-deferred)
  :custom
  ;; OBSERVAÇÃO: Defina estes se Python 3 for chamado de "python3" em seu sistema!
  (python-shell-interpreter "python3")
  (dap-python-executable "python3")
  (dap-python-debugger 'debugpy)
  :config
  (require 'dap-python))

(use-package pyvenv
  :after python-mode
  :config
  (pyvenv-mode 1))

(use-package company
    :after lsp-mode
    :hook (lsp-mode . company-mode)
    :bind (:map company-active-map
           ("<tab>" . company-complete-selection))
          (:map lsp-mode-map
           ("<tab>" . company-indent-or-complete-common))
    :custom
    (company-minimum-prefix-length 1)
    (company-idle-delay 0.0))

;; Auto completion
  (use-package company
    :config
    (setq company-idle-delay 0
          company-minimum-prefix-length 4
          company-selection-wrap-around t))
  (global-company-mode)

  (use-package company-box
    :hook (company-mode . company-box-mode))

  ;; (setq company-auto-complete t)

  ;;   (defun my-company-visible-and-explicit-action-p ()
  ;;   (and (company-tooltip-visible-p)
  ;;        (company-explicit-action-p)))

  ;; (defun company-ac-setup ()
  ;;   "Sets up `company-mode' to behave similarly to `auto-complete-mode'."
  ;;   (setq company-require-match nil)
  ;;   (setq company-auto-complete #'my-company-visible-and-explicit-action-p)
  ;;   (setq company-frontends '(company-echo-metadata-frontend
  ;;                             company-pseudo-tooltip-unless-just-one-frontend-with-delay
  ;;                             company-preview-frontend)))

  ;;  (company-ac-setup)

;; (use-package projectile
;;   :diminish projectile-mode
;;   :config (projectile-mode)
;;   :custom ((projectile-completion-system 'ivy))
;;   :bind-keymap
;;   ("C-c p" . projectile-command-map)
;;   :init
;;   ;; OBSERVAÇÃO: Coloque isto na pasta onde você mantém seu repositório Git!
;;   (when (file-directory-p "~/Projects/Code")
;;     (setq projectile-project-search-path '("~/Projects/Code")))
;;   (setq projectile-switch-project-action #'projectile-dired))

(use-package projectile 
  :ensure t
  :init (projectile-mode +1)
  :config 
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(use-package counsel-projectile
  :after projectile
  :config (counsel-projectile-mode))

(use-package flycheck :ensure t :init (global-flycheck-mode))

(use-package yasnippet :config (yas-global-mode))
(use-package yasnippet-snippets :ensure t)

(use-package magit
  :commands magit-status
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; NOTA: Certifique-se de configurar um token GitHub antes de usar este pacote!
;; - https://magit.vc/manual/forge/Token-Creation.html#Token-Creation
;; - https://magit.vc/manual/ghub/Getting-Started.html#Getting-Started
(use-package forge
  :after magit)

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

(use-package smartparens
  :diminish smartparens-mode ;; Do not show in modeline
  :init
  (require 'smartparens-config)
  :config
  (smartparens-global-mode t) ;; These options can be t or nil.
  (show-smartparens-global-mode t)
  (setq sp-show-pair-from-inside t)
  :custom-face
  (sp-show-pair-match-face ((t (:foreground "red")))) ;; Could also have :background "Grey" for example.
  )

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package term
  :commands term
  :config
  (setq explicit-shell-file-name "bash") ;; Mude isto para zsh, etc.
  ;;(setq explicit-zsh-args '())
  ;; Use 'explicit-<shell>-args para Args específicos do shell

  ;; Corresponder ao prompt padrão do Bash shell.
  ;; Atualize isto se você tiver um prompt personalizado
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *"))

(use-package eterm-256color
  :hook (term-mode . eterm-256color-mode))

(use-package vterm
  :commands vterm
  :config
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")  ;; Defina isto para combinar com seu prompt de shell personalizado
  ;;(setq vterm-shell "zsh")                       ;; Configure isto para personalizar o shell para lançar
  (setq vterm-max-scrollback 10000))

(when (eq system-type 'windows-nt)
  (setq explicit-shell-file-name "powershell.exe")
  (setq explicit-powershell.exe-args '()))

(defun efs/configure-eshell ()
  ;; Salvar o histórico de comandos quando os comandos são inseridos
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

  ;; Buffer truncado para desempenho
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

  ;; Ligar algumas chaves úteis para evil-mode
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "C-r") 'counsel-esh-history)
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "<home>") 'eshell-bol)
  (evil-normalize-keymaps)

  (setq eshell-history-size         10000
        eshell-buffer-maximum-lines 10000
        eshell-hist-ignoredups t
        eshell-scroll-to-bottom-on-input t))

(use-package eshell-git-prompt
  :after eshell)

(use-package eshell
  :hook (eshell-first-time-mode . efs/configure-eshell)
  :config

  (with-eval-after-load 'esh-opt
    (setq eshell-destroy-buffer-when-process-dies t)
    (setq eshell-visual-commands '("htop" "zsh" "vim")))

  (eshell-git-prompt-use-theme 'powerline))

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first"))
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "l" 'dired-single-buffer))

(use-package dired-single
  :commands (dired dired-jump))

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package dired-open
  :commands (dired dired-jump)
  :config
  ;; Não funciona como esperado!
  ;;(add-to-list 'dired-open-functions #'dired-open-xdg t)
  (setq dired-open-extensions '(("png" . "feh")
                                ("mkv" . "mpv"))))

(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "H" 'dired-hide-dotfiles-mode))

;; Faça as pausas do gc mais rápidas diminuindo o limite.
(setq gc-cons-threshold (* 2 1000 1000))

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-limiar 30000000000 ; 300mb 
                  gc-cons-percentagem 0.1)))
