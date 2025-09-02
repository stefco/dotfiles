;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "DejaVu Sans Mono" :size 13 :weight 'normal))
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-theme 'doom-one)
;(setq doom-theme 'doom-earl-grey)
(setq doom-theme 'modus-operandi)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)
;;(setq display-line-numbers-type relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; STEF CUSTOM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; MOUSE KEYBINDINGS

(defun stef/at-cursor (func)
    "Return a lambda that moves cursor to the mouse location and executes func"
    (lambda (event)
        (interactive "e")
        (mouse-set-point event)
        (funcall func event)))    ;; Execute the  command

(defun stef/bind-key (key func)
    "Bind a function to a key globally and in evil editing modes"
    (global-set-key (kbd key) func)
    (define-key evil-insert-state-map (kbd key) func)
    (define-key evil-normal-state-map (kbd key) func)
    (define-key evil-replace-state-map (kbd key) func))

;; Fwd/back
(global-set-key (kbd "<mouse-8>") 'better-jumper-jump-backward)         ; back button
(global-set-key (kbd "<mouse-9>") 'better-jumper-jump-forward)          ; fwd button

;; Middle-click lookup def
;(defun stef-mouse-lookup-def (event)
;  "Move cursor to the mouse location and execute +lookup/definition."
;  (interactive "e")
;  (mouse-set-point event)  ;; Move cursor to mouse location
;  (+lookup/definition event))    ;; Execute the +lookup/definition command

;(global-set-key (kbd "<mouse-2>") 'stef-mouse-lookup-def)
;(define-key evil-insert-state-map (kbd "<mouse-2>") 'stef-mouse-lookup-def)
;(define-key evil-normal-state-map (kbd "<mouse-2>") 'stef-mouse-lookup-def)
;(define-key evil-replace-state-map (kbd "<mouse-2>") 'stef-mouse-lookup-def)

;; Code navigation
(stef/bind-key "<mouse-2>" (stef/at-cursor '+lookup/definition))        ; middle click
(stef/bind-key "S-<mouse-2>" (stef/at-cursor '+lookup/references))      ; shift-middle click
(stef/bind-key "M-<mouse-2>" (stef/at-cursor '+lookup/implementations)) ; meta-middle click
(stef/bind-key "S-<mouse-3>" (stef/at-cursor '+lookup/type-definition)); shift-right click


;(global-set-key (kbd "<mouse-3>") '+lookup/references)                  ; right click
;(global-set-key (kbd "S-<mouse-2>") '+lookup/implementations)           ; shift-middle click
;(global-set-key (kbd "S-<mouse-3>") '+lookup/type-definition)           ; shift-right click

;; COPILOT
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("S-<tab>" . 'copilot-clear-overlay)
              ("S-TAB" . 'copilot-clear-overlay)
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))

;; ELDOC DOCUMENTATION TRUNCATION
(setq lsp-eldoc-render-all t)
(setq resize-mini-windows t)
;; maybe needed?
;(setq tooltip-resize-echo-area t)
;(setq temp-buffer-resize-mode nil)
;(vertico-resize nil)
;(resize-mini-frames t)
;(setq eldoc-echo-area-use-multiline-p t)
;(setq max-mini-window-height 10)

;; WGSL (WebGPU Shader Language) LSP SUPPORT
(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-language-id-configuration '(wgsl-mode . "wgsl"))
  (lsp-register-client (make-lsp-client :new-connection (lsp-stdio-connection "wgsl_analyzer")
                                        :activation-fn (lsp-activate-on "wgsl")
                                        :server-id 'wgsl_analyzer)))

;; COMPILATION MODE
;; TESTING
;; Add NodeJS error format
;; From https://web.archive.org/web/20230405065942/https://benhollis.net/blog/2015/12/20/nodejs-stack-traces-in-emacs-compilation-mode/
;; and https://emacs.stackexchange.com/questions/59628/adding-a-pattern-to-compilation-error-regexp-alist
(after! compile
  (add-to-list 'compilation-error-regexp-alist-alist
               '(node "^[  ]+at \\(?:[^\(\n]+ \(\\)?\\([a-zA-Z\.0-9_/-]+\\):\\([0-9]+\\):\\([0-9]+\\)\)?$"
                 1 ;; file
                 2 ;; line
                 3 ;; column
                 ))
  (add-to-list 'compilation-error-regexp-alist 'node))

;; Add pattern match for a bare file path
(after! compile
  (add-to-list 'compilation-error-regexp-alist-alist
               '(bare-path
                 "^\\(/[^:]+\\):\\([0-9]+\\)\\(?::\\([0-9]+\\)\\)?$"
                 1 2 3))
  (add-to-list 'compilation-error-regexp-alist 'bare-path))

;; MINOR MODE
;; Javascript/Typescript
;; RUN TESTS
;; Helper: Read node version from package.json (adjust the filename if needed)
(defun my/get-node-version-from-package ()
  "Return the node version string from the project’s package.json.
Expects package.json to have an \"engines\" object with a \"node\" field."
  (let* ((proj-root (projectile-project-root))
         (lock-file (expand-file-name "package.json" proj-root)))
    (unless (file-exists-p lock-file)
      (user-error "No package.json found in project root"))
    (with-temp-buffer
      (insert-file-contents lock-file)
      (let* ((json-object-type 'hash-table)
             (json-array-type 'list)
             (json-key-type 'string)
             (data (json-read-from-string (buffer-string)))
             (engines (gethash "engines" data)))
        (unless engines
          (user-error "No 'engines' field found in package.json"))
        (or (gethash "node" engines)
            (user-error "No 'node' field in engines in package.json"))))))

;; Helper: Compute the npm path using the node version from package.json.
(defun my/npm-path-from-node-version ()
  "Return the full path to the npm executable for the node version in
package.json. This assumes that NVM installs node versions under
~/.nvm/versions/node/v<VERSION>/bin/npm."
  (let ((node-ver (my/get-node-version-from-package)))
    (expand-file-name (format "~/.nvm/versions/node/v%s/bin/npm" node-ver))))

;; Command 1: Run tests for the current file.
(defun my/npm-run-test-current-file ()
  "Run npm test for the current file.
Uses the npm executable determined from package.json.
The command is:
  <npm-path> run test -- <relative-file-path>"
  (interactive)
  (let* ((proj-root (projectile-project-root))
         (rel-file (file-relative-name (buffer-file-name) proj-root))
         (default-directory proj-root)
         (npm (my/npm-path-from-node-version))
         (cmd (format "pwd -P && %s run test -- %s" npm rel-file)))
    (let ((compilation-scroll-output t))
      (compile cmd))))

;; Command 2: Run tests for the current file, filtering for the symbol at point.
(defun my/npm-run-test-current-function ()
  "Run npm test for the current file, filtering by the symbol at point.
The command is:
  <npm-path> run test -- <relative-file-path> --grep <symbol>"
  (interactive)
  (let* ((proj-root (projectile-project-root))
         (rel-file (file-relative-name (buffer-file-name) proj-root))
         (sym (thing-at-point 'symbol t)))
    (unless sym
      (user-error "No symbol found at point"))
    (let* ((default-directory proj-root)
           (npm (my/npm-path-from-node-version))
           (cmd (format "pwd -P && %s run test -- %s --grep %s" npm rel-file sym)))
      (let ((compilation-scroll-output t))
        (compile cmd)))))

;; Command 3: Run the entire test suite for the project.
(defun my/npm-run-test-project ()
  "Run the full npm test suite for the project.
Uses the npm executable determined from package.json."
  (interactive)
  (let* ((proj-root (projectile-project-root))
         (default-directory proj-root)
         (npm (my/npm-path-from-node-version))
         (cmd (format "pwd -P && %s run test" npm)))
    (compile cmd)))

;; Keybindings using Doom’s local leader (SPC m)
;; Maps:
;;   SPC m t f  → test current file
;;   SPC m t h  → test with grep for symbol at point (e.g. the current test)
;;   SPC m t t  → run the full test suite
;(map! :leader
;      "m t f" #'my/npm-run-test-current-file
;      "m t h" #'my/npm-run-test-current-function
;      "m t t" #'my/npm-run-test-project)
(after! js2-mode
  (map! :map js2-mode-map
        :localleader
        (:prefix ("t" . "npm test")
          :desc "Run test for current file" "f" #'my/npm-run-test-current-file
          :desc "Run test for symbol at point" "h" #'my/npm-run-test-current-function
          :desc "Run project tests" "t" #'my/npm-run-test-project)))

(after! typescript-mode
  (map! :map typescript-mode-map
        :localleader
        (:prefix ("t" . "npm test")
          :desc "Run test for current file" "f" #'my/npm-run-test-current-file
          :desc "Run test for symbol at point" "h" #'my/npm-run-test-current-function
          :desc "Run project tests" "t" #'my/npm-run-test-project)))

;; USE UNIX LINE ENDINGS EVERYWHERE
(setq-default buffer-file-coding-system 'unix)

;; CC LSP
(after! lsp-clangd
  (setq lsp-clients-clangd-args
        '("-j=3"
          "--background-index"
          "--clang-tidy"
          "--completion-style=detailed"
          "--header-insertion=never"
          "--header-insertion-decorators=0"))
  (set-lsp-priority! 'clangd 2))
