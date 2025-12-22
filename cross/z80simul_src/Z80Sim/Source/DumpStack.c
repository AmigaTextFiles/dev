/********************************************************************
** DumpStack.c - Stack display requester code.
**
** Functional interface:
**   PUBLIC int HandleStackReq( void );
**
** RETURNS:  0 for success, -1 for failure.
**
**  GUI Designed by : Jim Steichen
*********************************************************************/

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

#define StrBfPtr(g) (((struct StringInfo *)g->SpecialInfo)->Buffer)

#define StartStr 0
#define Okay     1
#define Abort    2
#define EndStr   3

#define DS_CNT   4

/* ----------------------------------- Located in Z80SimGTGUI.c file */
IMPORT struct Screen   *Scr;
IMPORT struct TextAttr topaz8;
IMPORT UBYTE           *PubScreenName;
IMPORT APTR            VisualInfo;
IMPORT unsigned short  FromAddress;
IMPORT unsigned short  ToAddress;
/* ----------------------------------- */

PRIVATE struct Window         *DSWnd    = NULL;
PRIVATE struct Gadget         *DSGList  = NULL;
PRIVATE struct IntuiMessage    DSMsg;
PRIVATE struct Gadget         *DSGadgets[4];

PRIVATE UWORD  DSLeft   = 320;
PRIVATE UWORD  DSTop    = 155;
PRIVATE UWORD  DSWidth  = 280;
PRIVATE UWORD  DSHeight = 88;
PRIVATE UBYTE *DSWdt    = "Enter a Stack Range:";


PRIVATE struct IntuiText DSIText[] = {

   2, 0, JAM1, 57, 5, &topaz8, (UBYTE *) "(Use HexaDecimal!)", NULL 
};

PRIVATE UWORD DSGTypes[] = {

   STRING_KIND, BUTTON_KIND,
   BUTTON_KIND, STRING_KIND
};


PRIVATE int StartStrClicked( void );
PRIVATE int EndStrClicked( void );
PRIVATE int OkayClicked( void );
PRIVATE int AbortClicked( void );

PRIVATE struct NewGadget DSNGad[] = {

    59, 22, 61, 15, (UBYTE *) "From:",    NULL, StartStr, 
   PLACETEXT_LEFT, NULL, (APTR) StartStrClicked,
   
     7, 55, 58, 22, (UBYTE *) " _OKAY ",  NULL, Okay, 
   PLACETEXT_IN, NULL, (APTR) OkayClicked,
   
   202, 55, 68, 22, (UBYTE *) " _ABORT ", NULL, Abort, 
   PLACETEXT_IN, NULL, (APTR) AbortClicked,
   
   202, 22, 61, 15, (UBYTE *) "To:",      NULL, EndStr, 
   PLACETEXT_LEFT, NULL, (APTR) EndStrClicked
};

PRIVATE ULONG DSGTags[] = {
   
   (GA_TabCycle),   FALSE, (GTST_MaxChars), 7, 
   (STRINGA_Justification), (GACT_STRINGCENTER), (TAG_DONE),
   
   (GT_Underscore),   '_', (TAG_DONE),
   (GT_Underscore),   '_', (TAG_DONE),
   
   (GA_TabCycle),   FALSE, (GTST_MaxChars), 7,
   (STRINGA_Justification), (GACT_STRINGCENTER), (TAG_DONE)
};

/* -------------------------------------------------------------------- */

PRIVATE int ValidStartAddress = FALSE;
PRIVATE int ValidEndAddress   = FALSE;
PRIVATE int StartAddr         = 0;
PRIVATE int EndAddr           = 0;

/* routine when gadget "From:" is clicked. */

PRIVATE int StartStrClicked( void )
{
   (void) stch_i( (char *) StrBfPtr( DSGadgets[0] ), &StartAddr );

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

      GT_SetGadgetAttrs( DSGadgets[ 0 ], DSWnd, NULL,
                         GTST_String, (STRPTR) "",
                         TAG_END
                       );
      }

   return( (int) TRUE  );
}

/* routine when gadget "To:" is clicked. */

PRIVATE int EndStrClicked( void )
{
   (void) stch_i( (char *) StrBfPtr( DSGadgets[3] ), &EndAddr );

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

      GT_SetGadgetAttrs( DSGadgets[ 3 ], DSWnd, NULL,
                         GTST_String, (STRPTR) "",
                         TAG_END
                       );
      }

   return( (int) TRUE  );
}


PRIVATE void CloseDSWindow( void )
{
   if (DSWnd) 
      {
      CloseWindow( DSWnd );
      DSWnd = NULL;
      }

   if (DSGList) 
      {
      FreeGadgets( DSGList );
      DSGList = NULL;
      }
   return;
}

#define OPEN_STACK_CONSOLE  11

