
#ifndef _IFFPARSELIBRARY_CPP
#define _IFFPARSELIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/IFFParseLibrary.h>

IFFParseLibrary::IFFParseLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("iffparse.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open iffparse.library") );
	}
}

IFFParseLibrary::~IFFParseLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

struct IFFHandle * IFFParseLibrary::AllocIFF()
{
	register struct IFFHandle * _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-30)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (struct IFFHandle *) _res;
}

LONG IFFParseLibrary::OpenIFF(struct IFFHandle * iff, LONG rwMode)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = iff;
	register int d0 __asm("d0") = rwMode;

	__asm volatile ("jsr a6@(-36)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (LONG) _res;
}

LONG IFFParseLibrary::ParseIFF(struct IFFHandle * iff, LONG control)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = iff;
	register int d0 __asm("d0") = control;

	__asm volatile ("jsr a6@(-42)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (LONG) _res;
}

VOID IFFParseLibrary::CloseIFF(struct IFFHandle * iff)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = iff;

	__asm volatile ("jsr a6@(-48)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID IFFParseLibrary::FreeIFF(struct IFFHandle * iff)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = iff;

	__asm volatile ("jsr a6@(-54)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

LONG IFFParseLibrary::ReadChunkBytes(struct IFFHandle * iff, APTR buf, LONG numBytes)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = iff;
	register void * a1 __asm("a1") = buf;
	register int d0 __asm("d0") = numBytes;

	__asm volatile ("jsr a6@(-60)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
	return (LONG) _res;
}

LONG IFFParseLibrary::WriteChunkBytes(struct IFFHandle * iff, CONST APTR buf, LONG numBytes)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = iff;
	register const void * a1 __asm("a1") = buf;
	register int d0 __asm("d0") = numBytes;

	__asm volatile ("jsr a6@(-66)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
	return (LONG) _res;
}

LONG IFFParseLibrary::ReadChunkRecords(struct IFFHandle * iff, APTR buf, LONG bytesPerRecord, LONG numRecords)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = iff;
	register void * a1 __asm("a1") = buf;
	register int d0 __asm("d0") = bytesPerRecord;
	register int d1 __asm("d1") = numRecords;

	__asm volatile ("jsr a6@(-72)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1)
	: "a0", "a1", "d0", "d1");
	return (LONG) _res;
}

LONG IFFParseLibrary::WriteChunkRecords(struct IFFHandle * iff, CONST APTR buf, LONG bytesPerRecord, LONG numRecords)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = iff;
	register const void * a1 __asm("a1") = buf;
	register int d0 __asm("d0") = bytesPerRecord;
	register int d1 __asm("d1") = numRecords;

	__asm volatile ("jsr a6@(-78)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1)
	: "a0", "a1", "d0", "d1");
	return (LONG) _res;
}

LONG IFFParseLibrary::PushChunk(struct IFFHandle * iff, LONG type, LONG id, LONG size)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = iff;
	register int d0 __asm("d0") = type;
	register int d1 __asm("d1") = id;
	register int d2 __asm("d2") = size;

	__asm volatile ("jsr a6@(-84)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2)
	: "a0", "d0", "d1", "d2");
	return (LONG) _res;
}

LONG IFFParseLibrary::PopChunk(struct IFFHandle * iff)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = iff;

	__asm volatile ("jsr a6@(-90)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (LONG) _res;
}

LONG IFFParseLibrary::EntryHandler(struct IFFHandle * iff, LONG type, LONG id, LONG position, struct Hook * handler, APTR object)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = iff;
	register int d0 __asm("d0") = type;
	register int d1 __asm("d1") = id;
	register int d2 __asm("d2") = position;
	register void * a1 __asm("a1") = handler;
	register void * a2 __asm("a2") = object;

	__asm volatile ("jsr a6@(-102)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (a1), "r" (a2)
	: "a0", "d0", "d1", "d2", "a1", "a2");
	return (LONG) _res;
}

