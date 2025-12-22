/****h* IniFuncs.c [3.0] ****************************************
*
* NAME
*    IniFuncs.c
*
* DESCRIPTION
*    Various functions for Creating & Editing .ini files for the
*    Amiga.
*
* HISTORY
*    13-Dec-2004 - Began a complete re-write of this file.
*
*    22-Nov-2004 - added iniSearchForGroup() function.
*
*    01-Nov-2004 - Added AmigaOS4 & gcc support.
*
*    16-Sep-2003 - Created this file.
*
* COPYRIGHT
*    (c) 2003 by J.T. Steichen, ALL rights reserved.
*   
* NOTES
*    The idea for this group of functions was inspired by
*    amigaini.library.  Since I don't have access to the original
*    source code, everything in this file is of my own efforts.
*
*    $VER: IniFuncs.c 3.0 (13-Dec-2004) by J.T. Steichen
*
*****************************************************************
*
*/

#include <stdio.h>
#include <string.h>

#include <exec/types.h>
#include <exec/memory.h>
#include <exec/io.h>

#include <AmigaDOSErrs.h>

#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/gadgetclass.h>

#include <graphics/displayinfo.h>
#include <graphics/gfxbase.h>

#include <libraries/asl.h>
#include <libraries/gadtools.h>

#include <utility/tagitem.h>

#ifndef __amigaos4__

# include <proto/locale.h>
# include <clib/exec_protos.h>
# include <clib/dos_protos.h>
# include <clib/utility_protos.h>
# include <clib/intuition_protos.h>
# include <clib/gadtools_protos.h>
# include <clib/graphics_protos.h>
# include <clib/diskfont_protos.h>

IMPORT __far struct IntuitionBase *IntuitionBase;
IMPORT __far struct GfxBase       *GfxBase;
IMPORT __far struct Library       *GadToolsBase;
IMPORT __far struct LocaleBase    *LocaleBase;

PRIVATE char v[] = "\0$VER: IniFuncs.o 3.0 " __AMIGADATE__ " by J.T. Steichen\0";

#else

# define __USE_INLINE__

# include <proto/dos.h>
# include <proto/exec.h>
# include <proto/intuition.h>
# include <proto/graphics.h>
# include <proto/gadtools.h>
# include <proto/diskfont.h>
# include <proto/locale.h>

IMPORT struct Library *LocaleBase;
IMPORT struct Library *GadToolsBase;

IMPORT struct IntuitionIFace *IIntuition;
IMPORT struct GraphicsIFace  *IGraphics;
IMPORT struct LocaleIFace    *ILocale;
IMPORT struct ExecIFace      *IExec;
IMPORT struct DOSIFace       *IDOS;
IMPORT struct DiskfontIFace  *IDiskfont;
IMPORT struct GadToolsIFace  *IGadTools;

PRIVATE char v[] = "\0$VER: IniFuncsPPC.o 3.0 " __DATE__ " by J.T. Steichen\0";

#endif

PUBLIC struct Catalog *aiCatalog;

#define   CATCOMP_ARRAY      1
#include "IniFuncsLocale.h"

#define    INIFUNCS_C
# include "IniFuncs.h"   // main struct definition & protos
#undef     INIFUNCS_C

#include "CPGM:GlobalObjects/CommonFuncs.h"
#include "CPGM:GlobalObjects/IniFuncs.h"

// -----------------------------------------------------------

/*
PUBLIC struct amigaIni {

   // Fields that get set once only (normally): ------------------

   char               *ai_FileName;         
   BPTR                ai_FilePtr;

   // Fields that change: ----------------------------------------
   
   struct List         ai_FileList;
   struct ListViewMem *ai_LVM;      // The .ini file contents.
   
};

typedef struct amigaIni *aiPTR, AI;
*/

#define AI_FILELINES      ai_LVM->lvm_NodeStrs
#define IMLS              INI_MAX_LINE_SIZE
#define START_LINE_NUMBER 0

/* If you use iniView_EditContents, be sure to test for changes
** to updateAIPointer & use aiCopy to reset whatever aiPTR you're
** currently using after iniVIew_EditContents() returns.
*/

PUBLIC aiPTR aiCopy          = NULL;
PUBLIC BOOL  updateAIPointer = FALSE; // unless set by iniView_EditContents()

PUBLIC char  currentGroupName[IMLS]       = { 0, }; // "[Default Group Name]";
PUBLIC char  currentItemName[IMLS]        = { 0, }; // "DefaultItem";
PUBLIC char  currentItemValue[IMLS]       = { 0, }; // "NULL";

PUBLIC ULONG  currentErrorNumber          = INI_NOERROR;
PUBLIC ULONG  currentLineNumber           = START_LINE_NUMBER;
PUBLIC ULONG  currentGroupStartLineNumber = 1;
PUBLIC ULONG  currentGroupEndLineNumber   = 1;
PUBLIC ULONG  numberOfElements            = 1; // The number of lines in the file.

// -----------------------------------------------------------

PRIVATE char    itemDelimiters[32]    = { 0, }; // DEFAULT_DELIMITERS;
PRIVATE BOOL    caseSensitive         = TRUE;   // TRUE == Case Sensitive, FALSE = insensitive   
PRIVATE BOOL    stringType            = TRUE;   // TRUE == String, FALSE == Number   

PRIVATE struct List *currentFileList  = NULL;

PRIVATE char errStrings[13][80] = {

   ".ini: NO ERROR!",
   ".ini: File NOT found!",
   ".ini: File is EMPTY!",
   ".ini: File did NOT open!",
   ".ini: No group found!",
   ".ini: Item NOT found!",
   ".ini: Ran out of Memory!",
   ".ini: Item was NOT found and Auto-added!",
   ".ini: User/Programmer forgot/omitted something!",
   ".ini: Unknown ERROR!",
   ".ini: More than one group with the same name!",
   ".ini: Wrong number of items in message!",

   0, // (char **) NULL
};

PRIVATE char   *User_ERROR       = NULL; // "User ERROR:";
PRIVATE char   *SystemProblem    = NULL; // "System Problem:";

PRIVATE UBYTE   em[512], *ErrMsg = &em[0];

PRIVATE struct TagItem    FileTags[] = {

   ASLFR_Window,          (ULONG) NULL,
   ASLFR_TitleText,       (ULONG) NULL, // "Enter a .ini File Name...",
   ASLFR_InitialHeight,   400,
   ASLFR_InitialWidth,    500,
   ASLFR_InitialTopEdge,  16,
   ASLFR_InitialLeftEdge, 100,
   ASLFR_PositiveText,    (ULONG) NULL, // " OKAY! ",
   ASLFR_NegativeText,    (ULONG) NULL, // " CANCEL! ",
   ASLFR_InitialPattern,  (ULONG) "#?.ini",
   ASLFR_InitialFile,     (ULONG) "",
   ASLFR_InitialDrawer,   (ULONG) "RAM:",
   ASLFR_Flags1,          FRF_DOPATTERNS,
   ASLFR_Flags2,          FRF_REJECTICONS,
   ASLFR_SleepWindow,     1,
   ASLFR_PrivateIDCMP,    1,
   TAG_END 
};

// -------------------------------------------------------------------

/****h* CMsg() [1.0] *************************************************
*
* NAME
*    CMsg()
*
* DESCRIPTION
*    Obtain a string from the locale catalog file, failing that,
*    return the default string.
**********************************************************************
*
*/

PRIVATE STRPTR CMsg( int strIndex, char *defaultString )
{
   if (aiCatalog) // != NULL)
      return( (STRPTR) GetCatalogStr( aiCatalog, strIndex, defaultString ) );
   else
      return( (STRPTR) defaultString );
}

/****h* SetupCatalog() [1.0] *****************************************
*
* NAME
*    SetupCatalog()
*
* DESCRIPTION
*    This is a test of the methods used to localize a program & is
*    not really necessary for the program since I never intend to
*    release this code for translations.
**********************************************************************
*
*/

PRIVATE int SetupCatalog( void )
{
#  ifdef INCLUDE_EDITCONTENTS    
   IMPORT int SetupViewCatalog( void );
#  endif

   FileTags[1].ti_Data = (ULONG) CMsg( MSG_IF_ASLFR_TITLE,    MSG_IF_ASLFR_TITLE_STR    );
   FileTags[6].ti_Data = (ULONG) CMsg( MSG_IF_ASLFR_OKAYBT,   MSG_IF_ASLFR_OKAYBT_STR   );
   FileTags[7].ti_Data = (ULONG) CMsg( MSG_IF_ASLFR_CANCELBT, MSG_IF_ASLFR_CANCELBT_STR );

   StringNCopy( currentGroupName, CMsg( MSG_IF_DEF_GRP_NAME,   MSG_IF_DEF_GRP_NAME_STR ), IMLS );
   StringNCopy( currentItemName,  CMsg( MSG_IF_DEF_ITEM_NAME,  MSG_IF_DEF_ITEM_NAME_STR ), IMLS );
   StringNCopy( currentItemValue, CMsg( MSG_IF_DEF_ITEM_VALUE, MSG_IF_DEF_ITEM_VALUE_STR ), IMLS );

   // Requester titles:
   
   User_ERROR       = CMsg( MSG_IF_USER_ERROR,     MSG_IF_USER_ERROR_STR     );
   SystemProblem    = CMsg( MSG_IF_SYSTEM_PROBLEM, MSG_IF_SYSTEM_PROBLEM_STR );
   
   StringNCopy( &errStrings[ 0][0], CMsg( MSG_IF_NO_ERROR,    MSG_IF_NO_ERROR_STR    ), 80 );      
   StringNCopy( &errStrings[ 1][0], CMsg( MSG_IF_NO_FILE,     MSG_IF_NO_FILE_STR     ), 80 );      
   StringNCopy( &errStrings[ 2][0], CMsg( MSG_IF_EMPTY_FILE,  MSG_IF_EMPTY_FILE_STR  ), 80 );      
   StringNCopy( &errStrings[ 3][0], CMsg( MSG_IF_NO_FILEOPEN, MSG_IF_NO_FILEOPEN_STR ), 80 );      
   StringNCopy( &errStrings[ 4][0], CMsg( MSG_IF_NO_GROUP,    MSG_IF_NO_GROUP_STR    ), 80 );      
   StringNCopy( &errStrings[ 5][0], CMsg( MSG_IF_NO_ITEM,     MSG_IF_NO_ITEM_STR     ), 80 );      
   StringNCopy( &errStrings[ 6][0], CMsg( MSG_IF_NO_MEMORY,   MSG_IF_NO_MEMORY_STR   ), 80 );      
   StringNCopy( &errStrings[ 7][0], CMsg( MSG_IF_AUTO_ADD,    MSG_IF_AUTO_ADD_STR    ), 80 );      
   StringNCopy( &errStrings[ 8][0], CMsg( MSG_IF_USER_ERR,    MSG_IF_USER_ERR_STR    ), 80 );      
   StringNCopy( &errStrings[ 9][0], CMsg( MSG_IF_UNK_ERROR,   MSG_IF_UNK_ERROR_STR   ), 80 );      
   StringNCopy( &errStrings[10][0], CMsg( MSG_IF_DUP_GROUP,   MSG_IF_DUP_GROUP_STR   ), 80 );      
   StringNCopy( &errStrings[11][0], CMsg( MSG_IF_WRONG_NUM,   MSG_IF_WRONG_NUM_STR   ), 80 );      

   StringNCopy( itemDelimiters, (UBYTE *) DEFAULT_DELIMITERS, 32 );

#  ifdef INCLUDE_EDITCONTENTS   
   return( SetupViewCatalog() );
#  else
   return( RETURN_OK );
#  endif
}

