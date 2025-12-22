/***************************************************************
**  Z80SimClearBrkPt.c - Clear BreakPoint requester code
**                       for the Z80Simulator program.
**
**  Functional interface:
**
**     PUBLIC int HandleClearBreakPt( void );
**
**  RETURNS:  0 for success, -1 for failure.
**
**  GUI Designed by : Jim Steichen
****************************************************************/

#include <stdio.h>
#include <string.h>

#include <exec/types.h>

#include <AmigaDOSErrs.h>

#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/imageclass.h>
#include <intuition/gadgetclass.h>

#include <libraries/gadtools.h>

#include <graphics/displayinfo.h>
#include <graphics/gfxbase.h>

#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/graphics_protos.h>
#include <clib/utility_protos.h>

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "Z80Sim.h"
#include "Z80BKPT.h"

#define ListViewGadget 0
#define OkayButton     1
#define AbortButton    2

#define CBrkPt_CNT     3

/* ------------------------------- Located in Z80SimGTGUI.c file: */
IMPORT struct Screen   *Scr;
IMPORT struct TextAttr topaz8;
IMPORT APTR            VisualInfo;
/* ------------------------------- */

/* ------------------------------- Located in SetBrkPt.c file: */
IMPORT struct List BreakPtList;
IMPORT struct Node BreakPtItems[];
IMPORT char        *BrkStrs;       // [MAXBKPT][BREAKLINE_LENGTH] 

#define BREAK_STR( i ) (BrkStrs + i * BREAKLINE_LENGTH)
/* ------------------------------- */

PRIVATE struct Window       *CBrkPtWnd   = NULL;
PRIVATE struct Gadget       *CBrkPtGList = NULL;
PRIVATE struct IntuiMessage  CBrkPtMsg;
PRIVATE struct Gadget       *CBrkPtGadgets[3];

PRIVATE UWORD  CBrkPtLeft   = 330;
PRIVATE UWORD  CBrkPtTop    = 155;
PRIVATE UWORD  CBrkPtWidth  = 281;
PRIVATE UWORD  CBrkPtHeight = 272;
PRIVATE UBYTE *CBrkPtWdt    = "Clear a BreakPoint:";

PRIVATE UWORD CBrkPtGTypes[] = {

   LISTVIEW_KIND, BUTTON_KIND, BUTTON_KIND
};


PRIVATE int ListViewClicked(    int whichitem );
PRIVATE int OkayButtonClicked(  int dummy );
PRIVATE int AbortButtonClicked( int dummy );

PRIVATE struct NewGadget CBrkPtNGad[] = {

     6,  16, 262, 224, (UBYTE *)"BreakPoints:", NULL, 
     ListViewGadget, PLACETEXT_ABOVE | NG_HIGHLABEL, NULL, 
     (APTR) ListViewClicked,
     
     6, 242,  62,  21, (UBYTE *)" _CLEAR ",     NULL, 
     OkayButton, PLACETEXT_IN, NULL, (APTR) OkayButtonClicked,

   146, 242,  62,  21, (UBYTE *)" _ABORT ",     NULL, 
   AbortButton, PLACETEXT_IN, NULL, (APTR) AbortButtonClicked
};

PRIVATE ULONG CBrkPtGTags[] = {

   (GTLV_ShowSelected), NULL, (TAG_DONE),
   (GT_Underscore),      '_', (TAG_DONE),
   (GT_Underscore),      '_', (TAG_DONE)
};

/* ------------------------------------------------------------------ */

PRIVATE void ClearBreakPoint( int whichitem )
{
   char CBPNIL[80], *TheBreakStr = &CBPNIL[0];
   int  index = 0;
   
   (void) strcpy( TheBreakStr, BREAK_STR( whichitem ) );
   *TheBreakStr       = '*';
   *(TheBreakStr + 1) = '*';

   index                        = atoi( &TheBreakStr[3] );
   breakpoint[ index ].BkptFlag = CLRBKPT;

   GT_SetGadgetAttrs( CBrkPtGadgets[ ListViewGadget ], CBrkPtWnd, NULL,
                      GTLV_Labels, ~NULL,
                      TAG_END
                    );
   
   (void) strcpy( BREAK_STR( whichitem ), TheBreakStr );

   GT_SetGadgetAttrs( CBrkPtGadgets[ ListViewGadget ], CBrkPtWnd, NULL,
                      GTLV_Labels, &BreakPtList,
                      TAG_END
                    );
   return;
}

PRIVATE void CloseCBrkPtWindow( void )
{
   if (CBrkPtWnd) 
      {
      CloseWindow( CBrkPtWnd );
      CBrkPtWnd = NULL;
      }

   if (CBrkPtGList) 
      {
      FreeGadgets( CBrkPtGList );
      CBrkPtGList = NULL;
      }
   return;
}

PRIVATE int SelectedBrk = -1;

PRIVATE int ListViewClicked( int whichitem )
{
   SelectedBrk = whichitem - 1;
   return( (int) TRUE );
}

