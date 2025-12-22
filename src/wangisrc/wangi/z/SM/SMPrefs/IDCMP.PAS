Procedure InfoGadFunc;

VAR
	ret : LONG;
	tgs : Array[0..5] of LONG;
	
begin
	wl := Pointer(rtLockWindow(TheWindow));
	tgs[0] := RT_IDCMPFlags;
	tgs[1] := IDCMP_MOUSEBUTTONS|IDCMP_VANILLAKEY;
	tgs[2] := RT_ReqPos;
	tgs[3] := REQPOS_CENTERSCR;
	tgs[4] := TAG_MORE;
	tgs[5] := LONG(@t); 
	ret := rtEZRequestA (CStrConstPtrAR(@RememberKey, InfoHead+ 
		'Copyright ©1994-96 Lee Kindness.'#10 +
		'wangi@frost3.demon.co.uk'#10 +
		''#10 +
		'See "Startup-Menu.Guide" for more information.'#10#10),
		CStrConstPtrAR(@RememberKey, 'Ok'), NIL, NIL, @tgs);
	rtUnLockWindow(TheWindow, wl);
end;

{ Use Reqtools requesters to get screen/window title strings from the user }
Procedure GetTitles;

VAR
	buffer: String[128];
	ret   : Long;
	tags  : array [0..4] of tTagItem;

begin
	wl := Pointer(rtLockWindow(TheWindow));
	tags[0].ti_Tag  := RT_Window;
	tags[0].ti_Data := LONG(TheWindow);
	tags[1].ti_Tag  := RTGS_TextFmt;
	tags[1].ti_Data := LONG(CStrConstPtrAR(@RememberKey, 'Enter the text to be displayed'+#10+' on the screen titlebar.'));
	tags[2].ti_Tag  := RTGS_FLAGS;
	tags[2].ti_Data := GSREQF_CENTERTEXT;
	tags[3].ti_Tag  := TAG_END;

	buffer := CD.cd_ScrTit+#0;
	ret := rtGetStringA (@buffer[1], 127, CStrConstPtrAR(@RememberKey, Win_Title), NIL, @tags);
	if ret <> 0 then
		CD.cd_ScrTit := PtrToPas(@Buffer[1]);

	buffer := CD.cd_WinTit+#0;
	tags[1].ti_Data := LONG(CStrConstPtrAR(@RememberKey, 'Enter the text to be displayed'+#10+' on the window titlebar.'));
	ret:=rtGetStringA (@buffer[1], 127, CStrConstPtrAR(@RememberKey, Win_Title), NIL, @tags);
	if ret <> 0 then 
		CD.cd_WinTit := PtrToPas(@buffer[1]);
	rtUnLockWindow(TheWindow, wl);
end;


{ Use Reqtools palette requester on a custom screen }
{ to get the users desired palette }
Procedure GetPal;

CONST
	MyPens : Array[0..8] of Word = ($FFFF); (* Get default *)

VAR
	result : Long;
	tags : array [0..10] of tTagItem;
	TheScreen : pScreen;
	win : pWindow;
	ok : boolean;
	MyTextFont : pTextFont;

begin
	wl := Pointer(rtLockWindow(TheWindow));

	DiskFontBase  := Openlibrary('diskfont.library',36); 
	If DiskFontBase <> NIL Then begin
		MyTextFont := OpenDiskFont(@CD.cd_Font);
		CloseLibrary(pLibrary(DiskFontBase));
	end;

	tags[0].ti_Tag  := SA_Type;
	tags[0].ti_Data := CUSTOMSCREEN;
	tags[1].ti_Tag  := SA_Title;
	tags[1].ti_Data := LONG(CStrConstPtrAR(@RememberKey, 'Change the palette'));
	tags[2].ti_Tag  := SA_OverScan;
	tags[2].ti_Data := OSCAN_TEXT;
	tags[3].ti_Tag  := SA_Depth;
	tags[3].ti_Data := 2;
	tags[4].ti_Tag  := SA_Font;
	tags[4].ti_Data := LONG(@CD.cd_Font);
	tags[5].ti_Tag  := SA_DisplayID;
	tags[5].ti_Data := CD.cd_ModeID; 
	tags[6].ti_Tag  := SA_Width;
	tags[6].ti_Data := STDSCREENWIDTH;
	tags[7].ti_Tag  := SA_Height;
	tags[7].ti_Data := STDSCREENHEIGHT;
	tags[8].ti_Tag  := SA_Pens;
	tags[8].ti_Data := LONG(@MyPens);
	tags[9].ti_Tag  := SA_Colors;
	tags[9].ti_Data := LONG(NIL);
	tags[10].ti_Tag  := TAG_END;
   
	TheScreen := OpenScreenTagList(NIL, @tags);
	IF TheScreen <> NIL then begin
		LoadRGB4(@TheScreen^.ViewPort, @CD.cd_Pal[0], 4);
    
		tags[0].ti_Tag  := RT_Screen;
		tags[0].ti_Data := LONG(TheScreen);
		tags[1].ti_Tag  := TAG_END;

		result := rtPaletteRequestA (CStrConstPtrAR(@RememberKey, 'Change palette'), NIL, @tags);
		if result <> -1 then begin
			CD.cd_Pal[0] := GetRGB4(TheScreen^.ViewPort.ColorMap,0);
			CD.cd_Pal[1] := GetRGB4(TheScreen^.ViewPort.ColorMap,1);
			CD.cd_Pal[2] := GetRGB4(TheScreen^.ViewPort.ColorMap,2);
			CD.cd_Pal[3] := GetRGB4(TheScreen^.ViewPort.ColorMap,3);
		end;
		ok := CloseScreen(TheScreen);
	end;
	CloseFont(MyTextFont);
	rtUnLockWindow(TheWindow, wl);
end;

{ Use Reqtools Screenmode requester to get users screenmode }
{ and size preferences } 
Function GetSCRID : LONG;

VAR
	scrnreq : prtScreenModeRequester;
	sreq    : pScreenModeRequester;
	Value   : Longint;
	ret     : longint;
	mytag   : Array[0..10] of tTagItem;
	UseAsl  : Boolean;

Begin
	Value := CD.cd_ModeID;
	UseAsl := False;
	wl := Pointer(rtLockWindow(TheWindow));
	If AslBase <> NIL then begin 
		If AslBase^.lib_Version >= 38 then
			UseAsl := True;
	End;
	If UseAsl then begin
		MyTag[0].ti_Tag  := ASLSM_InitialDisplayID;
		MyTag[0].ti_Data := CD.cd_ModeID;
		MyTag[1].ti_Tag  := ASLSM_InitialDisplayWidth;
		MyTag[1].ti_Data := CD.cd_ScrW;
		MyTag[2].ti_Tag  := ASLSM_InitialDisplayHeight;
		MyTag[2].ti_Data := CD.cd_ScrH;
		MyTag[3].ti_Tag  := ASLSM_InitialDisplayDepth;
		MyTag[3].ti_Data := CD.cd_ScrDepth; 
		MyTag[4].ti_Tag  := ASLSM_DoWidth;
		MyTag[4].ti_Data := True_;
		MyTag[5].ti_Tag  := ASLSM_DoHeight;
		MyTag[5].ti_Data := True_;
		MyTag[6].ti_Tag  := ASLSM_DoDepth;
		MyTag[6].ti_Data := True_;
		                        (*
		                         * MyTag[7].ti_Tag  := ASLSM_PropertyFlags;
	                         	 * MyTag[7].ti_Data := 0;
		                         * MyTag[8].ti_Tag  := ASLSM_PropertyMask;
		                         * MyTag[8].ti_Data := DIPF_IS_PF2PRI|DIPF_IS_DUALPF;
		                         *)
		MyTag[9].ti_Tag  := ASLSM_Window;
		MyTag[9].ti_Data := LONG(TheWindow);
		MyTag[10].ti_Tag := TAG_END;
		
		sreq := AllocAslRequest(ASL_ScreenModeRequest,@MyTag);
		if sreq <> NIL then begin
			if AslRequest(sreq, NIL) then begin
				value          := sreq^.sm_DisplayID;
				CD.cd_ScrW     := sreq^.sm_DisplayWidth;
				CD.cd_ScrH     := sreq^.sm_DisplayHeight;
				CD.cd_ScrDepth := sreq^.sm_DisplayDepth;
			End;
			FreeAslRequest(sreq);
		end;
	end else begin 
		scrnreq := Pointer(rtAllocRequestA (RT_SCREENMODEREQ, NIL));
		if (scrnreq<>NIL) then begin
			mytag[0].ti_Tag  := RTSC_DisplayID;
			mytag[0].ti_Data := CD.cd_ModeID;
			mytag[1].ti_Tag  := RTSC_DisplayHeight;
			mytag[1].ti_Data := CD.cd_ScrH;
			mytag[2].ti_Tag  := RTSC_DisplayWidth;
			mytag[2].ti_Data := CD.cd_ScrW;
			mytag[3].ti_Tag  := RTSC_DisplayDepth;
			mytag[3].ti_Data := CD.cd_ScrDepth;
			mytag[4].ti_Tag:=TAG_END;
			ret := rtChangeReqAttrA(scrnreq, @mytag);

			mytag[0].ti_Tag  := RTSC_Flags;
			mytag[0].ti_Data := SCREQF_SIZEGADS|SCREQF_DEPTHGAD|SCREQF_NONSTDMODES;
			mytag[1].ti_Tag  := RT_UnderScore;
			mytag[1].ti_Data := LongInt('_');
			mytag[2].ti_Tag  := RT_Window;
			mytag[2].ti_Data := LONG(TheWindow);
			mytag[3].ti_Tag  := TAG_END;

			ret:=rtScreenModeRequestA ( scrnreq, CStrConstPtrAR(@RememberKey, 'Pick a screenmode'), @mytag);
			value := LongInt(scrnreq^.DisplayID);
			CD.cd_ScrW := LongInt(scrnreq^.DisplayWidth);
			CD.cd_ScrH := LongInt(scrnreq^.DisplayHeight);
			CD.cd_ScrDepth := LONG(scrnreq^.DisplayDepth);
		end ;
		rtFreeRequest(scrnreq);
	end;
	GetSCRID := value;
	rtUnLockWindow(TheWindow, wl);
end;

{ move a node up to the of the list }
Procedure TopGadFunc;

begin
	if currentnode <> NIL then begin
		DetachObjectList;
		Remove(pNode(CurrentNode));
		AddHead(CurrentList,pNode(CurrentNode));
		CurrentOrd := 0; 
		if (CurrentOrd>ListViewRows-(ListViewRows div 2)) then
		currenttop := CurrentOrd+(ListViewRows div 2)-ListViewRows
		else currenttop := 0;
		AttachObjectList;
	end;
end;

{ move a node up the list }
Procedure UpGadFunc;

begin
	pred := pMyNode(Currentnode^.LSK_Node.ln_Pred);
	if (CurrentNode <> NIL) and (pred <> NIL) then begin
		DetachObjectList;
		(* Move node one position up *)
		pred := pMyNode(pred^.LSK_Node.ln_Pred);
		Remove(pNode(CurrentNode));
		Insert_(CurrentList,pNode(CurrentNode),pNode(pred));
		CurrentOrd := CurrentOrd - 1;
		if currentord < 0 then currentord := 0;
		if (CurrentOrd>ListViewRows-(ListViewRows div 2)) then
			currenttop := CurrentOrd+(ListViewRows div 2)-ListViewRows
		else 
			currenttop := 0;
		AttachObjectList;
	end;
end;

{ move a node down the list }
Procedure DownGadFunc;

begin
	succ := pMyNode(currentnode^.LSK_Node.ln_Succ);
	if (CurrentNode <> NIL) and (succ <> NIL) then begin
		DetachObjectList;
		Remove(pNode(CurrentNode));
		Insert_(CurrentList,pNode(CurrentNode),pNode(succ));
		Currentord := currentord + 1;
		i := 0;
		tmpnode := pMyNode(currentlist^.lh_Head);
		While tmpnode <> NIL do begin
			i := i + 1;
			tmpnode := pMyNode(tmpnode^.LSK_Node.ln_Succ);
		end;
		i := i-2;
		if currentord > i then currentord := i;
		if currentord < 0 then currentord := 0;
		if (CurrentOrd>ListViewRows-(ListViewRows div 2)) then
			currenttop := CurrentOrd+(ListViewRows div 2)-ListViewRows
		else 
			currenttop := 0;
		AttachObjectList;
	end;
end;

{ move a node to the bottom of the list }
Procedure BottomGadFunc;

begin
	if currentnode <> NIL then begin
		DetachObjectList;
		Remove(pNode(CurrentNode));
		AddTail(CurrentList,pNode(CurrentNode));
		tmpnode := pMyNode(currentlist^.lh_Head);
		i := 0;
		while tmpnode <> NIL do begin
			tmpnode := pMyNode(tmpnode^.LSK_Node.ln_Succ);
			i := i + 1;
		end;
		CurrentOrd := i - 2;
		if (CurrentOrd>ListViewRows-(ListViewRows div 2)) then
			currenttop := CurrentOrd+(ListViewRows div 2)-ListViewRows
		else 
			currenttop := 0;
		AttachObjectList;
	end;
end;

{ add a new node to the list }
Procedure NewGadFunc;

VAR
	Changed : Boolean;

begin
	DetachObjectList;
	tmpnode := Add_Name('<< New Gadget >>');
	changed := GadEDWindow(TheWindow^.LeftEdge+5, TheWindow^.TopEdge+Sizes[TBS], 
		tmpnode, CD.cd_Rexx);

	if changed then begin
		CurrentNode := tmpnode;
		currentnode^.LSK_Node.ln_Name := @currentnode^.LSK_Name[1];
		CurrentOrd := 0;
		if (CurrentOrd>ListViewRows-(ListViewRows div 2)) then
			currenttop := CurrentOrd+(ListViewRows div 2)-ListViewRows
		else 
			currenttop := 0;
		DisableObjectGadgets(False_);
	end else begin
		Remove(pNode(tmpnode));
	end;
	CD.cd_Down := calcdown(CD.cd_Across, NIL, NIL);
	AttachObjectList;
end;

{ remove a gadget node from the list }
Procedure RemoveGadFunc;

begin
	if currentnode <> NIL then begin
		DetachObjectList;
		DisableObjectGadgets(TRUE_);
		Remove(pNode(CurrentNode));
		CurrentNode := NIL;
		CurrentOrd := -1;
		currenttop := 0;
		AttachObjectList;
	end;
	CD.cd_Down := calcdown(CD.cd_Across, NIL, NIL);
end;

{ copy a gadget node }
Procedure CopyGadFunc;

begin
	if (CurrentNode <> NIL) then begin
		DetachObjectList;
		newnode := AllocRemember(@RememberKey, sizeof(tMyNode), MEMF_CLEAR);
		newnode^ := CurrentNode^;
		(* Correct pointers *)
		newnode^.LSK_Node.ln_Name := @newnode^.LSK_Name[1];
		if newnode <> NIL then begin
			Insert_(CurrentList,pNode(newnode),pNode(CurrentNode));
			CurrentNode := newnode;
			CurrentOrd := CurrentOrd + 1;
			if (CurrentOrd>ListViewRows-(ListViewRows div 2)) then
				currenttop := CurrentOrd+(ListViewRows div 2)-ListViewRows
			else 
				currenttop := 0;
		end;
		AttachObjectList;
	end;
	CD.cd_Down := calcdown(CD.cd_Across, NIL, NIL);
end;

{ save the prefs file as s:startup-menu.prefs }
Procedure SaveGadFunc;

VAR 
l, l2 : BPTR;

begin
	wl := Pointer(rtLockWindow(TheWindow));
	DetachObjectList;
	l2 := Lock(CStrConstPtrAR(@RememberKey, PrefsDIRH), ACCESS_READ);
	l := currentdir(l2);
	IF NOT WriteConfigFile(PREFSNAME) then DisplayBeep(NIL);
	AttachObjectList;
	l := currentdir(l);
	unlock(l2);
	AttachObjectList;
	rtUnLockWindow(TheWindow, wl);
	exitflag := True;
end;

{ save prefs file in user specified location }
Procedure SaveAsGadFunc;

VAR 
l, l2 : BPTR;

begin
	wl := Pointer(rtLockWindow(TheWindow));
	if AslRequest(sr, NIL) then begin
		DetachObjectList;
		l2 := Lock(STRPTR(sr^.fr_Drawer), ACCESS_READ);
		l := currentdir(l2);
		cfile := PtrToPas(STRPTR(sr^.fr_file));
		IF NOT WriteConfigFile(cfile) then DisplayBeep(NIL);
		l := currentdir(l); 
		unlock(l2);
		AttachObjectList;
	end;
	rtUnLockWindow(TheWindow, wl);
end;

Procedure NewListFunc;

Begin
	wl := Pointer(rtLockWindow(TheWindow));
	DetachObjectList;
	(* Start a' fresh *)
	CurrentList := AllocRemember(@RememberKey, sizeof(tList), MEMF_CLEAR);
	NewList(CurrentList);
	InitCD;
	CurrentNode := NIL;
	CurrentOrd := -1;
	currenttop := 0;
	DisableObjectGadgets(TRUE_);
	AttachObjectList; 
	rtUnLockWindow(TheWindow, wl);
end;

{ load a new prefs file }
Procedure LoadGadFunc;

VAR 
	l, l2 : BPTR;

Begin
	wl := Pointer(rtLockWindow(TheWindow));
	if AslRequest(lr, NIL) then begin
		DetachObjectList;
               
		l2 := Lock(STRPTR(lr^.fr_Drawer), ACCESS_READ);
		l := currentdir(l2);
               
		cfile := PtrToPas(STRPTR(lr^.fr_file));

		OKRes := ReadConfigFile(cfile);
		if OKRes then begin  
			CurrentNode := NIL;
			CurrentOrd := -1;
			currenttop := 0;
			DisableObjectGadgets(TRUE_);
		end else DisplayBeep(NIL);

		AttachObjectList; 

		l := currentdir(l);
		unlock(l2);
	end; 
	rtUnLockWindow(TheWindow, wl);
end;
               
{ if double click on LV then bring up the gadget edit window }
Procedure LVGadFunc;

VAR 
	y    : integer;
	junk : Boolean;

Begin
	oldord := currentord;
	CurrentOrd := msgCode;
	if currentord < 0 then currentord := 0;
	if (CurrentOrd>ListViewRows-(ListViewRows div 2)) then
		currenttop := CurrentOrd+(ListViewRows div 2)-ListViewRows
	else 
		currenttop := 0;
	CurrentNode := pMyNode(CurrentList^.lh_Head);
	For y := 1 to currentord do
		CurrentNode := pMyNode(CurrentNode^.LSK_Node.ln_Succ);

	(* Double Click? *)
	if (DoubleClick(CurrentSecs, CurrentMics, NewSecs, NewMics)) and
	(currentord = oldord) then begin
		wl := Pointer(rtLockWindow(TheWindow));
		detachobjectlist;
		junk := GadEDWindow(TheWindow^.LeftEdge+5, TheWindow^.TopEdge+Sizes[TBS], 
		currentnode, CD.cd_Rexx);
		currentnode^.LSK_Node.ln_Name := @currentnode^.LSK_Name[1];
		attachobjectlist;
		rtUnLockWindow(TheWindow, wl);
	end; 

	currentSecs := NewSecs;
	CurrentMics := NewMics;

	DisableObjectGadgets(False_);
end;


{ requester alowing user to pick a font }
Procedure FontGadFunc(Scroll : Boolean);

VAR
	tgs : Array[0..7] of tTagItem;
	fr  : pFontRequester;

begin
	tgs[0].ti_Tag  := ASLFO_TitleText;
	tgs[1].ti_Tag  := ASLFO_InitialName;
	tgs[2].ti_Tag  := ASLFO_InitialSize;
	tgs[3].ti_Tag  := ASLFO_MaxHeight;
	tgs[3].ti_Data := 100;
	tgs[4].ti_Tag  := ASLFO_Flags;
	tgs[4].ti_Data := FOF_DOSTYLE;
	if Scroll then begin
		tgs[0].ti_Data := LONG(CStrConstPtrAR(@RememberKey, 'Pick a font for the scrolling text'));
		tgs[1].ti_Data := LONG(CD.cd_SFont.ta_Name);
		tgs[2].ti_Data := long(CD.cd_SFont.ta_YSize);
		tgs[4].ti_Data := tgs[4].ti_Data|FOF_FIXEDWIDTHONLY;
	end else begin
		tgs[0].ti_Data := LONG(CStrConstPtrAR(@RememberKey, 'Pick a font for the gadgets'));
		tgs[1].ti_Data := LONG(CD.cd_Font.ta_Name);
		tgs[2].ti_Data := long(CD.cd_Font.ta_YSize);
	end;
	tgs[5].ti_Tag  := ASLFO_Window;
	tgs[5].ti_Data := long(TheWindow);
	tgs[6].ti_Tag  := ASLFO_InitialStyle;
	tgs[6].ti_Data := long(CD.cd_Font.ta_Style);
	tgs[7].ti_Tag  := TAG_DONE;
	fr := AllocASLRequest(ASL_FontRequest, @tgs);
	if fr <> NIL then begin
		wl := Pointer(rtLockWindow(TheWindow));
		if AslRequest(fr, @tgs) then begin
			if Scroll then begin
				CD.cd_SFont := fr^.fo_Attr;
				CD.cd_SFontName := PtrToPas(fr^.fo_Attr.ta_NAME)+#0;
				CD.cd_SFont.ta_NAME := @CD.cd_SFontName[1];
			end else begin
				CD.cd_Font := fr^.fo_Attr;
				CD.cd_FontName := PtrToPas(fr^.fo_Attr.ta_NAME)+#0;
				CD.cd_Font.ta_NAME := @CD.cd_FontName[1];
			end;  
		end;
		rtUnLockWindow(TheWindow, wl);
		FreeAslRequest(fr);
	end;
end;

{ 'run' Startup-Menu with the current prefs file in memory as arguments }
Procedure TestGadFunc;

VAR
	ts       : String;
	OldFlush : Boolean;
	
Begin
	begin
		wl := Pointer(rtLockWindow(TheWindow));
		ts := CD.cd_ScrTit;
		OldFlush := CD.cd_Flush;
		CD.cd_Flush := False;
		CD.cd_Test := True;
		CD.cd_ScrTit := CD.cd_ScrTit + ' ...TESTING-CMD NOT RUN ON BUTTON DEPRESS';
		IF WriteConfigFile('RAM:SMPrefs.TMP') then begin
			if NOT Execsynch(STRPTR(CStrConstPtrAR(@RememberKey, 'Startup-Menu RAM:SMPrefs.TMP'))) then
				DisplayBeep(NIL);

			Erase('RAM:SMPrefs.TMP');
		end;
		CD.cd_ScrTit := ts;
		CD.cd_Flush := OldFlush;
		CD.cd_Test := False;
		
		rtUnLockWindow(TheWindow, wl);
	end;
end;