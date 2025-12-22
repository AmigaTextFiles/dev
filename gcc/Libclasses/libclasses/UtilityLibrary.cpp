
#ifndef _UTILITYLIBRARY_CPP
#define _UTILITYLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/UtilityLibrary.h>

UtilityLibrary::UtilityLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("utility.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open utility.library") );
	}
}

UtilityLibrary::~UtilityLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

struct TagItem * UtilityLibrary::FindTagItem(Tag tagVal, CONST struct TagItem * tagList)
{
	register struct TagItem * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register Tag d0 __asm("d0") = tagVal;
	register const void * a0 __asm("a0") = tagList;

	__asm volatile ("jsr a6@(-30)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (a0)
	: "d0", "a0");
	return (struct TagItem *) _res;
}

ULONG UtilityLibrary::GetTagData(Tag tagValue, ULONG defaultVal, CONST struct TagItem * tagList)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register Tag d0 __asm("d0") = tagValue;
	register unsigned int d1 __asm("d1") = defaultVal;
	register const void * a0 __asm("a0") = tagList;

	__asm volatile ("jsr a6@(-36)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1), "r" (a0)
	: "d0", "d1", "a0");
	return (ULONG) _res;
}

ULONG UtilityLibrary::PackBoolTags(ULONG initialFlags, CONST struct TagItem * tagList, CONST struct TagItem * boolMap)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = initialFlags;
	register const void * a0 __asm("a0") = tagList;
	register const void * a1 __asm("a1") = boolMap;

	__asm volatile ("jsr a6@(-42)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (a0), "r" (a1)
	: "d0", "a0", "a1");
	return (ULONG) _res;
}

struct TagItem * UtilityLibrary::NextTagItem(struct TagItem ** tagListPtr)
{
	register struct TagItem * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = tagListPtr;

	__asm volatile ("jsr a6@(-48)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct TagItem *) _res;
}

VOID UtilityLibrary::FilterTagChanges(struct TagItem * changeList, struct TagItem * originalList, ULONG apply)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = changeList;
	register void * a1 __asm("a1") = originalList;
	register unsigned int d0 __asm("d0") = apply;

	__asm volatile ("jsr a6@(-54)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
}

VOID UtilityLibrary::MapTags(struct TagItem * tagList, CONST struct TagItem * mapList, ULONG mapType)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = tagList;
	register const void * a1 __asm("a1") = mapList;
	register unsigned int d0 __asm("d0") = mapType;

	__asm volatile ("jsr a6@(-60)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
}

struct TagItem * UtilityLibrary::AllocateTagItems(ULONG numTags)
{
	register struct TagItem * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = numTags;

	__asm volatile ("jsr a6@(-66)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (struct TagItem *) _res;
}

struct TagItem * UtilityLibrary::CloneTagItems(CONST struct TagItem * tagList)
{
	register struct TagItem * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = tagList;

	__asm volatile ("jsr a6@(-72)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct TagItem *) _res;
}

VOID UtilityLibrary::FreeTagItems(struct TagItem * tagList)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = tagList;

	__asm volatile ("jsr a6@(-78)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID UtilityLibrary::RefreshTagItemClones(struct TagItem * clone, CONST struct TagItem * original)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = clone;
	register const void * a1 __asm("a1") = original;

	__asm volatile ("jsr a6@(-84)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

BOOL UtilityLibrary::TagInArray(Tag tagValue, CONST Tag * tagArray)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register Tag d0 __asm("d0") = tagValue;
	register const void * a0 __asm("a0") = tagArray;

	__asm volatile ("jsr a6@(-90)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (a0)
	: "d0", "a0");
	return (BOOL) _res;
}

ULONG UtilityLibrary::FilterTagItems(struct TagItem * tagList, CONST Tag * filterArray, ULONG logic)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = tagList;
	register const void * a1 __asm("a1") = filterArray;
	register unsigned int d0 __asm("d0") = logic;

	__asm volatile ("jsr a6@(-96)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
	return (ULONG) _res;
}

ULONG UtilityLibrary::CallHookPkt(struct Hook * hook, APTR object, APTR paramPacket)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = hook;
	register void * a2 __asm("a2") = object;
	register void * a1 __asm("a1") = paramPacket;

	__asm volatile ("jsr a6@(-102)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a2), "r" (a1)
	: "a0", "a2", "a1");
	return (ULONG) _res;
}

VOID UtilityLibrary::Amiga2Date(ULONG seconds, struct ClockData * result)
{
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = seconds;
	register void * a0 __asm("a0") = result;

	__asm volatile ("jsr a6@(-120)"
	: 
	: "r" (a6), "r" (d0), "r" (a0)
	: "d0", "a0");
}

ULONG UtilityLibrary::Date2Amiga(CONST struct ClockData * date)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = date;

	__asm volatile ("jsr a6@(-126)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (ULONG) _res;
}

ULONG UtilityLibrary::CheckDate(CONST struct ClockData * date)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = date;

	__asm volatile ("jsr a6@(-132)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (ULONG) _res;
}

LONG UtilityLibrary::SMult32(LONG arg1, LONG arg2)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int d0 __asm("d0") = arg1;
	register int d1 __asm("d1") = arg2;

