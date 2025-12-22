Procedure DisableGadget;

VAR Dis_Tags : array[0..1] of tTagItem;

begin
	Dis_Tags[0].ti_Tag  := GA_Disabled;
	Dis_Tags[0].ti_Data := Disable;
	Dis_Tags[1].ti_Tag  := TAG_END;
	GT_SetGadgetAttrsA(g,w,NIL,@Dis_Tags);
end;

{ refresh the window }
Procedure RefreshWin;
begin
	GT_BeginRefresh(Window);
	GT_EndRefresh(Window, True);
end;

{ open the main window }
Function open_window;

Var 
	tgs       : Array[0..16] Of tTagItem;
	sampTxt   : tIntuiText;
	screendef : pScreen;
	OK        : Boolean;
	nd        : pNode;
	n         : Integer;
   
CONST
	mm : Array[0..13] of tNewMenu = (
		(nm_Type:NM_TITLE),
		(nm_Type:NM_ITEM),
		(nm_Type:NM_ITEM),
		(nm_Type:NM_ITEM),
		(nm_Type:NM_ITEM),
		(nm_Type:NM_ITEM),
		(nm_Type:NM_ITEM),
		(nm_Type:NM_ITEM),
		(nm_Type:NM_TITLE),
		(nm_Type:NM_ITEM),
		(nm_Type:NM_ITEM),
		(nm_Type:NM_TITLE),
		(nm_Type:NM_ITEM),
		(nm_Type:NM_END));

