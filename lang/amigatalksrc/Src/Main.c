/****h* AmigaTalk/Main.c [3.0] ******************************************
*
* NAME
*    Main.c
*
* DESCRIPTION
*    Main.c   Little Smalltalk - main driver function.
*
*    1. initializes various smalltalk constants and classes with
*       legitimate values.  these values, however, will for the 
*       most part be overridden when the standard prelude is read in.
*
*    2. reads in the standard prelude, plus any additional files listed
*       on the command line.
*
*    3. starts the process driver running (waiting for user input).
*
* HISTORY
*    07-Nov-2004 - Replaced forkl() code with code that will work under AmigaOS4.
*
*    24-Oct-2004 - Added AmigaOS4 & gcc support.
*
*    25-Dec-2003 - Fixed Menus Check state to reflect User command
*                  line arguments (if supplied).
*
*    04-Nov-2003 - Moved o_IDCMP_rval below the started = TRUE; line.
*                  o_IDCMP_rval needs to be a real Array, not
*                  o_acollection type.  started = TRUE will ensure this.
*                  Added cleanOutInterpreters() to SmallTalk() code.
*
*    31-Oct-2003 - Added a call to firstSetup() in main().
*
*    11-Oct-2003 - Added the needFiles() function to ProcessArgs().
*
* EXTERNAL REF'S: -----------------------------------------------------
*
* NOTES 
*    $VER: AmigaTalk:Src/Main.c 3.0 (07-Nov-2004) by J.T. Steichen
*
*    GUI Designed by : Jim Steichen
********************************************************************
*
*/

#include <stdio.h>
#include <string.h>
#include <assert.h>

#include <exec/types.h>
#include <exec/libraries.h>
#include <exec/lists.h>
#include <exec/nodes.h>
#include <exec/memory.h>

#include <AmigaDOSErrs.h>

#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/gadgetclass.h>

#include <workbench/workbench.h>
#include <workbench/startup.h>
#include <workbench/icon.h>

#include <libraries/dosextens.h>
#include <libraries/gadtools.h>
#include <libraries/locale.h>

#include <dos.h>

#include <dos/rdargs.h> // Added for V1.8+

#include <devices/inputevent.h> // RawKey support

#include <graphics/displayinfo.h>
#include <graphics/gfxbase.h>
#include <graphics/gfx.h>

#ifdef __SASC

# include <clib/exec_protos.h>
# include <clib/intuition_protos.h>
# include <clib/gadtools_protos.h>
# include <clib/graphics_protos.h>
# include <clib/utility_protos.h>

IMPORT struct DosLibrary    *DOSBase;

PUBLIC struct GfxBase       *GfxBase;
PUBLIC struct IntuitionBase *IntuitionBase;
PUBLIC struct LocaleBase    *LocaleBase;
PUBLIC struct Library       *GadToolsBase;
PUBLIC struct Library       *IconBase;
PUBLIC struct Library       *CyberGfxBase; // Added on 06-Feb-2002
PUBLIC struct RxsLib        *RexxSysBase;  // Moved from ARexxCmd.h V2.3

#else

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/intuition.h>
# include <proto/gadtools.h>
# include <proto/graphics.h>
# include <proto/utility.h>
# include <proto/rexxsyslib.h>

IMPORT struct Library *DOSBase;
IMPORT struct Library *SysBase;
IMPORT struct Library *IntuitionBase;
IMPORT struct Library *GfxBase;
IMPORT struct Library *IconBase;
//IMPORT struct Library *LocaleBase;  // -lauto should take care of these

PUBLIC struct Library *UtilityBase  = NULL;
PUBLIC struct Library *GadToolsBase = NULL;
PUBLIC struct Library *CyberGfxBase = NULL;

IMPORT struct DOSIFace       *IDOS;     // -lauto should take care of this
IMPORT struct ExecIFace      *IExec;    // -lauto should take care of this
//IMPORT struct LocaleIFace    *ILocale;
IMPORT struct IconIFace      *IIcon;
IMPORT struct IntuitionIFace *IIntuition;
IMPORT struct GraphicsIFace  *IGraphics;

PUBLIC struct UtilityIFace   *IUtility;
PUBLIC struct GadToolsIFace  *IGadTools;
PUBLIC struct CyberGfxIFace  *ICyberGfx;
PUBLIC struct RexxSysIFace   *IRexxSys;

#endif

PUBLIC struct Library *RexxSysBase = NULL;  // Moved from ARexxCmd.h V2.3

PUBLIC BOOL HaveCyberLibrary = FALSE; // Added for V2.0

#include <stringfunctions.h>

#include "CPGM:GlobalObjects/CommonFuncs.h" 

#include "object.h"
#include "CProtos.h"
#include "FuncProtos.h"
#include "Constants.h"

#include "IStructs.h"
#include "CantHappen.h"

#ifdef  __SASC
__near LONG __stack = 50000; // default is 4000 bytes (from LIB:sc.lib).
#endif

#include "StringConstants.h"
# include "StringIndexes.h"

#ifdef DEBUG
# define SDBG(str) fprintf( stderr, "%s", str ) 
# define FDBG(p)  p
#else
# define SDBG(str)
# define FDBG(p)
#endif

// -------- Located in Setup.c file: -------------

IMPORT int  InitATalk( void );
IMPORT void ShutDown( void );

// --------- Located in ReportErrs.c file: -----------------------

IMPORT UBYTE *FATAL_ERROR;
IMPORT UBYTE *FATAL_INTERROR;

// --------- Located in Global.c file: ---------------------------

IMPORT BOOL FDEV; // Debugging variable.

IMPORT UBYTE *Version;

IMPORT UBYTE *AaarrggButton;
IMPORT UBYTE *DefaultButtons;

IMPORT UBYTE *ATalkProblem;
IMPORT UBYTE *UserProblem;

IMPORT UBYTE *ErrMsg;       // For making error messages.
IMPORT UBYTE  PgmName[];

IMPORT UWORD  ATScrWidth, ATScrHeight; // in Global.c
IMPORT ULONG  ATScreenModeID;          // = 0x40D20001 = 1,087,504,385;

// Added for V2.2:
IMPORT UWORD  ATStatWidth, ATStatHeight, ATStatLeft, ATStatTop; // in Global.c

// ------------------------ GUI variables in other files: ------

IMPORT struct Menu      *ATMenus;
IMPORT struct NewMenu    ATNewMenu[];

IMPORT struct Gadget    *ATGList;
IMPORT struct Gadget    *ATGadgets[];
IMPORT struct NewGadget  ATNGad[];

IMPORT struct Console   *st_console;

// ------------------------ Visible variables: -----------------

PUBLIC struct Screen        *Scr           = NULL;
PUBLIC UBYTE                *WBScreenName  = "Workbench";
PUBLIC APTR                  VisualInfo    = NULL;
PUBLIC struct Window        *ATWnd         = NULL;

PUBLIC struct TextAttr      *Font   = NULL;
PUBLIC struct TextFont      *ATFont = NULL;
PUBLIC struct TextAttr       Attr   = { 0, };
PUBLIC struct CompFont       CFont  = { 0, };

PUBLIC UWORD                 wndwidth, wndheight;

PUBLIC struct List           PgmList;
PUBLIC struct Node           PgmListItems[ PGM_MAXITEM ] = { 0, };
PUBLIC char                 *PgmItemBuffer = NULL;

// Environment variables Storage space: TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT

IMPORT UBYTE ScreenMode_ID[    NUMBR_TOOLSPACE ]; // Added on 30-Oct-2002

