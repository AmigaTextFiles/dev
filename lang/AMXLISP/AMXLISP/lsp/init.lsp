; initialization file for XLISP 2.0

; define some macros
(defmacro defvar (sym &optional val)
  `(if (boundp ',sym) ,sym (setq ,sym ,val)))
(defmacro defparameter (sym val)
  `(setq ,sym ,val))
(defmacro defconstant (sym val)
  `(setq ,sym ,val))

; (makunbound sym) - make a symbol value be unbound
(defun makunbound (sym) (setf (symbol-value sym) '*unbound*) sym)

; (fmakunbound sym) - make a symbol function be unbound
(defun fmakunbound (sym) (setf (symbol-function sym) '*unbound*) sym)

; (mapcan fun list [ list ]...)
(defmacro mapcan (&rest args) `(apply #'nconc (mapcar ,@args)))

; (mapcon fun list [ list ]...)
(defmacro mapcon (&rest args) `(apply #'nconc (maplist ,@args)))

; (set-macro-character ch fun [ tflag ])
(defun set-macro-character (ch fun &optional tflag)
    (setf (aref *readtable* (char-int ch))
          (cons (if tflag :tmacro :nmacro) fun))
    t)

; (get-macro-character ch)
(defun get-macro-character (ch)
  (if (consp (aref *readtable* (char-int ch)))
    (cdr (aref *readtable* (char-int ch)))
    nil))

; (savefun fun) - save a function definition to a file
(defmacro savefun (fun)
  `(let* ((fname (strcat (symbol-name ',fun) ".lsp"))
          (fval (get-lambda-expression (symbol-function ',fun)))
          (fp (open fname :direction :output)))
     (cond (fp (print (cons (if (eq (car fval) 'lambda)
                                'defun
                                'defmacro)
                            (cons ',fun (cdr fval))) fp)
               (close fp)
               fname)
           (t nil))))

; (debug) - enable debug breaks
(defun debug ()
       (setq *breakenable* t))

; (nodebug) - disable debug breaks
(defun nodebug ()
       (setq *breakenable* nil))

; initialize to enable breaks but no trace back
(setq *breakenable* t)
(setq *tracenable* nil)

; probefile for  XLISP
(defun probefile (filename &optional path)
   (let ((handle (if (null path)
                     (open filename)
                     (open (strcat path filename)))))
        (if (null handle)
            ()
            (close handle)
            t)))

; aset
(defmacro aset (vector n value)
   `(setf (aref ,vector ,n) ,value))


; cassoc
(defmacro cassoc (s al)
   `(cdr (assoc ,s,al)))

(defun append1 (l s)
   (append l (list s)))

;in 1.7, functionnal value was obtained directly by evaluation
; the function
(defmacro getfn (f)
   `(get-lambda-expression (function ,f)))

(system "assign fd: amxlisp:fd")
(system "assign xlinclude: amxlisp:include")
(load "amxlisp:lsp/defamiga.lsp")
(load "amxlisp:lsp/interface.lsp")
(load-c-struct "exec/types")

