/* $Id: datatypes_protos.h,v 1.8 2005/11/10 15:30:32 hjfrieden Exp $ */
OPT NATIVE, INLINE
PUBLIC MODULE 'target/datatypes/animationclass', 'target/datatypes/datatypes', 'target/datatypes/datatypesclass', 'target/datatypes/pictureclass', 'target/datatypes/soundclass', 'target/datatypes/textclass'
MODULE 'target/exec/types', 'target/exec/lists', 'target/intuition/intuition', 'target/intuition/classes', 'target/intuition/classusr', 'target/intuition/gadgetclass', 'target/utility/tagitem', /*'target/datatypes/datatypesclass', 'target/datatypes/datatypes',*/ 'target/rexx/storage'
MODULE 'target/PEalias/exec', 'target/exec/libraries', 'target/graphics/rastport'
{
#include <proto/datatypes.h>
}
{
struct Library* DataTypesBase = NULL;
struct DataTypesIFace* IDataTypes = NULL;
}
NATIVE {CLIB_DATATYPES_PROTOS_H} CONST
NATIVE {PROTO_DATATYPES_H} CONST
NATIVE {PRAGMA_DATATYPES_H} CONST
NATIVE {INLINE4_DATATYPES_H} CONST
NATIVE {DATATYPES_INTERFACE_DEF_H} CONST

NATIVE {DataTypesBase} DEF datatypesbase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IDataTypes}    DEF

