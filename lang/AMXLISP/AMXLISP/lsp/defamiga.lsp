;the initialization of 'exec library'
;must be hand-coded
;in fact, there is no problem, since we have its base in absolute adress 4
(setq exec (list (cons 'base (memory-long 4))))

;(openlibrary 'intuition)
(defun openlibrary (lib)
   (if (boundp lib)
       (cassoc 'base (Eval lib))
       (set lib (list (cons 'base
                            (callamiga 'OpenLibrary exec
                                       (strcat (string-downcase (symbol-name lib))
                                               ".library")
                                       0))))))


;(callamiga "OpenWindow" intuition <window>)
;(callasm offset base lreg larg)
; Error code = 1163022930 from callasm !
(defun callamiga (fname lib &rest larg)
   (let ((finfo (cassoc fname lib)))
      (unless finfo (error "Unknown function" fname))
   (let ((result
   (callasm (car finfo)
            (cassoc 'base lib)
            (cdr finfo)
            (mapcar (lambda (arg)
                        (cond ((objectp arg) (send arg :ptr))
                              (t arg)))
                    larg))))
      (if (equal result 1163022930)
          (error "Bad parameter list in Callasm")
          result))))




(setq fd-path "fd:")
(setq fd-suffix ".fd")

;(defamiga 'OpenLibrary 'exec)
(defun defamiga (fname lib)
   (let ((handle (open (strcat fd-path (symbol-name lib) fd-suffix))))
        (when (null handle)
              (error "Unknown library:" (Symbol-name lib)))
        (do ((l (read handle) (read handle)))  ; (<sym> <init> <step>)
            ((or (eq (car l) fname)
                 (null l))                     ; <texpr>
             (if (null l)
                 (progn (close handle)
                        (error "Function not found" fname))
                 (progn (if (not (boundp lib))
                            (openlibrary lib))
                        (unless (cassoc fname (eval lib))
                        (set lib (cons l (eval lib))))))  ;fin du if
                  ))))



(defamiga 'openlibrary 'exec)
(defamiga 'closelibrary 'exec)

(defun explode-string (s)
   (let ((l ()))
        (dotimes (i (length s))
                 (setq l (cons (char s i) l)))
        (reverse l)))
(defun implode-string (l)
   (let ((s ""))
        (mapc (lambda (ch)
                 (setq s (strcat s (String ch))))
             l)
        s))

;XLISP 1.7    : we now use string-downcase
;(defun lowascii (s)
;   (implode-string (mapcar (lambda (x) (+ x 32)) (explode-string s))))

