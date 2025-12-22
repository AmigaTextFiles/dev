(define (make-pila) (list 'pila))

(define (pila? x)
        (and (pair? x) 
             (eq? 'pila (car x))))
 
(define (empty-pila? x)
        (if (pila? x) 
            (null? (cdr x))
            (error "arg to empty-pila must be a pila" pila)))

(define (push! x pila)
        (if (pila? pila) 
            (begin (set-cdr! pila
                             (cons x (cdr pila)))
                   pila)
            (error "arg to push must be a pila" pila)))

(define (pop! pila)
        (if (pila? pila) 
            (if (empty-pila? pila)
                (error "pila is empty" pila)
                (begin (set-cdr! pila (cddr pila))
                       pila))            
            (error "arg to pop must be a pila" pila)))

(define (top pila)
        (if (pila? pila) 
            (cadr pila)
            (error "arg to top must be a pila" pila)))