PROC new()
	InitLibrary('datatypes.library', NATIVE {(struct Interface **) &IDataTypes} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

/*--- functions in V40 or higher (Release 3.1) ---*/

/* Public entries */

->NATIVE {ObtainDataTypeA} PROC
PROC ObtainDataTypeA( type:ULONG, handle:APTR, attrs:ARRAY OF tagitem ) IS NATIVE {IDataTypes->ObtainDataTypeA(} type {,} handle {,} attrs {)} ENDNATIVE !!PTR TO datatype
->NATIVE {ObtainDataType} PROC
PROC ObtainDataType( type:ULONG, handle:APTR, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IDataTypes->ObtainDataType(} type {,} handle {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!PTR TO datatype
->NATIVE {ReleaseDataType} PROC
PROC ReleaseDataType( dt:PTR TO datatype ) IS NATIVE {IDataTypes->ReleaseDataType(} dt {)} ENDNATIVE
->NATIVE {NewDTObjectA} PROC

PROC NewDTObjectA( name:/*STRPTR*/ ARRAY OF CHAR, attrs:ARRAY OF tagitem ) IS NATIVE {IDataTypes->NewDTObjectA(} name {,} attrs {)} ENDNATIVE !!PTR TO INTUIOBJECT
->NATIVE {NewDTObject} PROC
PROC NewDTObject( name:/*STRPTR*/ ARRAY OF CHAR, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IDataTypes->NewDTObject(} name {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!PTR TO INTUIOBJECT
->NATIVE {DisposeDTObject} PROC
PROC DisposeDTObject( o:PTR TO INTUIOBJECT ) IS NATIVE {IDataTypes->DisposeDTObject(} o {)} ENDNATIVE
->NATIVE {SetDTAttrsA} PROC
PROC SetDTAttrsA( o:PTR TO INTUIOBJECT, win:PTR TO window, req:PTR TO requester, attrs:ARRAY OF tagitem ) IS NATIVE {IDataTypes->SetDTAttrsA(} o {,} win {,} req {,} attrs {)} ENDNATIVE !!ULONG
->NATIVE {SetDTAttrs} PROC
PROC SetDTAttrs( o:PTR TO INTUIOBJECT, win:PTR TO window, req:PTR TO requester, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IDataTypes->SetDTAttrs(} o {,} win {,} req {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {GetDTAttrsA} PROC
PROC GetDTAttrsA( o:PTR TO INTUIOBJECT, attrs:ARRAY OF tagitem ) IS NATIVE {IDataTypes->GetDTAttrsA(} o {,} attrs {)} ENDNATIVE !!ULONG
->NATIVE {GetDTAttrs} PROC
PROC GetDTAttrs( o:PTR TO INTUIOBJECT, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IDataTypes->GetDTAttrs(} o {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {AddDTObject} PROC
PROC AddDTObject( win:PTR TO window, req:PTR TO requester, o:PTR TO INTUIOBJECT, pos:VALUE ) IS NATIVE {IDataTypes->AddDTObject(} win {,} req {,} o {,} pos {)} ENDNATIVE !!VALUE
->NATIVE {RefreshDTObjectA} PROC
PROC RefreshDTObjectA( o:PTR TO INTUIOBJECT, win:PTR TO window, req:PTR TO requester, attrs:ARRAY OF tagitem ) IS NATIVE {IDataTypes->RefreshDTObjectA(} o {,} win {,} req {,} attrs {)} ENDNATIVE
->NATIVE {RefreshDTObjects} PROC
PROC RefreshDTObjects( o:PTR TO INTUIOBJECT, win:PTR TO window, req:PTR TO requester, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IDataTypes->RefreshDTObjects(} o {,} win {,} req {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE
->NATIVE {RefreshDTObject} PROC
PROC RefreshDTObject( o:PTR TO INTUIOBJECT, win:PTR TO window, req:PTR TO requester, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IDataTypes->RefreshDTObject(} o {,} win {,} req {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE
->NATIVE {DoAsyncLayout} PROC
PROC DoAsyncLayout( o:PTR TO INTUIOBJECT, gpl:PTR TO gplayout ) IS NATIVE {IDataTypes->DoAsyncLayout(} o {,} gpl {)} ENDNATIVE !!ULONG
->NATIVE {DoDTMethodA} PROC
PROC DoDTMethodA( o:PTR TO INTUIOBJECT, win:PTR TO window, req:PTR TO requester, msg:ARRAY /*OF msg*/ ) IS NATIVE {IDataTypes->DoDTMethodA(} o {,} win {,} req {, (Msg)} msg {)} ENDNATIVE !!ULONG
->NATIVE {DoDTMethod} PROC
PROC DoDTMethod( o:PTR TO INTUIOBJECT, win:PTR TO window, req:PTR TO requester, data:ULONG, data2=0:ULONG, ... ) IS NATIVE {IDataTypes->DoDTMethod(} o {,} win {,} req {,} data {,} data2 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {RemoveDTObject} PROC
PROC RemoveDTObject( win:PTR TO window, o:PTR TO INTUIOBJECT ) IS NATIVE {IDataTypes->RemoveDTObject(} win {,} o {)} ENDNATIVE !!VALUE
->NATIVE {GetDTMethods} PROC
PROC GetDTMethods( object:PTR TO INTUIOBJECT ) IS NATIVE {IDataTypes->GetDTMethods(} object {)} ENDNATIVE !!PTR TO ULONG
->NATIVE {GetDTTriggerMethods} PROC
->#unknown object dtmethods: PROC GetDTTriggerMethods( object:PTR TO INTUIOBJECT ) IS NATIVE {IDataTypes->GetDTTriggerMethods(} object {)} ENDNATIVE !!PTR TO dtmethods
->NATIVE {PrintDTObjectA} PROC
PROC PrintDTObjectA( o:PTR TO INTUIOBJECT, w:PTR TO window, r:PTR TO requester, msg:PTR TO dtprint ) IS NATIVE {IDataTypes->PrintDTObjectA(} o {,} w {,} r {,} msg {)} ENDNATIVE !!ULONG
->NATIVE {PrintDTObject} PROC
PROC PrintDTObject( o:PTR TO INTUIOBJECT, w:PTR TO window, r:PTR TO requester, data:ULONG, data2=0:ULONG, ... ) IS NATIVE {IDataTypes->PrintDTObject(} o {,} w {,} r {,} data {,} data2 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {ObtainDTDrawInfoA} PROC
PROC ObtainDTDrawInfoA( o:PTR TO INTUIOBJECT, attrs:ARRAY OF tagitem ) IS NATIVE {IDataTypes->ObtainDTDrawInfoA(} o {,} attrs {)} ENDNATIVE !!APTR
->NATIVE {ObtainDTDrawInfo} PROC
PROC ObtainDTDrawInfo( o:PTR TO INTUIOBJECT, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IDataTypes->ObtainDTDrawInfo(} o {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!APTR
->NATIVE {DrawDTObjectA} PROC
PROC DrawDTObjectA( rp:PTR TO rastport, o:PTR TO INTUIOBJECT, x:VALUE, y:VALUE, w:VALUE, h:VALUE, th:VALUE, tv:VALUE, attrs:ARRAY OF tagitem ) IS NATIVE {IDataTypes->DrawDTObjectA(} rp {,} o {,} x {,} y {,} w {,} h {,} th {,} tv {,} attrs {)} ENDNATIVE !!VALUE
->NATIVE {DrawDTObject} PROC
PROC DrawDTObject( rp:PTR TO rastport, o:PTR TO INTUIOBJECT, x:VALUE, y:VALUE, w:VALUE, h:VALUE, th:VALUE, tv:VALUE, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IDataTypes->DrawDTObject(} rp {,} o {,} x {,} y {,} w {,} h {,} th {,} tv {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {ReleaseDTDrawInfo} PROC
PROC ReleaseDTDrawInfo( o:PTR TO INTUIOBJECT, handle:APTR ) IS NATIVE {IDataTypes->ReleaseDTDrawInfo(} o {,} handle {)} ENDNATIVE
->NATIVE {GetDTString} PROC
PROC GetDTString( id:ULONG ) IS NATIVE {(char*) IDataTypes->GetDTString(} id {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
/*--- functions in V45 or higher (3rd party release) ---*/
->NATIVE {FindMethod} PROC
PROC FindMethod( methods:PTR TO ULONG, searchmethodid:ULONG ) IS NATIVE {IDataTypes->FindMethod(} methods {,} searchmethodid {)} ENDNATIVE !!PTR TO ULONG
->NATIVE {FindTriggerMethod} PROC
PROC FindTriggerMethod( dtm:PTR TO dtmethod, command:/*STRPTR*/ ARRAY OF CHAR, method:ULONG ) IS NATIVE {IDataTypes->FindTriggerMethod(} dtm {,} command {,} method {)} ENDNATIVE !!PTR TO dtmethod
->NATIVE {CopyDTMethods} PROC
PROC CopyDTMethods( methods:PTR TO ULONG, include:PTR TO ULONG, exclude:PTR TO ULONG ) IS NATIVE {IDataTypes->CopyDTMethods(} methods {,} include {,} exclude {)} ENDNATIVE !!PTR TO ULONG
->NATIVE {CopyDTTriggerMethods} PROC
PROC CopyDTTriggerMethods( methods:PTR TO dtmethod, include:PTR TO dtmethod, exclude:PTR TO dtmethod ) IS NATIVE {IDataTypes->CopyDTTriggerMethods(} methods {,} include {,} exclude {)} ENDNATIVE !!PTR TO dtmethod
->NATIVE {FreeDTMethods} PROC
PROC FreeDTMethods( methods:APTR ) IS NATIVE {IDataTypes->FreeDTMethods(} methods {)} ENDNATIVE
->NATIVE {SaveDTObjectA} PROC
PROC SaveDTObjectA( o:PTR TO INTUIOBJECT, win:PTR TO window, req:PTR TO requester, file:/*STRPTR*/ ARRAY OF CHAR, mode:ULONG, saveicon:VALUE, attrs:ARRAY OF tagitem ) IS NATIVE {IDataTypes->SaveDTObjectA(} o {,} win {,} req {,} file {,} mode {,} saveicon {,} attrs {)} ENDNATIVE !!ULONG
->NATIVE {StartDragSelect} PROC
PROC StartDragSelect( o:PTR TO INTUIOBJECT ) IS NATIVE {IDataTypes->StartDragSelect(} o {)} ENDNATIVE !!ULONG
