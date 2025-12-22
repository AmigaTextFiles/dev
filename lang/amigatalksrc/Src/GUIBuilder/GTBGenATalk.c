/****h* GTBGenATalk.c [2.0] ********************************************
*
* NAME
*    GTBGenATalk.c 
*
* DESCRIPTION
*    Parse through a GadToolsBox .gui file & send the output data to
*    the specified output fileName for AmigaTalk source.
* 
* SYNOPSIS 
*    GTBGenATalk <inputFile.ini> <outputFile.st>
*
* NOTES
*    $VER: GTBGenATalk.c 2.0 (01-Nov-2004) by J.T. Steichen
************************************************************************
*
*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <exec/types.h>
#include <exec/memory.h>

#include <libraries/dos.h>
#include <libraries/gadtools.h>
#include <libraries/iffparse.h>

#ifndef __amigaos4__
# include <clib/exec_protos.h>
# include <clib/dos_protos.h>
# include <clib/iffparse_protos.h>

#else

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/dos.h>
# include <proto/iffparse.h>

#endif

#include <graphics/rastport.h> // for JAM1, JAM2, etc

#include "GadToolsBoxIFFs.h"

#include "CPGM:GlobalObjects/CommonFuncs.h"

IMPORT UBYTE *ErrMsg;

// ----------------------------------------------------

PUBLIC int gtbGenATalk( char *iniFile, char *templateFile )
{
   int rval = RETURN_OK;
   
   return( rval );
}

#ifdef DEBUGGEN

PUBLIC int main( int argc, char **argv )
{
   long error = ~0L;

   if (argc != 3) // if not enough args or '?', print usage
      {
      fprintf( stderr, usage, argv[0] );

      return( ERROR_REQUIRED_ARG_MISSING );
      }
   else if (argv[1][0] == '?')
      {
      fprintf( stderr, usage, argv[0] );

      return( RETURN_WARN );
      }

   if ((error = SetupProgram()) != RETURN_OK)
      {
      }

   ShutdownProgram();

   if (outFile != stdout && outFile) // != NULL)
      fclose( outFile );

   return( RETURN_OK );
}

#endif

/* ------------- END of GTBGenATalk.c file! ---------------- */
