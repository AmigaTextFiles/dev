/****h* LibraryInterceptor/LibraryInterceptor.c [1.2] ******************
*
* NAME
*    LibraryInterceptor
*
* DESCRIPTION
*    This program waits for any calls to OpenLibrary() & then shows
*    a GUI that allows the user to change the name or version of
*    the Library that's to be opened.  The biggest bug in this code
*    was NOT specifying the register assignments for the arguments to
*    NewFunction().
*
* HISTORY
*    21-Feb-2001 Program now runs correctly.
*
* NOTES
*    GUI Designed by : Jim Steichen
************************************************************************
*
*/

#include <string.h>

#include <exec/execbase.h>
#include <exec/types.h>

#include <AmigaDOSErrs.h>

#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/gadgetclass.h>

#include <libraries/gadtools.h>

#include <graphics/displayinfo.h>
#include <graphics/gfxbase.h>

#include <workbench/workbench.h>
#include <workbench/startup.h>

#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/graphics_protos.h>
#include <clib/utility_protos.h>
#include <clib/diskfont_protos.h>

#include "CPGM:GlobalObjects/CommonFuncs.h"

#define StrBfPtr( g ) (((struct StringInfo *)g->SpecialInfo)->Buffer)
#define IntBfPtr( g ) (((struct StringInfo *)g->SpecialInfo)->LongInt)

#define LibNameStr    0
#define LibVersionInt 1
#define OpenLibBt     2
#define RestoreBt     3
#define KillBt        4

#define LI_CNT        5

#define NAMEGADGET    LIGadgets[ LibNameStr ]
#define VERSIONGADGET LIGadgets[ LibVersionInt ]

#define LIBRARYNAME    StrBfPtr( NAMEGADGET )
#define LIBRARYVERSION IntBfPtr( VERSIONGADGET )

IMPORT struct WBStartup *_WBenchMsg;
IMPORT struct Library   *SysBase;

PRIVATE char ver[] = "$VER: LibraryInterceptor 1.2 (21-Feb-2001) by J.T. Steichen";

struct IntuitionBase *IntuitionBase;
struct GfxBase       *GfxBase;
struct Library       *GadToolsBase;
struct Library       *Exec_Base = NULL;

// ----------------------------------------------------------------- 

#define LVO_OpenLibrary 0xFFFFFDD8  // 0xFFFFFDD8 == -552

PUBLIC  LONG OldLibraryVector = NULL;

PRIVATE BOOL ReadyToExit      = FALSE;

PRIVATE UBYTE InitialName[256] = { 0, };
PRIVATE long  InitialVersion   = 0L;

// -----------------------------------------------------------------

PRIVATE struct Screen       *Scr     = NULL;
PRIVATE struct Window       *LIWnd   = NULL;
PRIVATE struct Gadget       *LIGList = NULL;
PRIVATE struct IntuiMessage  LIMsg;
PRIVATE struct Gadget       *LIGadgets[ LI_CNT ];

PRIVATE struct TextFont *LIFont = NULL;
PRIVATE struct CompFont  CFont  = { 0, };
PRIVATE struct TextAttr  Attr   = { 0, };
PRIVATE struct TextAttr *Font   = NULL;

PRIVATE UBYTE *PubScreenName = "Workbench";
PRIVATE APTR   VisualInfo    = NULL;

PRIVATE UWORD  LILeft   = 100;
PRIVATE UWORD  LITop    = 16;
PRIVATE UWORD  LIWidth  = 440;
PRIVATE UWORD  LIHeight = 112;

PRIVATE UBYTE *LIWdt    = "Library Interceptor ©1999-2001:";
PRIVATE UBYTE *ScrTitle = "Library Interceptor ©1999-2001 by J.T. Steichen";
PRIVATE UBYTE *email    = "jimbot@rconnect.com";

PRIVATE UWORD LIGTypes[] = {

   STRING_KIND, INTEGER_KIND, BUTTON_KIND,
   BUTTON_KIND, BUTTON_KIND
};

PRIVATE int LibNameStrClicked(    void );
PRIVATE int LibVersionIntClicked( void );
PRIVATE int OpenLibBtClicked(     void );
PRIVATE int RestoreBtClicked(     void );
PRIVATE int KillBtClicked(        void );

