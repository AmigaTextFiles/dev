/* $VER: Lib_startup.c 1.2 (2005/06/16) © 2005 Guillaume ROGUEZ (yomgui1 @at@ gmail .dot. com)
**
** Generic library startup code for Amiga-m68k and MorphOS.
**
*****************************************************************************
/// History
/*
 * 1.1 ** 2005/06/16 *

    [Yomgui]
    - New version for a generic usage (not limited to Feelin).

 * 1.1 ** 2005/05/29 *

    [Yomgui]
    - Add SysBase and FeelinBase global symbols.
    - Add semaphore protection for lIB_Open().
    - FIX: twice LIB_Close() may trash lib_OpenCnt!

 * 1.0 ** 2005/05/20 *

    [Yomgui] First release.
//+
*/

/// Includes
#include <exec/types.h>
#include <exec/tasks.h>
#include <exec/ports.h>
#include <exec/memory.h>
#include <exec/lists.h>
#include <exec/semaphores.h>
#include <exec/execbase.h>
#include <exec/alerts.h>
#include <exec/libraries.h>
#include <exec/interrupts.h>
#include <exec/resident.h>
#include <dos/dos.h>

#include <proto/exec.h>

#include "lib_info.h"
//+

/// Debug
#ifndef NDEBUG
#include <clib/debug_protos.h> 

#define DEBUG_INIT(x)       x
#define DEBUG_OPEN(x)       x
#define DEBUG_CLOSE(x)      x
#define DEBUG_EXPUNGE(x)    x
#define DEBUG_NULL(x)       x

#else

#define DEBUG_INIT(x)
#define DEBUG_OPEN(x)
#define DEBUG_CLOSE(x)
#define DEBUG_EXPUNGE(x)
#define DEBUG_NULL(x)
#endif /* NDEBUG */
//+

/// Defines & Macros
#ifndef LIB_FUNCTIONS
#define LIB_FUNCTIONS
#endif
//+

/// Externals
/* defined in lib_info.h */
extern ULONG _LIB_Version, _LIB_Revision;
extern const UBYTE _LIB_VersionString[];
extern const UBYTE _LIB_LibName[];
//+
/// Structures & types
struct LibBase
{
    struct Library          Lib;
    BPTR                    SegList;
    struct ExecBase         *sysBase;
    struct SignalSemaphore  Yomgui;
};

struct LibInitStruct
{
    ULONG   LibSize;
    void    *FuncTable;
    void    *DataTable;
    void    (*InitFunc) (void);
};
//+
/// Functions Prototypes
static struct Library *LIB_Init(struct LibBase *MyLibBase, BPTR SegList, struct ExecBase *SBase); 
static struct Library *LIB_InitUser(struct LibBase *MyLibBase) __attribute__ ((weak));
static ULONG LIB_Expunge(void);
static struct Library *LIB_Open(void);
static ULONG LIB_Close(void);
static ULONG LIB_Reserved(void);

static ULONG LibExpunge(struct LibBase *MyLibBase); 
//+
/// Local Variables
static APTR LibFuncTable[] = {
#ifdef __MORPHOS__
    (APTR) FUNCARRAY_BEGIN,
    (APTR) FUNCARRAY_32BIT_NATIVE,
#endif /* __MORPHOS__ */

    LIB_Open,
    LIB_Close,
    LIB_Expunge,
    LIB_Reserved,

    LIB_FUNCTIONS /* from lib_info.h */

    (APTR) -1,

#ifdef __MORPHOS__
    (APTR) FUNCARRAY_END
#endif /* __MORPHOS__ */
};
//+
/// Global variables
struct LibInitStruct LibInitStruct = {
    sizeof(struct LibBase),
    LibFuncTable,
    NULL,
    (void (*)(void)) &LIB_Init
};

struct Resident LibResident = {
    RTC_MATCHWORD,
    &LibResident,
    &LibResident + 1,
    RTF_PPC | RTF_EXTENDED | RTF_AUTOINIT,
    0,                          /* filled by LibInit() */
    NT_LIBRARY,
    0,
    (char *) &_LIB_LibName[0],
    (char *) &_LIB_VersionString[7],
    &LibInitStruct,

#ifdef __MORPHOS__
    /* Morphos Fields */
    0,                          /* filled by LibInit() */
    NULL                        /* No More Tags for now */
#endif /* __MORPHOS__ */
};

struct ExecBase *SysBase = NULL;

#ifdef __MORPHOS__
ULONG __abox__ = 1;
#endif /* __MORPHOS__ */
 
//+

/* NoExecute() should be the first declared function */

///NoExecute
LONG NoExecute(void)
{
    return -1;
}
//+


/* Private Functions */

