/****h* ATalkGUI.c [2.0] **********************************************
*
* NAME
*    ATalkGUI.c
*
* DESCRIPTION
*    This will be the new AmigaTalk GUI.
*
*    This is a good example how to use Reaction classes like simple BOOPSI
*    classes and how to use it without window.class and the full ReAction
*    environment and layouter.
*
*    This code opens a simple window and then a ListBrowser gadget which is
*    subsequently attached to the window's gadget list.  Everytime the user
*    clicks on the close gadget, this code changes some of the attributes
*    of the ListBrowser gadget to demonstrate different ways it can be used,
*    including one demonstration which creates two images using the Label
*    class and shows them in the ListBrowser.
*
* NOTES
*    The original code has been refactored to:
*    a. MAKE IT READABLE
*    b. MAKE IT UNDERSTANDABLE (see a.)
*    by James T. Steichen:  http://www.frontiernet.net/~jimbot
*
*       Please folks, DO NOT follow Commodore's (Amiga Inc.) coding examples & 
*       nest your if statements 8 levels deep.  It just makes it harder to under-
*       stand your code and a pain in the butt to refactor.  I defy anyone to
*       assert that the code in this file is harder to understand than the
*       original source code.
*********************************************************************************
*
*/

#include <string.h>
#include <stdio.h>

#include <exec/types.h>
#include <exec/memory.h>

#include <AmigaDOSErrs.h>             // For RETURN_OK, PRIVATE, etc.

#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <intuition/imageclass.h>
#include <intuition/icclass.h>

#include <utility/tagitem.h>          // Only necessary for the definition of struct TagItem 

#include <graphics/rastport.h>        // For JAM1, JAM2, etc

#include <gadgets/listbrowser.h>
#include <gadgets/string.h>
#include <gadgets/button.h>
#include <images/label.h>

#include <reaction/reaction_macros.h> // VLayoutObject, etc.

#ifdef   __amigaos4__

# define __USE_INLINE__

#else

# include <clib/alib_protos.h> // Probably not necessary for AmigaOS4.

#endif

#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/listbrowser.h>
#include <proto/label.h>
#include <proto/string.h>
#include <proto/button.h>

#define RAWKEY_CURSORUP   76
#define RAWKEY_CURSORDOWN 77
#define QUALIFIER_SHIFT   0x03
#define QUALIFIER_ALT     0x30
#define QUALIFIER_CTRL    0x08

#ifdef __amigaos4__

extern struct Library *IntuitionBase;
extern struct Library *SysBase;

extern struct IntuitionIFace *IIntuition;
extern struct ExecIFace      *IExec;

PRIVATE struct Library *ListBrowserBase;
PRIVATE struct Library *LabelBase;
PRIVATE struct Library *StringBase;
PRIVATE struct Library *ButtonBase;

PUBLIC struct Library       *GadToolsBase; // For CommonFuncsPPC.o stuff
PUBLIC struct GadToolsIFace *IGadTools;

PRIVATE struct ListBrowserIFace *IListBrowser;
PRIVATE struct LabelIFace       *ILabel;
PRIVATE struct StringIFace      *IString;
PRIVATE struct ButtonIFace      *IButton;

#else

struct IntuitionBase *IntuitionBase; // SAS-C should not need this to automatically open intuition.library
struct Library       *ListBrowserBase;
struct Library       *LabelBase;
struct Library       *StringBase;
struct Library       *ButtonBase;

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#define GD_CmdHistLV     0
#define GD_CmdLineStr    1
#define GD_ParseBt       2

// Long list for testing the scroller keys functionality:

PRIVATE UBYTE *testClasses[] =
{
   "This is a", "test of the", "ListBrowser", "gadget class.",
   "This is like", "a souped-up", "listview", "gadget.  It", "has many",
   "cool new", "features", "though like", "multiple", "columns,",
   "horizontal", "scrolling,", "images in", "nodes,", "columns titles",
   "and much much", "more!",
   "This is a", "test of the", "ListBrowser", "gadget class.",
   "This is like", "a souped-up", "listview", "gadget.  It", "has many",
   "cool new", "features", "though like", "multiple", "columns,",
   "horizontal", "scrolling,", "images in", "nodes,", "columns titles",
   "and much much", "more!",
   "This is a", "test of the", "ListBrowser", "gadget class.",
   "This is like", "a souped-up", "listview", "gadget.  It", "has many",
   "cool new", "features", "though like", "multiple", "columns,",
   "horizontal", "scrolling,", "images in", "nodes,", "columns titles",
   "and much much", "more!", NULL
};

