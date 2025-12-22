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
; Optional runtime library for version 2.0


(define (caar x) (cxr x "aa"))
(define (cadr x) (cxr x "da"))
(define (cdar x) (cxr x "ad"))
(define (cddr x) (cxr x "dd"))

(define (caaar x) (cxr x "aaa"))
(define (caadr x) (cxr x "daa"))
(define (cadar x) (cxr x "ada"))
(define (caddr x) (cxr x "dda"))

(define (cdaar x) (cxr x "aad"))
(define (cdadr x) (cxr x "dad"))
(define (cddar x) (cxr x "add"))
(define (cdddr x) (cxr x "ddd"))

(define (caaaar x) (cxr x "aaaa"))
(define (caaadr x) (cxr x "daaa"))
(define (caadar x) (cxr x "adaa"))
(define (caaddr x) (cxr x "ddaa"))

(define (cadaar x) (cxr x "aada"))
(define (cadadr x) (cxr x "dada"))
(define (caddar x) (cxr x "adda"))
(define (cadddr x) (cxr x "ddda"))

(define (cdaaar x) (cxr x "aaad"))
(define (cdaadr x) (cxr x "daad"))
(define (cdadar x) (cxr x "adad"))
(define (cdaddr x) (cxr x "ddad"))

(define (cddaar x) (cxr x "aadd"))
(define (cddadr x) (cxr x "dadd"))
(define (cdddar x) (cxr x "addd"))
(define (cddddr x) (cxr x "dddd"))

(macro freeze (lambda (x)
                      (cons 'lambda 
                            (cons nil (cdr x)))))

(define (thaw x) (x))

