(define (deriv f h)
        (lambda (x)
                (/ (- (f (+ h x)) (f x)) h)))

(define (integral f a b dx)
        (define (add-dx z) (+ z dx))
        (sum f add-dx (+ a (/ dx 2)) b))

(define (sum f next x y)
        (if (> x y)
            0
            (+ (f x) (sum f next (next x) y))))
