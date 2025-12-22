/****h* AmigaTalk/ATGadgets.c [3.0] ********************************
*
* NAME
*    ATGadgets.c
*
* FUNCTIONAL INTERFACE:
*
*    PUBLIC void ClearCommandStrGadget( void );
*    PUBLIC void GetCommand( char *buffer ); Used in Line.c
*    PUBLIC void AddToPgmLV( char *string );
*
* HISTORY
*    24-Oct-2004 - Added AmigaOS4 & gcc support.
*    05-Sep-2003 - Added the CLearCommandStrGadget() function.
*    09-Jan-2003 - Moved all string constants to StringConstants.h
*
*    30-Apr-2000 - No more minor changes needed in this file.
*
*    09-Feb-2000 - Started a re-write of the entire program, 
*                  mostly to incorporate CommonFuncs.o.
*
* NOTES
*    $VER: AmigaTalk:Src/ATGadgets.c 3.0 (24-Oct-2004) by J.T. Steichen
*    GUI Designed by : Jim Steichen
********************************************************************
*
*/

#include <stdio.h>
#include <string.h>

#include <exec/types.h>
#include <exec/lists.h>
#include <exec/nodes.h>
#include <exec/memory.h>

#include <AmigaDOSErrs.h>

#include <intuition/intuitionbase.h>
#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/gadgetclass.h>

#include <libraries/gadtools.h>

#ifdef    __SASC
# include <clib/exec_protos.h>
# include <clib/intuition_protos.h>
# include <clib/gadtools_protos.h>

IMPORT struct IntuitionBase *IntuitionBase;
IMPORT struct Library       *GadToolsBase;

#else

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/intuition.h>
# include <proto/gadtools.h>

IMPORT struct Library *IntuitionBase;
IMPORT struct Library *GadToolsBase;

IMPORT struct GadToolsIFace *IGadTools;
#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "FuncProtos.h"

#include "IStructs.h"
#include "Constants.h"

#include "StringConstants.h"
#include "StringIndexes.h"

#define  LV_GAD ATGadgets[PgmListView]
#define STR_GAD ATGadgets[CmdStr]
#define PAR_GAD ATGadgets[ParseBt]

#define COMMAND_STRING StrBfPtr( STR_GAD )

IMPORT struct Window  *ATWnd;
IMPORT struct Screen  *Scr;

IMPORT struct List    PgmList;
IMPORT struct Node    PgmListItems[ PGM_MAXITEM ]; // PGM_MAXITEM == 100
IMPORT char          *PgmItemBuffer;

IMPORT UBYTE *DefaultButtons;
IMPORT UBYTE *AaarrggButton;

// --------------------------------------------------------------------

PUBLIC struct Gadget *ATGList = NULL;
PUBLIC struct Gadget *ATGadgets[ AT_CNT ];

PUBLIC UWORD ATGTypes[] = {

   LISTVIEW_KIND, STRING_KIND, BUTTON_KIND
};

PRIVATE int ProgramListViewClicked( int whichline );
PRIVATE int CommandLineClicked(     int dummy     );
PRIVATE int ParseButtonClicked(     int dummy     );

PUBLIC struct NewGadget ATNGad[] = {

     4,  19, 624, 495, NULL, NULL,
   PgmListView, PLACETEXT_ABOVE | NG_HIGHLABEL, NULL, 
   (APTR) ProgramListViewClicked,
   
   170, 520, 448, 19, NULL,  NULL, 
   CmdStr, PLACETEXT_LEFT | NG_HIGHLABEL, NULL, 
   (APTR) CommandLineClicked,

    10, 540,  127, 19, NULL, NULL, 
   ParseBt, PLACETEXT_IN, NULL, (APTR) ParseButtonClicked
};

PUBLIC ULONG ATGTags[] = {

   TAG_DONE,

   GA_TabCycle, FALSE, GTST_MaxChars, COMMAND_STRLENGTH, 
   STRINGA_Justification, GACT_STRINGCENTER, TAG_DONE,

   TAG_DONE
};

PUBLIC int PgmLineNumber = 0;

/****h* ClearCommandStrGadget() [3.0] *********************************
*
* NAME
*    ClearCommandStrGadget()
*
* DESCRIPTION
*    Clear the contents of the Command String Gadget.
***********************************************************************
*
*/

PUBLIC void ClearCommandStrGadget( void )
{
   GT_SetGadgetAttrs( STR_GAD, ATWnd, NULL, GTST_String, "", TAG_END );

   return;
}

/****i* AmigaTalk/GetCommand() [1.5] **********************************
*
* NAME
*    GetCommand( char *buffer )
*
* DESCRIPTION
*    This is how line_grabber() obtains input from the user via the
*    string gadget in ATWnd.
*
***********************************************************************
*
*/

PUBLIC void GetCommand( char *buffer )
{
   buffer[0] = NIL_CHAR; // Kill old contents
   
   (void) StringCopy( buffer, COMMAND_STRING );

   return;
}

PRIVATE int ProgramListViewClicked( int whichline )
{
   struct TextAttr *ta   = Scr->Font;
   struct Gadget   *gptr = STR_GAD;

   char *itemstr = PgmListItems[ whichline ].ln_Name;

   /* Copy the latest instruction to the Current Instruction String
   ** Gadget:
   */

   GT_SetGadgetAttrs( STR_GAD, ATWnd, NULL,
                      GTST_String, (UBYTE *) itemstr,
                      TAG_END
                    );

   // This should NOT have to be done!
   gptr->GadgetText->ITextFont = ta;
   
   // Put Cursor in the Instruction String Gadget:
   (void) ActivateGadget( STR_GAD, ATWnd, NULL );

   return( (int) TRUE );
}

