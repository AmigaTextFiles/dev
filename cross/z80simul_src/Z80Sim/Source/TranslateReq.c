/****h* Z80Simulator/TranslateReq.c [2.5] ****************************
*
* NAME
*    TranslateReq.c
*
* DESCRIPTION
*    The Translate file requester code for the Z80 Simulator program.
*
* RETURNS
*    0 for success, -1 for failure.
*
* Functional Interface:
*
*   PUBLIC int HandleTranslateReq( void );
*
* GUI Designed by : Jim Steichen
**********************************************************************
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
#include <libraries/asl.h>

#include <graphics/displayinfo.h>
#include <graphics/gfxbase.h>

#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/graphics_protos.h>
#include <clib/utility_protos.h>
#include <clib/asl_protos.h>

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "FileReqTags.h"

#define StrBfPtr( g ) (((struct StringInfo *)g->SpecialInfo)->Buffer)

#define OKAYBT       0
#define ABORTBT      1
#define InFileStr    2
#define IN_ASL       3
#define OutFileStr   4
#define OUT_ASL      5

#define XL_CNT       6

/* ----------------------------------- Located in Z80SimGTGUI.c file */
IMPORT struct TextAttr topaz8;
IMPORT struct Screen   *Scr;
IMPORT UBYTE           *PubScreenName;
IMPORT APTR            VisualInfo;
/* ----------------------------------- */

PRIVATE struct Window       *XLWnd    = NULL;
PRIVATE struct Gadget       *XLGList  = NULL;
PRIVATE struct IntuiMessage  XLMsg;
PRIVATE struct Gadget       *XLGadgets[6];

PRIVATE UWORD  XLLeft   = 220;
PRIVATE UWORD  XLTop    = 175;
PRIVATE UWORD  XLWidth  = 410;
PRIVATE UWORD  XLHeight = 120;
PRIVATE UBYTE *XLWdt    = "Z80Simulator Translate:";


PRIVATE struct IntuiText XLIText[] = {

   2, 0, JAM1,124, 9, &topaz8, 
   (UBYTE *) "(Z80XL <IntelInput >Z80.cfg)", NULL 
};

PRIVATE UWORD XLGTypes[] = {

   BUTTON_KIND,   BUTTON_KIND,
   STRING_KIND,   BUTTON_KIND,
   STRING_KIND,   BUTTON_KIND
};


PRIVATE int OkayClicked( void );
PRIVATE int AbortClicked( void );
PRIVATE int InFileClicked( void );
PRIVATE int InASLClicked( void );
PRIVATE int OutFileClicked( void );
PRIVATE int OutASLClicked( void );

PRIVATE struct NewGadget XLNGad[] = {

     8, 85, 110, 22, (UBYTE *)    " _TRANSLATE ", NULL, OKAYBT, 
   PLACETEXT_IN, NULL, (APTR) OkayClicked,
   
   320, 85,  70, 22, (UBYTE *)        " _ABORT ", NULL, ABORTBT, 
   PLACETEXT_IN, NULL, (APTR) AbortClicked,
   
   130, 24, 200, 15, (UBYTE *) "Intel FileName:", NULL, InFileStr, 
   PLACETEXT_LEFT, NULL, (APTR) InFileClicked,
   
   340, 24,  50, 14, (UBYTE *)           " ASL ", NULL, IN_ASL, 
   PLACETEXT_IN, NULL, (APTR) InASLClicked,
   
   129, 51, 200, 15, (UBYTE *)  ".cfg FileName:", NULL, OutFileStr, 
   PLACETEXT_LEFT, NULL, (APTR) OutFileClicked,
   
   340, 51,  50, 14, (UBYTE *)           " ASL ", NULL, OUT_ASL, 
   PLACETEXT_IN, NULL, (APTR) OutASLClicked
};


