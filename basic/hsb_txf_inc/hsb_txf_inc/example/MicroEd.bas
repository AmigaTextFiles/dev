' microed.bas V0.1
' Author: 	steffen.leistner@styx.in-chemnitz.de
' Compiler: HBC 2.0
' Includes: 3.1
' Status: Freeware

' Feel free for using this code. No warranties.

DEFLNG a-z

REM $NOSTACK
REM $NOBREAK
REM $NOLIBRARY
REM $NOWINDOW
REM $NOLINES
REM $NOEVENT
REM $NOARRAY
REM $NODEBUG
REM $NOOVERFLOW
REM $NOVARCHECKS
REM $AUTODIM
REM $NOERRORS
REM $HEAPDYNAMIC
REM $MINSTACK 200000

DEFLNG a-z

REM $INCLUDE intuition.bh
REM $INCLUDE exec.bh
REM $INCLUDE dos.bh
REM $INCLUDE graphics.bh
REM $INCLUDE diskfont.bh
REM $INCLUDE iffparse.bh
REM $INCLUDE utility.bh
REM $INCLUDE keymap.bh
REM $INCLUDE gadgets/textfield.bh
REM $INCLUDE gadtools.bh 
REM $INCLUDE asl.bh
REM $INCLUDE workbench.bh
REM $INCLUDE icon.bh
REM $INCLUDE amigaguide.bh
REM $INCLUDE BLib/gadtoolsmenus.bas

CONST MNLOAD&		= 1
CONST MNSAVE&		= 2
CONST MNABOUT&		= 3
CONST MNQUIT&		= 4
CONST MNCUT&		= 5
CONST MNCOPY&		= 6
CONST MNCOPYALL&	= 7
CONST MNPASTE&		= 8
CONST MNINSERT&		= 9
CONST MNERASE&		= 10
CONST MNUNDO&		= 11
CONST MNFONT&		= 12
CONST MNCURSOR&		= 13
CONST MNFIND&		= 14
CONST MNNEXT		= 15
CONST MNPRINT&		= 16
CONST MNPRINTBLOCK&	= 17
CONST MNFORMF&		= 18
CONST MNHELP&		= 19
CONST MNSAVEBLOCK&	= 20
CONST MNICON&		= 21
CONST MNHISTORY&	= 22

CONST sliderwidth%	= 12%

CONST PutIcon%		= 40%
CONST FormFeed%		= 41%
CONST FrontPen%		= 42%
CONST PaperPen%		= 43%
CONST BlockCsr%		= 44%
CONST WTop%			= 46%
CONST WLeft%		= 48%
CONST WWidth%		= 50%
CONST WHeight%		= 52%
CONST PrefsSize%	= 56%

'*** GadTools ***************************************************************

SUB SetNewGadget (ng&,x%,y%,w%,h%,t&,a&,i%,f&,v&,u&)
	POKEW ng& + ng_LeftEdge%,	x%
	POKEW ng& + ng_TopEdge%,	y%
	POKEW ng& + ng_Width%,		w%
	POKEW ng& + ng_Height%,		h%
	POKEL ng& + ng_GadgetText%,	t&
	POKEL ng& + ng_TextAttr%,	a&
	POKEW ng& + ng_GadgetID%,	i%
	POKEL ng& + ng_Flags%,		f&
	POKEL ng& + ng_VisualInfo%,	v&
	POKEL ng& + ng_UserData%,	u&
END SUB

'*** Requester **************************************************************

FUNCTION Requester& (titel$,body$,gadget$)
	SHARED winptr&
	LOCAL reqbufsize&, easystruct&, toffs&
	reqbufsize& = es_sizeof% + LEN(titel$) + LEN(body$) + LEN(gadget$) + 4&
	easystruct& = AllocVec& (reqbufsize&, MEMF_ANY& OR MEMF_CLEAR&)
	IF easystruct& THEN
		toffs& = easystruct& + es_sizeof%
		CopyMem SADD(titel$), toffs&, LEN(titel$)
		POKEL easystruct& + es_Title%, toffs&
		toffs& = easystruct& + es_sizeof% + LEN(titel$) + 1&
		CopyMem SADD(body$), toffs&, LEN(body$)
		POKEL easystruct& + es_TextFormat%, toffs&
		toffs& = easystruct& + es_sizeof% + LEN(titel$) + LEN(body$) + 2&
		CopyMem SADD(gadget$), toffs&, LEN(gadget$)
		POKEL easystruct& + es_GadgetFormat%, toffs&
		EasyRequest& = EasyRequestArgs& (winptr&, easystruct&, NULL&, NULL&)
		FreeVec easystruct&
	ELSE
		Requester& = NOT NULL&
	END IF
END FUNCTION

FUNCTION SelectTextFile$
	SHARED winptr&, tags&(), dstore$, oldstore$
	STATIC patt$
	SelectTextFile$ = ""
	
	IF patt$ = "" THEN
		patt$ = "#?"
	END IF
	
	IF dstore$ = CHR$(0) THEN
		dstore$ = oldstore$ + CHR$(0)
	END IF
	
	IF RIGHT$(dstore$,1%) <> CHR$(0) THEN
		dstore$ = dstore$ + CHR$(0)
	END IF
	
	req& = AllocAslRequest&(ASL_FileRequest&, NULL&)
	IF req& THEN
		TAGLIST VARPTR(tags&(0)), _
			ASLFR_Window&,			winptr&, _
			ASLFR_InitialLeftEdge&,	PEEKW(winptr& + WindowLeftEdge%) + PEEKB(winptr& + BorderLeft%), _
			ASLFR_InitialTopEdge&,	PEEKW(winptr& + WindowTopEdge%) + PEEKB(winptr& + BorderTop%), _
			ASLFR_InitialWidth&,	MAX(PEEKW(winptr& + WindowWidth%) \ 2, 300%), _
			ASLFR_InitialHeight&,	MAX(PEEKW(winptr& + WindowHeight%) - _
										PEEKB(winptr& + BorderTop%) - _
										PEEKB(winptr& + BorderBottom%), _
										PEEKW(SYSTAB + 2%) \ 2), _
			ASLFR_InitialFile&,		FilePart&(SADD(dstore$)), _
			ASLFR_InitialDrawer&,	LEFT$(dstore$, PathPart&(SADD(dstore$)) - SADD(dstore$)), _
			ASLFR_InitialPattern&,	patt$, _
			ASLFR_TitleText&,		"Select Textfile:", _
			ASLFR_PositiveText&,	"Load", _
			ASLFR_DoPatterns&,		TRUE&, _
		TAG_END&
		IF AslRequest&(req&, VARPTR(tags&(0))) THEN
			dir$ = PEEK$(PEEKL(req& + fr_Drawer%)) + STRING$(32%,0%)
			IF AddPart&(SADD(dir$), PEEKL(req& + fr_File%), LEN(dir$))
				dstore$ = PEEK$(SADD(dir$))
				patt$ = PEEK$(PEEKL(req& + fr_Pattern%))
				SelectTextFile$ = dstore$
			END IF
		END IF
		FreeAslRequest req&
	END IF
END FUNCTION

