Procedure SendARexxCommand;

VAR
	rxmsg         : pRexxMsg;
	ap, dummyport : pMsgPort;
	dummsg        : pMessage;
	dp            : string;
	
Begin
	dp := destport + #0;
	if (RexxSysBase <> NIL) and (command <> '') and (destport <> '') then begin
		{ rexx available, command and port reasonably valid }
		dummyport := CreateMsgPort;
		if dummyport <> NIL then begin
			{ create an ARexx message }
			rxmsg := CreateRexxMsg(DummyPort,NIL,NIL);
			if rxmsg <> NIL then begin
				{ create an argument string }
				rxmsg^.rm_Args[0] := CreateArgstring(@command[1],length(command));
				if rxmsg^.rm_Args[0] <> NIL then begin
					rxmsg^.rm_Action := RXCOMM|RXFF_NOIO;
					{ make sure port does not disapear }
					Forbid;
					{ find the destination port }
					ap := FindPort(@dp[1]);
					if ap <> NIL then
						{ send the message }
						PutMsg(ap, pMessage(rxmsg));
					Permit;
					if ap <> NIL then begin
						{ wait for message and remove }
						dummsg := WaitPort(DummyPort);
						dummsg := GetMsg(DummyPort);
					end;
					ClearRexxMsg(rxmsg,1);
				end;
				DeleteRexxMsg(rxmsg);
			end;
			DeleteMsgPort(dummyport);
		end;
	end;
end;
