/****h* Z80Simulator/AddressRange.c [2.5] ***************************
*
* NAME
*    AddressRange.c
*
* DESCRIPTION
*    Requester code for getting a starting & ending address from 
*    the user for the Z80 Simulator program.
*
* RETURNS
*    0 for success, -1 for failure.
*
* NOTES
*
*   Functional interface:
*      PUBLIC int HandleAddrRange( void );
*
*   GLOBALS USED:
* 
*   IMPORT struct TextAttr topaz8;
*   IMPORT struct Screen   *Scr;
*   IMPORT UBYTE           *PubScreenName;
*   IMPORT APTR            VisualInfo;
*   IMPORT unsigned short  FromAddress;
*   IMPORT unsigned short  ToAddress;
*
*   GUI Designed by : Jim Steichen
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

#define StrBfPtr( g ) (((struct StringInfo *)g->SpecialInfo)->Buffer)

#define STARTSTR   0
#define OKAYBT     1
#define ABORTBT    2
#define ENDSTR     3

#define AR_CNT     4

/* ------------------------------- Located in Z80SimGTGUI.c file: */
IMPORT struct TextAttr topaz8;
IMPORT struct Screen   *Scr;
IMPORT UBYTE           *PubScreenName;
IMPORT APTR            VisualInfo;
IMPORT unsigned short  FromAddress;
IMPORT unsigned short  ToAddress;
/* ----------------------------------- */

PRIVATE struct Window         *ARWnd    = NULL;
PRIVATE struct Gadget         *ARGList  = NULL;
PRIVATE struct IntuiMessage    ARMsg;
PRIVATE struct Gadget         *ARGadgets[4];

PRIVATE UWORD  ARLeft   = 320;
PRIVATE UWORD  ARTop    = 175;
PRIVATE UWORD  ARWidth  = 280;
PRIVATE UWORD  ARHeight = 88;
PRIVATE UBYTE *ARWdt    = "Enter an Address Range:";

PRIVATE struct IntuiText ARIText[] = {

   2, 0, JAM1, 57, 5, &topaz8, (UBYTE *) "(Use HexaDecimal!)", NULL 
};

PRIVATE UWORD ARGTypes[] = {

   STRING_KIND, BUTTON_KIND,
   BUTTON_KIND, STRING_KIND
};


PRIVATE int StartStrClicked( void );
PRIVATE int EndStrClicked( void );
PRIVATE int OkayBtClicked( void );
PRIVATE int AbortBtClicked( void );

PRIVATE struct NewGadget ARNGad[] = {

    59, 22, 61, 15, (UBYTE *) "From:",    NULL, STARTSTR, 
    PLACETEXT_LEFT, NULL, (APTR) StartStrClicked,
    
     7, 55, 58, 22, (UBYTE *) " _OKAY ",  NULL, OKAYBT, 
     PLACETEXT_IN, NULL, (APTR) OkayBtClicked,
   
   201, 55, 68, 22, (UBYTE *) " _ABORT ", NULL, ABORTBT, 
   PLACETEXT_IN, NULL, (APTR) AbortBtClicked,
   
   202, 22, 61, 15, (UBYTE *) "To:",      NULL, ENDSTR, 
   PLACETEXT_LEFT, NULL, (APTR) EndStrClicked

};

PRIVATE ULONG ARGTags[] = {

   (GA_TabCycle), FALSE, (GTST_MaxChars), 7, 
   (STRINGA_Justification), (GACT_STRINGCENTER), (TAG_DONE),
 
   (GT_Underscore), '_', (TAG_DONE),
   (GT_Underscore), '_', (TAG_DONE),
   
   (GA_TabCycle), FALSE, (GTST_MaxChars), 7, 
   (STRINGA_Justification), (GACT_STRINGCENTER), (TAG_DONE)
};


/* -------------------------------------------------------------------- */

PRIVATE int  StartAddr = 0;
PRIVATE int  EndAddr   = 0;

PRIVATE BOOL ValidStartAddress = FALSE;
PRIVATE BOOL ValidEndAddress   = FALSE;

