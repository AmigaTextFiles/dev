;;; special-forms.scm

(add-syntax! 'let*
  (let ()
    (define (first-loop bindings body-exps)
      (define (loop binding1 rest-bindings)
	(if (null? rest-bindings)
	    `(let (,binding1) . ,body-exps)
	    `(let (,binding1) ,(loop (car rest-bindings) (cdr rest-bindings))) ))
      (if (null? bindings)
	  `(let () . body-exps)
	  (loop (car bindings) (cdr bindings)) ))
    (lambda (exp env)
      (eval
	(first-loop (cadr exp) (cddr exp))
	env) )))



(add-syntax! 'case
  (let ()
    (define (find-case-exps-to-eval key clauses)
      (cond ((null? clauses)
	     '(()))
	    ((eq? (caar clauses) 'else)
	     (cdar clauses))
	    ((memv key (caar clauses))
	     (cdar clauses))
	    (else
	     (find-case-exps-to-eval key (cdr clauses)))))
    (lambda (exp env)
      (eval
	(cons 'begin
	  (find-case-exps-to-eval (eval (cadr exp) env) (cddr exp)))
	env) )))

