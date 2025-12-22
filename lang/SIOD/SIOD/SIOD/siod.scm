; Scheme In One Define.
; 
; The garbage collector, the name and other parts of this program are
;
; *                     COPYRIGHT (c) 1989 BY                              *
; *      PARADIGM ASSOCIATES INCORPORATED, CAMBRIDGE, MASSACHUSETTS.       *
;
; Conversion  to  full scheme standard, characters, vectors, ports, complex &
; rational numbers, debug utils, and other major enhancments by
;
; *      Scaglione Ermanno, v. Pirinoli 16 IMPERIA P.M. 18100 ITALY        * 
;
; Permission  to use, copy, modify, distribute and sell this software and its
; documentation  for  any purpose and without fee is hereby granted, provided
; that  the  above  copyright  notice appear in all copies and that both that
; copyright   notice   and   this  permission  notice  appear  in  supporting
; documentation,  and that the name of Paradigm Associates Inc not be used in
; advertising or publicity pertaining to distribution of the software without
; specific, written prior permission.
;
; Runtime library for version 2.6

(define my-path "SIOD:")

(autoload-from-file (string-append my-path "cxr.scm")
                    '(caar cadr cdar cddr 
                      caaar caadr cadar caddr  
                      cdaar cdadr cddar cdddr  
                      caaaar caaadr caadar caaddr 
                      cadaar cadadr caddar cadddr 
                      cdaaar cdaadr cdadar cdaddr 
                      cddaar cddadr cdddar cddddr
                      1st 2nd 3rd 4th)
                     user-global-environment)

(autoload-from-file (string-append my-path "delay.scm") 
                    '(freeze thaw delay force delayed-object?)
                    user-global-environment)

(autoload-from-file (string-append my-path "streams.scm")
                    '(cons-stream head tail the-empty-stream 
                      empty-stream? stream? stream->list list->stream
                      stream-map stream-append stream-filter stream-ref
                      stream-nth stream-for-each)
                    user-global-environment)     

(autoload-from-file (string-append my-path "port.scm") 
                    '(file-length open-binary-input-file
                      open-binary-output-file open-input-file
                      open-output-file open-extend-file
                      current-input-port current-output-port
                      newline page call-with-input-file
                      call-with-output-file with-input-from-file
                      with-output-to-file)
                    user-global-environment)

(autoload-from-file (string-append my-path "string.scm")
                    '(string<? string>? string=? string<=?
                      string>=? string-CI<? string-CI=? string-null?)
                    user-global-environment)


(autoload-from-file (string-append my-path "substring.scm") 
                    '(substring-CI<? substring-CI=? substring<?
                      substring=? substring-fill! 
                      substring-move-left! substring-move-right!
                      substring-find-next-char-in-set 
                      substring-find-previous-char-in-set)
                    user-global-environment)

(autoload-from-file (string-append my-path "exp-imp.scm")
                    '(implode explode)
                    user-global-environment)


(autoload-from-file (string-append my-path "char.scm") 
                    '(char<? char>? char=? char<=? char>=?
                      char-ci<? char-ci>? char-ci=? char-ci<=?
                      char-ci>=? char-upper-case?
                      char-lower-case? char-digit?)
                    user-global-environment)

(autoload-from-file (string-append my-path "sort.scm") 
                    '(sort!)
                    user-global-environment)

(autoload-from-file (string-append my-path "debug.scm") 
                    '(break unbreak *tracer* trace untrace assert)
                    user-global-environment)

(autoload-from-file (string-append my-path "vector.scm") 
                    '(vector-copy vector-append vector-reverse
                      vector-reverse! vector-map vector-for-each)
                    user-global-environment)

(define #\backspace (integer->char 8))

(define #\escape (integer->char 27))

(define #\newline (integer->char 10))

(define #\page (integer->char 12))

(define #\return (integer->char 13))

(define #\rubout (integer->char 63))

(define #\space (integer->char 32))

(define #\tab (integer->char 9))

(macro make-environment (lambda (x)
                                `(let () 
                                      ,@(cdr x) 
                                      (the-environment))))

(macro alias 
       (lambda (x)
               `(macro ,(cadr x)
                       (lambda (e)
                               (if (pair? e) 
                                   (cons ,(caddr x) (cdr e))
                                   ,(caddr x))))))

(macro rec (lambda (x)
                   `(letrec ((,(cadr x) ,(caddr x)))
                            ,(cadr x))))

(define (boolean? x) (or (eq? x #t) (eq? x #f)))

(define time-of-day runtime)

(define nth list-ref)

(define (compose x y)
        (eval `(lambda a (,x (apply ,y a)))))

(define (edit)
        (begin (dos-call "c:ed siod.tmp")
               (load "siod.tmp" (environment-parent (the-environment)))))

(define (ced)
        (dos-call "ced"))

(define (call-with-current-continuation fcn)
  (let ((tag (cons nil nil)))
    (*catch tag
       (fcn (lambda (value)
         (*throw tag value))))))

(define call/cc call-with-current-continuation)

(define (call-on-reset p)
        (if (proc? p)
            (eval `(set! err-stack (cons ,p err-stack))
                  *on-reset-env*)
            (error "arg to call-on-reset must be a procedure"))
        #t)

(define *on-reset-env*
        (make-environment (define err-stack)
                          (define p)
                          (define (reset-handler)
                                  (while err-stack
                                         (set! p (car err-stack))
                                         (set! err-stack (cdr err-stack))
                                         (p)))))

(set! *on-reset* (access reset-handler *on-reset-env*))

(define (uncall-on-reset p)
        (if (proc? p)
        (eval `(set! err-stack (delq! ,p err-stack))
              *on-reset-env*)
            (error "arg to call-on-reset must be a procedure"))
        #t)

(macro cycle (lambda (e)
                     `(while #t ,@(cdr e))))

(macro repeat 
       (lambda (e)
               `(begin ,(cadr e) (while ,(caddr e) ,(cadr e)))))

(macro for
       (lambda (e)
               `(do ((,(cadr e) ,(caddr e) ,(cadddr e)))
                    (,(car (cddddr e)))
                    ,@(cdr (cddddr e)))))