PRIVATE BOOL openedLibraries = FALSE;

// Required for Locale catalog translations:

PRIVATE void shutLibraries( void )
{
   if (aiCatalog) // != NULL)
      {
      CloseCatalog( aiCatalog );
      
      aiCatalog = NULL;
      }

#  ifdef __amigaos4__
   if (IGadTools)
      DropInterface( (struct Interface *) IGadTools );

   if (GadToolsBase)
      CloseLibrary( GadToolsBase );
#  else
   if (LocaleBase) // != NULL)
      CloseLibrary( (struct Library *) LocaleBase );

   if (IntuitionBase) // != NULL)
      CloseLibrary( (struct Library *) IntuitionBase );
#  endif

   openedLibraries = FALSE; // Reset guard.
   
   return;
}

PRIVATE int setupLibraries( char *catalogName )
{
//   IMPORT struct Catalog *OpenCatalog( struct Locale *, STRPTR, struct TagItem, ... );
   
#  ifdef __SASC
   if (OpenLibs() < 0)
      {
      shutLibraries();

      currentErrorNumber = INI_UNKERROR;

      return( -1 );
      }

   if ((LocaleBase = (struct LocaleBase *) 
                      OpenLibrary( "locale.library", 39L )) == NULL)
      {
      shutLibraries();

      currentErrorNumber = INI_UNKERROR;

      return( -2 );
      }
#  else

   if ((GadToolsBase = OpenLibrary( "gadtools.library", 50L )))
      {
      if (!(IGadTools = (struct GadToolsIFace *) GetInterface( GadToolsBase, "main", 1, NULL )))
         {
	 shutLibraries();

         currentErrorNumber = INI_UNKERROR;

         return( -3 );
	 }
      }
   else
      {
      shutLibraries();
      
      currentErrorNumber = INI_UNKERROR;

      return( -3 );
      }
#  endif

   // MYNULL is for the Locale (from OpenLocale()): 
   aiCatalog = OpenCatalog( (struct Locale *) NULL, catalogName,
                                              OC_BuiltInLanguage, "english",
                                              TAG_DONE 
                          );

   if (SetupCatalog() != RETURN_OK)
      {
      shutLibraries();

      currentErrorNumber = INI_UNKERROR;

      return( -3 );
      }

   openedLibraries = TRUE; // Set guard.
   
   return( 0 );
}

/****i* IniFuncs.o/AddNewline() [1.0] *********************************
*
* NAME
*    char *AddNewline( char *string );
*
* DESCRIPTION
*    Append a newline at end of the string.
***********************************************************************
*
*/

SUBFUNC char *AddNewline( char *string, int max )
{
   char *cp = string;
   int   i  = 0;
   
   while (*cp != '\0' && i < max) // Added '&& i < max' on 22-Nov-2004
      {
      cp++; // Find the end of the string.
      i++;
      }

   if (i < max - 1)
      {
      if (*(cp - 1) != '\n')
         {
         *cp = '\n';
         cp++;      
         *cp = '\0';
         }
      // else we already had a newline, so do nothing.
      }
   else
      {
      *(cp - 1) = '\n'; // Just truncated something!
      *cp       = '\0';
      }
      
   return( string );
}

/****h* IniFuncs.o/iniAskForFileName() [1.0] **************************
*
* NAME
*    int length = iniAskForFileName( char *fileNameBuffer );
*
* DESCRIPTION
*    Ask the user to supply a .ini fileName, since they did NOT do
*    so when necessary.
*
* RETURN VALUE
*    The length of the fileName that was selected.
***********************************************************************
*
*/

PUBLIC int iniAskForFileName( char *fnBuffer )
{
   struct Window *wptr = GetActiveWindow();

   if (!wptr) // == NULL) // Should never happen!!
      return( 0 );
      
   SetTagItem( &FileTags[0], ASLFR_Window, (ULONG) wptr );

   return( FileReq( fnBuffer, &FileTags[0] ) );   
}

/****i* IniFuncs.o/RewindFile() [1.0] *********************************
*
* NAME
*    void RewindFile( BPTR filePtr );
*
* DESCRIPTION
*    Rewind the file to it's logical beginning.
***********************************************************************
*
*/

SUBFUNC void RewindFile( BPTR filePtr )
{
   int  location;

   location = Seek( filePtr, 0, OFFSET_CURRENT );     // Where are we?

   (void) Seek( filePtr, -location, OFFSET_CURRENT ); // rewind this much.
   
   return;
}

/****i* IniFuncs.o/myFGets() [1.0] ************************************
*
* NAME
*    char *rval = myFGets( BPTR file, cahr *buf, int max );
*
* DESCRIPTION
*    Same as AmigaDOS FGets(), except that the '\n' at the end of a
*    line is changed to '\0'.  This is only necessary because we 
*    don't want to constantly strip them off only to add them before
*    writing because FPuts() doesn't do so.
***********************************************************************
*
*/

SUBFUNC char *myFGets( BPTR file, char *buffer, int maxSize )
{
   char *rval = FGets( file, buffer, maxSize );
   char *cp   = NULL;
   
   if (rval) // != NULL)
      {
      cp = &buffer[ StringLength( buffer ) - 1 ]; // point to last valid character.
      
      if (*cp == '\n') // Kill this!
         *cp = '\0';
      }

   return( rval );
}

/****i* IniFuncs.o/iniCountLines() [1.0] ******************************
*
* NAME
*    int numLines = iniCountLines( BPTR file );
*
* DESCRIPTION
*    Count the number of newlines in the file.
***********************************************************************
*
*/

PRIVATE int iniCountLines( BPTR filePtr )
{
   char *chk, buf[ INI_MAX_LINE_SIZE ] = { 0, };   
   int  rval = 0;

   // Count the newlines, then rewind the file:

   while ((chk = myFGets( filePtr, &buf[0], INI_MAX_LINE_SIZE ))) // != NULL)
      rval++;

   RewindFile( filePtr );
                     
   return( rval );
}

/****i* IniFuncs.o/iniReadInFile() [1.0] ******************************
*
* NAME
*    void iniReadInFile( aiPTR ai );
*
* DESCRIPTION
*    Read file contents into the aiPTR.
***********************************************************************
*
*/

PRIVATE void iniReadInFile( aiPTR ai )
{
   BPTR  fpr = ai->ai_FilePtr;
   char *buf = ai->AI_FILELINES;
   int   i   = 0;
   
   currentErrorNumber = INI_NOERROR;

   if (!fpr || !buf) // == NULL)
      return;
         
   for (i = 0; i < numberOfElements; i++)
      {
      if (!myFGets( fpr, &buf[i * IMLS], INI_MAX_LINE_SIZE )) // == NULL)
         {
         struct Window *wptr = GetActiveWindow();
         
         SetNotifyWindow( wptr );

#        ifdef TEST_INI
         sprintf( ErrMsg, CMsg( MSG_IF_FMT_SMALL_FILE, MSG_IF_FMT_SMALL_FILE_STR ),
                          numberOfElements
                );
         
         UserInfo( ErrMsg, User_ERROR );
#        endif

         currentErrorNumber = INI_UNKERROR;
                  
         return;
         }
      }
      
   return;
}

/****h* IniFuncs.o/getCurrentLineNumber() [2.0] ***********************
*
* NAME
*    ULONG lineIdx = getCurrentLineNumber( void );
*
* DESCRIPTION
*    Just return the currentLineNumber.  This is a private debug
*    function, NOT documented anywhere.
***********************************************************************
*
*/

PUBLIC ULONG getCurrentLineNumber( void )
{
   return( currentLineNumber );
}

/****h* IniFuncs.o/iniFirstGroup() [1.3] ******************************
*
* NAME
*    int lineIdx = iniFirstGroup( aiPTR ai );
*
* DESCRIPTION
*    Go to the top of the file & set the global variables accordingly.
***********************************************************************
*
*/

PUBLIC int iniFirstGroup( aiPTR ai )
{
   currentLineNumber = START_LINE_NUMBER;

   StringNCopy( currentGroupName, &ai->AI_FILELINES[ currentLineNumber ], IMLS ); // Includes the []

   currentGroupStartLineNumber = 1;
   currentGroupEndLineNumber   = iniGetGroupEnd(   ai, currentGroupName );

   StringNCopy( currentItemName,  iniGetItemName(  ai, 1 ), IMLS );
   StringNCopy( currentItemValue, iniGetItemValue( ai, 1 ), IMLS );

   stringType        = iniItemTypeIsString( currentItemValue );
   currentLineNumber = START_LINE_NUMBER; // Just in case.
   
   return( START_LINE_NUMBER );
}     

/****h* IniFuncs.o/iniLastGroup() [1.3] *******************************
*
* NAME
*    int lineIdx = iniLastGroup( aiPTR ai );
*
* DESCRIPTION
*    Go to the Bottom of the file & set the global variables accordingly.
***********************************************************************
*
*/

PUBLIC int iniLastGroup( aiPTR ai )
{
   int idx;
   
   idx = currentLineNumber = numberOfElements;
   
   while (StringNComp( &ai->AI_FILELINES[idx * IMLS], "[", 1 ) != 0)
      idx--; // Go up the list until a group line is found.
      
   StringNCopy( currentGroupName, &ai->AI_FILELINES[idx * IMLS], IMLS ); // Includes the []

   currentGroupEndLineNumber   = numberOfElements; // THis is wrong!
   
   StringNCopy( currentItemName,  iniGetItemName(  ai, idx + 1 ), IMLS );
   StringNCopy( currentItemValue, iniGetItemValue( ai, idx + 1 ), IMLS );

   if (idx == START_LINE_NUMBER)
      idx++;

   // idx is always >= 1 after this point:
   currentGroupStartLineNumber = idx + 1;
   currentLineNumber           = idx;

   stringType                  = iniItemTypeIsString( currentItemValue );
   
   return( idx );
}     

/****h* IniFuncs.o/iniTranslateErrorNumber() [1.0] ********************
*
* NAME
*    char *errString = iniTranslateErrorNumber( int errNumber );
*
* DESCRIPTION
*    Return a string corresponding to the given error number.
***********************************************************************
*
*/

PUBLIC char *iniTranslateErrorNumber( int errNumber )
{
   if (errNumber < 0 || errNumber > MAX_ERROR_NUMBER)
      return( &errStrings[ INI_UNKERROR ][0] );
   else
      return( &errStrings[ errNumber ][0] );
}     

/****i* IniFuncs.o/OpenINIFile() [1.0] ********************************
*
* NAME
*    BPTR OpenINIFile( char *fileName, int fmode )
*
* DESCRIPTION
*    Open the given fileName (if valid).  If the User supplied a bogus
*    name, ask for a new filename.
***********************************************************************
* 
*/

