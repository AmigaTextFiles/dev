/****h* Z80Simulator/PrintListing.c [2.5] **************************
*
* NAME
*    PrintListing.c
*
* DESCRIPTION
*    Print the Z80 Source from 'From:' to 'To:'
*    to the file requested for the Z80Simulator.
*
* RETURNS
*    0 for success, -1 for failure.
*
* Functional Interface:
*
*   PUBLIC int HandlePrintListing( void );
*
* GUI Designed by : Jim Steichen
********************************************************************
*
*/

#include <stdio.h>
#include <string.h>

#include <exec/types.h>

#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/imageclass.h>
#include <intuition/gadgetclass.h>

#include <libraries/gadtools.h>
#include <libraries/asl.h>

#include <graphics/displayinfo.h>
#include <graphics/gfxbase.h>

#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/graphics_protos.h>
#include <clib/utility_protos.h>
#include <clib/asl_protos.h>

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "FileReqTags.h"

#define StrBfPtr( g ) (((struct StringInfo *)g->SpecialInfo)->Buffer)

#define OKAYBT       0
#define ABORTBT      1
#define FileNameStr  2
#define GetFileASL   3
#define FromAddrStr  4
#define ToAddrStr    5

#define PL_CNT       6


/* ----------------------------------- Located in Z80SimGTGUI.c file */
IMPORT struct TextAttr topaz8;
IMPORT struct Screen   *Scr;
IMPORT UBYTE           *PubScreenName;
IMPORT APTR            VisualInfo;
IMPORT unsigned short  FromAddress;
IMPORT unsigned short  ToAddress;
IMPORT char            OutFileName[];
/* ----------------------------------- */



PRIVATE struct Window         *PLWnd    = NULL;
PRIVATE struct Gadget         *PLGList  = NULL;
PRIVATE struct IntuiMessage    PLMsg;
PRIVATE struct Gadget         *PLGadgets[6];

PRIVATE UWORD  PLLeft   = 240;
PRIVATE UWORD  PLTop    = 155;
PRIVATE UWORD  PLWidth  = 400;
PRIVATE UWORD  PLHeight = 125;
PRIVATE UBYTE *PLWdt    = "Print to a File:";

PRIVATE struct IntuiText PLIText[] = {

   2, 0, JAM1, 116,  6, &topaz8, (UBYTE *) "(Print a Listing)", &PLIText[1],
   2, 0, JAM1, 129, 45, &topaz8, (UBYTE *) "(Use HexaDecimal)", NULL 
};

PRIVATE UWORD PLGTypes[] = {

   BUTTON_KIND,   BUTTON_KIND,
   STRING_KIND,   BUTTON_KIND,
   STRING_KIND,   STRING_KIND
};


PRIVATE int StrClicked( void );
PRIVATE int FromAddrClicked( void );
PRIVATE int ToAddrClicked( void );
PRIVATE int ASLClicked( void );
PRIVATE int OkayClicked( void );
PRIVATE int AbortClicked( void );

PRIVATE struct NewGadget PLNGad[] = {

     8, 89,  58, 22, (UBYTE *)    " _OKAY ", NULL, OKAYBT, 
   PLACETEXT_IN, NULL, (APTR) OkayClicked,
   
   288, 89,  68, 22, (UBYTE *)   " _ABORT ", NULL, ABORTBT, 
   PLACETEXT_IN, NULL, (APTR) AbortClicked,
   
    91, 23, 237, 15, (UBYTE *) "File Name:", NULL, FileNameStr, 
   PLACETEXT_LEFT, NULL, (APTR) StrClicked,

   330, 23,  50, 14, (UBYTE *)      " ASL ", NULL, GetFileASL, 
   PLACETEXT_IN, NULL, (APTR) ASLClicked,
   
    91, 59,  71, 15, (UBYTE *)      "From:", NULL, FromAddrStr, 
   PLACETEXT_LEFT, NULL, (APTR) FromAddrClicked,
   
   257, 59,  71, 15, (UBYTE *)        "To:", NULL, ToAddrStr, 
   PLACETEXT_LEFT, NULL, (APTR) ToAddrClicked
};