(macro delay (lambda (x)
                 (list 'cons ''delayed-object
                       (list 'lambda 
                                   '() (cadr x)))))

(define (force x) 
        (if (eq? (car x) 'memoized-object)
            (cdr x) 
            (sequence (set-cdr! x ((cdr x)))
                      (set-car! x 'memoized-object)
                      (cdr x))))

(define (delayed-object? x)
        (if (pair? x)
            (or (eq? (car x) 'delayed-object)(eq? (car x) 'memoized-object))
            #f))

(macro cons-stream 
       (lambda (x) 
               (list 'cons
                     (cadr x)
                     (list 'delay (caddr x)))))

(define (head x) (car x))

(define (tail x) (force (cdr x)))

(define the-empty-stream 
        ((named-lambda (empty-stream) 
                       (cons-stream 'empty-stream (empty-stream)))))

(define (empty-stream? x) (eq? (head x) 'empty-stream))

(define (stream? x)
        (and (pair? x) (delayed-object? (cdr x))))

(define (stream->list z)
        (define (str->ls x y)
                (if (empty-stream? x)
                    y
                    (str->ls (tail x) (cons (head x) y))))
         (str->ls z nil))  

(define (list->stream z)
        (if (null? z)
            the-empty-stream
            (cons-stream (car z) (list->stream (cdr z)))))

(define (integer->string x) (number->string x '(int)))

(macro make-environment (lambda (x)
                        (append (list 'let '())
                                (cdr x)
                                (list (list 'the-environment)))))

(macro alias (lambda (x) 
                     (list 'define
                           (cadr x) 
                           (caddr x))))

(macro rec (lambda (x) 
           (list 'letrec 
                 (list (list (cadr x) 
                             (caddr x)))
                 (cadr x))))

(define (file-length x)
        (let ((a (open-input-file x))
              (b nil))
             (set-file-position! a 0 2)
             (set! b (get-file-position a))
             (close-port a)
             b))

(define (open-binary-input-file x) (open-port x "rb" 1))

(define (open-binary-output-port x) (open-port x "wb" 1))

(define (open-input-file x) (open-port x "r" 1))

(define (open-output-file x) (open-port x "w" 1))

(define (open-extend-file x) (open-port x "a" 1))

(define (current-input-port) (fluid input-port))

(define close-output-port close-port)

(define close-input-port close-port)

(define (current-output-port) (fluid output-port))

(define (flush-input x) (begin (read-line x) '()))

(define (newline . x) (display #\newline (car x)))

(define (page . x) (display #\page (car x)))

(define (call-with-input-file x y)
        (let* ((in (open-input-file x))
               (res (y in)))
        (close-port in)
        res))

(define (call-with-output-file x y)
        (let* ((out (open-output-file x))
               (res (y out)))
        (close-port out)
        res))

(define (with-input-from-file x y)
        (let ((old-input (fluid input-port))
              (res nil))
             (set! (fluid input-port) (open-input-file x))
             (set! res (y))
             (close-port (fluid input-port))
             (set! (fluid input-port) old-input)
             res))

(define (with-output-to-file x y)
        (let ((old-output (fluid output-port))
              (res nil))
             (set! (fluid output-port) (open-output-file x))
             (set! res (y))
             (close-port (fluid output-port))
             (set! (fluid output-port) old-output)
             res))

(define #\backspace (integer->char 8))

(define #\escape (integer->char 27))

(define #\newline (integer->char 10))

(define #\page (integer->char 12))

(define #\return (integer->char 13))

(define #\rubout (integer->char 63))

(define #\space (integer->char 32))

(define #\tab (integer->char 9))

(define (string<? x y)
        (< (string-cmp x y) 0))        

(define (string>? x y)
        (> (string-cmp x y) 0))

(define (string=? x y)
        (= (string-cmp x y) 0))

(define (string<=? x y)
        (<= (string-cmp x y) 0))

(define (string>=? x y)
        (>= (string-cmp x y) 0))

(define (string-CI<? x y)
        (< (string-cmp-CI x y) 0))        

(define (string-CI=? x y)
        (= (string-cmp-CI x y) 0))

(define (substring-CI<? x y z a b c)
        (string-ci<? (substring x y z) (substring a b c)))

(define (substring-CI=? x y z a b c)
        (string-ci=? (substring x y z) (substring a b c)))

(define (substring<? x y z a b c)
        (string<? (substring x y z) (substring a b c)))

(define (substring=? x y z a b c)
        (string=? (substring x y z) (substring a b c)))

(define (string-null? x)
        (= (string-cmp x "") 0))

(define (substring-fill! x y z a)
        (while (< y z)
               (string-set! x y a)
               (set! y (1+ y)))
        x)

(define (substring-move-left! x y z a b)
        (while (< y z)
               (string-set! x b (string-ref a y))
               (set! b (1+ b))
               (set! y (1+ y)))
        x)

(define (substring-move-right! x y z a b)
        (while (<= y z)
               (set! z (-1+ z))
               (string-set! x b (string-ref a z))
               (set! b (1+ b)))
        x)

(define (symbol->ASCII x) 
        (char->integer (string-ref (symbol->string x) 0)))

(define (ASCII->symbol x)
        (string->symbol (make-string 1 (integer->char x))))

(define (implode x)
        (define y "")
        (while (not (atom? x)) 
               (cond ((string? (car x)) 
                      (set! y (string-append y 
                                     (make-string 1 (string-ref (car x) 0)))))
                     ((symbol? (car x))
                      (set! y (string-append y 
                                     (make-string 1 (integer->char (symbol->ASCII (car x)))))))
                     ((integer? (car x))
                      (set! y (string-append y 
                                     (make-string 1 (integer->char (car x))))))
                     (else (error "arg to implode must be a symbol or a string or an integer" (car x))))
                (set! x (cdr x)))
        (string->symbol y))
                  
(define (explode x)
        (cond ((symbol? x) (set! x (symbol->string x)))
              ((integer? x) (set! x (integer->string x)))
              ((string? x))
              (else (error "arg to explode must be a symbol or a string or an integer" x)))
        (do ((i 0 (1+ i))
             (res nil))
            ((= i (string-length x)) (reverse! res))
            (set! res 
                  (cons (string->symbol (make-string 1 (string-ref x i)))
                        res))))

(define (char<? x y)
        (< (char-cmp x y) 0))   
     
(define (char>? x y)
        (> (char-cmp x y) 0))
                   
(define (char=? x y)
        (= (char-cmp x y) 0))

(define (char<=? x y)
        (<= (char-cmp x y) 0))

(define (char>=? x y)
        (>= (char-cmp x y) 0))

(define (char-ci<? x y)
        (< (char-cmp (char-downcase x) (char-downcase y)) 0))   
     
(define (char-ci>? x y)
        (> (char-cmp (char-downcase x) (char-downcase y)) 0))   
     
(define (char-ci=? x y)
        (= (char-cmp (char-downcase x) (char-downcase y)) 0))   
     
(define (char-ci<=? x y)
        (<= (char-cmp (char-downcase x) (char-downcase y)) 0))   
     
(define (char-ci>=? x y)
        (>= (char-cmp (char-downcase x) (char-downcase y)) 0))   
     
(define (char-upper-case? x)
        (and (char>=? x #\A) (char<=? x #\Z)))

(define (char-lower-case? x)
        (and (char>=? x #\a) (char<=? x #\z)))

(define (char-digit? x)
        (and (char>=? x #\0) (char<=? x #\9)))

(define (boolean? x) (or (eq? x #t) (eq? x #f)))

(define (edit)
        (begin (dos-call "c:ed siod.tmp")
               (load "siod.tmp")))

(define (ced)
        (dos-call "ced"))

(define (call-with-current-continuation fcn)
  (let ((tag (cons nil nil)))
    (*catch tag
       (fcn (lambda (value)
         (*throw tag value))))))

(define call/cc call-with-current-continuation)

(define (sort! x . y)
        (define test <=)
        (define (interchange x i j)
                (define tmp (vector-ref x i))
                (vector-set! x i (vector-ref x j))
                (vector-set! x j tmp))
        (define (qsort x m n)
                (if (< m n)
                    (do ((i m) (j (1+ n))
                         (k (begin (interchange x m (quotient (+ m n) 2))  
                                   (vector-ref x m))))
                        ((>= i j) (interchange x m j)
                                  (qsort x m (-1+ j))
                                  (qsort x (1+ j) n) x)
                        (set! i (1+ i))
                        (do () ((or (test k (vector-ref x i)) (>= i n)))
                               (set! i (1+ i)))
                        (set! j (-1+ j))
                        (do () ((or (test (vector-ref x j) k) (<= j m)))
                               (set! j (-1+ j)))
                        (if (< i j) (interchange x i j)))))
        (define (m-s x y)
                (define res (list 'dummy))
                (do ((ptr res (cdr ptr))
                     (done #f))
                    (done (cdr res))
                    (cond ((null? x) (set-cdr! ptr y) (set! done #t))
                          ((null? y) (set-cdr! ptr x) (set! done #t))
                          ((test (car x) (car y))
                           (set-cdr! ptr x) (set! x (cdr x)))
                          (else (set-cdr! ptr y) (set! y (cdr y))))))
        (define (mer-so x)
                (if (or (null? x) (null? (cdr x))) 
                    x
                    (m-s x (mer-so (do ((ptr (cdr x) (cdr ptr))
                                        (y (cddr x) (cdr y)))
                                       ((or (null? y) (test (car y) (car ptr))) 
                                        (set-cdr! ptr nil) y))))))
        (if (pair? y)
            (if (proc? (car y))
                (set! test (car y))
                (error "second arg to sort! must be a procedure" (car y))))
        (cond ((vector? x) (qsort x 0 (-1+ (vector-length x))) x)
              ((pair? x) (mer-so x))
              (else (error "first arg to sort! must be a vector or a list" x))))

(define (break proc . nome)
        (let ((code (procedure-code proc))
              (text (if (string? (car nome))
                        (string-append "break-point entered in " (car nome))
                        "breakpoint entered")))
             (set-cdr! code (list 'begin 
                                  (list 'bkpt text)
                                  (cdr code)))
             (set-procedure-code! proc code)))

(define (unbreak proc)
        (let ((code (procedure-code proc)))
             (if (eq? (caaddr code) 'bkpt)
                 (set-cdr! code (cadddr code))
                 (error "procedure is not breaked"))
             (set-procedure-code! proc code)))

(define (*tracer* nome env)
        (display (string-append "entering procedure " 
                                nome
                                " with parameters:"))
        (do ((ar (environment-bindings env) (cdr ar))) 
            ((null? ar)) 
            (print (cdar ar))
            (newline)))

(define (trace proc nome)
        (let ((code (procedure-code proc)))
             (set-cdr! code 
                       (list 'begin 
                             (list '*tracer* (if (string? (car nome)) 
                                                 (car nome) 
                                                 "")   
                                             (list 'the-environment))
                             (cdr code)))
             (set-procedure-code! proc code)))

(define (untrace proc)
        (let ((code (procedure-code proc)))
             (if (eq? (caaddr code) '*tracer*)
                 (set-cdr! code (cadddr code))
                 (error "procedure is not traced"))
             (set-procedure-code! proc code)))

