/****h* Z80Simulator/FillMem.c [2.5] ******************************
*
* NAME
*    FillMem.c
*
* DESCRIPTION
*    Fill Memory requester for the Z80 Simulator program.
*
* Functional interface:
*    PUBLIC int HandleFillMemReq( void );
*
* RETURNS
*    0 for success, -1 for failure.
*
*  GUI Designed by : Jim Steichen
*******************************************************************
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

#define StartStr   0
#define OkayBt     1
#define AbortBt    2
#define EndStr     3
#define PattStr    4

#define FM_CNT     5

/* ----------------------------------- Located in Z80SimGTGUI.c file */
IMPORT struct TextAttr topaz8;
IMPORT struct Screen   *Scr;
IMPORT UBYTE           *PubScreenName;
IMPORT APTR            VisualInfo;

IMPORT unsigned short  FromAddress;
IMPORT unsigned short  ToAddress;

IMPORT char            *PatternStr;
IMPORT unsigned long   PatternValue;
/* ----------------------------------- */

PRIVATE struct Window       *FMWnd    = NULL;
PRIVATE struct Gadget       *FMGList  = NULL;
PRIVATE struct IntuiMessage  FMMsg;
PRIVATE struct Gadget       *FMGadgets[5];

PRIVATE UWORD  FMLeft   = 320;
PRIVATE UWORD  FMTop    = 155;
PRIVATE UWORD  FMWidth  = 282;
PRIVATE UWORD  FMHeight = 110;
PRIVATE UBYTE *FMWdt    = "Enter Fill Range & Pattern:";

PRIVATE struct IntuiText FMIText[] = {

   2, 0, JAM1,57, 5, &topaz8, (UBYTE *) "(Use HexaDecimal!)", NULL 
};

UWORD FMGTypes[] = {

   STRING_KIND, BUTTON_KIND,
   BUTTON_KIND, STRING_KIND,
   STRING_KIND
};

PRIVATE int FromClicked( void );
PRIVATE int ToClicked( void );
PRIVATE int PatternClicked( void );
PRIVATE int OkayClicked( void );
PRIVATE int AbortClicked( void );

PRIVATE struct NewGadget FMNGad[] = {

    55, 50, 61,  15, (UBYTE *) "From:",    NULL, StartStr, 
   PLACETEXT_LEFT, NULL, (APTR) FromClicked,
   
     7, 76, 58,  22, (UBYTE *) " _OKAY ",  NULL, OkayBt, 
   PLACETEXT_IN, NULL, (APTR) OkayClicked,
   
   200, 76, 68,  22, (UBYTE *) " _ABORT ", NULL, AbortBt, 
   PLACETEXT_IN, NULL, (APTR) AbortClicked,

   205, 50, 61,  15, (UBYTE *) "To:",      NULL, EndStr, 
   PLACETEXT_LEFT, NULL, (APTR) ToClicked,
   
    91, 23, 151, 15, (UBYTE *) "Pattern:", NULL, PattStr, 
   PLACETEXT_LEFT, NULL, (APTR) PatternClicked
};

PRIVATE ULONG FMGTags[] = {

   (GTST_MaxChars),   7, (STRINGA_Justification), 
   (GACT_STRINGCENTER), (TAG_DONE),
   
   (GT_Underscore), '_', (TAG_DONE),
   (GT_Underscore), '_', (TAG_DONE),
   
   (GTST_MaxChars),   7, (STRINGA_Justification), 
   (GACT_STRINGCENTER), (TAG_DONE),
   
   (GTST_MaxChars), 256, (STRINGA_Justification), 
   (GACT_STRINGCENTER), (TAG_DONE)
};

PRIVATE int ValidStartAddress = FALSE;
PRIVATE int ValidEndAddress   = FALSE;
PRIVATE int ValidPattern      = FALSE;

PRIVATE int StartAddr = 0;
PRIVATE int EndAddr   = 0;


PRIVATE int FromClicked( void )
{
   (void) stch_i( (char *) StrBfPtr( FMGadgets[0] ), &StartAddr );

   /* Verify correct address range was entered: */

   if (StartAddr >= 0 && StartAddr < 0xFFFF)
      {
      ValidStartAddress = TRUE;
      }
   else
      {
      GT_SetGadgetAttrs( FMGadgets[ 0 ], FMWnd, NULL,
                         GTST_String, (STRPTR) "",
                         TAG_END
                       );
      ValidStartAddress = FALSE;
      }

   FromAddress = StartAddr;

   return( (int) TRUE  );
}

