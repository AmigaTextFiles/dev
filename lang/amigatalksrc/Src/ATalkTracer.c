/****h* AmigaTalk/ATalkTracer.c [3.0] **********************************
*
* NAME
*    ATalkTracer.c
*
* DESCRIPTION
* 
* SYNOPSIS 
*    This is a GUI for interfacing to AmigaTalk when an error is found
*    in User Smalltalk code.
*
* HISTORY
*    24-Oct-2004 - Added AmigaOS4 & gcc support.
*
*    29-Dec-2003 - Removed the FileReq() calls.  Just use 
*                  "AmigaTalk:BackTrace" for all bactraces.
*
*    Oct-25-2003 - Created this file.
*
* COPYRIGHT
*    ATalkTracer.c 2003(C) by J.T. Steichen
*
* NOTES
*
*    $VER: ATalkTracer.c 3.0 (24-Oct-2004) by J.T. Steichen
************************************************************************
*
*/

#include <stdio.h>
#include <string.h>

#include <exec/types.h>

#include <AmigaDOSErrs.h>

#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/gadgetclass.h>

#include <libraries/gadtools.h>

#include <utility/tagitem.h>
#include <dos/dostags.h>
#include <libraries/asl.h>

#include <graphics/displayinfo.h>
#include <graphics/gfxbase.h>

#ifdef __SASC

# include <proto/locale.h>

# include <clib/exec_protos.h>
# include <clib/intuition_protos.h>
# include <clib/gadtools_protos.h>
# include <clib/graphics_protos.h>
# include <clib/utility_protos.h>
# include <clib/diskfont_protos.h>

IMPORT struct IntuitionBase *IntuitionBase;
IMPORT struct GfxBase       *GfxBase;
IMPORT struct Library       *GadToolsBase;
IMPORT struct LocaleBase    *LocaleBase;

#else

# define __USE_INLINE__

# include <proto/locale.h>
# include <proto/exec.h>
# include <proto/intuition.h>
# include <proto/graphics.h>
# include <proto/gadtools.h>
# include <proto/utility.h>
# include <proto/diskfont.h>

IMPORT struct Library *IntuitionBase;
IMPORT struct Library *GfxBase;
IMPORT struct Library *GadToolsBase;
IMPORT struct Library *LocaleBase;

#endif

#include "ATStructs.h"
#include "Constants.h"
#include "FuncProtos.h"
#include "StringIndexes.h"

#include "CPGM:GlobalObjects/CommonFuncs.h"

#define ID_TraceLV  0
#define ID_ContBt   1
#define ID_StopBt   2
#define ID_ExamBt   3
#define ID_ExitBt   4

#define BT_CNT      5

// ----------------------------------------------------

//IMPORT struct TagItem        LoadTags[];

IMPORT struct Screen        *Scr;
IMPORT struct CompFont       CFont;

IMPORT UBYTE                *PubScreenName;
IMPORT APTR                  VisualInfo;

IMPORT UBYTE                *ErrMsg;
IMPORT OBJECT               *o_nil;

// ----------------------------------------------------

PUBLIC  UBYTE *BTWdt = NULL;   // Visible to TraceCatalog() in CatalogFuncs.c

// ----------------------------------------------------

PRIVATE INTERPRETER         *interp     = NULL;
PRIVATE FILE                *outf       = NULL;
PRIVATE UBYTE               *BTFileName = NULL;

PRIVATE struct TextAttr     *BTFont;
PRIVATE struct Window       *BTWnd   = NULL;
PRIVATE struct Gadget       *BTGList = NULL;
PRIVATE struct Gadget       *BTGadgets[ BT_CNT ] = { 0, };

PRIVATE struct IntuiMessage  BTMsg = { 0, };

PRIVATE UWORD  BTLeft   = 0;
PRIVATE UWORD  BTTop    = 100;
PRIVATE UWORD  BTWidth  = 800;
PRIVATE UWORD  BTHeight = 370;

#define TLV_NUM_ELEMENTS  200
#define ELEMENT_SIZE      128

PRIVATE struct List         TraceLVList = { 0, };
PRIVATE struct ListViewMem *TraceLV_lvm = NULL;

PRIVATE UWORD BTGTypes[ BT_CNT ] = {

   LISTVIEW_KIND, BUTTON_KIND, BUTTON_KIND,
     BUTTON_KIND, BUTTON_KIND,
};

