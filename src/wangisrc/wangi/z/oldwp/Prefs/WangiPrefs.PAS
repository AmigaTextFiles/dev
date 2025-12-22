Program WangiPrefs;

{SF-,I-,R-,S-,V-}
{$M 4,1,2,15}

Uses 
	Exec, Intuition, utility, gadtools, graphics, DiskFont, Icon, 
	Workbench, ASL, AmigaDOS, Amiga, IFFParse, ReqTools, Input, DOS, 
	Datatypes, Modeid, BackFill, KeyFile;

{$I WangiPrefs.h }


{ Init the global CData structure, what does the C stand for?? }   
Procedure InitCD;

begin
	With CD do begin
		cd_Font.ta_Name  := CStrConstPtrAR(@RememberKey, 'topaz.font');
		cd_Font.ta_YSize := 8;
		cd_Font.ta_Style := FS_NORMAL;
		cd_Font.ta_Flags := FPF_ROMFONT;
		cd_ScrTit        := CStrConstPtrAR(@RememberKey, 'WangiPad ©Lee Kindness');
		cd_WinTit        := CStrConstPtrAR(@RememberKey, 'Pick One...');
		cd_PubScreen     := CStrConstPtrAR(@RememberKey, '');
		cd_LeftEdge      := 640;
		cd_TopEdge       := 12;
		cd_Width         := 100;
		cd_Height        := 118; 
		cd_Level         := LEV_FLOAT;
		cd_SWid          := 16;
		cd_Selection     := SEL_DOUBLE;
	End;
end;

{ close the window and free related structures }
Procedure Close_Window;

Begin
	if MenuStrip <> NIL then begin
		ClearMenuStrip(TheWindow);
		FreeMenus(MenuStrip);
	end;
	CloseWindow(TheWindow);
	FreeBackFill(bf);
	FreeGadgets(gads[G_NI]);
	FreeVisualInfo(vi);
End;

{ The main IDCMP loop }
Procedure HandleIDCMP;

Const
	exitflag : Boolean  = False; 
	small    : Boolean  = False;
	CurrentSecs : Long = 0;
	CurrentMics : Long = 0;
	NewSecs : Long = 0;
	NewMics : Long = 0;
	InfoDone : Boolean = False;
   
Var 
	dummy      : longint;
	Tags       : Array[0..8] Of tTagItem;
	message    : pIntuiMessage;
	MsgClass, osm, oss : LongInt;
	MsgCode    : Word;
	gadcode    : pGadget;
	StrInfo    : pStringInfo;
	OKRes,cont : boolean;
	i          : Longint;
	lr, sr     : pFileRequester;
	cfile, cdir: String;
	t          : array[0..1] of tTagItem;
	menunumber : Word;
	Item       : pMenuItem;
	am         : pAppMessage;
	dobj       : pDiskObject;
	ol         : BPTR;
	

Procedure InfoGadFunc; Forward;
Procedure GetTitles(GetWindow : Boolean); Forward;
Procedure TopGadFunc; Forward;
Procedure UpGadFunc; Forward;
Procedure DownGadFunc; Forward;
Procedure BottomGadFunc; Forward;
Procedure NewGadFunc; Forward;
Procedure RemoveGadFunc; Forward;
Procedure CopyGadFunc; Forward;
Procedure SaveGadFunc; Forward;
Procedure SaveAsGadFunc; Forward;
Procedure NewListFunc; Forward;
Procedure LoadGadFunc(mode : tLMode); Forward;
Procedure LVGadFunc; Forward;
Procedure FontGadFunc(Scroll : Boolean); Forward;
{$I IDCMP.PAS }

