(define-machine explicit-control-evaluator
                (registers exp env val continue fun argl unev)
                (controller
                   eval-dispatch
                    (branch (self-evaluating? (fetch exp)) ev-self-eval)
                    (branch (quoted? (fetch exp)) ev-quote)
                    (branch (variable? (fetch? exp)) ev-variable)
                    (branch (definition? (fetch exp)) ev-definition)
                    (branch (assignment? (fetch exp)) ev-assignment)
                    (branch (lambda? (fetch exp)) ev-cond)
                    (branch (no-args? (fetch exp)) ev-no-args)
                    (branch (application? (fetch exp)) ev-application)
                    (goto unknown-expression-type-error)
                   ev-self-eval
                    (assign val (fetch exp))
                    (goto (fetch continue))
                   ev-quote
                    (assign val (text-of-quotation (fetch exp)))
                    (goto (fetch continue))
                   ev-variable
                    (assign val 
                            (lookup-variable-value (fetch exp) (fetch env)))
                    (goto (fetch continue))
                   ev-lambda
                    (assign val (make-procedure (fetch exp) (fetch env)))
                    (goto (fetch continue))
                   ev-no-args
                    (assign exp (operator (fetch exp)))
                    (save continue)
                    (assign continue setup-no-arg-apply)
                    (goto eval-dispatch)
                   setup-no-arg-apply
                    (assign fun (fetch val))
                    (assign argl '())
                    (goto apply-dispatch)
                   ev-application
                    (assign unev (operands (fetch exp)))
                    (assign exp (operator (fetch exp)))
                    (save continue)
                    (save env)
                    (save unev)
                    (assign continue eval-args)
                    (goto eval-dispatch)
                   eval-args
                    (restore unev)
                    (restore env)
                    (assign fun (fetch val))
                    (save fun)
                    (assign argl '())
                    (goto eval-arg-loop)
                   eval-arg-loop
                    (save argl)
                    (assign exp (first-operand (fetch unev)))
                    (branch (last-operand (fetch unev)) eval-last-arg)
                    (save env)
                    (save unev)
                    (assign continue accumulate-arg)
                    (goto eval-dispatch) 
                   accumulate-arg
                    (restore unev)
                    (restore env)
                    (restore argl)
                    (assign argl (cons (fetch val) (fetch argl)))
                    (assign unev (rest-operands (fetch unev)))
                    (goto eval-arg-loop)
                   eval-last-arg
                    (assign continue accumulate-last-arg)
                    (goto eval-dispatch)
                   accumulate-last-arg
                    (restore argl)
                    (assign argl (cons (fetch val) (fetch argl)))
                    (restore fun)
                    (goto apply-dispatch)
                   apply-dispatch
                    (branch (primitive-procedure? (fetch fun)) primitive-apply)
                    (branch (compound-procedure? (fetch fun)) compound-apply)
                    (goto unknown-procedure-type-error)
                   primitive-apply
                    (assign val (apply-primitive-procedure (fetch fun)
                                                           (fetch argl)))
                    (restore continue)
                    (goto (fetch continue))
                   compound-apply
                    (assign env (make-binding (fetch fun) (fetch argl)))
                    (assign unev (procedure-body (fetch fun)))
                    (goto eval-sequence)
                   eval-sequence
                    (assign exp (first-exp (fetch unev)))
                    (branch (last-exp? (fetch unev)) last-exp)
                    (save unev)
                    (save env)
                    (assign continue eval-sequence-continue)
                    (goto eval-dispatch) 
                   eval-sequence-continue
                    (restore env)
                    (restore unev)
                    (assign unev (rest-exps (fetch unev)))
                    (goto eval-sequence)
                   last-exp
                    (restore continue)
                    (goto eval-dispatch)
                   ev-cond
                    (save continue)
                    (assign continue evcond-decide)
                    (assign unev (clauses (fetch exp)))
                   ev-cond-pred
                    (branch (no-clauses? (fetch unev)) evcond-return-nil)
                    (assign exp (first-clause (fetch unev)))
                    (branch (else-clause? (fetch exp)) evcond-else-clause)
                    (save env)
                    (save unev)
                    (assign exp (predicate (fetch exp)))
                    (goto eval-dispatch)
                   evcond-return-nil
                    (restore continue)
                    (assign val nil)
                    (goto (fetch continue))
                   evcond-decide
                    (restore unev)
                    (restore env)
                    (branch (true? (fetch val)) evcond-true-predicate)
                    (assign unev (rest-clauses (fetch unev)))
                    (goto evcond-pred)
                   evcond-true-predicate
                    (assign exp (first-clause (fetch unev)))
                   evcond-else-clause
                    (assign unev (actions (fetch exp)))
                    (goto eval-sequence)
                   ev-assignment
                    (assign unev (assignment-variable (fetch exp)))
                    (save unev)
                    (assign exp (assignment-value (fetch exp)))
                    (save env)
                    (save continue)
                    (assign continue ev-assignment-1)
                    (goto eval-dispatch)
                   ev-definition-1
                    (restore continue)
                    (restore env)
                    (restore unev)
                    (perform
                       (define-variable! (fetch unev) (fetch val) (fetch env)))
                    (assign val (fetch unev))
                    (goto (fetch continue))
                   read-eval-print-loop 
                    (perform (initialize-stack))
                    (perform (newline))
                    (perform (display "EC-EVAL==> "))
                    (assign exp (read))
                    (assign env the-global-environment)
                    (assign continue print-result)
                    (goto eval-dispatch)
                   print-result
                    (perform (user-print (fetch val)))
                    (goto read-eval-print-loop)
                   unknown-procedure-type-error
                    (assign val 'unknown-procedure-type-error)
                    (goto signal-error)
                   unknown-expression-type-error
                    (assign val 'unknown-expression-type-error)
                    (goto signal-error)
                   signal-error
                    (perform (user-print (fetch val)))
                    (goto read-eval-print-loop)))