PRIVATE int TraceLVClicked( void );
PRIVATE int ContBtClicked(  void );
PRIVATE int StopBtClicked(  void );
PRIVATE int ExamBtClicked(  void );
PRIVATE int ExitBtClicked(  void );

PUBLIC struct NewGadget BTNGad[ BT_CNT ] = { // Visible to TraceCatalog() in CatalogFuncs.c

    10,  40, 770, 300, "Tracings:", NULL,
   ID_TraceLV, NG_HIGHLABEL | PLACETEXT_ABOVE, NULL, (APTR) TraceLVClicked,

    10, 340,  90,  20, "_Continue", NULL,
   ID_ContBt, PLACETEXT_IN, NULL, (APTR) ContBtClicked,

   115, 340,  90,  20, "_Stop Trace", NULL,
   ID_StopBt, PLACETEXT_IN, NULL, (APTR) StopBtClicked,

   220, 340, 130,  20, "_Examine File", NULL,
   ID_ExamBt, PLACETEXT_IN, NULL, (APTR) ExamBtClicked,

   680, 340,  90,  20, "E_XIT", NULL,
   ID_ExitBt, PLACETEXT_IN, NULL, (APTR) ExitBtClicked,
};

PRIVATE ULONG BTGTags[] = {

   GTLV_Labels,     (ULONG) NULL, 
   LAYOUTA_Spacing, 2, 
   GTLV_ReadOnly,   TRUE, TAG_DONE,

   GT_Underscore, '_', TAG_DONE,

   GT_Underscore, '_', TAG_DONE,

   GT_Underscore, '_', TAG_DONE,

   GT_Underscore, '_', TAG_DONE,
};

// ----------------------------------------------------------------

PRIVATE void CloseBTWindow( void )
{
   if (BTWnd) // != NULL)
      {
      CloseWindow( BTWnd );

      BTWnd = NULL;
      }

   if (BTGList) // != NULL)
      {
      FreeGadgets( BTGList );

      BTGList = NULL;
      }

   return;
}

// ----------------------------------------------------------------

IMPORT char *getBackTrace( INTERPRETER *current ); // Located in Courier.c

SUBFUNC void fillInTracings( void )
{
   char *line = NULL;
   int   i    = 0;

   if (interp == (INTERPRETER *) o_nil)
      return;
         
   while (i < TLV_NUM_ELEMENTS)
      {
      line = getBackTrace( interp );
      
      if (!line || (StringLength( line ) < 1))
         break;
      else
         {
         int len = StringLength( line );
         
         if (*(line + len) == '\n')
            *(line + len) = '\0';   // Don't need newlines in ListViews
            
         StringNCopy( &TraceLV_lvm->lvm_NodeStrs[ i * ELEMENT_SIZE ], line, ELEMENT_SIZE );
         }
            
      i++;
      }

   ModifyListView( BTGadgets[ ID_TraceLV ], BTWnd, &TraceLVList, NULL );
      
   return;
}

SUBFUNC void clearListView( void )
{
   int i = 0;
   
   while (i < TLV_NUM_ELEMENTS)
      {
      StringNCopy( &TraceLV_lvm->lvm_NodeStrs[ i * ELEMENT_SIZE ], "", ELEMENT_SIZE );
      
      i++;
      }
      
   return;
}

SUBFUNC void traceToFile( void )
{
   int i   = 0;
   int len = 0;
   
   if (!outf) // == NULL)
      return;
      
   // Send the current ListView contents to the outfile.
   len = StringLength( &TraceLV_lvm->lvm_NodeStrs[i] );
   
   while (i < TLV_NUM_ELEMENTS && len > 0)
      {
      fputs( &TraceLV_lvm->lvm_NodeStrs[ i * ELEMENT_SIZE ], outf );

      fputc( '\n', outf );

      i++;
      
      len = StringLength( &TraceLV_lvm->lvm_NodeStrs[ i * ELEMENT_SIZE ] );
      }

   return;
}

// ---------------------------------------------------------------------

PRIVATE int TraceLVClicked( void )
{
   return( TRUE ); // Nothing to do here
}

PRIVATE int ContBtClicked( void )
{
   // 1. Send the current ListView contents to the outfile.
   traceToFile();
   
   // 2. Erase the current ListView contents.
   clearListView();
   
   // 3. Refill the ListView
   fillInTracings();
   
   return( TRUE );
}

