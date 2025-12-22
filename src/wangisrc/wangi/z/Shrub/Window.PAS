(*
 * Shrub... HSPascal source
 *
 * ©Lee Kindness
 *
 * Window.pas
 *
 *)

{ add window to wb app. list }
Procedure AddAppWin(VAR w : pWindow);

Begin
	AppPort := CreateMsgPort;
	if AppPort <> NIL then
		aw := AddAppWindowA(0,0,w,AppPort,NIL);
End;

Procedure RemoveAppWin;

Var
	Ok : Boolean;
	m  : pMessage;
	
Begin
	if AppPort <> NIL then begin
		m := GetMsg(AppPort);
		While m <> NIL do begin
			ReplyMsg(m);
			m := GetMsg(AppPort);
		End;
	End;
	if aw <> NIL then
		Ok := RemoveAppWindow(aw);
	if AppPort <> NIL then
		DeleteMsgPort(AppPort);
End;
	
(*
 * A little routine to fill in the members of a NewMenu struct
 *
 * Cheat & use a bit of assembler to get direct access to the embedded
 * string constants
 *)
procedure nm(var mnm: tNewMenu;
	nmType: byte;
	nmLabel: string;
	nmCommKey: string;
	nmFlags: word;
	nmMutualExclude: longint;
	nmUserData: LONG); assembler;
asm
	move.l	mnm,a0						{ address of the element }
	move.b	nmType,tNewMenu.nm_Type(a0)	{ copy the type }

	move.l	nmLabel,a1					{ the address of the Pascal string }
	tst.b	(a1)+						{ check for zero length & skip length byte }
	bne		@1							{ if not zero, nothing to do }
	move.l	#NM_BARLABEL,a1				{ substitute empty strings with a bar }
@1:	move.l	a1,tNewMenu.nm_Label(a0)	{ store the C string }

	move.l	nmCommKey,a1				{ same for the CommKey }
	tst.b	(a1)+
	bne		@2
	suba.l	a1,a1						{ use nil if the empty string }
@2:	move.l	a1,tNewMenu.nm_CommKey(a0)

{ the remaining fields }
	move.w	nmFlags,tNewMenu.nm_Flags(a0)
	move.l	nmMutualExclude,tNewMenu.nm_MutualExclude(a0)
	move.l	nmUserData,tNewMenu.nm_UserData(a0)
end;


	
{ open the main window }
Function OpenTheWindow;

Var 
	T              : Array[0..17] Of tTagItem;
	screendef      : pScreen;
	TheWindow      : pWindow;
	mm             : Array[0..22] of tNewMenu;
	Flags, f_si, 
	f_wi, f_fld, 
	f_sodc, f_iodc : LONG;
   
