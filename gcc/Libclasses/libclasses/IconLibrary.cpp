
#ifndef _ICONLIBRARY_CPP
#define _ICONLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/IconLibrary.h>

IconLibrary::IconLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("icon.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open icon.library") );
	}
}

IconLibrary::~IconLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

VOID IconLibrary::FreeFreeList(struct FreeList * freelist)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = freelist;

	__asm volatile ("jsr a6@(-54)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

BOOL IconLibrary::AddFreeList(struct FreeList * freelist, CONST APTR mem, ULONG size)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = freelist;
	register const void * a1 __asm("a1") = mem;
	register unsigned int a2 __asm("a2") = size;

	__asm volatile ("jsr a6@(-72)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
	return (BOOL) _res;
}

struct DiskObject * IconLibrary::GetDiskObject(CONST_STRPTR name)
{
	register struct DiskObject * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * a0 __asm("a0") = name;

	__asm volatile ("jsr a6@(-78)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct DiskObject *) _res;
}

BOOL IconLibrary::PutDiskObject(CONST_STRPTR name, CONST struct DiskObject * diskobj)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * a0 __asm("a0") = name;
	register const void * a1 __asm("a1") = diskobj;

	__asm volatile ("jsr a6@(-84)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}

VOID IconLibrary::FreeDiskObject(struct DiskObject * diskobj)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = diskobj;

	__asm volatile ("jsr a6@(-90)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

UBYTE * IconLibrary::FindToolType(CONST_STRPTR * toolTypeArray, CONST_STRPTR typeName)
{
	register UBYTE * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = toolTypeArray;
	register const char * a1 __asm("a1") = typeName;

	__asm volatile ("jsr a6@(-96)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (UBYTE *) _res;
}

BOOL IconLibrary::MatchToolValue(CONST_STRPTR typeString, CONST_STRPTR value)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * a0 __asm("a0") = typeString;
	register const char * a1 __asm("a1") = value;

	__asm volatile ("jsr a6@(-102)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}

STRPTR IconLibrary::BumpRevision(STRPTR newname, CONST_STRPTR oldname)
{
	register STRPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register char * a0 __asm("a0") = newname;
	register const char * a1 __asm("a1") = oldname;

	__asm volatile ("jsr a6@(-108)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (STRPTR) _res;
}

struct DiskObject * IconLibrary::GetDefDiskObject(LONG type)
{
	register struct DiskObject * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int d0 __asm("d0") = type;

	__asm volatile ("jsr a6@(-120)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (struct DiskObject *) _res;
}

BOOL IconLibrary::PutDefDiskObject(CONST struct DiskObject * diskObject)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = diskObject;

	__asm volatile ("jsr a6@(-126)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (BOOL) _res;
}

struct DiskObject * IconLibrary::GetDiskObjectNew(CONST_STRPTR name)
{
	register struct DiskObject * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * a0 __asm("a0") = name;

	__asm volatile ("jsr a6@(-132)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct DiskObject *) _res;
}

BOOL IconLibrary::DeleteDiskObject(CONST_STRPTR name)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * a0 __asm("a0") = name;

	__asm volatile ("jsr a6@(-138)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (BOOL) _res;
}

struct DiskObject * IconLibrary::DupDiskObjectA(CONST struct DiskObject * diskObject, CONST struct TagItem * tags)
{
	register struct DiskObject * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = diskObject;
	register const void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-150)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (struct DiskObject *) _res;
}

ULONG IconLibrary::IconControlA(struct DiskObject * icon, CONST struct TagItem * tags)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = icon;
	register const void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-156)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (ULONG) _res;
}

VOID IconLibrary::DrawIconStateA(struct RastPort * rp, CONST struct DiskObject * icon, CONST_STRPTR label, LONG leftOffset, LONG topOffset, ULONG state, CONST struct TagItem * tags)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = rp;
	register const void * a1 __asm("a1") = icon;
	register const char * a2 __asm("a2") = label;
	register int d0 __asm("d0") = leftOffset;
	register int d1 __asm("d1") = topOffset;
	register unsigned int d2 __asm("d2") = state;
	register const void * a3 __asm("a3") = tags;

	__asm volatile ("jsr a6@(-162)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (d0), "r" (d1), "r" (d2), "r" (a3)
	: "a0", "a1", "a2", "d0", "d1", "d2", "a3");
}

BOOL IconLibrary::GetIconRectangleA(struct RastPort * rp, CONST struct DiskObject * icon, CONST_STRPTR label, struct Rectangle * rect, CONST struct TagItem * tags)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = rp;
	register const void * a1 __asm("a1") = icon;
	register const char * a2 __asm("a2") = label;
	register void * a3 __asm("a3") = rect;
	register const void * a4 __asm("a4") = tags;

	__asm volatile ("jsr a6@(-168)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3), "r" (a4)
	: "a0", "a1", "a2", "a3", "a4");
	return (BOOL) _res;
}

struct DiskObject * IconLibrary::NewDiskObject(LONG type)
{
	register struct DiskObject * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int d0 __asm("d0") = type;

	__asm volatile ("jsr a6@(-174)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (struct DiskObject *) _res;
}

struct DiskObject * IconLibrary::GetIconTagList(CONST_STRPTR name, CONST struct TagItem * tags)
{
	register struct DiskObject * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * a0 __asm("a0") = name;
	register const void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-180)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (struct DiskObject *) _res;
}

BOOL IconLibrary::PutIconTagList(CONST_STRPTR name, CONST struct DiskObject * icon, CONST struct TagItem * tags)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * a0 __asm("a0") = name;
	register const void * a1 __asm("a1") = icon;
	register const void * a2 __asm("a2") = tags;

	__asm volatile ("jsr a6@(-186)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
	return (BOOL) _res;
}

BOOL IconLibrary::LayoutIconA(struct DiskObject * icon, struct Screen * screen, struct TagItem * tags)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = icon;
	register void * a1 __asm("a1") = screen;
	register void * a2 __asm("a2") = tags;

	__asm volatile ("jsr a6@(-192)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
	return (BOOL) _res;
}

VOID IconLibrary::ChangeToSelectedIconColor(struct ColorRegister * cr)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = cr;

	__asm volatile ("jsr a6@(-198)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}


#endif

