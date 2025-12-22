/****h* AmigaTalk/Disk2.c [3.0] ***************************************
*
* NAME
*    Disk2.c
*
* DESCRIPTION
*    GUI for displaying ByteArrays.
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    08-Jan-2003 - Moved all string constants to StringConstants.h
*
* NOTES
*    $VER: Disk2.c 3.0 (25-Oct-2004) by J.T. Steichen
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
#include <intuition/gadgetclass.h>

#include <libraries/gadtools.h>

#include <graphics/displayinfo.h>
#include <graphics/gfxbase.h>

#ifndef __amigaos4__

# include <clib/exec_protos.h>
# include <clib/intuition_protos.h>
# include <clib/gadtools_protos.h>
# include <clib/graphics_protos.h>
# include <clib/diskfont_protos.h>

IMPORT struct IntuitionBase *IntuitionBase;
IMPORT struct GfxBase       *GfxBase;
IMPORT struct Library       *GadToolsBase;

#else

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/intuition.h>
# include <proto/gadtools.h>
# include <proto/graphics.h>
# include <proto/diskfont.h>

IMPORT struct Library *IntuitionBase;
IMPORT struct Library *GfxBase;
IMPORT struct Library *GadToolsBase;

#endif

#include "ATStructs.h"

#include "FuncProtos.h" 

#include "StringConstants.h"
#include "StringIndexes.h"

#include "CPGM:GlobalObjects/CommonFuncs.h"

#define BALV   0
#define DoneBt 1

#define D1_CNT 2

// ---------------------------------------------------------------

IMPORT struct Screen    *Scr;
IMPORT APTR              VisualInfo;

IMPORT struct TextAttr  *Font;
IMPORT struct CompFont   CFont;

IMPORT UBYTE *AaarrggButton;
IMPORT UBYTE *DefaultButtons;
IMPORT UBYTE *SystemProblem;
IMPORT UBYTE *ATalkProblem;
IMPORT UBYTE *ErrMsg;

// ---------------------------------------------------------------

#define TXTLENGTH   80

PUBLIC UBYTE  D1Wdt[TXTLENGTH] = { 0, }; // D2_WTITLE;

// ---------------------------------------------------------------

PRIVATE struct Window       *D1Wnd   = NULL;
PRIVATE struct Gadget       *D1GList = NULL;
PRIVATE struct IntuiMessage  D1Msg;
PRIVATE struct Gadget       *D1Gadgets[ D1_CNT ];

PRIVATE UWORD  D1Left    = 0;
PRIVATE UWORD  D1Top     = 32;
PRIVATE UWORD  D1Width   = 632;
PRIVATE UWORD  D1Height  = 290;

PRIVATE struct TextFont *D1Font = NULL;

PRIVATE struct List         BALVList = { 0, };
PRIVATE struct ListViewMem *lvm      = NULL;

PRIVATE ULONG               NumLines     = 0L;
PRIVATE ULONG               NumAllocated = 0L; // Allocation Guard.

// TXTLENGTH * NumLines in Dir':

PRIVATE UWORD D1GTypes[ D1_CNT ] = { LISTVIEW_KIND, BUTTON_KIND };

PRIVATE int BALVClicked(   int whichitem );
PRIVATE int DoneBtClicked( int dummy     );

PUBLIC struct NewGadget D1NGad[ D1_CNT ] = {

     2,  17, 626, 247, NULL, NULL, BALV,   PLACETEXT_ABOVE, 
   NULL, (APTR) BALVClicked,

   542, 266,  72,  16, NULL, NULL, DoneBt, PLACETEXT_IN, 
   NULL, (APTR) DoneBtClicked
};

PRIVATE ULONG D1GTags[] = {

   GTLV_Labels,       (ULONG) &BALVList, 
   GTLV_ReadOnly,     TRUE, 
   GTLV_Selected,     0,
   GTLV_ShowSelected, 0L,
   LAYOUTA_Spacing,   2, 
   TAG_DONE,
	
   GT_Underscore, UNDERSCORE_CHAR, TAG_DONE
};

// ----------------------------------------------------------------

PRIVATE void CloseD1Window( void )
{
   if (D1Wnd) // != NULL) 
      {
      CloseWindow( D1Wnd );
      D1Wnd = NULL;
      }

   if (D1GList) // != NULL) 
      {
      FreeGadgets( D1GList );
      D1GList = NULL;
      }

   if (D1Font) // != NULL) 
      {
      CloseFont( D1Font );
      D1Font = NULL;
      }

   return;
}

PRIVATE int BALVClicked( int whichitem )
{
   return( (int) TRUE );
}

PRIVATE int DoneBtClicked( int dummy )
{
   return( (int) FALSE );
}

PRIVATE int OpenD1Window( void )
{
   struct NewGadget  ng;
   struct Gadget    *g;
   UWORD             lc, tc;
   UWORD             wleft = D1Left, wtop = D1Top, ww, wh;

   ComputeFont( Scr, Font, &CFont, D1Width, D1Height );

   ww = ComputeX( CFont.FontX, D1Width );
   wh = ComputeY( CFont.FontY, D1Height );

   if ((wleft + ww + CFont.OffX + Scr->WBorRight) > Scr->Width) 
      wleft = Scr->Width - ww;

   if ((wtop + wh + CFont.OffY + Scr->WBorBottom) > Scr->Height) 
      wtop = Scr->Height - wh;

   if (!(g = CreateContext( &D1GList ))) // == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < D1_CNT; lc++) 
      {
      CopyMem( (char *) &D1NGad[ lc ], (char *) &ng, 
               (long) sizeof( struct NewGadget )
             );

      ng.ng_VisualInfo = VisualInfo;
      ng.ng_TextAttr   = Font;

      ng.ng_LeftEdge   = CFont.OffX + ComputeX( CFont.FontX, 
                                                ng.ng_LeftEdge
                                              );

      ng.ng_TopEdge    = CFont.OffY + ComputeY( CFont.FontY,
                                                ng.ng_TopEdge
                                              );

      ng.ng_Width      = ComputeX( CFont.FontX, ng.ng_Width );
      ng.ng_Height     = ComputeY( CFont.FontY, ng.ng_Height);

      D1Gadgets[ lc ] = g 
                      = CreateGadgetA( (ULONG) D1GTypes[ lc ], 
                                       g, 
                                       &ng, 
                                       (struct TagItem *) &D1GTags[ tc ]
                                     );

      while (D1GTags[ tc ] != TAG_DONE)
         tc += 2;

      tc++;

      if (!g) // == NULL)
         return( -2 );
      }

   if (!(D1Wnd = OpenWindowTags( NULL,

                   WA_Left,         wleft,
                   WA_Top,          wtop,
                   WA_Width,        ww + CFont.OffX + Scr->WBorRight,
                   WA_Height,       wh + CFont.OffY + Scr->WBorBottom,
                   
                   WA_IDCMP,        LISTVIEWIDCMP | BUTTONIDCMP 
                     | IDCMP_VANILLAKEY | IDCMP_REFRESHWINDOW,

                   WA_Flags,        WFLG_DRAGBAR | WFLG_DEPTHGADGET
                     | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,

                   WA_Gadgets,      D1GList,
                   WA_Title,        D1Wdt,
                   WA_CustomScreen, Scr,
                   TAG_DONE )
      )) // == NULL)
      return( -4 );

   GT_RefreshWindow( D1Wnd, NULL );

   return( 0 );
}

PRIVATE int D1VanillaKey( int whichkey )
{
   int rval = TRUE;
   
   switch (whichkey)
      {
      case SMALL_D_CHAR:
      case SMALL_X_CHAR:
      case SMALL_Q_CHAR:
      case CAP_X_CHAR:
      case CAP_D_CHAR:
      case CAP_Q_CHAR:
      
         rval = DoneBtClicked( 0 );
         break;
      }
      
   return( rval );
}

PRIVATE int HandleD1IDCMP( void )
{
   struct IntuiMessage *m;
   int                (*func)( int );
   BOOL                 running = TRUE;

   while (running == TRUE)
      {
      if (!(m = GT_GetIMsg( D1Wnd->UserPort ))) // == NULL) 
         {
         (void) Wait( 1L << D1Wnd->UserPort->mp_SigBit );
         
	 continue;
         }

      CopyMem( (char *) m, (char *) &D1Msg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (D1Msg.Class) 
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( D1Wnd );
            GT_EndRefresh( D1Wnd, TRUE );
            break;

         case IDCMP_VANILLAKEY:
            running = D1VanillaKey( D1Msg.Code );
            break;
            
         case IDCMP_GADGETUP:
         case IDCMP_GADGETDOWN:
            func = (int (*)( int )) ((struct Gadget *) D1Msg.IAddress)->UserData;
            
            if (func) // != NULL)
               running = func( D1Msg.Code );

            break;
         }
      }

   return( running );
}

PRIVATE void KillLV( struct ListViewMem *lvm )
{
   Guarded_FreeLV( lvm );

   NumAllocated = 0; // Deactivate the Allocation guard.

   return;
}

PRIVATE int AllocateLV( int numitems, int itemsize )
{
   if ((numitems < 1) || (itemsize < 1))
      {
      int ans = 0;
      
      sprintf( ErrMsg, DiskCMsg( MSG_FMT_ALLCLV_DISK2 ), numitems, itemsize );

      SetReqButtons( DiskCMsg( MSG_D2_BAILOUT_BUTTONS_DISK2 ) );

      ans = Handle_Problem( ErrMsg, ATalkProblem, NULL );

      SetReqButtons( DefaultButtons );

      if (ans == 0)
         {
         return( 2 ); // You define the SPECIAL_VALUE (> 0)!!
         }
      else // User pressed the Ignore button:
         {
         // Hopefully, the User is smarter than this:
         NumLines = 0;
         return( RETURN_WARN );
         }
      }

   if (numitems != NumAllocated)
      {
      /* Get rid of previous allocation.  This is safe because 
      ** KillLV() checks for NULL pointers & doesn't do anything if
      ** there's no memory allocated
      */
      KillLV( lvm );
      }
   else
      {
      NumLines = numitems;
      return( 0 ); // don't have to do any allocation!
      }

   // --------- GUARDED SECTION: -----------------------------------

   if (!(lvm = Guarded_AllocLV( numitems, itemsize )))
      {
      return( -2 );
      }

   // --------- END OF GUARDED SECTION: ----------------------------

   NumLines     = numitems;
   NumAllocated = numitems; // Activate the Allocation Guard again. 

   return( 0 );
}

