pattern SetKeyMapDefault(_keyMap) is
	push a6;
	a0:=_keyMap;
	a6:=KeymapBase; jsr [a6-30];
	pop a6;
endp;															# SETKEYMAPDEFAULT

pattern AskKeyMapDefault is
	push a6;
	a6:=KeymapBase; jsr [a6-36];
	pop a6;
endp;															# ASKKEYMAPDEFAULT

pattern MapRawKey(_event,_buffer,_length,_keyMap) is
	push a2\a6;
	safe a0:=_event; a1:=_buffer; d1.l:=_length; a2:=_keyMap;;
	a6:=KeymapBase; jsr [a6-42];
	pop a2\a6;
endp;															# MAPRAWKEY

pattern MapANSI(_string,_count,_buffer,_length,_keyMap) is
	push a2\a6;
	safe a0:=_string; d0.l:=_count; a1:=_buffer; d1.l:=_length; a2:=_keyMap;;
	a6:=KeymapBase; jsr [a6-48];
	pop a2\a6;
endp;															# MAPANSI

