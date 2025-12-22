/****h* Z80Simulator/IM2Req.c [2.5] *****************************
*
* NAME
*    IM2Req.c
*
* DESCRIPTION
*    Mode 2 Interrupt Requester for the Z80 Simulator.
*
* Functional interface:
*
*    PUBLIC int HandleIM2Req( void );
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

#include "Z80Sim.h" /* for the '#define I' value only! */

#define StrBfPtr( g ) (((struct StringInfo *)g->SpecialInfo)->Buffer)

#define IVecStr  0
#define OKAYBT   1
#define HALTBT   2
#define IRegTxt  3

#define IM2_CNT  4

/* ----------------------------------- Located in Z80SimGTGUI.c file */
IMPORT struct TextAttr topaz8;
IMPORT struct Screen   *Scr;
IMPORT UBYTE           *PubScreenName;
IMPORT APTR            VisualInfo;
IMPORT unsigned short  FromAddress;
IMPORT unsigned short  ToAddress;
/* ----------------------------------- */

IMPORT UBYTE           reg[];


PRIVATE struct Window       *IM2Wnd    = NULL;
PRIVATE struct Gadget       *IM2GList  = NULL;
PRIVATE struct IntuiMessage  IM2Msg;
PRIVATE struct Gadget       *IM2Gadgets[4];

PRIVATE UWORD  IM2Left   = 360;
PRIVATE UWORD  IM2Top    = 155;
PRIVATE UWORD  IM2Width  = 280;
PRIVATE UWORD  IM2Height = 88;
PRIVATE UBYTE *IM2Wdt    = "Enter a MODE 2 Address:";


PRIVATE struct IntuiText IM2IText[] = {

   2, 0, JAM1,86, 6, &topaz8, (UBYTE *) "(Use HexaDecimal!)", NULL 
};

PRIVATE UWORD IM2GTypes[] = {

   STRING_KIND, BUTTON_KIND,
   BUTTON_KIND, TEXT_KIND
};


PRIVATE int IVecStrClicked( void );
PRIVATE int OkayBtClicked( void );
PRIVATE int HaltBtClicked( void );

PRIVATE struct NewGadget IM2NGad[] = {

   140, 26, 60, 15, (UBYTE *) "IVec",    NULL, IVecStr, 
   PLACETEXT_RIGHT, NULL, (APTR) IVecStrClicked,
   
     7, 55, 58, 22, (UBYTE *) " _OKAY ", NULL, OKAYBT, 
   PLACETEXT_IN, NULL, (APTR) OkayBtClicked,
   
   201, 55, 68, 22, (UBYTE *) " _HALT ", NULL, HALTBT, 
   PLACETEXT_IN, NULL, (APTR) HaltBtClicked,
   
    51, 26, 60, 15, (UBYTE *) "IReg:",   NULL, IRegTxt, 
   PLACETEXT_LEFT, NULL, NULL
};

PRIVATE ULONG IM2GTags[] = {

   (GA_TabCycle), FALSE, (GTST_String), (ULONG) "0", 
   (GTST_MaxChars), 3, 
   (STRINGA_Justification), (GACT_STRINGCENTER), (TAG_DONE),
   
   (GT_Underscore), '_', (TAG_DONE),
   (GT_Underscore), '_', (TAG_DONE),
   
   (GTTX_Border), TRUE, (TAG_DONE)
};

/* ------------------------------------------------------------------ */

PRIVATE char Mode2Vector[10] = "";
PRIVATE int  ValidIVector    = FALSE;
PRIVATE int  IVector         = 0;

PRIVATE int IVecStrClicked( void )
{
   (void) strncpy( &Mode2Vector[0], StrBfPtr( IM2Gadgets[IVecStr] ), 9 );
   (void) stch_i( &Mode2Vector[0], &IVector );

   /* Verify correct range was entered: */

   if (IVector >= 0 && IVector <= 0xFF)
      {
      ValidIVector = TRUE;
      }
   else
      {
      (void) Handle_Problem( "Invalid Interrupt Vector value!", 
                             "IM2 Requester Problem:", NULL 
                           );

      GT_SetGadgetAttrs( IM2Gadgets[ IVecStr ], IM2Wnd, NULL,
                         GTST_String, (STRPTR) "",
                         TAG_END
                       );
      ValidIVector = FALSE;
      IVector      = 0;
      }

   return( (int) TRUE );
}


PRIVATE void CloseIM2Window( void )
{
   if (IM2Wnd != NULL) 
      {
      CloseWindow( IM2Wnd );
      IM2Wnd = NULL;
      }

   if (IM2GList != NULL) 
      {
      FreeGadgets( IM2GList );
      IM2GList = NULL;
      }

   return;
}


PRIVATE int OkayBtClicked( void )
{
   if (ValidIVector != TRUE)
      {
      (void) strncpy( &Mode2Vector[0], 
                      StrBfPtr( IM2Gadgets[IVecStr] ), 9 
                    );
      (void) stch_i( &Mode2Vector[0], &IVector );

      /* Verify correct range was entered: */

      if (IVector >= 0 && IVector <= 0xFF)
         {
         ValidIVector = TRUE;
         }
      else
         {
         (void) Handle_Problem( "Invalid Interrupt Vector value!", 
                                "IM2 Requester Problem:", NULL 
                              );

         GT_SetGadgetAttrs( IM2Gadgets[ IVecStr ], IM2Wnd, NULL,
                            GTST_String, (STRPTR) "",
                            TAG_END
                          );
         ValidIVector = FALSE;
         IVector      = 0;
         return( (int) TRUE );
         }
      }

   CloseIM2Window();

   return( (int) FALSE );
}

