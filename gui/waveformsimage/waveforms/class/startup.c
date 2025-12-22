/*
**      $VER: StartUp.c 37.31 (18.3.98)
**
**      Library startup-code and function table definition
**
**      (C) Copyright 1996-98 Andreas R. Kleinert
**      All Rights Reserved.
*/

#define __USE_SYSBASE        // perhaps only recognized by SAS/C

#include <exec/types.h>
#include <exec/memory.h>
#include <exec/libraries.h>
#include <exec/execbase.h>
#include <exec/resident.h>
#include <exec/initializers.h>


#ifdef __MAXON__
#include <pragma/exec_lib.h>
#include <linkerfunc.h>
#else
#include <proto/exec.h>    // all other compilers
#endif

#include "compiler.h"

#ifdef __GNUC__
#include "clib37x/source/include/example/examplebase.h"
#elif VBCC
#include "clib37/source/include/example/examplebase.h"
#else
#include "waveforms.h"
#include "waveforms_protos.h"
#endif


extern ULONG __saveds __stdargs L_OpenLibs( struct WFIBase *WFIBase );
extern VOID  __saveds __stdargs L_CloseLibs( struct WFIBase *WFIBase );

#define SysBase         WFIBase->wfi_SysBase
#define IntuitionBase   WFIBase->wfi_IntuitionBase
#define UtilityBase     WFIBase->wfi_UtilityBase

struct WFIBase * __saveds ASM InitLib( REGISTER __a6 struct ExecBase       *sysbase GNUCREG(a6),
                                           REGISTER __a0 SEGLISTPTR         seglist GNUCREG(a0),
                                           REGISTER __d0 struct WFIBase    *cb     GNUCREG(d0));
struct WFIBase * __saveds ASM OpenLib( register __a6 struct WFIBase *WFIBase GNUCREG(a6));
SEGLISTPTR __saveds ASM CloseLib( register __a6 struct WFIBase *WFIBase GNUCREG(a6));
SEGLISTPTR __saveds ASM ExpungeLib( REGISTER __a6 struct WFIBase *cb GNUCREG(a6));
ULONG ASM ExtFuncLib(void);


/* ----------------------------------------------------------------------------------------
   ! LibStart:
   !
   ! If someone tries to start a library as an executable, it must return (LONG) -1
   ! as result. That's what we are doing here.
   ---------------------------------------------------------------------------------------- */

LONG ASM LibStart( VOID )
{
   return( -1 );
}


/* ----------------------------------------------------------------------------------------
   ! Function and Data Tables:
   !
   ! The function and data tables have been placed here for traditional reasons.
   ! Placing the RomTag structure before (-> LibInit.c) would also be a good idea,
   ! but it depends on whether you would like to keep the "version" stuff separately.
   ---------------------------------------------------------------------------------------- */

extern APTR FuncTab [];
#ifdef _DCC
extern DataTab;                     /* DICE fix */
#else
extern struct MyDataInit DataTab;
#endif /* _DCC */
                                    /* Instead you may place ROMTag + Datatab directly, here */
                                    /* (see LibInit.c). This may fix "Installer" version     */
                                    /* checking problems, too - try it.                      */

struct InitTable                       /* do not change */
{
   ULONG                LibBaseSize;
   APTR                *FunctionTable;
   struct MyDataInit   *DataTable;
   APTR                 InitLibTable;
} InitTab =
{
   (ULONG)              sizeof( struct WFIBase ),
   (APTR              *)&FuncTab[0],
   (struct MyDataInit *)&DataTab,
   (APTR)               InitLib
};

APTR FuncTab [] =
{
   OpenLib,
   CloseLib,
   ExpungeLib,
   ExtFuncLib,

   dispatchWFI,        /* add your own functions here */

   (APTR) ((LONG)-1)
};


extern struct WFIBase  *WFIBase;