FUNCTION SaveTextFileAs$
	SHARED winptr&, tags&(), dstore$
	SaveTextFileAs$ = ""
		
	IF RIGHT$(dstore$,1%) <> CHR$(0) THEN
		dstore$ = dstore$ + CHR$(0)
	END IF
		
	req& = AllocAslRequest&(ASL_FileRequest&, NULL&)
	IF req& THEN
		TAGLIST VARPTR(tags&(0)), _
			ASLFR_Window&,			winptr&, _
			ASLFR_InitialLeftEdge&,	PEEKW(winptr& + WindowLeftEdge%) + PEEKB(winptr& + BorderLeft%), _
			ASLFR_InitialTopEdge&,	PEEKW(winptr& + WindowTopEdge%) + PEEKB(winptr& + BorderTop%), _
			ASLFR_InitialWidth&,	MAX(PEEKW(winptr& + WindowWidth%) \ 2, 300%), _
			ASLFR_InitialHeight&,	MAX(PEEKW(winptr& + WindowHeight%) - _
										PEEKB(winptr& + BorderTop%) - _
										PEEKB(winptr& + BorderBottom%), _
										PEEKW(SYSTAB + 2%) \ 2), _
			ASLFR_InitialFile&,		FilePart&(SADD(dstore$)), _
			ASLFR_InitialDrawer&,	LEFT$(dstore$, PathPart&(SADD(dstore$)) - SADD(dstore$)), _
			ASLFR_TitleText&,		"Save Textfile:", _
			ASLFR_PositiveText&,	"Save", _
			ASLFR_DoSaveMode&,		TRUE&, _
		TAG_END&
		IF AslRequest&(req&, VARPTR(tags&(0))) THEN
			dir$ = PEEK$(PEEKL(req& + fr_Drawer%)) + STRING$(32%,0%)
			IF AddPart&(SADD(dir$), PEEKL(req& + fr_File%), LEN(dir$))
				dstore$ = PEEK$(SADD(dir$))
				SaveTextFileAs$ = dstore$
			END IF
		END IF
		FreeAslRequest req&
	END IF	
END FUNCTION

FUNCTION SelectFont&
	SHARED currentfont&, global&, winptr&, tags&()
	
	req& = AllocAslRequest&(ASL_FontRequest&, NULL&)
	IF req& THEN
		TAGLIST VARPTR(tags&(0)), _
			ASLFO_Window&,			winptr&, _
			ASLFO_InitialLeftEdge&,	PEEKW(winptr& + WindowLeftEdge%) + PEEKB(winptr& + BorderLeft%), _
			ASLFO_InitialTopEdge&,	PEEKW(winptr& + WindowTopEdge%) + PEEKB(winptr& + BorderTop%), _
			ASLFO_InitialWidth&,	MAX(PEEKW(winptr& + WindowWidth%) \ 2, 300%), _
			ASLFO_InitialHeight&,	MAX(PEEKW(winptr& + WindowHeight%) - _
										PEEKB(winptr& + BorderTop%) - _
										PEEKB(winptr& + BorderBottom%), _
										PEEKW(SYSTAB + 2%) \ 2), _
			ASLFO_DoBackPen&,		TRUE&, _
			ASLFO_DoFrontPen&,		TRUE&, _
			ASLFO_MaxHeight&,		36%, _
			ASLFO_MinHeight&,		8%, _
			ASLFO_InitialName&,		PEEK$(PEEKL(global& + ta_Name%)), _
			ASLFO_InitialSize&,		PEEKW(global& + ta_YSize%), _
			ASLFO_InitialFrontPen&,	PEEKB(global& + FrontPen%), _
			ASLFO_InitialBackPen&,	PEEKB(global& + PaperPen%), _
			ASLFO_TitleText&,		"Select Font and Colors:", _
			ASLFO_PositiveText&,	"Use", _
		TAG_END&
		IF AslRequest&(req&, VARPTR(tags&(0))) THEN
			CloseFont currentfont&
			CopyMem req& + fo_Attr%, global&, TextAttr_sizeof%
			fontname$ = PEEK$(PEEKL(req& + fo_Attr% + ta_Name%)) + CHR$(0)
			CopyMem SADD(fontname$), global& + TextAttr_sizeof%, LEN(fontname$)
			POKEL global& + ta_Name%, global& + TextAttr_sizeof%
			POKEB global& + FrontPen%, PEEKB(req& + fo_FrontPen%)
			POKEB global& + PaperPen%, PEEKB(req& + fo_BackPen%)
			currentfont& = OpenFont&(global&)
		END IF
		FreeAslRequest req&
	END IF
END FUNCTION

FUNCTION GetString$(title$, body$, ln%)
	SHARED winptr&
	LOCAL workbuf&, p&, scr&, wfont&, glistptr&, gad&, ngptr&, vinfo&, swin&
	LOCAL inputeventbuf&, cl&, mo&, msg&
	LOCAL okaykey%, exitkey%, strgh%, strwd%, mpix%, z%, gpix%, lpix%, winwd%
	LOCAL sgdwd%, winhg%, w_left%, w_top%, ln%, cd%, qu%, gn%
	GetString$ = ""
	workbuf& = AllocVec&(512&, MEMF_ANY& OR MEMF_CLEAR&)
	IF workbuf& = NULL&
		EXIT FUNCTION
	END IF
	okay$ = "_Okay"
	cancel$ = "_Cancel"
	p& = INSTR(okay$,"_")
	IF p&
		okaykey% = ASC(LCASE$(MID$(okay$,p& + 1&, 1&)))
	END IF
	p& = INSTR(cancel$,"_")
	IF p&
		exitkey% = ASC(LCASE$(MID$(cancel$,p& + 1&, 1&)))
	END IF
	scr& = PEEKL(winptr& + WScreen%)
	wfont& = PEEKL(scr& + ScreenFont%)
	strgh% = PEEKW(wfont& + ta_YSize%) + 6%
	strwd% = PEEKW(scr& + RastPort% + TxWidth%)
	mpix% = TextLength&(scr& + RastPort%, SADD(body$), LEN(body$)) + 25%
	gpix% = MAX(TextLength&(scr& + RastPort%, SADD(okay$), LEN(okay$)), TextLength&(scr& + RastPort%, SADD(cancel$), LEN(cancel$))) + 20%
	lpix% = ln% * strwd%
	winwd% = MIN(MAX(mpix% + lpix% + 20%, (gpix% * 2%) + 15%), PEEKW(scr& + ScreenWidth%) - 20%)
	sgdwd% = MIN(winwd% - mpix% - 10%, lpix%)
	winhg% = 3% * strgh% + 8%
	w_left% = (PEEKW(scr& + ScreenWidth%) - winwd%) \ 2
	w_top%  = (PEEKW(scr& + ScreenHeight%) - winhg%) \ 2
	glistptr& = NULL&
	gad& = CreateContext&(VARPTR(glistptr&))
	ngptr& = workbuf& + 256&
	TAGLIST workbuf&, TAG_END&
	vinfo& = GetVisualInfoA&(scr&, workbuf&)
	SetNewGadget ngptr&, 5%, strgh%, winwd% - 10%, strgh%, SADD(body$ + CHR$(0)), NULL&, 3%, PLACETEXT_ABOVE&, vinfo&, NULL&
	TAGLIST workbuf&, _
		GTST_String&,	"", _
		GTST_MaxChars&,	ln%, _
		STRINGA_Justification&, GACT_STRINGCENTER&, _
	TAG_END&
	gad& = CreateGadgetA&(STRING_KIND&, gad&, ngptr&, workbuf&)
	stg& = gad&
	SetNewGadget ngptr&, (winwd% - (2 * gpix%)) \ 3, winhg% - strgh% - 5%, gpix%, strgh%, SADD(okay$ + CHR$(0)), NULL&, 1%, NULL&, vinfo&, NULL&
	TAGLIST workbuf&, _
		GT_Underscore&,   	"_"%, _
	TAG_END&
	gad& = CreateGadgetA&(BUTTON_KIND&, gad&, ngptr&, workbuf&)	
	SetNewGadget ngptr&, gpix% + (2 * (winwd% - (2 * gpix%)) \ 3), winhg% - strgh% - 5%, gpix%, strgh%, SADD(cancel$ + CHR$(0)), NULL&, 2%, NULL&, vinfo&, NULL&
	gad& = CreateGadgetA&(BUTTON_KIND&, gad&, ngptr&, workbuf&)
	TAGLIST workbuf&, _
		WA_CustomScreen&,	scr&, _
		WA_Left&,			w_left%, _
		WA_Top&,			w_top%, _
		WA_InnerHeight&,	winhg%, _
		WA_InnerWidth&,		winwd%, _
		WA_Gadgets&,		glistptr&, _
		WA_IDCMP&,			IDCMP_GADGETUP& OR IDCMP_GADGETDOWN& OR IDCMP_RAWKEY& OR _
							IDCMP_REFRESHWINDOW& OR IDCMP_CLOSEWINDOW& OR IDCMP_MOUSEMOVE&, _
		WA_SimpleRefresh&,	TRUE&, _
		WA_Activate&,		TRUE&, _
		WA_GimmeZeroZero&,	TRUE&, _
		WA_DragBar&,		TRUE&, _
		WA_DepthGadget&,	TRUE&, _
		WA_CloseGadget&,	TRUE&, _
		WA_Title&,			title$, _
	TAG_END&
	swin& = OpenWindowTagList&(NULL&, workbuf&)
	inputeventbuf& = workbuf& + 256&
	POKEB inputeventbuf& + ie_Class%, IECLASS_RAWKEY&
	POKEB inputeventbuf& + ie_SubClass%, 0%
	IF swin&
		GT_RefreshWindow swin&, NULL&
		junk& = ActivateGadget&(stg&, swin&, NULL&)
		ln% = 0%
		DO
			junk& = WaitPort&(PEEKL(swin& + UserPort%))
			msg& = GT_GetIMsg&(PEEKL(swin& + UserPort%))
			IF msg& THEN
				cl& = PEEKL(msg& + Class%)
				cd% = PEEKW(msg& + IntuiMessageCode%)
				qu% = PEEKW(msg& + Qualifier%)
				mo& = PEEKL(msg& + IAddress%)
				gn% = PEEKW(mo& + GadgetGadgetID%)
				GT_ReplyIMsg msg&
				SELECT CASE cl&
					CASE IDCMP_REFRESHWINDOW&
						GT_BeginRefresh swin&
						GT_EndRefresh swin&, TRUE&
					CASE IDCMP_RAWKEY&
						POKEW inputeventbuf& + ie_Code%, cd%
						POKEW inputeventbuf& + ie_Qualifier%, qu%
						POKEL inputeventbuf& + ie_addr%, mo&
						IF MapRawKey&(inputeventbuf&, workbuf&, 255&, NULL&) THEN
							cd% = PEEKB(workbuf&)
							SELECT CASE cd%
								CASE 27%, exitkey%, exitkey% - 32%
									EXIT LOOP
								CASE 13%, okaykey%, okaykey% - 32%
									GetString$ = PEEK$(PEEKL(PEEKL(stg& + GadgetSpecialInfo%) + StringInfoBuffer%))
									EXIT LOOP
							END SELECT
						END IF
					CASE IDCMP_GADGETUP&, IDCMP_GADGETDOWN&
						SELECT CASE gn%
							CASE 1%
								GetString$ = PEEK$(PEEKL(PEEKL(stg& + GadgetSpecialInfo%) + StringInfoBuffer%))
								EXIT LOOP
							CASE 2%
								EXIT LOOP
						END SELECT
					CASE IDCMP_CLOSEWINDOW&
						EXIT LOOP
				END SELECT
			END IF
		LOOP
		CloseWindow swin&
		FreeGadgets glistptr&
	END IF
	FreeVisualInfo vinfo&
	FreeVec workbuf&
