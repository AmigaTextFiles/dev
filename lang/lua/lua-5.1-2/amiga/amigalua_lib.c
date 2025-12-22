/*
** This is a basic implementation of an AmigaOS dynamic Lua library.
**
** The setup is the same as any shared library except we add an additional
** interface named "lua" of type LuaIFace to your library.
**
** Lua libraries also require a minimal amount of C library support which
** is provided using clib2's shared library accessibility feature. It
** should be possible to use the newlib C library as well with some effort.
**
*/

#include <dos/dos.h>
#include <proto/dos.h>
#include <proto/exec.h>

#include "lauxlib.h"

#include <dos.h>
#include <string.h>


/*---------------------------------------------------------------------------*/
#define LIBNAME		"amigalua.library"
#define LIBPRI		0
#define LIBVER		1
#define LIBREV		0
#define LIBVSTR		LIBNAME" 1.0 (27.5.2006)"  /* dd.mm.yyyy */

static const char* __attribute__((used)) vtag = "$VER: "LIBVSTR;


/*---------------------------------------------------------------------------*/
struct AmigaLuaBase {
	struct Library libNode;
	BPTR segList;
	struct ExecIFace* iexec;
};


struct LuaIFace {
	struct InterfaceData Data;

	uint32 APICALL (*Obtain)(struct LuaIFace *Self);
	uint32 APICALL (*Release)(struct LuaIFace *Self);
	void APICALL (*Expunge)(struct LuaIFace *Self);
	struct Interface * APICALL (*Clone)(struct LuaIFace* Self);
	lua_CFunction APICALL (*GetFunctionAddress)(struct LuaIFace* Self,
		const char* symbol);
};


/*---------------------------------------------------------------------------*/
struct AmigaLuaBase* libInit(struct AmigaLuaBase*, BPTR, struct ExecIFace*);
uint32 libObtain(struct LibraryManagerInterface*);
uint32 libRelease(struct LibraryManagerInterface*);
struct AmigaLuaBase* libOpen(struct LibraryManagerInterface*, uint32);
BPTR libClose(struct LibraryManagerInterface*);
BPTR libExpunge(struct LibraryManagerInterface*);

uint32 _Lua_Obtain(struct LuaIFace*);
uint32 _Lua_Release(struct LuaIFace*);
lua_CFunction _Lua_GetFunctionAddress(struct LuaIFace*, const char*);


/*---------------------------------------------------------------------------*/
static APTR libManagerVectors[] = {
	libObtain,
	libRelease,
	NULL,
	NULL,
	libOpen,
	libClose,
	libExpunge,
	NULL,
	(APTR)-1
};


static struct TagItem libManagerTags[] = {
	{MIT_Name, (uint32)"__library"},
	{MIT_VectorTable, (uint32)libManagerVectors},
	{MIT_Version, 1},
	{MIT_DataSize, 0},
	{TAG_END, 0}
};


static APTR libLuaVectors[] = {
	_Lua_Obtain,
	_Lua_Release,
	NULL,
	NULL,
	_Lua_GetFunctionAddress,
	(APTR)-1
};


static struct TagItem libLuaTags[] = {
	{MIT_Name, (uint32)"lua"},
	{MIT_VectorTable, (uint32)libLuaVectors},
	{MIT_Version, 1},
	{MIT_DataSize, 0},
	{TAG_END, 0}
};


static APTR libInterfaces[] = {
	libManagerTags,
	libLuaTags,
	NULL
};


static struct TagItem libCreateTags[] = {
	{CLT_DataSize, sizeof(struct AmigaLuaBase)},
	{CLT_InitFunc, (uint32)libInit},
	{CLT_Interfaces, (uint32)libInterfaces},
	{TAG_END, 0}
};


