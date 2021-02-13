;;;###autoload
(defun execute-in-shell (shell function)
  "Change `shell-file-name' to SHELL and execute FUNCTION then switch back the `shell-file-name'"
  (let ((shell-file-name shell))
    (funcall function)))
