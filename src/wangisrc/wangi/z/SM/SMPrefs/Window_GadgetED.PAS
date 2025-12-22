Function GadEDWindow; 
 
CONST
	NI         = 0; 
	CC         = 1;
	G_TXT      = 2; 
	G_CMDD     = 3; 
	G_CMDF     = 4; 
	G_CMDREQ   = 5; 
	G_KEY      = 6; 
	G_STACK    = 7; 
	G_PRIORITY = 8; 
	G_RCMD     = 9; 
	G_RPORT    = 10; 
	G_SYNCH    = 11;
	G_OUT      = 12; 
	G_QUIT     = 13;
	G_SHELL    = 14;
	G_SHELLT   = 15;
	G_SHELLW   = 16;
	G_OK       = 17; 
	G_CAN      = 18;
 
VAR 
	T            : Array[0..13] of tTagItem;
	CmdFile, CmdDir, Key : String;
	GadFlags     : tNewGadget;
	G            : Array[NI..G_CAN] of pGadget;
	cr           : pFileRequester;
	dummy        : LONG;
	ExitFlag, OK, cont : Boolean;
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

begin
	cr := NIL;
	ret := false;
	Key := node^.LSK_Key;
	RK := NIL;
	G[NI] := NIL;
	G[CC] := CreateContext(@g[NI]);
	If G[CC] <> NIL Then begin

	T[0].ti_Tag  := GA_Disabled;
	T[0].ti_Data := False_;
	T[1].ti_Tag  := GT_UnderScore;
	T[1].ti_Data := LONG('_');
	T[2].ti_Tag  := GTST_MaxChars;
	T[2].ti_Data := 31;
	T[3].ti_Tag  := GTST_String;
	T[3].ti_Data := LONG(CStrConstPtrAR(@RK, node^.LSK_Name));
	T[4].ti_Tag  := TAG_DONE;
	With GadFlags Do Begin
		ng_TextAttr   := @My_Font;
		ng_Width      := Sizes[S_G2_W] div 2;
		ng_LeftEdge   := Sizes[TxtWin_L]+4;
		ng_TopEdge    := Sizes[TBS] + 4;
		ng_Height     := Sizes[S_GAD_H];
		ng_GadgetText := CStrConstPtrAR(@RK, 'Gadget Text');
		ng_GadgetID   := G_TXT;
		ng_VisualInfo := vi;
		ng_Flags      := 0;
	End;
	G[G_TXT] := CreateGadgetA(STRING_KIND, G[CC], @GadFlags, @T);

	T[2].ti_Tag  := GTST_MaxChars;
	T[2].ti_Data := 1;
	T[3].ti_Tag  := GTST_String;
	T[3].ti_Data := LONG(CStrConstPtrAR(@RK, Key));
	T[4].ti_Tag  := TAG_DONE;
	With GadFlags Do Begin
		ng_Width      := Sizes[S_G2_W] div 6;
		ng_LeftEdge   := Sizes[TxtWin_L]+Sizes[S_G2_W]-(ng_Width)+4;
		ng_GadgetText := CStrConstPtrAR(@RK, 'Key');
		ng_GadgetID   := G_KEY;
	End;
	G[G_KEY] := CreateGadgetA(STRING_KIND, G[G_TXT], @GadFlags, @T);

	T[2].ti_Data := 180;
	T[3].ti_Data := LONG(CStrConstPtrAR(@RK, node^.LSK_Cmd[0]));
	With GadFlags Do Begin
	ng_LeftEdge   := Sizes[TxtWin_L]+4;
	ng_Width      := Sizes[S_G2_W];
	ng_TopEdge    := ng_TopEdge + ng_Height + 1;
	ng_GadgetText := CStrConstPtrAR(@RK, 'Directory');
	ng_GadgetID   := G_CMDD;
	End;
	G[G_CMDD] := CreateGadgetA(STRING_KIND, G[G_KEY], @GadFlags, @T);

	T[3].ti_Data := LONG(CStrConstPtrAR(@RK, node^.LSK_Cmd[1]));
	With GadFlags Do Begin
		ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 1;
		ng_GadgetText := CStrConstPtrAR(@RK, 'Command');
		ng_GadgetID   := G_CMDF;
		ng_Width      := Sizes[S_G2_W]-(Sizes[TBS]*2);
	End;
	G[G_CMDF] := CreateGadgetA(STRING_KIND, G[G_CMDD], @GadFlags, @T);

	T[2].ti_Tag := TAG_END;
	With GadFlags Do Begin
		ng_LeftEdge   := ng_LeftEdge+ng_Width;
		ng_Width      := Sizes[TBS]*2;
		ng_GadgetText := CStrConstPtrAR(@RK, '^');
		ng_GadgetID   := G_CMDREQ;
	End;
	G[G_CMDREQ] := CreateGadgetA(BUTTON_KIND, G[G_CMDF], @GadFlags, @T);

	T[2].ti_Tag  := GTCB_Checked;
	T[2].ti_Data := ord(node^.LSK_ASynch);
	T[3].ti_Tag  := $80080044;  { GTCB_Scaled }
	T[3].ti_Data := True_;
	T[4].ti_Tag  := TAG_END;
	With GadFlags Do Begin
		ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 1;
		ng_LeftEdge   := Sizes[TxtWin_L]+4;
		ng_GadgetText := CStrConstPtrAR(@RK, 'Asynchronous');
		ng_Width      := Sizes[S_CM_W];
		ng_GadgetID   := G_SYNCH;
	End;
	G[G_SYNCH] := CreateGadgetA(CHECKBOX_KIND, G[G_CMDREQ], @GadFlags, @T);
	
	T[2].ti_Data := ord(Node^.LSK_Quit);
	With GadFlags Do Begin
		ng_LeftEdge   := Sizes[S_G2_W]+ng_LeftEdge-ng_Width;
		ng_GadgetText := CStrConstPtrAR(@RK, 'Quit After');
	End;
	G[G_QUIT] := CreateGadgetA(CHECKBOX_KIND, G[G_SYNCH], @GadFlags, @T);

	T[2].ti_Tag  := GTIN_MaxChars;
	T[2].ti_Data := 4;
	T[3].ti_Tag  := GTIN_Number;
	T[3].ti_Data := node^.LSK_Priority;
	With GadFlags Do Begin
		ng_LeftEdge   := Sizes[TxtWin_L]+4;
		ng_Width      := Sizes[S_G2_W] div 4;
		ng_GadgetText := CStrConstPtrAR(@RK, 'Priority');
		ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 1;
		ng_GadgetID   := G_PRIORITY;
	End;
	G[G_PRIORITY] := CreateGadgetA(INTEGER_KIND, G[G_QUIT], @GadFlags, @T);
 
	T[2].ti_Data := 8;
	T[3].ti_Data := node^.LSK_Stack;
	With GadFlags Do Begin
		ng_Width      := Sizes[S_G2_W] div 3;
		ng_LeftEdge   := ng_LeftEdge + Sizes[S_G2_W] - ng_Width;
		ng_GadgetText := CStrConstPtrAR(@RK, 'Stack');
		ng_GadgetID   := G_STACK;
	End;
	G[G_STACK] := CreateGadgetA(INTEGER_KIND, G[G_PRIORITY], @GadFlags, @T);

	T[2].ti_Tag  := GTST_MaxChars;
	T[2].ti_Data := 180;
	T[3].ti_Tag  := GTST_String;
	T[3].ti_Data := LONG(CStrConstPtrAR(@RK, node^.LSK_Output));
	T[4].ti_Tag  := TAG_DONE;
	With GadFlags Do Begin
		ng_LeftEdge   := Sizes[TxtWin_L]+4;
		ng_Width      := Sizes[S_G2_W];
		ng_GadgetText := CStrConstPtrAR(@RK, 'Input/Output');
		ng_GadgetID   := G_OUT;
		ng_Flags      := PLACETEXT_LEFT;
		ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 1;
	End;
	G[G_OUT] := CreateGadgetA(STRING_KIND, G[G_STACK], @GadFlags, @T);

	if Rexxwished then
		T[0].ti_Data := false_
	else
		T[0].ti_Data := true_;
	T[3].ti_Data := LONG(CStrConstPtrAR(@RK, node^.LSK_RexxCmd));
	With GadFlags Do Begin
		ng_GadgetText := CStrConstPtrAR(@RK, 'ARexx Command');
		ng_GadgetID   := G_RCMD;
		ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 1;
	End;
	G[G_RCMD] := CreateGadgetA(STRING_KIND, G[G_OUT], @GadFlags, @T);
    
	T[2].ti_Data := 25;
	T[3].ti_Data := LONG(CStrConstPtrAR(@RK, node^.LSK_RexxPort));
	With GadFlags Do Begin
		ng_GadgetText := CStrConstPtrAR(@RK, 'ARexx Port');
		ng_GadgetID   := G_RPORT;
		ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 1;
	End;
	G[G_RPORT] := CreateGadgetA(STRING_KIND, G[G_RCMD], @GadFlags, @T);

	T[0].ti_Data := false_;
	T[2].ti_Tag  := GTCB_Checked;
	T[2].ti_Data := ord(Node^.LSK_NewShell);
	T[3].ti_Tag  := $80080044;  { GTCB_Scaled }
	T[3].ti_Data := True_;
	T[4].ti_Tag  := TAG_END;
	With GadFlags Do Begin
		ng_GadgetText := CStrConstPtrAR(@RK, 'New Shell');
		ng_Width      := Sizes[S_CM_W];
		ng_Flags      := PLACETEXT_LEFT;
		ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 1;
	End;
	G[G_SHELL] := CreateGadgetA(CHECKBOX_KIND, G[G_RPORT], @GadFlags, @T);
	
	T[2].ti_Tag  := GTST_MaxChars;
	T[2].ti_Data := 80;
	T[3].ti_Tag  := GTST_String;
	T[3].ti_Data := LONG(CStrConstPtrAR(@RK, node^.LSK_ShellFrom));
	T[4].ti_Tag  := TAG_DONE;
	With GadFlags Do Begin
		ng_LeftEdge   := ng_LeftEdge + ng_Width + (((Sizes[TxtWin_L] + Sizes[S_G2_W]+4-(ng_LeftEdge + ng_Width))) div 2);
		ng_Width      := (Sizes[TxtWin_L] + Sizes[S_G2_W]+4)-ng_LeftEdge;
		ng_GadgetText := CStrConstPtrAR(@RK, 'From');
	End;
	G[G_SHELLT] := CreateGadgetA(STRING_KIND, G[G_SHELL], @GadFlags, @T);
	
	T[3].ti_Data := LONG(CStrConstPtrAR(@RK, node^.LSK_ShellWin));
	With GadFlags Do Begin
		ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 1;
		ng_GadgetText := CStrConstPtrAR(@RK, 'Window');
	End;
	G[G_SHELLW] := CreateGadgetA(STRING_KIND, G[G_SHELLT], @GadFlags, @T);
	
	T[0].ti_Tag := TAG_END;
	With GadFlags Do Begin
		ng_LeftEdge   := Sizes[S_WB_L]+8;
		ng_Width      := (Sizes[S_G2_W] div 3);
		ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 8;
		ng_GadgetText := CStrConstPtrAR(@RK, 'Ok');
		ng_GadgetID   := G_OK;
		ng_Flags      := 0;
	End;
	G[G_OK] := CreateGadgetA(BUTTON_KIND, G[G_SHELLW], @GadFlags, @T);
 
	With GadFlags Do Begin
		ng_LeftEdge   := Sizes[TxtWin_L] + Sizes[S_G2_W]+4-ng_Width; 
		ng_GadgetText := CStrConstPtrAR(@RK, 'Cancel');
		ng_GadgetID   := G_CAN;
	End;
	G[G_CAN] := CreateGadgetA(BUTTON_KIND, G[G_OK], @GadFlags, @T);
	     
	T[0].ti_Tag  := WA_Left;
	T[0].ti_Data := Left;
	T[1].ti_Tag  := WA_Top;
	T[1].ti_Data := Top;
	T[2].ti_Tag  := WA_InnerWidth;
	T[2].ti_Data := Sizes[TxtWin_L] + Sizes[S_G2_W]+8;
	T[3].ti_Tag  := WA_Height;
	T[3].ti_Data := g[G_CAN]^.TopEdge + g[G_CAN]^.Height + Sizes[S_WB_B] + 4;
	T[4].ti_Tag  := WA_Title;
	T[4].ti_Data := LONG(CStrConstPtrAR(@RK, 'Edit Gadget.')); 
	T[5].ti_Tag  := WA_IDCMP;
	T[5].ti_Data := STRINGIDCMP|BUTTONIDCMP|IDCMP_GADGETUP|IDCMP_REFRESHWINDOW|IDCMP_CLOSEWINDOW;
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
		GT_RefreshWindow(TheWin, NIL);

		ExitFlag := False;
		While Not exitflag Do Begin
			dummy := Wait(BitMask(TheWin^.UserPort^.MP_SIGBIT));
			Repeat
				cont := True;
				message  := GT_GetIMsg(TheWin^.userPort);
				If message <> NIL then begin
					MsgClass := message^.Class;
					if MsgClass = IDCMP_GADGETUP then begin
						GadID := pGadget(message^.IAddress)^.GadgetID;
						StrInfo  := pGadget(message^.IAddress)^.SpecialInfo;
					end;
					GT_ReplyIMsg(message);
					Case MsgClass Of
	      
						IDCMP_REFRESHWINDOW : Begin
							GT_BeginRefresh(TheWin);
							GT_EndRefresh(TheWin, True);
						end;
	          IDCMP_CLOSEWINDOW : ExitFlag := True;
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
	
								G_OK : begin         
									StrInfo := g[G_KEY]^.SpecialInfo;
									Key := PtrToPas(strinfo^.Buffer);
									if Length(Key) >= 1 then
										node^.LSK_Key := UpCase(Key[1])
									else
										node^.LSK_Key := '';
	
									StrInfo := g[G_TXT]^.SpecialInfo;
									node^.LSK_Name := PtrToPas(strinfo^.Buffer)+#0;
	
									StrInfo := g[G_CMDD]^.SpecialInfo;
									node^.LSK_Cmd[0] := PtrToPas(strinfo^.Buffer);
	
									StrInfo := g[G_CMDF]^.SpecialInfo;
									node^.LSK_Cmd[1] := PtrToPas(strinfo^.Buffer);
	
									StrInfo := g[G_RCMD]^.SpecialInfo;
									node^.LSK_RexxCmd := PtrToPas(strinfo^.Buffer);
	
									StrInfo := g[G_RPORT]^.SpecialInfo;
									node^.LSK_RexxPort := PtrToPas(strinfo^.Buffer);
	
									StrInfo := g[G_PRIORITY]^.SpecialInfo;
									node^.LSK_priority := strinfo^.LongInt_;
	
									StrInfo := g[G_STACK]^.SpecialInfo;
									node^.LSK_stack := strinfo^.LongInt_;
	
									node^.LSK_ASynch := False;
									if G[G_SYNCH]^.Flags and GFLG_SELECTED <> 0 then 
										node^.LSK_ASynch := True;
	
									StrInfo := g[G_OUT]^.SpecialInfo;
									node^.LSK_Output := PtrToPas(strinfo^.Buffer);
	
									node^.LSK_NewShell := False;
									if G[G_SHELL]^.Flags and GFLG_SELECTED <> 0 then 
										node^.LSK_NewShell := True;
										
									StrInfo := g[G_SHELLT]^.SpecialInfo;
									node^.LSK_ShellFrom := PtrToPas(strinfo^.Buffer);
									
									StrInfo := g[G_SHELLW]^.SpecialInfo;
									node^.LSK_ShellWin := PtrToPas(strinfo^.Buffer);
									
									node^.LSK_Quit := False;
									if G[G_QUIT]^.Flags and GFLG_SELECTED <> 0 then 
										node^.LSK_Quit := True;
	
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
			CloseWindow(TheWin);
			FreeGadgets(g[NI]);
		end;
	end;
	FreeRemember(@RK, true);
	GadEDWindow := ret;
end;