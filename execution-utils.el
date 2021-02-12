;;;###autoload
(defun execute-in-shell (shell function)) 
  "Change `shell-file-name' to SHELL and exexute FUNCTION then switch back the `shell-file-name'"
  (let ((old-shell-file-name shell-file-name)
         output)
    (setq-default shell-file-name shell) 
    (setq output (funcall function)) 
    (setq-default shell-file-name old-shell-file-name)
    output))
