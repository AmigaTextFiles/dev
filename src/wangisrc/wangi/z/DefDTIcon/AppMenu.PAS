Function InitAppIcons(VAR V : tProgVars;VAR AppPort : pMsgPort;
							VAR AppMenu : pAppMenuItem):Boolean;

VAR
	res : Boolean;
	
Begin
	res := False;
	AppPort := CreateMsgPort;
	If AppPort <> NIL then begin
		AppMenu := AddAppMenuItemA(0,0,CStrConstPtrAR(@RKey, V.TEXT),AppPort,NIL);
		If AppMenu <> NIL then
			res := true;
	end;
	InitAppIcons := res;
end;


Procedure CleanAppMenu(VAR AppPort : pMsgPort;
								VAR AppMenu : pAppMenuItem);

VAR
	mes : pMessage;
	OK : Boolean;

Begin
	OK := RemoveAppMenuItem(AppMenu);
	mes := GetMsg(AppPort);
	While mes <> NIL do begin
		ReplyMsg(mes);
		mes := GetMsg(AppPort);
	end;
	DeleteMsgPort(AppPort);
end;
	
