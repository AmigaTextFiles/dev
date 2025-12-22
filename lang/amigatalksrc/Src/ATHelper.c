/****** AmigaTalk/ATHelper.c [3.0] **********************************
*
* NAME
*    ATHelper.c
*
* DESCRIPTION
*    Show the User the Help directory of documents to view. 
*
* HISTORY
*    24-Oct-2004 - Added AmigaOS4 & gcc support.
*
*    09-Jan-2003 - Moved all string constants to StringConstants.h
*
*    30-Apr-2000 - No more minor changes needed in this file.
*
*    15-Feb-2000 - Moved DocumentViewer to ATHelper & eliminated
*                  the Icon, along with the opening on the wrong
*                  screen behavior.
*
*    14-Feb-2000 - Added another argv for letting this program
*                  know the name of the Screen to open on.
*
*    13-Feb-2000 - Added the capability for the User to supply the
*                  Path to the documents as a CLI argument.
*
* FUNCTIONAL INTERFACE:
*    PUBLIC int ATHelper( char *parentdir, char *fileviewer, 
*                         char *filefilter 
*                       );
*
* NOTES
*    The following Default ToolTypes are used by this program:
*
*    ParentDir     = "AmigaTalk:Help/"
*    FileViewer    = "MultiView"
*    FileExtFilter = "(#?.doc|#?.guide)"
*
*    GUI Designed by : Jim Steichen
*********************************************************************
*
*/

#include <string.h>
#include <stdlib.h>               // for abs() macro.

#include <exec/types.h>
#include <AmigaDOSErrs.h>
#include <Author.h>

#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/imageclass.h>
#include <intuition/gadgetclass.h>

#include <libraries/gadtools.h>
#include <libraries/asl.h>

#include <dos/dostags.h>

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
IMPORT struct Library       *IconBase;
IMPORT struct Library       *UtilityBase;

#else

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/dos.h>
# include <proto/intuition.h>
# include <proto/gadtools.h>
# include <proto/graphics.h>
# include <proto/utility.h>
# include <proto/diskfont.h>

IMPORT struct Library *IntuitionBase;
IMPORT struct Library *GfxBase;
IMPORT struct Library *GadToolsBase;
IMPORT struct Library *IconBase;
IMPORT struct Library *UtilityBase;

IMPORT struct GadToolsIFace *IGadTools;

#endif

#include "FuncProtos.h"

#include "StringConstants.h"
#include "StringIndexes.h"

#include "CPGM:GlobalObjects/CommonFuncs.h"

#ifndef  StrBfPtr
# define StrBfPtr( g ) (((struct StringInfo *)g->SpecialInfo)->Buffer)
#endif

#define DocListView 0
#define ASLBt       1
#define FileNameStr 2
#define ChangeDirBt 3
#define ViewFileBt  4

#define DV_CNT      5

#define FileNameGad DVGadgets[ FileNameStr ]
#define FILENAME    StrBfPtr( FileNameGad )

#define STRLENGTH   256

//IMPORT Class *initGet( void );

IMPORT struct Screen        *Scr;
IMPORT struct Window        *ATWnd;
IMPORT struct TextAttr      *Font;
IMPORT struct TextFont      *ATFont;
IMPORT struct CompFont       CFont;
IMPORT APTR                  VisualInfo;

// From Global.c: ----------------------

IMPORT UBYTE *DefaultButtons;
IMPORT UBYTE *AaarrggButton;
IMPORT UBYTE *ErrMsg;
IMPORT UBYTE *UserProblem;
IMPORT UBYTE *ATalkProblem;
IMPORT UBYTE *AllocProblem;

// --------------------------------------------------------------------

//PRIVATE struct IClass       *getClass = NULL;
//PRIVATE struct _Object      *getImage = NULL;

PRIVATE struct Window       *DVWnd    = NULL;
PRIVATE struct Gadget       *DVGList  = NULL;
PRIVATE struct Gadget       *DVGadgets[ DV_CNT ];
PRIVATE struct IntuiMessage  DVMsg;

