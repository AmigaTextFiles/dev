/**********************************************************************
** CmdReq.c - Get a command string from the user & execute it.
**
** Functional Interface:
**
**   VISIBLE int HandleCommandReq( char *cmdbuf, char *cmdname );
**
** RETURNS:  0 for success, -1 for failure, -2 for abort.
**
**  GUI Designed by : Jim Steichen
***********************************************************************/

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

#define OkayBt   0
#define AbortBt  1
#define CmdStrGt 2

#define CR_CNT   3


IMPORT struct TextAttr topaz8;
IMPORT struct Screen   *Scr;
IMPORT UBYTE           *PubScreenName;
IMPORT APTR            VisualInfo;

PRIVATE struct Window       *CRWnd    = NULL;
PRIVATE struct Gadget       *CRGList  = NULL;
PRIVATE struct IntuiMessage  CRMsg;
PRIVATE struct Gadget       *CRGadgets[3];

PRIVATE UWORD  CRLeft   = 235;
PRIVATE UWORD  CRTop    = 160;
PRIVATE UWORD  CRWidth  = 405;
PRIVATE UWORD  CRHeight = 85;
PRIVATE UBYTE *CRWdt    = "Macro or Assemble Command:";

PRIVATE struct IntuiText CRIText[] = {

   2, 0, JAM1,91, 8, &topaz8, 
   (UBYTE *) "Enter Command string to execute:", NULL 
};

PRIVATE UWORD CRGTypes[] = {

   BUTTON_KIND,   BUTTON_KIND,   STRING_KIND
};

PRIVATE int OkayClicked( void );
PRIVATE int AbortClicked( void );
PRIVATE int CmdStringClicked( void );
 
PRIVATE struct NewGadget CRNGad[] = {

     5, 52,  80, 22, (UBYTE *) " _Execute",        NULL, OkayBt, 
   PLACETEXT_IN, NULL, (APTR) OkayClicked,

   324, 52,  68, 22, (UBYTE *) " _ABORT ",        NULL, AbortBt, 
   PLACETEXT_IN, NULL, (APTR) AbortClicked,

   130, 24, 263, 15, (UBYTE *) "Command String:", NULL, CmdStrGt, 
   PLACETEXT_LEFT, NULL, (APTR) CmdStringClicked
};

PRIVATE ULONG CRGTags[] = {

   (GT_Underscore), '_', (TAG_DONE),
   (GT_Underscore), '_', (TAG_DONE),
   (GA_TabCycle), FALSE, (GTST_MaxChars), 256, 
   (STRINGA_Justification), (GACT_STRINGCENTER), (TAG_DONE)
};

/* ------------------------------------------------------------- */

PRIVATE void CloseCRWindow( void )
{
   if (CRWnd) 
      {
      CloseWindow( CRWnd );
      CRWnd = NULL;
      }

   if (CRGList) 
      {
      FreeGadgets( CRGList );
      CRGList = NULL;
      }
   return;
}

PRIVATE char CRNIL[256], *CmdReqStr = &CRNIL[0];

#define EXECUTE_STRING 18

PRIVATE int OkayClicked( void )
{
   if (strlen( StrBfPtr( CRGadgets[CmdStrGt] )) > 0)
      {
      (void) strcpy( CmdReqStr, StrBfPtr( CRGadgets[ CmdStrGt ] ) );

      CloseCRWindow();

      return( (int) EXECUTE_STRING );
      }
   else
      return( (int) TRUE );
}

PRIVATE int AbortClicked( void )
{
   CloseCRWindow();

   return( (int) FALSE );
}

PRIVATE int CmdStringClicked( void )
{
   return( (int) TRUE );
}

PRIVATE void CRRender( void )
{
   UWORD offx, offy;

   offx = CRWnd->BorderLeft;
   offy = CRWnd->BorderTop;

   PrintIText( CRWnd->RPort, CRIText, offx, offy );

   return;
}

