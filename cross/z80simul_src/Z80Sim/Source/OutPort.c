/****h* Z80Simulator/OutPort.c [2.5] *******************************
*
* NAME
*    OutPort.c
*
* DESCRIPTION
*    Display the OUT() value of the Z80 Simulator.
*
* RETURNS
*    0 for success, -1 for failure.
*
* Functional Interface:
*
*   PUBLIC int HandleOutPort( int address, int value );
* 
*  GUI Designed by : Jim Steichen
********************************************************************
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

#define OkayBt         0
#define PortAddrStr    1
#define PortValueStr   2

#define OP_CNT         3

/* ----------------------------------- Located in Z80SimGTGUI.c file */
IMPORT struct TextAttr topaz8;
IMPORT struct Screen   *Scr;
IMPORT UBYTE           *PubScreenName;
IMPORT APTR            VisualInfo;
/* ----------------------------------- */

PRIVATE struct Window         *OPWnd    = NULL;
PRIVATE struct Gadget         *OPGList  = NULL;
PRIVATE struct IntuiMessage    OPMsg;
PRIVATE struct Gadget         *OPGadgets[3];

PRIVATE UWORD  OPLeft   = 310;
PRIVATE UWORD  OPTop    = 155;
PRIVATE UWORD  OPWidth  = 330;
PRIVATE UWORD  OPHeight = 80;
PRIVATE UBYTE *OPWdt    = "Z80 OUT() instruction:";

PRIVATE struct IntuiText OPIText[] = {

   2, 0, JAM1, 107, 6, &topaz8, (UBYTE *) "(Port Output)", NULL 
};

PRIVATE UWORD OPGTypes[] = {

   BUTTON_KIND,   TEXT_KIND,   TEXT_KIND
};


PRIVATE int OkayBtClicked( void );

PRIVATE struct NewGadget OPNGad[] = {

   131, 51, 59, 22, (UBYTE *) " _OKAY ", NULL, OkayBt, 
   PLACETEXT_IN, NULL, (APTR) OkayBtClicked,
   
    79, 22, 70, 14, (UBYTE *) "Address:", NULL, PortAddrStr, 
   PLACETEXT_LEFT, NULL, NULL,
   
   228, 22, 70, 14, (UBYTE *)   "Value:", NULL, PortValueStr, 
   PLACETEXT_LEFT, NULL, NULL
};

PRIVATE ULONG OPGTags[] = {

   (GT_Underscore), '_', (TAG_DONE),
   (GTTX_Border), TRUE, (TAG_DONE),
   (GTTX_Border), TRUE, (TAG_DONE)
};

/* ---------------------------------------------------------------- */

PRIVATE void CloseOPWindow( void )
{
   if (OPWnd != NULL) 
      {
      CloseWindow( OPWnd );
      OPWnd = NULL;
      }

   if (OPGList != NULL) 
      {
      FreeGadgets( OPGList );
      OPGList = NULL;
      }

   return;
}


PRIVATE int OkayBtClicked( void )
{
   CloseOPWindow();

   return( (int) FALSE );
}


PRIVATE void OPRender( void )
{
   UWORD offx, offy;

   offx = OPWnd->BorderLeft;
   offy = OPWnd->BorderTop;

   PrintIText( OPWnd->RPort, OPIText, offx, offy );

   return;
}

PRIVATE void SetTextStrings( int address, int value )
{
   IMPORT int stci_h( char *, int );

   UBYTE OPNIL1[6], *OPAddr  = &OPNIL1[0];
   UBYTE OPNIL2[4], *OPValue = &OPNIL2[0];

   *OPAddr  = '$';
   *OPValue = '$';

   (void) stci_h( &OPAddr[1],  (address & 0x0000FFFF) );
   (void) stci_h( &OPValue[1], (value   & 0x000000FF) );

   OPAddr[5]  = '\0';
   OPValue[3] = '\0';
   
   GT_SetGadgetAttrs( OPGadgets[ PortAddrStr ], OPWnd, NULL,
                      GTTX_Text, OPAddr,
                      TAG_END
                    );

   GT_SetGadgetAttrs( OPGadgets[ PortValueStr ], OPWnd, NULL,
                      GTTX_Text, OPValue,
                      TAG_END
                    );

   return; 
}