IMPORT UBYTE EnvironFile[      LARGE_TOOLSPACE ]; // Added on 03-Jan-2005
IMPORT UBYTE BrowserName[      LARGE_TOOLSPACE ]; // Added on 04-Mar-2003
IMPORT UBYTE InitializeScript[ LARGE_TOOLSPACE ]; // Added on 31-Jan-2002
IMPORT UBYTE UpdateScript[     LARGE_TOOLSPACE ]; // Added on 28-Jan-2002
IMPORT UBYTE ToolEditor[       LARGE_TOOLSPACE ]; // Added on 17-Sep-2001
IMPORT UBYTE FileDisplayer[    LARGE_TOOLSPACE ]; // Added on 17-May-2000
IMPORT UBYTE DisplayEnvFile[   LARGE_TOOLSPACE ]; // Added on 16-Apr-2000 (OBSOLETE)
IMPORT UBYTE HelpProgram[      LARGE_TOOLSPACE ];
IMPORT UBYTE CommandPath[      LARGE_TOOLSPACE ];
IMPORT UBYTE LibraryPath[      LARGE_TOOLSPACE ];
IMPORT UBYTE ParserName[       LARGE_TOOLSPACE ];
IMPORT UBYTE HelpPath[         LARGE_TOOLSPACE ];
IMPORT UBYTE GeneralPath[      LARGE_TOOLSPACE ];
IMPORT UBYTE IntuitionPath[    LARGE_TOOLSPACE ];
IMPORT UBYTE SystemPath[       LARGE_TOOLSPACE ];
IMPORT UBYTE UserClassPath[    LARGE_TOOLSPACE ];
IMPORT UBYTE Editor[           LARGE_TOOLSPACE ];
IMPORT UBYTE ImageFile[        LARGE_TOOLSPACE ];
IMPORT UBYTE SymbolFile[       LARGE_TOOLSPACE ]; // Added on 23-Feb-2000
IMPORT UBYTE UserInterface[    LARGE_TOOLSPACE ]; // NOT USED
IMPORT UBYTE ARexxPortName[    LARGE_TOOLSPACE ]; // NOT USED
IMPORT UBYTE LogoCmd[          LARGE_TOOLSPACE ];
IMPORT UBYTE LogoName[         LARGE_TOOLSPACE ];

IMPORT UWORD DefaultTabSize;  // Used by Amiga_Printf()
IMPORT UWORD StatusHistoryLength;

IMPORT ULONG ObjectTableSize;      // Added on 31-Oct-2003
IMPORT ULONG ByteArrayTableSize;   // Added on 06-Nov-2003
IMPORT ULONG InterpreterTableSize; // Added on 06-Nov-2003
IMPORT ULONG IntegerTableSize;     // Added on 06-Nov-2003
IMPORT ULONG SymbolTableSize;      // Added on 06-Nov-2003

// TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT

// -------------------------------------------------------------------

PRIVATE OBJECT *null_object;            /* a totally classless object */

PRIVATE char    filebase[80] = { 0, };  /* base for forming temp file names */

// counters in Global.c: ---------------------------------------------

IMPORT int ca_address;

IMPORT int n_incs, n_decs, n_mallocs;   /* counters in Object.c */
IMPORT int ca_obj, ca_objTotal; // ca_caobj[];

IMPORT int ca_block, ca_class, ca_terp, ca_int,   ca_float;
IMPORT int ca_str,   ca_sym,   ca_wal,  ca_cdict;

IMPORT int ca_barray, ca_symSpace, ca_walSize; // btabletop; // for Byte.c

//IMPORT int wtop;

IMPORT char outmsg[]; // For APrint() calls.

// -------------------------------------------------------------------

IMPORT int hailLogo;        // Command Line switch flags.
IMPORT int EnbStatus;
IMPORT int silence;
IMPORT int noload;
IMPORT int fastload;
IMPORT int prallocs;
IMPORT int prntcmd;
IMPORT int lexprnt;
IMPORT int debug;
IMPORT int started;
IMPORT int developer; // For my tracing of bugs.

// pseudo-variables:

IMPORT OBJECT *o_acollection;// arrayed collection (used internally)
IMPORT OBJECT *o_drive;      // driver interpreter
IMPORT OBJECT *o_empty;      // the empty array (used during initial)
IMPORT OBJECT *o_false;      // value for pseudo variable false
IMPORT OBJECT *o_magnitude;  // instance of class Magnitude
IMPORT OBJECT *o_nil;        // value for pseudo variable nil
IMPORT OBJECT *o_number;     // instance of class Number
IMPORT OBJECT *o_object;     // instance of class Object
IMPORT OBJECT *o_tab;        // string with tab character only
IMPORT OBJECT *o_true;       // value of pseudo variable true
IMPORT OBJECT *o_IDCMP_rval; // For GadTools.c
IMPORT OBJECT *o_smalltalk;  // value of pseudo variable smalltalk

// classes to be initialized first:

IMPORT CLASS *Array;
IMPORT CLASS *ArrayedCollection;

// input file stack:

IMPORT FILE *fdstack[];
IMPORT int fdtop;

#ifdef  __SASC
IMPORT  struct WBStartup    *WBenchMsg; // Linker stuff.
# define DEFAULTSCREENMODEID 0x40D20001
#else
IMPORT  struct WBStartup    *__WBenchMsg; // Linker stuff.
# define DEFAULTSCREENMODEID 0x50031100
#endif

IMPORT  struct DiskObject   *diskobj;

PRIVATE struct IntuiMessage  ATMsg;

IMPORT BOOL  traceByteCodes;
IMPORT FILE *TraceFile;
IMPORT int   TraceIndent;    // indent the bytecodes.

/* -------------------------- Functions: ------------------------- */

/* clean_files - delete all temp files created */

PRIVATE void clean_files( void )
{
   char cmdbuffer[512] = { 0, };

#  ifndef NOSYSTEM
   if (!filebase) // == NULL)
      return;
      
   if (*filebase == NIL_CHAR)
      return;             // no filebase, just return then.
      
   sprintf( cmdbuffer, MainCMsg( MSG_DELETE_COMMAND_MAIN ), filebase );

   system( cmdbuffer );
#  endif

   return;
}

// Currently NOT IMPLEMENTED.

/* dofast - do a fast load of the standard prelude */

PRIVATE int dofast( void )
{
   char cmdbuffer[100] = { 0, };

   sprintf( cmdbuffer, ")l %s\n", FAST ); // Eliminate FAST from the code.

   dolexcommand( cmdbuffer );

   return( 0 );
}

/****i* null_class() [1.0] ******************************************
*
* NAME
*    null_class()
*
* DESCRIPTION
*    Create a null class for bootstrapping purposes
*********************************************************************
*
*/

PRIVATE CLASS *null_class( char *name )
{
   CLASS  *New    = new_class();
   SYMBOL *NewSym = new_sym( name );

   if (!NewSym) // == NULL)
      {
      // Flag the User about this:
      if (ATWnd) // != NULL)
         {
         int ans = 0;
         
         sprintf( ErrMsg, MainCMsg( MSG_NOMAKE_NULL_MAIN ), name );

         ans = Handle_Problem( ErrMsg, FATAL_INTERROR, NULL );

         if (ans == 0)
            return( (CLASS *) NULL );
         else
            ShutDown();
         }
      else
         {
         int ans = 0;
         
         ATWnd = GetActiveWindow();
         
         SetNotifyWindow( ATWnd );
                  
         sprintf( ErrMsg, MainCMsg( MSG_NOMAKE_NULL_MAIN ), name );

         ans = Handle_Problem( ErrMsg, FATAL_INTERROR, NULL );

         if (ans == 0)
            return( (CLASS *) NULL );
         else
            ShutDown();
         }
      }

   New->class_name = AssignObj( (OBJECT *) NewSym );

   enter_class( name, (OBJECT *) New, o_nil );

   return( New );
}

/****h* AmigaTalk/DebugBreak() ***************************************
*
* NAME
*    DebugBreak()
*
* DESCRIPTION
*    This function exists only as a breakpoint for the SAS-C 
*    debugger cpr (CodeProbe).
**********************************************************************
*
*/

PUBLIC void DebugBreak( void )
{
   return;
}

PRIVATE char *PreludeNames[] = {
   
   "AmigaTalk:Prelude/standard",
   "AmigaTalk:System/System.p",
   "AmigaTalk:Intuition/Intuition.p",
   "AmigaTalk:Intuition/DTSystem.p",   // "For the next one",

   NULL   
};

//IMPORT int StringIComp( UBYTE *str1, UBYTE *str2 ); // Located in StringFuncs.o // CLDict.c

