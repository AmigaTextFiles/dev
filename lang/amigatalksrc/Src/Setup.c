/****h* AmigaTalk/Setup.c [3.0] ************************************
*
* NAME
*   Setup.c
*
* HISTORY
*   25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*   10-Dec-2003 - Added freeVecAllAddresses() to 
*                 freeVecMemorySpaces()
*
* FUNCTIONAL INTERFACE:
*   PUBLIC void freeVecMemorySpaces(   void );
*   PUBLIC int  freeSlackMemorySpaces( void ); 
*
*   PUBLIC int  firstSetup( void );
*   PUBLIC int  InitATalk(  void );
*   PUBLIC void ShutDown( void );
*
*   InitATalk() calls these functions:
*
*   PRIVATE  int   SetupScreen( void );
*
*   PRIVATE  int   OpenATWindow( void );
*   PRIVATE  int   SetupListViewer( void );
*
*   IMPORT  void InitAList( void );
*   ------------------------------------------------------------
*   ShutDown() calls these functions:
*
*   IMPORT  void KillList( void );
*   IMPORT  void CloseStatusWindow( void );
*   IMPORT  void UpdateIconToolTypes();
*
*   PRIVATE void CloseATWindow( void );
*   PRIVATE void CloseDownScreen( void );
*   PRIVATE void CloseATLibs( void );
*
* NOTES
*   $VER: AmigaTalk:Src/Setup.c 3.0 (25-Oct-2004) by J.T. Steichen
********************************************************************
*
*/

#include <stdio.h>
#include <string.h>
#include <assert.h> // Remove after fixing bugs...

#include <exec/types.h>
#include <exec/libraries.h>
#include <exec/lists.h>
#include <exec/nodes.h>
#include <exec/memory.h>

#include <AmigaDOSErrs.h>

#include <dos/dos.h>

#include <intuition/intuitionbase.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/gadgetclass.h>

#include <libraries/gadtools.h>
#include <libraries/asl.h>
#include <libraries/locale.h>

#include <utility/tagitem.h>

#include <graphics/gfxbase.h>
#include <graphics/displayinfo.h>

#ifdef __SASC

# include <cybergraphx/cybergraphics.h>     // Added for V2.0
# include <pragmas/cybergraphics_pragmas.h> // Added for V2.1

# include <clib/dos_protos.h>           // Added for V2.1 
# include <clib/exec_protos.h>
# include <clib/intuition_protos.h>
# include <clib/gadtools_protos.h>
# include <clib/graphics_protos.h>
# include <clib/diskfont_protos.h>
# include <clib/cybergraphics_protos.h>     // Added for V2.1

IMPORT struct ExecBase      *SysBase;
IMPORT struct DosLibrary    *DOSBase;
IMPORT struct GfxBase       *GfxBase;
IMPORT struct Library       *IconBase;
IMPORT struct IntuitionBase *IntuitionBase;
IMPORT struct LocaleBase    *LocaleBase;       // In Main.c, Added on 09-Jan-2003

IMPORT struct Library       *GadToolsBase;
IMPORT struct Library       *CyberGfxBase;     // Added for V2.0

#else

# define __USE_INLINE__

# include <proto/dos.h>           // Added for V2.1 
# include <proto/exec.h>          // Added for V2.1 
# include <proto/intuition.h>     // Added for V2.1 
# include <proto/gadtools.h>      // Added for V2.1 
# include <proto/graphics.h>      // Added for V2.1 
# include <proto/diskfont.h>      // Added for V2.1 
# include <proto/locale.h>
# include <proto/utility.h>
# include <proto/cybergraphics.h> // Added for V2.1 

# include <cybergraphics.h>         // Located in SDK:Local/Include/ Added for V2.0
//# include <cybergraphics_pragmas.h> // Located in SDK:Local/Include/ Added for V2.1

IMPORT struct DOSIFace       *IDOS;       // -lauto should take care of these:
IMPORT struct ExecIFace      *IExec;
IMPORT struct IconIFace      *IIcon;
IMPORT struct IntuitionIFace *IIntuition;
IMPORT struct GraphicsIFace  *IGraphics;
IMPORT struct LocaleIFace    *ILocale;    // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

IMPORT struct UtilityIFace   *IUtility;
IMPORT struct CyberGfxIFace  *ICyberGfx;
IMPORT struct GadToolsIFace  *IGadTools;
 
IMPORT struct Library *SysBase;           // -lauto should take care of these:
IMPORT struct Library *DOSBase;
IMPORT struct Library *GfxBase;
IMPORT struct Library *IntuitionBase;
IMPORT struct Library *LocaleBase;        // In Main.c, Added on 09-Jan-2003
IMPORT struct Library *IconBase;          // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

IMPORT struct Library *UtilityBase;
IMPORT struct Library *GadToolsBase;
IMPORT struct Library *CyberGfxBase;     // Added for V2.0

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"
#include "CPGM:GlobalObjects/IniFuncs.h"

#include "CProtos.h"
#include "FuncProtos.h"

#include "IStructs.h"
#include "Constants.h"
#include "CantHappen.h" // for the char *ch_errstrs[] declaration only

# include "StringIndexes.h"
#include "StringConstants.h"

IMPORT struct Catalog *catalog;
IMPORT struct Catalog *ATECatalog;

IMPORT int debug;
IMPORT int prallocs;
IMPORT int silence;
IMPORT int n_incs, n_decs, n_mallocs;

IMPORT BOOL              HaveCyberLibrary; // Added for V2.0

IMPORT struct Menu      *ATMenus;
IMPORT struct NewMenu    ATNewMenu[];

IMPORT struct Gadget    *ATGList;
IMPORT struct Gadget    *ATGadgets[];
IMPORT struct NewGadget  ATNGad[];

IMPORT struct Screen    *Scr;
IMPORT struct Window    *ATWnd;
IMPORT APTR              VisualInfo;

IMPORT struct TextFont  *ATFont;
IMPORT struct TextAttr  *Font, Attr;
IMPORT struct CompFont   CFont;

IMPORT UWORD  wndwidth, wndheight;
IMPORT UWORD  ATScrWidth, ATScrHeight; // in Global.c

// Added for V2.2:
IMPORT UWORD  ATStatLeft, ATStatTop; // in Global.c

IMPORT UBYTE *Version;
IMPORT UBYTE  CopyRight[];
IMPORT UBYTE *scrtitle;
IMPORT UBYTE *ErrMsg;

IMPORT struct List  PgmList;
IMPORT struct Node  PgmListItems[ PGM_MAXITEM ];
IMPORT char        *PgmItemBuffer;

IMPORT UBYTE       *ATalkProblem;

IMPORT struct TagItem FontTags[];   // In Global.c
IMPORT struct TagItem LoadTags[];   // In Global.c
IMPORT struct TagItem SaveTags[];   // In Global.c
IMPORT struct TagItem ScreenTags[]; // In Global.c

IMPORT UBYTE EnvironFile[ LARGE_TOOLSPACE ]; // The last remaining ToolType.

// ------------------------ Former ToolTypes: -----------------

// MemorySpaces: ------------
IMPORT ULONG ByteArrayTableSize;
IMPORT ULONG InterpreterTableSize;
IMPORT ULONG IntegerTableSize;
IMPORT ULONG SymbolTableSize;
IMPORT ULONG ObjectTableSize;
//IMPORT ULONG ClassTableSize;

// PathNames: ---------------
IMPORT UBYTE LibraryPath[   LARGE_TOOLSPACE ];
IMPORT UBYTE CommandPath[   LARGE_TOOLSPACE ];
IMPORT UBYTE HelpPath[      LARGE_TOOLSPACE ];
IMPORT UBYTE GeneralPath[   LARGE_TOOLSPACE ];
IMPORT UBYTE IntuitionPath[ LARGE_TOOLSPACE ];
IMPORT UBYTE SystemPath[    LARGE_TOOLSPACE ];
IMPORT UBYTE UserClassPath[ LARGE_TOOLSPACE ];

// Command Names: -----------
IMPORT UBYTE FileDisplayer[ LARGE_TOOLSPACE ];
IMPORT UBYTE HelpProgram[   LARGE_TOOLSPACE ];
IMPORT UBYTE Editor[        LARGE_TOOLSPACE ];
IMPORT UBYTE ParserName[    LARGE_TOOLSPACE ];
IMPORT UBYTE LogoCmd[       LARGE_TOOLSPACE ];

// Misc Strings: ------------
IMPORT UBYTE InitializeScript[ LARGE_TOOLSPACE ];
IMPORT UBYTE UpdateScript[     LARGE_TOOLSPACE ];
IMPORT UBYTE ARexxPortName[    LARGE_TOOLSPACE ];
IMPORT UWORD DefaultTabSize;
IMPORT UWORD StatusHistoryLength;
IMPORT UBYTE LogoName[         LARGE_TOOLSPACE ];
IMPORT UBYTE ImageFile[        LARGE_TOOLSPACE ];
IMPORT UBYTE SymbolFile[       LARGE_TOOLSPACE ];

// GUI Variables: -----------
IMPORT UWORD ATStatWidth;
IMPORT UWORD ATStatHeight;

PUBLIC UBYTE  UseFontName[ BUFF_SIZE ] = { 0, };
PUBLIC int    UseFontSize              = 8;

#ifdef __SASC
PUBLIC ULONG  ATScreenModeID = 0x40D20001;
PUBLIC UWORD  ATWidth        = 640;
PUBLIC UWORD  ATHeight       = 260;
#else
PUBLIC ULONG  ATScreenModeID = 0x50031100;
PUBLIC UWORD  ATWidth        = 1024;
PUBLIC UWORD  ATHeight       = 478;
#endif

PUBLIC ULONG  CurrentScrModeID = 0;

// Palette Variables: -------
PUBLIC int    numberOfPens     = 45;
PUBLIC ULONG  colorPens[ 256 ] = { 0, };
PUBLIC UBYTE *penNames[  256 ] = { NULL, };
    
// ------------------------------------------------------------

PUBLIC UBYTE *PubScreenName = AT_PUBSCREENNAME; 
PUBLIC UWORD  ATLeft        = 0;
PUBLIC UWORD  ATTop         = 16;

// ------------------------ Various Catalog setup functions: --

