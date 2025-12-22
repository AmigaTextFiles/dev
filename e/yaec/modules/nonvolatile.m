OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
-> --- functions in V40 or higher (Release 3.1) ---
MACRO GetCopyNV(appName,itemName,killRequesters) IS Stores(nvbase,appName,itemName,killRequesters) BUT Loads(A6,A0,A1,D1) BUT ASM ' jsr -30(a6)'
MACRO FreeNVData(data) IS (A0:=data) BUT (A6:=nvbase) BUT ASM ' jsr -36(a6)'
MACRO StoreNV(appName,itemName,data,length,killRequesters) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(nvbase,appName,itemName,data,length,killRequesters) BUT Loads(A6,A0,A1,A2,D0,D1) BUT ASM ' jsr -42(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO DeleteNV(appName,itemName,killRequesters) IS Stores(nvbase,appName,itemName,killRequesters) BUT Loads(A6,A0,A1,D1) BUT ASM ' jsr -48(a6)'
MACRO GetNVInfo(killRequesters) IS (D1:=killRequesters) BUT (A6:=nvbase) BUT ASM ' jsr -54(a6)'
MACRO GetNVList(appName,killRequesters) IS Stores(nvbase,appName,killRequesters) BUT Loads(A6,A0,D1) BUT ASM ' jsr -60(a6)'
MACRO SetNVProtection(appName,itemName,mask,killRequesters) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(nvbase,appName,itemName,mask,killRequesters) BUT Loads(A6,A0,A1,D2,D1) BUT ASM ' jsr -66(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
