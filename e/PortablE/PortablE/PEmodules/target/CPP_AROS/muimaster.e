OPT NATIVE
PUBLIC MODULE 'target/libraries/mui'
MODULE 'target/aros/libcall', 'target/intuition/classes', 'target/intuition/classusr', 'target/utility/tagitem', 'target/graphics/regions'
MODULE 'target/exec/libraries', 'target/exec/types'
{
#include <proto/muimaster.h>
}
{
struct Library* MUIMasterBase = NULL;
}
NATIVE {CLIB_MUIMASTER_PROTOS_H} CONST
NATIVE {PROTO_MUIMASTER_H} CONST

NATIVE {MUIMasterBase} DEF muimasterbase:PTR TO lib		->AmigaE does not automatically initialise this


/* By default, disable the variadic stuff for zune, since it's not 
   very backward compatible */
->#ifndef MUIMASTER_YES_INLINE_STDARG
->#undef  MUIMASTER_NO_INLINE_STDARG
NATIVE {MUIMASTER_NO_INLINE_STDARG} CONST
->#endif

/* Prototypes for stubs in mui.lib */

NATIVE {MUI_AllocAslRequestTags} PROC
PROC Mui_AllocAslRequestTags(reqType:ULONG, tag1:TAG, Tag2=0:ULONG, ...) IS NATIVE {MUI_AllocAslRequestTags(} reqType {,} tag1 {,} Tag2 {,} ... {)} ENDNATIVE !!APTR2 
NATIVE {MUI_AslRequestTags} PROC
PROC Mui_AslRequestTags(requester:APTR2, tag1:TAG, Tag2=0:ULONG, ...) IS NATIVE {-MUI_AslRequestTags(} requester {,} tag1 {,} Tag2 {,} ... {)} ENDNATIVE !!INT 
NATIVE {MUI_MakeObject} PROC
PROC Mui_MakeObject(type:VALUE, type2=0:ULONG, ...) IS NATIVE {MUI_MakeObject(} type {,} type2 {,} ... {)} ENDNATIVE !!PTR TO INTUIOBJECT
NATIVE {MUI_NewObject} PROC
PROC Mui_NewObject(classname:ARRAY OF CHAR, tag1:TAG,tag2=0:ULONG, ...) IS NATIVE {MUI_NewObject(} classname {,} tag1 {,} tag2 {,} ... {)} ENDNATIVE !!PTR TO INTUIOBJECT 
NATIVE {MUI_Request} PROC
PROC Mui_Request(app:APTR, win:APTR, flags:VALUE, title:ARRAY OF CHAR, gadgets:ARRAY OF CHAR, format:ARRAY OF CHAR, param1:APTR, param2=0:ULONG, ...) IS NATIVE {MUI_Request(} app {,} win {,} flags {,} title {,} gadgets {,} format {,} param1 {,} param2 {,} ... {)} ENDNATIVE !!VALUE 

/* Predeclaration of private structures */
->NATIVE {MUI_RenderInfo} OBJECT
->NATIVE {MUI_PenSpec} OBJECT