PRIVATE UWORD  DVLeft   = 220;
PRIVATE UWORD  DVTop    = 170;
PRIVATE UWORD  DVWidth  = 545;
PRIVATE UWORD  DVHeight = 270;

PRIVATE char   fn[512]     = { 0, };
PRIVATE char   cp[256]     = { 0, };
PRIVATE char  *CurrentPath = &cp[0];
PRIVATE char  *SpareFName  = &fn[0];

PRIVATE char   ParsedPattern[128] = { 0, }; // For FileExtFilter ToolType use.

// --------------------------------------------------------------------

#define TXTLENGTH   80 // Reasonable length for the document names. 

PRIVATE struct MinList DocLVList    = { 0, };

PRIVATE struct Node    DocLVNode    = { 0, };
PRIVATE struct Node   *DocLVNodes   = NULL;

PRIVATE ULONG          NumDocuments = 0L;
PRIVATE ULONG          NumAllocated = 0L; // TXTLENGTH * NumDocuments.

PRIVATE UBYTE         *NodeStrs     = NULL;

PRIVATE struct FileInfoBlock *The_fib; // used in several functions.

// --------------------------------------------------------------------

PUBLIC UBYTE *WhatDidYouDo = NULL; // AH_WHAT_DID;  // VIsible to CatalogATHelper();
PUBLIC UBYTE *DVWdt        = NULL; // AH_WTITLE = "AmigaTalk Help Selector (C) 2000:"; // VIsible to CatalogATHelper();

// Environment variables: -------------------------------

PUBLIC char DefParentDir[128]     = { 0, }; // "AmigaTalk:Help";     // VIsible to CatalogATHelper();
PUBLIC char DefFileExtFilter[128] = { 0, }; // "(#?.guide|#?.doc)";  // VIsible to CatalogATHelper();
PUBLIC char DefFileViewer[128]    = { 0, }; // "MultiView";          // VIsible to CatalogATHelper();

PRIVATE char *TTParentDir          = &DefParentDir[0];
PRIVATE char *TTFileExtFilter      = &DefFileExtFilter[0];
PRIVATE char *TTFileViewer         = &DefFileViewer[0];

// --------------------------------------------------------------------

PRIVATE UWORD DVGTypes[] = {

   LISTVIEW_KIND, BUTTON_KIND, STRING_KIND,
   BUTTON_KIND,   BUTTON_KIND
};

PRIVATE int DocListViewClicked( int whichitem );
PRIVATE int ASLBtClicked(       int dummy     );
PRIVATE int FileNameStrClicked( int dummy     );
PRIVATE int ChangeDirBtClicked( int dummy     );
PRIVATE int ViewFileBtClicked(  int dummy     );

PUBLIC struct NewGadget DVNGad[] = { // VIsible to CatalogATHelper();

     5,  25, 400, 195, NULL, NULL, DocListView, 
   PLACETEXT_ABOVE, NULL, (APTR) DocListViewClicked,

   485, 230,  40,  20, "_ASL", NULL, ASLBt, 
   0, NULL, (APTR) ASLBtClicked,

   110, 230, 365,  20, "_File Name:" , NULL, FileNameStr, 
   PLACETEXT_LEFT, NULL, (APTR) FileNameStrClicked,

   425,  25, 105,  20, "_Change Dir", NULL, ChangeDirBt, 
   PLACETEXT_IN, NULL, (APTR) ChangeDirBtClicked,
 
   425,  55, 105,  20, "_View File...", NULL, ViewFileBt, 
   PLACETEXT_IN, NULL, (APTR) ViewFileBtClicked
};

PRIVATE ULONG DVGTags[] = {

   GTLV_ShowSelected, 0L, LAYOUTA_Spacing, 2, TAG_DONE,

   GT_Underscore, '_', TAG_DONE,

   GTST_MaxChars, 256, 
   STRINGA_Justification, GACT_STRINGCENTER, 
   GT_Underscore, '_', TAG_DONE,

   GT_Underscore, UNDERSCORE_CHAR, TAG_DONE,
   GT_Underscore, UNDERSCORE_CHAR, TAG_DONE
};

