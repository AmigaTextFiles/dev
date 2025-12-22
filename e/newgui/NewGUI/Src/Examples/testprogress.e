OPT     OSVERSION = 37

MODULE  'newgui/ng_progress'

DEF     pw:PTR TO progresswin

PROC main()     HANDLE
 NEW pw.progresswin('NewGUI - ProgressWindow','Testing this wonderful Window!','still testing...',3,2,1,50,NIL,NIL)

  runaction()

EXCEPT DO
 END pw
ENDPROC

PROC runaction()
 DEF    a=0,
        b=0,
        status[50]:STRING
  FOR a:=0 TO 99
   Delay(5)
    IF a=20
     AstrCopy(status,'... and testing...')
      b:=status
    ELSEIF a=40
     AstrCopy(status,'now: testing!')
      b:=status
    ELSEIF a=60
     AstrCopy(status,'great, eh?')
      b:=status
    ELSEIF a=80
     AstrCopy(status,'thats NewGUI!')
      b:=status
    ELSE
     b:=NIL
    ENDIF
     pw.set(a,b,NIL)
  ENDFOR
ENDPROC
