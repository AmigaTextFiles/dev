/* $Id: commodities_protos.h,v 1.7 2005/11/10 15:30:32 hjfrieden Exp $ */
OPT NATIVE
PUBLIC MODULE 'target/libraries/commodities'
MODULE 'target/exec/types', 'target/exec/nodes', /*'target/libraries/commodities',*/ 'target/devices/inputevent', 'target/devices/keymap'
MODULE 'target/PEalias/exec', 'target/exec/libraries', 'target/exec/lists'
{
#include <proto/commodities.h>
}
{
struct Library* CxBase = NULL;
struct CommoditiesIFace* ICommodities = NULL;
}
NATIVE {CLIB_COMMODITIES_PROTOS_H} CONST
NATIVE {PROTO_COMMODITIES_H} CONST
NATIVE {PRAGMA_COMMODITIES_H} CONST
NATIVE {INLINE4_COMMODITIES_H} CONST
NATIVE {COMMODITIES_INTERFACE_DEF_H} CONST

NATIVE {CxBase} DEF cxbase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {ICommodities} DEF

PROC new()
	InitLibrary('commodities.library', NATIVE {(struct Interface **) &ICommodities} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

/*--- functions in V36 or higher (Release 2.0) ---*/

/*  OBJECT UTILITIES */

->NATIVE {CreateCxObj} PROC
PROC CreateCxObj( type:ULONG, arg1:VALUE, arg2:VALUE ) IS NATIVE {ICommodities->CreateCxObj(} type {,} arg1 {,} arg2 {)} ENDNATIVE !!PTR TO CXOBJ
->NATIVE {CxBroker} PROC
PROC CxBroker( nb:PTR TO newbroker, error:PTR TO VALUE ) IS NATIVE {ICommodities->CxBroker(} nb {,} error {)} ENDNATIVE !!PTR TO CXOBJ
->NATIVE {ActivateCxObj} PROC
PROC ActivateCxObj( co:PTR TO CXOBJ, doIt:VALUE ) IS NATIVE {ICommodities->ActivateCxObj(} co {,} doIt {)} ENDNATIVE !!VALUE
->NATIVE {DeleteCxObj} PROC
PROC DeleteCxObj( co:PTR TO CXOBJ ) IS NATIVE {ICommodities->DeleteCxObj(} co {)} ENDNATIVE
->NATIVE {DeleteCxObjAll} PROC
PROC DeleteCxObjAll( co:PTR TO CXOBJ ) IS NATIVE {ICommodities->DeleteCxObjAll(} co {)} ENDNATIVE
->NATIVE {CxObjType} PROC
PROC CxObjType( co:PTR TO CXOBJ ) IS NATIVE {ICommodities->CxObjType(} co {)} ENDNATIVE !!ULONG
->NATIVE {CxObjError} PROC
PROC CxObjError( co:PTR TO CXOBJ ) IS NATIVE {ICommodities->CxObjError(} co {)} ENDNATIVE !!VALUE
->NATIVE {ClearCxObjError} PROC
PROC ClearCxObjError( co:PTR TO CXOBJ ) IS NATIVE {ICommodities->ClearCxObjError(} co {)} ENDNATIVE
->NATIVE {SetCxObjPri} PROC
PROC SetCxObjPri( co:PTR TO CXOBJ, pri:VALUE ) IS NATIVE {ICommodities->SetCxObjPri(} co {,} pri {)} ENDNATIVE !!VALUE

/*  OBJECT ATTACHMENT */

->NATIVE {AttachCxObj} PROC
PROC AttachCxObj( headObj:PTR TO CXOBJ, co:PTR TO CXOBJ ) IS NATIVE {ICommodities->AttachCxObj(} headObj {,} co {)} ENDNATIVE
->NATIVE {EnqueueCxObj} PROC
PROC EnqueueCxObj( headObj:PTR TO CXOBJ, co:PTR TO CXOBJ ) IS NATIVE {ICommodities->EnqueueCxObj(} headObj {,} co {)} ENDNATIVE
->NATIVE {InsertCxObj} PROC
PROC InsertCxObj( headObj:PTR TO CXOBJ, co:PTR TO CXOBJ, pred:PTR TO CXOBJ ) IS NATIVE {ICommodities->InsertCxObj(} headObj {,} co {,} pred {)} ENDNATIVE
->NATIVE {RemoveCxObj} PROC
PROC RemoveCxObj( co:PTR TO CXOBJ ) IS NATIVE {ICommodities->RemoveCxObj(} co {)} ENDNATIVE

/*  TYPE SPECIFIC */

->NATIVE {SetTranslate} PROC
PROC SetTranslate( translator:PTR TO CXOBJ, events:PTR TO inputevent ) IS NATIVE {ICommodities->SetTranslate(} translator {,} events {)} ENDNATIVE
->NATIVE {SetFilter} PROC
PROC SetFilter( filter:PTR TO CXOBJ, text:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {ICommodities->SetFilter(} filter {,} text {)} ENDNATIVE
->NATIVE {SetFilterIX} PROC
PROC SetFilterIX( filter:PTR TO CXOBJ, ix:PTR TO /*IX*/ inputxpression ) IS NATIVE {ICommodities->SetFilterIX(} filter {,} ix {)} ENDNATIVE
->NATIVE {ParseIX} PROC
PROC ParseIX( description:/*STRPTR*/ ARRAY OF CHAR, ix:PTR TO /*IX*/ inputxpression ) IS NATIVE {ICommodities->ParseIX(} description {,} ix {)} ENDNATIVE !!VALUE

/*  COMMON MESSAGE */

->NATIVE {CxMsgType} PROC
PROC CxMsgType( cxm:PTR TO CXMSG ) IS NATIVE {ICommodities->CxMsgType(} cxm {)} ENDNATIVE !!ULONG
->NATIVE {CxMsgData} PROC
PROC CxMsgData( cxm:PTR TO CXMSG ) IS NATIVE {ICommodities->CxMsgData(} cxm {)} ENDNATIVE !!APTR
->NATIVE {CxMsgID} PROC
PROC CxMsgID( cxm:PTR TO CXMSG ) IS NATIVE {ICommodities->CxMsgID(} cxm {)} ENDNATIVE !!VALUE

/*  MESSAGE ROUTING */

->NATIVE {DivertCxMsg} PROC
PROC DivertCxMsg( cxm:PTR TO CXMSG, headObj:PTR TO CXOBJ, returnObj:PTR TO CXOBJ ) IS NATIVE {ICommodities->DivertCxMsg(} cxm {,} headObj {,} returnObj {)} ENDNATIVE
->NATIVE {RouteCxMsg} PROC
PROC RouteCxMsg( cxm:PTR TO CXMSG, co:PTR TO CXOBJ ) IS NATIVE {ICommodities->RouteCxMsg(} cxm {,} co {)} ENDNATIVE
->NATIVE {DisposeCxMsg} PROC
PROC DisposeCxMsg( cxm:PTR TO CXMSG ) IS NATIVE {ICommodities->DisposeCxMsg(} cxm {)} ENDNATIVE

/*  INPUT EVENT HANDLING */

->NATIVE {InvertKeyMap} PROC
PROC InvertKeyMap( ansiCode:ULONG, event:PTR TO inputevent, km:PTR TO keymap ) IS NATIVE {-ICommodities->InvertKeyMap(} ansiCode {,} event {,} km {)} ENDNATIVE !!INT
->NATIVE {AddIEvents} PROC
PROC AddIEvents( events:PTR TO inputevent ) IS NATIVE {ICommodities->AddIEvents(} events {)} ENDNATIVE
/*--- functions in V38 or higher (Release 2.1) ---*/
/*  MORE INPUT EVENT HANDLING */
->NATIVE {MatchIX} PROC
PROC MatchIX( event:PTR TO inputevent, ix:PTR TO /*IX*/ inputxpression ) IS NATIVE {-ICommodities->MatchIX(} event {,} ix {)} ENDNATIVE !!INT

->missing from clib:
/* v50 stuff */

->NATIVE {CopyBrokerList} PROC
PROC CopyBrokerList(blist:PTR TO lh) IS NATIVE {ICommodities->CopyBrokerList(} blist {)} ENDNATIVE !!VALUE
->NATIVE {FreeBrokerList} PROC
PROC FreeBrokerList(list:PTR TO lh) IS NATIVE {ICommodities->FreeBrokerList(} list {)} ENDNATIVE
->NATIVE {BrokerCommand} PROC
PROC BrokerCommand(name:/*STRPTR*/ ARRAY OF CHAR, id:VALUE) IS NATIVE {(BOOLEAN)ICommodities->BrokerCommand(} name {,} id {)} ENDNATIVE !!BOOL
