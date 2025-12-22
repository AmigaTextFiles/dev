/* pAmiga_requesters.e 12-11-2010
	Some simple requesters, which are similar to the standard AmigaDos commands.
	Copyright (c) 2009,2010 Christopher Steven Handley ( http://cshandley.co.uk/email )
*/

OPT INLINE, POINTER
MODULE 'asl', 'gadtools'
MODULE 'exec', '*pAmigaDos', '*pAmigaGraphics', '*pAmigaIntuition', 'utility/tagitem'

PROC new()
	aslbase := OpenLibrary('asl.library', 39)
	IF aslbase=NIL THEN CleanUp(RETURN_ERROR)
	
	gadtoolsbase := OpenLibrary('gadtools.library', 39)
	IF gadtoolsbase=NIL THEN CleanUp(RETURN_ERROR)
ENDPROC

PROC end()
	CloseLibrary(aslbase)
	CloseLibrary(gadtoolsbase)
ENDPROC

/*****************************/

->NOTE: Allowed flags: FRF_DOSAVEMODE, FRF_DOMULTISELECT, FRF_DRAWERSONLY, FRF_REJECTICONS.
->NOTE: Suggested tag items: ASLFR_POSITIVETEXT,ASLFR_NEGATIVETEXT, ASLFR_SCREEN,ASLFR_WINDOW,ASLFR_SLEEPWINDOW,ASLFR_PRIVATEIDCMP.
PROC requestFile(drawer=NILA:ARRAY OF CHAR, file=NILA:ARRAY OF CHAR, pattern=NILA:ARRAY OF CHAR, title=NILA:ARRAY OF CHAR, flags=0, tagList=NILA:ARRAY OF tagitem) RETURNS files:OWNS STRING
	DEF freq:PTR TO filerequester, i, newFile:OWNS STRING
	
	files  := NILS
	
	IF freq := AllocAslRequest(ASL_FILEREQUEST, [
			ASLFR_TITLETEXT, IF title THEN title ELSE 'Select File',
			ASLFR_INITIALSHOWVOLUMES, drawer = NILA,
			IF drawer  THEN ASLFR_INITIALDRAWER  ELSE TAG_IGNORE, drawer,
			IF file    THEN ASLFR_INITIALFILE    ELSE TAG_IGNORE, file,
			IF pattern THEN ASLFR_INITIALPATTERN ELSE TAG_IGNORE, pattern,
			ASLFR_DOPATTERNS, pattern <> NILA,
			ASLFR_FLAGS1, flags AND (FRF_DOSAVEMODE  OR FRF_DOMULTISELECT),	->uses bits 3 & 5
			ASLFR_FLAGS2, flags AND (FRF_DRAWERSONLY OR FRF_REJECTICONS),	->uses bits 0 & 2
			/*
			ASLFR_DOSAVEMODE,    saveMode,
			ASLFR_DOMULTISELECT, multiSelect,
			ASLFR_DRAWERSONLY,   drawersOnly,
			ASLFR_REJECTICONS,   noIcons,
			*/
			->ASLFR_POSITIVETEXT, 'OK',
			->ASLFR_NEGATIVETEXT, 'Cancel',
			IF tagList THEN TAG_MORE ELSE TAG_END, tagList
		]:tagitem)
		
		IF AslRequest(freq, NILA)
			IF freq.numargs = 0
				IF freq.file
					NEW files[StrLen(freq.drawer) + 1 + StrLen(freq.file)]
					StrCopy(files, freq.drawer)
					strAddPart(files, freq.file)
				ELSE
					->(this is needed for AROS)
					files := StrJoin(freq.drawer)
				ENDIF
			ELSE
				FOR i := freq.numargs - 1 TO 0 STEP -1
					newFile := pathOfWbArg(freq.arglist[i])
					Link(newFile, PASS files)
					files := PASS newFile
				ENDFOR
			ENDIF
			
			->lastDrawer  := StrJoin(freq.drawer)
			->lastPattern := StrJoin(freq.pattern)
		ENDIF
		FreeAslRequest(freq) ; freq := NIL
	ENDIF
ENDPROC

