pattern BuildEasyRequest(_window,_easyStruct,_idcmp, ...) is
	push a3\a6;
	push ...;
	safe a0:=_window; a1:=_easyStruct; d0.l:=_idcmp; a3:=sp;;
	a6:=IntuitionBase; jsr [a6-594];
	sp:=sp+ssizeof(...);
	pop a3\a6;
endp;															# BUILDEASYREQUEST

pattern DoGadgetMethod(_gad,_win,_req, ...) is
	push a2\a3\a6;
	push.l ...;
	safe a0:=_gad; a1:=_win; a2:=_req; a3:=sp;;
	a6:=IntuitionBase; jsr [a6-810];
	sp:=sp+countof(...)<<2;
	pop a2\a3\a6;
endp;															# DOGADGETMETHOD

pattern EasyRequest(_window,_easyStruct,_idcmpPtr, ...) is
	push a2\a3\a6;
	push ...;
	safe a0:=_window; a1:=_easyStruct; a2:=_idcmpPtr; a3:=sp;;
	a6:=IntuitionBase; jsr [a6-588];
	sp:=sp+ssizeof(...);
	pop a2\a3\a6;
endp;															# EASYREQUEST

pattern NewObject(_classPtr,_classID, ...) is
	push a2\a6;
	push.l ...;
	safe a0:=_classPtr; a1:=_classID; a2:=sp;;
	a6:=IntuitionBase; jsr [a6-636];
	sp:=sp+countof(...)<<2;
	pop a2\a6;
endp;															# NEWOBJECT

pattern OpenScreenTags(_newScreen, ...) is
	push a6;
	push.l ...;
	safe a0:=_newScreen; a1:=sp;;
	a6:=IntuitionBase; jsr [a6-612];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# OPENSCREENTAGS

pattern OpenWindowTags(_newWindow, ...) is
	push a6;
	push.l ...;
	safe a0:=_newWindow; a1:=sp;;
	a6:=IntuitionBase; jsr [a6-606];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# OPENWINDOWTAGS

pattern SetAttrs(_object, ...) is
	push a6;
	push.l ...;
	safe a0:=_object; a1:=sp;;
	a6:=IntuitionBase; jsr [a6-648];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# SETATTRS

pattern SetGadgetAttrs(_gadget,_window,_requester, ...) is
	push a2\a3\a6;
	push.l ...;
	safe a0:=_gadget; a1:=_window; a2:=_requester; a3:=sp;;
	a6:=IntuitionBase; jsr [a6-660];
	sp:=sp+countof(...)<<2;
	pop a2\a3\a6;
endp;															# SETGADGETATTRS

pattern SetWindowPointer(_win, ...) is
	push a6;
	push.l ...;
	safe a0:=_win; a1:=sp;;
	a6:=IntuitionBase; jsr [a6-816];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# SETWINDOWPOINTER

