Unit AppIcon;

INTERFACE

Uses
	Exec, Icon, Workbench, Dos;
	
Type
	tAIHandle = Record
		ai_AppIcon : pAppIcon;
		ai_MsgPort : pMsgPort;
	End;
	
Function AddAIcon(VAR ai       : tAIHandle;
                      fn, 
                      iname    : String;
                      Left,
                      Top,
                      id,
                      UserData : LONG;
                      RealRet  : Boolean) : Boolean;
Procedure RemoveAIcon(VAR ai   : tAIHandle);

IMPLEMENTATION

Function AddAIcon;

Var
	dobj : pDiskObject;

Begin
	AddAIcon := False;
	iname := iname + #0;
	ai.ai_MsgPort := CreateMsgPort;
	If ai.ai_MsgPort <> NIL then begin
		dobj := NIL;
		If fn <> '' then begin
			fn := fn + #0;
			dobj := GetDiskObjectNew(@fn[1]);
		End;
		If dobj = NIL then begin
			{ get program icon }
			fn := Paramstr(0) + #0;
			dobj := GetDiskObjectNew(@fn[1]);
		End;
		If dobj <> NIL then begin
			With dobj^ do begin
				do_Magic := 0;
				do_Version := 0;
				do_Type := 0;
				do_CurrentX := Left;
				do_CurrentY := Top;
			End;
			ai.ai_AppIcon := AddAppIconA(id, userdata, @iname[1], ai.ai_MsgPort, NIL, dobj, NIL);
			If NOT ((ai.ai_AppIcon = NIL) and RealRet) then
				AddAIcon := True;
			FreeDiskObject(dobj);
		End;
	End;
End;


Procedure RemoveAIcon;

Var
	m  : pMessage;
	ok : Boolean;
	
begin
	If ai.ai_MsgPort <> NIL then begin
		m := GetMsg(ai.ai_MsgPort);
		While m <> NIL do begin
			ReplyMsg(m);
			m := GetMsg(ai.ai_MsgPort);
		End;
		if ai.ai_AppIcon <> NIL then
			Ok := RemoveAppIcon(ai.ai_AppIcon);
		DeleteMsgPort(ai.ai_MsgPort);
	End;
End;

End.