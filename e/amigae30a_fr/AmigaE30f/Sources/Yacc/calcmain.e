MODULE '*yyparse'

PROC main()
  Flush(stdin)
  PutStr('Calculatrice E-Yacc\n> ')
  Flush(stdout)
  LOOP
    yyparse()
  ENDLOOP
ENDPROC