Begin
	Open_Window := False;
	mm[0].nm_Label := CStrConstPtrAR(@RememberKey, 'Project');
	mm[1].nm_Label := CStrConstPtrAR(@RememberKey, 'Open...');
	mm[2].nm_Label := CStrConstPtrAR(@RememberKey, 'Save as...');
	mm[3].nm_Label := CStrConstPtrAR(@RememberKey, 'Test');
	mm[4].nm_Label := STRPTR(NM_BARLABEL);
	mm[5].nm_Label := CStrConstPtrAR(@RememberKey, 'About');
	mm[6].nm_Label := STRPTR(NM_BARLABEL);
	mm[7].nm_Label := CStrConstPtrAR(@RememberKey, 'Quit');
	
	mm[8].nm_Label := CStrConstPtrAR(@RememberKey, 'Edit');
	mm[9].nm_Label := CStrConstPtrAR(@RememberKey, 'Reset To Defaults');
	mm[10].nm_Label := CStrConstPtrAR(@RememberKey, 'Restore');
	
	mm[11].nm_Label := CStrConstPtrAR(@RememberKey, 'Settings');
	mm[12].nm_Label := CStrConstPtrAR(@RememberKey, 'Create Icons?');

	mm[1].nm_CommKey := CStrConstPtrAR(@RememberKey, 'O');
	mm[2].nm_CommKey := CStrConstPtrAR(@RememberKey, 'A');
	mm[7].nm_CommKey := CStrConstPtrAR(@RememberKey, 'Q');
	
	mm[9].nm_CommKey := CStrConstPtrAR(@RememberKey, 'D');
	mm[10].nm_CommKey := CStrConstPtrAR(@RememberKey, 'R');
	
	mm[12].nm_CommKey := CStrConstPtrAR(@RememberKey, 'I');
	mm[12].nm_Flags   := NM_ITEMDISABLED|CHECKIT|MENUTOGGLED;

	WindowIDCMP := INTEGERIDCMP Or IDCMP_REFRESHWINDOW 
		Or BUTTONIDCMP Or LISTVIEWIDCMP
		OR CHECKBOXIDCMP OR IDCMP_VANILLAKEY OR IDCMP_MENUPICK or IDCMP_CLOSEWINDOW;
	gads[G_NI]  := NIL;
   
	ScreenDef := LockPubScreen(NIL);

	{ Get visual info and create context }
	vi := GetVisualInfoA(screendef, NIL);
	If vi <> NIL Then begin
		Gads[G_CC] := CreateContext(@gads[G_NI]);
		If Gads[G_CC] <> NIL Then begin
			{ Get some data from the screen }

			Sizes[TBS]   := screendef^.WBorTop + (screendef^.Font^.ta_YSize + 1);

			My_Font := Screendef^.Font^;
			if (My_Font.ta_YSize*(ListViewRows+5)>Screendef^.Height) then begin 
				with My_Font do begin
					ta_Name    := CStrConstPtrAR(@RememberKey, 'topaz.font');
					ta_YSize   := 8;
					ta_Style   := FS_NORMAL;
					ta_Flags   := FPF_ROMFONT
				end;
				Sizes[S_Gad_H] := 9+screendef^.WBorTop+1;
			end else
				Sizes[S_Gad_H] := sizes[TBS] + 1;
				
			Sizes[S_CM_W] := (Sizes[S_Gad_H]*2)+(Sizes[S_Gad_H] div 3);

			ZoomSizes[3] := Sizes[TBS];
   
			sizes[S_WB_T]    := Screendef^.WBorTop;
			sizes[S_WB_L]    := Screendef^.WBorLeft;
			sizes[S_WB_R]    := Screendef^.WBorRight;
			sizes[S_WB_B]    := Screendef^.WBorBottom;
   
			Samptxt.ITextFont := @My_Font;
			Sizes[S_G1_L] := Sizes[S_WB_L] + Sizes[S_WB_L];
			Samptxt.IText := @G_B_BOTTOMtxt[1];
			Sizes[S_G1_W] := IntuiTextLength(@Samptxt) + 10;
			Samptxt.IText := @Sampstr[1];
			Sizes[S_G2_W] := IntuiTextLength(@Samptxt) + 10;
			Sizes[S_G2_L] := sizes[S_G1_L] + sizes[S_G1_W] + sizes[S_WB_L];
			Samptxt.IText := @sampstr2[1];
			Sizes[S_G3_W] := IntuiTextLength(@Samptxt) + 20;
			Sizes[S_G3_L] := sizes[S_G2_L] + sizes[S_G2_W] + 6;
			Samptxt.IText := CStrConstPtrAR(@RememberKey, 'System options...');
			sizes[extra] := IntuiTextLength(@Samptxt);
			Samptxt.IText := CStrConstPtrAR(@RememberKey, 'The Requesters');
			sizes[S_SCRID_W] := IntuiTextLength(@Samptxt) + 20;
			Samptxt.IText := CStrConstPtrAR(@RememberKey, 'ARexx Command');
			Sizes[TxtWin_L] := IntuiTextLength(@Samptxt) + 25;
			Samptxt.IText := CStrConstPtrAR(@RememberKey, 'Initial ARexx command');
			Sizes[RexxWin_L] := IntuiTextLength(@Samptxt) + 25;
			Samptxt.IText := CStrConstPtrAR(@RememberKey, 'ASynch ');
			Sizes[Synch_W] := IntuiTextLength(@Samptxt) + 7;
			Samptxt.IText := CStrConstPtrAR(@RememberKey, 'Sanghai windows to default public screen ');
			Sizes[SOTxt_W] := IntuiTextLength(@Samptxt) + 20;
			Samptxt.IText := CStrConstPtrAR(@RememberKey, 'Middle Mouse Button');
			Sizes[QTxt_W] := IntuiTextLength(@Samptxt) + 20; 
			
			{ Initilise gadget structures }
			tgs[0].ti_Tag  := GA_Disabled;
			tgs[0].ti_Data := True_;
			tgs[1].ti_Tag  := GT_UnderScore;
			tgs[1].ti_Data := LONG('_');
			tgs[2].ti_Tag  := TAG_END;
   
			With GadgetFlags Do Begin
				ng_TextAttr   := @My_Font;
				ng_LeftEdge   := sizes[S_G1_L]+5;
				ng_TopEdge    := (Sizes[TBS]+Sizes[S_Gad_H])+(Sizes[S_Gad_H] div 2);
				ng_Width      := Sizes[S_G1_W];
				ng_Height     := Sizes[S_GAD_H];
				ng_GadgetText := @G_B_TOPtxt[1];
				ng_VisualInfo := vi;
				ng_GadgetID   := G_B_TOP;
			End;
			{ create gadgets }
			Gads[G_B_TOP] := CreateGadgetA(BUTTON_KIND, Gads[G_CC], @Gadgetflags, @tgs);
			   
			With GadgetFlags Do Begin
				ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H];
				ng_GadgetText := @G_B_UPtxt[1];
				ng_GadgetID   := G_B_UP;
			End;
			Gads[G_B_UP] := CreateGadgetA(BUTTON_KIND, Gads[G_B_TOP], @Gadgetflags, @tgs);
			   
			With GadgetFlags Do Begin
				ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H];
				ng_GadgetText := @G_B_DOWNtxt[1];
				ng_GadgetID   := G_B_DOWN;
			End;
			Gads[G_B_DOWN] := CreateGadgetA(BUTTON_KIND, Gads[G_B_UP], @Gadgetflags, @tgs);
			   
			With GadgetFlags Do Begin
				ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H];
				ng_GadgetText := @G_B_BOTTOMtxt[1];
				ng_GadgetID   := G_B_BOTTOM;
			End;
			Gads[G_B_BOTTOM] := CreateGadgetA(BUTTON_KIND, Gads[G_B_DOWN], @Gadgetflags, @tgs);
			
			tgs[0].ti_Data := False_;
			With GadgetFlags Do Begin
				ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H];
				ng_GadgetText := @G_B_SORTtxt[1];
				ng_GadgetID   := G_B_SORT;
			End;
			Gads[G_B_SORT] := CreateGadgetA(BUTTON_KIND, Gads[G_B_BOTTOM], @Gadgetflags, @tgs);
			
			With GadgetFlags Do Begin
				ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H];
				ng_GadgetText := @G_B_NEWtxt[1];
				ng_GadgetID   := G_B_NEW;
			End;
			Gads[G_B_NEW] := CreateGadgetA(BUTTON_KIND, Gads[G_B_SORT], @Gadgetflags, @tgs);

			tgs[0].ti_Data := True_;
			With GadgetFlags Do Begin
				ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H];
				ng_GadgetText := @G_B_REMOVEtxt[1];
				ng_GadgetID   := G_B_REMOVE;
			End;
			Gads[G_B_REMOVE] := CreateGadgetA(BUTTON_KIND, Gads[G_B_NEW], @Gadgetflags, @tgs);
			
			With GadgetFlags Do Begin
				ng_TopEdge    := ng_TopEdge + Sizes[S_Gad_H];
				ng_GadgetText := @G_B_COPYtxt[1];
				ng_GadgetID   := G_B_COPY;
			End;
			Gads[G_B_COPY] := CreateGadgetA(BUTTON_KIND, Gads[G_B_REMOVE], @Gadgetflags, @tgs);
			   
			tgs[0].ti_Data := False_;
			tgs[2].ti_Tag  := GTLV_ShowSelected;
			tgs[2].ti_Data := 0;
			tgs[3].ti_Tag  := GTLV_Labels;
			tgs[3].ti_Data := LONG(CurrentList);
			tgs[4].ti_Tag  := TAG_END;
			With GadgetFlags Do Begin
				ng_Height     := (ng_TopEdge+ng_Height)-((Sizes[TBS]+Sizes[S_Gad_H])+(Sizes[S_Gad_H] div 2));
				ng_LeftEdge   := sizes[S_G2_L]+5;
				ng_TopEdge    := (Sizes[TBS]+Sizes[S_Gad_H])+(Sizes[S_Gad_H] div 2);
				ng_Width      := Sizes[S_G2_W];
				ng_GadgetText := CStrConstPtrAR(@RememberKey, 'Menu Buttons');
				ng_GadgetID   := G_LV;
				ng_Flags      := PLACETEXT_ABOVE|NG_HIGHLABEL;
			End;
			Gads[G_LV] := CreateGadgetA(LISTVIEW_KIND, Gads[G_B_COPY], @Gadgetflags, @tgs);

			Listviewrows := GadgetFlags.ng_Height div My_Font.ta_YSize;
			
			Labs[0] := CStrConstPtrAR(@RememberKey, 'ARexx');
			Labs[1] := CStrConstPtrAR(@RememberKey, 'Font');
			Labs[2] := CStrConstPtrAR(@RememberKey, 'Palette');
			Labs[3] := CStrConstPtrAR(@RememberKey, 'Qualifiers');
			Labs[4] := CStrConstPtrAR(@RememberKey, 'Screen & Window');
			Labs[5] := CStrConstPtrAR(@RememberKey, 'ScreenMode');
			Labs[6] := CStrConstPtrAR(@RememberKey, 'ScrollFont');
			Labs[7] := CStrConstPtrAR(@RememberKey, 'System & Misc. Settings');
			Labs[8] := CStrConstPtrAR(@RememberKey, 'Titles');
			Labs[9]:= NIL;
			
			SetList := AllocRemember(@Rememberkey, Sizeof(tList), MEMF_CLEAR);
			if SetList = NIL then Halt;
			NewList(SetList);
			For n := 0 to LabMax do begin
				nd := AllocRemember(@RememberKey, Sizeof(tNode), MEMF_CLEAR);
				if nd <> NIL then begin
					nd^.ln_Name := Labs[n];
					AddTail(SetList, nd);
				End;
			End;

			tgs[3].ti_Data := LONG(SetList);
			With GadgetFlags Do Begin
				ng_LeftEdge   := ng_LeftEdge+ng_Width+8;
				ng_GadgetText := CStrConstPtrAR(@RememberKey, 'Settings');
				ng_GadgetID   := G_C_SET;
				ng_Flags      := PLACETEXT_ABOVE|NG_HIGHLABEL;
				ng_Width      := Sizes[S_G2_W];
			End;
			Gads[G_C_SET] := CreateGadgetA(LISTVIEW_KIND, Gads[G_LV], @Gadgetflags, @tgs);

			tgs[2].ti_Tag  := TAG_DONE;
			With GadgetFlags Do Begin
				ng_Height     := Sizes[S_GAD_H];
				ng_TopEdge    := gads[G_B_COPY]^.TopEdge + gads[G_B_COPY]^.Height + 8;
				If NOT V39 then ng_TopEdge := ng_TopEdge + Sizes[S_Gad_H];
				ng_LeftEdge   := sizes[S_G1_L]+5;
				ng_Width      := Sizes[S_G1_W]+25;
				ng_GadgetText := @G_B_SAVEtxt[1];
				ng_Flags      := 0;
				ng_GadgetID   := G_B_SAVE;
			End;
			Gads[G_B_SAVE] := CreateGadgetA(BUTTON_KIND, Gads[G_C_SET], @Gadgetflags, @tgs);
			  
			With GadgetFlags Do Begin
				ng_Leftedge   := Gads[G_C_SET]^.LeftEdge+Gads[G_C_SET]^.Width-ng_Width;
				ng_GadgetText := @G_B_CANCELtxt[1];
				ng_GadgetID   := G_B_CANCEL;
			End;
			Gads[G_B_CANCEL] := CreateGadgetA(BUTTON_KIND, Gads[G_B_SAVE], @Gadgetflags, @tgs);
			 		   
			{ window structure }
			tgs[0].ti_Tag  := WA_Left;
			tgs[0].ti_Data := 0;
			tgs[1].ti_Tag  := WA_Top;
			tgs[1].ti_Data := Sizes[TBS];
			tgs[2].ti_Tag  := WA_InnerWidth;
			tgs[2].ti_Data := GadgetFlags.ng_LeftEdge+GadgetFlags.ng_Width+8;
			tgs[3].ti_Tag  := WA_Height;
			tgs[3].ti_Data := gads[G_B_SAVE]^.TopEdge + gads[G_B_SAVE]^.Height+6;
			tgs[4].ti_Tag  := WA_Title;
			tgs[4].ti_Data := LONG(@Win_Title[1]); 
			tgs[5].ti_Tag  := WA_IDCMP;
			tgs[5].ti_Data := WindowIDCMP;
			tgs[6].ti_Tag  := WA_CloseGadget;
			tgs[6].ti_Data := True_;
			tgs[7].ti_Tag  := WA_DragBar;
			tgs[7].ti_Data := True_;
			tgs[8].ti_Tag  := WA_DepthGadget;
			tgs[8].ti_Data := True_;
			tgs[9].ti_Tag  := WA_AutoAdjust;
			tgs[9].ti_Data := True_;
			tgs[10].ti_Tag := WA_Activate;
			tgs[10].ti_Data:= True_;
			tgs[11].ti_Tag := WA_Gadgets;
			tgs[11].ti_Data:= LONG(gads[G_NI]);
			tgs[12].ti_Tag := WA_Zoom;
			tgs[12].ti_Data:= LONG(@ZoomSizes);
			tgs[13].ti_Tag := $80000093 {WA_NewLookMenus};
			tgs[13].ti_Data:= True_;
			tgs[14].ti_Tag := WA_ScreenTitle;
			tgs[14].ti_Data:= LONG(@Scr_Title[1]);
			tgs[15].ti_Tag := WA_SimpleRefresh;
			tgs[15].ti_Data:= True_;
			tgs[16].ti_Tag := TAG_DONE;
  
			TheWindow := OpenWindowTaglist(NIL,@tgs);
			If TheWindow <> NIL Then begin 

				tgs[0].ti_Tag  := $80080043 {GTMN_NewLookMenus};
				tgs[0].ti_Data := True_;
				tgs[1].ti_Tag  := TAG_END;
				menustrip := CreateMenusA(@mm, NIL);
				if menustrip <> NIL then
					if LayoutMenusA(menustrip,vi,@tgs) then
						OK := SetMenuStrip(TheWindow,MenuStrip);
				GT_RefreshWindow(TheWindow, NIL);
				
				Open_Window := True;
			end;
		end;
	end; 
	UnlockPubScreen(NIL, ScreenDef); 
End;