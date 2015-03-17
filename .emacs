(defvar ostype nil)
(cond ((string-match "linux" system-configuration)  ;; Linux
       (setq ostype 'linux))
      ((string-match "apple-darwin" system-configuration)  ;; Mac
       (setq ostype 'mac)))
(defun linux? () (eq ostype 'linux))
(defun mac? () (eq ostype 'mac))
(defun mac-gui?() (eq window-system 'ns))

;; add ~/.emacs.d/elisp and its subdirectries to load-path
(let ((default-directory "~/.emacs.d/elisp"))
  (setq load-path
	(append
	 (append 
	  (normal-top-level-add-to-load-path '("."))
	  (normal-top-level-add-subdirs-to-load-path))
	 load-path)))

;; 起動時のサイズ、表示位置設定
;(setq default-frame-alist
;      (append (list '(width . 80)
;		    '(height . 39))
;	      default-frame-alist))
(cond ((mac?)
       (setq initial-frame-alist
	     (append (list '(width . 200) '(height . 60)
			   '(top . 0) '(left . 0))
		     initial-frame-alist))
       (setq default-frame-alist initial-frame-alist)))

;; find-file のデフォルトディレクトリを設定
(cond ((mac?)
       (setq default-directory "~/")
       (setq command-line-default-directory "~/")))

;; 日本語フォント設定
(cond ((mac?)
       (set-face-attribute 'default nil :family "Monaco" :height 140)))
(cond ((mac?)
       (if (mac-gui?)
       	   (set-fontset-font nil 'japanese-jisx0208
       			     (font-spec
       			      :family "Hiragino Kaku Gothic ProN"))))
       ;; (set-fontset-font nil 'japanese-jisx0208
       ;; 			 (font-spec
       ;; 			  :family "Hiragino Kaku Gothic ProN")))
      ((linux?)
       (set-fontset-font nil 'japanese-jisx0208
			 (font-spec
			  :family "Takaoゴシック"))
       (setq face-font-rescale-alist
	     (append '((".*Takaoゴシック*." . 1.1))
		     face-font-rescale-alist))))

;; 行番号と列番号の表示
(line-number-mode t)
(column-number-mode t)

;; ツールバー(アイコンが並んでいる)とメニューバー(文字が並んでいる)の非表示
;; (if (mac-gui?)
;;     (progn (tool-bar-mode 0)
;; 	   (menu-bar-mode 0)))
(if (mac-gui?)
    (tool-bar-mode 0))
;; (tool-bar-mode 0)
(menu-bar-mode 0)

;; change (yes/no) to (y/n)
(fset 'yes-or-no-p 'y-or-n-p)

;; YaTeX-mode

(defconst my-main-typesetter "latexmk -pdf")
(defconst my-sub-typesetter "latexmk")

(setq auto-mode-alist
      (cons (cons "\\.tex$" 'yatex-mode) auto-mode-alist))
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
(setq tex-command my-main-typesetter)  ;; タイプセッタ設定
(cond ((linux?)  ;; プレビューア設定
       (setq dvi2-command "evince"))
      ((mac?)
       (setq dvi2-command "open -a Preview")))
(setq YaTeX-no-begend-shortcut t)  ;; [prefix] b で補完入力
;(add-hook 'yatex-mode-hook 'turn-on-reftex)  ;; RefTeX-mode

;; C-c p で別のタイプセッタを使う (compile を呼ぶ)
;; 遅い
(defun YaTeX-another-typeset ()
  compile)
(defun my-yatex-mode-init ()
  (setq compile-command my-sub-typesetter))
(require 'yatexlib)
(require 'yatex)
(YaTeX-define-key "p" 'compile)
(add-hook 'yatex-mode-hook 'my-yatex-mode-init)
(cond ((mac?)
       (setenv "PATH"
	       (concat "/usr/texbin:" (getenv "PATH")))
       (setq exec-path
	     (cons "/usr/texbin" exec-path))))

;; popwin-mode
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)
(require 'popwin-yatex)  ;; popwin for YaTeX
  ;; force buffers in a popup window
(push '("*YaTeX-typesetting*" :height 8 :position bottom :noselect f)
      popwin:special-display-config)
(push '("*dvi-preview*" :height 4 :position bottom :noselect t)
      popwin:special-display-config)
(push '("*asy-compilation*" :height 8 :position bottom :noselect t)
      popwin:special-display-config)
(push '("*Backtrace*" :height 8 :position bottom :noselect t)
      popwin:special-display-config)
(push '("*haskell*" :width 70 :position right :noselect t)
      popwin:special-display-config)
(push '("*compilation*" :height 8 :position bottom :noselect f)
      popwin:special-display-config)
(global-set-key (kbd "C-z") popwin:keymap)

;; Aspell
;(setq-default ispell-program-name "aspell")
;(eval-after-load "ispell"
;  '(add-to-list 'ispell-skip-region-alist '("[^\000-\377]+")))

;; DocView-mode
(setq doc-view-continuous t)
(add-hook 'doc-view-mode-hook 'auto-revert-mode)

;; wdired (writable dired)
(require 'dired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)

;; Haskell-mode
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(cond ((mac?)
       (require 'haskell-mode)
       (add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode))
       (require 'inf-haskell)))

;; Graphviz-dot-mode
(autoload 'graphviz-dot-mode "graphviz-dot-mode" "Graphviz dot mode" t)
(setq auto-mode-alist
      (cons (cons "\\.dot$" 'graphviz-dot-mode) auto-mode-alist))
(setq graphviz-dot-indent-width 2)
(setq graphviz-dot-auto-indent-on-semi nil)

;; compile-command
(setq compilation-read-command nil)
(setq compilation-ask-about-save nil)
