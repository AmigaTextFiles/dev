
#ifndef LIBRARYBASE_H
#define LIBRARYBASE_H

#include <exec/types.h>
#include "compiler.h"

#ifdef   __MAXON__
#ifndef  EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif
#else
#ifndef  EXEC_LIBRARIES
#include <exec/libraries.h>
#endif /* EXEC_LIBRARIES_H */
#endif



#define VERSION  1
#define REVISION 8

#define EXLIBNAME "c2p.library"
#define EXLIBVER  " 1.8 (09.09.2025)"
#define EXLIBCOPY "(C)opyright 2022-2025, Alimede Informatica. All rights reserved."



struct LibraryBase
{
    struct Library         lb_LibNode;
    SEGLISTPTR             lb_SegList;
    struct ExecBase       *lb_SysBase;
    struct IntuitionBase  *lb_IntuitionBase;
    struct GfxBase        *lb_GfxBase;
    APTR                   lb_MemoryManager;
    BOOL                   lb_Initialized;
    BOOL                   lb_AkikoDetected;
    APTR                   lb_AkikoC2P;
    ULONG                  lb_Cpu;
};

#ifndef AFB_68060
#define AFB_68060 7
#define AFF_68060 (1 << AFB_68060)
#endif

#ifndef AFB_68080
#define AFB_68080 10
#define AFF_68080 (1 << AFB_68080)
#endif

#endif /* LIBRARYBASE_H */