PRIVATE ULONG XLGTags[] = {

   (GT_Underscore), '_', (TAG_DONE),
   (GT_Underscore), '_', (TAG_DONE),

   (GA_TabCycle), FALSE, (GTST_MaxChars), 256, 
   (STRINGA_Justification), (GACT_STRINGCENTER), (TAG_DONE),
   
   (TAG_DONE), /* InASL button  */
   
   (GA_TabCycle), FALSE, (GTST_MaxChars), 256, 
   (STRINGA_Justification), (GACT_STRINGCENTER), (TAG_DONE),
   
   (TAG_DONE)  /* OutASL button */
};

/* -------------------------------------------------------------- */

IMPORT char InFileName[], OutFileName[];

PRIVATE int ValidInput = FALSE, ValidOutput = FALSE;


PRIVATE int InFileClicked( void )
{
   if (strlen( StrBfPtr( XLGadgets[ InFileStr ] )) > 0)
      ValidInput = TRUE;

   return( (int) TRUE );
}

PRIVATE int OutFileClicked( void )
{
   if (strlen( StrBfPtr( XLGadgets[ OutFileStr ] )) > 0)
      ValidOutput = TRUE;

   return( (int) TRUE );
}

IMPORT char *File_Req( struct Window *, int );

PRIVATE int InASLClicked( void )
{
   char fname[256] = "";

   SetTagItem( LoadTags, ASLFR_Window, (ULONG) XLWnd );

   SetTagItem( LoadTags, ASLFR_TitleText, 
                         (ULONG) "Z80XLate: Get Intel Input File..." 
             );

   if (FileReq( fname, LoadTags ) > 1)
      {
      (void) strcpy( &InFileName[0], fname );

      GT_SetGadgetAttrs( XLGadgets[ InFileStr], XLWnd, NULL,
                         GTST_String, &InFileName[0], TAG_END
                       );
      ValidInput = TRUE;
      }

   return( (int) TRUE );
}

PRIVATE int OutASLClicked( void )
{
   char fname[256] = "";

   SetTagItem( LoadTags, ASLFR_Window, (ULONG) XLWnd );

   SetTagItem( LoadTags, ASLFR_TitleText, 
                         (ULONG) "Z80XLate: Get .cfg Output File..." 
             );

   if (FileReq( fname, LoadTags ) > 1)
      {
      (void) strcpy( &OutFileName[0], fname );

      GT_SetGadgetAttrs( XLGadgets[ OutFileStr], XLWnd, NULL,
                         GTST_String, &OutFileName[0], TAG_END
                       );

      ValidOutput = TRUE;
      }

   return( (int) TRUE );
}

PRIVATE void CloseXLWindow( void )
{
   if (XLWnd != NULL) 
      {
      CloseWindow( XLWnd );
      XLWnd = NULL;
      }

   if (XLGList != NULL) 
      {
      FreeGadgets( XLGList );
      XLGList = NULL;
      }
 
   return;
}

#define TRANSLATE_FILE 16

PRIVATE int OkayClicked( void )
{
   if (ValidInput == FALSE)
      {
      (void) Handle_Problem( "Please enter an Input filename!", 
                             "Translation Problem:", NULL 
                           );
      return( (int) TRUE );
      }

   if (ValidOutput == FALSE)
      {
      (void) Handle_Problem( "Please enter an Output filename!", 
                             "Translation Problem:", NULL 
                           );
      return( (int) TRUE );
      }

   (void) strcpy( &InFileName[0],  StrBfPtr( XLGadgets[ InFileStr  ] ) );
   (void) strcpy( &OutFileName[0], StrBfPtr( XLGadgets[ OutFileStr ] ) );

   CloseXLWindow();

   return( TRANSLATE_FILE );
}

PRIVATE int AbortClicked( void )
{
   InFileName[0]  = '\0';
   OutFileName[0] = '\0';

   CloseXLWindow();

   return( (int) FALSE );
}


