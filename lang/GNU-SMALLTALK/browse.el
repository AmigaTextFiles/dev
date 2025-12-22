;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Copyright (C) 1988, 1989, 1990 Free Software Foundation, Inc.
;;; Written by Steve Byrne.
;;;
;;; This file is part of GNU Smalltalk.
;;;
;;; GNU Smalltalk is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by the Free
;;; Software Foundation; either version 1, or (at your option) any later 
;;; version.
;;;
;;; GNU Smalltalk is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
;;; or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
;;; for more details.
;;;
;;; You should have received a copy of the GNU General Public License along
;;; with GNU Smalltalk; see the file COPYING.  If not, write to the Free
;;; Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(provide 'browse)

(defvar smalltalk-indicator "=>"
  "Used to mark the selected class or method when browsing")


(defvar smalltalk-br-mode-map nil "Local keymap for smalltalk-br-mode buffers.")


(if smalltalk-br-mode-map
    nil
  (setq smalltalk-br-mode-map (make-keymap))
  (suppress-keymap smalltalk-br-mode-map)
  (define-key smalltalk-br-mode-map " "  'smalltalk-br-browse-def))

;; Smalltalk-Br mode is suitable only for specially formatted data.
(put 'smalltalk-br-mode 'mode-class 'special)

(defun smalltalk-br-mode (func vec)
  "Mode for browsing Smalltalk \"collections\"
\\{smalltalk-br-mode-map}"
  (interactive)
  (kill-all-local-variables)    
  (setq major-mode 'smalltalk-br-mode)
  (setq mode-name "ST Browse")
  (setq indent-tabs-mode nil)
  (make-local-variable 'smalltalk-br-func)
  (setq smalltalk-br-func func)
  (make-local-variable 'smalltalk-br-vector)
  (setq smalltalk-br-vector vec)
;;  (setq mode-line-buffer-identification '("Smalltalk-Br: %17b"))
  (setq buffer-read-only t)
  (use-local-map smalltalk-br-mode-map)
  (run-hooks 'smalltalk-br-mode-hook))

(defun smalltalk-hier-br-mode (vec)
  "Mode for browsing Smalltalk hierarchy
\\{smalltalk-br-mode-map}"
  (interactive)
  (let (map)
    (kill-all-local-variables)    
    (setq major-mode 'smalltalk-br-mode
	  mode-name "Hier Browse"
	  buffer-read-only t
	  truncate-lines t
	  indent-tabs-mode nil
	  )
    (make-local-variable 'smalltalk-br-func)
    (setq smalltalk-br-func 'smalltalk-br-selected)
    (make-local-variable 'smalltalk-br-vector)
    (make-local-variable 'smalltalk-prev-indicator)
    (setq smalltalk-br-vector vec)
    (setq map (copy-keymap smalltalk-br-mode-map))
    ;; old def'n
    ;(define-key map " "  'smalltalk-arrow-br-browse-def)
    (define-key map " "  'smalltalk-browse-all-methods)
    (define-key map "d"  'smalltalk-browse-direct-methods)
    (define-key map "i"  'smalltalk-browse-indirect-methods)
    (define-key map "c"  'smalltalk-browse-class-methods)
    (use-local-map map)
    (delete-other-windows)
    (run-hooks 'smalltalk-br-mode-hook)
    )
  )

(defun smalltalk-method-br-mode (vec)
  "Mode for browsing Smalltalk hierarchy
\\{smalltalk-br-mode-map}"
  (interactive)
  (let (map)
    (kill-all-local-variables)    
    (setq major-mode 'smalltalk-br-mode
	  mode-name "Method Browse"
	  buffer-read-only t
	  truncate-lines t
	  )
    (make-local-variable 'smalltalk-br-func)
    (setq smalltalk-br-func 'test-func)
    (make-local-variable 'smalltalk-br-vector)
    (setq smalltalk-br-vector vec)
    (make-local-variable 'smalltalk-prev-indicator)
    (setq smalltalk-prev-indicator nil)	;in case we reused this buffer
    (setq map (copy-keymap smalltalk-br-mode-map))
    (define-key map " "  'smalltalk-arrow-br-browse-def)
    (use-local-map map)
    (run-hooks 'smalltalk-br-mode-hook)
    )
  )

(defun smalltalk-browse (name func sortp list)
  ;; eventually sortp will be nil, t, or sort function
  (let (buf vec (len (length list)))
    (setq buf (current-buffer))
    (switch-to-buffer (get-buffer-create name))
    (setq buffer-read-only nil)
    (erase-buffer)			;in case we reused the buffer
    (and sortp
	 (setq list
	       (sort list (function (lambda (x y)
				      (string-lessp (car x) (car y))))))
	 )
    (setq vec
	  (apply 'vector
		 (mapcar
		  (function (lambda (x)
			      (cond ((consp x)
				     (insert (car x))
				     (newline)
				     (cdr x))
				    (t
				   (insert x)
				   (newline)
				   x)
				  )
			      ))
		  list)
		 ))
    (goto-char (point-min))
    (smalltalk-br-mode func vec)
    (set-buffer buf)
;;    (switch-to-buffer buf)
;;    (switch-to-buffer-other-window buf)
;;    (other-window 1)
    )
  )

(defun smalltalk-method-browse (buf-name list)
  ;; eventually sortp will be nil, t, or sort function
  (let (buf vec (len (length list)))
    (setq buf (current-buffer))
    (pop-to-buffer (get-buffer-create buf-name))
    (setq buffer-read-only nil)
    (erase-buffer)			;in case we reused the buffer
    (setq indent-tabs-mode nil)
    (setq list
	  (sort list (function (lambda (x y)
				 (string-lessp (car x) (car y))))))
    (setq vec
	  (apply 'vector
		 (mapcar
		  (function (lambda (x)
			      (cond ((consp x)
				     (insert "   " (car x))
				     (newline)
				     (cdr x))
				    (t
				   (insert "   " x)
				   (newline)
				   x)
				  )
			      ))
		  list)
		 ))
    (goto-char (point-min))
    (smalltalk-method-br-mode vec)
;;    (set-buffer buf)
;;    (switch-to-buffer buf)
;;    (switch-to-buffer-other-window buf)
;;    (other-window 1)
    )
  )

(defun smalltalk-hier-browser (list)
  ;; list is this way instead of &rest so that we don't need tons of quotes
  (let (buf vec (len (length list)))
    (setq buf (current-buffer))
    (switch-to-buffer (get-buffer-create "ST Hierarchy"))
    (setq buffer-read-only nil)
    (setq indent-tabs-mode nil)
    (erase-buffer)			;in case we reused the buffer
    (setq vec
	  (apply 'vector
		 (mapcar
		  (function (lambda (x)
			      (indent-to (+ (* (cdr x) 2) 3))
			      (insert (car x))
			      (newline)
			      (car x)
			      ))
		  list)
		 ))
    (goto-char (point-min))
    (smalltalk-hier-br-mode vec)
;; this line removed to try to fix the char gobbling bug
;;    (set-buffer buf)
;;    (switch-to-buffer buf)
;;    (switch-to-buffer-other-window buf)
;;    (other-window 1)
    )
  )

(defun smalltalk-br-browse-def ()
  (interactive)
  (let (line)
    (save-restriction
      (widen)
      (save-excursion
	(beginning-of-line)
	(setq line (count-lines 1 (point)))
	)
      )
    (funcall smalltalk-br-func (aref smalltalk-br-vector line))
    )
  )

(defun smalltalk-arrow-br-browse-def (arg)
  (interactive "p")
  (let (line)
    (save-restriction
      (widen)
      (save-excursion
	(beginning-of-line)
	(smalltalk-set-indicator)
	(setq line (count-lines 1 (point)))
	)
      )
    (funcall smalltalk-br-func (aref smalltalk-br-vector line) arg)
    )
  )

(defun smalltalk-browse-direct-methods (arg)
  (interactive "p")
  (let (line)
    (setq line (smalltalk-prepare-method-browsing "*Direct Methods*"))
;	(smalltalk-show-direct-class-methods class-name)
    (smalltalk-show-direct-instance-methods (aref smalltalk-br-vector line))
    )
  )

(defun smalltalk-browse-all-methods (arg)
  (interactive "p")
  (let (line)
    (setq line (smalltalk-prepare-method-browsing "*All Methods*"))
;	(smalltalk-show-direct-class-methods class-name)
    (smalltalk-show-all-instance-methods (aref smalltalk-br-vector line))
    )
  )

(defun smalltalk-browse-indirect-methods (arg)
  (interactive "p")
  (let (line)
    (setq line (smalltalk-prepare-method-browsing "*Indirect Methods*"))
;	(smalltalk-show-direct-class-methods class-name)
    (smalltalk-show-indirect-instance-methods (aref smalltalk-br-vector line))
    )
  )

(defun smalltalk-browse-class-methods (arg)
  (interactive "p")
  (let (line)
    (setq line (smalltalk-prepare-method-browsing "*Direct Class Methods*"))
    (smalltalk-show-direct-class-methods (aref smalltalk-br-vector line))
    )
  )

(defun smalltalk-prepare-method-browsing (buf-name)
  (let (line buf cur-buf)
    (setq cur-buf (current-buffer))
    (beginning-of-line)
    (smalltalk-set-indicator)
    (setq line (count-lines 1 (point)))
    (setq buf (get-buffer-create buf-name))
    (delete-other-windows)
    (split-window-vertically)
    (split-window-horizontally)
    (other-window 1)
    (switch-to-buffer buf)
    (let ((buffer-read-only nil))
      (erase-buffer))
    (other-window -1)
    line)
  )

(defun smalltalk-set-indicator ()
  (let ((buffer-read-only nil))
    (save-excursion
      (and smalltalk-prev-indicator
	   (save-excursion
	     (goto-char smalltalk-prev-indicator)
	     (smalltalk-replace-chars
	      (make-string (length smalltalk-indicator) ? ))
	     )
	   )
      (setq smalltalk-prev-indicator (point))
      (smalltalk-replace-chars smalltalk-indicator)
      )
    )
  )

(defun smalltalk-replace-chars (str)
  (delete-char (length str))
  (insert str))


(defun smalltalk-br-selected (class-name arg)
  (let (buf is-meta)
    (setq is-meta (/= arg 1))
    (setq buf (get-buffer-create (if is-meta "*Class Methods*" "*Methods*")))
    (delete-other-windows)
    (split-window-vertically)
    (split-window-horizontally)
    (other-window 1)
    (switch-to-buffer buf)
    (let ((buffer-read-only nil))
      (erase-buffer))
    (if is-meta
	(smalltalk-show-direct-class-methods class-name)
      (smalltalk-show-direct-instance-methods class-name)
      )
    )
  )
    
    


;(smalltalk-browse
; "zoneball"
; 'test-func
; '(("foo:" . "bar")
;   ("quem:" . "zoneball")
;   ("ducks:" . "inARow"))
; )
