#include <exec/resident.h>

#include <proto/exec.h>

#include "Library.h"
#include "sysv.h"

#define COMPILE_VERSION  1
#define COMPILE_REVISION 0
#define COMPILE_DATE     "(1.1.2005)"
#define PROGRAM_VER      "1.0"

/**********************************************************************
	Function prototypes
**********************************************************************/

static struct Library *LIB_Open(void);
static BPTR            LIB_Close(void);
static BPTR            LIB_Expunge(void);
static ULONG           LIB_Reserved(void);
static struct Library *LIB_Init(struct MyLibrary *LibBase, BPTR SegList, struct ExecBase *MySysBase);

/**********************************************************************
	Library Header
**********************************************************************/

static const char VerString[]	= "\0$VER: example_sysv.library " PROGRAM_VER " "COMPILE_DATE;
static const char LibName[]	= "example_sysv.library";

static const APTR FuncTable[] =
{
	(APTR)   FUNCARRAY_BEGIN,

	// Start m68k block for system functions.

	(APTR)   FUNCARRAY_32BIT_NATIVE, 
	(APTR)   LIB_Open,
	(APTR)   LIB_Close,
	(APTR)   LIB_Expunge,
	(APTR)   LIB_Reserved,
	(APTR)   -1,

	// Start sysv block for user functions.

	(APTR)   FUNCARRAY_32BIT_SYSTEMV,
	(APTR)   sysv_add,
	(APTR)   sysv_sub,
	(APTR)   sysv_mul,
	(APTR)   sysv_div,
	(APTR)   -1,

	(APTR)   FUNCARRAY_END
};

static const struct MyInitData InitData	=
{
	0xa0,8,  NT_LIBRARY,0,
	0xa0,9,  0xfb,0,					/* 0xfb -> priority -5 */
	0x80,10, (ULONG)&LibName[0],
	0xa0,14, LIBF_SUMUSED|LIBF_CHANGED,0,
	0x90,20, COMPILE_VERSION,
	0x90,22, COMPILE_REVISION,
	0x80,24, (ULONG)&VerString[7],
	0
};

static const ULONG InitTable[] =
{
	sizeof(struct MyLibrary),
	(ULONG)	FuncTable,
	(ULONG)	&InitData,
	(ULONG)	LIB_Init
};

const struct Resident RomTag	=
{
	RTC_MATCHWORD,
	(struct Resident *)&RomTag,
	(struct Resident *)&RomTag+1,
	RTF_AUTOINIT | RTF_PPC | RTF_EXTENDED,
	COMPILE_VERSION,
	NT_LIBRARY,
	0,
	(char *)&LibName[0],
	(char *)&VerString[7],
	(APTR)&InitTable[0],
	COMPILE_REVISION, NULL
};

/**********************************************************************
	Globals
**********************************************************************/

#ifdef __MORPHOS__
const ULONG __abox__	= 1;
#endif

struct ExecBase *SysBase;

/**********************************************************************
	LIB_Reserved
**********************************************************************/

static ULONG LIB_Reserved(void)
{
	return 0;
}

/**********************************************************************
	LIB_Init
**********************************************************************/

static struct Library *LIB_Init(struct MyLibrary *LibBase, BPTR SegList, struct ExecBase *MySysBase)
{
	LibBase->SegList	= SegList;
	SysBase				= MySysBase;
	return &LibBase->Library;
}

/**********************************************************************
	RemoveLibrary
**********************************************************************/

static VOID RemoveLibrary(struct MyLibrary *LibBase)
{
	Remove(&LibBase->Library.lib_Node);
	FreeMem((APTR)((ULONG)(LibBase) - (ULONG)(LibBase->Library.lib_NegSize)), LibBase->Library.lib_NegSize + LibBase->Library.lib_PosSize);
}

/**********************************************************************
	LIB_Expunge
 ********************************************************************/

static BPTR LIB_Expunge(void)
{
	struct MyLibrary *LibBase = (struct MyLibrary *)REG_A6;

	if (LibBase->Library.lib_OpenCnt == 0)
	{
		BPTR seglist = LibBase->SegList;

		RemoveLibrary(LibBase);
		return seglist;
	}

	LibBase->Library.lib_Flags |= LIBF_DELEXP;
	return 0;
}

/**********************************************************************
	LIB_Close
**********************************************************************/

static BPTR LIB_Close(void)
{
	struct MyLibrary *LibBase = (struct MyLibrary *)REG_A6;
	BPTR	SegList	= 0;

	LibBase->Library.lib_OpenCnt--;

	if (LibBase->Library.lib_Flags & LIBF_DELEXP && LibBase->Library.lib_OpenCnt == 0)
	{
		SegList = LibBase->SegList;
		RemoveLibrary(LibBase);
	}

	return SegList;
}

/**********************************************************************
	LIB_Open
**********************************************************************/

static struct Library *LIB_Open(void)
{
	struct MyLibrary *LibBase = (struct MyLibrary *)REG_A6;
	LibBase->Library.lib_Flags &= ~LIBF_DELEXP;
	LibBase->Library.lib_OpenCnt++;
	return &LibBase->Library;
}
