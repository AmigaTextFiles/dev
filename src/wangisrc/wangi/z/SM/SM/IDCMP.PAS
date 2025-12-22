Procedure DoShell(n : pMyNode);
VAR
	nd : pMyNode;
	
begin
	if n^.LSK_NewShell then begin
		nd := AllocMem(sizeof(tMyNode), MEMF_CLEAR);
		if nd <> NIL then begin
			if n^.LSK_ShellFrom <> '' then
				nd^.LSK_Cmd[1]     := 'NewShell FROM '+n^.LSK_ShellFrom
			else
				nd^.LSK_Cmd[1]     := 'NewShell';
			if n^.LSK_ShellWin <> '' then
				nd^.LSK_Cmd[1] := nd^.LSK_Cmd[1]+' WINDOW '+n^.LSK_ShellWin+#0
			else
				nd^.LSK_Cmd[1] := nd^.LSK_Cmd[1]+#0;
			nd^.LSK_ASynch       := True;
			nd^.LSK_Output       := 'NIL:';
			if NOT StartCLIProgram(nd) then begin end;
			FreeMem_(nd, Sizeof(tMyNode));
		end;
	end;
end;
		
{ IDCMP loop }
Function HandleIDCMP;

Const
   exitflag : Boolean  = False;
   rc       : shortint = 0;
   j        : Integer = 1;
   Ticks    : LONG = 0;
   
Var 
	dummy, w1mask, w2mask    : longint;
	Tags     : Array[0..1] of tTagItem;
  message  : pIntuiMessage;
  MsgClass : LongInt;
  MsgCode  : Word;
  gadcode  : pGadget;
  StrInfo  : pStringInfo;
	found    : boolean;
	node     : pMyNode;
	tf       : pTextFont;
	it, it2  : tIntuiText;
	txt, txt2 : String;
	secs : Long;
	cdt : pDateTime;
	ds  : pDateStamp;
	tg : pTagItem;
	
	
Procedure UpDate_RAM_Time;
VAR
	OK  : Boolean;
	mem : LONG;
	
begin
	if (ds <> NIL) and (cdt <> NIL) and (window2 <> NIL) then begin
		ds := DateStamp(ds);
		With cdt^ do
			dat_Stamp   := ds^;
		OK := DateToStr(cdt);
		txt2 := 'Time : '+PtrToPas(@txt2[1])+#0;
		mem := (AvailMem(0));
		Str(mem, txt);
		txt := 'Free memory : '+txt+' bytes      '#0;
		PrintIText(Window2^.RPort, @it, 0, 0);
	end;
end;

Function DoGad(GadNode : pMyNode) : Boolean;

VAR
	QuitAfter : Boolean;
	
begin
	QuitAfter := False;
	DisableWindow(TheWindow, @DummyReq, waitpointer);

	if CD.cd_Rexx then begin
		if GadNode^.LSK_Quit then
			SendARexxCommand(CD.cd_RexxCmd3, CD.cd_RexxPort3);
		SendARexxCommand(GadNode^.LSK_RexxCmd, GadNode^.LSK_RexxPort);
	end;
	
	if NOT CD.cd_Test Then begin
		If GadNode^.LSK_Quit Then
			ScreenToBack(TheScreen);
		WriteLogFile(lf, GadNode, False);
		if NOT StartCLIProgram(GadNode) then begin
			{ launch failure }
			QuitAfter := false;
			DisplayBeep(NIL);
		end else begin
			{ launch success }
			DoShell(GadNode);
			if GadNode^.LSK_Quit then begin
				QuitAfter := true;
			end else begin 
				CD.cd_Wait := 0; {disable time out}
			end;
		end;  		            			
	end else begin
		{ Test mode }
		rc := rtEZRequestA(CSCPAR(@RememberKey, 'Gadget Selected : ' + 
			GadNode^.LSK_Name+'"'),
			CSCPAR(@RememberKey,'OK'),NIL,NIL,@Tags);
			
		If GadNode^.LSK_Quit then
			QuitAfter := true
		else begin
			QuitAfter := False;
		end
	end;
	EnableWindow(TheWindow, @DummyReq, WindowIDCMP);
	if CD.cd_ScrT = ST_RAM then
		UpDate_RAM_Time;
	DoGad := QuitAfter;
end;