PRIVATE UBYTE HorizMeasure[] = "00000000 11111111 22222222 33333333 ................";

PRIVATE struct IntuiText hm = { 0, };
    
PRIVATE void SetDisplaySize( int lines )
{
   int height = 0;
   int width  = 0;
   int wht    = Scr->WBorBottom + Scr->BarHeight 
                                + D1Font->tf_YSize 
                                + D1NGad[1].ng_Height
                                + Scr->WBorTop;

   hm.ITextFont = Font;
   hm.IText     = &HorizMeasure[0];
   width        = IntuiTextLength( &hm ); // Min' Width for the text (416).
   
   // 20 is approx' the width of the slider:
   width += Scr->WBorLeft + Scr->WBorRight + 26 - D1Left;

   if (width < D1Width)
      D1Width = width;
      
   if (lines >= 16)
      height = 16    * (D1Font->tf_YSize + 2) + wht;
   else
      height = lines * (D1Font->tf_YSize + 2) + wht;
      
   if (height < D1Height)
      D1Height = height;
   else if (height < Scr->Height)
      D1Height = height;

   // ListView Gadget adjustments:
   D1NGad[0].ng_Width   = D1Width - Scr->WBorLeft - Scr->WBorRight;

   D1NGad[0].ng_TopEdge = Scr->WBorTop + Scr->BarHeight - 3;

   D1NGad[0].ng_Height  = D1Height - wht + 10;

   // Button Gadget adjustments:
   D1NGad[1].ng_TopEdge  = D1Height - D1NGad[1].ng_Height - 5;
   D1NGad[1].ng_LeftEdge = (D1Width - D1NGad[1].ng_Width) / 2;
   
   D1Left = (Scr->Width - D1Width) / 2; // Center the Requester.

   return;
}