PRIVATE void ReadPreludes( int noload )
{
   FILE  *sfd = NULL;
   int   i    = 0;
   
   if (StringLength( &ImageFile[0] ) > 0)
      {
      if (StringIComp( &ImageFile[0], PreludeNames[0] ) != 0)
         PreludeNames[0] = ImageFile;
      }

   while (PreludeNames[i]) // != NULL) // strlen( PreludeNames[i] ) > 0)
      {
      BreakPointDBG( "ReadPreludes():", "Reading in '%s'", PreludeNames[i] );   

      if (noload == 0) 
         {
         sfd = fopen( PreludeNames[i], FILE_READ_STR );

         if (!sfd && i == 0)          // No Standard Prelude??
            cant_happen( PRELUDE_UNOPENED ); // Die, you abomination!!

         else if (!sfd && i != 0)
            {
            sprintf( outmsg, MainCMsg( MSG_FMT_PRE_UNOPEN_MAIN ), PreludeNames[i] );

            APrint( outmsg );

            goto SkipMissingFile; // Now we can go around broken files.
            }

         set_file( sfd );

         sprintf( outmsg, MainCMsg( MSG_FMT_PRE_READING_MAIN ), PreludeNames[i] );

         APrint( outmsg );

         (void) start_execution( FALSE );    // Interpret prelude file.

         // Temporary for debugging purposes only.
//         DebugBreak();
          
         fclose( sfd );
         }

SkipMissingFile:
      i++;        // Find next filename in PreludeNames[].
      }

   return;
}

PUBLIC void print_usage( char *pgm_name )
{
   if (Scr) // != NULL)
      {
      (void) OpenStatusWindow( Scr->Height );

      sprintf( outmsg, MainCMsg( MSG_USAGE1_MAIN ), pgm_name );
      APrint( outmsg );

      sprintf( outmsg, MainCMsg( MSG_USAGE2_MAIN ), pgm_name );
      APrint( outmsg );

      sprintf( outmsg, MainCMsg( MSG_USAGE3_MAIN ) );
      APrint( outmsg );

      sprintf( outmsg, MainCMsg( MSG_USAGE4_MAIN ) );
      APrint( outmsg );

      sprintf( outmsg, MainCMsg( MSG_USAGE5_MAIN ), pgm_name );
      APrint( outmsg );

      sprintf( outmsg, MainCMsg( MSG_USAGE6_MAIN ) );
      APrint( outmsg );

      sprintf( outmsg, MainCMsg( MSG_USAGE7_MAIN ) );
      APrint( outmsg );

      sprintf( outmsg, MainCMsg( MSG_USAGE8_MAIN ) );
      APrint( outmsg );

      sprintf( outmsg, MainCMsg( MSG_USAGE9_MAIN ) );
      APrint( outmsg );

      sprintf( outmsg, MainCMsg( MSG_USAGE10_MAIN ) );
      APrint( outmsg );

      sprintf( outmsg, MainCMsg( MSG_USAGE11_MAIN ) );
      APrint( outmsg );

      sprintf( outmsg, MainCMsg( MSG_USAGE12_MAIN ) );
      APrint( outmsg );

      sprintf( outmsg, MainCMsg( MSG_USAGE13_MAIN ) );
      APrint( outmsg );
      }
   else
      {
      fprintf( stderr, MainCMsg( MSG_USAGE1_MAIN  ), pgm_name );
      fprintf( stderr, MainCMsg( MSG_USAGE2_MAIN  ), pgm_name );
      fprintf( stderr, MainCMsg( MSG_USAGE3_MAIN  )           );
      fprintf( stderr, MainCMsg( MSG_USAGE4_MAIN  )           );
      fprintf( stderr, MainCMsg( MSG_USAGE5_MAIN  ), pgm_name );
      fprintf( stderr, MainCMsg( MSG_USAGE6_MAIN  )           );
      fprintf( stderr, MainCMsg( MSG_USAGE7_MAIN  )           );
      fprintf( stderr, MainCMsg( MSG_USAGE8_MAIN  )           );
      fprintf( stderr, MainCMsg( MSG_USAGE9_MAIN  )           );
      fprintf( stderr, MainCMsg( MSG_USAGE10_MAIN )           );
      fprintf( stderr, MainCMsg( MSG_USAGE11_MAIN )           );
      fprintf( stderr, MainCMsg( MSG_USAGE12_MAIN )           );
      fprintf( stderr, MainCMsg( MSG_USAGE13_MAIN )           );
      }

   return;
}

PUBLIC void ShowSystemDirectives( void )
{
   UBYTE *sdh = MainCMsg( MSG_SYSDIRECTIVES_MAIN );
                 
   UserInfo( sdh, MainCMsg( MSG_SYS_SUMMARY_MAIN ) );
   
   return;
}

/*
#define IEQUALIFIER_LSHIFT		0x0001
#define IEQUALIFIER_RSHIFT		0x0002
#define IEQUALIFIER_CAPSLOCK		0x0004
#define IEQUALIFIER_CONTROL		0x0008
#define IEQUALIFIER_LALT		0x0010
#define IEQUALIFIER_RALT		0x0020
#define IEQUALIFIER_LCOMMAND		0x0040
#define IEQUALIFIER_RCOMMAND		0x0080
#define IEQUALIFIER_NUMERICPAD		0x0100
#define IEQUALIFIER_REPEAT		0x0200
#define IEQUALIFIER_INTERRUPT		0x0400
#define IEQUALIFIER_MULTIBROADCAST	0x0800
#define IEQUALIFIER_MIDBUTTON		0x1000
#define IEQUALIFIER_RBUTTON		0x2000
#define IEQUALIFIER_LEFTBUTTON		0x4000
#define IEQUALIFIER_RELATIVEMOUSE	0x8000
*/

PRIVATE int ATRawKey( int whichkey, int qualifier )
{
   IMPORT int ATHelpProgram( void );

   IMPORT void Trace( struct Window *parent );   
   
   int ShiftMask = IEQUALIFIER_LSHIFT | IEQUALIFIER_RSHIFT;
   
   switch (whichkey)
      {
      case 0x10: // 'q' or 'Q'
      case 0x32: // 'x' or 'X'
         return( ATQuitAmigaTalk() );

      case 0x17: // 'i' or 'I'
         (void) ATAboutAmigaTalk();
         break;

      case 0x3A: // '?'
         if ((qualifier & ShiftMask) == 0) // Must be just a '/'
            break;
         
         // else FALLTHROUGH

      case 0x5F: // Help key
      case 0x25: // 'h' or 'H'
         (void) ATHelpProgram();
         break;

      case 0x28: // 'l' or 'L'
         return( ATLoadProgram() );
         break;

      case 0x21: // 's' or 'S'
         return( ATSaveProgram() );
         break;

      case 0x20: // 'a' or 'A'
         return( ATSaveAsProgram() );

      case 0x35: // 'b' or 'B'
         (void) ATOpenBrowser(); // Errors already flagged to User.
         break;

      case 0x12: // 'e' or 'E'
         return( ATEditFile() );

      case 0x13: // 'r' or 'R'
         return( ATRemoveUserScript() );
         
      case 0x14: // 't' or 'T' (no longer an option.)
         Trace( ATWnd );
         break;

      case 0x16: // 'u' or 'U'
         return( ATAddUserScript() );
         
      case 0x22: // 'd' or 'D'
         (void) DebugBreak();
         break;

      // Sometime in the future, we should test for f1 or F1, etc.

      case 0x50: // f1
         if ((qualifier & ShiftMask) == 0)
            {
            ShowSystemDirectives();

            break;
            }
         // else FALLTHROUGH for Shift-f1

      case 0x51: // F2
      case 0x52: // F3
      case 0x53: // F4
      case 0x54: // F5
      case 0x55: // F6
      case 0x56: // F7
      case 0x57: // F8
      case 0x58: // F9
      case 0x59: // F10

      default:
         break;
      }

   return( (int) TRUE );
}

PRIVATE int ATCloseWindow( void )
{
   CloseATWindow();

   return( (int) FALSE );
}

