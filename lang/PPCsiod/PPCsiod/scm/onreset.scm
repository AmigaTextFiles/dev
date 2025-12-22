(define (call-on-reset p)
        (if (proc? p)
            (eval `(set! err-stack (cons ,p err-stack))
                  on-reset-env)
            (error "arg to call-on-reset must be a procedure"))
        #t)

(define on-reset-env
        (make-environment (define err-stack)
                          (define p)
                          (define (reset-handler)
                                  (while err-stack
                                         (set! p (car err-stack))
                                         (set! err-stack (cdr err-stack))
                                         (p)))))

(set! *on-reset* (access reset-handler on-reset-env))

(define (uncall-on-reset p)
        (if (proc? p)
        (eval `(set! err-stack (delq! ,p err-stack))
              on-reset-env)
            (error "arg to call-on-reset must be a procedure"))
        #t)
