Procedure QualWin;
 
CONST
	NI       = 0; 
	CC       = 1; 
	G_LSHIFT = 2; 
	G_RSHIFT = 3; 
	G_CAPS   = 4;
	G_CTRL   = 5;
	G_LALT   = 6;
	G_RALT   = 7;
	G_LAMIGA = 8;
	G_RAMIGA = 9;
	G_LMB    = 10;
	G_MMB    = 11;
	G_RMB    = 12;
	G_APP    = 13;
	G_OK     = 14;  
	G_CAN    = 15;
	RKey : pRemember = NIL;
	 
VAR 
	T							: Array[0..15] of tTagItem;
	GadFlags			: tNewGadget;
	G							: Array[NI..G_CAN] of pGadget;
	dummy					: LONG;
	ExitFlag, OK	: Boolean;
	TheWin				: pWindow;
	message				: pIntuiMessage;
	MsgClass, msgcode			: LongInt;
	gadcode       : pGadget;
	Labs          : Array[G_LSHIFT..G_CAN] of STRPTR;
	quals         : Array[G_LSHIFT..G_CAN] of LONG; 
	cl            : Array[0..2] of STRPTR;
	n, tmpapp     : Integer;

begin
	tmpapp := CD.cd_App;
	{ Init labs }
	Labs[G_LSHIFT] := CStrConstPtrAR(@RKey, 'Left Shift'); 
	Labs[G_RSHIFT] := CStrConstPtrAR(@RKey, 'Right Shift'); 
	Labs[G_CAPS]   := CStrConstPtrAR(@RKey, 'Caps Lock');
	Labs[G_CTRL]   := CStrConstPtrAR(@RKey, 'Control');
	Labs[G_LALT]   := CStrConstPtrAR(@RKey, 'Left Alt');
	Labs[G_RALT]   := CStrConstPtrAR(@RKey, 'Right Alt');
	Labs[G_LAMIGA] := CStrConstPtrAR(@RKey, 'Left Amiga');
	Labs[G_RAMIGA] := CStrConstPtrAR(@RKey, 'Right Amiga');
	Labs[G_LMB]    := CStrConstPtrAR(@RKey, 'Left Mouse Button');
	Labs[G_MMB]    := CStrConstPtrAR(@RKey, 'Middle Mouse Button');
	Labs[G_RMB]    := CStrConstPtrAR(@RKey, 'Right Mouse Button');
	Labs[G_OK]     := CStrConstPtrAR(@RKey, 'Ok');  
	Labs[G_CAN]    := CStrConstPtrAR(@RKey, 'Cancel');
	
	{ init quals }
	Quals[G_LSHIFT] := IEQUALIFIER_LSHIFT;
	Quals[G_RSHIFT] := IEQUALIFIER_RSHIFT;
	Quals[G_CAPS]   := IEQUALIFIER_CAPSLOCK;
	Quals[G_CTRL]   := IEQUALIFIER_CONTROL;
	Quals[G_LALT]   := IEQUALIFIER_LALT;
	Quals[G_RALT]   := IEQUALIFIER_RALT;
	Quals[G_LAMIGA] := IEQUALIFIER_LCOMMAND;
	Quals[G_RAMIGA] := IEQUALIFIER_RCOMMAND;
	Quals[G_LMB]    := IEQUALIFIER_LEFTBUTTON;
	Quals[G_MMB]    := IEQUALIFIER_MIDBUTTON;
	Quals[G_RMB]    := IEQUALIFIER_RBUTTON;
	
	G[NI] := NIL;
	G[CC] := CreateContext(@g[NI]);
	If G[CC] <> NIL Then begin
    
		T[0].ti_Tag  := GTCB_Checked;
		T[0].ti_Data := ord(CD.cd_NoClick);
		T[1].ti_Tag  := $80080044;  { GTCB_Scaled }
		T[1].ti_Data := True_;
		T[2].ti_Tag  := TAG_DONE;

		With GadFlags Do Begin
			ng_Width      := Sizes[S_CM_W];
			ng_Height     := Sizes[S_GAD_H];
			ng_LeftEdge   := Sizes[S_WB_L]+8;
			ng_TopEdge    := (Sizes[TBS]+4);
			ng_TextAttr   := @My_Font;
			ng_VisualInfo := vi;
			ng_Flags      := PLACETEXT_RIGHT;
		End;
		
		{ make the CB gadgets }
		n := 0;
		For n := G_LSHIFT to G_RMB do begin
			If n = G_LAMIGA then begin
				With GadFlags do begin
					ng_LeftEdge := ng_LeftEdge + ng_Width+((Sizes[QTxt_W]*2) div 3);
					ng_TopEdge := (Sizes[TBS]+4);
				End;
			End;
			if CD.cd_Quals and Quals[n] <> 0 then
				T[0].ti_Data := True_
			else
				T[0].ti_Data := False_;
			With GadFlags do begin
				ng_GadgetID   := n;
				ng_GadgetText := Labs[n];
			end;
			G[n] := CreateGadgetA(CHECKBOX_KIND, G[n-1], @GadFlags, @T);
			With GadFlags do
				ng_TopEdge := ng_TopEdge+ng_Height+1;
		end;
			
		CL[0] := CStrConstPtrAR(@RKey, 'All'); 
		CL[1] := CStrConstPtrAR(@RKey, 'One');
		CL[2] := NIL;
		
		T[0].ti_Tag  := GTCY_Labels;
		T[0].ti_Data := Long(@CL);
		T[1].ti_Tag  := GTCY_Active;
		T[1].ti_Data := CD.cd_App;
		T[2].ti_Tag  := TAG_DONE;
		With GadFlags Do Begin
			ng_Width      := Sizes[S_G2_W];
			ng_LeftEdge   := Sizes[S_WB_L]+8;
			With G[G_RALT]^ do
				ng_TopEdge    := TopEdge+Height+2;
			ng_Height     := Sizes[S_GAD_H];
			ng_GadgetText := CStrConstPtrAR(@RKey, 'Applicability');
			ng_GadgetID   := G_APP;
			ng_Flags      := PLACETEXT_RIGHT;
		End;
		G[G_APP] := CreateGadgetA(CYCLE_KIND, G[G_RMB], @Gadflags, @T);
		 	
		T[0].ti_Tag := TAG_END;
		With GadFlags Do Begin
			ng_Width      := (Sizes[S_G2_W] div 3);
			ng_TopEdge    := ng_TopEdge+ng_Height+8;
			ng_GadgetText := Labs[G_OK];
			ng_GadgetID   := G_OK;
			ng_Flags      := 0;
		End;
		G[G_OK] := CreateGadgetA(BUTTON_KIND, G[G_APP], @GadFlags, @T);
	 
		With GadFlags Do Begin
			ng_LeftEdge   := G[G_LAMIGA]^.LeftEdge+G[G_LAMIGA]^.Width+Sizes[QTxt_W]-ng_Width; 
			ng_GadgetText := Labs[G_CAN];
			ng_GadgetID   := G_CAN;
		End;
		G[G_CAN] := CreateGadgetA(BUTTON_KIND, G[G_OK], @GadFlags, @T);
	 
		T[0].ti_Tag  := WA_Left;
		T[0].ti_Data := Left;
		T[1].ti_Tag  := WA_Top;
		T[1].ti_Data := Top;
		T[2].ti_Tag  := WA_Width;
		T[2].ti_Data := gadflags.ng_LeftEdge+gadflags.ng_Width+12;
		T[3].ti_Tag  := WA_Height;
		T[3].ti_Data := g[G_CAN]^.TopEdge + g[G_CAN]^.Height + Sizes[S_WB_B] + 4;
		T[4].ti_Tag  := WA_Title;
		T[4].ti_Data := LONG(CStrConstPtrAR(@RKey, 'Select qualifiers')); 
		T[5].ti_Tag  := WA_IDCMP;
		T[5].ti_Data := BUTTONIDCMP|IDCMP_GADGETUP|CHECKBOXIDCMP|
    							IDCMP_REFRESHWINDOW|IDCMP_CLOSEWINDOW;
		T[6].ti_Tag  := WA_CloseGadget;
		T[6].ti_Data := True_;
		T[7].ti_Tag  := WA_DragBar;
		T[7].ti_Data := True_;
		T[8].ti_Tag  := WA_DepthGadget;
		T[8].ti_Data := True_;
		T[9].ti_Tag  := WA_AutoAdjust;
		T[9].ti_Data := True_;
		T[10].ti_Tag := WA_Activate;
		T[10].ti_Data:= True_;
		T[12].ti_Tag := WA_Gadgets;
		T[12].ti_Data:= LONG(g[NI]);
		T[13].ti_Tag := WA_SimpleRefresh;
		T[13].ti_Data:= True_; 
		T[14].ti_Tag := TAG_DONE;
    
		TheWin := OpenWindowTaglist(NIL,@T);
		If TheWin <> NIL Then begin
			GT_RefreshWindow(TheWin, NIL);
		
			ExitFlag := False;
			While Not exitflag Do Begin
				dummy := Wait(BitMask(TheWin^.UserPort^.MP_SIGBIT));
				message  := GT_GetIMsg(TheWin^.userPort);
			While message <> NIL do begin
				MsgClass := message^.Class;
				MsgCode  := Message^.Code;
				if MsgClass = IDCMP_GADGETUP then 
					GadCode  := pGadget(message^.IAddress);
				GT_ReplyIMsg(message);
				Case MsgClass Of
      	
					IDCMP_REFRESHWINDOW : Begin
						GT_BeginRefresh(TheWin);
						GT_EndRefresh(TheWin, True);
					end;
					IDCMP_CLOSEWINDOW : ExitFlag := True;
					IDCMP_GADGETUP : Begin
						Case gadcode^.GadgetID Of
							G_APP : tmpapp := msgcode;
							G_OK   : begin
								ExitFlag := True;
								CD.cd_App := tmpApp;
								CD.cd_Quals := 0;
								for n := G_LSHIFT to G_RMB do begin
									if G[n]^.Flags and GFLG_SELECTED <> 0 then 
										CD.cd_Quals := CD.cd_Quals|Quals[n];
								end;
							end;
							G_CAN : ExitFlag := True;
						End;
					end;
				End;
				message  := GT_GetIMsg(TheWin^.userPort);
				end;
			End;
			CloseWindow(TheWin);
			FreeGadgets(g[NI]);
		end;
	end;
	FreeRemember(@RKey, true);
end;