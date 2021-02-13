;;;###autoload
(defun execute-in-shell (shell function)
  "Change `shell-file-name' to SHELL and execute FUNCTION then switch back the `shell-file-name'"
  (let ((shell-file-name shell))
    (funcall function)))

;;;###autoload
(defun evaluate-elisp-expression (input)
  "Evaluate lisp expression, either string or list as input. Results are concatinated with double ampersand."
  (cond ((stringp input)
         (evaluate-elisp-expression-string input))
        ((listp input)
         (mapconcat 'evaluate-elisp-expression-string input " && "))
        (t
         (error
          "Invalid input to evaluate-elisp-expression: Input not a list or string"))))

(defun evaluate-elisp-expression-string (string)
  "Locate all places with \"{}\" in the STRING and evaluate it as elisp and replace its value with the original value in the string"
  (let ((expressions (get-all-elisp-expressions-from-string string)))
    (seq-do
     (lambda (expression)
       (let* ((elisp-value (eval (read (format "%s" (substring expression 1 (- (length expression) 1)))))))
         (setq string (replace-regexp-in-string (regexp-quote expression) (evaluate-elisp-expression elisp-value) string))))
     expressions))
  string)

(defvar lisp-expression-finder-regexp
  "{\\(.+?\\)}"
  "Regular expression for how to decide what is to be interpreted as elisp.")

(defun get-all-elisp-expressions-from-string (command)
  (save-match-data
    (let ((pos 0) matches)
      (while (string-match lisp-expression-finder-regexp command pos)
        (push (match-string 0 command) matches)
        (setq pos (match-end 0)))
      matches)))

(provide 'execution-utils)
