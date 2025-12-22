/****h* Z80Simulator/IM0Req.c [2.5] *********************************
*
* NAME
*    IM0Req.c
*
* DESCRIPTION
*    Interrupt Mode 0 requester for the Z80 Simulator.
*
* Functional interface:
*   PUBLIC int HandleIM0Req( void );
*
* RETURNS
*    -1 for failure, 0 through 7 for the vector selected, or
*       > 7 for HALT button being pressed.
*       The vector selected corresponds to:
*
*               0 ->  RST 00H
*               1 ->  RST 08H
*               2 ->  RST 10H
*               3 ->  RST 18H
*               4 ->  RST 20H
*               5 ->  RST 28H
*               6 ->  RST 30H
*               7 ->  RST 38H
*
*  GUI Designed by : Jim Steichen
*********************************************************************
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

#define VectorBts  0
#define OKAYBT     1
#define HALTBT     2

#define IM0_CNT    3

/* ----------------------------------- Located in Z80SimGTGUI.c file */
IMPORT struct TextAttr topaz8;
IMPORT struct Screen   *Scr;
IMPORT UBYTE           *PubScreenName;
IMPORT APTR            VisualInfo;
/* ----------------------------------- */

PRIVATE struct Window       *IM0Wnd    = NULL;
PRIVATE struct Gadget       *IM0GList  = NULL;
PRIVATE struct IntuiMessage  IM0Msg;
PRIVATE struct Gadget       *IM0Gadgets[3];

PRIVATE UWORD  IM0Left   = 320;
PRIVATE UWORD  IM0Top    = 155;
PRIVATE UWORD  IM0Width  = 270;
PRIVATE UWORD  IM0Height = 137;
PRIVATE UBYTE *IM0Wdt    = "Select Mode 0 Interrupt:";

PRIVATE UBYTE *M0BtLabels[] = {

   (UBYTE *)"RST 00H", (UBYTE *)"RST 08H",
   (UBYTE *)"RST 10H", (UBYTE *)"RST 18H",
   (UBYTE *)"RST 20H", (UBYTE *)"RST 28H",
   (UBYTE *)"RST 30H", (UBYTE *)"RST 38H",
   NULL 
};


PRIVATE UWORD IM0GTypes[] = {

   MX_KIND, BUTTON_KIND, BUTTON_KIND
};

PRIVATE int Mode0ButtonsClicked( int GadgetNum );
PRIVATE int OkayBtClicked( int dummy );
PRIVATE int HaltBtClicked( int dummy );

PRIVATE struct NewGadget IM0NGad[] = {

   149,   4, 17,  9, NULL,               NULL, VectorBts, 
   PLACETEXT_LEFT, NULL, (APTR) Mode0ButtonsClicked,
   
     8, 101, 66, 29, (UBYTE *)" _OKAY ", NULL, OKAYBT, 
   PLACETEXT_IN, NULL, (APTR) OkayBtClicked,
   
   194, 100, 61, 28, (UBYTE *)" _HALT ", NULL, HALTBT, 
   PLACETEXT_IN, NULL, (APTR) HaltBtClicked
};

PRIVATE ULONG IM0GTags[] = {

   (GTMX_Labels), (ULONG) &M0BtLabels[ 0 ], (GTMX_Spacing), 3, (TAG_DONE),
   (GT_Underscore), '_', (TAG_DONE),
   (GT_Underscore), '_', (TAG_DONE)
};

// ------------------------------------------------------------------

PRIVATE void CloseIM0Window( void )
{
   if (IM0Wnd != NULL) 
      {
      CloseWindow( IM0Wnd );
      IM0Wnd = NULL;
      }

   if (IM0GList != NULL) 
      {
      FreeGadgets( IM0GList );
      IM0GList = NULL;
      }

   return;
}

#define HALT_ME  108

PRIVATE int Mode0Vector = 0; /* for communicating with the handler */

PRIVATE int Mode0ButtonsClicked( int GadgetNum )
{
   Mode0Vector = GadgetNum;

   return( (int) TRUE );
}

PRIVATE int OkayBtClicked( int dummy )
{
   CloseIM0Window();

   return( (int) FALSE );
}

