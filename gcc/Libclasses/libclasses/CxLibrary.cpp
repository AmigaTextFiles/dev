
#ifndef _CXLIBRARY_CPP
#define _CXLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/CxLibrary.h>

CxLibrary::CxLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("cx.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open cx.library") );
	}
}

CxLibrary::~CxLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

CxObj * CxLibrary::CreateCxObj(ULONG type, LONG arg1, LONG arg2)
{
	register CxObj * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = type;
	register int a0 __asm("a0") = arg1;
	register int a1 __asm("a1") = arg2;

	__asm volatile ("jsr a6@(-30)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (a0), "r" (a1)
	: "d0", "a0", "a1");
	return (CxObj *) _res;
}

CxObj * CxLibrary::CxBroker(CONST struct NewBroker * nb, LONG * error)
{
	register CxObj * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = nb;
	register void * d0 __asm("d0") = error;

	__asm volatile ("jsr a6@(-36)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (CxObj *) _res;
}

LONG CxLibrary::ActivateCxObj(CxObj * co, LONG condition)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = co;
	register int d0 __asm("d0") = true;

	__asm volatile ("jsr a6@(-42)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (LONG) _res;
}

VOID CxLibrary::DeleteCxObj(CxObj * co)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = co;

	__asm volatile ("jsr a6@(-48)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID CxLibrary::DeleteCxObjAll(CxObj * co)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = co;

	__asm volatile ("jsr a6@(-54)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

ULONG CxLibrary::CxObjType(CONST CxObj * co)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = co;

	__asm volatile ("jsr a6@(-60)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (ULONG) _res;
}

LONG CxLibrary::CxObjError(CONST CxObj * co)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = co;

	__asm volatile ("jsr a6@(-66)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (LONG) _res;
}

VOID CxLibrary::ClearCxObjError(CxObj * co)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = co;

	__asm volatile ("jsr a6@(-72)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

LONG CxLibrary::SetCxObjPri(CxObj * co, LONG pri)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = co;
	register int d0 __asm("d0") = pri;

	__asm volatile ("jsr a6@(-78)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (LONG) _res;
}

VOID CxLibrary::AttachCxObj(CxObj * headObj, CxObj * co)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = headObj;
	register void * a1 __asm("a1") = co;

	__asm volatile ("jsr a6@(-84)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

VOID CxLibrary::EnqueueCxObj(CxObj * headObj, CxObj * co)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = headObj;
	register void * a1 __asm("a1") = co;

	__asm volatile ("jsr a6@(-90)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

VOID CxLibrary::InsertCxObj(CxObj * headObj, CxObj * co, CxObj * pred)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = headObj;
	register void * a1 __asm("a1") = co;
	register void * a2 __asm("a2") = pred;

	__asm volatile ("jsr a6@(-96)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
}

VOID CxLibrary::RemoveCxObj(CxObj * co)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = co;

	__asm volatile ("jsr a6@(-102)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID CxLibrary::SetTranslate(CxObj * translator, struct InputEvent * events)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = translator;
	register void * a1 __asm("a1") = events;

	__asm volatile ("jsr a6@(-114)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

VOID CxLibrary::SetFilter(CxObj * filter, CONST_STRPTR text)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = filter;
	register const char * a1 __asm("a1") = text;

	__asm volatile ("jsr a6@(-120)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

VOID CxLibrary::SetFilterIX(CxObj * filter, CONST IX * ix)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = filter;
	register const void * a1 __asm("a1") = ix;

	__asm volatile ("jsr a6@(-126)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

LONG CxLibrary::ParseIX(CONST_STRPTR description, IX * ix)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * a0 __asm("a0") = description;
	register void * a1 __asm("a1") = ix;

	__asm volatile ("jsr a6@(-132)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (LONG) _res;
}

ULONG CxLibrary::CxMsgType(CONST CxMsg * cxm)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = cxm;

	__asm volatile ("jsr a6@(-138)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (ULONG) _res;
}

APTR CxLibrary::CxMsgData(CONST CxMsg * cxm)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = cxm;

	__asm volatile ("jsr a6@(-144)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (APTR) _res;
}

LONG CxLibrary::CxMsgID(CONST CxMsg * cxm)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = cxm;

	__asm volatile ("jsr a6@(-150)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (LONG) _res;
}

VOID CxLibrary::DivertCxMsg(CxMsg * cxm, CxObj * headObj, CxObj * returnObj)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = cxm;
	register void * a1 __asm("a1") = headObj;
	register void * a2 __asm("a2") = returnObj;

	__asm volatile ("jsr a6@(-156)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
}

VOID CxLibrary::RouteCxMsg(CxMsg * cxm, CxObj * co)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = cxm;
	register void * a1 __asm("a1") = co;

	__asm volatile ("jsr a6@(-162)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

VOID CxLibrary::DisposeCxMsg(CxMsg * cxm)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = cxm;

	__asm volatile ("jsr a6@(-168)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

BOOL CxLibrary::InvertKeyMap(ULONG ansiCode, struct InputEvent * event, CONST struct KeyMap * km)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = ansiCode;
	register void * a0 __asm("a0") = event;
	register const void * a1 __asm("a1") = km;

	__asm volatile ("jsr a6@(-174)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (a0), "r" (a1)
	: "d0", "a0", "a1");
	return (BOOL) _res;
}

VOID CxLibrary::AddIEvents(struct InputEvent * events)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = events;

	__asm volatile ("jsr a6@(-180)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

BOOL CxLibrary::MatchIX(CONST struct InputEvent * event, CONST IX * ix)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = event;
	register const void * a1 __asm("a1") = ix;

	__asm volatile ("jsr a6@(-204)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}


#endif

