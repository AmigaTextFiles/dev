/****h* AmigaTalk/Tools.c [3.0] ***************************************
*
* NAME
*    Tools.c
*
* DESCRIPTION
*    Functions and data for the ToolTypes in the AmigaTalk Icon.
*
* HISTORY
*    02-Jan-2005 - Added EnvironFile ToolType & removed all of the 
*                  others.
*
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
* NOTES
*    $VER: AmigaTalk:Src/Tools.c 3.0 (02-Jan-2005) by J.T. Steichen
*
* ToolTypes:
*  EnvironFile          =AmigaTalk:AmigaTalk.ini
********************************************************************
*
*/

#include <stdio.h>
#include <string.h>

#include <exec/types.h>
#include <exec/libraries.h>

#include <AmigaDOSErrs.h>

#include <workbench/workbench.h>
#include <workbench/startup.h>
#include <workbench/icon.h>

#include <dos.h>

#ifdef __SASC

# include <clib/exec_protos.h>

IMPORT struct Library *IconBase;

#else

# define   __USE_INLINE__

# include <proto/exec.h>
# include <proto/icon.h>
# include <proto/wb.h>

IMPORT struct Library   *IconBase;
IMPORT struct IconIFace *IIcon;

#endif

#include "StringConstants.h"
#include "StringIndexes.h"

#include "CPGM:GlobalObjects/CommonFuncs.h" 

#include "FuncProtos.h"
#include "Constants.h"

#ifndef  BUFF_SIZE
# define BUFF_SIZE 512
#endif

#define LARGE_TOOLSPACE 256
#define TITLE_SIZE      80
#define NUMBR_TOOLSPACE 32

#define DEFAULT_OBJ_SIZE 2000000
#define DEFAULT_INT_SIZE 1000000
#define DEFAULT_BAR_SIZE 2000000
#define DEFAULT_ITP_SIZE 5000000
#define DEFAULT_SYM_SIZE 1000000

// ToolType Storage space: TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT

PUBLIC UBYTE ScreenMode_ID[    NUMBR_TOOLSPACE ] = { 0, }; // Added on 30-Oct-2002

PUBLIC UBYTE EnvironFile[      LARGE_TOOLSPACE ] = { 0, }; // Added on 02-Jan-2005
PUBLIC UBYTE BrowserName[      LARGE_TOOLSPACE ] = { 0, }; // Added on 04-Mar-2003
PUBLIC UBYTE InitializeScript[ LARGE_TOOLSPACE ] = { 0, }; // Added on 31-Jan-2002
PUBLIC UBYTE UpdateScript[     LARGE_TOOLSPACE ] = { 0, }; // Added on 28-Jan-2002
PUBLIC UBYTE ToolEditor[       LARGE_TOOLSPACE ] = { 0, }; // Added on 17-Sep-2001
PUBLIC UBYTE FileDisplayer[    LARGE_TOOLSPACE ] = { 0, }; // Added on 17-May-2000
PUBLIC UBYTE DisplayEnvFile[   LARGE_TOOLSPACE ] = { 0, }; // Added on 16-Apr-2000
PUBLIC UBYTE SymbolFile[       LARGE_TOOLSPACE ] = { 0, }; // Added on 23-Feb-2000
PUBLIC UBYTE HelpProgram[      LARGE_TOOLSPACE ] = { 0, };
PUBLIC UBYTE CommandPath[      LARGE_TOOLSPACE ] = { 0, };
PUBLIC UBYTE LibraryPath[      LARGE_TOOLSPACE ] = { 0, };
PUBLIC UBYTE ParserName[       LARGE_TOOLSPACE ] = { 0, };
PUBLIC UBYTE HelpPath[         LARGE_TOOLSPACE ] = { 0, };
PUBLIC UBYTE GeneralPath[      LARGE_TOOLSPACE ] = { 0, };
PUBLIC UBYTE IntuitionPath[    LARGE_TOOLSPACE ] = { 0, };
PUBLIC UBYTE SystemPath[       LARGE_TOOLSPACE ] = { 0, };
PUBLIC UBYTE UserClassPath[    LARGE_TOOLSPACE ] = { 0, };
PUBLIC UBYTE Editor[           LARGE_TOOLSPACE ] = { 0, };
PUBLIC UBYTE ImageFile[        LARGE_TOOLSPACE ] = { 0, }; // Prelude/standard 
PUBLIC UBYTE UserInterface[    LARGE_TOOLSPACE ] = { 0, }; // Unused
PUBLIC UBYTE ARexxPortName[    LARGE_TOOLSPACE ] = { 0, }; // Unused
PUBLIC UBYTE LogoCmd[          LARGE_TOOLSPACE ] = { 0, };
PUBLIC UBYTE LogoName[         LARGE_TOOLSPACE ] = { 0, };

