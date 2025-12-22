/****h* ATalkBrowserAddReq.c [2.0] **********************************************
*
* NAME
*    ATalkBrowserAddReq.c
*
* DESCRIPTION
*    Allow the User of AmigaTalkPPC to add new classes to the
*    system.
*
* NOTES
*    GUI Designed by : Jim Steichen
*    $VER: ATalkBrowserAddReq.c 3.0 (12-Nov-2004) by J.T. Steichen
*********************************************************************************
*
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

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
#include <gadgets/texteditor.h>

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
#include <proto/texteditor.h>
#include <proto/string.h>
#include <proto/button.h>
#include <proto/locale.h>

#ifndef DEBUG

IMPORT struct Catalog *browserCatalog;
IMPORT char           *CMsgATB( int, char * ); // In ATalkBrowser.c
IMPORT UBYTE          *ErrMsg;

#else

struct Catalog *browserCatalog = NULL; // NOT used in debug code.

PRIVATE UBYTE em[1024], *ErrMsg = &em[0];

#endif

#define   CATCOMP_ARRAY    1
#include "ATBrowserLocale.h"

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

extern struct Library     *LocaleBase;
extern struct LocaleIFace *ILocale;

PRIVATE struct Library *ListBrowserBase;
PRIVATE struct Library *LabelBase;
PRIVATE struct Library *ButtonBase;
PRIVATE struct Library *StringBase;
PRIVATE struct Library *TextEditorBase;

PRIVATE struct ListBrowserIFace *IListBrowser;
PRIVATE struct LabelIFace       *ILabel;
PRIVATE struct ButtonIFace      *IButton;
PRIVATE struct StringIFace      *IString;
PRIVATE struct TextEditorIFace  *ITextEditor;

# ifdef DEBUG
PUBLIC struct Library       *GadToolsBase; // Required for CommonFuncsPPC.o
PUBLIC struct GadToolsIFace *IGadTools;
# endif

#else

IMPORT  struct Library *IntuitionBase; // SAS-C should not need this to automatically open intuition.library

PRIVATE struct Library *ListBrowserBase;
PRIVATE struct Library *LabelBase;
PRIVATE struct Library *ButtonBase;
PRIVATE struct Library *StringBase;
PRIVATE struct Library *TextEditorBase;

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h" // For UserInfo() & struct ListViewMem *

#ifndef DEBUG

IMPORT struct Screen *Scr;
IMPORT UBYTE         *PubScreenName;
IMPORT APTR           VisualInfo;

#else


PRIVATE struct Screen   *Scr     = NULL;

// Long list for testing the scroller keys functionality:

PRIVATE UBYTE *testClasses[] =
{
   "This is a", "test of the", "ListBrowser", "gadget class.",
   "This is like", "a souped-up", "listview", "gadget.  It", "has many",
   "cool new", "features", "though like", "multiple", "columns,",
   "horizontal", "scrolling,", "images in", "nodes,", "columns titles",
   "and much much", "more!", NULL
};
#endif

PRIVATE struct DrawInfo *dri = NULL;

// Gadget ID's for usable Gadgets in the Requester:

enum  {

   GD_PClassStr, GD_CNameStr, GD_FNameStr,   GD_MethodsTE,
   GD_IVarsTE,   GD_ClassLV,  GD_AddClassBt, GD_CancelBt
};

// Communicate with our caller in ATalkBrowser: --------------------------

PRIVATE char   parentClass[80] = { 0, };
PRIVATE char   className[80]   = { 0, };
PRIVATE char   fileName[512]   = { 0, };

PRIVATE int reqReturnValue = FALSE;

# define CLASS_ADDED (TRUE+1)

PRIVATE APTR   outMethodsBuffer = NULL;
PRIVATE APTR   outIVarsBuffer   = NULL;

PRIVATE struct ListViewMem *clLVM = NULL;;

// ------------------------------------------------------------------------

// fonts for our GUI:

PRIVATE struct TextAttr helvetica13  = { "helvetica.font", 13, 0, FPF_DISKFONT };
PRIVATE struct TextAttr helvetica13B = { "helvetica.font", 13, FSF_BOLD, FPF_DISKFONT };

PRIVATE struct IntuiMessage ACRMsg  = { 0, };

PRIVATE struct Window   *ACRWnd     = NULL;
PRIVATE struct Gadget   *ACRGadgets[ 8 ];

#define PClassStr  ACRGadgets[ GD_PClassStr  ]
#define CNameStr   ACRGadgets[ GD_CNameStr   ]
#define FNameStr   ACRGadgets[ GD_FNameStr   ]
#define MethodsTE  ACRGadgets[ GD_MethodsTE  ]
#define IVarsTE    ACRGadgets[ GD_IVarsTE    ]
#define ClassLV    ACRGadgets[ GD_ClassLV    ]
#define AddClassBt ACRGadgets[ GD_AddClassBt ]
#define CancelBt   ACRGadgets[ GD_CancelBt   ]

PRIVATE struct List      displayList, *passedInList;

#define BUFFER_SIZE  4096

PRIVATE char initialMethodsBuffer[ BUFFER_SIZE ];
PRIVATE char initialIVarsBuffer[   BUFFER_SIZE ];

PRIVATE UWORD ACRTop    = 0;
PRIVATE UWORD ACRLeft   = 0;
PRIVATE UWORD ACRWidth  = 800; // 790
PRIVATE UWORD ACRHeight = 600; // 575

// ----------------------------------------------------------------------------------

#ifdef DEBUG

PUBLIC char *CMsgATB( int strIndex, char *defaultString )
{
   if (browserCatalog) // != NULL)
      return( (char *) GetCatalogStr( browserCatalog, strIndex, defaultString ) );
   else
      return( defaultString );
}

PRIVATE void MessageBoxA( char *format, APTR args )
{
   char buffer[512];

   memset( buffer, 0, 512 );

   RawDoFmt( format, args, NULL, buffer );

   UserInfo( buffer, "ATalkBrowser Add Class Message:" );

   return;
}

PRIVATE void VARARGS68K MessageBox( char *format, ... )
{
   va_list  ap;

   va_startlinear( ap, format );

   MessageBoxA( format, va_getlinearva( ap, void * ) );

   va_end( ap );
   
   return;
}   
#endif

PRIVATE void freeListBrowserNodes( struct List *list ) // list is an Exec-type list
{
   struct Node *node, *nextnode;

   if (!list) // == NULL)
      return; // No point in continuing
      
   node = list->lh_Head;

   while (nextnode = node->ln_Succ) // != NULL)
      {
      FreeListBrowserNode( node );

      node = nextnode;
      }

   return;
}

/* Function to make a List of ListBrowserNodes from an array of strings. */

