Function OpenDTWin(fn : STRPTR) : pWindow;

VAR
	nomwidth, nomheight,Junk : LONG;
	win : pWindow;
	t : Array[0..16] of LONG;

Begin
	nomheight := 0;
	nomwidth  := 0;
	win := NIL;
	if DataTypesBase = NIL then begin
		dto := NIL;
		CD.cd_ScrT := ST_NONE;
		OpenDTWin := Win;
		Exit;
	end;
	
	{ get datatype }
	dto := NewDTObjectA(fn, NIL);
	if dto <> NIL then begin
		{ get info }
		t[0] := DTA_NominalHoriz;
		t[1] := LONG(@nomwidth);
		t[2] := DTA_NominalVert;
		t[3] := LONG(@nomheight);
		{If CD.cd_HAM then begin
			cregs := AllocVec(CD.cd_ScrDepth*
			t[4] := PDTA_ColorRegisters;}
		t[4] := TAG_END;
		if GetDTAttrsA(dto, @t) <> 0 then begin
		
			if nomwidth = 0 then 
				nomwidth := TheScreen^.Width;
			if nomheight = 0 then 
				nomheight := TheScreen^.Height;
				
			{ open the window }
			t[0]  := WA_InnerWidth;
			t[1]  := nomwidth;
			t[2]  := WA_InnerHeight;
			t[3]  := nomheight;
			t[4]  := WA_IDCMP;
			t[5]  := IDCMP_IDCMPUPDATE|IDCMP_REFRESHWINDOW;
			t[6]  := WA_BackDrop;
			t[7]  := True_;
			t[8]  := WA_SimpleRefresh;
			t[9]  := True_;
			t[10] := WA_BorderLess;
			t[11] := True_;
			t[12] := WA_Top;
			t[13] := Sizes[TBS];
			t[14] := WA_PubScreen;
			t[15] := LONG(TheScreen);
			t[16] := TAG_END;
			win := OpenWindowTagList(NIL, @t);
			if win <> NIL then begin
				{ set dt dim. }
				t[ 0] := GA_Left;
				t[ 1] := win^.BorderLeft;
				t[ 2] := GA_Top;
				t[ 3] := win^.BorderTop;
				t[ 4] := GA_Width;
				t[ 5] := win^.Width - win^.BorderLeft - win^.BorderRight;
				t[ 6] := GA_Height;
				t[ 7] := win^.Height - win^.BorderTop - win^.BorderBottom;
				t[ 8] := ICA_TARGET;
				t[ 9] := ICTARGET_IDCMP;
				t[10] := DTA_Immediate;
				t[11] := LONG(CD.cd_DTImmed);
				t[12] := DTA_Repeat;
				t[13] := LONG(CD.cd_DTRepeat);
				t[14] := TAG_END;
				junk := SetDTAttrsA(dto, NIL, NIL, @t);
				
				{ add object to the window }
				junk := AddDTObject(win, NIL, dto, -1);
				
				{ refresh }
				RefreshDTObjectA(dto, win, NIL, NIL);
			end;
		end; { else begin
			junk := IOErr;
			Writeln('Can not load, error : ',junk);
		end;}
	end;
	OpenDTWin := Win;
end;

Procedure CloseDTWin(VAR win : pWindow);
VAR
	rc : LONG;
begin
	if DataTypesBase <> NIL then begin

		if dto <> NIL then begin
			rc := RemoveDTObject(win, dto);
			DisposeDTObject(dto);
		end;
		if win <> NIL then
			CloseWindow(win);
	end;
end;
