
#ifndef _DATATYPESLIBRARY_CPP
#define _DATATYPESLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/DataTypesLibrary.h>

DataTypesLibrary::DataTypesLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("datatypes.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open datatypes.library") );
	}
}

DataTypesLibrary::~DataTypesLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

struct DataType * DataTypesLibrary::ObtainDataTypeA(ULONG type, APTR handle, struct TagItem * attrs)
{
	register struct DataType * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = type;
	register void * a0 __asm("a0") = handle;
	register void * a1 __asm("a1") = attrs;

	__asm volatile ("jsr a6@(-36)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (a0), "r" (a1)
	: "d0", "a0", "a1");
	return (struct DataType *) _res;
}

VOID DataTypesLibrary::ReleaseDataType(struct DataType * dt)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = dt;

	__asm volatile ("jsr a6@(-42)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

Object * DataTypesLibrary::NewDTObjectA(APTR name, struct TagItem * attrs)
{
	register Object * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * d0 __asm("d0") = name;
	register void * a0 __asm("a0") = attrs;

	__asm volatile ("jsr a6@(-48)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (a0)
	: "d0", "a0");
	return (Object *) _res;
}

VOID DataTypesLibrary::DisposeDTObject(Object * o)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = o;

	__asm volatile ("jsr a6@(-54)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

ULONG DataTypesLibrary::SetDTAttrsA(Object * o, struct Window * win, struct Requester * req, struct TagItem * attrs)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = o;
	register void * a1 __asm("a1") = win;
	register void * a2 __asm("a2") = req;
	register void * a3 __asm("a3") = attrs;

	__asm volatile ("jsr a6@(-60)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
	: "a0", "a1", "a2", "a3");
	return (ULONG) _res;
}

ULONG DataTypesLibrary::GetDTAttrsA(Object * o, struct TagItem * attrs)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = o;
	register void * a2 __asm("a2") = attrs;

	__asm volatile ("jsr a6@(-66)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a2)
	: "a0", "a2");
	return (ULONG) _res;
}

LONG DataTypesLibrary::AddDTObject(struct Window * win, struct Requester * req, Object * o, LONG pos)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = win;
	register void * a1 __asm("a1") = req;
	register void * a2 __asm("a2") = o;
	register int d0 __asm("d0") = pos;

	__asm volatile ("jsr a6@(-72)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (d0)
	: "a0", "a1", "a2", "d0");
	return (LONG) _res;
}

VOID DataTypesLibrary::RefreshDTObjectA(Object * o, struct Window * win, struct Requester * req, struct TagItem * attrs)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = o;
	register void * a1 __asm("a1") = win;
	register void * a2 __asm("a2") = req;
	register void * a3 __asm("a3") = attrs;

	__asm volatile ("jsr a6@(-78)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
	: "a0", "a1", "a2", "a3");
}

ULONG DataTypesLibrary::DoAsyncLayout(Object * o, struct gpLayout * gpl)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = o;
	register void * a1 __asm("a1") = gpl;

	__asm volatile ("jsr a6@(-84)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (ULONG) _res;
}

ULONG DataTypesLibrary::DoDTMethodA(Object * o, struct Window * win, struct Requester * req, Msg msg)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = o;
	register void * a1 __asm("a1") = win;
	register void * a2 __asm("a2") = req;
	register Msg a3 __asm("a3") = msg;

	__asm volatile ("jsr a6@(-90)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
	: "a0", "a1", "a2", "a3");
	return (ULONG) _res;
}

LONG DataTypesLibrary::RemoveDTObject(struct Window * win, Object * o)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = win;
	register void * a1 __asm("a1") = o;

	__asm volatile ("jsr a6@(-96)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (LONG) _res;
}

ULONG * DataTypesLibrary::GetDTMethods(Object * object)
{
	register ULONG * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = object;

	__asm volatile ("jsr a6@(-102)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (ULONG *) _res;
}

struct DTMethods * DataTypesLibrary::GetDTTriggerMethods(Object * object)
{
	register struct DTMethods * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = object;

	__asm volatile ("jsr a6@(-108)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct DTMethods *) _res;
}

ULONG DataTypesLibrary::PrintDTObjectA(Object * o, struct Window * w, struct Requester * r, struct dtPrint * msg)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = o;
	register void * a1 __asm("a1") = w;
	register void * a2 __asm("a2") = r;
	register void * a3 __asm("a3") = msg;

	__asm volatile ("jsr a6@(-114)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
	: "a0", "a1", "a2", "a3");
	return (ULONG) _res;
}

STRPTR DataTypesLibrary::GetDTString(ULONG id)
{
	register STRPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = id;

	__asm volatile ("jsr a6@(-138)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (STRPTR) _res;
}


#endif