// ----------------------------------------------------------------------


// --------------------------------------------------------------

PRIVATE BOOL FileFilter( char *pattern, struct FileInfoBlock *fib )
{
   BOOL rval = MatchPatternNoCase( pattern, fib->fib_FileName );

   return( rval );
}

PRIVATE int CountFiles( BPTR root )
{
   register BPTR mylock = (BPTR) NULL;
   int           rval   = 0;
   
   if (ParsePatternNoCase( TTFileExtFilter, ParsedPattern, 128 ) < 0)
      {
      // Error in parsing pattern!
      sprintf( ErrMsg, HelpCMsg( MSG_FMT_AH_CANTPARSE_HELP ), TTFileExtFilter );

      UserInfo( ErrMsg, HelpCMsg( MSG_AH_FILEEXT_BRK_HELP ) );

      *ParsedPattern = NIL_CHAR; // Kill the match pattern.

      return( -1 );
      }

   mylock = DupLock( root );

   if ((Examine( mylock, The_fib ) == FALSE)  // Can't examine
         || (The_fib->fib_DirEntryType < 0))  // Found a file.
      {   
      // Not a directory, the User is a total SmegHead!
      UnLock( mylock );
      return( 0 );
      }

   // If we've made it this far, count the number of valid filenames:

   while ((ExNext( mylock, The_fib ) != 0) || (IoErr() != ERROR_NO_MORE_ENTRIES))
      {
      if (The_fib->fib_DirEntryType < 0)
         {
         // Got a filename:

         if (FileFilter( ParsedPattern, The_fib ) == TRUE)
            rval++; // File matched the pattern!
         }
      }             

   UnLock( mylock );

   return( rval );
}

PRIVATE int CountNumFiles( char *dirname )
{
   BPTR start = 0; // NULL;
   int  rval  = 0;

   if (!(start = Lock( dirname, ACCESS_READ ))) // == NULL)
      {
      sprintf( ErrMsg, HelpCMsg( MSG_FMT_AH_CANTLOCK_HELP ), dirname );

      UserInfo( ErrMsg, WhatDidYouDo );

      goto ExitCountNumFiles;
      }

   if ((rval = CountFiles( start )) <= 0)
      {
      if (rval == 0)
         {
         // User didn't select a directory for us to use:
         
         sprintf( ErrMsg, HelpCMsg( MSG_FMT_AH_NOTDIR_HELP ), dirname );
         
         UserInfo( ErrMsg, WhatDidYouDo );

         rval = 10; // an abritrary value.
         } 
      else if (rval == -1)
         {
         rval = 10; // We already informed the User of this problem.
         }
      else if (rval == -2)
         {
         // We're out of memory!
         MemoryOut( HelpCMsg( MSG_AH_HELPER_FUNC_HELP ) );

         rval = -1;
         }
      }

ExitCountNumFiles:

   UnLock( start );
   return( rval );
}

PRIVATE void KillLV( void )
{
   DBG( fprintf( stderr, HelpCMsg( MSG_FMT_KILLLV_HELP ), NumAllocated ) );

   if (NodeStrs) // != NULL)
      {
      FreeVec( NodeStrs );
      NodeStrs = NULL;
      }

   if (DocLVNodes) // != NULL)
      {
      FreeVec( DocLVNodes );
      DocLVNodes = NULL;
      }

   NumAllocated = 0; // Deactivate the Allocation guard.

   return;
}

PRIVATE int ChangeDirBtClicked( int dummy );

