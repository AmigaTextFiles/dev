/****h* AmigaTalk/ATMenus.c [3.0] **********************************
*
* NAME
*    ATMenus.c
*
* DESCRIPTION
*    This file contains the structures & functions that define
*    the Menus & control of the main program window ATWnd.
*
* FUNCTIONAL INTERFACE:
*    PUBLIC void CheckMenuItem( char *, BOOL );
*
*    PUBLIC int ATHelpProgram( void );
*
*    IMPORT int HandleBrowser() in ATalkBrowser.c file.
*
* HISTORY
*    31-Dec-2004 - Added Palette menu item.
*
*    24-Oct-2004 - Added AmigaOS4 & gcc support.
*
*    25-Dec-2003 - Added CheckMenuItem() for ProcessArgs() to use.
*
*    27-Nov-2003 - Added settings for InitialDrawer & TitleText
*                  for all MenuItems that use ASL File Requesters.
*
*    17-Nov-2003 - Fixed the Trace MenuItem so that it tracks the
*                  state of the CHECKED Flag.
*
*    03-Oct-2003 - Added USER SCRIPTS Menu space.
*
* NOTES
*    $VER: AmigaTalk:Src/ATMenus.c 3.0 (24-Oct-2004) by J.T. Steichen
********************************************************************
*
*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>               // for abs() macro.
 
#include <exec/types.h>
#include <exec/memory.h>

#include <AmigaDOSErrs.h>

#include <intuition/intuitionbase.h>
#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/gadgetclass.h>

#include <libraries/gadtools.h>
#include <libraries/asl.h>

#include <utility/tagitem.h>

#ifdef __SASC

# include <clib/exec_protos.h>
# include <clib/intuition_protos.h>
# include <clib/gadtools_protos.h>
# include <clib/graphics_protos.h>
# include <clib/utility_protos.h>
# include <clib/diskfont_protos.h>

IMPORT struct Library *GadToolsBase;

#else

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/intuition.h>
# include <proto/gadtools.h>
# include <proto/graphics.h>
# include <proto/utility.h>
# include <proto/diskfont.h>

IMPORT struct Library       *GadToolsBase;
IMPORT struct GadToolsIFace *IGadTools;

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h" 

#include "FuncProtos.h"

#include "IStructs.h"
#include "Constants.h"

#include "StringConstants.h"
#include "StringIndexes.h"

IMPORT struct Screen  *Scr;
IMPORT struct Window  *ATWnd;
IMPORT struct Gadget  *ATGadgets[];
IMPORT struct List     PgmList;
IMPORT APTR            VisualInfo;
IMPORT char           *PgmItemBuffer;
IMPORT int             PgmLineNumber;

IMPORT UBYTE          *AaarrggButton;
IMPORT UBYTE          *DefaultButtons;
IMPORT UBYTE          *UserProblem;

IMPORT void CloseATWindow( void );

IMPORT void Trace( struct Window *parent ); // For the Examine menu item.


IMPORT int EnbStatus; // -b Set to FALSE for no status window.
IMPORT int silence;   // -s 1 if silence is desired on output.
IMPORT int prallocs;  // -a 1 if printing final alloc figures is wanted.
IMPORT int lexprnt;   // -z 1 if printing during lex is desired.
IMPORT int debug;     //      debug flag, set by a primitive call.
IMPORT int prntcmd;   // -d 0 to 2.

IMPORT UBYTE *ErrMsg;

// -----------------------------------------------------------------

PUBLIC UBYTE *ATFileProblem = NULL; // AM_FILEPROBLEM; Visible to CatalogATMenus()
PUBLIC STRPTR Report0Str    = NULL; // AM_REPORT0;     Visible to CatalogATMenus()
PUBLIC STRPTR Report1Str    = NULL; // AM_REPORT1;     Visible to CatalogATMenus()
PUBLIC STRPTR Report2Str    = NULL; // AM_REPORT2;     Visible to CatalogATMenus()

// -----------------------------------------------------------------

PUBLIC UBYTE ami[MENU_LENGTH] = { 0, }, *MenuScriptName     = &ami[0]; // Used in UserScriptReq.c
PUBLIC UBYTE amf[ BUFLENGTH ] = { 0, }, *MenuScriptFileName = &amf[0];

PUBLIC struct Menu *ATMenus = NULL;


IMPORT void ShowSystemDirectives( void ); // In Main.c file.

PUBLIC int ATHelpProgram(    void );
PUBLIC int ATLoadProgram(    void );
PUBLIC int ATIncludeClass(   void );
PUBLIC int ATSaveProgram(    void );
PUBLIC int ATSaveAsProgram(  void );
PUBLIC int ATSetPalette(     void );

PUBLIC int ATQuitAmigaTalk(  void );

PUBLIC int ATAddUserScript(    void ); // Added on 03-Oct-2003
PUBLIC int ATRemoveUserScript( void );

PUBLIC int ATAboutAmigaTalk( void );
PUBLIC int ATOpenBrowser(    void );
PUBLIC int ATEditFile(       void );

PRIVATE int ATEnbStatusMI(    void );
PRIVATE int ATSilenceMI(      void );
PRIVATE int ATPrAllocsMI(     void );
PRIVATE int ATLexPrntMI(      void );
PRIVATE int ATDebugMI(        void );
PRIVATE int ATTraceMI(        void );
PRIVATE int ATExamineMI(      void );

PRIVATE int ATReportLevel0(   void ); // prntcmd = 0.
PRIVATE int ATReportLevel1(   void ); // prntcmd = 1.
PRIVATE int ATReportLevel2(   void ); // prntcmd = 2.

PRIVATE int ATSystemDirectivesMI( void ); // f1

PUBLIC struct NewMenu ATNewMenu[] = { // Visible to CatalogATMenus()

   NM_TITLE, "PROJECT", NULL, 0, 0L, NULL,

    NM_ITEM, "Load Commands File...", NULL, 0, 0L, (APTR) ATLoadProgram,

    NM_ITEM, "Load Class Source File...", NULL, 0, 0L, (APTR) ATIncludeClass,

    NM_ITEM, "Save", NULL, 0, 0L, (APTR) ATSaveProgram,

    NM_ITEM, "Save As...", NULL, 0, 0L, (APTR) ATSaveAsProgram,

    NM_ITEM, "Set Palette...", "P", 0, 0L, (APTR) ATSetPalette,

    NM_ITEM, "Quit", NULL, 0, 0L, (APTR) ATQuitAmigaTalk,

    // --------------------------------------------------------------
    NM_ITEM, (STRPTR) NM_BARLABEL, NULL, 0, 0L, NULL, // #7

    NM_ITEM, "Add User Script..",    "U", 0, 0L, (APTR) ATAddUserScript,

    NM_ITEM, "Remove User Script..", "R", 0, 0L, (APTR) ATRemoveUserScript,
    
    // --------------------------------------------------------------
    NM_ITEM, (STRPTR) NM_BARLABEL, NULL, 0, 0L, NULL, // #10

    NM_ITEM, "About...", NULL, 0, 0L, (APTR) ATAboutAmigaTalk,

    NM_ITEM, "Help...", NULL, 0, 0L, (APTR) ATHelpProgram,

    NM_ITEM, "System Directives... f1", NULL, 0, 0L, (APTR) ATSystemDirectivesMI,

    // --------------------------------------------------------------
    NM_ITEM, (STRPTR) NM_BARLABEL, NULL, 0, 0L, NULL, // #14

    NM_ITEM, "Open Browser...", NULL, 0, 0L, (APTR) ATOpenBrowser,

    NM_ITEM, "Edit a file...", NULL, 0, 0L, (APTR) ATEditFile,

   NM_TITLE, "BEHAVIOR", NULL, 0, 0L, NULL,

    NM_ITEM, "Report Level >>", NULL, 0, 0L, NULL,              // #18

      NM_SUB, "Requested Results only! (PRNTCMD=0)", NULL, CHECKIT | MENUTOGGLE, 0L, (APTR) ATReportLevel0,
      
      NM_SUB, "Results of Expressions (Default)!", NULL, CHECKED | CHECKIT | MENUTOGGLE, 0L, (APTR) ATReportLevel1,
      
      NM_SUB, "ALL Results! (PRNTCMD=2)", NULL, CHECKIT | MENUTOGGLE, 0L, (APTR) ATReportLevel2,
      
    NM_ITEM, "Debug", NULL, CHECKIT | MENUTOGGLE, 0L, (APTR) ATDebugMI, // #22

    NM_ITEM, "Examiner..", NULL, 0L, 0L, (APTR) ATExamineMI,

    NM_ITEM, "Trace..", NULL, CHECKIT | MENUTOGGLE, 0L, (APTR) ATTraceMI,

    NM_ITEM, "LeX print", NULL, CHECKIT | MENUTOGGLE, 0L, (APTR) ATLexPrntMI,

    NM_ITEM, "silence", NULL, CHECKIT | MENUTOGGLE, 0L, (APTR) ATSilenceMI, // #26

    NM_ITEM, "prallocs", NULL, CHECKIT | MENUTOGGLE, 0L, (APTR) ATPrAllocsMI,

    NM_ITEM, "EnbStatus", NULL, CHECKIT | CHECKED | MENUTOGGLE, 0L, (APTR) ATEnbStatusMI,

   NM_TITLE, "USER SCRIPTS", NULL, 0, 0L, NULL, // #29

    NM_IGNORE, "Blank", NULL, 0L, 0L, NULL, // Space for User Script calls.
    NM_IGNORE, "Blank", NULL, 0L, 0L, NULL,
    NM_IGNORE, "Blank", NULL, 0L, 0L, NULL,
    NM_IGNORE, "Blank", NULL, 0L, 0L, NULL,
    NM_IGNORE, "Blank", NULL, 0L, 0L, NULL,
    NM_IGNORE, "Blank", NULL, 0L, 0L, NULL,
    NM_IGNORE, "Blank", NULL, 0L, 0L, NULL,
    NM_IGNORE, "Blank", NULL, 0L, 0L, NULL,
    NM_IGNORE, "Blank", NULL, 0L, 0L, NULL,
    NM_IGNORE, "Blank", NULL, 0L, 0L, NULL,
    NM_IGNORE, "Blank", NULL, 0L, 0L, NULL,
    NM_IGNORE, "Blank", NULL, 0L, 0L, NULL,
    NM_IGNORE, "Blank", NULL, 0L, 0L, NULL,
    NM_IGNORE, "Blank", NULL, 0L, 0L, NULL,
    NM_IGNORE, "Blank", NULL, 0L, 0L, NULL,
    NM_IGNORE, "Blank", NULL, 0L, 0L, NULL,
    NM_IGNORE, "Blank", NULL, 0L, 0L, NULL,
    NM_IGNORE, "Blank", NULL, 0L, 0L, NULL,
    NM_IGNORE, "Blank", NULL, 0L, 0L, NULL,
    NM_IGNORE, "Blank", NULL, 0L, 0L, NULL,
    NM_IGNORE, "Blank", NULL, 0L, 0L, NULL,
    NM_IGNORE, "Blank", NULL, 0L, 0L, NULL,
    NM_IGNORE, "Blank", NULL, 0L, 0L, NULL,
    NM_IGNORE, "Blank", NULL, 0L, 0L, NULL,
    NM_IGNORE, "Blank", NULL, 0L, 0L, NULL,
    NM_IGNORE, "Blank", NULL, 0L, 0L, NULL,
    NM_IGNORE, "Blank", NULL, 0L, 0L, NULL,
    NM_IGNORE, "Blank", NULL, 0L, 0L, NULL,
    NM_IGNORE, "Blank", NULL, 0L, 0L, NULL,
    NM_IGNORE, "Blank", NULL, 0L, 0L, NULL,

   NM_END,   NULL, NULL, 0, 0L, NULL 
};

#define FIRST_SCRIPT 30 // Change this if more menu items are added!!

PUBLIC char fnclf[BUFLENGTH] = { 0, }, *CurrentLoadFile = &fnclf[0];

IMPORT void AddToPgmLV( char *string ); // ATGadgets.c file.

// -------- Functions: ------------------------------------------------

SUBFUNC int UserScript29( void );
SUBFUNC int UserScript30( void );
SUBFUNC int UserScript31( void );
SUBFUNC int UserScript32( void );
SUBFUNC int UserScript33( void );
SUBFUNC int UserScript34( void );
SUBFUNC int UserScript35( void );
SUBFUNC int UserScript36( void );
SUBFUNC int UserScript37( void );
SUBFUNC int UserScript38( void );
SUBFUNC int UserScript39( void );
SUBFUNC int UserScript40( void );
SUBFUNC int UserScript41( void );
SUBFUNC int UserScript42( void );
SUBFUNC int UserScript43( void );
SUBFUNC int UserScript44( void );
SUBFUNC int UserScript45( void );
SUBFUNC int UserScript46( void );
SUBFUNC int UserScript47( void );
SUBFUNC int UserScript48( void );
SUBFUNC int UserScript49( void );
SUBFUNC int UserScript50( void );
SUBFUNC int UserScript51( void );
SUBFUNC int UserScript52( void );
SUBFUNC int UserScript53( void );
SUBFUNC int UserScript54( void );
SUBFUNC int UserScript55( void );
SUBFUNC int UserScript56( void );
SUBFUNC int UserScript57( void );
SUBFUNC int UserScript58( void );
SUBFUNC int UserScript59( void );

typedef int (*SCRIPT)( void );

PRIVATE struct userScripts {
   
   SCRIPT  us_UserFunction; 
   char   *us_FileName;

}  UserScripts[] = { 
    
     UserScript29, NULL,
     UserScript30, NULL,
     UserScript31, NULL,
     UserScript32, NULL,
     UserScript33, NULL,
     UserScript34, NULL,
     UserScript35, NULL,
     UserScript36, NULL,
     UserScript37, NULL,
     UserScript38, NULL,
     UserScript39, NULL,
     UserScript40, NULL,
     UserScript41, NULL,
     UserScript42, NULL,
     UserScript43, NULL,
     UserScript44, NULL,
     UserScript45, NULL,
     UserScript46, NULL,
     UserScript47, NULL,
     UserScript48, NULL,
     UserScript49, NULL,
     UserScript50, NULL,
     UserScript51, NULL,
     UserScript52, NULL,
     UserScript53, NULL,
     UserScript54, NULL,
     UserScript55, NULL,
     UserScript56, NULL,
     UserScript57, NULL,
     UserScript58, NULL,
     UserScript59, NULL,
     NULL,         NULL,
};

// Jump points from User Menu Items to ExecuteExternalScript():

SUBFUNC int UserScript29( void )
{
   ExecuteExternalScript( UserScripts[ 0 ].us_FileName );

   return( TRUE );
}

SUBFUNC int UserScript30( void )
{
   ExecuteExternalScript( UserScripts[ 1 ].us_FileName );

   return( TRUE );
}

SUBFUNC int UserScript31( void )
{
   ExecuteExternalScript( UserScripts[ 2 ].us_FileName );

   return( TRUE );
}

SUBFUNC int UserScript32( void )
{
   ExecuteExternalScript( UserScripts[ 3 ].us_FileName );

   return( TRUE );
}

SUBFUNC int UserScript33( void )
{
   ExecuteExternalScript( UserScripts[ 4 ].us_FileName );

   return( TRUE );
}

SUBFUNC int UserScript34( void )
{
   ExecuteExternalScript( UserScripts[ 5 ].us_FileName );

   return( TRUE );
}

SUBFUNC int UserScript35( void )
{
   ExecuteExternalScript( UserScripts[ 6 ].us_FileName );

   return( TRUE );
}

SUBFUNC int UserScript36( void )
{
   ExecuteExternalScript( UserScripts[ 7 ].us_FileName );

   return( TRUE );
}

SUBFUNC int UserScript37( void )
{
   ExecuteExternalScript( UserScripts[ 8 ].us_FileName );

   return( TRUE );
}

SUBFUNC int UserScript38( void )
{
   ExecuteExternalScript( UserScripts[ 9 ].us_FileName );

   return( TRUE );
}

SUBFUNC int UserScript39( void )
{
   ExecuteExternalScript( UserScripts[ 10 ].us_FileName );

   return( TRUE );
}

SUBFUNC int UserScript40( void )
{
   ExecuteExternalScript( UserScripts[ 11 ].us_FileName );

   return( TRUE );
}

SUBFUNC int UserScript41( void )
{
   ExecuteExternalScript( UserScripts[ 12 ].us_FileName );

   return( TRUE );
}

SUBFUNC int UserScript42( void )
{
   ExecuteExternalScript( UserScripts[ 13 ].us_FileName );

   return( TRUE );
}

SUBFUNC int UserScript43( void )
{
   ExecuteExternalScript( UserScripts[ 14 ].us_FileName );

   return( TRUE );
}

SUBFUNC int UserScript44( void )
{
   ExecuteExternalScript( UserScripts[ 15 ].us_FileName );

   return( TRUE );
}

SUBFUNC int UserScript45( void )
{
   ExecuteExternalScript( UserScripts[ 16 ].us_FileName );

   return( TRUE );
}

SUBFUNC int UserScript46( void )
{
   ExecuteExternalScript( UserScripts[ 17 ].us_FileName );

   return( TRUE );
}

SUBFUNC int UserScript47( void )
{
   ExecuteExternalScript( UserScripts[ 18 ].us_FileName );

   return( TRUE );
}

SUBFUNC int UserScript48( void )
{
   ExecuteExternalScript( UserScripts[ 19 ].us_FileName );

   return( TRUE );
}

SUBFUNC int UserScript49( void )
{
   ExecuteExternalScript( UserScripts[ 20 ].us_FileName );

   return( TRUE );
}

SUBFUNC int UserScript50( void )
{
   ExecuteExternalScript( UserScripts[ 21 ].us_FileName );

   return( TRUE );
}

SUBFUNC int UserScript51( void )
{
   ExecuteExternalScript( UserScripts[ 22 ].us_FileName );

   return( TRUE );
}

SUBFUNC int UserScript52( void )
{
   ExecuteExternalScript( UserScripts[ 23 ].us_FileName );

   return( TRUE );
}

SUBFUNC int UserScript53( void )
{
   ExecuteExternalScript( UserScripts[ 24 ].us_FileName );

   return( TRUE );
}

SUBFUNC int UserScript54( void )
{
   ExecuteExternalScript( UserScripts[ 25 ].us_FileName );

   return( TRUE );
}

SUBFUNC int UserScript55( void )
{
   ExecuteExternalScript( UserScripts[ 26 ].us_FileName );

   return( TRUE );
}

SUBFUNC int UserScript56( void )
{
   ExecuteExternalScript( UserScripts[ 27 ].us_FileName );

   return( TRUE );
}

SUBFUNC int UserScript57( void )
{
   ExecuteExternalScript( UserScripts[ 28 ].us_FileName );

   return( TRUE );
}

SUBFUNC int UserScript58( void )
{
   ExecuteExternalScript( UserScripts[ FIRST_SCRIPT ].us_FileName );

   return( TRUE );
}

SUBFUNC int UserScript59( void )
{
   ExecuteExternalScript( UserScripts[ 30 ].us_FileName );

   return( TRUE );
}

/****i* AddItemMI() [2.5] *********************************************
*
* NAME
*    AddItemMI()
*
* DESCRIPTION
*    Add a Script menu item to the USER SCRIPTS Menu Title.
*    Called by ATAddUserScript() only!
***********************************************************************
*
*/

