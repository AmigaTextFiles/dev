OPT MODULE
OPT EXPORT
OPT NODEFMODS

-> Module created with E:bin/fd2mod from YAECv2.5 package.
-> --- functions in V36 or higher (Release 2.0) ---
-> 
->  Tag item functions
-> 
MACRO FindTagItem(tagVal,tagList) IS Stores(utilitybase,tagVal,tagList) BUT Loads(A6,D0,A0) BUT ASM ' jsr -30(a6)'
MACRO GetTagData(tagValue,defaultVal,tagList) IS Stores(utilitybase,tagValue,defaultVal,tagList) BUT Loads(A6,D0,D1,A0) BUT ASM ' jsr -36(a6)'
MACRO PackBoolTags(initialFlags,tagList,boolMap) IS Stores(utilitybase,initialFlags,tagList,boolMap) BUT Loads(A6,D0,A0,A1) BUT ASM ' jsr -42(a6)'
MACRO NextTagItem(tagListPtr) IS (A0:=tagListPtr) BUT (A6:=utilitybase) BUT ASM ' jsr -48(a6)'
MACRO FilterTagChanges(changeList,originalList,apply) IS Stores(utilitybase,changeList,originalList,apply) BUT Loads(A6,A0,A1,D0) BUT ASM ' jsr -54(a6)'
MACRO MapTags(tagList,mapList,mapType) IS Stores(utilitybase,tagList,mapList,mapType) BUT Loads(A6,A0,A1,D0) BUT ASM ' jsr -60(a6)'
MACRO AllocateTagItems(numTags) IS (D0:=numTags) BUT (A6:=utilitybase) BUT ASM ' jsr -66(a6)'
MACRO CloneTagItems(tagList) IS (A0:=tagList) BUT (A6:=utilitybase) BUT ASM ' jsr -72(a6)'
MACRO FreeTagItems(tagList) IS (A0:=tagList) BUT (A6:=utilitybase) BUT ASM ' jsr -78(a6)'
MACRO RefreshTagItemClones(clone,original) IS Stores(utilitybase,clone,original) BUT Loads(A6,A0,A1) BUT ASM ' jsr -84(a6)'
MACRO TagInArray(tagValue,tagArray) IS Stores(utilitybase,tagValue,tagArray) BUT Loads(A6,D0,A0) BUT ASM ' jsr -90(a6)'
MACRO FilterTagItems(tagList,filterArray,logic) IS Stores(utilitybase,tagList,filterArray,logic) BUT Loads(A6,A0,A1,D0) BUT ASM ' jsr -96(a6)'
-> 
->  Hook functions
-> 
MACRO CallHookPkt(hook,object,paramPacket) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(utilitybase,hook,object,paramPacket) BUT Loads(A6,A0,A2,A1) BUT ASM ' jsr -102(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
-> --- (1 function slot reserved here) ---
-> 
->  Date functions
-> 
-> --- (1 function slot reserved here) ---
MACRO Amiga2Date(seconds,result) IS Stores(utilitybase,seconds,result) BUT Loads(A6,D0,A0) BUT ASM ' jsr -120(a6)'
MACRO Date2Amiga(date) IS (A0:=date) BUT (A6:=utilitybase) BUT ASM ' jsr -126(a6)'
MACRO CheckDate(date) IS (A0:=date) BUT (A6:=utilitybase) BUT ASM ' jsr -132(a6)'
-> 
->  32 bit integer muliply functions
-> 
MACRO SMult32(arg1,arg2) IS Stores(utilitybase,arg1,arg2) BUT Loads(A6,D0,D1) BUT ASM ' jsr -138(a6)'
MACRO UMult32(arg1,arg2) IS Stores(utilitybase,arg1,arg2) BUT Loads(A6,D0,D1) BUT ASM ' jsr -144(a6)'
-> 
->  32 bit integer division funtions. The quotient and the remainder are
->  returned respectively in d0 and d1
-> 
MACRO SDivMod32(dividend,divisor) IS Stores(utilitybase,dividend,divisor) BUT Loads(A6,D0,D1) BUT ASM ' jsr -150(a6)'
MACRO UDivMod32(dividend,divisor) IS Stores(utilitybase,dividend,divisor) BUT Loads(A6,D0,D1) BUT ASM ' jsr -156(a6)'
-> --- functions in V37 or higher (Release 2.04) ---
-> 
->  International string routines
-> 
MACRO Stricmp(string1,string2) IS Stores(utilitybase,string1,string2) BUT Loads(A6,A0,A1) BUT ASM ' jsr -162(a6)'
MACRO Strnicmp(string1,string2,length) IS Stores(utilitybase,string1,string2,length) BUT Loads(A6,A0,A1,D0) BUT ASM ' jsr -168(a6)'
MACRO ToUpper(character) IS (D0:=character) BUT (A6:=utilitybase) BUT ASM ' jsr -174(a6)'
MACRO ToLower(character) IS (D0:=character) BUT (A6:=utilitybase) BUT ASM ' jsr -180(a6)'
-> --- functions in V39 or higher (Release 3) ---
-> 
->  More tag Item functions
-> 
MACRO ApplyTagChanges(list,changeList) IS Stores(utilitybase,list,changeList) BUT Loads(A6,A0,A1) BUT ASM ' jsr -186(a6)'
-> --- (1 function slot reserved here) ---
-> 
->  64 bit integer muliply functions. The results are 64 bit quantities
->  returned in D0 and D1
-> 
MACRO SMult64(arg1,arg2) IS Stores(utilitybase,arg1,arg2) BUT Loads(A6,D0,D1) BUT ASM ' jsr -198(a6)'
MACRO UMult64(arg1,arg2) IS Stores(utilitybase,arg1,arg2) BUT Loads(A6,D0,D1) BUT ASM ' jsr -204(a6)'
-> 
->  Structure to Tag and Tag to Structure support routines
-> 
MACRO PackStructureTags(pack,packTable,tagList) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(utilitybase,pack,packTable,tagList) BUT Loads(A6,A0,A1,A2) BUT ASM ' jsr -210(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO UnpackStructureTags(pack,packTable,tagList) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(utilitybase,pack,packTable,tagList) BUT Loads(A6,A0,A1,A2) BUT ASM ' jsr -216(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
-> 
->  New, object-oriented NameSpaces
-> 
MACRO AddNamedObject(nameSpace,object) IS Stores(utilitybase,nameSpace,object) BUT Loads(A6,A0,A1) BUT ASM ' jsr -222(a6)'
MACRO AllocNamedObjectA(name,tagList) IS Stores(utilitybase,name,tagList) BUT Loads(A6,A0,A1) BUT ASM ' jsr -228(a6)'
MACRO AttemptRemNamedObject(object) IS (A0:=object) BUT (A6:=utilitybase) BUT ASM ' jsr -234(a6)'
MACRO FindNamedObject(nameSpace,name,lastObject) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(utilitybase,nameSpace,name,lastObject) BUT Loads(A6,A0,A1,A2) BUT ASM ' jsr -240(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO FreeNamedObject(object) IS (A0:=object) BUT (A6:=utilitybase) BUT ASM ' jsr -246(a6)'
MACRO NamedObjectName(object) IS (A0:=object) BUT (A6:=utilitybase) BUT ASM ' jsr -252(a6)'
MACRO ReleaseNamedObject(object) IS (A0:=object) BUT (A6:=utilitybase) BUT ASM ' jsr -258(a6)'
MACRO RemNamedObject(object,message) IS Stores(utilitybase,object,message) BUT Loads(A6,A0,A1) BUT ASM ' jsr -264(a6)'
-> 
->  Unique ID generator
-> 
MACRO GetUniqueID() IS (A6:=utilitybase) BUT ASM ' jsr -270(a6)'
-> 
-> --- (4 function slots reserved here) ---
-> 
