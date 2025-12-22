OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
MACRO FreeFreeList(freelist) IS (A0:=freelist) BUT (A6:=iconbase) BUT ASM ' jsr -54(a6)'
MACRO AddFreeList(freelist,mem,size) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(iconbase,freelist,mem,size) BUT Loads(A6,A0,A1,A2) BUT ASM ' jsr -72(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO GetDiskObject(name) IS (A0:=name) BUT (A6:=iconbase) BUT ASM ' jsr -78(a6)'
MACRO PutDiskObject(name,diskobj) IS Stores(iconbase,name,diskobj) BUT Loads(A6,A0,A1) BUT ASM ' jsr -84(a6)'
MACRO FreeDiskObject(diskobj) IS (A0:=diskobj) BUT (A6:=iconbase) BUT ASM ' jsr -90(a6)'
MACRO FindToolType(toolTypeArray,typeName) IS Stores(iconbase,toolTypeArray,typeName) BUT Loads(A6,A0,A1) BUT ASM ' jsr -96(a6)'
MACRO MatchToolValue(typeString,value) IS Stores(iconbase,typeString,value) BUT Loads(A6,A0,A1) BUT ASM ' jsr -102(a6)'
MACRO BumpRevision(newname,oldname) IS Stores(iconbase,newname,oldname) BUT Loads(A6,A0,A1) BUT ASM ' jsr -108(a6)'
-> --- functions in V36 or higher (Release 2.0) ---
MACRO GetDefDiskObject(type) IS (D0:=type) BUT (A6:=iconbase) BUT ASM ' jsr -120(a6)'
MACRO PutDefDiskObject(diskObject) IS (A0:=diskObject) BUT (A6:=iconbase) BUT ASM ' jsr -126(a6)'
MACRO GetDiskObjectNew(name) IS (A0:=name) BUT (A6:=iconbase) BUT ASM ' jsr -132(a6)'
-> --- functions in V37 or higher (Release 2.04) ---
MACRO DeleteDiskObject(name) IS (A0:=name) BUT (A6:=iconbase) BUT ASM ' jsr -138(a6)'
-> --- (4 function slots reserved here) ---
