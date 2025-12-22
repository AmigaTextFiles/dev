-> Silly Shell Example
PROC main()
  DEF inputstring[80]:STRING, con
  IF con:=Open('con:10/10/400/100/MySillyShell v0.1',NEWFILE)
    Write(con,'Shell by $#%! in 1991. "BYE" to stop.\n',STRLEN)
    WHILE StrCmp(inputstring,'BYE')=FALSE
      Execute(inputstring,0,con)
      Write(con,'MyPrompt> ',STRLEN)
      ReadStr(con,inputstring)
      UpperStr(inputstring)
    ENDWHILE
    Close(con)
  ENDIF
ENDPROC NIL