SUBFUNC int AddItemMI( char *menu, char *file )
{
   int i = 0;
   
   ClearMenuStrip( ATWnd );

   while ((ATNewMenu[i].nm_Type != NM_IGNORE) && (ATNewMenu[i].nm_Type != NM_END))
      i++; // 29 through 60 are NM_IGNORE

   if (ATNewMenu[i].nm_Type != NM_END)
      {
      char *fileSpace = NULL, *menuSpace = NULL;

      if (!(fileSpace = (char *) AllocVec( BUFLENGTH * sizeof( char ), 
                                     MEMF_CLEAR | MEMF_ANY ))) // == NULL)
         {
         int ans = 0;
         
         SetReqButtons( MenuCMsg( MSG_DEFAULT_BUTTONS ) );

         ans = Handle_Problem( MenuCMsg( MSG_AH_MEMORYOUT_MENU ), 
                               MenuCMsg( MSG_RQTITLE_SYSTEM_PROBLEM_MENU ), NULL 
                             );
         if (ans == 0)
            goto ReattachMenus;
         else 
            return( FALSE );
         }
      else
         {
         StringNCopy( fileSpace, file, BUFLENGTH );
         
         UserScripts[ i - FIRST_SCRIPT ].us_FileName = fileSpace;
         }
            
      if (!(menuSpace = (char *) AllocVec( MENU_LENGTH * sizeof( char ), 
                                           MEMF_CLEAR | MEMF_ANY ))) // == NULL)
         {
         int ans = 0;
         
         SetReqButtons( MenuCMsg( MSG_DEFAULT_BUTTONS ) );

         ans = Handle_Problem( MenuCMsg( MSG_AH_MEMORYOUT_MENU ), 
                               MenuCMsg( MSG_RQTITLE_SYSTEM_PROBLEM_MENU ), NULL 
                             );
                             
         FreeVec( fileSpace ); // No matter what the answer, Free this!

         if (ans == 0)
            goto ReattachMenus;
         else 
            return( FALSE );
         }
      else
         StringNCopy( menuSpace, menu, MENU_LENGTH );
            
      ATNewMenu[i].nm_Type     = NM_ITEM;
      ATNewMenu[i].nm_Label    = (UBYTE *) menuSpace;
      ATNewMenu[i].nm_UserData = (APTR) UserScripts[ i - FIRST_SCRIPT ].us_UserFunction;
      }
   else
      UserInfo( MenuCMsg( MSG_NO_MORE_ITEMS_MENU ), 
                MenuCMsg( MSG_RQTITLE_USER_ERROR_MENU )
              );   

ReattachMenus:

   if (!(ATMenus = CreateMenus( ATNewMenu, GTMN_FrontPen, 0L, TAG_DONE ))) // == NULL)
      return( FALSE );

   LayoutMenus( ATMenus, VisualInfo, TAG_DONE );
      
   SetMenuStrip( ATWnd, ATMenus );

   return( TRUE );
}

