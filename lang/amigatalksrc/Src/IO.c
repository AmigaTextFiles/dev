/****h* AmigaTalk/IO.c [3.0] ******************************************
*
* NAME 
*   IO.c
*
* DESCRIPTION
*   Functions that handle AmigaTalk I/O primitives.
*
* FUNCTIONAL INTERFACE:
*
*   PUBLIC OBJECT *HandleIO( int numargs, OBJECT **args ); <186>
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*   31-Oct-2003 - Added two methods to Set/Clear searching of the
*                 internal memory lists for free slots.  The Clear
*                 method will speed up code execution for large
*                 instantiations, such as the Intuition Class.
*
*   03-Oct-2003 - Added two more primitives to handle adding &
*                 removing User Script MenuItems from the main
*                 command window menu strip.
*
*   07-Jan-2003 - Moved all string constants to StringConstants.h
*
*   18-Apr-2002 - Added the getActiveScreen() & getActiveWindow()
*                 primitives & removed the ALlocLV() & KillLV() code. 
*
*   18-May-2000 - Moved FontXDim() to CommonFuncs.c
*
* NOTES
*   $VER: AmigaTalk:Src/IO.c 3.0 (25-Oct-2004) by J.T. Steichen
***********************************************************************
*
*/

#include <stdio.h>

#include <exec/types.h>
#include <exec/memory.h>
#include <AmigaDOSErrs.h>

#include <dos/dostags.h>

#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/imageclass.h>
#include <intuition/gadgetclass.h>

#include <libraries/gadtools.h>
#include <libraries/asl.h>

#include <utility/tagitem.h>

#include <graphics/displayinfo.h>
#include <graphics/gfxbase.h>

#ifdef __SASC

# include <clib/exec_protos.h>
# include <clib/dos_protos.h>
# include <clib/intuition_protos.h>
# include <clib/gadtools_protos.h>
# include <clib/graphics_protos.h>
# include <clib/utility_protos.h> 
# include <clib/diskfont_protos.h>

IMPORT struct IntuitionBase *IntuitionBase;
IMPORT struct GfxBase       *GfxBase;
IMPORT struct Library       *GadToolsBase;

#else

# define __USE_INLINE__

# include <proto/dos.h>
# include <proto/exec.h>
# include <proto/intuition.h>
# include <proto/gadtools.h>
# include <proto/graphics.h>
# include <proto/utility.h>
# include <proto/diskfont.h>

IMPORT struct Library *IntuitionBase;
IMPORT struct Library *GfxBase;
IMPORT struct Library *GadToolsBase;

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ATStructs.h"

#include "Object.h"
#include "Constants.h"
#include "FuncProtos.h"

#include "StringConstants.h"
#include "StringIndexes.h"

#ifndef  StrBfPtr
# define StrBfPtr( g ) (((struct StringInfo *)g->SpecialInfo)->Buffer)
# define IntBfPtr( g ) (((struct StringInfo *)g->SpecialInfo)->LongInt)
#endif

#define SIGad     0 
#define DoneBt    1
#define CancelBt  2

/*
IMPORT void SetupLV( struct List *LVList,
                     struct Node *nodes, 
                     char        *buffer,
                     int          numitems, 
                     int          itemsize
                   );
*/

PRIVATE int IO_CNT = 3; // How many gadgets are there?

// --------------------------------------------------------------------

IMPORT OBJECT *o_nil, *o_true, *o_false;

IMPORT int     ChkArgCount( int need, int numargs, int primnumber );
IMPORT OBJECT *ReturnError( void );
IMPORT OBJECT *PrintArgTypeError( int primnumber );


IMPORT struct Screen    *Scr;
IMPORT struct Window    *ATWnd;
IMPORT APTR              VisualInfo;

IMPORT struct TextAttr  *Font;
IMPORT struct CompFont   CFont;

// See Global.c for these: --------------------------------------------

IMPORT UBYTE *DefaultButtons;

IMPORT UBYTE *SystemProblem;
IMPORT UBYTE *AllocProblem;
IMPORT UBYTE *UserPgmError;

IMPORT UBYTE *ErrMsg;

// --------------------------------------------------------------------

PRIVATE struct Window       *IOWnd   = NULL;
PRIVATE struct Gadget       *IOGList = NULL;
PRIVATE struct IntuiMessage  IOMsg;
PRIVATE struct Gadget       *IOGadgets[ 3 ] = { NULL, }; // IO_CNT == 3

PRIVATE UWORD IOLeft   = 0;
PRIVATE UWORD IOTop    = 32;
PRIVATE UWORD IOWidth  = 632;
PRIVATE UWORD IOHeight = 50;

PRIVATE struct TextFont *IOFont = NULL;

// --------------------------------------------------------------------

#define TXTLENGTH   80

PRIVATE struct ListViewMem *lvm      = NULL;
PRIVATE struct List         SIList   = { 0, };
PRIVATE ULONG               NumLines = 0L;

//PRIVATE struct Node *SINodes      = NULL;
//PRIVATE ULONG        NumAllocated = 0L; // Allocation Guard.

// TXTLENGTH * NumLines in Dir':

//PRIVATE UBYTE       *NodeStrs     = NULL;

// --------------------------------------------------------------------

PRIVATE UWORD IOGTypes[] = { LISTVIEW_KIND, BUTTON_KIND, BUTTON_KIND };

#define BUTT_WIDTH  72
#define BUTT_HEIGHT 17