PRIVATE int AllocateLV( int numdox, char *dirname )
{
   DBG( fprintf( stderr, HelpCMsg( MSG_FMT_ALLOCLV_HELP ), numdox, dirname ) );

   if (numdox < 1)
      {
      int ans = 0;
      
      sprintf( ErrMsg, HelpCMsg( MSG_FMT_AH_NOFILES_HELP ), dirname );

      SetReqButtons( HelpCMsg( MSG_AH_SELECT_NEW_HELP ) );

      ans = Handle_Problem( ErrMsg, 
                            HelpCMsg( MSG_AH_SELECT_DOC_HELP ), 
                            NULL 
                          );

      SetReqButtons( DefaultButtons );

      if (ans == 0)
         {
         return( ChangeDirBtClicked( 0 ) );
         }
      else
         {
         // Hopefully, the User is smarter than this:
         NumDocuments = 0;
         return( RETURN_WARN );
         }
      }

   if (numdox != NumAllocated)
      {
      /* Get rid of previous allocation.  This is safe because 
      ** KillLV() checks for NULL pointers & doesn't do anything if
      ** there's no memory allocated
      */
      KillLV();
      }
   else
      {
      NumDocuments = numdox;
      return( 0 ); // don't have to do any allocation!
      }

   // --------- GUARDED SECTION: -----------------------------------

   DocLVNodes = (struct Node*) AllocVec( numdox * sizeof( struct Node ),
                                         MEMF_CLEAR   
                                       );
   if (!DocLVNodes) // == NULL)
      {
      KillLV();
      return( -1 );
      }

   NodeStrs = (UBYTE *) AllocVec( numdox * TXTLENGTH, MEMF_CLEAR );

   if (!NodeStrs) // == NULL)
      {
      KillLV();
      return( -2 );
      }

   // --------- END OF GUARDED SECTION: ----------------------------

   NumDocuments = numdox;
   NumAllocated = numdox; // Activate the Allocation Guard again. 

   return( 0 );
}

PRIVATE void SetSelectedItem( char *filename )
{
   char *filepart = FilePart( filename );
   int   i;
   
   HideListFromView( DVGadgets[ DocListView ], DVWnd );

   for (i = 0; i < NumDocuments; i++)
      {
      if (StringComp( &NodeStrs[ i * TXTLENGTH ], filepart ) == 0)
         {
         break;
         }
      }

   ModifyListView( DVGadgets[ DocListView ], DVWnd, 
                   (struct List *) &DocLVList, NULL 
                 );

   GT_SetGadgetAttrs( DVGadgets[ DocListView ], DVWnd, NULL,
                      GTLV_Selected, i, TAG_DONE
                    );
   return;
}

PRIVATE void ClearNodeStrs( int numdox )
{
   int i, len = TXTLENGTH * numdox;
   
   for (i = 0; i < len; i++)
      *(NodeStrs + i) = NIL_CHAR; 

   return;
}

PRIVATE void FilesToListView( char *dirname )
{
   register BPTR mylock;
   int           count = 0;
   
   HideListFromView( DVGadgets[ DocListView ], DVWnd );

   ClearNodeStrs( NumDocuments );

   // We know how many files & have already allocated 
   // memory if necessary, so re-build the list:
   
   if (!(mylock = Lock( dirname, ACCESS_READ ))) // == NULL)
      {
      sprintf( ErrMsg, HelpCMsg( MSG_FMT_AH_CANTLOCK_HELP ), dirname );

      UserInfo( ErrMsg, WhatDidYouDo );
      
      goto ExitFilesToListView;
      }

   if ((Examine( mylock, The_fib ) == FALSE)  // Can't examine
         || (The_fib->fib_DirEntryType < 0))  // Found a file.
      {   
      // Not a directory, the User is a total SmegHead!
      UnLock( mylock );

      sprintf( ErrMsg, HelpCMsg( MSG_FMT_AH_NOTDIR_HELP ), dirname );

      UserInfo( ErrMsg, WhatDidYouDo );

      goto ExitFilesToListView;
      }

   while (((ExNext( mylock, The_fib ) != 0)
           || (IoErr() != ERROR_NO_MORE_ENTRIES)) 
           && (count < NumDocuments))
      {
      if (The_fib->fib_DirEntryType < 0)
         {
         // Got a filename:

         if (FileFilter( ParsedPattern, The_fib ) == TRUE)
            {
            // File matched the pattern, copy to the List buffer:
            StringNCopy( &NodeStrs[ count * TXTLENGTH ], 
                         The_fib->fib_FileName,
                         TXTLENGTH - 1 
                       );

            count++;
            }
         }
      }             

   UnLock( mylock );

ExitFilesToListView:

   ModifyListView( DVGadgets[ DocListView ], DVWnd, 
                   (struct List *) &DocLVList, NULL 
                 );
   return;
}

