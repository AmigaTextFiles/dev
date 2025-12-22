
#ifndef _CXLIBRARY_H
#define _CXLIBRARY_H

#include <exec/types.h>
#include <exec/nodes.h>
#include <libraries/commodities.h>
#include <devices/inputevent.h>
#include <devices/keymap.h>

class CxLibrary
{
public:
	CxLibrary();
	~CxLibrary();

	static class CxLibrary Default;

	CxObj * CreateCxObj(ULONG type, LONG arg1, LONG arg2);
	CxObj * CxBroker(CONST struct NewBroker * nb, LONG * error);
	LONG ActivateCxObj(CxObj * co, LONG condition);
	VOID DeleteCxObj(CxObj * co);
	VOID DeleteCxObjAll(CxObj * co);
	ULONG CxObjType(CONST CxObj * co);
	LONG CxObjError(CONST CxObj * co);
	VOID ClearCxObjError(CxObj * co);
	LONG SetCxObjPri(CxObj * co, LONG pri);
	VOID AttachCxObj(CxObj * headObj, CxObj * co);
	VOID EnqueueCxObj(CxObj * headObj, CxObj * co);
	VOID InsertCxObj(CxObj * headObj, CxObj * co, CxObj * pred);
	VOID RemoveCxObj(CxObj * co);
	VOID SetTranslate(CxObj * translator, struct InputEvent * events);
	VOID SetFilter(CxObj * filter, CONST_STRPTR text);
	VOID SetFilterIX(CxObj * filter, CONST IX * ix);
	LONG ParseIX(CONST_STRPTR description, IX * ix);
	ULONG CxMsgType(CONST CxMsg * cxm);
	APTR CxMsgData(CONST CxMsg * cxm);
	LONG CxMsgID(CONST CxMsg * cxm);
	VOID DivertCxMsg(CxMsg * cxm, CxObj * headObj, CxObj * returnObj);
	VOID RouteCxMsg(CxMsg * cxm, CxObj * co);
	VOID DisposeCxMsg(CxMsg * cxm);
	BOOL InvertKeyMap(ULONG ansiCode, struct InputEvent * event, CONST struct KeyMap * km);
	VOID AddIEvents(struct InputEvent * events);
	BOOL MatchIX(CONST struct InputEvent * event, CONST IX * ix);

private:
	struct Library *Base;
};

CxLibrary CxLibrary::Default;

#endif

