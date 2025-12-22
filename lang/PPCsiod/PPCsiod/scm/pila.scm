(define make-pila '())

(define empty-pila? null?)

(define (push x pila)
        (cons x pila))

(define (pop pila)
        (if (empty-pila? pila)
            '()
            (cdr pila)))

(define (top pila)
        (if (empty-pila? pila)
            '()
            (car pila)))