PRIVATE int StartStrClicked( void )
{
   (void) stch_i( (char *) StrBfPtr( ARGadgets[0] ), &StartAddr );

   /* Verify correct address range was entered: */

   if (StartAddr >= 0 && StartAddr < 0xFFFF)
      {
      ValidStartAddress = TRUE;
      FromAddress       = StartAddr;
      }
   else
      {
      (void) Handle_Problem( "Starting address out of range!", 
                             "Address Range Requester Problem:", NULL 
                           );

      ValidStartAddress = FALSE;
      FromAddress       = 0;

      GT_SetGadgetAttrs( ARGadgets[ 0 ], ARWnd, NULL,
                         GTST_String, (STRPTR) "",
                         TAG_END
                       );
      }

   return( (int) TRUE );
}

PRIVATE int EndStrClicked( void )
{
   (void) stch_i( (char *) StrBfPtr( ARGadgets[3] ), &EndAddr );

   /* Verify correct address range was entered: */

   if (EndAddr > 0 && EndAddr <= 0xFFFF)
      {
      ValidEndAddress = TRUE;
      ToAddress       = EndAddr;
      }
   else
      {
      (void) Handle_Problem( "Ending address out of range!", 
                             "Address Range Requester Problem:", NULL 
                           );

      ValidEndAddress = FALSE;
      ToAddress       = 0;

      GT_SetGadgetAttrs( ARGadgets[ 3 ], ARWnd, NULL,
                         GTST_String, (STRPTR) "",
                         TAG_END
                       );
      }

   return( (int) TRUE );
}

PRIVATE void CloseARWindow( void )
{
   if (ARWnd) 
      {
      CloseWindow( ARWnd );
      ARWnd = NULL;
      }

   if (ARGList) 
      {
      FreeGadgets( ARGList );
      ARGList = NULL;
      }
   return;
}

#define NORMAL_EXIT 14