/****h* ATAddUserScript() [2.5] ***************************************
*
* NAME
*    ATAddUserScript()
*
* DESCRIPTION
*    Add a Script menu item to the USER SCRIPTS Menu Title.
***********************************************************************
*
*/

PUBLIC int ATAddUserScript( void )
{
   int chk = RETURN_OK;
   
   if ((StringLength( MenuScriptName ) > 1) 
       && (StringLength( MenuScriptFileName ) > 1))
      {
      // Already have what we need, so just do the addition:
      if (AddItemMI( MenuScriptName, MenuScriptFileName ) == FALSE)
         {
         int ans = 0;
         
         SetReqButtons( MenuCMsg( MSG_DEFAULT_BUTTONS ) );

         ans = Handle_Problem( MenuCMsg( MSG_NO_MENU_ATTACH_MENU ),
                               MenuCMsg( MSG_RQTITLE_SYSTEM_PROBLEM_MENU ), 
                               NULL
                             );
         if (ans != 0)
            return( FALSE );
         }
      }
   else
      {
      if ((chk = getUserScript( MenuScriptName, MenuScriptFileName, 1 )) != RETURN_OK)
         {
         goto exitAddScript;
         }
      else if (AddItemMI( MenuScriptName, MenuScriptFileName ) == FALSE)
         {
         return( FALSE );
         }
      }

exitAddScript:

   *MenuScriptName     = '\0'; // Done with these so reset them.
   *MenuScriptFileName = '\0';
   
   return( TRUE );
}

