unit EnableDisableWindow;

INTERFACE

Uses
	Intuition, Exec, Reqtools, Utility;
	
Type
	pEnDisWin = ^tEnDisWin;
	tEnDisWin = Record
		edw_req : pRequester;
	End;
	
Procedure EnableWindow(w : pWindow; key : Pointer);
Function DisableWindow(w : pWindow) : Pointer;

IMPLEMENTATION

Procedure EnableWindow;

Var
	edw : pEnDisWin;

Begin
	if pLibrary(SysBase)^.lib_Version >= 39 then begin
		SetWindowPointerA(w, NIL);
		edw := pEnDisWin(key);
		If edw <> NIL then begin
			if edw^.edw_Req <> NIL then begin
				EndRequest(edw^.edw_Req, w);
				FreeVec(edw^.edw_Req);
				FreeVec(edw);
			End;
		End;
	End else begin
		if ReqToolsBase <> NIL then begin
			if key <> NIL then begin
				rtUnLockWindow(w, Key);
			End;
		End;
	End;
End;

Function DisableWindow;

Var
	t : Array[0..4] of LONG;
	req : pEnDisWin;

begin
	DisableWindow := NIL;
	if pLibrary(SysBase)^.lib_Version >= 39 then begin
		t[0] := WA_BusyPointer;
		t[1] := True_;
		t[2] := WA_PointerDelay;
		t[3] := True_;
		t[4] := TAG_END;
		SetWindowPointerA(w, @t);
		req := AllocVec(sizeof(tEnDisWin), MEMF_CLEAR);
		if req <> NIL then begin
			req^.edw_Req := AllocVec(sizeof(tRequester), MEMF_CLEAR);
			if req^.edw_req <> NIL then begin
				If Request(req^.edw_req, w) then begin
					DisableWindow := Pointer(req);
				end else begin
					FreeVec(req^.edw_Req);
					FreeVec(req);
				End;
			End;
		End;
	End else begin
		If ReqtoolsBase <> NIL then
			DisableWindow := Pointer(rtLockWindow(w));
	End;
end;

End.
