/****h* AmigaTalk/ATHB.c [3.0] *************************************
*
* NAME
*    ATHB.c
*
* DESCRIPTION
*    Part of the Browser handling code for AmigaTalk.
*
* FUNCTIONAL INTERFACE:
*
*    PUBLIC int GetClassType( char *TheType );
*
* HISTORY
*    24-Oct-2004 - Added AmigaOS4 & gcc support.
*
*    09-Jan-2003 - Moved all string constants to StringConstants.h
*
*    30-Apr-2000 - No more minor changes needed in this file.
*
*    09-Feb-2000 - Started a re-write of the entire program,
*                  mostly to incorporate CommonFuncs.o.
*
* NOTES
*    'TheType' has to be at least ten characters long!
*
*    $VER: AmigaTalk:Src/ATHB.c 3.0 (24-Oct-2004) by J.T. Steichen
********************************************************************
*
*/

#include <string.h>

#include <exec/types.h>

#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/gadgetclass.h>

#include <libraries/gadtools.h>

#include <graphics/displayinfo.h>
#include <graphics/gfxbase.h>

#ifdef __SASC

# include <clib/exec_protos.h>
# include <clib/intuition_protos.h>
# include <clib/gadtools_protos.h>
# include <clib/utility_protos.h>

IMPORT struct Library       *GadToolsBase;
IMPORT struct IntuitionBase *IntuitionBase;

#else

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/intuition.h>
# include <proto/gadtools.h>
# include <proto/utility.h>

IMPORT struct Library *GadToolsBase;
IMPORT struct Library *IntuitionBase;

IMPORT struct GadToolsIFace *IGadTools;

#endif

#include "StringConstants.h"
#include "StringIndexes.h"

#include "CPGM:GlobalObjects/CommonFuncs.h"

#define ClassMX   0
#define OkayBt    1
#define CancelBt  2

#define HB_CNT    3

#define GENERAL   0
#define INTUITION 1
#define SYSTEM    2
#define USER      3

IMPORT struct Screen *Scr;
IMPORT struct Window *ATWnd;
IMPORT UBYTE         *PubScreenName;
IMPORT APTR           VisualInfo;

IMPORT UBYTE *AaarrggButton;
IMPORT UBYTE *DefaultButtons;
IMPORT UBYTE *ATalkProblem;

// -------------------------------------------------------------------

PRIVATE struct Window       *HBWnd    = NULL;
PRIVATE struct Gadget       *HBGList  = NULL;
PRIVATE struct IntuiMessage  HBMsg;
PRIVATE struct Gadget       *HBGadgets[ HB_CNT ];

PRIVATE UWORD  HBLeft   = 125;
PRIVATE UWORD  HBTop    = 14;
PRIVATE UWORD  HBWidth  = 340;
PRIVATE UWORD  HBHeight = 140;
PRIVATE UBYTE *HBWdt    = NULL; // ATHB_WTITLE;

PRIVATE UBYTE *CTypeLabels[] = {

   (UBYTE *) NULL, 
   (UBYTE *) NULL, 
   (UBYTE *) NULL, 
   (UBYTE *) NULL,
   NULL 
};

PRIVATE struct TextAttr topaz8 = { (STRPTR) "topaz.font", 8, 0x00, 0x01 };

PRIVATE struct IntuiText HBIText[] = {

   2, 0, JAM1, 23, 4, &topaz8, (UBYTE *) NULL, NULL 
};

PRIVATE UWORD HBGTypes[] = { MX_KIND, BUTTON_KIND, BUTTON_KIND };

PRIVATE int ClassSystemClicked( int whichclass );
PRIVATE int OkayBtClicked(      int dummy      );
PRIVATE int CancelBtClicked(    int dummy      );

