/****h* AmigaTalk/Icon.c [3.0] *****************************************
*
* NAME
*    Icon.c
*
* DESCRIPTION 
*    This file contains the code to view/modify Amiga icons.
*
* FUNCTIONAL INTERFACE:
*
*    PUBLIC OBJECT *HandleIcons( int numargs, OBJECT **args ); // 219
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    07-Jan-2003 - Moved all string constants to StringConstants.h
*
*    14-Mar-2002 - Added all of the missing icon.library functions.
*
*    03-Dec-2001 - Removed NullCheck() function & replaced it with 
*                  NullChk(), which is in Global.c
*
* NOTES
*    $VER: AmigaTalk:Src/Icon.c 3.0 (25-Oct-2004) by J.T. Steichen
************************************************************************
*
*/

#include <stdio.h>
#include <string.h>

#include <AmigaDOSErrs.h>

#include <exec/types.h>
#include <exec/io.h>
#include <exec/memory.h>

#include <workbench/workbench.h>
#include <workbench/startup.h>
#include <workbench/icon.h>

#include <libraries/asl.h>
#include <libraries/gadtools.h>
#include <utility/tagitem.h>

#ifdef __SASC

# include <clib/exec_protos.h>
# include <clib/gadtools_protos.h>
# include <clib/alib_protos.h>
# include <clib/dos_protos.h>
# include <clib/intuition_protos.h>
# include <clib/icon_protos.h>

#define  FASTMEM  MEMF_CLEAR | MEMF_FAST | MEMF_PUBLIC

#else

# define __USE_INLINE__

# include <proto/dos.h>
# include <proto/exec.h>
# include <proto/intuition.h>
# include <proto/icon.h>
# include <proto/gadtools.h>

#define  FASTMEM  MEMF_CLEAR | MEMF_FAST | MEMF_SHARED

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "Constants.h"
#include "Object.h"

#include "ATStructs.h"
#include "FuncProtos.h"

#include "StringConstants.h"
#include "StringIndexes.h"

#define DISKOBJ  inst_var[0]
#define DISKNAME inst_var[1]

typedef struct DiskObject *DOPTR;

// ---------------------------------------------------------------------

IMPORT OBJECT *PrintArgTypeError( int primnumber );

IMPORT struct Library  *IconBase;
IMPORT struct Screen   *Scr;        // from main.c
IMPORT struct Window   *ATWnd;
IMPORT struct TextAttr *Font;
IMPORT struct CompFont  CFont;
IMPORT APTR             VisualInfo;
IMPORT struct TagItem   LoadTags[];

IMPORT OBJECT         *o_nil; 

IMPORT UBYTE          *ToolEditor; // AmigaTalk:c/ToolTypesEditor
IMPORT UBYTE          *AllocProblem;
IMPORT UBYTE          *UserProblem;
IMPORT UBYTE          *ATalkProblem;
IMPORT UBYTE          *SystemProblem;
IMPORT UBYTE          *DefaultButtons;
IMPORT UBYTE          *ErrMsg;

// ---------------------------------------------------------------------

// PRIVATE struct Library *LayersBase;

/****i* StringToUpper() [1.0] ****************************************
*
* NAME
*    StringToUpper()
*
* DESCRIPTION
*    Convert a string to upper case letters.
**********************************************************************
*
*/

SUBFUNC void StringToUpper( char *dest, char *src )
{
   int index = 0;

   while (*(src + index) != NIL_CHAR)   
      {
      *(dest + index) = toupper( *(src + index) );

      index++;
      }

   *(dest + index) = *(src + index);   /* copy '\0' */

   return;
}

SUBFUNC int str_right_index( char *string, char *substring )
{
   register int   i, j, k;
   int            right_loc = -1;
   
   for (i = 0; *(string + i) != 0; i++)
      for (j = i, k = 0; *(substring + k) == *(string + j); k++, j++)
         if (!*(substring + k + 1)) // == NULL)
            {
            right_loc = i;

            break;
            }
            
   return( right_loc );
}

/* Strip '.info' from an icon file name: */

SUBFUNC void CleanFileName( char *iconname )
{
   register int   loc = 0;
   char           NIL[256], *upr = &NIL[0];
    
   StringToUpper( upr, iconname );

   loc = str_right_index( upr, ".INFO" ); // IconCMsg( MSG_IC_EXTENSION_ICON ) );

   if (loc > 0)
      *(iconname + loc) = NIL_CHAR;

   return;
}

/****i* FindDiskObj() [1.8] ******************************************
*
* NAME
*    FindDiskObj()
*
* DESCRIPTION
*
**********************************************************************
*
*/

SUBFUNC struct DiskObject *FindDiskObj( OBJECT *iconObj )
{
   struct DiskObject *dobj = (struct DiskObject *) CheckObject( iconObj );
   
   return( dobj );
}


/****i* CloseIcon() [1.8] ********************************************
*
* NAME
*    CloseIcon()
*
* DESCRIPTION
*    Write an Icon object to the file system & free resources.
*    ^ <219 0 private iconName>
**********************************************************************
*
*/

METHODFUNC OBJECT *CloseIcon( OBJECT *iconobj, char *iconName )
{
   struct DiskObject *dobj = FindDiskObj( iconobj );
   OBJECT            *rval = o_nil;
   
   if (dobj) // != NULL)
      {
      if (StringLength( iconName ) < 1)
         {
         if (PutDiskObject( IconCMsg( MSG_IC_UNKNOWNICON_ICON ), dobj ) == FALSE)
            {
            rval = AssignObj( new_int( IoErr() ));
            }
         }
      else
         {
         if (PutDiskObject( iconName, dobj ) == FALSE)
            {
            rval = AssignObj( new_int( IoErr() ));
            }
         }
      
      FreeDiskObject( dobj );
      }

   return( rval );
}

/****i* SetupIcon() [1.8] ********************************************
*
* NAME
*    SetupIcon()
*
* DESCRIPTION
*    Allocate resources, & get the Icon from the file system.
**********************************************************************
*
*/

SUBFUNC int SetupIcon( char *iconName )
{
   struct DiskObject *dobj = (struct DiskObject *) NULL;
   
   CleanFileName( iconName ); // Cut off the '.info' file extension.

   dobj = GetDiskObject( iconName );

   if (!dobj) // == NULL)
      {
      return( -1 );
      }
   else
      {
      return( 0 );
      }
}

/****i* OpenIcon() [1.8] *********************************************
*
* NAME
*    OpenIcon()
*
* DESCRIPTION
*    private <- <primitive 219 1 iconName>
**********************************************************************
*
*/

METHODFUNC OBJECT *OpenIcon( char *iconName )
{
   struct DiskObject *dobj = (struct DiskObject *) NULL;
   OBJECT            *rval = o_nil;

   UBYTE         nicon[512] = { 0, };
   int           chk = 0;
      
   if ((chk = SetupIcon( iconName )) < 0)
      {
      // Flag the bad iconName & get the user to supply a good one:
      int ans = -1;
            
      sprintf( ErrMsg, IconCMsg( MSG_FMT_IC_NOTFOUND_ICON ), iconName );
      
      SetReqButtons( IconCMsg( MSG_IC_YES_ABORT_BUTTONS_ICON ) );
      ans = Handle_Problem( ErrMsg, UserProblem, NULL );
      SetReqButtons( DefaultButtons );
      
      if (ans == 0)
         {
         int chk = 0;
         
         SetTagItem( LoadTags, ASLFR_Window, (LONG) ATWnd );
         SetTagItem( LoadTags, ASLFR_Screen, (LONG) Scr );
         SetTagItem( LoadTags, ASLFR_Flags2, 0 );
         
         if ((chk = FileReq( nicon, LoadTags )) < 1)
            {
            // User pressed cancel button:
            SetTagItem( LoadTags, ASLFR_Flags2, FRF_REJECTICONS );
   
            return( rval );
            }
         
         SetTagItem( LoadTags, ASLFR_Flags2, FRF_REJECTICONS );

         if ((chk = SetupIcon( nicon )) == 0)
            {
            dobj = GetDiskObject( nicon );

            return( AssignObj( new_address( (ULONG) dobj ))); // Weesa okey-dokey!
            }
         else if (chk > 0)
            {
            // What a bonehead!!
            return( rval );
            }
         }
      else // User pressed ABORT!
         {
         return( rval );
         }
      }
   else // SetupIcon() was okay.
      {
      dobj = GetDiskObject( iconName );
      
      return( AssignObj( new_address( (ULONG) dobj ))); // Weesa okey-dokey!
      }
}

/****i* EditToolTypes() [1.8] ****************************************
*
* NAME
*    EditToolTypes()
*
* DESCRIPTION
*    The user wishes to use my ToolTypesEditor program on an Icon.
*    Boolean <- <primitive 219 2 iconName>
**********************************************************************
*
*/

METHODFUNC OBJECT *EditToolTypes( char *iconName )
{
   OBJECT *rval = o_true;
   char    cmd[512] = { 0, };
   
   sprintf( cmd, "%s %s.info", ToolEditor, iconName );

   if (System( cmd, TAG_DONE ) < 0)
      {
      CheckToolType( IconCMsg( MSG_TT_TTEDITOR_ICON ) );

      rval = o_false;
      }
   
   return( rval );
}

/****i* DisplayIconInfo() [1.8] **************************************
*
* NAME
*    DisplayIconInfo()
*
* DESCRIPTION
*    Display the system information contained in an Icon.
*    <primitive 219 3 iconObject iconName>
**********************************************************************
*
*/

METHODFUNC OBJECT *DisplayIconInfo( OBJECT *iconobj, char *iconName )
{
   IMPORT int IconInfoDisplay( DOPTR diskobject, char *iconName );

   struct DiskObject *dobj = FindDiskObj( iconobj );
   OBJECT            *rval = o_nil;
   int                chk  = 0;
   
   if (dobj) // != NULL)
      {
      chk  = IconInfoDisplay( dobj, iconName );

      if (chk != 0)
         rval = new_int( chk );
      }
   else
      rval = o_false;
        
   return( rval );
}

// IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII

PRIVATE struct Window       *IpWnd   = NULL;
PRIVATE struct Gadget       *IpGList = NULL;
PRIVATE struct Gadget       *IpGadget;
PRIVATE struct IntuiMessage  IpMsg;