PRIVATE int OkayButtonClicked( int dummy )
{
   char CHKNIL[256], *Sanity = &CHKNIL[0];

   if (SelectedBrk < 0)
      {
      (void) Handle_Problem( "Select a BreakPoint first!", 
                             "Clear BreakPt Problem:", NULL 
                           );
      return( (int) TRUE );
      }
   else
      {    
      (void) strcpy( Sanity, "Really Clear " );
      (void) strcat( Sanity, BREAK_STR( SelectedBrk ) );
      (void) strcat( Sanity, "?\n   Click on CONTINUE!" );
   
      if (Handle_Problem( Sanity, "Clear BreakPt Sanity Check:", NULL ) == 0)
         {
         /* Okay, clear the selected breakpoint: */
         ClearBreakPoint( SelectedBrk );
         Delay( 50 );
         CloseCBrkPtWindow();

         return( (int) FALSE );
         }
      }
   return( (int) TRUE );
}


PRIVATE int AbortButtonClicked( int dummy )
{
   CloseCBrkPtWindow();
   return( (int) FALSE );
}


PRIVATE int OpenCBrkPtWindow( void )
{
   struct NewGadget ng;
   struct Gadget    *g;
   UWORD            lc, tc;
   UWORD            offx = Scr->WBorLeft, 
                    offy = Scr->WBorTop + Scr->RastPort.TxHeight + 1;

   if ((g = CreateContext( &CBrkPtGList )) == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < CBrkPt_CNT; lc++) 
      {
      CopyMem( (char *) &CBrkPtNGad[ lc ], (char *) &ng, 
               (long) sizeof( struct NewGadget )
             );

      ng.ng_VisualInfo = VisualInfo;
      ng.ng_TextAttr   = &topaz8;
      ng.ng_LeftEdge  += offx;
      ng.ng_TopEdge   += offy;

      CBrkPtGadgets[ lc ] = g = CreateGadgetA( 
                                       
                                 (ULONG) CBrkPtGTypes[ lc ], g,
                                 &ng, 
                                 (struct TagItem *) &CBrkPtGTags[ tc ] );

      while (CBrkPtGTags[ tc ] != TAG_DONE) 
         tc += 2;

      tc++;

      if (g == NULL)
         return( -2 );
      }

   if ((CBrkPtWnd = OpenWindowTags( NULL,

                             WA_Left,   CBrkPtLeft,
                             WA_Top,    CBrkPtTop,
                             WA_Width,  CBrkPtWidth,
                             WA_Height, CBrkPtHeight + offy,
                             WA_IDCMP,  LISTVIEWIDCMP | BUTTONIDCMP
                               | IDCMP_REFRESHWINDOW | IDCMP_VANILLAKEY,
                             
                             WA_Flags, WFLG_DRAGBAR | WFLG_DEPTHGADGET
                               | WFLG_SMART_REFRESH | WFLG_ACTIVATE
                               | WFLG_RMBTRAP,

                             WA_Gadgets,     CBrkPtGList,
                             WA_Title,       CBrkPtWdt,
                             TAG_DONE )
      ) == NULL)
      return( -4 );

   GT_SetGadgetAttrs( CBrkPtGadgets[ ListViewGadget ], CBrkPtWnd, NULL,
                      GTLV_Labels,       &BreakPtList,
                      GTLV_ShowSelected, NULL,
                      GTLV_Selected,     0,
                      GTLV_MaxPen,       255,
                      GTLV_ItemHeight,   12,
                      TAG_END
                    );

   GT_RefreshWindow( CBrkPtWnd, NULL );

   return( 0 );
}

PRIVATE int CBrkPtVanillaKey( int whichkey )
{
   int rval = TRUE;
   
   switch (whichkey)
      {
      case 'c':
      case 'C':
         rval = OkayButtonClicked( 0 );
         break;

      case 'a':
      case 'A':
         rval = AbortButtonClicked( 0 );
         break;
      }

   return( rval );
}

PRIVATE int HandleCBrkPtIDCMP( void )
{
   struct IntuiMessage *m;
   int                 (*func)();
   BOOL                running = TRUE;

   while (running == TRUE)
      {
      if ((m = GT_GetIMsg( CBrkPtWnd->UserPort )) == NULL) 
         {
         (void) Wait( 1L << CBrkPtWnd->UserPort->mp_SigBit );
         continue;
         }

      CopyMem( (char *) m, (char *) &CBrkPtMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (CBrkPtMsg.Class) 
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( CBrkPtWnd );
            GT_EndRefresh( CBrkPtWnd, TRUE );
            break;

         case IDCMP_VANILLAKEY:
            running = CBrkPtVanillaKey( CBrkPtMsg.Code );
            break;
            
         case IDCMP_GADGETUP:
            func    = (void *) ((struct Gadget *) 
                                CBrkPtMsg.IAddress)->UserData;
            running = func( (int) CBrkPtMsg.Code + 1 );
            break;
         }
      }
   return( running );
}

PUBLIC int HandleClearBreakPt( void )
{
   if (OpenCBrkPtWindow() < 0)
      {
      fprintf( stderr, "problem in Opening ClearBreakPt Requester!\n" );

      (void) Handle_Problem( "Couldn't open ClearBreakPt Requester!", 
                             "Clear BreakPt Requester Problem:", NULL 
                           );
      return( -1 );
      }

   (void) HandleCBrkPtIDCMP();

   return( 0 );
}

/* ---------------- END of Z80SimClearBrkPt.c file ---------------- */
