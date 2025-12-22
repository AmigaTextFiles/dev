(define gcd
        (build-model '(a b t)
                     '(test-b
                       (branch (zero? (fetch b)) gcd-done)
                       (assign t (remainder (fetch a) (fetch b)))
                       (assign a (fetch b))
                       (assign b (fetch t))
                       (goto test-b)
                       gcd-done)))

(define fact
        (build-model '(n val continue)
                     '((assign continue fib-done)
                     fib-loop
                       (branch (< (fetch n) 2) immediate-answer)
                       (save continue)
                       (assign continue after-fib-n-1)
                       (save n)
                       (assign n (- (fetch n) 1))
                       (goto fib-loop)
                     after-fib-n-1
                       (restore n)
                       (restore continue)
                       (assign n (- (fetch n) 2))
                       (save continue)
                       (assign continue after-fib-n-2)
                       (save val)
                       (goto fib-loop)
                     after-fib-n-2
                       (assign n (fetch val))
                       (restore val)
                       (restore continue)
                       (assign val (+ (fetch val) (fetch n)))
                       (goto (fetch continue))
                     immediate-answer
                       (assign val (fetch n))
                       (goto (fetch continue))
                     fib-done)))