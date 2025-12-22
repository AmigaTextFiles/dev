(*
 * Shrub... HSPascal source
 *
 * ©Lee Kindness
 *
 * ProcessMsg.pas
 *
 *)

Procedure EnableMenuItems;

Begin
	OnMenu(w, FULLMENUNUM(0, MN_SAVAS, 0));
	OnMenu(w, FULLMENUNUM(0, MN_INFO, 0));
	OnMenu(w, FULLMENUNUM(0, MN_PRINT, 0));
	OnMenu(w, FULLMENUNUM(2, MN_FIND, 0));
	OnMenu(w, FULLMENUNUM(2, MN_FINDNEXT, 0));
End;

Procedure HandleResize(VAR w : pWindow);
	
Var
	pos, Top : LONG;
	t : Array[0..3] of tTagItem;
	
Begin
	pos := RemoveGList(w, g[G_NI], -1);
	if pos <> -1 then begin
		EraseRect(w^.RPort, 0, 0, w^.Width, w^.Height);
		arg.arg_Left    := w^.LeftEdge;
		arg.arg_Top     := w^.TopEdge;
		arg.arg_Width   := w^.Width;
		arg.arg_Height := w^.Height;
		
		pos := 0;
		if GadToolsBase^.lib_Version >= 39 then begin
			T[0].ti_Tag  := GTLV_Top;
			T[0].ti_Data := LONG(@Top);
			T[1].ti_Tag  := TAG_END;
			pos := GT_GetGadgetAttrsA(g[G_LV], w, NIL, @t);
		End;
		if pos = 0 then top := 0;
		
		FreeGadgets(g[G_NI]);
		g[G_NI] := NIL;
		G[G_CC] := CreateContext(@G[G_NI]);
		If G[G_CC] <> NIL Then begin
			T[0].ti_Tag  := GTLV_Top;
			T[0].ti_Data := top;
			t[1].ti_Tag  := GTLV_Labels;
			t[1].ti_Data := LONG(th^.th_List);
			T[2].ti_Tag  := GTLV_ShowSelected;
			T[2].ti_Data := 0;
			T[3].ti_Tag  := TAG_END;
			With GadgetFlags Do Begin
				ng_TextAttr   := @My_Font;
				ng_LeftEdge   :=  8;
				ng_TopEdge    := S[TBS]+2;
				ng_Width      := Arg.arg_Width-ng_LeftEdge*2;
				ng_VisualInfo := vi;
				ng_Height     := Arg.arg_Height-ng_TopEdge-13;
				if GadToolsBase^.lib_Version < 39 then
					ng_Height := ng_Height - S[TBS];
				ng_GadgetText := NIL;
				ng_GadgetID   := G_LV;
				ng_Flags      := 0;
			End;
			G[G_LV] := CreateGadgetA(LISTVIEW_KIND, G[G_CC], @Gadgetflags, @T);

			pos := AddGList(w, g[G_NI], $FFFF, -1, NIL);
			RefreshGList(g[G_NI], w, NIL, -1);
			GT_RefreshWindow(w,NIL);
			RefreshWindowFrame(w);
		End;
	End;
End;


Procedure EnableWindow(w : pWindow; key : Pointer);

Var
	edw : pEnDisWin;

Begin
	if pLibrary(SysBase)^.lib_Version >= 39 then begin
		SetWindowPointerA(w, NIL);
		edw := pEnDisWin(key);
		If edw <> NIL then begin
			if edw^.edw_Req <> NIL then begin
				EndRequest(edw^.edw_Req, w);
				if (edw^.edw_OldWidth <> w^.Width) or 
				   (edw^.edw_OldHeight <> w^.Height) then { resize window }
					HandleResize(w);
				FreeVec(edw^.edw_Req);
				FreeVec(edw);
			End;
		End;
	End else begin
		if ReqToolsBase <> NIL then begin
			if key <> NIL then begin
				rtUnLockWindow(w, Key);
			End;
		End;
	End;
End;

Function DisableWindow(w : pWindow) : Pointer;

Var
	t : Array[0..4] of LONG;
	req : pEnDisWin;

