OPT NATIVE
PUBLIC MODULE 'target/libraries/commodities'
MODULE 'target/aros/libcall', 'target/exec/types', 'target/exec/nodes', 'target/devices/inputevent', 'target/devices/keymap'/*, 'target/libraries/commodities'*/
MODULE 'target/exec/libraries', 'target/exec/lists'
{
#include <proto/commodities.h>
}
{
struct Library* CxBase = NULL;
}
NATIVE {CLIB_COMMODITIES_PROTOS_H} CONST
NATIVE {PROTO_COMMODITIES_H} CONST

NATIVE {CxBase} DEF cxbase:PTR TO lib		->AmigaE does not automatically initialise this

NATIVE {CreateCxObj} PROC
PROC CreateCxObj(type:ULONG, arg1:VALUE, arg2:VALUE) IS NATIVE {CreateCxObj(} type {, (IPTR) } arg1 {, (IPTR) } arg2 {)} ENDNATIVE !!PTR TO CXOBJ
NATIVE {CxBroker} PROC
PROC CxBroker(nb:PTR TO newbroker, error:PTR TO SLONG) IS NATIVE {CxBroker(} nb {,} error {)} ENDNATIVE !!PTR TO CXOBJ
NATIVE {ActivateCxObj} PROC
PROC ActivateCxObj(co:PTR TO CXOBJ, true:VALUE) IS NATIVE {ActivateCxObj(} co {,} true {)} ENDNATIVE !!VALUE
NATIVE {DeleteCxObj} PROC
PROC DeleteCxObj(co:PTR TO CXOBJ) IS NATIVE {DeleteCxObj(} co {)} ENDNATIVE
NATIVE {DeleteCxObjAll} PROC
PROC DeleteCxObjAll(co:PTR TO CXOBJ) IS NATIVE {DeleteCxObjAll(} co {)} ENDNATIVE
NATIVE {CxObjType} PROC
PROC CxObjType(co:PTR TO CXOBJ) IS NATIVE {CxObjType(} co {)} ENDNATIVE !!ULONG
NATIVE {CxObjError} PROC
PROC CxObjError(co:PTR TO CXOBJ) IS NATIVE {CxObjError(} co {)} ENDNATIVE !!VALUE
NATIVE {ClearCxObjError} PROC
PROC ClearCxObjError(co:PTR TO CXOBJ) IS NATIVE {ClearCxObjError(} co {)} ENDNATIVE
NATIVE {SetCxObjPri} PROC
PROC SetCxObjPri(co:PTR TO CXOBJ, pri:VALUE) IS NATIVE {SetCxObjPri(} co {,} pri {)} ENDNATIVE !!VALUE
NATIVE {AttachCxObj} PROC
PROC AttachCxObj(headObj:PTR TO CXOBJ, co:PTR TO CXOBJ) IS NATIVE {AttachCxObj(} headObj {,} co {)} ENDNATIVE
NATIVE {EnqueueCxObj} PROC
PROC EnqueueCxObj(headObj:PTR TO CXOBJ, co:PTR TO CXOBJ) IS NATIVE {EnqueueCxObj(} headObj {,} co {)} ENDNATIVE
NATIVE {InsertCxObj} PROC
PROC InsertCxObj(headObj:PTR TO CXOBJ, co:PTR TO CXOBJ, pred:PTR TO CXOBJ) IS NATIVE {InsertCxObj(} headObj {,} co {,} pred {)} ENDNATIVE
NATIVE {RemoveCxObj} PROC
PROC RemoveCxObj(co:PTR TO CXOBJ) IS NATIVE {RemoveCxObj(} co {)} ENDNATIVE
NATIVE {SetTranslate} PROC
PROC SetTranslate(translator:PTR TO CXOBJ, events:PTR TO inputevent) IS NATIVE {SetTranslate(} translator {,} events {)} ENDNATIVE
NATIVE {SetFilter} PROC
PROC SetFilter(filter:PTR TO CXOBJ, text:/*STRPTR*/ ARRAY OF CHAR) IS NATIVE {SetFilter(} filter {,} text {)} ENDNATIVE
NATIVE {SetFilterIX} PROC
PROC SetFilterIX(filter:PTR TO CXOBJ, ix:PTR TO /*IX*/ inputxpression) IS NATIVE {SetFilterIX(} filter {,} ix {)} ENDNATIVE
NATIVE {ParseIX} PROC
PROC ParseIX(desc:/*STRPTR*/ ARRAY OF CHAR, ix:PTR TO /*IX*/ inputxpression) IS NATIVE {ParseIX(} desc {,} ix {)} ENDNATIVE !!VALUE
NATIVE {CxMsgType} PROC
PROC CxMsgType(cxm:PTR TO CXMSG) IS NATIVE {CxMsgType(} cxm {)} ENDNATIVE !!ULONG
NATIVE {CxMsgData} PROC
PROC CxMsgData(cxm:PTR TO CXMSG) IS NATIVE {CxMsgData(} cxm {)} ENDNATIVE !!APTR
NATIVE {CxMsgID} PROC
PROC CxMsgID(cxm:PTR TO CXMSG) IS NATIVE {CxMsgID(} cxm {)} ENDNATIVE !!VALUE
NATIVE {DivertCxMsg} PROC
PROC DivertCxMsg(cxm:PTR TO CXMSG, headObj:PTR TO CXOBJ, returnObj:PTR TO CXOBJ) IS NATIVE {DivertCxMsg(} cxm {,} headObj {,} returnObj {)} ENDNATIVE
NATIVE {RouteCxMsg} PROC
PROC RouteCxMsg(cxm:PTR TO CXMSG, co:PTR TO CXOBJ) IS NATIVE {RouteCxMsg(} cxm {,} co {)} ENDNATIVE
NATIVE {DisposeCxMsg} PROC
PROC DisposeCxMsg(cxm:PTR TO CXMSG) IS NATIVE {DisposeCxMsg(} cxm {)} ENDNATIVE
NATIVE {InvertKeyMap} PROC
PROC InvertKeyMap(ansiCode:ULONG, event:PTR TO inputevent, km:PTR TO keymap) IS NATIVE {-InvertKeyMap(} ansiCode {,} event {,} km {)} ENDNATIVE !!INT
NATIVE {AddIEvents} PROC
PROC AddIEvents(events:PTR TO inputevent) IS NATIVE {AddIEvents(} events {)} ENDNATIVE
NATIVE {CopyBrokerList} PROC
PROC CopyBrokerList(CopyofList:PTR TO lh) IS NATIVE {CopyBrokerList(} CopyofList {)} ENDNATIVE !!VALUE
NATIVE {FreeBrokerList} PROC
PROC FreeBrokerList(brokerList:PTR TO lh) IS NATIVE {FreeBrokerList(} brokerList {)} ENDNATIVE
NATIVE {BrokerCommand} PROC
PROC BrokerCommand(name:/*STRPTR*/ ARRAY OF CHAR, command:ULONG) IS NATIVE {BrokerCommand(} name {,} command {)} ENDNATIVE !!ULONG
NATIVE {MatchIX} PROC
PROC MatchIX(event:PTR TO inputevent, ix:PTR TO /*IX*/ inputxpression) IS NATIVE {-MatchIX(} event {,} ix {)} ENDNATIVE !!INT
