(macro iterate
       (lambda (e)
               (let ((name (cadr e))
                     (initial-bindings (caddr e))
                     (body (cdddr e)))
                    `((rec ,name
                           (lambda
                                  ,(mapcar car initial-bindings)
                                  ,@body))
                           ,@(mapcar cadr initial-bindings)))))