begin
	DisableWindow := NIL;
	if pLibrary(SysBase)^.lib_Version >= 39 then begin
		t[0] := WA_BusyPointer;
		t[1] := True_;
		t[2] := WA_PointerDelay;
		t[3] := True_;
		t[4] := TAG_END;
		SetWindowPointerA(w, @t);
		req := AllocVec(sizeof(tEnDisWin), MEMF_CLEAR);
		if req <> NIL then begin
			req^.edw_Req := AllocVec(sizeof(tRequester), MEMF_CLEAR);
			if req^.edw_req <> NIL then begin
				If Request(req^.edw_req, w) then begin
					req^.edw_OldWidth := w^.Width;
					req^.edw_OldHeight := w^.Height;
					DisableWindow := Pointer(req);
				end else begin
					FreeVec(req^.edw_Req);
					FreeVec(req);
				End;
			End;
		End;
	End else begin
		If ReqtoolsBase <> NIL then
			DisableWindow := Pointer(rtLockWindow(w));
	End;
end;

Function WriteString(VAR f : BPTR; s : String) : Boolean;
VAR
	err : LONG;
	
begin
	S := S+#10+#0; { add EOL and null term. }
	err := FPuts(f,@s[1]);
	if err = 0 then
		WriteString := True
	else
		WriteString := False;
End;

Procedure PrintAscii(filename : String; Print : Boolean; w : pWindow);

VAR
	node    : pNode;
	out     : BPTR;
	dobj    : pDiskObject;
	olddt,
	thgs    : STRPTR;
	daybuf, 
	datebuf, 
	buf     : String;
	dt      : pDateTime;
	ds      : pDateStamp;
	Ok, Ok2 : Boolean;
	y       : LONG;
	ez      : pEasyStruct;
	