PRIVATE UWORD IpLeft    = 80; //(640 - 480) / 2;
PRIVATE UWORD IpTop     = 85; //(480 - 310) / 2;
PRIVATE UWORD IpWidth   = 480;
PRIVATE UWORD IpHeight  = 310;

PUBLIC  UBYTE IpWdt[80] = { 0, }; // IC_IP_WTITLE;

PUBLIC struct IntuiText IpIText[] = {

   2, 0, JAM1, 105, 12, NULL, NULL, NULL,
   2, 0, JAM1, 336, 12, NULL, NULL, NULL 
};

PRIVATE int tx1, tx2;

#define Ip_TNUM 2

PRIVATE UWORD IpGType = BUTTON_KIND;

PRIVATE int IpOkayBtClicked( void );

#define GWIDTH  70
#define GHEIGHT 17

PRIVATE int gx = 230, gy = 280;

PUBLIC struct NewGadget IpNGad = {

   194, 278, GWIDTH, GHEIGHT, NULL, NULL, 
   0, PLACETEXT_IN, NULL, (APTR) IpOkayBtClicked
};

PRIVATE ULONG IpGTags[] = { GT_Underscore, UNDERSCORE_CHAR, TAG_DONE };

// -----------------------------------------------------------------

PRIVATE void CloseIpWindow( void )
{
   if (IpWnd) // != NULL)
      {
      CloseWindow( IpWnd );
      IpWnd = NULL;
      }

   if (IpGList) // != NULL)
      {
      FreeGadgets( IpGList );
      IpGList = NULL;
      }

   return;
}

PRIVATE int IpOkayBtClicked( void )
{
   CloseIpWindow();
   return( FALSE );
}

PRIVATE int bx1 = 7, by = 24, bx2 = 233, bw = 240, bh = 245;

PRIVATE void IpRender( void )
{
   struct IntuiText it;

   ComputeFont( Scr, Font, &CFont, IpWidth, IpHeight );

   DrawBevelBox( IpWnd->RPort, 
                 bx1, 
                 CFont.OffY + ComputeY( CFont.FontY, 24 ) - 6, 
                 bw, bh, 
                 GT_VisualInfo, VisualInfo, 
                 GTBB_Recessed, TRUE, TAG_DONE 
               );

   DrawBevelBox( IpWnd->RPort, 
                 bx2, 
                 CFont.OffY + ComputeY( CFont.FontY, 24 ) - 6, 
                 bw, bh,
                 GT_VisualInfo, VisualInfo, 
                 GTBB_Recessed, TRUE, TAG_DONE 
               );

   it.ITextFont = Font;

   CopyMem( (char *) &IpIText[ 0 ], (char *) &it,
            (long) sizeof( struct IntuiText )
          );

   it.LeftEdge = tx1 + IpWnd->BorderLeft;

   it.TopEdge  = CFont.OffY + ComputeY( CFont.FontY, it.TopEdge ) 
                 - (Font->ta_YSize >> 1) - 5;
   
   PrintIText( IpWnd->RPort, &it, 0, 0 );

   CopyMem( (char *) &IpIText[ 1 ], (char *) &it,
            (long) sizeof( struct IntuiText )
          );

   it.LeftEdge = tx2 + IpWnd->BorderLeft;
   it.TopEdge  = CFont.OffY + ComputeY( CFont.FontY, it.TopEdge ) 
                 - (Font->ta_YSize >> 1) - 5;
   
   PrintIText( IpWnd->RPort, &it, 0, 0 );

   return;
}

PRIVATE int OpenIpWindow( int wx, int wy, int ww, int wh )
{
   struct NewGadget  ng;
   struct Gadget    *g;

   ComputeFont( Scr, Font, &CFont, IpWidth, IpHeight );

   if (!(g = CreateContext( &IpGList ))) // == NULL)
      return( -1 );

   CopyMem( (char *) &IpNGad, (char *) &ng,
            (long) sizeof( struct NewGadget )
          );

   ng.ng_VisualInfo = VisualInfo;
   ng.ng_TextAttr   = Font;
   ng.ng_LeftEdge   = gx;
   ng.ng_TopEdge    = gy + GHEIGHT;
   ng.ng_Width      = ComputeX( CFont.FontX, ng.ng_Width );
   ng.ng_Height     = ComputeY( CFont.FontY, ng.ng_Height);

   IpGadget = g 
            = CreateGadgetA( (ULONG) IpGType, g, 
                             &ng, (struct TagItem *) &IpGTags[0]
                           );

   if (!g) // == NULL)
      return( -2 );

   if (!(IpWnd = OpenWindowTags( NULL,

            WA_Left,     wx, //IpLeft,
            WA_Top,      wy, //IpTop,
            WA_Width,    ww + CFont.OffX + Scr->WBorRight,
            WA_Height,   wh + CFont.OffY + Scr->WBorBottom,

            WA_IDCMP,    BUTTONIDCMP | IDCMP_VANILLAKEY
              | IDCMP_REFRESHWINDOW,

            WA_Flags,    WFLG_DRAGBAR | WFLG_DEPTHGADGET
              | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,
            WA_Gadgets,  IpGList,
            WA_Title,    IpWdt,
            WA_PubScreen,   Scr,
            TAG_DONE )
      )) // == NULL)
      return( -4 );

   GT_RefreshWindow( IpWnd, NULL );

   IpRender();

   return( 0 );
}

PRIVATE int IpVanillaKey( int whichkey )
{
   int rval = TRUE;
   
   switch (whichkey)
      {
      case SMALL_O_CHAR:
      case CAP_O_CHAR:
         rval = IpOkayBtClicked();
         break;
      }
      
   return( rval );
}

