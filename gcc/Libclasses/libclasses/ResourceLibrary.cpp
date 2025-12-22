
#ifndef _RESOURCELIBRARY_CPP
#define _RESOURCELIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/ResourceLibrary.h>

ResourceLibrary::ResourceLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("resource.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open resource.library") );
	}
}

ResourceLibrary::~ResourceLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

RESOURCEFILE ResourceLibrary::RL_OpenResource(void * resource, struct Screen * screen, struct Catalog * catalog)
{
	register RESOURCEFILE _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = resource;
	register void * a1 __asm("a1") = screen;
	register void * a2 __asm("a2") = catalog;

	__asm volatile ("jsr a6@(-30)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
	return (RESOURCEFILE) _res;
}

void ResourceLibrary::RL_CloseResource(RESOURCEFILE resfile)
{
	register void * a6 __asm("a6") = Base;
	register RESOURCEFILE a0 __asm("a0") = resfile;

	__asm volatile ("jsr a6@(-36)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

Object * ResourceLibrary::RL_NewObjectA(RESOURCEFILE resfile, RESOURCEID resourceid, struct TagItem * taglist)
{
	register Object * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register RESOURCEFILE a0 __asm("a0") = resfile;
	register RESOURCEID d0 __asm("d0") = resourceid;
	register void * a1 __asm("a1") = taglist;

	__asm volatile ("jsr a6@(-42)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (a1)
	: "a0", "d0", "a1");
	return (Object *) _res;
}

void ResourceLibrary::RL_DisposeObject(RESOURCEFILE resfile, Object * object)
{
	register void * a6 __asm("a6") = Base;
	register RESOURCEFILE a0 __asm("a0") = resfile;
	register void * a1 __asm("a1") = object;

	__asm volatile ("jsr a6@(-48)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

Object ** ResourceLibrary::RL_NewGroupA(RESOURCEFILE resfile, RESOURCEID resourceid, struct TagItem * taglist)
{
	register Object ** _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register RESOURCEFILE a0 __asm("a0") = resfile;
	register RESOURCEID d0 __asm("d0") = resourceid;
	register void * a1 __asm("a1") = taglist;

	__asm volatile ("jsr a6@(-54)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (a1)
	: "a0", "d0", "a1");
	return (Object **) _res;
}

void ResourceLibrary::RL_DisposeGroup(RESOURCEFILE resfile, Object ** objects)
{
	register void * a6 __asm("a6") = Base;
	register RESOURCEFILE a0 __asm("a0") = resfile;
	register void * a1 __asm("a1") = objects;

	__asm volatile ("jsr a6@(-60)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

Object ** ResourceLibrary::RL_GetObjectArray(RESOURCEFILE resfile, Object * object, RESOURCEID resourceid)
{
	register Object ** _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register RESOURCEFILE a0 __asm("a0") = resfile;
	register void * a1 __asm("a1") = object;
	register RESOURCEID d0 __asm("d0") = resourceid;

	__asm volatile ("jsr a6@(-66)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
	return (Object **) _res;
}

BOOL ResourceLibrary::RL_SetResourceScreen(RESOURCEFILE resfile, struct Screen * screen)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register RESOURCEFILE a0 __asm("a0") = resfile;
	register void * a1 __asm("a1") = screen;

	__asm volatile ("jsr a6@(-72)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}


#endif