PRIVATE void MakeStrings( BYTEARRAY *bytes, int lines )
{
   int i = 0;
   
   for (i = 0; i < lines; i++)
      {
      (void) MakeHexASCIIStr( &lvm->lvm_NodeStrs[ i * lvm->lvm_NodeLength ], 
                              &bytes->bytes[i * 16 ] , 16 
                            );
      }
      
   return;
}

/* We don't need a ListView Gadget for 1 line, so adjust the
** Gadgets to reflect using a Text Gadget: 
*/

PRIVATE void MakeSmallGadgets( int numBytes )
{
   int length;

   hm.ITextFont = Font;
   hm.IText     = ONE_SPACE;
   length       = numBytes * IntuiTextLength( &hm ) + 20;

   D1GTypes[0] = TEXT_KIND;

   D1NGad[0].ng_Width    = length;
   D1NGad[0].ng_Height   = 15;
   
   D1NGad[1].ng_LeftEdge = (length - D1NGad[1].ng_Width) / 2;
   D1NGad[1].ng_TopEdge  = 35;
   
   D1GTags[0] = GTTX_Border;         D1GTags[1] = TRUE;
   D1GTags[2] = GTTX_Justification;  D1GTags[3] = GTJ_CENTER;
   D1GTags[4] = TAG_DONE;
   
   D1GTags[5] = GT_Underscore;       D1GTags[6] = UNDERSCORE_CHAR;
   D1GTags[7] = TAG_DONE;

   D1Height = 55;
   D1Width  = length + 20;
   D1Left   = (Scr->Width - D1Width) / 2; // Center the Requester.
   
   return;
}

