' buttondemo.bas V0.1
' Author: 	steffen.leistner@styx.in-chemnitz.de
' Compiler: HSB 2.0
' Includes: 3.1

' IMPORTANT: The button.gadget from then "Amiga Developer CD 1.1"
'            if not compatible with the button.gadget from the
'            "ClassAct" - Distribution. The ARRAY-Feature is not
'            supported!

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
REM $INCLUDE gadgets/button.bh

CONST MINVERSION& =	39&
CONST WORKBUFSIZE& = 1024&
CONST WINW& = 270
CONST WINH& = 80
CONST BUTTON_1% = 3%
CONST BUTTON_2% = 4%

'******************************************************************************

FUNCTION StructImage& (x%,y%,w%,h%,d%,g&,t&,p%,o%,n&)
	LOCAL imgs&, memb&
	memb& = g& + Image_sizeof%
	imgs& = AllocVec& (memb&, MEMF_CHIP& OR MEMF_CLEAR&)
	IF imgs& THEN
		t& 	= imgs& + Image_sizeof%
		POKEW imgs& + ImageLeftEdge%,	x%
		POKEW imgs& + ImageTopEdge%,	y%
		POKEW imgs& + ImageWidth%,		w%
		POKEW imgs& + ImageHeight%,		h%
		POKEW imgs& + ImageDepth%,		d%
		POKEL imgs& + ImageImageData%,	t&
		POKEB imgs& + ImagePlanePick%,	p%
		POKEB imgs& + ImagePlaneOnOff%,	o%
		POKEL imgs& + NextImage%,		n&
		StructImage& = imgs&
	ELSE
		ERROR 7
	END IF
END FUNCTION

'******************************************************************************

FUNCTION Main&
	Main& = RETURN_ERROR&
	
	check$ = "Libs:gadgets/button.gadget"
	IF NOT FEXISTS(check$)
		PRINT "Can't find " + check$
		EXIT FUNCTION
	END IF
	
	LIBRARY OPEN "exec.library", MINVERSION&
	LIBRARY OPEN "intuition.library"
	LIBRARY OPEN "gadgets/button.gadget"
	
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
		WA_Title&,			"Buttons with Text and Images:", _
		WA_ScreenTitle&,	"ButtonDemo", _
	TAG_END&
	
	mainwin& = OpenWindowTagList&(NULL&, workbuf&)
	IF mainwin&
		
		fft& = PEEKL(PEEKL(mainwin& + WScreen%) + ScreenFont%)
		
		TAGLIST workbuf&, _
			GA_ID&,					BUTTON_1%, _
			GA_Top&,				10%, _
			GA_Left&,				10%, _
			GA_Height&,				PEEKW(fft& + ta_YSize%) + 8%, _
			GA_Width&,				150%, _
			GA_TextAttr&,			fft&, _
			GA_Text&,				"Simple Text-Button", _
			GA_Previous&,			NULL&, _
			GA_RelVerify&,			TRUE&, _
		TAG_END&
		gadget&(0%) = NewObjectA& (NULL&, SADD("button.gadget" + CHR$(0)), workbuf&)
		
		DIM images&(1%)

		images&(0%) = StructImage& (0%,0%,64%,24%,2%,384&,okaydata&,3%,0%,0&)
		RESTORE OKAY_IMAGE
		FOR zaehler& = 0& TO 383& STEP 2%
			READ wert%
			POKEW okaydata& + zaehler&, wert%
		NEXT zaehler&
		images&(1%) = StructImage& (0%,0%,64%,24%,2%,384&,exitdata&,3%,0%,0&)
		RESTORE EXIT_IMAGE
		FOR zaehler& = 0& TO 383& STEP 2%
			READ wert%
			POKEW exitdata& + zaehler&, wert%
		NEXT zaehler&
		
		TAGLIST workbuf&, _
			GA_ID&,					BUTTON_2%, _
			GA_Top&,				10%, _
			GA_Left&,				180%, _
			GA_Height&,				26%, _
			GA_Width&,				66%, _
			GA_Image&,				VARPTR(images&(0%)), _
			GA_Previous&,			gadget&(0%), _
			GA_RelVerify&,			TRUE&, _
			BUTTON_Array&,			2&, _
		TAG_END&
		gadget&(1%) = NewObjectA& (NULL&, SADD("button.gadget" + CHR$(0)), workbuf&)
		
		IF (gadget&(0%) <> NULL&) AND (gadget&(1%) <> NULL&)
			junk& = AddGList& (mainwin&, gadget&(0%), NOT NULL&, NOT NULL&, NULL&)
			RefreshGList gadget&(0%), mainwin&, NULL, NOT NULL&
			
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
								
								CASE BUTTON_1%
									IF endloop& THEN
										EXIT LOOP
									ELSE
										SOUND 880,2
									END IF
								
								CASE BUTTON_2%
									IF mcode% = 1% THEN
										TAGLIST workbuf&, _
											GA_Text&,	"Perform", _
										TAG_END&
										junk& = SetGadgetAttrsA&(gadget&(0%), mainwin&, _
																NULL&, workbuf&)
										endloop& = TRUE&
									ELSE
										TAGLIST workbuf&, _
											GA_Text&,	"Simple Text-Button", _
										TAG_END&
										junk& = SetGadgetAttrsA&(gadget&(0%), mainwin&, _
																NULL&, workbuf&)
										endloop& = FALSE&
									END IF
							
							END SELECT
							
					END SELECT
				END IF
			LOOP
			Main& = RETURN_OK&

			junk& = RemoveGList&(mainwin&, gadget&(0%), NOT NULL&)
			DisposeObject gadget&

		ELSE
			PRINT "Can't create Gadget!"
		END IF

		FreeVec images&(0%)
		FreeVec images&(1%)
		FreeVec dlabels&
		CloseWindow mainwin&

	ELSE
		PRINT "Can't open Window!"
	END IF

	FreeVec workbuf&