PRIVATE int HandleATIDCMP( void )
{
//   IMPORT void AdjustGadgetSizes( void );
   
   struct IntuiMessage *m;
   struct MenuItem     *n;
   int                 (*func)( int ), (*mfunc)( void );
   ULONG               signal  = 0L;
   BOOL                running = TRUE;

   while (running == TRUE)
      {
      if (!(m = (struct IntuiMessage *) GT_GetIMsg( ATWnd->UserPort ))) // == NULL) 
         {
         signal = SetSignal( 0, 0 );

         if ((SIGBREAKF_CTRL_C & signal) == SIGBREAKF_CTRL_C)
            {
            (void) SetSignal( 0, SIGBREAKF_CTRL_C );

            running = TRUE;

            break;
            }
         else
            (void) Wait( 1L << ATWnd->UserPort->mp_SigBit );

         continue;
         }

      CopyMem( (char *) m, (char *) &ATMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (ATMsg.Class) 
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( ATWnd );
            GT_EndRefresh( ATWnd, TRUE );
            break;
/*
         case IDCMP_NEWSIZE:
            AdjustGadgetSizes(); // Cannot be done with GadTools!

            GT_BeginRefresh( ATWnd );
            GT_EndRefresh( ATWnd, TRUE );
            break;
*/
/*
         case IDCMP_VANILLAKEY:
            running = ATVanillaKey( ATMsg.Code );
            break;
*/
         case IDCMP_CLOSEWINDOW:
            running = ATCloseWindow();
            break;

         case IDCMP_RAWKEY:
            running = ATRawKey( ATMsg.Code, ATMsg.Qualifier );
            break;
            
         case IDCMP_GADGETUP:
         case IDCMP_GADGETDOWN:
            func = (int (*)( int )) ((struct Gadget *)ATMsg.IAddress)->UserData;
            
            if (func) // != NULL)
               running = func( ATMsg.Code );
            
            break;

         case IDCMP_MENUPICK:
            if ((ATMsg.Code != MENUNULL) && (ATMenus)) // != NULL))
               {   
               n = ItemAddress( ATMenus, ATMsg.Code );
    
               if (n) // != NULL)
                  mfunc = (int (*)( void )) (GTMENUITEM_USERDATA( n ));
               
               if (mfunc) // != NULL)
                  running = mfunc();
   
//               ATMsg.Code = n->NextSelect;
               }

            break;
         }
      }

   return( running );
}

/****i* AmigaTalk/AmigaLoop() [1.5] ********************************
*
* NAME
*    AmigaLoop( char *buffer )
*
* DESCRIPTION
*    Get Commands from the User via the main GUI.
*
* SEE ALSO
*    line_grabber() in Line.c
********************************************************************
*
*/

PUBLIC int AmigaLoop( char *buffer )
{
   IMPORT void GetCommand( char *cmdbuffer ); // see ATGadgets.c file.

   int rval = 0;

   FBEGIN( printf( "AmigaLoop( %s )\n", buffer ) );    

   if ((rval = HandleATIDCMP()) == USER_COMMAND)
      GetCommand( buffer ); // Copy CmdStr Gadget contents into buffer

   FEND( printf( "%d = AmigaLoop() exits\n", rval ) );

   return( rval );
}

/****i* ProcessArgs/needFiles() [2.5] ******************************
*
* NAME
*    needFiles()
*
* HISTORY
*    11-Oct-2003 - Created this function code.
*
* DESCRIPTION
*    See if the user has specified command line arguments that 
*    will require a temporary file to be created.  Called from
*    ProcessArgs() only.
********************************************************************
*
*/ 

SUBFUNC BOOL needFiles( STRPTR RDAtemplate, LONG argArray[] )
{
   int  i;
   BOOL rval = FALSE;

   i = FindArg( RDAtemplate, MainCMsg( MSG_OPTION_LOADLIB_MAIN ) ); // -g option
   
   if (i >= 0 && argArray[i]) // != NULL)
      {
      rval = TRUE;
      
      goto exitNeedFiles; // No further checking needed.
      }

   i = FindArg( RDAtemplate, MainCMsg( MSG_OPTION_LOADCMD_MAIN ) ); // -r option
   
   if (i >= 0 && argArray[i]) // != NULL)
      {
      rval = TRUE;
      
      goto exitNeedFiles; // No further checking needed.
      }

   i = FindArg( RDAtemplate, MainCMsg( MSG_OPTION_CLASSES_MAIN ) ); // )i option
   
   if (i >= 0 && argArray[i]) // != NULL)
      rval = TRUE;
 
exitNeedFiles:

   return( rval );         
}

/****i* Main.c/ProcessArgs() ***************************************
*
* NAME
*    ProcessArgs()
*
* HISTORY
*    25-Dec-2003 - Added CheckMenuItem() calls.
*
*    11-Oct-2003 - Added needFiles() function code.
*
* DESCRIPTION
*    Set global flags according to command line switches or use
*    set_file() to read in user files.
********************************************************************
*
*/ 