LONG IFFParseLibrary::ExitHandler(struct IFFHandle * iff, LONG type, LONG id, LONG position, struct Hook * handler, APTR object)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = iff;
	register int d0 __asm("d0") = type;
	register int d1 __asm("d1") = id;
	register int d2 __asm("d2") = position;
	register void * a1 __asm("a1") = handler;
	register void * a2 __asm("a2") = object;

	__asm volatile ("jsr a6@(-108)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (a1), "r" (a2)
	: "a0", "d0", "d1", "d2", "a1", "a2");
	return (LONG) _res;
}

LONG IFFParseLibrary::PropChunk(struct IFFHandle * iff, LONG type, LONG id)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = iff;
	register int d0 __asm("d0") = type;
	register int d1 __asm("d1") = id;

	__asm volatile ("jsr a6@(-114)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1)
	: "a0", "d0", "d1");
	return (LONG) _res;
}

LONG IFFParseLibrary::PropChunks(struct IFFHandle * iff, CONST LONG * propArray, LONG numPairs)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = iff;
	register const void * a1 __asm("a1") = propArray;
	register int d0 __asm("d0") = numPairs;

	__asm volatile ("jsr a6@(-120)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
	return (LONG) _res;
}

LONG IFFParseLibrary::StopChunk(struct IFFHandle * iff, LONG type, LONG id)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = iff;
	register int d0 __asm("d0") = type;
	register int d1 __asm("d1") = id;

	__asm volatile ("jsr a6@(-126)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1)
	: "a0", "d0", "d1");
	return (LONG) _res;
}

LONG IFFParseLibrary::StopChunks(struct IFFHandle * iff, CONST LONG * propArray, LONG numPairs)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = iff;
	register const void * a1 __asm("a1") = propArray;
	register int d0 __asm("d0") = numPairs;

	__asm volatile ("jsr a6@(-132)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
	return (LONG) _res;
}

LONG IFFParseLibrary::CollectionChunk(struct IFFHandle * iff, LONG type, LONG id)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = iff;
	register int d0 __asm("d0") = type;
	register int d1 __asm("d1") = id;

	__asm volatile ("jsr a6@(-138)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1)
	: "a0", "d0", "d1");
	return (LONG) _res;
}

LONG IFFParseLibrary::CollectionChunks(struct IFFHandle * iff, CONST LONG * propArray, LONG numPairs)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = iff;
	register const void * a1 __asm("a1") = propArray;
	register int d0 __asm("d0") = numPairs;

	__asm volatile ("jsr a6@(-144)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
	return (LONG) _res;
}

LONG IFFParseLibrary::StopOnExit(struct IFFHandle * iff, LONG type, LONG id)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = iff;
	register int d0 __asm("d0") = type;
	register int d1 __asm("d1") = id;

	__asm volatile ("jsr a6@(-150)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1)
	: "a0", "d0", "d1");
	return (LONG) _res;
}

struct StoredProperty * IFFParseLibrary::FindProp(CONST struct IFFHandle * iff, LONG type, LONG id)
{
	register struct StoredProperty * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = iff;
	register int d0 __asm("d0") = type;
	register int d1 __asm("d1") = id;

	__asm volatile ("jsr a6@(-156)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1)
	: "a0", "d0", "d1");
	return (struct StoredProperty *) _res;
}

struct CollectionItem * IFFParseLibrary::FindCollection(CONST struct IFFHandle * iff, LONG type, LONG id)
{
	register struct CollectionItem * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = iff;
	register int d0 __asm("d0") = type;
	register int d1 __asm("d1") = id;

	__asm volatile ("jsr a6@(-162)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1)
	: "a0", "d0", "d1");
	return (struct CollectionItem *) _res;
}

struct ContextNode * IFFParseLibrary::FindPropContext(CONST struct IFFHandle * iff)
{
	register struct ContextNode * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = iff;

	__asm volatile ("jsr a6@(-168)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct ContextNode *) _res;
}

struct ContextNode * IFFParseLibrary::CurrentChunk(CONST struct IFFHandle * iff)
{
	register struct ContextNode * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = iff;

	__asm volatile ("jsr a6@(-174)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct ContextNode *) _res;
}

struct ContextNode * IFFParseLibrary::ParentChunk(CONST struct ContextNode * contextNode)
{
	register struct ContextNode * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = contextNode;

