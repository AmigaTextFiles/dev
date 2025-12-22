REM Image-Demo3.bas
REM Demo for using standard-images with boopsi-gadgets
REM Author: steffen.leistner@styx.in-chemnitz.de
REM Requires Kickstart 2.0+ 

REM $NOLIBRARY
REM $NOWINDOW

REM $INCLUDE exec.bh
REM $INCLUDE dos.bh
REM $INCLUDE intuition.bh
REM $INCLUDE utility.bh
REM $INCLUDE blib/imagesupport.bas

LIBRARY OPEN "exec.library", 37&
LIBRARY OPEN "intuition.library"

'******************************************************************************

FUNCTION Main&

	Main& = RETURN_ERROR&

	img&(0) = StructImage& (0%,0%,47%,47%,2%,564&,diskdata&,3%,0%,0&)
	RESTORE DISK_IMAGE
	FOR zaehler& = 0& TO 563& STEP 2%
		READ wert%
		POKEW diskdata& + zaehler&, wert%
	NEXT zaehler&
	
	img&(1) = StructImage& (0%,0%,47%,47%,2%,564&,stopdata&,3%,0%,0&)
	RESTORE STOP_IMAGE
	FOR zaehler& = 0& TO 563& STEP 2%
		READ wert%
		POKEW stopdata& + zaehler&, wert%
	NEXT zaehler&
	workbuf& = AllocVec&(1024&, MEMF_PUBLIC& OR MEMF_CLEAR&)

	TAGLIST workbuf&, _
		IA_FrameType&,	FRAME_BUTTON&, _
	TAG_END&
	border& = NewObjectA&(NULL&, SADD("frameiclass" + CHR$(0)), workbuf&)
	
	TAGLIST workbuf&, _
		GA_Left&,			20&, _
		GA_Top&,			20&, _
		GA_Image&,			border&, _
		GA_LabelImage&,		img&(0), _
		GA_RelVerify&,		TRUE&, _
		GA_ID&,				1&, _
	TAG_END&
	gadget&(0) = NewObjectA&(NULL&, SADD("frbuttonclass" + CHR$(0)), workbuf&)
	
	TAGLIST workbuf&, _
		GA_Left&,			80&, _
		GA_Top&,			20&, _
		GA_Image&,			border&, _
		GA_LabelImage&,		img&(1), _
		GA_RelVerify&,		TRUE&, _
		GA_ID&,				2&, _
		GA_Previous&,		gadget&(0), _
	TAG_END&
	gadget&(1) = NewObjectA&(NULL&, SADD("frbuttonclass" + CHR$(0)), workbuf&)
		
	TAGLIST workbuf&, _
		WA_AutoAdjust&,		TRUE&, _
		WA_Width&,			170&, _
		WA_Height&,			110&, _
		WA_Gadgets&,		gadget&(0), _
		WA_GimmeZeroZero&,	TRUE&, _
		WA_Activate&,		TRUE&, _
		WA_DragBar&,		TRUE&, _
		WA_CloseGadget&,	TRUE&, _
		WA_DepthGadget&,	TRUE&, _
		WA_IDCMP&,			IDCMP_CLOSEWINDOW& OR IDCMP_GADGETUP&, _
		WA_Title&,			"Imagebuttons...", _
		WA_ScreenTitle&,	"Image-Demo 3", _
	TAG_END&
	mainwin& = OpenWindowTaglist&(NULL&, workbuf&)
	IF mainwin&

		userport& = PEEKL(mainwin& + UserPort%)

		DO
			junk& = WaitPort&(userport&)
			msg& = GetMsg&(userport&)
			IF msg&
				mclass&  = PEEKL(msg& + Class%)
				mobject& = PEEKL(msg& + IAddress%)
				ReplyMsg msg&
				
				SELECT CASE mclass&	
					CASE IDCMP_CLOSEWINDOW&
						EXIT LOOP
						
					CASE IDCMP_GADGETUP&
						gad_id%  = PEEKW(mobject& + GadgetGadgetID%)
						SetWindowTitles mainwin&, SADD("Button:" + STR$(gad_id%) + CHR$(0)), NOT NULL&
				
				END SELECT
			END IF
		LOOP
		CloseWindow mainwin&
		Main& = RETURN_OK&
	ELSE
		PRINT "Can't open Window!"
	END IF
	
	FOR z% = 0% TO 1%
		IF gadget&(z%) <> NULL&
			DisposeObject gadget&(z%)
		END IF
		IF img&(z%) <> NULL&
			FreeVec img&(z%)
		END IF
	NEXT z%
	
	DisposeObject border&
	FreeVec workbuf&

END FUNCTION

'******************************************************************************

STOP Main&

DATA "$VER: Image-Demo_3 V1.0 "

'**** ImageData ***************************************************************

