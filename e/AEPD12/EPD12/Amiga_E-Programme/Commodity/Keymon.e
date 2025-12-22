/*
	Keyboard monitor v1.0
*/
MODULE 'commodities','libraries/commodities','exec/ports','dos/dos','devices/inputevent',
	'intuition/intuition','intuition/intuitionbase','intuition/screens',
	'workbench/startup','workbench/workbench','icon','keymap'
ENUM NOERROR,ER_NOLIBRARY,ER_MESSAGEPORT
CONST GOT_ONE=232

DEF broker:PTR TO newbroker,messport:PTR TO mp,brokerobj,cxsigbit,filter,sender,
	buff

PROC main()
	DEF wb:PTR TO wbstartup,wba:PTR TO wbarg,dobj:PTR TO diskobject,toolarray,
	str,olddir=0,pri=0,read,rdargs,myargs[2]:LIST

	/* Probably will run under V36, but who still has only V36? */
	/* Besides, V36 sucks. */
	IF (KickVersion(37))=FALSE
		WriteF('Sorry, requires Kick V37+\n')
		getout(0)
	ENDIF
	IF (cxbase:=OpenLibrary('commodities.library',37))=0
		error(ER_NOLIBRARY,'commodities')
	ENDIF
	IF (keymapbase:=OpenLibrary('keymap.library',37))=0
		error(ER_NOLIBRARY,'keymap')
	ENDIF
	IF (iconbase:=OpenLibrary('icon.library',37))=0
		error(ER_NOLIBRARY,'icon')
	ENDIF
	/*
		This checks the tooltypes or command line arguments
		for priority.
	*/
	IF wbmessage
		wb:=wbmessage ; wba:=wb.arglist
		IF (wba.lock>0) AND (wba.name>0)
			olddir:=CurrentDir(wba.lock)
		ENDIF
		IF (dobj:=GetDiskObject(wba.name))>0
			toolarray:=dobj.tooltypes
			IF (str:=FindToolType(toolarray,'CX_PRIORITY'))>0
				pri:=Val(str,read)
				IF read=0
					pri:=0
				ENDIF
			ENDIF
			/* Add more checks here, before the freediskobject */
			FreeDiskObject(dobj)
		ENDIF
		IF olddir>0
			CurrentDir(olddir)
		ENDIF
	ELSE
		/*
			If commodity accepts other commodity args, like CX_POPKEY, or CX_POPUP
			or whatever it's called, they're put in the command line args as
			/K types. (Like here)
		*/
		IF (rdargs:=ReadArgs('CX_PRIORITY/N/K',myargs,0))>0
			pri:=Long(myargs[0])
			FreeArgs(rdargs)
		ENDIF
	ENDIF

	broker:=[NB_VERSION,0,'KeyMon','Keyboard Input Monitor','Buffers keyboard input to a file.',
	NBU_UNIQUE OR NBU_NOTIFY,0,0,0,0]:newbroker
	IF (messport:=CreateMsgPort())>0
		broker.port:=messport
		IF (brokerobj:=CxBroker(broker,0))>0
			cxsigbit:=Shl(1,messport.sigbit)
			IF (sender:=cxsender(messport,GOT_ONE))>0
				AttachCxObj(brokerobj,sender)
				ActivateCxObj(brokerobj,1)
				justdoit()
			ENDIF
			getout(0)
		ENDIF
	ELSE
		error(ER_MESSAGEPORT,0)
	ENDIF
	getout(0)
ENDPROC
CHAR '$VER: Keymon v1.0 (C) 1994 Jason Maskell',0

PROC justdoit()
	DEF msg:PTR TO mn,sigrcvd,msgid,msgtype,ievent:PTR TO inputevent,num
	buff:=New(100)
	LOOP
		sigrcvd:=Wait(SIGBREAKF_CTRL_C OR cxsigbit)
		WHILE (msg:=GetMsg(messport))
			ievent:=CxMsgData(msg) ; msgtype:=CxMsgType(msg) ; ReplyMsg(msg)
			SELECT msgtype
				CASE CXM_IEVENT
					IF ievent.class=IECLASS_RAWKEY
							num:=MapRawKey(ievent,buff,100,0)
						IF num=1
							Write(stdout,buff,num)
						ENDIF
					ENDIF
				CASE CXM_COMMAND
					msgid:=CxMsgID(msg)
					SELECT msgid
						CASE CXCMD_DISABLE
							ActivateCxObj(brokerobj,0)
						CASE CXCMD_ENABLE
							ActivateCxObj(brokerobj,1)
						CASE CXCMD_KILL
							RETURN 0
						CASE CXCMD_UNIQUE
							RETURN 0
					ENDSELECT
			ENDSELECT
		ENDWHILE
		IF (sigrcvd AND SIGBREAKF_CTRL_C)
			RETURN 0
		ENDIF
	ENDLOOP
ENDPROC
/*
	Commodities macros...
*/
PROC cxsender(port,id)
ENDPROC CreateCxObj(CX_SEND,port,id)

/*
	These are the commodities macros taken from the includes.h files..
	They allow you to use the rkm examples pretty easily.
*/

/*
PROC cxfilter(d)
ENDPROC CreateCxObj(CX_FILTER,d,0)
PROC cxtypefilter(type)
ENDPROC CreateCxObj(CX_TYPEFILTER,type,0)
PROC cxsignal(task,sig)
ENDPROC CreateCxObj(CX_SIGNAL,task,sig)
PROC cxtranslate(ie)
ENDPROC CreateCxObj(CX_TRANSLATE,ie,0)
PROC cxdebug(id)
ENDPROC CreateCxObj(CX_DEBUG,id,0)
PROC cxcustom(action,id)
ENDPROC CreateCxObj(CX_CUSTOM,action,id)
*/
PROC getout(retcode)
	DEF msg:PTR TO mn

	IF brokerobj
		DeleteCxObjAll(brokerobj)
	ENDIF
	IF messport
		WHILE (msg:=GetMsg(messport))
			ReplyMsg(msg)
		ENDWHILE
		DeleteMsgPort(messport)
	ENDIF
	IF cxbase
		CloseLibrary(cxbase)
	ENDIF
	IF keymapbase
		CloseLibrary(keymapbase)
	ENDIF
	IF iconbase
		CloseLibrary(iconbase)
	ENDIF
	CleanUp(retcode)
ENDPROC

PROC error(errnum,str)
	DEF work[80]:STRING
	SELECT errnum
		CASE ER_NOLIBRARY
			StringF(work,'Unable to open \s.library V37+',str)
		CASE ER_MESSAGEPORT
			StringF(work,'Unable to create message port.')
		DEFAULT
	ENDSELECT
	request(work,'Ok',0)
	getout(11)
ENDPROC
PROC request(body,gadgets,args)
ENDPROC EasyRequestArgs(0,[20,0,0,body,gadgets],0,args)
