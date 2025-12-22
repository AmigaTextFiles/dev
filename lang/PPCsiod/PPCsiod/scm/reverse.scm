(define (append x y)
        (if (null? x)
            y
            (cons (car x) (append (cdr x) y))))

(define (reverse x)
        (define (reverse_it x y)
                (if (null? x)
                    y
                    (reverse_it (cdr x) (cons (car x) y))))
        (reverse_it x nil))

(define (append_it x y res)
        (if (null? x)
            (if (null? y)
                (cons res nil)
                (append_it x (cdr y) (cons res (car y))))
            (append_it (cdr x) y (cons res (car x)))))

(define (A x y)
        (cond ((= y 0) 0)
              ((= x 0) (* 2 y))
              ((= y 1) 2)
              (else (A (- x 1) (A x (- y 1))))))

             