SUBFUNC BPTR OpenINIFile( char *fileName, int fmode )
{
   struct Window *wptr   = GetActiveWindow();
   BPTR           aiFile = (BPTR) NULL;
   
   currentErrorNumber = INI_NOERROR;

   if ((aiFile = Open( fileName, fmode )) == 0)
      {
      char getFile[512] = { 0, }; // fileName probably bogus:
      
      if (iniAskForFileName( getFile ) > 0)
         {
         StringNCopy( fileName, getFile, 512 );
         
         if ((aiFile = Open( fileName, fmode )) == 0)
            {
            // User is a hopeless moron:
            SetNotifyWindow( wptr );

#           ifdef TEST_INI
            sprintf( ErrMsg, CMsg( MSG_IF_FMT_FILE_UNOPENED, MSG_IF_FMT_FILE_UNOPENED_STR ),
                             fileName
                   );            

            UserInfo( ErrMsg, User_ERROR );
#           endif

            currentErrorNumber = INI_USERERROR;
            
            return( (BPTR) NULL );
            }
         }
      else
         {
         // User is a hopeless moron:
         SetNotifyWindow( wptr );

#        ifdef TEST_INI
         UserInfo( CMsg( MSG_IF_ABORT_OPENFILE, MSG_IF_ABORT_OPENFILE_STR ), User_ERROR );
#        endif

         currentErrorNumber = INI_USERERROR;
                        
         return( (BPTR) NULL );
         }
      }
   else
      {
      currentLineNumber = 1;
      
      return( aiFile );
      }
}

/****i* IniFuncs.o/SetupGlobals() [1.0] *******************************
*
* NAME
*    SetupGlobals()
*
* DESCRIPTION
*    Initialize global variables to the correct values.
***********************************************************************
* 
*/

SUBFUNC void SetupGlobals( aiPTR ai, char *fileName )
{
   StringNCopy( currentGroupName, &ai->AI_FILELINES[0], IMLS ); // Includes the []

   currentLineNumber           = 1;
   currentGroupStartLineNumber = iniGetGroupStart( ai, currentGroupName );
   currentGroupEndLineNumber   = iniGetGroupEnd(   ai, currentGroupName );

   StringNCopy( currentItemName,  iniGetItemName(  ai, currentLineNumber ), IMLS );
   StringNCopy( currentItemValue, iniGetItemValue( ai, currentLineNumber ), IMLS );

   stringType      = iniItemTypeIsString( currentItemValue );
   ai->ai_FileName = fileName;

   return; // currentLineNumber++; // We're at the first item, first group
}

/****i* IniFuncs.o/SetupDefaultGrouping() [1.0] ***********************
*
* NAME
*    SetupDefaultGrouping()
*
* DESCRIPTION
*    Initialize the strings to default names/values.
***********************************************************************
* 
*/

SUBFUNC void SetupDefaultGrouping( aiPTR ai, int amount )
{
   int i;
   
   StringNCopy( &ai->AI_FILELINES[0], 
              CMsg( MSG_IF_DEF_GRP_NAME, MSG_IF_DEF_GRP_NAME_STR ), 
              INI_MAX_GROUPNAME_SIZE 
            );

   for (i = 1; i < amount; i++)
      {
      StringNCopy( &ai->AI_FILELINES[i * IMLS],
                 CMsg( MSG_IF_DEFAULT_ITEM_VALUE, MSG_IF_DEFAULT_ITEM_VALUE_STR ),
                 INI_MAX_LINE_SIZE 
               );
      }

   return;
}

/****h* IniFuncs.o/iniOpenFile() [1.0] ********************************
*
* NAME
*    aiPTR rval = iniOpenFile( char *fileName, BOOL caseFlag, char *delimiters );
*
* DESCRIPTION
*    Open a .ini file & read its contents into the aiPTR.
*
* INPUTS
*    fileName    - the new file to create.  If the file is empty,
*                  a default size of DEFAULT_FILE_SIZE (100 lines)
*                  will be allocated.
*    caseFlag    - TRUE is Case-sensitive, FALSE is insensitive.
*    delimiters  - the separators between the itemName & itemValue.
*
* RETURN VALUE
*    an aiPTR, NULL if there's a problem.
***********************************************************************
*
*/

PUBLIC aiPTR iniOpenFile( char *fileName, BOOL caseFlag, char *delimiters )
{
   struct Window *wptr   = GetActiveWindow(); // For UserInfo() only
   aiPTR          rval   = (struct amigaIni *) NULL;
   BPTR           aiFile = (BPTR) NULL;

   currentErrorNumber = INI_NOERROR;

   if (openedLibraries == FALSE)
      (void) setupLibraries( "inifuncs.catalog" ); // We don't care if this fails!
         
   if (!(rval = (aiPTR) AllocVec( sizeof( AI ), MEMF_CLEAR | MEMF_SHARED ))) // == NULL)
      {
      currentErrorNumber = INI_NOMEMORY;
      
      return( NULL );
      }

   caseSensitive  = caseFlag;

   StringNCopy( itemDelimiters, delimiters, 32 );

   if (!(aiFile = OpenINIFile( fileName, MODE_READWRITE ))) // == NULL)
      {
      currentErrorNumber = IoErr();
      
      FreeVec( rval );

      return( NULL );
      }
   else
      rval->ai_FilePtr = aiFile;
      
   if ((numberOfElements = iniCountLines( aiFile )) < 1)
      {
      currentErrorNumber = INI_NOCONTENT;

      rval->ai_LVM = Guarded_AllocLV( DEFAULT_FILE_SIZE, INI_MAX_LINE_SIZE );
      
      if (!rval->ai_LVM) // == NULL)
         {
         currentErrorNumber = INI_NOMEMORY; // Ran out of memory.
        
         Close( aiFile );
         
         FreeVec( rval );
         
         ReportAllocLVError();
         
         return( NULL );
         }

      SetNotifyWindow( wptr );

#     ifdef TEST_INI
      UserInfo( CMsg( MSG_IF_USING_DEFAULT, MSG_IF_USING_DEFAULT_STR ), User_ERROR );
#     endif

      SetupList( &rval->ai_FileList, rval->ai_LVM );

      currentFileList = &rval->ai_FileList;
      
      SetupDefaultGrouping( rval, DEFAULT_FILE_SIZE );

      SetupGlobals( rval, fileName );      
      }
   else
      {
      rval->ai_LVM = Guarded_AllocLV( numberOfElements, INI_MAX_LINE_SIZE );
      
      if (!rval->ai_LVM) // == NULL)
         {
         currentErrorNumber = INI_NOMEMORY; // Ran out of memory.
        
         Close( aiFile );
         
         FreeVec( rval );

         SetNotifyWindow( wptr );

         ReportAllocLVError();
         
         return( NULL );
         }
      else
         {
         iniReadInFile( rval ); // Setup the strings.
         }

      SetupList( &rval->ai_FileList, rval->ai_LVM );

      currentFileList = &rval->ai_FileList;

      SetupGlobals( rval, fileName );
      }

   return( rval );
}

/****h* iniGetListViewMem() [3.0] *************************************
*
* NAME
*    struct ListViewMem *iniGetListViewMem( aiPTR ai );
*
* DESCRIPTION
*    Retreive the internal ListViewMem structure.
***********************************************************************
*
*/

PUBLIC struct ListViewMem *iniGetListViewMem( aiPTR ai )
{
   if (!ai)
      return( NULL );
   else
      return( ai->ai_LVM );
}

/****h* iniGetList() [3.0] ********************************************
*
* NAME
*    struct List *iniGetList( aiPTR ai );
*
* DESCRIPTION
*    Retreive the internal List structure.
***********************************************************************
*
*/

PUBLIC struct List *iniGetList( aiPTR ai )
{
   if (!ai)
      return( NULL );
   else
      return( &ai->ai_FileList );
}

/****h* IniFuncs.o/iniExit() [1.0] ************************************
*
* NAME
*    void iniExit( aiPTR ai );
*
* DESCRIPTION
*    Close a .ini file & free it's memory spaces.
*
* RETURN VALUE
*    None.
***********************************************************************
*
*/

PUBLIC void iniExit( aiPTR ai )
{
   currentErrorNumber = INI_NOERROR;

   if (!ai) // == NULL)
      return;
      
   if (ai->ai_FilePtr) // != NULL)
      {
      Close( ai->ai_FilePtr );

      ai->ai_FilePtr = (BPTR) NULL;
      }

   if (ai->ai_LVM) // != NULL)
      Guarded_FreeLV( ai->ai_LVM );
       
   FreeVec( ai );

   ai = (struct amigaIni *) NULL;

   currentLineNumber = START_LINE_NUMBER;
   numberOfElements  = 0;

   currentGroupName[0]  = '\0';
   currentItemName[0]   = '\0';
   currentItemValue[0]  = '\0';
   
   StringNCopy( currentGroupName, "[NO_GROUP]", IMLS );
   StringNCopy( currentItemName,  "NO_ITEM",    IMLS );
   StringNCopy( currentItemValue, "NO_VALUE",   IMLS );

   if (openedLibraries == TRUE)
      shutLibraries();
         
   return;
}

/****h* IniFuncs.o/iniIsGroup() [1.0] *********************************
*
* NAME
*    BOOL check = iniIsGroup( aiPTR ai, int lineIndex );
*
* DESCRIPTION
*    Returns TRUE if the given lineIndex contains a groupName,
*    FALSE if otherwise.
***********************************************************************
*
*/

PUBLIC BOOL iniIsGroup( aiPTR ai, int lineIndex )
{
   BOOL rval = TRUE;
   
   currentErrorNumber = INI_NOERROR;

   if (StringNComp( &ai->AI_FILELINES[lineIndex * IMLS], "[", 1 ) != 0)
      rval = FALSE;             // lineIndex is NOT on a group header (ex: [grpName] )
   else // Perform side-effect:
      StringNCopy( currentGroupName, &ai->AI_FILELINES[lineIndex * IMLS], INI_MAX_GROUPNAME_SIZE );
      
   return( rval );
}
     
/****h* IniFuncs.o/iniIsItem() [1.0] **********************************
*
* NAME
*    BOOL check = iniIsItem( aiPTR ai, int lineIndex );
*
* DESCRIPTION
*    Returns TRUE if the given lineIndex contains a group Item,
*    FALSE if otherwise.
***********************************************************************
*
*/

PUBLIC BOOL iniIsItem( aiPTR ai, int lineIndex )
{
   currentErrorNumber = INI_NOERROR;

   return( (BOOL) !iniIsGroup( ai, lineIndex ) );
}

/****h* IniFuncs.o/iniGetItemName() [1.0] *****************************
*
* NAME
*    char *item = iniGetItemName( aiPTR ai, int lineIndex );
*
* DESCRIPTION
*    Returns a copy of the Item Name for the given lineIndex (if it's
*    an item & NOT a group), NULL if there's a problem.
***********************************************************************
*
*/

PRIVATE char igItemName[ INI_MAX_LINE_SIZE ] = { 0, }; // Liebensraum

