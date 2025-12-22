/****h* AmigaTalk/UserScriptReq.c [3.0] ********************************
*
* NAME
*    UserScriptReq.c
*
* DESCRIPTION
* 
* SYNOPSIS 
*    This is a GUI for getting the name & filename for a User Script
*    to be added to the AmigaTalk USER SCRIPTS menu.  It is only 
*    called from ATMenus.c functions.
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    Oct-02-2003 - Created this file.
*
* COPYRIGHT
*    UserScriptReq.c Oct-02-2003(C) by J.T. Steichen
*
* NOTES
*    FUNCTIONAL INTERFACE:
*       PUBLIC int getUserScript( char *ScriptName, char *FileName, int AddFlag );
*
*    $VER: UserScriptReq.c 3.0 (25-Oct-2004) by J.T. Steichen
************************************************************************
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

#include <utility/tagitem.h>
#include <dos/dostags.h>
#include <libraries/asl.h>

#include <graphics/displayinfo.h>
#include <graphics/gfxbase.h>

#ifdef __SASC

# include <clib/exec_protos.h>
# include <clib/intuition_protos.h>
# include <clib/gadtools_protos.h>
# include <clib/graphics_protos.h>
# include <clib/utility_protos.h>
# include <clib/diskfont_protos.h>

IMPORT struct IntuitionBase *IntuitionBase;
IMPORT struct GfxBase       *GfxBase;
IMPORT struct LocaleBase    *LocaleBase;

#else

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/intuition.h>
# include <proto/gadtools.h>
# include <proto/graphics.h>
# include <proto/utility.h>
# include <proto/diskfont.h>

IMPORT struct Library *IntuitionBase;
IMPORT struct Library *GfxBase;
IMPORT struct Library *LocaleBase;

IMPORT struct IntuitionIFace *IIntuition;
IMPORT struct LocaleIFace    *ILocale;
#endif


#include "FuncProtos.h"

#include "StringIndexes.h"

#include "CPGM:GlobalObjects/CommonFuncs.h"

#ifndef StrBfPtr
# define StrBfPtr( g ) (((struct StringInfo *)g->SpecialInfo)->Buffer)
#endif

#define ID_MenuStr      0
#define ID_FileNameStr  1
#define ID_FindBt       2
#define ID_OkayBt       3
#define ID_CancelBt     4

#define US_CNT          5

#define MenuStr_Gad     USGadgets[ ID_MenuStr ]
#define FileStr_Gad     USGadgets[ ID_FileNameStr ]

// ----------------------------------------------------

IMPORT struct Library       *GadToolsBase;
IMPORT struct TextFont      *ATFont;
IMPORT struct TextAttr      *Font;
IMPORT struct CompFont       CFont;

IMPORT struct Screen        *Scr;
IMPORT UBYTE                *PubScreenName;
IMPORT APTR                  VisualInfo;

IMPORT UBYTE                *ErrMsg;

// ----------------------------------------------------

PUBLIC  UBYTE *USWdt    = NULL;   // Visible to CatalogUserScript()
// ----------------------------------------------------

PRIVATE BOOL                 disableFind = FALSE;

PRIVATE struct Window       *USWnd   = NULL;
PRIVATE struct Gadget       *USGList = NULL;
PRIVATE struct Gadget       *USGadgets[ US_CNT ] = { NULL, };

PRIVATE struct IntuiMessage  USMsg = { 0, };

PRIVATE UWORD  USLeft   = 120;
PRIVATE UWORD  USTop    = 240;
PRIVATE UWORD  USWidth  = 555;
PRIVATE UWORD  USHeight = 130;

PRIVATE struct TextAttr helvetica13 = { "helvetica.font", 13, 0x00, 0x62 };

PUBLIC struct TagItem FileTags[] = { // Visible to CatalogUserScript()

   ASLFR_Window,          (ULONG) NULL,
   ASLFR_TitleText,       (ULONG) "Obtain a filename...",
   ASLFR_InitialHeight,   400,
   ASLFR_InitialWidth,    500,
   ASLFR_InitialTopEdge,  16,
   ASLFR_InitialLeftEdge, 100,
   ASLFR_PositiveText,    (ULONG) " OKAY! ",
   ASLFR_NegativeText,    (ULONG) " CANCEL! ",
   ASLFR_InitialPattern,  (ULONG) "#?",
   ASLFR_InitialFile,     (ULONG) "",
   ASLFR_InitialDrawer,   (ULONG) "AmigaTalk:",
   ASLFR_Flags1,          FRF_DOPATTERNS,
   ASLFR_Flags2,          FRF_REJECTICONS,
   ASLFR_SleepWindow,     1,
   ASLFR_PrivateIDCMP,    1,
   TAG_END 
};

PRIVATE UWORD USGTypes[] = {

   STRING_KIND, STRING_KIND, BUTTON_KIND,
   BUTTON_KIND, BUTTON_KIND,
};

PRIVATE int MenuStrClicked(     void );
PRIVATE int FileNameStrClicked( void );
PRIVATE int FindBtClicked(      void );
PRIVATE int OkayBtClicked(      void );
PRIVATE int CancelBtClicked(    void );

PUBLIC struct NewGadget USNGad[ US_CNT ] = { // Visible to CatalogUserScript()

   136,  29, 301,  20, "Script Menu Name:", NULL,
   ID_MenuStr, PLACETEXT_LEFT, NULL, (APTR) MenuStrClicked,

   136,  57, 301,  20, "Script File Name:", NULL,
   ID_FileNameStr, PLACETEXT_LEFT, NULL, (APTR) FileNameStrClicked,

   446,  57,  96,  21, "Find _File..", NULL,
   ID_FindBt, PLACETEXT_IN, NULL, (APTR) FindBtClicked,

    41,  95,  96,  21, "_OKAY!", NULL,
   ID_OkayBt, PLACETEXT_IN, NULL, (APTR) OkayBtClicked,

   364,  95,  96,  21, "_CANCEL!", NULL,
   ID_CancelBt, PLACETEXT_IN, NULL, (APTR) CancelBtClicked,
};

PRIVATE ULONG USGTags[] = {

   GTST_MaxChars, 256, TAG_DONE,
   GTST_MaxChars, 256, TAG_DONE,

   GT_Underscore, '_', TAG_DONE,
   GT_Underscore, '_', TAG_DONE,
   GT_Underscore, '_', TAG_DONE,
};

// ----------------------------------------------------------------

PRIVATE void CloseUSWindow( void )
{
   if (USWnd) // != NULL)
      {
      CloseWindow( USWnd );

      USWnd = NULL;
      }

   if (USGList) // != NULL)
      {
      FreeGadgets( USGList );

      USGList = NULL;
      }

   return;
}

// ----------------------------------------------------------------

IMPORT UBYTE *MenuScriptName;      // In ATMenus.c
IMPORT UBYTE *MenuScriptFileName;

#define MENU_STRING StrBfPtr( MenuStr_Gad )

PRIVATE int MenuStrClicked( void )
{
   // Here is where we get what we came for:

   if (StringLength( MENU_STRING ) > 0)
      StringNCopy( MenuScriptName, MENU_STRING, 80 );

   return( TRUE );
}

#define FILE_NAME   StrBfPtr( FileStr_Gad )

PRIVATE int FindBtClicked( void )
{
   int rval = 0;
   
   SetTagItem( &FileTags[0], ASLFR_Window, (ULONG) USWnd );
   
   if ((rval = FileReq( MenuScriptFileName, &FileTags[0] )) > 0)
      {
      GT_SetGadgetAttrs( FileStr_Gad, USWnd, NULL, 
                         GTST_String, MenuScriptFileName, TAG_DONE
                       );
      }
   else
      {
      GT_SetGadgetAttrs( FileStr_Gad, USWnd, NULL, 
                         GTST_String, "", TAG_DONE
                       );
      }
         
   return( TRUE );
}

PRIVATE int FileNameStrClicked( void )
{
   // Here is where we get what we came for:

   if (StringLength( FILE_NAME ) > 0)
      StringNCopy( MenuScriptFileName, FILE_NAME, 256 );
   else
      return( FindBtClicked() );
      
   return( TRUE );
}

PRIVATE int OkayBtClicked( void )
{
   if (StringLength( MENU_STRING ) < 1)
      {
      UserInfo( USRCMsg( MSG_NEED_MENU_NAME_USR ), 
                USRCMsg( MSG_RQTITLE_USER_ERROR_USR ) 
              );
              
      return( TRUE );
      }

   if (disableFind == FALSE)      
      {
      if (StringLength( FILE_NAME ) < 1)
         {
         UserInfo( USRCMsg( MSG_NEED_FILE_NAME_USR ), 
                   USRCMsg( MSG_RQTITLE_USER_ERROR_USR ) 
                 );
              
         return( TRUE );
         }
      }

   CloseUSWindow();

   return( FALSE );
}

#define USER_CANCELLED  5

PRIVATE int returnValue = RETURN_OK;

PRIVATE int CancelBtClicked( void )
{
   *MenuScriptName     = '\0';
   *MenuScriptFileName = '\0';
   
   CloseUSWindow();

   returnValue = USER_CANCELLED;
      
   return( FALSE );
}

// ----------------------------------------------------------------

PRIVATE int OpenUSWindow( void )
{
   struct NewGadget  ng;
   struct Gadget    *g;
   UWORD             lc, tc;
   UWORD             wleft, wtop, ww, wh;

   ComputeFont( Scr, Font, &CFont, USWidth, USHeight );

   ww = ComputeX( CFont.FontX, USWidth  );
   wh = ComputeY( CFont.FontY, USHeight );

   wleft = (Scr->Width  - USWidth ) / 2;
   wtop  = (Scr->Height - USHeight) / 2;

   if (!(g = CreateContext( &USGList ))) // == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < US_CNT; lc++)
      {
      CopyMem( (char *) &USNGad[ lc ], (char *) &ng,
               (long) sizeof( struct NewGadget )
             );

      ng.ng_VisualInfo = VisualInfo;
      ng.ng_TextAttr   = &helvetica13;
      ng.ng_LeftEdge   = CFont.OffX + ComputeX( CFont.FontX, ng.ng_LeftEdge );
      ng.ng_TopEdge    = CFont.OffY + ComputeY( CFont.FontY, ng.ng_TopEdge );

      USGadgets[ lc ] = g
                      = CreateGadgetA( (ULONG) USGTypes[ lc ],
                                       g,
                                       &ng,
                                       (struct TagItem *) &USGTags[ tc ]
                                     );

      while (USGTags[ tc ] != TAG_DONE)
         tc += 2;

      tc++;

      if (!g) // == NULL)
         return( -2 );
      }

   if (!(USWnd = OpenWindowTags( NULL,

         WA_Left,          wleft,
         WA_Top,           wtop,
         WA_Width,         ww + CFont.OffX + Scr->WBorRight,
         WA_Height,        wh + CFont.OffY + Scr->WBorBottom,

         WA_IDCMP,         STRINGIDCMP | BUTTONIDCMP | 
           IDCMP_VANILLAKEY | IDCMP_REFRESHWINDOW,

         WA_Flags,         WFLG_ACTIVATE | WFLG_DRAGBAR | WFLG_DEPTHGADGET
           | WFLG_RMBTRAP,

         WA_Gadgets,       USGList,
         WA_Title,         USWdt,
         WA_CustomScreen,  Scr,
         TAG_DONE ))) // == NULL)
      {
      return( -4 );
      }

   GT_RefreshWindow( USWnd, NULL );

   return( 0 );
}


PRIVATE int USVanillaKey( int whichKey )
{
   int rval = TRUE;

   switch (whichKey)
      {
      case 'f':
      case 'F':
         if (disableFind == FALSE)
            rval = FindBtClicked();
   
         break;
         
      case 'o':
      case 'O':
         rval = OkayBtClicked();
         break;
         
      case 'c':
      case 'C':
         rval = CancelBtClicked();
         break;

      default:
         break;

      }

   return( rval );
}


PRIVATE int HandleUSIDCMP( void )
{
   struct IntuiMessage *m;
   int                (*func)( void );
   BOOL                 running = TRUE;

   while (running == TRUE)
      {
      if (!(m = GT_GetIMsg( USWnd->UserPort ))) // == NULL) 
         {
         (void) Wait( 1L << USWnd->UserPort->mp_SigBit );

         continue;
         }

      CopyMem( (char *) m, (char *) &USMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (USMsg.Class)
         {
         case IDCMP_GADGETUP:
            func = (int (*)( void )) ((struct Gadget *)USMsg.IAddress)->UserData;

            if (func) // != NULL)
               running = func();

            break;

         case IDCMP_VANILLAKEY:
            running = USVanillaKey( USMsg.Code );
            break;

         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( USWnd );

            GT_EndRefresh( USWnd, TRUE );

            break;
         }
      }

   return( running );
}

// ----------------------------------------------------------------

PRIVATE void ShutdownUS_Req( void )
{
   CloseUSWindow();

   return;
}

PRIVATE int SetupUS_Req( char *script, char *file )
{
   int rval = RETURN_OK;

   if (OpenUSWindow() < 0)
      {
      rval = ERROR_ON_OPENING_WINDOW;

      ShutdownUS_Req();

      goto exitSetup;
      }

   if (StringLength( script ) > 0)
      GT_SetGadgetAttrs( MenuStr_Gad, USWnd, NULL, GTST_String, script, TAG_DONE );

   if (StringLength( file ) > 0)
      GT_SetGadgetAttrs( FileStr_Gad, USWnd, NULL, GTST_String, file, TAG_DONE );
   
exitSetup:

   return( rval );
}

PUBLIC int getUserScript( char *ScriptName, char *FileName, int AddFlag )
{
   IMPORT struct Window *ATWnd;
   
   int error = RETURN_OK;

   if (!Scr) // == NULL)
      Scr = GetActiveScreen(); // Should never happen!
      
   if ((error = SetupUS_Req( ScriptName, FileName )) != RETURN_OK)
      {
      return( error );
      }
    
   SetNotifyWindow( USWnd );

   if (AddFlag == FALSE)
      {
      // User wants to remove an item, so disable these...
      GT_SetGadgetAttrs( FileStr_Gad, USWnd, NULL, GA_Disabled, TRUE, TAG_DONE );

      GT_SetGadgetAttrs( USGadgets[ ID_FindBt ], USWnd, NULL, GA_Disabled, TRUE, TAG_DONE );
      
      disableFind = TRUE;
      }
      
   (void) HandleUSIDCMP();

   ShutdownUS_Req();

   SetNotifyWindow( ATWnd );

   return( returnValue );
}

/* --------------- END of UserScriptReq.c file! ------------------ */
