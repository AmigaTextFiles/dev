/****h* SysAssigns/AddAssign.c [1.0] ********************************
*
* NAME
*    AddAssign
*
* DESCRIPTION
*    Get an Assignment string & a pathname from the User.
* 
* FUNCTIONAL INTERFACE:
*
*    PUBLIC int AddAssignment( void );
*********************************************************************
*
*/

#include <string.h>

#include <exec/types.h>

#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/gadgetclass.h>

#include <libraries/gadtools.h>

#include <graphics/displayinfo.h>
#include <graphics/gfxbase.h>

#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/graphics_protos.h>
#include <clib/utility_protos.h>
#include <clib/diskfont_protos.h>

#include "CPGM:GlobalObjects/CommonFuncs.h"

#define StrBfPtr( g ) (((struct StringInfo *)g->SpecialInfo)->Buffer)

#define AssignStr 0
#define PathStr   1
#define OkayBt    2
#define CancelBt  3

#define AAR_CNT   4

#define ASSIGN_STR StrBfPtr( AARGadgets[ AssignStr ] )
#define PATH_STR   StrBfPtr( AARGadgets[ PathStr ] )

IMPORT struct Screen   *Scr;
IMPORT struct TextAttr *Font;
IMPORT struct CompFont  CFont;

IMPORT UBYTE           *PubScreenName;
IMPORT APTR             VisualInfo;
IMPORT char            *ErrMsg;

IMPORT struct IntuitionBase *IntuitionBase;
IMPORT struct Library       *GadToolsBase;

// --------------------------------------------------------------------

PUBLIC char an[256], *assignname = &an[0];
PUBLIC char pn[256], *pathname   = &pn[0];

// --------------------------------------------------------------------

PRIVATE struct TextFont     *AARFont  = NULL;
PRIVATE struct Window       *AARWnd   = NULL;
PRIVATE struct Gadget       *AARGList = NULL;
PRIVATE struct IntuiMessage  AARMsg;
PRIVATE struct Gadget       *AARGadgets[ AAR_CNT ];

PRIVATE UWORD  AARLeft   = 80;
PRIVATE UWORD  AARTop    = 32;
PRIVATE UWORD  AARWidth  = 415;
PRIVATE UWORD  AARHeight = 80;
PRIVATE UBYTE *AARWdt    = "Add an Assignment to the System:";


PRIVATE UWORD AARGTypes[] = {

   STRING_KIND, STRING_KIND, BUTTON_KIND, BUTTON_KIND
};

PRIVATE int AssignStrClicked( void );
PRIVATE int PathStrClicked(   void );
PRIVATE int OkayBtClicked(    void );
PRIVATE int CancelBtClicked(  void );

PRIVATE struct NewGadget AARNGad[] = {

    72,  5, 301, 18, (UBYTE *) "_Assign:",  NULL, AssignStr, 
   PLACETEXT_LEFT, NULL, (APTR) AssignStrClicked,

    72, 29, 301, 18, (UBYTE *) "_To Path:", NULL, PathStr, 
   PLACETEXT_LEFT, NULL, (APTR) PathStrClicked,

    18, 54,  65, 18, (UBYTE *) "_OKAY",     NULL, OkayBt, 
   PLACETEXT_IN, NULL, (APTR) OkayBtClicked,
 
   333, 54,  65, 18, (UBYTE *) "_CANCEL",   NULL, CancelBt, 
   PLACETEXT_IN, NULL, (APTR) CancelBtClicked
};

PRIVATE ULONG AARGTags[] = {

   (GTST_MaxChars), 256, (STRINGA_Justification), (GACT_STRINGCENTER), 
   (GT_Underscore), '_', (TAG_DONE),
   
   (GTST_MaxChars), 256, (STRINGA_Justification), (GACT_STRINGCENTER), 
   (GT_Underscore), '_', (TAG_DONE),
   
   (GT_Underscore), '_', (TAG_DONE),
   (GT_Underscore), '_', (TAG_DONE)
};

// --------------------------------------------------------------------

PRIVATE void CloseAARWindow( void )
{
   if (AARWnd != NULL) 
      {
      CloseWindow( AARWnd );
      AARWnd = NULL;
      }

   if (AARGList != NULL) 
      {
      FreeGadgets( AARGList );
      AARGList = NULL;
      }

   if (AARFont != NULL) 
      {
      CloseFont( AARFont );
      AARFont = NULL;
      }

   return;
}

PRIVATE BOOL GotAssignStr = FALSE;
PRIVATE BOOL GotPathStr   = FALSE;

PRIVATE int AssignStrClicked( void )
{
   strcpy( assignname, ASSIGN_STR );

   GotAssignStr = TRUE;

   return( (int) TRUE );
}

PRIVATE int PathStrClicked( void )
{
   strcpy( pathname, PATH_STR );
   
   GotPathStr = TRUE;
   
   return( (int) TRUE );
}

#define GOTASSIGN  2

