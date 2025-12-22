OPT PREPROCESS

MODULE 'intuition/intuition'
MODULE 'utility/tagitem'
MODULE 'rexx/errors'
MODULE 'exec/ports'

MODULE 'easyrexx'
MODULE 'libraries/easyrexx'
MODULE 'libraries/easyrexx_macros'

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

PROC myHandleARexx(c:PTR TO arexxcontext)
  DEF done=FALSE,id=0
  DEF resultstring=NIL,error=NIL
  DEF result1=RC_OK

  IF GetARexxMsg(c)
    PrintF('Received: ')
    id:=c.id
    SELECT id
    CASE AREXX_CLEAR
      PrintF('CLEAR')
      IF ARG(c,0)
        PrintF(' FORCE=on')
      ENDIF
    CASE AREXX_GETVAR
      PrintF('GETVAR')
      IF ARG(c,0)
        PrintF(' HELLOWORLD')
        resultstring:='Hello World!'
      ENDIF
    CASE AREXX_HELP
      PrintF('HELP')
      IF ARG(c,0)
        PrintF(' AMIGAGUIDE')
      ENDIF
      IF ARG(c,1)
        PrintF(' TOPIC=\s',ARGSTRING(c,1))
      ENDIF
    CASE AREXX_OPEN
      PrintF('OPEN')
      IF ARG(c,1)
        PrintF(' TEXT')
      ELSE
        PrintF(' PROJECT') -> defaults to project
      ENDIF
      IF ARG(c,2)
        PrintF(' \a\s\a',ARGSTRING(c,2))
      ENDIF
    CASE AREXX_QUIT
      PrintF('QUIT')
      done:=TRUE
    CASE AREXX_ROW
      PrintF('ROW')
      IF ARG(c,0)
        PrintF(' \d',ARGNUMBER(c,0))
      ENDIF
    CASE AREXX_SAVE
      PrintF('SAVE')
      IF ARG(c,0)
        PrintF(' AS')
      ENDIF
      IF ARG(c,1)
        PrintF(' \s',ARGSTRING(c,1))
      ENDIF
    CASE AREXX_TEXT
      PrintF('TEXT')
      IF ARG(c,0)
        PrintF(' \a\s\a',ARGSTRING(c,0))
      ENDIF
    CASE AREXX_RX
      PrintF('RX \a\s\a\n*Sending command asynchronously: \a\s\a to the \a\s\a port',ARGSTRING(c,0),ARGSTRING(c,0),c.portname)
      SendARexxCommandA(ARGSTRING(c,0),[ER_Port,c.port,ER_Context,c,ER_Asynch,TRUE,TAG_DONE])
    CASE AREXX_CAUSEERROR
      PrintF('CAUSEERROR')
      error:='Error: Because you asked for it ;)'
      result1:=RC_ERROR
    ENDSELECT
    ReplyARexxMsgA(c,[
                      ER_ReturnCode,result1,
                      IF error THEN ER_ErrorMessage ELSE TAG_IGNORE,error,
                      IF resultstring THEN ER_ResultString ELSE TAG_IGNORE,resultstring,
                      TAG_DONE])
    PrintF('\n')
  ENDIF
ENDPROC done

PROC main()
  DEF done=FALSE
  DEF context=NIL:PTR TO arexxcontext,signals=0

  IF easyrexxbase:=OpenLibrary(EASYREXXNAME, EASYREXXVERSION)
    context:=AllocARexxContextA([ER_CommandTable,
                                  [AREXX_CLEAR,'CLEAR','FORCE/S',NIL,
                                   AREXX_GETVAR,'GETVAR','HELLOWORLD/S',NIL,
                                   AREXX_HELP,'HELP','AMIGAGUIDE/S,TOPIC/F',NIL,
                                   AREXX_OPEN,'OPEN','PROJECT/S,TEXT/S,NAME/F',NIL,
                                   AREXX_QUIT,'QUIT','',NIL,
                                   AREXX_ROW,'ROW','NUMBER/A/N',NIL,
                                   AREXX_SAVE,'SAVE','AS/S,NAME/F',NIL,
                                   AREXX_TEXT,'TEXT','TEXT/A/F',NIL,
                                   AREXX_RX,'RX','COMMAND/A/F',NIL,
                                   AREXX_CAUSEERROR,'CAUSEERROR','',NIL,
                                   TABLE_END]:arexxcommandtable,
                                 ER_Author,'Ketil Hunn',
                                 ER_Copyright,'© 1995 Ketil Hunn',
                                 ER_Version,'2',
                                 ER_Portname,'EASYREXX_TEST',
                                 TAG_DONE])
  ELSE
    PrintF('easyrexx.library not found.\n')
  ENDIF
  IF context
    ArexxCommandShellA(context,[
                               WA_TITLE,'ARexx Commandline Interface',
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
    context:=0
  ENDIF
  IF easyrexxbase
    CloseLibrary(easyrexxbase)
    easyrexxbase:=0
  ENDIF
ENDPROC