PRIVATE struct ColumnInfo fancy_ci[] = {

   { 100, NULL, 0 },
   { -1, (STRPTR)~0, -1 }
};

/* Some fonts for our fancy list.  */

PRIVATE struct TextAttr helvetica24b = { "helvetica.font", 24, FSF_BOLD, FPF_DISKFONT };
PRIVATE struct TextAttr times18i     = { "times.font",     18, FSF_ITALIC, FPF_DISKFONT };
PRIVATE struct TextAttr times18      = { "times.font",     18, 0, FPF_DISKFONT };

PRIVATE struct DrawInfo *dri     = NULL;
PRIVATE struct Screen   *Scr     = NULL;
PRIVATE struct Window   *ATWnd   = NULL;

PRIVATE struct Gadget   *CHistoryLV = NULL;
PRIVATE struct Gadget   *ParseBt    = NULL;
PRIVATE struct Gadget   *CmdLineStr = NULL;

PRIVATE struct List      cHistoryList = { 0, };

PRIVATE UWORD ACRTop    = 0;
PRIVATE UWORD ACRLeft   = 0;
PRIVATE UWORD ACRWidth  = 800; // 790
PRIVATE UWORD ACRHeight = 600; // 575

/* Normally I would add a header comment to each function in my source code, but the
** names of the function explain just what each function does, making such comments
** unnecessary.
*/

PRIVATE void freeListBrowserNodes( struct List *list ) // list is an Exec-type list
{
   struct Node *node, *nextnode;

   if (!list)
      return; // No point in continuing
      
   node = list->lh_Head;

   while (nextnode = node->ln_Succ)
      {
      FreeListBrowserNode( node );

      node = nextnode;
      }

   return;
}

/* Function to make a List of ListBrowserNodes from an array of strings. */

PRIVATE BOOL makeListBrowserNodes( struct List *list, UBYTE **labels )
{
   struct Node *node = NULL;
   WORD         i    = 0;
   BOOL         rval = TRUE;
   
   NewList( list );

   while (*labels)
      {
      if (node = AllocListBrowserNode( 1, LBNCA_CopyText, TRUE,
                                          LBNCA_Text,     *labels,
                                          LBNCA_MaxChars, 255, // 80,
                                          LBNCA_Editable, TRUE,
                                          TAG_DONE ))
         {
         AddTail( list, node );
         }
      else
         {
         freeListBrowserNodes( list ); // Free what's been done so far!
	 
	      rval = FALSE;   
         break;
	      }

      labels++;
      i++;
      }

   return( rval );
}

SUBFUNC void checkForHistoryMovement( struct IntuiMessage *imsg )
{
   if (!(imsg->Code & IECODE_UP_PREFIX))
      {
      switch (imsg->Code)
         {
         case RAWKEY_CURSORUP:
            if (imsg->Qualifier & QUALIFIER_CTRL)
               SetGadgetAttrs( CHistoryLV, ATWnd, NULL, LISTBROWSER_Position, LBP_TOP, TAG_DONE );

            if (imsg->Qualifier & QUALIFIER_SHIFT)
               SetGadgetAttrs( CHistoryLV, ATWnd, NULL, LISTBROWSER_Position, LBP_PAGEUP, TAG_DONE );
            else
               SetGadgetAttrs( CHistoryLV, ATWnd, NULL, LISTBROWSER_Position, LBP_LINEUP, TAG_DONE );
            break;

         case RAWKEY_CURSORDOWN:
            if (imsg->Qualifier & QUALIFIER_CTRL)
               SetGadgetAttrs( CHistoryLV, ATWnd, NULL, LISTBROWSER_Position, LBP_BOTTOM, TAG_DONE );

            if (imsg->Qualifier & QUALIFIER_SHIFT)
               SetGadgetAttrs( CHistoryLV, ATWnd, NULL, LISTBROWSER_Position, LBP_PAGEDOWN, TAG_DONE );
            else
               SetGadgetAttrs( CHistoryLV, ATWnd, NULL, LISTBROWSER_Position, LBP_LINEDOWN, TAG_DONE );
            break;

         default:
            break;
         }
      }

   return;
}
	
