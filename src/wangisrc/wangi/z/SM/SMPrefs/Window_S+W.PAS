Procedure SWWindow; 
 
CONST
	NI         = 0; 
	CC         = 1;
	G_SCR      = 6;
	G_DTS      = 2;
	G_REQ      = 3;
	G_IMMED    = 4;
	G_REP      = 5;
	G_DOWN     = 7;
	G_ACROSS   = 8;
	G_WAIT     = 9;
	G_WIT      = 10;
	G_OK       = 11; 
	G_CAN      = 12;
 
VAR 
	T            : Array[0..13] of tTagItem;
	CmdFile, CmdDir, fpart, dpart, junkis: String;
	GadFlags     : tNewGadget;
	G            : Array[NI..G_CAN] of pGadget;
	cr           : pFileRequester;
	dummy        : LONG;
	ExitFlag, OK : Boolean;
	TheWin       : pWindow;
	message      : pIntuiMessage;
	MsgClass, MsgCode     : LongInt;
	gadID        : LONG;
	StrInfo      : pStringInfo;
	l            : Pointer;
	l2           : LONG;
	ret, cont    : Boolean;
	RK           : pRemember;
	l3           : BPTR;
	strp         : STRPTR;
	Lab          : Array[0..4] of STRPTR;
	tmpdown, tmpacross, tmpscrt : LONG;

   

Procedure CheckFile(f : STRPTR);

TYPE
	ULONG = LongInt;
	UBYTE = Byte;
	
	pFrameInfo = ^tFrameInfo;
	tFrameInfo = Record
		fri_PropertyFlags : ULONG;
		fri_Resolution : Point;
		fri_RedBits : UBYTE;
		fri_GreenBits : UBYTE;
		fri_BlueBits : UBYTE;
		fri_Width : ULONG;
		fri_Height : ULONG;
		fri_Depth : ULONG;
		fri_Screen : pScreen;
		fri_ColorMap : pColorMap;
		fri_Flags : ULONG;
	End;
	
	pdtFrameBox = ^tdtFrameBox;
	tdtFrameBox = Record
		MethodID : ULONG;
		dtf_GInfo : Pointer;
		dtf_ContentsInfo : pFrameInfo;
		dtf_FrameInfo : pFrameInfo;
		dtf_SizeFrameInfo : ULONG;
		dtf_FrameFlags : ULONG;
	End;
	
VAR
	obj    : Pointer;
	modeid : LONG;
	T      : Array[0..4] of LONG;
	junk   : LONG;
	dtf    : pdtFrameBox;
	fri    : pFrameInfo;
	
CONST
	PDTA_ModeID       = $800010C8;
	DTM_FRAMEBOX = $601;
	
begin
	If DataTypesBase <> NIL then begin
		modeid := 0;
		dtf := AllocVec(Sizeof(tdtFrameBox), MEMF_CLEAR);
		if dtf <> NIL then begin
			fri := AllocVec(sizeof(tFrameInfo), MEMF_CLEAR);
			if fri <> NIL then begin
				obj := NewDTObjectA(f, NIL);
				if obj <> NIL then begin
					T[0] := PDTA_ModeID;
					T[1] := LONG(@modeid);
					T[2] := TAG_END;
					junk := GetDTAttrsA(obj, @T);
			
					dtf^.MethodID := DTM_FRAMEBOX;
					dtf^.dtf_FrameInfo := fri;
					dtf^.dtf_ContentsInfo := fri;
					dtf^.dtf_SizeFrameInfo := sizeof(tFrameInfo);
					if DoDTMethodA(obj, NIL, NIL, pMsg(dtf)) <> NULL then begin
						
						If fri^.fri_Depth <> 0 then
							CD.cd_ScrDepth := fri^.fri_Depth;
						
						If ModeID <> 0 then begin
							If ModeID <> CD.cd_ModeId then
								CD.cd_ModeId := ModeID;
						End;

						if ((fri^.fri_PropertyFlags and DIPF_IS_HAM) <> 0) then begin
							CD.cd_ModeId := CD.cd_ModeId | HAM_KEY;
						End;
						
						if ((fri^.fri_PropertyFlags and DIPF_IS_EXTRAHALFBRITE) <> 0) then begin
							CD.cd_ModeId := CD.cd_ModeId | EXTRAHALFBRITE_KEY;
						End;
						
						If fri^.fri_Width <> 0 then
							CD.cd_ScrW := fri^.fri_Width;
							
						If fri^.fri_Height <> 0 then
							CD.cd_ScrH := fri^.fri_Height;
					End;
					DisposeDTObject(obj);
				End;
				FreeVec(fri);
			End;
			FreeVec(dtf);
		end;
	end;