/****i* SetupATHLV() **********************************************
*
* NAME
*    SetupATHLV()
*
* DESCRIPTION
*    Do all that administration stuff that exec wants to see.
*******************************************************************
*
*/

PRIVATE void SetupATHLV( void )
{
   int i = 0;

   DocLVNode.ln_Succ = (struct Node *) DocLVList.mlh_Tail;
   DocLVNode.ln_Pred = (struct Node *) DocLVList.mlh_Head;
   DocLVNode.ln_Type = NT_USER;

   DocLVNodes[0]         = DocLVNode;
   DocLVNodes[0].ln_Name = &NodeStrs[ 0 ];

   // change to signed char range:
   DocLVNodes[0].ln_Pri  = NumDocuments - 129;

   for (i = 1; i < NumDocuments; i++)
      {
      DocLVNodes[i].ln_Name = &NodeStrs[ i * TXTLENGTH ];
      DocLVNodes[i].ln_Pri  = NumDocuments - i - 129;
      DocLVNodes[i].ln_Type = NT_USER;
      }

   NewList( (struct List *) &DocLVList );

   for (i = 0; i < NumDocuments; i++)
      Enqueue( (struct List *) &DocLVList, &DocLVNodes[i] );

   return;
}

// ---------------------------------------------------------------

PRIVATE void SetCurrentPath( char *file_and_path )
{
   char *path_end = PathPart( file_and_path );
   int   len      = abs( path_end - file_and_path );

   if (len == 0)
      {
      // No Path????
      *CurrentPath = NIL_CHAR;

      return;
      }   

   StringNCopy( CurrentPath, file_and_path, len );

   return;
}

IMPORT struct TagItem FileTags[];

PRIVATE int ChangeDirBtClicked( int dummy )
{
   char *title = HelpCMsg( MSG_AH_WTITLE2_HELP );

   char UserFileName[ STRLENGTH ];

   SetTagItem( &FileTags[0], ASLFR_Window, (ULONG) DVWnd );

   SetTagItem( &FileTags[0], ASLFR_InitialDrawer, 
               (ULONG) &TTParentDir[0]
             );

   SetTagItem( &FileTags[0], ASLFR_InitialPattern,
               (ULONG) &TTFileExtFilter[0]
             );

   SetTagItem( &FileTags[0], ASLFR_TitleText, 
               (ULONG) &title[0]
             );

   if (FileReq( UserFileName, &FileTags[0] ) > 1)
      {
      ULONG SaveNumDocs = NumDocuments;
      
      sprintf( SpareFName, "%s", &UserFileName[0] );

      SetCurrentPath( UserFileName );

      NumDocuments = CountNumFiles( CurrentPath );

      if (NumDocuments < 0)
         {
         int ans = TRUE;

         ans = Handle_Problem( HelpCMsg( MSG_AH_CONTINUE_HELP ), ATalkProblem, NULL );
         
         if (ans == 0)
            return( (int) TRUE );
         else
            return( (int) FALSE );
         }
         
      if (NumDocuments > SaveNumDocs)
         {
         // Get more memory for the bigger directory &
         // re-build the ListView:
         int rval = 0;
         
         KillLV();
         
         rval = AllocateLV( NumDocuments, CurrentPath );

         if (rval == 0)
            {
            TTParentDir = CurrentPath; //????????
            SetupATHLV();
            FilesToListView( CurrentPath );
            }
         else if (rval < 0)
            {
            // Ran out of memory:
            int ans = TRUE;
 
            ans = Handle_Problem( HelpCMsg( MSG_AH_MEMORYOUT_HELP ), AllocProblem, NULL );
         
            if (ans == 0)
               return( (int) TRUE );
            else
               return( (int) FALSE );
            }
         else
            {
            // got RETURN_WARN:
            SetupATHLV();
            FilesToListView( CurrentPath );
            }
         }
      else
         {
         // Just erase the old strings & redisplay the ListView:
         SetupATHLV();
         FilesToListView( CurrentPath );
         }

      GT_SetGadgetAttrs( FileNameGad, DVWnd, NULL,
                         GTST_String, (STRPTR) SpareFName, TAG_END 
                       );
      
      SetSelectedItem( FILENAME );
      }

   return( (int) TRUE );
}