PRIVATE void HandleATIDCMP( struct Window *win, struct Gadget *CHistoryLV )
{
   BOOL running = TRUE;

   while (running == TRUE)
      {
      struct Gadget       *gadget;
      struct IntuiMessage *imsg;
         
      WaitPort( win->UserPort );
      
      while (imsg = (struct IntuiMessage *) GetMsg( win->UserPort ))
         {
         switch (imsg->Class)
            {
            case IDCMP_CLOSEWINDOW:
               running = FALSE;
               break;

            case IDCMP_GADGETUP:
               gadget = (struct Gadget *) imsg->IAddress;

               Printf( "Gadget: %ld  Code: %ld\n", (LONG) gadget->GadgetID, (LONG) imsg->Code );

               break;

            case IDCMP_RAWKEY:
				   checkForHistoryMovement( imsg );
               break;
      
            default:
               break;
            }
   
         ReplyMsg( (struct Message *) imsg );
         }
      }

   return;
}

PRIVATE int displayLabel( STRPTR LabelText, int x, int y, int w, BOOL centeredFlag )
{
   struct IntuiText labelText;
   int    left, top;
   
   labelText.FrontPen  = dri->dri_Pens[ TEXTPEN ];
   labelText.BackPen   = dri->dri_Pens[ BACKGROUNDPEN ];
   labelText.IText     = LabelText;
   labelText.DrawMode  = JAM1;
   labelText.ITextFont = &times18;
   labelText.NextText  = NULL;

   if (centeredFlag)      
      left = x + (w - IntuiTextLength( &labelText )) / 2;
	else
	   left = x;
		
   top  = y - times18.ta_YSize;

   DBG( fprintf( stderr, "Label Coords: (%d, %d)\n", left, top ) );

   labelText.LeftEdge  = left;
   labelText.TopEdge   = top;

   PrintIText( ATWnd->RPort, &labelText, 0, 0 );
   
   return( RETURN_OK );
}

PRIVATE int createCHistoryListView( void )
{
   if (CHistoryLV = (struct Gadget *)
        NewObject( LISTBROWSER_GetClass(), NULL,
            GA_ID,                      GD_CmdHistLV,
            GA_Left,                    10,                                   // 10,
            GA_Top,                     Scr->BarHeight + times18.ta_YSize + 5, // ATWnd->BorderTop + 5,
            GA_Width,                   Scr->Width - 20,
  	         GA_Height,                  Scr->Height / 2,
/*
            GA_RelWidth,              -34,
            GA_RelHeight,             -(ATWnd->BorderTop + ATWnd->BorderBottom + 10),
*/
            GA_RelVerify,               TRUE,
            LISTBROWSER_Labels,         (ULONG) &cHistoryList,
            LISTBROWSER_MultiSelect,    FALSE,
            LISTBROWSER_ShowSelected,   TRUE,
            LISTBROWSER_Editable,       TRUE,
            LISTBROWSER_AutoFit,        TRUE,
//            LISTBROWSER_HorizontalProp, TRUE,
            LISTBROWSER_VerticalProp,   TRUE,

            TAG_END ))
      {
      (void) displayLabel( (STRPTR) "Command History List:", // CMsg( MSG_AG_CLHSTR_GAD, MSG_AG_CLHSTR_GAD_STR ),
		                     10, // 390, 
									Scr->BarHeight + times18.ta_YSize + 3, 
									Scr->Width, TRUE ); // 400 ); // ATWnd->BorderTop + 5, 400 );
      
      return( RETURN_OK );
      }
   else
      return( RETURN_FAIL );
}