PRIVATE ULONG PLGTags[] = {

   (GT_Underscore), '_', (TAG_DONE),
   (GT_Underscore), '_', (TAG_DONE),

   (GA_TabCycle), FALSE, (GTST_MaxChars), 256, 
   (STRINGA_Justification), (GACT_STRINGCENTER), (TAG_DONE),
   
   (TAG_DONE),         /* The ASL button gadget. */
    
   (GTST_MaxChars), 7, 
   (STRINGA_Justification), (GACT_STRINGCENTER), (TAG_DONE),
   
   (GTST_MaxChars), 7, 
   (STRINGA_Justification), (GACT_STRINGCENTER), (TAG_DONE)
};

/* ------------------------------------------------------------------ */

PRIVATE char ListFileName[256];
PRIVATE int  StartAddr = 0;
PRIVATE int  EndAddr   = 0;

PRIVATE int StrClicked( void )
{
   (void) strcpy( &ListFileName[0], StrBfPtr( PLGadgets[2] ) );

   return( (int) TRUE );
}

PRIVATE int ASLClicked( void )
{
   char fname[256] = "";

   SetTagItem( DefaultTags, ASLFR_Window, (ULONG) PLWnd );

   SetTagItem( DefaultTags, ASLFR_TitleText,
                            (ULONG) "Print: Make a listing..." 
             );

   if (FileReq( fname, DefaultTags ) > 1)
      {
      (void) strcpy( &ListFileName[0], fname );

      GT_SetGadgetAttrs( PLGadgets[2], PLWnd, NULL,
                         GTST_String, (STRPTR) &ListFileName[0],
                         TAG_END
                       );
      }

   return( (int) TRUE );
}

PRIVATE int FromAddrClicked( void )
{ 
   (void) stch_i( (char *) StrBfPtr( PLGadgets[4] ), &StartAddr );

   if (StartAddr < 0 || StartAddr > 0xFFFE)
      return( (int) TRUE );

   FromAddress = StartAddr;

   return( (int) TRUE );
}

PRIVATE int ToAddrClicked( void )
{
   (void) stch_i( (char *) StrBfPtr( PLGadgets[5] ), &EndAddr );

   if (EndAddr < 1 || EndAddr > 0xFFFF)
      return( (int) TRUE );
      
   ToAddress = EndAddr;

   return( (int) TRUE );
}


PRIVATE void ClosePLWindow( void )
{
   if (PLWnd != NULL) 
      {
      CloseWindow( PLWnd );
      PLWnd = NULL;
      }

   if (PLGList != NULL) 
      {
      FreeGadgets( PLGList );
      PLGList = NULL;
      }

   return;
}


#define PRINT_LISTING 12

PRIVATE int OkayClicked( void )
{
   (void) stch_i( (char *) StrBfPtr( PLGadgets[4] ), &StartAddr );
   (void) stch_i( (char *) StrBfPtr( PLGadgets[5] ), &EndAddr );

   if (StartAddr < 0 || StartAddr > 0xFFFE)
      return( (int) TRUE );

   if (EndAddr < 1 || EndAddr > 0xFFFF)
      return( (int) TRUE );
      
   if (EndAddr <= StartAddr)
      return( (int) TRUE );

   if (strlen( &ListFileName[0] ) > 0)
      (void) strcpy( &OutFileName[0], &ListFileName[0] );

   FromAddress = (unsigned short) StartAddr;
   ToAddress   = (unsigned short) EndAddr;
 
   ClosePLWindow();
 
   return( PRINT_LISTING );
}


PRIVATE int AbortClicked( void )
{
   ListFileName[0] = '\0';
   FromAddress     = ToAddress = 0;

   ClosePLWindow();

   return( (int) FALSE );
}