	__asm volatile ("jsr a6@(-180)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct ContextNode *) _res;
}

struct LocalContextItem * IFFParseLibrary::AllocLocalItem(LONG type, LONG id, LONG ident, LONG dataSize)
{
	register struct LocalContextItem * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int d0 __asm("d0") = type;
	register int d1 __asm("d1") = id;
	register int d2 __asm("d2") = ident;
	register int d3 __asm("d3") = dataSize;

	__asm volatile ("jsr a6@(-186)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
	: "d0", "d1", "d2", "d3");
	return (struct LocalContextItem *) _res;
}

APTR IFFParseLibrary::LocalItemData(CONST struct LocalContextItem * localItem)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = localItem;

	__asm volatile ("jsr a6@(-192)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (APTR) _res;
}

VOID IFFParseLibrary::SetLocalItemPurge(struct LocalContextItem * localItem, CONST struct Hook * purgeHook)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = localItem;
	register const void * a1 __asm("a1") = purgeHook;

	__asm volatile ("jsr a6@(-198)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

VOID IFFParseLibrary::FreeLocalItem(struct LocalContextItem * localItem)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = localItem;

	__asm volatile ("jsr a6@(-204)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

struct LocalContextItem * IFFParseLibrary::FindLocalItem(CONST struct IFFHandle * iff, LONG type, LONG id, LONG ident)
{
	register struct LocalContextItem * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = iff;
	register int d0 __asm("d0") = type;
	register int d1 __asm("d1") = id;
	register int d2 __asm("d2") = ident;

	__asm volatile ("jsr a6@(-210)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2)
	: "a0", "d0", "d1", "d2");
	return (struct LocalContextItem *) _res;
}

LONG IFFParseLibrary::StoreLocalItem(struct IFFHandle * iff, struct LocalContextItem * localItem, LONG position)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = iff;
	register void * a1 __asm("a1") = localItem;
	register int d0 __asm("d0") = position;

	__asm volatile ("jsr a6@(-216)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
	return (LONG) _res;
}

VOID IFFParseLibrary::StoreItemInContext(struct IFFHandle * iff, struct LocalContextItem * localItem, struct ContextNode * contextNode)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = iff;
	register void * a1 __asm("a1") = localItem;
	register void * a2 __asm("a2") = contextNode;

	__asm volatile ("jsr a6@(-222)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
}

VOID IFFParseLibrary::InitIFF(struct IFFHandle * iff, LONG flags, CONST struct Hook * streamHook)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = iff;
	register int d0 __asm("d0") = flags;
	register const void * a1 __asm("a1") = streamHook;

	__asm volatile ("jsr a6@(-228)"
	: 
	: "r" (a6), "r" (a0), "r" (d0), "r" (a1)
	: "a0", "d0", "a1");
}

VOID IFFParseLibrary::InitIFFasDOS(struct IFFHandle * iff)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = iff;

	__asm volatile ("jsr a6@(-234)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID IFFParseLibrary::InitIFFasClip(struct IFFHandle * iff)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = iff;

	__asm volatile ("jsr a6@(-240)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

struct ClipboardHandle * IFFParseLibrary::OpenClipboard(LONG unitNumber)
{
	register struct ClipboardHandle * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int d0 __asm("d0") = unitNumber;

	__asm volatile ("jsr a6@(-246)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (struct ClipboardHandle *) _res;
}

VOID IFFParseLibrary::CloseClipboard(struct ClipboardHandle * clipHandle)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = clipHandle;

	__asm volatile ("jsr a6@(-252)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

LONG IFFParseLibrary::GoodID(LONG id)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int d0 __asm("d0") = id;

	__asm volatile ("jsr a6@(-258)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (LONG) _res;
}

LONG IFFParseLibrary::GoodType(LONG type)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int d0 __asm("d0") = type;

	__asm volatile ("jsr a6@(-264)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (LONG) _res;
}

STRPTR IFFParseLibrary::IDtoStr(LONG id, STRPTR buf)
{
	register STRPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int d0 __asm("d0") = id;
	register char * a0 __asm("a0") = buf;

	__asm volatile ("jsr a6@(-270)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (a0)
	: "d0", "a0");
	return (STRPTR) _res;
}


#endif

