/****h* Z80Simulator/DumpMem.c [2.5] ****************************
*
* NAME
*    DumpMem.c
*
* DESCRIPTION
*    Memory Dump requester for the Z80Simulator program.
*
* Functional interface:
*    PUBLIC int HandleDumpReq( void );
*
* RETURNS
*    0 for success, -1 for failure.
*
* GUI Designed by : Jim Steichen
*****************************************************************
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

#define DumpStartStr    0
#define DumpOkayButton  1
#define DumpAbortButton 2
#define DumpEndStr      3

#define Dump_CNT        4

/* ----------------------------------- Located in Z80SimGTGUI.c file: */
IMPORT struct Screen   *Scr;
IMPORT struct TextAttr topaz8;
IMPORT UBYTE           *PubScreenName;
IMPORT APTR            VisualInfo;
IMPORT unsigned short  FromAddress;
IMPORT unsigned short  ToAddress;
/* ----------------------------------- */

PRIVATE struct Window       *DumpWnd   = NULL;
PRIVATE struct Gadget       *DumpGList = NULL;
PRIVATE struct IntuiMessage  DumpMsg;
PRIVATE struct Gadget       *DumpGadgets[4];

PRIVATE UWORD  DumpLeft   = 320;
PRIVATE UWORD  DumpTop    = 155;
PRIVATE UWORD  DumpWidth  = 280;
PRIVATE UWORD  DumpHeight = 88;
PRIVATE UBYTE *DumpWdt    = "Enter a Dump Range:";


PRIVATE struct IntuiText DumpIText[] = {

   2, 0, JAM1,57, 5, &topaz8, (UBYTE *) "(Use HexaDecimal!)", NULL 
};

PRIVATE UWORD DumpGTypes[] = {

   STRING_KIND, BUTTON_KIND,
   BUTTON_KIND, STRING_KIND
};


PRIVATE int DumpStartStrClicked( void );
PRIVATE int DumpEndStrClicked( void );
PRIVATE int OkayButtonClicked( void );
PRIVATE int AbortButtonClicked( void );

PRIVATE struct NewGadget DumpNGad[] = {

    59, 22, 61, 15, (UBYTE *) "Start:",   NULL, DumpStartStr, 
    PLACETEXT_LEFT, NULL, (APTR) DumpStartStrClicked,
    
     7, 55, 58, 22, (UBYTE *) " _OKAY ",  NULL, DumpOkayButton, 
     PLACETEXT_IN, NULL, (APTR) OkayButtonClicked,
   
   201, 55, 68, 22, (UBYTE *) " _ABORT ", NULL, DumpAbortButton, 
   PLACETEXT_IN, NULL, (APTR) AbortButtonClicked,
   
   202, 22, 61, 15, (UBYTE *) "End:",     NULL, DumpEndStr, 
   PLACETEXT_LEFT, NULL, (APTR) DumpEndStrClicked
};

PRIVATE ULONG DumpGTags[] = {

   (GA_TabCycle),   FALSE, (GTST_MaxChars), 7, (STRINGA_Justification), 
   (GACT_STRINGCENTER), (TAG_DONE),
   
   (GT_Underscore),   '_', (TAG_DONE),
   (GT_Underscore),   '_', (TAG_DONE),
   
   (GA_TabCycle),   FALSE, (GTST_MaxChars), 7, (STRINGA_Justification), 
   (GACT_STRINGCENTER), (TAG_DONE)
};


/* ------------------------------------------------------------------ */

PRIVATE BOOL ValidStartAddress = FALSE;
PRIVATE BOOL ValidEndAddress   = FALSE;
PRIVATE int  StartAddr         = 0;
PRIVATE int  EndAddr           = 0;

PRIVATE int DumpStartStrClicked( void )
{
   (void) stch_i( (char *) StrBfPtr( DumpGadgets[0] ), &StartAddr );

   /* Verify correct address range was entered: */

   if (StartAddr >= 0 && StartAddr < 0xFFFF)
      {
      ValidStartAddress = TRUE;
      FromAddress       = StartAddr;
      }
   else
      {
      (void) Handle_Problem( "Starting address out of range!", 
                             "Dump Stack Problem:", NULL 
                           );

      ValidStartAddress = FALSE;
      FromAddress       = 0;

      GT_SetGadgetAttrs( DumpGadgets[ 0 ], DumpWnd, NULL,
                         GTST_String, (STRPTR) "",
                         TAG_END
                       );
      }

   return( (int) TRUE  );
}