PUBLIC struct NewGadget HBNGad[] = {

   111, 25, 17,  9,                  NULL, NULL, ClassMX, 
   PLACETEXT_RIGHT, NULL, (APTR) ClassSystemClicked,
   
     8, 98, 86, 25, (UBYTE *) "_OKAY!", NULL, OkayBt, 
   PLACETEXT_IN, NULL, (APTR) OkayBtClicked,
   
   239, 98, 81, 25, (UBYTE *) "_CANCEL!", NULL, CancelBt, 
   PLACETEXT_IN, NULL, (APTR) CancelBtClicked
};

PRIVATE ULONG HBGTags[] = {

   GTMX_Labels, (ULONG) &CTypeLabels[ 0 ], 
   GTMX_Spacing, 3, GT_Underscore, UNDERSCORE_CHAR, TAG_DONE,

   GT_Underscore, UNDERSCORE_CHAR, TAG_DONE,
   GT_Underscore, UNDERSCORE_CHAR, TAG_DONE
};

/* -------------------------- Functions: ------------------------ */

PRIVATE void CloseHBWindow( void )
{
   if (HBWnd) // != NULL) 
      {
      CloseWindow( HBWnd );
      HBWnd = NULL;
      }

   if (HBGList) // != NULL) 
      {
      FreeGadgets( HBGList );
      HBGList = NULL;
      }

   return;
}

PRIVATE BOOL ClassSelected = FALSE;

PRIVATE char ct[10] = { 0, }, *classtype = &ct[0];

PRIVATE int ClassSystemClicked( int whichclass )
{
   switch (whichclass)
      {
      case GENERAL:
         ClassSelected = TRUE;
         // FALL THROUGH:

      default:
         StringCopy( classtype, ATHBCMsg( ATHB_GENCLASS_ATHB ) );
         break;

      case INTUITION:
         ClassSelected = TRUE;
         StringCopy( classtype, ATHBCMsg( ATHB_INTCLASS_ATHB ) );
         break;

      case SYSTEM:
         ClassSelected = TRUE;
         StringCopy( classtype, ATHBCMsg( ATHB_SYSCLASS_ATHB ) );
         break;

      case USER:
         ClassSelected = TRUE;
         StringCopy( classtype, ATHBCMsg( ATHB_USECLASS_ATHB ) );
         break;
      }

   return( (int) TRUE );
}

#define GOT_CLASS 4

PRIVATE int OkayBtClicked( int dummy )
{
   if (ClassSelected == TRUE)
      {
      CloseHBWindow();
      return( GOT_CLASS );
      }
   else // Use the default value of "GENERAL" 
      {
      if (StringLength( classtype ) < 1)
         StringCopy( classtype, ATHBCMsg( ATHB_GENCLASS_ATHB ) );
           
      CloseHBWindow();
      return( GOT_CLASS );
      }
}

PRIVATE int CancelBtClicked( int dummy )
{
   CloseHBWindow();

   return( (int) FALSE );
}

PRIVATE void HBRender( void )
{
   UWORD offx, offy;

   offx = HBWnd->BorderLeft;
   offy = HBWnd->BorderTop;

   DrawBevelBox( HBWnd->RPort, offx + 92, offy + 16, 
                 134, 61, GT_VisualInfo, VisualInfo, TAG_DONE
               );

   PrintIText( HBWnd->RPort, HBIText, offx, offy );

   return;
}