IMPORT int CatalogUserScript( void ); // In UserScriptReq.c
IMPORT int CatalogADOS1(      void ); // In ADOS1.c
IMPORT int CatalogATGadgets(  void ); // In ATGadgets.c
IMPORT int CatalogATHelper(   void ); // In ATHelper.c
IMPORT int CatalogATMenus(    void ); // In ATMenus.c
IMPORT int CatalogCDROM(      void ); // In CDROM.c
IMPORT int CatalogClipboard(  void ); // In Clipboard.c
IMPORT int CatalogConsole(    void ); // In Console.c
IMPORT int CatalogDisk2(      void ); // In Disk2.c
IMPORT int CatalogGlobal(     void ); // In Global.c
IMPORT int CatalogIcon(       void ); // In Icon.c
IMPORT int CatalogIconDsp(    void ); // In IconDsp.c
IMPORT int CatalogIFF(        void ); // In IFF.c
IMPORT int CatalogIO(         void ); // In IO.c
IMPORT int CatalogInterp(     void ); // In Interp.c
IMPORT int CatalogMenu(       void ); // In Menu.c
IMPORT int CatalogMsgPort(    void ); // In MsgPort.c
IMPORT int CatalogNarrator(   void ); // In Narrator.c
IMPORT int CatalogParallel(   void ); // In Parallel.c
IMPORT int CatalogPrinter(    void ); // In Printer.c
IMPORT int CatalogErrStrings( void ); // In ReportErrs.
IMPORT int CatalogRexx(       void ); // In Rexx.c
IMPORT int CatalogScreen(     void ); // In Screen.c
IMPORT int CatalogSystem(     void ); // In System.c
IMPORT int CatalogTools(      void ); // In Tools.c
IMPORT int CatalogTracer(     void ); // In Tracer.c
IMPORT int CatalogTracer2(    void ); // In Tracer2.c

// ------------------------------------------------------------

PRIVATE aiPTR ai = NULL;

PRIVATE struct TextAttr *ScrFontTA = NULL; // Remember Prefs Scr->Font.

PRIVATE BOOL SysBaseOpened     = FALSE;
PRIVATE BOOL UtilityBaseOpened = FALSE;

PRIVATE UBYTE ATWdt[80] = { 0, };

PUBLIC struct TextAttr helvetica13 = { "helvetica.font", 13, 0x00, 0x62 };

/* Now Found in AmigaDOSErrs.h
#ifdef DEBUG
# define DBG(x) x
#else
# define DBG(x)
#endif
*/

/* ------------------------ Functions: ------------------------- */

PRIVATE void SetupPenNames( void )
{
   penNames[ 0] = SetupCMsg( MSG_ATEGRP_ITEM_PEN00_SETUP );
   penNames[ 1] = SetupCMsg( MSG_ATEGRP_ITEM_PEN01_SETUP );
   penNames[ 2] = SetupCMsg( MSG_ATEGRP_ITEM_PEN02_SETUP ); 
   penNames[ 3] = SetupCMsg( MSG_ATEGRP_ITEM_PEN03_SETUP );
   penNames[ 4] = SetupCMsg( MSG_ATEGRP_ITEM_PEN04_SETUP );
   penNames[ 5] = SetupCMsg( MSG_ATEGRP_ITEM_PEN05_SETUP );
   penNames[ 6] = SetupCMsg( MSG_ATEGRP_ITEM_PEN06_SETUP );
   penNames[ 7] = SetupCMsg( MSG_ATEGRP_ITEM_PEN07_SETUP );
   penNames[ 8] = SetupCMsg( MSG_ATEGRP_ITEM_PEN08_SETUP ); 
   penNames[ 9] = SetupCMsg( MSG_ATEGRP_ITEM_PEN09_SETUP ); 
   penNames[10] = SetupCMsg( MSG_ATEGRP_ITEM_PEN0A_SETUP ); 
   penNames[11] = SetupCMsg( MSG_ATEGRP_ITEM_PEN0B_SETUP ); 
   penNames[12] = SetupCMsg( MSG_ATEGRP_ITEM_PEN0C_SETUP ); 
   penNames[13] = SetupCMsg( MSG_ATEGRP_ITEM_PEN0D_SETUP ); 
   penNames[14] = SetupCMsg( MSG_ATEGRP_ITEM_PEN0E_SETUP ); 
   penNames[15] = SetupCMsg( MSG_ATEGRP_ITEM_PEN0F_SETUP ); 
   penNames[16] = SetupCMsg( MSG_ATEGRP_ITEM_PEN10_SETUP ); 
   penNames[17] = SetupCMsg( MSG_ATEGRP_ITEM_PEN11_SETUP ); 
   penNames[18] = SetupCMsg( MSG_ATEGRP_ITEM_PEN12_SETUP ); 
   penNames[19] = SetupCMsg( MSG_ATEGRP_ITEM_PEN13_SETUP ); 
   penNames[20] = SetupCMsg( MSG_ATEGRP_ITEM_PEN14_SETUP ); 
   penNames[21] = SetupCMsg( MSG_ATEGRP_ITEM_PEN15_SETUP ); 
   penNames[22] = SetupCMsg( MSG_ATEGRP_ITEM_PEN16_SETUP ); 
   penNames[23] = SetupCMsg( MSG_ATEGRP_ITEM_PEN17_SETUP ); 
   penNames[24] = SetupCMsg( MSG_ATEGRP_ITEM_PEN18_SETUP ); 
   penNames[25] = SetupCMsg( MSG_ATEGRP_ITEM_PEN19_SETUP ); 
   penNames[26] = SetupCMsg( MSG_ATEGRP_ITEM_PEN1A_SETUP ); 
   penNames[27] = SetupCMsg( MSG_ATEGRP_ITEM_PEN1B_SETUP ); 
   penNames[28] = SetupCMsg( MSG_ATEGRP_ITEM_PEN1C_SETUP ); 
   penNames[29] = SetupCMsg( MSG_ATEGRP_ITEM_PEN1D_SETUP ); 
   penNames[30] = SetupCMsg( MSG_ATEGRP_ITEM_PEN1E_SETUP ); 
   penNames[31] = SetupCMsg( MSG_ATEGRP_ITEM_PEN1F_SETUP ); 
   penNames[32] = SetupCMsg( MSG_ATEGRP_ITEM_PEN20_SETUP ); 
   penNames[33] = SetupCMsg( MSG_ATEGRP_ITEM_PEN21_SETUP ); 
   penNames[34] = SetupCMsg( MSG_ATEGRP_ITEM_PEN22_SETUP ); 
   penNames[35] = SetupCMsg( MSG_ATEGRP_ITEM_PEN23_SETUP ); 
   penNames[36] = SetupCMsg( MSG_ATEGRP_ITEM_PEN24_SETUP ); 
   penNames[37] = SetupCMsg( MSG_ATEGRP_ITEM_PEN25_SETUP ); 
   penNames[38] = SetupCMsg( MSG_ATEGRP_ITEM_PEN26_SETUP ); 
   penNames[39] = SetupCMsg( MSG_ATEGRP_ITEM_PEN27_SETUP ); 
   penNames[40] = SetupCMsg( MSG_ATEGRP_ITEM_PEN28_SETUP ); 
   penNames[41] = SetupCMsg( MSG_ATEGRP_ITEM_PEN29_SETUP ); 
   penNames[42] = SetupCMsg( MSG_ATEGRP_ITEM_PEN2A_SETUP ); 
   penNames[43] = SetupCMsg( MSG_ATEGRP_ITEM_PEN2B_SETUP ); 
   penNames[44] = SetupCMsg( MSG_ATEGRP_ITEM_PEN2C_SETUP ); 
    
   return;
}

/****h* freeVecMemorySpaces() [3.0] **********************************
*
* NAME
*    freeVecMemorySpaces()
*
* DESCRIPTION
*    FreeVec all Objects that have been allocated from the heap.
**********************************************************************
*
*/

PUBLIC void freeVecMemorySpaces( void )
{
   freeVecAllFiles();
//   DBG( fprintf( stderr, "Freed Files!\n" ) );

   freeVecAllAddresses();
//   DBG( fprintf( stderr, "Freed Addresses!\n" ) );
   
   freeVecAllIntegers();
//   DBG( fprintf( stderr, "Freed Integers!\n" ) );

   freeVecAllFloats();
//   DBG( fprintf( stderr, "Freed Floats!\n" ) );

   freeVecAllBlocks();
//   DBG( fprintf( stderr, "Freed Blocks!\n" ) );

   freeVecAllByteArrays();
//   DBG( fprintf( stderr, "Freed ByteArrays!\n" ) );

   freeVecAllStrings();
//   DBG( fprintf( stderr, "Freed Strings!\n" ) );

   freeVecAllProcesses();
//   DBG( fprintf( stderr, "Freed Processes!\n" ) );

   freeVecAllInterpreters();
//   DBG( fprintf( stderr, "Freed Interpreters!\n" ) );

   freeVecAllClassEntries();
//   DBG( fprintf( stderr, "Freed ClassEntries!\n" ) );

   freeVecAllClasses();
//   DBG( fprintf( stderr, "Freed Classes!\n" ) );

   freeVecAllObjects();
//   DBG( fprintf( stderr, "Freed Objects\n" ) );

   freeVecVariables(); // Located in Drive.c
//   DBG( fprintf( stderr, "Freed Variables\n" ) );
   
   return;
}

/****h* freeSlackMemorySpace() [3.0] *********************************
*
* NAME
*    freeSlackMemorySpace()
*
* DESCRIPTION
*    FreeVec all Objects that are NOT marked MMF_INUSE_MASK.  This is
*    necessary if the User's system does not have a lot of memory or
*    we've used up a lot of memory & the system's memory pool is 
*    about dry.
**********************************************************************
*
*/

PUBLIC int freeSlackMemorySpaces( void )
{
   int freedBytesCount = 0;

   freedBytesCount  = freeSlackBlockMemory() * BLOCK_SIZE;
   freedBytesCount += freeSlackClassMemory() * CLASS_SIZE;
   freedBytesCount += freeSlackClassEntryMemory() * CLASS_ENTRY_SIZE;
   freedBytesCount += freeSlackByteArrayMemory();
   freedBytesCount += freeSlackInterpreterMemory() * INTERPRETER_SIZE;
   freedBytesCount += freeSlackFloatMemory() * FLOAT_SIZE;
   freedBytesCount += freeSlackProcessMemory() * PROCESS_SIZE;
   freedBytesCount += freeSlackStringMemory() * STRING_SIZE;
   freedBytesCount += freeSlackObjectMemory();

   DBG( fprintf( stderr, "freed slack space: 0x%08LX\n", freedBytesCount ) );
   
   return( freedBytesCount );
}

/****i* CloseATLibs() [2.0] ******************************************
*
* NAME
*    CloseATLibs()
*
* DESCRIPTION
*
**********************************************************************
*
*/

