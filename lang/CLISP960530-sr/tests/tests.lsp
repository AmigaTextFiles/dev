;; Test-Suiten ablaufen lassen:

#+CLISP
(defmacro with-ignored-errors (&rest forms)
  (let ((b (gensym)))
    `(BLOCK ,b
       (LET ((*ERROR-HANDLER*
               #'(LAMBDA (&REST ARGS) (RETURN-FROM ,b 'ERROR))
            ))
         ,@forms
     ) )
) )

#+AKCL
(defmacro with-ignored-errors (&rest forms)
  (let ((b (gensym))
        (h (gensym)))
    `(BLOCK ,b
       (LET ((,h (SYMBOL-FUNCTION 'SYSTEM:UNIVERSAL-ERROR-HANDLER)))
         (UNWIND-PROTECT
           (PROGN (SETF (SYMBOL-FUNCTION 'SYSTEM:UNIVERSAL-ERROR-HANDLER)
                        #'(LAMBDA (&REST ARGS) (RETURN-FROM ,b 'ERROR))
                  )
                  ,@forms
           )
           (SETF (SYMBOL-FUNCTION 'SYSTEM:UNIVERSAL-ERROR-HANDLER) ,h)
     ) ) )
) )

(defun run-test (testname
                 &aux (logname (merge-pathnames #".erg" testname)) log-empty-p)
  (with-open-file (s (merge-pathnames #".tst" testname) :direction :input)
    (with-open-file (log logname :direction :output)
      (let ((*package* *package*)
            (*print-pretty* nil)
            (eof "EOF"))
        (loop
          (let ((form (read s nil eof))
                (result (read s nil eof)))
            (when (or (eq form eof) (eq result eof)) (return))
            (print form)
            (let ((my-result
                    (if (equal testname "conditions")
                      (eval form) ; don't disturb the condition system when testing it!
                      (with-ignored-errors (eval form)) ; return ERROR on errors
                 )) )
              (cond ((eql result my-result)
                     (format t "~%EQL-OK: ~S" result)
                    )
                    ((equal result my-result)
                     (format t "~%EQUAL-OK: ~S" result)
                    )
                    ((equalp result my-result)
                     (format t "~%EQUALP-OK: ~S" result)
                    )
                    (t
                     (format t "~%FEHLER!! ~S sollte ~S sein!" my-result result)
                     (format log "~%Form: ~S~%SOLL: ~S~%~A: ~S~%"
                                 form result
                                 #+CLISP "CLISP" #+AKCL "AKCL"
                                 my-result
                    ))
        ) ) ) )
      )
      (setq log-empty-p (zerop (file-length log)))
  ) )
  (when log-empty-p (delete-file logname))
  (values)
)

(defun run-all-tests ()
  (mapc #'run-test
        '( #-AKCL     "alltest"
                      "array"
                      "backquot"
           #-AKCL     "characters"
           #+CLISP    "clos"
           #+CLISP    "conditions"
                      "eval20"
                      "format"
           #+CLISP    "genstream"
           #+XCL      "hash"
                      "hashlong"
                      "iofkts"
                      "lambda"
                      "lists151"
                      "lists152"
                      "lists153"
                      "lists154"
                      "lists155"
                      "lists156"
           #+CLISP    "loop"
                      "macro8"
                      "map"
                      "number"
           #+CLISP    "number2"
           #-AKCL     "pack11"
      #-(or AKCL DOS) "path"
           #+XCL      "readtable"
                      "setf"
                      "steele7"
                      "streams"
                      "streamslong"
                      "strings"
           #-AKCL     "symbol10"
                      "symbols"
           #+XCL      "tprint"
           #+XCL      "tread"
                      "type"
  )      )
  t
)