PRIVATE void PLRender( void )
{
   UWORD offx, offy;

   offx = PLWnd->BorderLeft;
   offy = PLWnd->BorderTop;

   PrintIText( PLWnd->RPort, PLIText, offx, offy );

   return;
}

PRIVATE int OpenPLWindow( void )
{
   struct NewGadget ng;
   struct Gadget    *g;
   UWORD            lc, tc;
   UWORD            offx = Scr->WBorLeft, 
                    offy = Scr->WBorTop + Scr->RastPort.TxHeight + 1;

   if ((g = CreateContext( &PLGList )) == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < PL_CNT; lc++) 
      {
      CopyMem( (char *) &PLNGad[ lc ], (char *) &ng, 
               (long) sizeof( struct NewGadget )
             );

      ng.ng_VisualInfo = VisualInfo;
      ng.ng_TextAttr   = &topaz8;
      ng.ng_LeftEdge  += offx;
      ng.ng_TopEdge   += offy;

      PLGadgets[ lc ] = g = CreateGadgetA( (ULONG) PLGTypes[ lc ], 
                              g, 
                              &ng, 
                              (struct TagItem *) &PLGTags[ tc ] );

      while (PLGTags[ tc ] != TAG_DONE) 
         tc += 2;
      
      tc++;

      if (g == NULL)
         return( -2 );
      }

   if ((PLWnd = OpenWindowTags( NULL,

                    WA_Left,        PLLeft,
                    WA_Top,         PLTop,
                    WA_Width,       PLWidth,
                    WA_Height,      PLHeight + offy,
                    WA_IDCMP,       BUTTONIDCMP | STRINGIDCMP
                      | IDCMP_GADGETUP | IDCMP_REFRESHWINDOW
                      | IDCMP_VANILLAKEY,

                    WA_Flags,       WFLG_DRAGBAR | WFLG_DEPTHGADGET
                      | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,

                    WA_Gadgets,     PLGList,
                    WA_Title,       PLWdt,
                    TAG_DONE )
      ) == NULL)
      return( -4 );

   GT_RefreshWindow( PLWnd, NULL );
   PLRender();

   return( 0 );
}

PRIVATE int PLVanillaKey( int whichkey )
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

PRIVATE int HandlePLIDCMP( void )
{
   struct IntuiMessage *m;
   int                 (*func)();
   BOOL                running = TRUE;

   while (running == TRUE)
      {
      if ((m = GT_GetIMsg( PLWnd->UserPort )) == NULL) 
         {
         (void) Wait( 1L << PLWnd->UserPort->mp_SigBit );
         continue;
         }

      CopyMem( (char *) m, (char *) &PLMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (PLMsg.Class) 
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( PLWnd );
            PLRender();
            GT_EndRefresh( PLWnd, TRUE );
            break;

         case IDCMP_VANILLAKEY:
            running = PLVanillaKey( PLMsg.Code );
            break;
            
         case IDCMP_GADGETUP:
            func = (void *) ((struct Gadget *)PLMsg.IAddress)->UserData;
            
            if (func != NULL)
               running = func();
            
            break;
         }
      }

   return( running );
}


PUBLIC int HandlePrintListing( void )
{
   if (OpenPLWindow() < 0)
      {
      fprintf( stderr, "problem in Opening Print Listing Requester!\n" );

      (void) Handle_Problem( "Couldn't open Print Listing Requester!", 
                             "Print Listing Requester Problem:", NULL 
                           );
      return( -1 );
      }

   if (HandlePLIDCMP() == PRINT_LISTING)
      {
      (void) strcpy( &OutFileName[0], &ListFileName[0] );

      if (strlen( &OutFileName[0] ) == 0)
         return( -2 );

      if (EndAddr <= StartAddr)
         return( -3 );
      }

   return( 0 );
}

/* ------------------- END of PrintListing.c file --------------------- */
