Function GadEDWindow; 
 
CONST
	NI         = 0; 
	CC         = 1;
	G_TYPE     = 2;
	G_TXT      = 3; 
	G_CMDD     = 4; 
	G_CMDF     = 5; 
	G_CMDREQ   = 6; 
	G_STACK    = 7; 
	G_PRIORITY = 8; 
	G_RCMD     = 9; 
	G_RPORT    = 10; 
	G_OUT      = 11;
	G_KEY      = 12;
	G_TOOLS    = 13;
	G_EDITCMD  = 14;
	G_OK       = 15; 
	G_CAN      = 16;
 
VAR 
	T            : Array[0..13] of tTagItem;
	CmdFile, 
	CmdDir       : String;
	GadFlags     : tNewGadget;
	G            : Array[NI..G_CAN] of pGadget;
	dis          : Array[2..G_CAN] of LONG;
	cr           : pFileRequester;
	dummy,
	curtype,
	tmppri : LONG;
	msgcode : Word;
	ExitFlag, OK, 
	cont,
	ToolMenu,
	EditCmd      : Boolean;
	TheWin       : pWindow;
	message      : pIntuiMessage;
	MsgClass     : LongInt;
	gadID        : LONG;
	StrInfo      : pStringInfo;
	l            : Pointer;
	l2           : LONG;
	ret          : Boolean;
	RK           : pRemember;
	l3           : BPTR;
	strp         : STRPTR;
	typelabs     : Array[0..4] of STRPTR;
	bf           : tBackFill;

Procedure DisGads;

var
	n : Integer;
	
begin
	For n := 2 to G_CAN do
		dis[n] := False_; 
	Case curtype of 
		TYPE_WB : Begin
			dis[G_OUT] := True_;
			dis[G_EDITCMD] := True_;
		End;
		TYPE_AREXX : Begin
			dis[G_CMDD] := True_;
			dis[G_CMDF] := True_;
			dis[G_CMDREQ] := True_;
			dis[G_STACK] := True_;
			dis[G_PRIORITY] := True_;
			dis[G_OUT] := True_;
			dis[G_EDITCMD] := True_;
		End;
		TYPE_COMNT : Begin
			dis[G_CMDD] := True_;
			dis[G_CMDF] := True_;
			dis[G_CMDREQ] := True_;
			dis[G_STACK] := True_;
			dis[G_PRIORITY] := True_;
			dis[G_RCMD] := True_;
			dis[G_RPORT] := True_;
			dis[G_OUT] := True_;
			dis[G_KEY] := True_;
			dis[G_EDITCMD] := True_;
		End;
	End;
	If Reg.key_ID = UNREG then
		dis[G_KEY] := True_;
	For n := 2 to G_CAN do begin
		t[0].ti_Tag  := GA_Disabled;
		t[0].ti_Data := dis[n];
		t[1].ti_Tag  := TAG_DONE;
		GT_SetGadgetAttrsA(G[n], Thewin, NIL, @t);
	End;
End;