PRIVATE int DocListViewClicked( int whichitem )
{
   StringCopy( SpareFName, &NodeStrs[ TXTLENGTH * whichitem ] );

   GT_SetGadgetAttrs( FileNameGad, DVWnd, NULL,
                      GTST_String, (STRPTR) SpareFName, TAG_END 
                    );

   return( (int) TRUE );
}

PRIVATE int ASLBtClicked( int dummy )
{
   char *title = HelpCMsg( MSG_AH_WTITLE3_HELP );
   char UserFileName[ STRLENGTH ] = { 0, };

   SetTagItem( &FileTags[0], ASLFR_Window, (ULONG) DVWnd );

   SetTagItem( &FileTags[0], ASLFR_InitialPattern, (ULONG) &TTFileExtFilter[0] );

   SetTagItem( &FileTags[0], ASLFR_InitialDrawer, (ULONG) CurrentPath ); // &TTParentDir[0]

   SetTagItem( &FileTags[0], ASLFR_TitleText, (ULONG) &title[0] );

   if (FileReq( UserFileName, &FileTags[0] ) > 1)
      {
      sprintf( SpareFName, "%s", &UserFileName[0] );

      SetCurrentPath( UserFileName );

      GT_SetGadgetAttrs( FileNameGad, DVWnd, NULL,
                         GTST_String, (STRPTR) SpareFName, TAG_END 
                       );
      }

   return( (int) TRUE );
}

PRIVATE int FileNameStrClicked( int dummy )
{
   if (StringLength( FILENAME ) > 0)
      SetCurrentPath( FILENAME );

   return( (int) TRUE );
}

PRIVATE char command[256] = { 0, };

/* Verify that this code doesn't produce paths with '//' in them: */

PRIVATE int ViewFileBtClicked( int dummy )
{
   int pathlen = StringLength( CurrentPath );

   if (StringLength( FILENAME ) > 0)
      {
      if (pathlen == 0)
         {
         sprintf( command, "%s %s", TTFileViewer, FilePart( FILENAME ) );
         }
      else if ((CurrentPath[ pathlen - 1 ] != SLASH_CHAR) 
                && (CurrentPath[ pathlen - 1 ] != COLON_CHAR))
         {
         sprintf( command, "%s %s/%s", TTFileViewer, CurrentPath, FilePart( FILENAME ) );
         }
      else  // Volume name or logical device is the Path:
         {
         sprintf( command, "%s %s%s", TTFileViewer, CurrentPath, FilePart( FILENAME ) );
         }

      // Tell the OS to run our file viewing command:
      if (System( &command[0], TAG_DONE ) != RETURN_OK)
         CheckToolType( HelpCMsg( MSG_AH_FILEVIEWER_HELP ) );
      }
   else
      {
      sprintf( ErrMsg, HelpCMsg( MSG_AH_ENTER_FILE_HELP ) );
      UserInfo( ErrMsg, UserProblem );
      }   

   return( (int) TRUE );
}

PRIVATE void CloseDVWindow( void )
{
   if (DVWnd) // != NULL) 
      {
      CloseWindow( DVWnd );
      DVWnd = NULL;
      }

   if (DVGList) // != NULL) 
      {
      FreeGadgets( DVGList );
      DVGList = NULL;
      }

   return;
}