PRIVATE void CloseATLibs( void )
{
   // Added for V2.0:
   if (HaveCyberLibrary == TRUE)
      {
#     ifdef __amigaos4__
      DropInterface( ( struct Interface *) ICyberGfx );
#     endif

      CloseLibrary( CyberGfxBase );

      CyberGfxBase     = NULL;
      HaveCyberLibrary = FALSE;
      }
   
   if (SysBaseOpened == TRUE)
      {
#     ifdef __amigaos4__
      DropInterface( ( struct Interface *) IExec );
#     endif

      CloseLibrary( (struct Library *) SysBase );
      
      SysBaseOpened = FALSE;
      }

   if (UtilityBaseOpened == TRUE)
      {
#     ifdef __amigaos4__
      if (IUtility)
         DropInterface( ( struct Interface *) IUtility );
#     endif
      
      if (UtilityBase)
         CloseLibrary( UtilityBase );
      
      UtilityBaseOpened = FALSE;
      }

   if (GadToolsBase) // != NULL)
      {
#     ifdef __amigaos4__
      DropInterface( ( struct Interface *) IGadTools );
#     endif

      CloseLibrary( GadToolsBase );
      GadToolsBase = NULL;
      }

   OpenWorkBench();    // just in case.

   return;
}

PRIVATE void CloseDownScreen( void )
{
   if (VisualInfo) // != NULL) 
      {
      FreeVisualInfo( VisualInfo );
      VisualInfo = NULL;
      }

   if (Scr) // != NULL) 
      {
      CloseScreen( Scr );
      Scr = NULL;
      }

   return;
}

SUBFUNC void writeEnvMemorySpaces( FILE *fp )
{
   fprintf( fp, "%s\n", SetupCMsg( MSG_ATEGRP_MEMORY_SETUP ) );
   
   fprintf( fp, "%s = %d\n", SetupCMsg( MSG_ATEGRP_ITEM_OBJECT_SIZE_SETUP ), 
                             ObjectTableSize 
	  );

   fprintf( fp, "%s = %d\n", SetupCMsg( MSG_ATEGRP_ITEM_BYTEARRAY_SIZE_SETUP ),
                             ByteArrayTableSize
	  );

   fprintf( fp, "%s = %d\n", SetupCMsg( MSG_ATEGRP_ITEM_INTEGER_SIZE_SETUP ), 
                             IntegerTableSize 
	  );

   fprintf( fp, "%s = %d\n", SetupCMsg( MSG_ATEGRP_ITEM_INTERP_SIZE_SETUP ), 
                             InterpreterTableSize 
	  );

   fprintf( fp, "%s = %d\n", SetupCMsg( MSG_ATEGRP_ITEM_SYMBOL_SIZE_SETUP ), 
                             SymbolTableSize 
	  );

   return;
}

SUBFUNC void writeEnvPathNames( FILE *fp )
{
   fprintf( fp, "%s\n", SetupCMsg( MSG_ATEGRP_PATHS_SETUP ) );

   fprintf( fp, "%s = %s\n", SetupCMsg( MSG_ATEGRP_ITEM_LIBRARY_PATH_SETUP ), 
                             &LibraryPath[0] 
	  );

   fprintf( fp, "%s = %s\n", SetupCMsg( MSG_ATEGRP_ITEM_COMMAND_PATH_SETUP ),
                             &CommandPath[0]
	  );

   fprintf( fp, "%s = %s\n", SetupCMsg( MSG_ATEGRP_ITEM_HELP_PATH_SETUP ),
                             &HelpPath[0]
          );

   fprintf( fp, "%s = %s\n", SetupCMsg( MSG_ATEGRP_ITEM_GENERAL_PATH_SETUP ),
                             &GeneralPath[0]
	  );

   fprintf( fp, "%s = %s\n", SetupCMsg( MSG_ATEGRP_ITEM_INTUITION_PATH_SETUP ),
                             &IntuitionPath[0]
          );

   fprintf( fp, "%s = %s\n", SetupCMsg( MSG_ATEGRP_ITEM_SYSTEM_PATH_SETUP ),
                             &SystemPath[0]
          );
	  
   fprintf( fp, "%s = %s\n", SetupCMsg( MSG_ATEGRP_ITEM_USER_PATH_SETUP ),
                             &UserClassPath[0]
          );

   return;
}

SUBFUNC void writeEnvCommandNames( FILE *fp )
{
   fprintf( fp, "%s\n", SetupCMsg( MSG_ATEGRP_SUPPORT_SETUP ) );

   fprintf( fp, "%s = %s\n", SetupCMsg( MSG_ATEGRP_ITEM_FILE_DISPLAYER_SETUP ),
                             &FileDisplayer[0]
          );

   fprintf( fp, "%s = %s\n", SetupCMsg( MSG_ATEGRP_ITEM_HELP_PROGRAM_SETUP ),
                             &HelpProgram[0]
          );

   fprintf( fp, "%s = %s\n", SetupCMsg( MSG_ATEGRP_ITEM_EDITOR_SETUP ),
                             &Editor[0]
          );

   fprintf( fp, "%s = %s\n", SetupCMsg( MSG_ATEGRP_ITEM_PARSER_NAME_SETUP ),
                             &ParserName[0]
          );

   fprintf( fp, "%s = %s\n", SetupCMsg( MSG_ATEGRP_ITEM_LOGO_COMMAND_SETUP ),
                             &LogoCmd[0]
          );
	  
   return;
}

SUBFUNC void writeEnvMiscStrings( FILE *fp )
{
   fprintf( fp, "%s\n", SetupCMsg( MSG_ATEGRP_MISC_SETUP ) );

   fprintf( fp, "%s = %s\n", SetupCMsg( MSG_ATEGRP_ITEM_INIT_SCRIPT_SETUP ),
                             &InitializeScript[0]
          );

   fprintf( fp, "%s = %s\n", SetupCMsg( MSG_ATEGRP_ITEM_UPDATE_SCRIPT_SETUP ),
                             &UpdateScript[0]
          );

   fprintf( fp, "%s = %s\n", SetupCMsg( MSG_ATEGRP_ITEM_AREXX_PORTNAME_SETUP ),
                             &ARexxPortName[0]
          );

   fprintf( fp, "%s = %d\n", SetupCMsg( MSG_ATEGRP_ITEM_TAB_SIZE_SETUP ),
                             DefaultTabSize
          );

   fprintf( fp, "%s = %d\n", SetupCMsg( MSG_ATEGRP_ITEM_STATUS_HLENGTH_SETUP ),
                             StatusHistoryLength
          );

   fprintf( fp, "%s = %s\n", SetupCMsg( MSG_ATEGRP_ITEM_LOGO_NAME_SETUP ),
                             &LogoName[0]
          );

   fprintf( fp, "%s = %s\n", SetupCMsg( MSG_ATEGRP_ITEM_IMAGE_FILE_SETUP ),
                             &ImageFile[0]
          );

   fprintf( fp, "%s = %s\n", SetupCMsg( MSG_ATEGRP_ITEM_SYMBOL_FILE_SETUP ),
                             &SymbolFile[0]
          );

   return;
}

SUBFUNC void writeEnvGUINumbers( FILE *fp )
{
   ULONG modeID = INVALID_ID;

   fprintf( fp, "%s\n", SetupCMsg( MSG_ATEGRP_GUI_SETUP ) );

   if ((modeID = GetVPModeID( &(Scr->ViewPort) )) == INVALID_ID)
      modeID = ATScreenModeID; // 0x40D20001;

   if (modeID == 0 && CurrentScrModeID != 0)
      modeID = CurrentScrModeID;

   if (modeID)
      fprintf( fp, "%s = 0x%08LX\n", SetupCMsg( MSG_ATEGRP_ITEM_SCREENMODEID_SETUP ),
                                     modeID
	     );
   else
      fprintf( fp, "%s = 0x%08LX\n", SetupCMsg( MSG_ATEGRP_ITEM_SCREENMODEID_SETUP ),
                                     ATScreenModeID
	     );
   
   if (Font)
      {
      fprintf( fp, "%s = %s\n", SetupCMsg( MSG_ATEGRP_ITEM_FONT_NAME_SETUP ), 
                                Font->ta_Name
             );

      fprintf( fp, "%s = %d\n", SetupCMsg( MSG_ATEGRP_ITEM_FONT_SIZE_SETUP ), 
                                Font->ta_YSize
             ); 
      }
   else
      {
      fprintf( fp, "%s = %s\n", SetupCMsg( MSG_ATEGRP_ITEM_FONT_NAME_SETUP ), 
                                "FONTS:topaz.font"
             );

      fprintf( fp, "%s = %d\n", SetupCMsg( MSG_ATEGRP_ITEM_FONT_SIZE_SETUP ), 
                                8
             ); 
      }

   if (ATWnd)
      {
      fprintf( fp, "%s = %d\n", SetupCMsg( MSG_ATEGRP_ITEM_GUI_WIDTH_SETUP ), 
                                ATWnd->Width - ATWnd->LeftEdge
	     );

      fprintf( fp, "%s = %d\n", SetupCMsg( MSG_ATEGRP_ITEM_GUI_HEIGHT_SETUP ), 
                                ATWnd->Height - ATWnd->TopEdge - 2
	     );
      }
   else
      {
      fprintf( fp, "%s = %d\n", SetupCMsg( MSG_ATEGRP_ITEM_GUI_WIDTH_SETUP ), 
                                ATWidth
	     );

      fprintf( fp, "%s = %d\n", SetupCMsg( MSG_ATEGRP_ITEM_GUI_HEIGHT_SETUP ), 
                                ATHeight
	     );
      }

   // Write out Status Window coordinates: 

   fprintf( fp, "%s = %d\n", SetupCMsg( MSG_ATEGRP_ITEM_STATUS_WIDTH_SETUP ), 
                             ATStatWidth 
	  );

   fprintf( fp, "%s = %d\n", SetupCMsg( MSG_ATEGRP_ITEM_STATUS_HEIGHT_SETUP ), 
                             ATStatHeight 
          );

   return;
}

/*
        struct ColorMap *cm = GetColorMap( UWORD numEntries );

        VOID GetRGB32( CONST struct ColorMap *cm, UWORD firstColor, UWORD numEntries, ULONG *RGBTable );

        colorTable[0] = (numEntries << 16) + firstColorNumber;

	colorTable[1] = red1;
	colorTable[2] = green1;
	colorTable[3] = blue1;
	...
	colorTable[last] = 0x00000000;
	
        VOID LoadRGB32( struct ViewPort *vp, CONST ULONG *colorTable );

        void SetRGB32( struct ViewPort *vp, ULONG n, ULONG red, ULONG green, ULONG blue );
        
	void SetRGB32CM( struct ColorMap *cm, UWORD n, ULONG r, ULONG g, ULONG b );
	
        VOID FreeColorMap( struct ColorMap *cm );
*/

