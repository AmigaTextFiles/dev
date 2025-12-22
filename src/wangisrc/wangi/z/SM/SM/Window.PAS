Procedure EnableWindow;

VAR result : boolean;

begin
	(* if (OSV39)
	 *  SetWindowPointer(w,TAG_DONE);
    * else
    * not yet, only got v37 defines... NOT!! :) *)
	ClearPointer(w);
	(* Enable window input *)
	EndRequest(req,w);
	(* Enable IDCMP *)
	result := ModifyIDCMP(w,idcmp);
end;

Procedure DisableWindow;

VAR result : boolean;

begin
	result := ModifyIDCMP(w,IDCMP_REFRESHWINDOW);
	(* Block window input *)
	result := Request(req,w);
	(* Set wait pointer *)
 	(*if (OSV39)
	 *	SetWindowPointer(w,WA_BusyPointer,TRUE,TAG_DONE);
	 * else
	 * not yet, only got v37 defines *)
	SetPointer(w,WaitPointer,16,16,-6,0);
end;

{ close the window }
Procedure Close_Window;

Begin
	If CD.cd_ScrT = ST_DT then
		CloseDTWin(Window2);
	If CD.cd_ScrT = ST_RAM then
		If Window2 <> NIL then	
			CloseWindow(Window2);
	CloseWindow(TheWindow);       { close window and free gadgets and }
	FreeGadgets(glist);           { visualinfo                        }
	FreeVisualInfo(vi);
End;

{ Inserts a marker at the first occurence of the given character in the }
{ given string. This is then used as the keyboard shortcut for the gadget } 
Function UnderIfThere;

VAR
	n        : byte;
	sr       : string;
	Finished : Boolean;
	c        : byte;
	
begin
	c := ToUpper(ord(ch));
	
	if c = 0 then begin
		UnderIfThere := s;
		exit;
	end;
	
	if s[length(s)] = #0 then s := copy(s, 1, length(s)-1);
	finished := False;
	n:=1; 
	
	while not finished AND (n <= length(s)) do begin
		if c = ToUpper(ord(s[n])) then begin
			sr := include('æ', s, n)+#0;
			finished := true;
		end;
		n:=n+1;
	end;
	if not finished then
		sr := s + ' (' + 'æ' + ch + ')' + #0; 
	UnderIfThere := sr;
end;

{ refresh the window }
Procedure RefreshWin;
begin
	GT_BeginRefresh(TheWindow);
	GT_EndRefresh(TheWindow, True);
end;



{ open the window }
Function open_window;

CONST
	HSpace = 2{INTERWIDTH}; {2}
	VSpace = 1{INTERHEIGHT}; {1}

Var 
	DTags     : Array[0..10] Of tTagItem;
	GTags     : Array[0..1] Of tTagItem;
	tags      : Array[0..5] of tTagItem;
	node      : pMyNode;
	SampTxt   : tIntuiText;
	n,i       : integer;
	sizeofstr : long;
	win       : pWindow;
   