Begin
	osm := 0;
	oss := 0;
	currentnode := NIL;
	Tags[0].ti_Tag  := ASLFR_TitleText;
	Tags[0].ti_Data := LONG(CStrConstPtrAR(@RememberKey, 'Locate the prefs file'));
	Tags[1].ti_Tag  := ASLFR_InitialFile;
	Tags[1].ti_Data := LONG(CStrConstPtrAR(@RememberKey, V.arg_FilePart));
	Tags[2].ti_Tag  := ASLFR_InitialDrawer;
	Tags[2].ti_Data := long(CStrConstPtrAR(@RememberKey, V.arg_DirPart));
	Tags[3].ti_Tag  := ASLFR_Window;
	Tags[3].ti_Data := long(TheWindow);
	Tags[4].ti_Tag  := ASLFR_Flags2;
	Tags[4].ti_Data := FRF_REJECTICONS;
	Tags[5].ti_Tag  := ASLFR_Flags1;
	Tags[5].ti_Data := FRF_DOPATTERNS;
	Tags[6].ti_Tag  := ASLFR_InitialPattern;
	Tags[6].ti_Data := LONG(CStrConstPtrAR(@RememberKey, '#?.prefs'));
	Tags[7].ti_Tag  := TAG_DONE;

	lr := AllocASLRequest(ASL_FileRequest, @Tags[0]);
	
	Tags[0].ti_Tag  := ASLFR_TitleText;
	Tags[0].ti_Data := LONG(CStrConstPtrAR(@RememberKey, 'Save prefs file as'));
	Tags[1].ti_Tag  := ASLFR_InitialFile;
	Tags[1].ti_Data := LONG(CStrConstPtrAR(@RememberKey, V.arg_FilePart));
	Tags[2].ti_Tag  := ASLFR_InitialDrawer;
	Tags[2].ti_Data := long(CStrConstPtrAR(@RememberKey, V.arg_DirPart));
	Tags[3].ti_Tag  := ASLFR_Window;
	Tags[3].ti_Data := long(TheWindow);
	Tags[4].ti_Tag  := ASLFR_Flags2;
	Tags[4].ti_Data := FRF_REJECTICONS;
	Tags[4].ti_Tag  := ASLFR_Flags1;
	Tags[4].ti_Data := FRF_DOSAVEMODE;
	Tags[5].ti_Tag  := TAG_DONE;
	
	sr := AllocASLRequest(ASL_FileRequest, @Tags[0]);

	t[0].ti_Tag  := RT_Window;
	t[0].ti_Data := LONG(TheWindow);
	t[1].ti_Tag  := TAG_END;
	
	While Not exitflag Do Begin
		dummy    := Wait(BitMask(TheWindow^.UserPort^.MP_SIGBIT)|
		                 BitMask(AppPort^.MP_SIGBIT));
		                 
		If ((dummy and BitMask(AppPort^.MP_SIGBIT))=BitMask(AppPort^.MP_SIGBIT)) then begin
			{ user has droped an icon on our window, use it to create a new item }
			am := pAppMessage(GetMsg(AppPort));
			While am <> NIL do begin
				If PtrToPas(STRPTR(am^.am_ArgList^.wa_Name)) <> '' then begin
					DetachObjectList;
					tmpnode := Add_Name('');
					wl := Pointer(rtLockWindow(TheWindow));
					ol := CurrentDir(am^.am_ArgList^.wa_Lock);
					dobj := GetDiskObject(STRPTR(am^.am_ArgList^.wa_Name));
					If dobj <> NIL then begin
						{ has .info file, so it will be a "Workbench" item }
						tmpnode^.wi_Type := TYPE_WB;
						tmpnode^.wi_Stack := dobj^.do_StackSize;
						FreeDiskObject(dobj);
					End else
						tmpnode^.wi_Type := TYPE_SHELL;
					With tmpnode^ do begin
						wi_Node.ln_Name := CStrConstPtrAR(@RememberKey, PtrToPas(STRPTR(am^.am_ArgList^.wa_Name)));
						wi_Cmd[1] := wi_Node.ln_Name;
						wi_Cmd[0] := CStrConstPtrAR(@RememberKey, FExpandLock(am^.am_ArgList^.wa_Lock));
					End;
					If GadEDWindow(TheWindow^.LeftEdge+5, TheWindow^.TopEdge+Sizes[TBS], tmpnode) then begin
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
					ol := CurrentDir(ol);
					rtUnLockWindow(TheWindow, wl);
					AttachObjectList;
				End else
					DisplayBeep(NIL);
				ReplyMsg(pMessage(am));
				am := pAppMessage(GetMsg(AppPort));
			End;
		End;
		
		If ((dummy and BitMask(TheWindow^.UserPort^.MP_SIGBIT)) =
		    BitMask(TheWindow^.UserPort^.MP_SIGBIT)) then begin
			{ window event }
			message  := GT_GetIMsg(TheWindow^.userPort);
			While message <> NIL do begin
				MsgClass := message^.Class;
				MsgCode  := message^.Code;
				if MsgClass = IDCMP_GADGETUP then begin
					GadCode  := pGadget(message^.IAddress);
					StrInfo  := gadcode^.SpecialInfo;
				end;
				NewSecs  := message^.Seconds;
				NewMics  := message^.Micros;
				GT_ReplyIMsg(message);
				Case MsgClass Of
			
					IDCMP_CLOSEWINDOW : ExitFlag := True;
					
					IDCMP_REFRESHWINDOW : begin
						GT_BeginRefresh(TheWindow);
						DrawBackFill(bf, TheWindow);
						GT_EndRefresh(TheWindow, True);
						RefreshGList(gads[G_NI], TheWindow, NIL, -1);
						GT_RefreshWindow(TheWindow, NIL);
					End;
					
					IDCMP_MENUPICK : Begin
						MenuNumber := MsgCode;
						While (menunumber <> MENUNULL) and (ExitFlag = False) do begin
							Item := ItemAddress(MenuStrip, menunumber);
							Case LONG(GTMENUITEM_USERDATA(item)) of 
								MI_OPEN : LoadGadFunc(LM_LOAD);
								MI_APPE : LoadGadFunc(LM_APPEND);
								MI_SAVA : SaveAsGadFunc;
								MI_INFO : begin
									InfoDone := True;
									InfoGadFunc;
								End;
								MI_QUIT : ExitFlag := True;
								MI_RDEF : NewListFunc;
								MI_REST : begin
									DetachObjectList;
									CloseFont(CD.cd_TFont);
									OKRes := ReadConfigFile(V.arg_FileName, LM_LOAD,RememberKey);
									if OKRes then begin  
										CurrentNode := NIL;
										CurrentOrd := -1;
										currenttop := 0;
										DisableObjectGadgets(TRUE_);
									end else begin
										DisplayBeep(NIL);
										NewListFunc;
									End;
									AttachObjectList;
								End;
							end;
						menunumber := item^.NextSelect;
						end;
					end;       
					
					IDCMP_GADGETUP : Begin       
						Case gadcode^.GadgetID Of         
							G_B_TOP     : TopGadFunc;
							G_B_UP      : UpGadFunc;
							G_B_DOWN    : DownGadFunc;
							G_B_BOTTOM  : BottomGadFunc;
							G_B_SORT    : SortGadgetFunc;
							G_B_NEW     : NewGadFunc;
							G_B_REMOVE  : RemoveGadFunc;
							G_B_COPY    : CopyGadFunc;
							G_B_SAVE    : SaveGadFunc;
							G_B_CANCEL  : exitflag := True;                               
							G_LV        : LVGadFunc;
							G_C_SET     : begin
								If DoubleClick(oss, osm, NewSecs, NewMics) then begin
									if MsgCode = CurSet then begin
										Case curset of 
											C_FONT : FontGadFunc(false);
											C_STIT : GetTitles(False);
											C_WTIT : GetTitles(True);
											C_POSI : Begin
												wl := Pointer(rtLockWindow(TheWindow));
												PosWindow(TheWindow^.LeftEdge+5, TheWindow^.TopEdge+Sizes[TBS]);
												rtUnLockWindow(TheWindow, wl);
											End;
										End;
									End;
								End;
								CurSet := MsgCode;
								oss := NewSecs;
								osm := NewMics;
							End;
						End; {case}
					end;
	            
					IDCMP_VANILLAKEY : begin
						case chr(msgcode) of
							'N','n' : NewGadFunc;
							'T','t' : TopGadFunc;
							'U','u' : UpGadFunc;
							'W','w' : DownGadFunc;
							'B','b' : BottomGadFunc;
							'V','v' : RemoveGadFunc;
							'Y','y' : CopyGadFunc;
							'S','s' : SaveGadFunc;
							'C','c' : exitflag := True;
						end;
					end; 
				End; {case}
				message  := GT_GetIMsg(TheWindow^.userPort);
			End;
		End;
	End; {while}
	
	If reg.key_ID = UNREG then
		If InfoDone = False then
			InfoGadFunc; { A right bug fuck :-< eheh }
	   
	FreeAslRequest(lr);
	FreeAslRequest(sr);
End;
	
{ ===================================================================== }
	
	{ 
	 * Main Procedure 
	 }
	
Procedure main;
	
Begin
	If Open_Libs then begin
		If pExecBase(SysBase)^.LibNode.lib_Version >= 39 then 
			V39 := True
		else
			V39 := False;
			
		GetToolTypes(V);
	
		if NOT ReadConfigFile(V.arg_FileName, LM_LOAD, RememberKey) then begin
			currentlist := pList(AllocRemember(@RememberKey, sizeof(tList), MEMF_CLEAR|MEMF_PUBLIC));
			newlist(currentlist);
			InitCD;  
		end;
		CurrentNode := NIL;
	       
	  ReadKeyFile(reg, 'S:WangiPad.key');
	  
		if Open_Window then begin
			If AddAppWin(aw, TheWindow, AppPort) then begin
				HandleIDCMP;
				Close_window;
				RemoveAppWin(aw, AppPort);
			End;
			CloseFont(CD.cd_TFont);
		end;
		FreeRemember(@RememberKey, True);
	end;
	Close_Libs;
end;
	
{ ===================================================================== }  
begin
main; 
end.
{ ===================================================================== }