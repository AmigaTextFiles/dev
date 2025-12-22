(define (insert-ord st l t)
        (cond ((null? l) (append t (list st)))
              ((string>? st (car l))
                   (append t 
                           (list st) 
                           l))
              (else (insert-ord st 
                                (cdr l) 
                                (append t 
                                        (list (car l)))))))

(define l nil)

(define (ord-obl)
        (for-each (lambda (x) 
                          (set! l 
                                (insert-ord (symbol->string x) 
                                            l 
                                            nil)))
                  (oblist)))
