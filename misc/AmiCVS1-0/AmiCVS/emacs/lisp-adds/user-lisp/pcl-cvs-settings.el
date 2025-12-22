(autoload 'cvs-update "pcl-cvs"
	  "Run a 'cvs update' in the current working directory. Feed the
output to a *cvs* buffer and run cvs-mode on it.
If optional prefix argument LOCAL is non-nil, 'cvs update -l' is run."
	  t)

;;; *** redefinition of system specific variables ***
(setq cvs-program		"GNU:AmiCVS/bin/cvs")
(setq cvs-diff-program		"rcs:bin/diff")
(setq cvs-rm-program		"c:delete")
(setq cvs-shell			"bin:sh")
(setq cvs-tempdir		"T:")


;;; *** some support functions ***
(defvar cvs-header-file (expand-file-name "CVSROOT:CVSheaders/")
  "File name to load cvs header.")

(defun cvs-insert-header (&optional file)
  "Inserts a cvs header from FILE to top of the current buffer.
If FILE is nil, you are ask for a file name"
  (interactive)
  (if (null file)
      (setq file
	    (read-file-name "Load cvs header from file: " 
			    cvs-header-file
			    cvs-header-file t)))
  (setq cvs-header-file file)
  (goto-char (point-min))
  (insert-file cvs-header-file))


;;; *** global key bindings to simplify invocation of cvs
(global-set-key "\C-cu" 'cvs-update)
(global-set-key "\C-ci" 'cvs-insert-header)
