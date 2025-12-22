Program Jiggggler;
{$F-,I+,R+,S+,V+,M 3,1,1,1}

Uses 
	AmigaDos, Exec, Intuition, Graphics, Icon, Amiga, Workbench, 
	Commodities, CStrCOnstPtr, Timer, Input;
	
Type
	tProgVars = Record
		arg_Delay : LONG;
		arg_HotKey : String;
		arg_Pri,
		arg_CxPri,
		arg_Off    : LONG;
	End;
	
Var
	v : tProgVars;
	CxPort, timerport, iport : pMsgPort;
	broker, filter, translate, sender : pCxObj;
	tio : ptimerequest;
	ior : pIORequest;
	
{$I ToolType.PAS }
{$I Version.H }


Function InitCx : Boolean;

Var
	rk : pRemember;
	nb : tNewBroker;
	r  : LONG;

Begin
	InitCx := False;
	rk := NIL;
	Cxport := CreateMsgPort;
	if Cxport <> NIL then begin
		{ watch this Pascalians ;^). if you put : }
		{ With nb do begin                        }
		{   nb_Version := NB_VERSION              }
		{ end;                                    }
		{ you will not get any messages from Cx   }
		{ because you are assigning the field     }
		{ nb_Version to the field nb_version and  }
		{ not the NB_VERSION constant             }
			
		nb.nb_Version := NB_VERSION;
		With nb do begin
			nb_Name   := @CX_NAME[1];
			nb_Title  := @CX_TITLE[1];
			nb_Descr  := @CX_DESCR[1];
			nb_Unique := 0;
			nb_Flags  := 0;
			nb_Pri    := V.arg_CxPri;
			nb_Port   := CxPort;
			nb_ReservedChannel := 0;
		end;
		Broker := CxBroker(@nb, NIL);
		If broker <> NIL then begin
			Filter := CxFilter(CSCPAR(@rk, V.arg_Hotkey));
			if filter <> NIL then begin
				AttachCxObj(broker,filter);
				Sender := CxSender(CxPort, 0);
				If sender <> NIL then begin
					AttachCxObj(filter, sender);
					translate := CxTranslate(NIL);
					if translate <> NIL then begin
						AttachCxObj(filter, translate);
						
						if (CxObjError(filter) = 0) then begin
							r := ActivateCxObj(broker, 1);
							InitCx := True;
						End;
					End;
				End;
			End;
		End;
	End;
	FreeRemember(@rk, True);
End;

Procedure RemoveCx;

Var
	msg : pMessage;
	
Begin
	DeleteCxObjAll(broker);
	{ clear the port of any last minute messages }
	Msg := GetMsg(Cxport);
	While msg <> NIL do begin
		ReplyMsg(msg);
		Msg := GetMsg(Cxport);
	end;
	{ remove the port }
	DeleteMsgPort(CxPort);
end;

Function InitTimer : Boolean;

Begin
	Inittimer := false;
	TimerPort := CreateMsgPort;
	If timerport <> NIL then begin
		tio := pTimeRequest(CreateIORequest(TimerPort, sizeof(ttimerequest)));
		if tio <> NIL then begin
			If OpenDevice(TIMERNAME,UNIT_VBLANK, pIORequest(tio),0) = 0 then begin
				InitTimer := True;
			End;
		End;
	End;
End;

Procedure CloseTimer;

Var
	e : LONG;
	
begin
	If CheckIO(pIORequest(tio)) = NIL then begin
		AbortIO(pIORequest(tio));
		e := WaitIO(pIORequest(tio));
	End;
	CloseDevice(pIORequest(tio));
	DeleteIORequest(pIORequest(tio));
	DeleteMsgPort(TimerPort);
End;

Procedure SendTimer;

Begin
	tio^.tr_Node.io_Command := TR_ADDREQUEST;
	tio^.tr_Node.io_Flags := 0;
	tio^.tr_Node.io_Error := 0;
	tio^.tr_Time.tv_Secs := V.arg_Delay;
	tio^.tr_Time.tv_Micro := 0; 
	SendIO(pIORequest(tio));
End;

Function InitInput : Boolean;

