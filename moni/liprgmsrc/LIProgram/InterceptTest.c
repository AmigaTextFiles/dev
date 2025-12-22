/****h *InterceptTest/InterceptTest.c [1.0] ****************************
**
** NAME
**    InterceptTest
**
** DESCRIPTION
**    See if LibraryInterceptor is working correctly.
************************************************************************
*/

#include <stdio.h>

#include <exec/execbase.h>
#include <exec/types.h>

#include <AmigaDOSErrs.h>

#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>

#include <graphics/gfxbase.h>

#include <clib/exec_protos.h>

#include "CPGM:GlobalObjects/CommonFuncs.h"

IMPORT struct Library   *SysBase;

struct IntuitionBase *IntuitionBase;
struct GfxBase       *GfxBase;
struct Library       *GadToolsBase;

PUBLIC int main( int argc, char **argv )
{
   fprintf( stderr, "SysBase       == 0x%08LX\n", SysBase );

   if (OpenLibs() < 0)
      {
      fprintf( stderr, "OpenLibs() failed in %s\n", argv[0] );
      return( RETURN_FAIL );
      }

   fprintf( stderr, "IntuitionBase == 0x%08LX\n", IntuitionBase );
   fprintf( stderr, "GfxBase       == 0x%08LX\n", GfxBase       );
   fprintf( stderr, "GadToolsBase  == 0x%08LX\n", GadToolsBase  );

   CloseLibs();

   return( RETURN_OK );
}

/* -------------- END of InterceptTest.c file! ----------------- */