PRIVATE int OpenOPWindow( int address, int value )
{
   struct NewGadget ng;
   struct Gadget    *g;
   UWORD            lc, tc;
   UWORD            offx = Scr->WBorLeft, 
                    offy = Scr->WBorTop + Scr->RastPort.TxHeight + 1;

   if ((g = CreateContext( &OPGList )) == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < OP_CNT; lc++) 
      {
      CopyMem( (char *) &OPNGad[ lc ], (char *) &ng, 
               (long) sizeof( struct NewGadget )
             );

      ng.ng_VisualInfo = VisualInfo;
      ng.ng_TextAttr   = &topaz8;
      ng.ng_LeftEdge  += offx;
      ng.ng_TopEdge   += offy;

      OPGadgets[ lc ] = g = CreateGadgetA( (ULONG) OPGTypes[ lc ], 
                              g, 
                              &ng, 
                              (struct TagItem *) &OPGTags[ tc ] );

      while (OPGTags[ tc ] != TAG_DONE) 
         tc += 2;
      
      tc++;

      if (g == NULL)
         return( -2 );
      }

   if ((OPWnd = OpenWindowTags( NULL,

                   WA_Left,        OPLeft,
                   WA_Top,         OPTop,
                   WA_Width,       OPWidth,
                   WA_Height,      OPHeight + offy,

                   WA_IDCMP,       BUTTONIDCMP | TEXTIDCMP
                     | IDCMP_REFRESHWINDOW | IDCMP_VANILLAKEY,

                   WA_Flags,       WFLG_DRAGBAR | WFLG_DEPTHGADGET
                     | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,
                   WA_Gadgets,     OPGList,
                   WA_Title,       OPWdt,
                   TAG_DONE )
      ) == NULL)
      return( -4 );

   SetTextStrings( address, value );
   OPRender();

   return( 0 );
}

PRIVATE int OPVanillaKey( int whichkey )
{
   int rval = TRUE;
   
   switch (whichkey)
      {
      case 'o':
      case 'O':
         rval = OkayBtClicked();
         break;
      }
      
   return( rval );
}

PRIVATE int HandleOPIDCMP( void )
{
   struct IntuiMessage *m;
   int                 (*func)();
   BOOL                running = TRUE;

   while (running == TRUE)
      {
      if ((m = GT_GetIMsg( OPWnd->UserPort )) == NULL) 
         {
         (void) Wait( 1L << OPWnd->UserPort->mp_SigBit );
         continue;
         }

      CopyMem( (char *) m, (char *) &OPMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (OPMsg.Class) 
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( OPWnd );
            OPRender();
            GT_EndRefresh( OPWnd, TRUE );
            break;

         case IDCMP_VANILLAKEY:
            running = OPVanillaKey( OPMsg.Code );
            break;
            
         case IDCMP_GADGETUP:
            func = (void *)((struct Gadget *)OPMsg.IAddress)->UserData;
            
            if (func != NULL)
               running = func();
            
            break;
         }
      }

   return( running );
}


PUBLIC int HandleOutPort( int address, int value )
{
   if (OpenOPWindow( address, value ) < 0)
      {
      fprintf( stderr, "problem in Opening Out Port Requester!\n" );

      (void) Handle_Problem( "Couldn't open OUT() Port Requester!", 
                             "OUT() Requester Problem:", NULL 
                           );
      return( -1 );
      }

   (void) HandleOPIDCMP();

   return( 0 );
}

/* ---------------------- END of OutPort.c file ----------------------- */