PUBLIC char *iniGetItemName( aiPTR ai, int lineIndex )
{
   char  *cp, *delimiter = itemDelimiters;
   int    idx = 0;
   
   currentErrorNumber = INI_NOERROR;

   if (iniIsItem( ai, lineIndex ) == FALSE)
      {
      currentErrorNumber = INI_USERERROR; // lineIndex was on a group header []
      
      return( NULL );
      }

   cp = &ai->AI_FILELINES[ lineIndex * IMLS ];

   StringNCopy( igItemName, cp, INI_MAX_LINE_SIZE );

   idx = 0;
   
   while (*cp != '\0')
      {
      if (*cp == delimiter[0] || *cp == delimiter[1]
          || *cp == delimiter[2] || *cp == delimiter[3])
         {
         break;
         }  

      cp++;
      idx++;
      }

   igItemName[idx] = '\0'; // Chop off everything after the first delimiter

   StringNCopy( currentItemName, &igItemName[0], IMLS );

   if (lineIndex < 2)
      currentLineNumber = 2;
   else
      currentLineNumber = lineIndex; // Side effect.
   
   return( &igItemName[0] );
}

/****h* IniFuncs.o/iniItemTypeIsString() [1.0] ************************
*
* NAME
*    BOOL check = iniItemTypeIsString( char *itemValue );
*
* DESCRIPTION
*    Returns TRUE if the itemValue is a string, FALSE if it's a Number.
***********************************************************************
*
*/

PUBLIC BOOL iniItemTypeIsString( char *itemValue )
{
   BOOL rval = FALSE;
   int  i = 0, len = 0;

   currentErrorNumber = INI_NOERROR;

   if (!itemValue) // == NULL)
      {
      // Add some error reporting here!

      return( rval );
      }
      
   len = StringLength( (char *) itemValue );
   
   if (itemValue[0] == '0' && itemValue[1] == 'x')
      return( rval ); // Hexadecimal number found, this is NOT a string
      
   for (i = 0; i < len; i++)
      {
      if (isdigit( itemValue[i] ) == FALSE)
         {
         rval = TRUE; // Something besides a digit present.

         break;
         }
      }

   return( rval );   
}

/****h* IniFuncs.o/iniStringToNumber() [2.0] **************************
*
* NAME
*    int value = iniStringToNumber( UBYTE *itemValue );
*
* DESCRIPTION
*    Convert an item Value string to an integer.
***********************************************************************
*
*/

PUBLIC int iniStringToNumber( UBYTE *itemValue )
{
   int integerValue = 0;

   while (*itemValue == ' ')
      itemValue++; // skip over leading whitespace (if any).
         
   if (*itemValue == '0' && itemValue[1] == 'x')
      {
      UBYTE *end;
      
      integerValue = (int) strtol( &itemValue[2], end, 16 );
      }
   else if (*itemValue >= '0' && *itemValue <= '9')
      {
      UBYTE *end;
      
      integerValue = (int) strtol( &itemValue[0], end, 10 );
      }
   
   return( integerValue );
}

/****h* IniFuncs.o/iniGetItemValue() [1.1] ****************************
*
* NAME
*    char *value = iniGetItemValue( aiPTR ai, int lineIndex );
*
* DESCRIPTION
*    Returns a copy of the Item Value for the given lineIndex (if it's
*    an item & NOT a group), NULL if there's a problem.
***********************************************************************
*
*/

PRIVATE char  igItemValue[ INI_MAX_LINE_SIZE ] = { 0, }; // Liebensraum
PRIVATE ULONG igValue = 0L;

PUBLIC char *iniGetItemValue( aiPTR ai, int lineIndex )
{
   char *rval = &igItemValue[0]; // NULL;
   char *cp, *delimiter = itemDelimiters;

   currentErrorNumber = INI_NOERROR;

   if (iniIsItem( ai, lineIndex ) == FALSE)
      {
      currentErrorNumber = INI_USERERROR; // lineIndex is on a group header
      
      return( NULL ); // (char *) 0xDEADBEEF );
      }
               
   cp = &ai->AI_FILELINES[ lineIndex * IMLS ];

   while (*cp != '\0')
      {
      if (*cp == delimiter[0] || *cp == delimiter[1]
         || *cp == delimiter[2] || *cp == delimiter[3])
         {
         break;
         }  

      cp++;   // Get to first delimiter.
      }
      
   while (*cp == delimiter[0] || *cp == delimiter[1]
         || *cp == delimiter[2] || *cp == delimiter[3])
      {
      cp++; // Skip to first non-delimiter character.
      }

/*
   if (*cp == '0' && *(cp + 1) == 'x')
      {
      // We're just interested in the Hex Number.
      StringNCopy( igItemValue, &cp[2], INI_MAX_LINE_SIZE );

      stringType = FALSE;
      }
   else if (*cp >= '0' && *cp <= '9')
      {
      StringNCopy( igItemValue, cp, INI_MAX_LINE_SIZE );

      stringType = FALSE;
      }
   else
      {
*/	
      StringNCopy( igItemValue, cp, INI_MAX_LINE_SIZE );

      stringType = TRUE;
//      }

   rval = &igItemValue[0];

   StringNCopy( currentItemValue, rval, IMLS );

   if (lineIndex < 2)
      currentLineNumber = 2;
   else
      currentLineNumber = lineIndex; // side effect.
   
   return( rval );
}

/****h* IniFuncs.o/iniGetGroupStart() [1.0] ***************************
*
* NAME
*    ULONG index = iniGetGroupStart( aiPTR ai, char *groupName );
*
* DESCRIPTION
*    Return the lineIndex for the first item in the named group,
*    0 if there's a problem.
***********************************************************************
*
*/

PUBLIC ULONG iniGetGroupStart( aiPTR ai, char *groupName )
{
   static int numPasses = 0;
   
   ULONG  rval = currentLineNumber; // Not necessarily zero anymore.

   int    len  = StringLength( groupName );

tryFromTop:

   if (numPasses > 1)
      {
      currentErrorNumber = INI_NOHEADER; // groupName is NOT in the file!
      numPasses          = 0;            // Reset loop guard.   
      currentLineNumber  = START_LINE_NUMBER;

      StringNCopy( currentGroupName, &ai->AI_FILELINES[ 0 ], IMLS );
      
      return( 1 );
      }   

   currentErrorNumber = INI_NOERROR;

   // Start at current location of file & look for groupName:
   if (caseSensitive == TRUE)
      {
      while (rval < numberOfElements)
         {
         if ( StringNComp( &ai->AI_FILELINES[ rval * IMLS ], groupName, len ) == 0)
            break;
         else
            rval++;
         }
      }
   else
      {
      while (rval < numberOfElements)
         {
         if (StringIComp( &(ai->AI_FILELINES[ rval * IMLS ]), groupName, len ) == 0)
            break;
         else
            rval++;
         }
      }

   if (rval >= numberOfElements)
      {
      rval = 0;    // Set rval to start from Top of file this time.

      numPasses++; // Try to avoid inifinite looping.
       
      goto tryFromTop;
      }
      
   return( rval + 1 ); // The line below groupName is the 1st Item
}

/****h* IniFuncs.o/iniGetGroupEnd() [1.0] *****************************
*
* NAME
*    ULONG index = iniGetGroupEnd( aiPTR ai, char *groupName );
*
* DESCRIPTION
*    Return the lineIndex for the last item in the named group,
*    0 if there's a problem.
***********************************************************************
*
*/

PUBLIC ULONG iniGetGroupEnd( aiPTR ai, char *groupName )
{
   ULONG rval = currentLineNumber; // iniGetGroupStart( ai, groupName );

   if (StringNComp( &(ai->AI_FILELINES[ rval * IMLS ]), "[", 1 ) == 0)
      rval++;
      
   currentErrorNumber = INI_NOERROR;

   while (rval < numberOfElements)
      {
      if (StringNComp( &(ai->AI_FILELINES[ rval * IMLS ]), "[", 1 ) == 0)
         {
	 currentGroupEndLineNumber = rval;

         break;
	 }
      else
         rval++;
      }

   return( rval );
}

/****h* IniFuncs.o/iniGroupLength() [1.0] *****************************
*
* NAME
*    ULONG length = iniGroupLength( aiPTR ai );
*
* DESCRIPTION
*    Get the length in file lines of the current group.
***********************************************************************
*
*/

PUBLIC ULONG iniGroupLength( aiPTR ai )
{
   int end, start;

   currentErrorNumber = INI_NOERROR;

   start = iniGetGroupStart( ai, currentGroupName );
   end   = iniGetGroupEnd(   ai, currentGroupName );

   return( end - start ); 
}

/****h* IniFuncs.o/iniNamedGroupLen() [1.0] ***************************
*
* NAME
*    ULONG length = iniNamedGroupLen( aiPTR ai, char *groupName );
*
* DESCRIPTION
*    Get the length in file lines of the named group.
***********************************************************************
*
*/

PUBLIC ULONG iniNamedGroupLen( aiPTR ai, char *groupName )
{
   int start, end;
   
   currentErrorNumber = INI_NOERROR;

   start = iniGetGroupStart( ai, groupName );
   end   = iniGetGroupEnd(   ai, groupName );

   return( end - start ); 
}

/****h* IniFuncs.o/iniCurrentGroup() [1.0] ****************************
*
* NAME
*    char *name = iniCurrentGroup( aiPTR ai );
*
* DESCRIPTION
*    Return the name of the Current group.
***********************************************************************
*
*/

PUBLIC char *iniCurrentGroup( aiPTR ai )
{
   currentErrorNumber = INI_NOERROR;

   return( currentGroupName );
}

/****i* IniFuncs.o/FindGroup() [1.0] *******************************
*
* NAME
*    ULONG index = FindGroup( aiPTR ai, char *groupName );
*
* DESCRIPTION
*    Starting at startLine in the memory list, find the first
*    group that matches groupName (which includes the []).
*    Return the Line number of the matched group or 0xFFFFFFFF if 
*    there's no match.
***********************************************************************
*
*/

SUBFUNC ULONG FindGroup( aiPTR ai, char *groupName, int startLine )
{
   ULONG rval = 0xFFFFFFFFL;
   int   idx  = 0;

   currentLineNumber  = startLine;
   currentErrorNumber = INI_NOERROR;

   if (!groupName)
      {
      currentErrorNumber = INI_USERERROR; // groupName was NULL!

      return( rval );
      }
           
   if (*groupName != '[')
      {
      currentErrorNumber = INI_USERERROR; // groupName did NOT have a '[' start character!

      return( rval );
      }
           
   for (idx = currentLineNumber; idx < numberOfElements; idx++)
      {
      int len = StringLength( groupName );

      if (caseSensitive == TRUE)
         {
         if (StringNComp( &ai->AI_FILELINES[idx * IMLS], groupName, len ) == 0)
            {
            StringNCopy( currentGroupName, groupName, IMLS );

            currentErrorNumber = INI_NOERROR;

            rval = currentLineNumber = idx;

            currentGroupStartLineNumber = rval + 1;

	    (void) iniGetGroupEnd( ai, groupName );

            break;
            }
         }
      else
         {
         if (StringIComp( &ai->AI_FILELINES[idx * IMLS], groupName, len ) == 0)
            {
            StringNCopy( currentGroupName, groupName, IMLS );
            
            currentErrorNumber = INI_NOERROR;

            rval = currentLineNumber = idx;

            currentGroupStartLineNumber = rval + 1;

	    (void) iniGetGroupEnd( ai, groupName );

            break;
            }
         }
      }

   if (rval == 0xFFFFFFFF)
      {
//      rval++;
      
      currentErrorNumber = INI_UNKERROR;

      StringNCopy( currentGroupName, "[GROUP_NOT_FOUND]", IMLS );
      }      
      
   return( rval );
}

