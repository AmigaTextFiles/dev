Procedure PosWindow; 
 
CONST
	NI         = 0; 
	CC         = 1;
	G_TOP      = 2;
	G_LEFT     = 3;
	G_WIDTH    = 4;
	G_HEIGHT   = 5;
	G_GC       = 6;
	G_PUB      = 7;
	G_LEV      = 8;
	G_SEL      = 9;
	G_SWID     = 10;
	G_OK       = 11; 
	G_CAN      = 12;
 
VAR 
	T            : Array[0..13] of tTagItem;
	GadFlags     : tNewGadget;
	G            : Array[NI..G_CAN] of pGadget;
	dummy        : LONG;
	ExitFlag, OK : Boolean;
	TheWin       : pWindow;
	message      : pIntuiMessage;
	MsgClass, 
	MsgCode,
	gadID,
	Levord, selord, 
	tmpswid      : LONG;
	StrInfo      : pStringInfo;
	l            : Pointer;
	l2           : LONG;
	ret, cont    : Boolean;
	RK           : pRemember;
	l3           : BPTR;
	strp         : STRPTR;
	levlabs      : Array[0..5] of STRPTR;
	sellabs      : Array[0..2] of STRPTR;
	tmpdown, tmpacross, tmpscrt : LONG;
	msg          : pIPCMsg;
	port, rpyport: pMsgPort;
	bf           : tBackFill;

Procedure SetIntGads(gad : pGadget; value : LONG);

Begin
	t[0].ti_Tag  := GTIN_Number;
	t[0].ti_Data := value;
	t[1].ti_Tag  := TAG_DONE;
	GT_SetGadgetAttrsA(gad, TheWin, NIL, @t);
End;

