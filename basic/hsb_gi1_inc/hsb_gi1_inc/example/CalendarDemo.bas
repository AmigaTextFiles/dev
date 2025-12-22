' calendardemo.bas V0.1
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
REM $INCLUDE gadgets/calendar.bh

CONST MINVERSION& =	39&
CONST WORKBUFSIZE& = 1024&
CONST WINW& = 320
CONST WINH& = 220
CONST CALGAD% = 2%

'****************************************************************************

FUNCTION Main&
	Main& = RETURN_ERROR&
	
	check$ = "Libs:gadgets/calendar.gadget"
	IF NOT FEXISTS(check$)
		PRINT "Can't find " + check$
		EXIT FUNCTION
	END IF
	
	LIBRARY OPEN "exec.library", MINVERSION&
	LIBRARY OPEN "intuition.library"
	LIBRARY OPEN "gadgets/calendar.gadget"
	
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
		WA_Title&,			"Select a day:", _
		WA_ScreenTitle&,	"CalendarDemo", _
	TAG_END&
	
	mainwin& = OpenWindowTagList&(NULL&, workbuf&)
	IF mainwin&
		
		fft& = PEEKL(PEEKL(mainwin& + WScreen%) + ScreenFont%)
	
		DIM pens%(MAX_DL_PENS&)
		pen%(DL_TEXTPEN&) 		= 1%	' use -1% for defaults
		pen%(DL_BACKGROUNDPEN&) = 0%
		pen%(DL_FILLTEXTPEN&)	= 3%
		pen%(DL_FILLPEN&)		= 2%
	
		dlabels& = AllocVec& (31 * DayLabel_SIZEOF%, MEMF_PUBLIC& OR MEMF_CLEAR&)
		FOR dstruct% = 0% TO 600% STEP 20%
			CopyMem VARPTR(pen%(0&)), dlabels& + dstruct% + dl_Pens%, MAX_DL_PENS& * 2%
		NEXT dstruct%
		
		RESTORE DayNames
		DIM daytexts&(6%)
		FOR z% = 0% TO 6%
			READ txt$
			daytexts&(z%) = SADD(txt$ + CHR$(0))
		NEXT z%
		
		TAGLIST workbuf&, _
			GA_ID&,					CALGAD%, _
			GA_Top&,				10%, _
			GA_Left&,				10%, _
			GA_Height&,				200, _
			GA_Width&,				300%, _
			GA_TextAttr&,			fft&, _
			GA_Previous&,			NULL&, _
			GA_RelVerify&,			TRUE&, _
			GA_Immediate&,			TRUE&, _
			GA_FollowMouse&,		TRUE&, _
			CALENDAR_Label&,		TRUE&, _
			CALENDAR_Labels&,		dlabels&, _
			CALENDAR_Days&,			VARPTR(daytexts&(0%)), _
			CALENDAR_FirstWeekDay&,	1&, _
		TAG_END&
		gadget& = NewObjectA& (NULL&, SADD("calendar.gadget" + CHR$(0)), workbuf&)
		
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
								CASE CALGAD%
									SetWindowTitles mainwin&, SADD(STR$(mcode%) + "." + _
													LEFT$(DATE$,2) + "." + RIGHT$(DATE$,2) + _
													CHR$(0)), NOT NULL&
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

		FreeVec dlabels&
		CloseWindow mainwin&

	ELSE
		PRINT "Can't open Window!"
	END IF

	FreeVec workbuf&
END FUNCTION

'******************************************************************************

STOP Main&

DATA "$VER: CalendarDemo V0.1 "

DayNames:
	DATA "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"