DISK_IMAGE:
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H5554, &H0000, &H00FE, &HAAAB, &HF000, &H00FF, &H557D
	DATA &HF800, &H00FE, &HAABB, &HFC00, &H00FF, &H557D, &HFE00, &H00FE
	DATA &HAABB, &HFE00, &H00FF, &H557D, &HFE00, &H00FE, &HAABB, &HFE00
	DATA &H00FF, &H557D, &HFE00, &H00FE, &HAAAB, &HFE00, &H00FF, &H5555
	DATA &HFE00, &H00FF, &HFFFF, &HFE00, &H00FF, &HFFFF, &HFE00, &H00FF
	DATA &HFFFF, &HFE00, &H00FF, &HFFFF, &HFE00, &H00FF, &HFFFF, &HFE00
	DATA &H00FF, &HFFFF, &HFE00, &H00FF, &HFFFF, &HFE00, &H00F8, &H0000
	DATA &H3E00, &H00F0, &H0000, &H1E00, &H00F0, &H0000, &H1E00, &H00F0
	DATA &H0000, &H1E00, &H00F0, &H0000, &H1E00, &H00F0, &H0000, &H1E00
	DATA &H00F0, &H0000, &H1E00, &H00F0, &H0000, &H1E00, &H00F0, &H0000
	DATA &H1E00, &H00F8, &H0000, &H3E00, &H00FF, &HFFFF, &HFE00, &H00FF
	DATA &HFFFF, &HFE00, &H00FF, &HFFFF, &HFE00, &H01FF, &HFFFF, &HFE00
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H00FF, &HFFFF, &HF000
	DATA &H01FF, &HFFD7, &HF800, &H01FF, &HFFBF, &HFC00, &H01FF, &HFFFD
	DATA &HFE00, &H01FF, &HFFBF, &HFC00, &H01FF, &HFFFD, &HFC00, &H01FF
	DATA &HFFBF, &HFC00, &H01FF, &HFFFD, &HFC00, &H01FF, &HFFBF, &HFC00
	DATA &H01FF, &HFFFD, &HFC00, &H01FE, &HAAAB, &HFC00, &H01FF, &HFFFF
	DATA &HFC00, &H01FF, &HFFFF, &HFC00, &H01FF, &HFFFF, &HFC00, &H01FF
	DATA &HFFFF, &HFC00, &H01FF, &HFFFF, &HFC00, &H01FF, &HFFFF, &HFC00
	DATA &H01FF, &HFFFF, &HFC00, &H01FF, &HFFFF, &HFC00, &H01FF, &HFFFF
	DATA &HFC00, &H01FF, &HFFFF, &HFC00, &H01FF, &HFFFF, &HFC00, &H01FF
	DATA &HFFFF, &HFC00, &H01FF, &HFFFF, &HFC00, &H01FF, &HFFFF, &HFC00
	DATA &H01FF, &HFFFF, &HFC00, &H01FF, &HFFFF, &HFC00, &H01FF, &HFFFF
	DATA &HFC00, &H019F, &HFFFF, &HFC00, &H019F, &HFFFF, &HFC00, &H01FF
	DATA &HFFFF, &HFC00, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000
STOP_IMAGE:
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0FC0, &H0000
	DATA &H0000, &H3FF0, &H0000, &H0000, &H7878, &H0000, &H0000, &HE01C
	DATA &H0000, &H0001, &HC03E, &H0000, &H0001, &H8076, &H0000, &H0003
	DATA &H80E7, &H0000, &H0003, &H01C3, &H0000, &H0003, &H0383, &H0000
	DATA &H0003, &H0703, &H0000, &H0003, &H0E03, &H0000, &H0003, &H9C07
	DATA &H0000, &H0001, &HB806, &H0000, &H0001, &HF00E, &H0000, &H0000
	DATA &HE01C, &H0000, &H0000, &H7878, &H0000, &H0000, &H3FF0, &H0000
	DATA &H0000, &H0FC0, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0300, &H00F3
	DATA &HF1E3, &HE300, &H01FB, &HF3F3, &HF300, &H0188, &HC73B, &H3300
	DATA &H01F0, &HC61B, &H3300, &H00F8, &HC61B, &HF300, &H0118, &HC73B
	DATA &HE000, &H01F8, &HC3F3, &H0300, &H00F0, &HC1E3, &H0300, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0FC0, &H0000, &H0000, &H3FF0, &H0000
	DATA &H0000, &H7FF8, &H0000, &H0000, &HFC3C, &H0000, &H0001, &HF03E
	DATA &H0000, &H0001, &HE07F, &H0000, &H0003, &HC0FF, &H0000, &H0003
	DATA &HC1F3, &H8000, &H0003, &H83E3, &H8000, &H0003, &H87C3, &H8000
	DATA &H0003, &H8F83, &H8000, &H0003, &H9F07, &H8000, &H0001, &HFE07
	DATA &H8000, &H0001, &HFC0F, &H0000, &H0000, &HF81F, &H0000, &H0000
	DATA &H787E, &H0000, &H0000, &H3FFC, &H0000, &H0000, &H1FF8, &H0000
	DATA &H0000, &H07E0, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0080, &H0000
	DATA &H0800, &H0080, &H0075, &H38C0, &HC880, &H0004, &H2184, &H8880
	DATA &H0000, &H2104, &H0880, &H0064, &H2004, &H1980, &H0004, &H200C
	DATA &HF000, &H000C, &H2018, &H8080, &H0078, &H60F1, &H8180, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000, &H0000
	DATA &H0000, &H0000
	

	

