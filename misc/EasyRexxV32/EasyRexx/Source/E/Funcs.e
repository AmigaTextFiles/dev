OPT PREPROCESS

MODULE 'intuition/intuition'
MODULE 'utility/tagitem'
MODULE 'rexx/errors'
MODULE 'exec/ports'

MODULE 'easyrexx'
MODULE 'libraries/easyrexx'
MODULE 'libraries/easyrexx_macros'

OBJECT arexxretvalues
  retvalue
  retstring:PTR TO CHAR
  error:PTR TO CHAR
ENDOBJECT

ENUM
  AREXX_CLEAR=1,
  AREXX_GETVAR,
  AREXX_HELP,
  AREXX_OPEN,
  AREXX_QUIT,
  AREXX_ROW,
  AREXX_SAVE,
  AREXX_TEXT,
  AREXX_RX,
  AREXX_CAUSEERROR

DEF myreturn:arexxretvalues

PROC arexxfuncCLEAR(c:PTR TO arexxcontext)
  PrintF('CLEAR')
  IF ARG(c,0)
    PrintF(' FORCE=on')
  ENDIF
ENDPROC RC_OK
PROC arexxfuncGETVAR(c:PTR TO arexxcontext)
  PrintF('GETVAR')
  IF ARG(c,0)
    PrintF(' HELLOWORLD')
    myreturn.retstring:='Hello World!'
  ENDIF
ENDPROC RC_OK
PROC arexxfuncHELP(c:PTR TO arexxcontext)
  PrintF('HELP')
  IF ARG(c,0)
    PrintF(' AMIGAGUIDE')
  ENDIF
  IF ARG(c,1)
    PrintF(' TOPIC=\s',ARGSTRING(c,1))
  ENDIF
ENDPROC RC_OK
PROC arexxfuncOPEN(c:PTR TO arexxcontext)
  PrintF('OPEN')
  IF ARG(c,1)
    PrintF(' TEXT')
  ELSE
    PrintF(' PROJECT') -> defaults to project
  ENDIF
  IF ARG(c,2)
    PrintF(' \a\s\a',ARGSTRING(c,2))
  ENDIF
ENDPROC RC_OK
PROC arexxfuncQUIT(c:PTR TO arexxcontext)
  PrintF('QUIT')
ENDPROC -1
PROC arexxfuncROW(c:PTR TO arexxcontext)
  PrintF('ROW')
  IF ARG(c,0)
    PrintF(' \d',ARGNUMBER(c,0))
  ENDIF
ENDPROC RC_OK
PROC arexxfuncSAVE(c:PTR TO arexxcontext)
  PrintF('SAVE')
  IF ARG(c,0)
    PrintF(' AS')
  ENDIF
  IF ARG(c,1)
    PrintF(' \s',ARGSTRING(c,1))
  ENDIF
ENDPROC RC_OK
PROC arexxfuncTEXT(c:PTR TO arexxcontext)
  PrintF('TEXT')
  IF ARG(c,0)
    PrintF(' \a\s\a',ARGSTRING(c,0))
  ENDIF
ENDPROC RC_OK
PROC arexxfuncRX(c:PTR TO arexxcontext)
  PrintF('RX \a\s\a\n*Sending command asynchronously: \a\s\a to the \a\s\a port',ARGSTRING(c,0),ARGSTRING(c,0),c.portname)
  SendARexxCommandA(ARGSTRING(c,0),[ER_Port,c.port,ER_Context,c,ER_Asynch,TRUE,TAG_DONE])
ENDPROC RC_OK
PROC arexxfuncCAUSEERROR(c:PTR TO arexxcontext)
  PrintF('CAUSEERROR')
  myreturn.error:='Error: Because you asked for it ;)'
ENDPROC RC_ERROR

