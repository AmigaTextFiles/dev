OPT EXPORT -> ddebuglib.m
OPT NODEFMODS
OPT LINK 'e:linklib/ddebug.lib' -> whatever setup ya got..
OPT XREF DGetChar, DGetNum, DMayGetChar, DPutChar, DPutStr, _KCmpStr

MACRO DGetChar() IS ASM ' bsr DGetChar'
MACRO DGetNum() IS ASM ' bsr DGetNum'
MACRO DMayGetChar() IS ASM ' bsr DMayGetChar'
MACRO DPutChar(char) IS (D0 := char) BUT ASM ' bsr DPutChar'
MACRO DPutFmt(fstr,...) IS Stores(StringF(String(1024), fstr, ...)) BUT DPutStr(Long(A7)) BUT EndString(Long(A7)) BUT Rems(SIZEOF LONG)
MACRO DPutStr(str) IS (A0 := str) BUT ASM ' bsr DPutStr'
MACRO DCmpStr(string1, string2) IS Stores(string1,string2) BUT ASM ' bsr _KCmpStr' BUT Rems(8) BUT D0

/* (LS) 2001 YAEC2.5d */