PRIVATE int DVCloseWindow( void )
{
   CloseDVWindow();

   return( (int) FALSE );
}

PRIVATE void ShowInfoReq( void )
{
   char msg[512] = { 0, };
   
   sprintf( &msg[0], HelpCMsg( MSG_FMT_AH_ABOUTMSG_HELP ), authorName, authorEMail );
   
   UserInfo( msg, HelpCMsg( MSG_AH_ABOUT_HELP ) );   
   
   return;
}

PRIVATE int DVVanillaKey( int whichkey )
{
   BOOL rval = TRUE;
   
   switch (whichkey)
      {
      case CAP_Q_CHAR:   // quit
      case CAP_E_CHAR:
      case CAP_X_CHAR:   // end
      case SMALL_E_CHAR:
      case SMALL_X_CHAR: // exit
      case SMALL_Q_CHAR:
         rval = FALSE; // In other words, die!!
         break;
         
      case CAP_C_CHAR:
      case SMALL_C_CHAR:
         rval = ChangeDirBtClicked( 0 );
         break;
         
      case CAP_V_CHAR:
      case SMALL_V_CHAR:
         rval = ViewFileBtClicked( 0 );
         break;

      case CAP_I_CHAR:
      case SMALL_I_CHAR:
         ShowInfoReq(); // Information Requester.
         break;

      default:
         break;
      }

   return( rval );
}