PRIVATE int createCommandLineString( void )
{
   if (CmdLineStr = (struct Gadget *)
        NewObject( STRING_GetClass(), NULL,
            GA_ID,                    GD_CmdLineStr,
            GA_Left,                  190,                                   // 10,
            GA_Top,                   Scr->BarHeight + times18.ta_YSize + 10 + Scr->Height / 2, // ATWnd->BorderTop + 5,
            GA_Width,                 Scr->Width - 200,
  	         GA_Height,                20,

//            GA_RelWidth,              -34,
//            GA_RelHeight,             -(ATWnd->BorderTop + ATWnd->BorderBottom + 10),

            GA_RelVerify,             TRUE,

            TAG_END ))
      {
      (void) displayLabel( (STRPTR) "Single Command Line:", // CMsg( MSG_AG_SLISTR_GAD, MSG_AG_SLISTR_GAD_STR ),
		                     10, Scr->BarHeight + times18.ta_YSize + 30 + Scr->Height / 2, 200, FALSE );
      
      return( RETURN_OK );
      }
   else
      return( RETURN_FAIL );
}

PRIVATE int createParseButton( void )
{
   if (ParseBt = (struct Gadget *)
        NewObject( BUTTON_GetClass(), NULL,
            GA_ID,                    GD_ParseBt,
				GA_Text,                  " PARSER ", // CMsg( MSG_AG_PARSER_GAD, MSG_AG_PARSER_GAD_STR )
            GA_Left,                  190,
            GA_Top,                   Scr->BarHeight + times18.ta_YSize + 35 + Scr->Height / 2,
            GA_Width,                 100,
  	         GA_Height,                 20,
            GA_RelVerify,             TRUE,

            TAG_END ))
      {
      return( RETURN_OK );
      }
   else
      return( RETURN_FAIL );
}

PRIVATE void closeLibraries( void )
{
#  ifdef __amigaos4__
   if (IListBrowser)
      DropInterface( (struct Interface *) IListBrowser );

   if (ILabel)
      DropInterface( (struct Interface *) ILabel );

   if (IString)
      DropInterface( (struct Interface *) IString );

   if (IButton)
      DropInterface( (struct Interface *) IButton );

   if (IGadTools)
      DropInterface( (struct Interface *) IGadTools );
#  endif

   if (GadToolsBase)
      CloseLibrary( GadToolsBase );

   if (ListBrowserBase)
      CloseLibrary( ListBrowserBase );

   if (LabelBase)
      CloseLibrary( LabelBase );

   if (StringBase)
      CloseLibrary( StringBase );

   if (ButtonBase)
      CloseLibrary( ButtonBase );

   return;
}

PRIVATE int openLibraries( void )
{
   int rval = RETURN_OK;

#  ifdef __amigaos4__
   ULONG libVersion = 50L;
#  else
   ULONG libVersion = 44L; // Original value from the source code.
#  endif
   
   if (ListBrowserBase = OpenLibrary( "gadgets/listbrowser.gadget", libVersion ))
      {
#     ifdef __amigaos4__
      if (!(IListBrowser = (struct ListBrowserIFace *) GetInterface( ListBrowserBase, "main", 1, NULL )))
         {
         PutStr( "IListBrowser.IFace did NOT open!" );

   	   rval = ERROR_INVALID_RESIDENT_LIBRARY;
	 
	      closeLibraries();

	      goto ExitOpenLibraries;
         }
#     endif
      }
   else
      {
      PutStr( "ERROR: Could NOT open ListBrowser.gadget\n" );

      rval = ERROR_INVALID_RESIDENT_LIBRARY;

      closeLibraries();
      
      goto ExitOpenLibraries;
      }

   if (LabelBase = OpenLibrary( "images/label.image", libVersion ))
      {
#     ifdef __amigaos4__
      if (!(ILabel = (struct LabelIFace *) GetInterface( LabelBase, "main", 1, NULL )))
         {
         PutStr( "ILabel.IFace did NOT open!" );

	      rval = ERROR_INVALID_RESIDENT_LIBRARY;
	 
	      closeLibraries();

	      goto ExitOpenLibraries;
         }
#     endif
      }
   else
      {
      PutStr( "ERROR: Could NOT open label.image\n" );

      rval = ERROR_INVALID_RESIDENT_LIBRARY;

      closeLibraries();
      
      goto ExitOpenLibraries;
      }


   if (StringBase = OpenLibrary( "gadgets/string.gadget", libVersion ))
      {
#     ifdef __amigaos4__
      if (!(IString = (struct StringIFace *) GetInterface( StringBase, "main", 1, NULL )))
         {
         PutStr( "IString.IFace did NOT open!" );

	      rval = ERROR_INVALID_RESIDENT_LIBRARY;
	 
	      closeLibraries();

	      goto ExitOpenLibraries;
         }
#     endif
      }
   else
      {
      PutStr( "ERROR: Could NOT open string.gadget\n" );

      rval = ERROR_INVALID_RESIDENT_LIBRARY;

      closeLibraries();
      
      goto ExitOpenLibraries;
      }

   if (ButtonBase = OpenLibrary( "gadgets/button.gadget", libVersion ))
      {
#     ifdef __amigaos4__
      if (!(IButton = (struct ButtonIFace *) GetInterface( ButtonBase, "main", 1, NULL )))
         {
         PutStr( "IButton.IFace did NOT open!" );

	      rval = ERROR_INVALID_RESIDENT_LIBRARY;
	 
	      closeLibraries();

	      goto ExitOpenLibraries;
         }
#     endif
      }
   else
      {
      PutStr( "ERROR: Could NOT open button.gadget\n" );

      rval = ERROR_INVALID_RESIDENT_LIBRARY;

      closeLibraries();
      
      goto ExitOpenLibraries;
      }

#  ifdef __amigaos4__
   if (GadToolsBase = OpenLibrary( "gadtools.library", libVersion ))
      {
      if (!(IGadTools = (struct GadToolsIFace *) GetInterface( GadToolsBase, "main", 1, NULL )))
         {
         PutStr( "IGadTools.IFace did NOT open!" );

	      rval = ERROR_INVALID_RESIDENT_LIBRARY;
	 
	      closeLibraries();

	      goto ExitOpenLibraries;
         }
      }
   else
      {
      PutStr( "ERROR: Could NOT open gadtools.library\n" );

      rval = ERROR_INVALID_RESIDENT_LIBRARY;

      closeLibraries();
      
      goto ExitOpenLibraries;
      }
#  endif

ExitOpenLibraries:

   return( rval );
}

