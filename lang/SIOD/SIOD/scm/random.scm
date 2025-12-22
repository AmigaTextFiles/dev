(define (next-rand x)
        (remainder (+ 25514 (* x 3)) 65536))

(define rand (let ((random 2346))
                  (lambda () (set! random (next-rand random)) random)))
