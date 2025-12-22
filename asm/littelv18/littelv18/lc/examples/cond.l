;

PROC main
   VAR a b c
   CODESTART
   COPY 10 a
   COPY 12 b
   CND a > b c
   cnd a < b c


ENDPROC
END

