/****h* AmigaTalk/ATAbout.c [3.0] *************************************
* 
* NAME
*    ATAbout.c 
*
* DESCRIPTION
*    Display a requester with some information about AmigaTalk.
*
* FUNCTIONAL INTERFACE:
*
*    PUBLIC void AboutReq( void );
*
* HISTORY
*    24-Oct-2004 - Added AmigaOS4 & gcc support.
*
*    09-Jan-2003 - Moved all string constants to StringConstants.h
*
*    30-Apr-2000 - No more minor changes needed in this file.
*
*    09-Feb-2000 - Started a re-write of the entire program, mostly
*                  incorporating CommonFuncs.o stuff.
*
* NOTES
*    $VER: AmigaTalk:Src/ATAbout.c 3.0 (24-Oct-2004) by J.T. Steichen
***********************************************************************
*
*/

#include <stdio.h>
#include <string.h>

#include <exec/types.h>
#include <AmigaDOSErrs.h>

#include <intuition/intuition.h>

#include <Author.h> // My Name & EMail address allocated in Global.c

/*
#ifndef __amigaos4__
# include <clib/exec_protos.h>
# include <clib/intuition_protos.h>
#else

# define __USE_INLINE__

# include <proto/intuition.h>

#endif
*/

#include "StringConstants.h"
#include "StringIndexes.h"

#include "FuncProtos.h"

#include "CPGM:GlobalObjects/CommonFuncs.h"

// ----------------------------------- Located in Main.c file:

IMPORT struct Window *ATWnd;

// -----------------------------------------------------------

// -------- Located in Global.c file:

IMPORT UBYTE *Version;
IMPORT UBYTE *ErrMsg;
IMPORT UBYTE  CopyRight[];
IMPORT UBYTE  PgmName[];

// ----------------------------------

PRIVATE UBYTE AboutTitle[128] = { 0, };

PUBLIC void AboutReq( void )
{
   sprintf( ErrMsg, AboutCMsg( MSG_FMT_AR_ABOUT ), &PgmName[0], Version, authorName, authorEMail );

   sprintf( AboutTitle, AboutCMsg( MSG_FMT_AR_TITLE_ABOUT ), &PgmName[0], &CopyRight[0] );

   if (ATWnd) // != NULL)
      {
      UserInfo( ErrMsg, AboutTitle );
      }
   else
      {
      fprintf( stderr, "%s\n\n%s", AboutTitle, ErrMsg );
      }

   return;
}

/* --------------------- END of ATAbout.c file! ---------------------- */
