#ifndef _INCLUDE_PRAGMA_COMMODITIES_LIB_H
#define _INCLUDE_PRAGMA_COMMODITIES_LIB_H

/*
**  $VER: commodities_lib.h 10.1 (19.7.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_COMMODITIES_PROTOS_H
#include <clib/commodities_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(CxBase, 0x1e, CreateCxObj(d0,a0,a1))
#pragma amicall(CxBase, 0x24, CxBroker(a0,d0))
#pragma amicall(CxBase, 0x2a, ActivateCxObj(a0,d0))
#pragma amicall(CxBase, 0x30, DeleteCxObj(a0))
#pragma amicall(CxBase, 0x36, DeleteCxObjAll(a0))
#pragma amicall(CxBase, 0x3c, CxObjType(a0))
#pragma amicall(CxBase, 0x42, CxObjError(a0))
#pragma amicall(CxBase, 0x48, ClearCxObjError(a0))
#pragma amicall(CxBase, 0x4e, SetCxObjPri(a0,d0))
#pragma amicall(CxBase, 0x54, AttachCxObj(a0,a1))
#pragma amicall(CxBase, 0x5a, EnqueueCxObj(a0,a1))
#pragma amicall(CxBase, 0x60, InsertCxObj(a0,a1,a2))
#pragma amicall(CxBase, 0x66, RemoveCxObj(a0))
#pragma amicall(CxBase, 0x72, SetTranslate(a0,a1))
#pragma amicall(CxBase, 0x78, SetFilter(a0,a1))
#pragma amicall(CxBase, 0x7e, SetFilterIX(a0,a1))
#pragma amicall(CxBase, 0x84, ParseIX(a0,a1))
#pragma amicall(CxBase, 0x8a, CxMsgType(a0))
#pragma amicall(CxBase, 0x90, CxMsgData(a0))
#pragma amicall(CxBase, 0x96, CxMsgID(a0))
#pragma amicall(CxBase, 0x9c, DivertCxMsg(a0,a1,a2))
#pragma amicall(CxBase, 0xa2, RouteCxMsg(a0,a1))
#pragma amicall(CxBase, 0xa8, DisposeCxMsg(a0))
#pragma amicall(CxBase, 0xae, InvertKeyMap(d0,a0,a1))
#pragma amicall(CxBase, 0xb4, AddIEvents(a0))
#pragma amicall(CxBase, 0xcc, MatchIX(a0,a1))

#ifdef __cplusplus
}
#endif

#endif