SUBFUNC void writeEnvPalette( FILE *fp )
{
   struct DrawInfo    *dri = GetScreenDrawInfo( Scr );
   struct DisplayInfo  di;
   ULONG               modeid = GetVPModeID( (&(Scr->ViewPort)) );
   ULONG               red, green, blue, colorValue;
   ULONG               RGBTable[ 3 * 256 ];
   UBYTE               colorString[32] = { 0, };
   int                 i, colorReg;
   
   fprintf( fp, "%s\n", SetupCMsg( MSG_ATEGRP_PALETTE_SETUP ) );
         
   fprintf( fp, "%s = %d\n", SetupCMsg( MSG_ATEGRP_ITEM_NUM_PENS_SETUP ), 
                             dri->dri_NumPens
	  );

   (void) GetDisplayInfoData( NULL, (APTR) &di, sizeof( struct DisplayInfo ), DTAG_DISP, modeid );

   GetRGB32( (CONST struct ColorMap *) Scr->ViewPort.ColorMap, 0, dri->dri_NumPens, &RGBTable[0] );

   for (colorReg = 0, i = 0; colorReg < dri->dri_NumPens; colorReg++, i += 3)
      {
      if (di.RedBits <= 8)
         red = (RGBTable[ i ] & 0x000000FF) << 24;
      else if (di.RedBits <= 16)
         red = (RGBTable[ i ] & 0x0000FFFF) << 16;
      else if (di.RedBits <= 24)
         red = (RGBTable[ i ] & 0x00FFFFFF) << 8;
      else
         red = RGBTable[ i ] & 0xFFFFFFFF;

      if (di.GreenBits <= 8)
         green = (RGBTable[ i + 1 ] & 0x000000FF) << 24;
      else if (di.GreenBits <= 16)
         green = (RGBTable[ i + 1 ] & 0x0000FFFF) << 16;
      else if (di.GreenBits <= 24)
         green = (RGBTable[ i + 1 ] & 0x00FFFFFF) << 8;
      else
         green = RGBTable[ i + 1 ] & 0xFFFFFFFF;

      if (di.BlueBits <= 8)
         blue = (RGBTable[ i + 2 ] & 0x000000FF) << 24;
      else if (di.BlueBits <= 16)
         blue = (RGBTable[ i + 2 ] & 0x0000FFFF) << 16;
      else if (di.BlueBits <= 24)
         blue = (RGBTable[ i + 2 ] & 0x00FFFFFF) << 8;
      else
         blue = RGBTable[ i + 2 ] & 0xFFFFFFFF;

      colorValue = (red + (green >> 8) + (blue >> 16)) & 0xFFFFFF00;

      // See if this fixes the fprintf() problem:
      (void) longToHexStr( &colorString[0], colorValue );
      (void) fputs( penNames[colorReg], fp );
      (void) fputs( " = 0x",            fp );
      (void) fputs( &colorString[0],    fp );
      (void) fputc( '\n',               fp );
      
      colorString[0] = '\0';
       
      //fprintf( fp, "%32.32s = 0x%08LX\n", penNames[colorReg], colorValue );
      }

   if (dri)
      FreeScreenDrawInfo( Scr, dri );
      
   return;
}

PRIVATE BOOL openedEnvCatalog = FALSE;

/* EnvUpdated is a guard that prevents the program from executing
** UpdateEnvSettings() after the ATWnd has been closed.
*/

PRIVATE BOOL EnvUpdated = FALSE;


PRIVATE void UpdateEnvSettings( void )
{
   FILE *envfile = NULL;

   if (EnvUpdated == TRUE) // Check the Guard.
      return;

   if (LocaleBase && !ATECatalog)
      {
      if (ATECatalog = OpenCatalog( NULL, "atalkenviron.catalog",
                                          OC_BuiltInLanguage, "english", 
                                          TAG_DONE 
                                  ))
         {
	      openedEnvCatalog = TRUE;
 	      }
      else
         openedEnvCatalog = FALSE;
      }           
   
   if ((envfile = fopen( &EnvironFile[0], FILE_WRITE_STR ))) // != NULL)
      {
      writeEnvMemorySpaces( envfile );
      writeEnvPathNames(    envfile );
      writeEnvCommandNames( envfile );
      writeEnvMiscStrings(  envfile );
      writeEnvGUINumbers(   envfile );
      writeEnvPalette(      envfile );

      fclose( envfile );
      }

   if (openedEnvCatalog == TRUE)
       CloseCatalog( ATECatalog );
       
   EnvUpdated = TRUE; // Set the Guard.

   return;      
}

PUBLIC void CloseATWindow( void )
{
   if (EnvUpdated == FALSE)
      UpdateEnvSettings(); // Ensure that the window has NOT been closed!

   if (ATMenus) // != NULL) 
      {
      ClearMenuStrip( ATWnd );
      FreeMenus( ATMenus );
      ATMenus = NULL;   
      }

   if (ATWnd) // != NULL) 
      {
      CloseWindow( ATWnd );
      ATWnd      = NULL;
      EnvUpdated = TRUE;  // Just in case.
      }

   if (ATGList) // != NULL) 
      {
      FreeGadgets( ATGList );
      ATGList = NULL;
      }

   if (ATFont) // != NULL) 
      {
      CloseFont( ATFont );
      ATFont = NULL;
      }

   return;
}

/****i* calculateMemorySize() [3.0] ********************************
*
* NAME
*    calculateMemorySize()
*
* DESCRIPTION
*    Figure out how much memory the User used during this invocation
*    of AmigaTalk.  The value will be used to check against System
*    memory before AmigaTalk starts the next time.  These values 
*    will be placed in ToolTypes in the Icon.
********************************************************************
*
*/

SUBFUNC ULONG calculateMemorySize( void )
{
   IMPORT int ca_obj, ca_class, ca_terp, ca_bsize;
   IMPORT int ca_block, ca_int, ca_float, ca_objTotal;
   IMPORT int ca_str, ca_sym, ca_wal, ca_cdict;
   IMPORT int ca_barray, ca_symSpace, ca_walSize;
   
   // ----------------------------------------------
   
   ULONG rval = 0L;

   // ClassTableSize = ca_class * CLASS_SIZE + ca_cdict * CLASS_ENTRY_SIZE;
   
   ByteArrayTableSize   = ca_barray * BYTEARRAY_SIZE + ca_bsize;
   InterpreterTableSize = ca_terp   * INTERPRETER_SIZE;
   IntegerTableSize     = ca_int    * INTEGER_SIZE;
   SymbolTableSize      = ca_sym    * SYMBOL_SIZE;
   ObjectTableSize      = ca_objTotal;

   rval  = ca_block * BLOCK_SIZE   + ByteArrayTableSize;
   rval += ca_class * CLASS_SIZE   + InterpreterTableSize;
   rval += ca_float * FLOAT_SIZE   + IntegerTableSize;
   rval += ca_str   * STRING_SIZE  + SymbolTableSize;
   rval += ca_walSize              + ca_cdict  * CLASS_ENTRY_SIZE;
   rval += ca_symSpace + 1024 + ObjectTableSize;

   // Now set the minimum requirements here:
      
   ByteArrayTableSize   = ByteArrayTableSize   < MIN_BYTTABLE_SIZE ? MIN_BYTTABLE_SIZE : ByteArrayTableSize;
   InterpreterTableSize = InterpreterTableSize < MIN_ITPTABLE_SIZE ? MIN_ITPTABLE_SIZE : InterpreterTableSize;
   IntegerTableSize     = IntegerTableSize     < MIN_INTTABLE_SIZE ? MIN_INTTABLE_SIZE : IntegerTableSize;
   SymbolTableSize      = SymbolTableSize      < MIN_SYMTABLE_SIZE ? MIN_SYMTABLE_SIZE : SymbolTableSize;
   ObjectTableSize      = ObjectTableSize      < MIN_OBJTABLE_SIZE ? MIN_OBJTABLE_SIZE : ObjectTableSize;
//   ClassTableSize       = ClassTableSize       < MIN_CLSTABLE_SIZE ? MIN_CLSTABLE_SIZE : ClassTableSize;

   return( rval );
}

PUBLIC void ShutDown( void )
{
   IMPORT void UpdateIconToolTypes( void );
   IMPORT void KillLogo( struct MsgPort * );
   IMPORT int  hailLogo;

   ULONG memUsed = 0L;

   if (hailLogo != 0)
      KillLogo( NULL ); // Perhaps we'll delete the function arg later.  

   CloseStatusWindow();
   
   CloseATWindow();

   CloseDownScreen();

   if (silence == FALSE)
      fprintf( stderr, SetupCMsg( MSG_FMT_INCS_DECS_SETUP ), 
                        n_incs, n_decs, n_incs - n_decs, n_mallocs 
	          );

   if (prallocs != FALSE) 
      {
      spitOutAllocationData(); // Located in Main.c
      }

   // Reset the ObjectTableSize ToolType here:
   memUsed = calculateMemorySize();

   DBG( fprintf( stderr, "Freeing memory (%d) AmigaTalk used...\n", memUsed ) );
      
   freeVecMemorySpaces(); // Remove AmigaTalk allocations.
   
   UpdateIconToolTypes(); // In Tools.c

   if (catalog) // != NULL)
      CloseCatalog( catalog );

   CloseATLibs();

   if (PgmItemBuffer) // != NULL)
      {
      FreeVec( PgmItemBuffer );
      PgmItemBuffer = NULL;
      }

   return;
}