PRIVATE int SIGadClicked(    void );
PRIVATE int DoneBtClicked(   void );
PRIVATE int CancelBtClicked( void );

PUBLIC struct NewGadget IONGad[] = { // Visible to CatalogIO();

     2, 17, 60, 17, NULL, NULL, SIGad,    PLACETEXT_ABOVE, 
   NULL, (APTR) SIGadClicked,

     7, 35, 72, 17, NULL, NULL, DoneBt,   PLACETEXT_IN, 
   NULL, (APTR) DoneBtClicked,

   540, 35, 72, 17, NULL, NULL, CancelBt, PLACETEXT_IN, 
   NULL, (APTR) CancelBtClicked,
};

PRIVATE ULONG IOGTags[] = {

   GTLV_Labels,       (ULONG) &SIList, 
   GTLV_ReadOnly,     TRUE, 
   GTLV_Selected,     0,
   GTLV_ShowSelected, 0L,
   LAYOUTA_Spacing,   2, 
   TAG_DONE,
	
   GT_Underscore, UNDERSCORE_CHAR, TAG_DONE,
   GT_Underscore, UNDERSCORE_CHAR, TAG_DONE
};

PRIVATE void CloseIOWindow( void )
{
   if (IOWnd) // != NULL) 
      {
      CloseWindow( IOWnd );
      IOWnd = NULL;
      }

   if (IOGList) // != NULL) 
      {
      FreeGadgets( IOGList );
      IOGList = NULL;
      }

   if (IOFont) // != NULL) 
      {
      CloseFont( IOFont );
      IOFont = NULL;
      }

   return;
}

PRIVATE int SIGadClicked( void )
{
   return( (int) TRUE );
}

#define GOTAVALUE 2

PRIVATE int DoneBtClicked( void )
{
   return( (int) GOTAVALUE ); // Something greater than TRUE!
}

PRIVATE int CancelBtClicked( void )
{
   return( (int) FALSE );
}