begin
	ret := false;
	RK := NIL;
	G[NI] := NIL;
	G[CC] := CreateContext(@g[NI]);
	If G[CC] <> NIL Then begin
	
		T[0].ti_Tag  := GTIN_MaxChars;
		T[0].ti_Data := 5;
		T[1].ti_Tag  := GTIN_Number;
		T[1].ti_Data := CD.cd_LeftEdge;
		T[2].ti_Tag  := TAG_END;
		With GadFlags Do Begin
			ng_TextAttr   := @My_Font;
			ng_Width      := Sizes[S_G2_W];
			ng_LeftEdge   := ((Sizes[TxtWin_L] * 2) div 3)+4+BF_W;
			ng_TopEdge    := Sizes[TBS] + 4  + BF_H;
			ng_Height     := Sizes[S_GAD_H];
			ng_VisualInfo := vi;
			ng_GadgetText := CStrConstPtrAR(@RK, 'Left Edge');
			ng_GadgetID   := G_LEFT;
			ng_Flags      := PLACETEXT_LEFT;
		End;
		G[G_LEFT] := CreateGadgetA(INTEGER_KIND, G[CC], @GadFlags, @T);
		
		T[1].ti_Data := CD.cd_TopEdge;
		With GadFlags Do Begin
			ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 2;
			ng_GadgetText := CStrConstPtrAR(@RK, 'Top Edge');
			ng_GadgetID   := G_TOP;
		End;
		G[G_TOP] := CreateGadgetA(INTEGER_KIND, G[G_LEFT], @GadFlags, @T);
		
		T[1].ti_Data := CD.cd_Width;
		With GadFlags Do Begin
			ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 2;
			ng_GadgetText := CStrConstPtrAR(@RK, 'Width');
			ng_GadgetID   := G_WIDTH;
		End;
		G[G_WIDTH] := CreateGadgetA(INTEGER_KIND, G[G_TOP], @GadFlags, @T);
		
		T[1].ti_Data := CD.cd_Height;
		With GadFlags Do Begin
			ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 2;
			ng_GadgetText := CStrConstPtrAR(@RK, 'Height');
			ng_GadgetID   := G_HEIGHT;
		End;
		G[G_HEIGHT] := CreateGadgetA(INTEGER_KIND, G[G_WIDTH], @GadFlags, @T);
		
		With GadFlags Do Begin
			ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 2;
			ng_GadgetText := CStrConstPtrAR(@RK, 'Grab Current Position');
			ng_GadgetID   := G_GC;
			ng_Flags      := PLACETEXT_IN;
		End;
		G[G_GC] := CreateGadgetA(BUTTON_KIND, G[G_HEIGHT], @GadFlags, NIL);
		
		T[0].ti_Tag  := GTST_MaxChars;
		T[0].ti_Data := 255;
		T[1].ti_Tag  := GTST_String;
		T[1].ti_Data := LONG(CD.cd_PubScreen);
		T[2].ti_Tag  := TAG_DONE;
		With GadFlags Do Begin
			ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 2;
			ng_GadgetText := CStrConstPtrAR(@RK, 'PubScreen');
			ng_GadgetID   := G_PUB;
			ng_Flags      := PLACETEXT_LEFT;  
		End;
		G[G_PUB] := CreateGadgetA(STRING_KIND, G[G_GC], @GadFlags, @T);
		
		T[0].ti_Tag  := GTSL_Min;
		T[0].ti_Data := 0;
		T[1].ti_Tag  := GTSL_Max;
		T[1].ti_Data := 50;
		T[2].ti_Tag  := GTSL_Level;
		T[2].ti_Data := CD.cd_SWid;
		T[3].ti_Tag  := GTSL_LevelPlace;
		T[3].ti_Data := PLACETEXT_RIGHT;
		T[4].ti_Tag  := GTSL_LevelFormat;
		T[4].ti_Data := LONG(CStrConstPtrAR(@RK, '%ld'));
		T[5].ti_Tag  := GTSL_MaxLevelLen;
		T[5].ti_Data := 2;
		T[6].ti_Tag  := TAG_DONE;
		With GadFlags Do Begin
			ng_Width      := Sizes[S_G2_W] - (3*ng_TextAttr^.ta_YSize);
			ng_GadgetText := CStrConstPtrAR(@RK, 'ScrollerW');
			ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 1;
			ng_GadgetID   := G_SWID;
		End;
		G[G_SWID] := CreateGadgetA(SLIDER_KIND, G[G_PUB], @GadFlags, @T);
		tmpswid := CD.cd_SWid;


		levlabs[0] := CStrConstPtrAR(@RK, 'Float');
		levlabs[1] := CStrConstPtrAR(@RK, 'Backdrop');
		levlabs[2] := CStrConstPtrAR(@RK, 'Backmost');
		levlabs[3] := CStrConstPtrAR(@RK, 'Frontmost');
		levlabs[4] := CStrConstPtrAR(@RK, 'No Border');
		levlabs[5] := NIL;
		T[0].ti_Tag  := GTCY_Labels;
		T[0].ti_Data := LONG(@levlabs);
		T[1].ti_Tag  := GTCY_Active;
		T[1].ti_Data := CD.cd_Level;
		T[2].ti_Tag  := TAG_DONE;
		With GadFlags Do Begin
			ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 2;
			ng_Width      := Sizes[S_G2_W];
			ng_GadgetText := CStrConstPtrAR(@RK, 'Pad Type');
			ng_GadgetID   := G_LEV;
			ng_Flags      := PLACETEXT_LEFT;  
		End;
		G[G_LEV] := CreateGadgetA(CYCLE_KIND, G[G_SWID], @GadFlags, @T);
		
		sellabs[0] := CStrConstPtrAR(@RK, 'Double-Click');
		sellabs[1] := CStrConstPtrAR(@RK, 'Single-Click');
		sellabs[2] := NIL;
		T[0].ti_Tag  := GA_Disabled;
		If Reg.key_ID = UNREG then 
			t[0].ti_Data := True_
		else
			t[0].ti_Data := False_; 
		T[1].ti_Tag  := GTCY_Labels;
		T[1].ti_Data := LONG(@sellabs);
		T[2].ti_Tag  := GTCY_Active;
		T[2].ti_Data := CD.cd_Selection;
		T[3].ti_Tag  := TAG_DONE;
		With GadFlags Do Begin
			ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 2;
			ng_GadgetText := CStrConstPtrAR(@RK, 'Selection');
			ng_GadgetID   := G_SEL;  
		End;
		G[G_SEL] := CreateGadgetA(CYCLE_KIND, G[G_LEV], @GadFlags, @T);

		With GadFlags Do Begin
			ng_LeftEdge   := Sizes[S_WB_L]+8;
			ng_Width      := (Sizes[S_G2_W] div 3);
			ng_TopEdge  := ng_TopEdge + ng_Height +  8;
			ng_Height     := Sizes[S_GAD_H];
			ng_GadgetText := CStrConstPtrAR(@RK, 'Ok');
			ng_GadgetID   := G_OK;
			ng_Flags      := 0;
		End;
		G[G_OK] := CreateGadgetA(BUTTON_KIND, G[G_SEL], @GadFlags, NIL);
 
		With GadFlags Do Begin
			ng_LeftEdge   := ((Sizes[TxtWin_L] * 2) div 3) + (2*BF_W) + Sizes[S_G2_W]+4-ng_Width; 
			ng_GadgetText := CStrConstPtrAR(@RK, 'Cancel');
			ng_GadgetID   := G_CAN;
		End;
		G[G_CAN] := CreateGadgetA(BUTTON_KIND, G[G_OK], @GadFlags, NIL);
		
	     
		T[0].ti_Tag  := WA_Left;
		T[0].ti_Data := Left;
		T[1].ti_Tag  := WA_Top;
		T[1].ti_Data := Top;
		T[2].ti_Tag  := WA_InnerWidth;
		T[2].ti_Data := ((Sizes[TxtWin_L] * 2) div 3) + Sizes[S_G2_W] + 8 + (2*BF_W);
		T[3].ti_Tag  := WA_Height;
		T[3].ti_Data := g[G_CAN]^.TopEdge + g[G_CAN]^.Height + Sizes[S_WB_B] + 4;
		T[4].ti_Tag  := WA_Title;
		T[4].ti_Data := LONG(CStrConstPtrAR(@RK, 'Window Position and Preferences.')); 
		T[5].ti_Tag  := WA_IDCMP;
		T[5].ti_Data := STRINGIDCMP|BUTTONIDCMP|IDCMP_GADGETUP|IDCMP_REFRESHWINDOW
		                |IDCMP_CLOSEWINDOW|MXIDCMP|IDCMP_MOUSEMOVE|SLIDERIDCMP;
		T[6].ti_Tag  := WA_Flags;
		T[6].ti_Data := WFLG_DEPTHGADGET|WFLG_CLOSEGADGET|WFLG_ACTIVATE|
		                WFLG_SIMPLE_REFRESH|WFLG_DRAGBAR;
		T[7].ti_Tag := WA_Gadgets;
		T[7].ti_Data:= LONG(g[NI]);
		T[8].ti_Tag := TAG_DONE;
    
		TheWin := OpenWindowTaglist(NIL,@T);
		If TheWin <> NIL Then begin
			InitBackFill(bf, TheWin, Sizes[S_WB_L], Sizes[TBS], T[2].ti_Data, 
		   T[3].ti_Data-Sizes[TBS]-Sizes[S_WB_B], BF_W, BF_H, BBF_H, 2, 0, JAM1); 
		
			GT_RefreshWindow(TheWin, NIL);
			RefreshGList(g[NI], TheWIn, NIL, -1);
			
			Levord := CD.cd_Level;
			selord := CD.cd_Selection;
			 
			ExitFlag := False;
			While Not exitflag Do Begin
				dummy := Wait(BitMask(TheWin^.UserPort^.MP_SIGBIT));
				message  := GT_GetIMsg(TheWin^.userPort);
				While message <> NIL do begin
					MsgClass := message^.Class;
					Msgcode := message^.Code;
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
	          IDCMP_MOUSEMOVE : If GadID = G_SWID then
	          	tmpswid := Integer(MsgCode);
						IDCMP_GADGETUP : Begin
							Case GadID Of
								G_LEV : Levord := MsgCode;
								G_SEL : Selord := MsgCode;
								G_GC : begin
									{ if WangiPad is running get current dims. }
									Forbid;
									port := FindPort(CStrConstPtrAR(@RK, 'WangiPad_Port'));
									if port <> NIL then begin
										rpyport := CreateMsgPort;
										if rpyport <> NIL then begin
											rpyport^.mp_Node.ln_Name := CStrConstPtrAR(@RK, 'Wangi_Prefs_Port');
											rpyport^.mp_Node.ln_Pri := 100;
											AddPort(rpyport);
											
											msg := AllocVec(Sizeof(tIPCMsg), MEMF_CLEAR);
											if msg <> NIL then begin
												msg^.ipc_Type := IPC_REQUESTSIZES;
												msg^.ipc_Msg.mn_Length := Sizeof(tIPCMsg);
												
												PutMsg(port, pMessage(msg));
												
												msg := pIPCMsg(WaitPort(rpyport));
												while msg = NIL do 
													msg := pIPCMsg(WaitPort(rpyport));
												msg := pIPCMsg(GetMsg(rpyport));
												Permit;
												
												{ set gadget attrs }
												SetIntGads(G[G_LEFT], msg^.ipc_Left);
												SetIntGads(G[G_TOP], msg^.ipc_Top);
												SetIntGads(G[G_WIDTH], msg^.ipc_Width);
												SetIntGads(G[G_HEIGHT], msg^.ipc_Height);
												FreeVec(msg);
											End;
											RemPort(rpyport);
											DeleteMsgPort(rpyport);
										End;
									End else
										Permit;
								End;
								
								G_OK : begin			
									StrInfo := g[G_LEFT]^.SpecialInfo;
									CD.cd_LeftEdge := StrInfo^.LongInt_;
									
									StrInfo := g[G_TOP]^.SpecialInfo;
									CD.cd_TopEdge := StrInfo^.LongInt_;
									
									StrInfo := g[G_WIDTH]^.SpecialInfo;
									CD.cd_Width := StrInfo^.LongInt_;
									
									StrInfo := g[G_HEIGHT]^.SpecialInfo;
									CD.cd_Height := StrInfo^.LongInt_;
																		
									StrInfo := g[G_PUB]^.SpecialInfo;
									CD.cd_PubScreen := CStrConstPtrAR(@RememberKey, PtrToPas(strinfo^.Buffer));
									
									CD.cd_SWid := tmpswid;
									
									CD.cd_Level := levord;
									
									CD.cd_Selection := selord;
									
									ExitFlag := True;
									ret := True;
								end;
				
								G_CAN : ExitFlag := True;
							End;
						end;
					End;
					message  := GT_GetIMsg(TheWin^.userPort);
				End;
			End;
			FreeBackFill(bf);
			CloseWindow(TheWin);
			FreeGadgets(g[NI]);
		end;
	end;
	FreeRemember(@RK, true);
end;