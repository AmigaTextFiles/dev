OPT NATIVE
PUBLIC MODULE 'target/libraries/mui', 'target/libraries/muip'
MODULE 'target/exec/libraries', 'target/exec/types', 'target/intuition/classes', 'target/utility/tagitem', 'target/intuition/classusr', 'target/graphics/regions'
{MODULE 'muimaster'}

NATIVE {muimasterbase} DEF muimasterbase:NATIVE {LONG} PTR TO lib		->AmigaE does not automatically initialise this

/****************************************/
/* functions to be used in applications */
/****************************************/

NATIVE {Mui_NewObjectA} PROC
PROC Mui_NewObjectA(classname:ARRAY OF CHAR,tags:ARRAY OF tagitem) IS NATIVE {Mui_NewObjectA(} classname {,} tags {)} ENDNATIVE !!PTR TO INTUIOBJECT
->NATIVE {Mui_NewObject} PROC
->PROC MuI_NewObject(classname:ARRAY OF CHAR,tag1:TAG,tag12=0:ULONG, tag13=0:ULONG, tag14=0:ULONG, tag15=0:ULONG, tag16=0:ULONG, tag17=0:ULONG, tag18=0:ULONG) IS NATIVE {Mui_NewObject(} classname {,} tag1 {,} tag12 {,} tag13 {,} tag14 {,} tag15 {,} tag16 {,} tag17 {,} tag18 {)} ENDNATIVE !!PTR TO INTUIOBJECT
NATIVE {Mui_MakeObjectA} PROC
PROC Mui_MakeObjectA(type:VALUE,params:ARRAY OF tagitem) IS NATIVE {Mui_MakeObjectA(} type {,} params {)} ENDNATIVE !!PTR TO INTUIOBJECT
->NATIVE {Mui_MakeObject} PROC
->PROC MuI_MakeObject(type:VALUE,type2=0:ULONG, type3=0:ULONG, type4=0:ULONG, type5=0:ULONG, type6=0:ULONG, type7=0:ULONG, type8=0:ULONG) IS NATIVE {Mui_MakeObject(} type {,} type2 {,} type3 {,} type4 {,} type5 {,} type6 {,} type7 {,} type8 {)} ENDNATIVE !!PTR TO INTUIOBJECT
NATIVE {Mui_DisposeObject} PROC
PROC Mui_DisposeObject(obj:PTR TO INTUIOBJECT) IS NATIVE {Mui_DisposeObject(} obj {)} ENDNATIVE
NATIVE {Mui_RequestA} PROC
PROC Mui_RequestA(app:APTR,win:APTR,flags:LONGBITS,title:ARRAY OF CHAR,gadgets:ARRAY OF CHAR,format:ARRAY OF CHAR,params:APTR) IS NATIVE {Mui_RequestA(} app {,} win {,} flags {,} title {,} gadgets {,} format {,} params {)} ENDNATIVE !!VALUE
->NATIVE {Mui_Request} PROC
->PROC MuI_Request(app:APTR,win:APTR,flags:LONGBITS,title:ARRAY OF CHAR,gadgets:ARRAY OF CHAR,format:ARRAY OF CHAR,format2=0:ULONG, format3=0:ULONG, format4=0:ULONG, format5=0:ULONG, format6=0:ULONG, format7=0:ULONG, format8=0:ULONG) IS NATIVE {Mui_Request(} app {,} win {,} flags {,} title {,} gadgets {,} format {,} format2 {,} format3 {,} format4 {,} format5 {,} format6 {,} format7 {,} format8 {)} ENDNATIVE !!VALUE
NATIVE {Mui_Error} PROC
PROC Mui_Error() IS NATIVE {Mui_Error()} ENDNATIVE !!VALUE
NATIVE {Mui_AllocAslRequest} PROC
PROC Mui_AllocAslRequest(reqType:ULONG, tagList:ARRAY OF tagitem) IS NATIVE {Mui_AllocAslRequest(} reqType {,} tagList {)} ENDNATIVE !!APTR2
->NATIVE {Mui_AllocAslRequestTags} PROC
->PROC MuI_AllocAslRequestTags(reqType:ULONG, Tag1:TAG, Tag12=0:ULONG, Tag13=0:ULONG, Tag14=0:ULONG, Tag15=0:ULONG, Tag16=0:ULONG, Tag17=0:ULONG, Tag18=0:ULONG) IS NATIVE {Mui_AllocAslRequestTags(} reqType {,} Tag1 {,} Tag12 {,} Tag13 {,} Tag14 {,} Tag15 {,} Tag16 {,} Tag17 {,} Tag18 {)} ENDNATIVE !!APTR2
NATIVE {Mui_FreeAslRequest} PROC
PROC Mui_FreeAslRequest(requester:APTR2 ) IS NATIVE {Mui_FreeAslRequest(} requester {)} ENDNATIVE
NATIVE {Mui_AslRequest} PROC
PROC Mui_AslRequest(requester:APTR2, tagList:ARRAY OF tagitem) IS NATIVE {-Mui_AslRequest(} requester {,} tagList {)} ENDNATIVE !!INT
->NATIVE {Mui_AslRequestTags} PROC
->PROC MuI_AslRequestTags(requester:APTR2, Tag1:TAG, Tag12=0:ULONG, Tag13=0:ULONG, Tag14=0:ULONG, Tag15=0:ULONG, Tag16=0:ULONG, Tag17=0:ULONG, Tag18=0:ULONG) IS NATIVE {-Mui_AslRequestTags(} requester {,} Tag1 {,} Tag12 {,} Tag13 {,} Tag14 {,} Tag15 {,} Tag16 {,} Tag17 {,} Tag18 {)} ENDNATIVE !!INT