->NOTE: Returns NILS if the user cancels the requester.
PROC requestString(title:ARRAY OF CHAR, message:ARRAY OF CHAR, defString=NILA:ARRAY OF CHAR, notEmpty=FALSE:BOOL, screen=NIL:PTR TO screen, positive=NILA:ARRAY OF CHAR, negative=NILA:ARRAY OF CHAR, maxLen=0) RETURNS result:OWNS STRING
	DEF lines:OWNS STRING, linesWidth, linesHeight
	DEF scr:PTR TO screen, width, height, border, fontA:PTR TO textattr, font:PTR TO textfont, font2A:textattr
	DEF win:PTR TO window, originX, originY, wasNotOnFrontScreen:BOOL
	DEF vi:PTR, glist:PTR TO gadget, myGads[MYGADSIZE]:ARRAY OF PTR TO gadget, gad:PTR TO gadget, ng:newgadget,
	    positiveStr:OWNS STRING, negativeStr:OWNS STRING, positiveChara:CHAR, negativeChara:CHAR
	DEF msg:PTR TO intuimessage, class, code, button, finished:BOOL
	
	scr   := NIL
	win   := NIL
	vi    := NIL
	font  := NIL
	glist := NIL
	
	border := 9		->was 4
	
	->use defaults
	IF positive = NILA THEN positive := 'OK'
	IF negative = NILA THEN negative := 'Cancel'
	IF screen = NIL
		scr := LockPubScreen(NILA)
		screen := scr
	ENDIF
	
	->prepare button hotkeys
	positiveStr := StrJoin('_', positive)
	negativeStr := StrJoin('_', negative)
	
	positiveChara := lowerChara(positive[0])
	negativeChara := lowerChara(negative[0])
	
	->split message into lines
	lines := formatLinesOfText(message)
	
	->open suitably sized window
	vi := GetVisualInfoA(screen, NILA)
	fontA := screen.font
	font  := OpenFont(fontA)
	
	font2A.name  := fontA.name
	font2A.ysize := fontA.ysize
	font2A.style := fontA.style OR FSF_BOLD !!UBYTE
	font2A.flags := fontA.flags
	
	linesWidth, linesHeight := sizeOfText(lines, font)
	linesWidth := Max(200, linesWidth)
	width  := (2 * border) + linesWidth
	height := (2 * border) + linesHeight + (font.ysize + border + 4) + (font.ysize + border + 4 + border)
	
	win, originX, originY, wasNotOnFrontScreen := openWindow(width, height, title, screen, IDCMP_ACTIVEWINDOW OR IDCMP_REFRESHWINDOW OR IDCMP_VANILLAKEY OR BUTTONIDCMP /*OR STRINGIDCMP*/, WFLG_ACTIVATE /*OR WFLG_SIZEGADGET*/)
	IF win = NIL THEN RETURN NILS
	
	SetFont(win.rport, font)
	IF scr
		UnlockPubScreen(NILA, scr) ; scr := NIL
	ENDIF
	
	->create gadgets
	gad := CreateContext(ADDRESSOF glist)
	ng. topedge   := originY + border !!INT
	ng.leftedge   := originX + border /*+ sizeOfLine('#gadgettext', font)*/ !!INT
	ng. width     := linesWidth  !!INT
	ng.height     := linesHeight !!INT
	ng.textattr   := fontA
	ng.flags      := NG_HIGHLABEL
	ng.visualinfo := vi
	ng.userdata   := NILA
	
	SetAPen(win.rport, 2)
	RectFill(win.rport, originX, originY, originX + width, originY + height)
	
	SetAPen(win.rport, 1)
	SetBPen(win.rport, 2)
	drawText(lines, win.rport, ng.leftedge, ng.topedge)
	/*
	ng.topedge    := ng.topedge
	ng.gadgettext := ''
	ng.gadgetid   := MYGAD_TEXT
	myGads[MYGAD_TEXT] := gad := CreateGadgetA(TEXT_KIND, gad, ng, [
		GTTX_TEXT,     message,		->only shows as one line
		GTTX_COPYTEXT, FALSE,
		GTTX_BORDER,   FALSE,
		GTTX_CLIPPED,  TRUE,
		GTTX_JUSTIFICATION, GTJ_LEFT,
		GT_UNDERSCORE, "_",
		TAG_DONE
	]:tagitem)
	*/
	
	ng. topedge   := ng.topedge + ng.height + border !!INT
	ng.height     := font.ysize + (font.ysize - font.baseline - 1) !!INT		-># this may only happen to work!
	ng.gadgettext := ''
	ng.gadgetid   := MYGAD_STRING
	myGads[MYGAD_STRING] := gad := CreateGadgetA(STRING_KIND, gad, ng, [
		IF defString  THEN GTST_STRING   ELSE TAG_IGNORE, defString,
		IF maxLen > 0 THEN GTST_MAXCHARS ELSE TAG_IGNORE, maxLen,
		GT_UNDERSCORE, "_",
		TAG_DONE
	]:tagitem)
	
	ng. topedge   := ng.topedge + ng.height + border !!INT
	ng. width     := Max(sizeOfLine(positiveStr, font), sizeOfLine(negativeStr, font)) + 25 !!INT
	ng.height     := ng.height + border !!INT
	ng.textattr   := font2A
	ng.gadgettext := positiveStr
	ng.gadgetid   := MYGAD_BUTTON1
	myGads[MYGAD_BUTTON1] := gad := CreateGadgetA(BUTTON_KIND, gad, ng, [GT_UNDERSCORE, "_", TAG_DONE]:tagitem)
	
	ng.leftedge   := ng.leftedge + linesWidth - ng.width !!INT
	ng.textattr   := fontA
	ng.gadgettext := negativeStr
	ng.gadgetid   := MYGAD_BUTTON2
	myGads[MYGAD_BUTTON2] := gad := CreateGadgetA(BUTTON_KIND, gad, ng, [GT_UNDERSCORE, "_", TAG_DONE]:tagitem)
	
	->add gadgets to window
	gad := NIL
	AddGList(win, glist, $FFFF, -1, NIL)
	RefreshGList( glist, win, NIL, -1)
	Gt_RefreshWindow(win, NIL)
	
	->activate string gadget
	ActivateGadget(myGads[MYGAD_STRING], win, NIL)
	
	->handle intuition events
	finished := FALSE
	REPEAT
		WaitPort(win.userport)
		
		msg := Gt_GetIMsg(win.userport)
		gad   := msg.iaddress
		class := msg.class
		code  := msg.code
		Gt_ReplyIMsg(msg)
		
		button := 0
		SELECT class
		->CASE IDCMP_GADGETDOWN
		->CASE IDCMP_MOUSEMOVE
		CASE IDCMP_GADGETUP
			IF gad.gadgetid = MYGAD_BUTTON1	->OK
				button := 1
			ELSE IF gad.gadgetid = MYGAD_BUTTON2	->Cancel
				button := 2
			ENDIF
			
		CASE IDCMP_VANILLAKEY
			code := lowerChara(code !!CHAR)
			IF (code = positiveChara) OR (code = 13)
				button := 1
			ELSE IF (code = negativeChara) OR (code = 27)
				button := 2
			ENDIF
			
		CASE IDCMP_REFRESHWINDOW
			Gt_BeginRefresh(win)
			Gt_EndRefresh(  win, TRUE)
			
			SetAPen(win.rport, 2)
			RectFill(win.rport, originX, originY, originX + width, originY + height)
			
			SetAPen(win.rport, 1)
			SetBPen(win.rport, 2)
			drawText(lines, win.rport, originY + border, originX + border)
			
		CASE IDCMP_ACTIVEWINDOW
			->reactivate string gadget
			ActivateGadget(myGads[MYGAD_STRING], win, NIL)
		ENDSELECT
		
		IF button = 1
			result := StrJoin(myGads[MYGAD_STRING].specialinfo::stringinfo.buffer)
			IF EstrLen(result) = 0 AND notEmpty
				END result
				DisplayBeep(win.wscreen)
			ELSE
				finished := TRUE
			ENDIF
			
		ELSE IF button = 2
			finished := TRUE
		ENDIF
	UNTIL finished
