' simpledemo.bas V0.1
' Author: 	steffen.leistner@styx.in-chemnitz.de
' Compiler: HBC 2.0
' Includes: 3.1
' Status: Freeware

' Feel free for using this code. No warranties.

DEFLNG a-z

REM $JUMPS
REM $NOLIBRARY
REM $NOBREAK
REM $NOWINDOW
REM $NOSTACK
REM $NOOVERFLOW
REM $NOVARCHECKS

REM $INCLUDE dos.bh
REM $INCLUDE asl.bh
REM $INCLUDE intuition.bh
REM $INCLUDE utility.bh
REM $INCLUDE gadgets/textfield.bh

CONST MINVERSION& =	37&
CONST SLIDERWIDTH% = 14%

DECLARE FUNCTION GetFile$(f$)
DECLARE SUB TabsToSpaces(s$)

'****************************************************************************

Main:	
	check$ = "Libs:gadgets/textfield.gadget"
	IF NOT FEXISTS(check$)
		PRINT "Can't find " + check$
		SYSTEM 20
	END IF
	
	LIBRARY OPEN "intuition.library", MINVERSION&
	LIBRARY OPEN "dos.library"
	LIBRARY OPEN "asl.library"
	LIBRARY OPEN "gadgets/textfield.gadget"
	
	ON ERROR GOTO Quit

	WINDOW 1,"Simple Textreader",(10%,20%)-(PEEKW(SYSTAB) - 20%, PEEKW(SYSTAB + 2%) - 40%), 30%

	GOSUB CreateGadgets
	
	MENU 1%, 0%, 1%, "Project"
	MENU 1%, 1%, 1%, "Load Text... "
	MENU 1%, 2%, 0%, "Print        "
	MENU 1%, 3%, 1%, "About        "
	MENU 1%, 4%, 1%, "Quit         "
	
	ON CLOSE GOSUB CloseAll
	ON MENU GOSUB Menuhandler
	CLOSE ON
	MENU ON
	
	IF LEN(COMMAND$) > NULL&
		file$ = COMMAND$
		GOSUB LoadFile
	END IF
	
	REPEAT eventloop
		SLEEP
		IF MENU(1%) = 4%
			EXIT eventloop
		END IF
	END REPEAT eventloop

Quit:

	GOSUB CloseAll

END

'******************************************************************************

CloseAll:
	IF txfg& THEN	
		junk& = RemoveGList&(winptr&, txfg&, NOT NULL&)
		DisposeObject txfg&
	END IF
	
	IF prop& THEN
		DisposeObject prop&
	END IF
	
	ERASE tags&, map1&, map2&
	
	LIBRARY CLOSE
	
	SYSTEM 0
RETURN

CreateGadgets:
	DIM tags&(40), map1&(4), map2&(8)
	winptr& = WINDOW(7%)
	
	TAGLIST VARPTR(map1&(0)), _
		PGA_Top&,	TEXTFIELD_Top&, _
	TAG_END&
	
	TAGLIST VARPTR(map2&(0)), _
		TEXTFIELD_Top&,		PGA_Top&, _
		TEXTFIELD_Visible&,	PGA_Visible&, _
		TEXTFIELD_Lines&,	PGA_Total&, _
	TAG_END&

	TAGLIST VARPTR(tags&(0)), _
		GA_ID&,				1&, _
		GA_Top&,			0&, _
		GA_RelRight&,		- sliderwidth%, _
		GA_Width&,			sliderwidth%, _
		GA_Height&,			PEEKW(winptr& + WindowHeight%) - _
							PEEKB(winptr& + BorderTop%) - _
							PEEKB(winptr& + BorderBottom%), _
		ICA_MAP&,			VARPTR(map1&(0)), _
		PGA_NewLook&,		TRUE&, _
		PGA_Visible&,		20%, _
		PGA_Total&,			50%, _
	TAG_END&
	prop& = NewObjectA&(NULL&, SADD("propgclass" + CHR$(0)), VARPTR(tags&(0)))
	
	IF prop& THEN
		TAGLIST VARPTR(tags&(0)), _
			GA_ID&,					2&, _
			GA_Top&,				0&, _
			GA_Left&,				0&, _
			GA_Width&,				PEEKW(winptr& + WindowWidth%) - _
									PEEKB(winptr& + BorderLeft%) - _ 
									PEEKB(winptr& + BorderRight%) - _
									sliderwidth% - 2%, _
			GA_Height&,				PEEKW(winptr& + WindowHeight%) - _
									PEEKB(winptr& + BorderTop%) - _
									PEEKB(winptr& + BorderBottom%), _
			GA_Previous&,			prop&, _
			ICA_MAP&,				VARPTR(map2&(0)), _
			ICA_TARGET&,			prop&, _
			TEXTFIELD_Text&,		SADD(CHR$(0%)), _
			TEXTFIELD_TextAttr&,	PEEKL(SYSTAB + 28%), _
			TEXTFIELD_Border&,		TEXTFIELD_BORDER_NONE&, _
			TEXTFIELD_ReadOnly&,	TRUE&, _
			TEXTFIELD_NoGhost&,		TRUE&, _
		TAG_END&

		txfg& = NewObjectA&(TEXTFIELD_GetClass&(NULL&), NULL&, VARPTR(tags&(0)))

		IF txfg& THEN
			TAGLIST	VARPTR(tags&(0)), ICA_TARGET&, txfg&, TAG_END&
			junk& = SetGadgetAttrsA&(prop&, winptr&, NULL&, VARPTR(tags&(0)))
			junk& = AddGList&(winptr&, prop&, NOT NULL&, NOT NULL&, NULL&)
			RefreshGList prop&, winptr&, NULL&, NOT NULL&
		ELSE
			PRINT "Can't create Textfield."
			SLEEP
			SYSTEM 10
		END IF
	ELSE
		PRINT "Can't create Propgadget."
		SLEEP
		SYSTEM 10
	END IF