/****i* RemoveItemMI() [2.5] ******************************************
*
* NAME
*    RemoveItemMI()
*
* DESCRIPTION
*    Remove a Script menu item from the USER SCRIPTS Menu Title.
*    Called by ATRemoveUserScript() only!
***********************************************************************
*
*/

SUBFUNC int RemoveItemMI( char *menuName )
{
   int i = 0;

   if (StringLength( menuName ) < 1)  // Prevent lots of heartache!!
      return( TRUE );
         
   while (ATNewMenu[i].nm_Type != NM_END)
      i++; // Find end of list marker.
   
   i--; // go up one in the list to last NM_ITEM or NM_IGNORE.
   
   while (ATNewMenu[i].nm_Type == NM_IGNORE && ATNewMenu[i].nm_Type != NM_TITLE)
      i--; // Find first non-blank menu Item (29 through 60)
   
   ClearMenuStrip( ATWnd );

checkAgain:

   if (ATNewMenu[i].nm_Type != NM_TITLE)
      {
      if (StringComp( menuName, ATNewMenu[i].nm_Label ) == 0)
         {
         ATNewMenu[i].nm_Type = NM_IGNORE;

         if (UserScripts[ i - FIRST_SCRIPT ].us_FileName != NULL) 
            {
            FreeVec( UserScripts[ i - FIRST_SCRIPT ].us_FileName );

            UserScripts[ i - FIRST_SCRIPT ].us_FileName = NULL;
            
            if (ATNewMenu[i].nm_Label != NULL)
               {
               FreeVec( ATNewMenu[i].nm_Label );
               
               ATNewMenu[i].nm_Label = NULL;
               }
            }
         }
      else
         {
         i--;

         goto checkAgain;
         }
      }
   else
      UserInfo( MenuCMsg( MSG_NO_LESS_ITEMS_MENU ),
                MenuCMsg( MSG_RQTITLE_USER_ERROR_MENU )
              );

   if (!(ATMenus = CreateMenus( ATNewMenu, GTMN_FrontPen, 0L, TAG_DONE ))) // == NULL)
      return( FALSE );

   LayoutMenus( ATMenus, VisualInfo, TAG_DONE );
      
   SetMenuStrip( ATWnd, ATMenus );

   return( TRUE );
}

