MODULE  'dos/var','dos/dos','dos/rdargs','dos/dostags',
        'utility/tagitem','utility','utility/hooks'

OBJECT mainargs
  file:PTR TO LONG, wz
ENDOBJECT

OBJECT subargs
  wizard:PTR TO LONG
ENDOBJECT

OBJECT subsubargs
  cmd,arg
ENDOBJECT

DEF rda:PTR TO rdargs, subrda:PTR TO rdargs

PROC main()
  DEF rdargs,subrdargs,str,i=0,
      arg1:PTR TO mainargs,
      arg2:PTR TO subargs,
      arg3:PTR TO subsubargs

  IF rda:=AllocDosObject( DOS_RDARGS, NIL )
    arg1:=New( SIZEOF mainargs )
    str:=estr( 'fil1 fil2 wz "Log to *"ram:test*"" "Wrap width=20"\n')
    setRDA( str, rda )

    IF rdargs := ReadArgs( 'FILE/M,WZ/K/F', arg1, rda)
      StrCopy( str, arg1.wz )
      FreeArgs(rdargs)

      setRDA( str, rda )
      IF rdargs := ReadArgs( 'WIZARD/M',arg2:=[0],rda )

        WHILE arg2.wizard[i]
          StringF(str, '\s\n', arg2.wizard[i])
          setRDA( str, rda )          
          IF subrdargs:=ReadArgs('CMD/A,ARG/F',arg3:=[0,0],rda)
            PrintF('\s\n', arg3.arg )
            FreeArgs(subrdargs)
          ELSE
            PrintFault(IoErr(), NIL)
          ENDIF
          INC i
        ENDWHILE

        FreeArgs(rdargs)
      ENDIF
    ENDIF

    FreeDosObject( DOS_RDARGS, rda )
  ENDIF

ENDPROC

PROC setRDA( str, rda:PTR TO rdargs )
  rda.source.buffer := str
  rda.source.length := StrLen( str )
  rda.source.curchr := NIL
  rda.buffer        := NIL
ENDPROC

PROC estr( str )
  DEF estr
  estr:=String( StrLen(str) )
  StrCopy( estr, str )
ENDPROC estr
