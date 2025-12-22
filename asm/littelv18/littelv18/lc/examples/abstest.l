;

PROC main
   COPY 222 d1
   ABS d1 d0
   COPY -222 d1
   ABS d1 d0
ENDPROC

END

