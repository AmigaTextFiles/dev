/* $VER: commodities_protos.h 40.1 (17.5.1996) */
OPT NATIVE
PUBLIC MODULE 'target/libraries/commodities'
MODULE 'target/exec/types', 'target/exec/nodes', /*'target/libraries/commodities',*/ 'target/devices/inputevent', 'target/devices/keymap'
MODULE 'target/exec/libraries'
{MODULE 'commodities'}

NATIVE {cxbase} DEF cxbase:NATIVE {LONG} PTR TO lib		->AmigaE does not automatically initialise this

/*--- functions in V36 or higher (Release 2.0) ---*/

/*  OBJECT UTILITIES */

NATIVE {CreateCxObj} PROC
PROC CreateCxObj( type:ULONG, arg1:VALUE, arg2:VALUE ) IS NATIVE {CreateCxObj(} type {,} arg1 {,} arg2 {)} ENDNATIVE !!PTR TO CXOBJ
NATIVE {CxBroker} PROC
PROC CxBroker( nb:PTR TO newbroker, error:PTR TO VALUE ) IS NATIVE {CxBroker(} nb {,} error {)} ENDNATIVE !!PTR TO CXOBJ
NATIVE {ActivateCxObj} PROC
PROC ActivateCxObj( co:PTR TO CXOBJ, doIt:VALUE ) IS NATIVE {ActivateCxObj(} co {,} doIt {)} ENDNATIVE !!VALUE
NATIVE {DeleteCxObj} PROC
PROC DeleteCxObj( co:PTR TO CXOBJ ) IS NATIVE {DeleteCxObj(} co {)} ENDNATIVE
NATIVE {DeleteCxObjAll} PROC
PROC DeleteCxObjAll( co:PTR TO CXOBJ ) IS NATIVE {DeleteCxObjAll(} co {)} ENDNATIVE
NATIVE {CxObjType} PROC
PROC CxObjType( co:PTR TO CXOBJ ) IS NATIVE {CxObjType(} co {)} ENDNATIVE !!ULONG
NATIVE {CxObjError} PROC
PROC CxObjError( co:PTR TO CXOBJ ) IS NATIVE {CxObjError(} co {)} ENDNATIVE !!VALUE
NATIVE {ClearCxObjError} PROC
PROC ClearCxObjError( co:PTR TO CXOBJ ) IS NATIVE {ClearCxObjError(} co {)} ENDNATIVE
NATIVE {SetCxObjPri} PROC
PROC SetCxObjPri( co:PTR TO CXOBJ, pri:VALUE ) IS NATIVE {SetCxObjPri(} co {,} pri {)} ENDNATIVE !!VALUE

/*  OBJECT ATTACHMENT */

NATIVE {AttachCxObj} PROC
PROC AttachCxObj( headObj:PTR TO CXOBJ, co:PTR TO CXOBJ ) IS NATIVE {AttachCxObj(} headObj {,} co {)} ENDNATIVE
NATIVE {EnqueueCxObj} PROC
PROC EnqueueCxObj( headObj:PTR TO CXOBJ, co:PTR TO CXOBJ ) IS NATIVE {EnqueueCxObj(} headObj {,} co {)} ENDNATIVE
NATIVE {InsertCxObj} PROC
PROC InsertCxObj( headObj:PTR TO CXOBJ, co:PTR TO CXOBJ, pred:PTR TO CXOBJ ) IS NATIVE {InsertCxObj(} headObj {,} co {,} pred {)} ENDNATIVE
NATIVE {RemoveCxObj} PROC
PROC RemoveCxObj( co:PTR TO CXOBJ ) IS NATIVE {RemoveCxObj(} co {)} ENDNATIVE

/*  TYPE SPECIFIC */

NATIVE {SetTranslate} PROC
PROC SetTranslate( translator:PTR TO CXOBJ, events:PTR TO inputevent ) IS NATIVE {SetTranslate(} translator {,} events {)} ENDNATIVE
NATIVE {SetFilter} PROC
PROC SetFilter( filter:PTR TO CXOBJ, text:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {SetFilter(} filter {,} text {)} ENDNATIVE
NATIVE {SetFilterIX} PROC
PROC SetFilterIX( filter:PTR TO CXOBJ, ix:PTR TO /*IX*/ inputxpression ) IS NATIVE {SetFilterIX(} filter {,} ix {)} ENDNATIVE
NATIVE {ParseIX} PROC
PROC ParseIX( description:/*STRPTR*/ ARRAY OF CHAR, ix:PTR TO /*IX*/ inputxpression ) IS NATIVE {ParseIX(} description {,} ix {)} ENDNATIVE !!VALUE

/*  COMMON MESSAGE */

NATIVE {CxMsgType} PROC
PROC CxMsgType( cxm:PTR TO CXMSG ) IS NATIVE {CxMsgType(} cxm {)} ENDNATIVE !!ULONG
NATIVE {CxMsgData} PROC
PROC CxMsgData( cxm:PTR TO CXMSG ) IS NATIVE {CxMsgData(} cxm {)} ENDNATIVE !!APTR
NATIVE {CxMsgID} PROC
PROC CxMsgID( cxm:PTR TO CXMSG ) IS NATIVE {CxMsgID(} cxm {)} ENDNATIVE !!VALUE

/*  MESSAGE ROUTING */

NATIVE {DivertCxMsg} PROC
PROC DivertCxMsg( cxm:PTR TO CXMSG, headObj:PTR TO CXOBJ, returnObj:PTR TO CXOBJ ) IS NATIVE {DivertCxMsg(} cxm {,} headObj {,} returnObj {)} ENDNATIVE
NATIVE {RouteCxMsg} PROC
PROC RouteCxMsg( cxm:PTR TO CXMSG, co:PTR TO CXOBJ ) IS NATIVE {RouteCxMsg(} cxm {,} co {)} ENDNATIVE
NATIVE {DisposeCxMsg} PROC
PROC DisposeCxMsg( cxm:PTR TO CXMSG ) IS NATIVE {DisposeCxMsg(} cxm {)} ENDNATIVE

/*  INPUT EVENT HANDLING */

NATIVE {InvertKeyMap} PROC
PROC InvertKeyMap( ansiCode:ULONG, event:PTR TO inputevent, km:PTR TO keymap ) IS NATIVE {InvertKeyMap(} ansiCode {,} event {,} km {)} ENDNATIVE !!INT
NATIVE {AddIEvents} PROC
PROC AddIEvents( events:PTR TO inputevent ) IS NATIVE {AddIEvents(} events {)} ENDNATIVE
/*--- functions in V38 or higher (Release 2.1) ---*/
/*  MORE INPUT EVENT HANDLING */
NATIVE {MatchIX} PROC
PROC MatchIX( event:PTR TO inputevent, ix:PTR TO /*IX*/ inputxpression ) IS NATIVE {MatchIX(} event {,} ix {)} ENDNATIVE !!INT