/****i* AddToPgmLV() [1.0] *****************************************
*
* NAME
*    AddToPgmLV()
*
* DESCRIPTION
*    Place the given string into the Program List Viewer.
********************************************************************
*
*/

PUBLIC void AddToPgmLV( char *string )
{
   if (PgmLineNumber < PGM_MAXITEM)
      {
      HideListFromView( LV_GAD, ATWnd );

      StringCopy( &PgmItemBuffer[ PgmLineNumber * PGM_ITEMLENGTH ], string );
      
      ModifyListView( LV_GAD, ATWnd, &PgmList, NULL );

      PgmLineNumber++;
      }

   return;
}

/****i* CommandLineClicked() [1.5] ********************************
*
* NAME
*    CommandLineClicked()
*
* DESCRIPTION
*    This routine must take the contents of the CommandLine string
*    gadget & place it at the end of the ListView contents.  If
*    there is no room, the ListView contents are saved via a 
*    program requester.
*******************************************************************
*
*/

PRIVATE int CommandLineClicked( int dummy )
{
   IMPORT struct TagItem  SaveTags[];      // In Global.c file.
   IMPORT char           *CurrentLoadFile;
   IMPORT UBYTE          *ErrMsg;
   
   if (PgmLineNumber < PGM_MAXITEM)
      {
      HideListFromView( LV_GAD, ATWnd );

      StringCopy( &PgmItemBuffer[ PgmLineNumber * PGM_ITEMLENGTH ], COMMAND_STRING );
      
      ModifyListView( LV_GAD, ATWnd, &PgmList, NULL );

      PgmLineNumber++;
      }
   else
      {
      int  i, ans = 0;
      
      sprintf( ErrMsg, GadCMsg( MSG_AG_LV_FULL_GAD ) );

      SetReqButtons( GadCMsg( MSG_YES_NO_BUTTONS_GAD ) );
      ans = Handle_Problem( ErrMsg, GadCMsg( MSG_AG_HELPER_GAD ), NULL );
      SetReqButtons( DefaultButtons );

      PgmLineNumber = 0;

      if (ans != 0)
         {
         HideListFromView( LV_GAD, ATWnd );

         for (i = 0; i < (PGM_ITEMLENGTH * PGM_MAXITEM); i++)
             *(PgmItemBuffer + i) = NIL_CHAR;

         ModifyListView( LV_GAD, ATWnd, &PgmList, NULL );

         return( (int) TRUE );
         }
      else
         {
         // save the Program ListView gadget contents:
         char fn[512] = { 0, }, *filename = &fn[0];
         int  rval;
         
         SetTagItem( &SaveTags[0], ASLFR_Window, (ULONG) ATWnd );

         HideListFromView( LV_GAD, ATWnd );

         if ((rval = FileReq( filename, &SaveTags[0] )) > 0)
            {
            // User gave us a filename:
            FILE *outf = NULL;
            int   i;

            if (!(outf = fopen( filename, FILE_WRITE_STR ))) // == NULL)
               {
               sprintf( ErrMsg, GadCMsg( MSG_CANNOT_OPEN_GAD ), filename );
               
               UserInfo( ErrMsg, GadCMsg( MSG_ATALK_FILE_PROB_GAD ) );
               }
            else
               {
               for (i = 0; i < PgmLineNumber; i++)
                  {
                  char bf[PGM_ITEMLENGTH] = { 0, }, *buf = &bf[0];
               
                  StringCopy( buf, &PgmItemBuffer[ i * PGM_ITEMLENGTH ] );
                  fputs( buf, outf );
                  }

               fclose( outf );
               StringCopy( CurrentLoadFile, filename );
               }
            }

         ModifyListView( LV_GAD, ATWnd, &PgmList, NULL );

         return( (int) TRUE );
         }
      }
   
   return( (int) USER_COMMAND );
}

/****i* ParseButtonClicked() [1.0] ***********************************
*
* NAME
*    ParseButtonClicked()
*
* DESCRIPTION
*    User asked the program to Get a file for AmigaTalk to Include.
**********************************************************************
*
*/

PRIVATE int ParseButtonClicked( int dummy )
{
   IMPORT struct TagItem  LoadTags[];      // In Global.c file.
   IMPORT char           *CurrentLoadFile;
   
   char nil[512]  = { 0, }, *filename = &nil[0]; 
   char   c[1024] = { 0, }, *command  = &c[0];

   int  rval = 0;

   c[0] = NIL_CHAR; // Ensure empty command string.
   
   SetTagItem( &LoadTags[0], ASLFR_Window, (ULONG) ATWnd );
      
   if ((rval = FileReq( filename, &LoadTags[0] )) > 0)
      {
      // User gave us a filename:
      
      sprintf( command, ")i %s", filename );
      StringCopy( CurrentLoadFile, filename );

      lexinclude( filename ); // Parse the Class Decription file.

      AddToPgmLV( command );
      }

   if (StringLength( command ) > 0)
      return( (int) USER_COMMAND ); // Tell line_grabber to pass the cmd.
   else
      return( (int) TRUE );
}

/* --------------------- END of ATGadgets.c file! ----------------- */
