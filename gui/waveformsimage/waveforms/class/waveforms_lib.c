/*
**      $VER: LibInit.c 37.32 (2.3.99)
**
**      Library initializers and functions to be called by StartUp.c
**
**      (C) Copyright 1996-99 Andreas R. Kleinert
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
#include <clib/exec_protos.h>
#else
#include <proto/exec.h>
#endif

#include "compiler.h"

#ifdef __GNUC__
#include "clib37/source/include/example/examplebase.h"
#elif VBCC
#include "clib37/source/include/example/examplebase.h"
#else
#include "waveforms.h"
#include "waveforms_protos.h"
#endif


ULONG __saveds __stdargs L_OpenLibs( struct WFIBase *WFIBase );
VOID  __saveds __stdargs L_CloseLibs( struct WFIBase *WFIBase );

#define VERSION  44
#define REVISION  0

#define WFILIBNAME "waveforms"
#define WFILIBVER  " '020 v44.0 "
#define WFIDATE    __AMIGADATE__
#define WFIRIGHTS  " (C)opyright ©'01 strandedUFO."

char __aligned WFILibName [] = WFILIBNAME ".image";
char __aligned WFILibID   [] = WFILIBNAME WFILIBVER WFIDATE;
char __aligned VERSTRING  [] = "\0$VER: " WFILIBNAME ".image" WFILIBVER WFIDATE WFIRIGHTS;


#undef  GfxBase
#undef  IntuitionBase
#undef  UtilityBase
#define SysBase                  cb->wfi_SysBase
#define GfxBase                  cb->wfi_GfxBase
#define IntuitionBase            cb->wfi_IntuitionBase
#define UtilityBase              cb->wfi_UtilityBase


/* ----------------------------------------------------------------------------------------
   ! ROMTag and Library inilitalization structure:
   !
   ! Below you find the ROMTag, which is the most important "magic" part of a library
   ! (as for any other resident module). You should not need to modify any of the
   ! structures directly, since all the data is referenced from constants from somewhere else.
   !
   ! You may place the ROMTag directly after the LibStart (-> StartUp.c) function as well.
   !
   ! Note, that the data initialization structure may be somewhat redundant - it's
   ! for demonstration purposes.
   !
   ! EndResident can be placed somewhere else - but it must follow the ROMTag and
   ! it must not be placed in a different SECTION.
   ---------------------------------------------------------------------------------------- */

extern ULONG InitTab[];
extern APTR EndResident; /* below */

struct Resident __aligned ROMTag =     /* do not change */
{
 RTC_MATCHWORD,
 &ROMTag,
 &EndResident,
 RTF_AUTOINIT,
 VERSION,
 NT_LIBRARY,
 0,
 &WFILibName[0],
 &WFILibID[0],
 &InitTab[0]
};

APTR EndResident;

struct MyDataInit                      /* do not change */
{
 UWORD ln_Type_Init;      UWORD ln_Type_Offset;      UWORD ln_Type_Content;
 UBYTE ln_Name_Init;      UBYTE ln_Name_Offset;      ULONG ln_Name_Content;
 UWORD lib_Flags_Init;    UWORD lib_Flags_Offset;    UWORD lib_Flags_Content;
 UWORD lib_Version_Init;  UWORD lib_Version_Offset;  UWORD lib_Version_Content;
 UWORD lib_Revision_Init; UWORD lib_Revision_Offset; UWORD lib_Revision_Content;
 UBYTE lib_IdString_Init; UBYTE lib_IdString_Offset; ULONG lib_IdString_Content;
 ULONG ENDMARK;
} DataTab =
{
 INITBYTE(OFFSET(Node,         ln_Type),      NT_LIBRARY),
 0x80, (UBYTE) OFFSET(Node,    ln_Name),      (ULONG) &WFILibName[0],
 INITBYTE(OFFSET(Library,      lib_Flags),    LIBF_SUMUSED | LIBF_CHANGED),
 INITWORD(OFFSET(Library,      lib_Version),  VERSION),
 INITWORD(OFFSET(Library,      lib_Revision), REVISION),
 0x80, (UBYTE) OFFSET(Library, lib_IdString), (ULONG) &WFILibID[0],
 (ULONG) 0
};


/* ----------------------------------------------------------------------------------------
   ! L_OpenLibs:
   !
   ! Since this one is called by InitLib, libraries not shareable between Processes or
   ! libraries messing with RamLib (deadlock and crash) may not be opened here.
   !
   ! You may bypass this by calling this function fromout LibOpen, but then you will
   ! have to a) protect it by a semaphore and b) make sure, that libraries are only
   ! opened once (when using global library bases).
   ---------------------------------------------------------------------------------------- */

ULONG __saveds __stdargs L_OpenLibs( struct WFIBase *WFIBase )
{
   struct WFIBase         *cb = WFIBase;

   if (( SysBase )->lib_Version >= LIBRARY_VER ) {

      if ( IntuitionBase = OpenLibrary( "intuition.library", LIBRARY_VER )) {

         if ( GfxBase = OpenLibrary( "graphics.library", LIBRARY_VER )) {

            if ( UtilityBase = OpenLibrary( "utility.library", LIBRARY_VER )) {

               Class               *cl = WFIBase->wfi_WFIClass;

               if ( !cl ) {

                  if ( cl = MakeClass( "waveforms.image", IMAGECLASS, NULL,
                                       sizeof( struct waveformData ), 0 )) {

                     cl->cl_Dispatcher.h_SubEntry  = NULL;
                     cl->cl_Dispatcher.h_Entry     = ( HOOKFUNC )dispatchWFI;
                     cl->cl_Dispatcher.h_Data      = (VOID *)WFIBase;
                     cl->cl_UserData               = 0xdead;
                     WFIBase->wfi_WFIClass         = cl;

                     AddClass((struct IClass *)cl );  /* make it publicly available */

                     return( TRUE );                  /* class now successfully open */
                  }
               }
            }
         }
      }
   }
   return( FALSE );
}


/* ----------------------------------------------------------------------------------------
   ! L_CloseLibs:
   !
   ! This one by default is called by ExpungeLib, which only can take place once
   ! and thus per definition is single-threaded.
   !
   ! When calling this fromout LibClose instead, you will have to protect it by a
   ! semaphore, since you don't know whether a given CloseLibrary(foobase) may cause a Wait().
   ! Additionally, there should be protection, that a library won't be closed twice.
   ---------------------------------------------------------------------------------------- */

VOID __saveds __stdargs L_CloseLibs( struct WFIBase *WFIBase )
{
   struct WFIBase         *cb = WFIBase;

   if ( cb->wfi_WFIClass ) {
      FreeClass( cb->wfi_WFIClass );
      cb->wfi_WFIClass = NULL;
   }
   if ( UtilityBase )            CloseLibrary( UtilityBase );
   if ( GfxBase )                CloseLibrary( GfxBase );
   if ( IntuitionBase )          CloseLibrary( IntuitionBase );
   UtilityBase   = NULL;
   GfxBase       = NULL;
   IntuitionBase = NULL;
}