PRIVATE int HandleIpIDCMP( void )
{
   struct IntuiMessage   *m;
   int                  (*func)( void );
   BOOL                   running = TRUE;

   while (running == TRUE)
      {
      if (!(m = GT_GetIMsg( IpWnd->UserPort ))) // == NULL) 
         {
         (void) Wait( 1L << IpWnd->UserPort->mp_SigBit );

         continue;
         }

      CopyMem( (char *) m, (char *) &IpMsg,
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (IpMsg.Class) 
         {
         case   IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( IpWnd );
              IpRender();
            GT_EndRefresh( IpWnd, TRUE );
            break;

         case   IDCMP_VANILLAKEY:
            running = IpVanillaKey( IpMsg.Code );
            break;

         case   IDCMP_GADGETUP:
            func = (int (*)( void )) ((struct Gadget *) IpMsg.IAddress)->UserData;
            
            if (func) // != NULL)
               running = func();
    
            break;
         }
      }

   return( running );
}

SUBFUNC int PrintIconImages( DOPTR diskObj, int x1, int x2, int y )
{
   struct Image *image = (struct Image *) diskObj->do_Gadget.GadgetRender;
   struct Image *altim = (struct Image *) diskObj->do_Gadget.SelectRender;
   
   struct Rectangle rect;
   
   LONG gotPalette     = FALSE;
   BOOL openedIconBase = FALSE;

   if (!IconBase) // == NULL)
      {
#     ifdef  __SASC
      if (!(IconBase = OpenLibrary( "icon.library", 39L )))
         {
         NotOpened( 4 );

         return( -2 );
         }
#     else
      if ((IconBase = OpenLibrary( "icon.library", 50L )))
         {
	 if (!(IIcon = (struct IconIFace *) GetInterface( IconBase, "main", 1, NULL )))
	    {
            CloseLibrary( IconBase );

            NotOpened( 4 );

            return( -2 );
	    }
	 else
	    openedIconBase = TRUE;
	 }
#     endif      
      else
         openedIconBase = TRUE;
      }

   IconControl( diskObj, ICONCTRLA_SetGlobalScreen, Scr,
                         ICONCTRLA_IsPaletteMapped, &gotPalette,
                         TAG_DONE
              );
   
   LayoutIconA( diskObj, Scr, NULL );

   GetIconRectangle( IpWnd->RPort, diskObj, NULL,
                     &rect, ICONDRAWA_Borderless, 
                     TAG_DONE 
                   );

   rect.MinX = (bw - rect.MaxX) / 2 + x1;
   rect.MinY = (bh - rect.MaxY) / 2 + y;

   if (gotPalette == FALSE)
      {
      DrawImage( IpWnd->RPort, image, rect.MinX, rect.MinY );

      rect.MinX = (bw - rect.MaxX) / 2 + x2;

      DrawImage( IpWnd->RPort, altim, rect.MinX, rect.MinY );
      }
   else
      {
      DrawIconState( IpWnd->RPort, diskObj, NULL,
                     rect.MinX, rect.MinY,
                     IDS_NORMAL, ICONDRAWA_Borderless, TRUE, 
                     ICONDRAWA_EraseBackground, TAG_DONE
                   );

      rect.MinX = (bw - rect.MaxX) / 2 + x2;

      DrawIconState( IpWnd->RPort, diskObj, NULL,
                     rect.MinX, rect.MinY, 
                     IDS_SELECTED, ICONDRAWA_Borderless, TRUE, 
                     ICONDRAWA_EraseBackground, TAG_DONE
                   );
      }

   if (openedIconBase == TRUE)
      {
#     ifdef __amigaos4__
      DropInterface( (struct Interface *) IIcon );
#     endif

      CloseLibrary( IconBase );
      } 
           
   return( 0 );
}

PRIVATE struct IntuiText wt = { 0, 0, JAM1, 0, 0, NULL, NULL, NULL };
    
SUBFUNC int ShowIconPix( DOPTR diskObj )
{
   struct Rectangle rect;
   
   int wx, wy, ww, wh, iw, ih;

   IconControl( diskObj, ICONCTRLA_SetGlobalScreen, Scr, TAG_DONE );
   LayoutIconA( diskObj, Scr, NULL );

   GetIconRectangle( IpWnd->RPort, diskObj, NULL,
                     &rect, ICONDRAWA_Borderless, 
                     TAG_DONE 
                   );

   iw = rect.MaxX; // Image width & height
   ih = rect.MaxY;

   ww = iw * 2 + 54; // 54 = 4 * bdr(=2) + 3 * spc(=10) + 2 * imgspc(=8).
   wh = ih + GHEIGHT + Font->ta_YSize + 32;

   if (ww < GWIDTH)
      ww = GWIDTH + 54;

   if (ww < (IntuiTextLength( &IpIText[0] ) 
            + IntuiTextLength( &IpIText[1] )))
      {
      ww = IntuiTextLength( &IpIText[0] ) + IntuiTextLength( &IpIText[1] )
           + 54;
      }

   if (ww < 240)
      ww = 240;

   if (ww < IntuiTextLength( &wt ))
      ww = IntuiTextLength( &wt ) + 80; // should be big enough now!
      
   // Center the display window:
   wx = (Scr->Width  - ww) / 2;      
   wy = (Scr->Height - wh) / 2;

   IpIText[0].ITextFont = Scr->Font;
   IpIText[1].ITextFont = Scr->Font;

   tx1 = (ww / 2 - IntuiTextLength( &IpIText[0] )) / 2;
   tx2 = (ww / 2 - IntuiTextLength( &IpIText[1] )) / 2 + ww / 2;

   // Set the Gadget coord's:
   gx = (ww - GWIDTH) / 2;
   gy = wh - GHEIGHT - 4;
   
   // BevelBox coordinates:

   bx1 = (ww / 2 - iw) / 2;

   bx2 = (ww / 2 - iw) / 2 + ww / 2;

   by  = Font->ta_YSize + 24;

   bw  = iw + 8; // four pixels on each side of the Image.

   bh  = ih + 8;
   
   if (OpenIpWindow( wx, wy, ww, wh ) < 0)
      {
      NotOpened( 1 );

      return( -1 );
      }

   (void) PrintIconImages( diskObj, bx1, bx2, by + 4 );
         
   (void) HandleIpIDCMP();

   return( 0 );
}

// IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII

/****i* DisplayIconImages() [1.8] ************************************
*
* NAME
*    DisplayIconImages()
*
* DESCRIPTION
*    <primitive 219 4 iconObject iconName>
**********************************************************************
*
*/

METHODFUNC void DisplayIconImages( OBJECT *iconobj, char *iconName )
{
   struct DiskObject *icon = FindDiskObj( iconobj );

   char  ttl[80] = { 0, };
   
   sprintf( ttl, "%s  %s", IpWdt, iconName );   
   StringCopy( IpWdt, ttl );
   
   wt.ITextFont = Scr->Font;
   wt.IText     = &IpWdt[0]; // For later comparision.
   
   if (icon) // != NULL)
      {
      // Now, display something:
      ShowIconPix( icon );
      }

   StringNCopy( IpWdt, IconCMsg( MSG_IC_IP_WTITLE_ICON ), 80 ); // Reset the title prefix.

   return;
}

/****i* SetIconPosition() [1.8] **************************************
*
* NAME
*    SetIconPosition()
*
* DESCRIPTION
*    Set the coordinates for an Icon.  <primitive 219 5 iconObject iconName x y>
**********************************************************************
*
*/

METHODFUNC OBJECT *SetIconPosition( OBJECT *iconobj, char *iconName, 
                                    int x, int y )
{
   struct DiskObject *icon = FindDiskObj( iconobj );
   OBJECT            *rval = o_nil;

   if (icon) // != NULL)
      {
      // probably should lock out any user mouse actions before this:
      icon->do_CurrentX        = x;
      icon->do_CurrentY        = y;
      icon->do_Gadget.TopEdge  = y; // is this correct??
      icon->do_Gadget.LeftEdge = x;
      // & then we should probably update the workbench screen!

      if (PutDiskObject( iconName, icon ) == 0)
         rval = AssignObj( new_int( IoErr() ) );
      }
   else
      rval = o_false;

   return( rval );
}

/****i* MoveIcon() [1.8] *********************************************
*
* NAME
*    MoveIcon()
*
* DESCRIPTION
*    Move an Icon by (dx, dy).  <primitive 219 6 iconObject iconName dx dy>
**********************************************************************
*
*/

METHODFUNC OBJECT *MoveIcon( OBJECT *iconobj, char *iconName,
                             int dx, int dy )
{
   struct DiskObject *icon = FindDiskObj( iconobj );
   OBJECT            *rval = o_nil;

   if (icon) // != NULL)
      {
      // probably should lock out any user mouse actions before this:
      icon->do_CurrentX        += dx;
      icon->do_CurrentY        += dy;
      icon->do_Gadget.TopEdge  += dy;
      icon->do_Gadget.LeftEdge += dx;
      // & then we should probably update the workbench screen!

      if (PutDiskObject( iconName, icon ) == 0)
         rval = AssignObj( new_int( IoErr() ) );
      }
   else
      rval = o_false;

   return( rval );
}

/****i* ExternalIconEditor() [1.8] ***********************************
*
* NAME
*    ExternalIconEditor()
*
* DESCRIPTION
*    User wishes to use an External Icon Editor on an Icon.
*    <primitive 219 7 iconName editorName>
**********************************************************************
*
*/

METHODFUNC OBJECT *ExternalIconEditor( char *iconName, char *edName )
{
   OBJECT *rval = o_true;
   char    cmd[512] = { 0, };

   sprintf( cmd, "%s %s.info", edName, iconName );
         
   if (System( cmd, TAG_DONE ) < 0)
      {
      CheckToolType( IconCMsg( MSG_TT_ICONEDITOR_ICON ) );

      rval = o_false;
      }

   return( rval );
}

/****i* AddToolType() [1.8] ******************************************
*
* NAME
*    AddToolType()
*
* DESCRIPTION
*    Add a ToolType to an Icon.  <primitive 219 8 iconObject iconName toolString>
**********************************************************************
*
*/

METHODFUNC OBJECT *AddToolType( OBJECT *iconobj, char *iconName,
                                char *toolStr )
{
   struct DiskObject *icon = FindDiskObj( iconobj );

   OBJECT  *rval      = o_true;
   int      toolcount = 0;
   STRPTR  *toolarray = (STRPTR *) NULL;
   char    *NewTool   = NULL;
      
   if (icon) // != NULL)
      {
      toolarray = (STRPTR *) icon->do_ToolTypes;
         
      if (icon->do_Type != WBDRAWER || icon->do_Type != WBPROJECT 
                                    || icon->do_Type != WBTOOL 
                                    || toolarray == NULL)
         {
         rval = o_false; // Icon type doesn't have ToolTypes!
     
         goto ExitAddToolType; 
         }  

      while (*(toolarray + toolcount)) // != NULL)
         toolcount++;

      /* make sure that there is a null pointer after the array
      ** pointers by allocating two more pointer spaces, one for 
      ** the null & one for the new tool type pointer.
      */
      toolarray = (STRPTR *) calloc( toolcount + 2, sizeof( char * ));

      if (!toolarray) // == NULL)
         {
         rval = o_false;
       
         goto ExitAddToolType;
         }

      toolcount = 0;

      /* Copy the ToolTypes to the new toolarray pointers: */
      while (*(icon->do_ToolTypes + toolcount)) // != NULL)
         {
         *(toolarray + toolcount) = *(icon->do_ToolTypes + toolcount);
         toolcount++;
         }

      NewTool = (char *) calloc( strlen( toolStr ) + 1, sizeof( char));

      if (!NewTool) // == NULL)
         {
         rval = o_false;
         free( toolarray );
      
         goto ExitAddToolType;
         }

      (void) StringCopy( NewTool, toolStr );

      *(toolarray + toolcount) = NewTool;

      icon->do_ToolTypes       = toolarray;
   
      if (PutDiskObject( iconName, icon ) == 0)
         rval = new_int( IoErr() );
   
      free( toolarray );
      free( NewTool );
      }
   else
      rval = o_false;

ExitAddToolType:
   
   return( rval );
}

/****i* DeleteToolType() [1.8] ***************************************
*
* NAME
*    DeleteToolType()
*
* DESCRIPTION
*    Delete a ToolType from an Icon.  
*    <primitive 219 9 iconObject iconName toolString>
**********************************************************************
*
*/

METHODFUNC OBJECT *DeleteToolType( OBJECT *iconobj, char *iconName, 
                                   char *toolStr )
{
   struct DiskObject *icon = FindDiskObj( iconobj );

   OBJECT  *rval      = o_true;
   char   **toolarray = NULL;
   int      tool      = 0;
   
   if (icon) // != NULL)
      {
      toolarray = (char **) icon->do_ToolTypes;

      if (icon->do_Type != WBDRAWER || icon->do_Type != WBPROJECT 
                                    || icon->do_Type != WBTOOL 
                                    || toolarray == NULL)
         {
         rval = o_false; // Icon type doesn't have ToolTypes!
      
         goto ExitDeleteToolType; 
         }  

      while (StringComp( *(toolarray + tool), toolStr ) != 0)
         tool++;

      if (StringComp( *(toolarray + tool), toolStr ) == 0)
         {
         while (StringLength( *(toolarray + tool + 1) ) > 0)
            {
            *(toolarray + tool) = *(toolarray + tool + 1);
            tool++;   
            }

         *(toolarray + tool) = NULL;
         }

      if (PutDiskObject( iconName, icon ) == 0)
         rval = AssignObj( new_int( IoErr() ) );
      }
   else
      rval = o_false;

ExitDeleteToolType:
   
   return( rval );
}

/****i* GetWidth() [1.8] ******************************************
*
* NAME
*    GetWidth()
*
* DESCRIPTION
*    <primitive 219 10 private>
*******************************************************************
*
*/

METHODFUNC OBJECT *GetWidth( OBJECT *iconobj )
{
   struct DiskObject *icon = FindDiskObj( iconobj );
   OBJECT            *rval = o_nil;
   
   if (icon) // != NULL)
      rval = AssignObj( new_int( icon->do_Gadget.Width ) );

   return( rval );
}

/****i* GetHeight() [1.8] *****************************************
*
* NAME
*    GetHeight()
*
* DESCRIPTION
*    <primitive 219 11 private>
*******************************************************************
*
*/

METHODFUNC OBJECT *GetHeight( OBJECT *iconobj )
{
   struct DiskObject *icon = FindDiskObj( iconobj );
   OBJECT            *rval = o_nil;
   
   if (icon) // != NULL)
      rval = AssignObj( new_int( icon->do_Gadget.Height ) );

   return( rval );
}

/****i* GetFlags() [1.8] ******************************************
*
* NAME
*    GetFlags()
*
* DESCRIPTION
*    <primitive 219 12 private>
*******************************************************************
*
*/

METHODFUNC OBJECT *GetFlags( OBJECT *iconobj )
{
   struct DiskObject *icon = FindDiskObj( iconobj );
   OBJECT            *rval = o_nil;
   
   if (icon) // != NULL)
      rval = AssignObj( new_int( icon->do_Gadget.Flags ) );

   return( rval );
}

/****i* GetImage() [1.8] ****************************************
*
* NAME
*    GetImage()
*
* DESCRIPTION
*    Get an image pointer from iconname & return it as an
*    Integer Object.  <primitive 219 13 private>
*****************************************************************
*
*/

METHODFUNC OBJECT *GetImage( OBJECT *iconobj )
{
   struct DiskObject *icon = FindDiskObj( iconobj );
   OBJECT            *rval = o_nil;
   
   if (icon) // != NULL)
      rval = AssignObj( new_address( (ULONG) icon->do_Gadget.GadgetRender ));

   return( rval );
}

/****i* GetAltImage() [1.8] ************************************
*
* NAME
*    GetAltImage()
*
* DESCRIPTION
*    Get an image pointer from iconname & return it as an
*    Integer Object.  <primitive 219 14 private>
*****************************************************************
*
*/

METHODFUNC OBJECT *GetAltImage( OBJECT *iconobj )
{
   struct DiskObject *icon = FindDiskObj( iconobj );
   OBJECT            *rval = o_nil;
   
   if (icon) // != NULL)
      {
      if ((icon->do_Gadget.Flags & GADGHIMAGE) == GADGHIMAGE)
         {
         icon->do_Gadget.Flags |= GADGHIMAGE;
         }

      rval = AssignObj( new_address( (ULONG) icon->do_Gadget.SelectRender ));
      }

   return( rval );
}

/****i* GetType() [1.8] *****************************************
*
* NAME
*    GetType()
*
* DESCRIPTION
*    Get the type of an Icon & return it as an Integer Object.
*     <primitive 219 15 private>
*****************************************************************
*
*/

METHODFUNC OBJECT *GetType( OBJECT *iconobj )
{
   struct DiskObject *icon = FindDiskObj( iconobj );
   OBJECT            *rval = o_nil;
   
   if (icon) // != NULL)
      rval = AssignObj( new_int( icon->do_Type ) );

   return( rval );
}

/****i* GetDefaultTool() [1.8] **********************************
*
* NAME
*    GetDefaultTool()
*
* DESCRIPTION
*    Get the Default tool (if any) of an Icon & return it as a
*    String Object.
*     <primitive 219 16 private>
*****************************************************************
*
*/

METHODFUNC OBJECT *GetDefaultTool( OBJECT *iconobj )
{
   struct DiskObject *icon = FindDiskObj( iconobj );
   OBJECT            *rval = o_nil;
   
   if (icon) // != NULL)
      {
      rval = new_int( icon->do_Type );

      if (icon->do_Type == WBPROJECT || icon->do_Type == WBDISK)
         rval = AssignObj( new_str( icon->do_DefaultTool ) );
      else
         rval = AssignObj( new_str( IconCMsg( MSG_IC_NO_DEFAULT_ICON )));
      }

   return( rval );
}

/****i* GetStackSize() [1.8] ************************************
*
* NAME
*    GetStackSize()
*
* DESCRIPTION
*    Get the stack setting of an Icon & return it as an 
*    Integer Object.  <primitive 219 17 private>
*****************************************************************
*
*/

METHODFUNC OBJECT *GetStackSize( OBJECT *iconobj )
{
   struct DiskObject *icon = FindDiskObj( iconobj );
   OBJECT            *rval = o_nil;
   
   if (icon) // != NULL)
      {
      if (icon->do_Type == WBTOOL || icon->do_Type == WBPROJECT)
         rval = AssignObj( new_int( icon->do_StackSize ) );
      else
         rval = AssignObj( new_int( 0 ) );
      }

   return( rval );
}

/****i* GetWindowWidth() [1.8] **********************************
*
* NAME
*    GetWindowWidth()
*
* DESCRIPTION
*    Get the window width (if any) of an Icon & return it as an 
*    Integer Object.  <primitive 219 18 private>
*****************************************************************
*
*/

METHODFUNC OBJECT *GetWindowWidth( OBJECT *iconobj )
{
   struct DiskObject *icon = FindDiskObj( iconobj );
   OBJECT            *rval = o_nil;
   
   if (icon) // != NULL)
      {
      if (icon->do_Type == WBPROJECT || icon->do_Type == WBTOOL
                                     || icon->do_Type == WBDEVICE
                                     || icon->do_Type == WBAPPICON)
         rval = AssignObj( new_int( 0 )); /* these types have no window! */
      else
         rval = AssignObj( new_int( icon->do_DrawerData->dd_NewWindow.Width ));
      }

   return( rval );
}

/****i* GetWindowHeight() [1.8] *********************************
*
* NAME
*    GetWindowHeight()
*
* DESCRIPTION
*    Get the window height (if any) of an Icon & return it as an 
*    Integer Object.  <primitive 219 19 private>
*****************************************************************
*
*/

METHODFUNC OBJECT *GetWindowHeight( OBJECT *iconobj )
{
   struct DiskObject *icon = FindDiskObj( iconobj );
   OBJECT            *rval = o_nil;
   
   if (icon) // != NULL)
      {
      if (icon->do_Type == WBPROJECT || icon->do_Type == WBTOOL
                                     || icon->do_Type == WBDEVICE
                                     || icon->do_Type == WBAPPICON)
         rval = AssignObj( new_int( 0 )); /* these types have no window! */
      else
         rval = AssignObj( new_int( icon->do_DrawerData->dd_NewWindow.Height ));
      }

   return( rval );
}

/****i* GetWindowTopEdge() [1.8] ********************************
*
* NAME
*    GetWindowTopEdge()
*
* DESCRIPTION
*    Get the window TopEdge (if any) of an Icon & return it as an 
*    Integer Object.  <primitive 219 20 private>
*****************************************************************
*
*/

METHODFUNC OBJECT *GetWindowTopEdge( OBJECT *iconobj )
{
   struct DiskObject *icon = FindDiskObj( iconobj );
   OBJECT            *rval = o_nil;
   
   if (icon) // != NULL)
      {
      if (icon->do_Type == WBPROJECT || icon->do_Type == WBTOOL
                                     || icon->do_Type == WBDEVICE
                                     || icon->do_Type == WBAPPICON)
         rval = o_nil; /* these types have no window! */
      else
         rval = AssignObj( new_int( icon->do_DrawerData->dd_NewWindow.TopEdge ));
      }

   return( rval );
}

/****i* GetWindowLeftEdge() [1.8] *******************************
*
* NAME
*    GetWindowLeftEdge()
*
* DESCRIPTION
*    Get the window LeftEdge (if any) of an Icon & return it 
*    as an Integer Object.  <primitive 219 21 private>
*****************************************************************
*
*/

METHODFUNC OBJECT *GetWindowLeftEdge( OBJECT *iconobj )
{
   struct DiskObject *icon = FindDiskObj( iconobj );
   OBJECT            *rval = o_nil;
   
   if (icon) // != NULL)
      {
      if (icon->do_Type == WBPROJECT || icon->do_Type == WBTOOL
                                     || icon->do_Type == WBDEVICE
                                     || icon->do_Type == WBAPPICON)
         rval = o_nil; /* these types have no window! */
      else
         rval = AssignObj( new_int( icon->do_DrawerData->dd_NewWindow.LeftEdge ));
      }

   return( rval );
}

/****i* SetWidth() [1.8] *********************************************
*
* NAME
*    SetWidth()
*
* DESCRIPTION
*    Set the image width of an Icon.
*    <primitive 219 22 iconObject iconName newWidth>
**********************************************************************
*
*/

METHODFUNC OBJECT *SetWidth( OBJECT *iconobj, char *iconName, int newWidth)
{
   struct DiskObject *icon = FindDiskObj( iconobj );
   OBJECT            *rval = o_true;
   
   struct Image   *iptr, *aptr;
   
   if (icon) // != NULL)
      {
      icon->do_Gadget.Width = newWidth;
         
      iptr        = (struct Image *) icon->do_Gadget.GadgetRender;
      iptr->Width = newWidth;

      if (icon->do_Gadget.SelectRender) // != NULL)
         {
         aptr        = (struct Image *) icon->do_Gadget.SelectRender;
         aptr->Width = newWidth;
         }

      if (PutDiskObject( iconName, icon ) == 0) 
         rval = AssignObj( new_int( IoErr() ));
      }
   else
      rval = o_false;
      
   return( rval );
}

/****i* SetHeight() [1.8] ********************************************
*
* NAME
*    SetHeight()
*
* DESCRIPTION
*    Set the image height of an Icon.
*    <primitive 219 23 iconObject iconName newHeight>
**********************************************************************
*
*/

METHODFUNC OBJECT *SetHeight( OBJECT *iconobj, char *iconName, 
                              int newHeight )
{
   struct DiskObject *icon = FindDiskObj( iconobj );
   OBJECT            *rval = o_true;
   
   struct Image *iptr, *aptr;
   
   if (icon) // != NULL)
      {
      icon->do_Gadget.Height = newHeight;
         
      /* subtract off 1 in order to space the icon name 
      ** from the image: 
      */
      iptr         = (struct Image *) icon->do_Gadget.GadgetRender;
      iptr->Height = newHeight - 1;

      if (icon->do_Gadget.SelectRender) // != NULL)
         {
         aptr         = (struct Image *) icon->do_Gadget.SelectRender;
         aptr->Height = newHeight - 1;
         }

      if (PutDiskObject( iconName, icon ) == 0) 
         rval = AssignObj( new_int( IoErr() ));
      }
   else
      rval = o_false;      

   return( rval );
}

/* /\/\/\/\ LOCAL FUNCTION: /\/\/\/\/\/\/ */

SUBFUNC int CheckFlags( int flags )
{
   int   rval = -1;

   if ((flags & GADGIMAGE) != GADGIMAGE)
      flags |= GADGIMAGE;   
 
   if (      (flags & GADGHIMAGE) == GADGHIMAGE 
          || (flags & GADGBACKFILL) == GADGBACKFILL
          || (flags & GADGHCOMP) == GADGHCOMP)
      rval = 0;
      
   return( rval );       
}

/****i* SetFlags() [1.8] *********************************************
*
* NAME
*    SetFlags()
*
* DESCRIPTION
*    Set the Flags of an Icon.
*    <primitive 219 24 iconObject iconName newFlags>
**********************************************************************
*
*/

METHODFUNC OBJECT *SetFlags( OBJECT *iconobj, char *iconName, int newFlags)
{
   struct DiskObject *icon = FindDiskObj( iconobj );
   OBJECT            *rval = o_true;
   
   if (icon) // != NULL)
      {
      if (CheckFlags( newFlags ) == 0)
         icon->do_Gadget.Flags = newFlags;
      else
         {
         icon->do_Gadget.Flags = GADGIMAGE + GADGBACKFILL; 
         rval                  = o_false;
         }

      if (PutDiskObject( iconName, icon ) == 0) 
         rval = AssignObj( new_int( IoErr() ));
      }
   else
      rval = o_false;       

   return( rval );
}

/****i* SetImage() [1.8] *********************************************
*
* NAME
*    SetImage()
*
* DESCRIPTION
*    Set the primary Image of an Icon.
*    <primitive 219 25 iconObject iconName newImage>
**********************************************************************
*
*/

METHODFUNC OBJECT *SetImage( OBJECT *iconobj, char *iconName, 
                             OBJECT *imgobj )
{
   struct DiskObject *icon = FindDiskObj( iconobj );
   OBJECT            *rval = o_true;
   struct  Image     *iptr = NULL;
   
   if (NullChk( imgobj ) == FALSE)
      {
      iptr = (struct Image *) CheckObject( imgobj );
         
      if (!iptr) // == NULL)
         return( o_false );
      }
      
   if (icon) // != NULL)
      {
      icon->do_Gadget.GadgetRender = iptr;

      if (PutDiskObject( iconName, icon ) == 0) 
         rval = AssignObj( new_int( IoErr() ));
      }
   else
      rval = o_false;

   return( rval );
}

/****i* SetAltImage() [1.8] ******************************************
*
* NAME
*    SetAltImage()
*
* DESCRIPTION
*    Set the alternate Image of an Icon.
*    <primitive 219 26 iconObject iconName newImage>
**********************************************************************
*
*/

METHODFUNC OBJECT *SetAltImage( OBJECT *iconobj, char *iconName,
                                OBJECT *imgobj )
{
   struct DiskObject *icon = FindDiskObj( iconobj );
   OBJECT            *rval = o_true;
   struct  Image     *iptr = NULL;
   
   if (NullChk( imgobj ) == FALSE)
      {
      iptr = (struct Image *) CheckObject( imgobj );
      
      if (!iptr) // == NULL)
         return( o_false );
      }
      
   if (icon) // != NULL)
      {
      icon->do_Gadget.SelectRender = iptr;
      icon->do_Gadget.Flags        = GADGIMAGE + GADGHIMAGE;

      if (PutDiskObject( iconName, icon ) == 0) 
         rval = AssignObj( new_int( IoErr() ));
      }
   else
      rval = o_false;

   return( rval );
}

/* /\/\/\/\/\/\/ LOCAL FUNCTION: /\/\/\/\/\/\/\/ */

SUBFUNC int CheckType( int type )
{
   switch( type )
      {
      case WBDISK:
      case WBDRAWER:
      case WBTOOL:
      case WBPROJECT:
      case WBGARBAGE:
      case WBDEVICE:
      case WBKICK:
      case WBAPPICON:
         return 0;    // Icon Type was valid!

      default:
         return -1;
      }
}

/****i* SetType() [1.8] **********************************************
*
* NAME
*    SetType()
*
* DESCRIPTION
*    Set the type of an Icon.
*    <primitive 219 27 iconObject iconName newType>
**********************************************************************
*
*/

METHODFUNC OBJECT *SetType( OBJECT *iconobj, char *iconName, int newType )
{
   struct DiskObject *icon = FindDiskObj( iconobj );
   OBJECT            *rval = o_true;

   if (icon) // != NULL)
      {
      if (CheckType( newType ) == 0)
         icon->do_Type = newType;
      else
         return( rval = o_false );

      if (PutDiskObject( iconName, icon ) == 0) 
         rval = AssignObj( new_int( IoErr() ));
      }
   else
      rval = o_false;

   return( rval );
}

/****i* SetDefaultTool() [1.8] ***************************************
*
* NAME
*    SetDefaultTool()
*
* DESCRIPTION
*    Set the Default tool of an Icon.
*    <primitive 219 28 iconObject iconName newTool>
**********************************************************************
*
*/

METHODFUNC OBJECT *SetDefaultTool( OBJECT *iconobj, char *iconName,
                                   char *newTool )
{
   struct DiskObject *icon = FindDiskObj( iconobj );
   OBJECT            *rval = o_true;

   if (icon) // != NULL)
      {
      if ((icon->do_Type == WBDISK) || (icon->do_Type == WBPROJECT))
         {
         if (StringLength( newTool ) > 0) 
            (void) StringCopy( icon->do_DefaultTool, newTool );
         else 
            (void) StringCopy( icon->do_DefaultTool, EMPTY_STRING );
         }
      else
         return( rval = o_false );

      if (PutDiskObject( iconName, icon ) == 0) 
         rval = AssignObj( new_int( IoErr() ));
      }
   else
      rval = o_false;

   return( rval );
}

/****i* SetStackSize() [1.8] *****************************************
*
* NAME
*    SetStackSize()
*
* DESCRIPTION
*    Set the Stack size of an Icon.
*    <primitive 219 29 iconObject iconName newStkSize>
**********************************************************************
*
*/

METHODFUNC OBJECT *SetStackSize( OBJECT *iconobj, char *iconName, 
                                 int newStkSize )
{
   struct DiskObject *icon = FindDiskObj( iconobj );
   OBJECT            *rval = o_true;

   if (icon) // != NULL)
      {
      if (icon->do_Type == WBTOOL || icon->do_Type == WBPROJECT)
         icon->do_StackSize = newStkSize;
      else
         rval = o_false;

      if (PutDiskObject( iconName, icon ) == 0) 
         rval = AssignObj( new_int( IoErr() ));
      }
   else
      rval = o_false;

   return( rval );
}

/****i* SetWindowWidth() [1.8] *****************************************
*
* NAME
*    SetWindowWidth()
*
* DESCRIPTION
*    Set the window width (if any) of an Icon.
*    <primitive 219 30 iconObject iconName newWidth>
**********************************************************************
*
*/

METHODFUNC OBJECT *SetWindowWidth( OBJECT *iconobj, char *iconName,
                                   int newWidth )
{
   struct DiskObject *icon = FindDiskObj( iconobj );
   OBJECT            *rval = o_true;
   UBYTE              type = 0;
   
   if (icon) // != NULL)
      {
      type = icon->do_Type;
         
      if (type == WBTOOL || type == WBAPPICON || type == WBDEVICE 
                         || type == WBPROJECT)
         {
         rval = o_false;
         goto LeaveSetWindowWidth;  /* these types have no window! */
         }

      if (newWidth > 0 && newWidth <= Scr->Width)
         icon->do_DrawerData->dd_NewWindow.Width = newWidth;

      if (PutDiskObject( iconName, icon ) == 0) 
         rval = AssignObj( new_int( IoErr() ));
      }
   else
      rval = o_false;

LeaveSetWindowWidth:

   return( rval );
}

/****i* SetWindowHeight() [1.8] **************************************
*
* NAME
*    SetWindowHeight()
*
* DESCRIPTION
*    Set the window height (if any) of an Icon.
*    <primitive 219 31 iconObject iconName newHeight>
**********************************************************************
*
*/

METHODFUNC OBJECT *SetWindowHeight( OBJECT *iconobj, char *iconName,
                                    int newHeight )
{
   struct DiskObject *icon = FindDiskObj( iconobj );
   OBJECT            *rval = o_true;
   UBYTE              type = 0;
   
   if (icon) // != NULL)
      {
      type = icon->do_Type;
         
      if (type == WBTOOL || type == WBAPPICON || type == WBDEVICE 
                         || type == WBPROJECT)
         {
         rval = o_false;
         goto LeaveSetWindowHeight;  /* these types have no window! */
         }

      if (newHeight > 0 && newHeight <= Scr->Height)
         icon->do_DrawerData->dd_NewWindow.Height = newHeight;

      if (PutDiskObject( iconName, icon ) == 0) 
         rval = AssignObj( new_int( IoErr() ));
      }
   else
      rval = o_false;

LeaveSetWindowHeight:

   return( rval );
}

/****i* SetWindowTopEdge() [1.8] *************************************
*
* NAME
*    SetWindowTopEdge()
*
* DESCRIPTION
*    Set the window top edge (if any) of an Icon.
*    <primitive 219 32 iconObject iconName newTop>
**********************************************************************
*
*/

METHODFUNC OBJECT *SetWindowTopEdge( OBJECT *iconobj, char *iconName,
                                     int newTop )
{
   struct DiskObject *icon = FindDiskObj( iconobj );
   OBJECT            *rval = o_true;
   UBYTE              type = 0;
   
   if (icon) // != NULL)
      {
      type = icon->do_Type;
         
      if (type == WBTOOL || type == WBAPPICON || type == WBDEVICE 
                         || type == WBPROJECT)
         {
         rval = o_false;
         goto LeaveSetWindowTopEdge;  /* these types have no window! */
         }

      if (newTop > 0 && newTop < Scr->Height) // ?????
         {
         icon->do_DrawerData->dd_NewWindow.TopEdge = newTop;
         icon->do_DrawerData->dd_CurrentY          = newTop;
         }
      else
         rval = o_false;

      if (PutDiskObject( iconName, icon ) == 0) 
         rval = AssignObj( new_int( IoErr() ));
      }
   else
      rval = o_false;

LeaveSetWindowTopEdge:

   return( rval );
}

/****i* SetWindowLeftEdge() [1.8] ************************************
*
* NAME
*    SetWindowLeftEdge()
*
* DESCRIPTION
*    Set the window left edge (if any) of an Icon.
*    <primitive 219 33 iconObject iconName newLeft>
**********************************************************************
*
*/

METHODFUNC OBJECT *SetWindowLeftEdge( OBJECT *iconobj, char *iconName,
                                      int newLeft )
{
   struct DiskObject *icon = FindDiskObj( iconobj );
   OBJECT            *rval = o_true;
   UBYTE              type = 0;
   
   if (icon) // != NULL)
      {
      type = icon->do_Type;
         
      if (type == WBTOOL || type == WBAPPICON || type == WBDEVICE 
                         || type == WBPROJECT)
         {
         rval = o_false;
         goto LeaveSetWindowLeftEdge;  /* these types have no window! */
         }

      if (newLeft > 0 && newLeft <= Scr->Width) // ?????
         {
         icon->do_DrawerData->dd_NewWindow.LeftEdge = newLeft;
         icon->do_DrawerData->dd_CurrentX           = newLeft;
         }
      else
         rval = o_false;

      if (PutDiskObject( iconName, icon ) == 0) 
         rval = AssignObj( new_int( IoErr() ));
      }
   else
      rval = o_false;

LeaveSetWindowLeftEdge:

   return( rval );
}

/****i* ReadInAsciiImage() [1.8] **************************************
*
* NAME
*    ReadInAsciiImage()
*
* NOTES
*    The ASCII image file has the following format:
*
*      width, height, depth \n
*      datum \n datum \n datum \n ... \n
*
*    The image read in will be placed in icon->do_Gadget.GadgetRender,
*    then it will be written to the file system.
*     <primitive 219 34>
*
***********************************************************************
*
*/

METHODFUNC OBJECT *ReadInAsciiImage( OBJECT *iconobj, char *iconName,
                                     char *filename )
{
   struct DiskObject *icon = FindDiskObj( iconobj );
   struct Image      *newImage = NULL;

   FILE   *infile = (FILE *) NULL;
   OBJECT *rval   = o_true;

   int     width, height, depth;
   UWORD  *data   = NULL;
   int     i, temp, size = 0;

   if (icon) // != NULL)
      {
      if (!(infile = fopen( filename, FILE_READ_STR ))) // == NULL)
         {
         rval = o_false;
         goto ExitReadAsciiImage;
         }

      fscanf( infile, "%d,%d,%d\n", &width, &height, &depth );

      if (depth < 2)
         {
         rval = o_false;
         fclose( infile );

         goto ExitReadAsciiImage;
         }

      size = height * depth * ((width + 16) / 16);
      data = (UWORD *) calloc( size, sizeof( UWORD ) );
      
      if (!data) // == NULL)
         {
         rval = o_false;
         fclose( infile );

         goto ExitReadAsciiImage;
         }

      for (i = 0; i < size; i++)
         {
         fscanf( infile, "%d\n", &temp );

         *(data + i) = (UWORD) temp;
         }

      fclose( infile );

      newImage = (struct Image *) icon->do_Gadget.GadgetRender;

      newImage->Width      = width;
      newImage->Height     = height;
      newImage->Depth      = depth;
      newImage->ImageData  = data;

      if (PutDiskObject( iconName, icon ) == 0) 
         rval = AssignObj( new_int( IoErr() ));

      free( data );
      }
   else
      rval = o_false;

ExitReadAsciiImage:

   return( rval );
}

/****i* WriteAsciiImage() [1.8] **************************************
*
* NAME
*    WriteAsciiImage()
*
* DESCRIPTION
*    Write icon->do_Gadget.GadgetRender to the filename in the 
*    following format:
*
*       width, height, depth\n
*       datum \n datum \n datum \n ...
*
*     <primitive 219 35>
**********************************************************************
*
*/

METHODFUNC OBJECT *WriteAsciiImage( OBJECT *iconobj, char *filename )
{
   struct DiskObject *icon   = FindDiskObj( iconobj );
   struct Image      *wImage = (struct Image *) NULL;

   FILE   *outfile = (FILE *) NULL;
   OBJECT *rval    = o_true;
   int     size    = 0;
   int     i;
   UWORD   datum;
   

   if (icon) // != NULL)
      {
      wImage = (struct Image *) icon->do_Gadget.GadgetRender;
         
      if (!(outfile = fopen( filename, FILE_WRITE_STR ))) // == NULL)
         {
         rval = o_false;

         goto ExitWriteAsciiImage;
         } 

      fprintf( outfile, "%d,%d,%d\n", 
                        wImage->Width, wImage->Height, wImage->Depth
             );

      size = wImage->Height * wImage->Depth 
                            * ((wImage->Width + 16) / 16);
   
      for (i = 0; i < size; i++)
         {
         datum = (UWORD) *(wImage->ImageData + i);

         fprintf( outfile, "%d\n", datum );
         }

      fclose( outfile );
      }
   else
      rval = o_false;

ExitWriteAsciiImage:

   return( rval );
}

/****i* getDefDiskObject() [2.0] *************************************
*
* NAME
*    getDefDiskObject()
*
* DESCRIPTION
*    ^ <primitive 219 36 iconType>
**********************************************************************
*
*/

METHODFUNC OBJECT *getDefDiskObject( LONG iconType )
{
   struct DiskObject *dobj = (struct DiskObject *) NULL;
   OBJECT            *rval = o_nil;
   
   switch (iconType)
      {
      case WBDISK:
      case WBDRAWER:
      case WBTOOL:
      case WBPROJECT:
      case WBGARBAGE:
      case WBDEVICE:
      case WBKICK:
      case WBAPPICON:

         dobj = GetDefDiskObject( iconType );
         rval = AssignObj( new_address( (ULONG) dobj ));
         break;
      
      default:
         break; 
      }
      
   return( rval );   
}

/****i* putDefDiskObject() [2.0] *************************************
*
* NAME
*    putDefDiskObject()
*
* DESCRIPTION
*    ^ <primitive 219 37 diskObject>
**********************************************************************
*
*/

METHODFUNC OBJECT *putDefDiskObject( OBJECT *diskObject )
{
   struct DiskObject *dobj = (struct DiskObject *) CheckObject( diskObject );
   OBJECT            *rval = o_false;

   if (!dobj) // == NULL)
      return( rval );
      
   if (PutDefDiskObject( dobj ) == FALSE)
      return( rval );
   else
      return( o_true );
}

/****i* getNewDiskObject() [2.0] *************************************
*
* NAME
*    getNewDiskObject()
*
* DESCRIPTION
*    ^ <primitive 219 38 iconName>
**********************************************************************
*
*/

METHODFUNC OBJECT *getNewDiskObject( char *iconName )
{
   struct DiskObject *dobj = (struct DiskObject *) NULL;

   CleanFileName( iconName );
   
   if (!(dobj = GetDiskObjectNew( iconName ))) // != NULL)
      return( AssignObj( new_address( (ULONG) dobj ) ));
   else
      return( o_nil );
}

/****i* deleteDiskObject() [2.0] *************************************
*
* NAME
*    deleteDiskObject()
*
* DESCRIPTION
*    ^ <primitive 219 39 iconName>
**********************************************************************
*
*/

METHODFUNC OBJECT *deleteDiskObject( char *iconName )
{
   CleanFileName( iconName );

   if (DeleteDiskObject( iconName ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* duplicateDiskObject() [2.0] **********************************
*
* NAME
*    duplicateDiskObject()
*
* DESCRIPTION
*    ^ <primitive 219 40 diskObj tagArray>
**********************************************************************
*
*/

METHODFUNC OBJECT *duplicateDiskObject( OBJECT *diskObj, OBJECT *tagArray )
{
   struct TagItem    *tags = (struct TagItem *) NULL;
   struct DiskObject *dobj = (struct DiskObject *) CheckObject( diskObj );
   struct DiskObject *New  = (struct DiskObject *) NULL;
   OBJECT            *rval = o_nil;

   if (!dobj) // == NULL)
      return( rval );
      
   if (NullChk( tagArray ) == FALSE)
      {
      tags = ArrayToTagList( tagArray );
      }   

   New = DupDiskObjectA( dobj, tags );
   
   if (tags) // != NULL)
      AT_FreeVec( tags, "dupDiskObjectTags", TRUE );
      
   if (!New) // == NULL)
      return( rval );
   else
      return( AssignObj( new_address( (ULONG) New ) ) );
}

/****i* newDiskObject() [2.0] ****************************************
*
* NAME
*    newDiskObject()
*
* DESCRIPTION
*    ^ <primitive 219 41 iconType>
**********************************************************************
*
*/

METHODFUNC OBJECT *newDiskObject( LONG iconType )
{
   struct DiskObject *dobj = (struct DiskObject *) NULL;
   OBJECT            *rval = o_nil;

   switch (iconType)
      {
      case WBDISK:
      case WBDRAWER:
      case WBTOOL:
      case WBPROJECT:
      case WBGARBAGE:
      case WBDEVICE:
      case WBKICK:
      case WBAPPICON:
      
         if ((dobj = NewDiskObject( iconType ))) // != NULL)
            rval = AssignObj( new_address( (ULONG) dobj ) );

         break;

      default:
         break;  
      }
      
   return( rval );   
}

/****i* iconControl() [2.0] ******************************************
*
* NAME
*    iconControl()
*
* DESCRIPTION
*    ^ <primitive 219 42 diskObj tagArray>
**********************************************************************
*
*/

METHODFUNC OBJECT *iconControl( OBJECT *diskObj, OBJECT *tagArray )
{
   struct DiskObject *dobj = (struct DiskObject *) CheckObject( diskObj );
   struct TagItem    *tags = (struct TagItem *) NULL;
   ULONG              chk  = 0L;
   
   if (!dobj) // == NULL)
      return( o_nil );
      
   if (NullChk( tagArray ) == FALSE)
      {
      tags = ArrayToTagList( tagArray );
      }
      
   chk = IconControlA( dobj, tags );
   
   if (tags) // != NULL)
      AT_FreeVec( tags, "iconCtrlTags", TRUE );
      
   return( new_int( (int) chk ) );
}

/****i* drawIconState() [2.0] ****************************************
*
* NAME
*    drawIconState()
*
* DESCRIPTION
*    <primitive 219 43 windowObj diskObj labelStr xOffset yOffset
*                      whichState tagArray>
**********************************************************************
*
*/

METHODFUNC void drawIconState( OBJECT *winObj,
                               OBJECT *diskObj,
                               char   *labelStr,
                               LONG    xOffset,
                               LONG    yOffset,
                               ULONG   whichState, 
                               OBJECT *tagArray 
                             )
{
   struct DiskObject *dobj = (struct DiskObject *) CheckObject( diskObj );
   struct Window     *wptr = (struct Window     *) CheckObject( winObj  );
   struct TagItem    *tags = (struct TagItem *) NULL;
   
   if (!dobj || !wptr) // == NULL)
      return;
      
   if (NullChk( tagArray ) == FALSE)
      tags = ArrayToTagList( tagArray );
         
   DrawIconStateA( wptr->RPort, dobj, labelStr, xOffset, yOffset, 
                   whichState, tags 
                 );

   if (tags) // != NULL)
      AT_FreeVec( tags, "drawIconTags", TRUE );
     
   return;  
}

/****i* layoutIcon() [2.0] *******************************************
*
* NAME
*    layoutIcon()
*
* DESCRIPTION
*    ^ <primitive 219 44 diskObj screenObj tagArray>
**********************************************************************
*
*/

METHODFUNC OBJECT *layoutIcon( OBJECT *diskObj, 
                               OBJECT *scrObj, 
                               OBJECT *tagArray 
                             )
{
   struct DiskObject *dobj = (struct DiskObject *) CheckObject( diskObj );
   struct Screen     *sptr = (struct Screen     *) CheckObject( scrObj  );
   struct TagItem    *tags = (struct TagItem *) NULL;
   
   if (!dobj || !sptr) // == NULL)
      return( o_false );
      
   if (NullChk( tagArray ) == FALSE)
      tags = ArrayToTagList( tagArray );

   if (LayoutIconA( dobj, sptr, tags ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* findToolType() [2.0] *****************************************
*
* NAME
*    findToolType()
*
* DESCRIPTION
*    ^ <primitive 219 45 diskObj toolName>
**********************************************************************
*
*/

METHODFUNC OBJECT *findToolType( OBJECT *diskObj, char *toolName )
{
   struct DiskObject *dobj  = (struct DiskObject *) CheckObject( diskObj );
   STRPTR            *tools = (STRPTR *) NULL;
   char              *rval  = NULL;
   
   if (!dobj || StringLength( toolName ) < 1)
      return( o_nil );
      
   tools = dobj->do_ToolTypes;

   rval  = FindToolType( tools, toolName );
   
   if (!rval) // == NULL)
      return( o_nil );
   else
      return( new_str( rval ) );
}

/****i* matchToolValue() [2.0] ***************************************
*
* NAME
*    matchToolValue()
*
* DESCRIPTION
*    ^ <primitive 219 46 toolName toolValueStr>
**********************************************************************
*
*/

METHODFUNC OBJECT *matchToolValue( char *toolName, char *toolValue )
{
   if (StringLength( toolName ) < 1)
      return( o_false );
   
   if (MatchToolValue( toolName, toolValue ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* bumpRevision() [2.0] *****************************************
*
* NAME
*    bumpRevision()
*
* DESCRIPTION
*    ^ <primitive 219 47 newName oldName>
**********************************************************************
*
*/

METHODFUNC OBJECT *bumpRevision( char *newName, char *oldName )
{
   return( AssignObj( new_str( BumpRevision( newName, oldName ))));
}

/****i* getIconRectangle() [2.0] *************************************
*
* NAME
*    getIconRectangle()
*
* DESCRIPTION
*    ^ <primitive 219 48 windowObj diskObj labelStr rectObj tagArray>
**********************************************************************
*
*/

METHODFUNC OBJECT *getIconRectangle( OBJECT *winObj,
                                     OBJECT *diskObj,
                                     char   *labelStr,
                                     OBJECT *rectObj,
                                     OBJECT *tagArray 
                                   )
{
   struct Window     *wptr =     (struct Window *) CheckObject( winObj );
   struct DiskObject *dobj = (struct DiskObject *) CheckObject( diskObj );
   struct Rectangle  *rect = (struct Rectangle  *) CheckObject( rectObj );
   struct TagItem    *tags = (struct TagItem    *) NULL;
   BOOL               rval = FALSE;
      
   if (!wptr || !dobj || !rect) // == NULL)
      return( o_false );

   if (NullChk( tagArray ) == FALSE)
      tags = ArrayToTagList( tagArray );
      
   rval = GetIconRectangleA( wptr->RPort, dobj, labelStr, rect, tags );

   if (tags) // != NULL)
      AT_FreeVec( tags, "getIconRectTags", TRUE );
      
   if (rval == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* getIconTagList() [2.0] ***************************************
*
* NAME
*    getIconTagList()
*
* DESCRIPTION
*    ^ <primitive 219 49 iconName tagArray>
**********************************************************************
*
*/

METHODFUNC OBJECT *getIconTagList( char *iconName, OBJECT *tagArray )
{
   struct TagItem    *tags = (struct TagItem    *) NULL;
   struct DiskObject *dobj = (struct DiskObject *) NULL;

   if (StringLength( iconName ) < 1)
      return( o_nil );

   dobj = GetIconTagList( iconName, tags );
   
   if (!dobj) // == NULL)
      return( o_nil );
   else
      return( AssignObj( new_address( (ULONG) dobj ) ) );
}

/****i* putIconTagList() [2.0] ***************************************
*
* NAME
*    putIconTagList()
*
* DESCRIPTION
*    ^ <primitive 219 50 iconName diskObj tagArray>
**********************************************************************
*
*/

METHODFUNC OBJECT *putIconTagList( char *iconName, OBJECT *diskObj, OBJECT *tagArray )
{
   struct DiskObject *dobj = (struct DiskObject *) CheckObject( diskObj );
   struct TagItem    *tags = (struct TagItem *) NULL;
   BOOL               rval = FALSE;
   
   if (!dobj) // == NULL)
      return( o_false );
      
   if (NullChk( tagArray ) == FALSE)
      tags = ArrayToTagList( tagArray );
      
   rval = PutIconTagList( iconName, dobj, tags );
   
   if (tags) // != NULL)
      AT_FreeVec( tags, "putIconTags", TRUE );

   if (rval == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* freeFreeList() [2.0] *****************************************
*
* NAME
*    freeFreeList()
*
* DESCRIPTION
*    <primitive 219 51 freeListObj>
**********************************************************************
*
*/

METHODFUNC void freeFreeList( OBJECT *freeListObj )
{
   struct FreeList *free = (struct FreeList *) CheckObject( freeListObj );
   
   if (!free) // == NULL)
      return;

   FreeFreeList( free );

   return;
}

/****i* addFreeList() [2.0] ******************************************
*
* NAME
*    addFreeList()
*
* DESCRIPTION
*    ^ <primitive 219 52 freeListObj memObj size>
**********************************************************************
*
*/

METHODFUNC OBJECT *addFreeList( OBJECT *freeListObj, OBJECT *memObj, ULONG size )
{
   struct FreeList *free = (struct FreeList *) CheckObject( freeListObj );
   APTR             mem  =              (APTR) CheckObject( memObj );
   
   if (!free || !mem || (size < 1))
      return( o_false );
   
   if (AddFreeList( free, mem, size ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* changeSelIconColor() [2.0] ***********************************
*
* NAME
*    changeSelIconColor()
*
* DESCRIPTION
*    <primitive 219 53 colorRegisterObj>
**********************************************************************
*
*/

METHODFUNC void changeSelIconColor( OBJECT *cregObj )
{
   struct ColorRegister *cr = (struct ColorRegister *) CheckObject( cregObj );
   
   if (!cr) // == NULL)
      return;
      
   ChangeToSelectedIconColor( cr );
   
   return;
}

/****i* HandleIcons() [1.8] ******************************************
*
* NAME
*    HandleIcons()
*
* DESCRIPTION
*    Translate primitive 219 calls into Icon functions.
**********************************************************************
*
*/

PUBLIC OBJECT *HandleIcons( int numargs, OBJECT **args )
{

   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 219 );

      return( o_nil );
      }
         
   switch (int_value( args[0] ))
      {
      case 0:  // closeIcon  ^ <219 0 private iconName>
         if (is_string( args[2] ) == FALSE)
            (void) PrintArgTypeError( 219 );
         else
            {
            rval = CloseIcon( args[1], string_value( (STRING *) args[2] ));
            }

         break;
      
      case 1: // openIcon: iconFileName or new: iconFileName
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 219 );
         else
            {
            rval = OpenIcon( string_value( (STRING *) args[1] ) );
            }

         break;

      case 2: // editToolTypes
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 219 );
         else
            rval = EditToolTypes( string_value( (STRING *) args[1] ) );
         break;
      
      case 3: // displayIconInfo
         if (is_string( args[2] ) == FALSE)
            (void) PrintArgTypeError( 219 );
         else
            rval = DisplayIconInfo( args[1], 
                                    string_value( (STRING *) args[2] ) 
                                  );
         break;
      
      case 4: // displayIconImages
         if (is_string( args[2] ) == FALSE)
            (void) PrintArgTypeError( 219 );
         else
            DisplayIconImages( args[1],
                               string_value( (STRING *) args[2] ) 
                             );
         break;

      case 5: // setIconPosition: setPoint
         if (!is_string( args[2]) || !is_integer( args[3] )
                                  || !is_integer( args[4] ))
            (void) PrintArgTypeError( 219 );
         else
            {
            rval = SetIconPosition( args[1],
                                    string_value( (STRING *) args[2] ),
                                    int_value( args[3] ),
                                    int_value( args[4] ) 
                                  );
            }
         break;
      
      case 6: // moveIcon: deltaPoint
         if (!is_string( args[2] ) || !is_integer( args[3] )
                                   || !is_integer( args[3] ))
            (void) PrintArgTypeError( 219 );
         else
            {
            rval = MoveIcon( args[1],
                             string_value( (STRING *) args[2] ),
                             int_value( args[3] ),
                             int_value( args[4] ) 
                           );
            }
         break;

      case 7: // editIcon: externalEditorName 
         if (!is_string( args[1] ) || !is_string( args[2] ))
            (void) PrintArgTypeError( 219 );
         else
            {
            rval = ExternalIconEditor( string_value( (STRING *) args[1] ), 
                                       string_value( (STRING *) args[2] ) 
                                     );
            }
         break;

      case 8:  // AddToolType: toolString
         if (!is_string( args[2] ) || !is_string( args[3] ))
            (void) PrintArgTypeError( 219 );
         else
            rval = AddToolType( args[1], 
                                string_value( (STRING *) args[2] ),
                                string_value( (STRING *) args[3] )
                              );
         break;

      case 9:  // DeleteToolType: toolString
         if (!is_string( args[2] ) || !is_string( args[3] ))
            (void) PrintArgTypeError( 219 );
         else
            rval = DeleteToolType( args[1], 
                                   string_value( (STRING *) args[2] ),
                                   string_value( (STRING *) args[3] )
                                 );
         break;

      case 10: // getIconWidth
         rval = GetWidth( args[1] );
         break;

      case 11: // getIconHeight
         rval = GetHeight( args[1] );
         break;

      case 12: // getIconFlags
         rval = GetFlags( args[1] );
         break;

      case 13: // getIconImage
         rval = GetImage( args[1] );
         break;

      case 14: // getIconAlternateImage
         rval = GetAltImage( args[1] );
         break;

      case 15: // getIconType
         rval = GetType( args[1] );
         break;

      case 16: // getDefaultTool
         rval = GetDefaultTool( args[1] );
         break;

      case 17: // getStackSize
         rval = GetStackSize( args[1] );
         break;

      case 18: // getWindowWidth
         rval = GetWindowWidth( args[1] );
         break;

      case 19: // getWindowHeight
         rval = GetWindowHeight( args[1] );
         break;

      case 20: // getWindowTopEdge
         rval = GetWindowTopEdge( args[1] );
         break;

      case 21: // getWindowLeftEdge
         rval = GetWindowLeftEdge( args[1] );
         break;

      case 22: // setIconWidth: newWidth
         if (!is_string( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 219 );
         else
            rval = SetWidth( args[1], 
                             string_value( (STRING *) args[2] ),
                             int_value( args[3] ) 
                           );
   
         break;

      case 23: // setIconHeight: newHeight
         if (!is_string( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 219 );
         else
            rval = SetHeight( args[1], 
                              string_value( (STRING *) args[2] ),
                              int_value( args[3] ) 
                            );
         break;

      case 24: // setIconFlags: newFlags
         if (!is_string( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 219 );
         else
            rval = SetFlags( args[1], 
                             string_value( (STRING *) args[2] ),
                             int_value( args[3] ) 
                           );
         break;

      case 25: // setIconImage: imageObject
         if (!is_string( args[2] ))
            rval = SetImage( args[1], 
                             string_value( (STRING *) args[2] ),
                             args[3]
                           );
         break;

      case 26: // setIconAlternateImage: imageObject
         if (!is_string( args[2] ))
            rval = SetAltImage( args[1], 
                                string_value( (STRING *) args[2] ),
                                args[3]
                              );
         break;

      case 27: // setIconType: newType
         if (!is_string( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 219 );
         else
            rval = SetType( args[1], 
                            string_value( (STRING *) args[2] ),
                            int_value( args[3] )
                          );
         break;

      case 28: // setDefaultTool: newTool
         if (!is_string( args[2] ) || !is_string( args[3] ))
            (void) PrintArgTypeError( 219 );
         else
            rval = SetDefaultTool( args[1], 
                                   string_value( (STRING *) args[2] ),
                                   string_value( (STRING *) args[3] )
                                 );
         break;

      case 29: // setStackSize: newStackSize
         if (!is_string( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 219 );
         else
            rval = SetStackSize( args[1], 
                                 string_value( (STRING *) args[2] ),
                                 int_value( args[3] )
                               );
         break;

      case 30: // setWindowWidth: newWidth
         if (!is_string( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 219 );
         else
            rval = SetWindowWidth( args[1], 
                                   string_value( (STRING *) args[2] ),
                                   int_value( args[3] )
                                 );
         break;

      case 31: // setWindowHeight: newHeight
         if (!is_string( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 219 );
         else
            rval = SetWindowHeight( args[1], 
                                    string_value( (STRING *) args[2] ),
                                    int_value( args[3] )
                                  );
         break;

      case 32: // setWindowTopEdge: newTopEdge
         if (!is_string( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 219 );
         else
            rval = SetWindowTopEdge( args[1], 
                                     string_value( (STRING *) args[2] ),
                                     int_value( args[3] )
                                   );
         break;

      case 33: // setWindowLeftEdge: newLeftEdge
         if (!is_string( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 219 );
         else
            rval = SetWindowLeftEdge( args[1], 
                                      string_value( (STRING *) args[2] ),
                                      int_value( args[3] )
                                    );
         break;

      case 34: // getAsciiImage: filename
         if (!is_string( args[2] ) || !is_string( args[3] ))
            (void) PrintArgTypeError( 219 );
         else
            rval = ReadInAsciiImage( args[1], 
                                     string_value( (STRING *) args[2] ),
                                     string_value( (STRING *) args[3] ) 
                                   );
         break;

      case 35: // writeAsciiImage: filename
         if (is_string( args[2] ) == FALSE)
            (void) PrintArgTypeError( 219 );
         else
            rval = WriteAsciiImage( args[1],
                                    string_value( (STRING *) args[2] ) 
                                  );
         break;

      case 36: // getDefaultIcon: iconType
               // ^ <primitive 219 36 iconType>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 219 );
         else
            rval = getDefDiskObject( (LONG) int_value( args[1] ) ); 
            
         break;         

      case 37: // putDefaultIcon: diskObject
               // ^ <primitive 219 37 diskObject>
         rval = putDefDiskObject( args[1] );
         break;

      case 38: // getNewDiskObject: iconName
               // ^ <primitive 219 38 iconName> // make sure that iconName isn't icon.info
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 219 );
         else
            rval = getNewDiskObject( string_value( (STRING *) args[1] ) );
         
         break;

      case 39: // deleteDiskObject: iconName
               // ^ <primitive 219 39 iconName>
         if (is_string( args[1] ) == FALSE) // make sure that iconName isn't icon.info
            (void) PrintArgTypeError( 219 );
         else
            rval = deleteDiskObject( string_value( (STRING *) args[1] ) );
         
         break;

      case 40: // duplicateDiskObject: diskObject tags: tagArray
               // ^ <primitive 219 40 diskObj tagArray>
         if (is_array( args[1] ) == FALSE)
            (void) PrintArgTypeError( 219 );
         else
            rval = duplicateDiskObject( args[1], args[2] );

         break;
      
      case 41: // newDiskObject: iconType
               // ^ <primitive 219 41 iconType>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 219 );
         else
            rval = newDiskObject( (LONG) int_value( args[1] ) );
         
         break;

      case 42: // iconControl: diskObject tags: tagArray
               // ^ <primitive 219 42 diskObj tagArray>    // diskObj can be nil
         if (is_array( args[2] ) == FALSE)
            (void) PrintArgTypeError( 219 );
         else
            rval = iconControl( args[1], args[2] );
            
         break;

      case 43: // drawIconState: diskObj on: windowObj label: labelStr at: sPoint
               //       inState: whichState tags: tagArray
               // <primitive 219 43 windowObj diskObj labelStr xOffset yOffset
               //                   whichState tagArray>
         if (!is_integer( args[4] ) || !is_integer( args[5] )
                                    || !is_integer( args[6] )
                                    || !is_array(   args[7] ))
            (void) PrintArgTypeError( 219 );
         else
            drawIconState( args[1], args[2],
                                string_value( (STRING *) args[3] ), // can be NULL!
                           (LONG)  int_value( args[4] ),
                           (LONG)  int_value( args[5] ),
                           (ULONG) int_value( args[6] ),
                           args[7]
                         );
         break;

      case 44: // layoutIcon: diskObj on: screenObj tags: tagArray
               // ^ <primitive 219 44 diskObj screenObj tagArray>  // scrObj can be nil
         if (is_array( args[3] ) == FALSE)
            (void) PrintArgTypeError( 219 );
         else
            rval = layoutIcon( args[1], args[2], args[3] );
         
         break;

      case 45: // findToolType: toolName in: diskObj
               // ^ <primitive 219 45 diskObj toolName>
         if (is_string( args[2] ) == FALSE)
            (void) PrintArgTypeError( 219 );
         else
            rval = findToolType( args[1], string_value( (STRING *) args[2] ) );
            
         break;

      case 46: // matchTool: toolTypeString to: toolValueStr
               // ^ <primitive 219 46 toolTypeString toolValueStr>
         if (!is_string( args[1] ) || !is_string( args[2] ))
            (void) PrintArgTypeError( 219 );
         else
            rval = matchToolValue( string_value( (STRING *) args[1] ),
                                   string_value( (STRING *) args[2] )
                                 );
         break;

      case 47: // bumpRevision: oldName to: newName
               // ^ <primitive 219 47 newName oldName>
         if (!is_string( args[1] ) || !is_string( args[2] ))
            (void) PrintArgTypeError( 219 );
         else
            {
            if (StringLength( string_value( (STRING *) args[1] )) < 31)
               {
               OBJECT *buf = new_str( "01234567890123456789012345678901" );

               rval = bumpRevision( string_value( (STRING *) buf ),
                                    string_value( (STRING *) args[2] )
                                  );
               }
            else
               {
               rval = bumpRevision( string_value( (STRING *) args[1] ),
                                    string_value( (STRING *) args[2] )
                                  );
               }
            }
         break;

      case 48: // getIconBounds: diskObj   for: rectObj from: windowObj 
               //         label: labelStr tags: tagArray
               // ^ <primitive 219 48 windowObj diskObj labelStr rectObj tagArray>
         if (is_array( args[5] ) == FALSE)
            (void) PrintArgTypeError( 219 );
         else
            rval = getIconRectangle( args[1], args[2],
                                     string_value( (STRING *) args[3] ), // can be nil
                                     args[4], args[5]
                                   );
         break;

      case 49: // getIcon: iconName tags: tagArray
               // ^ <primitive 219 49 iconName tagArray>
         if (is_array( args[2] ) == FALSE)
            (void) PrintArgTypeError( 219 );
         else
            rval = getIconTagList( string_value( (STRING *) args[1] ), // can be nil
                                                            args[2] 
                                 );
         break;

      case 50: // storeIcon: diskObj named: iconName tags: tagArray
               // ^ <primitive 219 50 iconName diskObj tagArray>
         if (!is_string( args[1] ) || !is_array( args[3] ))
            (void) PrintArgTypeError( 219 );
         else
            rval = putIconTagList( string_value( (STRING *) args[1] ),
                                   args[2], args[3] 
                                 );
         break;

      case 51: // disposeFreeList: freeListObj
               // <primitive 219 51 freeListObj>
         freeFreeList( args[1] );
         break;

      case 52: // add: memoryObj toFreeList: freeListObj size: size
               // ^ <primitive 219 52 freeListObj memObj size>
         if (is_integer( args[3] ) == FALSE)
            (void) PrintArgTypeError( 219 );
         else
            rval = addFreeList( args[1], args[2],
                                (ULONG) int_value( args[3] )
                              );
         break;

      case 53: // changeColorToSelectedIconColor: colorRegisterObj
               // <primitive 219 53 colorRegisterObj>
         changeSelIconColor( args[1] );
         break;

      default:
         (void) PrintArgTypeError( 219 );
         break;
      }

   return( rval );
}

/* ------------------- END of Icon.c file! ----------------------- */
