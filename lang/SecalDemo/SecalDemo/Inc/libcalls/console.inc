pattern CDInputHandler(_events,_consoleDevice) is
	push a6;
	safe a0:=_events; a1:=_consoleDevice;;
	a6:=ConsoleDevice; jsr [a6-42];
	pop a6;
endp;															# CDINPUTHANDLER

pattern RawKeyConvert(_events,_buffer,_length,_keyMap) is
	push a2\a6;
	safe a0:=_events; a1:=_buffer; d1.l:=_length; a2:=_keyMap;;
	a6:=ConsoleDevice; jsr [a6-48];
	pop a2\a6;
endp;															# RAWKEYCONVERT

pattern consolePrivate1 is
	push a6;
	a6:=ConsoleDevice; jsr [a6-54];
	pop a6;
endp;															# CONSOLEPRIVATE1

pattern consolePrivate2 is
	push a6;
	a6:=ConsoleDevice; jsr [a6-60];
	pop a6;
endp;															# CONSOLEPRIVATE2

pattern consolePrivate3 is
	push a6;
	a6:=ConsoleDevice; jsr [a6-66];
	pop a6;
endp;															# CONSOLEPRIVATE3

pattern consolePrivate4 is
	push a6;
	a6:=ConsoleDevice; jsr [a6-72];
	pop a6;
endp;															# CONSOLEPRIVATE4