PRIVATE void ProcessArgs( int argc, char **argv )
{
   IMPORT void CheckMenuItem( char *menuStr, BOOL chkState ); // In ATMenus.c
   
   IMPORT STRPTR ArgHelp, RDATemplate;
   
   struct RDArgs *allocdargs   = (struct RDArgs *) NULL;
   struct RDArgs *rdargs       = (struct RDArgs *) NULL;
   LONG           argarray[15] = { 0, };
   int            i;

   FILE *fd          = (FILE *) NULL;
   int   count       = 0;
   char  buffer[100] = { 0, };
   char  name[100]   = { 0, }, *tempname = NULL;

   count = 0;

   RDATemplate = MainCMsg( MSG_RDA_TEMPLATE_MAIN );
   
   if (!(allocdargs = (struct RDArgs *) AllocDosObject( DOS_RDARGS, NULL ))) // == NULL)
      {
      MemoryOut( MainCMsg( MSG_PROCARGS_FUNC_MAIN ) );

      return;
      }
   
   allocdargs->RDA_ExtHelp = ArgHelp; // Only reason for allocdargs.
      
   rdargs = (struct RDArgs *) ReadArgs( RDATemplate, argarray, allocdargs );

   // Only need a temporary file if the ReadArgs has a command present that
   // requires us to read in User files from )r, )g or )i commands:

   if (needFiles( RDATemplate, argarray ) == TRUE)
      {
      tempname = tmpnam( &name[0] );
      fd       = fopen( tempname, FILE_WRITE_STR );

      if (!fd) // == NULL)
         cant_happen( FILE_OPEN_ERROR );  // Die, you abomination!!

      StringNCopy( filebase, tempname, 80 ); // filebase HAS to be set up!
      }

   /* Added to enable tracing during startup of the program so that
   ** we can see what low-level problems are occurring.
   ** Normal usage:  CPR AmigaTalkDBG YDEV >Tracings/startupTrace
   ** THIS IS PRIVATE & IS NOT KNOWN BY USERS:
   */
   i = FindArg( RDATemplate, "YDEV" );
   
   if (i >= 0 && argarray[i]) // != NULL)
      {
      // YDEV or Y was supplied as an argument 
      fprintf( stderr, "Sending startup trace to stdout...\n" );

      TraceFile      = stdout;
      traceByteCodes = TRUE;
      TraceIndent    = 0;
      }
           
   i = FindArg( RDATemplate, MainCMsg( MSG_OPTION_NOSTD_MAIN ) ); // -n 1 or -l option
   
   if (i >= 0 && argarray[i]) // != NULL)
      {
      noload   = TRUE;
      fastload = FALSE;      
      }      

   i = FindArg( RDATemplate, MainCMsg( MSG_OPTION_LEXDBG_MAIN ) ); // -z option
   
   if (i >= 0 && argarray[i]) // != NULL)
      {
      lexprnt = TRUE;      

      CheckMenuItem( MainCMsg( MSG_AM_LEXPRT_MENU_MAIN ), TRUE );
      }      

   i = FindArg( RDATemplate, MainCMsg( MSG_OPTION_HELP_MAIN ) ); // -h option
   
   if (i >= 0 && argarray[i]) // != NULL)
      {
      print_usage( argv[0] );
      }      

   i = FindArg( RDATemplate, "?" ); // MSG_M_OPTION_QUES );    // -h option
   
   if (i >= 0 && argarray[i]) // != NULL)
      {
      print_usage( argv[0] );
      }      

   i = FindArg( RDATemplate, MainCMsg( MSG_OPTION_LOGO_MAIN ) ); // -i option
   
   if (i >= 0 && argarray[i]) // != NULL)
      {
      hailLogo = TRUE;
      }      

   i = FindArg( RDATemplate, MainCMsg( MSG_OPTION_SUMMARY_MAIN ) ); // -a option
   
   if (i >= 0 && argarray[i]) // != NULL)
      {
      prallocs = TRUE; 

      CheckMenuItem( MainCMsg( MSG_AM_PRALLOC_MENU_MAIN ), TRUE );
      }      

   i = FindArg( RDATemplate, MainCMsg( MSG_OPTION_LOADLIB_MAIN ) ); // -g option
   
   if (i >= 0 && argarray[i]) // != NULL)
      {
      sprintf( buffer, ")g %s\n", (char *) argarray[i] );
      count++;
      fputs( buffer, fd );
      }      

   i = FindArg( RDATemplate, MainCMsg( MSG_OPTION_LOADCMD_MAIN ) ); // -r option
   
   if (i >= 0 && argarray[i]) // != NULL)
      {
      sprintf( buffer, ")r %s\n", (char *) argarray[i] );
      count++;
      fputs( buffer, fd );
      }      

   i = FindArg( RDATemplate, MainCMsg( MSG_OPTION_DBGLVL_MAIN ) );
   
   if (i >= 0 && argarray[i]) // != NULL)
      {
      UBYTE *value = (UBYTE *) argarray[i];
      
      debug = atoi( (int *) value );
      
      switch (debug)
         {
         case 0:
         default:
            CheckMenuItem( MainCMsg( MSG_AM_DEBUG_MENU_MAIN ), FALSE );
            break;
            
         case 1:
            CheckMenuItem( MainCMsg( MSG_AM_DEBUG_MENU_MAIN ), TRUE );
            break;
         }
      }      

   i = FindArg( RDATemplate, MainCMsg( MSG_OPTION_PRTCMD_MAIN ) ); // -dX option
   
   if (i >= 0 && argarray[i]) // != NULL)
      {
      UBYTE *value = (UBYTE *) argarray[i];
      
      prntcmd = atoi( (int *) value );
      
      switch (prntcmd)
         {
         case 0:
            CheckMenuItem( MainCMsg( MSG_AM_REPORT0_MENU_MAIN ), TRUE );

            CheckMenuItem( MainCMsg( MSG_AM_REPORT1_MENU_MAIN ), FALSE );

            CheckMenuItem( MainCMsg( MSG_AM_REPORT2_MENU_MAIN ), FALSE );
            break;

         default:
         case 1:
            CheckMenuItem( MainCMsg( MSG_AM_REPORT1_MENU_MAIN ), TRUE );

            CheckMenuItem( MainCMsg( MSG_AM_REPORT0_MENU_MAIN ), FALSE );

            CheckMenuItem( MainCMsg( MSG_AM_REPORT2_MENU_MAIN ), FALSE );
            break;
            
         case 2:
            CheckMenuItem( MainCMsg( MSG_AM_REPORT2_MENU_MAIN ), TRUE );

            CheckMenuItem( MainCMsg( MSG_AM_REPORT0_MENU_MAIN ), FALSE );

            CheckMenuItem( MainCMsg( MSG_AM_REPORT1_MENU_MAIN ), FALSE );
            break;
         }
      }      

   i = FindArg( RDATemplate, MainCMsg( MSG_OPTION_NOSUMM_MAIN ) ); // -s option
   
   if (i >= 0 && argarray[i]) // != NULL)
      {
      silence = TRUE;

      CheckMenuItem( MainCMsg( MSG_AM_SILENCE_MENU_MAIN ), TRUE );
      }      

   i = FindArg( RDATemplate, MainCMsg( MSG_OPTION_NOSTAT_MAIN ) ); 
   
   if (i >= 0 && argarray[i]) // != NULL)
      {
      EnbStatus = FALSE;  

      CheckMenuItem( MainCMsg( MSG_AM_ENBSTAT_MENU_MAIN ), FALSE );
      }      

   i = FindArg( RDATemplate, MainCMsg( MSG_OPTION_CLASSES_MAIN ) );
   
   if (i >= 0 && argarray[i]) // != NULL)
      {
      sprintf( buffer, ")i %s\n", (char *) argarray[i] );
      count++;
      fputs( buffer, fd );
      }      

   FreeArgs( rdargs );
   FreeDosObject( DOS_RDARGS, allocdargs );

   return;   
}

#ifdef  __SASC
struct ProcID  disp_proc = { 0, };
struct FORKENV disp_env  = { 0, };

PRIVATE int SplashOut( void )
{
   IMPORT UBYTE *PubScreenName; // See Setup.c file. 

   char c1[512] = { 0, }, *logocmd  = &c1[0];
   char ln[512] = { 0, }, *logoname = &ln[0];
   
   int  rval = 0;

   StringCopy( logocmd, &CommandPath[0] );
   StringCat(  logocmd, &LogoCmd[0] );

   StringCopy( logoname, &CommandPath[0] );
   StringCat(  logoname, &LogoName[0]    );
/*
#  ifdef DEBUG   
   fprintf( stderr, "forkl( %s, %s,\n       %s, %s )\n", 
                     logocmd, logocmd, logoname, PubScreenName
          );
#  endif

   Since this is a SAS-C function, gcc will probably choke on it:
*/
   rval = forkl( logocmd, logocmd, logoname, PubScreenName, NULL, 
                 &disp_env, &disp_proc 
               );

/*
#  ifdef DEBUG   
   fprintf( stderr, "forkl() returned: %d\n", rval ); 
#  endif
*/
   return( rval );
}

PRIVATE struct Message goaway = { 0, };
    
/****h* AmigaTalk/KillLogo() ****************************************
*
* NAME
*    KillLogo()
*
* DESCRIPTION
*    Send a message to the DisplayLogo program to close its display.
*    This function is PUBLIC because ShutDown() (in Setup.c)
*    has to call it in order for the Screen to close.
*********************************************************************
*
*/    

PUBLIC void KillLogo( struct MsgPort *masterPort )
{
   PutMsg( disp_proc.child, &goaway );

   (void) wait( &disp_proc );

   hailLogo = FALSE; // Prevent a second closure in ShutDown().

   return;
}

#else

PRIVATE int SplashOut( void )
{
   IMPORT UBYTE *PubScreenName; // See Setup.c file. 

   char command[1024] = { 0, };
   char c1[512] = { 0, }, *logocmd  = &c1[0];
   char ln[256] = { 0, }, *logoname = &ln[0];
   
   int  rval = 0;

   StringCopy( logocmd, &CommandPath[0] );
   StringCat(  logocmd, &LogoCmd[0] );

   StringCopy( logoname, &CommandPath[0] );
   StringCat(  logoname, &LogoName[0]    );

   sprintf( command, "%s %s %s", logocmd, logoname, PubScreenName );

   rval = System( command, TAG_DONE );

/*
#  ifdef DEBUG   
   fprintf( stderr, "System() returned: %d\n", rval ); 
#  endif
*/
   return( rval );
}

/****h* AmigaTalk/KillLogo() ****************************************
*
* NAME
*    KillLogo()
*
* DESCRIPTION
*    Send a message whose contents are unimportant, to the DisplayLogo 
*    program to close its display.
*    This function is PUBLIC because ShutDown() (in Setup.c)
*    has to call it in order for the Screen to close.
*********************************************************************
*
*/    

PRIVATE struct Message goaway = { 0, };

PUBLIC void KillLogo( struct MsgPort *masterPort )
{
   struct MsgPort *logoPort = FindPort( "ATALK_DISPLAYLOGO" );

   if (logoPort)   
      PutMsg( logoPort, &goaway );

   hailLogo = FALSE; // Prevent a second closure in ShutDown().

   return;
}
#endif

/****h* spitOutAllocationData() [2.5] *******************************
*
* NAME
*    spitOutAllocationData()
*
* DESCRIPTION
*    Print out the amounts of memory AmigaTalk used.
*    This function is PUBLIC because ShutDown() (in Setup.c)
*    has to call it.
*********************************************************************
*
*/    