#ifdef DEBUG
PRIVATE BOOL makeListBrowserNodes( struct List *inputList, UBYTE **labels )
{
   struct Node *node = NULL;
   BOOL         rval = TRUE;
   
   NewList( inputList );

   while (*labels) // != NULL)
      {
      if (node = AllocListBrowserNode( 1, LBNCA_CopyText, TRUE,
                                          LBNCA_Text,     *labels,
                                          LBNCA_MaxChars, 80,
                                          TAG_DONE )) // != NULL)
         {
         AddTail( inputList, node );
         }
      else
         {
         freeListBrowserNodes( inputList ); // Free what's been done so far!
	 
	 rval = FALSE;   
         break;
	 }

      labels++;
      }

   return( rval );
}

#else // DEBUG is NOT defined:

PRIVATE BOOL makeListBrowserNodes( struct List *inputList )
{
   struct Node *node      = NULL;
   struct Node *inputNode = NULL;
   WORD         i         = 0;
   BOOL         rval      = TRUE;
   
   inputNode = (struct Node *) inputList->lh_Head;
   
   NewList( &displayList );

   while (inputNode->ln_Name) // != NULL)
      {
      if (node = AllocListBrowserNode( 1, LBNCA_CopyText, TRUE,
                                          LBNCA_Text,     inputNode->ln_Name,
                                          LBNCA_MaxChars, 80,
                                          TAG_DONE )) // != NULL)
         {
         AddTail( &displayList, node );
         }
      else
         {
         freeListBrowserNodes( &displayList ); // Free what's been done so far!
	 
	 rval = FALSE;   
         break;
	 }

      inputNode = inputNode->ln_Succ;
      i++;
      }

   return( rval );
}
#endif

// -------------------------------------------------------------------------------

PRIVATE int PClassStrClicked( int dummy )
{
   char pclass[80] = { 0, };
   
   GetAttr( (ULONG) STRINGA_Buffer, (APTR) PClassStr, (ULONG *) pclass );
   
   StringNCopy( parentClass, pclass, 80 );

#  ifdef DEBUG
   MessageBox( "You clicked on the Parent Class string Gadget (%s)", parentClass );
#  endif

   return( TRUE );
}

PRIVATE int CNameStrClicked( int dummy )
{
   char thisClass[80] = { 0, };
   
   GetAttr( (ULONG) STRINGA_Buffer, (APTR) CNameStr, (ULONG *) thisClass );
   
   if (StringLength( thisClass ) > 0)
      StringNCopy( className, thisClass, 80 );

#  ifdef DEBUG
   MessageBox( "You clicked on the Class Name string Gadget (%s)", className );
#  endif

   return( TRUE );
}

PRIVATE int FNameStrClicked( int dummy )
{
   char fname[512] = { 0, };
   
   GetAttr( (ULONG) STRINGA_Buffer, (APTR) FNameStr, (ULONG *) fname );
   
   if (StringLength( fname ) > 0)
      StringNCopy( fileName, fname, 512 );

#  ifdef DEBUG
   MessageBox( "You clicked on the File Name string Gadget (%s)", fileName );
#  endif

   return( TRUE );
}

PRIVATE int MethodsTEClicked( int dummy )
{
   return( TRUE );
}

PRIVATE int IVarsTEClicked( int dummy )
{
   return( TRUE );
}

PRIVATE int ClassLVClicked( int whichItem )
{
#  ifdef DEBUG
   struct Node *node = NULL;
   char         errmsg[256] = { 0, };
   int          i    = 0;

   node = (struct Node *) displayList.lh_Head; 

   i = 0;

   while (i < whichItem)
      {
      node = node->ln_Succ;
      i++;
      }

   SetAttrs( (Object *) PClassStr, STRINGA_TextVal, testClasses[ whichItem ], TAG_DONE );

   sprintf( errmsg, "You selected %s[%d] in the ListView Gadget", node->ln_Name, whichItem );

   UserInfo( errmsg, "ATalkBrowserAddReq Message:" );

#  else // DEBUG NOT defined (how much simpler the code is here!):

   char *selection = &clLVM->lvm_NodeStrs[ whichItem * clLVM->lvm_NodeLength ];
   
   SetAttrs( (Object *) PClassStr, STRINGA_TextVal, selection, TAG_DONE );

   StringNCopy( parentClass, selection, 80 );

#  endif

   RefreshGList( ClassLV, ACRWnd, NULL, -1 ); // SetAttrs() is not smart enough to do this.

   return( TRUE );   
}