/****h* ATRemoveUserScript() [2.5] ************************************
*
* NAME
*    ATRemoveUserScript()
*
* DESCRIPTION
*    Remove a Script menu item from the USER SCRIPTS Menu Title.
***********************************************************************
*
*/

PUBLIC int ATRemoveUserScript( void )
{
   if (StringLength( MenuScriptName ) > 1)
      {
      // Already have what we need, so just do the Removal:
      if (RemoveItemMI( MenuScriptName ) == FALSE)
         {
         int ans = 0;
         
         SetReqButtons( MenuCMsg( MSG_DEFAULT_BUTTONS ) );

         ans = Handle_Problem( MenuCMsg( MSG_NO_MENU_ATTACH_MENU ),
                               MenuCMsg( MSG_RQTITLE_SYSTEM_PROBLEM_MENU ), 
                               NULL
                             );
         if (ans != 0)
            return( FALSE );
         }
      else
         {
         MenuScriptName     = '\0'; // Reset these.
         MenuScriptFileName = '\0';
         }
      }
   else
      {
      int chk = RETURN_OK;
      
      if ((chk = getUserScript( MenuScriptName, MenuScriptFileName, 0 )) != RETURN_OK)
         {
         goto exitRemoveScript; // User might've cancelled operation!
         }
      else if (RemoveItemMI( MenuScriptName ) == FALSE)
         {
         int ans = 0;
         
         SetReqButtons( MenuCMsg( MSG_DEFAULT_BUTTONS ) );

         ans = Handle_Problem( MenuCMsg( MSG_NO_MENU_ATTACH_MENU ),
                               MenuCMsg( MSG_RQTITLE_SYSTEM_PROBLEM_MENU ), 
                               NULL
                             );
         if (ans != 0)
            return( FALSE );
         }
      else
         {

exitRemoveScript:

         MenuScriptName     = '\0'; // Reset these.
         MenuScriptFileName = '\0';
         }
      }

   return( TRUE );
}

/****h* ATSetPalette() [3.0] ******************************************
*
* NAME
*    ATSetPalette()
*
* DESCRIPTION
*    Show a GUI for setting the screen colors.
***********************************************************************
*
*/

PUBLIC int ATSetPalette( void )
{
   IMPORT UBYTE EnvironFile[ LARGE_TOOLSPACE ];
   IMPORT int ATalkPalette( UBYTE *iniFileName ); // Located in ATPalette.c
   
   (void) ATalkPalette( &EnvironFile[0] );

   return( TRUE );
}

/****i* ATSystemDirectivesMI() [2.1] **********************************
*
* NAME
*    ATSystemDirectivesMI()
*
* DESCRIPTION
*    Show a summary of System Directives.
***********************************************************************
*
*/

PRIVATE int ATSystemDirectivesMI( void )
{
   ShowSystemDirectives();

   return( TRUE );
}

/****i* ATExamineMI() [2.0] *******************************************
*
* NAME
*    ATExamineMI()
*
* DESCRIPTION
*    Open the Trace Window on ATWnd.
***********************************************************************
*
*/

PRIVATE int ATExamineMI( void )
{
   Trace( ATWnd );

   return( TRUE );
}

/****i* SetItemFlags() [1.9] ******************************************
*
* NAME
*    SetItemFlags()
*
* DESCRIPTION
*    Set the flags for the given menu item (usually CHECKED or ~CHECKED)
***********************************************************************
*
*/

SUBFUNC void SetItemFlags( char *itemTitle, int newFlags )
{
   struct MenuItem *sub = NULL;
   UWORD            oldFlags = 0;
   
                                  // CommonFuncs function:   
   if (!(sub = (struct MenuItem *) CFFindMenuPtr( ATMenus, itemTitle ))) // == NULL)
      return;

   // LockIBase()???
   
   oldFlags   = sub->Flags & 0x30C0; // Mask off Intuition flags. 

   // Restore oldFlags & add new ones:

   sub->Flags = (newFlags & 0xCF3F) | oldFlags; 
   
   // UnLockIBase()???
      
   return;
}

/****h* CheckMenuItem() [3.0] *****************************************
*
* NAME
*    CheckMenuItem()
*
* DESCRIPTION
*    Set/reset the check state of a menuitem.  Called from
*    ProcessArgs() in Main.c only.
***********************************************************************
*
*/

PUBLIC void CheckMenuItem( char *miStr, BOOL chkState )
{
   UWORD menuFlags = CHECKIT | MENUTOGGLE | ITEMTEXT | ITEMENABLED; 

   if (chkState == TRUE)
      menuFlags |= CHECKED;
   else
      menuFlags &= ~CHECKED;
      
   SetItemFlags( miStr, menuFlags );
   
   return;   
}

/****i* ResetReportChecks() [1.9] *************************************
*
* NAME
*    ResetReportChecks()
*
* DESCRIPTION
*    Clear the checkmarks for Report Level sub-menuitems.
***********************************************************************
*
*/

