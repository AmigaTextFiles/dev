OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
-> --- functions in V40 or higher (Release 3.1) ---
-> 
->  Public entries
-> 
MACRO LockAmigaGuideBase(handle) IS (A0:=handle) BUT (A6:=amigaguidebase) BUT ASM ' jsr -36(a6)'
MACRO UnlockAmigaGuideBase(key) IS (D0:=key) BUT (A6:=amigaguidebase) BUT ASM ' jsr -42(a6)'
MACRO OpenAmigaGuideA(nag,x) IS Stores(amigaguidebase,nag,x) BUT Loads(A6,A0,A1) BUT ASM ' jsr -54(a6)'
MACRO OpenAmigaGuideAsyncA(nag,attrs) IS Stores(amigaguidebase,nag,attrs) BUT Loads(A6,A0,D0) BUT ASM ' jsr -60(a6)'
MACRO CloseAmigaGuide(cl) IS (A0:=cl) BUT (A6:=amigaguidebase) BUT ASM ' jsr -66(a6)'
MACRO AmigaGuideSignal(cl) IS (A0:=cl) BUT (A6:=amigaguidebase) BUT ASM ' jsr -72(a6)'
MACRO GetAmigaGuideMsg(cl) IS (A0:=cl) BUT (A6:=amigaguidebase) BUT ASM ' jsr -78(a6)'
MACRO ReplyAmigaGuideMsg(amsg) IS (A0:=amsg) BUT (A6:=amigaguidebase) BUT ASM ' jsr -84(a6)'
MACRO SetAmigaGuideContextA(cl,id,attrs) IS Stores(amigaguidebase,cl,id,attrs) BUT Loads(A6,A0,D0,D1) BUT ASM ' jsr -90(a6)'
MACRO SendAmigaGuideContextA(cl,attrs) IS Stores(amigaguidebase,cl,attrs) BUT Loads(A6,A0,D0) BUT ASM ' jsr -96(a6)'
MACRO SendAmigaGuideCmdA(cl,cmd,attrs) IS Stores(amigaguidebase,cl,cmd,attrs) BUT Loads(A6,A0,D0,D1) BUT ASM ' jsr -102(a6)'
MACRO SetAmigaGuideAttrsA(cl,attrs) IS Stores(amigaguidebase,cl,attrs) BUT Loads(A6,A0,A1) BUT ASM ' jsr -108(a6)'
MACRO GetAmigaGuideAttr(tag,cl,storage) IS Stores(amigaguidebase,tag,cl,storage) BUT Loads(A6,D0,A0,A1) BUT ASM ' jsr -114(a6)'
MACRO LoadXRef(lock,name) IS Stores(amigaguidebase,lock,name) BUT Loads(A6,A0,A1) BUT ASM ' jsr -126(a6)'
MACRO ExpungeXRef() IS (A6:=amigaguidebase) BUT ASM ' jsr -132(a6)'
MACRO AddAmigaGuideHostA(h,name,attrs) IS Stores(amigaguidebase,h,name,attrs) BUT Loads(A6,A0,D0,A1) BUT ASM ' jsr -138(a6)'
MACRO RemoveAmigaGuideHostA(hh,attrs) IS Stores(amigaguidebase,hh,attrs) BUT Loads(A6,A0,A1) BUT ASM ' jsr -144(a6)'
MACRO GetAmigaGuideString(id) IS (D0:=id) BUT (A6:=amigaguidebase) BUT ASM ' jsr -210(a6)'
