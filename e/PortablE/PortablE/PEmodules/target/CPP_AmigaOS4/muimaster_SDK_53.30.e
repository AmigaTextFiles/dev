OPT NATIVE
PUBLIC MODULE 'target/libraries/mui'
MODULE 'target/exec/types', 'target/intuition/classes', 'target/utility/tagitem'
MODULE 'target/PEalias/exec', 'target/exec/libraries', 'target/intuition/classusr', 'target/graphics/regions'
{
#include <proto/muimaster.h>
}
{
struct Library* MUIMasterBase = NULL;
struct MUIMasterIFace* IMUIMaster = NULL;
}
NATIVE {CLIB_MUIMASTER_PROTOS_H} CONST
NATIVE {PROTO_MUIMASTER_H} CONST
NATIVE {MUIMASTER_INTERFACE_DEF_H} CONST

NATIVE {MUIMasterBase} DEF muimasterbase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IMUIMaster} DEF

PROC new()
	InitLibrary('muimaster.library', NATIVE {(struct Interface **) &IMUIMaster} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

/****************************************/
/* functions to be used in applications */
/****************************************/

->NATIVE {MUI_NewObjectA} PROC
PROC Mui_NewObjectA(classname:ARRAY OF CHAR,tags:ARRAY OF tagitem) IS NATIVE {IMUIMaster->MUI_NewObjectA(} classname {,} tags {)} ENDNATIVE !!PTR TO INTUIOBJECT
->NATIVE {MUI_NewObject} PROC
PROC Mui_NewObject(classname:ARRAY OF CHAR,tag1:TAG,tag2=0:ULONG, ...) IS NATIVE {IMUIMaster->MUI_NewObject(} classname {,} tag1 {,} tag2 {,} ... {)} ENDNATIVE !!PTR TO INTUIOBJECT
->NATIVE {MUI_MakeObjectA} PROC
PROC Mui_MakeObjectA(type:VALUE,params:ARRAY OF tagitem) IS NATIVE {IMUIMaster->MUI_MakeObjectA(} type {, (ULONG*)} params {)} ENDNATIVE !!PTR TO INTUIOBJECT
->NATIVE {MUI_MakeObject} PROC
PROC Mui_MakeObject(type:VALUE,type2=0:ULONG, ...) IS NATIVE {IMUIMaster->MUI_MakeObject(} type {,} type2 {,} ... {)} ENDNATIVE !!PTR TO INTUIOBJECT
->NATIVE {MUI_DisposeObject} PROC
PROC Mui_DisposeObject(obj:PTR TO INTUIOBJECT) IS NATIVE {IMUIMaster->MUI_DisposeObject(} obj {)} ENDNATIVE
->NATIVE {MUI_RequestA} PROC
PROC Mui_RequestA(app:APTR,win:APTR,flags:LONGBITS,title:ARRAY OF CHAR,gadgets:ARRAY OF CHAR,format:ARRAY OF CHAR,params:APTR) IS NATIVE {IMUIMaster->MUI_RequestA(} app {,} win {,} flags {,} title {,} gadgets {,} format {,} params {)} ENDNATIVE !!VALUE
->NATIVE {MUI_Request} PROC
PROC Mui_Request(app:APTR,win:APTR,flags:LONGBITS,title:ARRAY OF CHAR,gadgets:ARRAY OF CHAR,format:ARRAY OF CHAR,format2=0:ULONG, ...) IS NATIVE {IMUIMaster->MUI_Request(} app {,} win {,} flags {,} title {,} gadgets {,} format {,} format2 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {MUI_Error} PROC
PROC Mui_Error() IS NATIVE {IMUIMaster->MUI_Error()} ENDNATIVE !!VALUE
->NATIVE {MUI_AllocAslRequest} PROC
PROC Mui_AllocAslRequest(reqType:ULONG, tagList:ARRAY OF tagitem) IS NATIVE {IMUIMaster->MUI_AllocAslRequest(} reqType {,} tagList {)} ENDNATIVE !!APTR2
->NATIVE {MUI_AllocAslRequestTags} PROC
PROC Mui_AllocAslRequestTags(reqType:ULONG, Tag1:TAG, Tag2=0:ULONG, ...) IS NATIVE {IMUIMaster->MUI_AllocAslRequestTags(} reqType {,} Tag1 {,} Tag2 {,} ... {)} ENDNATIVE !!APTR2
->NATIVE {MUI_FreeAslRequest} PROC
PROC Mui_FreeAslRequest(requester:APTR2 ) IS NATIVE {IMUIMaster->MUI_FreeAslRequest(} requester {)} ENDNATIVE
->NATIVE {MUI_AslRequest} PROC
PROC Mui_AslRequest(requester:APTR2, tagList:ARRAY OF tagitem) IS NATIVE {-IMUIMaster->MUI_AslRequest(} requester {,} tagList {)} ENDNATIVE !!INT
->NATIVE {MUI_AslRequestTags} PROC
PROC Mui_AslRequestTags(requester:APTR2, Tag1:TAG, Tag2=0:ULONG, ...) IS NATIVE {-IMUIMaster->MUI_AslRequestTags(} requester {,} Tag1 {,} Tag2 {,} ... {)} ENDNATIVE !!INT

/******************************************/
/* functions to be used in custom classes */
/******************************************/

->NATIVE {MUI_SetError} PROC
PROC Mui_SetError(num:VALUE) IS NATIVE {IMUIMaster->MUI_SetError(} num {)} ENDNATIVE !!VALUE
->NATIVE {MUI_GetClass} PROC
PROC Mui_GetClass(classname:ARRAY OF CHAR) IS NATIVE {IMUIMaster->MUI_GetClass(} classname {)} ENDNATIVE !!PTR TO iclass
->NATIVE {MUI_FreeClass} PROC
PROC Mui_FreeClass(classptr:PTR TO iclass) IS NATIVE {IMUIMaster->MUI_FreeClass(} classptr {)} ENDNATIVE
->NATIVE {MUI_RequestIDCMP} PROC
PROC Mui_RequestIDCMP(obj:PTR TO INTUIOBJECT,flags:ULONG) IS NATIVE {IMUIMaster->MUI_RequestIDCMP(} obj {,} flags {)} ENDNATIVE
->NATIVE {MUI_RejectIDCMP} PROC
PROC Mui_RejectIDCMP(obj:PTR TO INTUIOBJECT,flags:ULONG) IS NATIVE {IMUIMaster->MUI_RejectIDCMP(} obj {,} flags {)} ENDNATIVE
->NATIVE {MUI_Redraw} PROC
PROC Mui_Redraw(obj:PTR TO INTUIOBJECT,flags:ULONG) IS NATIVE {IMUIMaster->MUI_Redraw(} obj {,} flags {)} ENDNATIVE
->NATIVE {MUI_AddClipping} PROC
PROC Mui_AddClipping(mri:PTR TO mui_renderinfo,left:INT,top:INT,width:INT,height:INT) IS NATIVE {IMUIMaster->MUI_AddClipping(} mri {,} left {,} top {,} width {,} height {)} ENDNATIVE !!APTR
->NATIVE {MUI_RemoveClipping} PROC
PROC Mui_RemoveClipping(mri:PTR TO mui_renderinfo,handle:APTR) IS NATIVE {IMUIMaster->MUI_RemoveClipping(} mri {,} handle {)} ENDNATIVE
->NATIVE {MUI_AddClipRegion} PROC
PROC Mui_AddClipRegion(mri:PTR TO mui_renderinfo,r:PTR TO region) IS NATIVE {IMUIMaster->MUI_AddClipRegion(} mri {,} r {)} ENDNATIVE !!APTR
->NATIVE {MUI_RemoveClipRegion} PROC
PROC Mui_RemoveClipRegion(mri:PTR TO mui_renderinfo,handle:APTR) IS NATIVE {IMUIMaster->MUI_RemoveClipRegion(} mri {,} handle {)} ENDNATIVE
->NATIVE {MUI_BeginRefresh} PROC
PROC Mui_BeginRefresh(mri:PTR TO mui_renderinfo,flags:ULONG) IS NATIVE {-IMUIMaster->MUI_BeginRefresh(} mri {,} flags {)} ENDNATIVE !!INT
->NATIVE {MUI_EndRefresh} PROC
PROC Mui_EndRefresh(mri:PTR TO mui_renderinfo,flags:ULONG) IS NATIVE {IMUIMaster->MUI_EndRefresh(} mri {,} flags {)} ENDNATIVE
->NATIVE {MUI_CreateCustomClass} PROC
PROC Mui_CreateCustomClass(base:PTR TO lib,supername:ARRAY OF CHAR,supermcc:PTR TO mui_customclass,datasize:VALUE,dispatcher:APTR2) IS NATIVE {IMUIMaster->MUI_CreateCustomClass(} base {,} supername {,} supermcc {, (int) } datasize {,} dispatcher {)} ENDNATIVE !!PTR TO mui_customclass
->NATIVE {MUI_DeleteCustomClass} PROC
PROC Mui_DeleteCustomClass(mcc:PTR TO mui_customclass) IS NATIVE {-IMUIMaster->MUI_DeleteCustomClass(} mcc {)} ENDNATIVE !!INT
->NATIVE {MUI_ObtainPen} PROC
PROC Mui_ObtainPen(mri:PTR TO mui_renderinfo,spec:PTR TO mui_penspec,flags:ULONG) IS NATIVE {IMUIMaster->MUI_ObtainPen(} mri {,} spec {,} flags {)} ENDNATIVE !!VALUE
->NATIVE {MUI_ReleasePen} PROC
PROC Mui_ReleasePen(mri:PTR TO mui_renderinfo,pen:VALUE) IS NATIVE {IMUIMaster->MUI_ReleasePen(} mri {,} pen {)} ENDNATIVE

/*************************************************************/
/* layout function, use only in custom layout callback hook! */
/*************************************************************/

->NATIVE {MUI_Layout} PROC
PROC Mui_Layout(obj:PTR TO INTUIOBJECT,left:VALUE,top:VALUE,width:VALUE,height:VALUE,flags:ULONG) IS NATIVE {-IMUIMaster->MUI_Layout(} obj {,} left {,} top {,} width {,} height {,} flags {)} ENDNATIVE !!INT