SUBFUNC void ResetReportChecks( void )
{
   SetItemFlags( Report0Str, 
                 CHECKIT | MENUTOGGLE | ITEMTEXT | ITEMENABLED 
               );

   SetItemFlags( Report1Str,
                 CHECKIT | MENUTOGGLE | ITEMTEXT | ITEMENABLED 
               );

   SetItemFlags( Report2Str,
                 CHECKIT | MENUTOGGLE | ITEMTEXT | ITEMENABLED 
               );

   return;
}

/****i* ATReportLevel0() [1.9] ****************************************
*
* NAME
*    ATReportLevel0()
*
* DESCRIPTION
*    Set prntcmd = level 0, display requested results only.
***********************************************************************
*
*/

PRIVATE int ATReportLevel0( void )
{
   ResetReportChecks();

   SetItemFlags( Report0Str, 
                 CHECKED | CHECKIT | MENUTOGGLE | ITEMTEXT | ITEMENABLED
               );
   
   prntcmd = 0;

   return( TRUE );
}

/****i* ATReportLevel1() [1.9] ****************************************
*
* NAME
*    ATReportLevel1()
*
* DESCRIPTION
*    Set prntcmd = level 1, display results of typed-in expressions.
***********************************************************************
*
*/

PRIVATE int ATReportLevel1( void )
{
   ResetReportChecks();

   SetItemFlags( Report1Str,
                 CHECKED | CHECKIT | MENUTOGGLE | ITEMTEXT | ITEMENABLED
               );

   prntcmd = 1;

   return( TRUE );
}

/****i* ATReportLevel2() [1.9] ****************************************
*
* NAME
*    ATReportLevel2()
*
* DESCRIPTION
*    Set prntcmd = level 2, display ALL results.
***********************************************************************
*
*/

PRIVATE int ATReportLevel2( void )
{
   ResetReportChecks();

   SetItemFlags( Report2Str, 
                 CHECKED | CHECKIT | MENUTOGGLE | ITEMTEXT | ITEMENABLED
               );

   prntcmd = 2;

   return( TRUE );
}

/****i* ATEnbStatusMI() [1.6] *****************************************
*
* NAME
*    ATEnbStatusMI()
*
* DESCRIPTION
*    Toggle the EnbStatus flag.
*    EnbStatus:   -b Set to FALSE for no status window.
***********************************************************************
*
*/

PRIVATE int ATEnbStatusMI( void )
{
   if (EnbStatus == 0)
      EnbStatus = 1;
   else
      EnbStatus = 0;
      
   return( (int) TRUE );
}

/****i* ATSilenceMI() [1.6] *******************************************
*
* NAME
*    ATSilenceMI()
*
* DESCRIPTION
*    Toggle the silence flag.
*    silence:   -s 1 if silence is desired on output.
***********************************************************************
*
*/

PRIVATE int ATSilenceMI( void )
{
   if (silence == 0)
      silence = 1;
   else
      silence = 0;

   return( (int) TRUE );
}

/****i* ATPrAllocsMI() [1.6] ******************************************
*
* NAME
*    ATPrAllocsMI()
*
* DESCRIPTION
*    Toggle the prallocs flag.
*    prallocs:   -a 1 if printing final allocation figures is wanted.
***********************************************************************
*
*/

PRIVATE int ATPrAllocsMI( void )
{
   if (prallocs == 0)
      prallocs = 1;
   else
      prallocs = 0;

   return( (int) TRUE );
}

/****i* ATLexPrntMI() [1.6] *******************************************
*
* NAME
*    ATLexPrntMI()
*
* DESCRIPTION
*    Toggle the lexprnt flag.
*    lexprnt:   -z 1 if printing during lex is desired (for debug).
***********************************************************************
*
*/

PRIVATE int ATLexPrntMI( void )
{
   if (lexprnt == 0)
      lexprnt = 1;
   else
      lexprnt = 0;

   return( (int) TRUE );
}

/****i* ATDebugMI() [1.6] *********************************************
*
* NAME
*    ATDebugMI()
*
* DESCRIPTION
*    Toggle the debug flag.
*    debug:   debug flag, set by a primitive call (or here).
***********************************************************************
*
*/

PRIVATE int ATDebugMI( void )
{
   if (debug == FALSE)
      debug = TRUE;
   else
      debug = FALSE;

   return( (int) TRUE );
}

/****i* ATTraceMI() [1.9] *********************************************
*
* NAME
*    ATTraceMI()
*
* DESCRIPTION
*    Toggle the trace flag (& Reset the TraceIndent value)..
***********************************************************************
*
*/

PRIVATE int ATTraceMI( void )
{
   IMPORT OBJECT *o_nil;
   IMPORT OBJECT *o_true;
   IMPORT OBJECT *o_false;
   IMPORT OBJECT *o_drive;
   IMPORT BOOL    traceByteCodes;
   IMPORT int     TraceIndent;
   IMPORT FILE   *TraceFile;
   
   UBYTE           *name = MenuCMsg( MSG_AM_TRACE_MENU_MENU );
   struct MenuItem *tr   = (struct MenuItem *) CFFindMenuPtr( ATWnd->MenuStrip, name );

   if ((tr->Flags & CHECKED) == CHECKED)
      {
      IMPORT FILE *TraceFile;
      
      IMPORT struct TagItem LoadTags[];
      
      char nil[BUFLENGTH], *filename = &nil[0]; 
      int  rval = 0;

      SetTagItem( &LoadTags[0], ASLFR_Window,        (ULONG) ATWnd        );
      SetTagItem( &LoadTags[0], ASLFR_InitialDrawer, (ULONG) "AmigaTalk:" );

      SetTagItem( &LoadTags[0], ASLFR_TitleText, 
                  (ULONG) MenuCMsg( MSG_AM_ENTER_TFILE_MENU ) 
                );
         
      if ((rval = FileReq( filename, &LoadTags[0] )) > 0)
         {
         // User gave us a filename:
         if ((TraceFile != NULL) && (TraceFile != stdout))
            fclose( TraceFile );
            
         TraceFile = fopen( filename, FILE_WRITE_STR );

         if (!TraceFile) // == NULL)
            {
            sprintf( ErrMsg, MenuCMsg( MSG_AM_NOTRACE_MENU ), filename );

            UserInfo( ErrMsg, UserProblem );
            
            TraceFile = stdout;
            }             
         }
      else
         {
         TraceFile = stdout;
         }
         
      TraceIndent    = 0;      // Reset this.
      traceByteCodes = TRUE;

      // Make this a ToolType later:
      ExecuteExternalScript( "Amigatalk:c/TracerOn" ); // TracingOnScript );

      fprintf( TraceFile, MenuCMsg( MSG_FMT_AM_NIL_MENU    ), o_nil   );
      fprintf( TraceFile, MenuCMsg( MSG_FMT_AM_TRUE_MENU   ), o_true  );
      fprintf( TraceFile, MenuCMsg( MSG_FMT_AM_FALSE_MENU  ), o_false );
      fprintf( TraceFile, MenuCMsg( MSG_FMT_AM_DRIVER_MENU ), o_drive );
      }
   else
      {
      if (TraceFile != stdout && TraceFile) // != NULL)
         {
         fclose( TraceFile );
         TraceFile = NULL;
         }

      traceByteCodes = FALSE;
      TraceIndent    = 0;      // Reset this.

      // Make this a ToolType later:
      ExecuteExternalScript( "Amigatalk:c/TracerOFF" ); // TracingOFFScript );
      }

   return( (int) TRUE );
}