PRIVATE int AddClassBtClicked( int dummy )
{
#  ifdef DEBUG
   SetNotifyWindow( ACRWnd );
   
   UserInfo( "You clicked on the Add Class! button", "ATalkBrowserAddReq Message:" );

#  else        // The big enchilada!!:

   FILE  *outf    = NULL;
   
   reqReturnValue = FALSE;
   
   if ((StringLength( fileName ) < 1)
      || (StringComp( fileName, CMsgATB( MSG_UNKST, MSG_UNKST_STR ) ) == 0))
      {
      UserInfo( CMsgATB( MSG_ENTER_FNAME, MSG_ENTER_FNAME_STR ),
                CMsgATB( MSG_RQTITLE_USER_ERROR,  MSG_RQTITLE_USER_ERROR_STR  )
              );
      
      return( TRUE ); 
      }
   
   if (!(outf = fopen( fileName, "w" ))) // == NULL)
      {
      CannotOpenFile( fileName );
      
      return( TRUE );
      }   

   // Take Gadget Data & make a Class file from it:
   fprintf( outf, "\" -------------------------------------------------------- \"\n" );

   fprintf( outf, "\" %s %s \"\n", className,
                  CMsgATB( MSG_FORMAT_GEN, MSG_FORMAT_GEN_STR ) 
          );

   fprintf( outf, "\" -------------------------------------------------------- \"\n\n" );

   if (StringLength( parentClass ) < 1)
      fprintf( outf, "Class %s :Object \" %s \"\n", className,
               CMsgATB( MSG_FORMAT_NOPARENT, MSG_FORMAT_NOPARENT_STR )
             );
   else
      fprintf( outf, "Class %s :%s\n", className, parentClass );

   outIVarsBuffer = (APTR) DoGadgetMethod( IVarsTE, ACRWnd, NULL, GM_TEXTEDITOR_ExportText, TAG_DONE );

   if (StringLength( outIVarsBuffer ) > 0)
      {
      fprintf( outf, "! %s !\n", outIVarsBuffer );
      }
   else
      fprintf( outf, "! \" %s \" !\n", 
               CMsgATB( MSG_FORMAT_NOINSTANCES, MSG_FORMAT_NOINSTANCES_STR ) 
             );

   if (outIVarsBuffer)
      {
      FreeVec( outIVarsBuffer );
      
      outIVarsBuffer = NULL;
      }

   outMethodsBuffer = (APTR) DoGadgetMethod( MethodsTE, ACRWnd, NULL, GM_TEXTEDITOR_ExportText, TAG_DONE );

   if (StringLength( outIVarsBuffer ) > 0)
      {
      fprintf( outf, "[\n%s\n]\n", outMethodsBuffer );      
      }
   else
      fprintf( outf, "[\n   \" %s \"\n]\n", 
               CMsgATB( MSG_FORMAT_NOMETHODS, MSG_FORMAT_NOMETHODS_STR )
             );
      
   if (outMethodsBuffer)
      {
      FreeVec( outMethodsBuffer );
      
      outMethodsBuffer = NULL;
      }

wrapUp:
   
   if (outf) // != NULL)
      fclose( outf );
   
   reqReturnValue = CLASS_ADDED;

   UserInfo( CMsgATB( MSG_NOW_PRESS, MSG_NOW_PRESS_STR ),
             CMsgATB( MSG_RQTITLE_USER_INFO, MSG_RQTITLE_USER_INFO_STR )
           );
#  endif

   return( TRUE );
}

PRIVATE int CancelBtClicked( int dummy )
{
   reqReturnValue = FALSE;

   return( FALSE );
}

// -------------------------------------------------------------------------------

PRIVATE void closeLibraries( void )
{
#  ifdef __amigaos4__
   if (IListBrowser) // != NULL)
      DropInterface( (struct Interface *) IListBrowser );

   if (ILabel)       // != NULL)
      DropInterface( (struct Interface *) ILabel );

   if (IButton)       // != NULL)
      DropInterface( (struct Interface *) IButton );

   if (ButtonBase)
      CloseLibrary( ButtonBase );
      
   if (IString)       // != NULL)
      DropInterface( (struct Interface *) IString );

   if (StringBase)
      CloseLibrary( StringBase );

   if (ITextEditor)       // != NULL)
      DropInterface( (struct Interface *) ITextEditor );

   if (TextEditorBase)
      CloseLibrary( TextEditorBase );
#  ifdef DEBUG
   if (IGadTools)
      DropInterface( (struct Interface *) IGadTools );

   if (GadToolsBase)
      CloseLibrary( GadToolsBase );
#  endif
#  endif

   if (ListBrowserBase) // != NULL)
      CloseLibrary( ListBrowserBase );

   if (LabelBase)       // != NULL)
      CloseLibrary( LabelBase );

   return;
}

PRIVATE int reportLibraryFailure( char *whichLib )
{
   fprintf( stderr, CMsgATB( MSG_FORMAT_LIBRARY_FAILURE, MSG_FORMAT_LIBRARY_FAILURE_STR ), whichLib );

   closeLibraries();

   return( ERROR_INVALID_RESIDENT_LIBRARY );
}