PRIVATE void ShutdownProgram( BOOL madeList )
{
   if (madeList == TRUE)
	   {
		DBG( fprintf( stderr, "Calling freeListBrowserNodes( 0x%08LX )...\n", &cHistoryList ) );
      freeListBrowserNodes( &cHistoryList );
	   }

	DBG( fprintf( stderr, "Calling closeLibraries()...\n" ) );
   closeLibraries();

   if (ATWnd)
	   {
		DBG( fprintf( stderr, "Calling CloseWindow( 0x%08LX )...\n", ATWnd ) );
      CloseWindow( ATWnd );
	   }

	DBG( fprintf( stderr, "CloseWindow() Succeeded!\n" ) );

   if (dri)
	   {
		DBG( fprintf( stderr, "Calling FreeScreenDrawInfo( 0x%08LX, 0x%08LX )...\n", Scr, dri ) );
      FreeScreenDrawInfo( Scr, dri );
      }    

   if (Scr)
	   {
		DBG( fprintf( stderr, "Calling UnlockPubScreen( 0, 0x%08LX )...\n", Scr ) );
      UnlockPubScreen( 0, Scr );
	   }

	DBG( fprintf( stderr, "Exiting ShutdownProgram()...\n" ) );

   return;
}

PRIVATE int SetupProgram( char *pgmName )
{
   int rval = RETURN_OK;

   if ((rval = openLibraries()) != RETURN_OK)
      {
      goto ExitSetup;
      }

   if (!(Scr = LockPubScreen( NULL )))
      {
      PutStr( "ERROR: Could NOT lock public screen\n" );
      
      ShutdownProgram( FALSE );
      
      goto ExitSetup;
      }
   else
      {
      dri = GetScreenDrawInfo( Scr ); // For Pens & labels, etc.
      
      ACRTop  = (Scr->Height - ACRHeight) / 2; // Center the window in the Screen.
      ACRLeft = (Scr->Width  - ACRWidth ) / 2;
      }

   // Open the window:

   if (!(ATWnd = OpenWindowTags( NULL,

            WA_Left,         0,           // ACRTop,    // 0,
            WA_Top,          0,           // ACRLeft,   // Scr->Font->ta_YSize + 3,
            WA_Width,        Scr->Width,  // ACRWidth,  // 300,
            WA_Height,       Scr->Height / 2 + 105, // ACRHeight, // 160,
            WA_CustomScreen, Scr,

            WA_IDCMP,        IDCMP_GADGETUP | IDCMP_MOUSEMOVE | IDCMP_RAWKEY
              | IDCMP_CLOSEWINDOW | IDCMP_GADGETDOWN,

            WA_Flags,        WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET 
	           | WFLG_ACTIVATE | WFLG_SMART_REFRESH,

            WA_Title,        "New AmigaTalk GUI:", // CMsg( MSG_, _STR ), 
            WA_MinWidth,     350,
            WA_MinHeight,    50,
            WA_MaxWidth,     -1,
            WA_MaxHeight,    -1,

            TAG_DONE )))
      {
      PutStr( "ERROR: Could NOT open window\n" );

      ShutdownProgram( FALSE );
      
      goto ExitSetup;
      }

ExitSetup:

   return( rval );
}