/****h* IniFuncs.o/iniSearchForGroup() [2.0] **************************
*
* NAME
*    ULONG index = iniSearchForGroup( aiPTR ai, char *groupName );
*
* DESCRIPTION
*    Starting at the beginning of the memory list, find the first
*    group that matches groupName (which includes the []).
*    Return the Line number of the matched group or 0xFFFFFFFF if 
*    there's no match.
***********************************************************************
*
*/

PUBLIC ULONG iniSearchForGroup( aiPTR ai, char *groupName )
{
   ULONG rval = FindGroup( ai, groupName, 0 );
   
   if (currentErrorNumber != INI_NOERROR)
      {
#     ifdef TEST_INI
      sprintf( ErrMsg, 
               CMsg( MSG_IF_FMT_GRP_NOT_FOUND, MSG_IF_FMT_GRP_NOT_FOUND_STR ),
               groupName 
             );
      
      UserInfo( ErrMsg, User_ERROR );
#     endif

      rval = START_LINE_NUMBER; // remove 0xFFFFFFFF (invalid number!)
      
      currentErrorNumber = INI_NOHEADER;
      }
      
   return( rval );
}

/****h* IniFuncs.o/iniFindGroup() [1.0] *******************************
*
* NAME
*    ULONG index = iniFindGroup( aiPTR ai, char *groupName );
*
* DESCRIPTION
*    Starting at the currentLineNumber of the memory list, find the first
*    group that matches groupName (which includes the []).
*    Return the Line number of the matched group or 0xFFFFFFFF if 
*    there's no match.
***********************************************************************
*
*/

PUBLIC ULONG iniFindGroup( aiPTR ai, char *groupName )
{
   ULONG rval = FindGroup( ai, groupName, currentLineNumber );
   
   if (currentErrorNumber != INI_NOERROR)
      {
#     ifdef TEST_INI
      sprintf( ErrMsg, 
               CMsg( MSG_IF_FMT_GRP_NOT_FOUND, MSG_IF_FMT_GRP_NOT_FOUND_STR ),
               groupName 
             );
      
      UserInfo( ErrMsg, User_ERROR );
#     endif

      rval = START_LINE_NUMBER; // remove 0xFFFFFFFF (invalid number!)
      
      currentErrorNumber = INI_NOHEADER;
      }
      
   return( rval );
}

/****h* IniFuncs.o/iniNextGroup() [1.2] *******************************
*
* NAME
*    ULONG index = iniNextGroup( aiPTR ai );
*
* DESCRIPTION
*    Starting at the current group, move down the list to the
*    beginning of the next group & return the lineIndex.  If there is 
*    none, return ai_NumElements.
***********************************************************************
*
*/

PUBLIC ULONG iniNextGroup( aiPTR ai )
{
   ULONG idx = currentLineNumber; // iniFindGroup( ai, currentGroupName ) + 1;

   if (StringNComp( &ai->AI_FILELINES[ idx * IMLS ], "[", 1 ) == 0)
      idx++; // We're at group name, go down one line.
      
   while (idx < numberOfElements)
      {
      if (StringNComp( &ai->AI_FILELINES[ idx * IMLS ], "[", 1 ) == 0)
         {
	 // Found the next Group header, so...
         int itemidx = idx + 1;

         StringNCopy( currentGroupName, &ai->AI_FILELINES[ idx * IMLS ], IMLS );
         StringNCopy( currentItemName,  iniGetItemName(  ai, itemidx ), IMLS );
         StringNCopy( currentItemValue, iniGetItemValue( ai, itemidx ), IMLS );

         currentGroupStartLineNumber = itemidx; // iniGetGroupStart( ai, currentGroupName );
         currentGroupEndLineNumber   = iniGetGroupEnd(   ai, currentGroupName );
         currentErrorNumber          = INI_NOERROR;

         currentLineNumber           = idx;

         return( idx );
         }
      
      idx++;
      }

   if (idx == numberOfElements)
      {
      currentLineNumber = 0;

      StringNCopy( currentGroupName, &ai->AI_FILELINES[ 0 ], IMLS );
      StringNCopy( currentItemName,  iniGetItemName(  ai, 1 ), IMLS );
      StringNCopy( currentItemValue, iniGetItemValue( ai, 1 ), IMLS );

      currentGroupStartLineNumber = 1;
      currentGroupEndLineNumber   = iniGetGroupEnd( ai, currentGroupName );
         
      currentErrorNumber          = INI_NOERROR;

      return( 0 ); // Wrap around to start of the file.
      }
   
   currentLineNumber = idx;

   return( idx );
}

/****h* IniFuncs.o/iniPrevGroup() [1.2] *******************************
*
* NAME
*    ULONG index = iniPrevGroup( aiPTR ai );
*
* DESCRIPTION
*    Starting at the current group, move up the list to the
*    beginning of the previous group & return the lineIndex.  
*    If there is none, return 0.
***********************************************************************
*
*/

PUBLIC ULONG iniPrevGroup( aiPTR ai )
{
   static int numTries = 0;
   
   int idx = currentLineNumber; // iniFindGroup( ai, currentGroupName ) - 1;

   if (StringNComp( &ai->AI_FILELINES[ idx * IMLS ], "[", 1 ) == 0)
      idx--; // We're at group name, go up one line.

tryAgain:

   while (idx > 0 && numTries < 2) // First item (0) is always a Group Name!
      {
      if (StringNComp( &ai->AI_FILELINES[ idx * IMLS ], "[", 1 ) == 0)
         {
         int itemidx = idx + 1;

         StringNCopy( currentGroupName, &ai->AI_FILELINES[ idx * IMLS ], IMLS );
         StringNCopy( currentItemName,  iniGetItemName(  ai, itemidx ), IMLS );
         StringNCopy( currentItemValue, iniGetItemValue( ai, itemidx ), IMLS );

         currentGroupStartLineNumber = itemidx; // iniGetGroupStart( ai, currentGroupName );
         currentGroupEndLineNumber   = iniGetGroupEnd( ai, currentGroupName );
         currentErrorNumber          = INI_NOERROR;

         currentLineNumber           = (ULONG) idx;
         
	 numTries = 0;
	       
         return( (ULONG) idx ); 
         }
      
      idx--;
      }

   if (idx == 0) // Are we at the start of the .ini file??
      {
      currentLineNumber = 0;

      StringNCopy( currentGroupName, &ai->AI_FILELINES[ 0 ], IMLS );
      StringNCopy( currentItemName,  iniGetItemName(  ai, 1 ), IMLS );
      StringNCopy( currentItemValue, iniGetItemValue( ai, 1 ), IMLS );

      currentGroupStartLineNumber = 1;
      currentGroupEndLineNumber   = iniGetGroupEnd( ai, currentGroupName );
         
      currentErrorNumber          = INI_NOERROR;

      numTries = 0;

      return( 0 );
      }
   else if (idx < 0)
      {
      idx = numberOfElements; // Wrap around to end of the file.

      numTries++;             // Increment inifinite loop guard.

      goto tryAgain;
      }
   else
      {
      currentLineNumber = (ULONG) idx;

      numTries = 0;

      return( (ULONG) idx );
      }
}

/****h* IniFuncs.o/iniFindItemInGroup() [1.0] *************************
*
* NAME
*    ULONG index = iniFindItemInGroup( aiPTR ia, char *groupName, char *itemName );
*
* DESCRIPTION
*    Starting at the beginning of the memory list, find the first
*    group item that matches itemName.
*    Return the Line number of the matched item or zero if there
*    is no match.
***********************************************************************
*
*/

PUBLIC ULONG iniFindItemInGroup( aiPTR ai, char *groupName, char *itemName )
{
   ULONG rval = 0L;
   int   idx  = 0;

   currentErrorNumber = INI_NOERROR;

   currentLineNumber  = START_LINE_NUMBER; // Start at the beginning.
   
   idx = iniFindGroup( ai, groupName ) + 1;
      
   while (idx < numberOfElements)
      {
      int len = StringLength( itemName );
      
      if (caseSensitive == TRUE)
         {
         if (StringNComp( &ai->AI_FILELINES[idx * IMLS], itemName, len ) == 0)
            {
            StringNCopy( currentItemName, itemName, IMLS );
            
            currentErrorNumber = INI_NOERROR;

            (void) iniGetItemValue( ai, idx );
         
            rval = currentLineNumber = idx;

            break;
            }
         }
      else
         {
         if (StringIComp( &ai->AI_FILELINES[idx * IMLS], itemName, len ) == 0)
            {
            StringNCopy( currentItemName, itemName, IMLS );
            
            currentErrorNumber = INI_NOERROR;

            (void) iniGetItemValue( ai, idx );
         
            rval = currentLineNumber = idx;

            break;
            }
         }
         
      idx++;
      }
      
   return( rval );
}

/****h* IniFuncs.o/iniFindItem() [1.0] ********************************
*
* NAME
*    ULONG index = iniFindItem( aiPTR ai, char *itemName );
*
* DESCRIPTION
*    Starting at the current group beginning, find the first
*    group item that matches itemName.
*    Return the Line number of the matched item or zero if there
*    is no match in the Current Group.
***********************************************************************
*
*/

PUBLIC ULONG iniFindItem( aiPTR ai, char *itemName )
{
   ULONG rval = 0L;
   int   idx  = 0;

   currentErrorNumber = INI_NOITEM;

   idx = currentLineNumber; // iniFindGroup( ai, currentGroupName ) + 1;

   if (StringNComp( &ai->AI_FILELINES[idx * IMLS], "[", 1 ) == 0)
      idx++;
      
   while (idx < numberOfElements)
      {
      int len = StringLength( itemName );

      if (StringNComp( &ai->AI_FILELINES[idx * IMLS], "[", 1 ) == 0)
         {
	 currentErrorNumber = INI_NOITEM;
	 
         return( START_LINE_NUMBER ); // Reached next group name, so bail out!
	 }

      if (caseSensitive == TRUE)
         {
         if (StringNComp( &ai->AI_FILELINES[idx * IMLS], itemName, len ) == 0)
            {
            StringNCopy( currentItemName, itemName, IMLS );
            
            currentErrorNumber = INI_NOERROR;

            (void) iniGetItemValue( ai, idx );
         
            rval = currentLineNumber = idx;

            break;
            }
         }
      else
         {
         if (StringIComp( &ai->AI_FILELINES[idx * IMLS], itemName, len ) == 0)
            {
            StringNCopy( currentItemName, itemName, IMLS );
            
            currentErrorNumber = INI_NOERROR;

            (void) iniGetItemValue( ai, idx );
         
            rval = currentLineNumber = idx;

            break;
            }
         }
            
      idx++;
      }

   currentLineNumber = idx;

   return( rval );
}

/****h* IniFuncs.o/iniSetItemName() [1.0] *****************************
*
* NAME
*    int error iniSetItemName( aiPTR ai, int lineIndex, char *itemName );
*
* DESCRIPTION
*    Set the given lineIndex item to itemName (if it's NOT a group).
*    Return zero if successful.
***********************************************************************
*
*/