static struct Resident __attribute__((used)) libResident = {
	RTC_MATCHWORD,				// rt_MatchWord
	&libResident,				// rt_MatchTag
	&libResident + 1,			// rt_EndSkip
	RTF_NATIVE | RTF_AUTOINIT,	// rt_Flags
	LIBVER,						// rt_Version
	NT_LIBRARY,					// rt_Type
	LIBPRI,						// rt_Pri
	LIBNAME,					// rt_Name
	LIBVSTR,					// rt_IdString
	libCreateTags				// rt_Init
};


/*---------------------------------------------------------------------------*/
int32 _start()
{
	return RETURN_FAIL;
}


/*---------------------------------------------------------------------------*/
struct AmigaLuaBase* libInit(struct AmigaLuaBase* libBase, BPTR seglist,
	struct ExecIFace* ISys)
{
	libBase->libNode.lib_Node.ln_Type = NT_LIBRARY;
	libBase->libNode.lib_Node.ln_Pri = LIBPRI;
	libBase->libNode.lib_Node.ln_Name = LIBNAME;
	libBase->libNode.lib_Flags = LIBF_SUMUSED | LIBF_CHANGED;
	libBase->libNode.lib_Version = LIBVER;
	libBase->libNode.lib_Revision = LIBREV;
	libBase->libNode.lib_IdString = LIBVSTR;
	libBase->segList = seglist;
	libBase->iexec = ISys;

	/* Initializes clib2 so we can access the C library */
	if ( __lib_init(ISys->Data.LibBase) ) {
		return libBase;
	}

	return NULL;
}


uint32 libObtain(struct LibraryManagerInterface* Self)
{
	return ++Self->Data.RefCount;
}


uint32 libRelease(struct LibraryManagerInterface* Self)
{
	return --Self->Data.RefCount;
}


struct AmigaLuaBase* libOpen(struct LibraryManagerInterface* Self,
	uint32 version)
{
	struct AmigaLuaBase* libBase = (struct AmigaLuaBase*)Self->Data.LibBase;

	++libBase->libNode.lib_OpenCnt;
	libBase->libNode.lib_Flags &= ~LIBF_DELEXP;

	return libBase;
}


BPTR libClose(struct LibraryManagerInterface* Self)
{
	struct AmigaLuaBase* libBase = (struct AmigaLuaBase*)Self->Data.LibBase;

	--libBase->libNode.lib_OpenCnt;

	if ( libBase->libNode.lib_OpenCnt > 0 ) {
		return 0;
	}

	if ( libBase->libNode.lib_Flags & LIBF_DELEXP ) {
		return (BPTR)Self->LibExpunge();
	}
	else {
		return 0;
	}
}


BPTR libExpunge(struct LibraryManagerInterface* Self)
{
	BPTR result = 0;

	struct AmigaLuaBase* libBase = (struct AmigaLuaBase*)Self->Data.LibBase;

	if ( libBase->libNode.lib_OpenCnt == 0 ) {
		result = libBase->segList;

		libBase->iexec->Remove(&libBase->libNode.lib_Node);
		libBase->iexec->DeleteLibrary(&libBase->libNode);

		/* Concludes access to clib2 C library */
		__lib_exit();
	}
	else {
		libBase->libNode.lib_Flags |= LIBF_DELEXP;
	}

	return result;
}


/*---------------------------------------------------------------------------*/
uint32 _Lua_Obtain(struct LuaIFace* Self)
{
	return ++Self->Data.RefCount;
}


uint32 _Lua_Release(struct LuaIFace* Self)
{
	return --Self->Data.RefCount;
}


lua_CFunction _Lua_GetFunctionAddress(struct LuaIFace* Self,
	const char* symbol)
{
	extern const volatile struct luaL_reg amigaLuaLib[];

	if ( symbol != 0 ) {
		const volatile struct luaL_reg* entry = 0;
		for ( entry = amigaLuaLib; entry->name != 0; ++entry ) {
			if ( strcmp(symbol, entry->name) == 0 ) {
				return entry->func;
			}
		}
	}

	return 0;
}