PRIVATE void doMakeVisible( void )
{
   SetWindowTitles( ATWnd, "Make the 10th node Visible:", (UBYTE *) ~0 );

   SetGadgetAttrs( CHistoryLV, ATWnd, NULL,
                            LISTBROWSER_MakeVisible, 10,
                            LISTBROWSER_EditNode,    8,
                            LISTBROWSER_EditColumn,  1,
                            TAG_DONE
	         );

   ActivateGadget( CHistoryLV, ATWnd, NULL );

   HandleATIDCMP( ATWnd, CHistoryLV );

   return;
}

PRIVATE void doShowSelectedAutoFit( void )
{	    
   SetWindowTitles( ATWnd, "Show selected, Auto-Fit", (UBYTE *) ~0 );

   SetGadgetAttrs( CHistoryLV, ATWnd, NULL,
                            LISTBROWSER_ShowSelected,   TRUE,
                            LISTBROWSER_AutoFit,        TRUE,
                            LISTBROWSER_HorizontalProp, TRUE,
                            TAG_DONE
                 );

   HandleATIDCMP( ATWnd, CHistoryLV );
   
   return;
}

PRIVATE void updateHistoryLV( void )
{	    
   SetWindowTitles( ATWnd, "updateHistoryLV(): Show selected, Auto-Fit", (UBYTE *) ~0 );

   SetGadgetAttrs( CHistoryLV, ATWnd, NULL,
                            LISTBROWSER_ShowSelected,   TRUE,
                            LISTBROWSER_AutoFit,        TRUE,
                            LISTBROWSER_HorizontalProp, TRUE,
                            TAG_DONE
                 );

   HandleATIDCMP( ATWnd, CHistoryLV );
   
   return;
}

PRIVATE void doMultiSelect_VirtualWidth( void )
{
   SetWindowTitles( ATWnd, "Multi-select, Virtual Width of 500", (UBYTE *) ~0 );

   SetGadgetAttrs( CHistoryLV, ATWnd, NULL,
                            LISTBROWSER_MultiSelect,  TRUE,
                            LISTBROWSER_VirtualWidth, 500,
                            LISTBROWSER_AutoFit,      FALSE,
                            TAG_DONE
                 );

   HandleATIDCMP( ATWnd, CHistoryLV );
   
   return;
}

PRIVATE void doDetachedList( void )
{
   SetWindowTitles( ATWnd, "Detached list", (UBYTE *) ~0 );

   SetGadgetAttrs( CHistoryLV, ATWnd, NULL,
                            LISTBROWSER_MultiSelect, FALSE,
                            LISTBROWSER_Labels,      ~0, // This is the detaching item
                            TAG_DONE
                 );

   HandleATIDCMP( ATWnd, CHistoryLV );
   
   return;
}

PRIVATE void doNoSeparatorsNoTitle( void )
{
   SetWindowTitles( ATWnd, "No separators, no title, 1 column.", (UBYTE *) ~0 );

   SetGadgetAttrs( CHistoryLV, ATWnd, NULL,
                            LISTBROWSER_Labels,       (ULONG) &cHistoryList,
                            LISTBROWSER_ColumnInfo,   (ULONG) &fancy_ci,
                            LISTBROWSER_Separators,   FALSE,
                            LISTBROWSER_ColumnTitles, FALSE,
                            LISTBROWSER_AutoFit,      TRUE,
                            LISTBROWSER_VirtualWidth, 0,
                            TAG_DONE
                 );

   HandleATIDCMP( ATWnd, CHistoryLV );
   
   return;
}