Begin
	win := NIL;
	WindowIDCMP := IDCMP_REFRESHWINDOW | BUTTONIDCMP | IDCMP_CLOSEWINDOW |
						IDCMP_MOUSEBUTTONS | IDCMP_VANILLAKEY | IDCMP_INTUITICKS;
	glist  := NIL;

	{ Get visual info and create context }
	vi := GetVisualInfoA(TheScreen, NIL);
	If vi <> NIL Then begin
		pGad := CreateContext(@glist);
		if pgad <> NIL then begin
 	
			{ Find longest gadget name and determine size }
			node := pMyNode(CurrentList^.lh_Head);
			sizeofstr := 0;
			With SampTxt do begin
				FrontPen := 0;
				BackPen := 0;
				DrawMode := 0;
				LeftEdge := 0;
				TopEdge := 0;
				ITextFont := @CD.cd_Font;
				IText := @Tmpstr[1];
				NextText := NIL;
			end;
	
			While pMyNode(node^.LSK_Node.ln_Succ) <> NIL do begin
				tmpstr := node^.LSK_Name+' (XX)'#0;
				{$IFDEF DEBUG}
					{Writeln('Size check, node name : ',tmpstr);}
				{$ENDIF}
				If IntuiTextLength(@SampTxt) > sizeofstr then
					sizeofstr := IntuiTextLength(@SampTxt);
				node := pMyNode(node^.LSK_Node.ln_Succ);
			end;

   		Sizes[TBS] := TheScreen^.WBorTop + (TheScreen^.Font^.ta_YSize + 1);
   		ZoomS[3] := Sizes[TBS];
   		Sizes[GAD_W] := sizeofstr+(2*MyTextFont^.tf_XSize);
   		sizes[S_WB_T] := TheScreen^.WBorTop;
   		sizes[S_WB_L] := TheScreen^.WBorLeft;
   		sizes[S_WB_R] := TheScreen^.WBorRight;
   		sizes[S_WB_B] := TheScreen^.WBorBottom;
   		
   		If CD.cd_ScrT = ST_RAM then begin
   			DTags[0].ti_Tag  := WA_Left;
   			DTags[0].ti_Data := 0;
   			DTags[1].ti_Tag  := WA_Top;
   			DTags[1].ti_Data := Sizes[TBS]+1;
   			DTags[2].ti_Tag  := WA_Height;
   			DTags[2].ti_Data := TheScreen^.Font^.ta_YSize*3;
   			DTags[3].ti_Tag  := WA_BackDrop;
   			DTags[3].ti_Data := True_; 
   			DTags[4].ti_Tag  := WA_Borderless;
   			DTags[4].ti_Data := True_;
   			DTags[5].ti_Tag  := WA_PubScreen;
   			DTags[5].ti_Data := LONG(TheScreen);
   			DTags[6].ti_Tag  := WA_IDCMP;
   			DTags[6].ti_Data := IDCMP_REFRESHWINDOW;
   			DTags[7].ti_Tag  := TAG_END;
   			Window2 := OpenWindowTaglist(NIL,@DTags);
   			{$IFDEF DEBUG}
   				if Window2 <> NIL then
						Writeln('Backdrop Window OK');
				{$ENDIF}
			end else Window2 := NIL;
			
			If CD.cd_ScrT = ST_DT then
				Window2 := OpenDTWin(CSCPAR( @RememberKey, CD.cd_DT));
   
			{ Initilise gadget struncture and tags }
   		Tags[0].ti_Tag  := GTTX_Text;
   		Tags[0].ti_Data := LONG(NIL);
   		Tags[1].ti_Tag  := GTTX_Border;
   		Tags[1].ti_Data := True_;
   		Tags[2].ti_Tag  := GTTX_CopyText;
   		Tags[2].ti_Data := False_;
   		Tags[3].ti_Tag  := GTTX_Justification;
   		Tags[3].ti_Data := GTJ_CENTER;
   		Tags[4].ti_Tag  := GTTX_Clipped;
   		Tags[4].ti_Data := True_;
   		Tags[5].ti_Tag  := TAG_END;
   
   		GTags[0].ti_Tag  := GT_UnderScore;
   		GTags[0].ti_Data := LONG('æ');
   		GTags[1].ti_Tag  := TAG_END;
 
   		With GadgetFlags Do Begin
      	ng_TextAttr   := @CD.cd_Font;
      	ng_LeftEdge   := sizes[S_WB_L]+HSpace+1;
      	ng_Width      := Sizes[GAD_W];
      	ng_Height     := Sizes[GAD_H];
      	ng_VisualInfo := vi;
      	ng_GadgetID   := 0;
   		End;

			{ traverse down list creating gadgets, producing a recessed 
			  text display if LSK_Name is 'COMMENT' } 
   		node := pMyNode(CurrentList^.lh_Head);
   		For n := 1 to CD.cd_Down do begin   
   			GadgetFlags.ng_TopEdge    := Sizes[TBS] + VSpace +1 + (n-1)*(Sizes[GAD_H]+VSpace);
   			For i := 1 to CD.cd_Across do begin
   				 With GadgetFlags Do begin
      				ng_LeftEdge   := sizes[S_WB_L] + (i-1)*(ng_Width+HSpace) + HSpace;
      					
      				If pMyNode(node^.LSK_Node.ln_Succ) <> NIL then begin
      					{$IFDEF DEBUG}
   								Writeln('Creating Gadget for ',node^.LSK_Name);
   							{$ENDIF}

      					IF UpperStr(node^.LSK_Cmd[1]) = 'COMMENT' then begin
      						Tags[0].ti_Data := LONG(CSCPAR( @RememberKey, node^.LSK_Name));
      						ng_GadgetText := NIL;
      						ng_GadgetID   := 0;
								pGad := CreateGadgetA(TEXT_KIND, pGad, @Gadgetflags, @Tags);
							end else begin
									if node^.LSK_Key <> '' then 
      							ng_GadgetText := CSCPAR( @RememberKey, UnderIfThere(node^.LSK_Name, Node^.LSK_Key[1]))
      						else
      							ng_GadgetText := CSCPAR( @RememberKey, node^.LSK_Name);
      						ng_UserData   := node;
      						ng_GadgetID   := 1;
      						pGad := CreateGadgetA(BUTTON_KIND, pGad, @Gadgetflags, @GTags);
      					end;
      				end else begin  { We dont want to traverse out of the list }
      					Tags[0].ti_Data := LONG(NIL);
      					ng_GadgetText := NIL;
      					ng_GadgetID   := 0;
							pGad := CreateGadgetA(TEXT_KIND, pGad, @Gadgetflags, @tags);
      				End;
   				End;
   				pGad := CreateGadgetA(BUTTON_KIND, pGad, @Gadgetflags, NIL);
   				If pMyNode(node^.LSK_Node.ln_Succ) <> NIL then
   					node := pMyNode(node^.LSK_Node.ln_Succ);
   			end;
   		end;
	
			{$IFDEF DEBUG}
				Writeln('User Gadgets created');
			{$ENDIF}
			{ Border around scrolling text, use a TD gadget so we dont have 
			  to worry about refreshing a bevelbox }
 			if CD.cd_Wit then begin
				Tags[0].ti_Tag  := GTTX_Text;
   			Tags[0].ti_Data := LONG(NIL);
   			Tags[1].ti_Tag  := GTTX_Border;
   			Tags[1].ti_Data := True_;
   			Tags[2].ti_Tag  := TAG_END;
				With GadgetFlags Do Begin
     				ng_GadgetText := NIL;
     				ng_UserData   := NIL;
     				ng_GadgetID   := 0;
     				ng_TopEdge    := ng_TopEdge + Sizes[TBS] + VSPACE +1;
     				ng_Width      := ng_Width + ng_LeftEdge - sizes[S_WB_L] - 2;
     				ng_LeftEdge   := sizes[S_WB_L] + 2;
     				ng_Height     := CD.cd_SFont.ta_YSize+9;
   			end;
   			pGad := CreateGadgetA(TEXT_KIND, pGad, @Gadgetflags, @tags);
   		end;

			{$IFDEF DEBUG}
				if pgad <> NIL then
					Writeln('Gadget creation OK');
			{$ENDIF}
			{ check nothing went wrong in the gadget production }
   		If pGad <> NIL Then begin
   
   			Base := (GadgetFlags.ng_TopEdge+GadgetFlags.ng_Height)-5;
   
				{ window tags }
   			DTags[0].ti_Tag  := WA_Width;
   			DTags[0].ti_Data := GadgetFlags.ng_LeftEdge+GadgetFlags.ng_Width + sizes[S_WB_R] + 2;
   			DTags[1].ti_Tag  := WA_Height;
   			DTags[1].ti_Data := GadgetFlags.ng_TopEdge+GadgetFlags.ng_Height+3;
   			DTags[2].ti_Tag  := WA_Left;
   			DTags[2].ti_Data := (TheScreen^.Width div 2) - (DTags[0].ti_Data div 2);
   			DTags[3].ti_Tag  := WA_Top;
   			DTags[3].ti_Data := Sizes[TBS]+(((TheScreen^.Height-Sizes[TBS]) div 2) - (DTags[1].ti_Data div 2));
   			DTags[4].ti_Tag  := WA_IDCMP;
   			DTags[4].ti_Data := WindowIDCMP;
   			if CD.cd_ScrT = ST_BACK then begin
   				DTags[5].ti_Tag  := WA_Flags;
   				DTags[5].ti_Data := WFLG_BACKDROP|WFLG_BORDERLESS;
   				DTags[6].ti_Tag  := TAG_IGNORE;
   				DTags[6].ti_Data := 0;
   			end else begin
   				DTags[5].ti_Tag  := WA_Flags;
   				DTags[5].ti_Data := WFLG_CLOSEGADGET|WFLG_DRAGBAR|WFLG_DEPTHGADGET;
   				DTags[6].ti_Tag  := WA_Title;
   				DTags[6].ti_Data := LONG(CSCPAR( @RememberKey, CD.cd_WinTit)); 
   			end;
   			DTags[5].ti_Data := DTags[5].ti_Data|WFLG_ACTIVATE|WFLG_SIMPLE_REFRESH|WFLG_RMBTRAP;
   			DTags[7].ti_Tag := WA_Gadgets;
   			DTags[7].ti_Data:= LONG(gList);
   			DTags[8].ti_Tag := WA_CustomScreen;
   			DTags[8].ti_Data:= LONG(TheScreen);
   			DTags[9].ti_Tag := WA_Zoom;
   			DTags[9].ti_Data:= LONG(@ZoomS);
   			DTags[10].ti_Tag := TAG_DONE;

				{ Open window }
   			Win := OpenWindowTaglist(NIL,@DTags);
   			If Win <> NIL Then 
   				{$IFDEF DEBUG}
						Writeln('Main Window OK');
					{$ENDIF}
   				{ Initial refresh of the gadgets }
   				GT_RefreshWindow(Win, NIL);
   		end;
   	end;
   end;
	Open_Window := win;
End;


