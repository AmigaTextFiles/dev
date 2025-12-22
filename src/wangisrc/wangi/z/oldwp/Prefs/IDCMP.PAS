Procedure InfoGadFunc;

VAR
	ret : LONG;
	al  : Array[0..2] of LONG;
	grk : pRemember;
	ez  : pEasyStruct;
	
begin
	grk := NIL;
	wl := Pointer(rtLockWindow(TheWindow));
	
	ez := AllocRemember(@grk, Sizeof(tEasyStruct), MEMF_CLEAR);
	if ez <> NIL then begin
		With ez^ do begin
			es_StructSize :=  Sizeof(tEasyStruct);
			es_Title := CStrConstPtrAR(@grk, 'WangiPad Prferences');
			es_TextFormat := CStrConstPtrAR(@grk,
							'WangiPad Copyright ©Lee Kindness.'#10+
							'%s'#10#10+
							'A compact launch-pad utility'#10+
							'Read "WangiPad.Guide" for more information'#10#10+
							'Comments to:'#10+
							' Lee Kindness'#10+
							' 8 Craigmarn Road'#10+
							' Portlethen Village'#10+
							' Aberdeen AB1 4QR'#10+
							' SCOTLAND'#10#10+
							'Registered to: %s'#10+
							'ID: %lx');
			es_GadgetFormat := CStrConstPtrAR(@grk, 'Ok');
		End;
		al[0] := LONG(@Prefsver[6]);
		al[1] := LONG(CStrConstPtrAR(@grk, Reg.key_User));
		al[2] := Reg.key_ID;
		ret := EasyRequestArgs(TheWindow, ez, NIL, @al);
	end;
	FreeRemember(@grk, True);
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
	tags[3].ti_Tag  := RTGS_AllowEmpty;
	tags[3].ti_Data := True_;
	tags[4].ti_Tag  := TAG_END;

	buffer := PtrToPas(CD.cd_ScrTit)+#0;
	If GetWindow then begin
		ret := rtGetStringA (@buffer[1], 127, CStrConstPtrAR(@RememberKey, Win_Title), NIL, @tags);
		if ret <> 0 then
			CD.cd_ScrTit := CStrConstPtrAR(@RememberKey, PtrToPas(@Buffer[1]));
	End else begin
		buffer := PtrToPas(CD.cd_WinTit)+#0;
		tags[1].ti_Data := LONG(CStrConstPtrAR(@RememberKey, 'Enter the text to be displayed'+#10+' on the window titlebar.'));
		ret:=rtGetStringA (@buffer[1], 127, CStrConstPtrAR(@RememberKey, Win_Title), NIL, @tags);
		if ret <> 0 then 
			CD.cd_WinTit := CStrConstPtrAR(@RememberKey, PtrToPas(@buffer[1]));
	End;
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
	pred := pMyNode(Currentnode^.wi_Node.ln_Pred);
	if (CurrentNode <> NIL) and (pred <> NIL) then begin
		DetachObjectList;
		(* Move node one position up *)
		pred := pMyNode(pred^.wi_Node.ln_Pred);
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
	succ := pMyNode(currentnode^.wi_Node.ln_Succ);
	if (CurrentNode <> NIL) and (succ <> NIL) then begin
		DetachObjectList;
		Remove(pNode(CurrentNode));
		Insert_(CurrentList,pNode(CurrentNode),pNode(succ));
		Currentord := currentord + 1;
		i := 0;
		tmpnode := pMyNode(currentlist^.lh_Head);
		While tmpnode <> NIL do begin
			i := i + 1;
			tmpnode := pMyNode(tmpnode^.wi_Node.ln_Succ);
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
			tmpnode := pMyNode(tmpnode^.wi_Node.ln_Succ);
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
	tmpnode := Add_Name('<< New Item >>');
	changed := GadEDWindow(TheWindow^.LeftEdge+5, TheWindow^.TopEdge+Sizes[TBS], 
		tmpnode);

	if changed then begin
		CurrentNode := tmpnode;
		CurrentOrd := 0;
		if (CurrentOrd>ListViewRows-(ListViewRows div 2)) then
			currenttop := CurrentOrd+(ListViewRows div 2)-ListViewRows
		else 
			currenttop := 0;
		DisableObjectGadgets(False_);
	end else begin
		Remove(pNode(tmpnode));
	end;
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
		AttachObjectList;
	end;
end;

{ copy a gadget node }
Procedure CopyGadFunc;

begin
	if (CurrentNode <> NIL) then begin
		DetachObjectList;
		newnode := AllocRemember(@RememberKey, sizeof(tMyNode), MEMF_CLEAR);
		newnode^ := CurrentNode^;
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
end;

{ save the prefs file }
Procedure SaveGadFunc;
begin
	wl := Pointer(rtLockWindow(TheWindow));
	DetachObjectList;
	IF NOT WriteConfigFile(V.arg_FileName) then DisplayBeep(NIL);
	AttachObjectList;
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

		If mode = LM_LOAD then 
			CloseFont(CD.cd_TFont);
		OKRes := ReadConfigFile(cfile, mode, RememberKey);
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
		CurrentNode := pMyNode(CurrentNode^.wi_Node.ln_Succ);

	(* Double Click? *)
	if (DoubleClick(CurrentSecs, CurrentMics, NewSecs, NewMics)) and
	(currentord = oldord) then begin
		wl := Pointer(rtLockWindow(TheWindow));
		detachobjectlist;
		junk := GadEDWindow(TheWindow^.LeftEdge+5, TheWindow^.TopEdge+Sizes[TBS], 
		currentnode);
		attachobjectlist;
		rtUnLockWindow(TheWindow, wl);
	end; 

	currentSecs := NewSecs;
	CurrentMics := NewMics;

	DisableObjectGadgets(False_);
end;


{ requester alowing user to pick a font }
Procedure FontGadFunc;

VAR
	tgs : Array[0..7] of tTagItem;
	fr  : pFontRequester;

begin
	tgs[0].ti_Tag  := ASLFO_TitleText;
	tgs[0].ti_Data := LONG(CStrConstPtrAR(@RememberKey, 'Pick a font for the Pad'));
	tgs[1].ti_Tag  := ASLFO_InitialName;
	tgs[1].ti_Data := LONG(CD.cd_Font.ta_Name);
	tgs[2].ti_Tag  := ASLFO_InitialSize;
	tgs[2].ti_Data := long(CD.cd_Font.ta_YSize);
	tgs[3].ti_Tag  := ASLFO_MaxHeight;
	tgs[3].ti_Data := 100;
	tgs[4].ti_Tag  := ASLFO_Flags;
	tgs[4].ti_Data := 0;
	tgs[5].ti_Tag  := ASLFO_Window;
	tgs[5].ti_Data := long(TheWindow);
	tgs[6].ti_Tag  := ASLFO_InitialStyle;
	tgs[6].ti_Data := long(CD.cd_Font.ta_Style);
	tgs[7].ti_Tag  := TAG_DONE;
	fr := AllocASLRequest(ASL_FontRequest, @tgs);
	if fr <> NIL then begin
		wl := Pointer(rtLockWindow(TheWindow));
		if AslRequest(fr, @tgs) then begin
			CD.cd_Font := fr^.fo_Attr;
			CD.cd_Font.ta_NAME := CStrConstPtrAR(@RememberKey, PtrToPas(fr^.fo_Attr.ta_Name)); 
		end;
		rtUnLockWindow(TheWindow, wl);
		FreeAslRequest(fr);
	end;
end;