PRIVATE struct NewGadget LINGad[] = {

    46, 23, 251, 17, (UBYTE *) "Library Name:",     NULL, LibNameStr, 
   PLACETEXT_ABOVE, NULL, (APTR) LibNameStrClicked,
   
   149, 62,  41, 17, (UBYTE *) "Library Version:",  NULL, LibVersionInt, 
   PLACETEXT_ABOVE, NULL, (APTR) LibVersionIntClicked,
   
    10, 84, 101, 17, (UBYTE *) "_Open Library",     NULL, OpenLibBt, 
   PLACETEXT_IN, NULL, (APTR) OpenLibBtClicked,

   119, 84, 120, 17, (UBYTE *) "_Restore Parm's",   NULL, RestoreBt, 
   PLACETEXT_IN, NULL, (APTR) RestoreBtClicked,

   245, 84, 150, 17, (UBYTE *) "_Kill Interceptor", NULL, KillBt, 
   PLACETEXT_IN, NULL, (APTR) KillBtClicked
};

PRIVATE ULONG LIGTags[] = {

   GTST_MaxChars, 256, STRINGA_Justification, GACT_STRINGCENTER, TAG_DONE,

   GTIN_Number, 0, GTIN_MaxChars, 10, 
   STRINGA_Justification, GACT_STRINGCENTER, TAG_DONE,

   GT_Underscore, '_', TAG_DONE,
   GT_Underscore, '_', TAG_DONE,
   GT_Underscore, '_', TAG_DONE
};

// ----------------------------------------------------------------

