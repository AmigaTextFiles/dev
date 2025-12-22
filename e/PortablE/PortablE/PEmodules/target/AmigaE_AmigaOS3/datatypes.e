/* $VER: datatypes_protos.h 44.2 (21.4.1999) */
OPT NATIVE
PUBLIC MODULE 'target/datatypes/animationclass', 'target/datatypes/datatypes', 'target/datatypes/datatypesclass', 'target/datatypes/pictureclass', 'target/datatypes/soundclass', 'target/datatypes/textclass'
MODULE 'target/exec/types', 'target/exec/lists', 'target/intuition/intuition', 'target/intuition/classes', 'target/intuition/classusr', 'target/intuition/gadgetclass', 'target/utility/tagitem', /*'target/datatypes/datatypesclass', 'target/datatypes/datatypes',*/ 'target/rexx/storage'
MODULE 'target/exec/libraries', 'target/graphics/rastport'
{MODULE 'datatypes'}

NATIVE {datatypesbase} DEF datatypesbase:NATIVE {LONG} PTR TO lib		->AmigaE does not automatically initialise this

/*--- functions in V40 or higher (Release 3.1) ---*/

/* Public entries */

NATIVE {ObtainDataTypeA} PROC
PROC ObtainDataTypeA( type:ULONG, handle:APTR, attrs:ARRAY OF tagitem ) IS NATIVE {ObtainDataTypeA(} type {,} handle {,} attrs {)} ENDNATIVE !!PTR TO datatype
->NATIVE {ObtainDataType} PROC
->PROC ObtainDataType( type:ULONG, handle:APTR, tag1:TAG, tag12=0:ULONG, tag13=0:ULONG, tag14=0:ULONG, tag15=0:ULONG, tag16=0:ULONG, tag17=0:ULONG, tag18=0:ULONG ) IS NATIVE {ObtainDataType(} type {,} handle {,} tag1 {,} tag12 {,} tag13 {,} tag14 {,} tag15 {,} tag16 {,} tag17 {,} tag18 {)} ENDNATIVE !!PTR TO datatype
NATIVE {ReleaseDataType} PROC
PROC ReleaseDataType( dt:PTR TO datatype ) IS NATIVE {ReleaseDataType(} dt {)} ENDNATIVE
NATIVE {NewDTObjectA} PROC
PROC NewDTObjectA( name:APTR, attrs:ARRAY OF tagitem ) IS NATIVE {NewDTObjectA(} name {,} attrs {)} ENDNATIVE !!PTR TO INTUIOBJECT
->NATIVE {NewDTObject} PROC
->PROC NewDTObject( name:APTR, tag1:TAG, tag12=0:ULONG, tag13=0:ULONG, tag14=0:ULONG, tag15=0:ULONG, tag16=0:ULONG, tag17=0:ULONG, tag18=0:ULONG ) IS NATIVE {NewDTObject(} name {,} tag1 {,} tag12 {,} tag13 {,} tag14 {,} tag15 {,} tag16 {,} tag17 {,} tag18 {)} ENDNATIVE !!PTR TO INTUIOBJECT
NATIVE {DisposeDTObject} PROC
PROC DisposeDTObject( o:PTR TO INTUIOBJECT ) IS NATIVE {DisposeDTObject(} o {)} ENDNATIVE
NATIVE {SetDTAttrsA} PROC
PROC SetDTAttrsA( o:PTR TO INTUIOBJECT, win:PTR TO window, req:PTR TO requester, attrs:ARRAY OF tagitem ) IS NATIVE {SetDTAttrsA(} o {,} win {,} req {,} attrs {)} ENDNATIVE !!ULONG
->NATIVE {SetDTAttrs} PROC
->PROC SetDTAttrs( o:PTR TO INTUIOBJECT, win:PTR TO window, req:PTR TO requester, tag1:TAG, tag12=0:ULONG, tag13=0:ULONG, tag14=0:ULONG, tag15=0:ULONG, tag16=0:ULONG, tag17=0:ULONG, tag18=0:ULONG ) IS NATIVE {SetDTAttrs(} o {,} win {,} req {,} tag1 {,} tag12 {,} tag13 {,} tag14 {,} tag15 {,} tag16 {,} tag17 {,} tag18 {)} ENDNATIVE !!ULONG
NATIVE {GetDTAttrsA} PROC
PROC GetDTAttrsA( o:PTR TO INTUIOBJECT, attrs:ARRAY OF tagitem ) IS NATIVE {GetDTAttrsA(} o {,} attrs {)} ENDNATIVE !!ULONG
->NATIVE {GetDTAttrs} PROC
->PROC GetDTAttrs( o:PTR TO INTUIOBJECT, tag1:TAG, tag12=0:ULONG, tag13=0:ULONG, tag14=0:ULONG, tag15=0:ULONG, tag16=0:ULONG, tag17=0:ULONG, tag18=0:ULONG ) IS NATIVE {GetDTAttrs(} o {,} tag1 {,} tag12 {,} tag13 {,} tag14 {,} tag15 {,} tag16 {,} tag17 {,} tag18 {)} ENDNATIVE !!ULONG
NATIVE {AddDTObject} PROC
PROC AddDTObject( win:PTR TO window, req:PTR TO requester, o:PTR TO INTUIOBJECT, pos:VALUE ) IS NATIVE {AddDTObject(} win {,} req {,} o {,} pos {)} ENDNATIVE !!VALUE
NATIVE {RefreshDTObjectA} PROC
PROC RefreshDTObjectA( o:PTR TO INTUIOBJECT, win:PTR TO window, req:PTR TO requester, attrs:ARRAY OF tagitem ) IS NATIVE {RefreshDTObjectA(} o {,} win {,} req {,} attrs {)} ENDNATIVE
->NATIVE {RefreshDTObjects} PROC
->PROC RefreshDTObjects( o:PTR TO INTUIOBJECT, win:PTR TO window, req:PTR TO requester, tag1:TAG, tag12=0:ULONG, tag13=0:ULONG, tag14=0:ULONG, tag15=0:ULONG, tag16=0:ULONG, tag17=0:ULONG, tag18=0:ULONG ) IS NATIVE {RefreshDTObjects(} o {,} win {,} req {,} tag1 {,} tag12 {,} tag13 {,} tag14 {,} tag15 {,} tag16 {,} tag17 {,} tag18 {)} ENDNATIVE
->NATIVE {RefreshDTObject} PROC
->PROC RefreshDTObject( o:PTR TO INTUIOBJECT, win:PTR TO window, req:PTR TO requester, tag1:TAG, tag12=0:ULONG, tag13=0:ULONG, tag14=0:ULONG, tag15=0:ULONG, tag16=0:ULONG, tag17=0:ULONG, tag18=0:ULONG ) IS NATIVE {RefreshDTObject(} o {,} win {,} req {,} tag1 {,} tag12 {,} tag13 {,} tag14 {,} tag15 {,} tag16 {,} tag17 {,} tag18 {)} ENDNATIVE
NATIVE {DoAsyncLayout} PROC
PROC DoAsyncLayout( o:PTR TO INTUIOBJECT, gpl:PTR TO gplayout ) IS NATIVE {DoAsyncLayout(} o {,} gpl {)} ENDNATIVE !!ULONG
NATIVE {DoDTMethodA} PROC
PROC DoDTMethodA( o:PTR TO INTUIOBJECT, win:PTR TO window, req:PTR TO requester, msg:ARRAY /*OF msg*/ ) IS NATIVE {DoDTMethodA(} o {,} win {,} req {,} msg {)} ENDNATIVE !!ULONG
->NATIVE {DoDTMethod} PROC
->PROC DoDTMethod( o:PTR TO INTUIOBJECT, win:PTR TO window, req:PTR TO requester, data:ULONG, data2=0:ULONG, data3=0:ULONG, data4=0:ULONG, data5=0:ULONG, data6=0:ULONG, data7=0:ULONG, data8=0:ULONG ) IS NATIVE {DoDTMethod(} o {,} win {,} req {,} data {,} data2 {,} data3 {,} data4 {,} data5 {,} data6 {,} data7 {,} data8 {)} ENDNATIVE !!ULONG
NATIVE {RemoveDTObject} PROC
PROC RemoveDTObject( win:PTR TO window, o:PTR TO INTUIOBJECT ) IS NATIVE {RemoveDTObject(} win {,} o {)} ENDNATIVE !!VALUE
NATIVE {GetDTMethods} PROC
PROC GetDTMethods( object:PTR TO INTUIOBJECT ) IS NATIVE {GetDTMethods(} object {)} ENDNATIVE !!PTR TO ULONG
NATIVE {GetDTTriggerMethods} PROC
->#unknown object dtmethods: PROC GetDTTriggerMethods( object:PTR TO INTUIOBJECT ) IS NATIVE {GetDTTriggerMethods(} object {)} ENDNATIVE !!PTR TO dtmethods
NATIVE {PrintDTObjectA} PROC
PROC PrintDTObjectA( o:PTR TO INTUIOBJECT, w:PTR TO window, r:PTR TO requester, msg:PTR TO dtprint ) IS NATIVE {PrintDTObjectA(} o {,} w {,} r {,} msg {)} ENDNATIVE !!ULONG
->NATIVE {PrintDTObject} PROC
->PROC PrintDTObject( o:PTR TO INTUIOBJECT, w:PTR TO window, r:PTR TO requester, data:ULONG, data2=0:ULONG, data3=0:ULONG, data4=0:ULONG, data5=0:ULONG, data6=0:ULONG, data7=0:ULONG, data8=0:ULONG ) IS NATIVE {PrintDTObject(} o {,} w {,} r {,} data {,} data2 {,} data3 {,} data4 {,} data5 {,} data6 {,} data7 {,} data8 {)} ENDNATIVE !!ULONG
->NATIVE {ObtainDTDrawInfoA} PROC
->PROC ObtainDTDrawInfoA( o:PTR TO INTUIOBJECT, attrs:ARRAY OF tagitem ) IS NATIVE {ObtainDTDrawInfoA(} o {,} attrs {)} ENDNATIVE !!APTR
->NATIVE {ObtainDTDrawInfo} PROC
->PROC ObtainDTDrawInfo( o:PTR TO INTUIOBJECT, tag1:TAG, tag12=0:ULONG, tag13=0:ULONG, tag14=0:ULONG, tag15=0:ULONG, tag16=0:ULONG, tag17=0:ULONG, tag18=0:ULONG ) IS NATIVE {ObtainDTDrawInfo(} o {,} tag1 {,} tag12 {,} tag13 {,} tag14 {,} tag15 {,} tag16 {,} tag17 {,} tag18 {)} ENDNATIVE !!APTR
->NATIVE {DrawDTObjectA} PROC
->PROC DrawDTObjectA( rp:PTR TO rastport, o:PTR TO INTUIOBJECT, x:VALUE, y:VALUE, w:VALUE, h:VALUE, th:VALUE, tv:VALUE, attrs:ARRAY OF tagitem ) IS NATIVE {DrawDTObjectA(} rp {,} o {,} x {,} y {,} w {,} h {,} th {,} tv {,} attrs {)} ENDNATIVE !!VALUE
->NATIVE {DrawDTObject} PROC
->PROC DrawDTObject( rp:PTR TO rastport, o:PTR TO INTUIOBJECT, x:VALUE, y:VALUE, w:VALUE, h:VALUE, th:VALUE, tv:VALUE, tag1:TAG, tag12=0:ULONG, tag13=0:ULONG, tag14=0:ULONG, tag15=0:ULONG, tag16=0:ULONG, tag17=0:ULONG, tag18=0:ULONG ) IS NATIVE {DrawDTObject(} rp {,} o {,} x {,} y {,} w {,} h {,} th {,} tv {,} tag1 {,} tag12 {,} tag13 {,} tag14 {,} tag15 {,} tag16 {,} tag17 {,} tag18 {)} ENDNATIVE !!VALUE
->NATIVE {ReleaseDTDrawInfo} PROC
->PROC ReleaseDTDrawInfo( o:PTR TO INTUIOBJECT, handle:APTR ) IS NATIVE {ReleaseDTDrawInfo(} o {,} handle {)} ENDNATIVE
NATIVE {GetDTString} PROC
PROC GetDTString( id:ULONG ) IS NATIVE {GetDTString(} id {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
