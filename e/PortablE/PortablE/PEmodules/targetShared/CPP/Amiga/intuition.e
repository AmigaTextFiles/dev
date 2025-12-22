OPT POINTER, PREPROCESS
MODULE 'target/intuition', '*graphics', 'target/utility/tagitem', 'target/exec', 'target/graphics'

PROC SetColour(screen:PTR TO screen, colourreg:UBYTE, r:UBYTE, g:UBYTE, b:UBYTE)
	SetRGB32(screen.viewport, colourreg, r SHL (32-8), g SHL (32-8), b SHL (32-8))
	->or SetRGB4(screen.viewport, colourreg, r, g, b)
ENDPROC


PROC OpenW(x, y, width, height, idcmp, wflags, title:ARRAY OF CHAR, screen:PTR TO screen, sflags, gadgets:PTR TO gadget, taglist=NILA:ARRAY OF tagitem)
	DEF wptr:PTR TO window
	wptr := OpenWindowTagList(NIL, [
		WA_LEFT, x,
		WA_TOP, y,
		WA_WIDTH, width,
		WA_HEIGHT, height,
		WA_DETAILPEN, $FF !!VALUE!!UBYTE,
		WA_BLOCKPEN,  $FF !!VALUE!!UBYTE,
		WA_IDCMP, idcmp,
		WA_FLAGS, wflags,
		IF gadgets THEN WA_GADGETS ELSE TAG_IGNORE, gadgets,
		/*WA_CHECKMARK, NIL,*/
		WA_TITLE, title,
		IF screen THEN WA_CUSTOMSCREEN ELSE TAG_IGNORE, screen,
		/*WA_SUPERBITMAP, NIL, WA_MINWIDTH, 0, WA_MINHEIGHT, 0, WA_MAXWIDTH, 0, WA_MAXHEIGHT, 0,*/
		/*???, sflags,*/
		IF taglist THEN TAG_MORE ELSE TAG_DONE, taglist
	]:tagitem)
	/*unused*/ sflags := 0
	stdrast := wptr.rport
ENDPROC wptr

PROC CloseW(wptr:PTR TO window)
	IF wptr
		IF wptr.rport = stdrast THEN stdrast := NIL
		CloseWindow(wptr)
	ENDIF
ENDPROC

PROC OpenS(width, height, depth, sflags, title:ARRAY OF CHAR, taglist=NILA:ARRAY OF tagitem)
	DEF sptr:PTR TO screen
	DEF modeID
	
	modeID := BestModeIDA([BIDTAG_NOMINALWIDTH, width, BIDTAG_NOMINALHEIGHT, height, BIDTAG_DEPTH, depth, TAG_END]:tagitem)
	
	/*newscreen.viewmodes := sflags*/	sflags := 0
	
	sptr := OpenScreenTagList(NIL, [
		SA_LEFT, 0,
		SA_TOP, 0,
		SA_WIDTH, width,
		SA_HEIGHT, height,
		SA_DEPTH, depth,
		SA_DETAILPEN, DETAILPEN,
		SA_BLOCKPEN,  BLOCKPEN,
		SA_TYPE, CUSTOMSCREEN OR SHOWTITLE,
		SA_TITLE, title,
		IF modeID = INVALID_ID THEN TAG_IGNORE ELSE SA_DISPLAYID, modeID,
		/*SA_FONT, ['topaz.font', 8, FS_NORMAL, FPF_PROPORTIONAL OR FPF_DESIGNED]:textattr,*/
		IF taglist THEN TAG_MORE ELSE TAG_DONE, taglist
	]:tagitem)
	stdrast := sptr.rastport
ENDPROC sptr

PROC CloseS(sptr:PTR TO screen)
	IF sptr
		IF sptr.rastport = stdrast THEN stdrast := NIL
		CloseScreen(sptr)
	ENDIF
ENDPROC

CONST GADGETSIZE = 120

