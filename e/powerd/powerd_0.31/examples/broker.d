// broker.d - small example (originaly from broker.e) with comodities

MODULE	'commodities',
			'dos/dos',
			'exec/libraries',
			'exec/ports',
			'libraries/commodities'

ENUM	ERR_NONE, ERR_ARG, ERR_BRKR, ERR_CXERR, ERR_LIB, ERR_PORT

RAISE	ERR_BRKR IF CxBroker()=NIL,
		ERR_LIB  IF OpenLibrary()=NIL,
		ERR_PORT IF CreateMsgPort()=NIL
    
DEF	broker=NIL,broker_mp=NIL:PTR TO MP,cxsigflag,CXBase
  
PROC main()
	DEF	msg
	CXBase:=OpenLibrary('commodities.library', 37)
	broker_mp:=CreateMsgPort()
	broker:=CxBroker([
		NB_VERSION,
		'RKM broker',
		'Broker',
		'A simple example of a broker',
		0,0,0,
		broker_mp,
		0]:NewBroker,NIL)

	cxsigflag:=1<<broker_mp.SigBit

	ActivateCxObj(broker,TRUE)

	PrintF('Try Exchange\n')

	ProcessMsg()

EXCEPTDO
	IF broker THEN DeleteCxObj(broker)
	IF broker_mp
		WHILE msg:=GetMsg(broker_mp) DO ReplyMsg(msg)
		DeleteMsgPort(broker_mp)
	ENDIF
	IF CXBase THEN CloseLibrary(CXBase)
	SELECT exception
	CASE ERR_BRKR;  PrintF('Error: Could not create broker\n')
	CASE ERR_CXERR; PrintF('Error: Could not activate broker\n')
	CASE ERR_LIB;   PrintF('Error: Could not open commodities.library\n')
	CASE ERR_PORT;  PrintF('Error: Could not create message port\n')
	ENDSELECT
ENDPROC

PROC ProcessMsg()
	DEF	msg,sigrcvd,msgid,msgtype,done=FALSE
	REPEAT
		sigrcvd:=Wait(cxsigflag|SIGBREAKF_CTRL_C)
		
		WHILE msg:=GetMsg(broker_mp)
			msgid:=CxMsgID(msg)
			msgtype:=CxMsgType(msg)
			ReplyMsg(msg)
			SELECT msgtype
			CASE CXM_IEVENT
			CASE CXM_COMMAND
				PrintF('A command: ')
				SELECT msgid
				CASE CXCMD_DISABLE;	PrintF('CXCMD_DISABLE\n');	ActivateCxObj(broker,FALSE)
				CASE CXCMD_ENABLE;	PrintF('CXCMD_ENABLE\n');	ActivateCxObj(broker,TRUE)
				CASE CXCMD_KILL;		PrintF('CXCMD_KILL\n');		done:=TRUE
				ENDSELECT
			DEFAULT;						PrintF('Unknown msgtype\n')
			ENDSELECT
		ENDWHILE
		IF sigrcvd&SIGBREAKF_CTRL_C
			done:=TRUE
			PrintF('CTRL C signal break\n')
		ENDIF
	UNTIL done
ENDPROC