END FUNCTION

'******************************************************************************

STOP Main&

DATA "$VER: ButtonDemo V0.1 "

OKAY_IMAGE:
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0380, &H0000, &H0000, &H000F, &H8380, &H0000, &H0000
	DATA &H003F, &HE380, &H0000, &H0000, &H0078, &HF380, &H0000, &H0000
	DATA &H0070, &H738F, &H1EEE, &H0E00, &H00E0, &H3B9E, &H3FEE, &H0E00
	DATA &H00E0, &H3BBC, &H79E7, &H1C00, &H00E0, &H3BF8, &H70E7, &H1C00
	DATA &H00E0, &H3BF0, &H70E3, &HB800, &H0070, &H73F8, &H70E3, &HB800
	DATA &H0078, &HF3BC, &H79E1, &HF000, &H003F, &HE39E, &H3FE1, &HF000
	DATA &H000F, &H838F, &H1EE0, &HE000, &H0000, &H0000, &H0000, &HE000
	DATA &H0000, &H0000, &H0001, &HC000, &H0000, &H0000, &H0003, &HC000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0380, &H0000, &H0000, &H000F, &H83E0, &H0000, &H0000
	DATA &H003F, &HE3E0, &H0000, &H0000, &H007F, &HFBE0, &H0000, &H0000
	DATA &H007E, &H7FEF, &H1EEE, &H0E00, &H00FC, &H3FFF, &HFFFF, &H8F80
	DATA &H00F8, &H3FFF, &HFFFF, &H9F80, &H00F8, &H3FFF, &H7EFF, &HDF00
	DATA &H00F8, &H3FFE, &H7CFB, &HFF00, &H0078, &H7FFC, &H7CFB, &HFE00
	DATA &H007C, &HFFFE, &H7DF9, &HFE00, &H003F, &HFFFF, &H3FF9, &HFC00
	DATA &H000F, &HFBEF, &H9FF8, &HFC00, &H0003, &HE0E3, &HC7B8, &HF800
	DATA &H0000, &H0000, &H0001, &HF800, &H0000, &H0000, &H0003, &HF000
	DATA &H0000, &H0000, &H0000, &HF000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
EXIT_IMAGE:
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0007, &HFCF0, &HF3CF, &HF800, &H0007, &HFC79, &HF3CF, &HF800
	DATA &H0007, &HBC79, &HE3CF, &HE800, &H0007, &H0439, &HC381, &HC000
	DATA &H0003, &H003F, &H8181, &HC000, &H0003, &HF82F, &H4181, &HC000
	DATA &H0003, &H100F, &H0181, &HC000, &H0003, &H100F, &H0181, &HC000
	DATA &H0001, &H000F, &H0181, &HC000, &H0001, &H800D, &H0100, &HC000
	DATA &H0001, &HF018, &H8100, &H8000, &H0001, &HD010, &H8000, &H8000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0007, &HFCF0, &HF3CF, &HF800, &H0007, &HFF7D, &HFFFF, &HFE00
	DATA &H0007, &HFF7F, &HFFFF, &HFE00, &H0007, &HEF3F, &HFBF3, &HFA00
	DATA &H0003, &HC13F, &HF1E1, &HF000, &H0003, &HF82F, &HE1E1, &HF000
	DATA &H0003, &HFE0F, &HD1E1, &HF000, &H0003, &HD40F, &HC1E1, &HF000
	DATA &H0001, &HC40F, &HC1E1, &HF000, &H0001, &HC00F, &HC160, &HF000
	DATA &H0001, &HF01B, &HC140, &HB000, &H0001, &HFC16, &HA040, &HA000
	DATA &H0000, &H7404, &H2000, &H2000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	

	

