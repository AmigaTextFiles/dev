/* pAmigaIntuition.e 30-06-2016
	A collection of useful procedures/wrappers for the Intuition library.
	Copyright (c) 2009, 2010, 2011, 2012, 2016 Christopher Steven Handley ( http://cshandley.co.uk/email )
*/
OPT INLINE, PREPROCESS
PUBLIC MODULE 'intuition'
MODULE 'utility'
MODULE 'exec', 'dos/dos', 'utility/tagitem'
MODULE 'graphics', 'exec/types'

PROC new()
	utilitybase := OpenLibrary('utility.library', 0)
	IF utilitybase=NIL THEN CleanUp(RETURN_ERROR)
ENDPROC

PROC end()
	CloseLibrary(utilitybase)
ENDPROC

/*****************************/

->this doesn't do anything useful, except allow (non-functional) wheel code to compile on non-AmigaOS4 targets
#ifndef pe_TargetOS_AmigaOS4
	CONST IDCMP_EXTENDEDMOUSE = $08000000
	CONST IMSGCODE_INTUIWHEELDATA = $8000
	OBJECT intuiwheeldata ; wheelx ; wheely ; ENDOBJECT
#endif

/*****************************/

PROC menuNumExtractTitle(number) RETURNS title IS MENUNUM(number)
PROC menuNumExtractItem( number) RETURNS item  IS ITEMNUM(number)
PROC menuNumExtractSub(  number) RETURNS sub   IS SUBNUM( number)

PROC menuNumCombine(title, item, sub) RETURNS number IS FULLMENUNUM(title, item, sub)

/*****************************/

->NOTE: If you don't want a centered window, then use the WA_TOP & WA_LEFT tags.
->NOTE: WFLG_DRAGBAR and WFLG_DEPTHGADGET are set by default (unless WFLG_BORDERLESS is used), so supply these flags to REMOVE them!
->EX: idcmpFlags=IDCMP_CLOSEWINDOW, DEFAULT_IDCMP
->EX:   winFlags= WFLG_CLOSEGADGET, WFLG_ACTIVATE, WFLG_SIZEGADGET, WFLG_BORDERLESS
PROC openWindow(width, height, title:ARRAY OF CHAR, scr=NIL:PTR TO screen, idcmpFlags=0, winFlags=0, tagList=NILA:ARRAY OF tagitem) RETURNS win:PTR TO window, originX, originY, wasNotOnFrontScreen:BOOL
	DEF pubScr:PTR TO screen, intuiBase:PTR TO intuitionbase, xpos, ypos, rWidth, rHeight, hasTitleBar:BOOL
	
	IF winFlags AND WFLG_BORDERLESS = 0
		->auto-set DRAGBAR & DEPTHGADGET
		winFlags := winFlags XOR (WFLG_DRAGBAR OR WFLG_DEPTHGADGET)
		
		->determine if window will have a title bar
		hasTitleBar := winFlags AND (WFLG_CLOSEGADGET OR WFLG_DRAGBAR OR WFLG_DEPTHGADGET OR WFLG_RMBTRAP) <> 0
	ELSE
		hasTitleBar := FALSE
	ENDIF
	
	->open suitably sized window
	IF scr
		pubScr := NIL
	ELSE
		pubScr := LockPubScreen(NILA)
		IF pubScr = NIL THEN Throw("RES", 'pAmiga; openWindow(); failed to lock default public screen')
		
		scr := pubScr
	ENDIF
	
	originX := IF winFlags AND WFLG_BORDERLESS THEN 0      ELSE scr.wborleft
	originY := IF winFlags AND WFLG_BORDERLESS THEN 0      ELSE scr.wbortop
	rWidth  := IF winFlags AND WFLG_BORDERLESS THEN width  ELSE originX + width  + scr.wborright
	rHeight := IF winFlags AND WFLG_BORDERLESS THEN height ELSE originY + height + scr.wborbottom
	IF hasTitleBar
		->(window will have a titlebar) so account for it
		originY := originY + 1 + scr.font.ysize
		rHeight := rHeight + 1 + scr.font.ysize
	ENDIF
	
	xpos := scr.width  - rWidth  / 2 ; IF tagList THEN xpos := GetTagData(WA_LEFT, xpos, tagList)
	ypos := scr.height - rHeight / 2 ; IF tagList THEN ypos := GetTagData(WA_TOP , ypos, tagList)
	
	win := OpenWindowTagList(NIL, [
		WA_LEFT, xpos,
		WA_TOP,  ypos,
		->WA_WIDTH,  rWidth,
		->WA_HEIGHT, rHeight,
		WA_INNERWIDTH,  width,
		WA_INNERHEIGHT, height,
		WA_DETAILPEN, $FF,
		WA_BLOCKPEN,  $FF,
		WA_IDCMP, idcmpFlags,
		WA_FLAGS, winFlags,
		IF hasTitleBar THEN WA_TITLE ELSE TAG_IGNORE, title,
		IF scr THEN WA_CUSTOMSCREEN ELSE TAG_IGNORE, scr,
		IF tagList THEN TAG_MORE ELSE TAG_DONE, tagList
	]:tagitem)
	
	IF winFlags AND WFLG_SIZEGADGET THEN WindowLimits(win, win.width-width+1 !!INT, win.height-height+1 !!INT, -1, -1)
	
	IF winFlags AND WFLG_ACTIVATE
		intuiBase := intuitionbase!!PTR
		wasNotOnFrontScreen := (scr <> intuiBase.firstscreen)
		ScreenToFront(scr)
	ELSE
		wasNotOnFrontScreen := FALSE
	ENDIF
FINALLY
	IF exception
		IF win THEN CloseW(win)
	ENDIF
	IF pubScr THEN UnlockPubScreen(NILA, pubScr)
ENDPROC

PROC closeWindow(win:PTR TO window, wasNotOnFrontScreen=FALSE:BOOL) RETURNS nil:PTR TO window
	DEF winMsg:PTR TO intuimessage
	
	IF win = NIL THEN RETURN
	
	->undo moving screen to front
	IF wasNotOnFrontScreen THEN ScreenToBack(win.wscreen)
	
	->close window
	Forbid()
	->IF win.userport THEN StripIntuiMessages(win.userport, win)
	IF win.userport THEN WHILE winMsg := GetMsg(win.userport) !!PTR DO IF winMsg.execmessage.ln.type = NT_MESSAGE THEN ReplyMsg(winMsg.execmessage)
	->ModifyIDCMP(win, 0)
	CloseWindow(win)
	Permit()
	
	nil := NIL
ENDPROC

/*****************************/

PROC blankMousePointer(win:PTR TO window)
	SetPointer(win, [0,0]:UINT, 0, 0, 0, 0)
ENDPROC

PROC unblankMousePointer(win:PTR TO window)
	IF win THEN ClearPointer(win)
ENDPROC

/*****************************/
