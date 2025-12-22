;;; load-patches.scm

(define path-object
  (let ()
    (define *CURRENT-DIR* ":")
    (define (extend-filename name add-slash?)
      (cond ((zero? (string-length name))
	     name)		    ; don't add slash
	    (else
	     (let ((name-chars
		    (let ((last-char (string-ref name (- (string-length name) 1))))
		      (if (or (not add-slash?)
			      (eq? last-char #\/)
			      (eq? last-char #\:))
			  (string->list name)
			  (append (string->list name) '(#\/)) ))))
		(cond ((null? name-chars)
		       *CURRENT-DIR*)
		      ((or (memq #\: name-chars)
			   (eq? (car name-chars) #\/))
		       (list->string name-chars))
		      (else
		       (string-append *CURRENT-DIR* (list->string name-chars))))))))
    (define (cd . dirlist)
      (cond ((= (length dirlist) 0)
	     *CURRENT-DIR*)
	    ((= (length dirlist) 1)
	     (let ((fullname (extend-filename (car dirlist) #t)))
	       (if (file-exists? fullname)
		   (set! *CURRENT-DIR* fullname)
		   (error "file not found" fullname))))
	    (else
	     (error "use zero or one argument" dirlist))))
    (lambda (m)
      (cond ((eq? m 'cd)              cd)
	    ((eq? m 'extend-filename) extend-filename))) ))



(define cd		(path-object 'cd))
(define extend-filename (path-object 'extend-filename))



(define load
  (let ()
    (define original-load load)
    (define last-file-list '())
    (define (ld file)
      (original-load (extend-filename file #f)))
    (define (do-load file-list)
      (for-each ld file-list))
    (lambda file-list
      (if (null? file-list)
	  (do-load last-file-list)
	  (begin (set! last-file-list file-list)
		 (do-load file-list)))) ))



;;; EOF load-patches.scm