PRIVATE void doReadOnly( void )
{
   SetWindowTitles( ATWnd, "Read-only", (UBYTE *) ~0 );

   SetGadgetAttrs( CHistoryLV, ATWnd, NULL,
                            LISTBROWSER_Labels,     (ULONG) &cHistoryList,
                            LISTBROWSER_AutoFit,    TRUE,
                            LISTBROWSER_Selected,   -1,
                            GA_ReadOnly,            TRUE, // The workhorse
                            TAG_DONE
                 );

   HandleATIDCMP( ATWnd, CHistoryLV );
   
   return;
}

PRIVATE void doDisabled( void )
{
   SetWindowTitles( ATWnd, "Disabled", (UBYTE *) ~0 );

   SetGadgetAttrs( CHistoryLV, ATWnd, NULL,
                            GA_Disabled, TRUE,
                            GA_ReadOnly, FALSE,
                            TAG_DONE 
	         );

   HandleATIDCMP( ATWnd, CHistoryLV );
   
   return;
}

PRIVATE void doNoScrollersNoBorders( void )
{
   SetWindowTitles( ATWnd, "No scrollbars, borderless", (UBYTE *) ~0 );

   SetGadgetAttrs( CHistoryLV, ATWnd, NULL,
                            GA_Disabled,                FALSE,
                            GA_Top,                     ATWnd->BorderTop,
                            GA_Left,                    2,
                            GA_RelWidth,                -18,
                            GA_RelHeight,               -(ATWnd->BorderTop + ATWnd->BorderBottom),
                            LISTBROWSER_Borderless,     TRUE,
                            LISTBROWSER_HorizontalProp, FALSE,
                            LISTBROWSER_VerticalProp,   FALSE,
                            TAG_DONE
	         );

   HandleATIDCMP( ATWnd, CHistoryLV );

   return;
}

PRIVATE void doFancyList( void )
{
   struct List   fancy_list;
   struct Image *image1, *image2;
   struct Node  *node1,  *node2;

   PutStr( "Creating Label class\n" );

   NewList( &fancy_list );

   PutStr( "Creating Label object\n" );

   if (!(image1 = (struct Image *) NewObject( LABEL_GetClass(), NULL,

              IA_FGPen,    1,
              IA_BGPen,    2,
              IA_Font,    (ULONG) &helvetica24b,
              LABEL_Text, (ULONG) "R",
              IA_Font,    (ULONG) &times18i,
              LABEL_Text, (ULONG) "e ",
              IA_Font,    (ULONG) &helvetica24b,
              LABEL_Text, (ULONG) "Act",
              IA_Font,    (ULONG) &times18i,
              LABEL_Text, (ULONG) "ion",
              TAG_END )))
      {
      PutStr( "ERROR: Couldn't create image1\n" );
      
      goto ExitFancyList;
      }

   PutStr( "Creating Label object\n" );

   if (!(image2 = (struct Image *) NewObject( LABEL_GetClass(), NULL,

              IA_FGPen,    2,
              IA_BGPen,    0,
              IA_Font,    (ULONG) &times18,
              LABEL_Text, (ULONG) "Amiga Inc.",
              TAG_END )))
      {
      PutStr( "ERROR: Couldn't create image2\n" );
      
      goto ExitFancyList;
      }

   if (!(node1 = AllocListBrowserNode( 1, LBNA_Column, 0,
                                            LBNCA_Image,         (ULONG) image1,
                                            LBNCA_Justification, LCJ_CENTRE,
                                            TAG_DONE )))
      {
      PutStr( "ERROR: Couldn't create node1\n" );
      
      goto ExitFancyList;
      }

   AddTail( &fancy_list, node1 );

   if (!(node2 = AllocListBrowserNode( 1, LBNA_Column, 0,
                                            LBNCA_Image,         (ULONG) image2,
                                            LBNCA_Justification, LCJ_CENTRE,
                                            TAG_DONE )))
      {
      PutStr( "ERROR: Couldn't create node2\n" );
      
      goto ExitFancyList;
      }

   AddTail( &fancy_list, node2 );

   // Set listbrowser.
   SetWindowTitles( ATWnd, "Fancy Renderings...", (UBYTE *) ~0 );

   SetGadgetAttrs( CHistoryLV, ATWnd, NULL,
                            LISTBROWSER_ColumnInfo, &fancy_ci,
                            LISTBROWSER_Labels,     (ULONG) &fancy_list,
                            LISTBROWSER_AutoFit,    TRUE,
                            TAG_DONE 
	         );

   HandleATIDCMP( ATWnd, CHistoryLV );

   SetGadgetAttrs( CHistoryLV, ATWnd, NULL, LISTBROWSER_Labels, ~0, TAG_DONE );

ExitFancyList:
   if (node2)
      FreeListBrowserNode( node2 );

   if (node1)
      FreeListBrowserNode( node1 );

   if (image2)
      DisposeObject( image2 );
   
   if (image1)
      DisposeObject( image1 );

   return;
}