/******************************************/
/* functions to be used in custom classes */
/******************************************/

NATIVE {Mui_SetError} PROC
PROC Mui_SetError(num:VALUE) IS NATIVE {Mui_SetError(} num {)} ENDNATIVE !!VALUE
NATIVE {Mui_GetClass} PROC
PROC Mui_GetClass(classname:ARRAY OF CHAR) IS NATIVE {Mui_GetClass(} classname {)} ENDNATIVE !!PTR TO iclass
NATIVE {Mui_FreeClass} PROC
PROC Mui_FreeClass(classptr:PTR TO iclass) IS NATIVE {Mui_FreeClass(} classptr {)} ENDNATIVE
NATIVE {Mui_RequestIDCMP} PROC
PROC Mui_RequestIDCMP(obj:PTR TO INTUIOBJECT,flags:ULONG) IS NATIVE {Mui_RequestIDCMP(} obj {,} flags {)} ENDNATIVE
NATIVE {Mui_RejectIDCMP} PROC
PROC Mui_RejectIDCMP(obj:PTR TO INTUIOBJECT,flags:ULONG) IS NATIVE {Mui_RejectIDCMP(} obj {,} flags {)} ENDNATIVE
NATIVE {Mui_Redraw} PROC
PROC Mui_Redraw(obj:PTR TO INTUIOBJECT,flags:ULONG) IS NATIVE {Mui_Redraw(} obj {,} flags {)} ENDNATIVE
NATIVE {Mui_AddClipping} PROC
PROC Mui_AddClipping(mri:PTR TO mui_renderinfo,left:INT,top:INT,width:INT,height:INT) IS NATIVE {Mui_AddClipping(} mri {,} left {,} top {,} width {,} height {)} ENDNATIVE !!APTR
NATIVE {Mui_RemoveClipping} PROC
PROC Mui_RemoveClipping(mri:PTR TO mui_renderinfo,handle:APTR) IS NATIVE {Mui_RemoveClipping(} mri {,} handle {)} ENDNATIVE
NATIVE {Mui_AddClipRegion} PROC
PROC Mui_AddClipRegion(mri:PTR TO mui_renderinfo,r:PTR TO region) IS NATIVE {Mui_AddClipRegion(} mri {,} r {)} ENDNATIVE !!APTR
NATIVE {Mui_RemoveClipRegion} PROC
PROC Mui_RemoveClipRegion(mri:PTR TO mui_renderinfo,handle:APTR) IS NATIVE {Mui_RemoveClipRegion(} mri {,} handle {)} ENDNATIVE
NATIVE {Mui_BeginRefresh} PROC
PROC Mui_BeginRefresh(mri:PTR TO mui_renderinfo,flags:ULONG) IS NATIVE {-Mui_BeginRefresh(} mri {,} flags {)} ENDNATIVE !!INT
NATIVE {Mui_EndRefresh} PROC
PROC Mui_EndRefresh(mri:PTR TO mui_renderinfo,flags:ULONG) IS NATIVE {Mui_EndRefresh(} mri {,} flags {)} ENDNATIVE
NATIVE {Mui_CreateCustomClass} PROC
PROC Mui_CreateCustomClass(base:PTR TO lib,supername:ARRAY OF CHAR,supermcc:PTR TO mui_customclass,datasize:VALUE,dispatcher:PTR) IS NATIVE {Mui_CreateCustomClass(} base {,} supername {,} supermcc {,} datasize {,} dispatcher {)} ENDNATIVE !!PTR TO mui_customclass
NATIVE {Mui_DeleteCustomClass} PROC
PROC Mui_DeleteCustomClass(mcc:PTR TO mui_customclass) IS NATIVE {-Mui_DeleteCustomClass(} mcc {)} ENDNATIVE !!INT
NATIVE {Mui_ObtainPen} PROC
PROC Mui_ObtainPen(mri:PTR TO mui_renderinfo,spec:PTR TO mui_penspec,flags:ULONG) IS NATIVE {Mui_ObtainPen(} mri {,} spec {,} flags {)} ENDNATIVE !!VALUE
NATIVE {Mui_ReleasePen} PROC
PROC Mui_ReleasePen(mri:PTR TO mui_renderinfo,pen:VALUE) IS NATIVE {Mui_ReleasePen(} mri {,} pen {)} ENDNATIVE

/*************************************************************/
/* layout function, use only in custom layout callback hook! */
/*************************************************************/

NATIVE {Mui_Layout} PROC
PROC Mui_Layout(obj:PTR TO INTUIOBJECT,left:VALUE,top:VALUE,width:VALUE,height:VALUE,flags:ULONG) IS NATIVE {-Mui_Layout(} obj {,} left {,} top {,} width {,} height {,} flags {)} ENDNATIVE !!INT
