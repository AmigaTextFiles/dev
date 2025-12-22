pattern AllocDosObjectTags(_type, ...) is
	push d2\a6;
	push.l ...;
	safe d1.l:=_type; d2.l:=sp;;
	a6:=DOSBase; jsr [a6-228];
	sp:=sp+countof(...)<<2;
	pop d2\a6;
endp;															# ALLOCDOSOBJECTTAGS

pattern CreateNewProcTags( ...) is
	push a6;
	push.l ...;
	d1.l:=sp;
	a6:=DOSBase; jsr [a6-498];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# CREATENEWPROCTAGS

pattern NewLoadSegTags(_file, ...) is
	push d2\a6;
	push.l ...;
	safe d1.l:=_file; d2.l:=sp;;
	a6:=DOSBase; jsr [a6-768];
	sp:=sp+countof(...)<<2;
	pop d2\a6;
endp;															# NEWLOADSEGTAGS

pattern SystemTags(_command, ...) is
	push d2\a6;
	push.l ...;
	safe d1.l:=_command; d2.l:=sp;;
	a6:=DOSBase; jsr [a6-606];
	sp:=sp+countof(...)<<2;
	pop d2\a6;
endp;															# SYSTEMTAGS

pattern FPrintf(_fh,_format, ...) is
	push d2\d3\a6;
	push ...;
	safe d1.l:=_fh; d2.l:=_format; d3.l:=sp;;
	a6:=DOSBase; jsr [a6-354];
	sp:=sp+ssizeof(...);
	pop d2\d3\a6;
endp;															# FPRINTF

pattern FWritef(_fh,_format, ...) is
	push d2\d3\a6;
	push ...;
	safe d1.l:=_fh; d2.l:=_format; d3.l:=sp;;
	a6:=DOSBase; jsr [a6-348];
	sp:=sp+ssizeof(...);
	pop d2\d3\a6;
endp;															# FWRITEF

pattern Printf(_format, ...) is
	push d2\a6;
	push ...;
	safe d1.l:=_format; d2.l:=sp;;
	a6:=DOSBase; jsr [a6-954];
	sp:=sp+ssizeof(...);
	pop d2\a6;
endp;															# PRINTF