END FUNCTION

SUB Help (base$)
	SHARED winptr&
	helpcontext& = AllocVec&(NewAmigaGuide_sizeof%, MEMF_PUBLIC& OR MEMF_CLEAR&)
	b$ = base$ + CHR$(0)
	POKEL helpcontext& + nag_Name%,	SADD(b$)
	POKEL helpcontext& + nag_Node%, SADD("Main" + CHR$(0))
	POKEL helpcontext& + nag_Screen%, PEEKL(winptr& + WScreen%)
	aghandle& = OpenAmigaGuideA&(helpcontext&, NULL&)
	IF aghandle& THEN
		CloseAmigaGuide aghandle&
	END IF
	FreeVec helpcontext&
END SUB

'*** Menu *******************************************************************

FUNCTION CreateMenuStrip&
	SHARED menustrip&, menulist&, xpk&, global&, history$()
	CreateMenuStrip& = FALSE&
	IF PEEKB(global& + BlockCsr%) THEN
		flag1& = CHECKIT& OR CHECKED&
	ELSE
		flag1& = CHECKIT&
	END IF
	IF PEEKB(global& + FormFeed%) THEN
		flag2& = CHECKIT& OR CHECKED&
	ELSE
		flag2& = CHECKIT&
	END IF
	IF PEEKB(global& + PutIcon%) THEN
		flag3& = CHECKIT& OR CHECKED&
	ELSE
		flag3& = CHECKIT&
	END IF
	defscreen& = LockPubScreen&(NULL&)
	IF defscreen& THEN
		vinfo& = GetVisualInfoA& (defscreen&, NULL&)
		menufont& = PEEKL(defscreen& + ScreenFont%)
		menulist& = MenuAlloc& (pe&, 50&)
		IF menulist& THEN
			IF	MenuTitle%	(pe&, "Project", 0%, NULL&) AND _
				MenuItem%	(pe&, "load ...", "l", 0%, 0%, MNLOAD&) AND _
				MenuItem%	(pe&, "save ...  ", "s", 0%, 0%, MNSAVE&) AND _
				MenuItem%	(pe&, "print", "p", 0%, 0%, MNPRINT&) AND _
				MenuItem%	(pe&, "", "", 0%, 0%, NULL&) AND _
				MenuItem%	(pe&, "Help", "h", 0%, 0%, MNHELP&) AND _
				MenuItem%	(pe&, "about ...", "ü", 0%, 0%, MNABOUT&) AND _
				MenuItem%	(pe&, "", "", 0%, 0%, NULL&) AND _
				MenuItem%	(pe&, "quit", "q", 0%, 0%, MNQUIT&) AND _
				MenuTitle%	(pe&, "Edit", 0%, NULL&) AND _
				MenuItem%	(pe&, "cut", "x", 0%, 0%, MNCUT&) AND _
				MenuItem%	(pe&, "copy", "c", 0%, 0%, MNCOPY&) AND _
				MenuItem%	(pe&, "copy all", "a", 0%, 0%, MNCOPYALL&) AND _
				MenuItem%	(pe&, "", "", 0%, 0%, NULL&) AND _
				MenuItem%	(pe&, "paste", "v", 0%, 0%, MNPASTE&) AND _
				MenuItem%	(pe&, "", "", 0%, 0%, NULL&) AND _
				MenuItem%	(pe&, "print Block", "d", 0%, 0%, MNPRINTBLOCK&) AND _
				MenuItem%	(pe&, "save Block", "k", 0%, 0%, MNSAVEBLOCK&) AND _	
				MenuItem%	(pe&, "insert File ...     ", "i", 0%, 0%, MNINSERT&) AND _
				MenuItem%	(pe&, "", "", 0%, 0%, NULL&) AND _
				MenuItem%	(pe&, "erase", "e", 0%, 0%, MNERASE&) AND _
				MenuItem%	(pe&, "undo erase", "u", 0%, 0%, MNUNDO&) AND _
				MenuTitle%	(pe&, "Search", 0%, NULL&) AND _
				MenuItem%	(pe&, "search String ...  ", "f", 0%, 0%, MNFIND&) AND _
				MenuItem%	(pe&, "continue  ", "w", 0%, 0%, MNNEXT&) AND _
				MenuTitle%	(pe&, "Preferences", 0%, NULL&) AND _
				MenuItem%	(pe&, "Select Font ...  ", "t", 0%, 0%, MNFONT&) AND _
				MenuItem%	(pe&, "Blockcursor", "b", flag1&, 0%, MNCURSOR&) AND _ 
				MenuItem%	(pe&, "Formfeed", "n", flag2&, 0%, MNFORMF&) AND _
				MenuItem%	(pe&, "Create Icons", "g", flag3&, 0%, MNICON&) THEN
				IF history$(0%) <> CHR$(0) THEN
					junk& = MenuTitle%(pe&, "Review", 0%, NULL&)
					FOR z% = 0% TO 9%
						IF history$ <> CHR$(0) THEN
							mt$ = PEEK$(FilePart&(SADD(history$(z%))))
							IF mt$ <> "" THEN
								junk& = MenuItem%(pe&, mt$ + SPACE$(4), LTRIM$(STR$(z%)), 0%, 0%, z% + 100%)
							END IF
						END IF
					NEXT z%
					junk& = MenuItem%(pe&, "", "", 0%, 0%, NULL&)
					junk& = MenuItem%(pe&, "Cleanup   ","r",0%,0%, MNHISTORY&)
				END IF
				IF MenuEnd%	(pe&, menustrip&, menulist&, menufont&, vinfo&, NULL&, NULL&) THEN
					CreateMenuStrip = menustrip&
				ELSE
					MenuFree menulist&, menustrip&
				END IF
			ELSE
				MenuFree menulist&, menustrip&
			END IF
		END IF
		FreeVisualInfo vinfo&
		UnLockPubScreen NULL&, defscreen&
	END IF
