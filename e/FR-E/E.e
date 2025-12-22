/* $VER: E 1.0 (5-4-97) © Frédéric RODRIGUES - freeware
   Execute multiple commands in just one
*/

OPT OSVERSION=36

MODULE 'dos/dos','dos/dosasl'

CONST MAX_LINE=512
DEF myargs:PTR TO LONG,rdargs,commands:PTR TO LONG,line[MAX_LINE]:STRING

PROC main()
  DEF s,t,u
  myargs:=[NIL,NIL]
  IF rdargs:=ReadArgs('$VER: E 1.0 (5-4-97) © Frédéric RODRIGUES - freeware'+
                      '\nExecute multiple commands in just one\n\n'+
                      'COMMANDS/M/A,ARG=ARGUMENTS/F/K',myargs,NIL)
    commands:=myargs[0]
    WHILE commands[]
      IF CtrlC()
        PrintFault(ERROR_BREAK,'E error')
        RETURN RETURN_WARN
      ENDIF
      StrCopy(line,commands[]++,ALL)
      s:=line
      WHILE s[]
        IF s[]++="["
          IF s[]++="]"
            IF StrLen(myargs[1])>=2
              t:=s+StrLen(s)+1
              u:=StrLen(myargs[1])-2
              WHILE t-->=s DO t[u]:=t[]
            ELSE
              t:=s
              u:=2-StrLen(myargs[1])
              REPEAT
                t[-u]:=t[]
              UNTIL t[]++=0
            ENDIF
            t:=s-2
            u:=myargs[1]
            WHILE u[] DO t[]++:=u[]++
          ENDIF
        ENDIF
      ENDWHILE
      SystemTagList(line,[0])
    ENDWHILE
    FreeArgs(rdargs)
  ELSE
    PrintFault(IoErr(),'E error')
    RETURN RETURN_ERROR
  ENDIF
ENDPROC
