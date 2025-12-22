/****h* Z80Simulator/InPort.c [2.5] *****************************
*
* NAME
*    InPort.c
*
* DESCRIPTION
*    The Requester for handling IN() port instructions
*    for the Z80Simulator program.
*
* RETURNS
*    0->255 for success, -1 for failure, 257 for no
*    port value supplied.
*
* Functional Interface:
*  
*   PUBLIC int HandleInPort( void );
*
*  GUI Designed by : Jim Steichen
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

#define OkayBt     0
#define INPORTSTR  1
#define AbortBt    2

#define InPort_CNT 3

/* ----------------------------------- Located in Z80SimGTGUI.c file */
IMPORT struct TextAttr topaz8;
IMPORT struct Screen   *Scr;
IMPORT UBYTE           *PubScreenName;
IMPORT APTR            VisualInfo;
/* ----------------------------------- */

PRIVATE struct Window       *InPortWnd    = NULL;
PRIVATE struct Gadget       *InPortGList  = NULL;
PRIVATE struct IntuiMessage  InPortMsg;
PRIVATE struct Gadget       *InPortGadgets[3];

PRIVATE UWORD  InPortLeft   = 300;
PRIVATE UWORD  InPortTop    = 155;
PRIVATE UWORD  InPortWidth  = 340;
PRIVATE UWORD  InPortHeight = 100;
PRIVATE UBYTE *InPortWdt    = "Z80 IN() instruction:";


PRIVATE struct IntuiText InPortIText[] = {

   2, 0, JAM1,  67, 11, &topaz8, (UBYTE *) "(Enter a Port Input value)", 
   &InPortIText[1],
   
   2, 0, JAM1, 120, 30, &topaz8, (UBYTE *) "(Use HexaDecimal)", NULL 
};

PRIVATE UWORD InPortGTypes[] = {

   BUTTON_KIND,   STRING_KIND,   BUTTON_KIND
};


PRIVATE int OkayBtClicked( void );
PRIVATE int InPortStrClicked( void );
PRIVATE int AbortBtClicked( void );

PRIVATE struct NewGadget InPortNGad[] = {

    13, 71, 59, 22, (UBYTE *) " _OKAY ", NULL, OkayBt, 
   PLACETEXT_IN, NULL, (APTR) OkayBtClicked,

   131, 43, 91, 15, (UBYTE *)   "Value:", NULL, INPORTSTR, 
   PLACETEXT_LEFT, NULL, (APTR) InPortStrClicked,

   265, 71, 64, 22, (UBYTE *) " _ABORT ", NULL, AbortBt, 
   PLACETEXT_IN, NULL, (APTR) AbortBtClicked
};

PRIVATE ULONG InPortGTags[] = {

   (GT_Underscore), '_', (TAG_DONE),

   (GTST_MaxChars), 3, 
   (STRINGA_Justification), (GACT_STRINGCENTER), (TAG_DONE),

   (GT_Underscore), '_', (TAG_DONE)
};

/* ----------------------------------------------------------------- */

PRIVATE void CloseInPortWindow( void )
{
   if (InPortWnd != NULL) 
      {
      CloseWindow( InPortWnd );
      InPortWnd = NULL;
      }

   if (InPortGList != NULL) 
      {
      FreeGadgets( InPortGList );
      InPortGList = NULL;
      }

   return;
}

PRIVATE int  PortValue = -1, ValidPortValue = FALSE;

PRIVATE int InPortStrClicked( void )
{
   int PortVal = 0;

   (void) stch_i( StrBfPtr( InPortGadgets[ INPORTSTR ] ), &PortVal );

   if (PortVal < 0 || PortVal > 0xFF)
      {
      (void) Handle_Problem( "Supplied value out of range!", 
                             "IN() Value Problem:", &PortVal
                           );
      StrBfPtr( InPortGadgets[ INPORTSTR ] )[0] = '\0';      
      ValidPortValue = FALSE;

      return( (int) TRUE );
      }
   else
      {
      ValidPortValue = TRUE;
      PortValue      = PortVal;

      return( (int) TRUE );
      }
}

PRIVATE int OkayBtClicked( void )
{
   int PortVal = -1;

   if (ValidPortValue == TRUE)
      {
      CloseInPortWindow();

      return( (int) FALSE );
      }
   else
      {
      (void) stch_i( StrBfPtr( InPortGadgets[ INPORTSTR ] ), &PortVal );

      if (PortVal < 0 || PortVal > 0xFF)
         {
         (void) Handle_Problem( "Supplied value out of range!", 
                                "IN() Value Problem:", &PortVal
                              );
         StrBfPtr( InPortGadgets[ INPORTSTR ] )[0] = '\0';      
         ValidPortValue = FALSE;

         return( (int) TRUE );
         }
      else
         {
         ValidPortValue = TRUE;
         PortValue      = PortVal;

         return( (int) FALSE );
         }
      }
}


