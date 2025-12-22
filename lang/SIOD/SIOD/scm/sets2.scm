(define (adjoin-set x set)
        (cond ((empty-tree? set) (cons x the-empty-set))
              ((> x (car set)) (cons (car set) (adjoin-set x (cdr set))))
              ((= x (car set)) set)
              (else (cons x (cdr set)))))

(define (element-of-set? x set)
        (cond ((empty-set? set) #f)
              ((> x (car set)) #f)
              ((eqv? x (car set)) #t)
              (else (element-of-set x (cdr set)))))
     
(define (union-set set1 set2)
        (cond ((empty-set? set1) set2)
              ((< (car set1) (car set2))
                  (union-set (cdr set1) (cons (car set1) set2)))
              (else (union-set (cdr set1) (adjoin-set (car set1) set2)))))

(define (intersection-set set1 set2)
        (cond ((empty-set? set1) the-empty-set)
              ((empty-set? set2) the-empty-set)
              ((element-of-set? (car set1) set2)
                      (cons (car set1) (intersection-set (cdr set1) set2)))
              (else (intersection-set (cdr set1) set2))))

(define (empty-set? x)
        (eq? x the-empty-set))

(define the-empty-set 'empty-set)