END FUNCTION

SUB FreeMenuStrip
	SHARED menulist&, menustrip&
	MenuFree menulist&, menustrip&
END SUB

'*** Strings ****************************************************************

SUB TabsToSpaces(a&, b&)
	FOR z& = a& TO a& + b& - 1&
		IF PEEKB(z&) = 9% THEN
			POKEB z&, 32% 
		ELSEIF PEEKB(z&) = 0% THEN
			POKEB z&, 32%
		END IF
	NEXT z&
END SUB

FUNCTION SaveFile& (f$, b&, l&)
	SHARED global&
	SaveFile& = FALSE&
	fh& = xOpen&(SADD(f$ + CHR$(0)), MODE_NEWFILE&)
	IF fh& THEN
		IF xWrite&(fh&, b&, l&) = l& THEN
			okay& = TRUE&
		ELSE
			okay& = FALSE&
		END IF
		junk& = xClose&(fh&)
	END IF
	IF okay& THEN
		IF PEEKB(global& + PutIcon%) THEN
			diskobj& = GetDiskObject&(SADD(f$ + CHR$(0)))
			IF diskobj& = NULL& THEN
				diskobj& = GetDiskObject&(SADD("ENVARC:SYS/def_text" + CHR$(0)))	
				IF diskobj& = NULL& THEN
					diskobj& = GetDefDiskObject&(WBPROJECT&)
				END IF
			END IF
			IF diskobj& THEN
				POKEL diskobj& + do_DefaultTool%, SADD("gce" + CHR$(0))
				junk& = PutDiskObject& (SADD(f$ + CHR$(0)), diskobj&)
				FreeDiskObject diskobj&
			END IF
		END IF
		SaveFile& = TRUE&
	END IF
END FUNCTION

FUNCTION ReadFile& (f$, tag&)
	SHARED winptr&, txfg&, tags&(), history$()
	ReadFile& = NULL&
	fh& = xOpen&(SADD(f$ + CHR$(0)), MODE_OLDFILE&)
	IF fh& THEN
		fibl& = AllocVec&(FileInfoBlock_sizeof%, MEMF_PUBLIC& OR MEMF_CLEAR&)
		junk& = ExamineFH&(fh&, fibl&)
		size& = PEEKL(fibl& + fib_Size%)
		FreeVec fibl&
		buf& = AllocVec&(size& + 2&, MEMF_PUBLIC& OR MEMF_CLEAR&)
		IF buf& THEN
			junk& = xRead&(fh&, buf&, size&)
			junk& = xClose&(fh&)	
			TabsToSpaces buf&, size&
			ReadFile& = TRUE&
			IF tag& = TEXTFIELD_Text& THEN
				flag& = FALSE&
			ELSE
				flag& = TRUE&
			END IF
			TAGLIST	VARPTR(tags&(0)), _ 
				tag&,			 		buf&, _
				TEXTFIELD_Modified&,	flag&, _
			TAG_END&
			junk& = SetGadgetAttrsA&(txfg&, winptr&, NULL&, VARPTR(tags&(0)))
			SetWindowTitles winptr&, FilePart&(SADD(f$ + CHR$(0))), NOT NULL&
			FreeVec buf&
			file$ = f$ + CHR$(0)
			FOR z% = 0% TO 9%
				IF file$ == history$(z%) THEN
					EXIT SUB
				END IF
			NEXT z%
			FOR z% = 9% TO 1% STEP -1%
				SWAP history$(z%), history$(z% - 1%)
			NEXT z%
			history$(0%) = file$
			ClearMenuStrip winptr&
			FreeMenuStrip
			junk& = SetMenuStrip&(winptr&, CreateMenuStrip&)
		END IF
	END IF
END FUNCTION

FUNCTION CheckModify&
	SHARED txfg&
	CheckModify& = TRUE&
	IF GetAttr&(TEXTFIELD_Modified&, txfg&, VARPTR(check&)) THEN
		IF check& THEN
			title$ = "Warning:"
			body$ = "The Text has been modified."
			gadg$ = "Go back|So what ?"
			CheckModify& = Requester&(title$, body$, gadg$)
		END IF
	END IF
END FUNCTION

'*** Eventhandling **********************************************************