/* ----------------------------------------------------------------------------------------
   ! InitLib:
   !
   ! This one is single-threaded by the Ramlib process. Theoretically you can do, what
   ! you like here, since you have full exclusive control over all the library code and data.
   ! But due to some bugs in Ramlib V37-40, you can easily cause a deadlock when opening
   ! certain libraries here (which open other libraries, that open other libraries, that...)
   !
   ---------------------------------------------------------------------------------------- */

struct WFIBase * __saveds ASM InitLib( REGISTER __a6 struct ExecBase   *sysbase GNUCREG(a6),
                                       REGISTER __a0 SEGLISTPTR         seglist GNUCREG(a0),
                                       REGISTER __d0 struct WFIBase    *cb      GNUCREG(d0))
{
   WFIBase              = cb;
   SysBase              = ( struct Library *)sysbase;
   WFIBase->wfi_SegList = (ULONG)seglist;

   InitSemaphore( &cb->wfi_LibLock );
   ObtainSemaphore( &cb->wfi_LibLock );

   if (((struct ExecBase *)SysBase)->AttnFlags & AFF_68020 ) {

      if ( L_OpenLibs( cb )) {

         ReleaseSemaphore( &cb->wfi_LibLock );
         return( cb );
      }
   }
   Remove((struct Node *)WFIBase );             /* remove library from lib list */

   L_CloseLibs( WFIBase );

   ReleaseSemaphore( &cb->wfi_LibLock );

   FreeMem( ((UBYTE *)WFIBase) - WFIBase->wfi_Lib.lib_NegSize,
           WFIBase->wfi_Lib.lib_NegSize + WFIBase->wfi_Lib.lib_PosSize );
   return( NULL );
}


/* ----------------------------------------------------------------------------------------
   ! OpenLib:
   !
   ! This one is enclosed within a Forbid/Permit pair by Exec V37-40. Since a Wait() call
   ! would break this Forbid/Permit(), you are not allowed to start any operations that
   ! may cause a Wait() during their processing. It's possible, that future OS versions
   ! won't turn the multi-tasking off, but instead use semaphore protection for this
   ! function.
   !
   ! Currently you only can bypass this restriction by supplying your own semaphore
   ! mechanism.
   ---------------------------------------------------------------------------------------- */

struct WFIBase * __saveds ASM OpenLib( register __a6 struct WFIBase *WFIBase GNUCREG(a6))
{

   ObtainSemaphore( &WFIBase->wfi_LibLock );
   WFIBase->wfi_Lib.lib_OpenCnt++;
   WFIBase->wfi_Lib.lib_Flags &= ~LIBF_DELEXP;
   ReleaseSemaphore( &WFIBase->wfi_LibLock );
   return( WFIBase );
}


/* ----------------------------------------------------------------------------------------
   ! CloseLib:
   !
   ! This one is enclosed within a Forbid/Permit pair by Exec V37-40. Since a Wait() call
   ! would break this Forbid/Permit(), you are not allowed to start any operations that
   ! may cause a Wait() during their processing. It's possible, that future OS versions
   ! won't turn the multi-tasking off, but instead use semaphore protection for this
   ! function.
   !
   ! Currently you only can bypass this restriction by supplying your own semaphore
   ! mechanism.
   ---------------------------------------------------------------------------------------- */

SEGLISTPTR __saveds ASM CloseLib( register __a6 struct WFIBase *WFIBase GNUCREG(a6))
{

   ObtainSemaphore( &WFIBase->wfi_LibLock );

   if ( --WFIBase->wfi_Lib.lib_OpenCnt == 0 ) {

      if ( WFIBase->wfi_Lib.lib_Flags & LIBF_DELEXP ) {

         ReleaseSemaphore( &WFIBase->wfi_LibLock );
         return ( ExpungeLib( WFIBase ));
      }
   }
   ReleaseSemaphore( &WFIBase->wfi_LibLock );
   return( NULL );
}


