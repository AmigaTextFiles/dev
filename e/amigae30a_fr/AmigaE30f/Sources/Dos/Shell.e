-> TurboShell en Amiga E. notez qu'on utilise notre propre CON:

PROC main()
  DEF inputstring[80]:STRING, con
  IF con:=Open('con:10/10/400/100/TurboShell v0.1',NEWFILE)
    Write(con,'Shell by $#%! in 1991. "BYE" pour sortir.\n',STRLEN)
    WHILE StrCmp(inputstring,'BYE',ALL)=FALSE
      Execute(inputstring,0,con)
      Write(con,'Turbo> ',STRLEN)
      ReadStr(con,inputstring)
      UpperStr(inputstring)
    ENDWHILE
    Close(con)
  ENDIF
ENDPROC