FUNCTION HandleMenuEvents&(code%)
	SHARED menustrip&, txfg&, winptr&, currentfont&, global&
	SHARED version$, file$, history$(), dstore$, tags&()
	STATIC file$, search$, curtext$, curfind&
	HandleMenuEvents& = NULL&
	item& = ItemAddress&(menustrip&, code%)
  	IF item& THEN
  		pick& = PEEKL(item& + MenuItem_sizeof%)
  		SELECT CASE pick&
			CASE MNLOAD&
				IF CheckModify& THEN
					file$ = SelectTextFile$
					IF (file$ <> "") AND (FEXISTS(file$) <> NULL&) THEN	
						IF ReadFile&(file$, TEXTFIELD_Text&) = FALSE& THEN
							junk& = Requester&("Panic:", "Can't read the File " + CHR$(10) + file$,"Oh no!")
						END IF
					END IF
				END IF
			CASE MNSAVE&
				file$ = SaveTextFileAs$
				IF file$ <> "" THEN
					TAGLIST	VARPTR(tags&(0)), TEXTFIELD_ReadOnly&, TRUE&, TAG_END&
					junk& = SetGadgetAttrsA&(txfg&, winptr&, NULL&, VARPTR(tags&(0)))
					IF GetAttr&(TEXTFIELD_Size&, txfg&, VARPTR(size&)) THEN
						IF GetAttr&(TEXTFIELD_Text&, txfg&, VARPTR(textbuf&)) THEN
							IF SaveFile& (file$, textbuf&, size&) = FALSE& THEN
								junk& = Requester&("Panic:","Can't save the File!","Oh no!")
							END IF
						END IF
					END IF
					TAGLIST	VARPTR(tags&(0)), _
						TEXTFIELD_ReadOnly&, FALSE&, _
						TEXTFIELD_Modified&, FALSE&, _
					TAG_END&
					junk& = SetGadgetAttrsA&(txfg&, winptr&, NULL&, VARPTR(tags&(0)))
				END IF
			CASE MNABOUT&
				title$ = "About MicroEd:"
				body$ = "A little Texteditor, written in HiSoftBASIC" + CHR$(10) + _
						"by Steffen 'Ironbyte' Leistner 1996," + CHR$(10) + _
						"Last modified: 11.08.1998." + CHR$(10) + _
						"Demo for the Textfield.gadget in BASIC." + CHR$(10) +_
						PEEK$(TEXTFIELD_GetCopyright&(NULL&))
				gadg$ = "Cool !"
				junk& = Requester&(title$, body$, gadg$)
			CASE MNQUIT&
				HandleMenuEvents& = CheckModify&
			CASE MNCUT&
				TAGLIST	VARPTR(tags&(0)), TEXTFIELD_Cut&, TRUE&, TAG_END&
				junk& = SetGadgetAttrsA&(txfg&, winptr&, NULL&, VARPTR(tags&(0)))
			CASE MNCOPY&
				TAGLIST	VARPTR(tags&(0)), TEXTFIELD_Copy&, FALSE&, TAG_END&
				junk& = SetGadgetAttrsA&(txfg&, winptr&, NULL&, VARPTR(tags&(0)))
			CASE MNCOPYALL&
				TAGLIST	VARPTR(tags&(0)), TEXTFIELD_CopyAll&, FALSE&, TAG_END&
				junk& = SetGadgetAttrsA&(txfg&, winptr&, NULL&, VARPTR(tags&(0)))
			CASE MNPASTE&
				TAGLIST	VARPTR(tags&(0)), TEXTFIELD_Paste&, FALSE&, TAG_END&
				junk& = SetGadgetAttrsA&(txfg&, winptr&, NULL&, VARPTR(tags&(0)))
			CASE MNINSERT&
				ifile$ = SelectTextFile$
				IF (ifile$ <> "") AND (FEXISTS(ifile$) <> NULL&) THEN
					IF ReadFile&(ifile$, TEXTFIELD_InsertText&) = FALSE& THEN
						junk& = Requester&("Panic:", "Can't read the File " + CHR$(10) + ifile$, "Oh no!")
					END IF
				END IF
			CASE MNERASE&
				TAGLIST	VARPTR(tags&(0)), TEXTFIELD_Erase&, FALSE&, TAG_END&
				junk& = SetGadgetAttrsA&(txfg&, winptr&, NULL&, VARPTR(tags&(0)))
			CASE MNUNDO&
				TAGLIST	VARPTR(tags&(0)), TEXTFIELD_Undo&, FALSE&, TAG_END&
				junk& = SetGadgetAttrsA&(txfg&, winptr&, NULL&, VARPTR(tags&(0)))
			CASE MNFONT&
				IF SelectFont& THEN
					TAGLIST	VARPTR(tags&(0)), _
						TEXTFIELD_TextAttr&, 	global&, _
						TEXTFIELD_PaperPen&, 	PEEKB(global& + PaperPen%), _
						TEXTFIELD_InkPen&,		PEEKB(global& + FrontPen%), _
					TAG_END&
					junk& = SetGadgetAttrsA&(txfg&, winptr&, NULL&, VARPTR(tags&(0)))
				END IF
			CASE MNCURSOR&
				ClearMenuStrip winptr&
				IF PEEKB(global& + BlockCsr%) THEN
					csr& = NULL&
					POKEB global& + BlockCsr%, 0%
					POKEW item& + MenuItemFlags%, PEEKW(item& + MenuItemFlags%) XOR CHECKED&
				ELSE
					csr& = TRUE&
					POKEB global& + BlockCsr%, 1%
					POKEW item& + MenuItemFlags%, PEEKW(item& + MenuItemFlags%) OR CHECKED&
				END IF
				junk& = ResetMenuStrip&(winptr&, menustrip&)
				TAGLIST	VARPTR(tags&(0)), TEXTFIELD_BlockCursor&, csr&, TAG_END&
				junk& = SetGadgetAttrsA&(txfg&, winptr&, NULL&, VARPTR(tags&(0)))
			CASE MNFIND&
				search$ = GetString$ ("Search:", "String:", 30%)
				IF search$ <> "" THEN
					TAGLIST	VARPTR(tags&(0)), TEXTFIELD_ReadOnly&, TRUE&, TAG_END&
					junk& = SetGadgetAttrsA&(txfg&, winptr&, NULL&, VARPTR(tags&(0)))
					IF GetAttr&(TEXTFIELD_Text&, txfg&, VARPTR(textbuf&)) THEN
						curtext$ = PEEK$(textbuf&)
					END IF
					TAGLIST	VARPTR(tags&(0)), TEXTFIELD_ReadOnly&, FALSE&, TAG_END&
					junk& = SetGadgetAttrsA&(txfg&, winptr&, NULL&, VARPTR(tags&(0)))
					curfind& = INSTR(1&, curtext$, search$)
					IF curfind& THEN
						DECR curfind&
						TAGLIST	VARPTR(tags&(0)), TEXTFIELD_CursorPos&, curfind&, TAG_END&
						junk& = SetGadgetAttrsA&(txfg&, winptr&, NULL&, VARPTR(tags&(0)))
					END IF
				END IF
			CASE MNNEXT&
				IF search$ <> "" THEN
					curfind& = curfind& + 2&
					curfind& = INSTR(curfind&, curtext$, search$)
					IF curfind& THEN
						DECR curfind&
						TAGLIST	VARPTR(tags&(0)), TEXTFIELD_CursorPos&, curfind&, TAG_END&
						junk& = SetGadgetAttrsA&(txfg&, winptr&, NULL&, VARPTR(tags&(0)))
					ELSE
						junk& = Requester&("Search:","End of File.","Okay")
						search$ = "" : curtext$ = ""
					END IF
				END IF	
			CASE MNPRINT&
				IF Requester&("Print:","Print this Text ?","Okay|Cancel") THEN
					TAGLIST	VARPTR(tags&(0)), TEXTFIELD_ReadOnly&, TRUE&, TAG_END&
					junk& = SetGadgetAttrsA&(txfg&, winptr&, NULL&, VARPTR(tags&(0)))
					IF GetAttr&(TEXTFIELD_Text&, txfg&, VARPTR(textbuf&)) THEN
						curtext$ = PEEK$(textbuf&)
						LPRINT curtext$; 
						IF PEEKB(global& + FormFeed%) THEN
							LPRINT CHR$(12);
						ELSE
							LPRINT : LPRINT
						END IF
					END IF
					TAGLIST	VARPTR(tags&(0)), TEXTFIELD_ReadOnly&, FALSE&, TAG_END&
					junk& = SetGadgetAttrsA&(txfg&, winptr&, NULL&, VARPTR(tags&(0)))
				END IF
			CASE MNPRINTBLOCK&
				IF GetAttr&(TEXTFIELD_SelectSize&, txfg&, VARPTR(size&)) THEN
					IF size& > NULL& THEN
						IF GetAttr&(TEXTFIELD_CursorPos&, txfg&, VARPTR(curfind&)) THEN
							start& = curfind& - size&
							TAGLIST	VARPTR(tags&(0)), _
								TEXTFIELD_CursorPos&,	start&, _
								TEXTFIELD_SelectSize&,	size&, _
							TAG_END&
							junk& = SetGadgetAttrsA&(txfg&, winptr&, NULL&, VARPTR(tags&(0)))
							junk& = ActivateGadget&(txfg&, winptr&, NULL&)
							Delay 75
							IF Requester&("Print:", "Print this Block ?", "Okay|Cancel") THEN
								TAGLIST	VARPTR(tags&(0)), TEXTFIELD_ReadOnly&, TRUE&, TAG_END&
								junk& = SetGadgetAttrsA&(txfg&, winptr&, NULL&, VARPTR(tags&(0)))
								IF GetAttr&(TEXTFIELD_Text&, txfg&, VARPTR(textbuf&)) THEN
									curtext$ = PEEK$(textbuf& + start&)
									LPRINT LEFT$(curtext$, size&); 
									IF PEEKB(global& + FormFeed%) THEN
										LPRINT CHR$(12);
									ELSE
										LPRINT : LPRINT
									END IF
								END IF
								TAGLIST	VARPTR(tags&(0)), TEXTFIELD_ReadOnly&, FALSE&, TAG_END&
								junk& = SetGadgetAttrsA&(txfg&, winptr&, NULL&, VARPTR(tags&(0)))
							END IF
						END IF
					END IF
				END IF
			CASE MNSAVEBLOCK&
				IF GetAttr&(TEXTFIELD_SelectSize&, txfg&, VARPTR(size&)) THEN
					IF size& > NULL& THEN
						IF GetAttr&(TEXTFIELD_CursorPos&, txfg&, VARPTR(curfind&)) THEN
							start& = curfind& - size&
							TAGLIST	VARPTR(tags&(0)), _
								TEXTFIELD_CursorPos&,	start&, _
								TEXTFIELD_SelectSize&,	size&, _
							TAG_END&
							junk& = SetGadgetAttrsA&(txfg&, winptr&, NULL&, VARPTR(tags&(0)))
							junk& = ActivateGadget&(txfg&, winptr&, NULL&)
							Delay 75
							ifile$ = SaveTextFileAs$
							IF ifile$ <> "" THEN
								TAGLIST	VARPTR(tags&(0)), TEXTFIELD_ReadOnly&, TRUE&, TAG_END&
								junk& = SetGadgetAttrsA&(txfg&, winptr&, NULL&, VARPTR(tags&(0)))
								IF GetAttr&(TEXTFIELD_Text&, txfg&, VARPTR(textbuf&)) THEN
									IF SaveFile& (ifile$, textbuf& + start, size&) = FALSE& THEN
										junk& = Requester&("Panic:","Can't save Textblock.","Oh no!")
									END IF
								END IF
								TAGLIST	VARPTR(tags&(0)), TEXTFIELD_ReadOnly&, FALSE&, TAG_END&
								junk& = SetGadgetAttrsA&(txfg&, winptr&, NULL&, VARPTR(tags&(0)))
							END IF
						END IF
					END IF
				END IF	
			CASE MNFORMF&
				ClearMenuStrip winptr&
				IF PEEKB(global& + FormFeed%) THEN
					POKEB global& + FormFeed%, 0%
					POKEW item& + MenuItemFlags%, PEEKW(item& + MenuItemFlags%) XOR CHECKED&
				ELSE
					POKEB global& + FormFeed%, 1%
					POKEW item& + MenuItemFlags%, PEEKW(item& + MenuItemFlags%) OR CHECKED&
				END IF
				junk& = ResetMenuStrip&(winptr&, menustrip&)
			CASE MNHELP&
				help$ = "HELP:MicroEd.guide"
				IF FEXISTS(help$) THEN
					Help help$
				ELSE
					help$ = "MicroEd.guide"
					IF FEXISTS(help$)
						Help help$
					ELSE
						body$ = "The File " + CHR$(34) + help$ + CHR$(34) + CHR$(10) + _
								"does not exists..."
						junk& = Requester&("Help:",body$,"Oh no!")
					END IF
				END IF
			CASE MNICON&
				ClearMenuStrip winptr&
				IF PEEKB(global& + PutIcon%) THEN
					POKEB global& + PutIcon%, 0%
					POKEW item& + MenuItemFlags%, PEEKW(item& + MenuItemFlags%) XOR CHECKED&
				ELSE
					POKEB global& + PutIcon%, 1%
					POKEW item& + MenuItemFlags%, PEEKW(item& + MenuItemFlags%) OR CHECKED&
				END IF
				junk& = ResetMenuStrip&(winptr&, menustrip&)
			CASE MNHISTORY&
				FOR z% = 0% TO 9%
					history$(z%) = CHR$(0)
				NEXT z%
				ClearMenuStrip winptr&
				FreeMenuStrip
				junk& = SetMenuStrip&(winptr&, CreateMenuStrip&)
			CASE 100% TO 109%
				IF FEXISTS(PEEK$(SADD(history$(pick& - 100%)))) THEN
					IF CheckModify& THEN
						file$ = PEEK$(SADD(history$(pick& - 100%)))
						IF (file$ <> "")
							IF FEXISTS(file$) THEN	
								IF ReadFile&(file$, TEXTFIELD_Text&) THEN
									dstore$ = history$(pick& - 100%)
								ELSE
									junk& = Requester&("Panic:", "Can't read the File " + CHR$(10) + file$,"Oh no!")
								END IF
							ELSE
								junk& = Requester&("Panic:", "File not exists:" + CHR$(10) + file$, "Oh no!")
							END IF
						END IF
					END IF
				END IF
		END SELECT
	END IF
	SetWindowTitles winptr&, FilePart&(SADD(file$ + CHR$(0))), SADD(version$ + CHR$(0))