PRIVATE int ToClicked( void )
{
   (void) stch_i( (char *) StrBfPtr( FMGadgets[3] ), &EndAddr );

   /* Verify correct address range was entered: */

   if (EndAddr > 0 && EndAddr <= 0xFFFF)
      {
      ValidEndAddress = TRUE;
      }
   else
      {
      GT_SetGadgetAttrs( FMGadgets[ 3 ], FMWnd, NULL,
                         GTST_String, (STRPTR) "",
                         TAG_END
                       );
      ValidEndAddress = FALSE;
      }

   ToAddress = EndAddr;

   return( (int) TRUE  );
}

PRIVATE int PatternClicked( void )
{
   if ((strlen( StrBfPtr( FMGadgets[4] )) % 2) != 0)
      {
      /* Pattern string is an ODD length: */
      (void) Handle_Problem( "Pattern is an ODD length!", 
                             "FillMem Problem:", NULL 
                           );

      /* This might NOT be desirable: */ 
      GT_SetGadgetAttrs( FMGadgets[ 4 ], FMWnd, NULL,
                         GTST_String, (STRPTR) "",
                         TAG_END
                       );

      ValidPattern = FALSE;
      return( (int) TRUE );      
      }
   else
      {
      (void) strcpy( PatternStr, (char *) StrBfPtr( FMGadgets[4] ) );

      ValidPattern = TRUE;
      return( (int) TRUE );
      }
}


PRIVATE void CloseFMWindow( void )
{
   if (FMWnd != NULL) 
      {
      CloseWindow( FMWnd );
      FMWnd = NULL;
      }

   if (FMGList != NULL) 
      {
      FreeGadgets( FMGList );
      FMGList = NULL;
      }

   return;
}

#define DO_FILL_MEM 17

PRIVATE int OkayClicked( void )
{
   int PatLen;

   /* Check the to, from & pattern strings for sanity, then do the
   ** memory fill: 
   */

   if (ValidStartAddress == TRUE && ValidEndAddress == TRUE 
                                 && ValidPattern == TRUE)
      {
      goto SkipTesting;
      }

   (void) stch_i( (char *) StrBfPtr( FMGadgets[0] ), &StartAddr );

   if (StartAddr >= 0 && StartAddr < 0xFFFF)
      {
      ValidStartAddress = TRUE;
      }
   else
      {
      (void) Handle_Problem( "Invalid Starting Address!", 
                             "FillMem Problem:", NULL 
                           );

      GT_SetGadgetAttrs( FMGadgets[ 0 ], FMWnd, NULL,
                         GTST_String, (STRPTR) "",
                         TAG_END
                       );
      ValidStartAddress = FALSE;
      return( (int) TRUE );
      }

   FromAddress = StartAddr;

   (void) stch_i( (char *) StrBfPtr( FMGadgets[3] ), &EndAddr );

   if (EndAddr > 0 && EndAddr <= 0xFFFF)
      {
      ValidEndAddress = TRUE;
      }
   else
      {
      (void) Handle_Problem( "Invalid Ending Address!", 
                             "FillMem Problem:", NULL 
                           );

      GT_SetGadgetAttrs( FMGadgets[ 3 ], FMWnd, NULL,
                         GTST_String, (STRPTR) "",
                         TAG_END
                       );
      ValidEndAddress = FALSE;
      return( (int) TRUE );
      }

   ToAddress = EndAddr;

   if ((strlen( StrBfPtr( FMGadgets[4] )) % 2) != 0)
      {
      /* Pattern string is an ODD length: */
      (void) Handle_Problem( "Pattern is an ODD length!", 
                             "FillMem Problem:", NULL 
                           );

      ValidPattern = FALSE;
      return( (int) TRUE );      
      }
   else
      {
      (void) strcpy( PatternStr, (char *) StrBfPtr( FMGadgets[4] ) );
      ValidPattern = TRUE;
      }

SkipTesting:

   PatLen = strlen( PatternStr );
      
   if (StartAddr >= EndAddr)
      {
      (void) Handle_Problem( "Start Address GREATER THAN End Address!", 
                             "FillMem Problem:", NULL 
                           );
      return( (int) TRUE );
      }

   if (((EndAddr - StartAddr) % PatLen) != 0)
      {
      if (Handle_Problem( "Pattern doesn't fit properly, Continue?", 
                          "FillMem Problem:", NULL 
                        ) < 0)
         return( (int) TRUE );
      }

   CloseFMWindow();
   return( (int) DO_FILL_MEM );
}