PROC Gadget(buffer:ARRAY, glist:ARRAY, id, flags, x, y, width, string:ARRAY OF CHAR)
	DEF nextbuffer:ARRAY
	DEF gadget:PTR TO gadget, border:PTR TO border, intuitext:PTR TO intuitext, borderxy:ARRAY OF INT
	DEF height:INT, firstgadget:PTR TO gadget
	DEF zero:ARRAY OF BYTE, i
	
	nextbuffer := buffer
	height := 12
	
	->clear memory (probably not necessary, but does no harm)
	zero := nextbuffer
	FOR i := 0 TO SIZEOF gadget + SIZEOF border + SIZEOF intuitext - 1
		zero[i] := 0
	ENDFOR
	
	->init Gadget
	gadget := nextbuffer !!PTR TO gadget
	gadget.nextgadget := NIL
	gadget.leftedge := x !!INT
	gadget.topedge  := y !!INT
	gadget.width    := width !!INT
	gadget.height   := height
	gadget.flags      := GFLG_GADGHCOMP OR (IF flags AND 2 THEN GFLG_SELECTED ELSE 0)
	gadget.activation := GACT_RELVERIFY OR (IF flags AND 1 THEN GACT_TOGGLESELECT ELSE 0)
	gadget.gadgettype := GTYP_BOOLGADGET
	->gadget.gadgetrender
	gadget.selectrender := NIL
	->gadget.gadgettext
	gadget.mutualexclude := 0
	gadget.specialinfo   := NIL
	gadget.gadgetid := 0
	gadget.userdata := id !!ARRAY
	nextbuffer := nextbuffer + SIZEOF gadget
	
	->init Border
	border := nextbuffer !!PTR TO border
	border.leftedge := 0
	border.topedge  := 0
	border.frontpen := 1
	border.backpen  := 0
	border.drawmode := 0
	border.count := 5
	->border.xy
	border.nextborder := NIL
	nextbuffer := nextbuffer + SIZEOF border
	
	->init IntuiText
	intuitext := nextbuffer !!PTR TO intuitext
	intuitext.frontpen := 1
	intuitext.backpen  := 0
	intuitext.drawmode := 1
	intuitext.leftedge := (width - (8 * StrLen(string))) / 2 !!INT
	intuitext.topedge  := 2
	intuitext.itextfont:= ['topaz.font', 8, FS_NORMAL, FPF_PROPORTIONAL OR FPF_DESIGNED]:textattr
	intuitext.itext    := string
	intuitext.nexttext := NIL
	nextbuffer := nextbuffer + SIZEOF intuitext
	
	->init BorderXY
	borderxy := nextbuffer !!ARRAY OF INT
	borderxy[0] := 0               ; borderxy[1] := 0
	borderxy[2] := 0               ; borderxy[3] := height - 1
	borderxy[4] := width - 1 !!INT ; borderxy[5] := height - 1
	borderxy[6] := width - 1 !!INT ; borderxy[7] := 0
	borderxy[8] := 0               ; borderxy[9] := 0
	nextbuffer := nextbuffer + (10 * SIZEOF INT)
	
	->link objects to each other
	gadget.gadgetrender := border
	gadget.gadgettext   := intuitext
	border.xy := borderxy
	
	->add Gadget to list
	IF glist
		firstgadget := glist!!PTR TO gadget
		gadget.nextgadget      := firstgadget.nextgadget
		firstgadget.nextgadget := gadget
	ENDIF
	
	IF (nextbuffer - buffer) > GADGETSIZE THEN Throw("BUG", 'Gadget(); GADGETSIZE is too small')
	nextbuffer := buffer + GADGETSIZE
ENDPROC nextbuffer

PROC Mouse()
	DEF code
	code := 0
	IF GetByte($BFE001 !!VALUE!!PTR) AND   64 THEN code := code OR 1
	IF GetInt( $DFF016 !!VALUE!!PTR) AND 1024 THEN code := code OR 2
	IF GetInt( $DFF016 !!VALUE!!PTR) AND  256 THEN code := code OR 4
ENDPROC code

PROC LeftMouse(win:PTR TO window) RETURNS button:BOOL
	DEF idcmp:LONG, msg:PTR TO intuimessage
	
	#ifdef pe_TargetOS_AmigaOS4
		GetWindowAttr(win, WA_IDCMP, ADDRESSOF idcmp, SIZEOF LONG)
	#else
		idcmp := win.idcmpflags !!LONG
	#endif
	ModifyIDCMP(win, IDCMP_MOUSEBUTTONS OR idcmp)
	
	msg := GetMsg(win.userport) !!PTR!!PTR TO intuimessage
	IF msg
		button := (msg.class = IDCMP_MOUSEBUTTONS) AND (msg.code = SELECTDOWN)
		ReplyMsg(msg.execmessage)
	ELSE
		button := FALSE
	ENDIF
ENDPROC

PROC WaitLeftMouse(win:PTR TO window)
	DEF idcmp:LONG, msg:PTR TO intuimessage, class, code
	
	#ifdef pe_TargetOS_AmigaOS4
		GetWindowAttr(win, WA_IDCMP, ADDRESSOF idcmp, SIZEOF LONG)
	#else
		idcmp := win.idcmpflags !!LONG
	#endif
	ModifyIDCMP(win, IDCMP_MOUSEBUTTONS OR idcmp)
	
	msg := GetMsg(win.userport) !!PTR!!PTR TO intuimessage
	REPEAT
		IF msg = NIL
			WaitPort(win.userport)
			msg := GetMsg(win.userport) !!PTR!!PTR TO intuimessage
		ENDIF
		
		class := msg.class
		code  := msg.code
		ReplyMsg(msg.execmessage)
		msg := NIL
	UNTIL (class = IDCMP_MOUSEBUTTONS) AND (code = SELECTDOWN)
ENDPROC

PROC MouseX(win:PTR TO window) IS win.mousex !!VALUE

PROC MouseY(win:PTR TO window) IS win.mousey !!VALUE


PRIVATE
DEF code, qual, iaddr:APTR
PUBLIC

PROC WaitIMessage(win:PTR TO window)
	DEF class
	DEF port:PTR TO mp, mes:PTR TO intuimessage
	
	port := win.userport
	WHILE (mes := GetMsg(port) !!PTR!!PTR TO intuimessage) = NIL
		WaitPort(port)
	ENDWHILE
	
	class := mes.class
	code  := mes.code
	qual  := mes.qualifier
	iaddr := mes.iaddress
	ReplyMsg(mes.execmessage)
ENDPROC class

PROC MsgCode() IS code

PROC MsgQualifier() IS qual

PROC MsgIaddr() IS iaddr