/* ----------------------------------------------------------------------------------------
   ! ExpungeLib:
   !
   ! This one is enclosed within a Forbid/Permit pair by Exec V37-40. Since a Wait() call
   ! would break this Forbid/Permit(), you are not allowed to start any operations that
   ! may cause a Wait() during their processing. It's possible, that future OS versions
   ! won't turn the multi-tasking off, but instead use semaphore protection for this
   ! function.
   !
   ! Currently you only could bypass this restriction by supplying your own semaphore
   ! mechanism - but since expunging can't be done twice, one should avoid it here.
   ---------------------------------------------------------------------------------------- */

SEGLISTPTR __saveds ASM ExpungeLib( REGISTER __a6 struct WFIBase *cb GNUCREG(a6))
{
   struct WFIBase   *WFIBase = cb;
   SEGLISTPTR        seglist;

   ObtainSemaphore( &WFIBase->wfi_LibLock );

   if ( !WFIBase->wfi_Lib.lib_OpenCnt ) {

      RemoveClass( WFIBase->wfi_WFIClass );        /* remove the class */

      Remove((struct Node *)WFIBase );             /* remove library from lib list */

      seglist = WFIBase->wfi_SegList;              /* cache seglist before freeing library */

      L_CloseLibs( WFIBase );                      /* this frees all the user stuff */

      ReleaseSemaphore( &WFIBase->wfi_LibLock );

      FreeMem( ((UBYTE *)WFIBase) - WFIBase->wfi_Lib.lib_NegSize,
                  WFIBase->wfi_Lib.lib_NegSize + WFIBase->wfi_Lib.lib_PosSize );

      return( seglist );
   }
   WFIBase->wfi_Lib.lib_Flags |= LIBF_DELEXP;
   ReleaseSemaphore( &WFIBase->wfi_LibLock );
   return( NULL );
}


/* ----------------------------------------------------------------------------------------
   ! ExtFunct:
   !
   ! This one is enclosed within a Forbid/Permit pair by Exec V37-40. Since a Wait() call
   ! would break this Forbid/Permit(), you are not allowed to start any operations that
   ! may cause a Wait() during their processing. It's possible, that future OS versions
   ! won't turn the multi-tasking off, but instead use semaphore protection for this
   ! function.
   !
   ! Currently you only can bypass this restriction by supplying your own semaphore
   ! mechanism - but since this function currently is unused, you should not touch
   ! it, either.
   ---------------------------------------------------------------------------------------- */

ULONG ASM ExtFuncLib(void)
{
   return(NULL);
}

struct WFIBase   *WFIBase  = NULL;


/* ----------------------------------------------------------------------------------------
   ! __SASC stuff:
   !
   ! This is only for SAS/C - its intention is to turn off internal CTRL-C handling
   ! for standard C functions and to avoid calls to exit() et al.
   ---------------------------------------------------------------------------------------- */

#ifdef __SASC

#ifdef ARK_OLD_STDIO_FIX

ULONG XCEXIT       = NULL; /* These symbols may be referenced by    */
ULONG _XCEXIT      = NULL; /* some functions of sc.lib, but should  */
ULONG ONBREAK      = NULL; /* never be used inside a shared library */
ULONG _ONBREAK     = NULL;
ULONG base         = NULL; /* Note, that XCEXIT/ONBREAK actually    */
ULONG _base        = NULL; /* should have been defined as functions */
ULONG ProgramName  = NULL; /* and not as ULONGs...                  */
ULONG _ProgramName = NULL;
ULONG StackPtr     = NULL;
ULONG _StackPtr    = NULL;
ULONG oserr        = NULL;
ULONG _oserr       = NULL;
ULONG OSERR        = NULL;
ULONG _OSERR       = NULL;

#endif /* ARK_OLD_STDIO_FIX */

#ifdef __chkabort
#undefine __chkabort
void __regargs __chkabort(void) { }  /* a shared library cannot be    */
void __regargs _CXBRK(void)     { }  /* CTRL-C aborted when doing I/O */
#endif /* __chkabort */

#endif /* __SASC */