PUBLIC int iniSetItemName( aiPTR ai, int lineIndex, char *itemName )
{
   char *ivalue  = NULL;
   char *delimit = itemDelimiters;
   int   len     = 0;

   currentErrorNumber = INI_NOERROR;

   if (StringNComp( &ai->AI_FILELINES[ lineIndex * IMLS ], "[", 1) == 0)
      return( INI_USERERROR ); // lineIndex is NOT on a group Item!
   
   ivalue = (char *) iniGetItemValue( ai, lineIndex );

   delimit[1] = '\0'; // Just need the first delimiter;

   StringNCopy( &ai->AI_FILELINES[ lineIndex * IMLS ], 
              itemName, INI_MAX_LINE_SIZE
            );

   StringNCat( &ai->AI_FILELINES[ lineIndex * IMLS ], delimit, 1 );   

   len = INI_MAX_LINE_SIZE - StringLength( &ai->AI_FILELINES[lineIndex * IMLS] ) - 1;

   StringNCat( &ai->AI_FILELINES[ lineIndex * IMLS ], ivalue, len );   

   StringNCopy( currentItemName, itemName, IMLS );
   
   return( 0 );
}

/****h* IniFuncs.o/iniSetItemValue() [1.0] ****************************
*
* NAME
*    int error iniSetItemValue( aiPTR ai, int lineIndex, char *itemValue );
*
* DESCRIPTION
*    Set the given lineIndex item value to itemValue (if it's 
*    NOT a group).  Return zero if successful.
***********************************************************************
*
*/

PUBLIC int iniSetItemValue( aiPTR ai, int lineIndex, char *itemValue )
{
   char *iname   = NULL;
   char *delimit = itemDelimiters;
   int   len     = 0;

   currentErrorNumber = INI_NOERROR;

   if (StringNComp( &ai->AI_FILELINES[lineIndex * IMLS], "[", 1) == 0)
      return( INI_USERERROR );
      
   iname = iniGetItemName( ai, lineIndex );

   delimit[1] = '\0'; // Just need the first delimiter;
      
   StringNCopy( &ai->AI_FILELINES[ lineIndex * IMLS ], iname, INI_MAX_LINE_SIZE );

   StringNCat( &ai->AI_FILELINES[ lineIndex * IMLS ], delimit, 1 );   

   len = INI_MAX_LINE_SIZE - StringLength( &ai->AI_FILELINES[lineIndex * IMLS] ) - 1;

   StringNCat( &ai->AI_FILELINES[ lineIndex * IMLS ], itemValue, len );   

   StringNCopy( currentItemValue, itemValue, IMLS );
   
   return( INI_NOERROR );
}

/****h* IniFuncs.o/iniSetGroupName() [1.0] ****************************
*
* NAME
*    int error iniSetGroupName( aiPTR ai, int lineIndex, cahr *groupName );
*
* DESCRIPTION
*    Set the given lineIndex group name groupName (if it's 
*    NOT an item).  Return INI_NOERROR if successful.
***********************************************************************
*
*/

PUBLIC int iniSetGroupName( aiPTR ai, int lineIndex, char *groupName )
{
   int len = StringLength( groupName );

   currentErrorNumber = INI_NOERROR;

   if (StringNComp( &ai->AI_FILELINES[ lineIndex * IMLS ], "[", 1) != 0)
      {
      currentErrorNumber = INI_USERERROR;

      return( INI_USERERROR );
      }

   if (*groupName != '[' && groupName[len] != ']')
      {
      // User screwed up, so correct it...

      sprintf( ErrMsg, "[%*.*s]", 
                       INI_MAX_GROUPNAME_SIZE, 
                       INI_MAX_GROUPNAME_SIZE, 
                       groupName 
             );
      
      StringNCopy( &ai->AI_FILELINES[ lineIndex * IMLS ], ErrMsg, IMLS );
      
      StringNCopy( currentGroupName, &ai->AI_FILELINES[ lineIndex * IMLS ], IMLS );

      currentErrorNumber = INI_NOHEADER;

      return( currentErrorNumber );
      }
   
   if (len > INI_MAX_GROUPNAME_SIZE)
      {
      sprintf( ErrMsg, 
               CMsg( MSG_IF_FMT_GRP_TRUNCATED, MSG_IF_FMT_GRP_TRUNCATED_STR ),
               groupName 
             );
      
      UserInfo( ErrMsg, User_ERROR );
      
      len = INI_MAX_GROUPNAME_SIZE;
      
      currentErrorNumber = INI_USERERROR;
      
      if (groupName[len] != ']')
         {
         sprintf( ErrMsg, "%*.*s]", INI_MAX_GROUPNAME_SIZE + 1,
                                    INI_MAX_GROUPNAME_SIZE + 1,
                                    groupName 
                );

         StringNCopy( currentGroupName, ErrMsg, IMLS );
         
         return( currentErrorNumber );
         }
      }
      
   StringNCopy( &ai->AI_FILELINES[ lineIndex * IMLS ], groupName, INI_MAX_GROUPNAME_SIZE );

   StringNCopy( currentGroupName, groupName, IMLS );
   
   return( INI_NOERROR );
}

/****h* IniFuncs.o/iniWrite() [1.0] ***********************************
*
* NAME
*    int errorValue = iniWrite( aiPTR ai );
*
* DESCRIPTION
*    Update the file with the contents of the memory list.
*
* RETURN VALUE
*    Zero if successful, IoErr() if there's a problem.
***********************************************************************
*
*/

PUBLIC int iniWrite( aiPTR ai )
{
   int rval = 0, i;
   
   currentErrorNumber = INI_NOERROR;

   RewindFile( ai->ai_FilePtr );

   for (i = 0; i < numberOfElements; i++)
      {
      // Removed lines will only be a newline, so we don't write them out:
      if (StringLength( &ai->AI_FILELINES[i * IMLS] ) <= 1)
         continue;
      else
         {
         // Insure that newlines are written to the file, since FPuts() does NOT:
         (void) AddNewline( &ai->AI_FILELINES[i * IMLS], INI_MAX_LINE_SIZE );

         if (FPuts( ai->ai_FilePtr, &ai->AI_FILELINES[i * IMLS] ) != 0)
            {
            // Some sort of IoErr:
            sprintf( ErrMsg, 
                     CMsg( MSG_IF_FMT_FILE_WRT_ERROR, MSG_IF_FMT_FILE_WRT_ERROR_STR ),
                     IoErr()
                   );
         
            UserInfo( ErrMsg, SystemProblem );
         
            rval               = IoErr();
            currentErrorNumber = INI_UNKERROR;
            }
         }
      }

   return( rval );
}

/****h* IniFuncs.o/iniWriteToFile() [1.0] *****************************
*
* NAME
*    int errorValue = iniWriteToFile( aiPTR ai, char *fileName );
*
* DESCRIPTION
*    Write the contents of the memory list to a different file.
*
* RETURN VALUE
*    Zero if successful, IoErr() if there's a problem.
***********************************************************************
*
*/

PUBLIC int iniWriteToFile( aiPTR ai, char *fileName )
{
   struct Window *wptr    = GetActiveWindow();
   BPTR           outFile = (BPTR) NULL;
   int            rval    = 0, i;
   
   currentErrorNumber = INI_NOERROR;

   if (StringLength( fileName ) < 1)
      {
      currentErrorNumber = INI_NOFILE;
      
      return( INI_NOFILE );
      }

   if (!(outFile = OpenINIFile( fileName, MODE_NEWFILE ))) // == NULL)
      {
      currentErrorNumber = INI_USERERROR;

      return( INI_USERERROR );
      }
                 
   for (i = 0; i < numberOfElements; i++)
      {
      // Removed lines will only be a newline, so we don't write them out:
      if (StringLength( &ai->AI_FILELINES[ i * IMLS ] ) <= 1)
         continue;
      else
         {
         // Insure that newlines are written to the file, since FPuts() does NOT:
         (void) AddNewline( &ai->AI_FILELINES[i * IMLS], INI_MAX_LINE_SIZE );

         if (FPuts( outFile, &ai->AI_FILELINES[i * IMLS] ) != 0)
            {
            // Some sort of IoErr:
#           ifdef TEST_INI
            sprintf( ErrMsg, 
                     CMsg( MSG_IF_FMT_FILE_WRT_ERROR, MSG_IF_FMT_FILE_WRT_ERROR_STR ),
                     IoErr()
                   );
         
            SetNotifyWindow( wptr );
            
            UserInfo( ErrMsg, SystemProblem );
#           endif
         
            rval               = IoErr();
            currentErrorNumber = INI_UNKERROR;
            }
         }
      }

   if (outFile) // != NULL)
      Close( outFile ); // weesa okey-dokey!
                 
   return( rval );
}

/****h* IniFuncs.o/iniAddGroup() [1.0] ********************************
*
* NAME
*    int errorValue = iniAddGroup( aiPTR ai, char *groupName, int numItems );
*
* DESCRIPTION
*    Create a new memory space with room for a new group.
*
* INPUTS
*    ai        - the current aiPTR.
*    groupName - the name of the group that will be added (including
*                the []).
*    numItems  - the Number of items to add.
*
* RETURN VALUE
*    Zero if successful, INI_ERROR_NUMBER if there's a problem.
***********************************************************************
*
*/

PUBLIC int iniAddGroup( aiPTR ai, char *groupName, int numItems )
{
   int rval    = 0, i;
   int newSize = numberOfElements + numItems + 1;

   currentErrorNumber = INI_NOERROR;

   if ((rval = iniWrite( ai )) != 0)   
      {
      return( rval );
      }

   Guarded_FreeLV( ai->ai_LVM );  // Throw out old memory space.

   // Allocate larger space:      

   if (!(ai->ai_LVM = Guarded_AllocLV( newSize, INI_MAX_LINE_SIZE ))) // == NULL)
      {
      // Ran out of memory:
      currentErrorNumber = INI_NOMEMORY;
        
      Close( ai->ai_FilePtr );
         
      FreeVec( ai );
      
      ReportAllocLVError();   

      return( (int) currentErrorNumber );
      }

   SetupList( &ai->ai_FileList, ai->ai_LVM ); // Reset file node pointers

   currentFileList = &ai->ai_FileList;
   
   RewindFile( ai->ai_FilePtr );         // Reset for the iniReadInFile()

   iniReadInFile( ai );                  // Read the old items back into memory

   currentLineNumber = numberOfElements; // point to added groupName

   // Add the new group & its items:

   StringNCopy( &ai->AI_FILELINES[ currentLineNumber * IMLS ], groupName, INI_MAX_LINE_SIZE );
   
   // Initialize the new items to empty string:
   for (i = numberOfElements + 1; i < newSize; i++)
      {
      StringNCopy( &ai->AI_FILELINES[i * IMLS],
                   CMsg( MSG_IF_DEFAULT_ITEM_VALUE, MSG_IF_DEFAULT_ITEM_VALUE_STR ),
                   INI_MAX_LINE_SIZE
                 );
      }

   // Finally, update internal struct record keeping variables:
   numberOfElements = newSize;

   StringNCopy( currentGroupName, groupName, IMLS );
 
   currentGroupStartLineNumber = iniGetGroupStart( ai, currentGroupName );
   currentGroupEndLineNumber   = iniGetGroupEnd(   ai, currentGroupName );
   
   StringNCopy( currentItemName,  iniGetItemName(  ai, currentLineNumber + 1 ), IMLS );
   StringNCopy( currentItemValue, iniGetItemValue( ai, currentLineNumber + 1 ), IMLS );
   
   stringType = iniItemTypeIsString( currentItemValue );

   return( rval );
}

