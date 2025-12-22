(define (self-evaluating? exp) (number? exp))

(define (quoted? exp)
        (if (atom? exp)
            nil
            (eq? (car exp) 'quote)))

(define (text-of-quotation exp) (cadr exp))

(define (variable? exp) (symbol? exp))

(define (assignment? exp)
        (if (atom? exp)
            nil
            (eq? (car exp) 'set!)))

(define (assignment-variable exp) (cadr exp))

(define (assignment-value exp) (caddr exp))

(define (definition? exp)
        (if (atom? exp)
            nil
            (eq? (car exp) 'define)))

(define (definition-variable exp)
        (if (variable? (cadr exp))
            (cadr exp)
            (caadr exp)))

(define (definition-value exp)
        (if (variable? (cadr exp))
            (caddr exp)
            (cons 'lambda
                  (cons (cdadr exp)
                        (cddr exp)))))

(define (lambda? exp)
        (if (atom? exp)
            nil
            (eq? (car exp) 'lambda)))

(define (conditional? exp) 
        (if (atom? exp)
            nil
            (eq? (car exp) 'cond)))

(define (clauses exp) (cdr exp))

(define (no-clauses? clauses) (null? clauses))

(define (first-clause clauses) (car clauses))

(define (rest-clauses clauses) (cdr clauses))

(define (true? x) (not (null? x)))

(define (else-clause? clause)
        (eq? (predicate clause) 'else))

(define (last-exp? seq) (null? (cdr seq)))

(define (first-exp seq) (car seq))

(define (rest-exp seq) (cdr seq))

(define (application? exp) (not (atom? exp)))

(define (operator app) (car app))

(define (operands app) (cdr app))

(define (no-operands? args) (null? args))

(define (first-operand args) (car args))

(define (rest-operands args) (cdr args))

(define (make-procedure lambda-exp env)
        (list 'procedure lambda-exp env))

(define (compound-procedure? proc)
        (if (atom? proc)
            nil
            (eq? (car proc) 'procedure)))

(define (parameters proc) (cadr (cadr proc)))

(define (procedure-body proc) (cddr (cadr proc)))

(define (procedure-envirot proc) (caddr proc))

(define (lookup-variable-value var env)
        (let ((b (binding-in-env var env)))
             (if (found-binding? b)
                 (binding-value b)
                 (error "unbound variable" var))))

(define (binding-in-env var env)
        (if (no-mor-frames? env)
            no-binding
            (let ((b (binding-in-frame var (first-frame env))))
                 (if (found-binding? b)
                     b
                     (binding-in-env var (rest-frames env))))))

(define (extend-environment variables value base-env)
        (adjoin-frame (make-frame variables values) base-env))

(define (set-variable-value! var val env)
        (let ((b (binding-in-frame var (first frame env))))
             (if (found-binding? b)
                 (set-binding-value! b val)
                 (set-first-frame! env (adjoin-binding (make-binding var val)
                                                       (first-frame env))))))

(define (first-frame env) (car env))

(define (rest-frames env) (cdr env))

(define (no-more-frames? env) (null? env))

(define (adjoin-frame frame env) (cons frame env))

(define (set-first-frame! env new-frame)
        (set-car! env new-frame))

(define (make-frame variables values)
        (cond ((and (null? variables) (null? values)) '())
              ((null? variables)
               (error "too many values supplied" values))
              ((null? values)
               (error "too few values supplied" variables))
              (else (cons (make-binding (car variables) (car values))
                          (make-frame (cdr variables) (cdr values))))))

(define (adjoin-binding binding frame)
        (cons binding frame))

(define (assq key bindings)
        (cond ((null? bindings) no-binding)
              ((eq? key (binding-variable (car bindings))) 
                  (car bindings)) 
              (else (assq key (cdr bindings)))))

(define (binding-in-frame var frame)
        (assq var frame))

(define (found-binding? b)
        (not (eq? b no-binding)))

(define no-binding nil)

(define (make-binding variable value)
        (cons variable value))

(define (binding-variable binding)
        (car binding))

(define (binding-value binding)
        (cdr binding))

(define (set-binding-value! binding value)
        (set-cdr! binding value))

(define (user-print object)
        (cond ((compound-procedure? object)
              (print (list 'compound-procedure
                           (parameters object)
                           (procedure-body object)
                           '[procedure-env])))
              (else (print object))))

(define (make-bindings proc args)
        (extend-binding-environment (parameters proc)
                                    args
                                    (procedure-environment proc)))

(define (extend-binding-environment vars args env)
        (extend-environment vars (reverse args) env)) 

(define the-global-environment (setup-environment))

(start explicit-control-evaluator)