PRIVATE int OkayBtClicked( void )
{
   /* User has to press <RETURN> in both string gadgets for this
   ** test to pass:
   */
   if (ValidStartAddress == TRUE && ValidEndAddress == TRUE)
      goto SkipTesting;
      

   /* Check & make sure that the user entered sane values into the 
   ** start & end address string gadgets:
   */
   (void) stch_i( (char *) StrBfPtr( ARGadgets[0] ), &StartAddr );

   if (StartAddr >= 0 && StartAddr < 0xFFFF)
      {
      ValidStartAddress = TRUE;
      FromAddress       = StartAddr;
      }
   else
      {
      (void) Handle_Problem( "Starting Address out of range!", 
                             "Address Range Requester Problem:", NULL 
                           );

      ValidStartAddress = FALSE;
      FromAddress       = 0;
      
      GT_SetGadgetAttrs( ARGadgets[ 0 ], ARWnd, NULL,
                         GTST_String, (STRPTR) "",
                         TAG_END
                       );

      return( (int) TRUE );
      }

   (void) stch_i( (char *) StrBfPtr( ARGadgets[3] ), &EndAddr );

   if (EndAddr > 0 && EndAddr <= 0xFFFF)
      {
      ValidEndAddress = TRUE;
      ToAddress       = EndAddr;
      }
   else
      {
      (void) Handle_Problem( "Ending Address out of range!", 
                             "Address Range Requester Problem:", NULL 
                           );

      ValidEndAddress = FALSE;
      ToAddress       = 0;
      
      GT_SetGadgetAttrs( ARGadgets[ 3 ], ARWnd, NULL,
                         GTST_String, (STRPTR) "",
                         TAG_END
                       );
      
      return( (int) TRUE );
      }

SkipTesting:

   if (StartAddr > EndAddr)
      {
      (void) Handle_Problem( "End Address < Start Address!", 
                             "Address Range Problem:", NULL 
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
      CloseARWindow();
      return( NORMAL_EXIT );  /* the Only Good exit point. */
      }
}

PRIVATE int AbortBtClicked( void )
{
   FromAddress       = ToAddress       = 0;
   ValidStartAddress = ValidEndAddress = FALSE;
   CloseARWindow();
   return( (int) FALSE );
}


PRIVATE void ARRender( void )
{
   UWORD offx, offy;

   offx = ARWnd->BorderLeft;
   offy = ARWnd->BorderTop;

   PrintIText( ARWnd->RPort, ARIText, offx, offy );
   return;
}

PRIVATE int OpenARWindow( void )
{
   struct NewGadget ng;
   struct Gadget    *g;
   UWORD            lc, tc;
   UWORD            offx = Scr->WBorLeft, 
                    offy = Scr->WBorTop + Scr->RastPort.TxHeight + 1;

   if ((g = CreateContext( &ARGList )) == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < AR_CNT; lc++) 
      {
      CopyMem( (char *) &ARNGad[ lc ], (char *) &ng, 
               (long) sizeof( struct NewGadget )
             );

      ng.ng_VisualInfo = VisualInfo;
      ng.ng_TextAttr   = &topaz8;
      ng.ng_LeftEdge  += offx;
      ng.ng_TopEdge   += offy;

      ARGadgets[ lc ] = g = CreateGadgetA( (ULONG) ARGTypes[ lc ], 
                             g, 
                             &ng, 
                             (struct TagItem *) &ARGTags[ tc ] );

      while (ARGTags[ tc ] != TAG_DONE) 
         tc += 2;

      tc++;
      
      if (g == NULL)
         return( -2 );
      }

   if ((ARWnd = OpenWindowTags( NULL,

                   WA_Left,        ARLeft,
                   WA_Top,         ARTop,
                   WA_Width,       ARWidth,
                   WA_Height,      ARHeight + offy,
                   WA_IDCMP,       STRINGIDCMP | BUTTONIDCMP 
                     | IDCMP_REFRESHWINDOW | IDCMP_VANILLAKEY,

                   WA_Flags,       WFLG_DRAGBAR | WFLG_DEPTHGADGET
                     | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,

                   WA_Gadgets,     ARGList,
                   WA_Title,       ARWdt,
                   TAG_DONE )
      ) == NULL)
      return( -4 );

   GT_RefreshWindow( ARWnd, NULL );
   ARRender();
   return( 0 );
}

PRIVATE int ARVanillaKey( int whichkey )
{
   int rval = TRUE;
   
   switch (whichkey)
      {
      case 'o':
      case 'O':
         rval = OkayBtClicked();
         break;
   
      case 'a':
      case 'A':
         rval = AbortBtClicked();
         break;
      }
      
   return( rval );
}

PRIVATE int HandleARIDCMP( void )
{
   struct IntuiMessage *m;
   int                 (*func)();
   BOOL                running = TRUE;

   while (running == TRUE)
      {
      if ((m = GT_GetIMsg( ARWnd->UserPort )) == NULL) 
         {
         (void) Wait( 1L << ARWnd->UserPort->mp_SigBit );
         continue;
         }

      CopyMem( (char *) m, (char *) &ARMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (ARMsg.Class) 
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( ARWnd );
            ARRender();
            GT_EndRefresh( ARWnd, TRUE );
            break;

         case IDCMP_VANILLAKEY:
            running = ARVanillaKey( ARMsg.Code );
            break;
            
         case IDCMP_GADGETUP:
            func    = (void *) ((struct Gadget *)ARMsg.IAddress)->UserData;
            running = func();
            break;
         }
      }
   return( running );
}

PUBLIC int HandleAddrRange( void )
{
   if (OpenARWindow() < 0)
      {
      fprintf( stderr, "problem in Opening Address Range Requester!\n" );

      (void) Handle_Problem( "Couldn't open Address Range Requester!", 
                             "Address Range Requester Problem:", NULL 
                           );
      return( -1 );
      }

   if (HandleARIDCMP() == NORMAL_EXIT)
      {
      FromAddress = StartAddr;
      ToAddress   = EndAddr;
      }
   else
      {
      FromAddress = 0;
      ToAddress   = 0x1000;
      }
   return( 0 );
}

/* ----------------- END of AddressRange.c file ------------------- */
