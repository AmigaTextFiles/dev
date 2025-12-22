;;
;;  FILE
;;      fetchrefs.el    $VER: V1.00 fetchrefs.el
;;
;;  DESCRIPTION
;;      Script for integrating the 'FetchRefs' Utility, used for getting 
;;      quick online help for Autodocs and Includes, into EMACS 18.59.
;;      FetchRefs is written by Anders Melchiorsen and can be found on
;;      Aminet in 'dev/misc'.
;;
;;  FEATURES
;;      The main function to call is 'fetch-get-keyword', which fetches
;;      the word underneath the cursor (similar to find-tag call).
;;      'fetch-stop' stops 'FetchRefs'.
;;      Automatic invocation of 'FetchRefs' if 'FETCHREFS' ARexx port
;;      not found. Reference text is placed in a seperate buffer named
;;      *reference*. The text transfer is realised through the clipboard
;;      with (amiga-paste) so the text is also in the kill-ring and can
;;      be accessed through 'yank' or 'yank-pop'.
;;       
;;
;;  INSTALLATION
;;      Copy this file to a lisp-directory, for example Gnuemacs:lisp
;;
;;      Edit the following:
;;         (defconst fetch-index-file < "YOUR FETCHREFS INDEX FILE" >)
;;         
;;      Note: you may have several index files delimited by blanks.
;;      Make sure 'FetchRefs' is in your path, or edit
;;         (defconst fetch-run-command ...)
;;
;;      Put something like the following lines in your s:.emacs file
;;
;;       (autoload 'fetch-get-keyword "fetchrefs.el" nil t)
;;       (define-key global-map "\C-x\C-^1~" 'fetch-get-keyword) /* F2 */
;;       (define-key global-map "\C-x\C-^11~" 'fetch-stop)     /* SHIFT F2 */
;;
;;
;;
;;  This program is free software; you may redistribute it and/or modify it.
;;
;;  HOW TO CONTACT ME:
;;      email:   uhay@rz.uni-karlsruhe.de
;;      mail:    David Luebbren
;;               Zaehringerstr. 18
;;               76131 Karlsruhe
;;               Germany
;;


(defconst fetch-index-file "s:FetchRefs.index"
  "FetchRefs Index files")

(defconst fetch-run-command "Run FetchRefs"
  "Command to invoke 'FetchRefs'")

(defvar fetch-started nil
  "If t, FetchRefs is up and running.")

(defun fetch-running-p ()
  "True if FetchRefs ready to execute commands"
  (if (eq fetch-started nil)
      (fetch-start))
  (eq fetch-started t))

(defun fetch-get-keyword (keyword)
  "Find documentation for KEYWORD and place in buffer in other window."
  (interactive (find-tag-tag "Find Reference: "))
  (if (eq (fetch-running-p) t)
      (progn
       (setq tagname keyword)
       (setq tagname (fetch-filter-tags tagname))
       (let ((gotoline (fetch-find-keyword tagname)))
	 (if (not (eq gotoline nil))
	     (progn
	       (setq doc-buf (get-buffer "*references*"))
	       (if (bufferp doc-buf)
		   (kill-buffer doc-buf))
	       (setq doc-buf (get-buffer-create "*references*"))
	       (switch-to-buffer-other-window doc-buf)
	       (insert (amiga-paste))
	       (beginning-of-buffer)
	       (goto-line gotoline)
	       (not-modified)
	       (message "")))))
    (message "Unable to start FetchRefs")))

(defun fetch-filter-tags (keyword)
  "If keyword ends in either 'TagList', 'Tags', or 'A', return 
with end truncated"
  (setq len (length keyword))
  (cond ((and 
	  (> len 7) 
	  (string-equal "TagList" (substring keyword (- len 7) len)))
	 (substring keyword 0 (- len 7)))
	((and 
	  (> len 4) 
	  (string-equal "Tags" (substring keyword (- len 4) len)))
	 (substring keyword 0 (- len 4)))
	((and 
	  (> len 1) 
	  (string-equal "A" (substring keyword (- len 1) len)))
	 (substring keyword 0 (- len 1)))
	(keyword)))

(defun find-tag-tag (string)
  (let* ((default (find-tag-default))
	 (spec (read-string
		(if default
		    (format "%s(default %s) " string default)
		  string))))
    (list (if (equal spec "")
	      default
	    spec))))

(defun find-tag-default ()
  (save-excursion
    (while (looking-at "\\sw\\|\\s_")
      (forward-char 1))
    (if (re-search-backward "\\sw\\|\\s_" nil t)
	(progn (forward-char 1)
	       (buffer-substring (point)
				 (progn (forward-sexp -1)
					(while (looking-at "\\s'")
					  (forward-char 1))
					(point))))
      nil)))

(defun fetch-start ()
  "Try to run FetchRefs"
  (if (not (eq (fetch-check-port) 0))
      (progn
	(message " - Starting 'FetchRefs'") 
	(if (> (fetch-arexx-command 
		(concat "address command '"
			fetch-run-command
			" FILES "
			fetch-index-file
			"';return rc")) 0)
	    (message "Error executing 'FetchRefs'")
	  (if (eq (fetch-arexx-command 
		   "address command 'WaitForPort FETCHREFS';return rc") 0)
	      (setq fetch-started t)
	    (message "Could not find FETCHREFS port"))
	  (setq fetch-started t)))
    (setq fetch-started t)))

(defun fetch-stop ()
  "Terminate FetchRefs"
  (interactive)
  (if (eq fetch-started t)
      (if (not (eq (fetch-arexx-command 
		    "address FETCHREFS FR_QUIT;return rc") 0))
	  (message "Error trying to quit FetchRefs")
	(setq fetch-started nil))))

(defun fetch-check-port ()
  "Check if FetchRefs Port is set up"
  (fetch-arexx-command 
   "if show('Ports', 'FETCHREFS') then return 0;else return 1"))

(defun fetch-arexx-command (command)
  "Send a command to arexx and return rc"
  (string-to-int (amiga-arexx-do-command 
		  (concat "options results;" command) t)))

(defun fetch-find-keyword (keyword)
  "Awkward means of determining return value of arexx call"
  (setq ret (amiga-arexx-do-command
	     (concat "options results;"
		     "address 'FETCHREFS' 'FR_GET' '"
		     keyword
		     "(%|Tags|TagList|A)' "
		     "CLIP0 FILEREF;"
		     "return rc2") t))
  (let ((first (string-to-char ret)))
    (if (and (> first 47) (< first 58))
	(string-to-int ret)
      (progn
	(message ret)
	nil))))
  
