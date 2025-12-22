/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_COMMODITIES_H
#define _PPCINLINE_COMMODITIES_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef COMMODITIES_BASE_NAME
#define COMMODITIES_BASE_NAME CxBase
#endif /* !COMMODITIES_BASE_NAME */

#define ActivateCxObj(co, true) \
	LP2(0x2a, LONG, ActivateCxObj, CxObj *, co, a0, LONG, true, d0, \
	, COMMODITIES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define AddIEvents(events) \
	LP1NR(0xb4, AddIEvents, struct InputEvent *, events, a0, \
	, COMMODITIES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define AttachCxObj(headObj, co) \
	LP2NR(0x54, AttachCxObj, CxObj *, headObj, a0, CxObj *, co, a1, \
	, COMMODITIES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ClearCxObjError(co) \
	LP1NR(0x48, ClearCxObjError, CxObj *, co, a0, \
	, COMMODITIES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define CreateCxObj(type, arg1, arg2) \
	LP3(0x1e, CxObj *, CreateCxObj, ULONG, type, d0, LONG, arg1, a0, LONG, arg2, a1, \
	, COMMODITIES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define CxBroker(nb, error) \
	LP2(0x24, CxObj *, CxBroker, CONST struct NewBroker *, nb, a0, LONG *, error, d0, \
	, COMMODITIES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define CxMsgData(cxm) \
	LP1(0x90, APTR, CxMsgData, CONST CxMsg *, cxm, a0, \
	, COMMODITIES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define CxMsgID(cxm) \
	LP1(0x96, LONG, CxMsgID, CONST CxMsg *, cxm, a0, \
	, COMMODITIES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define CxMsgType(cxm) \
	LP1(0x8a, ULONG, CxMsgType, CONST CxMsg *, cxm, a0, \
	, COMMODITIES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define CxObjError(co) \
	LP1(0x42, LONG, CxObjError, CONST CxObj *, co, a0, \
	, COMMODITIES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define CxObjType(co) \
	LP1(0x3c, ULONG, CxObjType, CONST CxObj *, co, a0, \
	, COMMODITIES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define DeleteCxObj(co) \
	LP1NR(0x30, DeleteCxObj, CxObj *, co, a0, \
	, COMMODITIES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define DeleteCxObjAll(co) \
	LP1NR(0x36, DeleteCxObjAll, CxObj *, co, a0, \
	, COMMODITIES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define DisposeCxMsg(cxm) \
	LP1NR(0xa8, DisposeCxMsg, CxMsg *, cxm, a0, \
	, COMMODITIES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define DivertCxMsg(cxm, headObj, returnObj) \
	LP3NR(0x9c, DivertCxMsg, CxMsg *, cxm, a0, CxObj *, headObj, a1, CxObj *, returnObj, a2, \
	, COMMODITIES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define EnqueueCxObj(headObj, co) \
	LP2NR(0x5a, EnqueueCxObj, CxObj *, headObj, a0, CxObj *, co, a1, \
	, COMMODITIES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define InsertCxObj(headObj, co, pred) \
	LP3NR(0x60, InsertCxObj, CxObj *, headObj, a0, CxObj *, co, a1, CxObj *, pred, a2, \
	, COMMODITIES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define InvertKeyMap(ansiCode, event, km) \
	LP3(0xae, BOOL, InvertKeyMap, ULONG, ansiCode, d0, struct InputEvent *, event, a0, CONST struct KeyMap *, km, a1, \
	, COMMODITIES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define MatchIX(event, ix) \
	LP2(0xcc, BOOL, MatchIX, CONST struct InputEvent *, event, a0, CONST IX *, ix, a1, \
	, COMMODITIES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ParseIX(description, ix) \
	LP2(0x84, LONG, ParseIX, CONST_STRPTR, description, a0, IX *, ix, a1, \
	, COMMODITIES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define RemoveCxObj(co) \
	LP1NR(0x66, RemoveCxObj, CxObj *, co, a0, \
	, COMMODITIES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define RouteCxMsg(cxm, co) \
	LP2NR(0xa2, RouteCxMsg, CxMsg *, cxm, a0, CxObj *, co, a1, \
	, COMMODITIES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SetCxObjPri(co, pri) \
	LP2(0x4e, LONG, SetCxObjPri, CxObj *, co, a0, LONG, pri, d0, \
	, COMMODITIES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SetFilter(filter, text) \
	LP2NR(0x78, SetFilter, CxObj *, filter, a0, CONST_STRPTR, text, a1, \
	, COMMODITIES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SetFilterIX(filter, ix) \
	LP2NR(0x7e, SetFilterIX, CxObj *, filter, a0, CONST IX *, ix, a1, \
	, COMMODITIES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SetTranslate(translator, events) \
	LP2NR(0x72, SetTranslate, CxObj *, translator, a0, struct InputEvent *, events, a1, \
	, COMMODITIES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_COMMODITIES_H */