PRIVATE int OpenATLibs( void )
{
#  ifdef __SASC
   if (!(LocaleBase = (struct LocaleBase *) OpenLibrary( "locale.library", 38L ))) // == NULL)
      return( -1 );
      
   if (!(DOSBase = (struct DosLibrary *) OpenLibrary( DOSNAME, 0 ))) // == NULL)
      {
      CloseLibrary( (struct Library *) LocaleBase );

      return( -1 );
      }

   if (!(IconBase = OpenLibrary( "icon.library", 44L ))) // == NULL)
      {
      CloseLibrary( (struct Library *) LocaleBase );
      CloseLibrary( (struct Library *) DOSBase );

      return( -2 );
      }

   if (!SysBase) // == NULL)
      {
      if (!(SysBase = (struct ExecBase *) OpenLibrary( "exec.library", 39L ))) // == NULL)
         {
         CloseATLibs();
         
         return( -6 );
         }
      
      SysBaseOpened = TRUE;
      }
      
   if (!(GfxBase = (struct GfxBase *) OpenLibrary( "graphics.library", 39L ))) // == NULL)
      {
      CloseATLibs();

      return( -3 );
      }

   if (!(IntuitionBase = (struct IntuitionBase *) OpenLibrary( "intuition.library", 39L ))) // == NULL)
      {
      CloseATLibs();

      return( -4 );
      }

   if (!(GadToolsBase = OpenLibrary( "gadtools.library", 39L ))) // == NULL)
      {
      CloseATLibs();

      return( -5 );
      }

   // Added for V2.0:
   if (!(CyberGfxBase = OpenLibrary( CYBERGFXNAME, CYBERGFX_INCLUDE_VERSION ))) // == NULL)
      HaveCyberLibrary = FALSE;
   else
      HaveCyberLibrary = TRUE;

#  else // __amigaos4__ is DEFINED:

   if (!UtilityBase)
      {
      if ((UtilityBase = OpenLibrary( "utility.library", 50L ))) // != NULL)
         {
         if (!(IUtility = (struct UtilityIFace *) GetInterface( UtilityBase, "main", 1, NULL )))
            {
            CloseATLibs();
         
            return( -5 );
            }
         else
            UtilityBaseOpened = TRUE;
         }
      else
         {
         CloseATLibs();

         return( -5 );
         }
      }

   if ((GadToolsBase = OpenLibrary( "gadtools.library", 50L ))) // != NULL)
      {
      if (!(IGadTools = (struct GadToolsIFace *) GetInterface( GadToolsBase, "main", 1, NULL )))
         {
         CloseATLibs();
         
         return( -5 );
         }
      }
   else
      {
      CloseATLibs();

      return( -5 );
      }

   if ((CyberGfxBase = OpenLibrary( CYBERGFXNAME, CYBERGFX_INCLUDE_VERSION ))) // != NULL)
      {
      if (!(ICyberGfx = (struct CyberGfxIFace *) GetInterface( CyberGfxBase, "main", 1, NULL )))
         {
         CloseLibrary( CyberGfxBase );
         HaveCyberLibrary = FALSE;
         }
      else   
         HaveCyberLibrary = TRUE;
      }
   else
      HaveCyberLibrary = FALSE;
#  endif

   return( 0 );
}

SUBFUNC struct TextAttr *TryToGetUserFont( void )
{
   struct TextAttr *fptr = NULL;

   BreakPointDBG( "TryToGetUserFont():", "Calling getUserFont()..." );
   
   if (!(fptr = getUserFont( FontTags, Scr,          // In commonfuncsPPC.o
                             SetupCMsg( MSG_GL_SELECT_FONT_SETUP ) 
                           ))) // == NULL)
      {
      // Set Font to ScrFontTA (Prefs Default Screen Font):
      CopyMem( ScrFontTA, Font, sizeof( struct TextAttr ) );

      // Our last resort:

      if (!(ATFont = OpenDiskFont( Font ))) // == NULL)
         return( NULL ); // Abort, Die, Kill!!
      }
   else
      {
      if (!(ATFont = OpenDiskFont( fptr ))) // == NULL)
         return( NULL ); // Abort, Die, Kill!!
      }

   StringNCopy( &UseFontName[0], fptr->ta_Name, LARGE_TOOLSPACE );

   UseFontSize = fptr->ta_YSize;
   
   return( fptr );
}

SUBFUNC struct TextAttr *SetupATalkFont( void )
{
   struct TextAttr *rval;
   
   rval = &Attr;
   
   if (!UseFontName) // Short circuit any strlen() problems...
      {
      DBG( fprintf( stderr, "UseFontName was NULL! going to TryToGetUserFont()...\n" ) );

      return( TryToGetUserFont() );
      }

   rval->ta_Name  = (STRPTR) &UseFontName[0];
   rval->ta_YSize = UseFontSize;

   if (!(ATFont = OpenDiskFont( rval ))) // == NULL)
      {
      // Environmental variables were junk, so...
      BreakPointDBG( "SetupATalkFont():", "Could NOT OpenDiskFont( '%s', %ld )", UseFontName, UseFontSize );

      return( TryToGetUserFont() );
      }
      
   rval->ta_Style = ATFont->tf_Style;
   rval->ta_Flags = ATFont->tf_Flags;

   // This was a hard bug to find!      
   // Reset again since fontName[] is Temporary stack space:
   rval->ta_Name  = ATFont->tf_Message.mn_Node.ln_Name;
   
   return( rval );
}

/****i* ComputeATalkFont() [2.1] *************************************
*
* NAME
*    ComputeATalkFont()
*
* DESCRIPTION
*    Almost the same as ComputeFont() in CommonFuncs.o, except that
*    this function DOES NOT write into the Font argument.
**********************************************************************
*
*/

SUBFUNC void ComputeATalkFont( struct Screen   *Scr, 
                               struct TextAttr *Font,
                               struct CompFont *cf
                             )
{
   cf->FontY = Font->ta_YSize; 
   cf->FontX = FontXDim( Font ); // How long is one character?

   // Ensure that Coordinates are inside the Window's Borders:
   cf->OffX  = Scr->WBorLeft;
   cf->OffY  = Scr->RastPort.TxHeight + Scr->WBorTop + 1;

   return;
}
/*
PUBLIC UWORD computeX( UWORD fontxsize, UWORD value )
{
   return( (UWORD) (((fontxsize * value) + (fontxsize / 2)) / fontxsize) );
}

PUBLIC UWORD computeY( UWORD fontysize, UWORD value )
{
   return( (UWORD) (((fontysize * value) + (fontysize / 2)) / fontysize) );
}
*/
// Helper for SetupScreen():

SUBFUNC int OpenMyScreen( int w, int h, int d, ULONG scrID )
{
   if (!(Scr = OpenScreenTags( NULL, 
        
                 SA_PubName,     PubScreenName,
                 SA_Left,        0,
                 SA_Top,         0,
                 SA_Width,       w,
                 SA_Height,      h,
                 SA_Depth,       d,
                 SA_Font,        ScrFontTA,    // ta,
                 SA_Type,        PUBLICSCREEN, // CUSTOMSCREEN,

                 // Hopefully this will override the Depth setting:
                 SA_DisplayID,     scrID,

                 SA_AutoScroll,    TRUE,
                 SA_LikeWorkbench, TRUE,
                 SA_SharePens,     TRUE,
                 SA_FullPalette,   TRUE,
                 SA_Title,         scrtitle,
                 TAG_DONE 
                 )
      )) // == NULL)
      return( -1 );
   else
      return( 0 );
}

/****i* SetupScreen() [2.1] ******************************************
*
* NAME
*    SetupScreen()
*
* DESCRIPTION
*    Open a Custom AmigaTalk Screen in a hopefully flexible way.
**********************************************************************
*
*/

PRIVATE int SetupScreen( void )
{
   struct DrawInfo *di    = NULL;
   struct TextAttr *ta    = NULL;
   struct Screen   *wbscr = LockPubScreen( "Workbench" );
   UWORD            w, h, d, i;
   BOOL             needunlock = FALSE;
   int              rval       = RETURN_OK;

//   DBG( fprintf( stderr, "wbscr = 0x%08LX = LockPubScreen() \n", wbscr ) );

   if (!wbscr) // == NULL)
      {
      wbscr = GetActiveScreen(); // There HAS TO BE at least an Active Screen!
//      DBG( fprintf( stderr, "wbscr = 0x%08LX = GetActiveScreen() \n", wbscr ) );
      }
   else
      needunlock = TRUE;
      
   ta = ScrFontTA = wbscr->Font; // Temporary storage.

//   DBG( fprintf( stderr, "Calling SetupATalkFont()...\n" ) );

   if (!(Font = SetupATalkFont())) // == NULL) // Override system font with UseFontName Env Var.
      Font = ta;                               // Didn't happen, use the System default font.
   else
      ScrFontTA = Font;                   // Remember our Screen Font setting.

   di = GetScreenDrawInfo( wbscr );
//   DBG( fprintf( stderr, "GetScreenDrawInfo() returned 0x%08LX\n", di ) );

   if (di->dri_Version >= DRI_VERSION)
	   {
      d = (di->dri_Depth < 1) ? 1 : di->dri_Depth;
	   }
   else
	   {
      d = 8;
	   }

   w = di->dri_Screen->Width  > ATScrWidth  ? di->dri_Screen->Width  : ATScrWidth;
   h = di->dri_Screen->Height > ATScrHeight ? di->dri_Screen->Height : ATScrHeight;

   BreakPointDBG( "SetupScreen()", "Calling OpenMyScreen( %ld, %ld, %ld, %p )", w, h, d, ATScreenModeID );
   
   if (OpenMyScreen( w, h, d, ATScreenModeID ) < 0)
      {
      // Try the default ScreenModeID:

      if (OpenMyScreen( w, h, d, DEFAULT_MONITOR_ID ) < 0)
         {
         // Failed again, bail out!!

         rval = -1;

         goto WrapUp; // Let's not get pedantic, it eliminates some identical code.
         }

      rval = -1; 
      
      goto WrapUp;
      }      

/* A better way to set the colors of the screen has to be found.
   for (i = 0; i < numberOfPens; i++)
      {
      ULONG r, g, b;
      // Probably wrong, correct later:      
      r = (colorPens[i] & 0xFF000000);
      g = (colorPens[i] & 0x00FF0000) << 8;
      b = (colorPens[i] & 0x0000FF00) << 16;

      SetRGB32( &Scr->ViewPort, i, r, g, b );
      }
*/
   // Setup CFont struct:
   ComputeATalkFont( Scr, ScrFontTA, &CFont ); // Might NOT be necessary.

   // Set VisualInfo variable:
   if (!(VisualInfo = GetVisualInfo( Scr, TAG_DONE ))) // == NULL)
      {
      /* User might have selected an invalid ScreenModeID to get here.
      ** VisualInfo is needed later for computing NewGadgets &
      ** NewMenus in OpenATWindow(), so a NULL is catastrophic!
      */
      rval = -2;
      
      goto WrapUp;
      }

//   ATWidth = Scr->Width;
   
   SetTagItem( &LoadTags[0],   ASLFR_Screen, (ULONG) Scr );
   SetTagItem( &SaveTags[0],   ASLFR_Screen, (ULONG) Scr );
   SetTagItem( &FontTags[0],   ASLFO_Screen, (ULONG) Scr );
   SetTagItem( &ScreenTags[0], ASLSM_Screen, (ULONG) Scr );

WrapUp:

   if (di) // != NULL)
      FreeScreenDrawInfo( wbscr, di );

   if (needunlock == TRUE)
      UnlockPubScreen( NULL, wbscr );

   return( rval );
}

/****i* SetupATGadget() [2.2] ******************************************
*
* NAME
*    SetupATGadget()
*
* DESCRIPTION
*    Unrolled the setup gadgets loop that GadToolsBox generated in 
*    OpenATWindow() so that each gadget can be sized differently.
************************************************************************
*
*/

