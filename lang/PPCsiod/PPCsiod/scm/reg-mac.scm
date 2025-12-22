(macro define-machine 
       (lambda (x) 
               `(define ,(cadr x) (build-model ',(caddr x) ',(cadddr x)))))

(define (build-model registers controller)
        (let ((machine (make-new-machine)))
             (set-up-registers machine registers)
             (set-up-controller machine controller)
             machine))

(define (set-up-registers machine registers)
        (mapc (lambda (register-name)
                      (make-machine-register machine register-name))
              registers))

(define (set-up-controller machine controller)
        (build-instruction-list machine (cons '*start* controller)))

(define (build-instruction-list machine op-list)
        (if (null? op-list)
            '()
            (let ((rest-of-instructions
                  (build-instruction-list machine (cdr op-list))))
                 (if (label? (car op-list))
                     (sequence (declare-label machine
                                              (car op-list)
                                              rest-of-instructions)
                                rest-of-instructions)
                     (cons (make-machine-instruction machine
                                                     (car op-list))
                           rest-of-instructions)))))

(define (label? expression)
        (symbol? expression))

(define (make-machine-register machine name)
        (remote-define machine name (make-register name)))

(define (make-register name)
        (define contents nil)
        (define (get) contents)
        (define (set value)
                (set! contents value))
        (define (dispatch message)
                (cond ((eq? message 'get) (get))
                      ((eq? message 'set) set)
                      (else (error "unknown request -- REGISTER"
                                   (cons name mesage)))))
        dispatch)

(define (get-contents register)
        (register 'get))

(define (set-contents register value)
        ((register 'set) value))

(define (declare-label machine label labeled-entry)
        (let ((defined-labels (remote-get machine '*labels*)))
             (if (memq label defined-labels)
                 (error "Multiply-defined label" label)
                 (sequence 
                   (remote-define machine label labeled-entry)
                   (remote-set machine
                               '*labels*
                               (cons label defined-labels))))))

(define (make-stack)
        (define s '())
        (define number-pushes 0)
        (define max-depth 0)
        (define (push x)
                (set! s (cons x s))
                (set! number-pushes (1+ number-pushes))
                (set! max-depth (max (lenght s) max-depth)))
        (define (pop)
                (if (null? s)
                    (error "empty stack --- POP")
                    (let ((top (car s)))
                         (set! s (cdr s))
                         top)))
        (define (initialize)
                (set! s '())
                (set! number-pushes 0)                 
                (set! max-depth 0))
        (define (print-statistics)
                (print (list 'total-pushes: number-pushes
                             'maximum-depth: max-depth))) 
        (define (dispatch message)
                (cond ((eq? message 'push) push)
                      ((eq? message 'pop) (pop))
                      ((eq? message 'initialize) (initialize))
                      ((eq? message 'print-statistics)
                                    (print-statistics))
                      (else (error "unknown request -- STACK" message))))
        dispatch)

(define (pop stack)
        (stack 'pop))

(define (push stack value)
        ((stack 'push) value))

(define (make-new-machine)
        (make-environment
        (define *labels* '())
        (define *the-stack* (make-stack))
        (define (initialize-stack)
                (*the-stack* 'print-statistics)
                (*the-stack* 'initialize))
        (define fetch get-contents)
        (define *program-counter* '())
        (define (execute sequence)
                (set! *program-counter* sequence)
                (if (null? *program-counter*)
                    'done
                    ((car *program-counter*))))
        (define (normal-next-instruction)
                (execute (cdr *program-counter*)))
        (define (assign register value)
                (set-contents register value)
                (normal-next-instruction))
        (define (save reg)
                (push *the-stack* (get-contents reg))
                (normal-next-instruction))
        (define (restore reg)
                (set-contents reg (pop *the-stack*))
                (normal-next-instruction))
        (define (goto new-sequence)
                (execute new-sequence))
        (define (branch predicate alternate-next)
                (if predicate
                    (goto alternate-next)
                    (normal-next-instruction)))
        (define (perform operation)
                (normal-next-instruction))))

(define (remote-get machine variable)
        (eval variable machine))

(define (remote-define machine variable value)
        (eval (list 'define variable (list 'quote value))
              machine))

(define (remote-set machine variable value)
        (eval (list 'set! variable (list 'quote value))
              machine))

(define (make-machine-instruction machine exp)
        (eval (list 'lambda '() exp) machine))


(define (remote-fetch machine register-name)
        (get-contents (remote-get machine register-name)))

(define (remote-assign machine register-name value)
        (set-contents (remote-get machine register-name) value)
        'done)

(define (start machine)
        (eval '(goto *start*) machine))

