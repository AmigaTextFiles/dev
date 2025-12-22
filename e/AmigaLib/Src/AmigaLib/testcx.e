OPT PREPROCESS

MODULE 'commodities',
       'amigalib/cx',
       'devices/timer',
       'devices/inputevent',
       'dos/dos',
       'exec/ports',
       'libraries/commodities'

ENUM ERR_NONE, ERR_BRKR, ERR_CRCX, ERR_CXERR, ERR_HOT, ERR_LIB, ERR_PORT

RAISE ERR_BRKR IF CxBroker()=NIL,
      ERR_CRCX IF CreateCxObj()=NIL,
      ERR_LIB  IF OpenLibrary()=NIL,
      ERR_PORT IF CreateMsgPort()=NIL

CONST EVT_HOTKEY=1

DEF broker_mp=NIL:PTR TO mp, broker=NIL, cxsigflag, ie:PTR TO inputevent

PROC main() HANDLE
  DEF hotkey, msg, newshell
  newshell:='newshell\b'
  cxbase:=OpenLibrary('commodities.library', 37)
  broker_mp:=CreateMsgPort()
  cxsigflag:=Shl(1, broker_mp.sigbit)

  broker:=CxBroker([NB_VERSION, 0,
                   'HotKey', 'Little Hotkey', 'A little hot key commodity',
                    NBU_UNIQUE OR NBU_NOTIFY,
                    0, 0, 0, broker_mp, 0]:newbroker, NIL)

  IF hotkey:=hotKey('rawkey control f1', broker_mp, EVT_HOTKEY)
    AttachCxObj(broker, hotkey)
    IF CxObjError(hotkey)<>FALSE
      Raise(ERR_CXERR)
    ELSE
      IF ie:=invertStringRev(newshell, NIL)
        ActivateCxObj(broker, TRUE)
        processMsg()
        freeIEvents(ie)
      ENDIF
    ENDIF
  ELSE
    Raise(ERR_HOT)
  ENDIF
EXCEPT DO
  IF broker THEN DeleteCxObjAll(broker)
  IF broker_mp
    WHILE msg:=GetMsg(broker_mp) DO ReplyMsg(msg)
    DeleteMsgPort(broker_mp)
  ENDIF
  IF cxbase THEN CloseLibrary(cxbase)
  SELECT exception
  CASE ERR_BRKR;   WriteF('Error: Could not create broker\n')
  CASE ERR_CRCX;   WriteF('Error: Could not create CX object\n')
  CASE ERR_CXERR;  WriteF('Error: Could not activate broker\n')
  CASE ERR_HOT;    WriteF('Error: Could not create hot key\n')
  CASE ERR_LIB;    WriteF('Error: Could not open required library\n')
  CASE ERR_PORT;   WriteF('Error: Could not create message port\n')
  ENDSELECT
ENDPROC

PROC processMsg()
  DEF msg, sigrcvd, msgid, msgtype, going=TRUE
  WHILE going
    sigrcvd:=Wait(SIGBREAKF_CTRL_C OR cxsigflag)
    WHILE msg:=GetMsg(broker_mp)
      msgid:=CxMsgID(msg)
      msgtype:=CxMsgType(msg)
      ReplyMsg(msg)
      SELECT msgtype
      CASE CXM_IEVENT
        IF msgid=EVT_HOTKEY
          WriteF('You hit the HotKey -- adding input events\n')
          AddIEvents(ie)
        ENDIF
      CASE CXM_COMMAND
        SELECT msgid
        CASE CXCMD_DISABLE
          ActivateCxObj(broker, FALSE)
        CASE CXCMD_ENABLE
          ActivateCxObj(broker, TRUE)
        CASE CXCMD_KILL
          going:=FALSE
        CASE CXCMD_UNIQUE
          going:=FALSE
        ENDSELECT
      ENDSELECT
    ENDWHILE
    IF sigrcvd AND SIGBREAKF_CTRL_C THEN going:=FALSE
  ENDWHILE
ENDPROC
