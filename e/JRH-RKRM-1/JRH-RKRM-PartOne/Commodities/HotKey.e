-> HotKey.e - Simple hot key commodity

OPT PREPROCESS  -> E-Note: we are using the CxXXX creation macros

MODULE 'commodities',
       'icon',
       'amigalib/argarray',
       'dos/dos',
       'exec/ports',
       'libraries/commodities'

ENUM ERR_NONE, ERR_ARG, ERR_BRKR, ERR_CRCX, ERR_CXERR, ERR_LIB, ERR_PORT

RAISE ERR_BRKR IF CxBroker()=NIL,
      ERR_CRCX IF CreateCxObj()=NIL,  -> E-Note: the CxXXX macros use this
      ERR_LIB  IF OpenLibrary()=NIL,
      ERR_PORT IF CreateMsgPort()=NIL

CONST EVT_HOTKEY=1

DEF broker_mp=NIL:PTR TO mp, broker=NIL, filter=NIL, sender, translate,
    cxsigflag

PROC main() HANDLE
  DEF hotkey, ttypes=NIL, msg
  cxbase:=OpenLibrary('commodities.library', 37)
  -> Open the icon.library for the support functions, argArrayXXX()
  iconbase:=OpenLibrary('icon.library', 36)
  broker_mp:=CreateMsgPort()
  cxsigflag:=Shl(1, broker_mp.sigbit)

  -> argArrayInit() is a support function (from the 2.0 version of amiga.lib)
  -> that makes it easy to read arguments from either a CLI or from Workbench's
  -> ToolTypes.  Because it uses icon.library, the library has to be open before
  -> calling this function.  argArrayDone() cleans up after this function.
  -> E-Note: argArrayInit() needs no arguments: it uses global arg and wbmessage
  IF (ttypes:=argArrayInit())=NIL THEN Raise(ERR_ARG)

  broker:=CxBroker([NB_VERSION, 0,
                   'RKM HotKey',   -> String to identify this broker
                   'A Simple Hotkey',
                   'A simple hot key commodity',
                    -> Don't want any new commodities starting with this name.
                    -> If someone tries it, let me know
                    NBU_UNIQUE OR NBU_NOTIFY,
  -> argInt() (also in amiga.lib) searches through the array set up by
  -> argArrayInit() for a specific ToolType.  If it finds one, it returns the
  -> numeric value of the number that followed the ToolType (e.g.,
  -> CX_PRIORITY=7).  If it doesn't find the ToolType, it returns the default
  -> value (the third argument).
                    0, argInt(ttypes, 'CX_PRIORITY', 0), 0,
                    broker_mp, 0]:newbroker, NIL)

  -> argString() works just like argInt(), except it returns a pointer to a
  -> string rather than an integer.  In the example below, if there is no
  -> ToolType 'HOTKEY', the function returns a pointer to 'rawkey control esc'.
  hotkey:=argString(ttypes, 'HOTKEY', 'rawkey control esc')

  -> CxFilter() is a macro that creates a filter CxObject.  This filter passes
  -> input events that match the string pointed to by hotkey.
  filter:=CxFilter(hotkey)
  -> Add a CxObject to another's personal list
  AttachCxObj(broker, filter)

  -> CxSender() creates a sender CxObject.  Every time a sender gets a
  -> CxMessage, it sends a new CxMessage to the port pointed to in the first
  -> argument.  CxSender()'s second argument will be the ID of any CxMessages
  -> the sender sends to the port.  The data pointer associated with the
  -> CxMessage will point to a *COPY* of the InputEvent structure associated
  -> with the orginal CxMessage.
  sender:=CxSender(broker_mp, EVT_HOTKEY)
  AttachCxObj(filter, sender)

  -> CxTranslate() creates a translate CxObject.  When a translate CxObject
  -> gets a CxMessage, it deletes the original CxMessage and adds a new input
  -> event to the input.device's input stream after the Commodities input
  -> handler.  CxTranslate's argument points to an InputEvent structure from
  -> which to create the new input event.  In this example, the pointer is NIL,
  -> meaning no new event should be introduced, which causes any event that
  -> reaches this object to disappear from the input stream.
  translate:=CxTranslate(NIL)
  AttachCxObj(filter, translate)

  -> CxObjError() is a commodities.library function that returns the internal
  -> accumulated error code of a CxObject.
  IF CxObjError(filter)<>FALSE THEN Raise(ERR_CXERR)

  ActivateCxObj(broker, TRUE)
  processMsg()