/****h* ATLoadProgram() [1.6] ***************************************
*
* NAME
*    ATLoadProgram()
*
* DESCRIPTION
*    Execute the SmallTalk Load program command.  
*    ParseButtonClicked() also performs this function.
*********************************************************************
*
*/

PUBLIC int ATLoadProgram( void )
{
   IMPORT struct TagItem LoadTags[];
      
   char nil[BUFLENGTH], *filename = &nil[0]; int rval = 0;
   char   c[BUFLENGTH], *command  = &c[0];

   c[0] = '\0'; // Ensure empty command string.
   
   OS4SetTagItem( &LoadTags[0], ASLFR_Window, (ULONG) ATWnd );
   OS4SetTagItem( &LoadTags[0], ASLFR_Screen, (ULONG) Scr );
   OS4SetTagItem( &LoadTags[0], ASLFR_InitialDrawer, (ULONG) "AmigaTalk:" );

   OS4SetTagItem( &LoadTags[0], ASLFR_TitleText, 
                  (ULONG) MenuCMsg( MSG_GL_LOAD_STR_MENU )
                );
   
   if ((rval = FileReq( filename, &LoadTags[0] )) > 0)
      {
      // User gave us a filename:
      
      sprintf( command, ")r %s", filename );
      StringCopy( CurrentLoadFile, filename );     // Update Global.

      ClearCommandStrGadget();
      
      dolexcommand( command ); // read into interpreter.

      ScreenToFront( Scr );

      AddToPgmLV( command );
      }
   else
      return( TRUE );
       
   if (StringLength( command ) > 0)
      return( USER_COMMAND ); // TRUE );
   else
      return( TRUE );
}

/****h* ATIncludeClass() [2.5] **************************************
*
* NAME
*    ATIncludeClass()
*
* DESCRIPTION
*    Get a Class source fileName from the User & )include it.
*********************************************************************
*
*/

PUBLIC int ATIncludeClass( void )
{
   IMPORT struct TagItem LoadTags[];
      
   char nil[BUFLENGTH] = { 0, }, *filename = &nil[0]; 
   char   c[BUFLENGTH] = { 0, }, *command  = &c[0];
   int rval = 0;
   
   SetTagItem( &LoadTags[0], ASLFR_Window, (ULONG) ATWnd );
   SetTagItem( &LoadTags[0], ASLFR_InitialDrawer, (ULONG) "AmigaTalk:" );

   SetTagItem( &LoadTags[0], ASLFR_TitleText, 
               (ULONG) MenuCMsg( MSG_GL_LOAD_STR_MENU )
             );

   if ((rval = FileReq( filename, &LoadTags[0] )) > 0)
      {
      // User gave us a filename:
      
      sprintf( command, ")i %s\n", filename );
      StringCopy( CurrentLoadFile, filename );     // Update Global.

      ClearCommandStrGadget();
      dolexcommand( command ); // read into parser.

      ScreenToFront( Scr );

      AddToPgmLV( command );
      }
   else
      return( TRUE );
       
   if (StringLength( command ) > 0)
      return( USER_COMMAND ); // TRUE );
   else
      return( TRUE );
}

/****h* ATEditFile() [1.6] ********************************************
*
* NAME
*    ATEditFile()
*
* DESCRIPTION
*    Execute the SmallTalk Edit File Command, which only calls the
*    Editor specified in the ToolTypes on the user-selected file.
*    Not the same as the )e System Directive!
***********************************************************************
*
*/

PUBLIC int ATEditFile( void )
{
   IMPORT UBYTE           Editor[ LARGE_TOOLSPACE ]; // Environmental Variable from Tools.c file.
   IMPORT struct TagItem  LoadTags[];
   
   char nil[BUFLENGTH] = { 0, }, *filename = &nil[0]; 
   int  rval = 0;

   SetTagItem( &LoadTags[0], ASLFR_Window, (ULONG) ATWnd );
   SetTagItem( &LoadTags[0], ASLFR_InitialDrawer, (ULONG) "AmigaTalk:" );

   SetTagItem( &LoadTags[0], ASLFR_TitleText, 
               (ULONG) MenuCMsg( MSG_GL_LOAD_STR_MENU )
             );

   if ((rval = FileReq( filename, &LoadTags[0] )) > 0)
      {
      // User gave us a filename:
      char c[BUFLENGTH], *command = &c[0];
      
      sprintf( command, "%s %s", Editor, filename );
      StringCopy( CurrentLoadFile, filename );    // Update Global.

      ScreenToBack( Scr );

      ClearCommandStrGadget();
      
      ATSystem( command ); // read into editor.

      ScreenToFront( Scr );

      AddToPgmLV( command );
      }

   return( (int) TRUE );
}

/****h* ATSaveProgram() [1.6] **************************************
*
* NAME
*    ATSaveProgram()
*
* DESCRIPTION
*    Save the commands in the list view Gadget.
********************************************************************
*
*/