Begin
	Ok := False;
	out := Open(CStrConstPtrAR(@th^.th_RK, filename), MODE_NEWFILE);
	if Out <> NULL then begin
		If WriteString(out, '; Directory tree of "'+FExpandLock(th^.th_Loc)+'"') then begin
			if WriteString(out, '; Created by Shrub ©Lee Kindness') then begin
		
				ds := AllocVec(Sizeof(tDateStamp), MEMF_CLEAR);
				if ds <> NIL then begin
					ds := DateStamp(ds);
					dt := AllocVec(Sizeof(tDateTime), MEMF_CLEAR);
					if dt <> NIL then begin
						With dt^ do begin
							dat_Stamp   := ds^;
							dat_Format  := 4 {FORMAT_DEF};
							dat_StrDay  := @daybuf;
							dat_StrDate := @datebuf;
							dat_StrTime := @buf;
						End;
						If DateToStr(dt) then begin
							Ok := WriteString(out, '; Creation date: '+PtrToPas(@daybuf)+' '+
							                                           PtrToPas(@datebuf)+' '+
							                                           PtrToPas(@buf));
						End;
						FreeVec(dt);
					End;
					FreeVec(ds);
				End;
				
				If Ok then begin
		
					if WriteString(out, '') then begin
		
						if NOT ((numd = 0) and (numf = 0) and (tnumf = 0)) then begin 
							node := th^.th_List^.lh_Head;
							while (node^.ln_Succ <> NIL) and (Ok) do begin
								Ok := WriteString(out,PtrToPas(node^.ln_Name));
								node := node^.ln_Succ;
							End;
						End else
							Ok := WriteString(out, 'Directory is empty!');
			
						if (NOT Print) and (Ok) then begin
							{ save comment }
							Ok2 := SetComment(CStrConstPtrAR(@th^.th_RK, filename),
								CStrConstPtrAR(@th^.th_RK, '"'+FExpandLock(th^.th_Loc)+'" Shrub ©Lee Kindness'));
							Ok2 := SetProtection(CStrConstPtrAR(@th^.th_RK, filename),
								FIBF_EXECUTE);
						End;
		
						if (arg.arg_SaveIcons) and (NOT Print) then begin
							dobj := GetDefDiskObject(WBPROJECT);
							if dobj <> NIL then begin
								olddt := dobj^.do_DefaultTool;
								dobj^.do_DefaultTool := CStrConstPtrAR(@th^.th_RK, 'SYS:Utilities/More');
								filename := filename +#0;
								OK2 := PutDiskObject(@filename[1], dobj);
								dobj^.do_DefaultTool := olddt;
								FreeDiskObject(dobj);
							End;
						End;
						If (print) and (Ok) then
							Ok := WriteString(out, ''#12); { write a formfeed character }
					End;
				End;
			End;
		End;
		Ok2 := AmigaDos.Close_(out);
	End;
	If Ok = False then begin
		ez := AllocVec(Sizeof(tEasyStruct), MEMF_CLEAR);
		If ez <> NIL then begin
			with ez^ do begin
				es_StructSize :=  Sizeof(tEasyStruct);
				es_Title := CStrConstPtrAR(@th^.th_RK, 'Shrub');
				if print then
					es_TextFormat := CStrConstPtrAR(@th^.th_RK,'Error Printing')
				else
					es_TextFormat := CStrConstPtrAR(@th^.th_RK,'Error Writing file:'#10+
					                                           '%s');
				es_GadgetFormat := CStrConstPtrAR(@th^.th_RK,'Ok');
			End;
			y := Fault(IOErr, NIL, @buf, 256);
			thgs := @buf;
			y := EasyRequestArgs(w, ez, NIL, @thgs);
			FreeVec(ez);
		End;
	End;
End;

Procedure NewTree(w : pWindow; g :pGadget);
	
VAR
	fr : pFileRequester;
	t : Array[0..8] of LONG;
	tl : BPTR;
	Key : pWindow;

Begin
	key := DisableWindow(w);
	t[0] := ASLFR_TitleText;
	t[1] := LONG(CStrConstPtrAR(@th^.th_RK, 'Select a directory for the tree'));
	t[2] := ASLFR_Flags2;
	t[3] := FRF_DRAWERSONLY|FRF_REJECTICONS;
	t[4] := ASLFR_InitialDrawer;
	t[5] := LONG(CStrConstPtrAR(@th^.th_RK, cdir));
	t[6] := ASLFR_Window;
	t[7] := LONG(w);
	t[8] := TAG_DONE;

	fr := AllocASLRequest(ASL_FileRequest, @t);
	if fr <> NIL then begin
		if AslRequest(fr, NIL) then begin
		
			{ detach list }
			t[0] := GTLV_Labels;
			t[1] := $FFFFFFFF;
			t[2] := TAG_END;
			GT_SetGadgetAttrsA(g, w, NIL, @t);
			
			tl := Lock(STRPTR(fr^.fr_Drawer), ACCESS_READ);
			if tl <> NULL then begin
				wintitle := 'Freeing Tree...'#0;
				SetWindowTitles(w, @wintitle[1], STRPTR(-1));
				FreeTree(th);
				wintitle := 'CreatingTree...'#0;
				SetWindowTitles(w, @wintitle[1], STRPTR(-1));
				th := AllocTree(th);
				if th = NIL then Halt;
				th^.th_Loc := tl;
				If Empty then
					EnableMenuItems(w);
				CreateTree(th, True);
			End;
			
			cdir := PtrToPas(STRPTR(fr^.fr_Drawer));
			
			{ attach list }
			t[0] := GTLV_Labels;
			t[1] := LONG(th^.th_List);
			t[2] := TAG_END;
			GT_SetGadgetAttrsA(g, w, NIL, @t);
			
			wintitle := 'Tree for "' + cdir + '"'#0;
			scrtitle := DEFTITLE + #0;
			SetWindowTitles(w, @wintitle[1], @scrtitle[1]); 
		end;
		FreeAslRequest(fr);
	End;
	EnableWindow(w, Key);
End;


Procedure SaveAs(w : pWindow);
	
VAR
	fr      : pFileRequester;
	t       : Array[0..10] of LONG;
	buf     : String[255];
	key     : Pointer;
	fullname,
	dir, ext,
	name,
	cfile   : String;
	
Const
	cdir : String[80] = 'RAM:';

Begin
	if NOT empty then begin
		key := DisableWindow(w);
		
		fullname := FExpandLock(th^.th_Loc);
		FSplit(fullname, dir, name, ext);
		cfile := name+'.tree';
		
		t[0] := ASLFR_TitleText;
		t[1] := LONG(CStrConstPtrAR(@th^.th_RK, 'Select a file'));
		t[2] := ASLFR_InitialDrawer;
		t[3] := LONG(CStrConstPtrAR(@th^.th_RK, cdir));
		t[4] := ASLFR_InitialFile;
		t[5] := LONG(CStrConstPtrAR(@th^.th_RK, cfile));
		t[6] := ASLFR_Flags1;
		t[7] := FRF_DOSAVEMODE;
		t[8] := ASLFR_Window;
		t[9] := LONG(w);
		t[10] := TAG_DONE;
		fr := AllocASLRequest(ASL_FileRequest, @t);
		if fr <> NIL then begin
			if AslRequest(fr, NIL) then begin
				cdir := PtrToPas(STRPTR(fr^.fr_Drawer));
				cfile := PtrToPas(STRPTR(fr^.fr_File));
				buf := cdir + #0;
				If AddPart(@buf[1],STRPTR(fr^.fr_File), 255) then begin
					buf := PtrToPas(@buf[1]);
					PrintAscii(buf, false, w);
				End; 
			end;
			FreeAslRequest(fr);
		End;
		EnableWindow(w, key);
	End else DisplayBeep(NIL);
End;

Function UpperStr(s : String) : String;
Var
     X : Byte;
Begin
  For X := 1 To Length(S) Do
    S[X] := UpCase(S[X]);
  UpperStr := S;
End;

Function StripN(nd : pmn): String;

Var
	StartPos : Integer;

begin
	startpos := 1;
	if nd^.ln_NumSTxt <> 0 then
		startpos := Length(arg.arg_STxt) * nd^.ln_NumSTxt +1;
		
	StripN := Copy(PtrToPas(nd^.ln_Name), startpos, nd^.ln_AbsNameSize);
End;


Procedure RebuildPath(node : pmn; VAR name : String);

Var
	csts : Integer;
	n2     : pmn;
	
Begin
	{ rebuild the path }
	n2 := node^.ln_Pred;
	ok := True;
	csts := node^.ln_NumSTxt;
	while (n2^.ln_Pred <> NIL) and (Ok) do begin
		if n2^.ln_DirEntryType > 0 then begin
			if n2^.ln_NumStxt < csts then begin
				csts := n2^.ln_NumStxt;
		 		name := StripN(n2) + '/' + Name;
		 	End;
		End;
		if n2^.ln_NumSTxt = 0 then
			Ok := False;
		n2 := n2^.ln_Pred;
	End;
End;

Procedure ExecAsynch(filename : String);

VAR
	t       : Array[0..3] of tTagItem;
	outfile : BPTR;
	rc      : LONG;
	ok      : Boolean;

CONST
	Out : String[5] = 'NIL:'#0;
	
Begin
	filename := arg.arg_Viewer + ' "' + filename + '"'#0;
	{ open IO file }
	outfile := Open(@out[1], MODE_OLDFILE);
	{ Start program }
	t[0].ti_Tag  := SYS_ASynch;
	t[0].ti_Data := True_;
	t[1].ti_Tag  := SYS_Input;
	t[1].ti_Data := outfile;
	t[2].ti_Tag  := SYS_Output;
	t[2].ti_Data := 0;
	t[3].ti_Tag  := TAG_END;
	rc := SystemTagList(@filename[1], @t);
	If rc <> 0 then Begin
		If rc = -1 Then
			ok := Close_(outfile);
		DisplayBeep(NIL);
	End;
End;

	
Procedure ViewAction(w : pWindow; node : pmn; action : LONG);

Var
	FinalName, FinalNameNN, Name, DirPart, ext : String;
	l  : BPTR;
	Ok : Boolean;
	n  : LONG;

Begin
	If node <> NIL Then Begin
		{ Strip white space and other junk }
		Name := StripN(node);
		{ rebuild to complete path from starting dir }
		RebuildPath(node, Name);
		{ rebuild the FULL path }
		FinalName := FExpandLock(th^.th_Loc);
		FinalName := FinalName+#0;
		Name := Name + #0;
		Ok := AddPart(@FinalName[1], @Name[1], 255);
		FinalName := PtrToPas(@FinalName[1]);
		{ Split full path into separate bits }
		FSplit(FinalName, DirPart, Name, ext);
		{ Null terminate each and join if required }
		Name := Name + ext + #0;
		DirPart := DirPart + #0;
		FinalNameNN := FinalName;
		FinalName := FinalName + #0;

		l := Lock(@DirPart[1], ACCESS_READ);
		if l <> NULL then begin
			Case Action Of
				VIEW_ACTION_INFO : If WorkBenchBase^.lib_Version >= MININFOVER then
					n := WBInfo(l, @Name[1], w^.WScreen)
				else
					DisplayBeep(NIL);
				VIEW_ACTION_SHOW : ExecASynch(FinalNameNN);
			End;
			UnLock(l);
		End Else
			DisplayBeep(NIL);
	End Else
		DisplayBeep(NIL);
End;


Procedure HandleSearch(w : pWindow; mode : LONG);
	
Var
	SearchNode, 
	node2 : pmn;
	rk    : pRemember;
	t     : Array[0..6] Of LONG;
	key   : Pointer;
	n     : Integer;
	CurNodeText : String;
	ret   : LONG;
	cont  : Boolean;
	ez    : pEasyStruct;
	
Begin
	rk := NIL;
	Key := DisableWindow(w);
	
	If (cnode = NIL) Then
		SearchNode := pmn(th^.th_List^.lh_Head)
	else begin
		SearchNode := cnode;
		If (searchnode^.ln_Succ^.ln_Succ <> NIL) Then
			SearchNode := SearchNode^.ln_Succ;
	End;
	
	If NOT ValidPattern Then
		buf := ''#0;
	
	{ get search text }
	If mode = FIND_ITEM Then Begin
		ValidPattern := False;
		t[0] := RTGS_TextFmt;
		t[1] := LONG(CStrConstPtrAR(@rk, 'Enter the text to search for below.'#10+
		                                 'Standard wildcards are supported.'));
		t[2] := RTGS_Flags;
		t[3] := GSREQF_CENTERTEXT;
		t[4] := TAG_END;
		ret := rtGetStringA(@buf[1], 250, CStrConstPtrAR(@rk, 'Enter Search String'),
		                    NIL, @t);
		If ret = True_ Then Begin
			SearchText := '#?' + PtrToPas(@buf[1]) + '#?'#0;
			If pLibrary(DosBase)^.lib_Version < 39 then
				searchtext := UpperStr(searchtext); { V37 dos character classes workaround }
			{ parse the pattern }
			If ParsePatternNoCase(CStrConstPtrAR(@th^.th_RK, SearchText), @SKey, 514) <> -1 then
				ValidPattern := True;
		End;
	End Else
		ret := True_;
	
	If ret = True_ Then Begin
		cont := True;
		while (SearchNode^.ln_Succ <> NIL) and (cont) do begin
			curnodetext := StripN(SearchNode) + #0;
			If MatchPatternNoCase(@SKey, @curnodetext[1]) then begin
				cont := False;
				cnode := SearchNode;
				n := 0;
				node2 := pmn(th^.th_List^.lh_Head);
				While node2 <> SearchNode Do Begin
					node2 := node2^.ln_Succ;
					inc(n);
				End;
				T[0] := GTLV_Selected;
				T[1] := n;
				T[2] := GTLV_Top;
				If n > 2 then
					T[3] := n-2
				Else
					T[3] := 0;
				T[4] := GTLV_MakeVisible;
				T[5] := n;
				T[6] := TAG_END;
				GT_SetGadgetAttrsA(g[G_LV], w, NIL, @t);
				
			End else
				SearchNode := SearchNode^.ln_Succ;
		End;
		If SearchNode^.ln_Succ = NIL Then Begin
			ez := AllocVec(Sizeof(tEasyStruct), MEMF_CLEAR);
			If ez <> NIL Then Begin
				With ez^ Do Begin
					es_StructSize := Sizeof(tEasyStruct);
					es_Title := CStrConstPtrAR(@rk, 'Search');
					es_TextFormat := CStrConstPtrAR(@rk, 'No more matches found.');
					es_GadgetFormat := CStrConstPtrAR(@rk, 'Ok');
					ret := EasyRequestArgs(w, ez, NIL, NIL);
				End;
				FreeVec(ez);
			End;
		End;
	End;
	FreeRemember(@rk, True);
	EnableWindow(w,key);
End;
	


Procedure HandleMenu(w: pWindow; MenuNumber : Word; Var Exitflag : Boolean);

Var
	y, INum, MNum : Word;
	item          : pMenuItem;
	ez            : pEasyStruct;
	key           : Pointer;
	
Begin
	While (menunumber <> MENUNULL) and (ExitFlag = False) do begin
		item := ItemAddress(menustrip, menunumber);
		Case LONG(GTMENUITEM_USERDATA(item)) of 
			M_DIR  : NewTree(w, G[G_LV]);
			M_SAVE : SaveAs(w);
			M_INFO : if NOT empty then begin
				key := DisableWindow(w);
				ez := AllocRemember(@grk, Sizeof(tEasyStruct), MEMF_CLEAR);
				if ez <> NIL then begin
					With ez^ do begin
						es_StructSize :=  Sizeof(tEasyStruct);
						es_Title := CStrConstPtrAR(@grk, 'Shrub Stastistics');
						if (numd = 0) and (numf = 0) and (tnumf = 0) then
							es_TextFormat := CStrConstPtrAR(@grk,
								'Directory "%s" is empty')
						Else
							es_TextFormat := CStrConstPtrAR(@grk,
								'Directory "%s"'#10+
								'%ld drawers'#10+
								'%ld files shown out of %ld possible');
						es_GadgetFormat := CStrConstPtrAR(@grk, 'Ok');
					End;
					al[0] := LONG(CStrConstPtrAR(@th^.th_RK, FExpandLock(th^.th_Loc)));
					al[1] := numd;
					al[2] := numf;
					al[3] := tnumf;
					y := EasyRequestArgs(w, ez, NIL, @al);
				end;
				EnableWindow(w, key);
			end else DisplayBeep(NIL);
			M_PRINT : if NOT empty then begin
				key := DisableWindow(w);
				PrintAscii('PRT:', True, w);
				EnableWindow(w, key);
			End else DisplayBeep(NIL);
			M_ABOUT : Begin
				key := DisableWindow(w);
				ez := AllocRemember(@th^.th_RK, Sizeof(tEasyStruct), MEMF_CLEAR);
				if ez <> NIL then begin
					With ez^ do begin
						es_StructSize :=  Sizeof(tEasyStruct);
						es_Title := CStrConstPtrAR(@th^.th_RK, 'Shrub Information');
						es_TextFormat := CStrConstPtrAR(@th^.th_RK,
							'Shrub Copyright ©Lee Kindness.'#10+
							'%s'#10+
							''#10+
							'If you can''t find the roots then the shrub must be dead...'#10+
							'Read "Shrub.Guide" for more information'#10+
							''#10+
							'Comments to:'#10+
							' Lee Kindness'#10+
							' 8 Craigmarn Road'#10+
							' Portlethen Village'#10+
							' Aberdeen AB1 4QR'#10+
							' SCOTLAND'#10);
						es_GadgetFormat := CStrConstPtrAR(@th^.th_RK, 'Ok');
					End;
					al[0] := LONG(@ves[6]);
					y := EasyRequestArgs(w, ez, NIL, @al);
				end;
				EnableWindow(w, key);
			end;
			M_SHOWDC : ViewAction(w, cnode, VIEW_ACTION_SHOW);
			M_INFODC : ViewAction(w, cnode, VIEW_ACTION_INFO);
			M_FIND : HandleSearch(w, FIND_ITEM);
			M_FINDNEXT : If ValidPattern Then HandleSearch(w, FIND_NEXTITEM);
			M_QUIT : ExitFlag := True;
			M_SHOW : begin
				if (item^.Flags and CHECKED) <> 0 then
					arg.arg_ShowIcons := True
				else
					arg.arg_ShowIcons := False;
			End;
			M_SICO : begin
				if (item^.Flags and CHECKED) <> 0 then
					arg.arg_SaveIcons := True
				else
					arg.arg_SaveIcons := False;
			End;
			M_FLD : begin
				if (item^.Flags and CHECKED) <> 0 then
					arg.arg_fld := True
				else
					arg.arg_fld := False;
			End;
			M_SODC : begin
				if (item^.Flags and CHECKED) <> 0 then
					arg.arg_ShowODC := True
				else
					arg.arg_ShowODC := False;
			End;
			M_IODC : begin
				if (item^.Flags and CHECKED) <> 0 then
					arg.arg_InfoODC := True
				else
					arg.arg_InfoODC := False;
			End;
		End;
		menunumber := item^.NextSelect;
	end;
end;

Procedure HandleLV(w : pWindow; node : pmn);

Var
	t        : Array[0..2] of LONG;
	key      : pWindow;
	n        : LONg;
	l, tmplock, odir        : BPTR;
	name, finalname, dirpart, ext, titletext     : String;	
	
Begin
	key := DisableWindow(w);
	{ detach list }
	t[0] := GTLV_Labels;
	t[1] := $FFFFFFFF;
	t[2] := TAG_END;
	GT_SetGadgetAttrsA(g[G_LV], w, NIL, @t);

	name := StripN(node);
	
	RebuildPath(node, name);
	
	FinalName := FExpandLock(th^.th_Loc);
	finalname := finalname+#0;
	name := name + #0;
	Ok := AddPart(@finalname[1], @name[1], 255);
	finalname := PtrToPas(@finalName[1]);
	
	FSplit(finalname, dirpart, name, ext);
	name := name+ext;
		
	titleText := '';
	if Pos('l>', PtrToPas(node^.ln_Name)) <> 0 then begin
		tmplock := Lock(CStrConstPtrAR(@th^.th_RK, finalname), ACCESS_READ);
		if tmplock <> NULL then begin
			Case node^.ln_DirEntryType Of
				ST_SOFTLINK : TitleText := 'soft link to';
				ST_LINKFILE : TitleText := 'hard file link to';
				ST_LINKDIR  : TitleText := 'hard drawer link to';
				Else TitleText := '';
			End;
			titleText := '"'+finalname+'" '+TitleText+' "'+FExpandLock(tmplock)+'"';
			UnLock(tmplock);
		End;
	End else begin
		titletext := '"'+finalname+'"';
	End;
	scrtitle := titletext + #0;
	SetWindowTitles(w, STRPTR(-1), @scrtitle[1]);
	
	if pos('.INFO',UpperStr(finalname)) = 0 then begin
		l := Lock(CStrConstPtrAR(@th^.th_RK, dirpart), ACCESS_READ);
		if l <> NULL then begin
			if arg.arg_InfoODC then begin
				if WorkBenchBase^.lib_Version >= MININFOVER then
					n := WBInfo(l, CStrConstPtrAR(@th^.th_RK, name), w^.WScreen)
				else
					DisplayBeep(NIL);
			End;
				
			if arg.arg_ShowODC then begin
				ExecASynch(finalname)
			End;
			
			UnLock(l);
		End else
			DisplayBeep(NIL);
		
	End else
		DisplayBeep(NIL);
			
	{ attach list }
	t[0] := GTLV_Labels;
	t[1] := LONG(th^.th_List);
	t[2] := TAG_END;
	GT_SetGadgetAttrsA(g[G_LV], w, NIL, @t);
	
	EnableWindow(w, Key);
End;
	


Procedure HandleGadget(w : pWindow; gadcode : pGadget; num : LONG);

Var
	node : pmn;
	n : Integer;
	
Begin       
	Case gadcode^.GadgetID Of 
		G_DIR : NewTree(w, G[G_LV]);
		G_LV  : begin
			node := pmn(th^.th_List^.lh_Head);
			For n := 1 to num do begin
				node := node^.ln_Succ;
			End;
			cnode := node;
			If cnode^.ln_Succ <> NIL Then 
			
			If DoubleClick(oldsecs, oldmics, secs, mics) then begin
				HandleLV(w, node);
				oldsecs := 0;
				oldmics := 0;
			End else begin
				oldsecs := secs;
				oldmics := mics;
			End;
		End;
	End;
End;


Procedure RefreshTheWindow(w : pWindow);

begin
	GT_BeginRefresh(w);
	GT_EndRefresh(w, True);
end;

Procedure HandleAppWin(VAR args : pWBArg; g : pGadget; w : pWindow);

Var
	t : Array[0..2] of LONG;
	key : pWindow; 
	
Begin
	key := DisableWindow(w);
	{ detach list }
	t[0] := GTLV_Labels;
	t[1] := $FFFFFFFF;
	t[2] := TAG_END;
	GT_SetGadgetAttrsA(g, w, NIL, @t);
	
	If args^.wa_Lock <> NULL then begin
		wintitle := 'Freeing Tree...'#0;
		SetWindowTitles(w, @wintitle[1], STRPTR(-1));
		FreeTree(th);
		wintitle := 'Creating Tree...'#0;
		SetWindowTitles(w, @wintitle[1], STRPTR(-1));
		th := AllocTree(th);
		if th = NIL then Halt;
		th^.th_Loc := DupLock(args^.wa_Lock);
		If Empty then
			EnableMenuItems(w);
		CreateTree(th, True);
		cdir := FExpandLock(th^.th_Loc);
		wintitle := 'Tree for "' + cdir + '"'#0;
		SetWindowTitles(w, @wintitle[1], STRPTR(-1));
	End;
			
	{ attach list }
	t[0] := GTLV_Labels;
	t[1] := LONG(th^.th_List);
	t[2] := TAG_END;
	GT_SetGadgetAttrsA(g, w, NIL, @t);
	
	EnableWindow(w, Key);
End;


Procedure ProcessWindowEvents;

CONST
	Exitflag : Boolean = False;
	
VAR 
	message         : pIntuiMessage;
	MsgClass, sigre,
	AppMask, WinMask: LONG;
	MsgCode         : Word;
	Gadcode         : pGadget;
	am              : pAppMessage;
	ez              : pEasyStruct;

begin
	AppMask := BitMask(AppPort^.MP_SIGBIT);
	WinMask := BitMask(w^.UserPort^.MP_SIGBIT);
	While Not exitflag Do Begin
		sigre    := Wait(AppMask|WinMask);
		if ((sigre and AppMask)=AppMask) then begin
			{ message from the appwindow }
			am := pAppMessage(GetMsg(AppPort));
			while am <> NIL do begin
				If am^.am_ArgList <> NIL then begin
					HandleAppWin(am^.am_ArgList, G[G_LV], w);
				End;
				ReplyMsg(pMessage(am));
				am := pAppMessage(GetMsg(AppPort));
			End;
		End;
		
		if ((sigre and WinMask)=WinMask) then begin
			message  := GT_GetIMsg(w^.userPort);
			while message <> NIL do begin
				MsgClass := message^.Class;
				MsgCode  := message^.Code;
				GadCode  := pGadget(message^.IAddress);
				secs     := Message^.Seconds;
				mics     := Message^.Micros;	
				GT_ReplyIMsg(message);
				Case MsgClass Of
					IDCMP_CLOSEWINDOW   : ExitFlag := True;
					IDCMP_REFRESHWINDOW : RefreshTheWindow(w);
					IDCMP_MENUPICK      : HandleMenu(w, msgcode, exitflag);        
					IDCMP_GADGETUP      : HandleGadget(w, gadcode, msgcode);
					IDCMP_NEWSIZE       : HandleResize(w);
				End;
				message  := GT_GetIMsg(w^.userPort);
			End;
		end;
	End; {while}
end;