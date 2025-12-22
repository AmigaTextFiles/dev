(define (gcd x y)
        (if (= y 0)
            x
            (gcd y (remainder x y))))


(define (+rat x y)
        (make-rat
              (+ (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))

(define (-rat x y)
        (make-rat
              (- (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))

(define (*rat x y)
        (make-rat
              (* (numer x) (numer y))
              (* (denom x) (denom y))))

(define (/rat x y)
        (make-rat
              (* (numer x) (denom y))
              (* (denom x) (numer y))))

(define (=rat x y)
        (=
          (* (numer x) (denom y))
          (* (denom x) (numer y))))

(define (make-rat x y)
        (cons (/ x (gcd x y)) (/ y (gcd x y))))

(define numer car)

(define denom cdr)

(define (prin-rat x)
              (print (numer x) '/ (denom x)))

