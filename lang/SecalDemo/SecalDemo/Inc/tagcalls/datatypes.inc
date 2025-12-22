pattern DoDTMethod(_o,_win,_req, ...) is
	push a2\a3\a6;
	push.l ...;
	safe a0:=_o; a1:=_win; a2:=_req; a3:=sp;;
	a6:=DataTypesBase; jsr [a6-90];
	sp:=sp+countof(...)<<2;
	pop a2\a3\a6;
endp;															# DODTMETHOD

pattern GetDTAttrs(_o, ...) is
	push a2\a6;
	push.l ...;
	safe a0:=_o; a2:=sp;;
	a6:=DataTypesBase; jsr [a6-66];
	sp:=sp+countof(...)<<2;
	pop a2\a6;
endp;															# GETDTATTRS

pattern NewDTObject(_name, ...) is
	push a6;
	push.l ...;
	safe d0.l:=_name; a0:=sp;;
	a6:=DataTypesBase; jsr [a6-48];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# NEWDTOBJECT

pattern ObtainDataType(_type,_handle, ...) is
	push a6;
	push.l ...;
	safe d0.l:=_type; a0:=_handle; a1:=sp;;
	a6:=DataTypesBase; jsr [a6-36];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# OBTAINDATATYPE

pattern PrintDTObject(_o,_w,_r, ...) is
	push a2\a3\a6;
	push.l ...;
	safe a0:=_o; a1:=_w; a2:=_r; a3:=sp;;
	a6:=DataTypesBase; jsr [a6-114];
	sp:=sp+countof(...)<<2;
	pop a2\a3\a6;
endp;															# PRINTDTOBJECT

pattern RefreshDTObject(_o,_win,_req, ...) is
	push a2\a3\a6;
	push.l ...;
	safe a0:=_o; a1:=_win; a2:=_req; a3:=sp;;
	a6:=DataTypesBase; jsr [a6-78];
	sp:=sp+countof(...)<<2;
	pop a2\a3\a6;
endp;															# REFRESHDTOBJECT

pattern SetDTAttrs(_o,_win,_req, ...) is
	push a2\a3\a6;
	push.l ...;
	safe a0:=_o; a1:=_win; a2:=_req; a3:=sp;;
	a6:=DataTypesBase; jsr [a6-60];
	sp:=sp+countof(...)<<2;
	pop a2\a3\a6;
endp;															# SETDTATTRS

