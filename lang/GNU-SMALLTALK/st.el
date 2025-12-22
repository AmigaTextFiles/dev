;;;
;;; Smalltalk mode for Gnu Emacs
;;;

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

(require 'browse)
(provide 'st)

(defvar smalltalk-name-regexp "[A-Za-z][A-Za-z0-9]*"
  "A regular expression that matches a Smalltalk identifier")

(defvar smalltalk-keyword-regexp (concat smalltalk-name-regexp ":")
  "A regular expression that matches a Smalltalk keyword")

(defvar smalltalk-name-chars "a-zA-Z0-9"
  "The collection of character that can compose a Smalltalk identifier")

(defvar smalltalk-whitespace " \t\n\f")

(defvar smalltalk-mode-abbrev-table nil
  "Abbrev table in use in smalltalk-mode buffers.")
(define-abbrev-table 'smalltalk-mode-abbrev-table ())

(defvar smalltalk-c-style-tab t
  "Non-nil means that tab reindents, M-tab tabs to next tab stop.
Nil has the opposite effect.  Examined only when loading. ")

;;; this hack was to play around with adding Smalltalk-specific menu items
;;; to the Emacstool on the Sun.
(if (featurep 'sun-mouse)
    (let (new-menu i)
      (defmenu smalltalk-menu
	("Smalltalk")
	("Do it"))
      (setq new-menu (make-vector (1+ (length emacs-menu)) nil))
      (aset new-menu 0 (aref emacs-menu 0))
      (setq i 1)
      (while (< i (length emacs-menu))
	(aset new-menu (1+ i) (aref emacs-menu i))
	(setq i (1+ i)))
      (aset new-menu 1 '("Smalltalk" . smalltalk-menu))
      (setq emacs-menu new-menu)
      )
  )

(defvar smalltalk-mode-map nil "Keymap used in Smalltalk mode.")
(if smalltalk-mode-map
    ()
  (setq smalltalk-mode-map (make-sparse-keymap))
  (if smalltalk-c-style-tab
      (progn
	(define-key smalltalk-mode-map "\M-\t" 'smalltalk-tab)
	(define-key smalltalk-mode-map "\t"	'smalltalk-reindent)
	)
    (define-key smalltalk-mode-map "\t" 'smalltalk-tab)
    (define-key smalltalk-mode-map "\M-\t"	'smalltalk-reindent)
    )
  (define-key smalltalk-mode-map "\177" 'backward-delete-char-untabify)
  (define-key smalltalk-mode-map "\n" 'smalltalk-newline-and-indent)
  (define-key smalltalk-mode-map "\C-\M-a" 'smalltalk-begin-of-defun)
  (define-key smalltalk-mode-map "\C-\M-f" 'smalltalk-forward-sexp)
  (define-key smalltalk-mode-map "\C-\M-b" 'smalltalk-backward-sexp)
  (define-key smalltalk-mode-map "!" 	'smalltalk-bang)
  (define-key smalltalk-mode-map ":"	'smalltalk-colon)
  )

(defvar smalltalk-mode-syntax-table nil
  "Syntax table in use in smalltalk-mode buffers.")

(if smalltalk-mode-syntax-table
    ()
  (setq smalltalk-mode-syntax-table (make-syntax-table))
  (modify-syntax-entry ?\' "\"" smalltalk-mode-syntax-table)
  ;; GNU Emacs is deficient: there seems to be no way to have a comment char
  ;; that is both the start and end character.  This is going to cause
  ;; me great pain.
  (modify-syntax-entry ?\" "\"" smalltalk-mode-syntax-table)
  (modify-syntax-entry ?+ "." smalltalk-mode-syntax-table)
  (modify-syntax-entry ?- "." smalltalk-mode-syntax-table)
  (modify-syntax-entry ?* "." smalltalk-mode-syntax-table)
  (modify-syntax-entry ?/ "." smalltalk-mode-syntax-table)
  (modify-syntax-entry ?= "." smalltalk-mode-syntax-table)
  (modify-syntax-entry ?% "." smalltalk-mode-syntax-table)
  (modify-syntax-entry ?< "." smalltalk-mode-syntax-table)
  (modify-syntax-entry ?> "." smalltalk-mode-syntax-table)
  (modify-syntax-entry ?& "." smalltalk-mode-syntax-table)
  (modify-syntax-entry ?$ "\\" smalltalk-mode-syntax-table)
  (modify-syntax-entry ?# "'" smalltalk-mode-syntax-table)
  (modify-syntax-entry ?| "." smalltalk-mode-syntax-table)
  (modify-syntax-entry ?_ "." smalltalk-mode-syntax-table)
  (modify-syntax-entry ?\\ "." smalltalk-mode-syntax-table)
  (modify-syntax-entry ?! "." smalltalk-mode-syntax-table)
  )

(defconst smalltalk-indent-amount 4
  "*'Tab size'; used for simple indentation alignment.")

(autoload 'smalltalk-install-change-log-functions "st-changelog.el")
;;(autoload 'smalltalk-install-change-log-functions "~/mst/st-changelog.el")

(defun stm ()
  (smalltalk-mode))

(defun smalltalk-mode ()
  "Major mode for editing Smalltalk code.
Comments are delimited with \" ... \".
Paragraphs are separated by blank lines only.
Delete converts tabs to spaces as it moves back.

Of special interest are the commands for interacting with a live Smalltalk
session:
\\[mst]
    Invoke the Smalltalk interactor, which basically keeps the current buffer
    in one window, and creates another window with a running Smalltalk in it.
    The other window behaves essentially like a shell-mode window when the
    cursor is in it, but it will receive the operations requested when the
    interactor related commands are used.

\\[smalltalk-doit]
    interactively evaluate the expression that the cursor is in in a Smalltalk
    mode window, or with an argument execute the region as smalltalk code

\\[smalltalk-compile]
    compile the method definition that the cursor is currently in.

\\[smalltalk-snapshot]
    produce a snapshot binary image of the current working Smalltalk system.
    Useful to do periodically as you define new methods to save the state of
    your work.

\\{smalltalk-mode-map}

Turning on Smalltalk mode calls the value of the variable
smalltalk-mode-hook with no args, if that value is non-nil."
  (interactive)
  (kill-all-local-variables)
  (use-local-map smalltalk-mode-map)
  (setq major-mode 'smalltalk-mode)
  (setq mode-name "Smalltalk")
  (setq local-abbrev-table smalltalk-mode-abbrev-table)
  (set-syntax-table smalltalk-mode-syntax-table)
  (make-local-variable 'paragraph-start)
  (setq paragraph-start (concat "^$\\|" page-delimiter))
  (make-local-variable 'paragraph-separate)
  (setq paragraph-separate paragraph-start)
  (make-local-variable 'paragraph-ignore-fill-prefix)
  (setq paragraph-ignore-fill-prefix t)
  (make-local-variable 'indent-line-function)
  (setq indent-line-function 'smalltalk-indent-line)
  (make-local-variable 'require-final-newline)
  (setq require-final-newline t)
  (make-local-variable 'comment-start)
  (setq comment-start "\"")
  (make-local-variable 'comment-end)
  (setq comment-end "\"")
  (make-local-variable 'comment-column)
  (setq comment-column 32)
  (make-local-variable 'comment-start-skip)
  (setq comment-start-skip "\" *")
  (make-local-variable 'comment-indent-hook)
  (setq comment-indent-hook 'smalltalk-comment-indent)
  (make-local-variable 'parse-sexp-ignore-comments)
  (setq parse-sexp-ignore-comments nil)	;for interactive f-b sexp
  (smalltalk-install-change-log-functions)
  (run-hooks 'smalltalk-mode-hook))

;; This is used by indent-for-comment
;; to decide how much to indent a comment in Smalltalk code
;; based on its context.
(defun smalltalk-comment-indent ()
  (if (looking-at "^\"")
      0				;Existing comment at bol stays there.
    (save-excursion
      (skip-chars-backward " \t")
      (max (1+ (current-column))	;Else indent at comment column
	   comment-column))))	; except leave at least one space.

(defun smalltalk-indent-line ()
  (let (indent-amount is-keyword)
    (save-excursion
      (beginning-of-line)
      (smalltalk-forward-whitespace)
      (if (looking-at "[a-zA-Z][a-zA-Z0-9]*:") ;indent for colon
	  (let ((parse-sexp-ignore-comments t))
	    (beginning-of-line)
	    (smalltalk-backward-whitespace)
	    (if (not (memq (preceding-char) '(?\;)))
		(setq is-keyword t)
	      )
	    )
	)
      )
    (if is-keyword
	(smalltalk-indent-for-colon)
      (setq indent-amount (calculate-smalltalk-indent))
      (smalltalk-indent-to-column indent-amount)
      )
    )
  )

(defun calculate-smalltalk-indent ()
  (let (needs-indent indent-amount done c state start-of-line
		     (parse-sexp-ignore-comments t))
    (save-excursion
      (save-restriction
	(widen)
	(narrow-to-region (point-min) (point)) ;only care about what's before
	(setq state (parse-partial-sexp (point-min) (point)))
	(cond ((equal (nth 3 state) ?\") ;in a comment
	       (save-excursion
		 (smalltalk-backward-comment)
		 (setq indent-amount (1+ (current-column)))
		 ))
	      ((equal (nth 3 state) ?')	;in a string
	       (setq indent-amount 0))
	      (t
	       (save-excursion
		 (smalltalk-backward-whitespace)
		 (if (or (bobp)
			 (= (preceding-char) ?!))
		     (setq indent-amount 0))
		 )
	       ))
	(if (null indent-amount)
	    (progn
	      (smalltalk-narrow-to-method)
	      (beginning-of-line)
	      (setq state (parse-partial-sexp (point-min) (point)))
	      (narrow-to-paren state)
	      (smalltalk-backward-whitespace)
	      (cond ((bobp)		;must be first statment in block or exp
		     (if (nth 1 state)	;we're in a paren exp
			 (setq indent-amount (smalltalk-current-column))
		       ;; we're top level
		       (setq indent-amount smalltalk-indent-amount)))
		    ((= (preceding-char) ?.) ;at end of statement
		     (smalltalk-find-statement-begin)
		     (setq indent-amount (smalltalk-current-column)))
		    ((= (preceding-char) ?:)
		     (beginning-of-line)
		     (smalltalk-forward-whitespace)
		     (setq indent-amount (+ (smalltalk-current-column)
					    smalltalk-indent-amount))
		     )
		    ((= (preceding-char) ?>) ;maybe <primitive: xxx>
		     (setq orig (point))
		     (backward-char 1)
		     (smalltalk-backward-whitespace)
		     (skip-chars-backward "0-9")
		     (smalltalk-backward-whitespace)
		     (if (= (preceding-char) ?:)
			 (progn
			   (backward-char 1)
			   (skip-chars-backward "a-zA-Z")
			   (if (looking-at "primitive:")
			       (progn
				 (smalltalk-backward-whitespace)
				 (if (= (preceding-char) ?<)
				     (setq indent-amount (1- (smalltalk-current-column))))
				 )
			     )
			   )
		       )
		     (if (null indent-amount)
			 (progn
			   (goto-char orig)
			   (smalltalk-find-statement-begin)
			   (setq indent-amount (+ (smalltalk-current-column)
						  smalltalk-indent-amount))
			   )
		       )
		     )
		    (t			;must be a statement continuation
		     (save-excursion
		       (beginning-of-line)
		       (setq start-of-line (point)))
		     (smalltalk-find-statement-begin)
		     (setq indent-amount (+ (smalltalk-current-column)
					    smalltalk-indent-amount))
		     )
		    )
	      )
	  )
	indent-amount)
      )
    )
  )


(defun smalltalk-previous-nonblank-line ()
  (forward-line -1)
  (while (and (not (bobp))
	      (looking-at "^[ \t]*$"))
    (forward-line -1))
  )

(defun smalltalk-tab ()
  (interactive)
  (let (col)
    ;; round up, with overflow
    (setq col (* (/ (+ (current-column) smalltalk-indent-amount)
		    smalltalk-indent-amount)
		 smalltalk-indent-amount))
    (indent-to-column col)
  ))

(defun smalltalk-begin-of-defun ()
  "Skips to the beginning of the current method.  If already at
the beginning of a method, skips to the beginning of the previous
one."
  (interactive)
  (let ((parse-sexp-ignore-comments t) here delim start)
    (setq here (point))
    (while (and (search-backward "!" nil 'to-end)
		(setq delim (smalltalk-in-string)))
      (search-backward delim))
    (setq start (point))
    (if (looking-at "!")
	(forward-char 1))
    (smalltalk-forward-whitespace)
    ;; check to see if we were already at the start of a method
    ;; in which case, the semantics are to go to the one preceeding
    ;; this one
    (if (and (= here (point))
	     (/= start (point-min)))
	(progn
	  (goto-char start)
	  (smalltalk-backward-whitespace) ;may be at ! "foo" !
	  (if (= (preceding-char) ?!)
	      (backward-char 1))
	  (smalltalk-begin-of-defun)	;and go to the next one
	  )
      )
    )
  )

(defun smalltalk-in-string ()
  "Returns non-nil delimiter as a string if the current location is
actually inside a string or string like context."
  (let (state)
    (setq state (parse-partial-sexp (point-min) (point)))
    (and (nth 3 state)
	 (char-to-string (nth 3 state)))
    )
  )



(defun smalltalk-forward-whitespace ()
  "Skip white space and comments forward, stopping at end of buffer
or non-white space, non-comment character"
  (while (looking-at (concat "[" smalltalk-whitespace "\"]"))
    (skip-chars-forward smalltalk-whitespace)
    (if (= (following-char) ?\")
	(forward-sexp 1)))
  )

(defun smalltalk-backward-whitespace ()
  "Like forward whitespace only going towards the start of the buffer"
  (while (progn (skip-chars-backward smalltalk-whitespace)
		(= (preceding-char) ?\"))
    (backward-sexp 1))
  )

(defun smalltalk-forward-sexp (n)
  (interactive "p")
  (let (i)
    (cond ((< n 0)
	   (smalltalk-backward-sexp (- n)))
	  ((null parse-sexp-ignore-comments)
	   (forward-sexp n))
	  (t
	   (while (> n 0)
	     (smalltalk-forward-whitespace)
	     (forward-sexp 1)
	     (setq n (1- n))
	     )
	   )
	  )
    )
  )

(defun smalltalk-backward-sexp (n)
  (interactive "p")
  (let (i)
    (cond ((< n 0)
	   (smalltalk-forward-sexp (- n)))
	  ((null parse-sexp-ignore-comments)
	   (backward-sexp n))
	  (t
	   (while (> n 0)
	     (smalltalk-backward-whitespace)
	     (backward-sexp 1)
	     (setq n (1- n))
	     )
	  )))
  )

(defun smalltalk-reindent ()
  (interactive)
  ;; +++ Still loses if at first charcter on line
  (smalltalk-indent-line)
;  (let ((pos (- (point-max) (point))))
;    (beginning-of-line)
;    (delete-horizontal-space)
;    (delete-char -1)
;    (smalltalk-newline-and-indent 1)
;    (goto-char (- (point-max) pos))
;    (if (looking-at "[\t ]*$")
;	(end-of-line))
;    )
  )

(defun smalltalk-newline-and-indent (levels)
  "Called basically to do newline and indent.  Sees if the current line is a
new statement, in which case the indentation is the same as the previous
statement (if there is one), or is determined by context; or, if the current
line is not the start of a new statement, in which case the start of the
previous line is used, except if that is the start of a new line in which case
it indents by smalltalk-indent-amount."
  (interactive "p")
  (newline)
  (smalltalk-indent-line)
  )

;;;(defun smalltalk-newline-and-indent (levels)
;;;  "Called basically to do newline and indent.  Sees if the current line is a
;;;new statement, in which case the indentation is the same as the previous
;;;statement (if there is one), or is determined by context; or, if the current
;;;line is not the start of a new statement, in which case the start of the
;;;previous line is used, except if that is the start of a new line in which case
;;;it indents by smalltalk-indent-amount."
;;;  (interactive "p")
;;;  (let (needs-indent indent-amount done c state start-of-line
;;;		     (parse-sexp-ignore-comments t))
;;;    (save-excursion
;;;      (save-restriction
;;;	(save-excursion
;;;	  (smalltalk-backward-whitespace)
;;;	  (if (or (bobp)
;;;		  (= (preceding-char) ?!))
;;;	      (setq indent-amount 0))
;;;	  )
;;;	(if (null indent-amount)
;;;	    (progn
;;;	      (smalltalk-narrow-to-method)
;;;	      (setq state (parse-partial-sexp (point-min) (point)))
;;;	      (if (nth 3 state)		;in a string or comment
;;;		  (cond ((= (nth 3 state) ?\") ;in a comment
;;;			 (save-excursion
;;;			   (smalltalk-backward-comment)
;;;			   (setq indent-amount (1+ (current-column)))
;;;			   ))
;;;			((= (nth 3 state) ?')	;in a string
;;;			 (setq indent-amount 0))
;;;			)
;;;		(narrow-to-paren state)
;;;		(smalltalk-backward-whitespace)
;;;		(cond ((bobp)			;must be first statment in block or exp
;;;		       (if (nth 1 state)	;we're in a paren exp
;;;			   (setq indent-amount (smalltalk-current-column))
;;;			 ;; we're top level
;;;			 (setq indent-amount smalltalk-indent-amount)))
;;;		      ((= (preceding-char) ?.) ;at end of statement
;;;		       (smalltalk-find-statement-begin)
;;;		       (setq indent-amount (smalltalk-current-column)))
;;;		      ((= (preceding-char) ?:)
;;;		       (beginning-of-line)
;;;		       (smalltalk-forward-whitespace)
;;;		       (setq indent-amount (+ (smalltalk-current-column)
;;;					      smalltalk-indent-amount))
;;;		       )
;;;		      ((= (preceding-char) ?>) ;maybe <primitive: xxx>
;;;		       (setq orig (point))
;;;		       (backward-char 1)
;;;		       (smalltalk-backward-whitespace)
;;;		       (skip-chars-backward "0-9")
;;;		       (smalltalk-backward-whitespace)
;;;		       (if (= (preceding-char) ?:)
;;;			   (progn
;;;			     (backward-char 1)
;;;			     (skip-chars-backward "a-zA-Z")
;;;			     (if (looking-at "primitive:")
;;;				 (progn
;;;				   (smalltalk-backward-whitespace)
;;;				   (if (= (preceding-char) ?<)
;;;				       (setq indent-amount (1- (smalltalk-current-column))))
;;;				   )
;;;			       )
;;;			     )
;;;			 )
;;;		       (if (null indent-amount)
;;;			   (progn
;;;			     (goto-char orig)
;;;			     (smalltalk-find-statement-begin)
;;;			     (setq indent-amount (+ (smalltalk-current-column)
;;;						      smalltalk-indent-amount))
;;;			     )
;;;			 )
;;;		       )
;;;		      (t			;must be a statement continuation
;;;		       (save-excursion
;;;			 (beginning-of-line)
;;;			 (setq start-of-line (point)))
;;;		       (smalltalk-find-statement-begin)
;;;		       (setq indent-amount (+ (smalltalk-current-column)
;;;					      smalltalk-indent-amount))
;;;		       )
;;;		      )
;;;		)
;;;	      ))
;;;	)
;;;      )
;;;    (newline)
;;;    (delete-horizontal-space)		;remove any carried-along whites
;;;    (indent-to indent-amount)
;;;    (if (looking-at "[a-zA-Z][a-zA-Z0-9]*:") ;indent for colon
;;;	(save-excursion
;;;	  (goto-char (1- (match-end 0)))
;;;	  (smalltalk-indent-for-colon))
;;;	)
;;;    ))

(defun smalltalk-current-column ()
  "Returns the current column of the given line, regardless of narrowed buffer."
  (save-restriction
    (widen)
    (current-column)			;this changed in 18.56
    )
  )

(defun smalltalk-find-statement-begin ()
  "Leaves the point at the first non-blank, non-comment character of a new
statement.  If begininning of buffer is reached, then the point is left there.
This routine only will return with the point pointing at the first non-blank
on a line; it won't be fooled by multiple statements on a line into stopping
prematurely.  Also, goes to start of method if we started in the method
selector."
  (let (start ch)
    (if (= (preceding-char) ?.)		;if we start at eos
	(backward-char 1))		;we find the begin of THAT stmt
    (while (and (null start) (not (bobp)))
      (smalltalk-backward-whitespace)
      (cond ((= (setq ch (preceding-char)) ?.)
	     (let (saved-point)
	       (setq saved-point (point))
	       (smalltalk-forward-whitespace)
	       (if (smalltalk-white-to-bolp)
		   (setq start (point))
		 (goto-char saved-point)
		 (smalltalk-backward-sexp 1))
	       ))
	    ((= ch ?^)			;HACK -- presuming that when we back
					;up into a return that we're at the
					;start of a statement
	     (backward-char 1)
	     (setq start (point))
	     )
	    ((= ch ?!)
	     (smalltalk-forward-whitespace)
	     (setq start (point))
	     )
	    (t
	     (smalltalk-backward-sexp 1)
	     )
	    )
      )
    (if (null start)
      (progn
	(goto-char (point-min))
	(smalltalk-forward-whitespace)
	(setq start (point))))
  start))


;;; hold on to this code for a little bit, but then flush it
;;;
;;;	  ;; not in a comment, so skip backwards for some indication
;;;	  (smalltalk-backward-whitespace)
;;;	  (if (bobp)
;;;	      (setq indent-amount smalltalk-indent-amount)
;;;	    (setq c (preceding-char))
;;;	    (cond ((eq c ?.)		;this is a new statement
;;;		   (smalltalk-backward-statement)
;;;		   (setq indent-amount (current-column)))
;;;		  ((memq c '(?|
;;;
;;;			     (smalltalk-narrow-to-method)
;;;
;;;			     (smalltalk-backward-whitespace)
;;;			     (setq c (preceding-char))
;;;			     (cond
;;;			      ((memq c '(?. ?| ?\[ ?\( )) (setq done t))
;;;			      ((eq c ?:)
;;;			       (backward-char 1)
;;;			       (skip-chars-backward "a-zA-Z0-9")
;;;			       (setq indent-amount (current-column)))
;;;			      (t
;;;			       (smalltalk-backward-sexp 1)))
;;;			     )
;;;
;;;			 )
;;;		   )
;;;		  (if indent-amount
;;;		      (save-excursion
;;;			(beginning-of-line)
;;;			(delete-horizontal-space)
;;;			(indent-to indent-amount))
;;;		    )
;;;		  (insert last-command-char)
;;;		  ))

(defun narrow-to-paren (state)
  "Narrows the region to between point and the closest previous open paren.
Actually, skips over any block parameters, and skips over the whitespace
following on the same line."
  (let ((paren-addr (nth 1 state))
	start c done)
    (if (not paren-addr) nil
      (save-excursion
	(goto-char paren-addr)
	(setq c (following-char))
	(cond ((eq c ?\()
	       (setq start (1+ (point))))
	      ((eq c ?\[)
	       (setq done nil)
	       (forward-char 1)
	       (while (not done)
		 (skip-chars-forward " \t")
		 (setq c (following-char))
		 (cond ((eq c ?:)
			(smalltalk-forward-sexp 1))
		       ((eq c ?|)
			(forward-char 1) ;skip vbar
			(skip-chars-forward " \t")
			(setq done t))	;and leave
		       (t
			(setq done t))
		       )
		 )
	       (setq start (point))
	       )
	      )
	)
      (narrow-to-region start (point))
      )
    )
  )


(defun smalltalk-at-method-begin ()
  "Returns T if at the beginning of a method definition, otherwise nil"
  (let ((parse-sexp-ignore-comments t))
    (if (bolp)
	(save-excursion
	  (smalltalk-backward-whitespace)
	  (= (preceding-char) ?!)
	  )
      )
    )
  )
	
  


(defun smalltalk-colon ()
  "Possibly reindents a line when a colon is typed.
If the colon appears on a keyword that's at the start of the line (ignoring
whitespace, of course), then the previous line is examined to see if there
is a colon on that line, in which case this colon should be aligned with the
left most character of that keyword.  This function is not fooled by nested
expressions."
  (interactive)
  (let (needs-indent (parse-sexp-ignore-comments t))
    (save-excursion
      (skip-chars-backward "A-Za-z0-9")
      (if (and (looking-at smalltalk-name-regexp)
	       (not (smalltalk-at-method-begin)))
	  (setq needs-indent (smalltalk-white-to-bolp))
	)
      )
    (and needs-indent
	 (smalltalk-indent-for-colon))
;; out temporarily
;;    (expand-abbrev)			;I don't think this is the "correct"
;;					;way to do this...I suspect that
;;					;some flavor of "call interactively"
;;					;is better.
    (self-insert-command 1)
    )
  )


(defun smalltalk-indent-for-colon ()
  (let (indent-amount c start-line state done default-amount
		     (parse-sexp-ignore-comments t))
    ;; we're called only for lines which look like "<whitespace>foo:"
    (save-excursion
      (save-restriction
	(widen)
	(smalltalk-narrow-to-method)
	(beginning-of-line)
	(setq state (parse-partial-sexp (point-min) (point)))
	(narrow-to-paren state)
	(narrow-to-region (point-min) (point))
	(setq start-line (point))
	(smalltalk-backward-whitespace)
	(cond
	 ((bobp)
	  (setq indent-amount (smalltalk-current-column)))
	 ((eq (setq c (preceding-char)) ?\;)	; cascade before, treat as stmt continuation
	  (smalltalk-find-statement-begin)
	  (setq indent-amount (+ (smalltalk-current-column)
				 smalltalk-indent-amount)))
	 ((eq c ?.)	; stmt end, indent like it (syntax error here?)
	  (smalltalk-find-statement-begin)
	  (setq indent-amount (smalltalk-current-column)))
	 (t				;could be a winner
	    (smalltalk-find-statement-begin)
	    ;; we know that since we weren't at bobp above after backing
	    ;; up over white space, and we didn't run into a ., we aren't
	    ;; at the beginning of a statement, so the default indentation
	    ;; is one level from statement begin
	    (setq default-amount
		  (+ (smalltalk-current-column) ;just in case
		     smalltalk-indent-amount))
	    ;; might be at the beginning of a method (the selector), decide
	    ;; this here
	    (if (not (looking-at smalltalk-keyword-regexp ))
		;; not a method selector
		(while (and (not done) (not (eobp)))
		  (smalltalk-forward-sexp 1) ;skip over receiver
		  (smalltalk-forward-whitespace)
		  (cond ((eq (following-char) ?\;)
			 (setq done t)
			 (setq indent-amount default-amount))
			((and (null indent-amount) ;pick up only first one
			      (looking-at smalltalk-keyword-regexp))
			 (setq indent-amount (smalltalk-current-column))
			 )
			) 
		  )
	      )
	    (and (null indent-amount)
		 (setq indent-amount default-amount))
	    )
	 )
	)
      )
    (if indent-amount
	(smalltalk-indent-to-column indent-amount))
    )
  )

(defun smalltalk-indent-to-column (col)
  (save-excursion
    (beginning-of-line)
    (delete-horizontal-space)
    (indent-to col)
    )
  (if (bolp)
      ;;delete horiz space may have moved us to bol instead of staying where
      ;; we were.  this fixes it up.
      (move-to-column col))
  )

(defun smalltalk-narrow-to-method ()
  "Narrows the buffer to the contents of the method, exclusive of the
method selector and temporaries."
  (let ((end (point))
	(parse-sexp-ignore-comments t)
	done handled)
    (save-excursion
      (smalltalk-begin-of-defun)
      (if (looking-at "[a-zA-z]")	;either unary or keyword msg
	  ;; or maybe an immediate expression...
	  (progn
	    (forward-sexp)
	    (if (= (following-char) ?:) ;keyword selector
		(progn			;parse full keyword selector
		  (backward-sexp 1)	;setup for common code
		  (smalltalk-forward-keyword-selector)
		  )
	      ;; else maybe just a unary selector or maybe not
	      ;; see if there's stuff following this guy on the same line
	      (let (here eol-point)
		(setq here (point))
		(end-of-line)
		(setq eol-point (point))
		(goto-char here)
		(smalltalk-forward-whitespace)
		(if (< (point) eol-point) ;if there is, we're not a method
					; (a heuristic guess)
		    (beginning-of-line)
		  (goto-char here)	;else we're a unary method (guess)
		  )
		)
	      )
	    )

	;; this must be a binary selector, or a temporary
	(if (= (following-char) ?|)
	    (progn			;could be temporary
	      (end-of-line)
	      (smalltalk-backward-whitespace)
	      (if (= (preceding-char) ?|)
		  (progn
		    (setq handled t))
		)
	      (beginning-of-line)
	      )
	  )
	(if (not handled)
	    (progn
	      (skip-chars-forward (concat "^" smalltalk-whitespace))
	      (smalltalk-forward-whitespace)
	      (skip-chars-forward smalltalk-name-chars)) ;skip over operand
	  )
	)
      (skip-chars-forward smalltalk-whitespace)
      (if (= (following-char) ?|)	;scan for temporaries
	  (progn
	    (forward-char)		;skip over |
	    (smalltalk-forward-whitespace)
	    (while (and (not (eobp))
			(looking-at "[a-zA-Z]"))
	      (skip-chars-forward smalltalk-name-chars)
	      (smalltalk-forward-whitespace)
	      )
	    (if (and (= (following-char) ?|) ;only if a matching | as a temp
		     (< (point) end))	;and we're after the temps
		(narrow-to-region (1+ (point)) end) ;do we limit the buffer
	      )
	    )
	;; added "and <..." Dec 29 1991 as a test
	(and (< (point) end)
	     (narrow-to-region (point) end))
	)
      )
    )
  )

(defun smalltalk-forward-keyword-selector ()
  "Starting on a keyword, this function skips forward over a keyword selector.
It is typically used to skip over the actual selector for a method."
  (let (done)
    (while (not done)
      (if (not (looking-at "[a-zA-Z]"))
	  (setq done t)
	(skip-chars-forward smalltalk-name-chars)
	(if (= (following-char) ?:)
	    (progn
	      (forward-char)
	      (smalltalk-forward-sexp 1)
	      (smalltalk-forward-whitespace))
	  (setq done t)
	  (backward-sexp 1))
	)
      )
    )
  )


(defun smalltalk-white-to-bolp ()
  "Returns T if from the current position to beginning of line is whitespace.
Whitespace is defined as spaces, tabs, and comments."
  (let (done is-white line-start-pos)
    (save-excursion
      (save-excursion
	(beginning-of-line)
	(setq line-start-pos (point)))
      (while (not done)
	(and (not (bolp))
	     (skip-chars-backward " \t"))
	(cond ((bolp)
	       (setq done t)
	       (setq is-white t))
	      ((= (char-after (1- (point))) ?\")
	       (backward-sexp)
	       (if (< (point) line-start-pos) ;comment is multi line
		   (setq done t)
		 )
	       )
	      (t
	       (setq done t))
	      )
	)
      is-white)
    ))


(defun smalltalk-bang ()
  (interactive)
  (insert "!")
  (save-excursion
    (beginning-of-line)
    (if (looking-at "^[ \t]+!")
	(delete-horizontal-space))
    )
  )


(defun smalltalk-backward-comment ()
  (search-backward "\"")		;find its start
  (while (= (preceding-char) ?\")	;skip over doubled ones
    (backward-char 1)
    (search-backward "\""))
  )


;;;(defun smalltalk-collect-selector ()
;;;  "Point is stationed inside or at the beginning of the selector in question.
;;;This function computes the Smalltalk selector (unary, binary, or keyword) and
;;;returns it as a string.  Point is not changed."
;;;  (save-excursion
;;;    (let (start selector done
;;;		(parse-sexp-ignore-comments t))
;;;      (skip-chars-backward (concat "^" "\"" smalltalk-whitespace))
;;;      (setq start (point))
;;;      (if (looking-at smalltalk-name-regexp)
;;;	  (progn			;maybe unary, maybe keyword
;;;	    (skip-chars-forward smalltalk-name-chars)
;;;	    (if (= (following-char) ?:)	;keyword?
;;;		(progn
;;;		  (forward-char 1)
;;;		  (setq selector (buffer-substring start (point)))
;;;		  (smalltalk-forward-sexp 1)
;;;		  (smalltalk-forward-whitespace)
;;;		  (while (not done)
;;;		    (if (not (looking-at smalltalk-name-regexp))
;;;			(setq done t)
;;;		      (setq start (point))
;;;		      (skip-chars-forward smalltalk-name-chars)
;;;		      (if (= (following-char) ?:)
;;;			  (progn
;;;			    (forward-char)
;;;			    (setq selector (concat selector
;;;						   (buffer-substring
;;;						    start (point))))
;;;			    (smalltalk-forward-sexp 1)
;;;			    (smalltalk-forward-whitespace))
;;;			(setq done t))
;;;		      )
;;;		    )
;;;		  )
;;;	      (setq selector (buffer-substring start (point)))
;;;	      )
;;;	    )
;;;	(skip-chars-forward (concat "^" ?\" smalltalk-whitespace))
;;;	(setq selector (buffer-substring start (point)))
;;;	)
;;;      selector
;;;      )
;;;    )
;;;  )

(defun smalltalk-collect-selector ()
  "Point is stationed inside or at the beginning of the selector in question.
This function computes the Smalltalk selector (unary, binary, or keyword) and
returns it as a string.  Point is not changed."
  (save-excursion
    (let (start selector done ch
		(parse-sexp-ignore-comments t))
      (skip-chars-backward (concat "^" "\"" smalltalk-whitespace))
      (setq start (point))
      (if (looking-at smalltalk-name-regexp)
	  (progn			;maybe unary, maybe keyword
	    (skip-chars-forward smalltalk-name-chars)
	    (if (= (following-char) ?:)	;keyword?
		(progn
		  (forward-char 1)
		  (setq selector (buffer-substring start (point)))
		  (setq start (point))
		  (while (not done)
		    (smalltalk-forward-whitespace)
		    (setq ch (following-char))
		    (cond ((memq ch '(?\; ?. ?\] ?\) ?! ))
			   (setq done t))
			  ((= ch ?:)
			   (forward-char 1)
			   (setq selector
				 (concat selector
					 (buffer-substring start (point))))
			   )
			  (t
			   (setq start (point))
			   (smalltalk-forward-sexp 1))
			  )
		    )
		  )
	      (setq selector (buffer-substring start (point)))
	      )
	    )
	(skip-chars-forward (concat "^" ?\" smalltalk-whitespace))
	(setq selector (buffer-substring start (point)))
	)
      selector
      )
    )
  )



(defun st-test ()			;just an experimental testing harness
  (interactive)
  (let (l end)
    (setq end (point))
    (beginning-of-defun)
    (setq l (parse-partial-sexp (point) end nil nil nil))
    (message "%s" (prin1-to-string l)) (read-char)
    (message "depth %s" (nth 1 l)) (goto-char (nth 1 l)) (read-char)
    (message "last sexp %s" (nth 2 l)) (goto-char (nth 2 l)) (read-char)
    (message "lstsx %s stp %s com %s quo %s pdep %s"
	     (nth 3 l)
	     (nth 4 l)
	     (nth 5 l)
	     (nth 6 l)
	     (nth 7 l))
    ))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; GNU Emacs Smalltalk interactor mode
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar *smalltalk-process* nil)
(defvar mst-args '("-Vp"))

(defvar smalltalk-classes
  nil "The set of class names...used for completion")

(defvar smalltalk-command-string nil
  "Non nil means that we're accumulating output from Smalltalk")

(define-key smalltalk-mode-map "\C-cc" 	'smalltalk-compile)
(define-key smalltalk-mode-map "\C-cd" 	'smalltalk-doit)
(define-key smalltalk-mode-map "\C-ce" 	'smalltalk-eval-region)
(define-key smalltalk-mode-map "\C-cf" 	'smalltalk-filein)
(define-key smalltalk-mode-map "\C-cm" 	'mst)
(define-key smalltalk-mode-map "\C-cp" 	'smalltalk-print)
(define-key smalltalk-mode-map "\C-cq" 	'smalltalk-quit)
(define-key smalltalk-mode-map "\C-cs" 	'smalltalk-snapshot)
(define-key smalltalk-mode-map "\C-c\C-s" 'smalltalk-browse-selectors)

;;; experimental
(define-key smalltalk-mode-map "\C-xc"	'smalltalk-complete-class)

(defvar smalltalk-ctl-b-map (make-keymap)
  "Keymap of subcommands of C-c C-b")
(fset 'smalltalk-ctl-b-prefix smalltalk-ctl-b-map)
(define-key smalltalk-mode-map "\C-c\C-b" 'smalltalk-ctl-b-prefix)
					;(define-key smalltalk-ctl-b-map "\C-i" 'smalltalk-show-implementors)
(define-key smalltalk-ctl-b-map "\C-c" 'smalltalk-show-class-methods)
(define-key smalltalk-ctl-b-map "\C-i" 'smalltalk-show-instance-methods)
(define-key smalltalk-ctl-b-map "\C-d" 'smalltalk-show-direct-instance-methods)
(define-key smalltalk-ctl-b-map "\C-h" 'smalltalk-browse-hierarchy)
(define-key smalltalk-ctl-b-map "\C-o" 'smalltalk-get-class-names)

					; who implements method
					; what methods does a class/instance have
					; something about the class hierarchy
					; like direct subclasses
					; all subclasses
					; all superclasses


(defvar smalltalk-ctl-t-map (make-keymap)
  "Keymap of subcommands of C-c C-t")
(fset 'smalltalk-ctl-t-prefix smalltalk-ctl-t-map)
(define-key smalltalk-mode-map "\C-c\C-t" 'smalltalk-ctl-t-prefix)
(define-key smalltalk-ctl-t-map "\C-d" 'smalltalk-toggle-decl-tracing)
(define-key smalltalk-ctl-t-map "\C-e" 'smalltalk-toggle-exec-tracing)
(define-key smalltalk-ctl-t-map "\C-v" 'smalltalk-toggle-verbose-exec-tracing)

(defvar smalltalk-interactor-mode-map nil "Keymap used in Smalltalk interactor mode.")
(if smalltalk-interactor-mode-map
    ()
  (setq smalltalk-interactor-mode-map (copy-keymap smalltalk-mode-map))
  (define-key smalltalk-interactor-mode-map "\C-m" 'shell-send-input)
  (define-key smalltalk-interactor-mode-map "\C-c\C-d" 'shell-send-eof)
  (define-key smalltalk-interactor-mode-map "\C-c\C-u" 'kill-shell-input)
  (define-key smalltalk-interactor-mode-map "\C-c\C-c" 'interrupt-shell-subjob)
  (define-key smalltalk-interactor-mode-map "\C-c\C-z" 'stop-shell-subjob)
  (define-key smalltalk-interactor-mode-map "\C-c\C-\\" 'quit-shell-subjob)
  (define-key smalltalk-interactor-mode-map "\C-c\C-o" 'kill-output-from-shell)
  (define-key smalltalk-interactor-mode-map "\C-c\C-r" 'show-output-from-shell)
  (define-key smalltalk-interactor-mode-map "\C-c\C-y" 'copy-last-shell-input)
  )




(defun mst (args)
  (interactive (list (if (null current-prefix-arg)
			 mst-args
		       (read-smalltalk-args))))
  (setq mst-args args)
  (if (not (eq major-mode 'mst-mode))
      (switch-to-buffer-other-window
       (apply 'make-mst "mst" mst-args))
    ;; invoked from a Smalltalk interactor window, so stay there
    (apply 'make-mst "mst" mst-args)
    )
  (setq *smalltalk-process* (get-buffer-process (current-buffer)))
  )

(defun read-smalltalk-args ()
  "Reads the arguments to pass to Smalltalk as a string, returns a list."
  (let (str args args-str result-args start end)
    (setq args mst-args)
    (setq args-str "")
    (while args
      (setq args-str (concat args-str " " (car args)))
      (setq args (cdr args))
      )
    (setq str (read-string "Invoke Smalltalk: " args-str))
    
    (while (setq start (string-match "[^ ]" str))
      (setq end (or (string-match " " str start) (length str)))
      (setq result-args (cons (substring str start end) result-args))
      (setq str (substring str end))
      )
    (reverse result-args)
    )
  )


(defun make-mst (name &rest switches)
  (let ((buffer (get-buffer-create (concat "*" name "*")))
	proc status size)
    (setq proc (get-buffer-process buffer))
    (if proc (setq status (process-status proc)))
    (save-excursion
      (set-buffer buffer)
      ;;    (setq size (buffer-size))
      (if (memq status '(run stop))
	  nil
	(if proc (delete-process proc))
	(setq proc (apply  'start-process
			   name buffer
			   (concat exec-directory "env")
			   ;; I'm choosing to leave these here
			   (format "TERMCAP=emacs:co#%d:tc=unknown:"
				   (screen-width))
			   "TERM=emacs"
			   "EMACS=t"
			   "-"
			   "mst"
			   switches))
	(setq name (process-name proc)))
      (goto-char (point-max))
      (set-marker (process-mark proc) (point))
      (set-process-filter proc 'mst-filter)
      (mst-mode))
    buffer))

(defun mst-filter (process string)
  "Make sure that the window continues to show the most recently output
text."
  (let (where ch command-str)
    (setq where 0)			;fake to get through the gate
    (while (and string where)
      (if smalltalk-command-string
	  (setq string (smalltalk-accum-command string)))
      (if (and string
	       (setq where (string-match "\C-a\\|\C-b" string)))
	  (progn
	    (setq ch (aref string where))
	    (cond ((= ch ?\C-a)		;strip these out
		   (setq string (concat (substring string 0 where)
					(substring string (1+ where)))))
		  ((= ch ?\C-b)		;start of command
		   (setq smalltalk-command-string "") ;start this off
		   (setq string (substring string (1+ where))))
		  )
	    )
	)
      )
    (save-excursion
      (set-buffer (process-buffer process))
      (goto-char (point-max))
      (and string
	   (setq mode-status "idle")
	   (insert string))
      (if (process-mark process)
	  (set-marker (process-mark process) (point-max)))
      )
    )
  ;;  (if (eq (process-buffer process)
  ;;	  (current-buffer))
  ;;      (goto-char (point-max)))
					;  (save-excursion
					;      (set-buffer (process-buffer process))
					;      (goto-char (point-max))
  ;;      (set-window-dot (get-buffer-window (current-buffer)) (point-max))
					;      (sit-for 0))
  (let ((buf (current-buffer)))
    (set-buffer (process-buffer process))
    (goto-char (point-max)) (sit-for 0)
    (set-window-dot (get-buffer-window (current-buffer)) (point-max))
    (set-buffer buf))
  )

(defun smalltalk-accum-command (string)
  (let (where)
    (setq where (string-match "\C-a" string))
    (setq smalltalk-command-string
	  (concat smalltalk-command-string (substring string 0 where)))
    (if where
	(progn
	  (unwind-protect		;found the delimiter...do it
	      (smalltalk-handle-command smalltalk-command-string)
	    (setq smalltalk-command-string nil))
	  ;; return the remainder
	  (substring string where))
      ;; we ate it all and didn't do anything with it
      nil)
    )
  )


(defun smalltalk-handle-command (str)
  (eval (read str))
  )


(defun mst-mode ()
  "Major mode for interacting Smalltalk subprocesses.

The following commands imitate the usual Unix interrupt and
editing control characters:
\\{smalltalk-mode-map}

Entry to this mode calls the value of mst-mode-hook with no arguments,
if that value is non-nil.  Likewise with the value of shell-mode-hook.
mst-mode-hook is called after shell-mode-hook."
  (interactive)
  (kill-all-local-variables)
  (require 'shell)
  (setq mode-line-format
	'("" mode-line-modified mode-line-buffer-identification "   "
	  global-mode-string "   %[(" mode-name ": " mode-status
	  "%n" mode-line-process ")%]----" (-3 . "%p") "-%-"))
  (setq major-mode 'mst-mode)
  (setq mode-name "Smalltalk")
  ;;  (setq mode-line-process '(": %s"))
  (use-local-map smalltalk-interactor-mode-map)
  (make-local-variable 'last-input-start)
  (setq last-input-start (make-marker))
  (make-local-variable 'last-input-end)
  (setq last-input-end (make-marker))
  (make-local-variable 'mode-status)
  (make-local-variable 'smalltalk-command-string)
  (setq smalltalk-command-string nil)
  (setq mode-status "starting-up")
  (run-hooks 'shell-mode-hook 'mst-mode-hook))



(defun smalltalk-eval-region (start end &optional label)
  "Evaluate START to END as a Smalltalk expression in Smalltalk window.
If the expression does not end with an exclamation point, one will be
added (at no charge)."
  (interactive "r")
  (let (str filename line pos)
    (setq str (buffer-substring start end))
    (save-excursion
      (save-restriction 
	(goto-char (max start end))
	(smalltalk-backward-whitespace)
	(if (/= (preceding-char) ?!)	;canonicalize
	    (setq str (concat str "!")))
	;; unrelated, but reusing save-excursion
	(goto-char (min start end))
	(setq pos (point))
	(setq filename (buffer-file-name))
	(widen)
	(setq line (1+ (count-lines 1 (point))))
	)
      )
    (send-to-smalltalk str (or label "eval")
		       (list line filename pos))
    )
  )

(defun smalltalk-doit (use-region)
  (interactive "P")
  (let (start end rgn)
    (if use-region
	(progn
	  (setq start (min (mark) (point)))
	  (setq end (max (mark) (point)))
	  )
      (setq rgn (smalltalk-bound-expr))
      (setq start (car rgn)
	    end (cdr rgn))
      )
    (smalltalk-eval-region start end "doIt")
    )
  )

(defun smalltalk-bound-expr ()
  "Returns a cons of the region of the buffer that contains a smalltalk expression.
It's pretty dumb right now...looks for a line that starts with ! at the end and
a non-white-space line at the beginning, but this should handle the typical
cases nicely."
  (let (start end here)
    (save-excursion
      (setq here (point))
      (re-search-forward "^!")
      (setq end (point))
      (beginning-of-line)
      (if (looking-at "^[^ \t\"]")
	  (progn
	    (goto-char here)
	    (re-search-backward "^[^ \t\"]")
	    (while (looking-at "^$") ;this is a hack to get around a bug
	      (re-search-backward "^[^ \t\"]") ;with GNU Emacs's regexp system
	      )
	    )
	)
      (setq start (point))
      (cons start end)
      )
    )
  )

(defun smalltalk-compile (use-region)
  (interactive "P")
  (let (str start end rgn filename line pos header classname category)
    (if use-region
	(progn
	  (setq start (min (point) (mark)))
	  (setq end (max (point) (mark)))
	  (setq str (buffer-substring start end))
	  (save-excursion
	    (goto-char end)
	    (smalltalk-backward-whitespace)
	    (if (/= (preceding-char) ?!) ;canonicalize
		(setq str (concat str "!")))
	    )
	  (send-to-smalltalk str "compile"))
      (setq rgn (smalltalk-bound-method))
      (setq str (buffer-substring (car rgn) (cdr rgn)))
      (setq filename (buffer-file-name))
      (setq pos (car rgn))
      (save-excursion
	(save-restriction
	  (widen)
	  (setq line (1+ (count-lines 1 (car rgn))))
	  )
	)
      (if (buffer-file-name)
	  (progn 
	    (save-excursion
	      (re-search-backward "^![ \t]*[A-Za-z]")
	      (setq start (point))
	      (forward-char 1)
	      (search-forward "!")
	      (setq end (point))
	      (setq line (- line (1- (count-lines start end))))
	      ;; extra -1 here to compensate for emacs positions being 1 based,
	      ;; and smalltalk's (really ftell & friends) being 0 based.
	      (setq pos (- pos (- end start) 1)))
	    (setq str (concat (buffer-substring start end) "\n\n" str "!"))
	    (send-to-smalltalk str "compile"
		       ;-2 accounts for num lines and num chars extra
			       (list (- line 2) filename (- pos 2)))
	    )
	(save-excursion
	  (re-search-backward "^!\\(.*\\) methodsFor: \\(.*\\)!")
	  (setq classname (buffer-substring
			   (match-beginning 1) (match-end 1)))
	  (setq category (buffer-substring
			  (match-beginning 2) (match-end 2)))
	  (goto-char (match-end 0))
	  (setq str (smalltalk-quote-strings str))
	  (setq str (format "%s compile: '%s' classified: %s!\n"
			    classname (substring str 0 -1) category))
	  (save-excursion (set-buffer (get-buffer-create "junk"))
			  (erase-buffer)
			  (insert str))
	  (send-to-smalltalk str "compile"
			     (list line nil 0))
	  )
		 
      )
    )
    )
  )


(defun smalltalk-bound-method ()
  (let (start end)
    (save-excursion
      (re-search-forward "^!")
      (setq end (point)))
    (save-excursion
      (re-search-backward "^[^ \t\"]")
      (while (looking-at "^$")		;this is a hack to get around a bug
	(re-search-backward "^[^ \t\"]");with GNU Emacs's regexp system
	)
      (setq start (point)))
    (cons start end))
  )


(defun smalltalk-quote-strings (str)
  (let (new-str)
    (save-excursion
      (set-buffer (get-buffer-create " st-dummy "))
      (erase-buffer)
      (insert str)
      (goto-char 1)
      (while (and (not (eobp))
		  (search-forward "'" nil 'to-end))
	(insert "'"))
      (buffer-string)
      )
    )
  )

(defun smalltalk-snapshot (&optional snapshot-name)
  (interactive (if current-prefix-arg
		   (list (setq snapshot-name (expand-file-name (read-file-name "Snapshot to: "))))))
  (if snapshot-name
      (send-to-smalltalk (format "Smalltalk snapshot: '%s'!" "Snapshot"))
  (send-to-smalltalk "Smalltalk snapshot!" "Snapshot"))
  )

(defun smalltalk-print (start end)
  (interactive "r")
  (let (str)
    (setq str (buffer-substring start end))
    (save-excursion
      (goto-char (max start end))
      (smalltalk-backward-whitespace)
      (if (= (preceding-char) ?!)	;canonicalize
	  (setq str (buffer-substring (min start end)  (point)))
	)
      (setq str (format "(%s) printNl!" str))
      (send-to-smalltalk str "print")
      )
    )
  )


(defun smalltalk-quit ()
  (interactive)
  (send-to-smalltalk "Smalltalk quitPrimitive!" "Quitting"))

(defun smalltalk-filein (filename)
  (interactive "fSmalltalk file to load: ")
  (send-to-smalltalk (format "FileStream fileIn: '%s'!"
			     (expand-file-name filename))
		     "fileIn")
  )

;(defun smalltalk-show-implementors ()
;  (interactive)
;  (let (method-name)
;    (save-excursion
;      )
;    (send-to-smalltalk (format "Browser whoImplements: #%s"
;			       method-name)
;		       "implementors")


(defun smalltalk-complete-class (name)
  (interactive (list (completing-read "Class: " smalltalk-class-names nil
				      t nil)))
  (message name) (sit-for 3)
  name
  )

(defun smalltalk-get-class-names ()
  (interactive)
  (send-to-smalltalk "Browser loadClassNames!" "ClassNames")
  )

(defun smalltalk-set-class-names (class-names)
  (let (sym-str)
    (setq smalltalk-class-names nil)
    (while class-names
      (setq sym-str (symbol-name (car class-names)))
      (setq smalltalk-class-names (cons (cons sym-str sym-str)
					smalltalk-class-names))
      (setq class-names (cdr class-names))
      )
    )
  )

(defun smalltalk-set-all-methods (method-names)
  (let (sym-str)
    (setq smalltalk-method-names nil)
    (while method-names
      (and (not (assoc (car method-names) smalltalk-method-names))
	   (setq smalltalk-method-names (cons (list (car method-names))
					      smalltalk-method-names)))
      (setq method-names (cdr method-names))
      )
    )
  )

(defun smalltalk-show-instance-methods (class-name)
  (interactive (smalltalk-complete-class-name))
   ;;(require 'browse)
  (send-to-smalltalk (format "Browser showMethods: %s for: 'instance'!"
			     class-name)
		     "ShowInstMethods")
  )

(defun smalltalk-generic-show-methods (class-name kind is-class)
  "IS-CLASS is either the empty string or the word 'Class'.  
Kind is one of 'Direct', 'Indirect', or 'All'"
  (require 'browse)
  (let ((class-selector (downcase is-class))
	(inst-or-class (if (= (length is-class) 0) "Inst" "Class"))
	(class-space (if (= (length is-class) 0) "" "Class "))
	)
    (send-to-smalltalk
     (format "Browser show%sMethods: %s %s inBuffer: '*%s %sMethods*'!"
	     kind class-name class-selector kind
	     class-space)
     (format "Show%sMethods" inst-or-class)
     )
    )
  )
  

(defun smalltalk-show-direct-class-methods (class-name)
  (interactive (smalltalk-complete-class-name))
  (smalltalk-generic-show-methods class-name "Direct" "Class")
  )

(defun smalltalk-show-indirect-class-methods (class-name)
  (interactive (smalltalk-complete-class-name))
  (smalltalk-generic-show-methods class-name "Indirect" "Class")
  )

(defun smalltalk-show-all-class-methods (class-name)
  (interactive (smalltalk-complete-class-name))
  (smalltalk-generic-show-methods class-name "All" "Class")
  )

(defun smalltalk-show-direct-instance-methods (class-name)
  (interactive (smalltalk-complete-class-name))
  (smalltalk-generic-show-methods class-name "Direct" "")
  )

(defun smalltalk-show-all-instance-methods (class-name)
  (interactive (smalltalk-complete-class-name))
  (smalltalk-generic-show-methods class-name "All" "")
  )

(defun smalltalk-show-indirect-instance-methods (class-name)
  (interactive (smalltalk-complete-class-name))
  (smalltalk-generic-show-methods class-name "Indirect" "")
  )

(defun smalltalk-show-class-methods (class-name)
  (interactive (smalltalk-complete-class-name))
  (require 'browse)
  (send-to-smalltalk (format "Browser showMethods: %s class
                                      for: 'class' !"
			     class-name)
		     "ShowClassMethods")
  )

(defun smalltalk-browse-hierarchy ()
  (interactive)
  (require 'browse)
  (send-to-smalltalk "Browser browseHierarchy!" "GetHierarchy")
  )


(defun smalltalk-browse-selectors ()
  "Set up to browse all methods whose selectors match the selector under
point."
  (interactive)
  (let ((selector (smalltalk-collect-selector)))
    (send-to-smalltalk
     (format "Browser getAllSelectors: #%s inBuffer: '*%s classes*'!"
	     selector selector)
		       "ShowSelectors")
    )
  )

(defun smalltalk-complete-class-name (&optional prompt)
  (or prompt
      (setq prompt "Class name: "))
  ;; add getting of class names here when required.
  (list (completing-read prompt smalltalk-class-names nil t))
  )

(defun smalltalk-toggle-decl-tracing ()
  (interactive)
  (send-to-smalltalk
"Smalltalk declarationTrace:
     Smalltalk declarationTrace not!")
  )

(defun smalltalk-toggle-exec-tracing ()
  (interactive)
  (send-to-smalltalk "Smalltalk executionTrace: Smalltalk executionTrace not!")
  )


(defun smalltalk-toggle-verbose-exec-tracing ()
  (interactive)
  (send-to-smalltalk "Smalltalk verboseTrace: Smalltalk verboseTrace not!")
  )

(defun test-func (arg &optional cmd-arg)
  (let ((buf (current-buffer)))
    (unwind-protect
	(progn
	  (if (not (consp (cdr arg)))
	      (progn
		(find-file-other-window (car arg))
		(goto-char (1+ (cdr arg)))
		(recenter '(0))		;hack to recenter the window without
					;redisplaying everything
		)
	    (switch-to-buffer-other-window (get-buffer-create (car arg)))
	    (smalltalk-mode)
	    (erase-buffer)
	    (insert (format "!%s methodsFor: '%s'!

%s! !" (nth 0 arg) (nth 1 arg) (nth 2 arg)))
	    (beginning-of-buffer)
	    (forward-line 2)		;skip to start of method
	  )
	  )
      (pop-to-buffer buf)
      )
    )
  )

(defun hier-func (arg)
  ;; browse the direct methods for the given class in the other window.
  ;; just the local methods
  ;; idea: use the => marker, split the top pane in two, showing
;;;Object                            | Method for class desc 1
;;;    Autoload			     | method for class desc 2
;;;    Behavior			     | method for class desc 3 
;;;=>      ClassDescription	     |
;;;            Class		     |
;;;            Metaclass	     |
;;;    BlockContext		     |
  ;; don't even have to use the marker, just installing any random junk
  ;; into the buffer should be sufficient.  The bottom window shows the
  ;; source code.  May even use the marker for the method window?
  ;; --> be sure to set truncate lines to true (buffer local )

  (message arg)
  )




(defun send-to-smalltalk (str &optional mode fileinfo)
  (let (temp-file buf switch-back old-buf)
    (setq temp-file (concat "/tmp/" (make-temp-name "mst")))
    (save-excursion
      (setq buf (get-buffer-create " zap-buffer "))
      (set-buffer buf)
      (erase-buffer)
      (princ str buf)
      (write-region (point-min) (point-max) temp-file nil 'no-message)
      )
    (kill-buffer buf)
    ;; this should probably be conditional
    (save-window-excursion (mst mst-args))
;;; why is this like this?
;;    (if mode
;;	(progn
;;	  (save-excursion
;;	    (set-buffer (process-buffer *smalltalk-process*))
;;	    (setq mode-status mode))
;;	  ))
    (setq old-buf (current-buffer))
    (setq buf (process-buffer *smalltalk-process*))
    (pop-to-buffer buf)
    (if mode
	(setq mode-status mode))
    (goto-char (point-max))
    (newline)
    (pop-to-buffer old-buf)
;    (if (not (eq buf (current-buffer)))
;	(progn
;	  (switch-to-buffer-other-window buf)
;	  (setq switch-back t))
;      )
;    (if mode
;	(setq mode-status mode))
;    (goto-char (point-max))
;    (newline)
;    (and switch-back (other-window 1))
;      ;;(sit-for 0)
    (if fileinfo
	(process-send-string
	 *smalltalk-process*
	 (format
	  "FileStream fileIn: '%s' line: %d from: '%s' at: %d!\n"
	  temp-file (nth 0 fileinfo) (nth 1 fileinfo) (nth 2 fileinfo)
	  ))	
      (process-send-string *smalltalk-process*
			   (concat "FileStream fileIn: '" temp-file "'!\n"))
      )
    )
  )



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; GNU Emacs hooks for invoking Emacs on Smalltalk methods
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(setq command-switch-alist
      (append '(("-smalltalk" . smalltalk-edit))
	      command-switch-alist))


(defun smalltalk-edit (rest)
  (let (file pos done)
    (setq file (car command-line-args-left))
    (setq command-line-args-left
	  (cdr command-line-args-left))
    (setq pos (string-to-int (car command-line-args-left)))
    (setq command-line-args-left
	  (cdr command-line-args-left))
    (find-file (expand-file-name file))
    (goto-char pos)
    )
  )
