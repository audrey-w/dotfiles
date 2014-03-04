(defvar ostype nil)
(cond ((string-match "linux" system-configuration)  ;; Linux
       (setq ostype 'linux))
      ((string-match "apple-darwin" system-configuration)  ;; Mac
       (setq ostype 'mac)))

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
(cond ((eq ostype 'mac)
       nil))

;; フォント設定
(cond ((eq ostype 'mac)
       nil))

;; 行番号と列番号の表示
(line-number-mode t)
(column-number-mode t)

;; YaTeX-mode
(setq auto-mode-alist
      (cons (cons "\\.tex$" 'yatex-mode) auto-mode-alist))
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
(setq tex-command "latexmk"  ;; タイプセッタ設定
      dvi2-command "evince")  ;; プレビューア設定
(setq YaTeX-no-begend-shortcut t)  ;; [prefix] b で補完入力
;(add-hook 'yatex-mode-hook 'turn-on-reftex)  ;; RefTeX-mode

;; popwin-mode
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)
(require 'popwin-yatex)  ;; popwin for YaTeX
(push '("*YaTeX-typesetting*" :height 8 :position bottom :noselect f) popwin:special-display-config)  ;; force *YaTeX-typesetting* in a popup window
(push '("*dvi-preview*" :height 4 :position bottom :noselect t) popwin:special-display-config)  ;; force *dvi-preview* in a popup window
(push '("*asy-compilation*" :height 8 :position bottom :noselect t) popwin:special-display-config)  ;; force *asy-compilation* in a popup window
(push '("*Backtrace*" :height 8 :position bottom :noselect t) popwin:special-display-config)  ;; force *Backtrace* in a popup window
(global-set-key (kbd "C-z") popwin:keymap)

;; Aspell
;(setq-default ispell-program-name "aspell")
;(eval-after-load "ispell"
;  '(add-to-list 'ispell-skip-region-alist '("[^\000-\377]+")))

;; change (yes/no) to (y/n)
(fset 'yes-or-no-p 'y-or-n-p)