#define HALT_ME  10

PRIVATE int HaltBtClicked( void )
{
   Mode2Vector[0] = '\0';
   ValidIVector   = FALSE;
   IVector        = -1;

   CloseIM2Window();

   return( HALT_ME );
}


PRIVATE void IM2Render( void )
{
   UWORD offx, offy;

   offx = IM2Wnd->BorderLeft;
   offy = IM2Wnd->BorderTop;

   PrintIText( IM2Wnd->RPort, IM2IText, offx, offy );

   return;
}

PRIVATE int OpenIM2Window( int IRegister )
{
   struct NewGadget ng;
   struct Gadget    *g;
   UWORD            lc, tc;
   UWORD            offx = Scr->WBorLeft, 
                    offy = Scr->WBorTop + Scr->RastPort.TxHeight + 1;
   char             OI2NIL[4], *IRegStr = &OI2NIL[0];

   if ((g = CreateContext( &IM2GList )) == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < IM2_CNT; lc++) 
      {
      CopyMem( (char *) &IM2NGad[ lc ], (char *) &ng, 
               (long) sizeof( struct NewGadget )
             );

      ng.ng_VisualInfo = VisualInfo;
      ng.ng_TextAttr   = &topaz8;
      ng.ng_LeftEdge  += offx;
      ng.ng_TopEdge   += offy;

      IM2Gadgets[ lc ] = g = CreateGadgetA( (ULONG) IM2GTypes[ lc ], 
                               g, 
                               &ng, 
                               (struct TagItem *) &IM2GTags[ tc ] );

      while (IM2GTags[ tc ] != TAG_DONE) 
         tc += 2;

      tc++;

      if (g == NULL)
         return( -2 );
      }

   if ((IM2Wnd = OpenWindowTags( NULL,
                 
                    WA_Left,        IM2Left,
                    WA_Top,         IM2Top,
                    WA_Width,       IM2Width,
                    WA_Height,      IM2Height + offy,
                    WA_IDCMP,       STRINGIDCMP | BUTTONIDCMP | TEXTIDCMP
                      | IDCMP_REFRESHWINDOW | IDCMP_VANILLAKEY,
                    
                    WA_Flags,       WFLG_DRAGBAR | WFLG_DEPTHGADGET
                      | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,

                    WA_Gadgets,     IM2GList,
                    WA_Title,       IM2Wdt,
                    TAG_DONE )
      ) == NULL)
      return( -4 );

   GT_RefreshWindow( IM2Wnd, NULL );

   (void) stci_h( IRegStr, IRegister );

   GT_SetGadgetAttrs( IM2Gadgets[ IRegTxt ], IM2Wnd, NULL,
                      GTTX_Text, (STRPTR) IRegStr,
                      TAG_END
                    );
   IM2Render();

   return( 0 );
}

PRIVATE int IM2VanillaKey( int whichkey )
{
   int rval = TRUE;
   
   switch (whichkey)
      {
      case 'o':
      case 'O':
         rval = OkayBtClicked();
         break;

      case 'h':
      case 'H':
         rval = HaltBtClicked();
         break;
      }
      
   return( rval );
}

PRIVATE int HandleIM2IDCMP( void )
{
   struct IntuiMessage *m;
   int                 (*func)();
   BOOL                running = TRUE;

   while (running == TRUE)
      {
      if ((m = GT_GetIMsg( IM2Wnd->UserPort )) == NULL) 
         {
         (void) Wait( 1L << IM2Wnd->UserPort->mp_SigBit );
         continue;
         }

      CopyMem( (char *) m, (char *) &IM2Msg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );
      switch (IM2Msg.Class) 
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( IM2Wnd );
            IM2Render();
            GT_EndRefresh( IM2Wnd, TRUE );
            break;

         case IDCMP_VANILLAKEY:
            running = IM2VanillaKey( IM2Msg.Code );
            break;
            
         case IDCMP_GADGETUP:
            func = (void *) ((struct Gadget *)IM2Msg.IAddress)->UserData;
            
            if (func != NULL)
               running = func();
            
            break;
         }
      }

   return( running );
}

PUBLIC int HandleIM2Req( int IRegister )
{
   int response = FALSE;

   if (OpenIM2Window( IRegister ) < 0)
      {
      fprintf( stderr, "problem in Mode 2 Interrupt Requester!\n" );

      (void) Handle_Problem( "Couldn't open IM2 Requester!", 
                             "IM2 Requester Problem:", NULL 
                           );
      return( -1 );
      }

   response = HandleIM2IDCMP();

   if (response == FALSE)
      {
      return( IVector );
      }
   else if (response == HALT_ME) /* User Pressed the HALT gadget! */
      return( -2 );
}

/* ------------------------ END of IM2Req.c file -------------------- */