PRIVATE int OpenDVWindow( void )
{
   struct NewGadget  ng;
   struct Gadget    *g;
   UWORD             lc, tc;
   UWORD             wleft = DVLeft, wtop = DVTop, ww, wh;

   ComputeFont( Scr, Font, &CFont, DVWidth, DVHeight );

   ww = ComputeX( CFont.FontX, DVWidth );
   wh = ComputeY( CFont.FontY, DVHeight );

   if ((wleft + ww + CFont.OffX + Scr->WBorRight) > Scr->Width) 
      wleft = Scr->Width - ww;

   if ((wtop + wh + CFont.OffY + Scr->WBorBottom) > Scr->Height) 
      wtop = Scr->Height - wh;

   if (!(g = CreateContext( &DVGList ))) // == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < DV_CNT; lc++) 
      {
      CopyMem( (char *) &DVNGad[ lc ], (char *) &ng, 
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

         ng.ng_Width   = ComputeX( CFont.FontX, ng.ng_Width );
         ng.ng_Height  = ComputeY( CFont.FontY, ng.ng_Height);

      DVGadgets[ lc ] = g = CreateGadgetA( (ULONG) DVGTypes[ lc ], 
                              g, 
                              &ng, 
                              (struct TagItem *) &DVGTags[ tc ] );

      while (DVGTags[ tc ]) // != NULL) 
         tc += 2;
      
      tc++;

      if (!g) // == NULL)
         return( -2 );
      }

   if (!(DVWnd = OpenWindowTags( NULL,

                  WA_Left,        wleft,
                  WA_Top,         wtop,
                  WA_Width,       ww + CFont.OffX + Scr->WBorRight, 
                  WA_Height,      wh + CFont.OffY + Scr->WBorBottom,

                  WA_IDCMP,       LISTVIEWIDCMP | IDCMP_GADGETUP
                    | STRINGIDCMP | BUTTONIDCMP | IDCMP_CLOSEWINDOW
                    | IDCMP_VANILLAKEY | IDCMP_REFRESHWINDOW,

                  WA_Flags,       WFLG_DRAGBAR | WFLG_DEPTHGADGET
                    | WFLG_CLOSEGADGET | WFLG_SMART_REFRESH
                    | WFLG_ACTIVATE | WFLG_RMBTRAP,

                  WA_Gadgets,      DVGList,
                  WA_Title,        DVWdt,
                  WA_CustomScreen, Scr,
                  TAG_DONE )
      )) // == NULL)
      return( -4L );

   GT_RefreshWindow( DVWnd, NULL );

   return( 0 );
}

PRIVATE int HandleDVIDCMP( void )
{
   struct IntuiMessage *m;
   int                (*func)( int code );
   BOOL                 running = TRUE;

   while (running == TRUE)
      {
      if (!(m = GT_GetIMsg( DVWnd->UserPort ))) // == NULL) 
         {
         (void) Wait( 1L << DVWnd->UserPort->mp_SigBit );

         continue;
         }

      CopyMem( (char *) m, (char *) &DVMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (DVMsg.Class) 
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( DVWnd );
            GT_EndRefresh( DVWnd, TRUE );
            break;

         case IDCMP_CLOSEWINDOW:
            running = DVCloseWindow();
            break;

         case IDCMP_VANILLAKEY:
            running = DVVanillaKey( DVMsg.Code );
            break;

         case IDCMP_GADGETUP:
         case IDCMP_GADGETDOWN:
            func = (int (*)( int )) ((struct Gadget *) DVMsg.IAddress)->UserData;
   
            if (func) // != NULL)                // Just in case.
               running = func( DVMsg.Code );
   
            break;
         }
      }
   
   return( running );
}

// --------------------------------------------------------------

PRIVATE void KillATHelper( void )
{
   KillLV(); // Did'n wanna do it, but it had to be done.

   if (The_fib) // != NULL)
      {
      FreeVec( The_fib );
      The_fib = NULL;
      }

   CloseDVWindow();

   return;
}

PRIVATE int SetupATHelper( char *parentdir, 
                           char *fileviewer, 
                           char *filefilter
                         )
{
   int rval = 0;

   if (OpenDVWindow() < 0)
      {
      KillATHelper();
      return( -6 );
      }   

   SetNotifyWindow( DVWnd );   

   if (!(The_fib = (struct FileInfoBlock *) 
                    AllocVec( sizeof( struct FileInfoBlock ), 
                              MEMF_CLEAR )))
      {
      MemoryOut( HelpCMsg( MSG_AH_SETUP_FUNC_HELP ) );

      KillATHelper();

      return( -7 );
      }

   NumDocuments = CountNumFiles( TTParentDir );
   
   if ((rval = AllocateLV( NumDocuments, TTParentDir )) != 0)
      {
      if (rval < 0)
         {
         // Memory allocation failure:
         MemoryOut( HelpCMsg( MSG_AH_SETUP_FUNC_HELP ) );

         KillATHelper();

         return( -8 );
         }
      else   
         {
         // One file name or less(??):
         SetReqButtons( HelpCMsg( MSG_AH_UNDERSTAND_HELP ) );

         (void) Handle_Problem( HelpCMsg( MSG_AH_SELECTASAP_HELP ), 
                                HelpCMsg( MSG_AH_PARENTDIR_HELP ), 
                                NULL 
                              );

         SetReqButtons( DefaultButtons );
         }
      }

   SetupATHLV();

   StringCopy( CurrentPath, TTParentDir );

   FilesToListView( TTParentDir );

   return( 0 );
}

PUBLIC int ATHelper( char *parentdir, char *fileviewer, char *filefilter )
{
   /* Use what the User supplied, else don't upset the Default strings */

   if (parentdir) // != NULL)
      StringCopy( TTParentDir, parentdir );

   if (fileviewer) // != NULL)
      StringCopy( TTFileViewer, fileviewer );

   if (filefilter) // != NULL)
      StringCopy( TTFileExtFilter, filefilter );


   if (SetupATHelper( parentdir, fileviewer, filefilter ) < 0)
      {
      SetNotifyWindow( ATWnd );
      
      NotOpened( 1 ); // HelpCMsg( MSG_AH_HELPER_FUNC, MSG_AH_HELPER_FUNC_STR ) );

      return( -1 );
      }

   (void) HandleDVIDCMP();

   KillATHelper();
   SetNotifyWindow( ATWnd );

   return( 0 );
}

/* -------------- END of ATHelper.c file! ----------------- */
