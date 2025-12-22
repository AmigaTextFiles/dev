' tabsdemo.bas V0.1
' Author: 	steffen.leistner@styx.in-chemnitz.de
' Compiler: HSB 2.0
' Includes: 3.1

DEFLNG a-z

REM $NOLIBRARY
REM $NOEVENT
REM $NOBREAK
REM $NOWINDOW
REM $NOSTACK
REM $NOOVERFLOW
REM $NOVARCHECKS

REM $INCLUDE exec.bh
REM $INCLUDE graphics.bh
REM $INCLUDE intuition.bh
REM $INCLUDE gadgets/gadgetpens.bc
REM $INCLUDE gadgets/tabs.bh

CONST MINVERSION& =	39&
CONST WORKBUFSIZE& = 1024&
CONST WINW& = 400
CONST WINH& = 80
CONST TABGAD% = 1%

'****************************************************************************

FUNCTION Main&
	Main& = RETURN_ERROR&
	
	check$ = "Libs:gadgets/tabs.gadget"
	IF NOT FEXISTS(check$)
		PRINT "Can't find " + check$
		EXIT FUNCTION
	END IF
	
	LIBRARY OPEN "exec.library", MINVERSION&
	LIBRARY OPEN "intuition.library"
	LIBRARY OPEN "gadgets/tabs.gadget"
	
	workbuf& = AllocVec&(workbufsize&, MEMF_PUBLIC& OR MEMF_CLEAR&)
	IF workbuf& = NULL&
		PRINT "Not enough Memory!"
		EXIT FUNCTION
	END IF
	
	TAGLIST workbuf&, _
		WA_AutoAdjust&,		TRUE&, _
		WA_InnerWidth&,		winw&, _
		WA_InnerHeight&,	winh&, _
		WA_GimmeZeroZero&,	TRUE&, _
		WA_DragBar&,		TRUE&, _
		WA_RMBTrap&,		TRUE&, _
		WA_CloseGadget&,	TRUE&, _
		WA_DepthGadget&,	TRUE&, _
		WA_SimpleRefresh&,	TRUE&, _
		WA_IDCMP&,			IDCMP_CLOSEWINDOW& OR IDCMP_REFRESHWINDOW& _
							OR IDCMP_GADGETUP&, _
		WA_Title&,			"Select a folder:", _
		WA_ScreenTitle&,	"TabsDemo", _
	TAG_END&
	
	mainwin& = OpenWindowTagList&(NULL&, workbuf&)
	IF mainwin&
		
		tlabels& = AllocVec&(3 * TabLabel_SIZEOF%, MEMF_PUBLIC& OR MEMF_CLEAR&)
		DIM txt$(2%)
		
		FOR z% = 0% TO 2%
			pen% = z% + 1%
			txt$(z%) = "Folder" + STR$(pen%) + CHR$(0)
			POKEL tlabels& + (z% * TabLabel_SIZEOF%) + tl_Label%, SADD(txt$(z%))
			POKEW tlabels& + (z% * TabLabel_SIZEOF%) + tl_pens% + DL_TEXTPEN&, pen%
		NEXT z%

		fft& = PEEKL(PEEKL(mainwin& + WScreen%) + ScreenFont%)
	
		TAGLIST workbuf&, _
			GA_ID&,			TABGAD%, _
			GA_Top&,		PEEKB(mainwin& + BorderTop%) + 2%, _
			GA_Left&,		PEEKB(mainwin& + BorderLeft%), _
			GA_Height&,		PEEKW(fft& + ta_YSize%) + 6%, _
			GA_Width&,		PEEKW(mainwin& + WindowWidth%) - _
							PEEKB(mainwin& + BorderLeft%) - _
							PEEKB(mainwin& + BorderRight%) - 1%, _
			GA_TextAttr&,	fft&, _
			GA_RelVerify&,	TRUE&, _
			GA_Immediate&,	TRUE&, _
			GA_Previous&,	NULL&, _
			TABS_Labels&,	tlabels&, _
			TABS_Current&,	NULL&, _
		TAG_END&
		gadget& = NewObjectA& (NULL&, SADD("tabs.gadget" + CHR$(0)), workbuf&)
		
		IF gadget&
			junk& = AddGList& (mainwin&, gadget&, NOT NULL&, NOT NULL&, NULL&)
			RefreshGList gadget&, mainwin&, NULL, NOT NULL&
			
			userport& = PEEKL(mainwin& + UserPort%)
			
			DO
				junk& = WaitPort&(userport&)
				
				msg& = GetMsg&(userport&)
				IF msg&
					mclass&  = PEEKL(msg& + Class%)
					mcode% 	 = PEEKW(msg& + IntuiMessageCode%)
					mobject& = PEEKL(msg& + IAddress%)
					ReplyMsg msg&
					SELECT CASE mclass&
						CASE IDCMP_CLOSEWINDOW&
							EXIT LOOP
							
						CASE IDCMP_REFRESHWINDOW&
							BeginRefresh mainwin&
							EndRefresh mainwin&, TRUE&
						
						CASE IDCMP_GADGETUP&
							gad_id%  = PEEKW(mobject& + GadgetGadgetID%)
							SELECT CASE gad_id%
								CASE TABGAD%
									SetWindowTitles mainwin&, SADD("This is " + txt$(mcode%)), NOT NULL&
							END SELECT
							
					END SELECT
				END IF
			LOOP
			Main& = RETURN_OK&

			junk& = RemoveGList&(mainwin&, gadget&, NOT NULL&)
			DisposeObject gadget&

		ELSE
			PRINT "Can't create Gadget!"
		END IF

		FreeVec tlabels&
		CloseWindow mainwin&

	ELSE
		PRINT "Can't open Window!"
	END IF

	FreeVec workbuf&
END FUNCTION

'******************************************************************************

STOP Main&

DATA "$VER: TabsDemo V0.1 "