PRIVATE int DumpEndStrClicked( void )
{
   (void) stch_i( (char *) StrBfPtr( DumpGadgets[3] ), &EndAddr );

   /* Verify correct address range was entered: */

   if (EndAddr > 0 && EndAddr <= 0xFFFF)
      {
      ValidEndAddress = TRUE;
      ToAddress       = EndAddr;
      }
   else
      {
      (void) Handle_Problem( "Ending address out of range!", 
                             "Dump Stack Problem:", NULL 
                           );

      ValidEndAddress = FALSE;
      ToAddress       = 0;

      GT_SetGadgetAttrs( DumpGadgets[ 3 ], DumpWnd, NULL,
                         GTST_String, (STRPTR) "",
                         TAG_END
                       );
      }

   return( (int) TRUE  );
}

PRIVATE void CloseDumpWindow( void )
{
   if (DumpWnd) 
      {
      CloseWindow( DumpWnd );
      DumpWnd = NULL;
      }

   if (DumpGList) 
      {
      FreeGadgets( DumpGList );
      DumpGList = NULL;
      }
   return;
}

#define OPEN_DUMP_CONSOLE 10

PRIVATE int OkayButtonClicked( void )
{
   /* User has to press <RETURN> in both string gadgets for this
   ** test to pass:
   */
   if (ValidStartAddress == TRUE && ValidEndAddress == TRUE)
      goto SkipTesting;
      

   /* Check & make sure that the user entered sane values into the 
   ** start & end address string gadgets:
   */
   (void) stch_i( (char *) StrBfPtr( DumpGadgets[0] ), &StartAddr );

   if (StartAddr >= 0 && StartAddr < 0xFFFF)
      {
      ValidStartAddress = TRUE;
      FromAddress       = StartAddr;
      }
   else
      {
      (void) Handle_Problem( "Starting Address out of range!", 
                             "DumpMem Problem:", NULL 
                           );

      ValidStartAddress = FALSE;
      FromAddress       = 0;
      
      GT_SetGadgetAttrs( DumpGadgets[ 0 ], DumpWnd, NULL,
                         GTST_String, (STRPTR) "",
                         TAG_END
                       );

      return( (int) TRUE );
      }

   (void) stch_i( (char *) StrBfPtr( DumpGadgets[3] ), &EndAddr );

   if (EndAddr > 0 && EndAddr <= 0xFFFF)
      {
      ValidEndAddress = TRUE;
      ToAddress       = EndAddr;
      }
   else
      {
      (void) Handle_Problem( "Ending Address out of range!", 
                             "DumpMem Problem:", NULL 
                           );

      ValidEndAddress = FALSE;
      ToAddress       = 0;
      
      GT_SetGadgetAttrs( DumpGadgets[ 3 ], DumpWnd, NULL,
                         GTST_String, (STRPTR) "",
                         TAG_END
                       );
      
      return( (int) TRUE );
      }

SkipTesting:

   if (StartAddr > EndAddr)
      {
      (void) Handle_Problem( "End Address < Start Address!", 
                             "DumpMem Problem:", NULL 
                           );

      FromAddress       = ToAddress       = 0;
      ValidStartAddress = ValidEndAddress = FALSE;
      return( (int) TRUE );
      }
   else
      {
      FromAddress       = StartAddr;
      ToAddress         = EndAddr;
      ValidStartAddress = ValidEndAddress = TRUE;
      CloseDumpWindow();
      return( OPEN_DUMP_CONSOLE );  /* the Only Good exit point. */
      }
}

PRIVATE int AbortButtonClicked( void )
{
   ToAddress         = FromAddress     = 0;
   ValidStartAddress = ValidEndAddress = FALSE;

   CloseDumpWindow();

   return( FALSE );
}


