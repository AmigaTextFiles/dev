;;; HOP.scm

;;;
;;; Useful Higher-Order Procedures
;;;

(define (filter predicate source-list)
  (cond ((null? source-list) '())
	((predicate (car source-list))
	 (cons (car source-list)
	       (filter predicate (cdr source-list)) ))
	(else
	 (filter predicate (cdr source-list)) )))

(define (repeat thunk n)
  (if (< n 1)
      #u
      (begin
	(thunk)
	(repeat thunk (- n 1)) )))

(define (repeated f n)
  (if (< n 1)
      (lambda (x) x)
      (lambda (x) ((repeated f (- n 1)) (f x))) ))



;;; EOF HOP.scm

