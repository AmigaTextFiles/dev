(define (sostituisci lis a b)
        (define (sos-it lis a b ris)
                (cond ((null? lis) ris)
                      ((eqv? (car lis) a) (sos-it (cdr lis) 
                                                  a 
                                                  b 
                                                  (append ris 
                                                          (list b))))
                      ((eqv? (car lis) b) (sos-it (cdr lis) 
                                                  a 
                                                  b 
                                                  (append ris 
                                                          (list a))))
                      (else (sos-it (cdr lis) 
                                    a 
                                    b 
                                    (append ris 
                                            (list (car lis)))))))
         (sos-it lis a b nil))

(define (sostituisci2 lis a b)
        (define (sos-it lis a b ris)
                (cond ((null? lis) ris)
                      ((eqv? (car lis) a) (sos-it (cdr lis) 
                                                  a 
                                                  b 
                                                  (cons b ris)))
                      ((eqv? (car lis) b) (sos-it (cdr lis) 
                                                  a 
                                                  b 
                                                  (cons a ris)))
                      (else (sos-it (cdr lis) 
                                    a 
                                    b 
                                    (cons (car lis) ris)))))
         (reverse (sos-it lis a b nil)))

(define (sostituisci-all lis a b)
        (define (sos-all-it lis a b ris)
                (if (atom? (car lis))
                    (cond ((null? lis) ris)
                          ((eqv? (car lis) a) (sos-all-it (cdr lis) 
                                                      a 
                                                      b 
                                                      (append ris 
                                                              (list b))))
                          ((eqv? (car lis) b) (sos-all-it (cdr lis) 
                                                      a 
                                                      b 
                                                      (append ris 
                                                              (list a))))
                          (else (sos-all-it (cdr lis) 
                                        a 
                                        b 
                                        (append ris 
                                                (list (car lis))))))
                      (sos-all-it (cdr lis) 
                              a 
                              b 
                              (append ris 
                                   (list (sos-all-it (car lis) a b nil))))))
         (sos-all-it lis a b nil))