/****h* IniFuncs.o/iniAddItem() [1.0] *********************************
*
* NAME
*    int errorValue = iniAddItem( aiPTR ai, char *groupName, 
*                                 char *itemName, ULONG *itemValue );
*
* DESCRIPTION
*    Create a new memory space with room for a new item in the 
*    Current group.
*
* INPUTS
*    ai        - the current aiPTR.
*    groupName - the name of the group that will be added to (including
*                the []).
*    itemName  - the Name of the new item.
*    itemValue - the Value of the new item.
*
* RETURN VALUE
*    Zero if successful, INI_ERROR_NUMBER if there's a problem.
***********************************************************************
*
*/

PUBLIC int iniAddItem( aiPTR ai, char *groupName, 
                                 char *itemName,
                                 char *itemValue
                     )
{
   struct ListViewMem *lvm = NULL;
   int                 chk = 0, len, i;

   currentErrorNumber = INI_NOERROR;

   chk = StringLength( itemName ) + StringLength( itemValue ) + 2;
   
   if (chk > INI_MAX_LINE_SIZE)
      {
      // Truncate the itemName:
      chk = INI_MAX_LINE_SIZE - StringLength( itemValue ) - 2;
      
      itemName[chk] = '\0';

#     ifdef TEST_INI
      sprintf( ErrMsg, CMsg( MSG_IF_FMT_ITM_TRUNCATED, MSG_IF_FMT_ITM_TRUNCATED_STR ),
                             itemName 
             );
      
      UserInfo( ErrMsg, User_ERROR );
#     endif
      
      currentErrorNumber = INI_USERERROR;
      }
   
   if (!(lvm = Guarded_AllocLV(  numberOfElements + 1, INI_MAX_LINE_SIZE ))) // == NULL)
      {
      currentErrorNumber = INI_NOMEMORY;
      
      return( INI_NOMEMORY );
      }
  
   RewindFile( ai->ai_FilePtr );
   
   len = StringLength( groupName );

   i = 0; // Start at first line in memory space.

   while (StringNComp( &ai->AI_FILELINES[ i * IMLS ], groupName, len ) != 0)
      {
      StringNCopy( &lvm->lvm_NodeStrs[i * IMLS], &ai->AI_FILELINES[i * IMLS], INI_MAX_LINE_SIZE );

      i++;
      }
      
   StringNCopy( &lvm->lvm_NodeStrs[i * IMLS], // Copy the groupName also
              &ai->AI_FILELINES[ i * IMLS], 
              INI_MAX_LINE_SIZE 
            );

   i++; // Point to first item in groupName.
   currentGroupStartLineNumber = currentLineNumber = i;

   // Copy the new addition into the array:

   StringNCopy( &lvm->lvm_NodeStrs[i * IMLS], itemName, StringLength( itemName ) );

   StringNCat( &lvm->lvm_NodeStrs[i * IMLS], itemDelimiters, 1 );
   StringNCat( &lvm->lvm_NodeStrs[i * IMLS], itemValue, StringLength( itemValue ) );

   i++;
   
   for ( ; i < numberOfElements; i++) // numberOfElements + 1; i++)
      {
      StringNCopy( &lvm->lvm_NodeStrs[i * IMLS],       // Copy rest of lines
               &ai->AI_FILELINES[ (i - 1) * IMLS], 
               INI_MAX_LINE_SIZE 
             );
      }
      
   Guarded_FreeLV( ai->ai_LVM ); // Throw out old memory space.
   
   SetupList( &ai->ai_FileList, lvm ); // Update the list nodes.

   ai->ai_LVM = lvm; // Point to new initialized memory space

   // Now update the rest of the globals:
   currentFileList = &ai->ai_FileList;
   
   numberOfElements++;

   StringNCopy( currentGroupName, groupName, IMLS );
   StringNCopy( currentItemName,  itemName,  IMLS );
   StringNCopy( currentItemValue, itemValue, IMLS );
   
   currentGroupEndLineNumber = iniGetGroupEnd( ai, groupName );
          
   return( 0 );
}

/****h* IniFuncs.o/iniRemoveItem() [1.0] ******************************
*
* NAME
*    int errorValue = iniRemoveItem( aiPTR ai, char *groupName, 
*                                              char *itemName   );
*
* DESCRIPTION
*    Mark an itemName line as deleted.
*
* INPUTS
*    ai        - the current aiPTR.
*    groupName - the name of the group that will be shortened (including
*                the []).
*    itemName  - the Name of the item to remove.
*
* RETURN VALUE
*    Zero if successful, INI_ERROR_NUMBER if there's a problem.
***********************************************************************
*
*/

PUBLIC int iniRemoveItem( aiPTR ai, char *groupName, char *itemName )
{
   ULONG idx = 0;

   currentErrorNumber = INI_NOERROR;
/*
   if (FindGroup( ai, groupName, currentLineNumber ) == 0xFFFFFFFF)
      {
      currentErrorNumber = INI_NOHEADER;

      return( INI_NOHEADER );
      }
*/
   if ((idx = iniFindItem( ai, itemName )) != 0)
      {
      StringNCopy( (char *) &ai->AI_FILELINES[ idx * IMLS ], "\n\0", 2 );

      numberOfElements--;
      
      return( INI_NOERROR );
      }
   else
      {
      currentErrorNumber = INI_NOITEM;
      
      return( INI_NOITEM ); 
      }
}

/****h* IniFuncs.o/iniRemoveGroup() [1.0] *****************************
*
* NAME
*    int errorValue = iniRemoveGroup( aiPTR ai, char *groupName );
*
* DESCRIPTION
*    Mark an entire group as deleted.
*
* INPUTS
*    ai        - the current aiPTR.
*    groupName - the name of the group that will be removed (including
*                the []).
*
* RETURN VALUE
*    Zero if successful, INI_NOHEADER if there's a problem.
***********************************************************************
*
*/

PUBLIC int iniRemoveGroup( aiPTR ai, char  *groupName )
{
   ULONG idx = 0;

   currentErrorNumber = INI_NOERROR;

   if ((idx = FindGroup( ai, groupName, currentLineNumber )) == 0xFFFFFFFF)
      {
      currentErrorNumber = INI_NOHEADER;

      return( INI_NOHEADER );
      }
   else
      {
      StringNCopy( &ai->AI_FILELINES[ idx * IMLS ], "\n\0", 2 );

      idx++;
      numberOfElements--;
      
      while ((StringNComp( &ai->AI_FILELINES[ idx * IMLS ], "[", 1 ) != 0)
              && (idx < numberOfElements)) // In case this is the last group
         {
         StringNCopy( &ai->AI_FILELINES[ idx * IMLS ], "\n\0", 2 );
         
         idx++;
         numberOfElements--;
         }
      }

   return( INI_NOERROR );
}

/****h* IniFuncs.o/iniCreateNewFile() [1.0] ***************************
*
* NAME
*    aiPTR rval = iniCreateNewFile( char *fileName, int numElements,
*                                   BOOL caseFlag,  char *delimiters );
*
* DESCRIPTION
*    Create a new aiPTR & associated file.
*
* INPUTS
*    fileName    - the new file to create.
*    numElements - the Number of Lines to create.  If this value is
*                  < 1, a default size of 100 will be created.
*    caseFlag    - TRUE is Case-sensitive, FALSE is insensitive.
*    delimiters  - the separators between the itemName & itemValue.
*
* RETURN VALUE
*    an aiPTR, NULL if there's a problem.
***********************************************************************
*
*/

PUBLIC aiPTR iniCreateNewFile( char *fileName, int numElements, 
                               BOOL  caseFlag, char *delimiters
                             )
{
   struct Window *wptr   = GetActiveWindow(); // For UserInfo() only
   aiPTR          rval   = (aiPTR) NULL;
   BPTR           aiFile = (BPTR)  NULL;

   currentErrorNumber = INI_NOERROR;

   if (openedLibraries == FALSE)
      (void) setupLibraries( "inifuncs.catalog" );
      
   if (!(rval = (aiPTR) AllocVec( sizeof( AI ), MEMF_CLEAR | MEMF_ANY ))) // == NULL)
      {
      currentErrorNumber = INI_NOMEMORY;
      
      return( (aiPTR) NULL );
      }

   caseSensitive  = caseFlag;

   StringNCopy( itemDelimiters, delimiters, 32 );

   if (!(aiFile = OpenINIFile( fileName, MODE_NEWFILE ))) // == NULL)
      {
      FreeVec( rval );

      return( (aiPTR) NULL );
      }
   else
      rval->ai_FilePtr = aiFile;

   numberOfElements = numElements;
   
   if (numberOfElements < 1)
      {
      currentErrorNumber = INI_NOCONTENT;

      rval->ai_LVM = Guarded_AllocLV( DEFAULT_FILE_SIZE, INI_MAX_LINE_SIZE );
      
      if (!rval->ai_LVM) // == NULL)
         {
         // Ran out of memory:
         currentErrorNumber = INI_NOMEMORY;
        
         Close( aiFile );
         
         FreeVec( rval );

         ReportAllocLVError();
                  
         return( (aiPTR) NULL );
         }

      SetupList( &rval->ai_FileList, rval->ai_LVM );
      currentFileList = &rval->ai_FileList;

      SetNotifyWindow( wptr );

#     ifdef TEST_INI
      UserInfo( CMsg( MSG_IF_USING_DEFAULT, MSG_IF_USING_DEFAULT_STR ), 
                User_ERROR
              );
#     endif

      SetupDefaultGrouping( rval, DEFAULT_FILE_SIZE );
      }
   else
      {
      rval->ai_LVM = Guarded_AllocLV( numberOfElements, INI_MAX_LINE_SIZE );
      
      if (!rval->ai_LVM) // == NULL)
         {
         // Ran out of memory:
         currentErrorNumber = INI_NOMEMORY;
        
         Close( aiFile );
         
         FreeVec( rval );

         ReportAllocLVError();
                  
         return( (aiPTR) NULL );
         }
      else
         SetupDefaultGrouping( rval, numElements );

      SetupList( &rval->ai_FileList, rval->ai_LVM );
      currentFileList = &rval->ai_FileList;
      }

   SetupGlobals( rval, fileName );      

   return( rval );
}

// --------------------------------------------------------------

#ifdef TEST_INI

# define GROUPNAME1     "[GroupName1]"
# define GROUPNAME2     "[GroupName2]"
# define ADDEDGROUP3    "[AddedGroup3]"
# define MODIFIEDGROUP3 "[ModifiedGroup3]"
# define CREATEDGROUP   "[CreatedGroup]"

# define DEFAULTITEM    "DefaultItem"
# define CHANGEDITEM1   "ChangedItem1"
# define ADDEDITEM      "AddedItemXX"
# define CREATEDITEM1   "CreatedItem1"
# define CREATEDITEM2   "CreatedItem2"
# define ADDEDVALUE     "This string is part of added item!"