PUBLIC void spitOutAllocationData( void )
{
   fprintf( stderr, MainCMsg( MSG_FMT_ADRS_ALLC_MAIN ), 
                          ca_address, ca_address * ADDRESS_SIZE
          );

   fprintf( stderr, MainCMsg( MSG_FMT_INTS_ALLC_MAIN ), 
                          ca_int, ca_int * INTEGER_SIZE
          );

   fprintf( stderr, MainCMsg( MSG_FMT_FLTS_ALLC_MAIN ), 
                          ca_float, ca_float * FLOAT_SIZE
          );

   fprintf( stderr, MainCMsg( MSG_FMT_BLKS_ALLC_MAIN ), 
                          ca_block, ca_block * BLOCK_SIZE
          );

   fprintf( stderr, MainCMsg( MSG_FMT_BARY_ALLC_MAIN ), 
                          ca_barray, ca_barray * BYTEARRAY_SIZE
          );

   fprintf( stderr, MainCMsg( MSG_FMT_STRS_ALLC_MAIN ), 
                          ca_str, ca_str * STRING_SIZE
          );

   fprintf( stderr, MainCMsg( MSG_FMT_INTR_ALLC_MAIN ), 
                          ca_terp, ca_terp * INTERPRETER_SIZE
          );

   fprintf( stderr, MainCMsg( MSG_FMT_CLSS_ALLC_MAIN ), 
                          ca_class, ca_class * CLASS_SIZE
          );

   fprintf( stderr, MainCMsg( MSG_FMT_SYMS_ALLC_MAIN ), 
                          ca_sym, ca_sym * SYMBOL_SIZE
          );

   fprintf( stderr, MainCMsg( MSG_FMT_ENTR_ALLC_MAIN ), 
                          ca_cdict, ca_cdict * CLASS_ENTRY_SIZE
          );

   fprintf( stderr, MainCMsg( MSG_FMT_WALLOCS_MAIN ), ca_wal );
   fprintf( stderr, MainCMsg( MSG_FMT_WALLSZ_MAIN  ), ca_walSize );
   fprintf( stderr, MainCMsg( MSG_FMT_SYMSPC_MAIN  ), ca_symSpace );
   fprintf( stderr, MainCMsg( MSG_FMT_OBJS_ALLC_MAIN ), ca_obj, ca_objTotal );

   return;
}

/****h* cleanOutInterpreters() [2.5] *************************************
*
* NAME
*    cleanOutInterpreters()
*
* DESCRIPTION
*    freeVec the interpreterList & rebuild o_drive & the Process that
*    uses o_drive:
*
* HISTORY
*    04-Nov-2003 - Added the drv_init() call, which fixed this function!
**************************************************************************
*
*/

PUBLIC void cleanOutInterpreters( void )
{
//   SDBG( "Calling freeVecAllProcesses()...\n" );
   freeVecAllProcesses();
//   SDBG( "Calling freeVecAllInterpreters()...\n" );
   freeVecAllInterpreters();

//   SDBG( "Calling allocInterpPool()...\n" );
   if (!allocInterpPool( 0 )) // == NULL) // InterpreterTableSize
      {
      MemoryOut( "cleanOutInterpreters()" );
      
      fprintf( stderr, "Ran out of memory in cleanOutInterpreters()!\n" );
      
      cant_happen( NO_MEMORY );
      
      return;
      }
      
//   SDBG( "Calling drv_init()...\n" );
   drv_init(); // Needed for the reset() in Drive.c
         
   o_drive = AssignObj( (OBJECT *) cr_interpreter( (INTERPRETER *) 0,
                                                   null_object, 
                                                   null_object, 
                                                   null_object, 
                                                   null_object 
                                                 )
                      );

//   SDBG( "Calling init_process()...\n" );
   // First (& usually only) PROCESS gets setup: 
   init_process( (INTERPRETER *) o_drive );

   sprintf( outmsg, MainCMsg( MSG_CLEAN_MAIN ) );
   APrint( outmsg );

   ca_terp = 1; // Reset to the new count!

//   SDBG( "Exiting cleanOutInterpreters()...\n" );

   return;
}

SUBFUNC int initializeMemSpaces( void )
{
   int rval = RETURN_OK;

   BreakPointDBG( "initializeMemSpaces():", "Calling allocIntegerPool()..." );   
/*
   if (allocSymbolPool( 0 ) == NULL) // SymbolTableSize
      {
      rval = ERROR_NO_FREE_STORE;
      
      goto exitInitializeMemSpaces;
      }
*/
   if (!allocIntegerPool( 0 )) // == NULL) // IntegerTableSize
      {
      rval = ERROR_NO_FREE_STORE;
      
      goto exitInitializeMemSpaces;
      }

   BreakPointDBG( "initializeMemSpaces():", "Calling allocObjectPool()..." );   

   if (!allocObjectPool( 0 )) // == NULL)  // ObjectTableSize
      {
      rval = ERROR_NO_FREE_STORE;
      
      goto exitInitializeMemSpaces;
      }

   BreakPointDBG( "initializeMemSpaces():", "Calling allocClassEntryPool()..." );   
   // default # of classes = 25,000; ClassTableSize = 500,000
   if (!allocClassEntryPool( 0 )) // == NULL)  // ClassTableSize = #classes * 20
      {
      rval = ERROR_NO_FREE_STORE;
      
      goto exitInitializeMemSpaces;
      }

   BreakPointDBG( "initializeMemSpaces():", "Calling allocInterpPool()..." );   
   if (!allocInterpPool( 0 )) // == NULL) // InterpreterTableSize
      {
      rval = ERROR_NO_FREE_STORE;
      
      goto exitInitializeMemSpaces;
      }

   BreakPointDBG( "initializeMemSpaces():", "Calling allocByteArrayPool()..." );   
   if (!allocByteArrayPool( 0 )) // == NULL) // ByteArrayTableSize
      rval = ERROR_NO_FREE_STORE;

exitInitializeMemSpaces:

   return( rval );
}

SUBFUNC int setupInterpreter( void )
{
   int rval = RETURN_OK;
   
   BreakPointDBG( "setupInterpreter():", "Calling initializeMemSpaces()..." );   
   if (initializeMemSpaces() != RETURN_OK)
      {
      MemoryOut( "initializeMemSpaces()" );

      fprintf( stderr, "Ran out of memory in initializeMemspaces()!\n" );
               
      cant_happen( NO_MEMORY );
         
      return( ERROR_NO_FREE_STORE ); // Never reached
      }

   BreakPointDBG( "setupInterpreter():", "Calling int_init()..." );   
   int_init( "AmigaTalk:prelude/listFiles/Integers.list" ); // The only time this function gets called. 

   // sym_init() has been expanded to setup the x_tab[] array,
   // because the addresses of symbols were hard-coded into the
   // arrays:

   BreakPointDBG( "setupInterpreter():", "Calling sym_init()..." );   
   if (sym_init() < 0) // link symbol pointers into a list of symbols.
      {
      sprintf( ErrMsg, MainCMsg( MSG_FMT_PROBLEM_W_MAIN ), SymbolFile );

      UserInfo( ErrMsg, FATAL_ERROR );
       
      rval = ERROR_NO_FREE_STORE; 

      goto NoSymbols;
      }

   null_object = new_obj( (CLASS *) 0, 0, 0 ); // The first Object

   o_object    = AssignObj( null_object );

   // true is given a different object from others , so comparisons
   // work correctly 

   o_true        = AssignObj( new_obj( (CLASS *) 0, 0, 0 ) );

   o_false       = AssignObj( null_object );
   o_nil         = AssignObj( null_object );
   o_number      = AssignObj( null_object );
   o_magnitude   = AssignObj( null_object );
   o_empty       = AssignObj( null_object );
   o_smalltalk   = AssignObj( null_object );
   o_acollection = AssignObj( null_object );

   // We can't use the prelude/standard without these: -------------- 

   Array = (CLASS *) AssignObj( (OBJECT *) null_class( "ArrayBoot" )); // ARRAY_NAME ) );

   ArrayedCollection = (CLASS *) 
                        AssignObj( (OBJECT *) 
                                   null_class( ARRAYEDCOLL_NAME )
                                 );

   // ---------------------------------------------------------------
   BreakPointDBG( "setupInterpreter():", "Calling drv_init()..." );   
   drv_init();   // initialize the driver

   o_drive = AssignObj( (OBJECT *) cr_interpreter( (INTERPRETER *) 0,
                                                   null_object, 
                                                   null_object, 
                                                   null_object, 
                                                   null_object 
                                                 )
                      );

   BreakPointDBG( "setupInterpreter():", "Calling init_process()..." );   
   init_process( (INTERPRETER *) o_drive );

NoSymbols:

   return( rval );
}