PRIVATE int openLibraries( void )
{
   int rval = RETURN_OK;

#  ifdef __amigaos4__
   ULONG libVersion = 50L;
#  else
   ULONG libVersion = 44L; // Original value from the source code.
#  endif
   
   if (ListBrowserBase = OpenLibrary( "gadgets/listbrowser.gadget", libVersion )) // != NULL)
      {
#     ifdef __amigaos4__
      if (!(IListBrowser = (struct ListBrowserIFace *) GetInterface( ListBrowserBase, "main", 1, NULL )))
	 return( reportLibraryFailure( "IListBrowser.IFace" ) );
#     endif
      }
   else
      return( reportLibraryFailure( "ListBrowser.gadget" ) );

   if (LabelBase = OpenLibrary("images/label.image", libVersion ))
      {
#     ifdef __amigaos4__
      if (!(ILabel = (struct LabelIFace *) GetInterface( LabelBase, "main", 1, NULL )))
	 return( reportLibraryFailure( "ILable.IFace" ) );
#     endif
      }
   else
      return( reportLibraryFailure( "label.image" ) );

#  ifdef __amigaos4__

#  ifdef DEBUG
   if (GadToolsBase = OpenLibrary( "gadtools.library", libVersion ))
      {
      if (!(IGadTools = (struct GadToolsIFace *) GetInterface( GadToolsBase, "main", 1, NULL )))
	 return( reportLibraryFailure( "IGadTools.IFace" ) );
      }
   else
       return( reportLibraryFailure( "gadtools.library" ) );
#  endif

   if (ButtonBase = OpenLibrary( "gadgets/button.gadget", libVersion ))
      {
      if (!(IButton = (struct ButtonIFace *) GetInterface( ButtonBase, "main", 1, NULL )))
	 return( reportLibraryFailure( "IButton.IFace" ) );
      }
   else
      return( reportLibraryFailure( "gadgets/button.gadget" ) );

   if (StringBase = OpenLibrary( "gadgets/string.gadget", libVersion ))
      {
      if (!(IString = (struct StringIFace *) GetInterface( StringBase, "main", 1, NULL )))
	 return( reportLibraryFailure( "IString.IFace" ) );
      }
   else
      return( reportLibraryFailure( "gadgets/string.gadget" ) );

   if (TextEditorBase = OpenLibrary( "gadgets/texteditor.gadget", libVersion ))
      {
      if (!(ITextEditor = (struct TextEditorIFace *) GetInterface( TextEditorBase, "main", 1, NULL )))
	 return( reportLibraryFailure( "ITextEditor.IFace" ) );
      }
   else
      return( reportLibraryFailure( "gadgets/texteditor.gadget" ) );

#  endif

ExitOpenLibraries:

   return( rval );
}

PRIVATE void ShutdownProgram( BOOL madeList )
{
   if (madeList == TRUE)
      freeListBrowserNodes( &displayList );

   closeLibraries();

   if (ACRWnd) // != NULL)
      CloseWindow( ACRWnd );

   if (dri)    // != NULL)
      FreeScreenDrawInfo( Scr, dri );

#  ifdef DEBUG    
   if (Scr)    // != NULL)
      UnlockPubScreen( 0, Scr );
#  endif
      
   return;
}

PRIVATE int SetupProgram( char *pgmName )
{
   int rval = RETURN_OK;

   if ((rval = openLibraries()) != RETURN_OK)
      {
      goto ExitSetup;
      }

#  ifdef DEBUG
   if (!(Scr = LockPubScreen( NULL ))) // == NULL)
      {
      PutStr( "ERROR: Could NOT lock public screen\n" );
      
      ShutdownProgram( FALSE );
      
      goto ExitSetup;
      }
   else
      {
#  endif
      dri = GetScreenDrawInfo( Scr ); // For Pens & labels, etc.
      
      ACRTop  = (Scr->Height - ACRHeight) / 2; // Center the window in the Screen.
      ACRLeft = (Scr->Width  - ACRWidth ) / 2;
#  ifdef DEBUG
      }
#  endif

   // Open the window:

   if (!(ACRWnd = OpenWindowTags( NULL,

            WA_Left,         ACRTop,
            WA_Top,          ACRLeft,
            WA_Width,        ACRWidth,
            WA_Height,       ACRHeight,
            WA_CustomScreen, Scr,

            WA_IDCMP,        IDCMP_GADGETUP | IDCMP_MOUSEMOVE | IDCMP_RAWKEY
              | IDCMP_CLOSEWINDOW | IDCMP_GADGETDOWN | IDCMP_VANILLAKEY,

            WA_Flags,        WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET 
	      | WFLG_ACTIVATE | WFLG_SMART_REFRESH,

            WA_Title,        CMsgATB( MSG_ACR_WTITLE, MSG_ACR_WTITLE_STR ),

            WA_MinWidth,     200,
            WA_MinHeight,    40,
            WA_MaxWidth,     -1,
            WA_MaxHeight,    -1,

            TAG_DONE ))) // == NULL)
      {
      PutStr( "ERROR: Could NOT open window\n" );

      ShutdownProgram( FALSE );
      
      goto ExitSetup;
      }

ExitSetup:

   return( rval );
}

PRIVATE int getTextLength( char *text )
{
   struct IntuiText iText = { 0, };

   iText.IText     = (UBYTE *) text;
   iText.ITextFont = &helvetica13B;
   
   return( IntuiTextLength( &iText ) );
}

PRIVATE void displayGadgetLabel( char *label, int x, int y, int color )
{
   struct IntuiText iText;

   iText.FrontPen  = color;
   iText.BackPen   = dri->dri_Pens[ BACKGROUNDPEN ];
   iText.IText     = (UBYTE *) label;
   iText.DrawMode  = JAM1;
   iText.ITextFont = &helvetica13B;
   iText.NextText  = NULL;
   iText.LeftEdge  = x;
   iText.TopEdge   = y;

#  ifdef DEBUG
   fprintf( stderr, "Label Coords: (%d, %d)\n", x, y );
#  endif

   PrintIText( ACRWnd->RPort, &iText, 0, 0 );

   return;   
}