PRIVATE int tagcount = 0;

SUBFUNC struct Gadget *SetupATGadget( struct Gadget *g, int idx, int w, int h )
{
   IMPORT UWORD     ATGTypes[];
   IMPORT ULONG     ATGTags[];

   struct NewGadget ng = { 0, };

   CopyMem( (char *) &ATNGad[ idx ], (char *) &ng, 
            (long) sizeof( struct NewGadget )
          );

   ng.ng_VisualInfo = VisualInfo;
   ng.ng_TextAttr   = Font;

   ng.ng_LeftEdge   = CFont.OffX + ComputeX( CFont.FontX, 
                                             ng.ng_LeftEdge
                                           );

   ng.ng_TopEdge    = CFont.OffY + ComputeY( CFont.FontY,
                                             ng.ng_TopEdge
                                           );

   ng.ng_Width      = ComputeX( CFont.FontX, w );
   ng.ng_Height     = ComputeY( CFont.FontY, h );

   ATGadgets[ idx ] = g 
                    = CreateGadgetA( (ULONG) ATGTypes[ idx ], 
                                     g, 
                                     &ng, 
                                     (struct TagItem *) &ATGTags[ tagcount ] 
                                   );
   if (!g) // == NULL)
      {
      sprintf( ErrMsg, SetupCMsg( MSG_FMT_ATGADGETS_SETUP ), idx );

      CannotCreate( ErrMsg );

      return( NULL );
      }

   while (ATGTags[ tagcount ] != TAG_DONE)
      tagcount += 2;

   tagcount++; // Go past the TAG_DONE tag.

   return( g );
}

PRIVATE int OpenATWindow( void )
{
   struct Gadget *g;
   UWORD          wleft = ATLeft; // Normally zero!
   UWORD          wtop;
   
   wtop  = (Scr->BarHeight != ATTop) ? Scr->BarHeight + 1 : ATTop;
   ATTop = wtop;

   // Setup CFont struct for the Window size:
   ComputeATalkFont( Scr, Font, &CFont );

   // Ensure an integral number of characters fit in the window: 
   wndwidth  = ComputeX( CFont.FontX, ATWidth );
   wndheight = ComputeY( CFont.FontY, ATHeight );

   // Now, re-adjust the Window starting point:

   if ((wleft + wndwidth + CFont.OffX + Scr->WBorRight) > Scr->Width) 
      wleft = Scr->Width - wndwidth;
   
   if ((wtop + wndheight + CFont.OffY + Scr->WBorBottom) > Scr->Height) 
      wtop = Scr->Height - wndheight;

   if (!(g = CreateContext( &ATGList ))) // == NULL)
      return( -1 );

   if (!(g = SetupATGadget( g, 0, Scr->Width - 50, 498 ))) // Command Line History List Gadget
      {
      CannotCreate( SetupCMsg( MSG_CMDLINE_GADGET_STR_SETUP ) );

      return( -2 );
      }

   if (!(g = SetupATGadget( g, 1, Scr->Width - 220, 20 ))) // Single Command Line String Gadget
      {
      CannotCreate( SetupCMsg( MSG_SINGLE_GADGET_STR_SETUP ) );

      return( -2 );
      }

   if (!(g = SetupATGadget( g, 2, 130, 20 ))) // Parse Button Gadget
      {
      CannotCreate( SetupCMsg( MSG_PARSEBT_GADGET_STR_SETUP ) );

      return( -2 );
      }
      
   if (!(ATMenus = CreateMenus( ATNewMenu, 
                               GTMN_FrontPen, 0L, TAG_DONE ))) // == NULL)
      return( -3 );

   LayoutMenus( ATMenus, VisualInfo, TAG_DONE );

   if (!(ATWnd = OpenWindowTags( NULL,

                   WA_Left,   wleft,
                   WA_Top,    wtop,
                   WA_Width,  wndwidth  + CFont.OffX + Scr->WBorRight,
                   WA_Height, wndheight + CFont.OffY + Scr->WBorBottom,

                   WA_IDCMP,  LISTVIEWIDCMP | STRINGIDCMP | BUTTONIDCMP
                     | IDCMP_MENUPICK | IDCMP_CLOSEWINDOW 
                     | IDCMP_RAWKEY | IDCMP_REFRESHWINDOW,
                     // | IDCMP_NEWSIZE | IDCMP_CHANGEWINDOW // Don't work with GadTools
                     // | IDCMP_VANILLAKEY,

                   WA_Flags,  WFLG_DEPTHGADGET | WFLG_CLOSEGADGET 
                     | WFLG_SMART_REFRESH | WFLG_ACTIVATE, 
                     // | WFLG_HASZOOM | WFLG_SIZEBBOTTOM | WFLG_SIZEGADGET,
                   
                   WA_MinWidth,     400, // Scr->Width,
                   WA_MinHeight,    150, // wndheight,
                   WA_MaxWidth,     Scr->Width,
                   WA_MaxHeight,    Scr->Height,
                   WA_NewLookMenus, TRUE,

                   WA_Gadgets,      ATGList,
                   WA_Title,        ATWdt,
                   WA_ScreenTitle,  scrtitle,
                   WA_CustomScreen, Scr,
                   TAG_DONE )
      )) // == NULL)
      return( -4 );

   SetMenuStrip( ATWnd, ATMenus );
   GT_RefreshWindow( ATWnd, NULL );

   SetTagItem( &LoadTags[0],   ASLFR_Window, (ULONG) ATWnd );
   SetTagItem( &SaveTags[0],   ASLFR_Window, (ULONG) ATWnd );
   SetTagItem( &FontTags[0],   ASLFO_Window, (ULONG) ATWnd );
   SetTagItem( &ScreenTags[0], ASLSM_Window, (ULONG) ATWnd );

   return( 0 );
}

/****i* Setup.c/SetupListViewer() [2.0] ***************************** 
*
* NAME 
*   SetupListViewer - Initialize the structures necessary for proper
*                     operation of the Program Code ListView gadget.
*
* SYNOPSIS
*   success = SetupListViewer( void )
*
*********************************************************************
*/

PRIVATE int SetupListViewer( void )
{
   int i = 0;

   if (!(PgmItemBuffer = (char *) AllocVec( sizeof( char ) * PGM_MAXITEM * PGM_ITEMLENGTH, 
                                            MEMF_CLEAR | MEMF_ANY ))) // == NULL)
      {
      return( -1 );
      }

   for (i = 0; i < PGM_MAXITEM; i++)
      PgmListItems[i].ln_Name = &PgmItemBuffer[ i * PGM_ITEMLENGTH ];

   NewList( &PgmList );

   for (i = 0; i < PGM_MAXITEM; i++)
      AddTail( &PgmList, &PgmListItems[i] );


   GT_SetGadgetAttrs( ATGadgets[ PgmListView ], ATWnd, NULL,
                      GTLV_Labels,       &PgmList,
                      GTLV_ShowSelected, NULL, // ATGadgets[CmdStr]
                      GTLV_Selected,     0,
                      TAG_DONE
                    );
   return( 0 );
}

/****i* CatalogCantHappen() [2.3] *********************************** 
*
* NAME 
*   CatalogCantHappen()
*
* DESCRIPTION
*   Localize the impossible(?) error strings that Little Smalltalk
*   might want to show the User.  Called only by SetupMiscCatalogs().
*********************************************************************
*
*/

SUBFUNC int CatalogCantHappen( void )
{
   IMPORT char *ch_errstrs[];
   
   ch_errstrs[0 ] = SetupCMsg( MSG_CANT_NO_ERROR_SETUP   );
   ch_errstrs[1 ] = SetupCMsg( MSG_CANT_NO_MEM_SETUP     );
   ch_errstrs[2 ] = SetupCMsg( MSG_CANT_ARRAY_SIZE_SETUP );
   ch_errstrs[3 ] = SetupCMsg( MSG_CANT_NO_BLK_RET_SETUP );
   ch_errstrs[4 ] = SetupCMsg( MSG_CANT_NON_CLASS_SETUP  );
   ch_errstrs[5 ] = SetupCMsg( MSG_CANT_CASE_ERR_SETUP   );
   ch_errstrs[6 ] = SetupCMsg( MSG_CANT_DECR_UNK_SETUP   );
   ch_errstrs[7 ] = SetupCMsg( MSG_CANT_NO_CLASS_SETUP   );
   ch_errstrs[8 ] = SetupCMsg( MSG_CANT_PRIM_FREE_SETUP  );
   ch_errstrs[9 ] = SetupCMsg( MSG_CANT_INTERP_ERR_SETUP );
   ch_errstrs[10] = SetupCMsg( MSG_CANT_NON_BLOCK_SETUP  );
   ch_errstrs[11] = SetupCMsg( MSG_CANT_NO_SYMSPC_SETUP  );
   ch_errstrs[12] = SetupCMsg( MSG_CANT_NO_BCSPC_SETUP   );
   ch_errstrs[13] = SetupCMsg( MSG_CANT_DEADLOCK_SETUP   );
   ch_errstrs[14] = SetupCMsg( MSG_CANT_FREE_SYM_SETUP   );
   ch_errstrs[15] = SetupCMsg( MSG_CANT_INV_PSTATE_SETUP );
   ch_errstrs[16] = SetupCMsg( MSG_CANT_BUFF_OVFLW_SETUP );
   ch_errstrs[17] = SetupCMsg( MSG_CANT_NO_PRELUDE_SETUP );
   ch_errstrs[18] = SetupCMsg( MSG_CANT_SYS_FILE_SETUP   );
   ch_errstrs[19] = SetupCMsg( MSG_CANT_FASTSAVE_SETUP   );
   ch_errstrs[20] = SetupCMsg( MSG_CANT_BACKTRACE_SETUP  );
   ch_errstrs[21] = SetupCMsg( MSG_CANT_HI_BITS_SETUP    );
   ch_errstrs[22] = SetupCMsg( MSG_CANT_NON_SYMBOL40_SETUP );
   ch_errstrs[23] = SetupCMsg( MSG_CANT_NON_SYMBOL80_SETUP );
   ch_errstrs[24] = SetupCMsg( MSG_CANT_NON_SYMBOL90_SETUP );
   ch_errstrs[25] = SetupCMsg( MSG_CANT_LO_BITSC0_SETUP    );
   ch_errstrs[26] = SetupCMsg( MSG_CANT_LO_BITSF0_SETUP    );
   ch_errstrs[27] = SetupCMsg( MSG_CANT_BLK_COUNT_SETUP    );
   ch_errstrs[28] = SetupCMsg( MSG_CANT_NULL_OBJ_SETUP     );

   // My Additions to the cant_happen() system:
   
   ch_errstrs[29] = SetupCMsg( MSG_CANT_NO_SPECIAL_SETUP ); // SPECIAL_NOT_SYMBOL
   ch_errstrs[30] = SetupCMsg( MSG_CANT_NO_LIBRARY_SETUP );
   ch_errstrs[30] = SetupCMsg( MSG_CANT_NO_INTSPC_SETUP  );
   ch_errstrs[32] = SetupCMsg( MSG_CANT_IMPOSSIBLE_SETUP );
}