END FUNCTION

FUNCTION HandleEvents&
	SHARED txfg&, prop&, winptr&, file$, dstore$, version$, tags&()
	STATIC t%, check&
	HandleEvents& = RETURN_OK&
	SetWindowTitles winptr&, FilePart&(SADD(file$ + CHR$(0))), SADD(version$ + CHR$(0))
	DO 
		junk& = WaitPort&(PEEKL(winptr& + UserPort%))
		imsg& = GetMsg&(PEEKL(winptr& + UserPort%))
		IF imsg& THEN
			cl& = PEEKL(imsg& + Class%)
			cd% = PEEKW(imsg& + IntuiMessageCode%)
			IF cl& <> &H70000& THEN
				ReplyMsg imsg&
			END IF
		 	SELECT CASE cl&
		 		CASE &H70000&
		 			lck& = PEEKL(PEEKL(imsg& + am_ArgList%) + wa_Lock%)
					file$ = ""
					temp$ = STRING$(256%,0%)
					IF NameFromLock& (lck&, SADD(temp$), 255%) THEN
						IF AddPart& (SADD(temp$), _
									SADD(PEEK$(PEEKL(PEEKL(imsg& + am_ArgList%) + _
									wa_Name%)) + CHR$(0)), 255%) THEN
							file$ = PEEK$(SADD(temp$))
						END IF
					END IF
					ReplyMsg imsg&
					IF GetAttr&(TEXTFIELD_Modified&, txfg&, VARPTR(check&)) THEN
						IF check& THEN
							title$ = "Warning:"
							body$ = "The Text has been modified."
							gadg$ = "Go back|So what ?"
							IF Requester&(title$, body$, gadg$) THEN
								EXIT SELECT
							END IF
						END IF
					END IF
					IF file$ <> "" THEN
						IF ReadFile&(file$, TEXTFIELD_Text&) THEN
							ActivateWindow winptr&
							dstore$ = file$ + CHR$(0)
						ELSE
							junk& = Requester&("Panic:", "Cant read File " + CHR$(10) + file$, "Mist !")
						END IF
					END IF
		 		CASE IDCMP_INTUITICKS&
		 			INCR t%
		 			IF t% > 10% THEN
		 				t% = 0%
		 				junk& = GetAttr&(TEXTFIELD_CursorPos&, txfg&, VARPTR(csrp&))
		 				IF csrp& <> ocsrp& THEN
							ocsrp& = csrp&
		 					junk& = GetAttr&(TEXTFIELD_Modified&, txfg&, VARPTR(check&))
							IF check& THEN
								ntitle$ = "*  " + PEEK$(FilePart&(SADD(dstore$ + CHR$(0))))
							ELSE
								ntitle$ = PEEK$(FilePart&(SADD(dstore$ + CHR$(0))))
							END IF
							junk& = GetAttr&(TEXTFIELD_Lines&, txfg&, VARPTR(lines&))
							TAGLIST	VARPTR(tags&(0)), TEXTFIELD_ReadOnly&, TRUE&, TAG_END&
							junk& = SetGadgetAttrsA&(txfg&, winptr&, NULL&, VARPTR(tags&(0)))
							junk& = GetAttr&(TEXTFIELD_Text&, txfg&, VARPTR(tb&))
							TAGLIST	VARPTR(tags&(0)), TEXTFIELD_ReadOnly&, FALSE&, TAG_END&
							junk& = SetGadgetAttrsA&(txfg&, winptr&, NULL&, VARPTR(tags&(0)))
							al& = 1&
							FOR x& = tb& TO (tb& + csrp&)
								IF PEEKB(x&) = &H0A%
									INCR al&
								END IF
							NEXT x&
							ntitle$ = ntitle$ + "  [" + LTRIM$(STR$(al&)) + "/" + LTRIM$(STR$(lines&)) + "]" + CHR$(0)
							SetWindowTitles winptr&, SADD(ntitle$), NOT NULL&
						END IF
					END IF
		 		CASE IDCMP_CLOSEWINDOW&
	 				IF GetAttr&(TEXTFIELD_Modified&, txfg&, VARPTR(check&)) THEN
						IF check& THEN
							title$ = "Warning:"
							body$ = "The Text has been modified."
							gadg$ = "Go back|So what ?"
							IF Requester&(title$, body$, gadg$) THEN
								EXIT LOOP
							END IF
						END IF
					END IF
					EXIT LOOP
	 			CASE IDCMP_NEWSIZE&
	 				TAGLIST	VARPTR(tags&(0)), _
	 					GA_Top&,				0&, _
						GA_Left&,				0&, _
						GA_Width&,				PEEKW(winptr& + WindowWidth%) - _
												PEEKB(winptr& + BorderLeft%) - _ 
												PEEKB(winptr& + BorderRight%) - _
												sliderwidth% - 2%, _
						GA_Height&,				PEEKW(winptr& + WindowHeight%) - _
												PEEKB(winptr& + BorderTop%) - _
												PEEKB(winptr& + BorderBottom%), _
					TAG_END&
					junk& = SetGadgetAttrsA&(txfg&, winptr&, NULL&, VARPTR(tags&(0)))
					junk& = GetAttr&(TEXTFIELD_Top&, txfg&, VARPTR(top&))
					junk& = GetAttr&(TEXTFIELD_Visible&, txfg&, VARPTR(visible&))
					junk& = GetAttr&(TEXTFIELD_Lines&, txfg&, VARPTR(lines&))
					TAGLIST VARPTR(tags&(0)), _
						GA_RelRight&,		- sliderwidth%, _
						GA_Height&,			PEEKW(winptr& + WindowHeight%) - _
											PEEKB(winptr& + BorderTop%) - _
											PEEKB(winptr& + BorderBottom%), _
						PGA_Top&, 			top&, _
						PGA_Visible&, 		visible&, _
						PGA_Total&, 		lines&, _
					TAG_END&
					junk& = SetGadgetAttrsA&(prop&, winptr&, NULL&, VARPTR(tags&(0)))
					RefreshGList prop&, winptr&, NULL&, NOT NULL&
					RefreshWindowFrame winptr&
				CASE IDCMP_MENUPICK&
					IF HandleMenuEvents&(cd%) THEN
						EXIT LOOP
					END IF
	 		END SELECT
	 		junk& = ActivateGadget&(txfg&, winptr&, NULL&)
	 	END IF
	LOOP
