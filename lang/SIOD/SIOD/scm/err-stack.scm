
Evaluation took 1960 milliseconds (0 in gc) 0 cons work
#t
>> define err-stack)

Evaluation took 40 milliseconds (0 in gc) 0 cons work
err-stack
>> (define (on-error p)
           (if (proc? p)
               (set! err-stack (cons p err-stack))
               (error "proc is needed")))

Evaluation took 40 milliseconds (0 in gc) 8 cons work
on-error
>> (define (new-error s)
           (while err-stack
                  ((car err-stack))
                  (set! err-stack (cdr err-stack))))

Evaluation took 40 milliseconds (0 in gc) 8 cons work
new-error
>> (transcript-off)

Evaluation took 880 milliseconds (0 in gc) 0 cons work
#t
>> define (with-output s p)
           (let ((o (fluid output-port)))
                (set! s (open-output-file s))
                (set! (fluid output-port) s)
                (on-error (lambda () (close-output-port s)
                                     (set! (fluid output-port) o)))
                (p)
                (set! (fluid output-port) o)))

Evaluation took 40 milliseconds (0 in gc) 8 cons work
with-output
>> (transcript-off)

Evaluation took 899 milliseconds (0 in gc) 0 cons work
#t
>> define (unerror p)
           (set! err-stack (delq! p err-stack)))

Evaluation took 40 milliseconds (0 in gc) 8 cons work
unerror
>> (transcript-off)

Evaluation took 980 milliseconds (0 in gc) 0 cons work
#t
>> define (with-output s p)
           (let ((o (fluid output-port))
                 (e (lambda () (close-output-port s))))
                (set! (fluid output-port) (open-output-file s))
                (p)
                (close-output-port (fluid output-port))
                (set! (fluid output-port) o)))

Evaluation took 40 milliseconds (0 in gc) 6 cons work
with-output
>> (define (with-output s p)
           (letrec ((o (fluid output-port))
                    (f (open-output-file s))
                    (e (lambda () (close-output-port f)
                                  (set! (fluid output-port) o))))
                (set! (fluid output-port) f)
                (on-error e)
                (p)
                (close-output-port f)
                (set! (fluid output-port) o)
                (unerror e)))

Evaluation took 40 milliseconds (0 in gc) 6 cons work
with-output
>> (transcript-off)
