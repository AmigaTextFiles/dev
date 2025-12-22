/* AppMenuItem.d, loosely adapted from RKRM libraries 3rd ed. */
/* translated from AppMenuItem.e */

OPT OSVERSION=37,NOSTD

MODULE 'wb'

DEF	myport,appitem,appmsg,WorkbenchBase

PROC main()
	IF WorkbenchBase:=OpenLibrary('workbench.library',37)
		IF myport:=CreateMsgPort()
			IF appitem:=AddAppMenuItemA(0,0,'DisplayBeep()',myport,NIL)
				PrintF('Come on, go and see whats in the Tools menu ...\n')
				WaitPort(myport)
				DisplayBeep(NIL)
				PrintF('Wow, you found it!\n')
				RemoveAppMenuItem(appitem)
				WHILE appmsg:=GetMsg(myport) DO ReplyMsg(appmsg)
			ENDIF
			DeleteMsgPort(myport)
		ENDIF
		CloseLibrary(WorkbenchBase)
	ENDIF
ENDPROC
