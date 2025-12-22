; list merge sort

(define (sort! x test)      ; si utilizzano le regole di visibilita` 
                            ; per il test che non viene passato alle 
                            ; procedure interne.
        (define (m-s x y)     ; procedura iterativa per la fusione 
                              ; distruttiva di due liste.
                (define res (list 'dummy))  ; variabile su cui viene 
                                            ; costruita la lista risultato
                                            ; e` inizializzato ad una lista
                                            ; contenente un elemento 
                                            ; fittizio in modo da poter 
                                            ; usare direttamente set-cdr!.
                (do ((ptr res (cdr ptr))  ; ciclo do principale.
                                          ; la variabile ptr e` usata come
                                          ; puntatore per scorrere la lista
                                          ; risultato.
                     (done #f))   ; flag per terminare il ciclo.
                    (done (cdr res))  ; al termine restituisce il cdr 
                                      ; del risultato.
                    (cond ((null? x) (set-cdr! ptr y) ; se la prima lista e` 
                                                      ; terminata, appende la
                                                      ; seconda al risultato
                                                      ; e termina il ciclo do.
                                     (set! done #t))
                          ((null? y) (set-cdr! ptr x) ; se la seconda lista e` 
                                                      ; terminata, appende la
                                                      ; prima al risultato
                                                      ; e termina il ciclo do.
                                     (set! done #t))
                          ((test (car x) (car y)) ; se il car della prima lista
                                                  ; e` minore di quello della
                                                  ; seconda lo aggiunge al
                                                  ; risultato.
                           (set-cdr! ptr x) 
                           (set! x (cdr x)))
                          (else (set-cdr! ptr y) ; altrimenti aggiunge il car
                                                 ; del secondo.
                                (set! y (cdr y))))))                     
        (define (mer-so x) ; procedura ricorsiva che suddivide la lista da
                           ; ordinare in sottoliste rispettando l'eventuale
                           ; ordine gia` presente.
                (if (or (null? x) (null? (cdr x))) 
                    x
                    (if (test (car x) (cadr x))
                        (m-s x
                         (mer-so (do ((ptr (cdr x) (cdr ptr))
                                      (y (cddr x) (cdr y)))
                                     ((or (null? y)
                                          (test (car y) (car ptr))) 
                                      (set-cdr! ptr nil) y))))
                        (m-s (reverse! x)
                              (mer-so (do ((ptr (cdr x) (cdr ptr))
                                           (y (cddr x) (cdr y)))
                                          ((or (null? y)
                                               (test (car ptr) (car y))) 
                                           (set-cdr! ptr nil) y)))))))
        (mer-so x))