PRIVATE int OpenIOWindow( char *wTitle )
{
   struct NewGadget  ng;
   struct Gadget    *g;
   UWORD             lc, tc;
   UWORD             wleft, wtop, ww, wh;

   ComputeFont( Scr, Font, &CFont, IOWidth, IOHeight );

   ww = ComputeX( CFont.FontX, IOWidth );
   wh = ComputeY( CFont.FontY, IOHeight );
/*
   if ((wleft + ww + CFont.OffX + Scr->WBorRight) > Scr->Width) 
      wleft = Scr->Width - ww;

   if ((wtop + wh + CFont.OffY + Scr->WBorBottom) > Scr->Height) 
      wtop = Scr->Height - wh;
*/
   wleft = IOLeft; // (Scr->Width  - ww) / 2;  // Center the IOWindow.
   wtop  = IOTop;  // (Scr->Height - wh) / 2;

   if (!(g = CreateContext( &IOGList ))) // == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < IO_CNT; lc++) 
      {
      CopyMem( (char *) &IONGad[ lc ], (char *) &ng, 
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

      IOGadgets[ lc ] = g = CreateGadgetA( (ULONG) IOGTypes[ lc ], 
                              g, 
                              &ng, 
                              (struct TagItem *) &IOGTags[ tc ] );

      while (IOGTags[ tc ] != TAG_DONE) // NULL) 
         tc += 2;

      tc++;

      if (!g) // == NULL)
         return( -2 );
      }

   if (!(IOWnd = OpenWindowTags( NULL,

                   WA_Left,         wleft,
                   WA_Top,          wtop,
                   WA_Width,        ww + CFont.OffX + Scr->WBorRight,
                   WA_Height,       wh + CFont.OffY + Scr->WBorBottom,
                   
                   WA_IDCMP,        LISTVIEWIDCMP | BUTTONIDCMP 
                     | STRINGIDCMP | IDCMP_VANILLAKEY 
                     | IDCMP_REFRESHWINDOW,

                   WA_Flags,        WFLG_DRAGBAR | WFLG_DEPTHGADGET
                     | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,

                   WA_Gadgets,      IOGList,
                   WA_Title,        wTitle,
                   WA_CustomScreen, Scr,
                   TAG_DONE )
      )) // == NULL)
      return( -4 );

   GT_RefreshWindow( IOWnd, NULL );

   return( 0 );
}

PRIVATE int IOVanillaKey( int whichkey )
{
   int rval = TRUE;
   
   switch (whichkey)
      {
      case SMALL_D_CHAR:
      case CAP_D_CHAR:
         rval = DoneBtClicked();
         break;

      case SMALL_X_CHAR:
      case CAP_X_CHAR:
      case SMALL_Q_CHAR:
      case CAP_Q_CHAR:
      case SMALL_C_CHAR:
      case CAP_C_CHAR:
         rval = CancelBtClicked();
         break;
      }
      
   return( rval );
}

PRIVATE int HandleIOIDCMP( void )
{
   struct IntuiMessage *m;
   int                (*func)( void );
   BOOL                 running = TRUE;

   while (running == TRUE)
      {
      if (!(m = GT_GetIMsg( IOWnd->UserPort ))) // == NULL) 
         {
         (void) Wait( 1L << IOWnd->UserPort->mp_SigBit );

         continue;
         }

      CopyMem( (char *) m, (char *) &IOMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (IOMsg.Class) 
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( IOWnd );
            GT_EndRefresh( IOWnd, TRUE );
            break;

         case IDCMP_VANILLAKEY:
            running = IOVanillaKey( IOMsg.Code );
            break;
            
         case IDCMP_GADGETUP:
         case IDCMP_GADGETDOWN:
            func = (int (*)( void )) ((struct Gadget *)IOMsg.IAddress)->UserData;
            
            if (func) // != NULL)
               running = func();

            break;
         }
      }

   return( running );
}

#define OUT_LENGTH 65

SUBFUNC void SetDisplaySize( int lines, int titlelen )
{
   int height = 0;
   int width  = 0;
   int wht    = Scr->WBorBottom + Scr->BarHeight 
                                + IOFont->tf_YSize 
                                + Scr->WBorTop;

   IONGad[DoneBt].ng_Height = BUTT_HEIGHT;

   wht  += IONGad[DoneBt].ng_Height;
   width = OUT_LENGTH * FontXDim( Font ); // Min' Width for the text (520).

   IOWidth = Scr->Width;
   
   if (titlelen > width)
      width = titlelen;
         
   // 20 is approx' the width of the slider:
   width += Scr->WBorLeft + Scr->WBorRight + 26 - IOLeft;

   if (width < IOWidth)
      IOWidth = width;
      
   if (lines >= 42)
      {
      height = 42 * (IOFont->tf_YSize + 2) + wht;
      }
   else
      height = lines * (IOFont->tf_YSize + 2) + wht;
      
   if (height < IOHeight)
      IOHeight = height;
   else if (height < Scr->Height)
      IOHeight = height;
   else
      IOHeight = Scr->Height;
      
   IOTop  = (Scr->Height - IOHeight) / 2; // Center the Requester:
   IOLeft = (Scr->Width  - IOWidth ) / 2;
   
   // ListView Gadget adjustments:
   IONGad[SIGad].ng_Width    = IOWidth - Scr->WBorLeft - Scr->WBorRight;
   IONGad[SIGad].ng_TopEdge  = Scr->WBorTop + Scr->BarHeight - 3;
   IONGad[SIGad].ng_LeftEdge = (IOWidth - IONGad[SIGad].ng_Width) / 2;
   IONGad[SIGad].ng_Height   = IOHeight - wht + 10;

   // Button Gadget adjustments:
   IONGad[DoneBt].ng_Width    = BUTT_WIDTH;
   IONGad[DoneBt].ng_Height   = BUTT_HEIGHT;
   IONGad[DoneBt].ng_TopEdge  = IOHeight - IONGad[DoneBt].ng_Height - 2;
   IONGad[DoneBt].ng_LeftEdge = (IOWidth - IONGad[DoneBt].ng_Width) / 2;
   
   return;
}

SUBFUNC void MakeStrings( char *input, char *output, int numLines )
{
   int i;
   
   for (i = 0; i < numLines; i++)
      {
      StringNCopy( &output[ i * TXTLENGTH  ], 
                   &input[  i * OUT_LENGTH ], TXTLENGTH 
                 );
      }

   return;
}

SUBFUNC void DisplayText( char *bytes, char *msg, char *windowTitle )
{
   IMPORT struct Window *ATWnd;

   int  lent  = StringLength( windowTitle ) * FontXDim( Font );
   int  lines = StringLength( bytes ) / OUT_LENGTH;

   IONGad[SIGad].ng_GadgetText = msg;
   
   SetDisplaySize( lines, lent );

   IOGTags[0]  = GTLV_Labels;
   IOGTags[1]  = (ULONG) &SIList;
   IOGTags[2]  = GTLV_ReadOnly;
   IOGTags[3]  = TRUE;
   IOGTags[4]  = GTLV_Selected;
   IOGTags[5]  = 0L;
   IOGTags[6]  = GTLV_ShowSelected;
   IOGTags[7]  = 0L;
   IOGTags[8]  = LAYOUTA_Spacing;
   IOGTags[9]  = 2; 
   IOGTags[10] = TAG_DONE;
	
   IOGTags[11] = GT_Underscore;
   IOGTags[12] = UNDERSCORE_CHAR;
   IOGTags[13] = TAG_DONE;

   if (OpenIOWindow( windowTitle ) < 0)
      {
      NotOpened( 1 );

      return;
      }
      
   if ((lvm = Guarded_AllocLV( lines, TXTLENGTH )) == NULL)
      {
      ReportAllocLVError(); // In CommonFuncs.o

      return;
      }

   HideListFromView( IOGadgets[ 0 ], IOWnd );

   SetupList( &SIList, lvm ); // In CommonFuncs.o

   MakeStrings( bytes, lvm->lvm_NodeStrs, NumLines );

   GT_SetGadgetAttrs( IOGadgets[ SIGad ], IOWnd, NULL,
                      GTLV_Labels,       &SIList,
                      GTLV_ShowSelected, NULL,
                      GTLV_Selected,     0,
                      TAG_DONE
                    );
   
   (void) HandleIOIDCMP();
   
   CloseIOWindow();

   Guarded_FreeLV( lvm );          // In CommonFuncs.o

   ScreenToFront( Scr );

   (void) ActivateWindow( ATWnd ); // Get ready for next command.

   return;
}

/****i* GetString() [2.1] ***********************************************
*
* NAME
*    GetString()
*
* DESCRIPTION
*    ^ <primitive 186 0 msg title>
*************************************************************************
*
*/

PRIVATE char userStr[80] = { 0, }; // MSG_IO_ENTER_STRING;

METHODFUNC OBJECT *GetString( char *msg, char *title )
{
   OBJECT *rval   = o_nil;
   int     len1   = 50 * FontXDim( Font );
   int     len2   = StringLength( msg   ) * FontXDim( Font );
   int     len3   = StringLength( title ) * FontXDim( Font );
   int     lconst = Scr->WBorLeft + Scr->WBorRight + 6;
   int     chk    = FALSE;

   
   StringNCopy( userStr, IOCMsg( MSG_IO_ENTER_STRING_IO ), 80 );

   IOGTypes[SIGad] = STRING_KIND;
      
   if ((len1 > len2) && (len1 > len3))
      IOWidth = len1 + lconst;
   else if ((len2 > len1) && (len2 > len3))
      IOWidth = len2 + lconst;
   else if ((len3 > len1) && (len3 > len2))
      IOWidth = len3 + lconst;
   else
      IOWidth = 80 * FontXDim( Font );
      
   if (IOWidth > Scr->Width)
      {
      IOWidth = Scr->Width;
      }   

   IONGad[SIGad].ng_GadgetText = msg;
   IONGad[SIGad].ng_Width      = IOWidth - lconst;
   IONGad[SIGad].ng_LeftEdge   = Scr->WBorLeft + 2;
   IONGad[SIGad].ng_TopEdge    = 17;
   IONGad[SIGad].ng_Height     = BUTT_HEIGHT;

   IONGad[DoneBt].ng_Height   = BUTT_HEIGHT;
   
   IOHeight = IONGad[SIGad].ng_TopEdge + IONGad[SIGad].ng_Height 
                                       + IONGad[DoneBt].ng_Height
                                       + 6;

   IOTop    = (Scr->Height - IOHeight) / 2; // Center the Requester:
   IOLeft   = (Scr->Width  - IOWidth ) / 2;

   IONGad[DoneBt].ng_LeftEdge = Scr->WBorLeft + 3; 
   IONGad[DoneBt].ng_Width    = BUTT_WIDTH;
   IONGad[DoneBt].ng_TopEdge  = IOHeight - IONGad[DoneBt].ng_Height - 2;

   IONGad[CancelBt].ng_Width    = BUTT_WIDTH;
   IONGad[CancelBt].ng_Height   = BUTT_HEIGHT;
   IONGad[CancelBt].ng_TopEdge  = IOHeight - IONGad[CancelBt].ng_Height -2;
   IONGad[CancelBt].ng_LeftEdge = IOWidth - Scr->WBorLeft 
                                          - 3 
                                          - IONGad[CancelBt].ng_Width;
   
   IOGTags[0]  = GTST_String;
   IOGTags[1]  = (ULONG) &userStr[0];
   IOGTags[2]  = GTST_MaxChars;
   IOGTags[3]  = 512;
   IOGTags[4]  = TAG_DONE;
   IOGTags[5]  = GT_Underscore;
   IOGTags[6]  = UNDERSCORE_CHAR;
   IOGTags[7]  = TAG_DONE;
   IOGTags[8]  = GT_Underscore;
   IOGTags[9]  = UNDERSCORE_CHAR;
   IOGTags[10] = TAG_DONE;

   IO_CNT = 3; // Need Cancel Gadget also!
   
   if (OpenIOWindow( title ) < 0)
      {
      NotOpened( 1 );

      return( rval );
      }
      
   chk = HandleIOIDCMP();

   if (chk == GOTAVALUE)
      {
      if (StringLength( StrBfPtr( IOGadgets[ SIGad ] ) ) > 0)
         {
         if (StringComp( StrBfPtr( IOGadgets[ SIGad ] ), IOCMsg( MSG_IO_ENTER_STRING_IO ) ) != 0)
            {
            rval = AssignObj( new_str( StrBfPtr( IOGadgets[ SIGad ] ) ) );
            }
         }
      }
   // else we're going to return o_nil:

   CloseIOWindow();
       
   return( rval );
}

/****i* GetInteger() [2.1] **********************************************
*
* NAME
*    GetInteger()
*
* DESCRIPTION
*    ^ <primitive 186 1 msg title>
*************************************************************************
*
*/

PRIVATE int userInt = 0;
      
METHODFUNC OBJECT *GetInteger( char *msg, char *title )
{ 
   OBJECT *rval   = o_nil;
   int     len1   = 10 * FontXDim( Font );
   int     len2   = StringLength( msg   ) * FontXDim( Font );
   int     len3   = StringLength( title ) * FontXDim( Font );
   int     lconst = Scr->WBorLeft + Scr->WBorRight + 6;
   int     chk    = FALSE;


   IOGTypes[SIGad] = INTEGER_KIND;

   if ((len1 > len2) && (len1 > len3))
      IOWidth = len1 + lconst;
   else if ((len2 > len1) && (len2 > len3))
      IOWidth = len2 + lconst;
   else if ((len3 > len1) && (len3 > len2))
      IOWidth = len3 + lconst;
   else
      IOWidth = 80 * FontXDim( Font );
      
   if (IOWidth > Scr->Width)
      {
      IOWidth = Scr->Width;
      }   

   IONGad[SIGad].ng_GadgetText = msg;
   IONGad[SIGad].ng_Width      = IOWidth - lconst;
   IONGad[SIGad].ng_LeftEdge   = Scr->WBorLeft + 2;
   IONGad[SIGad].ng_TopEdge    = 17;
   IONGad[SIGad].ng_Height     = BUTT_HEIGHT;

   IONGad[DoneBt].ng_Width    = BUTT_WIDTH;
   IONGad[DoneBt].ng_Height   = BUTT_HEIGHT;
   IONGad[DoneBt].ng_LeftEdge = Scr->WBorLeft + 3; 
   IONGad[DoneBt].ng_TopEdge  = IOHeight - IONGad[DoneBt].ng_Height - 2;
   
   IOHeight = IONGad[SIGad].ng_TopEdge + IONGad[SIGad].ng_Height 
                                       + IONGad[DoneBt].ng_Height
                                       + 6;

   IOTop    = (Scr->Height - IOHeight) / 2; // Center the Requester:
   IOLeft   = (Scr->Width  - IOWidth ) / 2;

   IONGad[CancelBt].ng_Width    = BUTT_WIDTH;
   IONGad[CancelBt].ng_Height   = BUTT_HEIGHT;
   IONGad[CancelBt].ng_TopEdge  = IOHeight - IONGad[DoneBt].ng_Height - 2;
   IONGad[CancelBt].ng_LeftEdge = IOWidth - Scr->WBorLeft 
                                          - 3 
                                          - IONGad[CancelBt].ng_Width;
   
   IOGTags[0] = GTIN_Number;
   IOGTags[1] = (ULONG) userInt;
   IOGTags[2] = TAG_DONE;
   IOGTags[3] = GT_Underscore;
   IOGTags[4] = UNDERSCORE_CHAR;
   IOGTags[5] = TAG_DONE;
   IOGTags[6] = GT_Underscore;
   IOGTags[7] = UNDERSCORE_CHAR;
   IOGTags[8] = TAG_DONE;

   IO_CNT = 3; // Need Cancel Gadget also!

   if (OpenIOWindow( title ) < 0)
      {
      NotOpened( 1 );

      return( rval );
      }
      
   chk = HandleIOIDCMP();
   
   if (chk == GOTAVALUE)
      {
      rval = AssignObj( new_int( IntBfPtr( IOGadgets[ SIGad ] ) ) );
      }
   // else we're going to return o_nil:  

   CloseIOWindow();

   return( rval );       
}


/****i* AmigaTalk/DispayFile() [2.1] *********************************
*
* NAME
*    DisplayFile()
* 
* DESCRIPTION
*    Display the named file using the FileDisplayer ToolType program.
*    <primitive 186 2 filename>
**********************************************************************
*
*/      

METHODFUNC void DisplayFile( char *fname )
{
   IMPORT char *FileDisplayer; // ToolType.
   
   char command[512] = { 0, };
   
   sprintf( &command[0], "%s %s", FileDisplayer, fname );
   
   (void) System( &command[0], TAG_DONE );
   
   return; 
}

/****i* DisplayString() [2.1] *******************************************
*
* NAME
*    DisplayString()
*
* DESCRIPTION
*    <primitive 186 3 string msg title>
*************************************************************************
*
*/

METHODFUNC void DisplayString( char *string, char *msg, char *title )
{
   int len1     = StringLength( string ) * FontXDim( Font );
   int len2     = StringLength( msg    ) * FontXDim( Font );
   int strspace = Scr->Width - Scr->WBorLeft - Scr->WBorRight;

   IO_CNT = 2; // Don't need a Cancel button also!

   IONGad[SIGad].ng_GadgetText = msg;

   if (len1 > strspace)
      {
      // Use a ListView gadget instead of a Text Gadget:
      DisplayText( string, msg, title );
      }
   else
      {   
      if (len1 > len2)
         IOWidth = len1 + 20;
      else
         IOWidth = len2 + 20;

      if (IOWidth > Scr->Width)
         IOWidth = Scr->Width;

      IOGTypes[SIGad] = TEXT_KIND;

      IOGTags[0] = GTTX_Text;
      IOGTags[1] = (ULONG) &string[0];
      IOGTags[2] = GTTX_Border;
      IOGTags[3] = TRUE;
      IOGTags[4] = GTTX_Justification;  
      IOGTags[5] = GTJ_CENTER;
      IOGTags[6] = TAG_DONE;
      IOGTags[7] = GT_Underscore;
      IOGTags[8] = UNDERSCORE_CHAR;
      IOGTags[9] = TAG_DONE;

      IOLeft  = (Scr->Width  - IOWidth)  / 2; // Center the Requester.
      IOTop   = (Scr->Height - IOHeight) / 2;

      IONGad[SIGad].ng_Width    = IOWidth - 10;
      IONGad[SIGad].ng_Height   = BUTT_HEIGHT;
      IONGad[SIGad].ng_LeftEdge = (IOWidth - IONGad[SIGad].ng_Width) / 2;
      IONGad[SIGad].ng_TopEdge  = 17;

      IONGad[DoneBt].ng_Width    = BUTT_WIDTH;
      IONGad[DoneBt].ng_Height   = BUTT_HEIGHT;
   
      IOHeight = IONGad[SIGad].ng_TopEdge + IONGad[SIGad].ng_Height 
                                          + IONGad[DoneBt].ng_Height
                                          + 6;

      IONGad[DoneBt].ng_TopEdge  = IOHeight - IONGad[DoneBt].ng_Height - 2;
      IONGad[DoneBt].ng_LeftEdge = (IOWidth - IONGad[DoneBt].ng_Width) / 2;

      if (OpenIOWindow( title ) < 0)
         {
         NotOpened( 1 );

         return;
         }
      
      (void) HandleIOIDCMP();

      CloseIOWindow();
      }

   return;
}

/****i* DisplayInteger() [2.1] ******************************************
*
* NAME
*    DisplayInteger()
*
* DESCRIPTION
*    <primtivie 186 4 integer msg title>
*************************************************************************
*
*/

METHODFUNC void DisplayInteger( int i, char *msg, char *title )
{
   int len2 = StringLength( title ) * FontXDim( Font );
   int len1 = StringLength( msg   ) * FontXDim( Font );
   
   if (len1 > len2)
      IOWidth = len1 + 20;   
   else
      IOWidth = len2 + 20;

   if (IOWidth > Scr->Width)
      IOWidth = Scr->Width;
      
   IONGad[SIGad].ng_GadgetText = msg;
   IONGad[SIGad].ng_Width      = 70; // IOWidth - 10;
   IONGad[SIGad].ng_TopEdge    = 17;   
   IONGad[SIGad].ng_LeftEdge   = (IOWidth - IONGad[SIGad].ng_Width) / 2;
   IONGad[SIGad].ng_Height     = BUTT_HEIGHT;
   
   IONGad[DoneBt].ng_Height   = BUTT_HEIGHT;
   
   IOHeight = IONGad[SIGad].ng_TopEdge + IONGad[SIGad].ng_Height 
                                       + IONGad[DoneBt].ng_Height
                                       + 6;

   IOTop    = (Scr->Height - IOHeight) / 2; // Center the Requester:
   IOLeft   = (Scr->Width  - IOWidth ) / 2;

   IONGad[DoneBt].ng_Width    = BUTT_WIDTH;
   IONGad[DoneBt].ng_LeftEdge = (IOWidth - IONGad[DoneBt].ng_Width) / 2;
   IONGad[DoneBt].ng_TopEdge  = IOHeight - IONGad[DoneBt].ng_Height - 2;

   IOGTypes[SIGad] = NUMBER_KIND;

   IOGTags[0] = GTNM_Number;
   IOGTags[1] = (ULONG) i;
   IOGTags[2] = GTNM_Border;
   IOGTags[3] = TRUE;
   IOGTags[4] = GTNM_Justification;
   IOGTags[5] = GTJ_CENTER;
   IOGTags[6] = TAG_DONE;
   IOGTags[7] = GT_Underscore;
   IOGTags[8] = UNDERSCORE_CHAR;
   IOGTags[9] = TAG_DONE;

   IO_CNT     = 2; // Don't need a Cancel button also!

   if (OpenIOWindow( title ) < 0)
      {
      NotOpened( 1 );

      return;
      }
      
   (void) HandleIOIDCMP();

   CloseIOWindow();

   return;
}

/****i* GetFileName() [2.1] *********************************************
*
* NAME
*    GetFileName()
*
* DESCRIPTION
*    ^ <primitive 186 5 dir title>
*************************************************************************
*
*/

METHODFUNC OBJECT *GetFileName( char *dir, char *title )
{
   IMPORT struct TagItem LoadTags[];
   
   OBJECT *rval = o_nil;
   char    filename[512] = { 0, };
   
   SetTagItem( &LoadTags[0], ASLFR_Window, (ULONG) IOWnd );

   if (StringLength( dir ) > 0)
      SetTagItem( &LoadTags[0], ASLFR_InitialDrawer, (ULONG) dir );
   else
      SetTagItem( &LoadTags[0], ASLFR_InitialDrawer, (ULONG) "RAM:" );
   
   if (StringLength( title ) > 0)
      SetTagItem( &LoadTags[0], ASLFR_TitleText, (ULONG) title );
   else
      SetTagItem( &LoadTags[0], ASLFR_TitleText, (ULONG) IOCMsg( MSG_IO_GET_A_FILE_IO ) );
          
   if (FileReq( &filename[0], &LoadTags[0] ) > 0)
      rval = AssignObj( new_str( &filename[0] ) );
               
   return( rval );
}

// For GetScreenModeID(): -----------------------------------------------

PRIVATE struct TagItem smrtags[] = {

  ASLSM_TitleText,            0L,
  ASLSM_InitialLeftEdge,      100,
  ASLSM_InitialTopEdge,       16,
  ASLSM_InitialWidth,         400,
  ASLSM_InitialHeight,        400,
  ASLSM_Screen,               0L,
  ASLSM_DoWidth,              TRUE,
  ASLSM_DoHeight,             TRUE,
  ASLSM_DoDepth,              TRUE,
  ASLSM_DoOverscanType,       FALSE,
  ASLSM_DoAutoScroll,         FALSE,
  ASLSM_MinWidth,             200,
  ASLSM_MinHeight,            200,
  ASLSM_MinDepth,             4,
  ASLSM_MaxDepth,             24,
  ASLSM_InitialDisplayWidth,  200,
  ASLSM_InitialDisplayHeight, 400,
  ASLSM_InitialDisplayDepth,  4,
  TAG_DONE
};

/****i* GetScreenModeID() [2.1] *****************************************
*
* NAME
*    GetScreenModeID()
*
* DESCRIPTION
*    ^ <primitive 186 6 scrName title>
*************************************************************************
*
*/

METHODFUNC OBJECT *GetScreenModeID( char *scrName, char *title )
{
   IMPORT struct Screen *Scr; // AmigaTalk main screen pointer.
   
   struct Screen *sptr = FindScreenPtr( scrName );
   ULONG          mode = 0; // NULL;
   OBJECT        *rval = o_nil;

   SetTagItem( smrtags, ASLSM_TitleText, (ULONG) IOCMsg( MSG_IO_SELECT_SCRNMODE_IO ) );

   if (!sptr) // == NULL)
      {
      // scrName does not exist, so use the AmigaTalk Scr instead.
      mode = getScreenModeID( &smrtags[0], Scr, title ); // CommonFuncs.o

      rval = AssignObj( new_int( mode ) );
      
      return( rval );
      } 
   else
      {
      mode = getScreenModeID( &smrtags[0], sptr, title ); // CommonFuncs.o

      rval = AssignObj( new_int( mode ) ); // mode == 0 is valid.
      
      return( rval );
      }
}

/****i* getActiveScreen() [2.1] **********************************************
*
* NAME
*    getActiveScreen()
*
* DESCRIPTION
*    Use the GetActiveScreen() in CommonFuncs.o to obtain a pointer to the
*    currently active screen.
*    ^ <primitive 186 7>
******************************************************************************
*
*/

// OBJECT *rval = new_obj( lookup_class( "Screen" ), 3, FALSE );

METHODFUNC OBJECT *getActiveScreen( void )
{
   struct Screen *sptr     = (struct Screen *) NULL;
   CLASS         *scrClass = lookup_class( "Screen" ); // SCREEN_NAME );
   OBJECT        *rval     = new_inst( scrClass );
   int            i        = objSize( rval ) - 1;

   while (i >= 0)
      {
      // new_inst() initializes inst_var[]s to o_nil, so undo it:
      (void) obj_dec( rval->inst_var[i] );
         
      i--;
      }
   
   if (IntuitionBase) // != NULL)
      sptr = GetActiveScreen(); // There's always at least one screen!
   else
      {
      (void) obj_dec( rval ); // Throw rval away, we are dead!
      
      (void) NullFound( "getActiveScreen( IntuitionBase == NULL! )" );

      return( o_nil );
      }
         
   rval->inst_var[0] = AssignObj( new_address( (ULONG) sptr ) );  // private
   rval->inst_var[1] = AssignObj( new_str( sptr->Title ) ); // savedTitle
   rval->inst_var[2] = AssignObj( new_int( (int) GetVPModeID( &(sptr->ViewPort) )));
   
   return( rval );
}

/****i* getActiveWindow() [2.1] **********************************************
*
* NAME
*    getActiveWindow()
*
* DESCRIPTION
*    Use the GetActiveWindow() in CommonFuncs.o to obtain a pointer to the
*    currently active window.
*    ^ <primitive 186 8>
******************************************************************************
*
*/

METHODFUNC OBJECT *getActiveWindow( void )
{
   struct Window *wptr     = (struct Window *) NULL;
   OBJECT        *rval     = (OBJECT *) NULL;
   CLASS         *winClass = lookup_class( "Window" ); // WINDOW_NAME );
   int            i;
      
   if (IntuitionBase) // != NULL)
      wptr = GetActiveWindow();
   else
      {
      (void) NullFound( "getActiveWindow( IntuitionBase == NULL! )" );

      return( o_nil );
      }
   
   if (!wptr) // == NULL)
      return( o_nil ); // No active window?  Where are all of them?

   rval = new_inst( winClass ); // new_obj( lookup_class( "Window" ), 3, FALSE );
   i    = objSize( rval ) - 1;

   while (i >= 0) 
      {
      // new_inst() initializes inst_var[]s to o_nil, so undo it:
      (void) obj_dec( rval->inst_var[i] );
      
      i--;
      }
        
   rval->inst_var[0] = AssignObj( new_address( (ULONG) wptr ) );          // private
   rval->inst_var[1] = AssignObj( new_str( wptr->Title ) );               // savedTitle
   rval->inst_var[2] = AssignObj( new_address( (ULONG) wptr->WScreen ) ); // parent

   return( rval );
}

/****i* addUserScript() [3.0] ************************************************
*
* NAME
*    addUserScript()
*
* DESCRIPTION
*    Add a User Script Menu Item to the main Command Window of AmigaTalk.
*    ^ <primitive 186 9 scriptMenuName scriptFilename>
******************************************************************************
*
*/

METHODFUNC OBJECT *addUserScript( char *scriptMenuName, char *scriptFileName )
{
   IMPORT int   ATAddUserScript( void ); // in ATMenus.c
   IMPORT char *MenuScriptName;
   IMPORT char *MenuScriptFileName;
   
   OBJECT *rval = o_false;

   StringNCopy( MenuScriptName,     scriptMenuName, 80  );
   StringNCopy( MenuScriptFileName, scriptFileName, 256 );   

   if (ATAddUserScript() == TRUE)
      rval = o_true;
      
   return( rval );
}

/****i* removeUserScript() [3.0] *********************************************
*
* NAME
*    removeUserScript()
*
* DESCRIPTION
*    Remove a User Script Menu Item from the main Command Window of AmigaTalk.
*    <primitive 186 10 scriptMenuName>
******************************************************************************
*
*/

METHODFUNC void removeUserScript( char *scriptMenuName )
{
   IMPORT int   ATRemoveUserScript( void ); // in ATMenus.c
   IMPORT char *MenuScriptName;
   
   StringNCopy( MenuScriptName, scriptMenuName, 80 );

   (void) ATRemoveUserScript();
   
   return;
}

/****i* searchState() [3.0] **************************************************
*
* NAME
*    searchState()
*
* DESCRIPTION
*    Return the status of the started flag.
*    <primitive 186 11>
*
* SEE ALSO
*    setSearchState()    
******************************************************************************
*
*/

METHODFUNC OBJECT *searchState( void )
{
   IMPORT int started;
   
   OBJECT *rval = o_false;
   
   if (started == TRUE)
      rval = o_true;
   else
      rval = o_false;
      
   return( rval );
}

/****i* setSearchState() [3.0] ***********************************************
*
* NAME
*    setSearchState()
*
* DESCRIPTION
*    Set/Clear the started flag, which controls searching for free Objects
*    in the Object lists.
*    <primitive 186 12 state (1 = TRUE, 0 = FALSE)>
*
* SEE ALSO
*    searchState()    
******************************************************************************
*
*/

METHODFUNC void setSearchState( int newState )
{      
   IMPORT int started;
   
   if (newState == 0)
      started = FALSE;
   else
      started = TRUE;
      
   return;
}
        
/****h* HandleIO() [3.0] ***********************************************
*
* NAME
*    HandleIO()
*
* DESCRIPTION
*    The function that the Primitive handler calls for IO(186) stuff.
************************************************************************
*
*/

PUBLIC OBJECT *HandleIO( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;

   if (!(IOFont = OpenDiskFont( Font ))) // == NULL)
      {
      NotOpened( 7 );

      return( rval );
      }
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 186 );

      CloseIOWindow(); // Just closes the IOFont.
      return( rval );
      }

   switch (int_value( args[0] ))
      {
      case 0: // char *GetString( char *msg, char *title );
         if (is_string( args[1] ) == FALSE || is_string( args[2] ) == FALSE)
            (void) PrintArgTypeError( 186 );
         else
            rval = GetString( string_value( (STRING *) args[1] ),
                              string_value( (STRING *) args[2] ) 
                            );
         break;
      
      case 1: // int GetInteger( char *msg, char *title );
         if (is_string( args[1] ) == FALSE || is_string( args[2] ) == FALSE)
            (void) PrintArgTypeError( 186 );
         else
            rval = GetInteger( string_value( (STRING *) args[1] ),
                               string_value( (STRING *) args[2] )
                             );
         break;

      case 2: // DisplayFile( char *fname );
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 186 );
         else
            DisplayFile( string_value( (STRING *) args[1] ) );
         break;
      
      case 3: // DisplayString( char *string, char *msg, char *title );
         if ( !is_string( args[1] ) || !is_string( args[2] )
                                    || !is_string( args[3] ))
            (void) PrintArgTypeError( 186 );
         else
            DisplayString( string_value( (STRING *) args[1] ),
                           string_value( (STRING *) args[2] ), 
                           string_value( (STRING *) args[3] ) 
                         );
         break;

      case 4: // DisplayInteger( int i, char *msg, char *title );
         if (!is_integer( args[1] ) || (is_string( args[2] ) == FALSE)
                                    || (is_string( args[3] ) == FALSE))
            (void) PrintArgTypeError( 186 );
         else
            DisplayInteger( int_value( args[1] ),
                            string_value( (STRING *) args[2] ),
                            string_value( (STRING *) args[3] ) 
                          );
         break;

      case 5: // char *GetFileName( char *dir, char *title );
         if (is_string( args[1] ) == FALSE || is_string( args[2] ) == FALSE)
            (void) PrintArgTypeError( 186 );
         else
            rval = GetFileName( string_value( (STRING *) args[1] ),
                                string_value( (STRING *) args[2] )
                              );
         break;

      case 6: // ULONG GetScreenModeID( char *msg, char *title );
         if (is_string( args[1] ) == FALSE || is_string( args[2] ) == FALSE)
            (void) PrintArgTypeError( 186 );
         else
            rval = GetScreenModeID( string_value( (STRING *) args[1] ),
                                    string_value( (STRING *) args[2] )
                                  );
         break;

      case 7: // activeScreen  ^ <primitive 186 7>
         rval = getActiveScreen();
         break;
         
      case 8: // activeWindow  ^ <primitive 186 8>
         rval = getActiveWindow();
         break;

      case 9: // ^ addUserScript: scriptMenuName toCall: scripFileName
         if (is_string( args[1] ) == FALSE || is_string( args[2] ) == FALSE)
            (void) PrintArgTypeError( 186 );
         else
            rval = addUserScript( string_value( (STRING *) args[1] ),
                                  string_value( (STRING *) args[2] ) 
                                );
         break;
                  
      case 10: // removeUserScript: scriptMenuName
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 186 );
         else
            removeUserScript( string_value( (STRING *) args[1] ) );
   
         break;
                  
      case 11: // searchState  ^ <primitive 186 11>
         rval = searchState( );
         break;
      
      case 12: // turnOff/OnSearch [true = 1 or false = 0]
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 186 );
         else
            setSearchState( int_value( args[1] ) );
         break;
                              
      default:
         (void) PrintArgTypeError( 186 );
         break;
      }

   return( rval );
}

/* -------------------- END of IO.c file! ---------------------------- */
