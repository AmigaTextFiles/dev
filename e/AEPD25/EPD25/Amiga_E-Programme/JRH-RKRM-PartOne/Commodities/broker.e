-> broker.e - Simple skeletal example of opening a broker.

MODULE 'commodities',
       'dos/dos',
       'exec/libraries',
       'exec/ports',
       'libraries/commodities'

ENUM ERR_NONE, ERR_ARG, ERR_BRKR, ERR_CXERR, ERR_LIB, ERR_PORT

RAISE ERR_BRKR IF CxBroker()=NIL,
      ERR_LIB  IF OpenLibrary()=NIL,
      ERR_PORT IF CreateMsgPort()=NIL
    
DEF broker=NIL, broker_mp=NIL:PTR TO mp, cxsigflag
  
PROC main() HANDLE
  DEF msg
  -> Before bothering with anything else, open the library
  cxbase:=OpenLibrary('commodities.library', 37)
  -> Commodities talks to a Commodities application through an Exec Message
  -> port, which the application provides
  broker_mp:=CreateMsgPort()

  -> The commodities.library function CxBroker() adds a broker to the master
  -> list.  It takes two arguments, a pointer to a NewBroker structure and a
  -> pointer to a LONG.  The NewBroker structure contains information to set
  -> up the broker.  If the second argument is not NIL, CxBroker will fill it
  -> in with an error code.
  broker:=CxBroker(
           [NB_VERSION,   -> Version of the NewBroker object
            0,  -> E-Note: pad byte
           'RKM broker',  -> Name: commodities uses for this commodity
           'Broker',      -> Title of commodity that appears in CXExchange
           'A simple example of a broker',  -> Description
            0,  -> Unique: tells CX not to launch a commodity with the same name
            0,  -> Flags: tells CX if this commodity has a window
            0,  -> Pri: this commodity's priority
            0,  -> E-Note: pad byte
            broker_mp, -> Port: mp CX talks to
            0   -> ReservedChannel: reserved for later use
           ]:newbroker, NIL)
  cxsigflag:=Shl(1, broker_mp.sigbit)

  -> After it's set up correctly, the broker has to be activated
  ActivateCxObj(broker, TRUE)

  -> The main processing loop
  processMsg()

EXCEPT DO
  -> It's time to clean up.  Start by removing the broker from the Commodities
  -> master list.  The DeleteCxObjAll() function will take care of removing a
  -> CxObject and all those connected to it from the Commodities network
  IF broker THEN DeleteCxObj(broker)
  IF broker_mp
    -> Empty the port of CxMsgs
    WHILE msg:=GetMsg(broker_mp) DO ReplyMsg(msg)
    DeleteMsgPort(broker_mp) -> E-Note: C version incorrectly uses DeletePort()
  ENDIF
  IF cxbase THEN CloseLibrary(cxbase)
  SELECT exception
  CASE ERR_BRKR;  WriteF('Error: Could not create broker\n')
  CASE ERR_CXERR; WriteF('Error: Could not activate broker\n')
  CASE ERR_LIB;   WriteF('Error: Could not open commodities.library\n')
  CASE ERR_PORT;  WriteF('Error: Could not create message port\n')
  ENDSELECT
ENDPROC

PROC processMsg()
  DEF msg, sigrcvd, msgid, msgtype, done=FALSE
  REPEAT
    -> Wait for something to happen
    sigrcvd:=Wait(SIGBREAKF_CTRL_C OR cxsigflag)

    -> Process any messages
    WHILE msg:=GetMsg(broker_mp)
      -> Extract any necessary information from the CxMessage and return it
      msgid:=CxMsgID(msg)
      msgtype:=CxMsgType(msg)
      ReplyMsg(msg)

      SELECT msgtype
      CASE CXM_IEVENT
        -> Shouldn't get any of these in this example
      CASE CXM_COMMAND
        -> Commodities has sent a command
        WriteF('A command: ')
        SELECT msgid
        CASE CXCMD_DISABLE
          WriteF('CXCMD_DISABLE\n')
          -> The user clicked CX Exchange disable gadget, better disable
          ActivateCxObj(broker, FALSE)
        CASE CXCMD_ENABLE
          -> User clicked enable gadget
          WriteF('CXCMD_ENABLE\n')
          ActivateCxObj(broker, TRUE)
        CASE CXCMD_KILL
          -> User clicked kill gadget, better quit
          WriteF('CXCMD_KILL\n')
          done:=TRUE
        ENDSELECT
      DEFAULT
        WriteF('Unknown msgtype\n')
      ENDSELECT
    ENDWHILE
    -> Test to see if user tried to break
    IF sigrcvd AND SIGBREAKF_CTRL_C
      done:=TRUE
      WriteF('CTRL C signal break\n')
    ENDIF
  UNTIL done
ENDPROC