PRIVATE int AbortBtClicked( void )
{
   ValidPortValue = FALSE;
   PortValue      = -1;

   CloseInPortWindow();

   return( (int) FALSE );
}



PRIVATE void InPortRender( void )
{
   UWORD offx, offy;

   offx = InPortWnd->BorderLeft;
   offy = InPortWnd->BorderTop;

   PrintIText( InPortWnd->RPort, InPortIText, offx, offy );
   
   return;
}

PRIVATE int OpenInPortWindow( void )
{
   struct NewGadget ng;
   struct Gadget    *g;
   UWORD            lc, tc;
   UWORD            offx = Scr->WBorLeft, 
                    offy = Scr->WBorTop + Scr->RastPort.TxHeight + 1;

   if ((g = CreateContext( &InPortGList )) == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < InPort_CNT; lc++) 
      {
      CopyMem( (char *) &InPortNGad[ lc ], (char *) &ng, 
               (long) sizeof( struct NewGadget )
             );

      ng.ng_VisualInfo = VisualInfo;
      ng.ng_TextAttr   = &topaz8;
      ng.ng_LeftEdge  += offx;
      ng.ng_TopEdge   += offy;

      InPortGadgets[ lc ] = g = CreateGadgetA( (ULONG) InPortGTypes[ lc ], 
                                  g, 
                                  &ng, 
                                  (struct TagItem *) &InPortGTags[ tc ] );

      while (InPortGTags[ tc ] != TAG_DONE) 
         tc += 2;
      
      tc++;

      if (g == NULL)
         return( -2 );
      }

   if ((InPortWnd = OpenWindowTags( NULL,

                        WA_Left,        InPortLeft,
                        WA_Top,         InPortTop,
                        WA_Width,       InPortWidth,
                        WA_Height,      InPortHeight + offy,
                        
                        WA_IDCMP,       BUTTONIDCMP | STRINGIDCMP
                          | IDCMP_REFRESHWINDOW | IDCMP_VANILLAKEY,
                        
                        WA_Flags,       WFLG_DRAGBAR | WFLG_DEPTHGADGET
                          | WFLG_SMART_REFRESH | WFLG_ACTIVATE 
                          | WFLG_RMBTRAP,
                        
                        WA_Gadgets,     InPortGList,
                        WA_Title,       InPortWdt,
                        TAG_DONE )
      ) == NULL)
      return( -4 );

   GT_RefreshWindow( InPortWnd, NULL );
   InPortRender();

   return( 0 );
}


PRIVATE int InPortVanillaKey( int whichkey )
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

PRIVATE int HandleInPortIDCMP( void )
{
   struct IntuiMessage *m;
   int                 (*func)();
   BOOL                running = TRUE;

   while (running == TRUE)
      {
      if ((m = GT_GetIMsg( InPortWnd->UserPort )) == NULL) 
         {
         (void) Wait( 1L << InPortWnd->UserPort->mp_SigBit );
         continue;
         }

      CopyMem( (char *) m, (char *) &InPortMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (InPortMsg.Class) 
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( InPortWnd );
            InPortRender();
            GT_EndRefresh( InPortWnd, TRUE );
            break;

         case IDCMP_VANILLAKEY:
            running = InPortVanillaKey( InPortMsg.Code );
            break;
            
         case IDCMP_GADGETUP:
            func = (void *) 
                     ((struct Gadget *)InPortMsg.IAddress)->UserData;
            
            if (func != NULL)
               running = func();
           
            break;
         }
      }

   return( running );
}


PUBLIC int HandleInPort( void )
{
   if (OpenInPortWindow() < 0)
      {
      fprintf( stderr, "problem in Opening IN() Port Requester!\n" );

      (void) Handle_Problem( "Couldn't open IN() Port Requester!", 
                             "IN() Port Requester Problem:", NULL 
                           );
      return( -1 );
      }

   (void) HandleInPortIDCMP();

   if (ValidPortValue == TRUE)
      return( PortValue );
   else
      return( 257 );  /* value greater than 8 bits! */
}

/* --------------- END of InPort.c file -------------------------- */