PUBLIC int DisplayBytes( BYTEARRAY *bytes, char *windowTitle )
{
   IMPORT struct Window *ATWnd;

   char buffer[64] = { 0, }; 
   int  rval  = -1;
   int  lines = bytes->bsize / 16;

   buffer[0] = NIL_CHAR;

   if (!(D1Font = OpenDiskFont( Font ))) // == NULL)
      {
      NotOpened( 7 );

      return( -3 );
      }

   if (lines > 1)
      {
      SetDisplaySize( lines );

      StringNCopy( &D1Wdt[0], windowTitle, TXTLENGTH );

      if (OpenD1Window() < 0)
         {
         NotOpened( 1 );

         return( -1 );
         }
      
      if ((rval = AllocateLV( lines, TXTLENGTH )) < 0)
         {
         MemoryOut( DiskCMsg( MSG_D2_DSPBTS_FUNC_DISK2 ) );

         return( -2 );
         }

      HideListFromView( D1Gadgets[ 0 ], D1Wnd );

      SetupList( &BALVList, lvm );

      MakeStrings( bytes, NumLines );

      GT_SetGadgetAttrs( D1Gadgets[ BALV ], D1Wnd, NULL,
                         GTLV_Labels,       &BALVList,
                         GTLV_ShowSelected, 0,
                         GTLV_Selected,     0,
                         TAG_DONE
                       );
      }
   else // Less than 16 ByteCodes to Display:
      {
      // We don't need a ListView Gadget for 1 line, use a Text Gadget:
      MakeSmallGadgets( bytes->bsize );
      
      StringNCopy( &D1Wdt[0], windowTitle, TXTLENGTH );

      if (OpenD1Window() < 0)
         {
         NotOpened( 1 );
 
         return( -1 );
         }

      (void) MakeHexASCIIStr( &buffer[0],
                              &bytes->bytes[ 0 ] , 16 
                            );
      
      GT_SetGadgetAttrs( D1Gadgets[ BALV ], D1Wnd, NULL,
                         GTTX_Text, (STRPTR) &buffer[0], TAG_DONE
                       );
      }

   (void) HandleD1IDCMP();
   
   CloseD1Window();

   KillLV( lvm );

   (void) ActivateWindow( ATWnd ); // Get ready for next command.

   return( 0 );
}

/* ------------------------ END of Disk2.c file! ------------------ */
