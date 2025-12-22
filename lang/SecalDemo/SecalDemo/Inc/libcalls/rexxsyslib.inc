pattern CreateArgstring(_string,_length) is
	push a6;
	safe a0:=_string; d0.l:=_length;;
	a6:=RexxSysBase; jsr [a6-126];
	pop a6;
endp;															# CREATEARGSTRING

pattern DeleteArgstring(_argstring) is
	push a6;
	a0:=_argstring;
	a6:=RexxSysBase; jsr [a6-132];
	pop a6;
endp;															# DELETEARGSTRING

pattern LengthArgstring(_argstring) is
	push a6;
	a0:=_argstring;
	a6:=RexxSysBase; jsr [a6-138];
	pop a6;
endp;															# LENGTHARGSTRING

pattern CreateRexxMsg(_port,_extension,_host) is
	push a6;
	safe a0:=_port; a1:=_extension; d0.l:=_host;;
	a6:=RexxSysBase; jsr [a6-144];
	pop a6;
endp;															# CREATEREXXMSG

pattern DeleteRexxMsg(_packet) is
	push a6;
	a0:=_packet;
	a6:=RexxSysBase; jsr [a6-150];
	pop a6;
endp;															# DELETEREXXMSG

pattern ClearRexxMsg(_msgptr,_count) is
	push a6;
	safe a0:=_msgptr; d0.l:=_count;;
	a6:=RexxSysBase; jsr [a6-156];
	pop a6;
endp;															# CLEARREXXMSG

pattern FillRexxMsg(_msgptr,_count,_mask) is
	push a6;
	safe a0:=_msgptr; d0.l:=_count; d1.l:=_mask;;
	a6:=RexxSysBase; jsr [a6-162];
	pop a6;
endp;															# FILLREXXMSG

pattern IsRexxMsg(_msgptr) is
	push a6;
	a0:=_msgptr;
	a6:=RexxSysBase; jsr [a6-168];
	pop a6;
endp;															# ISREXXMSG

pattern LockRexxBase(_resource) is
	push a6;
	d0.l:=_resource;
	a6:=RexxSysBase; jsr [a6-450];
	pop a6;
endp;															# LOCKREXXBASE

pattern UnlockRexxBase(_resource) is
	push a6;
	d0.l:=_resource;
	a6:=RexxSysBase; jsr [a6-456];
	pop a6;
endp;															# UNLOCKREXXBASE

