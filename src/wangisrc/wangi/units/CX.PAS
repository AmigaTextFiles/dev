Unit cx;

INTERFACE

Uses
	Exec, Commodities;

Type
	pCxHandle = ^tCxHandle;
	tCxHandle = Record
		cx_Broker : pCxObj;
		cx_MsgPort : pMsgPort;
	End;

Function InitCx(VAR cxhandle : tCxHandle;
                    name,
                    title,
                    desc     : String;
                    flgs,
                    Uni,
                    Pri      : LONG): Boolean;
                    
Function InitCxHotKey(VAR cxhandle : tCxHandle;
                          name,
                          title,
                          desc,
                          hotkey   : String;
                          flgs,
                          Uni,
                          Pri      : LONG): Boolean;
                    
Procedure RemoveCx(VAR cxhandle : tCxHandle);

IMPLEMENTATION

Function InitCx;

Var
	nb          : tNewBroker;
	r           : LONG;

Begin
	InitCx := False;
	{ Null term. }
	InitCx := False;
	name := name + #0;
	title := title + #0;
	desc := desc + #0;
	
	{ create msg. port }
	cxhandle.cx_MsgPort := CreateMsgPort;
	if cxhandle.cx_MsgPort <> NIL then begin
		With nb do begin
			nb_Version := Commodities.NB_VERSION;
			nb_Name    := @name[1];
			nb_Title   := @title[1];
			nb_Descr   := @desc[1];
			nb_Unique  := Uni;
			nb_Flags   := flgs ;
			nb_Pri     := Pri;
			nb_Port    := cxhandle.cx_MsgPort;
			nb_ReservedChannel := 0;
		end;
		
		{ create the broker }
		cxhandle.cx_Broker := CxBroker(@nb, NIL);
		If cxhandle.cx_Broker <> NIL then begin
			if (CxObjError(cxhandle.cx_Broker) = 0) then begin
				r := ActivateCxObj(cxhandle.cx_Broker, 1);
				InitCx := True;
			End;
		End;
	End;
End;


  
Function InitCxHotKey;

Var
	nb          : tNewBroker;
	r           : LONG;
	Filter,
	sender,
	translate : pCxObj;

Begin
	InitCxHotKey := False;
	If InitCx(cxhandle,name,title,desc,flgs,Uni,Pri) then begin
		If cxhandle.cx_Broker <> NIL then begin
			{ create hotkey filter }
			Filter := CxFilter(@hotkey[1]);
			if filter <> NIL then begin
				{ attach filter to broker }
				AttachCxObj(cxhandle.cx_Broker,filter);
				{ create notifier }
				Sender := CxSender(cxhandle.cx_MsgPort, -1);
				If sender <> NIL then begin
					{ join }
					AttachCxObj(filter, sender);
					{ create item remover }
					translate := CxTranslate(NIL);
					if translate <> NIL then begin
						{ join }
						AttachCxObj(filter, translate);
						
						{ if all ok then activate }
						if (CxObjError(filter) = 0) then begin
							r := ActivateCxObj(cxhandle.cx_Broker, 1);
							InitCxHotKey := True;
						End;
					End;
				End;
			End;
		End;
	End;
End;

Procedure RemoveCx;

Var
	msg : pMessage;
	
Begin
	With cxhandle do begin
		If cx_MsgPort <> NIL Then Begin
			If cx_Broker <> NIL then
				DeleteCxObjAll(cx_Broker);
			
			{ clear the port of any last minute messages }
			Msg := GetMsg(cx_MsgPort);
			While msg <> NIL do begin
				ReplyMsg(msg);
				Msg := GetMsg(cx_MsgPort);
			end;
			{ remove the port }
			DeleteMsgPort(cx_MsgPort);
		End;
	End;
End;

End.