/****i* SetupMiscCatalogs() [2.3] *********************************** 
*
* NAME 
*   SetupMiscCatalogs()
*
* DESCRIPTION
*   This is the single entry point where all global strings get
*   localized via the locale.library functions.  Only source files
*   with File scope strings have entries in this function (for Menus,
*   Gadget labels, IntuiText, etc).
*********************************************************************
*
*/

PRIVATE int SetupMiscCatalogs( void )
{
   StringNCopy( &ATWdt[0], "AmigaTalkPPC:", 80 ); // W_SETUP_TITLE

   SetupPenNames(); // Added for V3.0 (03-Jan-2005)

   (void) CatalogCantHappen();
   (void) CatalogADOS1();      // In ADOS1.c 
   (void) CatalogUserScript(); // In UserScriptReq.c 
   (void) CatalogATGadgets();  // In ATGadgets.c 
   (void) CatalogATHelper();   // In ATHelper.c
   (void) CatalogATMenus();    // In ATMenus.c
   (void) CatalogCDROM();      // In CDROM.c
   (void) CatalogClipboard();  // In Clipboard.c
   (void) CatalogConsole();    // In Console.c
   (void) CatalogDisk2();      // In Disk2.c
   (void) CatalogGlobal();     // In Global.c
   (void) CatalogIcon();       // In Icon.c
   (void) CatalogIconDsp();    // In IconDsp.c
   (void) CatalogIFF();        // In IFF.c
   (void) CatalogInterp();     // In Interp.c
   (void) CatalogIO();         // In IO.c
   (void) CatalogMenu();       // In Menu.c
   (void) CatalogMsgPort();    // In MsgPort.c

#  ifdef  __SASC
   (void) CatalogNarrator();   // In Narrator.c
#  endif

   (void) CatalogParallel();   // In Parallel.c
   (void) CatalogPrinter();    // In Printer.c
   (void) CatalogErrStrings(); // in ReportErrs.c
   (void) CatalogRexx();       // In Rexx.c
   (void) CatalogScreen();     // In Screen.c
   (void) CatalogSystem();     // In System.c
   (void) CatalogTools();      // In Tools.c
   (void) CatalogTracer();     // In Tracer.c
   (void) CatalogTracer2();    // In Tracer2.c

   return( 0 );
}

/****h* Setup.c/firstSetup() [3.0] ********************************** 
*
* NAME 
*   firstSetup()
*
* DESCRIPTION
*   Open the libraries & setup the Catalog so that ToolTypes
*   are initialized before we process the Icon.
*
* SYNOPSIS
*   success = firstSetup( void )
*********************************************************************
*
*/

PUBLIC int firstSetup( void )
{
   if (OpenATLibs() < 0)
      {
      NotOpened( 4 );

      return( ERROR_INVALID_RESIDENT_LIBRARY );
      }

   // NULL is for the Locale (from OpenLocale()): 
   if (LocaleBase)
      catalog = (struct Catalog *) OpenCatalog( NULL, "amigatalk.catalog",
                                                       OC_BuiltInLanguage, "english", 
                                                       TAG_DONE 
                                              );

   if (SetupMiscCatalogs() < 0)
      {
      ShutDown();

      return( IoErr() );
      }

   return( RETURN_OK );      
}

SUBFUNC void readInMemorySpaces( aiPTR ai )
{
   int idx = 0;
   
   (void) iniFirstGroup( ai );
   
   idx = iniFindGroup( ai, SetupCMsg( MSG_ATEGRP_MEMORY_SETUP ) );
   BreakPointDBG( "readInMemorySpaces():", "Memory Group starts on line %ld", idx );
   
   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_OBJECT_SIZE_SETUP ) )) 
      {
      ObjectTableSize = (ULONG) atoi( iniGetItemValue( ai, idx ) );
      BreakPointDBG( "readInMemorySpaces():", "ObjectTableSize = %ld at line %ld", ObjectTableSize, idx );
      }

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_BYTEARRAY_SIZE_SETUP )))
      {
      ByteArrayTableSize = (ULONG) atoi( iniGetItemValue( ai, idx ) );
      BreakPointDBG( "readInMemorySpaces():", "ByteArrayTableSize = %ld at line %ld", ByteArrayTableSize, idx );
      }

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_INTEGER_SIZE_SETUP )))
      {
      IntegerTableSize = (ULONG) atoi( iniGetItemValue( ai, idx ) );
      BreakPointDBG( "readInMemorySpaces():", "IntegerTableSize = %ld at line %ld", IntegerTableSize, idx );
      }

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_INTERP_SIZE_SETUP )))
      {
      InterpreterTableSize = (ULONG) atoi( iniGetItemValue( ai, idx ) );
      BreakPointDBG( "readInMemorySpaces():", "InterpreterTableSize = %ld at line %ld", InterpreterTableSize, idx );
      }

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_SYMBOL_SIZE_SETUP )))
      {
      SymbolTableSize = (ULONG) atoi( iniGetItemValue( ai, idx ) );
      BreakPointDBG( "readInMemorySpaces():", "SymbolTableSize = %ld at line %ld", SymbolTableSize, idx );
      }

   return;
}

SUBFUNC void readInPathNames( aiPTR ai )
{
   int idx = 0;
   
   (void) iniFirstGroup( ai );

   idx = iniFindGroup( ai, SetupCMsg( MSG_ATEGRP_PATHS_SETUP ) );
   BreakPointDBG( "readInPathNames():", "Paths Group starts on line %ld", idx );

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_LIBRARY_PATH_SETUP )))
      {
      StringNCopy( &LibraryPath[0], (UBYTE *) iniGetItemValue( ai, idx ), LARGE_TOOLSPACE );
      BreakPointDBG( "readInPathNames():", "at line %ld,\n LibraryPath = '%s'", idx, LibraryPath );
      }

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_COMMAND_PATH_SETUP )))
      {
      StringNCopy( &CommandPath[0], (UBYTE *) iniGetItemValue( ai, idx ), LARGE_TOOLSPACE );
      BreakPointDBG( "readInPathNames():", "at line %ld,\n CommandPath = '%s'", idx, CommandPath );
      }

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_HELP_PATH_SETUP )))
      {
      StringNCopy( &HelpPath[0], (UBYTE *) iniGetItemValue( ai, idx ), LARGE_TOOLSPACE );
      BreakPointDBG( "readInPathNames():", "at line %ld,\n HelpPath = '%s'", idx, HelpPath );
      }

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_GENERAL_PATH_SETUP )))
      {
      StringNCopy( &GeneralPath[0], (UBYTE *) iniGetItemValue( ai, idx ), LARGE_TOOLSPACE );
      BreakPointDBG( "readInPathNames():", "at line %ld,\n GeneralPath = '%s'", idx, GeneralPath );
      }

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_INTUITION_PATH_SETUP )))
      {
      StringNCopy( &IntuitionPath[0], (UBYTE *) iniGetItemValue( ai, idx ), LARGE_TOOLSPACE );
      BreakPointDBG( "readInPathNames():", "at line %ld,\n IntuitionPath = '%s'", idx, IntuitionPath );
      }

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_SYSTEM_PATH_SETUP )))
      {
      StringNCopy( &SystemPath[0], (UBYTE *) iniGetItemValue( ai, idx ), LARGE_TOOLSPACE );
      BreakPointDBG( "readInPathNames():", "at line %ld,\n SystemPath = '%s'", idx, SystemPath );
      }

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_USER_PATH_SETUP )))
      {
      StringNCopy( &UserClassPath[0], (UBYTE *) iniGetItemValue( ai, idx ), LARGE_TOOLSPACE );
      BreakPointDBG( "readInPathNames():", "at line %ld,\n UserClassPath = '%s'", idx, UserClassPath );
      }

   return;
}

SUBFUNC void readInCommands( aiPTR ai )
{
   int idx = 0;
   
   (void) iniFirstGroup( ai );

   idx = iniFindGroup( ai, SetupCMsg( MSG_ATEGRP_SUPPORT_SETUP ) );
   BreakPointDBG( "readInCommands():", "Commands Group starts on line %ld", idx );

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_FILE_DISPLAYER_SETUP )))
      {
      StringNCopy( &FileDisplayer[0], (UBYTE *) iniGetItemValue( ai, idx ), LARGE_TOOLSPACE );
      BreakPointDBG( "readInCommands():", "at line %ld,\n FileDisplayer = '%s'", idx, FileDisplayer );
      }

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_HELP_PROGRAM_SETUP )))
      {
      StringNCopy( &HelpProgram[0], (UBYTE *) iniGetItemValue( ai, idx ), LARGE_TOOLSPACE );
      BreakPointDBG( "readInCommands():", "at line %ld,\n HelpProgram = '%s'", idx, HelpProgram );
      }

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_EDITOR_SETUP )))
      {
      StringNCopy( &Editor[0], (UBYTE *) iniGetItemValue( ai, idx ), LARGE_TOOLSPACE );
      BreakPointDBG( "readInCommands():", "at line %ld,\n Editor = '%s'", idx, Editor );
      }

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_PARSER_NAME_SETUP )))
      {
      StringNCopy( &ParserName[0], (UBYTE *) iniGetItemValue( ai, idx ), LARGE_TOOLSPACE );
      BreakPointDBG( "readInCommands():", "at line %ld,\n ParserName = '%s'", idx, ParserName );
      }

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_LOGO_COMMAND_SETUP )))
      {
      StringNCopy( &LogoCmd[0], (UBYTE *) iniGetItemValue( ai, idx ), LARGE_TOOLSPACE );
      BreakPointDBG( "readInCommands():", "at line %ld,\n LogoCmd = '%s'", idx, LogoCmd );
      }
   
   return;
}