PRIVATE int createIVarsTE( void )
{
   if (IVarsTE = (struct Gadget *)
        NewObject( TEXTEDITOR_GetClass(), NULL,

            GA_ID,                          GD_IVarsTE,
            GA_Left,                        20,
            GA_Top,                         Scr->BarHeight + 462,
            GA_Width,                       360,
	    GA_Height,                      105,
            GA_TEXTEDITOR_CursorX,          0,
            GA_TEXTEDITOR_CursorY,          0,
#           ifdef __amigaos4__ // V50 settings:
	    GA_TEXTEDITOR_CursorBlinkSpeed, 500000,
	    GA_TEXTEDITOR_TabSize,          3,
#           endif
            GA_TEXTEDITOR_Pen,              dri->dri_Pens[ BLOCKPEN ],
            GA_TEXTEDITOR_Separator,        LNSF_Thick,
            GA_TEXTEDITOR_Contents,         (APTR) initialIVarsBuffer,
	    GA_TextAttr,                    &helvetica13,
	    GA_UserData,                    (APTR) MethodsTEClicked,

            TAG_END )) // != NULL)
      {
      UBYTE *textLabel = CMsgATB( MSG_IVARS_GAD, MSG_IVARS_GAD_STR );
      
      displayGadgetLabel( textLabel, // "Class Instance Variables:", 
                          20 + ((360 - getTextLength( textLabel )) / 2), 
			  Scr->BarHeight + 447,
			  dri->dri_Pens[ SHINEPEN ] 
			);

      return( RETURN_OK );
      }
   else
      return( RETURN_FAIL );
}

PRIVATE int createMethodsTE( void )
{
   if (MethodsTE = (struct Gadget *)
        NewObject( TEXTEDITOR_GetClass(), NULL,

            GA_ID,                          GD_MethodsTE,
            GA_Left,                        20,
            GA_Top,                         Scr->BarHeight + 92,
            GA_Width,                       360,
	    GA_Height,                      350,
            GA_TEXTEDITOR_CursorX,          0,
            GA_TEXTEDITOR_CursorY,          0,
            GA_TEXTEDITOR_Pen,              dri->dri_Pens[ BLOCKPEN ], // Don't do anything!
            GA_TEXTEDITOR_Separator,        LNSF_Thick,
            GA_TEXTEDITOR_Contents,         (APTR) initialMethodsBuffer,
#           ifdef __amigaos4__ // V50 settings:
	    GA_TEXTEDITOR_CursorBlinkSpeed, 10, // Just what is a good value??
	    GA_TEXTEDITOR_TabSize,          3,
#           endif
	    GA_Next,                        IVarsTE, 
	    GA_TextAttr,                    &helvetica13,
	    GA_UserData,                    (APTR) MethodsTEClicked,

            TAG_END )) // != NULL)
      {
      UBYTE *textLabel = CMsgATB( MSG_METHODS_GAD, MSG_METHODS_GAD_STR );

      displayGadgetLabel( textLabel, // "Enter Methods:", 
                          20 + ((360 - getTextLength( textLabel )) / 2), 
			  Scr->BarHeight + 78, 
			  dri->dri_Pens[ SHINEPEN ] 
			);

      return( RETURN_OK );
      }
   else
      return( RETURN_FAIL );
}

PRIVATE int createFNameStr( void )
{
   if (FNameStr = (struct Gadget *)
        NewObject( STRING_GetClass(), NULL,
            GA_ID,                    GD_FNameStr,
            GA_Left,                  99,
            GA_Top,                   Scr->BarHeight + 53,
            GA_Width,                 280,
	    GA_Height,                20,
            GA_RelVerify,             TRUE,
	    GA_Next,                  MethodsTE, 
	    STRINGA_Justification,    GACT_STRINGCENTER,
	    STRINGA_MaxChars,         256,
	    STRINGA_TextVal,          CMsgATB( MSG_UNKST, MSG_UNKST_STR ), // "Amigatalk:User/Unknown.st",
	    GA_TextAttr,              &helvetica13,
	    GA_UserData,              (APTR) FNameStrClicked,
            TAG_END )) // != NULL)
      {
      UBYTE *textLabel = CMsgATB( MSG_FNAME_GAD, MSG_FNAME_GAD_STR );

      displayGadgetLabel( textLabel, // "File Name:", 
                          99 - getTextLength( textLabel ) - 5, 
			  Scr->BarHeight + 56, 
			  dri->dri_Pens[ TEXTPEN ] 
			);

      return( RETURN_OK );
      }
   else
      return( RETURN_FAIL );
}

PRIVATE int createCNameStr( void )
{
   if (CNameStr = (struct Gadget *)
        NewObject( STRING_GetClass(), NULL,
            GA_ID,                    GD_CNameStr,
            GA_Left,                  99,
            GA_Top,                   Scr->BarHeight + 30,
            GA_Width,                 280,
	    GA_Height,                20,
            GA_RelVerify,             TRUE,
	    GA_Next,                  FNameStr, 
	    STRINGA_Justification,    GACT_STRINGCENTER,
	    STRINGA_MaxChars,         80,
	    STRINGA_TextVal,          CMsgATB( MSG_UNKNOWN, MSG_UNKNOWN_STR ), // "Unknown",
	    GA_TextAttr,              &helvetica13,
	    GA_UserData,              (APTR) CNameStrClicked,
            TAG_END )) // != NULL)
      {
      UBYTE *textLabel = CMsgATB( MSG_CNAME_GAD, MSG_CNAME_GAD_STR );

      displayGadgetLabel( textLabel, // "Class Name:", 
                          99 - getTextLength( textLabel ) - 5, 
			  Scr->BarHeight + 33, 
			  dri->dri_Pens[ TEXTPEN ] 
			);

      return( RETURN_OK );
      }
   else
      return( RETURN_FAIL );
}