PRIVATE int OkayBtClicked( void )
{
   if (GotAssignStr == FALSE)
      {
      SetReqButtons( "OKAY!" );
      
      (void) Handle_Problem( "Enter an Assignment first!",
                             "User ERROR:", NULL
                           );

      SetReqButtons( "CONTINUE|ABORT!" );
      return( (int) TRUE );
      }

   if (GotPathStr == FALSE)
      {
      SetReqButtons( "OKAY!" );
      
      (void) Handle_Problem( "Enter a Path to Assign to first!",
                             "User ERROR:", NULL
                           );

      SetReqButtons( "CONTINUE|ABORT!" );
      return( (int) TRUE );
      }

   CloseAARWindow();

   return( (int) GOTASSIGN );
}

PRIVATE int CancelBtClicked( void )
{
   strcpy( assignname, "" );
   strcpy( pathname,   "" );

   CloseAARWindow();

   return( (int) FALSE );
}

PRIVATE int AARVanillaKey( int whichkey )
{
   int rval = TRUE;

   switch (whichkey)
      {
      case 'a':
      case 'A':
         rval = AssignStrClicked();
         break;
         
      case 't':
      case 'T':
         rval = PathStrClicked();
         break;
         
      case 'o':
      case 'O':
         rval = OkayBtClicked();
         break;

      case 'c':
      case 'C':
      case 'q':
      case 'Q':
      case 'x':
      case 'X':
         rval = CancelBtClicked();

      default:
         break;
      }

   return( rval );
}

PRIVATE int OpenAARWindow( void )
{
   struct NewGadget  ng;
   struct Gadget    *g;
   UWORD             lc, tc;
   UWORD             wleft = AARLeft, wtop = AARTop, ww, wh;

   ComputeFont( Scr, Font, &CFont, AARWidth, AARHeight );

   ww = ComputeX( CFont.FontX, AARWidth );
   wh = ComputeY( CFont.FontY, AARHeight );

   if ((wleft + ww + CFont.OffX + Scr->WBorRight) > Scr->Width) 
      wleft = Scr->Width - ww;
   
   if ((wtop + wh + CFont.OffY + Scr->WBorBottom) > Scr->Height) 
      wtop = Scr->Height - wh;

   if ((AARFont = OpenDiskFont( Font )) == NULL)
      return( -5 );

   if ((g = CreateContext( &AARGList )) == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < AAR_CNT; lc++) 
      {
      CopyMem( (char *) &AARNGad[ lc ], (char *) &ng, 
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

      ng.ng_Width      = ComputeX( CFont.FontX, ng.ng_Width );
      ng.ng_Height     = ComputeY( CFont.FontY, ng.ng_Height);

      AARGadgets[ lc ] = g = CreateGadgetA( (ULONG) AARGTypes[ lc ], 
                               g, 
                               &ng, 
                               (struct TagItem *) &AARGTags[ tc ] );

      while (AARGTags[ tc ] != NULL) 
         tc += 2;
         
      tc++;

      if (g == NULL)
         return( -2 );
      }

   if ((AARWnd = OpenWindowTags( NULL,

                   WA_Left,        wleft,
                   WA_Top,         wtop,
                   WA_Width,       ww + CFont.OffX + Scr->WBorRight,
                   WA_Height,      wh + CFont.OffY + Scr->WBorBottom,

                   WA_IDCMP,       STRINGIDCMP | BUTTONIDCMP 
                     | IDCMP_VANILLAKEY | IDCMP_REFRESHWINDOW,

                   WA_Flags,       WFLG_DRAGBAR | WFLG_DEPTHGADGET
                     | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,

                   WA_Gadgets,     AARGList,
                   WA_Title,       AARWdt,
                   WA_ScreenTitle, "System Info:",
                   TAG_DONE )
      ) == NULL)
      return( -4 );

   GT_RefreshWindow( AARWnd, NULL );

   return( 0 );
}

PRIVATE int HandleAARIDCMP( void )
{
   struct IntuiMessage	*m;
   int			(*func)( void );
   BOOL			running = TRUE;

   while (running == TRUE)
      {
      if ((m = GT_GetIMsg( AARWnd->UserPort )) == NULL) 
         {
         (void) Wait( 1L << AARWnd->UserPort->mp_SigBit );
         continue;
         }

      CopyMem( (char *) m, (char *) &AARMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (AARMsg.Class) 
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( AARWnd );
            GT_EndRefresh( AARWnd, TRUE );
            break;

         case IDCMP_VANILLAKEY:
            running = AARVanillaKey( AARMsg.Code );
      	    break;

         case IDCMP_GADGETUP:
            func = (void *) ((struct Gadget *)AARMsg.IAddress)->UserData;
            
            if (func != NULL)
               running = func();
            
            break;
         }
      }

   return( running );
}

PUBLIC int AddAssignment( void )
{
   if (OpenAARWindow() < 0)
      {
      return( -1 );
      }
      
   return( HandleAARIDCMP() );
}

/* --------------- END of AddAssign.c file! --------------------- */