EXCEPT DO
  -> DeleteCxObjAll() is a commodities.library function that not only deletes
  -> the CxObject pointed to in its argument, but it deletes all of the
  -> CxObjects that are attached to it.
  IF broker THEN DeleteCxObjAll(broker)
  IF broker_mp
    WHILE msg:=GetMsg(broker_mp) DO ReplyMsg(msg)
    DeleteMsgPort(broker_mp) -> E-Note: C version incorrectly uses DeletePort()
  ENDIF
  IF ttypes THEN argArrayDone()
  IF iconbase THEN CloseLibrary(iconbase)
  IF cxbase THEN CloseLibrary(cxbase)
  SELECT exception
  CASE ERR_ARG;   WriteF('Error: Could not init arg array\n')
  CASE ERR_BRKR;  WriteF('Error: Could not create broker\n')
  CASE ERR_CRCX;  WriteF('Error: Could not create CX object\n')
  CASE ERR_CXERR; WriteF('Error: Could not activate broker\n')
  CASE ERR_LIB;   WriteF('Error: Could not open required library\n')
  CASE ERR_PORT;  WriteF('Error: Could not create message port\n')
  ENDSELECT
ENDPROC

PROC processMsg()
  DEF msg, sigrcvd, msgid, msgtype, done=FALSE
  REPEAT
    sigrcvd:=Wait(SIGBREAKF_CTRL_C OR cxsigflag)
    WHILE msg:=GetMsg(broker_mp)
      msgid:=CxMsgID(msg)
      msgtype:=CxMsgType(msg)
      ReplyMsg(msg)
      SELECT msgtype
      CASE CXM_IEVENT
        WriteF('A CXM_IEVENT, ')
        SELECT msgid
        CASE EVT_HOTKEY  -> We got the message from the sender CxObject
          WriteF('You hit the HotKey.\n')
        DEFAULT
          WriteF('unknown.\n')
        ENDSELECT
      CASE CXM_COMMAND
        WriteF('A command: ')
        SELECT msgid
        CASE CXCMD_DISABLE
          WriteF('CXCMD_DISABLE\n')
          ActivateCxObj(broker, FALSE)
        CASE CXCMD_ENABLE
          WriteF('CXCMD_ENABLE\n')
          ActivateCxObj(broker, TRUE)
        CASE CXCMD_KILL
          WriteF('CXCMD_KILL\n')
          done:=TRUE
        CASE CXCMD_UNIQUE
          -> Commodities Exchange can be told not only to refuse to launch a
          -> commodity with a name already in use but also can notify the
          -> already running commodity that it happened.  It does this by
          -> sending a CXM_COMMAND with the ID set to CXMCMD_UNIQUE.  If the
          -> user tries to run a windowless commodity that is already running,
          -> the user wants the commodity to shut down.
          WriteF('CXCMD_UNIQUE\n')
          done:=TRUE
        DEFAULT
          WriteF('Unknown msgid\n')
        ENDSELECT
      DEFAULT
        WriteF('Unknown msgtype\n')
      ENDSELECT
    ENDWHILE
    IF sigrcvd AND SIGBREAKF_CTRL_C
      WriteF('CTRL C signal break\n')
      done:=TRUE
    ENDIF
  UNTIL done
ENDPROC
