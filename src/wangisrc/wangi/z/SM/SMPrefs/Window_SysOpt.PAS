Procedure SysOptWin(Left, Top : Integer);
 
CONST
	NI = 0; CC = 1; G_CLK = 2; G_WILD = 3; 
	G_SHAN = 4; G_POP = 5; G_FLUSH = 6; G_LOG = 7; 
	G_OK = 8;  G_CAN = 9;
	 
VAR 
	T							: Array[0..13] of tTagItem;
	GadFlags			: tNewGadget;
	G							: Array[NI..G_CAN] of pGadget;
	dummy					: LONG;
	ExitFlag, OK	: Boolean;
	TheWin				: pWindow;
	message				: pIntuiMessage;
	MsgClass			: LongInt;
	gadcode       : pGadget;

begin
	G[NI] := NIL;
	G[CC] := CreateContext(@g[NI]);
	If G[CC] <> NIL Then begin
    
		T[0].ti_Tag  := GTCB_Checked;
		T[0].ti_Data := ord(CD.cd_NoClick);
		T[1].ti_Tag  := $80080044;  { GTCB_Scaled }
		T[1].ti_Data := True_;
		T[2].ti_Tag  := TAG_DONE;

		With GadFlags Do Begin
			ng_TextAttr   := @My_Font;
			ng_Width      := Sizes[S_CM_W];
			ng_LeftEdge   := Sizes[S_WB_L]+8;
			ng_TopEdge    := Sizes[TBS] + 4;
			ng_Height     := Sizes[S_GAD_H];
			ng_GadgetText := CStrConstPtrAR(@RememberKey, 'No drive click');
			ng_GadgetID   := G_CLK;
			ng_VisualInfo := vi;
			ng_Flags      := PLACETEXT_RIGHT;
		End;
		G[G_CLK] := CreateGadgetA(CHECKBOX_KIND, G[CC], @GadFlags, @T);
		
		T[0].ti_Data := ord(CD.cd_WildStar);
		With GadFlags Do Begin
			ng_TopEdge    := ng_TopEdge + ng_Height + 1;
			ng_GadgetText := CStrConstPtrAR(@RememberKey, 'WildStar: use * as pattern');
			ng_GadgetID   := G_WILD;
		end;
		G[G_WILD] := CreateGadgetA(CHECKBOX_KIND, G[G_CLK], @GadFlags, @T);
		
		T[0].ti_Data := ord(CD.cd_Shanghai);
		With GadFlags Do Begin
			ng_TopEdge    := ng_TopEdge + ng_Height + 1;
			ng_GadgetText := CStrConstPtrAR(@RememberKey, 'Shanghai windows to default public screen');
			ng_GadgetID   := G_SHAN;
		end;
		G[G_SHAN] := CreateGadgetA(CHECKBOX_KIND, G[G_WILD], @GadFlags, @T);
		
		T[0].ti_Data := ord(CD.cd_PopPubScr);
		With GadFlags Do Begin
			ng_TopEdge    := ng_TopEdge + ng_Height + 1;
			ng_GadgetText := CStrConstPtrAR(@RememberKey, 'Screen to front when window opens');
			ng_GadgetID   := G_POP;
		end;
		G[G_POP] := CreateGadgetA(CHECKBOX_KIND, G[G_SHAN], @GadFlags, @T);
		
		T[0].ti_Data := ord(CD.cd_Flush);
		With GadFlags Do Begin
			ng_TopEdge    := ng_TopEdge + ng_Height + 1;
			ng_GadgetText := CStrConstPtrAR(@RememberKey, 'Flush memory after quiting');
			ng_GadgetID   := G_FLUSH;
		end;
		G[G_FLUSH] := CreateGadgetA(CHECKBOX_KIND, G[G_POP], @GadFlags, @T);

		T[0].ti_Data := ord(CD.cd_LogFile);
		With GadFlags Do Begin
			ng_TopEdge    := ng_TopEdge + ng_Height + 1;
			ng_GadgetText := CStrConstPtrAR(@RememberKey, 'Logfile (S:SM_LOG)');
			ng_GadgetID   := G_LOG;
		end;
		G[G_LOG] := CreateGadgetA(CHECKBOX_KIND, G[G_FLUSH], @GadFlags, @T);

		T[0].ti_Tag := TAG_END;
		With GadFlags Do Begin
			ng_LeftEdge   := Sizes[S_WB_L]+8;
			ng_Width      := (Sizes[S_G2_W] div 3);
			ng_TopEdge    := ng_TopEdge + Sizes[S_GAD_H] + 8;
			ng_GadgetText := CStrConstPtrAR(@RememberKey, 'OK');
			ng_GadgetID   := G_OK;
			ng_Flags      := 0;
		End;
		G[G_OK] := CreateGadgetA(BUTTON_KIND, G[G_LOG], @GadFlags, @T);
	 
		With GadFlags Do Begin
			ng_LeftEdge   := Sizes[S_WB_L]+48+Sizes[SOTxt_W]-ng_Width; 
			ng_GadgetText := CStrConstPtrAR(@RememberKey, 'Cancel');
			ng_GadgetID   := G_CAN;
		End;
		G[G_CAN] := CreateGadgetA(BUTTON_KIND, G[G_OK], @GadFlags, @T);
	 
		T[0].ti_Tag  := WA_Left;
		T[0].ti_Data := Left;
		T[1].ti_Tag  := WA_Top;
		T[1].ti_Data := Top;
		T[2].ti_Tag  := WA_Width;
		T[2].ti_Data := Sizes[S_WB_L]+8+Sizes[SOTxt_W]+40+Sizes[S_WB_L]+8;
		T[3].ti_Tag  := WA_Height;
		T[3].ti_Data := g[G_CAN]^.TopEdge + g[G_CAN]^.Height + Sizes[S_WB_B] + 4;
		T[4].ti_Tag  := WA_Title;
		T[4].ti_Data := LONG(CStrConstPtrAR(@RememberKey, 'System options')); 
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
		T[11].ti_Tag := WA_Gadgets;
		T[11].ti_Data:= LONG(g[NI]);
		T[12].ti_Tag := WA_SimpleRefresh;
		T[12].ti_Data:= True_; 
		T[13].ti_Tag := TAG_DONE;
    
		TheWin := OpenWindowTaglist(NIL,@T);
		If TheWin <> NIL Then begin
			GT_RefreshWindow(TheWin, NIL);
		
			ExitFlag := False;
			While Not exitflag Do Begin
				dummy := Wait(BitMask(TheWin^.UserPort^.MP_SIGBIT));
			message  := GT_GetIMsg(TheWin^.userPort);
			while message <> NIL do begin
				MsgClass := message^.Class;
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
							G_OK   : begin
								ExitFlag := True;
								if G[G_CLK]^.Flags and GFLG_SELECTED <> 0 then 
									CD.cd_NoClick := True
								else
									CD.cd_NoClick := False;
								if G[G_WILD]^.Flags and GFLG_SELECTED <> 0 then 
									CD.cd_WildStar := True
								else
									CD.cd_WildStar := False;
								if G[G_SHAN]^.Flags and GFLG_SELECTED <> 0 then 
									CD.cd_Shanghai := True
								else
									CD.cd_Shanghai := False;
								if G[G_POP]^.Flags and GFLG_SELECTED <> 0 then 
									CD.cd_PopPubScr := True
								else
									CD.cd_PopPubScr := False;
								if G[G_FLUSH]^.Flags and GFLG_SELECTED <> 0 then 
									CD.cd_Flush := True
								else
									CD.cd_Flush := False;
								if G[G_LOG]^.Flags and GFLG_SELECTED <> 0 then 
									CD.cd_LogFile := True
								else
									CD.cd_LogFile := False;
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
end;