PRIVATE void XLRender( void )
{
   UWORD offx, offy;

   offx = XLWnd->BorderLeft;
   offy = XLWnd->BorderTop;

   PrintIText( XLWnd->RPort, XLIText, offx, offy );

   return;
}

PRIVATE int OpenXLWindow( void )
{
   struct NewGadget ng;
   struct Gadget    *g;
   UWORD            lc, tc;
   UWORD            offx = Scr->WBorLeft, 
                    offy = Scr->WBorTop + Scr->RastPort.TxHeight + 1;

   if ((g = CreateContext( &XLGList )) == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < XL_CNT; lc++) 
      {
      CopyMem( (char *) &XLNGad[ lc ], (char *) &ng, 
               (long) sizeof( struct NewGadget )
             );

      ng.ng_VisualInfo = VisualInfo;
      ng.ng_TextAttr   = &topaz8;
      ng.ng_LeftEdge  += offx;
      ng.ng_TopEdge   += offy;

      XLGadgets[ lc ] = g = CreateGadgetA( (ULONG) XLGTypes[ lc ], 
                              g, 
                              &ng, 
                              (struct TagItem *) &XLGTags[ tc ] );

      while (XLGTags[ tc ] != TAG_DONE) 
         tc += 2;
      
      tc++;

      if (g == NULL)
         return( -2 );
      }

   if ((XLWnd = OpenWindowTags( NULL,

                   WA_Left,        XLLeft,
                   WA_Top,         XLTop,
                   WA_Width,       XLWidth,
                   WA_Height,      XLHeight + offy,

                   WA_IDCMP,       BUTTONIDCMP | STRINGIDCMP 
                     | IDCMP_GADGETUP | IDCMP_REFRESHWINDOW
                     | IDCMP_VANILLAKEY,

                   WA_Flags,       WFLG_DRAGBAR | WFLG_DEPTHGADGET
                     | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,

                   WA_Gadgets,     XLGList,
                   WA_Title,       XLWdt,
                   TAG_DONE )
      ) == NULL)
      return( -4 );

   GT_RefreshWindow( XLWnd, NULL );
   XLRender();

   return( 0 );
}

PRIVATE int XLVanillaKey( int whichkey )
{
   int rval = TRUE;
   
   switch (whichkey)
      {
      case 't':
      case 'T':
         rval = OkayClicked();
         break;

      case 'a':
      case 'A':
         rval = AbortClicked();
         break;
      }
      
   return( rval );
}

PRIVATE int HandleXLIDCMP( void )
{
   struct IntuiMessage *m;
   int                 (*func)();
   BOOL                running = TRUE;

   while (running == TRUE)
      {
      if ((m = GT_GetIMsg( XLWnd->UserPort )) == NULL) 
         {
         (void) Wait( 1L << XLWnd->UserPort->mp_SigBit );
         continue;
         }

      CopyMem( (char *) m, (char *) &XLMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (XLMsg.Class) 
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( XLWnd );
            XLRender();
            GT_EndRefresh( XLWnd, TRUE );
            break;

         case IDCMP_VANILLAKEY:
            running = XLVanillaKey( XLMsg.Code );
            break;
            
         case IDCMP_GADGETUP:
            func = (void *) ((struct Gadget *)XLMsg.IAddress)->UserData;
            
            if (func != NULL)
               running = func();
            
            break;
         }
      }

   return( running );
}


PUBLIC int HandleTranslateReq( void )
{
   if (OpenXLWindow() < 0)
      {
      fprintf( stderr, "problem in Opening Translate Requester!\n" );

      (void) Handle_Problem( "Couldn't open Translate Requester!", 
                             "Translate Requester Problem:", NULL 
                           );
      return( -1 );
      }

   if (HandleXLIDCMP() == TRANSLATE_FILE)
      {
      return( TRANSLATE_FILE );
      }

   return( 0 );
}

/* ---------------- END of TranslateReq.c file ------------------------ */