PRIVATE int SetupScreen( void )
{
   Font = &Attr;

   if ((Scr = LockPubScreen( PubScreenName )) == NULL)
      return( -1 );

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

PRIVATE int OpenLIWindow( void )
{
   struct NewGadget  ng;
   struct Gadget    *g;
   UWORD             lc, tc;
   UWORD             wleft = LILeft, wtop = LITop, ww, wh;

   if (LIWnd != NULL)    // LIWnd already opened!
      goto SkipOpening;
      
   ComputeFont( Scr, Font, &CFont, LIWidth, LIHeight );

   ww = ComputeX( CFont.FontX, LIWidth  );
   wh = ComputeY( CFont.FontY, LIHeight );

   if ((wleft + ww + CFont.OffX + Scr->WBorRight) > Scr->Width) 
      wleft = Scr->Width - ww;

   if ((wtop + wh + CFont.OffY + Scr->WBorBottom) > Scr->Height) 
      wtop = Scr->Height - wh;

   if ((LIFont = OpenDiskFont( Font )) == NULL)
      return( -5 );

   if ((g = CreateContext( &LIGList )) == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < LI_CNT; lc++) 
      {
      CopyMem( (char *) &LINGad[ lc ], (char *) &ng, 
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

      LIGadgets[ lc ] = g = CreateGadgetA( (ULONG) LIGTypes[ lc ], 
                              g, 
                              &ng, 
                              (struct TagItem *) &LIGTags[ tc ] );

      while (LIGTags[ tc ]) 
         tc += 2;

      tc++;
      
      if (NOT g)
         return( -2 );
      }

   if ((LIWnd = OpenWindowTags( NULL,

                  WA_Left,        wleft,
                  WA_Top,         wtop,
                  WA_Width,       ww + CFont.OffX + Scr->WBorRight,
                  WA_Height,      wh + CFont.OffY + Scr->WBorBottom,

                  WA_IDCMP,       STRINGIDCMP | INTEGERIDCMP 
                    | BUTTONIDCMP | IDCMP_VANILLAKEY
                    | IDCMP_REFRESHWINDOW,

                  WA_Flags,       WFLG_DRAGBAR | WFLG_DEPTHGADGET
                    | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,

                  WA_Gadgets,     LIGList,
                  WA_Title,       LIWdt,
                  WA_ScreenTitle, ScrTitle,
                  TAG_DONE )) == NULL)
      return( -4 );

SkipOpening:

   GT_RefreshWindow( LIWnd, NULL );

   return( 0 );
}


PRIVATE int LibNameStrClicked( void )
{
   return( (int) TRUE );
}

PRIVATE int LibVersionIntClicked( void )
{
   return( (int) TRUE );
}

PRIVATE void CloseLIWindow( void )
{
   if (LIWnd != NULL) 
      {
      CloseWindow( LIWnd );
      LIWnd = NULL;
      }

   if (LIGList != NULL) 
      {
      FreeGadgets( LIGList );
      LIGList = NULL;
      }

   if (LIFont != NULL) 
      {
      CloseFont( LIFont );
      LIFont = NULL;
      }

   return;
}

PRIVATE int OpenLibBtClicked( void )
{
   strcpy( &InitialName[0], LIBRARYNAME );
   
   InitialVersion = LIBRARYVERSION;
   
   CloseLIWindow();
   return( (int) FALSE );
}

/****i* RestoreBtClicked() *********************************************
*
* NAME
*    RestoreBtClicked()
*
* DESCRIPTION
*    Place stored library name & version back into the data entry
*    gadgets.
************************************************************************
*
*/

PRIVATE int RestoreBtClicked( void )
{
   GT_SetGadgetAttrs( NAMEGADGET, LIWnd, NULL,
                      GTST_String, (STRPTR) &InitialName[0],
                      TAG_DONE
                    );

   GT_SetGadgetAttrs( VERSIONGADGET, LIWnd, NULL,
                      GTIN_Number, InitialVersion, 
                      TAG_DONE
                    );
   
   return( (int) TRUE );
}

PRIVATE int KillBtClicked( void )
{
   ReadyToExit = TRUE; // Rest of program will now know to shut down.

   return( OpenLibBtClicked() );
}

PRIVATE void AboutProgram( void )
{
   char m[256], *msg   = &m[0];
   char t[80],  *title = &t[0];

   if (GetProgramName( msg, 255L ) == 0)
      strcpy( title, "About LibraryInterceptor:" );
   else
      sprintf( title, "About %s:", msg );   

   sprintf( msg, "This program allows the user to change Library\n"
                 "parameters before a Library gets opened.\n"
                 "my e-mail:  %s", email 
          );


   SetReqButtons( "OKAY" );
   (void) Handle_Problem( msg, title, NULL );
   SetReqButtons( "CONTINUE|ABORT!" );
   
   return;
}

PRIVATE int LIVanillaKey( int whichkey )
{
   int rval = TRUE;
   
   switch (whichkey)
      {
      case 'o':
      case 'O':
         rval = OpenLibBtClicked();
         break;
         
      case 'r':
      case 'R':
         rval = RestoreBtClicked();
         break;
      
      case 'k':
      case 'K':
      case 'x':
      case 'X':
      case 'q':
      case 'Q':
         rval = KillBtClicked();
         break;

      case 'i':
      case 'I':
         AboutProgram();
         break;
          
      default:
         break;      
      }

   return( rval );
}

PRIVATE void ShutdownProgram( void )
{
   CloseLIWindow();
   CloseDownScreen();
   CloseLibs();

   if (Exec_Base != NULL)
      {
      CloseLibrary( Exec_Base );
      Exec_Base = NULL;
      }

   return;
}

PRIVATE int HandleLIIDCMP( void )
{
   struct IntuiMessage  *m;
   int                 (*func)( void );
   BOOL                  running = TRUE;

   while (running == TRUE)
      {
      if ((m = GT_GetIMsg( LIWnd->UserPort )) == NULL) 
         {
         (void) Wait( 1L << LIWnd->UserPort->mp_SigBit );
         continue;
         }

      CopyMem( (char *) m, (char *) &LIMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (LIMsg.Class) 
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( LIWnd );
            GT_EndRefresh( LIWnd, TRUE );
            break;

         case IDCMP_VANILLAKEY:
            running = LIVanillaKey( LIMsg.Code );
            break;

         case IDCMP_GADGETUP:
            func = (void *) ((struct Gadget *)LIMsg.IAddress)->UserData;
            if (func != NULL)
               running = func();
            
            break;
         }
      }

   if (ReadyToExit == TRUE)
      {
      running = FALSE;
      }

   return( running );
}

// ------------------------------------------------------------------


typedef __asm struct Library *(*FPTR)( register __a1 UBYTE *, 
                                       register __d0 long 
                                     );

PUBLIC __saveds __asm struct Library

       *NewFunction( register __a1 UBYTE *libname, 
                     register __d0 long   libversion 
                   )
{
   FPTR            fptr = NULL;
   struct Library *ptr  = NULL;
   int             chk  = TRUE;

   fptr = (FPTR) OldLibraryVector;

#  ifdef DEBUG
   fprintf( stderr, "fptr == 0x%08LX\n", fptr );   
#  endif

   if (LIWnd == NULL)
      {
      if (OpenLIWindow() < 0)
         {
         ShutdownProgram();
         ReadyToExit = TRUE;
      
         ptr = fptr( libname, libversion );
         return( ptr );
         }   

      strncpy( &InitialName[0], libname, 255 );
      InitialVersion = libversion;

      GT_SetGadgetAttrs( NAMEGADGET, LIWnd, NULL,
                         GTST_String, (STRPTR) &InitialName[0],
                         TAG_DONE
                       );

      GT_SetGadgetAttrs( VERSIONGADGET, LIWnd, NULL,
                         GTIN_Number, InitialVersion, 
                         TAG_DONE
                       );
   
      SetNotifyWindow( LIWnd );
   
      chk = HandleLIIDCMP();
      ptr = fptr( &InitialName[0], InitialVersion );
      }
   else
      ptr = fptr( libname, libversion ); // ??????????????

   return( ptr );
}

// ----------------------------------------------------------------

PRIVATE int SetupProgram( void )
{
   if (OpenLibs() < 0)
      return( -1 );

   if ((Exec_Base = OpenLibrary( "exec.library", 39L )) == NULL)
      {
      CloseLibs();
      return( -1 );
      }      

   if (SetupScreen() < 0)
      {
      CloseLibs();
      CloseLibrary( Exec_Base );
      Exec_Base = NULL;
      return( -2 );
      }   

   return( 0 );   
}


PRIVATE void SFReplace( void )
{
#  ifdef DEBUG
   fprintf( stderr, "NewFunction() == 0x%08LX\n", NewFunction );
#  endif

   Forbid();

      OldLibraryVector = SetFunction( Exec_Base,
                                      LVO_OpenLibrary, 
                                      NewFunction
                                    );

      // Clear the cpu's cache so the execution cache is valid:
      CacheClearU();

   Permit();

#  ifdef DEBUG
   fprintf( stderr, "OldLibraryVecotor == 0x%08LX\n", OldLibraryVector );
#  endif

   return;
}

PRIVATE BOOL SFRestore( void )
{
   BOOL All_OKAY = FALSE;

   FPTR func;

   Forbid();

      // Put old pointer back and get current pointer at same time
      func = SetFunction( Exec_Base,
                          LVO_OpenLibrary,
                          OldLibraryVector
                        );

      // Clear the cpu's cache so the execution cache is valid:
      CacheClearU();

      // Check to see if the pointer we got back is ours:
      if (func != (FPTR) NewFunction)
         {
         // If not, leave jump table in place:
         All_OKAY = FALSE;

         (void) SetFunction( Exec_Base, LVO_OpenLibrary, func );
         }
      else
         {
         All_OKAY = TRUE;
         }

      // Clear the cpu's cache so the execution cache is valid:
      CacheClearU();

   Permit();

   return( All_OKAY );
}

// --------------------------------------------------------------------

PUBLIC int main( int argc, char **argv )
{
   long offset = LVO_OpenLibrary;

#  ifdef DEBUG
   long *v = NULL, Vector = NULL;
#  endif
   
   if (SetupProgram() < 0)
      {
      fprintf( stderr, "Couldn't Setup %s!\n", argv[0] );
      return( RETURN_FAIL );
      }

#  ifdef DEBUG
   fprintf( stderr, 
            "SysBase == 0x%08LX, Exec_Base = 0x%08LX\n", 
            SysBase, Exec_Base 
          );

   v      = (long *) (((long) Exec_Base) + offset + 2);
   Vector = *v;

   fprintf( stderr, 
            "Before patch, OpenLibrary() == 0x%08LX: JMP 0x%08LX\n",
            ((long) Exec_Base) + offset, 
            Vector
          );

   fprintf( stderr, "NewFunction() == 0x%08LX\n", &NewFunction );
#  endif

   SFReplace(); // Install LibraryInterceptor code.

#  ifdef DEBUG
   Vector = *v;

   fprintf( stderr, 
            "After patch, OpenLibrary() == 0x%08LX: JMP 0x%08LX\n",
            ((long) Exec_Base) + offset, 
            Vector
          );
#  endif

   while (ReadyToExit == FALSE)
      ;

//#  ifdef DEBUG
   fprintf( stderr, "Attempting to restore OpenLibrary() vector...\n" );
//#  endif

   if (SFRestore() != TRUE)
      {
      char em[80];
      
#     ifdef DEBUG
      fprintf( stderr, "Couldn't Restore OpenLibrary() vector!\n" );
#     endif
      
      SetReqButtons( "Aaarrgghh!!" );

      sprintf( &em[0], "%s ERROR:", argv[0] );

      (void) Handle_Problem( "Couldn't Restore OpenLibrary() vector!",
                             &em[0], NULL
                           );
      
      ShutdownProgram();
      return( RETURN_ERROR );
      }

//#  ifdef DEBUG
   fprintf( stderr, "Shutting down %s\n", argv[0] );
//#  endif

   ShutdownProgram();
      
   return( RETURN_OK );
}

/* -------------- END of LibraryInterceptor.c file! ----------------- */