Begin
	TheWindow := NIL;
	
	Flags := CHECKIT|MENUTOGGLE;
	if arg.arg_SaveIcons then
		f_si := Flags|CHECKED
	else
		f_si := Flags;
	if arg.arg_ShowIcons then
		f_wi := Flags|CHECKED
	else
		f_wi := Flags;
	if arg.arg_fld then
		f_fld := Flags|CHECKED
	else
		f_fld := Flags;
	if arg.arg_ShowODC then
		f_sodc := Flags|CHECKED
	else
		f_sodc := Flags;
	if arg.arg_InfoODC then
		f_iodc := Flags|CHECKED
	else
		f_iodc := Flags;
	
	nm(mm[ 0], NM_TITLE, 'Project'#0, '', 0, 0, 0);
	nm(mm[ 1], NM_ITEM , 'Directory...'#0, 'D'#0, 0, 0, M_DIR);
	nm(mm[ 2], NM_ITEM , 'Statistics...'#0, 'U'#0, NM_ITEMDISABLED, 0, M_INFO);
	nm(mm[ 3], NM_ITEM , '', '', 0, 0, 0);
	nm(mm[ 4], NM_ITEM , 'Save As...'#0, 'A'#0, NM_ITEMDISABLED, 0, M_SAVE);
	nm(mm[ 5], NM_ITEM , '', '', 0, 0, 0);
	nm(mm[ 6], NM_ITEM , 'Print'#0, 'P'#0, NM_ITEMDISABLED, 0, M_PRINT);
	nm(mm[ 7], NM_ITEM , 'About...'#0, '?'#0, 0, 0, M_ABOUT);
	nm(mm[ 8], NM_ITEM , '', '', 0, 0, 0);
	nm(mm[ 9], NM_ITEM , 'Quit'#0, 'Q'#0, 0, 0, M_QUIT);
	
	nm(mm[10], NM_TITLE, 'Item'#0, '', 0, 0, 0);
	nm(mm[11], NM_ITEM , 'Show...'#0, 'S'#0, 0, 0, M_SHOWDC);
	If IconBase^.lib_Version >= MININFOVER then
		nm(mm[12], NM_ITEM , 'Info...'#0, 'O'#0, 0, 0, M_INFODC)
	else begin
		nm(mm[12], NM_ITEM , 'Info...'#0, 'O'#0, NM_ITEMDISABLED, 0, M_INFODC);
	End;
	
	nm(mm[13], NM_TITLE, 'Search'#0, '', 0, 0, 0);
	nm(mm[14], NM_ITEM , 'Find...'#0, 'F'#0, NM_ITEMDISABLED, 0, M_FIND);
	nm(mm[15], NM_ITEM , 'Find Next'#0, 'N'#0, NM_ITEMDISABLED, 0, M_FINDNEXT);
	
	nm(mm[16], NM_TITLE, 'Settings'#0, ''#0, 0, 0, 0);
	nm(mm[17], NM_ITEM , 'Create Icons?'#0, 'I'#0, f_si, 0, M_SICO);
	nm(mm[18], NM_ITEM , 'Show Icons?'#0, 'W'#0, f_wi, 0, M_SHOW);
	nm(mm[19], NM_ITEM , 'Follow Linked Drawers'#0, 'F'#0, f_fld, 0, M_FLD);
	nm(mm[20], NM_ITEM , 'Show On Double Click'#0, 'H'#0, f_sodc, 0, M_SODC);
	If IconBase^.lib_Version >= MININFOVER then
		nm(mm[21], NM_ITEM , 'Info On Double Click'#0, 'K'#0, f_iodc, 0, M_IODC)
	else
		nm(mm[21], NM_ITEM , 'Info On Double Click'#0, 'K'#0, f_iodc|NM_ITEMDISABLED, 0, M_IODC);
	nm(mm[22], NM_END , '', '', 0, 0, 0);
	
	G[G_NI]  := NIL;
   
  if arg.arg_Pub <> '' then
		ScreenDef := LockPubScreen(CStrConstPtrAR(@grk, arg.arg_Pub))
	else
		ScreenDef := LockPubScreen(NIL);
	if Screendef = NIL then
		ScreenDef := LockPubScreen(NIL);

	{ Get visual info and create context }
	vi := GetVisualInfoA(screendef, NIL);
	If vi <> NIL Then begin
		G[G_CC] := CreateContext(@G[G_NI]);
		If G[G_CC] <> NIL Then begin
			{ Get some data from the screen }

			S[TBS]   := screendef^.WBorTop + (screendef^.Font^.ta_YSize + 1);
			with My_Font, GfxBase^.DefaultFont^, GfxBase^.DefaultFont^.tf_Message.mn_Node do begin
				ta_Name    := CStrConstPtrAR(@grk, PtrToPas(ln_Name));
				ta_YSize   := tf_YSize;
				ta_Style   := tf_Style;
				ta_Flags   := tf_Flags;
			end;
			{ open font (gfxbase.defaultfont can change before window is closed! }
			tf := OpenFont(@My_Font);
			S[S_Gad_H] := 9+screendef^.WBorTop+1;
   
			T[0].ti_Tag  := GTLV_ShowSelected;
			T[0].ti_Data := 0;
			t[1].ti_Tag  := GTLV_Labels;
			t[1].ti_Data := LONG(th^.th_List);
			T[2].ti_Tag := TAG_END;
			
			With GadgetFlags Do Begin
				ng_TextAttr   := @My_Font;
				ng_LeftEdge   := 8;
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
						 		   
			{ window structure }
			T[0].ti_Tag  := WA_Left;
			T[0].ti_Data := arg.arg_Left;
			T[1].ti_Tag  := WA_Top;
			if arg.arg_Top = -1 then
				T[1].ti_Data := S[TBS]
			else
				T[1].ti_Data := arg.arg_Top;
			T[2].ti_Tag  := WA_Width;
			T[2].ti_Data := arg.arg_Width;
			T[3].ti_Tag  := WA_Height;
			T[3].ti_Data := arg.arg_Height;
			T[4].ti_Tag  := WA_Title;
			if cdir <> '' then
				wintitle := 'Tree for "' + cdir + '"'#0
			else
				wintitle := 'Use Project/Directory... to create tree. ' + DEFTITLE + #0;
			T[4].ti_Data := LONG(@wintitle[1]);
				
			T[5].ti_Tag  := WA_IDCMP;
			T[5].ti_Data := IDCMP_REFRESHWINDOW|BUTTONIDCMP|LISTVIEWIDCMP|
			                IDCMP_MENUPICK|IDCMP_CLOSEWINDOW|IDCMP_NEWSIZE|
			                IDCMP_CHANGEWINDOW;
			T[6].ti_Tag  := WA_Flags;
			T[6].ti_Data := WFLG_CLOSEGADGET|WFLG_DRAGBAR|WFLG_DEPTHGADGET|
			                WFLG_ACTIVATE|WFLG_SIMPLE_REFRESH|WFLG_NEWLOOKMENUS|
			                WFLG_SIZEGADGET|WFLG_SIZEBBOTTOM;
			T[7].ti_Tag := WA_Gadgets;
			T[7].ti_Data:= LONG(G[G_NI]);
			T[8].ti_Tag := TAG_IGNORE;
			T[8].ti_Data:= 0;
			T[9].ti_Tag  := WA_ScreenTitle;
			
			scrtitle := DEFTITLE + #0; 
			T[9].ti_Data := LONG(@scrtitle[1]);
			
			T[10].ti_Tag := WA_MinWidth;
			T[10].ti_Data:= 130;
			T[11].ti_Tag := WA_MinHeight;
			T[11].ti_Data:= S[TBS]*8;
			T[12].ti_Tag := WA_MaxWidth;
			T[12].ti_Data:= -1;
			T[13].ti_Tag := WA_MaxHeight;
			T[13].ti_Data:= -1;
			T[14].ti_Tag := TAG_IGNORE;
			T[14].ti_Data:= 0;
			if arg.arg_Pub <> '' then begin
				T[15].ti_Tag  := WA_PubScreenName;
				T[15].ti_Data := LONG(CStrConstPtrAR(@grk, arg.arg_Pub));
				T[16].ti_Tag  := WA_PubScreenFallBack;
				T[16].ti_Data := True_;
				T[17].ti_Tag := TAG_DONE;
			End else begin
				T[15].ti_Tag := TAG_DONE;
			End;
  
			TheWindow := OpenWindowTaglist(NIL,@T);
			If TheWindow <> NIL Then begin
				menustrip := CreateMenusA(@mm, NIL);
				if menustrip <> NIL then begin
					T[0].ti_Tag  := GTMN_NewLookMenus;
					T[0].ti_Data := True_;
					T[1].ti_Tag  := TAG_END;
					if LayoutMenusA(menustrip,vi,@T) then
						OK := SetMenuStrip(TheWindow,MenuStrip);
				End;
				GT_RefreshWindow(TheWindow, NIL);
				proc := pProcess(FindTask(NIL));
				if proc <> NIL then begin
					oldwp := proc^.pr_WindowPtr;
					proc^.pr_WindowPtr := TheWindow;
				End; 
				If NOT Empty then
					EnableMenuItems(TheWindow);
			end;
		end;
	end; 
	UnlockPubScreen(NIL, ScreenDef);
	OpenTheWindow := TheWindow; 
End;

Procedure CloseTheWindow;

VAR
	m : pMessage;
	
Begin
	if proc <> NIL then begin
		proc^.pr_WindowPtr := oldwp;
	End;
	if MenuStrip <> NIL then begin
		ClearMenuStrip(w);
		FreeMenus(MenuStrip);
	end;
	m := GetMsg(w^.UserPort);
	while m <> NIL do begin
		ReplyMsg(m);
		m := GetMsg(w^.UserPort);
	End;
	CloseWindow(w);
	FreeGadgets(g[G_NI]);
	FreeVisualInfo(vi);
	CloseFont(tf);
End;