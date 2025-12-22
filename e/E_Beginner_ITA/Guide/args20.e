OPT OSVERSION=37

PROC main()
  DEF templ, rdargs, args=NIL:PTR TO LONG, i
  IF wbmessage=NIL
    WriteF('Lanciato dalla Shell/CLI\n')
    templ:='FILE/M'
    rdargs:=ReadArgs(templ,{args},NIL)
    IF rdargs
      IF args
        i:=0
        WHILE args[i]  /* Loop del numero di argomenti */
          WriteF('   Argomento \d: "\s"\n', i, args[i])
          i++
        ENDWHILE
      ENDIF
      FreeArgs(rdargs)
    ENDIF
  ENDIF
ENDPROC