	__asm volatile ("jsr a6@(-138)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1)
	: "d0", "d1");
	return (LONG) _res;
}

ULONG UtilityLibrary::UMult32(ULONG arg1, ULONG arg2)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = arg1;
	register unsigned int d1 __asm("d1") = arg2;

	__asm volatile ("jsr a6@(-144)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1)
	: "d0", "d1");
	return (ULONG) _res;
}

LONG UtilityLibrary::SDivMod32(LONG dividend, LONG divisor)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int d0 __asm("d0") = dividend;
	register int d1 __asm("d1") = divisor;

	__asm volatile ("jsr a6@(-150)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1)
	: "d0", "d1");
	return (LONG) _res;
}

ULONG UtilityLibrary::UDivMod32(ULONG dividend, ULONG divisor)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = dividend;
	register unsigned int d1 __asm("d1") = divisor;

	__asm volatile ("jsr a6@(-156)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1)
	: "d0", "d1");
	return (ULONG) _res;
}

LONG UtilityLibrary::Stricmp(CONST_STRPTR string1, CONST_STRPTR string2)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * a0 __asm("a0") = string1;
	register const char * a1 __asm("a1") = string2;

	__asm volatile ("jsr a6@(-162)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (LONG) _res;
}

LONG UtilityLibrary::Strnicmp(CONST_STRPTR string1, CONST_STRPTR string2, LONG length)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * a0 __asm("a0") = string1;
	register const char * a1 __asm("a1") = string2;
	register int d0 __asm("d0") = length;

	__asm volatile ("jsr a6@(-168)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
	return (LONG) _res;
}

UBYTE UtilityLibrary::ToUpper(ULONG character)
{
	register UBYTE _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = character;

	__asm volatile ("jsr a6@(-174)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (UBYTE) _res;
}

UBYTE UtilityLibrary::ToLower(ULONG character)
{
	register UBYTE _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = character;

	__asm volatile ("jsr a6@(-180)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (UBYTE) _res;
}

VOID UtilityLibrary::ApplyTagChanges(struct TagItem * list, CONST struct TagItem * changeList)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = list;
	register const void * a1 __asm("a1") = changeList;

	__asm volatile ("jsr a6@(-186)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

LONG UtilityLibrary::SMult64(LONG arg1, LONG arg2)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int d0 __asm("d0") = arg1;
	register int d1 __asm("d1") = arg2;

	__asm volatile ("jsr a6@(-198)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1)
	: "d0", "d1");
	return (LONG) _res;
}

ULONG UtilityLibrary::UMult64(ULONG arg1, ULONG arg2)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = arg1;
	register unsigned int d1 __asm("d1") = arg2;

	__asm volatile ("jsr a6@(-204)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1)
	: "d0", "d1");
	return (ULONG) _res;
}

ULONG UtilityLibrary::PackStructureTags(APTR pack, CONST ULONG * packTable, CONST struct TagItem * tagList)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = pack;
	register const void * a1 __asm("a1") = packTable;
	register const void * a2 __asm("a2") = tagList;

	__asm volatile ("jsr a6@(-210)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
	return (ULONG) _res;
}

ULONG UtilityLibrary::UnpackStructureTags(CONST APTR pack, CONST ULONG * packTable, struct TagItem * tagList)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = pack;
	register const void * a1 __asm("a1") = packTable;
	register void * a2 __asm("a2") = tagList;

	__asm volatile ("jsr a6@(-216)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
	return (ULONG) _res;
}

BOOL UtilityLibrary::AddNamedObject(struct NamedObject * nameSpace, struct NamedObject * object)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = nameSpace;
	register void * a1 __asm("a1") = object;

	__asm volatile ("jsr a6@(-222)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}

struct NamedObject * UtilityLibrary::AllocNamedObjectA(CONST_STRPTR name, CONST struct TagItem * tagList)
{
	register struct NamedObject * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * a0 __asm("a0") = name;
	register const void * a1 __asm("a1") = tagList;

	__asm volatile ("jsr a6@(-228)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (struct NamedObject *) _res;
}

LONG UtilityLibrary::AttemptRemNamedObject(struct NamedObject * object)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = object;

	__asm volatile ("jsr a6@(-234)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (LONG) _res;
}

struct NamedObject * UtilityLibrary::FindNamedObject(struct NamedObject * nameSpace, CONST_STRPTR name, struct NamedObject * lastObject)
{
	register struct NamedObject * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = nameSpace;
	register const char * a1 __asm("a1") = name;
	register void * a2 __asm("a2") = lastObject;

	__asm volatile ("jsr a6@(-240)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
	return (struct NamedObject *) _res;
}

VOID UtilityLibrary::FreeNamedObject(struct NamedObject * object)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = object;

	__asm volatile ("jsr a6@(-246)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

STRPTR UtilityLibrary::NamedObjectName(struct NamedObject * object)
{
	register STRPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = object;

	__asm volatile ("jsr a6@(-252)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (STRPTR) _res;
}

VOID UtilityLibrary::ReleaseNamedObject(struct NamedObject * object)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = object;

	__asm volatile ("jsr a6@(-258)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID UtilityLibrary::RemNamedObject(struct NamedObject * object, struct Message * message)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = object;
	register void * a1 __asm("a1") = message;

	__asm volatile ("jsr a6@(-264)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

ULONG UtilityLibrary::GetUniqueID()
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-270)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (ULONG) _res;
}


#endif