RETURN

MenuHandler:
	pt% = MENU(1%)
	SELECT CASE pt%
		CASE 1%
			file$ = GetFile$(file$)
			IF file$ <> "" THEN
				GOSUB LoadFile
			END IF
		CASE 2%
			GOSUB PrintFile
		CASE 3%
			GOSUB About
	END SELECT
RETURN

LoadFile:
	IF FEXISTS(file$) THEN
		OPEN file$ FOR INPUT AS #1
			buf$ = INPUT$(LOF(1), #1) + CHR$(0%)
			TabsToSpaces buf$
		CLOSE #1
		TAGLIST	VARPTR(tags&(0)), TEXTFIELD_Text&, SADD(buf$), TAG_END&
		junk& = SetGadgetAttrsA&(txfg&, winptr&, NULL&, VARPTR(tags&(0)))
		SetWindowTitles WINDOW(7%), FilePart&(SADD(file$ + CHR$(0))), NOT NULL&
		MENU 1%, 2%, 1%
	ELSE
		buf$ = CHR$(10%) + " File not found: " + file$ + CHR$(0)
		TAGLIST	VARPTR(tags&(0)), TEXTFIELD_Text&, SADD(buf$), TAG_END&
		junk& = SetGadgetAttrsA&(txfg&, WINDOW(7%), NULL&, VARPTR(tags&(0)))
		MENU 1%, 2%, 0%
	END IF
RETURN

PrintFile:
	TAGLIST	VARPTR(tags&(0)), TEXTFIELD_ReadOnly&, TRUE&, TAG_END&
	junk& = SetGadgetAttrsA&(txfg&, WINDOW(7%), NULL&, VARPTR(tags&(0)))
	IF GetAttr&(TEXTFIELD_Size&, txfg&, VARPTR(size&)) THEN
		IF GetAttr&(TEXTFIELD_Text&, txfg&, VARPTR(textbuf&)) THEN
			POKEB SYSTAB + 33%, 0%
			BSAVE "PRT:", textbuf&, size&
		END IF
	END IF
	TAGLIST	VARPTR(tags&(0)), TEXTFIELD_ReadOnly&, FALSE&, TAG_END&
	junk& = SetGadgetAttrsA&(txfg&, WINDOW(7%), NULL&, VARPTR(tags&(0)))
RETURN

About:
	crt$ = PEEK$(TEXTFIELD_GetCopyright&(NULL&)) + CHR$(0%)
	n& = INSTR(crt$, CHR$(10%))
	IF n& THEN
		POKEB SADD(crt$) + n& - 1&, 32%
	END IF
	buf$ = "Simple BASIC-Demo, using the textfield.gadget." + CHR$(0%)
	SetWindowTitles WINDOW(7%), SADD(crt$), SADD(buf$)
RETURN

'******************************************************************************

SUB TabsToSpaces(s$)
	LOCAL n&
	n& = INSTR(1&, s$, CHR$(9%))
	WHILE n&
		POKEB SADD(s$) + n& - 1&, 32%
		n& = INSTR(n&, s$, CHR$(9%))
	WEND
END SUB

FUNCTION GetFile$(f$)
	SHARED txfg&, tags&()
	LOCAL req&, dir$, buf$
	GetFile$ = ""
	IF f$ = ""
		f$ = CHR$(0%)
	ELSE
		f$ = f$ + CHR$(0%)
	END IF
	req& = AllocAslRequest&(ASL_FileRequest&, NULL&)
	IF req&
		TAGLIST VARPTR(tags&(0%)), _
			ASLFR_Window&,			WINDOW(7%), _
			ASLFR_InitialFile&,		FilePart&(SADD(f$)), _
			ASLFR_InitialDrawer&,	LEFT$(f$, PathPart&(SADD(f$)) - SADD(f$)), _
			ASLFR_TitleText&,		"Select a Textfile:", _
		TAG_END&
		IF AslRequest&(req&, VARPTR(tags&(0%)))
			dir$ = PEEK$(PEEKL(req& + fr_Drawer%)) + STRING$(130%, 0%)
			IF AddPart&(SADD(dir$), PEEKL(req& + fr_File%), LEN(dir$))
				GetFile$ = PEEK$(SADD(dir$))
			END IF
		END IF
		FreeAslRequest req&
	ELSE
		buf$ = CHR$(10%) + " Can't alloc ASL-Requester!" + CHR$(0%)
		TAGLIST	VARPTR(tags&(0)), TEXTFIELD_Text&, SADD(buf$), TAG_END&
		junk& = SetGadgetAttrsA&(txfg&, WINDOW(7%), NULL&, VARPTR(tags&(0)))
	END IF
END FUNCTION

'******************************************************************************

DATA "$VER: SimpleDemo V0.1 "