PRIVATE int createAddClassBt( void )
{
   if (AddClassBt = (struct Gadget *)
        NewObject( BUTTON_GetClass(), NULL,
            GA_ID,                    GD_AddClassBt,
            GA_Left,                  390,
            GA_Top,                   Scr->BarHeight + 530,
            GA_Width,                 125,
	    GA_Height,                22,
	    GA_Text,                  CMsgATB( MSG_ADDCLASS_GAD, MSG_ADDCLASS_GAD_STR ), // "ADD CLASS!",
	    GA_Next,                  CNameStr,
            GA_RelVerify,             TRUE,
	    GA_TextAttr,              &helvetica13B,
	    GA_UserData,              (APTR) AddClassBtClicked,
            TAG_END )) // != NULL)
      {
      return( RETURN_OK );
      }
   else
      return( RETURN_FAIL );
}

PRIVATE int createCancelBt( void )
{
   if (CancelBt = (struct Gadget *)
        NewObject( BUTTON_GetClass(), NULL,
            GA_ID,                    GD_CancelBt,
            GA_Left,                  699,
            GA_Top,                   Scr->BarHeight + 530,
            GA_Width,                 85,
	    GA_Height,                22,
	    GA_Next,                  AddClassBt,
	    GA_Text,                  CMsgATB( MSG_CANCEL_GAD, MSG_CANCEL_GAD_STR ), // "_CANCEL!",
            GA_RelVerify,             TRUE,
	    GA_TextAttr,              &helvetica13B,
	    GA_UserData,              (APTR) CancelBtClicked,
            TAG_END )) // != NULL)
      {
      return( RETURN_OK );
      }
   else
      return( RETURN_FAIL );
}

PRIVATE int createPClassStr( void )
{
   if (PClassStr = (struct Gadget *)
        NewObject( STRING_GetClass(), NULL,
            GA_ID,                    GD_PClassStr,
            GA_Left,                  99,
            GA_Top,                   Scr->BarHeight + 7,
            GA_Width,                 280,
	    GA_Height,                20,
            GA_RelVerify,             TRUE,
	    GA_Next,                  CancelBt, 
	    STRINGA_Justification,    GACT_STRINGCENTER,
	    STRINGA_MaxChars,         80,
	    STRINGA_TextVal,          CMsgATB( MSG_UNKNOWN, MSG_UNKNOWN_STR ), // "Unknown",
	    GA_TextAttr,              &helvetica13,
	    GA_UserData,              (APTR) PClassStrClicked,
            TAG_END )) // != NULL)
      {
      UBYTE *textLabel = CMsgATB( MSG_PCLASS_GAD, MSG_PCLASS_GAD_STR );

      displayGadgetLabel( textLabel, // "Parent Class:", 
                          99 - getTextLength( textLabel ) - 5, 
			  Scr->BarHeight + 10, 
			  dri->dri_Pens[ TEXTPEN ] 
			);

      return( RETURN_OK );
      }
   else
      return( RETURN_FAIL );
}

PRIVATE int createListView( void )
{
   if (ClassLV = (struct Gadget *)
        NewObject( LISTBROWSER_GetClass(), NULL,
            GA_ID,                    GD_ClassLV,
            GA_Left,                  390,
            GA_Top,                   Scr->BarHeight + helvetica13.ta_YSize + 5,
            GA_Width,                 400,
	    GA_Height,                500,
            GA_RelVerify,             TRUE,
	    GA_UserData,              (APTR) ClassLVClicked,
	    GA_Next,                  PClassStr, 
	    GA_TextAttr,              &helvetica13,
            LISTBROWSER_Labels,       (ULONG) &displayList,
	    LISTBROWSER_Spacing,      2,
            LISTBROWSER_MultiSelect,  FALSE,
            LISTBROWSER_ShowSelected, TRUE,

            TAG_END )) // != NULL)
      {
      UBYTE *textLabel = CMsgATB( MSG_CLASSES_GAD, MSG_CLASSES_GAD_STR );

      (void) displayGadgetLabel( textLabel, // "Classes:", 
                                 390 + ((400 - getTextLength( textLabel )) / 2), 
				 Scr->BarHeight + 5, 
				 dri->dri_Pens[ TEXTPEN ]
			       );
      
      return( RETURN_OK );
      }
   else
      return( RETURN_FAIL );
}

PRIVATE void disposeGadgets( void )
{
   if (IVarsTE)
      DisposeObject( IVarsTE );
      
   if (MethodsTE)
      DisposeObject( MethodsTE );
      
   if (FNameStr)
      DisposeObject( FNameStr );
      
   if (CNameStr)
      DisposeObject( CNameStr );
      
   if (AddClassBt)
      DisposeObject( AddClassBt );
      
   if (CancelBt)
      DisposeObject( CancelBt );
      
   if (PClassStr)
      DisposeObject( PClassStr );

   if (ClassLV)
      DisposeObject( ClassLV );
      
   return;
}

PRIVATE int creationFailureNotice( char *whichGadget )
{
   sprintf( ErrMsg, CMsgATB( MSG_FORMAT_CREATION_FAILURE, MSG_FORMAT_CREATION_FAILURE_STR ), whichGadget );

   UserInfo( ErrMsg, CMsgATB( MSG_RQTITLE_SYSTEM_PROBLEM, MSG_RQTITLE_SYSTEM_PROBLEM_STR ) );
      
   disposeGadgets();
   
   return( RETURN_FAIL );
}

