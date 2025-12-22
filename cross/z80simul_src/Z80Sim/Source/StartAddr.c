/****h* Z80Simulator/StartAddr.c [2.5] ********************************
*
* NAME
*    StartAddr.c
*
* DESCRIPTION
*    Jump to Address requester for the Z80 Simulator program.
*
* RETURNS
*    0 for success, -1 for failure.
*
* Functional interface:
*   PUBLIC int HandleStartAddr( void );
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

#define StrBfPtr( g ) (((struct StringInfo *)g->SpecialInfo)->Buffer)

#define SASTRING  0
#define OkayBt    1
#define AbortBt   2

#define SA_CNT    3

/* ----------------------------------- Located in Z80SimGTGUI.c file */
IMPORT struct TextAttr topaz8;
IMPORT struct Screen   *Scr;
IMPORT UBYTE           *PubScreenName;
IMPORT APTR            VisualInfo;
IMPORT unsigned short  ToAddress; 
IMPORT unsigned short  FromAddress; 
/* ----------------------------------- */

PRIVATE struct Window         *SAWnd    = NULL;
PRIVATE struct Gadget         *SAGList  = NULL;
PRIVATE struct IntuiMessage    SAMsg;
PRIVATE struct Gadget         *SAGadgets[3];

PRIVATE UWORD  SALeft   = 320;
PRIVATE UWORD  SATop    = 155;
PRIVATE UWORD  SAWidth  = 280;
PRIVATE UWORD  SAHeight = 88;
PRIVATE UBYTE *SAWdt    = "Enter a Start Address:";


PRIVATE struct IntuiText SAIText[] = {

   2, 0, JAM1,  57,  5, &topaz8, (UBYTE *) "(Use HexaDecimal!)", 
   &SAIText[1],
   
   1, 0, JAM1, 158, 24, &topaz8, (UBYTE *) "(PC)", NULL 
};

PRIVATE UWORD SAGTypes[] = {

   STRING_KIND, BUTTON_KIND, BUTTON_KIND
};

PRIVATE int AddrStrClicked( void );
PRIVATE int OkayClicked( void );
PRIVATE int AbortClicked( void );

PRIVATE struct NewGadget SANGad[] = {

    93, 21, 61, 15, (UBYTE *) "Go To:",   NULL, SASTRING, 
    PLACETEXT_LEFT, NULL, (APTR) AddrStrClicked,
    
     7, 55, 58, 22, (UBYTE *) " _OKAY ",  NULL, OkayBt, 
     PLACETEXT_IN, NULL, (APTR) OkayClicked,

   201, 55, 68, 22, (UBYTE *) " _ABORT ", NULL, AbortBt, 
   PLACETEXT_IN, NULL, (APTR) AbortClicked
};

PRIVATE ULONG SAGTags[] = {

   (GA_TabCycle), FALSE, (GTST_MaxChars), 7, 
   (STRINGA_Justification), (GACT_STRINGCENTER), (TAG_DONE),
   
   (GT_Underscore), '_', (TAG_DONE),
   (GT_Underscore), '_', (TAG_DONE)
};

/* -------------------------------------------------------------------- */

PRIVATE BOOL ValidAddress = FALSE;
PRIVATE int  StartAddr    = 0;

PRIVATE int AddrStrClicked( void )
{
   /* Verify the entry is a good Z80 address between 0 & 0xFFFF
   ** first, then set the global flag so that a click on the okay
   ** gadget will set the PCReg[] correctly.
   */

   (void) stch_i( (char *) StrBfPtr( SAGadgets[0] ), &StartAddr );

   if (StartAddr >= 0 && StartAddr <= 0xFFFF)
      ValidAddress = TRUE;
   else
      {
      GT_SetGadgetAttrs( SAGadgets[ 0 ], SAWnd, NULL,
                         GTST_String, (STRPTR) "",
                         TAG_END
                       );
      ValidAddress = FALSE;
      (void) Handle_Problem( "Entered Address out of 16-bit range!", 
                             "Z80 Addressing Problem:", NULL 
                           );
      }

   return( (int) TRUE );
}

PRIVATE void CloseSAWindow( void )
{
   if (SAWnd != NULL) 
      {
      CloseWindow( SAWnd );
      SAWnd = NULL;
      }

   if (SAGList != NULL) 
      {
      FreeGadgets( SAGList );
      SAGList = NULL;
      }

   return;
}

