/****h* TestMenuAddition.c [1.0] *****************************
*
* NAME
*    TestMenuAddition.c
*
* DESCRIPTION
*
* NOTES
*
*    GUI Designed by : Jim Steichen
**************************************************************
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

#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/graphics_protos.h>
#include <clib/utility_protos.h>
#include <clib/diskfont_protos.h>

#include "CPGM:GLobalObjects/CommonFuncs.h"

struct IntuitionBase *IntuitionBase;
struct GfxBase       *GfxBase;
struct Library       *GadToolsBase;


PRIVATE struct CompFont  CFont   = { 0, };
PRIVATE struct TextAttr *Font, Attr;
PRIVATE struct TextFont *TMFont  = NULL;
PRIVATE struct Screen   *Scr     = NULL;
PRIVATE struct Window   *TMWnd   = NULL;
PRIVATE struct Menu     *TMMenus = NULL;

PRIVATE struct IntuiMessage  TMMsg;
PRIVATE UBYTE               *PubScreenName = NULL;
PRIVATE APTR                 VisualInfo    = NULL;

PRIVATE UWORD  TMLeft   = 144;
PRIVATE UWORD  TMTop    = 208;
PRIVATE UWORD  TMWidth  = 396;
PRIVATE UWORD  TMHeight = 73;
PRIVATE UBYTE *TMWdt    = "Test Menu Additions:";


PRIVATE int TMLoadMI(       void );
PRIVATE int TMQuitMI(       void );
PRIVATE int TMAddItemMI(    void );
PRIVATE int TMRemoveItemMI( void );
PRIVATE int TMBlank1MI(     void );

PRIVATE struct NewMenu TMNewMenu[] = {

   NM_TITLE, "PROJECT",      NULL, 0, NULL, NULL,
    NM_ITEM, "Load...",       "L", 0, 0L, (APTR) TMLoadMI,
    NM_ITEM, "Add Item",      "A", 0, 0L, (APTR) TMAddItemMI,
    NM_ITEM, "Remove Item",   "R", 0, 0L, (APTR) TMRemoveItemMI,
    NM_ITEM, "Quit",          "Q", 0, 0L, (APTR) TMQuitMI,

   NM_TITLE, "USER SCRIPTS", NULL, 0, NULL, NULL,

    NM_IGNORE, "Blank1",     NULL, 0, 0L, NULL,
    NM_IGNORE, "Blank2",     NULL, 0, 0L, NULL,
    NM_IGNORE, "Blank3",     NULL, 0, 0L, NULL,
    NM_IGNORE, "Blank4",     NULL, 0, 0L, NULL,
    NM_IGNORE, "Blank5",     NULL, 0, 0L, NULL,
    NM_IGNORE, "Blank6",     NULL, 0, 0L, NULL,
    NM_IGNORE, "Blank7",     NULL, 0, 0L, NULL,
    NM_IGNORE, "Blank8",     NULL, 0, 0L, NULL,
    NM_IGNORE, "Blank9",     NULL, 0, 0L, NULL,
    NM_IGNORE, "Blank10",    NULL, 0, 0L, NULL,
    NM_IGNORE, "Blank11",    NULL, 0, 0L, NULL,
    NM_IGNORE, "Blank12",    NULL, 0, 0L, NULL,
    NM_IGNORE, "Blank13",    NULL, 0, 0L, NULL,
    NM_IGNORE, "Blank14",    NULL, 0, 0L, NULL,
    NM_IGNORE, "Blank15",    NULL, 0, 0L, NULL,
    NM_IGNORE, "Blank16",    NULL, 0, 0L, NULL,
    NM_IGNORE, "Blank17",    NULL, 0, 0L, NULL,
    NM_IGNORE, "Blank18",    NULL, 0, 0L, NULL,
    NM_IGNORE, "Blank19",    NULL, 0, 0L, NULL,
    NM_IGNORE, "Blank20",    NULL, 0, 0L, NULL,
    NM_IGNORE, "Blank21",    NULL, 0, 0L, NULL,
    NM_IGNORE, "Blank22",    NULL, 0, 0L, NULL,
    NM_IGNORE, "Blank23",    NULL, 0, 0L, NULL,
    NM_IGNORE, "Blank24",    NULL, 0, 0L, NULL,
    NM_IGNORE, "Blank25",    NULL, 0, 0L, NULL,
    NM_IGNORE, "Blank26",    NULL, 0, 0L, NULL,
    NM_IGNORE, "Blank27",    NULL, 0, 0L, NULL,
    NM_IGNORE, "Blank28",    NULL, 0, 0L, NULL,
    NM_IGNORE, "Blank29",    NULL, 0, 0L, NULL,
    NM_IGNORE, "Blank30",    NULL, 0, 0L, NULL,
    NM_IGNORE, "Blank31",    NULL, 0, 0L, NULL,

   NM_END, NULL, NULL, 0, 0L, NULL 
};

PRIVATE int SetupScreen( void )
{
   if ((Scr = LockPubScreen( PubScreenName )) == NULL)
      return( -1 );

   Font = &Attr;
   
   ComputeFont( Scr, Font, &CFont, 0, 0 );

   if ((VisualInfo = GetVisualInfo( Scr, TAG_DONE )) == NULL)
      return( -2 );

   return( 0 );
}

PRIVATE void CloseDownScreen( void )
{
   if (VisualInfo != NULL) 
      {
      FreeVisualInfo( VisualInfo );
      VisualInfo = NULL;
      }

   if (Scr != NULL) 
      {
      UnlockPubScreen( NULL, Scr );
      Scr = NULL;
      }

   return;
}

PRIVATE void CloseTMWindow( void )
{
   if (TMMenus != NULL) 
      {
      ClearMenuStrip( TMWnd );
      FreeMenus( TMMenus );
      TMMenus = NULL;   
      }

   if (TMWnd != NULL) 
      {
      CloseWindow( TMWnd );
      TMWnd = NULL;
      }

   if (TMFont != NULL) 
      {
      CloseFont( TMFont );
      TMFont = NULL;
      }

   return;
}

PRIVATE int OpenTMWindow( void )
{
   UWORD wleft = TMLeft, wtop = TMTop, ww, wh;

   ComputeFont( Scr, Font, &CFont, TMWidth, TMHeight );

   ww = ComputeX( CFont.FontX, TMWidth );
   wh = ComputeY( CFont.FontY, TMHeight );

   wleft = (Scr->Width  - ww) / 2;
   wtop  = (Scr->Height - wh) / 2;

   if ((TMFont = OpenDiskFont( Font )) == NULL)
      return( -5 );

   if ((TMMenus = CreateMenus( TMNewMenu, GTMN_FrontPen, 0L, TAG_DONE )) == NULL)
      return( -3 );

   LayoutMenus( TMMenus, VisualInfo, TAG_DONE );

   if ((TMWnd = OpenWindowTags( NULL,

            WA_Left,        wleft,
            WA_Top,         wtop,
            WA_Width,       ww + CFont.OffX + Scr->WBorRight,
            WA_Height,      wh + CFont.OffY + Scr->WBorBottom,

            WA_IDCMP,       IDCMP_MENUPICK | IDCMP_CLOSEWINDOW | IDCMP_REFRESHWINDOW,

            WA_Flags,       WFLG_DRAGBAR | WFLG_DEPTHGADGET
              | WFLG_CLOSEGADGET | WFLG_SMART_REFRESH,

            WA_Title,       TMWdt,
            WA_ScreenTitle, "TestMenus ©2003:",
            WA_PubScreen,   Scr,
            WA_MinWidth,    67,
            WA_MinHeight,   21,
            WA_MaxWidth,    800,
            WA_MaxHeight,   600,
            
            TAG_DONE )) == NULL)
      return( -4 );

   SetMenuStrip( TMWnd, TMMenus );

   GT_RefreshWindow( TMWnd, NULL );

   return( 0L );
}

PRIVATE int TMCloseWindow( void )
{
   CloseTMWindow();
   
   return( FALSE );
}

PRIVATE int TMLoadMI( void )
{
   return( TRUE );
}

PRIVATE int TMQuitMI( void )
{
   return( TMCloseWindow() );
}

PRIVATE int TMRemoveItemMI( void )
{
   int i = 0;
   
   while (TMNewMenu[i].nm_Type != NM_END)
      i++; // Find end of list marker.
   
   i--; // go up one in the list.
   
   while (TMNewMenu[i].nm_Type == NM_IGNORE && TMNewMenu[i].nm_Type != NM_TITLE)
      i--; // Find first non-blank menu Item
   
   ClearMenuStrip( TMWnd );

   if (TMNewMenu[i].nm_Type != NM_TITLE)
      {
      TMNewMenu[i].nm_Type = NM_IGNORE;
      }
   else
      UserInfo( "No more menu items can be removed!", "USer ERROR:" );      

   if ((TMMenus = CreateMenus( TMNewMenu, GTMN_FrontPen, 0L, TAG_DONE )) == NULL)
      return( FALSE );

   LayoutMenus( TMMenus, VisualInfo, TAG_DONE );
      
   SetMenuStrip( TMWnd, TMMenus );

   return( TRUE );
}

PRIVATE int TMAddItemMI( void )
{
   int i = 0;
   
   ClearMenuStrip( TMWnd );

   while (TMNewMenu[i].nm_Type != NM_IGNORE && TMNewMenu[i].nm_Type != NM_END)
      i++;

   if (TMNewMenu[i].nm_Type != NM_END)
      {
      TMNewMenu[i].nm_Type     = NM_ITEM;
      TMNewMenu[i].nm_Label    = "Added a Menu Item!";
      TMNewMenu[i].nm_UserData = (APTR) TMBlank1MI;
      }
   else
      UserInfo( "No more menu Items can be added!", "User ERROR:" );   

   if ((TMMenus = CreateMenus( TMNewMenu, GTMN_FrontPen, 0L, TAG_DONE )) == NULL)
      return( FALSE );

   LayoutMenus( TMMenus, VisualInfo, TAG_DONE );
      
   SetMenuStrip( TMWnd, TMMenus );

   return( TRUE );
}

PRIVATE int TMBlank1MI( void )
{
   UserInfo( "You selected a new menu item!", "This is an Added MenuItem:" );

   return( TRUE );
}

PRIVATE int HandleTMIDCMP( void )
{
   struct IntuiMessage *m;
   struct MenuItem     *n;
   int                (*mfunc)( void );
   BOOL                 running = TRUE;

   while (running == TRUE)
      {
      if ((m = GT_GetIMsg( TMWnd->UserPort )) == NULL) 
         {
         (void) Wait( 1L << TMWnd->UserPort->mp_SigBit );

         continue;
         }

     CopyMem( ( char *) m, ( char *) &TMMsg, 
              (long) sizeof( struct IntuiMessage )
            );

     GT_ReplyIMsg( m );

      switch ( TMMsg.Class ) 
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( TMWnd );
            GT_EndRefresh( TMWnd, TRUE );
            break;

         case IDCMP_CLOSEWINDOW:
            running = TMCloseWindow();
            break;

            break;

         case IDCMP_MENUPICK:
            if (TMMsg.Code != MENUNULL)
               {
               n = ItemAddress( TMMenus, TMMsg.Code );

               if (n == NULL)
                  break;

               mfunc = (void *) (GTMENUITEM_USERDATA( n ));

               if (mfunc == NULL)
                  break;

               running = mfunc();
               }

            break;
         }
      }

   return( running );
}

PRIVATE void ShutdownProgram( void )
{
   CloseTMWindow();
   CloseDownScreen();

   CloseLibs();

   return;
}

PRIVATE int SetupProgram( void )
{
   if (OpenLibs() < 0)
      return( -1 );
      
   if (SetupScreen() < 0)
      {
      ShutdownProgram();

      return( -5 );
      }   

   if (OpenTMWindow() < 0)
      {
      ShutdownProgram();

      return( -6 );
      }   

   return( 0 );   
}

PUBLIC int main( int argc, char ** argv )
{
   if (SetupProgram() < 0)
      {
      return( IoErr() );
      }
      
   SetNotifyWindow( TMWnd );
   
   (void) HandleTMIDCMP();
   
   ShutdownProgram();
   
   return( RETURN_OK );
}
