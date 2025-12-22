OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
-> --- functions in V40 or higher (Release 3.1) ---
-> 
->  Public entries
-> 
MACRO ObtainDataTypeA(type,handle,attrs) IS Stores(datatypesbase,type,handle,attrs) BUT Loads(A6,D0,A0,A1) BUT ASM ' jsr -36(a6)'
MACRO ReleaseDataType(dt) IS (A0:=dt) BUT (A6:=datatypesbase) BUT ASM ' jsr -42(a6)'
MACRO NewDTObjectA(name,attrs) IS Stores(datatypesbase,name,attrs) BUT Loads(A6,D0,A0) BUT ASM ' jsr -48(a6)'
MACRO DisposeDTObject(o) IS (A0:=o) BUT (A6:=datatypesbase) BUT ASM ' jsr -54(a6)'
MACRO SetDTAttrsA(o,win,req,attrs) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(datatypesbase,o,win,req,attrs) BUT Loads(A6,A0,A1,A2,A3) BUT ASM ' jsr -60(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO GetDTAttrsA(o,attrs) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(datatypesbase,o,attrs) BUT Loads(A6,A0,A2) BUT ASM ' jsr -66(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO AddDTObject(win,req,o,pos) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(datatypesbase,win,req,o,pos) BUT Loads(A6,A0,A1,A2,D0) BUT ASM ' jsr -72(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO RefreshDTObjectA(o,win,req,attrs) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(datatypesbase,o,win,req,attrs) BUT Loads(A6,A0,A1,A2,A3) BUT ASM ' jsr -78(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO DoAsyncLayout(o,gpl) IS Stores(datatypesbase,o,gpl) BUT Loads(A6,A0,A1) BUT ASM ' jsr -84(a6)'
MACRO DoDTMethodA(o,win,req,msg) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(datatypesbase,o,win,req,msg) BUT Loads(A6,A0,A1,A2,A3) BUT ASM ' jsr -90(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO RemoveDTObject(win,o) IS Stores(datatypesbase,win,o) BUT Loads(A6,A0,A1) BUT ASM ' jsr -96(a6)'
MACRO GetDTMethods(object) IS (A0:=object) BUT (A6:=datatypesbase) BUT ASM ' jsr -102(a6)'
MACRO GetDTTriggerMethods(object) IS (A0:=object) BUT (A6:=datatypesbase) BUT ASM ' jsr -108(a6)'
MACRO PrintDTObjectA(o,w,r,msg) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(datatypesbase,o,w,r,msg) BUT Loads(A6,A0,A1,A2,A3) BUT ASM ' jsr -114(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO GetDTString(id) IS (D0:=id) BUT (A6:=datatypesbase) BUT ASM ' jsr -138(a6)'