PRIVATE int StopBtClicked( void )
{
   IMPORT void resetBTInterpreter( void ); // Located in Courier.c

   resetBTInterpreter();

   interp = (INTERPRETER *) o_nil;
   
   return( TRUE );
}

PRIVATE int ExamBtClicked( void )
{
   IMPORT UBYTE *FileDisplayer; // ToolType in Tools.c
   
   char btfn[256] = { 0, }, *getFileName = &btfn[0];
   char cmd[256]  = { 0, };
   int  rval = RETURN_OK;
         
   if (StringLength( BTFileName ) < 1)
      {
//      SetTagItem( LoadTags, ASLFR_InitialDrawer, (ULONG) "Amigatalk:" );

//      SetTagItem( &LoadTags[0], ASLFR_Window, (ULONG) BTWnd );
   
//      if (FileReq( getFileName, &LoadTags[0] ) < 1)
//         {
         StringNCopy( getFileName, "AmigaTalk:BackTrace", 255 );
//         }
      
      BTFileName = getFileName;
      }

   sprintf( &cmd[0], "%s %s", FileDisplayer, BTFileName );

   if ((rval = System( &cmd[0], TAG_DONE )) != RETURN_OK)
      {
      sprintf( ErrMsg, ATTCMsg( MSG_FMT_CMD_ERR_TRACE ), &cmd[0], rval );
             
      UserInfo( ErrMsg, ATTCMsg( MSG_RQTITLE_USER_ERROR_TRACE ) );
      }
      
   return( TRUE );
}

PRIVATE int ExitBtClicked( void )
{
   IMPORT void resetBTInterpreter( void ); // Located in Courier.c

   traceToFile();
   
   resetBTInterpreter();
   
   CloseBTWindow();
   
   return( FALSE );
}

// ----------------------------------------------------------------

PRIVATE int OpenBTWindow( void )
{
   struct NewGadget  ng;
   struct Gadget    *g;
   UWORD             lc, tc;
   UWORD             wleft, wtop, ww, wh;

   ComputeFont( Scr, BTFont, &CFont, BTWidth, BTHeight );

   ww = ComputeX( CFont.FontX, BTWidth  );
   wh = ComputeY( CFont.FontY, BTHeight );

   wleft = (Scr->Width  - BTWidth ) / 2;
   wtop  = (Scr->Height - BTHeight) / 2;

   if (!(g = CreateContext( &BTGList ))) // == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < BT_CNT; lc++)
      {
      CopyMem( (char *) &BTNGad[ lc ], (char *) &ng,
               (long) sizeof( struct NewGadget )
             );

      ng.ng_VisualInfo = VisualInfo;
      ng.ng_TextAttr   = BTFont;
      ng.ng_LeftEdge   = CFont.OffX + ComputeX( CFont.FontX, ng.ng_LeftEdge );
      ng.ng_TopEdge    = CFont.OffY + ComputeY( CFont.FontY, ng.ng_TopEdge );

      BTGadgets[ lc ] = g
                      = CreateGadgetA( (ULONG) BTGTypes[ lc ],
                                       g,
                                       &ng,
                                       (struct TagItem *) &BTGTags[ tc ]
                                     );

      while (BTGTags[ tc ] != TAG_DONE)
         tc += 2;

      tc++;

      if (!g) // == NULL)
         return( -2 );
      }

   if (!(BTWnd = OpenWindowTags( NULL,

         WA_Left,          wleft,
         WA_Top,           wtop,
         WA_Width,         ww + CFont.OffX + Scr->WBorRight,
         WA_Height,        wh + CFont.OffY + Scr->WBorBottom,

         WA_IDCMP,         LISTVIEWIDCMP | BUTTONIDCMP | 
           IDCMP_CLOSEWINDOW | IDCMP_VANILLAKEY | IDCMP_REFRESHWINDOW,

         WA_Flags,         WFLG_ACTIVATE | WFLG_DRAGBAR | WFLG_DEPTHGADGET
           | WFLG_RMBTRAP,

         WA_Gadgets,       BTGList,
         WA_Title,         BTWdt,
         WA_CustomScreen,  Scr,
         TAG_DONE ))) // == NULL)
      {
      return( -4 );
      }

   GT_RefreshWindow( BTWnd, NULL );

   return( 0 );
}