FINALLY
	IF exception THEN END result
	END lines
	END positiveStr, negativeStr
	IF scr THEN UnlockPubScreen(NILA, scr)
	IF win THEN win := closeWindow(win, wasNotOnFrontScreen)
	IF glist THEN FreeGadgets(glist)
	IF vi THEN FreeVisualInfo(vi)
	IF font THEN CloseFont(font)
ENDPROC
PRIVATE
ENUM MYGAD_TEXT, MYGAD_STRING, MYGAD_BUTTON1, MYGAD_BUTTON2, MYGADSIZE
PROC lowerChara(chara:CHAR) IS IF (chara >= "A") AND (chara <= "Z") THEN chara - "A" + "a" ELSE chara
PUBLIC

->NOTE: If success=FALSE then it returns result=defInteger.
PROC requestInteger(title:ARRAY OF CHAR, message:ARRAY OF CHAR, defInteger=0, min=0, max=-1, screen=NIL:PTR TO screen, positive=NILA:ARRAY OF CHAR, negative=NILA:ARRAY OF CHAR, maxLen=0) RETURNS result, success:BOOL
	DEF resultStr:OWNS STRING, defString:OWNS STRING
	DEF read
	
	IF maxLen <= 0 THEN maxLen := 10
	IF max < min THEN max := $7FFFFFFF
	
	NEW defString[maxLen]
	StringF(defString, '\d', defInteger)
	
	success := TRUE
	REPEAT
		resultStr := requestString(title, message, defString, /*notEmpty*/ TRUE, screen, positive, negative, maxLen)
		IF resultStr
			result, read := Val(resultStr)
			IF (read = 0) OR (read <> EstrLen(resultStr)) OR (result < min) OR (result > max)
				END defString
				defString := PASS resultStr
				read := 0
			ENDIF
		ELSE
			result := defInteger
			read   := 1
			success := FALSE
		ENDIF
	UNTIL read > 0
FINALLY
	END resultStr, defString
ENDPROC

->NOTE: "choices" is a string of the format 'choice1|choice2|choice0'.
PROC requestChoice(title:ARRAY OF CHAR, message:ARRAY OF CHAR, choices:ARRAY OF CHAR, parameters=NILL:ILIST, parentWindow=NIL:PTR TO window) RETURNS choice
	choice := EasyRequestArgs(parentWindow, [SIZEOF easystruct, 0, title, message, choices]:easystruct, NILA, IF parameters THEN parameters ELSE [0])
ENDPROC

