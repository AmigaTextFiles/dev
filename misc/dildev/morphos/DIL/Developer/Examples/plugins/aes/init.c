/*
 * aes.dilp - AES cipher plugin for DIL
 * Copyright ©2004-2009 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 */

#include <exec/libraries.h>
#include <exec/execbase.h>
#include <exec/resident.h>
#include <dos/dos.h>
#include <libraries/dilplugin.h>

#include <proto/dilplugin.h>
#include <proto/exec.h>

#include "init.h"
#include "rev.h"

//-----------------------------------------------------------------------------

#define D(x) /* x */

//-----------------------------------------------------------------------------

const int __initlibraries	= 0; /* no auto-libinit */
const int __nocommandline  = 1; /* no argc, argv 	*/
const int __abox__ 			= 1; /* */

const UBYTE *verstag = VERSTAG;

//-----------------------------------------------------------------------------

struct ExecBase 	*SysBase;
struct DosLibrary *DOSBase;
struct Library 	*UtilityBase;

static struct Library *LIB_Init(struct DILPluginBase *base, BPTR seglist, struct ExecBase *sysbase);
static struct Library *LIB_Open(void);
static BPTR LIB_Close(void);
static BPTR LIB_Expunge(void);
static void LIB_Reserved(void);
static BPTR InternalExpunge(struct DILPluginBase *base);

extern void *EndResident;

//-----------------------------------------------------------------------------

static const ULONG FuncTable[] =
{
	FUNCARRAY_32BIT_NATIVE,
	(ULONG)LIB_Open,
	(ULONG)LIB_Close,
	(ULONG)LIB_Expunge,
	(ULONG)LIB_Reserved,
	(ULONG)dilGetInfo,
	(ULONG)dilSetup,
	(ULONG)dilCleanup,
	(ULONG)dilProcess,
	~0
};

struct {
	ULONG LibSize;
	const void *FuncTable;
	const void *DataTable;
	void (*InitFunc)(void);
} initStruct = {
	sizeof(struct DILPluginBase),
	FuncTable,
	NULL,
	(void (*)())LIB_Init
};

static const struct Resident ROMTag =
{
	RTC_MATCHWORD,
	(struct Resident *)&ROMTag,
	&EndResident,
	RTF_PPC | RTF_EXTENDED | RTF_AUTOINIT,
	VERSION,
	NT_LIBRARY,
	0,
	NAME,
	VSTRING,
	&initStruct,
   REVISION,
   NULL
};

//-----------------------------------------------------------------------------

LONG libStart(void) {
	return -1l;
}

//-----------------------------------------------------------------------------

#define SYS_MINVER 37l

static struct Library *LIB_Init(struct DILPluginBase *base, BPTR seglist, struct ExecBase *sysbase)
{
	D(kprintf("LibInit: struct DILPluginBase 0x%p SegList 0x%lx SysBase 0x%p\n",
		base, seglist, sysbase));
	
	SysBase = base->lib_SysBase = sysbase;
   			 base->lib_SegList = seglist;

	if ((DOSBase = base->lib_DOSBase = (struct DosLibrary *)OpenLibrary("dos.library", SYS_MINVER))) {
		if ((UtilityBase = base->lib_UtilityBase = OpenLibrary("utility.library", SYS_MINVER)))
			return ((struct Library *)base);

   	CloseLibrary((struct Library *)base->lib_DOSBase);
   }
	FreeMem((APTR)((ULONG)(base) - (ULONG)(base->lib_LibNode.lib_NegSize)),
          base->lib_LibNode.lib_NegSize + base->lib_LibNode.lib_PosSize);

	return NULL;
}

#undef SYS_MINVER

//-----------------------------------------------------------------------------

static struct Library *LIB_Open(void)
{
	struct DILPluginBase *base = (APTR)REG_A6;

	D(kprintf("LIB_Open: 0x%p <%s> OpenCount %ld\n",
		base, base->lib_LibNode.lib_Node.ln_Name, base->lib_LibNode.lib_OpenCnt));

	base->lib_LibNode.lib_Flags &= ~LIBF_DELEXP;
	base->lib_LibNode.lib_OpenCnt++;

	return ((struct Library *)base);
}

//-----------------------------------------------------------------------------

static BPTR LIB_Close(void)
{
	struct DILPluginBase *base = (APTR)REG_A6;

	D(kprintf("LIB_Close: 0x%p <%s> OpenCount %ld\n",
		base, base->lib_LibNode.lib_Node.ln_Name, base->lib_LibNode.lib_OpenCnt));

	if ((--base->lib_LibNode.lib_OpenCnt) > 0) {
		D(kprintf("LIB_Close: done\n"));
	} else {
		if (base->lib_LibNode.lib_Flags & LIBF_DELEXP) {
			D(kprintf("LIB_Close: LIBF_DELEXP set\n"));
			return (InternalExpunge(base));
		}
	}
	return (BPTR)0;
}

//-----------------------------------------------------------------------------

static BPTR InternalExpunge(struct DILPluginBase *base)
{
	BPTR seglist = base->lib_SegList;

	D(kprintf("LIB_Expunge: struct DILPluginBase 0x%p <%s> OpenCount %ld\n",
		base, base->lib_LibNode.lib_Node.ln_Name, base->lib_LibNode.lib_OpenCnt));

	if (base->lib_LibNode.lib_OpenCnt) {
		D(kprintf("LIB_Expunge: set LIBF_DELEXP\n"));
		base->lib_LibNode.lib_Flags |= LIBF_DELEXP;
		return (BPTR)0;
	}

	D(kprintf("LIB_Expunge: remove the library\n"));
   Forbid();
	Remove(&base->lib_LibNode.lib_Node);
	Permit();

   CloseLibrary(base->lib_UtilityBase);
   CloseLibrary((struct Library *)base->lib_DOSBase);

	D(kprintf("LIB_Expunge: free the library\n"));
	FreeMem((APTR)((ULONG)(base) - (ULONG)(base->lib_LibNode.lib_NegSize)),
		base->lib_LibNode.lib_NegSize + base->lib_LibNode.lib_PosSize);

	D(kprintf("LIB_Expunge: return Segment 0x%lx to ramlib\n", seglist));
	return seglist;
}

static BPTR LIB_Expunge(void)
{
	struct DILPluginBase *base = (APTR)REG_A6;

	D(kprintf("LIB_Expunge:\n"));
	return (InternalExpunge(base));
}

//-----------------------------------------------------------------------------

static void LIB_Reserved(void)
{
	D(kprintf("LIB_Reserved:\n"));
}

//-----------------------------------------------------------------------------

