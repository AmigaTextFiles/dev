OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
-> --- functions in V36 or higher (Release 2.0) ---
-> 
->  Basic functions
-> 
MACRO AllocIFF() IS (A6:=iffparsebase) BUT ASM ' jsr -30(a6)'
MACRO OpenIFF(iff,rwMode) IS Stores(iffparsebase,iff,rwMode) BUT Loads(A6,A0,D0) BUT ASM ' jsr -36(a6)'
MACRO ParseIFF(iff,control) IS Stores(iffparsebase,iff,control) BUT Loads(A6,A0,D0) BUT ASM ' jsr -42(a6)'
MACRO CloseIFF(iff) IS (A0:=iff) BUT (A6:=iffparsebase) BUT ASM ' jsr -48(a6)'
MACRO FreeIFF(iff) IS (A0:=iff) BUT (A6:=iffparsebase) BUT ASM ' jsr -54(a6)'
-> 
->  Read/Write functions
-> 
MACRO ReadChunkBytes(iff,buf,numBytes) IS Stores(iffparsebase,iff,buf,numBytes) BUT Loads(A6,A0,A1,D0) BUT ASM ' jsr -60(a6)'
MACRO WriteChunkBytes(iff,buf,numBytes) IS Stores(iffparsebase,iff,buf,numBytes) BUT Loads(A6,A0,A1,D0) BUT ASM ' jsr -66(a6)'
MACRO ReadChunkRecords(iff,buf,bytesPerRecord,numRecords) IS Stores(iffparsebase,iff,buf,bytesPerRecord,numRecords) BUT Loads(A6,A0,A1,D0,D1) BUT ASM ' jsr -72(a6)'
MACRO WriteChunkRecords(iff,buf,bytesPerRecord,numRecords) IS Stores(iffparsebase,iff,buf,bytesPerRecord,numRecords) BUT Loads(A6,A0,A1,D0,D1) BUT ASM ' jsr -78(a6)'
-> 
->  Context entry/exit
-> 
MACRO PushChunk(iff,type,id,size) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(iffparsebase,iff,type,id,size) BUT Loads(A6,A0,D0,D1,D2) BUT ASM ' jsr -84(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO PopChunk(iff) IS (A0:=iff) BUT (A6:=iffparsebase) BUT ASM ' jsr -90(a6)'
-> --- (1 function slot reserved here) ---
-> 
->  Low-level handler installation
-> 
MACRO EntryHandler(iff,type,id,position,handler,object) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(iffparsebase,iff,type,id,position,handler,object) BUT Loads(A6,A0,D0,D1,D2,A1,A2) BUT ASM ' jsr -102(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO ExitHandler(iff,type,id,position,handler,object) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(iffparsebase,iff,type,id,position,handler,object) BUT Loads(A6,A0,D0,D1,D2,A1,A2) BUT ASM ' jsr -108(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
-> 
->  Built-in chunk/property handlers
-> 
MACRO PropChunk(iff,type,id) IS Stores(iffparsebase,iff,type,id) BUT Loads(A6,A0,D0,D1) BUT ASM ' jsr -114(a6)'
MACRO PropChunks(iff,propArray,numPairs) IS Stores(iffparsebase,iff,propArray,numPairs) BUT Loads(A6,A0,A1,D0) BUT ASM ' jsr -120(a6)'
MACRO StopChunk(iff,type,id) IS Stores(iffparsebase,iff,type,id) BUT Loads(A6,A0,D0,D1) BUT ASM ' jsr -126(a6)'
MACRO StopChunks(iff,propArray,numPairs) IS Stores(iffparsebase,iff,propArray,numPairs) BUT Loads(A6,A0,A1,D0) BUT ASM ' jsr -132(a6)'
MACRO CollectionChunk(iff,type,id) IS Stores(iffparsebase,iff,type,id) BUT Loads(A6,A0,D0,D1) BUT ASM ' jsr -138(a6)'
MACRO CollectionChunks(iff,propArray,numPairs) IS Stores(iffparsebase,iff,propArray,numPairs) BUT Loads(A6,A0,A1,D0) BUT ASM ' jsr -144(a6)'
MACRO StopOnExit(iff,type,id) IS Stores(iffparsebase,iff,type,id) BUT Loads(A6,A0,D0,D1) BUT ASM ' jsr -150(a6)'
-> 
->  Context utilities
-> 
MACRO FindProp(iff,type,id) IS Stores(iffparsebase,iff,type,id) BUT Loads(A6,A0,D0,D1) BUT ASM ' jsr -156(a6)'
MACRO FindCollection(iff,type,id) IS Stores(iffparsebase,iff,type,id) BUT Loads(A6,A0,D0,D1) BUT ASM ' jsr -162(a6)'
MACRO FindPropContext(iff) IS (A0:=iff) BUT (A6:=iffparsebase) BUT ASM ' jsr -168(a6)'
MACRO CurrentChunk(iff) IS (A0:=iff) BUT (A6:=iffparsebase) BUT ASM ' jsr -174(a6)'
MACRO ParentChunk(contextNode) IS (A0:=contextNode) BUT (A6:=iffparsebase) BUT ASM ' jsr -180(a6)'
-> 
->  LocalContextItem support functions
-> 
MACRO AllocLocalItem(type,id,ident,dataSize) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(iffparsebase,type,id,ident,dataSize) BUT Loads(A6,D0,D1,D2,D3) BUT ASM ' jsr -186(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO LocalItemData(localItem) IS (A0:=localItem) BUT (A6:=iffparsebase) BUT ASM ' jsr -192(a6)'
MACRO SetLocalItemPurge(localItem,purgeHook) IS Stores(iffparsebase,localItem,purgeHook) BUT Loads(A6,A0,A1) BUT ASM ' jsr -198(a6)'
MACRO FreeLocalItem(localItem) IS (A0:=localItem) BUT (A6:=iffparsebase) BUT ASM ' jsr -204(a6)'
MACRO FindLocalItem(iff,type,id,ident) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(iffparsebase,iff,type,id,ident) BUT Loads(A6,A0,D0,D1,D2) BUT ASM ' jsr -210(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO StoreLocalItem(iff,localItem,position) IS Stores(iffparsebase,iff,localItem,position) BUT Loads(A6,A0,A1,D0) BUT ASM ' jsr -216(a6)'
MACRO StoreItemInContext(iff,localItem,contextNode) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(iffparsebase,iff,localItem,contextNode) BUT Loads(A6,A0,A1,A2) BUT ASM ' jsr -222(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
-> 
->  IFFHandle initialization
-> 
MACRO InitIFF(iff,flags,streamHook) IS Stores(iffparsebase,iff,flags,streamHook) BUT Loads(A6,A0,D0,A1) BUT ASM ' jsr -228(a6)'
MACRO InitIFFasDOS(iff) IS (A0:=iff) BUT (A6:=iffparsebase) BUT ASM ' jsr -234(a6)'
MACRO InitIFFasClip(iff) IS (A0:=iff) BUT (A6:=iffparsebase) BUT ASM ' jsr -240(a6)'
-> 
->  Internal clipboard support
-> 
MACRO OpenClipboard(unitNumber) IS (D0:=unitNumber) BUT (A6:=iffparsebase) BUT ASM ' jsr -246(a6)'
MACRO CloseClipboard(clipHandle) IS (A0:=clipHandle) BUT (A6:=iffparsebase) BUT ASM ' jsr -252(a6)'
-> 
->  Miscellaneous
-> 
MACRO GoodID(id) IS (D0:=id) BUT (A6:=iffparsebase) BUT ASM ' jsr -258(a6)'
MACRO GoodType(type) IS (D0:=type) BUT (A6:=iffparsebase) BUT ASM ' jsr -264(a6)'
MACRO IDtoStr(id,buf) IS Stores(iffparsebase,id,buf) BUT Loads(A6,D0,A0) BUT ASM ' jsr -270(a6)'