PRIVATE void DumpRender( void )
{
   UWORD offx, offy;

   offx = DumpWnd->BorderLeft;
   offy = DumpWnd->BorderTop;
   
   PrintIText( DumpWnd->RPort, DumpIText, offx, offy );

   return;
}

PRIVATE int OpenDumpWindow( void )
{
   struct NewGadget ng;
   struct Gadget    *g;
   UWORD            lc, tc;
   UWORD            offx = Scr->WBorLeft, 
                    offy = Scr->WBorTop + Scr->RastPort.TxHeight + 1;

   if ((g = CreateContext( &DumpGList )) == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < Dump_CNT; lc++) 
      {
      CopyMem( (char *) &DumpNGad[ lc ], (char *) &ng, 
               (long) sizeof( struct NewGadget )
             );

      ng.ng_VisualInfo = VisualInfo;
      ng.ng_TextAttr   = &topaz8;
      ng.ng_LeftEdge  += offx;
      ng.ng_TopEdge   += offy;

      DumpGadgets[ lc ] = g = CreateGadgetA( (ULONG) DumpGTypes[ lc ], g, 
                               &ng, 
                               (struct TagItem *) &DumpGTags[ tc ] );

      while (DumpGTags[ tc ] != TAG_DONE) 
         tc += 2;

      tc++;

      if (g == NULL)
         return( -2 );
      }

   if ((DumpWnd = OpenWindowTags( NULL,

                         WA_Left,   DumpLeft,
                         WA_Top,    DumpTop,
                         WA_Width,  DumpWidth,
                         WA_Height, DumpHeight + offy,
                         WA_IDCMP,  STRINGIDCMP | BUTTONIDCMP 
                           | IDCMP_REFRESHWINDOW | IDCMP_VANILLAKEY,

                         WA_Flags,       WFLG_DRAGBAR | WFLG_DEPTHGADGET
                           | WFLG_SMART_REFRESH | WFLG_ACTIVATE
                           | WFLG_RMBTRAP,

                         WA_Gadgets,     DumpGList,
                         WA_Title,       DumpWdt,
                         TAG_DONE )
      ) == NULL)
      return( -4 );

   GT_RefreshWindow( DumpWnd, NULL );
   DumpRender();

   return( 0 );
}

PRIVATE int DumpVanillaKey( int whichkey )
{
   int rval = TRUE;
   
   switch (whichkey)
      {
      case 'o':
      case 'O':
         rval = OkayButtonClicked();
         break;

      case 'a':
      case 'A':
         rval = AbortButtonClicked();
         break;
      }
      
   return( rval );
}

PRIVATE int HandleDumpIDCMP( void )
{
   struct IntuiMessage *m;
   int                 (*func)();
   BOOL                running = TRUE;

   while (running == TRUE)
      {
      if ((m = GT_GetIMsg( DumpWnd->UserPort )) == NULL) 
         {
         (void) Wait( 1L << DumpWnd->UserPort->mp_SigBit );
         continue;
         }

      CopyMem( (char *) m, (char *) &DumpMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (DumpMsg.Class) 
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( DumpWnd );
            DumpRender();
            GT_EndRefresh( DumpWnd, TRUE );
            break;

         case IDCMP_VANILLAKEY:
            running = DumpVanillaKey( DumpMsg.Code );
            break;
            
         case IDCMP_GADGETUP:
            func = (void *)((struct Gadget *)DumpMsg.IAddress)->UserData;
            
            if (func != NULL)
               running = func();

            break;
         }
      }
   return( running );
}

PUBLIC int HandleDumpReq( void )
{
   if (OpenDumpWindow() < 0)
      {
      fprintf( stderr, "problem in Opening Dump Memory Requester!\n" );

      (void) Handle_Problem( "Couldn't open DumpMem Requester!", 
                             "Dump Memory Problem:", NULL );

      return( -1 );
      }

   if (HandleDumpIDCMP() == OPEN_DUMP_CONSOLE)
      {
      FromAddress = (unsigned short) StartAddr;
      ToAddress   = (unsigned short) EndAddr;

      return( OPEN_DUMP_CONSOLE );
      }
   else
      return( 0 );   /* User Aborted! */
}

/* ------------------ END of DumpMem.c file ----------------------- */
