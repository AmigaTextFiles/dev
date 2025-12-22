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
	move.l	mnm,a0                                    { address of the element }
	move.b	nmType,tNewMenu.nm_Type(a0)                        { copy the type }

	move.l	nmLabel,a1                      { the address of the Pascal string }
	tst.b	(a1)+                     { check for zero length & skip length byte }
	bne		@1                                      { if not zero, nothing to do }
	move.l	#NM_BARLABEL,a1              { substitute empty strings with a bar }
@1:	move.l	a1,tNewMenu.nm_Label(a0)                    { store the C string }

	move.l	nmCommKey,a1                                { same for the CommKey }
	tst.b	(a1)+
	bne		@2
	suba.l	a1,a1                                { use nil if the empty string }
@2:	move.l	a1,tNewMenu.nm_CommKey(a0)
                                                      { the remaining fields }
	move.w	nmFlags,tNewMenu.nm_Flags(a0)
	move.l	nmMutualExclude,tNewMenu.nm_MutualExclude(a0)
	move.l	nmUserData,tNewMenu.nm_UserData(a0)
end;


Procedure InitMenus(w : pWindow);

Var
	T              : Array[0..2] Of LONG;
	mm             : Array[0..7] of tNewMenu;
   
Begin
	nm(mm[0], NM_TITLE, 'Project'#0, '', 0, 0, 0);
	nm(mm[1], NM_ITEM , 'Preferences...'#0, 'P'#0, 0, 0, M_PREF);
	nm(mm[2], NM_ITEM , 'About...'#0, '?'#0, 0, 0, M_ABOUT);
	nm(mm[3], NM_ITEM , '', '', 0, 0, 0);
	nm(mm[4], NM_ITEM , 'Hide'#0, 'H'#0, 0, 0, M_HIDE);
	nm(mm[5], NM_ITEM , '', '', 0, 0, 0);
	nm(mm[6], NM_ITEM , 'Quit'#0, 'Q'#0, 0, 0, M_QUIT);
	nm(mm[7], NM_END  , '', '', 0, 0, 0);

	menustrip := CreateMenusA(@mm, NIL);
	if menustrip <> NIL then begin
		T[0] := GTMN_NewLookMenus;
		T[1] := True_;
		T[2] := TAG_END;
		if LayoutMenusA(menustrip,vi,@T) then
			OK := SetMenuStrip(w,MenuStrip);
	End;
End;

Procedure FreeMenus(w : pWindow);

Begin
	if opened then begin
		{Writeln('* FreeMenus()');}
		ClearMenuStrip(w);
		Gadtools.FreeMenus(MenuStrip);
	End;
End;


{ add window to wb app. list }
Function AddAppWin(VAR w : pWindow) : Boolean;

Begin
	AddAppWin := False;
	AppPort := CreateMsgPort;
	if AppPort <> NIL then begin
		aw := AddAppWindowA(0,0,w,AppPort,NIL);
		{ don't check, it fails if wb not running }
		AddAppWin := True;
	End; 
End;

Procedure RemoveAppWin;

Var
	Ok : Boolean;
	m  : pMessage;
	
Begin
	if opened then begin
		{Writeln('* RemoveAppWin()');}

		if (AppPort <> NIL) then begin
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
End;

Function MakeLVGadget(prev : pGadget): pGadget;

Var
	gadgetflags : tNewGadget;
	t : Array[0..6] of LONG;
	
begin
	T[0] := GTLV_ShowSelected;
	T[1] := 0;
	t[2] := GTLV_Labels;
	t[3] := LONG(CurrentList);
	t[4] := GTLV_ScrollWidth;
	t[5] := CD.cd_SWid;
	T[6] := TAG_END;
	With GadgetFlags Do Begin
		ng_TextAttr   := @CD.cd_Font;
		ng_LeftEdge   := 8;
		ng_TopEdge    := (S[TBS]+1);
		
		If CD.cd_Level = LEV_NOBOR then begin
			ng_LeftEdge := 0;
			ng_TopEdge  := 0;
		End;
		
		If CD.cd_Level = LEV_NOBOR then
			ng_Width    := CD.cd_Width
		else
			ng_Width    := CD.cd_Width-ng_LeftEdge*2;
			 
		ng_VisualInfo := vi;
		ng_Height     := CD.cd_Height-ng_TopEdge-13;
		if GadToolsBase^.lib_Version < 39 then
			ng_Height   := ng_Height - S[TBS];
		If CD.cd_Level = LEV_BACKD then
			ng_Height   := ng_Height + 13;
			
		If CD.cd_Level = LEV_NOBOR then
			ng_Height   := CD.cd_Height + 4 - ((CD.cd_Height-4) mod ng_TextAttr^.ta_YSize);
			
		ng_GadgetText := NIL;
		ng_GadgetID   := G_LV;
		ng_Flags      := PLACETEXT_ABOVE|NG_HIGHLABEL;
	End;
	MakeLVGadget := CreateGadgetA(LISTVIEW_KIND, Prev, @Gadgetflags, @T);
	LVRows := ((GadgetFlags.ng_Height-4) div CD.cd_Font.ta_YSize);
End;

{ open the main window }
Function OpenTheWindow : pWindow;

Var 
	T              : Array[0..15] Of tTagItem;
	screendef      : pScreen;
	TheWindow      : pWindow;
   
Begin
	TheWindow := NIL;
	G[G_NI]  := NIL;
   
  if PtrToPas(CD.cd_PubScreen) <> '' then
		ScreenDef := LockPubScreen(CD.cd_PubScreen)
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
			S[S_Gad_H] := 9+screendef^.WBorTop+1;
   
			G[G_LV] := MakeLVGadget(G[G_CC]);
						 		   
			{ window structure }
			T[0].ti_Tag  := WA_Left;
			T[0].ti_Data := CD.cd_LeftEdge;
			T[1].ti_Tag  := WA_Top;
			if CD.cd_TopEdge = -1 then
				T[1].ti_Data := S[TBS]
			else
				T[1].ti_Data := CD.cd_TopEdge;
			T[2].ti_Tag  := WA_Width;
			T[2].ti_Data := CD.cd_Width;
			T[3].ti_Tag  := WA_Height;
			T[3].ti_Data := CD.cd_Height;
			If CD.cd_Level = LEV_NOBOR then
				T[3].ti_Data := G[G_LV]^.Height; 
			T[4].ti_Tag  := WA_Title;
			T[4].ti_Data := LONG(CD.cd_WinTit);
			If CD.cd_Level = LEV_NOBOR then
				T[4].ti_Tag:= TAG_IGNORE;
			T[5].ti_Tag  := WA_IDCMP;
			T[5].ti_Data := IDCMP_REFRESHWINDOW|BUTTONIDCMP|LISTVIEWIDCMP|
			                IDCMP_MENUPICK|IDCMP_CLOSEWINDOW|IDCMP_NEWSIZE|
			                IDCMP_CHANGEWINDOW|IDCMP_MENUPICK|IDCMP_VANILLAKEY;
			
			T[6].ti_Tag  := WA_Flags;
			T[6].ti_Data := WFLG_SIMPLE_REFRESH|WFLG_NEWLOOKMENUS;
			Case CD.cd_Level of
				LEV_BACKD : T[6].ti_Data := T[6].ti_Data|WFLG_CLOSEGADGET|WFLG_BACKDROP;
			  LEV_NOBOR : T[6].ti_Data := T[6].ti_Data|WFLG_BORDERLESS|WFLG_BACKDROP;
			  Else 
			  	T[6].ti_Data := T[6].ti_Data | WFLG_CLOSEGADGET|WFLG_DRAGBAR|
			                 WFLG_SIZEGADGET|WFLG_SIZEBBOTTOM|WFLG_DEPTHGADGET;
			End; 
			                
			T[7].ti_Tag := WA_Gadgets;
			T[7].ti_Data:= LONG(G[G_NI]);
			T[8].ti_Tag  := WA_ScreenTitle;
			T[8].ti_Data := LONG(CStrConstPtrAR(@prk, PtrToPas(CD.cd_ScrTit)+
			  '      Registered To : ' + Reg.key_User)); 
			T[9].ti_Tag := WA_MinWidth;
			T[9].ti_Data:= 80;
			T[10].ti_Tag := WA_MinHeight;
			T[10].ti_Data:= S[TBS]*4;
			
			T[11].ti_Tag := WA_MaxWidth;
			T[11].ti_Data:= -1;
			T[12].ti_Tag := WA_MaxHeight;
			T[12].ti_Data:= -1;
			if PtrToPas(CD.cd_PubScreen) <> '' then begin
				T[13].ti_Tag  := WA_PubScreenName;
				T[13].ti_Data := LONG(CD.cd_PubScreen);
				T[14].ti_Tag  := WA_PubScreenFallBack;
				T[14].ti_Data := True_;
				T[15].ti_Tag := TAG_DONE;
			End else begin
				T[13].ti_Tag := TAG_DONE;
			End;
  
			TheWindow := OpenWindowTaglist(NIL,@T);
			If TheWindow <> NIL Then begin
				SetAPen(TheWindow^.RPort, 1);
				SetBPen(TheWindow^.RPort, 2);
				GT_RefreshWindow(TheWindow, NIL);
				Case CD.cd_Level of
					LEV_FRONT : begin
						WindowToFront(TheWindow);
					End;
					LEV_BACKM : begin
						WindowToBack(TheWindow);
					End;
				End;
			end;
		end;
	end; 
	UnlockPubScreen(NIL, ScreenDef);
	OpenTheWindow := TheWindow; 
End;

Procedure CloseTheWindow(VAR w : pWindow);

VAR
	m : pMessage;
	
Begin
	If opened then begin
		{Writeln('* CloseTheWindow()');}

		m := GetMsg(w^.UserPort);
		while m <> NIL do begin
			ReplyMsg(m);
			m := GetMsg(w^.UserPort);
		End;
		CloseWindow(w);
		FreeGadgets(g[G_NI]);
		FreeVisualInfo(vi);
		w := NIL;
	End;
End;