;

PROC main
   copy d0 d1
   cdpr nisse
   copy 10 d0 ; never gets executed...
EXCEPT
   copy _exception d0 ;return exception to cli
ENDPROC 

PROC nisse              ;RAISE  just to know it can raise things..
   raise -16 17 d0 = d0
ENDPROC                 ; we just leave nisse with exception set

END

 