PROC myHandleARexx(c:PTR TO arexxcontext)
  DEF done=FALSE,id=0,i=0,function=NIL

  myreturn.retvalue:=RC_OK
  myreturn.retstring:=NIL
  myreturn.error:=NIL

  IF GetARexxMsg(c)
    PrintF('Received: ')
    -> while we didn't reach the end of the command table AND we didn't
    -> found the approriate function yet, continue the loop
    WHILE (c.table[i].command<>NIL) AND (function<>NIL)
      IF c.table[i].id=c.id
        -> there is a function, call it
        IF function:=c.table[i].userdata
          done:=function(c)
          myreturn.retvalue:=done
        -> there was no function, but we need to stop the loop now
        ELSE
          function:=TRUE
        ENDIF
      ELSE
        i:=i+1
      ENDIF
    ENDWHILE
    ReplyARexxMsgA(c,[
                      ER_ReturnCode,(IF (myreturn.retvalue=-1) THEN RC_OK ELSE myreturn.retvalue),
                      IF myreturn.error THEN ER_ErrorMessage ELSE TAG_IGNORE,myreturn.error,
                      IF myreturn.retstring THEN ER_ResultString ELSE TAG_IGNORE,myreturn.retstring,
                      TAG_DONE
                     ])
    PrintF('\n')
  ENDIF
ENDPROC done

PROC main()
  DEF done=FALSE
  DEF context=NIL:PTR TO arexxcontext,signals=0

  IF easyrexxbase:=OpenLibrary(EASYREXXNAME, EASYREXXVERSION)
    context:=AllocARexxContextA([ER_CommandTable,
                                   [AREXX_CLEAR,'CLEAR','FORCE/S',{arexxfuncCLEAR},
                                    AREXX_GETVAR,'GETVAR','HELLOWORLD/S',{arexxfuncGETVAR},
                                    AREXX_HELP,'HELP','AMIGAGUIDE/S,TOPIC/F',{arexxfuncHELP},
                                    AREXX_OPEN,'OPEN','PROJECT/S,TEXT/S,NAME/F',{arexxfuncOPEN},
                                    AREXX_QUIT,'QUIT','',{arexxfuncQUIT},
                                    AREXX_ROW,'ROW','NUMBER/A/N',{arexxfuncROW},
                                    AREXX_SAVE,'SAVE','AS/S,NAME/F',{arexxfuncSAVE},
                                    AREXX_TEXT,'TEXT','TEXT/A/F',{arexxfuncTEXT},
                                    AREXX_RX,'RX','COMMAND/A/F',{arexxfuncRX},
                                    AREXX_CAUSEERROR,'CAUSEERROR','',{arexxfuncCAUSEERROR},
                                    TABLE_END]:arexxcommandtable,
                                 ER_Author,'Ketil Hunn',
                                 ER_Copyright,'© 1995 Ketil Hunn',
                                 ER_Version,'2',
                                 ER_Portname,'EASYREXX_TEST',
                                 TAG_DONE])
    PrintF('context @$\h\n',context)
  ELSE
    PrintF('easyrexx.library not found.\n')
  ENDIF
  IF context
    PrintF('Welcome to a small EasyRexx demonstration\n'+
           '-----------------------------------------\n'+
           'Open another shell and start the small\n'+
           'AREXX script: rx test\n'+
           'or doubleclick on the test.rexx icon.\n')
    ArexxCommandShellA(context,[WA_TITLE,'ARexx Commandline Interface',
                               WA_LEFT,0,
                               WA_WIDTH,320,
                               WA_HEIGHT,100,
                               WA_DRAGBAR,TRUE,
                               WA_DEPTHGADGET,TRUE,
                               WA_SIZEGADGET,TRUE,
                               WA_CLOSEGADGET,TRUE,
                               WA_MINWIDTH,50,
                               WA_MINHEIGHT,50,
                               WA_MAXWIDTH,-1,
                               WA_MAXHEIGHT,-1,
                               WA_SIZEBBOTTOM,TRUE,
                               TAG_DONE])
    WHILE done=FALSE
      signals:=Wait(ER_SIGNAL(context))
      ER_SETSIGNALS(context,signals)
      IF (signals AND ER_SIGNAL(context))
        done:=myHandleARexx(context)
      ENDIF
    ENDWHILE
    FreeARexxContext(context)
  ENDIF
  IF easyrexxbase
    CloseLibrary(easyrexxbase)
  ENDIF
ENDPROC
