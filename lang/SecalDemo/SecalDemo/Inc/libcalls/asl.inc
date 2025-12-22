pattern AllocFileRequest is
	push a6;
	a6:=AslBase; jsr [a6-30];
	pop a6;
endp;															# ALLOCFILEREQUEST

pattern FreeFileRequest(_fileReq) is
	push a6;
	a0:=_fileReq;
	a6:=AslBase; jsr [a6-36];
	pop a6;
endp;															# FREEFILEREQUEST

pattern RequestFile(_fileReq) is
	push a6;
	a0:=_fileReq;
	a6:=AslBase; jsr [a6-42];
	pop a6;
endp;															# REQUESTFILE

pattern AllocAslRequest(_reqType,_tagList) is
	push a6;
	safe d0.l:=_reqType; a0:=_tagList;;
	a6:=AslBase; jsr [a6-48];
	pop a6;
endp;															# ALLOCASLREQUEST

pattern FreeAslRequest(_requester) is
	push a6;
	a0:=_requester;
	a6:=AslBase; jsr [a6-54];
	pop a6;
endp;															# FREEASLREQUEST

pattern AslRequest(_requester,_tagList) is
	push a6;
	safe a0:=_requester; a1:=_tagList;;
	a6:=AslBase; jsr [a6-60];
	pop a6;
endp;															# ASLREQUEST