PUBLIC ULONG ObjectTableSize      = DEFAULT_OBJ_SIZE; // Added on 21-Oct-2003
PUBLIC ULONG ByteArrayTableSize   = DEFAULT_BAR_SIZE; // Added on 06-Nov-2003
PUBLIC ULONG IntegerTableSize     = DEFAULT_INT_SIZE;
PUBLIC ULONG InterpreterTableSize = DEFAULT_ITP_SIZE;
PUBLIC ULONG SymbolTableSize      = DEFAULT_SYM_SIZE;

PUBLIC UWORD DefaultTabSize       = 3;  // Used by Amiga_Printf()
PUBLIC UWORD StatusHistoryLength  = 20; // Not currently used.

PUBLIC struct DiskObject *diskobj;

// TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT

PUBLIC UBYTE DefEnvironFile[ LARGE_TOOLSPACE ] = { 0, }; // Visible to CatalogTools();

// ToolNames: ----------------------------------------------------------

PUBLIC UBYTE *ENVIRONFILE          = NULL; // Visible to CatalogTools();

SUBFUNC char *MakeToolStr( UBYTE *buff, UBYTE *toolname, UBYTE *toolstr, int strlength )
{
   int len1 = StringLength( toolname ); 
   
   (void) StringCopy(  buff, toolname );
   (void) StringCat(   buff, "=" );
   (void) StringNCat( buff, toolstr, strlength ); // - len1 - 1 );
   
   return( buff );
}

/****h* UpdateIconToolTypes() [2.1] ************************************
*
* NAME
*    UpdateIconToolTypes()
*
* DESCRIPTION
*    Since some ToolTypes can be changed internally, we have to write
*    the ToolTypes back to the Icon.
************************************************************************
*
*/

PUBLIC void UpdateIconToolTypes( void )
{
//   IMPORT struct DiskObject *GetDiskObject( char *pgmName );  

   char    PrgmName[ BUFF_SIZE ] = { 0, };
   STRPTR *toolArray             = NULL;
   BOOL    rval                  = FALSE;
   BOOL    OpenedLibrary         = FALSE;

#  ifdef   __SASC
   ULONG   libVersion            = 39L;
#  else
   ULONG   libVersion            = 50L;
#  endif

   // --------------------------------------------------------

   if (!IconBase) // == NULL)
      {
      if ((IconBase = OpenLibrary( "icon.library", libVersion ))) // != NULL)
         {
#        ifdef __amigaos4__
	 if (!(IIcon = (struct IconIFace *) GetInterface( IconBase, "main", 1, NULL )))
	    {
            CloseLibrary( IconBase );

            NotOpened( 4 );

            return; // No point in doing this procedure.
	    }
	 else
#        endif
	    OpenedLibrary = TRUE; 
	 }
      else
         {
         NotOpened( 4 );

         return; // No point in doing this procedure.
	 }
      }      

   rval = GetProgramName( &PrgmName[0], BUFF_SIZE );

   if (rval != DOSFALSE)
      {
      UBYTE buffer[ BUFF_SIZE ] = { 0, };
	
      diskobj = GetDiskObject( &PrgmName[0] );

      if (!diskobj) // == NULL)
         {
         IMPORT UBYTE *ATalkProblem;
         
         UserInfo( ToolsCMsg( MSG_ICON_MISSING_TOOLS ), ATalkProblem );

         return;
         }
         
      toolArray = diskobj->do_ToolTypes;

      *toolArray = MakeToolStr( buffer, ToolsCMsg( MSG_ICON_ENVFILE_TOOLS ), 
                                EnvironFile, LARGE_TOOLSPACE );

      (void) PutDiskObject( &PrgmName[0], diskobj );   
      }

   if (OpenedLibrary == TRUE)
      {
#     ifdef __amigaos4__
      if (IIcon)
         DropInterface( (struct Interface *) IIcon );
#     endif

      CloseLibrary( IconBase );
      }
            
   return;
}

/****h* processToolTypes() [3.0] **************************************
*
* NAME
*    processToolTypes()
*
* DESCRIPTION
*    Read the Icon toolType array toolptr & set the various ToolTypes
*    accordingly.
***********************************************************************
*
*/

PUBLIC void *processToolTypes( STRPTR *toolptr )
{
   if (!toolptr) // == NULL)
      return( NULL );   // No Icon found condition.

   StringNCopy( &EnvironFile[0], GetToolStr( toolptr, ENVIRONFILE, &DefEnvironFile[0] ), LARGE_TOOLSPACE );

   return( (void *) toolptr ); // Anything, just don't return NULL!
}

/****i* SetupDefaultTools() [2.1] **************************************
* 
* NAME
*    SetupDefaultTools()
*
* NOTES
*    Make sure that pathnames & other ToolType values are initialized.
*    This is our last resort!
************************************************************************
* 
*/

PUBLIC void SetupDefaultTools( void )
{
   StringNCopy( &EnvironFile[0], &DefEnvironFile[0], LARGE_TOOLSPACE );

   return;
}

/* --------------------- END of Tools.c file! -------------------- */