/// LibExpunge
static ULONG
LibExpunge(struct LibBase *MyLibBase)
{
    BPTR MySegment;

    DEBUG_EXPUNGE(KPrintF("LIB_Expunge: LibBase 0x%p <%s> OpenCount %ld\n",
                          MyLibBase, MyLibBase->Lib.lib_Node.ln_Name, MyLibBase->Lib.lib_OpenCnt));

    MySegment = MyLibBase->SegList;

    if (MyLibBase->Lib.lib_OpenCnt)
    {
        DEBUG_EXPUNGE(KPrintF("LIB_Expunge: set LIBF_DELEXP\n"));
        MyLibBase->Lib.lib_Flags |= LIBF_DELEXP;
        return NULL;
    }

    if (FeelinBase != NULL)
        CloseLibrary(FeelinBase);

    /* We don't need a forbid() because Expunge and Close
     * are called with a pending forbid.
     * But let's do it for safety if somebody does it by hand.
     */
    Forbid();
    DEBUG_EXPUNGE(KPrintF("LIB_Expunge: remove the library\n"));
    Remove(&MyLibBase->Lib.lib_Node);
    Permit();

    DEBUG_EXPUNGE(KPrintF("LIB_Expunge: free the library\n"));
    FreeMem((APTR) ((ULONG) (MyLibBase) - (ULONG) (MyLibBase->Lib.lib_NegSize)),
            MyLibBase->Lib.lib_NegSize + MyLibBase->Lib.lib_PosSize);

    DEBUG_EXPUNGE(KPrintF("LIB_Expunge: return Segment 0x%lx to ramlib\n", MySegment));
    return (ULONG) MySegment;
}
//+


/* Minimal Library Functions */

/// LIB_Init
static struct Library *
LIB_Init(
    struct LibBase *MyLibBase,
    BPTR SegList,
    struct ExecBase *sBase)
{
    DEBUG_INIT(KPrintF("LibInit: LibBase 0x%p SegList 0x%lx SysBase 0x%p\n",
                       MyLibBase, SegList, sBase));

    MyLibBase->Lib.lib_Version = _LIB_Version;
    MyLibBase->Lib.lib_Revision = _LIB_Revision;
    MyLibBase->SegList = SegList;
    MyLibBase->sysBase = SysBase = sBase;

    InitSemaphore(&MyLibBase->Yomgui);
    
    return LIB_InitUser(&MyLibBase->Lib);
}

#define SysBase     MyLibBase->sysBase
//+
/// LIB_Expunge
static ULONG
LIB_Expunge(void)
{
    struct LibBase *MyLibBase = (struct LibBase *) REG_A6;

    /* This call is protected by a Forbid() */ 

    DEBUG_EXPUNGE(KPrintF("LIB_Expunge:\n"));
    return LibExpunge(MyLibBase);
}
//+
/// LIB_Open
static struct Library *
LIB_Open(void)
{
    struct LibBase *MyLibBase = (struct LibBase *) REG_A6;

    ObtainSemaphore(&MyLibBase->Yomgui);

    DEBUG_OPEN(KPrintF("LIB_Open: 0x%p <%s> OpenCount %ld\n",
                       MyLibBase, MyLibBase->Lib.lib_Node.ln_Name, MyLibBase->Lib.lib_OpenCnt));

    MyLibBase->Lib.lib_Flags &= ~LIBF_DELEXP;
    MyLibBase->Lib.lib_OpenCnt++;
    
    ReleaseSemaphore(&MyLibBase->Yomgui);

    return &MyLibBase->Lib;
}
//+
/// LIB_Close
static ULONG
LIB_Close(void)
{
    struct LibBase *MyLibBase = (struct LibBase *) REG_A6;

    DEBUG_CLOSE(KPrintF("LIB_Close: 0x%p <%s> OpenCount %ld\n",
                        MyLibBase, MyLibBase->Lib.lib_Node.ln_Name, MyLibBase->Lib.lib_OpenCnt));

    /* This call is protected by a Forbid() */

    if (MyLibBase->Lib.lib_OpenCnt > 0)
        MyLibBase->Lib.lib_OpenCnt--;
    
    if (MyLibBase->Lib.lib_OpenCnt == 0)
    {
        if (MyLibBase->Lib.lib_Flags & LIBF_DELEXP)
        {
            DEBUG_CLOSE(KPrintF("LIB_Close: LIBF_DELEXP set\n"));
            return LibExpunge(MyLibBase);
        }
    }
    else
    {
        DEBUG_CLOSE(KPrintF("LIB_Close: done\n"));
    }

    return 0;
}
//+
/// LIB_Reserved
static ULONG
LIB_Reserved(void)
{
    DEBUG_NULL(KPrintF("LIB_Reserved:\n"));

    return 0;
}
//+

/* Default User Functions */

///LIB_InitUser
struct Library *LIB_InitUser(struct LibBase *MyLibBase)
{
    return MyLibBase;
}
//+
