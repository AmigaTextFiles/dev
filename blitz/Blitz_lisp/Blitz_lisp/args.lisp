; My 1st lisp program ;)
(println @args)
(print "arg_len = ")
(println (strlen @args))  ; un-quoted spaces will not be counted here.

(println (strlen "1234 6789"))  ; here they are counted