PRIVATE int createGadgets( void )
{
   if (createIVarsTE() != RETURN_OK)
      return( creationFailureNotice( "Instance Variables TextEditor" ) );

   if (createMethodsTE() != RETURN_OK)
      return( creationFailureNotice( "Enter Methods TextEditor" ) );

   if (createFNameStr() != RETURN_OK)
      return( creationFailureNotice( "File Name String" ) );

   if (createCNameStr() != RETURN_OK)
      return( creationFailureNotice( "Class Name String" ) );

   if (createAddClassBt() != RETURN_OK)
      return( creationFailureNotice( "ADD CLASS! Button" ) );

   if (createCancelBt() != RETURN_OK)
      return( creationFailureNotice( "CANCEL! Button" ) );

   if (createPClassStr() != RETURN_OK)
      return( creationFailureNotice( "Parent Class String" ) );

   if (createListView() != RETURN_OK)
      return( creationFailureNotice( "Classes ListBrowser" ) );
   else
      return( RETURN_OK );
}

// ------------------------------------------------------------------------------------

PRIVATE void upArrowClicked( struct IntuiMessage *imsg )
{
   struct Gadget *gadget = (struct Gadget *) imsg->IAddress;
   LONG           gid    = gadget->GadgetID;
   
   switch (gid)
      {
      case GD_ClassLV:
         if (imsg->Qualifier & QUALIFIER_CTRL) // != 0)
            SetGadgetAttrs( ClassLV, ACRWnd, NULL, LISTBROWSER_Position, LBP_TOP, TAG_DONE );

         if (imsg->Qualifier & QUALIFIER_SHIFT) // != 0)
            SetGadgetAttrs( ClassLV, ACRWnd, NULL, LISTBROWSER_Position, LBP_PAGEUP, TAG_DONE );
         else
            SetGadgetAttrs( ClassLV, ACRWnd, NULL, LISTBROWSER_Position, LBP_LINEUP, TAG_DONE );
         break;

      case GD_MethodsTE:	 
         if (imsg->Qualifier & QUALIFIER_CTRL) // != 0)
            SetGadgetAttrs( MethodsTE, ACRWnd, NULL, GA_TEXTEDITOR_CursorY, 0,
	                                             GA_TEXTEDITOR_CursorX, 0, 
					             TAG_DONE 
		          );

         if (imsg->Qualifier & QUALIFIER_SHIFT) // != 0)
            SetGadgetAttrs( MethodsTE, ACRWnd, NULL, GA_TEXTEDITOR_CursorY, -10, TAG_DONE );
         break;

      case GD_IVarsTE:	 
         break;

      default:
         break;
      }

   return;
}

PRIVATE void downArrowClicked( struct IntuiMessage *imsg )
{
   struct Gadget *gadget = (struct Gadget *) imsg->IAddress;
   LONG           gid    = gadget->GadgetID;
   
   switch (gid)
      {
      case GD_ClassLV:
         if (imsg->Qualifier & QUALIFIER_CTRL) // != 0)
            SetGadgetAttrs( ClassLV, ACRWnd, NULL, LISTBROWSER_Position, LBP_BOTTOM, TAG_DONE );

         if (imsg->Qualifier & QUALIFIER_SHIFT) // != 0)
            SetGadgetAttrs( ClassLV, ACRWnd, NULL, LISTBROWSER_Position, LBP_PAGEDOWN, TAG_DONE );
         else
            SetGadgetAttrs( ClassLV, ACRWnd, NULL, LISTBROWSER_Position, LBP_LINEDOWN, TAG_DONE );
	 break;

      case GD_MethodsTE:	 
         if (imsg->Qualifier & QUALIFIER_CTRL) // != 0)
            SetGadgetAttrs( MethodsTE, ACRWnd, NULL, GA_TEXTEDITOR_CursorY, 66,
	                                             GA_TEXTEDITOR_CursorX, 0, 
					             TAG_DONE 
		          );

         if (imsg->Qualifier & QUALIFIER_SHIFT) // != 0)
            SetGadgetAttrs( MethodsTE, ACRWnd, NULL, GA_TEXTEDITOR_CursorY, 10, TAG_DONE );
         break;

      case GD_IVarsTE:	 
         break;

      default:
         break;
      }

   return;
}

PRIVATE int ACRVanillaKey( int whichKey )
{
   int rval = TRUE;
   
   switch (whichKey)
      {
      case 'c':
      case 'C':
         rval = CancelBtClicked( 0 );
	 break;
 
      default:
         break;
      }
      
   return( rval );
}

