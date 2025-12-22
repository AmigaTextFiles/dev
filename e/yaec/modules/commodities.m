OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
-> --- functions in V36 or higher (Release 2.0) ---
-> 
->   OBJECT UTILITIES
-> 
MACRO CreateCxObj(type,arg1,arg2) IS Stores(cxbase,type,arg1,arg2) BUT Loads(A6,D0,A0,A1) BUT ASM ' jsr -30(a6)'
MACRO CxBroker(nb,error) IS Stores(cxbase,nb,error) BUT Loads(A6,A0,D0) BUT ASM ' jsr -36(a6)'
MACRO ActivateCxObj(co,true) IS Stores(cxbase,co,true) BUT Loads(A6,A0,D0) BUT ASM ' jsr -42(a6)'
MACRO DeleteCxObj(co) IS (A0:=co) BUT (A6:=cxbase) BUT ASM ' jsr -48(a6)'
MACRO DeleteCxObjAll(co) IS (A0:=co) BUT (A6:=cxbase) BUT ASM ' jsr -54(a6)'
MACRO CxObjType(co) IS (A0:=co) BUT (A6:=cxbase) BUT ASM ' jsr -60(a6)'
MACRO CxObjError(co) IS (A0:=co) BUT (A6:=cxbase) BUT ASM ' jsr -66(a6)'
MACRO ClearCxObjError(co) IS (A0:=co) BUT (A6:=cxbase) BUT ASM ' jsr -72(a6)'
MACRO SetCxObjPri(co,pri) IS Stores(cxbase,co,pri) BUT Loads(A6,A0,D0) BUT ASM ' jsr -78(a6)'
-> 
->   OBJECT ATTACHMENT
-> 
MACRO AttachCxObj(headObj,co) IS Stores(cxbase,headObj,co) BUT Loads(A6,A0,A1) BUT ASM ' jsr -84(a6)'
MACRO EnqueueCxObj(headObj,co) IS Stores(cxbase,headObj,co) BUT Loads(A6,A0,A1) BUT ASM ' jsr -90(a6)'
MACRO InsertCxObj(headObj,co,pred) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(cxbase,headObj,co,pred) BUT Loads(A6,A0,A1,A2) BUT ASM ' jsr -96(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO RemoveCxObj(co) IS (A0:=co) BUT (A6:=cxbase) BUT ASM ' jsr -102(a6)'
-> 
->   TYPE SPECIFIC
-> 
MACRO SetTranslate(translator,events) IS Stores(cxbase,translator,events) BUT Loads(A6,A0,A1) BUT ASM ' jsr -114(a6)'
MACRO SetFilter(filter,text) IS Stores(cxbase,filter,text) BUT Loads(A6,A0,A1) BUT ASM ' jsr -120(a6)'
MACRO SetFilterIX(filter,ix) IS Stores(cxbase,filter,ix) BUT Loads(A6,A0,A1) BUT ASM ' jsr -126(a6)'
MACRO ParseIX(description,ix) IS Stores(cxbase,description,ix) BUT Loads(A6,A0,A1) BUT ASM ' jsr -132(a6)'
-> 
->   COMMON MESSAGE
-> 
MACRO CxMsgType(cxm) IS (A0:=cxm) BUT (A6:=cxbase) BUT ASM ' jsr -138(a6)'
MACRO CxMsgData(cxm) IS (A0:=cxm) BUT (A6:=cxbase) BUT ASM ' jsr -144(a6)'
MACRO CxMsgID(cxm) IS (A0:=cxm) BUT (A6:=cxbase) BUT ASM ' jsr -150(a6)'
-> 
->   MESSAGE ROUTING
-> 
MACRO DivertCxMsg(cxm,headObj,returnObj) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(cxbase,cxm,headObj,returnObj) BUT Loads(A6,A0,A1,A2) BUT ASM ' jsr -156(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO RouteCxMsg(cxm,co) IS Stores(cxbase,cxm,co) BUT Loads(A6,A0,A1) BUT ASM ' jsr -162(a6)'
MACRO DisposeCxMsg(cxm) IS (A0:=cxm) BUT (A6:=cxbase) BUT ASM ' jsr -168(a6)'
-> 
->   INPUT EVENT HANDLING
-> 
MACRO InvertKeyMap(ansiCode,event,km) IS Stores(cxbase,ansiCode,event,km) BUT Loads(A6,D0,A0,A1) BUT ASM ' jsr -174(a6)'
MACRO AddIEvents(events) IS (A0:=events) BUT (A6:=cxbase) BUT ASM ' jsr -180(a6)'
-> --- functions in V38 or higher (Release 2.1) ---
->   MORE INPUT EVENT HANDLING
MACRO MatchIX(event,ix) IS Stores(cxbase,event,ix) BUT Loads(A6,A0,A1) BUT ASM ' jsr -204(a6)'