END FUNCTION

'*** Startup ****************************************************************

SUB CheckArg (wintitle$)
	SHARED dstore$
	wintitle$ = "MicroEd"
	file$ = COMMAND$
	IF file$ <> "" THEN
		IF LEFT$(file$,1%) = CHR$(34) THEN
			file$ = MID$(file$, 2, LEN(file$)-2)
		END IF
		IF FEXISTS(file$) THEN
			IF ReadFile&(file$, TEXTFIELD_Text&) THEN
				dstore$ = file$
				wintitle$ = PEEK$(FilePart&(SADD(dstore$ + CHR$(0))))
			END IF
		END IF
	END IF
END SUB

FUNCTION ReadDefaults&
	SHARED currentfont&, global&, dstore$, oldstore$, history$()
	SetDefaults& = FALSE&
	global& = AllocVec& (PrefsSize%, MEMF_PUBLIC& OR MEMF_CLEAR&)
	IF global& THEN
		IF GetVar&(SADD("ENVARC:MicroEd/MicroEd.prefs" + CHR$(0)), global&, _
					PrefsSize%, GVF_GLOBAL_ONLY& OR GVF_BINARY_VAR&) > NULL& THEN
			POKEL global& + ta_Name%, global& + TextAttr_sizeof%
			currentfont& = OpenFont&(global&)
			IF currentfont& = NULL& THEN
				currentfont& = OpenDiskFont&(global&)
			END IF
		ELSE
			CopyMem PEEKL(SYSTAB + 28%), global&, TextAttr_sizeof%
			fontname$ = PEEK$(PEEKL(global& + ta_Name%)) + CHR$(0)
			CopyMem SADD(fontname$), global& + TextAttr_sizeof%, LEN(fontname$)
			POKEL global& + ta_Name%, global& + TextAttr_sizeof%
			POKEB global& + FrontPen%, 1%
			POKEB global& + PaperPen%, 0%
			POKEB global& + BlockCsr%, 1%
			POKEB global& + PutIcon%, 1%
			POKEB global& + FormFeed%, 0%
			POKEW global& + WTop%, 0%
			POKEW global& + WLeft%, 0%
			POKEW global& + WWidth%, 2 * (PEEKW(SYSTAB) \ 3)
			POKEW global& + WHeight%, 2 * (PEEKW(SYSTAB + 2%) \ 3)
			currentfont& = OpenFont&(global&)
		END IF
		SetDefaults& = TRUE&
	END IF
	dstore$ = STRING$(256%,0%)
	IF GetVar&(SADD("ENVARC:MicroEd/MicroEd.path" + CHR$(0)), SADD(dstore$), 255%, GVF_GLOBAL_ONLY&) THEN
		oldstore$ = PEEK$(SADD(dstore$)) + CHR$(0)
		dstore$ = CHR$(0)
	ELSE
		dstore$ = CHR$(0)
	END IF
	FOR z% = 0% TO 9%
		history$(z%) = CHR$(0)
	NEXT z%
	fh& = xOpen&(SADD("ENVARC:MicroEd/MicroEd.history" + CHR$(0)), MODE_OLDFILE&)
	IF fh& THEN
		temp$ = STRING$(256%,0%)
		z% = 0%
		WHILE FGetS&(fh&, SADD(temp$), 255%)
			history$(z%) = PEEK$(SADD(temp$))
			POKEB SADD(history$(z%)) + LEN(history$(z%)) - 1&, 0%
			INCR z%
		WEND
		junk& = xClose&(fh&)
	END IF
END FUNCTION