begin

	ds := AllocVec(Sizeof(tDateStamp), MEMF_CLEAR);
	cdt := AllocVec(Sizeof(tDateTime), MEMF_CLEAR);
	if cdt <> NIL then begin
		With cdt^ do begin
			dat_Format  := 4;
			dat_StrTime := @txt2[1];
		end;
	end;
	it.FrontPen := 1;
	it.BackPen := 0;
	it.Drawmode := JAM2;
	it.LeftEdge := 0;
	it.TopEdge := 2;
	it.ITextFont := @CD.cd_Font;
	it.IText := @txt[1];
	it.NextText := @it2;
	
	it2 := it;
	it2.TopEdge := it2.TopEdge+CD.cd_Font.ta_YSize;
	it2.IText := @txt2[1];
	it2.NextText := NIL;
	
	Tags[0].ti_Tag  := RT_Window;
	Tags[0].ti_Data := Long(TheWindow);
	Tags[1].ti_Tag  := TAG_END;
	
	{ Open font and set it as the current rastport font }
 	tf := OpenDiskFont(@CD.cd_SFont);
	SetFont(TheWindow^.RPort, tf);
	
	{ Set the current pen to register 1 (normally black) }
	SetAPen(TheWindow^.RPort, 1);
   
	w1mask := BitMask(TheWindow^.UserPort^.MP_SIGBIT);
	if window2 <> NIL then
		w2mask := BitMask(Window2^.UserPort^.MP_SIGBIT)
	else
		w2mask := 0;
   
	{ Loop until exitflag is false, ie a gadget has been pressed }
	While Not exitflag Do Begin
		{ Wait on our port }
		
			
		dummy    := Wait(w1mask|w2mask);
		
		if ((dummy and w2mask) <> 0) then begin
		message  := GT_GetIMsg(Window2^.userPort);
		While message <> NIL do begin
			MsgClass := message^.Class;
			
			if MsgClass = IDCMP_IDCMPUPDATE then begin
				tg := pTagItem(message^.IAddress);
				while tg^.ti_Tag <> TAG_END do begin
					If tg^.ti_Tag = DTA_Sync then begin
						RefreshDTObjectA (dto, window2, NIL, NIL);
					end;
					tg := pTagItem(LONG(tg)+Sizeof(tTagItem));
				end;
			end;
				
			if MsgClass = IDCMP_REFRESHWINDOW then begin
				GT_BeginRefresh(Window2);
				GT_EndRefresh(Window2, True);
			end;
			GT_ReplyIMsg(message);
			message  := GT_GetIMsg(Window2^.userPort);
		end;
		end;
				
		if ((dummy and w1mask) <> 0) then begin
		message  := GT_GetIMsg(TheWindow^.userPort);
		while message <> NIL do begin
			MsgClass := message^.Class;
			MsgCode  := message^.Code;
			secs := message^.Seconds;
      	
			{ only copy if it is a pointer to a gadget }
			if MsgClass = IDCMP_GADGETUP then begin
				GadCode  := pGadget(message^.IAddress);
				StrInfo  := gadcode^.SpecialInfo;
			end else begin 
				GadCode := NIL;
				StrInfo := NIL;
			end;
      	
      { Reply as we've copied all information required }
     	GT_ReplyIMsg(message);
			Case MsgClass Of
				IDCMP_CLOSEWINDOW : begin
					{$IFDEF DEBUG}
						Writeln('-->IDCMP_CLOSEWINDOW');
					{$ENDIF}
					{ close selected so exit }
					exitflag := true;
					rc := 10;
					WriteLogFile(lf, NIL, True);
				end;
				      	
				IDCMP_REFRESHWINDOW : 
				{$IFDEF DEBUG}
				Begin
					Writeln('-->IDCMP_REFRESHWINDOW');
				{$ENDIF}
					RefreshWin;
				{$IFDEF DEBUG}
				end;
				{$ENDIF}
				         	
				IDCMP_INTUITICKS : begin
					{$IFDEF DEBUG}
						{$IFDEF DEBUGITICKS}
							Writeln('-->IDCMP_INTUITICKS');
						{$ENDIF}
					{$ENDIF}
					inc(Ticks);
					if (Ticks >= (CD.cd_Wait*10)) and (CD.cd_Wait > 0) then begin
						exitflag := true;
						rc := 10;
					end;
					if CD.cd_Wit then
						{ Scroll text along the bottom of the window }
						ScrollText(TheWindow^.RPort, sizes[S_WB_L]+5, base, 
							(TheWindow^.Width-sizes[S_WB_L]-Sizes[S_WB_R]-10), CD.cd_SFont.ta_YSize, j, 
							CD.cd_WitTxt);
					if (CD.cd_ScrT = ST_RAM) and (Odd(Ticks)) then
						UpDate_RAM_Time;
				end;
				         		
				IDCMP_GADGETUP : If NOT exitflag then Begin
					{$IFDEF DEBUG}
						Writeln('-->IDCMP_GADGETUP');
					{$ENDIF}
					{ launch command pointed to by the gadgets userdata and set exitflag }
					{ just to be sure }
					if GadCode^.GadgetID = 1 then begin
						node := pMyNode(GadCode^.UserData);
						ExitFlag := DoGad(node); 
					end;
				end;
				            
				IDCMP_VANILLAKEY : if NOT exitflag then begin
					{ traverse thru list searching for a node with a LSK_Key 
						that matches the character pressed. If found launch 
						command and set loopflag }
				            	  
					{$IFDEF DEBUG}
						Writeln('-->IDCMP_VANILLAKEY');
					{$ENDIF}
				            	  
					node := pMyNode(CurrentList^.lh_Head);
					found := false;
					While (pMyNode(node^.LSK_Node.ln_Succ) <> NIL) AND (NOT Found) do begin
						if UpCase(chr(msgcode)) = node^.LSK_Key[1] then
							found := true
						else 
							node := pMyNode(node^.LSK_Node.ln_Succ);
					end;
					If found then begin       	
						ExitFlag := DoGad(node);
					end else DisplayBeep(TheScreen);  
				end;
			End;
		message  := GT_GetIMsg(TheWindow^.userPort);
		end;
		end;
	End;
	if cdt <> NIL then 
		FreeVec(cdt);
	if ds  <> NIL then
		FreeVec(ds);
	CloseFont(tf);
	HandleIdcmp := rc;
End;
