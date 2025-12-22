OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
-> --- functions in V36 or higher (Release 2.0) ---
MACRO SetKeyMapDefault(keyMap) IS (A0:=keyMap) BUT (A6:=keymapbase) BUT ASM ' jsr -30(a6)'
MACRO AskKeyMapDefault() IS (A6:=keymapbase) BUT ASM ' jsr -36(a6)'
MACRO MapRawKey(event,buffer,length,keyMap) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(keymapbase,event,buffer,length,keyMap) BUT Loads(A6,A0,A1,D1,A2) BUT ASM ' jsr -42(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO MapANSI(string,count,buffer,length,keyMap) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(keymapbase,string,count,buffer,length,keyMap) BUT Loads(A6,A0,D0,A1,D1,A2) BUT ASM ' jsr -48(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