SUB WriteDefaults
	SHARED global&, winptr&, dstore$, history$()
	
	check$ = "ENVARC:MicroEd"
	IF NOT FEXISTS(check$)
		MKDIR check$
	END IF
	
	POKEW global& + WTop%, PEEKW(winptr& + WindowTopEdge%)
	POKEW global& + WLeft%, PEEKW(winptr& + WindowLeftEdge%)
	POKEW global& + WWidth%, PEEKW(winptr& + WindowWidth%)
	POKEW global& + WHeight%, PEEKW(winptr& + WindowHeight%)
	
	junk& = SetVar&(SADD(check$ + "/MicroEd.prefs" + CHR$(0)), global&, PrefsSize%, _
							GVF_GLOBAL_ONLY& OR GVF_BINARY_VAR&)

	junk& = SetVar&(SADD(check$ + "/MicroEd.path" + CHR$(0)), SADD(dstore$ + CHR$(0)), _
					NOT NULL&, GVF_GLOBAL_ONLY&)
	
	fh& = xOpen&(SADD(check$ + "/MicroEd.history" + CHR$(0)), MODE_NEWFILE&)
	IF fh& THEN
		FOR z% = 0% TO 9%
			IF history$(z%) <> CHR$(0) THEN
				junk& = FPutS&(fh&, SADD(history$(z%)))
				junk& = FPutC&(fh&, 10%)
			END IF
		NEXT z%
		junk& = xClose&(fh&)
	END IF
END SUB

'*** Mainfunction ***********************************************************

FUNCTION Main&
	SHARED winptr&, prop&, txfg&, global&, version$, clipstream&, xpk&, dstore$, tags&()

	LIBRARY OPEN "intuition.library", 37
	LIBRARY OPEN "exec.library"
	LIBRARY OPEN "dos.library"
	LIBRARY OPEN "graphics.library"
	LIBRARY OPEN "diskfont.library"
	LIBRARY OPEN "iffparse.library"
	LIBRARY OPEN "gadgets/textfield.gadget"
	LIBRARY OPEN "gadtools.library"
	LIBRARY OPEN "asl.library"
	LIBRARY OPEN "workbench.library"
	LIBRARY OPEN "icon.library"
	LIBRARY OPEN "keymap.library"
	LIBRARY OPEN "amigaguide.library"
	
	Main& = RETURN_ERROR&

	DIM SHARED tags&(44), map1&(4), map2&(8), history$(9)

	IF ReadDefaults& = FALSE THEN
		ERROR 7
	END IF

	READ version$
	version$ = RIGHT$(version$, LEN(version$) - 6)

	wbscr& = LockPubScreen&(NULL&)

	TAGLIST VARPTR(tags&(0)), _
		WA_Top&,			PEEKW(global& + WTop%), _
		WA_Left&,			PEEKW(global& + WLeft%), _
		WA_Width&,			PEEKW(global& + WWidth%), _
		WA_Height&,			PEEKW(global& + WHeight%), _
		WA_MaxWidth&,		PEEKW(wbscr& + ScreenWidth%) - 20%, _
		WA_MaxHeight&,		PEEKW(wbscr& + ScreenHeight%) - 20%, _
		WA_MinWidth&,		150&, _
		WA_MinHeight&,		100&, _
		WA_CustomScreen&,	wbscr&, _
		WA_IDCMP&,			IDCMP_NEWSIZE& OR IDCMP_MENUPICK& OR IDCMP_INTUITICKS& OR _
							IDCMP_CLOSEWINDOW& OR IDCMP_RAWKEY&, _
		WA_GimmeZeroZero&,	TRUE&, _
		WA_DragBar&,		TRUE&, _
		WA_CloseGadget&,	TRUE&, _
		WA_DepthGadget&,	TRUE&, _
		WA_SizeGadget&,		TRUE&, _
		WA_SizeBBottom&,	TRUE&, _
		WA_NewLookMenus&,	TRUE&, _
		WA_Activate&,		TRUE&, _
		WA_Title&,			title$, _
		WA_ScreenTitle&,	version$, _
	TAG_END&
	
	winptr& = OpenWindowTagList&(NULL&, VARPTR(tags&(0)))

	IF winptr& THEN	
	
		appwin& = AddAppWindowA& (1&, NULL&, winptr&, PEEKL(winptr& + UserPort%), NULL&)
	
		IF SetMenuStrip&(winptr&, CreateMenuStrip&) THEN
			
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
				clipstream& = OpenClipBoard&(NULL&)
				undostream& = OpenClipBoard&(99&)
				
				TAGLIST VARPTR(tags&(0)), _
					GA_ID&,						2&, _
					GA_Top&,					0&, _
					GA_Left&,					0&, _
					GA_Width&,					PEEKW(winptr& + WindowWidth%) - _
												PEEKB(winptr& + BorderLeft%) - _ 
												PEEKB(winptr& + BorderRight%) - _
												sliderwidth% - 2%, _
					GA_Height&,					PEEKW(winptr& + WindowHeight%) - _
												PEEKB(winptr& + BorderTop%) - _
												PEEKB(winptr& + BorderBottom%), _
					GA_Previous&,				prop&, _
					ICA_MAP&,					VARPTR(map2&(0)), _
					ICA_TARGET&,				prop&, _
					TEXTFIELD_Text&,			SADD(CHR$(0)), _
					TEXTFIELD_TextAttr&,		global&, _
					TEXTFIELD_Border&,			TEXTFIELD_BORDER_NONE&, _
					TEXTFIELD_TabSpaces&,		4&, _
					TEXTFIELD_PassCommand&,		TRUE&, _
					TEXTFIELD_NonPrintChars&,	TRUE&, _
					TEXTFIELD_BlockCursor&,		PEEKB(global& + BlockCsr%), _
					TEXTFIELD_PaperPen&, 		PEEKB(global& + PaperPen%), _
					TEXTFIELD_InkPen&,			PEEKB(global& + FrontPen%), _
					TEXTFIELD_ClipStream&,		clipstream&, _
					TEXTFIELD_UndoStream&,		undostream&, _
				TAG_END&

				txfg& = NewObjectA&(TEXTFIELD_GetClass&(NULL&), NULL&, VARPTR(tags&(0)))

				IF txfg& THEN

					TAGLIST	VARPTR(tags&(0)), ICA_TARGET&, txfg&, TAG_END&
					junk& = SetGadgetAttrsA&(prop&, winptr&, NULL&, VARPTR(tags&(0)))
					junk& = AddGList&(winptr&, prop&, NOT NULL&, NOT NULL&, NULL&)
					RefreshGList prop&, winptr&, NULL&, NOT NULL&               
					junk& = ActivateGadget&(txfg&, winptr&, NULL&)

					CheckArg (title$)
					SetWindowTitles winptr&, SADD(title$ + CHR$(0)), NOT NULL&
					
					IF PEEKL(winptr& + WScreen%) <> PEEKL(LIBRARY("intuition.library") + FirstScreen%) THEN
						ScreenToFront PEEKL(winptr& + WScreen%)
					END IF

					Main& = HandleEvents

					imsg& = GetMsg&(PEEKL(winptr& + UserPort%))
					WHILE imsg&
						ReplyMsg imsg&
						imsg& = GetMsg&(PEEKL(winptr& + UserPort%))
					WEND

					junk& = RemoveGList&(winptr&, txfg&, NOT NULL&)
				END IF
				
				IF clipstream& THEN
					CloseClipBoard clipstream&
				END IF
				
				IF undostream& THEN
					CloseClipBoard undostream&
				END IF
			END IF
			
			ClearMenuStrip winptr&
						
			WriteDefaults
		END IF

		IF appwin& THEN
			junk& = RemoveAppWindow& (appwin&)
		END IF
		
		CloseWindow winptr&
		FreeMenuStrip

	END IF
	UnLockPubScreen NULL&, wbscr&
	LIBRARY CLOSE
END FUNCTION

'*** Let's go! **************************************************************

SYSTEM Main&

'*** Data *******************************************************************

DATA "$VER: MicroEd 0.1 "