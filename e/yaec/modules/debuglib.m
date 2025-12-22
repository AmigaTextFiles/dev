OPT EXPORT  -> debuglib.e
OPT NODEFMODS
OPT LINK 'e:linklib/debug.lib' -> whatever setup ya got..
OPT XREF _KGetChar, _KCmpStr, _KGetNum, _KMayGetChar, KPutChar, KPutStr

MACRO KCmpStr(string1, string2) IS Stores(string1, string2) BUT ASM ' bsr _KStrCmp' BUT Rems(8) BUT D0
MACRO KGetChar() IS ASM ' bsr _KGetChar'
MACRO KGetNum() IS ASM ' bsr _KGetNum'
MACRO KMayGetChar() IS ASM ' bsr _KMayGetChar'
MACRO KPrintF(fstr,...) IS Stores(StringF(String(1024), fstr, ...)) BUT KPutStr(Long(A7)) BUT EndString(Long(A7)) BUT Rems(4)
MACRO KPutChar(char) IS (D0 := char) BUT ASM ' bsr KPutChar'
MACRO KPutStr(str) IS (A0 := str) BUT ASM ' bsr KPutStr'

/* (LS) 2001 YAEC2.5d */

