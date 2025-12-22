(macro repeat 
       (lambda (e)
               `(begin ,(cadr e) (while ,(caddr e) ,(cadr e)))))

(macro for
       (lambda (e)
               `(do ((,(cadr e) ,(caddr e) ,(cadddr e)))
                    (,(car (cddddr e)))
                    ,@(cdr (cddddr e)))))
 