PRIVATE int OkayClicked( void )
{
   /* User has to press <RETURN> in both string gadgets for this
   ** test to pass:
   */
   if (ValidStartAddress == TRUE && ValidEndAddress == TRUE)
      goto SkipTesting;
      

   /* Check & make sure that the user entered sane values into the 
   ** start & end address string gadgets:
   */
   (void) stch_i( (char *) StrBfPtr( DSGadgets[0] ), &StartAddr );

   if (StartAddr >= 0 && StartAddr < 0xFFFF)
      {
      ValidStartAddress = TRUE;
      FromAddress       = StartAddr;
      }
   else
      {
      (void) Handle_Problem( "Starting Address out of range!", 
                             "DumpStack Problem:", NULL 
                           );

      ValidStartAddress = FALSE;
      FromAddress       = 0;

      GT_SetGadgetAttrs( DSGadgets[ 0 ], DSWnd, NULL,
                         GTST_String, (STRPTR) "",
                         TAG_END
                       );
      
      return( (int) TRUE );
      }

   (void) stch_i( (char *) StrBfPtr( DSGadgets[3] ), &EndAddr   );

   if (EndAddr > 0 && EndAddr <= 0xFFFF)
      {
      ValidEndAddress = TRUE;
      ToAddress       = EndAddr;
      }
   else
      {
      (void) Handle_Problem( "Ending Address out of range!", 
                             "DumpStack Problem:", NULL 
                           );
      
      ValidEndAddress = FALSE;
      ToAddress       = 0;
      
      GT_SetGadgetAttrs( DSGadgets[ 3 ], DSWnd, NULL,
                         GTST_String, (STRPTR) "",
                         TAG_END
                       );

      return( (int) TRUE );
      }

SkipTesting:

   if (StartAddr > EndAddr)
      {
      (void) Handle_Problem( "End Address LESS THAN Start Address!", 
                             "DumpStack Problem:", NULL 
                           );

      ValidStartAddress = ValidEndAddress = FALSE;
      FromAddress       = ToAddress       = 0;
      return( (int) TRUE );
      }
   else
      {
      FromAddress       = StartAddr;
      ToAddress         = EndAddr;
      ValidStartAddress = ValidEndAddress = TRUE;
      CloseDSWindow();
      return( OPEN_STACK_CONSOLE );  /* the Only Good exit point. */
      }
}

PRIVATE int AbortClicked( void )
{
   FromAddress       = ToAddress       = 0;
   ValidStartAddress = ValidEndAddress = FALSE;

   CloseDSWindow();

   return( FALSE );
}


PRIVATE void DSRender( void )
{
   UWORD offx, offy;

   offx = DSWnd->BorderLeft;
   offy = DSWnd->BorderTop;

   PrintIText( DSWnd->RPort, DSIText, offx, offy );

   return;
}

PRIVATE int OpenDSWindow( void )
{
   struct NewGadget ng;
   struct Gadget    *g;
   UWORD            lc, tc;
   UWORD            offx = Scr->WBorLeft, 
                    offy = Scr->WBorTop + Scr->RastPort.TxHeight + 1;

   if ((g = CreateContext( &DSGList )) == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < DS_CNT; lc++) 
      {
      CopyMem( (char *) &DSNGad[ lc ], (char *) &ng, 
               (long) sizeof( struct NewGadget )
             );

      ng.ng_VisualInfo = VisualInfo;
      ng.ng_TextAttr   = &topaz8;
      ng.ng_LeftEdge  += offx;
      ng.ng_TopEdge   += offy;

      DSGadgets[ lc ] = g = CreateGadgetA( (ULONG) DSGTypes[ lc ], g, 
                              &ng, 
                              (struct TagItem *) &DSGTags[ tc ] );

      while (DSGTags[ tc ] != TAG_DONE) 
         tc += 2;

      tc++;

      if (g == NULL)
         return( -2 );
      }

   if ((DSWnd = OpenWindowTags( NULL,

                         WA_Left,   DSLeft,
                         WA_Top,    DSTop,
                         WA_Width,  DSWidth,
                         WA_Height, DSHeight + offy,
                         WA_IDCMP,  STRINGIDCMP | BUTTONIDCMP 
                           | IDCMP_REFRESHWINDOW | IDCMP_VANILLAKEY,

                         WA_Flags,  WFLG_DRAGBAR | WFLG_DEPTHGADGET
                           | WFLG_SMART_REFRESH | WFLG_ACTIVATE
                           | WFLG_RMBTRAP,

                         WA_Gadgets,     DSGList,
                         WA_Title,       DSWdt,
                         TAG_DONE )
      ) == NULL)
      return( -4 );

   GT_RefreshWindow( DSWnd, NULL );
   DSRender();

   return( 0 );
}

PRIVATE int DSVanillaKey( int whichkey )
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

PRIVATE int HandleDSIDCMP( void )
{
   struct IntuiMessage *m;
   int                 (*func)();
   BOOL                running = TRUE;

   while (running == TRUE)
      {
      if ((m = GT_GetIMsg( DSWnd->UserPort )) == NULL) 
         {
         (void) Wait( 1L << DSWnd->UserPort->mp_SigBit );
         continue;
         }

      CopyMem( (char *) m, (char *) &DSMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (DSMsg.Class) 
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( DSWnd );
            DSRender();
            GT_EndRefresh( DSWnd, TRUE );
            break;

         case IDCMP_VANILLAKEY:
            running = DSVanillaKey( DSMsg.Code );
            break;
            
         case IDCMP_GADGETUP:
            func = (void *) ((struct Gadget *)DSMsg.IAddress)->UserData;
            
            if (func != NULL)
               running = func();
            
            break;
         }
      }
   return( running );
}


PUBLIC int HandleStackReq( void )
{
   if (OpenDSWindow() < 0)
      {
      fprintf( stderr, "problem in Opening Stack Dump Requester!\n" );

      (void) Handle_Problem( "Couldn't open StackDump Requester!", 
                             "StackDump Problem:", NULL 
                           );
      return( -1 );
      }

   if (HandleDSIDCMP() == OPEN_STACK_CONSOLE)
      return( OPEN_STACK_CONSOLE );
   else
      {
      FromAddress = 0xFFFF - 0x0100; /* Default values. */
      ToAddress   = 0xFFFF;
      }

   return( 0 ); /* User pressed ABORT! */
}

/* --------------- END of DumpStack.c file ------------------ */