PRIVATE void HandleACRIDCMP( void )
{
   struct Gadget       *gadget;
   struct IntuiMessage *imsg;
   BOOL                 running = TRUE;
   int                (*func)( int );
   
   while (running == TRUE)
      {
      if (!(imsg = (struct IntuiMessage *) GetMsg( ACRWnd->UserPort ))) // == NULL) 
         {
         (void) Wait( 1L << ACRWnd->UserPort->mp_SigBit );

         continue;
         }

      CopyMem( (char *) imsg, (char *) &ACRMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      ReplyMsg( (struct Message *) imsg ); // Respond as fast as possible!
      
      switch (ACRMsg.Class)
         {
         case IDCMP_CLOSEWINDOW:
            running = FALSE;
            break;

         case IDCMP_VANILLAKEY:
	    running = ACRVanillaKey( ACRMsg.Code );
	    break;
	    
         case IDCMP_GADGETUP:

            func   = (int (*)( int )) ((struct Gadget *) ACRMsg.IAddress)->UserData;
            if (func)
               running = func( ACRMsg.Code );
		  
            break;

         case IDCMP_RAWKEY:
            if (!(ACRMsg.Code & IECODE_UP_PREFIX)) // == 0)
               {
               switch (ACRMsg.Code)
                  {
                  case RAWKEY_CURSORUP:
                     upArrowClicked( &ACRMsg );
                     break;
			
                  case RAWKEY_CURSORDOWN:
                     downArrowClicked( &ACRMsg );
                     break;

                  default:
                     break;
                  }
               }
            break;
      
         default:
            break;
         }
      }

   return;
}

#ifdef DEBUG

PUBLIC int main( int argc, char *argv[] )
{
   BOOL madeList = FALSE;
   int  rval     = RETURN_OK;

   if (argc == 3)
      {
      sprintf( &initialMethodsBuffer[ 0 ], "%*s", BUFFER_SIZE, argv[1] );
      sprintf( &initialIVarsBuffer[ 0 ], "%*s", BUFFER_SIZE, argv[2] );
      }
   else
      {
      sprintf( &initialMethodsBuffer[ 0 ], CMsgATB( MSG_SAMPLE_METHOD, MSG_SAMPLE_METHOD_STR ) );

      sprintf( &initialIVarsBuffer[ 0 ], CMsgATB( MSG_SAMPLE_INSTANCES, MSG_SAMPLE_INSTANCES_STR ) );
      }

   if ((rval = SetupProgram( argv[0] )) != RETURN_OK)   
      {
      // SetupProgram() cleans up after itself, so...
      fprintf( stderr, "Could NOT setup %s!\n", argv[0] );

      return( rval ); // We can bail out here because SetupProgram() is such a nice function.
      }

   if ((madeList = makeListBrowserNodes( &displayList, testClasses )) != TRUE)
      {
      PutStr( "ERROR: Could NOT make Node for ListBrowser!\n" );

      goto BailOut;
      } 

   // Create a listbrowser gadget.
//   PutStr( "Creating ListBrowser object\n" );
   
   if (createGadgets() != RETURN_OK)
      {
      goto BailOut; // Already flagged the error...
      }

   // Adding gadgets.
//   PutStr( "Adding gadgets...\n" );
   AddGList( ACRWnd, ClassLV, -1, -1, NULL );

//   PutStr( "Refreshing gadget\n" );
   RefreshGList( ClassLV, ACRWnd, NULL, -1 );

   // Wait for close gadget click to continue.
   SetWindowTitles( ACRWnd, "Submit New Class to AmigaTalkPPC:", (UBYTE *) ~0 );

   HandleACRIDCMP();

   RemoveGList( ACRWnd, ClassLV, -1 ); // Opposite of AddGList()

   disposeGadgets();

BailOut:

   ShutdownProgram( madeList );

   return( rval );
}

#else

PUBLIC int browserAddReq( char               *parentClassName, 
                          struct ListViewMem *classesLVM,
                          struct List        *inputClassList
                        )
{
#  ifndef DEBUG  
   IMPORT struct Window *ATBWnd;
   IMPORT struct Screen *Scr;
#  else
   struct Window *ATBWnd = NULL;
   struct Screen *Scr    = LockPubScreen();
#  endif
      
   BOOL madeList = FALSE;
   int  rval     = RETURN_OK;

   passedInList = inputClassList; // In case GetAttrs() does not work in ClassLVClicked().
   
   sprintf( &initialMethodsBuffer[ 0 ], CMsgATB( MSG_SAMPLE_METHOD, MSG_SAMPLE_METHOD_STR ) );

   sprintf( &initialIVarsBuffer[ 0 ], CMsgATB( MSG_SAMPLE_INSTANCES, MSG_SAMPLE_INSTANCES_STR ) );

   if ((rval = SetupProgram( "ATalkBrowserAddReq()" )) != RETURN_OK)   
      {
      // SetupProgram() cleans up after itself, so...
      UserInfo( CMsgATB( MSG_ACR_SETUP_PROBLEM, MSG_ACR_SETUP_PROBLEM_STR ),
                CMsgATB( MSG_RQTITLE_ATALK_PROBLEM, MSG_RQTITLE_ATALK_PROBLEM_STR ) 
	      );

      return( rval ); // We can bail out here because SetupProgram() is such a nice function.
      }

   clLVM = classesLVM;

   if ((madeList = makeListBrowserNodes( inputClassList )) != TRUE)
      {
      UserInfo( CMsgATB( MSG_ACR_NO_NODES,           MSG_ACR_NO_NODES_STR ),
                CMsgATB( MSG_RQTITLE_SYSTEM_PROBLEM, MSG_RQTITLE_SYSTEM_PROBLEM_STR )
              );

      goto BailOut;
      } 

//   PutStr( "Creating ListBrowser object\n" );
   
   if (createGadgets() != RETURN_OK)
      {
      goto BailOut; // Already flagged the error...
      }

//   PutStr( "Adding gadgets...\n" );
   AddGList( ACRWnd, ClassLV, -1, -1, NULL );

//   PutStr( "Refreshing gadget\n" );
   RefreshGList( ClassLV, ACRWnd, NULL, -1 );

   SetAttrs( (Object *) PClassStr, STRINGA_TextVal, parentClassName, TAG_DONE );

   SetAttrs( (Object *) CNameStr, STRINGA_TextVal, 
                        CMsgATB( MSG_UNKNOWN, MSG_UNKNOWN_STR ), TAG_DONE 
           );

   SetAttrs( (Object *) FNameStr, STRINGA_TextVal, 
                        CMsgATB( MSG_UNKST, MSG_UNKST_STR ), TAG_DONE 
           );
 
   // Activate the first texteditor gadget.
   ActivateGadget( MethodsTE, ACRWnd, NULL );

   HandleACRIDCMP();

   RemoveGList( ACRWnd, ClassLV, -1 ); // Opposite of AddGList()

   SetNotifyWindow( ATBWnd );

   disposeGadgets();

BailOut:

   ShutdownProgram( madeList );

   if (dri)
      FreeScreenDrawInfo( Scr, dri );

#  ifdef DEBUG
   if (Scr)
      UnlockPubScreen( 0, Scr );
#  endif

   return( reqReturnValue );
}
#endif

/* ----------------- END of ATalkBrowserAddReq.c file ----------------- */
