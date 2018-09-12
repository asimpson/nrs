;;; nrs.el --- An ivy function to list and execute npm scripts. -*- lexical-binding: t; -*-

;; Adam Simpson <adam@adamsimpson.net>
;; Version: 0.2.0
;; Package-Requires: ((ivy "9.0"))
;; Keywords: npm

;;; Code:
(require 'json)
(require 'ivy)

;;;###autoload
(defun nrs()
  "List all npm scripts via Ivy.  Default aciton is to run the script."
  (interactive)
  (let* ((file (or (dired-file-name-at-point) (buffer-file-name)))
         (scripts (alist-get 'scripts (json-read-file (concat (locate-dominating-file file ".git") "package.json"))))
         (collection (mapcar (lambda(script) (list (concat (symbol-name (car script)) ": " (cdr script)) :script (symbol-name (car script)) :command (cdr script))) scripts)))
    (ivy-read "npm run: " collection :action (lambda(script) (async-shell-command (concat "npm run " (plist-get (cdr script) :script)))))))

(ivy-set-actions 'nrs
                 '(("c" (lambda(script) (kill-new (plist-get (cdr script) :command))) "Copy command")
                   ("p" (lambda(script) (let ((cmd (read-string "Run: " (plist-get (cdr script) :command))))
                                     (async-shell-command cmd))) "Prompt")))

(provide 'nrs)

;;; nrs.el ends here