PRIVATE int OpenHBWindow( void )
{
   struct NewGadget  ng;
   struct Gadget    *g;
   UWORD             lc, tc;
   UWORD             offx = Scr->WBorLeft, 
                     offy = Scr->WBorTop + Scr->RastPort.TxHeight + 1;

   if (!(g = CreateContext( &HBGList )))
      return( -1 );

   for (lc = 0, tc = 0; lc < HB_CNT; lc++) 
      {
      CopyMem( (char *) &HBNGad[ lc ], (char *) &ng, 
               (long) sizeof( struct NewGadget )
             );

      ng.ng_VisualInfo = VisualInfo;
      ng.ng_TextAttr   = &topaz8;
      ng.ng_LeftEdge  += offx;
      ng.ng_TopEdge   += offy;

      HBGadgets[ lc ] = g = CreateGadgetA( (ULONG) HBGTypes[ lc ], 
                                           g, 
                                           &ng, 
                                           (struct TagItem *) &HBGTags[ tc ] 
					 );

      while (HBGTags[ tc ]) // != NULL)
         tc += 2;

      tc++;

      if (!g) // == NULL)
         return( -2 );
      }

   if (!(HBWnd = OpenWindowTags( NULL,

                      WA_Left,        HBLeft,
                      WA_Top,         HBTop,
                      WA_Width,       HBWidth,
                      WA_Height,      HBHeight + offy,
                      WA_IDCMP,       MXIDCMP | BUTTONIDCMP 
                        | IDCMP_REFRESHWINDOW,
                      
                      WA_Flags,       WFLG_DRAGBAR | WFLG_DEPTHGADGET
                        | WFLG_SMART_REFRESH | WFLG_ACTIVATE
                        | WFLG_RMBTRAP,
                      
                      WA_Gadgets,      HBGList,
                      WA_Title,        HBWdt,
                      WA_CustomScreen, Scr,
                      TAG_DONE )
      )) // == NULL)
      return( -4 );

   GT_RefreshWindow( HBWnd, NULL );
   HBRender();

   return( 0 );
}

PRIVATE int HandleHBIDCMP( void )
{
   struct IntuiMessage *m;
   int                 (*func)( int );
   BOOL                running = TRUE;

   while (running == TRUE)
      {
      if (!(m = GT_GetIMsg( HBWnd->UserPort ))) // == NULL) 
         {
         (void) Wait( 1L << HBWnd->UserPort->mp_SigBit );

         continue;
         }

      CopyMem( (char *) m, (char *) &HBMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (HBMsg.Class) 
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( HBWnd );
            HBRender();
            GT_EndRefresh( HBWnd, TRUE );
            break;

         case IDCMP_GADGETUP:
         case IDCMP_GADGETDOWN:
            func    = (int (*)( int )) ((struct Gadget *) HBMsg.IAddress)->UserData;
            
            if (func) // != NULL)
               running = func( HBMsg.Code );

            break;
         }
      }

   return( running );
}

PUBLIC int GetClassType( char *TheType )
{
   int rval = 0;

   HBWdt = ATHBCMsg( ATHB_WTITLE_ATHB );
   
   HBIText[0].IText = ATHBCMsg( MSG_SELECT_ATHB );

   CTypeLabels[0] = ATHBCMsg( MSG_GENERAL_ATHB   ); // (UBYTE *) ATHB_GENERAL,
   CTypeLabels[1] = ATHBCMsg( MSG_INTUITION_ATHB ); // (UBYTE *) ATHB_INTUITION,
   CTypeLabels[2] = ATHBCMsg( MSG_SYSTEM_ATHB    ); // (UBYTE *) ATHB_SYSTEM,
   CTypeLabels[3] = ATHBCMsg( MSG_USER_ATHB      ); // (UBYTE *) ATHB_USER,

   HBNGad[1].ng_GadgetText = ATHBCMsg( MSG_GAD_OKAY_ATHB   );
   HBNGad[2].ng_GadgetText = ATHBCMsg( MSG_GAD_CANCEL_ATHB );
   
   if (OpenHBWindow() < 0) 
      {
      NotOpened( ATHBCMsg( ATHB_CLASSREQ_ATHB ) );

      return( -1 );
      }

   SetNotifyWindow( HBWnd );

   rval = HandleHBIDCMP();

   SetNotifyWindow( ATWnd );

   if (rval == GOT_CLASS)
      {
      StringCopy( TheType, classtype );

      return( 0 );
      }

   return( -1 );
}

/* ----------------------- END of ATHB.c file! ----------------------- */
