(define (empty-set-m) (list 'set))

(define (adjoin-set-m! x set)
        (if (element-of-set-m? x set)
            set
            (begin (set-cdr! set (cons x (cdr set)))
                   set)))

(define (element-of-set-m? x set)
        (define present #f)
        (while (and (not present) 
                    (not (null? set)))
               (if (eqv? x (car set))
                   (set! present #t)
                   (set! set (cdr set))))
        present)

(define (union-set-m set1 set2)
        (define uni-set (empty-set-m))
        (while (not (null? set2))
               (adjoin-set-m! (car set2) set1)
               (set! set2 (cdr set2))))

(define (intersection-set-m set1 set2)
        (define int-set (empty-set-m))
        (while (not (null? set2))
               (when (element-of-set-m? (car set1) set2)
                     (set-cdr! int-set (cons x (cdr int-set))))
               (set! set2 (cdr set2)))
        (set-cdr! set1 (cdr int-set)))
               
(define (empty-set-m? x)
        (or (and (eq? (car x) 'set) (null? (cdr x))) (null? x)))
