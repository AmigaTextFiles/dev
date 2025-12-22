/****h* Z80Simulator/ShowBrkPt.c [2.5] ********************************
*
* NAME
*    ShowBrkPt.c
*
* DESCRIPTION
*    Show BreakPoint Requester code for the Z80 Simulator program.
*
* RETURNS
*    0 for success, -1 for failure.
*
* Functional interface:
*   PUBLIC int HandleShowBreakPt( void );
*
* GUI Designed by : Jim Steichen
***********************************************************************
*
*/

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

#define BrkListView  0
#define DoneButton   1

#define ShBP_CNT     2

/* ------------------------------- Located in Z80SimGTGUI.c file: */
IMPORT struct TextAttr topaz8;
IMPORT struct Screen   *Scr;
IMPORT UBYTE           *PubScreenName;
IMPORT APTR            VisualInfo;
/* ------------------------------- */

/* ------------------------------- Located in SetBrkPt.c file: */
IMPORT struct List BreakPtList;
IMPORT struct Node BreakPtItems[];
IMPORT char        *BrkStrs;       //[MAXBKPT][BREAKLINE_LENGTH];

#define BREAK_STR( i ) (BrkStrs + i * BREAKLINE_LENGTH)
/* ------------------------------- */

PRIVATE struct Window       *ShBPWnd    = NULL;
PRIVATE struct Gadget       *ShBPGList  = NULL;
PRIVATE struct IntuiMessage  ShBPMsg;
PRIVATE struct Gadget       *ShBPGadgets[2];

PRIVATE UWORD  ShBPLeft   = 330;
PRIVATE UWORD  ShBPTop    = 155;
PRIVATE UWORD  ShBPWidth  = 281;
PRIVATE UWORD  ShBPHeight = 272;
PRIVATE UBYTE *ShBPWdt    = "List of BreakPoints:";


PRIVATE UWORD ShBPGTypes[] = {

   LISTVIEW_KIND, BUTTON_KIND
};

PRIVATE int BrkListClicked( void );
PRIVATE int DoneBtClicked( void );

PRIVATE struct NewGadget ShBPNGad[] = {

    6,  16, 262, 224, (UBYTE *) "BreakPoints:", NULL, 
    BrkListView, PLACETEXT_ABOVE | NG_HIGHLABEL, NULL, 
    (APTR) BrkListClicked,
   
   74, 243,  62,  21, (UBYTE *) " _DONE",       NULL, 
   DoneButton, PLACETEXT_IN, NULL, (APTR) DoneBtClicked
};

PRIVATE ULONG ShBPGTags[] = {

   (GTLV_ReadOnly), TRUE, (TAG_DONE),
   (GT_Underscore),  '_', (TAG_DONE)
};

/* ----------------------------------------------------------------- */

/* routine when gadget "BreakPoints:" is clicked. */

PRIVATE int BrkListClicked( void )
{
   return( (int) TRUE );
}


PRIVATE void CloseShBPWindow( void )
{
   if (ShBPWnd != NULL) 
      {
      CloseWindow( ShBPWnd );
      ShBPWnd = NULL;
      }

   if (ShBPGList != NULL) 
      {
      FreeGadgets( ShBPGList );
      ShBPGList = NULL;
      }

   return;
}


PRIVATE int DoneBtClicked( void )
{
   CloseShBPWindow();

   return( (int) FALSE );
}


PRIVATE int OpenShBPWindow( void )
{
   struct NewGadget ng;
   struct Gadget    *g;
   UWORD            lc, tc;
   UWORD            offx = Scr->WBorLeft, 
                    offy = Scr->WBorTop + Scr->RastPort.TxHeight + 1;

   if ((g = CreateContext( &ShBPGList )) == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < ShBP_CNT; lc++) 
      {
      CopyMem( (char *) &ShBPNGad[ lc ], (char *) &ng, 
               (long) sizeof( struct NewGadget )
             );

      ng.ng_VisualInfo = VisualInfo;
      ng.ng_TextAttr   = &topaz8;
      ng.ng_LeftEdge  += offx;
      ng.ng_TopEdge   += offy;

      ShBPGadgets[ lc ] = g = CreateGadgetA( (ULONG) ShBPGTypes[ lc ], 
                               g, 
                               &ng, 
                               (struct TagItem *) &ShBPGTags[ tc ] );

      while (ShBPGTags[ tc ] != TAG_DONE) 
         tc += 2;

      tc++;

      if (g == NULL)
         return( -2 );
      }

   if ((ShBPWnd = OpenWindowTags( NULL,

                    WA_Left,        ShBPLeft,
                    WA_Top,         ShBPTop,
                    WA_Width,       ShBPWidth,
                    WA_Height,      ShBPHeight + offy,

                    WA_IDCMP,       LISTVIEWIDCMP | BUTTONIDCMP 
                      | IDCMP_REFRESHWINDOW | IDCMP_VANILLAKEY,

                    WA_Flags,       WFLG_DRAGBAR | WFLG_DEPTHGADGET
                      | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,

                    WA_Gadgets,     ShBPGList,
                    WA_Title,       ShBPWdt,
                    TAG_DONE )
      ) == NULL)
      return( -4 );

   GT_SetGadgetAttrs( ShBPGadgets[ BrkListView ], ShBPWnd, NULL,
                      GTLV_Labels,       &BreakPtList,
                      GTLV_ShowSelected, NULL,
                      GTLV_Selected,     0,
                      GTLV_MaxPen,       255,
                      GTLV_ItemHeight,   12,
                      TAG_END
                    );

   GT_RefreshWindow( ShBPWnd, NULL );

   return( 0 );
}

PRIVATE int ShBPVanillaKey( int whichkey )
{
   int rval = TRUE;
   
   switch (whichkey)
      {
      case 'd':
      case 'D':
      case 'o':
      case 'O':
         rval = DoneBtClicked();
         break;
      }
      
   return( rval );
}

PRIVATE int HandleShBPIDCMP( void )
{
   struct IntuiMessage *m;
   int                 (*func)();
   BOOL                running = TRUE;

   while (running == TRUE)
      {
      if ((m = GT_GetIMsg( ShBPWnd->UserPort )) == NULL) 
         {
         (void) Wait( 1L << ShBPWnd->UserPort->mp_SigBit );
         continue;
         }

      CopyMem( (char *) m, (char *) &ShBPMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );
      switch (ShBPMsg.Class) 
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( ShBPWnd );
            GT_EndRefresh( ShBPWnd, TRUE );
            break;

         case IDCMP_VANILLAKEY:
            running = ShBPVanillaKey( ShBPMsg.Code );
            break;
            
         case IDCMP_GADGETUP:
            func = (void *) ((struct Gadget *)ShBPMsg.IAddress)->UserData;
            
            if (func != NULL)
               running = func();
            
            break;
         }
      }

   return( running );
}

PUBLIC int HandleShowBreakPt( void )
{
   if (OpenShBPWindow() < 0)
      {
      fprintf( stderr, "problem in Opening ShowBreakPt Requester!\n" );

      (void) Handle_Problem( "Couldn't open Show BreakPt Requester!", 
                             "Show BreakPt Requester Problem:", NULL 
                           );
      return( -1 );
      }

   (void) HandleShBPIDCMP();

   return( 0 );
}

/* ------------------ END of ShowBrkPt.c file ------------------ */