PRIVATE int AbortClicked( void )
{
   PatternStr[0] = '\0';
   FromAddress   = ToAddress = 0;

   CloseFMWindow();

   return( FALSE );
}


PRIVATE void FMRender( void )
{
   UWORD offx, offy;

   offx = FMWnd->BorderLeft;
   offy = FMWnd->BorderTop;

   PrintIText( FMWnd->RPort, FMIText, offx, offy );
   
   return;
}

PRIVATE int OpenFMWindow( void )
{
   struct NewGadget ng;
   struct Gadget    *g;
   UWORD            lc, tc;
   UWORD            offx = Scr->WBorLeft, 
                    offy = Scr->WBorTop + Scr->RastPort.TxHeight + 1;

   if ((g = CreateContext( &FMGList )) == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < FM_CNT; lc++) 
      {
      CopyMem( (char *) &FMNGad[ lc ], (char *) &ng, 
               (long) sizeof( struct NewGadget )
             );

      ng.ng_VisualInfo = VisualInfo;
      ng.ng_TextAttr   = &topaz8;
      ng.ng_LeftEdge  += offx;
      ng.ng_TopEdge   += offy;

      FMGadgets[ lc ] = g = CreateGadgetA( (ULONG) FMGTypes[ lc ], g, 
                               &ng, 
                               (struct TagItem *) &FMGTags[ tc ] );

      while (FMGTags[ tc ] != TAG_DONE) 
         tc += 2;

      tc++;

      if (g == NULL)
         return( -2 );
      }

   if ((FMWnd = OpenWindowTags( NULL,

                   WA_Left,        FMLeft,
                   WA_Top,         FMTop,
                   WA_Width,       FMWidth,
                   WA_Height,      FMHeight + offy,
                   WA_IDCMP,       STRINGIDCMP | BUTTONIDCMP 
                     | IDCMP_REFRESHWINDOW | IDCMP_VANILLAKEY,
 
                   WA_Flags,       WFLG_DRAGBAR | WFLG_DEPTHGADGET
                     | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,
 
                   WA_Gadgets,     FMGList,
                   WA_Title,       FMWdt,
                   TAG_DONE )
      ) == NULL)
      return( -4 );

   GT_RefreshWindow( FMWnd, NULL );
   FMRender();

   return( 0 );
}

PRIVATE int FMVanillaKey( int whichkey )
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

PRIVATE int HandleFMIDCMP( void )
{
   struct IntuiMessage *m;
   int                 (*func)();
   BOOL                running = TRUE;

   while (running == TRUE)
      {
      if ((m = GT_GetIMsg( FMWnd->UserPort )) == NULL) 
         {
         (void) Wait( 1L << FMWnd->UserPort->mp_SigBit );
         continue;
         }

      CopyMem( (char *) m, (char *) &FMMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );
      switch (FMMsg.Class) 
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( FMWnd );
            FMRender();
            GT_EndRefresh( FMWnd, TRUE );
            break;

         case IDCMP_VANILLAKEY:
            running = FMVanillaKey( FMMsg.Code );
            break;
            
         case IDCMP_GADGETUP:
            func = (void *) ((struct Gadget *)FMMsg.IAddress )->UserData;
            
            if (func != NULL)
               running = func();
            
            break;
         }
      }
   return( running );
}

PUBLIC int HandleFillMemReq( void )
{
   if (OpenFMWindow() < 0)
      {
      fprintf( stderr, "problem in Opening Fill Memory Requester!\n" );

      (void) Handle_Problem( "Couldn't open Fill Memory Requester!", 
                             "Fill Memory Requester Problem:", NULL 
                           );
      return( -1 );
      }

   if (HandleFMIDCMP() == DO_FILL_MEM)
      return( DO_FILL_MEM );
   else
      return( 0 ); /* User pressed ABORT! */
}

/* ------------------ END of FillMem.c file ---------------------- */