NATIVE {MUI_NewObjectA} PROC
PROC Mui_NewObjectA(classid:CLASSID, tags:ARRAY OF tagitem) IS NATIVE {MUI_NewObjectA(} classid {,} tags {)} ENDNATIVE !!PTR TO INTUIOBJECT
NATIVE {MUI_DisposeObject} PROC
PROC Mui_DisposeObject(obj:PTR TO INTUIOBJECT) IS NATIVE {MUI_DisposeObject(} obj {)} ENDNATIVE
NATIVE {MUI_RequestA} PROC
PROC Mui_RequestA(app:APTR, win:APTR, flags:LONGBITS, title:/*CONST_STRPTR*/ ARRAY OF CHAR, gadgets:/*CONST_STRPTR*/ ARRAY OF CHAR, format:/*CONST_STRPTR*/ ARRAY OF CHAR, params:APTR) IS NATIVE {MUI_RequestA(} app {,} win {,} flags {,} title {,} gadgets {,} format {,} params {)} ENDNATIVE !!VALUE
NATIVE {MUI_AllocAslRequest} PROC
PROC Mui_AllocAslRequest(reqType:ULONG, tagList:ARRAY OF tagitem) IS NATIVE {MUI_AllocAslRequest(} reqType {,} tagList {)} ENDNATIVE !!APTR2
NATIVE {MUI_AslRequest} PROC
PROC Mui_AslRequest(requester:APTR2, tagList:ARRAY OF tagitem) IS NATIVE {-MUI_AslRequest(} requester {,} tagList {)} ENDNATIVE !!INT
NATIVE {MUI_FreeAslRequest} PROC
PROC Mui_FreeAslRequest(requester:APTR2) IS NATIVE {MUI_FreeAslRequest(} requester {)} ENDNATIVE
NATIVE {MUI_Error} PROC
PROC Mui_Error() IS NATIVE {MUI_Error()} ENDNATIVE !!VALUE
NATIVE {MUI_SetError} PROC
PROC Mui_SetError(num:VALUE) IS NATIVE {MUI_SetError(} num {)} ENDNATIVE !!VALUE
NATIVE {MUI_GetClass} PROC
PROC Mui_GetClass(classid:CLASSID) IS NATIVE {MUI_GetClass(} classid {)} ENDNATIVE !!PTR TO iclass
NATIVE {MUI_FreeClass} PROC
PROC Mui_FreeClass(cl:PTR TO iclass) IS NATIVE {MUI_FreeClass(} cl {)} ENDNATIVE
NATIVE {MUI_RequestIDCMP} PROC
PROC Mui_RequestIDCMP(obj:PTR TO INTUIOBJECT, flags:ULONG) IS NATIVE {MUI_RequestIDCMP(} obj {,} flags {)} ENDNATIVE
NATIVE {MUI_RejectIDCMP} PROC
PROC Mui_RejectIDCMP(obj:PTR TO INTUIOBJECT, flags:ULONG) IS NATIVE {MUI_RejectIDCMP(} obj {,} flags {)} ENDNATIVE
NATIVE {MUI_Redraw} PROC
PROC Mui_Redraw(obj:PTR TO INTUIOBJECT, flags:ULONG) IS NATIVE {MUI_Redraw(} obj {,} flags {)} ENDNATIVE
NATIVE {MUI_CreateCustomClass} PROC
PROC Mui_CreateCustomClass(base:PTR TO lib, supername:ARRAY OF CHAR, supermcc:PTR TO mui_customclass, datasize:ULONG, dispatcher:APTR2) IS NATIVE {MUI_CreateCustomClass(} base {, (ClassID)} supername {,} supermcc {,} datasize {,} dispatcher {)} ENDNATIVE !!PTR TO mui_customclass
->#PROC Mui_CreateCustomClass(base:PTR TO lib, supername:CLASSID, supermcc:PTR TO mui_customclass, datasize:ULONG, dispatcher:APTR2) IS NATIVE {MUI_CreateCustomClass(} base {,} supername {,} supermcc {,} datasize {,} dispatcher {)} ENDNATIVE !!PTR TO mui_customclass
NATIVE {MUI_DeleteCustomClass} PROC
PROC Mui_DeleteCustomClass(mcc:PTR TO mui_customclass) IS NATIVE {-MUI_DeleteCustomClass(} mcc {)} ENDNATIVE !!INT
NATIVE {MUI_MakeObjectA} PROC
PROC Mui_MakeObjectA(type:VALUE, params:ARRAY OF tagitem) IS NATIVE {MUI_MakeObjectA(} type {, (IPTR*)} params {)} ENDNATIVE !!PTR TO INTUIOBJECT
NATIVE {MUI_Layout} PROC
PROC Mui_Layout(obj:PTR TO INTUIOBJECT, left:VALUE, top:VALUE, width:VALUE, height:VALUE, flags:ULONG) IS NATIVE {-MUI_Layout(} obj {,} left {,} top {,} width {,} height {,} flags {)} ENDNATIVE !!INT
NATIVE {MUI_ObtainPen} PROC
PROC Mui_ObtainPen(mri:PTR TO mui_renderinfo, spec:PTR TO mui_penspec, flags:ULONG) IS NATIVE {MUI_ObtainPen(} mri {,} spec {,} flags {)} ENDNATIVE !!VALUE
NATIVE {MUI_ReleasePen} PROC
PROC Mui_ReleasePen(mri:PTR TO mui_renderinfo, pen:VALUE) IS NATIVE {MUI_ReleasePen(} mri {,} pen {)} ENDNATIVE
NATIVE {MUI_AddClipping} PROC
PROC Mui_AddClipping(mri:PTR TO mui_renderinfo, left:INT, top:INT, width:INT, height:INT) IS NATIVE {MUI_AddClipping(} mri {,} left {,} top {,} width {,} height {)} ENDNATIVE !!APTR
NATIVE {MUI_RemoveClipping} PROC
PROC Mui_RemoveClipping(mri:PTR TO mui_renderinfo, handle:APTR) IS NATIVE {MUI_RemoveClipping(} mri {,} handle {)} ENDNATIVE
NATIVE {MUI_AddClipRegion} PROC
PROC Mui_AddClipRegion(mri:PTR TO mui_renderinfo, r:PTR TO region) IS NATIVE {MUI_AddClipRegion(} mri {,} r {)} ENDNATIVE !!APTR
NATIVE {MUI_RemoveClipRegion} PROC
PROC Mui_RemoveClipRegion(mri:PTR TO mui_renderinfo, handle:APTR) IS NATIVE {MUI_RemoveClipRegion(} mri {,} handle {)} ENDNATIVE
NATIVE {MUI_BeginRefresh} PROC
PROC Mui_BeginRefresh(mri:PTR TO mui_renderinfo, flags:ULONG) IS NATIVE {-MUI_BeginRefresh(} mri {,} flags {)} ENDNATIVE !!INT
NATIVE {MUI_EndRefresh} PROC
PROC Mui_EndRefresh(mri:PTR TO mui_renderinfo, flags:ULONG) IS NATIVE {MUI_EndRefresh(} mri {,} flags {)} ENDNATIVE
