Procedure RexxEDWin;
 
CONST
	NI = 0; CC = 1; G_CMD1 = 2; G_CMD2 = 3; G_CMD3 = 4; 
	G_PORT1 = 5; G_PORT2 = 6; G_PORT3 = 7; 
	G_OK = 8;  G_AREXX = 9; G_CAN = 10;
 
VAR 
	T            : Array[0..13] of tTagItem;
	GadFlags     : tNewGadget;
	G            : Array[NI..G_CAN] of pGadget;
	dummy        : LONG;
	ExitFlag, OK : Boolean;
	disable      : Byte;
	TheWin       : pWindow;
	message      : pIntuiMessage;
	MsgClass     : LongInt;
	gadcode      : pGadget;
	StrInfo      : pStringInfo;

begin
	G[NI] := NIL;
	G[CC] := CreateContext(@g[NI]);
	If G[CC] <> NIL Then begin
    
		T[0].ti_Tag  := GTCB_Checked;
		T[0].ti_Data := ord(rexxwished); 
		T[1].ti_Tag  := GA_Disabled;
		T[1].ti_Data := False_;
		T[2].ti_Tag  := $80080044;  { GTCB_Scaled }
		T[2].ti_Data := True_;
		T[3].ti_Tag  := TAG_DONE;

		With GadFlags Do Begin
			ng_TextAttr   := @My_Font;
			ng_Width      := Sizes[S_CM_W];
			ng_LeftEdge   := Sizes[RexxWin_L]+4;
			ng_TopEdge    := Sizes[TBS] + 4;
			ng_Height     := Sizes[S_GAD_H];
			ng_GadgetText := CStrConstPtrAR(@RememberKey, 'Send ARexx commands');
			ng_GadgetID   := G_AREXX;
			ng_VisualInfo := vi;
			ng_Flags      := PLACETEXT_LEFT;
		End;
		G[G_AREXX] := CreateGadgetA(CHECKBOX_KIND, G[CC], @GadFlags, @T);
  
		T[0].ti_Tag  := GA_Disabled;
		T[0].ti_Data := False_;
		T[1].ti_Tag  := GT_UnderScore;
		T[1].ti_Data := LONG('_');
		T[2].ti_Tag  := GTST_MaxChars;
		T[2].ti_Data := 180;
		T[3].ti_Tag  := GTST_String;
		T[3].ti_Data := LONG(CStrConstPtrAR(@RememberKey, Cmd1));
		T[4].ti_Tag  := TAG_DONE;
		With GadFlags Do Begin
			ng_Width      := Sizes[S_G2_W];
			ng_TopEdge    := ng_TopEdge + ng_Height + 1;
			ng_GadgetText := CStrConstPtrAR(@RememberKey, 'Initial ARexx command');
			ng_GadgetID   := G_CMD1;
		End;
		G[G_CMD1] := CreateGadgetA(STRING_KIND, G[G_AREXX], @GadFlags, @T);

		T[2].ti_Data := 24;
		T[3].ti_Data := LONG(CStrConstPtrAR(@RememberKey, RexxPort1));
		With GadFlags Do Begin
			ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 1;
			ng_GadgetText := CStrConstPtrAR(@RememberKey, 'Initial ARexx Port');
			ng_GadgetID   := G_PORT1;
		End;
		G[G_PORT1] := CreateGadgetA(STRING_KIND, G[G_CMD1], @GadFlags, @T);
 
 		T[2].ti_Data := 180;
		T[3].ti_Data := LONG(CStrConstPtrAR(@RememberKey, Cmd3));
		With GadFlags Do Begin
			ng_TopEdge    := ng_TopEdge + ng_Height + 1;
			ng_GadgetText := CStrConstPtrAR(@RememberKey, 'Precmd ARexx command');
			ng_GadgetID   := G_CMD3;
		End;
		G[G_CMD3] := CreateGadgetA(STRING_KIND, G[G_PORT1], @GadFlags, @T);

		T[2].ti_Data := 24;
		T[3].ti_Data := LONG(CStrConstPtrAR(@RememberKey, RexxPort3));
		With GadFlags Do Begin
			ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 1;
			ng_GadgetText := CStrConstPtrAR(@RememberKey, 'Precmd ARexx Port');
			ng_GadgetID   := G_PORT3;
		End;
		G[G_PORT3] := CreateGadgetA(STRING_KIND, G[G_CMD3], @GadFlags, @T);
		
		T[2].ti_Data := 180;
		T[3].ti_Data := LONG(CStrConstPtrAR(@RememberKey, Cmd2));
		With GadFlags Do Begin
			ng_TopEdge    := ng_TopEdge + ng_Height + 1;
			ng_GadgetText := CStrConstPtrAR(@RememberKey, 'Exit ARexx command');
			ng_GadgetID   := G_CMD2;
		End;
		G[G_CMD2] := CreateGadgetA(STRING_KIND, G[G_PORT3], @GadFlags, @T);

		T[2].ti_Data := 24;
		T[3].ti_Data := LONG(CStrConstPtrAR(@RememberKey, RexxPort2));
		With GadFlags Do Begin
			ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H] + 1;
			ng_GadgetText := CStrConstPtrAR(@RememberKey, 'Exit ARexx Port');
			ng_GadgetID   := G_PORT2;
		End;
		G[G_PORT2] := CreateGadgetA(STRING_KIND, G[G_CMD2], @GadFlags, @T);
		
		T[0].ti_Tag := TAG_END;
		With GadFlags Do Begin
			ng_LeftEdge   := Sizes[S_WB_L]+8;
			ng_Width      := (Sizes[S_G2_W] div 3);
			ng_TopEdge    := ng_TopEdge + Sizes[S_GAD_H] + 8;
			ng_Height     := Sizes[S_GAD_H];
			ng_GadgetText := CStrConstPtrAR(@RememberKey, 'Ok');
			ng_GadgetID   := G_OK;
			ng_Flags      := 0;
		End;
		G[G_OK] := CreateGadgetA(BUTTON_KIND, G[G_PORT2], @GadFlags, @T);
 
		With GadFlags Do Begin
			ng_LeftEdge   := Sizes[RexxWin_L] + Sizes[S_G2_W]+4-ng_Width; 
			ng_GadgetText := CStrConstPtrAR(@RememberKey, 'Cancel');
			ng_GadgetID   := G_CAN;
		End;
		G[G_CAN] := CreateGadgetA(BUTTON_KIND, G[G_OK], @GadFlags, @T);
     
		T[0].ti_Tag  := WA_Left;
		T[0].ti_Data := Left;
		T[1].ti_Tag  := WA_Top;
		T[1].ti_Data := Top;
		T[2].ti_Tag  := WA_InnerWidth;
		T[2].ti_Data := Sizes[RexxWin_L] + Sizes[S_G2_W]+8;
		T[3].ti_Tag  := WA_Height;
		T[3].ti_Data := g[G_CAN]^.TopEdge + g[G_CAN]^.Height + Sizes[S_WB_B] + 4;
		T[4].ti_Tag  := WA_Title;
		T[4].ti_Data := LONG(CStrConstPtrAR(@RememberKey, 'Rexx commands')); 
		T[5].ti_Tag  := WA_IDCMP;
		T[5].ti_Data := STRINGIDCMP|BUTTONIDCMP|IDCMP_GADGETUP|CHECKBOXIDCMP|
				IDCMP_REFRESHWINDOW|IDCMP_CLOSEWINDOW;
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
			if RexxWished then 
				disable := False_
			else 
				disable := True_;
				
			DisableGadget(g[G_PORT1], TheWin, Disable);
			DisableGadget(g[G_CMD1], TheWin, Disable);
			DisableGadget(g[G_PORT2], TheWin, Disable);
			DisableGadget(g[G_CMD2], TheWin, Disable);
			DisableGadget(g[G_PORT3], TheWin, Disable);
			DisableGadget(g[G_CMD3], TheWin, Disable);

			ExitFlag := False;
			While Not exitflag Do Begin
				dummy := Wait(BitMask(TheWin^.UserPort^.MP_SIGBIT));
				message  := GT_GetIMsg(TheWin^.userPort);
				While message <> NIL do begin
					MsgClass := message^.Class;
					if MsgClass = IDCMP_GADGETUP then begin
						GadCode  := pGadget(message^.IAddress);
						StrInfo  := gadcode^.SpecialInfo;
					end;
					
					GT_ReplyIMsg(message);
					Case MsgClass Of
					
      		IDCMP_CLOSEWINDOW : ExitFlag := True;
      		
					IDCMP_REFRESHWINDOW : Begin
						GT_BeginRefresh(TheWin);
						GT_EndRefresh(TheWin, True);
					end;
                  
					IDCMP_GADGETUP : Begin
         
						Case gadcode^.GadgetID Of
            
							G_AREXX : begin
								If RexxWished then 
									RexxWished := False
								else
									RexxWished := True;
								If NOT RexxWished then
									Disable := True_
								else
									disable := False_;
									
								DisableGadget(g[G_PORT1], TheWin, Disable);
								DisableGadget(g[G_CMD1], TheWin, Disable);
								DisableGadget(g[G_PORT2], TheWin, Disable);
								DisableGadget(g[G_CMD2], TheWin, Disable);
								DisableGadget(g[G_PORT3], TheWin, Disable);
								DisableGadget(g[G_CMD3], TheWin, Disable);
							end;
							
							G_OK   : begin
								StrInfo := g[G_CMD1]^.SpecialInfo;
								Cmd1 := PtrToPas(strinfo^.Buffer);
								StrInfo := g[G_CMD2]^.SpecialInfo;
								Cmd2 := PtrToPas(strinfo^.Buffer);
								StrInfo := g[G_CMD3]^.SpecialInfo;
								Cmd3 := PtrToPas(strinfo^.Buffer);
								StrInfo := g[G_PORT1]^.SpecialInfo;
								RexxPort1 := PtrToPas(strinfo^.Buffer);
								StrInfo := g[G_PORT2]^.SpecialInfo;
								RexxPort2 := PtrToPas(strinfo^.Buffer);
								StrInfo := g[G_PORT3]^.SpecialInfo;
								RexxPort3 := PtrToPas(strinfo^.Buffer);
								ExitFlag := True;
							end;
								
							G_CAN : ExitFlag := True;
						End; (*case*)
					end;
            
				End; (*case*)
				message  := GT_GetIMsg(TheWin^.userPort);
				end;
			End; (*while*)
			CloseWindow(TheWin);
			FreeGadgets(g[NI]);
		end;
	end;
end;