/* The original code had just about everything buried in the main() function.  Com'on folks,
** are you really that lazy?  Readable code will save you time in the long run.
*/

PUBLIC int main( int argc, char *argv[] )
{
   BOOL madeList = FALSE;
   int  rval     = RETURN_OK, gpos = 0;
   
   if ((rval = SetupProgram( argv[0] )) != RETURN_OK)   
      {
      // SetupProgram() cleans up after itself, so...
      fprintf( stderr, "Could NOT setup %s!\n", argv[0] );

      return( rval ); // We can bail out here because SetupProgram() is such a nice function.
      }

   if ((madeList = makeListBrowserNodes( &cHistoryList, testClasses )) != TRUE)
      {
      PutStr( "ERROR: Could NOT make Node for ListBrowser!\n" );

      goto BailOut;
      } 

   // Create a listbrowser gadget.
   PutStr( "Creating ListBrowser object...\n" );
   
   if (createCHistoryListView() != RETURN_OK)
      {
      PutStr( "ERROR: Couldn't create ListBrowser gadget\n" );

      goto BailOut;
      }

   if (createCommandLineString() != RETURN_OK)
      {
      PutStr( "ERROR: Couldn't create Command Line String gadget\n" );

      goto BailOut;
      }

   if (createParseButton() != RETURN_OK)
      {
      PutStr( "ERROR: Couldn't create Parser Button gadget\n" );

      goto BailOut;
      }


   // Adding gadgets.
//   PutStr( "Adding gadget\n" );
   gpos = AddGList( ATWnd, CHistoryLV, -1, -1, NULL );
   DBG( fprintf( stderr, "Command History List is at %d\n" , gpos ) );

//   PutStr( "Refreshing gadget\n" );
   RefreshGList( CHistoryLV, ATWnd, NULL, -1 );

//   PutStr( "Adding gadget\n" );
   gpos = AddGList( ATWnd, CmdLineStr, -1, -1, NULL );
   DBG( fprintf( stderr, "Single Command Line is at %d\n" , gpos ) );

//   PutStr( "Refreshing gadget\n" );
   RefreshGList( CmdLineStr, ATWnd, NULL, -1 );

//   PutStr( "Adding gadget\n" );
   gpos = AddGList( ATWnd, ParseBt, -1, -1, NULL );
   DBG( fprintf( stderr, "Parser Button is at %d\n" , gpos ) );

//   PutStr( "Refreshing gadget\n" );
   RefreshGList( ParseBt, ATWnd, NULL, -1 );

   updateHistoryLV();

   // Wait for close gadget click to continue.
   SetWindowTitles( ATWnd, "<- Click here to continue", (UBYTE *) ~0 );

   HandleATIDCMP( ATWnd, CHistoryLV );
	
   doMakeVisible();
/*
   doShowSelectedAutoFit();
   doMultiSelect_VirtualWidth();
   doDetachedList();
   doNoSeparatorsNoTitle();
   doReadOnly();
   doDisabled();
   doNoScrollersNoBorders();
*/
   doFancyList();
   
   RemoveGList( ATWnd, CHistoryLV, -1 ); // Has to be the FIRST gadget added1

	DisposeObject( ParseBt );
	DisposeObject( CmdLineStr );
   DisposeObject( CHistoryLV );           // Clean up for createCHistoryListView()

BailOut:

   ShutdownProgram( madeList );

   return( rval );
}

/* ----------------- END of ATalkGUI.c file ----------------- */

