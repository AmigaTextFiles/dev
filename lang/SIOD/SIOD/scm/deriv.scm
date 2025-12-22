(define (make-sum a b)
   (cond ((and (number? a)
               (number? b)) (+ a b))
         ((eqv? a 0) b)
         ((eqv? b 0) a)
         ((equal? a b) (make-prod 2 a))


         (else (if (number? a)
                   (list b 'sum a)



                   (list a 'sum b)))))

(define (adde1 exp)
   (car exp))

(define (adde2 exp)
   (caddr exp))

(define (sum? a)
   (eq? (cadr a) 'sum))

(define (make-minus a b)
   (cond ((and (number? a)
               (number? b)) (- a b))

         ((eqv? b 0) a)

         ((equal? a b) 0)

         (else (list a 'minus b))))

(define (sott1 exp)
   (car exp))

(define (sott2 exp)
   (caddr exp))

(define (minus? a)
   (eq? (cadr a) 'minus))

(define (make-prod a b)
   (cond ((and (number? a)
               (number? b)) (* a b))

         ((eqv? a 1) b)
         ((eqv? b 1) a)
         ((or (eqv? a 0)
              (eqv? b 0)) 0)
         ((equal? a b) (make-exp a 2))


         (else (if (number? a)
                   (list a 'prod b)



                   (list b 'prod a)))))

(define (fatt1 exp)
   (car exp))

(define (fatt2 exp)
   (caddr exp))

(define (prod? a)
   (eq? (cadr a) 'prod))

(define (make-div a b)
   (cond ((eqv? b 0)
          (error "divisione per zero"))

         ((eqv? a 0) 0)

         ((eqv? b 1) a)
         ((and (number? a)
               (number? b))
               (if (zero? (remainder a
                                     b))
                   (/ a b)
                   (list (/ a (gcd a b))
                         'div
                         (/ b (gcd a b)))))
         ((equal? a b) 1)

         (else (list a 'div b))))

(define (divid exp)
   (car exp))

(define (divis exp)
   (caddr exp))

(define (divi? a)
   (eq? (cadr a) 'div))

(define (base exp)
   (car exp))

(define (expo exp)
   (caddr exp))

(define (exp? a)
   (eq? (cadr a) 'exp))

(define (make-exp a b)
   (cond ((eqv? b 0)
          (if (eqv? a 0)
              (error "zero elevato zero")
              1))

         ((eqv? b 1) a)

         ((eqv? a 0) 0)

         ((and (number? a)
               (number? b)) (expt a b))

         ((and (pair? a)(exp? a)) (make-exp (base a) 
                                  (make-prod (expo a) 
                                              b)))

         (else (list a 'exp b))))

(define (make-log a)
   (if (eqv? a 1)
      0
   (list 'log a)))

(define (log1 exp)
   (cadr exp))

(define (log? a)
   (eq? (car a) 'log))


(define (variable? a)
   (symbol? a))

(define (constant? a)
   (number? a))

(define (same-variable? a b)
   (eq? a b))

(define (deriv exp var)
   (cond ((constant? exp) 0)
         ((variable? exp)
          (if (same-variable? exp var)
              1
              0))

      ((sum? exp)
         (make-sum (deriv (fatt1 exp) var)
                   (deriv (fatt2 exp) var)))

      ((minus? exp)
         (make-minus (deriv (sott1 exp) var)
                     (deriv (sott2 exp) var)))

      ((prod? exp)
               (make-sum (make-prod (deriv (fatt1 exp) var)
                                    (fatt2 exp))
                         (make-prod (fatt1 exp)
                                    (deriv (fatt2 exp) var))))

      ((divi? exp)
         (make-div (make-minus (make-prod (deriv (divid exp) var)
                                          (divis exp))
                               (make-prod (divid exp)
                                          (deriv (divis exp) var)))
                   (make-exp (divis exp) 2)))

      ((log? exp)
         (make-prod (make-div 1
                              (log1 exp))
                    (deriv (log1 exp) var)))

      ((exp? exp)
         (if (number? (expo exp))
             (make-prod (expo exp)
                        (make-prod (make-exp (base exp)
                                             (- (expo exp) 1))
                                   (deriv (base exp) var)))
             (error "l'esponente deve essere una costante"
                    (expo exp))))
      (else (error "operatore sconosciuto" exp))))


(alias m+ make-sum)
(alias m- make-minus)
(alias m* make-prod)
(alias m/ make-div)
(alias m^ make-exp)
(alias ml make-log)
(alias d deriv)
(define x 'x)
