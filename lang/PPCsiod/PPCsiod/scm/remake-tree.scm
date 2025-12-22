
(define (dividi lis el p)
       (if (eqv? (car lis) el)
           (list p (cdr lis))
           (dividi (cdr lis) 
                   el 
                   (append p 
                           (list (car lis))))))

(define (separa lis n p)
        (if (= n 0)
            (list p (cdr lis))
            (separa (cdr lis) 
                    (-1+ n) 
                    (append p 
                            (list (car lis))))))

(define (costruisci pre in)
        (if (null? pre)
            the-empty-tree
            (let* ((radice (car pre))
                   (coppia1 (dividi in radice nil))
                   (in-left (car coppia1))
                   (in-right (cadr coppia1))
                   (n (lenght in-left))
                   (coppia2 (separa (cdr pre) n nil))
                   (pre-left (car coppia2))
                   (pre-right (cadr coppia2)))
                  (make-tree (costruisci pre-left in-left)
                             radice
                             (costruisci pre-right in-right)))))
        
