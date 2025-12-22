OPT NATIVE
PUBLIC MODULE 'target/datatypes/amigaguideclass', 'target/datatypes/animationclass', 'target/datatypes/datatypes', 'target/datatypes/datatypesclass', 'target/datatypes/pictureclass', 'target/datatypes/soundclass', 'target/datatypes/soundclassext', 'target/datatypes/textclass'
MODULE 'target/aros/libcall', 'target/intuition/classes', 'target/intuition/intuition', 'target/intuition/gadgetclass' /*, 'target/datatypes/datatypes', 'target/datatypes/datatypesclass'*/
MODULE 'target/exec/libraries', 'target/exec/types', 'target/intuition/classusr', 'target/utility/tagitem', 'target/graphics/rastport', 'target/exec/lists'
{
#include <proto/datatypes.h>
}
{
struct Library* DataTypesBase = NULL;
}
NATIVE {CLIB_DATATYPES_PROTOS_H} CONST
NATIVE {PROTO_DATATYPES_H} CONST

NATIVE {DataTypesBase} DEF datatypesbase:PTR TO lib		->AmigaE does not automatically initialise this

NATIVE {GetDTAttrs} PROC
PROC GetDTAttrs(o:PTR TO INTUIOBJECT, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {GetDTAttrs(} o {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG
NATIVE {SetDTAttrs} PROC
PROC SetDTAttrs(o:PTR TO INTUIOBJECT, win:PTR TO window, req:PTR TO requester, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {SetDTAttrs(} o {,} win {,} req {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG
NATIVE {NewDTObject} PROC
PROC NewDTObject(name:APTR, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {NewDTObject(} name {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!PTR TO INTUIOBJECT
NATIVE {RefreshDTObject} PROC
PROC RefreshDTObject(o:PTR TO INTUIOBJECT, win:PTR TO window, req:PTR TO requester, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {RefreshDTObject(} o {,} win {,} req {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE
NATIVE {RefreshDTObjects} PROC
->#Not supported for some reason: PROC RefreshDTObjects(o:PTR TO INTUIOBJECT, win:PTR TO window, req:PTR TO requester, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {RefreshDTObjects(} o {,} win {,} req {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE
NATIVE {DoDTMethod} PROC
PROC DoDTMethod(param1:PTR TO INTUIOBJECT, win:PTR TO window, req:PTR TO requester, MethodID:ULONG, MethodID2=0:ULONG, ...) IS NATIVE {DoDTMethod(} param1 {,} win {,} req {,} MethodID {,} MethodID2 {,} ... {)} ENDNATIVE !!IPTR
NATIVE {ObtainDataTypeA} PROC
PROC ObtainDataTypeA(type:ULONG, handle:APTR, attrs:ARRAY OF tagitem) IS NATIVE {ObtainDataTypeA(} type {,} handle {,} attrs {)} ENDNATIVE !!PTR TO datatype
NATIVE {ReleaseDataType} PROC
PROC ReleaseDataType(dt:PTR TO datatype) IS NATIVE {ReleaseDataType(} dt {)} ENDNATIVE
NATIVE {NewDTObjectA} PROC
PROC NewDTObjectA(name:APTR, attrs:ARRAY OF tagitem) IS NATIVE {NewDTObjectA(} name {,} attrs {)} ENDNATIVE !!PTR TO INTUIOBJECT
NATIVE {DisposeDTObject} PROC
PROC DisposeDTObject(o:PTR TO INTUIOBJECT) IS NATIVE {DisposeDTObject(} o {)} ENDNATIVE
NATIVE {SetDTAttrsA} PROC
PROC SetDTAttrsA(o:PTR TO INTUIOBJECT, win:PTR TO window, req:PTR TO requester, attrs:ARRAY OF tagitem) IS NATIVE {SetDTAttrsA(} o {,} win {,} req {,} attrs {)} ENDNATIVE !!ULONG
NATIVE {GetDTAttrsA} PROC
PROC GetDTAttrsA(o:PTR TO INTUIOBJECT, attrs:ARRAY OF tagitem) IS NATIVE {GetDTAttrsA(} o {,} attrs {)} ENDNATIVE !!ULONG
NATIVE {AddDTObject} PROC
PROC AddDTObject(win:PTR TO window, req:PTR TO requester, obj:PTR TO INTUIOBJECT, pos:VALUE) IS NATIVE {AddDTObject(} win {,} req {,} obj {,} pos {)} ENDNATIVE !!VALUE
NATIVE {RefreshDTObjectA} PROC
PROC RefreshDTObjectA(object:PTR TO INTUIOBJECT, window:PTR TO window, req:PTR TO requester, attrs:ARRAY OF tagitem) IS NATIVE {RefreshDTObjectA(} object {,} window {,} req {,} attrs {)} ENDNATIVE
NATIVE {DoAsyncLayout} PROC
PROC DoAsyncLayout(object:PTR TO INTUIOBJECT, gpl:PTR TO gplayout) IS NATIVE {DoAsyncLayout(} object {,} gpl {)} ENDNATIVE !!ULONG
NATIVE {DoDTMethodA} PROC
PROC DoDTMethodA(o:PTR TO INTUIOBJECT, win:PTR TO window, req:PTR TO requester, msg:ARRAY /*OF msg*/) IS NATIVE {DoDTMethodA(} o {,} win {,} req {, (Msg)} msg {)} ENDNATIVE !!IPTR
NATIVE {RemoveDTObject} PROC
PROC RemoveDTObject(window:PTR TO window, object:PTR TO INTUIOBJECT) IS NATIVE {RemoveDTObject(} window {,} object {)} ENDNATIVE !!VALUE
NATIVE {GetDTMethods} PROC
PROC GetDTMethods(object:PTR TO INTUIOBJECT) IS NATIVE {GetDTMethods(} object {)} ENDNATIVE !!PTR TO ULONG
NATIVE {GetDTTriggerMethods} PROC
->#unknown object dtmethods: PROC GetDTTriggerMethods(object:PTR TO INTUIOBJECT) IS NATIVE {GetDTTriggerMethods(} object {)} ENDNATIVE !!PTR TO dtmethods
NATIVE {PrintDTObjectA} PROC
PROC PrintDTObjectA(object:PTR TO INTUIOBJECT, window:PTR TO window, requester:PTR TO requester, msg:PTR TO dtprint) IS NATIVE {PrintDTObjectA(} object {,} window {,} requester {,} msg {)} ENDNATIVE !!ULONG
NATIVE {ObtainDTDrawInfoA} PROC
PROC ObtainDTDrawInfoA(o:PTR TO INTUIOBJECT, attrs:ARRAY OF tagitem) IS NATIVE {ObtainDTDrawInfoA(} o {,} attrs {)} ENDNATIVE !!APTR
NATIVE {DrawDTObjectA} PROC
PROC DrawDTObjectA(rp:PTR TO rastport, o:PTR TO INTUIOBJECT, x:VALUE, y:VALUE, w:VALUE, h:VALUE, th:VALUE, tv:VALUE, attrs:ARRAY OF tagitem) IS NATIVE {DrawDTObjectA(} rp {,} o {,} x {,} y {,} w {,} h {,} th {,} tv {,} attrs {)} ENDNATIVE !!VALUE
NATIVE {ReleaseDTDrawInfo} PROC
PROC ReleaseDTDrawInfo(o:PTR TO INTUIOBJECT, handle:APTR) IS NATIVE {ReleaseDTDrawInfo(} o {,} handle {)} ENDNATIVE
NATIVE {GetDTString} PROC
PROC GetDTString(id:ULONG) IS NATIVE {GetDTString(} id {)} ENDNATIVE !!CONST_STRPTR
NATIVE {LockDataType} PROC
PROC LockDataType(dt:PTR TO datatype) IS NATIVE {LockDataType(} dt {)} ENDNATIVE
NATIVE {FindToolNodeA} PROC
PROC FindToolNodeA(toollist:PTR TO lh, attrs:ARRAY OF tagitem) IS NATIVE {FindToolNodeA(} toollist {,} attrs {)} ENDNATIVE !!PTR TO toolnode
NATIVE {LaunchToolA} PROC
PROC LaunchToolA(tool:PTR TO tool, project:/*STRPTR*/ ARRAY OF CHAR, attrs:ARRAY OF tagitem) IS NATIVE {LaunchToolA(} tool {,} project {,} attrs {)} ENDNATIVE !!ULONG
NATIVE {FindMethod} PROC
PROC FindMethod(methods:PTR TO ULONG, searchmethodid:ULONG) IS NATIVE {FindMethod(} methods {,} searchmethodid {)} ENDNATIVE !!PTR TO ULONG
NATIVE {FindTriggerMethod} PROC
PROC FindTriggerMethod(methods:PTR TO dtmethod, command:/*STRPTR*/ ARRAY OF CHAR, method:ULONG) IS NATIVE {FindTriggerMethod(} methods {,} command {,} method {)} ENDNATIVE !!PTR TO dtmethod
NATIVE {CopyDTMethods} PROC
PROC CopyDTMethods(methods:PTR TO ULONG, include:PTR TO ULONG, exclude:PTR TO ULONG) IS NATIVE {CopyDTMethods(} methods {,} include {,} exclude {)} ENDNATIVE !!PTR TO ULONG
NATIVE {CopyDTTriggerMethods} PROC
PROC CopyDTTriggerMethods(methods:PTR TO dtmethod, include:PTR TO dtmethod, exclude:PTR TO dtmethod) IS NATIVE {CopyDTTriggerMethods(} methods {,} include {,} exclude {)} ENDNATIVE !!PTR TO dtmethod
NATIVE {FreeDTMethods} PROC
PROC FreeDTMethods(methods:APTR) IS NATIVE {FreeDTMethods(} methods {)} ENDNATIVE
NATIVE {GetDTTriggerMethodDataFlags} PROC
PROC GetDTTriggerMethodDataFlags(method:ULONG) IS NATIVE {GetDTTriggerMethodDataFlags(} method {)} ENDNATIVE !!ULONG
NATIVE {SaveDTObjectA} PROC
PROC SaveDTObjectA(o:PTR TO INTUIOBJECT, win:PTR TO window, req:PTR TO requester, file:/*STRPTR*/ ARRAY OF CHAR, mode:ULONG, saveicon:INT, attrs:ARRAY OF tagitem) IS NATIVE {SaveDTObjectA(} o {,} win {,} req {,} file {,} mode {, -} saveicon {,} attrs {)} ENDNATIVE !!ULONG
NATIVE {StartDragSelect} PROC
PROC StartDragSelect(o:PTR TO INTUIOBJECT) IS NATIVE {StartDragSelect(} o {)} ENDNATIVE !!ULONG
NATIVE {DoDTDomainA} PROC
PROC DoDTDomainA(o:PTR TO INTUIOBJECT, win:PTR TO window, req:PTR TO requester, rport:PTR TO rastport, which:ULONG, domain:PTR TO ibox, attrs:ARRAY OF tagitem) IS NATIVE {DoDTDomainA(} o {,} win {,} req {,} rport {,} which {,} domain {,} attrs {)} ENDNATIVE !!ULONG