SUBFUNC void readInMiscStrings( aiPTR ai )
{
   int idx = 0;
   
   (void) iniFirstGroup( ai );

   idx = iniFindGroup( ai, SetupCMsg( MSG_ATEGRP_MISC_SETUP ) );
   BreakPointDBG( "readInMiscStrings():", "Misc Group starts on line %ld", idx );

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_INIT_SCRIPT_SETUP )))
      {
      StringNCopy( &InitializeScript[0], (UBYTE *) iniGetItemValue( ai, idx ), LARGE_TOOLSPACE );
      BreakPointDBG( "readInMiscStrings():", "at line %ld,\n InitializeScript = '%s'", idx, InitializeScript );
      }

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_UPDATE_SCRIPT_SETUP )))
      {
      StringNCopy( &UpdateScript[0], (UBYTE *) iniGetItemValue( ai, idx ), LARGE_TOOLSPACE );
      BreakPointDBG( "readInMiscStrings():", "at line %ld,\n UpdateScript = '%s'", idx, UpdateScript );
      }

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_AREXX_PORTNAME_SETUP )))
      {
      StringNCopy( &ARexxPortName[0], (UBYTE *) iniGetItemValue( ai, idx ), LARGE_TOOLSPACE );
      BreakPointDBG( "readInMiscStrings():", "at line %ld,\n ARexxPortName = '%s'", idx, ARexxPortName );
      }

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_TAB_SIZE_SETUP )))
      {
      DefaultTabSize = (UWORD) atoi( iniGetItemValue( ai, idx ) );
      BreakPointDBG( "readInMiscStrings():", "at line %ld,\n DefaultTabSize = %ld", idx, DefaultTabSize );
      }

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_STATUS_HLENGTH_SETUP )))
      {
      StatusHistoryLength = (UWORD) atoi( iniGetItemValue( ai, idx ) );
      BreakPointDBG( "readInMiscStrings():", "at line %ld,\n StatusHistoryLength = %ld", idx, StatusHistoryLength );
      }

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_LOGO_NAME_SETUP )))
      {
      StringNCopy( &LogoName[0], (UBYTE *) iniGetItemValue( ai, idx ), LARGE_TOOLSPACE );
      BreakPointDBG( "readInMiscStrings():", "at line %ld,\n LogoName = '%s'", idx, LogoName );
      }

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_IMAGE_FILE_SETUP )))
      {
      StringNCopy( &ImageFile[0], (UBYTE *) iniGetItemValue( ai, idx ), LARGE_TOOLSPACE );
      BreakPointDBG( "readInMiscStrings():", "at line %ld,\n ImageFile = '%s'", idx, ImageFile );
      }

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_SYMBOL_FILE_SETUP )))
      {
      StringNCopy( &SymbolFile[0], (UBYTE *) iniGetItemValue( ai, idx ), LARGE_TOOLSPACE );
      BreakPointDBG( "readInMiscStrings():", "at line %ld,\n SymbolFile = '%s'", idx, SymbolFile );
      }
      
   return;
}

SUBFUNC void readInGUIValues( aiPTR ai )
{
   int idx = 0;
   
   (void) iniFirstGroup( ai );

   idx = iniFindGroup( ai, SetupCMsg( MSG_ATEGRP_GUI_SETUP ) );
   BreakPointDBG( "readInGUIValues():", "GUI Group starts on line %ld", idx );

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_SCREENMODEID_SETUP )))
      {
      long   temp  = 0L;
      int    chk   = 0;
      UBYTE *scptr = iniGetItemValue( ai, idx );
      
      if (*scptr == '0' && *(scptr + 1) == 'x')
         {
	      chk = hexStrToLong( &scptr[2], &temp );
	      }
      else
         {
	      chk = hexStrToLong( &scptr[0], &temp );
	      }

      CurrentScrModeID = ATScreenModeID = (ULONG) chk;

      BreakPointDBG( "readInGUIValues():", "at line %ld,\n ScreenModeID = 0x%08lx", idx, CurrentScrModeID );
      }

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_FONT_NAME_SETUP )))
      {
      StringNCopy( UseFontName, iniGetItemValue( ai, idx ), BUFF_SIZE );
      BreakPointDBG( "readInGUIValues():", "at line %ld,\n UseFontName = '%s'", idx, UseFontName );
      }

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_FONT_SIZE_SETUP ))) 
      {
      UseFontSize = atoi( iniGetItemValue( ai, idx ) );
      BreakPointDBG( "readInGUIValues():", "at line %ld,\n UseFontSize = %ld", idx, UseFontSize );
      }

   TurnOnBreakPoints();

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_GUI_WIDTH_SETUP )))
      {
      ATWidth = (UWORD) atoi( iniGetItemValue( ai, idx ) );
      BreakPointDBG( "readInGUIValues():", "at line %ld,\n ATWidth = %ld", idx, ATWidth );
      }

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_GUI_HEIGHT_SETUP )))
      {
      ATHeight = (UWORD) atoi( iniGetItemValue( ai, idx ) );
      BreakPointDBG( "readInGUIValues():", "at line %ld,\n ATHeight = %ld", idx, ATHeight );
      }

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_STATUS_WIDTH_SETUP )))
      {
      ATStatWidth = (UWORD) atoi( iniGetItemValue( ai, idx ) ); 
      BreakPointDBG( "readInGUIValues():", "at line %ld,\n ATStatWidth = %ld", idx, ATStatWidth );
      }

   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_STATUS_HEIGHT_SETUP )))
      {
      ATStatHeight = (UWORD) atoi( iniGetItemValue( ai, idx ) );
      BreakPointDBG( "readInGUIValues():", "at line %ld,\n ATStatHeight = %ld", idx, ATStatHeight );
      }

   return;
}

SUBFUNC void readInPalette( aiPTR ai )
{
   int idx = 0, i;
   
   (void) iniFirstGroup( ai );

   idx = iniFindGroup( ai, SetupCMsg( MSG_ATEGRP_PALETTE_SETUP ) );
   BreakPointDBG( "readInPalette():", "Palette Group starts on line %ld", idx );
         
   if (idx = iniFindItem( ai, SetupCMsg( MSG_ATEGRP_ITEM_NUM_PENS_SETUP )))
      {
      numberOfPens = atoi( iniGetItemValue( ai, idx ) );
      BreakPointDBG( "readInPalette():", "at line %ld,\n numberOfPens = %ld", idx, numberOfPens );
      }

   for (i = 0; i < numberOfPens; i++)
      {
      if ((idx = iniFindItem( ai, penNames[i] )))
         {
         long   temp  = 0L;
         int    chk   = 0;
         UBYTE *cptr  = iniGetItemValue( ai, idx );
      
         if (*cptr == '0' && *(cptr + 1) == 'x')
            {
	         chk = hexStrToLong( &cptr[2], &temp );
	         }
         else
            {
	         chk = hexStrToLong( &cptr[0], &temp );
	         }

         colorPens[i] = (ULONG) chk;
         BreakPointDBG( "readInPalette():", "at line %ld,\n colorPens[%ld] = 0x%08lx", idx, i, colorPens[i] );
	      }
      }

   return;
}


SUBFUNC int readInEnvironmentFile( UBYTE *iniFileName )
{
   int rval = RETURN_OK;
   
   if (!(ai = iniOpenFile( iniFileName, FALSE, "= &;" )))
      {
      DBG( fprintf( stderr, "Could NOT open %s file!\n", iniFileName ) );
      rval = RETURN_FAIL;
      }
   else
      {
      BreakPointDBG( "readInEnvironmentFile():", "Calling readInMemorySpaces( %p )", ai );
      readInMemorySpaces( ai );
      BreakPointDBG( "readInEnvironmentFile():", "Calling readInPathNames( %p )", ai );
      readInPathNames( ai );
      BreakPointDBG( "readInEnvironmentFile():", "Calling readInCommands( %p )", ai );
      readInCommands( ai );
      BreakPointDBG( "readInEnvironmentFile():", "Calling readInMiscStrings( %p )", ai );
      readInMiscStrings( ai );
      BreakPointDBG( "readInEnvironmentFile():", "Calling readInGUIValues( %p )", ai );
      readInGUIValues( ai );
      BreakPointDBG( "readInEnvironmentFile():", "Calling readInPalette( %p )", ai );
      readInPalette( ai );
      }
      
   if (ai)
      iniExit( ai );
      
   return( rval );
}

/****h* Setup.c/InitATalk() [3.0] *********************************** 
*
* NAME 
*   InitATalk()
*
* DESCRIPTION
*   Initialize the structures necessary for proper operation of 
*   the AmigaTalk Program GUI.
*
* SYNOPSIS
*   success = InitATalk( void )
*********************************************************************
*
*/

PUBLIC int InitATalk( void )
{
   IMPORT UBYTE PgmName[];
   
   UWORD rval = 0;

   if (StringLength( &PgmName[0] ) < 1)
      {
      StringCopy( &PgmName[0], "AmigaTalkPPC" );
      }

   if (StringLength( &CopyRight[0] ) < 1)
      {
      StringCopy( &CopyRight[0], " 1998-2005" );
      }

//   DBG( fprintf( stderr, "Set PgmName = %s, CopyRight = %s\n", &PgmName[0], &CopyRight[0] ) );
      
   sprintf( &ATWdt[0], SetupCMsg( MSG_W_PROGRAM_TITLE_SETUP ), &PgmName[0], CopyRight );

   BreakPointDBG( "InitATalk():", "Calling readInEnvironmentFile( '%s' )", &EnvironFile[0] );

   if (readInEnvironmentFile( &EnvironFile[0] ) != RETURN_OK)
      {
      fprintf( stderr, "%s", SetupCMsg( MSG_INIFILE_ERROR_SETUP ) );

      UserInfo( SetupCMsg( MSG_INIFILE_ERROR_SETUP ),
                SetupCMsg( MSG_RQTITLE_FATAL_ERROR_SETUP )
	      );
      
      return( RETURN_FAIL );
      }

   TurnOnBreakPoints();      
   BreakPointDBG( "InitATalk():", "Calling SetupScreen()..." );

   if (SetupScreen() < 0)
      {
      CloseCatalog( catalog );
      CloseATLibs();

      NotOpened( 0 );

      return( ERROR_ON_OPENING_SCREEN );
      }

//   DBG( fprintf( stderr, "Ready to OpenATWindow()...\n" ) );
   
   if (OpenATWindow() < 0)
      {
      ShutDown();

      NotOpened( 1 );

      return( ERROR_ON_OPENING_WINDOW );
      }

   SetNotifyWindow( ATWnd ); // Enable CommonFuncs.o Requesters.

   if (SetupListViewer() < 0)
      {
      CannotSetup( SetupCMsg( MSG_PGM_LV_GADGET_STR_SETUP ) ); 

      ShutDown();

      return( ERROR_NO_FREE_STORE );
      }

   rval = PubScreenStatus( Scr, 0 ); // This function might have to move.

   return( RETURN_OK ); // All is groovy (so far).
}

/* ------------------- END of Setup.c file! --------------------- */