PRIVATE int OpenCRWindow( void )
{
   struct NewGadget ng;
   struct Gadget   *g;
   UWORD            lc, tc;
   UWORD            offx = Scr->WBorLeft, 
                    offy = Scr->WBorTop + Scr->RastPort.TxHeight + 1;

   if ((g = CreateContext( &CRGList )) == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < CR_CNT; lc++) 
      {
      CopyMem( (char *) &CRNGad[ lc ], (char *) &ng, 
               (long) sizeof( struct NewGadget )
             );

      ng.ng_VisualInfo = VisualInfo;
      ng.ng_TextAttr   = &topaz8;
      ng.ng_LeftEdge  += offx;
      ng.ng_TopEdge   += offy;

      CRGadgets[ lc ] = g = CreateGadgetA( (ULONG) CRGTypes[ lc ], 
                               g, 
                               &ng, 
                               (struct TagItem *) &CRGTags[ tc ] );

      while (CRGTags[ tc ] != TAG_DONE) 
         tc += 2;

      tc++;

      if (g == NULL)
         return( -2 );
      }

   if ((CRWnd = OpenWindowTags( NULL,

                    WA_Left,        CRLeft,
                    WA_Top,         CRTop,
                    WA_Width,       CRWidth,
                    WA_Height,      CRHeight + offy,
                    WA_IDCMP,       BUTTONIDCMP | STRINGIDCMP
                      | IDCMP_REFRESHWINDOW | IDCMP_VANILLAKEY,

                    WA_Flags,       WFLG_DRAGBAR | WFLG_DEPTHGADGET
                      | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,

                    WA_Gadgets,     CRGList,
                    WA_Title,       CRWdt,
                    TAG_DONE )
      ) == NULL)
      return( -4 );

   GT_RefreshWindow( CRWnd, NULL );
   CRRender();
   return( 0 );
}

PRIVATE int CRVanillaKey( int whichkey )
{
   int rval = TRUE;

   switch (whichkey)
      {
      case 'a':
      case 'A':
         rval = AbortClicked();
         break;

      case 'e':
      case 'E':
         rval = OkayClicked();
         break;
      }
         
   return( rval );
}

PRIVATE int HandleCRIDCMP( void )
{
   struct IntuiMessage *m;
   int                 (*func)();
   BOOL                running = TRUE;

   while (running == TRUE)
      {
      if ((m = GT_GetIMsg( CRWnd->UserPort )) == NULL) 
         {
         (void) Wait( 1L << CRWnd->UserPort->mp_SigBit );
         continue;
         }

      CopyMem( (char *) m, (char *) &CRMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (CRMsg.Class) 
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( CRWnd );
            CRRender();
            GT_EndRefresh( CRWnd, TRUE );
            break;

         case IDCMP_VANILLAKEY:
            running = CRVanillaKey( CRMsg.Code );
            break;
            
         case IDCMP_GADGETUP:
            func    = (void *) ((struct Gadget *)CRMsg.IAddress)->UserData;
            running = func();
            break;
         }
      }
   return( running );
}

VISIBLE int HandleCommandReq( char *cmdbuf, char *cmdname )
{
   char HCRNIL1[256], *t1 = &HCRNIL1[0];
   char HCRNIL2[256], *t2 = &HCRNIL2[0];

   if (cmdname != NULL)
      {
      (void) strcpy( t1, cmdname );
      (void) strcat( t1, " Command:" );
      CRWdt = t1;

      (void) strcpy( t2, cmdname );
      (void) strcat( t2, " String:" );
      CRIText[0].IText = t2;
      }
      
   if (OpenCRWindow() < 0)
      {
      fprintf( stderr, "problem in Opening Command Requester!\n" );

      (void) Handle_Problem( "Couldn't open Command Requester!", 
                             "Command Requester Problem:", NULL 
                           );
      return( -1 );
      }

   if (HandleCRIDCMP() == EXECUTE_STRING)
      {
      (void) strcpy( cmdbuf, CmdReqStr );

      return( 0 );
      }
   else
      return( -2 );  // User asked for abort! 
}

/* ------------------ END of CmdReq.c file -------------------------- */