PRIVATE int OkayClicked( void )
{
   /* Verify the entry is a good Z80 address between 0 & 0xFFFF
   ** first, then set the global flag so that a click on the okay
   ** gadget will set the PCReg[] correctly.
   */
   (void) stch_i( (char *) StrBfPtr( SAGadgets[0] ), &StartAddr );

   if (ValidAddress == TRUE)
      {
      CloseSAWindow();

      return( (int) FALSE );
      }
   else 
      {
      if (StartAddr >= 0 && StartAddr <= 0xFFFF)
         {
         CloseSAWindow();
         ValidAddress = TRUE;

         return( (int) FALSE );
         }
      else
         {
         GT_SetGadgetAttrs( SAGadgets[ 0 ], SAWnd, NULL,
                            GTST_String, (STRPTR) "",
                            TAG_END
                          );
         ValidAddress = FALSE;
         (void) Handle_Problem( "Entered Address out of 16-bit range!", 
                                "Z80 Addressing Problem:", NULL 
                              );
         }

      return( (int) TRUE );
      }
}

PRIVATE int AbortClicked( void )
{
   ValidAddress = FALSE;

   CloseSAWindow();

   return( (int) FALSE );
}


PRIVATE void SARender( void )
{
   UWORD offx, offy;

   offx = SAWnd->BorderLeft;
   offy = SAWnd->BorderTop;

   PrintIText( SAWnd->RPort, SAIText, offx, offy );

   return;
}

PRIVATE int OpenSAWindow( void )
{
   struct NewGadget ng;
   struct Gadget    *g;
   UWORD            lc, tc;
   UWORD            offx = Scr->WBorLeft, 
                    offy = Scr->WBorTop + Scr->RastPort.TxHeight + 1;

   if ((g = CreateContext( &SAGList )) == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < SA_CNT; lc++) 
      {
      CopyMem( (char *) &SANGad[ lc ], (char *) &ng, 
               (long) sizeof( struct NewGadget )
             );

      ng.ng_VisualInfo = VisualInfo;
      ng.ng_TextAttr   = &topaz8;
      ng.ng_LeftEdge  += offx;
      ng.ng_TopEdge   += offy;

      SAGadgets[ lc ] = g = CreateGadgetA( (ULONG) SAGTypes[ lc ], 
                              g, 
                              &ng, 
                              (struct TagItem *) &SAGTags[ tc ] );

      while (SAGTags[ tc ] != TAG_DONE) 
         tc += 2;

      tc++;

      if (g == NULL)
         return( -2 );
      }

   if ((SAWnd = OpenWindowTags( NULL,

                   WA_Left,        SALeft,
                   WA_Top,         SATop,
                   WA_Width,       SAWidth,
                   WA_Height,      SAHeight + offy,
                   
                   WA_IDCMP,       STRINGIDCMP | BUTTONIDCMP 
                     | IDCMP_REFRESHWINDOW | IDCMP_VANILLAKEY,

                   WA_Flags,       WFLG_DRAGBAR | WFLG_DEPTHGADGET
                     | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,

                   WA_Gadgets,     SAGList,
                   WA_Title,       SAWdt,
                   TAG_DONE )
      ) == NULL)
      return( -4 );

   GT_RefreshWindow( SAWnd, NULL );
   SARender();

   return( 0 );
}

PRIVATE int SAVanillaKey( int whichkey )
{
   int rval = TRUE;
   
   switch (whichkey)
      {
      case 'o':
      case 'O':
         rval = OkayClicked();
         break;

      case 'a':
      case 'A':
         rval = AbortClicked();
         break;
      }
      
   return( rval );
}

PRIVATE int HandleSAIDCMP( void )
{
   struct IntuiMessage *m;
   int                 (*func)();
   BOOL                running = TRUE;

   while (running == TRUE)
      {
      if ((m = GT_GetIMsg( SAWnd->UserPort )) == NULL) 
         {
         (void) Wait( 1L << SAWnd->UserPort->mp_SigBit );
         continue;
         }

      CopyMem( (char *) m, (char *) &SAMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );
      switch (SAMsg.Class) 
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( SAWnd );
            SARender();
            GT_EndRefresh( SAWnd, TRUE );
            break;

         case IDCMP_VANILLAKEY:
            running = SAVanillaKey( SAMsg.Code );
            break;
            
         case IDCMP_GADGETUP:
            func = (void *) ((struct Gadget *)SAMsg.IAddress)->UserData;
           
            if (func != NULL)
               running = func();
           
            break;
         }
      }

   return( running );
}


PUBLIC int HandleStartAddr( void )
{
   if (OpenSAWindow() < 0)
      {
      fprintf( stderr, "problem in Opening Start Address Requester!\n" );

      (void) Handle_Problem( "Couldn't open Start Requester!", 
                             "Start Address Problem:", NULL 
                           );
      return( -1 );
      }

   (void) HandleSAIDCMP();

   if (ValidAddress == TRUE)
      FromAddress = ToAddress = StartAddr;

   return( 0 );
}

/* --------------------- END of StartAddr.c file -------------- */