end;

{ check new across and if valid calculate down }
Procedure AcrossGadFunc;
	
Begin
	tmpAcross := Strinfo^.Longint_;
	if tmpAcross <= 0 then begin
		tmpAcross := 1;
		DisplayBeep(NIL);
		T[0].ti_Tag  := GTIN_Number;
		T[0].ti_Data := tmpacross;
		T[1].ti_Tag  := TAG_DONE;
		GT_SetGadgetAttrsA(g[G_ACROSS], TheWin, NIL, @T);
	end;
end;


begin
	tmpscrt := CD.cd_ScrT;
	tmpAcross := CD.cd_Across;
	cr := NIL;
	ret := false;
	RK := NIL;
	G[NI] := NIL;
	G[CC] := CreateContext(@g[NI]);
	If G[CC] <> NIL Then begin
	
	T[0].ti_Tag  := GTIN_MaxChars;
	T[0].ti_Data := 3;
	T[1].ti_Tag  := GTIN_Number;
	T[1].ti_Data := CD.cd_Across;
	T[2].ti_Tag  := TAG_END;
	With GadFlags Do Begin
		ng_TextAttr   := @My_Font;
		ng_Width      := Sizes[S_G2_W];
		ng_LeftEdge   := ((Sizes[TxtWin_L] * 2) div 3)+4;
		ng_TopEdge    := Sizes[TBS] + 4;
		ng_Height     := Sizes[S_GAD_H];
		ng_VisualInfo := vi;
		ng_GadgetText := CStrConstPtrAR(@RK, 'Across');
		ng_GadgetID   := G_ACROSS;
		ng_Flags      := PLACETEXT_LEFT;
	End;
	G[G_ACROSS] := CreateGadgetA(INTEGER_KIND, G[CC], @GadFlags, @T);
	
	T[0].ti_Tag  := GTNM_Border;
	T[0].ti_Data := True_;
	T[1].ti_Tag  := GTNM_Number;
	T[1].ti_Data := 337604; { magic number (NOT!) }
	T[2].ti_Tag  := TAG_END;
	With GadFlags Do Begin
		ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 1;
		ng_GadgetText := CStrConstPtrAR(@RK, 'Down');
		ng_GadgetID   := G_DOWN;
	End;
	G[G_DOWN] := CreateGadgetA(NUMBER_KIND, G[G_ACROSS], @GadFlags, @T);
	
	T[0].ti_Tag  := GTIN_MaxChars;
	T[0].ti_Data := 3;
	T[1].ti_Tag  := GTIN_Number;
	T[1].ti_Data := CD.cd_Wait;
	T[2].ti_Tag  := TAG_END;
	With GadFlags Do Begin
		ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 1;
		ng_GadgetText := CStrConstPtrAR(@RK, 'Wait (s)');;
		ng_GadgetID   := G_WAIT;
	End;
	G[G_WAIT] := CreateGadgetA(INTEGER_KIND, G[G_DOWN], @GadFlags, @T);
	
	T[0].ti_Tag  := GTCB_Checked;
	T[0].ti_Data := ord(CD.cd_Wit); 
	T[1].ti_Tag  := $80080044;  { GTCB_Scaled }
	T[1].ti_Data := True_;
	T[2].ti_Tag  := TAG_DONE;
	With GadFlags Do Begin
		ng_Width      := Sizes[S_CM_W];
		ng_TopEdge    := ng_TopEdge + ng_Height + 1;
		ng_GadgetText := CStrConstPtrAR(@RK, 'Phrases');
		ng_GadgetID   := G_WIT;
	End;
	G[G_WIT] := CreateGadgetA(CHECKBOX_KIND, G[G_WAIT], @GadFlags, @T);

	Lab[0] := CStrConstPtrAR(@RK, 'RAM + Time');
	Lab[1] := CStrConstPtrAR(@RK, 'Backdrop Window');
	Lab[2] := CStrConstPtrAR(@RK, 'Normal');
	Lab[3] := CStrConstPtrAR(@RK, 'Display File');
	Lab[4] := NIL;
			
	T[0].ti_Tag  := GTCY_Labels;
	T[0].ti_Data := Long(@Lab);
	T[1].ti_Tag  := GTCY_Active;
	T[1].ti_Data := CD.cd_ScrT;
	T[2].ti_Tag  := TAG_DONE;
	With GadFlags Do Begin
		ng_Width      := Sizes[S_G2_W];
		ng_LeftEdge   := ((Sizes[TxtWin_L] * 2) div 3)+4;
		ng_TopEdge    := ng_TopEdge+ng_Height+2;
		ng_Height     := Sizes[S_GAD_H];
		ng_GadgetText := CStrConstPtrAR(@RK, 'Screen');
		ng_GadgetID   := G_DTS;
		ng_GadgetID   := G_SCR;
		ng_Flags      := PLACETEXT_LEFT;
	End;
	G[G_SCR] := CreateGadgetA(CYCLE_KIND, G[G_WIT], @Gadflags, @T);
				
	T[0].ti_Tag  := GA_Disabled;
	If CD.cd_ScrT <> ST_DT then
		T[0].ti_Data := True_
	else
		T[0].ti_Data := False_;
	T[1].ti_Tag  := GTST_MaxChars;
	T[1].ti_Data := 255;
	T[2].ti_Tag  := GTST_String;
	T[2].ti_Data := LONG(CStrConstPtrAR(@RK, CD.cd_DT));
	T[3].ti_Tag  := TAG_DONE;
	With GadFlags Do Begin
		ng_LeftEdge   := ((Sizes[TxtWin_L] * 2) div 3)+4;
		ng_TopEdge    := ng_TopEdge+ng_Height+2;
		ng_Height     := Sizes[S_GAD_H];
		ng_GadgetText := CStrConstPtrAR(@RK, 'File');
		ng_GadgetID   := G_DTS;
		ng_Flags      := 0;
		ng_Width      := ng_Width-(Sizes[TBS]*2);  
	End;
	G[G_DTS] := CreateGadgetA(STRING_KIND, G[G_SCR], @GadFlags, @T);

	T[1].ti_Tag := TAG_END;
	With GadFlags Do Begin
		ng_LeftEdge   := ng_LeftEdge + ng_Width;
		ng_Width      := Sizes[TBS]*2;
		ng_GadgetText := CStrConstPtrAR(@RK, '^');
		ng_GadgetID   := G_REQ;
	End;
	G[G_REQ] := CreateGadgetA(BUTTON_KIND, G[G_DTS], @GadFlags, @T);
	
	T[1].ti_Tag  := GTCB_Checked;
	T[1].ti_Data := ord(CD.cd_DTImmed); 
	T[2].ti_Tag  := $80080044;  { GTCB_Scaled }
	T[2].ti_Data := True_;
	T[3].ti_Tag  := TAG_DONE;
	With GadFlags Do Begin
		ng_LeftEdge   := ((Sizes[TxtWin_L] * 2) div 3)+4;
		ng_Width      := Sizes[S_CM_W];
		ng_TopEdge    := ng_TopEdge + ng_Height + 1;
		ng_GadgetText := CStrConstPtrAR(@RK, 'Play Immediately');
		ng_GadgetID   := G_IMMED;
		ng_Flags      := PLACETEXT_RIGHT;
	End;
	G[G_IMMED] := CreateGadgetA(CHECKBOX_KIND, G[G_REQ], @GadFlags, @T);
	
	T[1].ti_Data := ord(CD.cd_DTRepeat); 
	With GadFlags Do Begin
		ng_TopEdge    := ng_TopEdge + ng_Height + 1;
		ng_GadgetText := CStrConstPtrAR(@RK, 'Repeat Playing');
		ng_GadgetID   := G_REP;
	End;
	G[G_REP] := CreateGadgetA(CHECKBOX_KIND, G[G_IMMED], @GadFlags, @T);

	With GadFlags Do Begin
		ng_LeftEdge   := Sizes[S_WB_L]+8;
		ng_Width      := (Sizes[S_G2_W] div 3);
		ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 8;
		ng_GadgetText := CStrConstPtrAR(@RK, 'Ok');
		ng_GadgetID   := G_OK;
		ng_Flags      := 0;
	End;
	G[G_OK] := CreateGadgetA(BUTTON_KIND, G[G_REP], @GadFlags, NIL);
 
	With GadFlags Do Begin
		ng_LeftEdge   := ((Sizes[TxtWin_L] * 2) div 3) + Sizes[S_G2_W]+4-ng_Width; 
		ng_GadgetText := CStrConstPtrAR(@RK, 'Cancel');
		ng_GadgetID   := G_CAN;
	End;
	G[G_CAN] := CreateGadgetA(BUTTON_KIND, G[G_OK], @GadFlags, NIL);
	     
	T[0].ti_Tag  := WA_Left;
	T[0].ti_Data := Left;
	T[1].ti_Tag  := WA_Top;
	T[1].ti_Data := Top;
	T[2].ti_Tag  := WA_InnerWidth;
	T[2].ti_Data := ((Sizes[TxtWin_L] * 2) div 3) + Sizes[S_G2_W]+8;
	T[3].ti_Tag  := WA_Height;
	T[3].ti_Data := g[G_CAN]^.TopEdge + g[G_CAN]^.Height + Sizes[S_WB_B] + 4;
	T[4].ti_Tag  := WA_Title;
	T[4].ti_Data := LONG(CStrConstPtrAR(@RK, 'Screen and Window.')); 
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
		tmpdown := CalcDown(CD.cd_Across, G[G_DOWN], TheWin);

		ExitFlag := False;
		While Not exitflag Do Begin
			dummy := Wait(BitMask(TheWin^.UserPort^.MP_SIGBIT));
			Repeat
				cont := True;
				message  := GT_GetIMsg(TheWin^.userPort);
				If message <> NIL then begin
					MsgClass := message^.Class;
					Msgcode := message^.Code;
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
								G_ACROSS : begin
									AcrossGadFunc;
									tmpdown := CalcDown(tmpAcross, G[G_DOWN], TheWin);
								End;
								G_SCR : begin
									tmpscrt := MsgCode;
									if tmpscrt = ST_DT then begin
										DisableGadget(g[G_DTS], TheWin, False_);
										DisableGadget(g[G_REQ], TheWin, False_);
										DisableGadget(g[G_IMMED], TheWin, False_);
										DisableGadget(g[G_REP], TheWin, False_);
									end else begin
										DisableGadget(g[G_DTS], TheWin, True_);
										DisableGadget(g[G_REQ], TheWin, True_);
										DisableGadget(g[G_IMMED], TheWin, True_);
										DisableGadget(g[G_REP], TheWin, True_);
									End;
								End;
								G_REQ  : begin
									l := pointer(rtLockWindow(TheWin));
	               
	               	StrInfo := g[G_DTS]^.SpecialInfo;
									CmdFile := PtrToPas(StrInfo^.Buffer)+#0;
									FSplit(PtrToPas(StrInfo^.Buffer),dpart,fpart,junkis);
									dpart := dpart+#0;
									fpart := fpart+junkis+#0;
	            
									T[0].ti_Tag  := ASLFR_TitleText;
									T[0].ti_Data := LONG(CStrConstPtrAR(@RK, 'Pick a file'));
									T[1].ti_Tag  := ASLFR_Window;
									T[1].ti_Data := long(TheWin);
									T[2].ti_Tag  := ASLFR_Flags1;
									T[2].ti_Data := FRF_DOPATTERNS;
									T[3].ti_Tag  := ASLFR_Flags2;
									T[3].ti_Data := FRF_REJECTICONS;
									T[4].ti_Tag  := ASLFR_InitialPattern;
									T[4].ti_Data := LONG(CStrConstPtrAR(@RK, '#?'));
									T[5].ti_Tag  := ASLFR_InitialDrawer;
									T[5].ti_Data := long(@dpart[1]);
									T[6].ti_Tag  := ASLFR_InitialFile;
									T[6].ti_Data := long(@fpart[1]);
									T[7].ti_Tag  := TAG_DONE;
	
									cr := AllocASLRequest(ASL_FileRequest, @T[0]);
	            
									if AslRequest(cr, NIL) then begin
	               
	               		l3 := Lock(STRPTR(cr^.fr_Drawer), ACCESS_READ);
	               		if l3 <> NULL then begin
	               			strp := AllocMem(255, MEMF_CLEAR);
	               			if strp <> NIL then begin
	               				if NameFromLock(l3,strp,255) then begin
	               					CmdDir := PtrToPas(strp)+#0;
													CmdFile := PtrToPas(STRPTR(cr^.fr_file))+#0;
													if AddPart(@Cmddir[1], STRPTR(cr^.fr_file), 255) then
														T[0].ti_Data := LONG(CStrConstPtrAR(@RK, PtrToPas(@Cmddir[1])))
													else
														T[0].ti_Data := LONG(CStrConstPtrAR(@RK, PtrToPas(STRPTR(cr^.fr_file))));
	
													T[0].ti_Tag  := GTST_String;
													T[1].ti_Tag  := TAG_END;
													GT_SetGadgetAttrsA(g[G_DTS], TheWin, NIL, @T);
												end;
												FreeMem_(strp,255);
											end;
										end;
									end;        
									FreeAslRequest(cr);
									rtUnLockWindow(TheWin, l);
								end;
	
								G_OK : begin	
															
									StrInfo := g[G_ACROSS]^.SpecialInfo;
									CD.cd_Across := StrInfo^.LongInt_;
									
									CD.cd_Down := CalcDown(CD.cd_Across, NIL, NIL);
									
									StrInfo := g[G_WAIT]^.SpecialInfo;
									CD.cd_Wait := StrInfo^.LongInt_;
									
									CD.cd_ScrT := tmpScrT;
									
									StrInfo := g[G_DTS]^.SpecialInfo;
									CD.cd_DT := PtrToPas(strinfo^.Buffer);
									
									CD.cd_DTImmed := False;
									if G[G_IMMED]^.Flags and GFLG_SELECTED <> 0 then 
										CD.cd_DTImmed := True;
									
									CD.cd_DTRepeat := False;
									if G[G_REP]^.Flags and GFLG_SELECTED <> 0 then 
										CD.cd_DTRepeat := True;
										
									CD.cd_Wit := False;
									if G[G_WIT]^.Flags and GFLG_SELECTED <> 0 then 
										CD.cd_Wit := True;
										
									CheckFile(strinfo^.Buffer);
	
									ExitFlag := True;
									ret := True;
								end;
				
								G_CAN : ExitFlag := True;
							End; (*case*)
						end;
					End; (*case*)
				End else cont := False;
				Until cont = False;
			End; (*while*)
			CloseWindow(TheWin);
			FreeGadgets(g[NI]);
		end;
	end;
	FreeRemember(@RK, true);
end;