begin
	InitInput := False; 
	iport := CreateMsgPort;
	if iport <> NIL then begin
		ior := CreateIORequest(iport, Sizeof(tIORequest));
		if ior <> NIL then begin
			if OpenDevice('input.device', 0, ior, 0) = 0 then begin
				InputBase := pLibrary(ior^.io_Device);
				InitInput := True;
			End;
		End;
	End;
End;

Procedure FreeInput;

begin
	CloseDevice(ior);
	DeleteIORequest(ior);
	DeleteMsgPort(iport);
End;
	
		
	
Procedure Main;

Var
	win : pWindow;
	ok : Boolean;
	dx, dy : Integer;
	Timermask, CxMask, sigre,
	cxtype, cxid, l : LONG;
	CxMsg : pCxMsg;
	Msg : pMessage;
	ExitFlag, Enabled : Boolean;

Begin
	IntuitionBase := pIntuitionBase(OpenLibrary('intuition.library',0));
	If intuitionBase <> NIL then begin
		CxBase := OpenLibrary('commodities.library',36);
		If CxBase <> NIL then begin
			IconBase := OpenLibrary('icon.library',0);
			If IconBase <> NIL then begin
				GetToolTypes(V);
				If InitCx then begin
					If InitTimer then begin
						{ reduce task priority }
						sigre := SetTaskPri(FindTask(NIL), V.arg_Pri);
						If InitInput Then begin
							SendTimer;
						
							CxMask    := BitMask(CxPort^.MP_SIGBIT);     { for Cx msgs    }
							TimerMask := BitMask(TimerPort^.MP_SIGBIT);  { for Timer msgs }

							ExitFlag := False;
							Enabled := True;
							While Not exitflag Do Begin
								sigre := Wait(CxMask|TimerMask|SIGBREAKF_CTRL_C);
		
								if ((sigre and SIGBREAKF_CTRL_C)=SIGBREAKF_CTRL_C) then
									ExitFlag := True;
							
								if ((sigre and CxMask)=CxMask) then begin
									CxMsg := pCxMsg(GetMsg(CxPort));
									While CxMsg <> NIL do begin
										cxtype := CxMsgType(CxMsg);
										cxid := CxMsgID(CxMsg);
										ReplyMsg(pMessage(CxMsg));
										Case cxtype of
											CXM_COMMAND : begin
												case cxid of       { messages from exchange }
													CXCMD_DISABLE   : Enabled := False;
													CXCMD_ENABLE    : Enabled := True;
													CXCMD_KILL      : ExitFlag := True; 
												end;
											end;
											CXM_IEVENT : Begin
												{ hotkey pressed, en/disable }
												If Enabled then
													Enabled := False
												else
													Enabled := True;
											End;
										end;
										CxMsg := pCxMsg(GetMsg(CxPort));
									end;
								End;
						
								if ((sigre and TimerMask)=TimerMask) then begin
									Msg := GetMsg(TimerPort);
									While Msg <> NIL do begin
										If Enabled and (PeekQualifier and IEQUALIFIER_RBUTTON = 0) then begin
											win := IntuitionBase^.FirstScreen^.FirstWindow;
											While win <> NIL Do begin
												If (win^.Flags and WFLG_DRAGBAR) = WFLG_DRAGBAR then begin
													If (win^.Flags and WFLG_BACKDROP) <> WFLG_BACKDROP then begin
														If (win^.Flags and WFLG_MENUSTATE) <> WFLG_MENUSTATE then begin
															dx := 0; dy := 0;
															If win^.MouseX > 0 then
																dx := V.arg_Off;
															If win^.MouseX < 0 then
																dx := -V.arg_Off;
															If win^.MouseY > 0 then
																dy := V.arg_Off;
															If win^.MouseY < 0 then
																dy := -V.arg_Off;
															If NOT ((dy = 0) and (dx = 0)) then
																MoveWindow(win, dx, dy);
														End;
													End;
												End;
												win := win^.NextWindow;
											End;
										End;
										Msg := GetMsg(TimerPort);
									End;
									SendTimer;
								End;
							End;
							FreeInput;
						End;
						CloseTimer;
					End;
					RemoveCx;
				End;
				CloseLibrary(pLibrary(IconBase));
			End;
			CloseLibrary(pLibrary(CxBase));
		End;
		CloseLibrary(pLibrary(IntuitionBase));
	End;
End;

Begin Main End.