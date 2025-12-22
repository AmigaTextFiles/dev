;;;;======================================================================
;;;; quik-fix.el (v1.0) by Patrick Fitzgerald
;;;; for GNU emacs (18.58, Amiga port 1.25DG)
;;;;======================================================================


;;;
;;; Config
;;;

(setq quik-fix-buffer-name "*QuikFix*")

; Set this to t and work backward for best results
(setq quik-fix-backward nil)



;;
;; quik-fix-start
;;
;; Loads the file "AxtecC.Err"
;; and finds the first (or last) error
;;
(defun quik-fix-start (directory)
  (get-buffer-create quik-fix-buffer-name)
  (switch-to-buffer quik-fix-buffer-name)
  (erase-buffer)
  (setq default-directory directory)
  (insert-file "AztecC.Err")

  (if quik-fix-backward ; Go to the first error
      (quik-fix-last)
    (quik-fix-first)))


;;
;; quik-fix-recompile
;;
(defun quik-fix-recompile ()
  (interactive)
  (save-some-buffers)
  (amiga-arexx-send-command "address QuikFix 'RECOMPILE'" t)
)


;;
;; quik-fix-stop
;;
(defun quik-fix-stop ()
  (interactive)
  (save-some-buffers)
  (amiga-arexx-send-command "address QuikFix 'STOP'" t)
)


;;
;; quik-fix-first
;;
(defun quik-fix-first ()
  (interactive)

  (switch-to-buffer quik-fix-buffer-name)
  (goto-char (point-min))
  (quik-fix-do-line))


;;
;; quik-fix-last
;;
(defun quik-fix-last ()
  (interactive)

  (switch-to-buffer quik-fix-buffer-name)
  (goto-char (point-max))
  (forward-line -1)
  (quik-fix-do-line))


;;
;; quik-fix-next
;;
(defun quik-fix-next ()
  (interactive)

  (switch-to-buffer quik-fix-buffer-name)
  (forward-line 1)
  (quik-fix-do-line))


;;
;; quik-fix-previous
;;
(defun quik-fix-previous ()
  (interactive)

  (switch-to-buffer quik-fix-buffer-name)
  (forward-line -1)
  (quik-fix-do-line))


;;
;; quik-fix-current
;;
(defun quik-fix-current ()
  (interactive)

  (switch-to-buffer quik-fix-buffer-name)
  (quik-fix-do-line))




;;
;; quik-fix-get-line
;;
(defun quik-fix-do-line ()
  (beginning-of-line)

  ; Format of line:
  ; str>int:int:char:int:str:

  (if (re-search-forward "^\\(.*\\)>\\(.*\\):\\(.*\\):\\(.*\\):\\(.*\\):\\(.*\\):" nil t)
      (let ((file (buffer-substring (match-beginning 1) (match-end 1)))
	    (line (string-to-int (buffer-substring (match-beginning 2) (match-end 2))))
	    (col  (string-to-int (buffer-substring (match-beginning 3) (match-end 3))))
	    (ew   (buffer-substring (match-beginning 4) (match-end 4)))
	    (code (buffer-substring (match-beginning 5) (match-end 5)))
	    (msg  (buffer-substring (match-beginning 6) (match-end 6))))
	(find-file file)
	(goto-line line)
	(goto-char (+ (point) col))
	(message (concat ew "(" code "):" msg)))
    (progn (beep)
	   (message "quik-fix: cannot find error"))))