PUBLIC int ATSaveProgram( void )
{
   IMPORT struct TagItem SaveTags[];  // In Global.c file.
      
   char nil[BUFLENGTH] = { 0, }, *filename = &nil[0]; 
   int  rval = 0;

   SetTagItem( &SaveTags[0], ASLFR_Window, (ULONG) ATWnd );
   SetTagItem( &SaveTags[0], ASLFR_InitialDrawer, (ULONG) "AmigaTalk:" );

   SetTagItem( &SaveTags[0], ASLFR_TitleText, 
               (ULONG) MenuCMsg( MSG_GL_SAVE_STR_MENU )
             );

   if (StringLength( CurrentLoadFile ) == 0)
      {
      if ((rval = FileReq( filename, &SaveTags[0] )) > 0)
         {
         // User gave us a filename:
         FILE *outf = NULL;
         int   i;

         if (!(outf = fopen( filename, FILE_WRITE_STR ))) // == NULL)
            {
            NotOpened( 2 );
            }
         else
            {
            HideListFromView( ATGadgets[PgmListView], ATWnd );

            for (i = 0; i < PgmLineNumber; i++)
               {
               char bf[PGM_ITEMLENGTH] = { 0, }, *buf = &bf[0];
            
               StringCopy( buf, &PgmItemBuffer[ i * PGM_ITEMLENGTH ] );
               fputs( buf, outf );
               fputc( NEWLINE_CHAR, outf );
               }

            ModifyListView( ATGadgets[PgmListView], ATWnd, 
                            &PgmList, NULL
                          );

            fclose( outf );

            StringCopy( CurrentLoadFile, filename );
            }
         }
      }
   else
      {
      FILE *outf = NULL;
      int   i;
      
      
      if (!(outf = fopen( CurrentLoadFile, FILE_WRITE_STR ))) // == NULL)
         {
         NotOpened( 2 ); // CurrentLoadFile );
         }
      else
         {
         HideListFromView( ATGadgets[PgmListView], ATWnd );

         for (i = 0; i < PgmLineNumber; i++)
            {
            char bf[PGM_ITEMLENGTH] = { 0, }, *buf = &bf[0];
            
            StringCopy( buf, &PgmItemBuffer[ i * PGM_ITEMLENGTH ] );

            fputs( buf, outf );
            fputc( NEWLINE_CHAR, outf );
            }

         ModifyListView( ATGadgets[PgmListView], ATWnd, &PgmList, NULL );

         fclose( outf );
         }
      }

   return( (int) TRUE );
}

/****h* ATSaveAsProgram() [1.6] ***********************************
*
* NAME
*    ATSaveAsProgram()
*
* DESCRIPTION
*    Save the commands in the list view Gadget.
*******************************************************************
*
*/

PUBLIC int ATSaveAsProgram( void )
{
   IMPORT struct TagItem SaveTags[];  // In Global.c file.   

   char nil[BUFLENGTH] = { 0, }, *filename = &nil[0]; 
   int  rval = 0;

   SetTagItem( &SaveTags[0], ASLFR_Window, (ULONG) ATWnd );
   SetTagItem( &SaveTags[0], ASLFR_InitialDrawer, (ULONG) "AmigaTalk:" );

   SetTagItem( &SaveTags[0], ASLFR_TitleText, 
               (ULONG) MenuCMsg( MSG_GL_SAVE_STR_MENU )
             );

   if ((rval = FileReq( filename, &SaveTags[0] )) > 0)
      {
      // User gave us a filename:
      FILE *outf = NULL;
      int   i;

      if (!(outf = fopen( filename, FILE_WRITE_STR ))) // == NULL)
         {
         NotOpened( 2 ); // filename );
         }
      else
         {
         HideListFromView( ATGadgets[PgmListView], ATWnd );

         for (i = 0; i < PgmLineNumber; i++)
            {
            char bf[PGM_ITEMLENGTH] = { 0, }, *buf = &bf[0];
            
            StringCopy( buf, &PgmItemBuffer[ i * PGM_ITEMLENGTH ] );
            fputs( buf, outf );
            fputc( NEWLINE_CHAR, outf );
            }

         ModifyListView( ATGadgets[PgmListView], ATWnd, &PgmList, NULL );

         fclose( outf );
         }
      }
   return( (int) TRUE );
}

PUBLIC int ATQuitAmigaTalk( void )
{
   int ans = 0;
   
   SetReqButtons( MenuCMsg( MSG_YES_NO_BUTTONS_MENU ) );

   ans = SanityCheck( MenuCMsg( MSG_AM_SURE_QUIT_MENU ) );

   SetReqButtons( DefaultButtons );

   if (ans == TRUE)
      {
      CloseATWindow();

      return( (int) FALSE );
      }

   return( (int) TRUE );
}

PUBLIC int ATAboutAmigaTalk( void )
{
   IMPORT void AboutReq( void ); // Located in ATAbout.c

   AboutReq();

   return( (int) TRUE );
}


/****h* ATHelpProgram() [1.6] ***********************************
*
* NAME
*    ATHelpProgram()
*
* DESCRIPTION
*    Start the ATHelper window in ATHelper.c & display
*    the help documents available in AmigaTalk:Help/.
*****************************************************************
*
*/

PUBLIC int ATHelpProgram( void )
{
   IMPORT int ATHelper( char *parentdir, 
                        char *fileviewer, 
                        char *filefilter 
                      );

   IMPORT UBYTE HelpPath[    LARGE_TOOLSPACE ];
   IMPORT UBYTE HelpProgram[ LARGE_TOOLSPACE ];

   if (ATHelper( HelpPath, HelpProgram, "(#?.guide|#?.doc)" ) < 0)
      {
      CheckToolType( MenuCMsg( MSG_TT_HELPPROGRAM_MENU ) );
      }

   ScreenToFront( Scr ); // Since MultiView won't do it.

   return( (int) TRUE );
}

PUBLIC int ATOpenBrowser( void )
{
   IMPORT int useBrowser( struct Window *parent, char *name ); // See ATalkBrowser.c file.
   
   IMPORT UBYTE BrowserName[ LARGE_TOOLSPACE ]; // In Tools.c
   
   int rval = useBrowser( ATWnd, (char *) BrowserName );

//   ScreenToFront( Scr );
   
   if (rval != TRUE)
      return( (int) FALSE );

   return( (int) TRUE );
}

/* ------------------- END of ATMenus.c file! ---------------------- */
