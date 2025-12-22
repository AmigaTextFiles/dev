-> PopShell.e - Simple hot key commodity

OPT PREPROCESS  -> E-Note: we are using the CxXXX creation macros

MODULE 'commodities',
       'icon',
       'amigalib/argarray',
       'amigalib/cx',
       'devices/timer',
       'devices/inputevent',
       'dos/dos',
       'exec/ports',
       'libraries/commodities'

ENUM ERR_NONE, ERR_ARGS, ERR_BRKR, ERR_CRCX, ERR_CXERR, ERR_HOT, ERR_IE,
     ERR_LIB,  ERR_PORT

RAISE ERR_BRKR IF CxBroker()=NIL,
      ERR_CRCX IF CreateCxObj()=NIL,  -> E-Note: the CxXXX macros use this
      ERR_LIB  IF OpenLibrary()=NIL,
      ERR_PORT IF CreateMsgPort()=NIL

CONST EVT_HOTKEY=1

DEF broker_mp=NIL:PTR TO mp, broker=NIL, filter=NIL,
    cxsigflag, ie=NIL:PTR TO inputevent

PROC main() HANDLE
  DEF hotkey, ttypes=NIL, msg, newshell
  -> E-Note: we can use invertStringRev(), so we don't need to spell backwards!
  newshell:='newshell\b'
  cxbase:=OpenLibrary('commodities.library', 37)
  iconbase:=OpenLibrary('icon.library', 36)
  broker_mp:=CreateMsgPort()
  cxsigflag:=Shl(1, broker_mp.sigbit)
  -> E-Note: argArrayInit() uses global "wbmessage" and "arg" by default
  -> E-Note: C version fails to check return value
  IF NIL=(ttypes:=argArrayInit()) THEN Raise(ERR_ARGS)
  hotkey:=argString(ttypes, 'HOTKEY', 'rawkey control esc')

  broker:=CxBroker([NB_VERSION, 0,  -> E-Note: pad byte!
                    'RKM PopShell',  -> String to identify this broker
                    'A Simple PopShell',
                    'A simple PopShell commodity',
                    -> Don't want any new commodities starting with this name.
                    -> If someone tries it, let me know
                    NBU_UNIQUE OR NBU_NOTIFY,
                    0, argInt(ttypes, 'CX_PRIORITY', 0),
                    0, broker_mp, 0]:newbroker, NIL)

  -> hotKey() is an amigalib function that creates a filter, sender and
  -> translate CxObject and connects them to report a hot key press and
  -> delete its input event.
  IF NIL=(filter:=hotKey(hotkey, broker_mp, EVT_HOTKEY)) THEN Raise(ERR_HOT)

  -> Add a CxObject to another's personal list
  AttachCxObj(broker, filter)
  IF CxObjError(filter)<>FALSE THEN Raise(ERR_CXERR)

  -> invertString() is an amigalib function that creates a linked list of input
  -> events which would translate into the string passed to it.  Note that it
  -> puts the input events in the opposite order in which the corresponding
  -> letters appear in the string.  A translate CxObject expects them backwards.
  -> E-Note: ...so use invertStringRev() and stay sane...
  IF NIL=(ie:=invertStringRev(newshell, NIL)) THEN Raise(ERR_IE)

  ActivateCxObj(broker, TRUE)
  processMsg()

EXCEPT DO
  -> We have to release the memory allocated by invertStringRev.
  -> E-Note: ...well, this isn't really necessary since it uses NEW
  IF ie THEN freeIEvents(ie)
  -> DeleteCxObjAll() is a commodities.library function that not only deletes
  -> the CxObject pointed to in its argument, but deletes all of the CxObjects
  -> attached to it.
  IF broker THEN DeleteCxObjAll(broker)
  -> This amigalib function cleans up after argArrayInit()
  IF ttypes THEN argArrayDone()
  IF broker_mp  -> Empty the port of all CxMsgs
    WHILE msg:=GetMsg(broker_mp) DO ReplyMsg(msg)
    DeleteMsgPort(broker_mp)
  ENDIF
  IF iconbase THEN CloseLibrary(iconbase)
  IF cxbase THEN CloseLibrary(cxbase)
  SELECT exception
  CASE ERR_ARGS;   WriteF('Error: Could not parse tooltypes/arguments\n')
  CASE ERR_BRKR;   WriteF('Error: Could not create broker\n')
  CASE ERR_CRCX;   WriteF('Error: Could not create CX object\n')
  CASE ERR_CXERR;  WriteF('Error: Could not activate broker\n')
  CASE ERR_HOT;    WriteF('Error: Could not create hot key\n')
  CASE ERR_LIB;    WriteF('Error: Could not open required library\n')
  CASE ERR_PORT;   WriteF('Error: Could not create message port\n')
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
        WriteF('A CXM_EVENT, ')
        SELECT msgid
        CASE EVT_HOTKEY
          -> We got the message from the sender CxObject
          WriteF('You hit the HotKey.\n')
          -> Add the string "newshell" to input * stream.  If a shell gets it,
          -> it'll open a new shell.
          AddIEvents(ie)
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
      done:=TRUE
      WriteF('CTRL C signal break\n')
    ENDIF
  UNTIL done
ENDPROC
