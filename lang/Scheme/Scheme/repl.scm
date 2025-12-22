;;; repl.scm

(define (make-id-cont)
  (call/cc
    (lambda (return)
      (call/cc
	(lambda (later) (return later))) )))

(define (make-error-handler interrupt-mask affected-interrupts restart-cont)
  (define (error-handler packet)
    (display "Yeeow!  ")
    (display (cadr packet))
    (newline)
    (display (car packet))
    (newline)
    (display "Interrupt flags/mask: ")
    (display (number->string (current-interrupt-flags) '(int (radix x e))))
    (display #\/)
    (display (number->string (current-interrupt-mask) '(int (radix x e))))
    (newline)
    (newline)
    (collect-garbage)
    (restart-cont "hello-again") )
  (with-interrupt-mask interrupt-mask affected-interrupts
    (lambda ()
      (call/cc
	(lambda (return)
	  (error-handler
	    (call/cc
	      (lambda (later) (return later)) )))))) )



(define (read-until stop-char omit?)
  (define (get-next input-list)
    (let ((c (read-char)))
      (cond ((eof-object? c)
	     (finish input-list))
	    ((eq? c stop-char)
	     (finish (if omit? input-list (cons c input-list))))
	    (else
	     (get-next (cons c input-list))))))
  (define (finish lst)
    (reverse lst))
  (get-next '()))



(define (check-system-call cmdchar obj)
  (if (symbol? obj)
      (let ((chars (string->list (symbol->string obj))))
	(if (and (not (null? chars)) (eq? cmdchar (car chars)))
	    (let ((cmd (list->string (append (cdr chars) (read-until #\newline #t)))))
	      (call-system cmd)
	      #t)))))



(define *LEVEL* 0)

(define (repl repl-read repl-eval repl-print)
  (define cmdchar #\~)
  (define internal-repl
    (let ((*LAST-IN*  'undefined)
	  (*LAST-OUT* 'undefined))
      (let ((internal-env (the-environment)))
	(lambda ()
	  (newline)
	  (display *LEVEL*)
	  (display "=> ")
	  (let ((obj (repl-read)))
	    (cond ((eof-object? obj)
		   'done)
		  (else
		   (cond ((check-system-call cmdchar obj)
			  (newline))
			 (else
			  (let ((result (repl-eval obj internal-env)))
			    (eval `(set! *LAST-IN*  ',obj)    internal-env)
			    (eval `(set! *LAST-OUT* ',result) internal-env)
			    (repl-print result)
			    (newline))))
		   (internal-repl))))))))
  (define protected-repl
    (call/cc
      (lambda (return)
	(error-context
	  (make-error-handler
	    #x0002
	    #xFFFF
	    (with-interrupt-mask #x0002 #xFFFF
	      (lambda ()
		(call/cc
		  (lambda (return)
		    (call/cc (lambda (later) (return later)))
		    (protected-repl "hello-again")))) ))
	  (lambda ()
	    (call/cc (lambda (later) (return later)))
	    (internal-repl))))))
  (if (procedure? protected-repl)
      (begin (set! *LEVEL* (+ *LEVEL* 1))
	     (protected-repl "first-time"))
      (set! *LEVEL* (- *LEVEL* 1))))



;;; EOF repl.scm