SUBFUNC void cleanupInterpreter( void )
{
   OBJECT *tempobj = (OBJECT *) NULL;

   sprintf( outmsg, MainCMsg( MSG_CLEANUP_MAIN ) );
   APrint( outmsg );

   // print out one last newline - to move everything out of output queue
   tempobj = AssignObj( (OBJECT *) new_sym( NEWLINE_STR ) );

   (void) primitive( SYMPRINT, 1, &tempobj );
   (void) obj_dec( tempobj ); // Mark tempobj for deletion.

   // now free things up, hopefully keeping ref counts straight:

   while (o_IDCMP_rval->ref_count > 0)
      obj_dec( o_IDCMP_rval );         // Added on 04-Feb-2002

   drv_free();
   flush_processes();

   freeTheSymbols(); // In Symbol.c
   
   return;
}

/****h* SmallTalk() [1.9] ************************************************
*
* NAME
*    SmallTalk()
*
* DESCRIPTION
*    The Interpreter is started & continues until the User quits
*    the AmigaTalk program.
**************************************************************************
*
*/

PUBLIC int SmallTalk( int logoflag )
{
   IMPORT UBYTE  InitializeScript[ LARGE_TOOLSPACE ]; // AmigaTalk:c/InitializeCommands  
   IMPORT UBYTE  UpdateScript[     LARGE_TOOLSPACE ]; // AmigaTalk:c/UpdateCommands  

   struct MsgPort *ATPort;
   struct Process *ATProcess;

   BOOL saveFDEV = FDEV;
      
   ATProcess = (struct Process *) FindTask( 0L );
   ATPort    = &ATProcess->pr_MsgPort;

   if (started == FALSE)
      FDEV = FALSE;
      
   if (fastload != FALSE) 
      dofast();
   else 
      {         
      // gotta do it the hard way:
      sprintf( outmsg, MainCMsg( MSG_FMT_VERSION_MAIN ), &PgmName[0], Version );

      APrint( outmsg );

      sprintf( outmsg, MainCMsg( MSG_FMT_INITING_MAIN ), &PgmName[0] );
      APrint( outmsg );

      BreakPointDBG( "SmallTalk():", "Calling setupInterpreter()..." );   
      if (setupInterpreter() != RETURN_OK)
         goto NoSymbolAbort;

      BreakPointDBG( "SmallTalk():", "Calling ReadPreludes()..." );   
      ReadPreludes( noload ); // read in Class definitions!

      // then set lexer up to read stdin
      set_file( stdin );

      o_tab = AssignObj( new_str( "\t" ) );
      }
   
   // Added on 31-Jan-2002: --------------------------------------------
   sprintf( outmsg, MainCMsg( MSG_INITCLASSES_MAIN ) );
   APrint( outmsg );

   if (logoflag == FALSE)
      KillLogo( NULL ); // ATPort ); Remove the Startup Logo ILBM window.

//   SDBG( "SmallTalk(): Calling cleanOutInterpreters()...\n" );
   cleanOutInterpreters( ); // Kill old Interpreters & re-make o_drive Process

   // Run the script that initializes some Singleton classes (or whatever): //What's overwriting the tooltypes??
//   FDBG( fprintf( stderr, "SmallTalk(): Calling ExecuteExternalScript( %s )...\n", InitializeScript ) );
   ExecuteExternalScript( &InitializeScript[0] );

   sprintf( outmsg, MainCMsg( MSG_FMT_WELCOME_MAIN ), &PgmName[0] );
   APrint( outmsg );

   started = TRUE;
   FDEV    = saveFDEV;

   o_IDCMP_rval = new_array( 5, FALSE ); // Used by HandleGT_IDCMP() in GadTools.c
   o_IDCMP_rval->ref_count++;

//   SDBG( "SmallTalk(): Calling ActivateWindow()...\n" );

   (void) ActivateWindow( ATWnd );

   // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   
//   SDBG( "SmallTalk(): Calling start-execution()...\n" );
   (void) start_execution( FALSE ); // Here's where we stay, until done!
//   SDBG( "SmallTalk(): preparing to Shutdown...\n" );
   
   // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

   // ----------- Starting to ShutDown: --------------------------------

   if (OpenStatusWindow( Scr->Height ) < 0)
      {
      fprintf( stderr, MainCMsg( MSG_NOT_REOPEN_STAT_MAIN ) );
      return -3;
      }

   sprintf( outmsg, MainCMsg( MSG_UPDATE_BRWSR_MAIN ) );
   APrint( outmsg );

   // Run the script that updates theBrowser support files: 
   ExecuteExternalScript( &UpdateScript[0] );

   sprintf( outmsg, MainCMsg( MSG_WRITE_NEWSYMS_MAIN ), SymbolFile );
   APrint( outmsg );

   if (WriteSymbolFile() < 0)
      {
      sprintf( outmsg, MainCMsg( MSG_FMT_SYMERR_MAIN ), SymbolFile );
      APrint( outmsg );

      fprintf( stderr, "%s", outmsg );
      }

   // ------------------------------------------------------------------

   cleanupInterpreter();

NoSymbolAbort:  // Couldn't find the symbols string file!!

   clean_files();

   // This will have be sped up somehow:
   (void) freeSlackMemorySpaces(); // Before Shutdown(), this has to be done!

/*
   sprintf( outmsg, "\n\t\t\tPress any key to finish: " );
   APrint( outmsg );

   i = ConGetc( st_console ); // Why doesn't ConGetc() work?
*/

   CloseStatusWindow();

   return( RETURN_OK );
}

/****i* SetDefaultScreenModeID() [2.2] *********************************
*
* NAME
*    SetDefaultScreenModeID()
*
* DESCRIPTION
*    Convert the ToolType ScreenMode_ID to a long integer & store
*    it in ATScreenModeID.
************************************************************************
*
*/

PRIVATE void SetDefaultScreenModeID( void )
{
#  ifdef __SASC
   if (ScreenMode_ID[0] == ZERO_CHAR && ScreenMode_ID[1] == SMALL_X_CHAR)
      (void) stch_l( &ScreenMode_ID[2], (long *) &ATScreenModeID ); 
   else if (ScreenMode_ID[0] == DOLLAR_CHAR)
      (void) stch_l( &ScreenMode_ID[1], (long *) &ATScreenModeID );
#  else
   char *end = NULL;
   
   if (ScreenMode_ID[0] == ZERO_CHAR && ScreenMode_ID[1] == SMALL_X_CHAR)
      ATScreenModeID = strtoul( &ScreenMode_ID[2], &end, 16 );
   else if (ScreenMode_ID[0] == DOLLAR_CHAR)
      ATScreenModeID = strtoul( &ScreenMode_ID[1], &end, 16 );
#  endif
   else
      ATScreenModeID = DEFAULTSCREENMODEID;

   return;
}
    
SUBFUNC ULONG CheckMemSpaceAvailable( ULONG desiredSize )
{
#  ifdef  __SASC
   IMPORT struct ExecBase *SysBase; // Setup by SAS-C  
#  endif
    
   ULONG chipmem = 0L;
   ULONG fastmem = 0L;
   ULONG rval    = 0L;
   
   fastmem = AvailMem( MEMF_FAST ); // exec.library function
   chipmem = AvailMem( MEMF_CHIP );
      
   if (desiredSize < fastmem)
      {
      rval = fastmem;
      
      goto exitCheck;
      }
   else if (desiredSize < (fastmem + chipmem))
      {
      rval = fastmem + chipmem;
      
      goto exitCheck;
      }
   else
      rval = fastmem; // User will have to okay continuation.
            
exitCheck:

   return( rval );
}

