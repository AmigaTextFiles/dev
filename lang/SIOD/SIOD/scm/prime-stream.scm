(define (sieve stream)
        (cons-stream (head stream)
                     (sieve (filter
                            (lambda (x) (not (divisible? x (head stream))))
                            (tail stream)))))

(define (divisible? x y) (= (remainder x y) 0))

(define (filter pred stream)
   (if (pred (head stream))
       (cons-stream (head stream)
                       (filter pred (tail stream)))
       (filter pred (tail stream))))

(define (integers-starting-from n)
        (cons-stream n (integers-starting-from (1+ n))))

(define integers (integers-starting-from 2))

(define primes (sieve integers))

(define (print-stream s)
        (print (head s))
        (print-stream (tail s)))