PUBLIC int main( int argc, char **argv )
{ 
   IMPORT aiPTR aiCopy;
   
   aiPTR  myAI      = NULL, newAI = NULL;
   char  *chkDelims = "= $|", *value = NULL; 
   ULONG  index     = 0L;
   int    rval      = RETURN_OK, chk = INI_NOERROR;
      
   if (argc != 2)
      {
      fprintf( stderr, "USAGE: %s fileName.ini\n", argv[0] );

      rval = ERROR_REQUIRED_ARG_MISSING;

      goto exitTestINI;
      }
      
   if (!(myAI = iniOpenFile( argv[1], FALSE, chkDelims ))) // == NULL)
      {
      fprintf( stdout, "%s had a Problem with %s\n", argv[0], argv[1] );

      rval = IoErr();

      goto exitTestINI;
      }
   else
      fprintf( stdout, "iniOpenFile() working!\n" );

/* These tests pass: ----------------------------------------------------------

   if (iniView_EditContents( myAI ) != 0)
      fprintf( stdout, "iniView_EditContents() failed!\n" );

   // User might have done a Load or Save operation, so...
   if (updateAIPointer == TRUE)
      myAI = aiCopy;


   fprintf( stdout, "Current GroupName: %s\n", iniCurrentGroup( myAI ) );

   index = iniFindGroup( myAI, GROUPNAME2 );

   fprintf( stdout, "%s located at line #: %d\n", iniCurrentGroup( myAI ), index );

   fprintf( stdout, "line# %d is a Group?  %s\n", 
                    index, 
                    iniIsGroup( myAI, index ) == TRUE ? "TRUE" : "FALSE" 
          );

   fprintf( stdout, "line# %d is an Item?  %s\n", 
                    index, 
                    iniIsItem( myAI, index ) == TRUE ? "TRUE" : "FALSE" 
          );

   index = iniFindItemInGroup( myAI, GROUPNAME1, "testHexValue" );
   value = iniGetItemValue( myAI, index );
   
   fprintf( stdout, "Now we're at %s on line# %d\n", iniGetItemName( myAI, index ), index );   

   fprintf( stdout, "iniTranslateErrorNumber( %d ) translates to: \"%s\"\n",  
                     INI_NOFILE, iniTranslateErrorNumber( INI_NOFILE )
          );

   fprintf( stdout, "Group StartLine# = %d, End# = %d\n", 
                     iniGetGroupStart( myAI, GROUPNAME1 ),
                     iniGetGroupEnd(   myAI, GROUPNAME1 )
          );

   fprintf( stdout, "Current GroupLen = %d\n", iniGroupLength( myAI ) );

   fprintf( stdout, "Named (%s) GroupLen = %d\n", 
                    GROUPNAME2, iniNamedGroupLen( myAI, GROUPNAME2 ) 
          );
*/
   fprintf( stdout, "Moving to %s...\n", (char *) GROUPNAME1 );
   index = iniFindGroup( myAI, (char *) GROUPNAME1 );

   index = iniNextGroup( myAI );   
   fprintf( stdout, "after iniNextGroup( ai ), group is %s\n", iniCurrentGroup( myAI ) );

   index = iniNextGroup( myAI );   
   fprintf( stdout, "after iniNextGroup( ai ), group is %s\n", iniCurrentGroup( myAI ) );

   index = iniPrevGroup( myAI );   
   fprintf( stdout, "after iniPrevGroup( ai ), group is %s\n", iniCurrentGroup( myAI ) );

   value = ADDEDVALUE;
   
   fprintf( stdout, "item Value is String? %s\n", 
                     iniItemTypeIsString( value ) == TRUE ? "TRUE" : "FALSE" 
          );

   value = "1000000";
   
   fprintf( stdout, "item Value (now 1000000) is String? %s\n", 
                     iniItemTypeIsString( value ) == TRUE ? "TRUE" : "FALSE" 
          );

   fprintf( stdout, "Attempting to add item...\n" );

   if ((chk = iniAddItem( myAI, (char *) GROUPNAME2, 
                          (char *) ADDEDITEM, value )) != 0)
      {
      fprintf( stdout, "Failed to iniAddItem( ai, \"%s\", \"%s\", 0x%08LX)!\n",
                        (char *) GROUPNAME2, (char *) ADDEDITEM, (char *) ADDEDVALUE
             );

      fprintf( stdout, "Error %d = %s\n", chk, iniTranslateErrorNumber( chk ) );
      }
   else
      {
      fprintf( stdout, "Removing added item...\n" );

      index = iniFirstGroup( myAI ); // Start from the top
      
      if ((chk = iniRemoveItem( myAI, (char *) GROUPNAME2, (char *) ADDEDITEM )) != 0)
         {
         fprintf( stdout, "Failed to iniRemoveItem( ai, \"%s\", \"%s\" )!\n", 
                          (char *) GROUPNAME2, (char *) ADDEDITEM
                );

         fprintf( stdout, "Error %d = %s\n", chk, iniTranslateErrorNumber( chk ) );
         }
      }

   fprintf( stdout, "Adding group %s...\n", (char *) ADDEDGROUP3 );

   if (iniAddGroup( myAI, ADDEDGROUP3, 2 ) != 0)
      {
      fprintf( stdout, "iniAddGroup( ai, \"%s\", 2 ) failed!\n", (char *) ADDEDGROUP3 );
      }
   else
      {   
      fprintf( stdout, "Change %s to %s...\n", 
                       (char *) ADDEDGROUP3, 
                       (char *) MODIFIEDGROUP3 
             );
      
      index = iniFirstGroup( myAI );
      index = iniFindGroup(  myAI, (char *) ADDEDGROUP3 );
      
      if (iniSetGroupName( myAI, index, (char *) MODIFIEDGROUP3 ) != 0)
         {
         fprintf( stdout, "iniSetGroupName( ai, %d, \"%s\" ); failed!\n",
                           index, (char *) MODIFIEDGROUP3  
                );
         }

      fprintf( stdout, "Trying to find first item for %s...\n", (char *) MODIFIEDGROUP3 );
      
      if ((index = iniFindItem( myAI, (char *) DEFAULTITEM )) == 0)
         {
         fprintf( stdout, "%s = NULL was NOT found!\n", (char *) DEFAULTITEM );
         
         }
      
      fprintf( stdout, "Changing first item for %s...\n", (char *) MODIFIEDGROUP3 );
 
      if ((chk = iniSetItemName( myAI, index, (char *) CHANGEDITEM1 )) != 0)
         {
         fprintf( stdout, "%s did not change!\n", (char *) DEFAULTITEM );
         fprintf( stdout, "Error %d = %s\n", chk, iniTranslateErrorNumber( chk ) );
         }       
      else
         {
         char *val = "Modified value is a String!";
         
         fprintf( stdout, "Changing first item value for %s...\n", (char *) MODIFIEDGROUP3 );

         if ((chk = iniSetItemValue( myAI, index, val )) != 0)
            {
            fprintf( stdout, "%s value did not change!\n", (char *) DEFAULTITEM );
            fprintf( stdout, "Error %d = %s\n", chk, iniTranslateErrorNumber( chk ) );
            }
         }
         
      fprintf( stdout, "Writing results to different file %s...\n", "TestedFuncs.ini" );
      
      if ((chk = iniWriteToFile( myAI, "TestFuncs.ini" )) != 0)
         {
         fprintf( stdout, "Failed to iniWriteToFile( ai, \"TestFuncs.ini\"\n" );

         fprintf( stdout, "Error %d = %s\n", chk, iniTranslateErrorNumber( chk ) );
         }      

      fprintf( stdout, "Now removing added group...\n" );

      index = iniFirstGroup( myAI ); // Start from top

      if ((chk = iniRemoveGroup( myAI, (char *) MODIFIEDGROUP3 )) != 0)
         {
         fprintf( stdout, "Failed to iniRemoveGroup( ai, \"%s\" );\n", (char *) MODIFIEDGROUP3 );

         fprintf( stdout, "Error %d = %s\n", chk, iniTranslateErrorNumber( chk ) );
         }      
      }

   fprintf( stdout, "Testing iniCreateNewFile( \"CreatedFile.ini\", 3, 1, \"= </\", )...\n" );

   iniExit( myAI ); // done with myAI
   
   newAI = iniCreateNewFile( "CreatedFile.ini", 3, TRUE, "= </" ); // 0x3D203C2F );
   
   fprintf( stdout, "iniCreateNewFile() has %s\n", newAI == NULL ? "FAILED!" : "Passed!" );

   index = iniFindGroup( newAI, "[Default Group Name]" );

   if ((chk = iniSetGroupName( newAI, index, (char *) CREATEDGROUP )) != 0)
      {
      fprintf( stdout, "iniSetGroupName( ai, %d, \"%s\" ); failed!\n",
                                         index, (char *) CREATEDGROUP  
             );
      }
   else
      {
      if ((index = iniFindItem( newAI, (char *) DEFAULTITEM )) == 0)
         {
         fprintf( stdout, "%s = NULL was NOT found!\n", (char *) DEFAULTITEM );
         
         }
      
      fprintf( stdout, "Changing first item for %s...\n", (char *) CREATEDGROUP );
 
      if ((chk = iniSetItemName( newAI, index, (char *) CREATEDITEM1 )) != 0)
         {
         fprintf( stdout, "%s did not change!\n", (char *) DEFAULTITEM );
         fprintf( stdout, "Error %d = %s\n", chk, iniTranslateErrorNumber( chk ) );
         }       
      else
         {
         char *val = "Created value is a String!";
         
         fprintf( stdout, "Changing first item value for %s...\n", (char *) CREATEDGROUP );

         if ((chk = iniSetItemValue( newAI, index, val )) != 0)
            {
            fprintf( stdout, "%s did not change!\n", (char *) DEFAULTITEM );
            fprintf( stdout, "Error %d = %s\n", chk, iniTranslateErrorNumber( chk ) );
            }
         }

      if ((index = iniFindItem( newAI, (char *) DEFAULTITEM )) == 0)
         {
         fprintf( stdout, "%s = NULL was NOT found!\n", (char *) DEFAULTITEM );
         
         }
      
      fprintf( stdout, "Changing second item for %s...\n", (char *) CREATEDGROUP );
 
      if ((chk = iniSetItemName( newAI, index, (char *) CREATEDITEM2 )) != 0)
         {
         fprintf( stdout, "%s did not change!\n", (char *) DEFAULTITEM );
         fprintf( stdout, "Error %d = %s\n", chk, iniTranslateErrorNumber( chk ) );
         }       
      else
         {
         char *val = "34000";
         
         fprintf( stdout, "Changing second item value for %s...\n", (char *) CREATEDGROUP );

         if ((chk = iniSetItemValue( newAI, index, val )) != 0)
            {
            fprintf( stdout, "%s did not change!\n", (char *) DEFAULTITEM );
            fprintf( stdout, "Error %d = %s\n", chk, iniTranslateErrorNumber( chk ) );
            }
         }
      }
      
   if ((chk = iniWrite( newAI )) != 0)
      {
      fprintf( stdout, "iniWrite() failed!\n" );
      fprintf( stdout, "Error %d = %s\n", chk, iniTranslateErrorNumber( chk ) );
      }       

   fprintf( stdout, "Done testing all IniFuncs.o functions!\n" );
   
   iniExit( newAI );

exitTestINI:

   return( rval );
}

#endif

/* ---------------- END of IniFuncs.c file! --------------------- */