begin
	cr := NIL;
	ret := false;
	ToolMenu := ((node^.wi_Flags and WIF_TOOLMENU) = WIF_TOOLMENU);
	EditCmd := ((node^.wi_Flags and WIF_EDITCMD) = WIF_EDITCMD);

	RK := NIL;
	G[NI] := NIL;
	G[CC] := CreateContext(@g[NI]);
	If G[CC] <> NIL Then begin
	
	typelabs[0] := CStrConstPtrAR(@RK, 'Shell');
	typelabs[1] := CStrConstPtrAR(@RK, 'Workbench');
	typelabs[2] := CStrConstPtrAR(@RK, 'ARexx');
	typelabs[3] := CStrConstPtrAR(@RK, 'Comment');
	typelabs[4] := NIL;
	T[0].ti_Tag  := GTCY_Labels;
	T[0].ti_Data := LONG(@typelabs);
	T[1].ti_Tag  := GTCY_Active;
	T[1].ti_Data := node^.wi_Type;
	T[2].ti_Tag  := TAG_DONE;
	With GadFlags Do Begin
		ng_GadgetText := CStrConstPtrAR(@RK, 'Type');
		ng_GadgetID   := G_TYPE;
		ng_TextAttr   := @My_Font;
		ng_Width      := Sizes[S_G2_W];
		ng_LeftEdge   := Sizes[TxtWin_L]+ 4 + BF_W;
		ng_TopEdge    := Sizes[TBS] + 4 + BF_H;
		ng_Height     := Sizes[S_GAD_H];
		ng_VisualInfo := vi;
		ng_Flags      := 0;
	End;
	G[G_TYPE] := CreateGadgetA(CYCLE_KIND, G[CC], @GadFlags, @T);
	curtype := node^.wi_Type;
	
	T[0].ti_Tag  := GTST_MaxChars;
	T[0].ti_Data := 31;
	T[1].ti_Tag  := GTST_String;
	T[1].ti_Data := LONG(node^.wi_Node.ln_Name);
	T[2].ti_Tag  := TAG_DONE;
	With GadFlags Do Begin
		ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 1;
		ng_GadgetText := CStrConstPtrAR(@RK, 'Item Text');
		ng_GadgetID   := G_TXT;
	End;
	G[G_TXT] := CreateGadgetA(STRING_KIND, G[G_TYPE], @GadFlags, @T);

	T[0].ti_Data := 180;
	T[1].ti_Data := LONG(node^.wi_Cmd[0]);
	With GadFlags Do Begin
	ng_Width      := Sizes[S_G2_W];
	ng_TopEdge    := ng_TopEdge + ng_Height + 1;
	ng_GadgetText := CStrConstPtrAR(@RK, 'Directory');
	ng_GadgetID   := G_CMDD;
	End;
	G[G_CMDD] := CreateGadgetA(STRING_KIND, G[G_TXT], @GadFlags, @T);

	T[1].ti_Data := LONG(node^.wi_Cmd[1]);
	With GadFlags Do Begin
		ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 1;
		ng_GadgetText := CStrConstPtrAR(@RK, 'Command');
		ng_GadgetID   := G_CMDF;
		ng_Width      := Sizes[S_G2_W]-(Sizes[TBS]*2);
	End;
	G[G_CMDF] := CreateGadgetA(STRING_KIND, G[G_CMDD], @GadFlags, @T);

	T[0].ti_Tag := TAG_END;
	With GadFlags Do Begin
		ng_LeftEdge   := ng_LeftEdge+ng_Width;
		ng_Width      := Sizes[TBS]*2;
		ng_GadgetText := CStrConstPtrAR(@RK, '^');
		ng_GadgetID   := G_CMDREQ;
	End;
	G[G_CMDREQ] := CreateGadgetA(BUTTON_KIND, G[G_CMDF], @GadFlags, @T);

	T[0].ti_Tag  := GTSL_Min;
	T[0].ti_Data := -128;
	T[1].ti_Tag  := GTSL_Max;
	T[1].ti_Data := 127;
	T[2].ti_Tag  := GTSL_Level;
	T[2].ti_Data := node^.wi_Priority;
	T[3].ti_Tag  := GTSL_LevelPlace;
	T[3].ti_Data := PLACETEXT_RIGHT;
	T[4].ti_Tag  := GTSL_LevelFormat;
	T[4].ti_Data := LONG(CStrConstPtrAR(@RK, '%ld'));
	T[5].ti_Tag  := GTSL_MaxLevelLen;
	T[5].ti_Data := 4;
	T[6].ti_Tag  := TAG_DONE;
	With GadFlags Do Begin
		ng_LeftEdge   := Sizes[TxtWin_L]+4+BF_W;
		ng_Width      := Sizes[S_G2_W] div 4;
		ng_GadgetText := CStrConstPtrAR(@RK, 'Priority');
		ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 1;
		ng_GadgetID   := G_PRIORITY;
	End;
	G[G_PRIORITY] := CreateGadgetA(SLIDER_KIND, G[G_CMDREQ], @GadFlags, @T);
	tmppri := node^.wi_Priority;
 
 
	T[0].ti_Tag  := GTIN_MaxChars;
	T[0].ti_Data := 8;
	T[1].ti_Tag  := GTIN_Number;
	T[1].ti_Data := node^.wi_Stack;
	T[2].ti_Tag  := TAG_DONE;
	With GadFlags Do Begin
		ng_Width      := Sizes[S_G2_W] div 3;
		ng_LeftEdge   := ng_LeftEdge + Sizes[S_G2_W] - ng_Width;
		ng_GadgetText := CStrConstPtrAR(@RK, 'Stack');
		ng_GadgetID   := G_STACK;
	End;
	G[G_STACK] := CreateGadgetA(INTEGER_KIND, G[G_PRIORITY], @GadFlags, @T);

	T[0].ti_Tag  := GTST_MaxChars;
	T[0].ti_Data := 180;
	T[1].ti_Tag  := GTST_String;
	T[1].ti_Data := LONG(node^.wi_Output);
	T[2].ti_Tag  := TAG_DONE;
	With GadFlags Do Begin
		ng_LeftEdge   := Sizes[TxtWin_L]+4+BF_W;
		ng_Width      := Sizes[S_G2_W];
		ng_GadgetText := CStrConstPtrAR(@RK, 'Input/Output');
		ng_GadgetID   := G_OUT;
		ng_Flags      := PLACETEXT_LEFT;
		ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 1;
	End;
	G[G_OUT] := CreateGadgetA(STRING_KIND, G[G_STACK], @GadFlags, @T);

	T[1].ti_Data := LONG(node^.wi_RexxCmd);
	With GadFlags Do Begin
		ng_GadgetText := CStrConstPtrAR(@RK, 'ARexx Command');
		ng_GadgetID   := G_RCMD;
		ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 1;
	End;
	G[G_RCMD] := CreateGadgetA(STRING_KIND, G[G_OUT], @GadFlags, @T);
    
	T[0].ti_Data := 25;
	T[1].ti_Data := LONG(node^.wi_RexxPort);
	With GadFlags Do Begin
		ng_GadgetText := CStrConstPtrAR(@RK, 'ARexx Port');
		ng_GadgetID   := G_RPORT;
		ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 1;
	End;
	G[G_RPORT] := CreateGadgetA(STRING_KIND, G[G_RCMD], @GadFlags, @T);
	
	T[0].ti_Data := 80;
	T[1].ti_Data := LONG(node^.wi_HotKey);
	With GadFlags Do Begin
		ng_GadgetText := CStrConstPtrAR(@RK, 'Hot Key');
		ng_GadgetID   := G_KEY;
		ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 1;
	End;
	G[G_KEY] := CreateGadgetA(STRING_KIND, G[G_RPORT], @GadFlags, @T);
	
	T[0].ti_Tag  := GTCB_Checked;
	T[0].ti_Data := Ord(ToolMenu);
	T[1].ti_Tag  := GTCB_Scaled;
	T[1].ti_Data := True_;
	T[2].ti_Tag  := TAG_END;
	With GadFlags Do Begin
		ng_GadgetText := CStrConstPtrAR(@RK, 'Tools Menu');
		ng_GadgetID   := G_TOOLS;
		ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 1;
		ng_Width      := ng_Height*2;
		If GadToolsBase^.lib_Version < 39 then begin
			ng_Width    := CHECKBOX_WIDTH;
			ng_Height   := CHECKBOX_HEIGHT;
		End;
	End;
	G[G_TOOLS] := CreateGadgetA(CHECKBOX_KIND, G[G_KEY], @GadFlags, @T);
	
	T[0].ti_Data := Ord(EditCmd);
	With GadFlags Do Begin
		ng_GadgetText := CStrConstPtrAR(@RK, 'Edit Command');
		ng_GadgetID   := G_EDITCMD;
		ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 1;
	End;
	G[G_EDITCMD] := CreateGadgetA(CHECKBOX_KIND, G[G_TOOLS], @GadFlags, @T);
	
	T[0].ti_Tag := TAG_END;
	With GadFlags Do Begin
		ng_LeftEdge   := Sizes[S_WB_L]+8;
		ng_Width      := (Sizes[S_G2_W] div 3);
		ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 8;
		ng_GadgetText := CStrConstPtrAR(@RK, 'Ok');
		ng_GadgetID   := G_OK;
		ng_Flags      := 0;
	End;
	G[G_OK] := CreateGadgetA(BUTTON_KIND, G[G_EDITCMD], @GadFlags, @T);
 
	With GadFlags Do Begin
		ng_LeftEdge   := Sizes[TxtWin_L] + (Sizes[S_G2_W]+4+(2*BF_W))-ng_Width; 
		ng_GadgetText := CStrConstPtrAR(@RK, 'Cancel');
		ng_GadgetID   := G_CAN;
	End;
	G[G_CAN] := CreateGadgetA(BUTTON_KIND, G[G_OK], @GadFlags, @T);
	     
	T[0].ti_Tag  := WA_Left;
	T[0].ti_Data := Left;
	T[1].ti_Tag  := WA_Top;
	T[1].ti_Data := Top;
	T[2].ti_Tag  := WA_InnerWidth;
	T[2].ti_Data := Sizes[TxtWin_L] + Sizes[S_G2_W] + 8 + (2*BF_W);
	T[3].ti_Tag  := WA_Height;
	T[3].ti_Data := g[G_CAN]^.TopEdge + g[G_CAN]^.Height + Sizes[S_WB_B] + 4;
	T[4].ti_Tag  := WA_Title;
	T[4].ti_Data := LONG(CStrConstPtrAR(@RK, 'Edit Pad Item.')); 
	T[5].ti_Tag  := WA_IDCMP;
	T[5].ti_Data := STRINGIDCMP|BUTTONIDCMP|IDCMP_GADGETUP|IDCMP_REFRESHWINDOW|
	 IDCMP_CLOSEWINDOW|SLIDERIDCMP|IDCMP_MOUSEMOVE;
	T[6].ti_Tag  := WA_DragBar;
	T[6].ti_Data := True_;
	T[7].ti_Tag  := WA_DepthGadget;
	T[7].ti_Data := True_;
	T[8].ti_Tag  := WA_AutoAdjust;
	T[8].ti_Data := True_;
	T[9].ti_Tag  := WA_Activate;
	T[9].ti_Data := True_;
	T[10].ti_Tag := WA_Gadgets;
	T[10].ti_Data:= LONG(g[NI]);
	T[11].ti_Tag := WA_SimpleRefresh;
	T[11].ti_Data:= True_; 
	T[12].ti_Tag := WA_CloseGadget;
	T[12].ti_Data:= True_; 
	T[13].ti_Tag := TAG_DONE;
    
	TheWin := OpenWindowTaglist(NIL,@T);
	If TheWin <> NIL Then begin
		InitBackFill(bf, TheWin, Sizes[S_WB_L], Sizes[TBS], T[2].ti_Data, 
		   T[3].ti_Data-Sizes[TBS]-Sizes[S_WB_B], BF_W, BF_H, BBF_H, 2, 0, JAM1); 
		
		GT_RefreshWindow(TheWin, NIL);
		RefreshGList(g[NI], TheWIn, NIL, -1);
		
		DisGads;

		ExitFlag := False;
		While Not exitflag Do Begin
			dummy := Wait(BitMask(TheWin^.UserPort^.MP_SIGBIT));
			Repeat
				cont := True;
				message  := GT_GetIMsg(TheWin^.userPort);
				If message <> NIL then begin
					MsgClass := message^.Class;
					MsgCode := message^.Code;
					if (MsgClass = IDCMP_GADGETUP) or (MsgClass = IDCMP_MOUSEMOVE) then begin
						GadID := pGadget(message^.IAddress)^.GadgetID;
						StrInfo  := pGadget(message^.IAddress)^.SpecialInfo;
					end;
					GT_ReplyIMsg(message);
					Case MsgClass Of
	      
						IDCMP_REFRESHWINDOW : Begin
							GT_BeginRefresh(TheWin);
							DrawBackFill(bf, TheWin);
							GT_EndRefresh(TheWin, True);
							RefreshGList(g[NI], TheWin, NIL, -1);
							GT_RefreshWindow(TheWin, NIL);
						end;
	          IDCMP_CLOSEWINDOW : ExitFlag := True;
	          IDCMP_MOUSEMOVE : If GadID = G_PRIORITY then
	          	tmppri := Integer(MsgCode);
						IDCMP_GADGETUP : Begin
							Case GadID Of
								G_CMDREQ  : begin
									l := pointer(rtLockWindow(TheWin));
	               
									StrInfo := g[G_CMDD]^.SpecialInfo;
									CmdDir := PtrToPas(strinfo^.Buffer)+#0;
									StrInfo := g[G_CMDF]^.SpecialInfo;
									CmdFile := PtrToPas(strinfo^.Buffer)+#0;
	            
									T[0].ti_Tag  := ASLFR_TitleText;
									T[0].ti_Data := LONG(CStrConstPtrAR(@RK, 'Pick Command'));
									T[1].ti_Tag  := ASLFR_Window;
									T[1].ti_Data := long(TheWin);
									T[2].ti_Tag  := ASLFR_Flags1;
									T[2].ti_Data := 0;
									T[3].ti_Tag  := ASLFR_InitialPattern;
									T[3].ti_Data := LONG(CStrConstPtrAR(@RK, '~(#?.info)'));
									T[4].ti_Tag  := ASLFR_InitialDrawer;
									T[4].ti_Data := long(@CmdDir[1]);
									T[5].ti_Tag  := ASLFR_InitialFile;
									T[5].ti_Data := long(@CmdFile[1]);
									T[6].ti_Tag  := TAG_DONE;
	
									cr := AllocASLRequest(ASL_FileRequest, @T[0]);
	            
									if AslRequest(cr, NIL) then begin
	               
	               		l3 := Lock(STRPTR(cr^.fr_Drawer), ACCESS_READ);
	               		if l3 <> NULL then begin
	               			strp := AllocMem(180, MEMF_CLEAR);
	               			if strp <> NIL then begin
	               				if NameFromLock(l3,strp,180) then begin
	               					CmdDir := PtrToPas(strp)+#0;
													CmdFile := PtrToPas(STRPTR(cr^.fr_file))+#0;
	
													T[0].ti_Tag  := GTST_String;
													T[0].ti_Data := LONG(CStrConstPtrAR(@RK, CmdFile));
													T[1].ti_Tag  := TAG_END;
													GT_SetGadgetAttrsA(g[G_CMDF], TheWin, NIL, @T);
	
													T[0].ti_Data := LONG(CStrConstPtrAR(@RK, CmdDir));
													GT_SetGadgetAttrsA(g[G_CMDD], TheWin, NIL, @T);
												end;
												FreeMem_(strp,180);
											end;
										end;
									end;        
									FreeAslRequest(cr);
									rtUnLockWindow(TheWin, l);
								end;
								
								G_TYPE : Begin
									curtype := msgcode;
									DisGads;
								End;
	
								G_OK : begin         
									node^.wi_Type := CurType;
										
									StrInfo := g[G_TXT]^.SpecialInfo;
									node^.wi_Node.ln_Name := CStrConstPtrAR(@RememberKey, PtrToPas(strinfo^.Buffer));
	
									StrInfo := g[G_CMDD]^.SpecialInfo;
									node^.wi_Cmd[0] := CStrConstPtrAR(@RememberKey, PtrToPas(strinfo^.Buffer));
	
									StrInfo := g[G_CMDF]^.SpecialInfo;
									node^.wi_Cmd[1] := CStrConstPtrAR(@RememberKey, PtrToPas(strinfo^.Buffer));
	
									StrInfo := g[G_RCMD]^.SpecialInfo;
									node^.wi_RexxCmd := CStrConstPtrAR(@RememberKey, PtrToPas(strinfo^.Buffer));
	
									StrInfo := g[G_RPORT]^.SpecialInfo;
									node^.wi_RexxPort := CStrConstPtrAR(@RememberKey, PtrToPas(strinfo^.Buffer));
	
									node^.wi_priority := tmppri;
	
									StrInfo := g[G_STACK]^.SpecialInfo;
									node^.wi_stack := strinfo^.LongInt_;
		
									StrInfo := g[G_OUT]^.SpecialInfo;
									node^.wi_Output := CStrConstPtrAR(@RememberKey, PtrToPas(strinfo^.Buffer));
									
									StrInfo := g[G_KEY]^.SpecialInfo;
									node^.wi_HotKey := CStrConstPtrAR(@RememberKey, PtrToPas(strinfo^.Buffer));
	
									node^.wi_Flags := 0;
									if G[G_TOOLS]^.Flags and GFLG_SELECTED <> 0 then 
										node^.wi_Flags := node^.wi_Flags|WIF_TOOLMENU;
									if G[G_EDITCMD]^.Flags and GFLG_SELECTED <> 0 then 
										node^.wi_Flags := node^.wi_Flags|WIF_EDITCMD;
										
									ExitFlag := True;
									ret := True;
								end;
				
								G_CAN : ExitFlag := True;
							End; (*case*)
						end;
					End; (*case*)
				end else cont := False;
				Until cont = True;
			End; (*while*)
			FreeBackFill(bf);
			CloseWindow(TheWin);
			FreeGadgets(g[NI]);
		end;
	end;
	FreeRemember(@RK, true);
	GadEDWindow := ret;
end;