PRIVATE int BTCloseWindow( void )
{
   CloseBTWindow();

   return( FALSE );
}

PRIVATE int BTVanillaKey( int whichKey )
{
   int rval = TRUE;

   switch (whichKey)
      {
      case 'c':
      case 'C':
         rval = ContBtClicked();
         break;
         
      case 's':
      case 'S':
         rval = StopBtClicked();
         break;
          
      case 'e':
      case 'E':
         rval = ExamBtClicked();
         break;
         
      case 'x':
      case 'X':
         rval = ExitBtClicked();
         break;

      default:
         break;
      }

   return( rval );
}

PRIVATE int HandleBTIDCMP( void )
{
   struct IntuiMessage *m;
   int                (*func)( void );
   BOOL                 running = TRUE;

   while (running == TRUE)
      {
      if (!(m = GT_GetIMsg( BTWnd->UserPort ))) // == NULL) 
         {
         (void) Wait( 1L << BTWnd->UserPort->mp_SigBit );

         continue;
         }

      CopyMem( (char *) m, (char *) &BTMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (BTMsg.Class)
         {
         case IDCMP_CLOSEWINDOW:
            running = BTCloseWindow();
            break;

         case IDCMP_GADGETDOWN:
         case IDCMP_GADGETUP:
            func = (int (*)( void )) ((struct Gadget *)BTMsg.IAddress)->UserData;

            if (func) // != NULL)
               running = func();

            break;

         case IDCMP_VANILLAKEY:
            running = BTVanillaKey( BTMsg.Code );
            break;

         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( BTWnd );

            GT_EndRefresh( BTWnd, TRUE );

            break;
         }
      }

   return( running );
}

// ----------------------------------------------------------------

PRIVATE void CloseBackTracer( void )
{
   CloseBTWindow();

   Guarded_FreeLV( TraceLV_lvm );
 
   return;
}

PRIVATE int SetupBackTracer( void )
{
   int rval = RETURN_OK;
   
//   (void) TraceCatalog(); // Done is Setup.c file. 

   BTFont = Scr->Font;

   if (OpenBTWindow() < 0)
      {
      rval = ERROR_ON_OPENING_WINDOW;

      CloseBackTracer();

      goto exitSetup;
      }

   TraceLV_lvm = Guarded_AllocLV( TLV_NUM_ELEMENTS, ELEMENT_SIZE );

   if (!TraceLV_lvm) // == NULL)
      {
      rval = ERROR_NO_FREE_STORE;

      CloseBackTracer();

      goto exitSetup;
      }
   else
      {
      SetupList( &TraceLVList, TraceLV_lvm );

      ModifyListView( BTGadgets[ ID_TraceLV ], BTWnd, &TraceLVList, NULL );
      }

exitSetup:

   return( rval );
}

PUBLIC INTERPRETER *BackTracer( INTERPRETER *startInterp )
{
   char  fn[512] = { 0, }, *getFileName = &fn[0];
   int   error = RETURN_OK;

   if (!Scr) // == NULL)
      Scr = GetActiveScreen();
         
   if ((error = SetupBackTracer()) != RETURN_OK)
      {
      return( (INTERPRETER *) o_nil );
      }
      
   interp = startInterp;
   
   SetNotifyWindow( BTWnd );

//   SetTagItem( LoadTags, ASLFR_InitialDrawer, (ULONG) "Amigatalk:" );

//   SetTagItem( &LoadTags[0], ASLFR_Window, (ULONG) BTWnd );
//   if (FileReq( getFileName, &LoadTags[0] ) < 1) etc...

   StringNCopy( getFileName, "AmigaTalk:BackTrace", 512 );
      
   BTFileName = getFileName;
   
   if (!(outf = fopen( BTFileName, "w+" ))) // == NULL)
      {
      error = IoErr();
      
      CloseBackTracer();

      interp = (INTERPRETER *) o_nil;
             
      goto exitBackTracer;
      }

   fillInTracings();
              
   (void) HandleBTIDCMP();

   CloseBackTracer();

   if (outf) // != NULL)
      fclose( outf);

exitBackTracer:
      
   return( interp );
}

/* --------------- END of ATalkTracer.c file! ------------------ */