PRIVATE int HaltBtClicked( int dummy )
{
   CloseIM0Window();

   return( HALT_ME );
}


PRIVATE int OpenIM0Window( void )
{
   struct NewGadget ng;
   struct Gadget    *g;
   UWORD            lc, tc;
   UWORD            offx = Scr->WBorLeft, 
                    offy = Scr->WBorTop + Scr->RastPort.TxHeight + 1;

   if ((g = CreateContext( &IM0GList )) == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < IM0_CNT; lc++) 
      {
      CopyMem( (char *) &IM0NGad[ lc ], (char *) &ng, 
               (long) sizeof( struct NewGadget )
             );

      ng.ng_VisualInfo = VisualInfo;
      ng.ng_TextAttr   = &topaz8;
      ng.ng_LeftEdge  += offx;
      ng.ng_TopEdge   += offy;

      IM0Gadgets[ lc ] = g = CreateGadgetA( (ULONG) IM0GTypes[ lc ], 
                              g, 
                              &ng, 
                              (struct TagItem *) &IM0GTags[ tc ] );

      while (IM0GTags[ tc ] != TAG_DONE) 
         tc += 2;

      tc++;

      if (g == NULL)
         return( -2 );
      }

   if ((IM0Wnd = OpenWindowTags( NULL,

                    WA_Left,        IM0Left,
                    WA_Top,         IM0Top,
                    WA_Width,       IM0Width,
                    WA_Height,      IM0Height + offy,
                    WA_IDCMP,       MXIDCMP | BUTTONIDCMP 
                      | IDCMP_REFRESHWINDOW | IDCMP_VANILLAKEY,
                    
                    WA_Flags,       WFLG_DRAGBAR | WFLG_DEPTHGADGET
                      | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,

                    WA_Gadgets,     IM0GList,
                    WA_Title,       IM0Wdt,
                    TAG_DONE )
      ) == NULL)
      return( -4 );

   GT_RefreshWindow( IM0Wnd, NULL );

   return( 0 );
}

PRIVATE int IM0VanillaKey( int whichkey )
{
   int rval = TRUE;
   
   switch (whichkey)
      {
      case 'o':
      case 'O':
         rval = OkayBtClicked( 0 );
         break;

      case 'h':
      case 'H':
         rval = HaltBtClicked( 0 );
         break;
      }
      
   return( rval );
}

PRIVATE int HandleIM0IDCMP( void )
{
   struct IntuiMessage *m;
   int                 (*func)( int GadNum );
   BOOL                running = TRUE;

   while (running == TRUE)
      {
      if ((m = GT_GetIMsg( IM0Wnd->UserPort )) == NULL) 
         {
         (void) Wait( 1L << IM0Wnd->UserPort->mp_SigBit );
         continue;
         }

      CopyMem( (char *) m, (char *) &IM0Msg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (IM0Msg.Class) 
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( IM0Wnd );
            GT_EndRefresh( IM0Wnd, TRUE );
            break;

         case IDCMP_VANILLAKEY:
            running = IM0VanillaKey( IM0Msg.Code );
            break;
            
         case IDCMP_GADGETUP:
         case IDCMP_GADGETDOWN:
            func = (void *) ((struct Gadget *)IM0Msg.IAddress)->UserData;
            
            if (func != NULL)
               running = func( IM0Msg.Code );

            break;
         }
      }

   return( running );
}


PUBLIC int HandleIM0Req( void )
{
   int response = FALSE, rval = 0;

   if (OpenIM0Window() < 0)
      {
      fprintf( stderr, "problem in Mode 0 Interrupt Requester!\n" );

      (void) Handle_Problem( "Couldn't open IM 0 Requester!", 
                             "Mode 0 Requester Problem:", NULL 
                           );
      return( -1 );
      }

   if ((response = HandleIM0IDCMP()) == FALSE)
      {
      rval = Mode0Vector & 0x00000007;
      return( rval );
      }
   else             /* User must have selected the HALT gadget! */
      return( 10 );
}

/* -------------------- END of IM0Req.c file ------------------------ */
