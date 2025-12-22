-> divert.e - commodity to monitor user inactivity

OPT PREPROCESS  -> E-Note: we are using the CxXXX creation macros

MODULE 'icon',
       'commodities',
       'amigalib/argarray',
       'other/ecode',
       'devices/inputevent',
       'dos/dos',
       'exec/libraries',
       'exec/ports',
       'libraries/commodities'

ENUM ERR_NONE, ERR_ARGS, ERR_BRKR, ERR_CRCX, ERR_CXERR, ERR_ECODE, ERR_LIB,
     ERR_PORT, ERR_SIG

RAISE ERR_BRKR IF CxBroker()=NIL,
      ERR_CRCX IF CreateCxObj()=NIL,  -> E-Note: the CxXXX macros use this
      ERR_LIB  IF OpenLibrary()=NIL,
      ERR_PORT IF CreateMsgPort()=NIL,
      ERR_SIG  IF AllocSignal()=-1
    
CONST TIMER_CLICKS=100

DEF broker_mp=NIL:PTR TO mp, broker=NIL, cocustom=NIL, cosignal=NIL,
    task, cxsigflag, signal=-1, cxobjsignal
  
-> E-Note: the C static used in the custom function is just a global variable
DEF time=0

PROC main() HANDLE
  DEF ttypes=NIL, msg, cxfunc
  cxbase:=OpenLibrary('commodities.library', 37)
  -> Open the icon.library for support functions, argXXX()
  iconbase:=OpenLibrary('icon.library', 36)
  broker_mp:=CreateMsgPort()
  cxsigflag:=Shl(1, broker_mp.sigbit)

  -> argArrayInit() is a support function (in the 2.0 version of amigalib)
  -> that makes it easy to read arguments from either a CLI or from
  -> Workbench's ToolTypes.  Because it uses icon.library, the library has
  -> to be open before before calling this function.  argArrayDone() cleans
  -> up after this function.
  -> E-Note: uses global "wbmessage" and "arg" so it needs no arguments
  ttypes:=argArrayInit()

  broker:=CxBroker([NB_VERSION, 0, 'Divert',  -> String to identify this broker
                    'Divert', 'Show divert',
                    -> Don't want any new commodities starting with this name.
                    -> If someone tries it, let me know
                    NBU_UNIQUE OR NBU_NOTIFY, 0,
  -> argInt() (in amigalib) searches through the array set up by argArrayInit()
  -> for a specific ToolType.  If it finds one, it returns the numeric value of
  -> the number that followed the ToolType (e.g., CX_PRIORITY=7).  If it doesn't
  -> find the ToolType, it returns the default value (the third argument).
                    argInt(ttypes, 'CX_PRIORITY', 0),
                    0, broker_mp, 0]:newbroker, NIL)

  -> CxCustom() takes two arguments, a pointer to the custom function and an
  -> ID.  Commodities Exchange will assign that ID to any CxMsg passed to the
  -> custom function.
  -> E-Note: eCodeCxCustom() protects an E function so you can use it as a
  ->         CX custom function
  IF NIL=(cxfunc:=eCodeCxCustom({cxFunction})) THEN Raise(ERR_ECODE)
  cocustom:=CxCustom(cxfunc, 0)
  AttachCxObj(broker, cocustom)

  -> Allocate a signal bit for the signal CxObj
  signal:=AllocSignal(-1)
  -> Set up the signal mask
  cxobjsignal:=Shl(1, signal)
  cxsigflag:=cxsigflag OR cxobjsignal

  -> CxSignal takes two arguments, a pointer to the task to signal (normally
  -> the commodity) and the number of the signal bit the commodity acquired
  -> to signal with.
  task:=FindTask(NIL)
  cosignal:=CxSignal(task, signal)
  AttachCxObj(cocustom, cosignal)
  ActivateCxObj(broker, TRUE)
  processMsg()

EXCEPT DO
  IF signal<>-1 THEN FreeSignal(signal)
  -> DeleteCxObjAll() is a commodities.library function that not only deletes
  -> the CxObject pointed to in its argument, but it deletes all of the
  -> CxObjects that are attached to it.
  IF broker THEN DeleteCxObjAll(broker)
  -> This amigalib function cleans up after argArrayInit()
  IF ttypes THEN argArrayDone()
  IF broker_mp
    -> Empty the port of all CxMsgs
    WHILE msg:=GetMsg(broker_mp) DO ReplyMsg(msg)
    DeleteMsgPort(broker_mp) -> E-Note: C version incorrectly uses DeletePort()
  ENDIF
  IF iconbase THEN CloseLibrary(iconbase)
  IF cxbase THEN CloseLibrary(cxbase)
  SELECT exception
  CASE ERR_ARGS;  WriteF('Error: Could not parse tooltypes/arguments\n')
  CASE ERR_BRKR;  WriteF('Error: Could not create broker\n')
  CASE ERR_CRCX;  WriteF('Error: Could not create CX object\n')
  CASE ERR_CXERR; WriteF('Error: Could not activate broker\n')
  CASE ERR_ECODE; WriteF('Error: Ran out of memory in eCodeCxCustom()\n')
  CASE ERR_LIB;   WriteF('Error: Could not open commodities.library\n')
  CASE ERR_PORT;  WriteF('Error: Could not create message port\n')
  CASE ERR_SIG;   WriteF('Error: Could not allocate signal\n')
  ENDSELECT
ENDPROC

PROC processMsg()
  DEF msg, sigrcvd, msgid, done=FALSE
  REPEAT
    sigrcvd:=Wait(SIGBREAKF_CTRL_C OR cxsigflag)

    WHILE msg:=GetMsg(broker_mp)
      msgid:=CxMsgID(msg)
      ReplyMsg(msg)

      SELECT msgid
      CASE CXCMD_DISABLE
        ActivateCxObj(broker, FALSE)
      CASE CXCMD_ENABLE
        ActivateCxObj(broker, TRUE)
      CASE CXCMD_KILL
        done:=TRUE
      CASE CXCMD_UNIQUE
        done:=TRUE
      ENDSELECT
    ENDWHILE

    IF sigrcvd AND SIGBREAKF_CTRL_C THEN done:=TRUE

    -> Check to see if the signal CxObj signalled us.
    IF sigrcvd AND cxobjsignal THEN WriteF('Got Signal\n')
  UNTIL done
ENDPROC

-> The custom function for the custom CxObject.  Any code for a custom CxObj
-> must be short and sweet because it runs as part of the input.device task.
PROC cxFunction(cxm, co)
  DEF ie:PTR TO inputevent

  -> Get the struct InputEvent associated with this CxMsg.  Unlike the
  -> InputEvent extracted from a CxSender's CxMsg, this is a *REAL* input
  -> event, be careful with it.
  ie:=CxMsgData(cxm)

  -> This custom function counts the number of timer events that go by while
  -> no other input events occur.  If it counts more than a certain amount of
  -> timer events, it clears the count and diverts the timer event CxMsg to the
  -> custom object's personal list.  If an event besides a timer event passes
  -> by, the timer event count is reset.
  IF ie.class=IECLASS_TIMER
    time++
    IF time>=TIMER_CLICKS
      time:=0
      DivertCxMsg(cxm, co, co)
    ENDIF
  ELSE
    time:=0
  ENDIF
ENDPROC
