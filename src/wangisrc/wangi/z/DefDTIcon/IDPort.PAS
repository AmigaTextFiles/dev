Function ChecKIDPortOrSetUp(VAR IDPort : pMsgPort; portname : STRPTR):Boolean;

VAR
	Port, ReplyPort : pMsgPort;
	Message, ms : pMessage;
	return : boolean;

Begin
	return := false;
	Forbid;
	{ Check that were not allready running }
	Port := FindPort(portname); 
	Permit;
	
	If Port <> NIL then begin
		{ already running so tell other copy to quit and exit ourselfs}
		Return := False;
		message := AllocMem(sizeof(tMessage),MEMF_CLEAR);
		if message <> NIL then begin
			ReplyPort := CreateMsgPort;
			if replyport <> NIL then begin
				message^.mn_Node.ln_Type := NT_MESSAGE;
				message^.mn_ReplyPort := ReplyPort;
				message^.mn_Length := sizeof(tMessage);

				PutMsg(Port, Message);
				ms := WaitPort(ReplyPort);
				ms := GetMsg(ReplyPort);
				FreeMem_(message, sizeof(tMessage));
			end;
		end;
	end else begin
		Return := true;
		{ create ID port }
		IDPort := CreateMsgPort;
		If IDPort <> NIL then begin
			IDPort^.mp_Node.ln_Name := portname;
			IDPort^.mp_Node.ln_Pri := 0;
			AddPort(IDPort);
		end;
	end;
	CheckIdPortOrSetup := return;
end;
			
Procedure CleanIDPort(IDPort : pMsgPort);

VAR
	mes : pMessage;
Begin
	if IDPort <> NIL then begin
		mes := GetMsg(IDPort);
		While mes <> NIL do begin
			ReplyMsg(mes);
			mes := GetMsg(IDPort);
		end;
		RemPort(IDPort);
		DeleteMsgPort(IDPort);
	end;
end;				
			
			 
			 
			 
			 
			 
			 
			 
			 
			 