PRIVATE void closeIconBase( void )
{
#  ifdef __amigaos4__
   if (IIcon)
      DropInterface( (struct Interface *) IIcon );
#  endif

   if (IconBase)
      CloseLibrary( IconBase );

   return;
}

PRIVATE int openIconBase( BOOL *useDefaults )
{
#  ifdef __amigaos4__
   ULONG libVersion = 50L;
#  else
   ULONG libVersion = 39L;
#  endif
   int   rval       = RETURN_OK;
   
   if ((IconBase = OpenLibrary( "icon.library", libVersion ))) // == NULL)
      {
#     ifdef __amigaos4__
      if (!(IIcon = (struct IconIFace *) GetInterface( IconBase, "main", 1, NULL )))
         {
	 CloseLibrary( IconBase );
         IconBase = NULL;
	   	 
         NotOpened( 4 ); 

         fprintf( stderr, "IIcon.IFace did NOT open!\n" ); // MainCMsg( MSG_NO_ICONLIB_MAIN ) );

         *useDefaults = TRUE;
 	  rval        = ERROR_INVALID_RESIDENT_LIBRARY;
         }
      else	 
#     endif
         *useDefaults = FALSE; // Let slip the icons of War!!
      }
   else
      {
      NotOpened( 4 ); 

      fprintf( stderr, MainCMsg( MSG_NO_ICONLIB_MAIN ) );

      *useDefaults = TRUE;
       rval        = ERROR_INVALID_RESIDENT_LIBRARY;
      }

   return( rval );
}

PRIVATE void initializeEnvironment( BOOL *UseDefaultTools )
{
   SetDefaultScreenModeID(); // ATScreenModeID <-- ScreenMode_ID ToolType

   ScreenMode_ID[0] = '0'; // Update the ScreenMode_ID ToolType.
   ScreenMode_ID[1] = 'x';

#  ifdef  __SASC
   (void) stcl_h( &ScreenMode_ID[2], ATScreenModeID );
#  else     // __amigaos4__
   (void) longToHexStr( &ScreenMode_ID[2], ATScreenModeID ); // sprintf( ScreenMode_ID, "0x%08LX", ATScreenModeID );
#  endif

   if (*UseDefaultTools == TRUE)
      {
      SetupDefaultTools();      // No icon.library was opened.

      ATScreenModeID = DEFAULTSCREENMODEID;

#     ifdef __amigaos4__
      StringCopy( &ScreenMode_ID[0], "0x50031100" ); // Update the ScreenMode_ID ToolType.
#     else // Use CyberGraphics ScreenModeID:
      StringCopy( &ScreenMode_ID[0], "0x40D20001" ); // Update the ScreenMode_ID ToolType.
#     endif
      }

   return;
}
     
PRIVATE int initializeProgram( int argc, char *argv[], BOOL *UseDefaultTools )
{
   struct WBArg *wbarg = NULL;
   void         *rchk  = NULL;
   int           rval  = RETURN_OK;

   if ((rval = firstSetup()) != RETURN_OK)
      {
      // Catalog or Library did NOT open!
      ShutDown();
         
      return( rval );
      }

   if (argc >= 1)  
      {                        // From the CLI:
      StringNCopy( &PgmName[0], argv[0], 80 );

      fprintf( stderr, MainCMsg( MSG_FMT_STARTUPMSG_MAIN ), &PgmName[0], Version );

      // We prefer to use the ToolTypes! 
      rchk = FindIcon( &processToolTypes, diskobj, argv[0] ); 

      if (!rchk) // == NULL
         SetupDefaultTools();  // Dopey user doesn't have the icon.
      }
   else // From Workbench:
      {
#     ifndef __amigaos4__
      wbarg = &( WBenchMsg->sm_ArgList[ WBenchMsg->sm_NumArgs - 1 ] );
#     else
      wbarg = &( __WBenchMsg->sm_ArgList[ __WBenchMsg->sm_NumArgs - 1 ] );
#     endif         

      StringNCopy( &PgmName[0], wbarg->wa_Name, 80 );

      // We prefer to use the ToolTypes! 
      rchk = FindIcon( &processToolTypes, diskobj, wbarg->wa_Name ); // argv[0] ); 

      if (!rchk) // == NULL
         SetupDefaultTools();  // Dopey user doesn't have the icon.
      }

   return( rval );
}

PUBLIC int main( int argc, char *argv[] )
{
   int   dispflag            = -1;
   int   rval                = RETURN_OK;
   ULONG memSizeNeeded       = 0L;
   BOOL  useDefaultTools     = FALSE;
   BOOL  haveToCloseIconBase = FALSE;
   
   SetupDefaultTools(); // Located in Tools.c

   if (argc > 1)
      {
      if (StringComp( argv[1], "-FDEV" ) == 0)
         FDEV = TRUE;
      }

   if (!IconBase)
      {
      SDBG( "Going to have to open icon.library in main():\n" );
      if (openIconBase( &useDefaultTools ) != RETURN_OK)
         {
         SDBG( "icon.library or IIcon.IFace did NOT open!\n" );  
	 haveToCloseIconBase = FALSE;
         initializeEnvironment( &useDefaultTools );
         }
      else
         {
	 haveToCloseIconBase = TRUE;
         rval                = initializeProgram( argc, argv, &useDefaultTools );

         initializeEnvironment( &useDefaultTools );
	 }
      }
   else
      {
      haveToCloseIconBase = FALSE;
      rval                = initializeProgram( argc, argv, &useDefaultTools );

      initializeEnvironment( &useDefaultTools );
      }

   if (haveToCloseIconBase == TRUE)
      closeIconBase();

   if (InitATalk() != RETURN_OK)
      {
      if (ATWnd) // != NULL)
         {
         SetNotifyWindow( ATWnd );

         UserInfo( MainCMsg( MSG_CHECKSYSTEM_MAIN ), MainCMsg( MSG_LASTMESSAGE1_MAIN ) );
         }
      else
         {
         fprintf( stderr, MainCMsg( MSG_LASTMESSAGE2_MAIN ) );
         }
      
      return( RETURN_ERROR );
      }

//   SDBG( "Ready to ProcessArgs() if any...\n" ); 
   if (argc > 0)
      ProcessArgs( argc, argv ); // Has to be after InitATalk().

   SetNotifyWindow( ATWnd );

   if (hailLogo > 0)
      {
      Delay( 10 ); // wait for Screen???

//#     ifdef DEBUG
//      fprintf( stderr, MainCMsg( MSG_M_CALL_SPLASH, MSG_M_CALL_SPLASH_STR ) );
//#     endif

      dispflag = SplashOut();
      }

//   SDBG( "Computing memSizeNeeded...\n" ); 

   memSizeNeeded = ObjectTableSize + ByteArrayTableSize + IntegerTableSize
                   + InterpreterTableSize + SymbolTableSize;
                   
   if (memSizeNeeded > 0)
      {
      ULONG chk = CheckMemSpaceAvailable( memSizeNeeded );
      
      if (chk < memSizeNeeded)
         {
         int ans = 0;

         SetReqButtons( MainCMsg( MSG_DEFAULT_BUTTONS ) );
          
         sprintf( ErrMsg, MainCMsg( MSG_FMT_MEM_CHECK_MAIN ), chk, memSizeNeeded );

         ans = Handle_Problem( ErrMsg, MainCMsg( MSG_RQTITLE_ATALK_PROBLEM_MAIN ), NULL );
         if (ans != 0)
            goto exitTheProgram; // User selected ABORT!
         }
      }

   if (OpenStatusWindow( Scr->Height ) < 0)
      {
      NotOpened( 6 );

      rval = ERROR_ON_OPENING_WINDOW;
      
      goto exitTheProgram;
      }

//   SDBG( "Ready to call SmallTalk()...\n" ); 
      
   rval = SmallTalk( dispflag ); // Setup & run the Interpreter!

exitTheProgram:

   ShutDown();       // The only Normal exit point!!

   return( rval );
}

/* ----------------- END of main.c file -------------------- */
