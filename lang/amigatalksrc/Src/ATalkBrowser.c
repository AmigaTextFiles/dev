/****h* ATalkBrowser.c [3.0] **************************************
*
* NAME
*    ATalkBrowser.c
*
* DESCRIPTION
*    A Class browser for AmigaTalk that does not depend on CanDo!
*
* HISTORY
*    24-Oct-2004 - Added AmigaOS4 & gcc support.
*    23-Feb-2003 - Created this file.
*
* NOTES
*    ToolTypes:
*      generalClassFileName  =AmigaTalk:Browser/GeneralClasses
*      systemClassFileName   =AmigaTalk:Browser/SystemClasses
*      intuitionClassFileName=AmigaTalk:Browser/IntuitionClasses
*      userClassFileName     =AmigaTalk:Browser/UserClasses
*      ExternalEditor        =C:Ed
*      ToolTypesEditor       =Amigatalk:c/ToolTypesEditor
*
*    FUNCTIONAL INTERFACE:
*      PUBLIC int useBrowser( struct Window *parentW, char *browserName );
*
*    EXTERNAL FUNCTIONS:
*      int chk = browserAddReq( char               *parentClassName,
*                               struct ListViewMem *classesLVM,
*                               struct List        *classesList
*                             );
*
*      int chk = browserDelReq( char               *className,
*                               struct ListViewMem *classesLVM,
*                               struct List        *classesList
*                             );
*
*    GUI Designed by : Jim Steichen
*    $VER: ATalkBrowser.c 3.0 (23-Feb-2003) by J.T. Steichen
*******************************************************************
*
*/

#include <stdio.h>
#include <string.h>

#include <exec/types.h>
#include <exec/memory.h>

#include <AmigaDOSErrs.h>

#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/imageclass.h>
#include <intuition/gadgetclass.h>

#include <workbench/workbench.h>
#include <workbench/startup.h>
#include <workbench/icon.h>

#include <libraries/gadtools.h>

#include <utility/tagitem.h>

#include <graphics/displayinfo.h>
#include <graphics/gfxbase.h>

#ifndef __amigaos4__
# include <clib/exec_protos.h>
# include <clib/dos_protos.h>
# include <clib/intuition_protos.h>
# include <clib/gadtools_protos.h>
# include <clib/graphics_protos.h>
# include <clib/utility_protos.h>
# include <clib/diskfont_protos.h>

IMPORT struct IntuitionBase *IntuitionBase;
IMPORT struct Library       *GadToolsBase;
IMPORT struct Library       *IconBase;
IMPORT struct LocaleBase    *LocaleBase;

IMPORT struct WBStartup     *_WBenchMsg;

#else

# define __USE_INLINE__

# include <proto/dos.h>
# include <proto/exec.h>
# include <proto/intuition.h>
# include <proto/gadtools.h>
# include <proto/graphics.h>
# include <proto/utility.h>
# include <proto/diskfont.h>

IMPORT struct WBStartup *__WBenchMsg;

IMPORT struct Library *IntuitionBase;
IMPORT struct Library *GadToolsBase;
IMPORT struct Library *IconBase;
IMPORT struct Library *LocaleBase;

IMPORT struct LocaleIFace *ILocale;

#endif

#include <Author.h>

#include <proto/locale.h>

#define   CATCOMP_ARRAY    1

#include "ATBrowserLocale.h"

#define  MY_LANGUAGE "english"

#include "FuncProtos.h"

#include "CPGM:GlobalObjects/CommonFuncs.h"

#ifndef  StrBfPtr
# define StrBfPtr( g ) (((struct StringInfo *)g->SpecialInfo)->Buffer)
#endif

#define GD_CLASSES_LV    0
#define GD_METHODS_LV    1
#define GD_METHODSRC_LV  2
#define GD_CMD_STRING    3

#define ATB_CNT          4

#define CLASSES_GAD ATBGadgets[ GD_CLASSES_LV   ]
#define METHODS_GAD ATBGadgets[ GD_METHODS_LV   ]
#define METHOD_GAD  ATBGadgets[ GD_METHODSRC_LV ]
#define COMMAND_GAD ATBGadgets[ GD_CMD_STRING   ]

#define COMMAND_STRING StrBfPtr( COMMAND_GAD )

// ---------------------------------------------------------

IMPORT OBJECT *o_nil;

IMPORT struct Screen        *Scr;
IMPORT struct TextAttr      *Font; // , Attr;
IMPORT struct CompFont       CFont;
IMPORT struct TagItem        LoadTags[]; // For later.
IMPORT struct TagItem        SaveTags[];

IMPORT UWORD  ATScrWidth, ATScrHeight;

IMPORT UBYTE *ErrMsg;
IMPORT APTR   VisualInfo;

// -----------------------------------------------------------

IMPORT int browserAddReq( char               *parentClassName, 
                          struct ListViewMem *classesLVM,
                          struct List        *classList
                        );

IMPORT int browserDelReq( char               *className,
                          struct ListViewMem *classesLVM,
                          struct List        *classesList 
                        );

// -----------------------------------------------------------

PUBLIC struct Catalog *browserCatalog = NULL;
PUBLIC struct Window  *ATBWnd         = NULL;

// -----------------------------------------------------------

PRIVATE struct Gadget       *ATBGList = NULL;
PRIVATE struct Menu         *ATBMenus = NULL;
//PRIVATE struct TextFont     *ATBFont  = NULL;
PRIVATE struct Gadget       *ATBGadgets[ ATB_CNT ] = { 0, };
PRIVATE struct IntuiMessage  ATBMsg;

PRIVATE UWORD ATBLeft    = 0;
PRIVATE UWORD ATBTop     = 0;

#ifdef __SASC
PRIVATE UWORD ATBWidth   = 800; // ATScrWidth;
PRIVATE UWORD ATBHeight  = 600; // ATScrHeight;
#else
PRIVATE UWORD ATBWidth   = 1024; // ATScrWidth;
PRIVATE UWORD ATBHeight  = 768;  // ATScrHeight;
#endif

PRIVATE UBYTE ATBWdt[80] = "AmigaTalkPPC Browser (C) 2004 by J.T. Steichen";

PRIVATE UBYTE ATBPgmName[256] = "TheBrowser";

PRIVATE int ATBLoadFile(         void );
PRIVATE int ATBSaveFile(         void );
PRIVATE int ATBSaveAsFile(       void );
PRIVATE int ATBToolTypesEditor(  void );
PRIVATE int ATBDisplayInstances( void );
PRIVATE int ATBAboutDisplay(     void );
PRIVATE int ATBQuitProgram(      void );
PRIVATE int ATBAddClassReq(      void );
PRIVATE int ATBAddMethodReq(     void );
PRIVATE int ATBGotoEditor(       void );
PRIVATE int ATBDisplaySource(    void );
PRIVATE int ATBDisplayByteCodes( void );
PRIVATE int ATBDelClassReq(      void );
PRIVATE int ViewAllClicked(      void );
PRIVATE int ViewSystemClicked(   void );
PRIVATE int ViewGeneralClicked(  void );
PRIVATE int ViewIntuiClicked(    void );
PRIVATE int ViewUserClicked(     void );

PRIVATE struct NewMenu ATBNewMenu[] = {

   NM_TITLE, "PROJECT",              NULL, 0, 0L, NULL,
    NM_ITEM, "Load...",               "L", 0, 0L, (APTR) ATBLoadFile,
    NM_ITEM, "Save",                  "S", 0, 0L, (APTR) ATBSaveFile,
    NM_ITEM, "Save As...",            "A", 0, 0L, (APTR) ATBSaveAsFile,
    NM_ITEM, NM_BARLABEL,            NULL, 0, 0L, NULL,
    NM_ITEM, "Edit ToolTypes...",    NULL, 0, 0L, (APTR) ATBToolTypesEditor,
    NM_ITEM, "Display Instances...", NULL, 0, 0L, (APTR) ATBDisplayInstances,
    NM_ITEM, NM_BARLABEL,            NULL, 0, 0L, NULL,
    NM_ITEM, "About...",              "I", 0, 0L, (APTR) ATBAboutDisplay,
    NM_ITEM, "Quit",                  "Q", 0, 0L, (APTR) ATBQuitProgram,
 
   NM_TITLE, "VIEW",              NULL, 0, 0L, NULL,
    NM_ITEM, "All Classes",       NULL, CHECKIT | CHECKED | MENUTOGGLE,
      0L, (APTR) ViewAllClicked,
       
    NM_ITEM, "General Classes",    NULL, CHECKIT | MENUTOGGLE,
      0L, (APTR) ViewGeneralClicked,
       
    NM_ITEM, "System Classes",    NULL, CHECKIT | MENUTOGGLE,
      0L, (APTR) ViewSystemClicked,
       
    NM_ITEM, "Intuition Classes", NULL, CHECKIT | MENUTOGGLE,
      0L, (APTR) ViewIntuiClicked,
       
    NM_ITEM, "User Classes",      NULL, CHECKIT | MENUTOGGLE,
      0L, (APTR) ViewUserClicked,
       
   NM_TITLE, "EDITING",         NULL, 0, 0L, NULL,
    NM_ITEM, "Add  Class..",    NULL, 0, 0L, (APTR) ATBAddClassReq,
    NM_ITEM, "Add  Method..",   NULL, 0, 0L, (APTR) ATBAddMethodReq,
    NM_ITEM, "Edit Method...",  NULL, 0, 0L, (APTR) ATBGotoEditor,
    NM_ITEM, "Delete Class...", NULL, 0, 0L, (APTR) ATBDelClassReq,
 
   NM_TITLE, "OPTIONS",        NULL, 0, 0L, NULL,

    NM_ITEM, "Show Source",    NULL, CHECKIT | CHECKED | MENUTOGGLE, 
      0L, (APTR) ATBDisplaySource,

    NM_ITEM, "Show ByteCodes", NULL, CHECKIT | MENUTOGGLE, 
      0L, (APTR) ATBDisplayByteCodes,
  
   NM_END, NULL, NULL, 0, 0L, NULL 
};

PRIVATE UWORD ATBGTypes[ ATB_CNT ] = {

   LISTVIEW_KIND, LISTVIEW_KIND, LISTVIEW_KIND, STRING_KIND
};

PRIVATE int ClassesLVClicked(   int whichItem );
PRIVATE int MethodsLVClicked(   int whichItem );
PRIVATE int MethodSrcLVClicked( int whichItem );
PRIVATE int CommandStrClicked(  int dummy     );

PRIVATE struct NewGadget ATBNGad[ ATB_CNT ] = {

     6,  17, 360, 288, "Classes:",         NULL, GD_CLASSES_LV, 
   PLACETEXT_ABOVE, NULL, (APTR) ClassesLVClicked,

   376,  17, 410, 288, "Methods:",         NULL, GD_METHODS_LV, 
   PLACETEXT_ABOVE, NULL, (APTR) MethodsLVClicked,

     6, 327, 782, 232, "Selected Method:", NULL, GD_METHODSRC_LV, 
   PLACETEXT_ABOVE, NULL, (APTR) MethodSrcLVClicked,

   153, 557, 630,  17, "Your Command:",    NULL, GD_CMD_STRING, 
   PLACETEXT_LEFT, NULL, (APTR) CommandStrClicked
};

PRIVATE ULONG ATBGTags[] = {

   GTLV_ShowSelected, 0, LAYOUTA_Spacing, 2, TAG_DONE,
   GTLV_ShowSelected, 0, LAYOUTA_Spacing, 2, TAG_DONE,
   GTLV_ShowSelected, 0, LAYOUTA_Spacing, 2, TAG_DONE,

   GA_TabCycle, FALSE, GTST_MaxChars, 256, 
   STRINGA_Justification, GACT_STRINGCENTER, TAG_DONE
};

PRIVATE int classesIndex     = 0; // for the Classes ListView Gadget
PRIVATE int lastClassIndex   = 0;
PRIVATE int methodsIndex     = 0; // for the Methods ListView Gadget
PRIVATE int lastMethodsIndex = 0;
PRIVATE int methodIndex      = 0; // for the MethodSrc ListView Gadget
PRIVATE int lastMethodIndex  = 0;

PRIVATE int lastSelectedGad  = GD_CLASSES_LV; // SELECTED Flag not working (sigh)

PRIVATE BOOL displaySource = TRUE; // FALSE means display ByteCodes

// TTTTTTTTT ToolTypes: TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT

PRIVATE char genClassFN[80] = "GENERALCLASSFILENAME";
PRIVATE char sysClassFN[80] = "SYSTEMCLASSFILENAME";
PRIVATE char intClassFN[80] = "INTUITIONCLASSFILENAME";
PRIVATE char usrClassFN[80] = "USERCLASSFILENAME";
PRIVATE char ExtEditor[80]  = "EXTERNALEDITOR";
PRIVATE char ToolEditor[80] = "TOOLTYPESEDITOR";

PRIVATE char DefgenClassFN[256] = "AmigaTalk:Browser/GeneralClasses";
PRIVATE char DefsysClassFN[256] = "AmigaTalk:Browser/SystemClasses";
PRIVATE char DefintClassFN[256] = "AmigaTalk:Browser/IntuitionClasses";
PRIVATE char DefusrClassFN[256] = "AmigaTalk:Browser/UserClasses";
PRIVATE char DefExtEditor[256]  = "C:Ed";
PRIVATE char DefToolEditor[256] = "Amigatalk:c/ToolTypesEditor";

PRIVATE char *TTgenClassFN = &DefgenClassFN[0];
PRIVATE char *TTsysClassFN = &DefsysClassFN[0];
PRIVATE char *TTintClassFN = &DefintClassFN[0];
PRIVATE char *TTusrClassFN = &DefusrClassFN[0];
PRIVATE char *TTExtEditor  = &DefExtEditor[0];
PRIVATE char *TTToolEditor = &DefToolEditor[0];

PRIVATE struct DiskObject   *brIcon_do = NULL;

PRIVATE void *processATBTools( STRPTR *toolptr )
{
   if (!toolptr) // == NULL)
      return( NULL );

   TTgenClassFN = GetToolStr( toolptr, genClassFN, DefgenClassFN );
   TTsysClassFN = GetToolStr( toolptr, sysClassFN, DefsysClassFN );
   TTintClassFN = GetToolStr( toolptr, intClassFN, DefintClassFN );
   TTusrClassFN = GetToolStr( toolptr, usrClassFN, DefusrClassFN );

   TTExtEditor  = GetToolStr( toolptr, ExtEditor,  DefExtEditor  );
   TTToolEditor = GetToolStr( toolptr, ToolEditor, DefToolEditor );

   return( NULL );
}

// TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT

// -------------------------------------------------------------

/****h* CMsgATB() [2.3] **********************************************
*
* NAME
*    CMsgATB()
*
* DESCRIPTION
*    Obtain a string from the locale catalog file, failing that,
*    return the default string.
**********************************************************************
*
*/

PUBLIC char *CMsgATB( int strIndex, char *defaultString )
{
   if (browserCatalog) // != NULL)
      return( (char *) GetCatalogStr( browserCatalog, strIndex, defaultString ) );
   else
      return( defaultString );
}

/****h* Aaarrgg() [3.0] **********************************************
*
* NAME
*    Aaarrgg()
*
* DESCRIPTION
*    Show the User an Information requester.
**********************************************************************
*
*/

PUBLIC void Aaarrgg( char *msg, char *title )
{
   SetReqButtons( CMsgATB( MSG_OKAY_GAD, MSG_OKAY_GAD_STR ) );

   (void) Handle_Problem( msg, title, NULL );

   SetReqButtons( CMsgATB( MSG_DEFAULT_BUTTONS_STR, MSG_DEFAULT_BUTTONS_STR_STR ) );
   
   return;
}

/****h* countATBClasses() [3.0] **************************************
*
* NAME
*    countATBClasses()
*
* DESCRIPTION
*    Determine the number of Classes in the file specified.  There's
*    one class for each line in the following format:
*
*      className:sourceFile.st:parentClass\n
**********************************************************************
*
*/

PUBLIC int countATBClasses( char *fileName )
{
   FILE *classFile = fopen( fileName, "r" );
   int   rval = 0, column = 0, ch = 0;
   
   if (!classFile) // == NULL)
      return( rval );
      
   if ((ch = fgetc( classFile )) != '\n')
      column++;
   
   while (ch != EOF)
      {
      if (ch == '\n' && column != 0)
         {
         rval++;
         column = 0;
         }
      else
         column++;

      ch = fgetc( classFile );
      } 

   if (classFile != NULL)
      fclose( classFile );
            
   return( rval );  
}

#define VIEW_ALL 1
#define VIEW_GEN 2
#define VIEW_SYS 3
#define VIEW_INT 4
#define VIEW_USR 5

PRIVATE int viewType = VIEW_ALL;

#define CLASSES_ELEMENTSIZE   80
#define METHODS_ELEMENTSIZE   80
#define METHODSRC_ELEMENTSIZE 128

PRIVATE struct List         classesList   = { 0, };
PRIVATE struct List         methodsList   = { 0, };
PRIVATE struct List         methodSrcList = { 0, };
PRIVATE struct ListViewMem *classesLVM    = NULL;
PRIVATE struct ListViewMem *methodsLVM    = NULL;
PRIVATE struct ListViewMem *methodSrcLVM  = NULL;

// ----------------------------------------------------

PRIVATE BOOL   allocSrcParentArrays = FALSE;
PRIVATE int    arraySize            = 0;
//PRIVATE char **sourceFileNames      = NULL;
PRIVATE char **parentClassNames     = NULL;

SUBFUNC void fillInSourceFile_Parents( char *classString, int index )
{
   char cp[256] = { 0, }, *copy = &cp[0], *tok1, *tok2, *ptr;
   int  i = 0;
   
   if (allocSrcParentArrays == FALSE)
      {
      return;
      }

   StringNCopy( copy, classString, 256 );
   
   tok1 = strpbrk( copy, ":\n" );
   tok1++;
   
   StringCopy( copy, tok1 );
   tok1 = copy;
      
   tok2 = strpbrk( copy, ":\n" );
   tok2++;
   
   copy = tok1;
   
   while (*(copy + i) != '\n' && *(copy + i) != ':')
      i++;
      
   *(copy + i) = '\0';
   tok1        = copy;
/*   
   ptr = (char *) AllocVec( (strlen( tok1 ) + 1) * sizeof( UBYTE ), 
                             MEMF_CLEAR | MEMF_ANY 
                          );
   if (ptr == NULL)
      return;
      
   strcpy( ptr, copy );

   sourceFileNames[ index ] = ptr;
*/   
   copy = tok2;
   i    = 0;
   
   while (*(copy + i) != '\n' && *(copy + i) != '\0')
      i++;
   
   *(copy + i) = '\0';
   tok2        = copy;

   ptr = (char *) AllocVec( (StringLength( tok2 ) + 1) * sizeof( UBYTE ), 
                             MEMF_CLEAR | MEMF_ANY 
                          );
   if (ptr == NULL)
      {
//      FreeVec( sourceFileNames[ index ] );  
      return;
      }

   StringCopy( ptr, copy );

   parentClassNames[ index ] = ptr;
   
   return;
}

/****i* clipFileName_Parent() [3.0] ******************************
*
* NAME
*    clipFileName_Parent()
*
* DESCRIPTION
*    Remove the source filename & parent Class name from the 
*    supplied string, which has the following format:
*
*      className:sourceFile.st:parentClass\n
******************************************************************
*
*/

SUBFUNC void clipFileName_Parent( char *string )
{
   int i = 0, len = StringLength( string );
   
   while (i < len && *(string + i) != '\0' 
                  && *(string + i) != '\n' 
                  && *(string + i) != ':')
      {
      i++;
      }
   
   if (*(string + i) == ':')
      *(string + i) = '\0';
   else if (*(string + i) == '\n')
      *(string + i) = '\0';
      
   return;
}

SUBFUNC void ClassesToListView( struct ListViewMem *lvm, char *fileName )
{
   FILE *classFile = fopen( fileName, "r" );

   char  instr[ CLASSES_ELEMENTSIZE ] = { 0, };
   int   i = 0;
   int   nodeSize = lvm->lvm_NodeLength;
   
   FGetS( instr, CLASSES_ELEMENTSIZE, classFile );

   /* Since this function might get called up to four times, we have to
   ** keep track of where we are in the listview with a global index
   ** variable, lastClassIndex:
   */   
   i = lastClassIndex;
   
   while (StringLength( instr ) > 1) // (instr[1] != '\0')
      {
      fillInSourceFile_Parents( instr, i );
      
      clipFileName_Parent( instr );
      
      StringNCopy( &lvm->lvm_NodeStrs[ i * nodeSize ], instr, nodeSize );
   
      if (i < lvm->lvm_NumItems)
         i++;
   
      if (FGetS( instr, CLASSES_ELEMENTSIZE, classFile ) == NULL)
         break;   
      }

   if (i > lastClassIndex)
      lastClassIndex = i; // += i; ???
            
   if (classFile) // != NULL)
      fclose( classFile );

   GT_SetGadgetAttrs( CLASSES_GAD, ATBWnd, NULL, 
                      GTLV_Labels,      &classesList,
                      GTLV_Selected,    0,
                      GTLV_MakeVisible, 0,
                      TAG_DONE 
                    );

   return;
}

PRIVATE int updateClassesLV( struct ListViewMem *lvm, int newcount )
{
   if (lvm->lvm_NumItems >= newcount)
      goto JustUpdateList;   // No need to change the list size.
         
   Guarded_FreeLV( lvm ); // Free old listview space
   
   // Now get a new listview space:
   if (!(lvm = Guarded_AllocLV( newcount, CLASSES_ELEMENTSIZE ))) // == NULL)
      {
      return( ERROR_NO_FREE_STORE ); // Aaarrgghh!!!
      }

   SetupList( &classesList, lvm ); // Re-setup the listview Gadget Space

JustUpdateList:

   lastSelectedGad = GD_CLASSES_LV;
   lastClassIndex  = 0;
   
   // See the Copy to listviewer space fragment for this:
   switch (viewType)
      {
      case VIEW_GEN:
         ClassesToListView( lvm, TTgenClassFN );
         break;

      case VIEW_SYS:
         ClassesToListView( lvm, TTsysClassFN );
         break;
         
      case VIEW_INT:
         ClassesToListView( lvm, TTintClassFN );
         break;
         
      case VIEW_USR:
         ClassesToListView( lvm, TTusrClassFN );
         break;
         
      default:
      case VIEW_ALL:
         ClassesToListView( lvm, TTgenClassFN );
         ClassesToListView( lvm, TTsysClassFN );
         ClassesToListView( lvm, TTintClassFN );
         ClassesToListView( lvm, TTusrClassFN );
         break;
      }

   return( 0 );
}

// -------------------------------------------------------------------

PRIVATE void CloseATBWindow( void )
{
   if (ATBMenus) // != NULL) 
      {
      ClearMenuStrip( ATBWnd );
      FreeMenus( ATBMenus );
      ATBMenus = NULL;   
      }

   if (ATBWnd) // != NULL) 
      {
      CloseWindow( ATBWnd );
      ATBWnd = NULL;
      }

   if (ATBGList) // != NULL) 
      {
      FreeGadgets( ATBGList );
      ATBGList = NULL;
      }
/*
   if (ATBFont) // != NULL) 
      {
      CloseFont( ATBFont );
      ATBFont = NULL;
      }
*/
   return;
}

PRIVATE int ATBCloseWindow( void )
{
   CloseATBWindow();

   return( FALSE );
}

// --------- How to Highlight a List Item using RawKey Arrows:

#define GO_UP 1
#define GO_DN 2

PRIVATE int SelectLVItem( struct Gadget   *whichList,
                          int            (*updateFunc)( int ),
                          int              direction, 
                          int             *index, 
                          int              lastIndex 
                        )
{
   if (direction == GO_UP)
      {
      if (*index > 0)
         (*index)--;             // Not at top item yet.
      else
         *index = 0; // Now we're at the bottom item again.
      }
   else
      {
      if (*index <= (lastIndex - 1))
         (*index)++;  // Not at bottom item yet.
      else
         *index = lastIndex - 1; // Now we're at the top item again.
      }

   GT_SetGadgetAttrs( whichList, ATBWnd, NULL, 
                      GTLV_Selected,    *index, 
                      GTLV_MakeVisible, *index,
                      TAG_DONE 
                    );
   
   (void) updateFunc( *index ); // Update the ListView Gadget
      
   return( TRUE );
}

// -------- Gadget Methods: --------------------------------------

SUBFUNC int updateMethodsListView( OBJECT *msgArray )
{
   int i = 0, size = objSize( msgArray ); // ->size;

   ClearLVMNodeStrs( methodsLVM ); // Blank out old contents.

   if (methodsLVM->lvm_NumItems >= size)
      goto JustUpdateList;   // No need to change the list size.
         
   Guarded_FreeLV( methodsLVM ); // Free old listview space
   
   // Now get a new listview space:
   if (!(methodsLVM = Guarded_AllocLV( size, METHODS_ELEMENTSIZE ))) // == NULL)
      {
      return( ERROR_NO_FREE_STORE ); // Aaarrgghh!!!
      }

   SetupList( &methodsList, methodsLVM ); // Re-setup the listview Gadget Space

JustUpdateList:

   lastMethodsIndex = size;   

   for (i = 0; i < size; i++)
      {
      StringNCopy( &methodsLVM->lvm_NodeStrs[ i * METHODS_ELEMENTSIZE ], 
                   symbol_value( (SYMBOL *) msgArray->inst_var[i] ), 
                   METHODS_ELEMENTSIZE
                 );
      }

   GT_SetGadgetAttrs( METHODS_GAD, ATBWnd, NULL, 
                      GTLV_Labels,      &methodsList,
                      GTLV_Selected,    0,
                      GTLV_MakeVisible, 0,
                      TAG_DONE 
                    );

   return( 0 );
}

PRIVATE int ClassesLVClicked( int whichItem )
{
   CLASS  *classPtr  = NULL;
   char   *className = NULL;
   
   classesIndex = whichItem;

   className = &classesLVM->lvm_NodeStrs[ whichItem * CLASSES_ELEMENTSIZE ];

   while (*className == ' ')
      className++; // Remove the indentation (if any)
      
   classPtr = lookup_class( className );
   
   if (!classPtr || (classPtr == (CLASS *) o_nil))
      {
      // User Class was not included into runtime environment:
      UserInfo( CMsgATB( MSG_NO_CLASSNAME, MSG_NO_CLASSNAME_STR ),
                CMsgATB( MSG_RQTITLE_USER_ERROR, MSG_RQTITLE_USER_ERROR_STR )
              );
              
      return( TRUE );
      }

   GT_SetGadgetAttrs( CLASSES_GAD, ATBWnd, NULL, 
                      GTLV_Labels,      &classesList,
                      GTLV_Selected,    classesIndex, 
                      GTLV_MakeVisible, classesIndex,
                      TAG_DONE 
                    );

   // Update methods ListView & blank out Method source Viewer:
   (void) updateMethodsListView( classPtr->message_names );
   
   ClearLVMNodeStrs( methodSrcLVM );

   ModifyListView( METHOD_GAD, ATBWnd, &methodSrcList, NULL );
   
//   (void) ActivateGadget( METHODS_GAD, ATBWnd, NULL );
   
   lastSelectedGad = GD_CLASSES_LV; // SELECTED Flag not working (sigh)
   
   return( TRUE );
}

SUBFUNC char *massageString( char *input )
{
   static char output[80] = { 0, };

   int         i;

   output[0] = '\0'; // Reset output array
       
   if (*input == '"')
      {
      input++; // Skip over comments
      
      while (*input != '"' && *input != '\n' && *input != '\0')
         input++; 

      if (*input == '"' || *input == '\n')
         input++;
         
      if (*input == '\0')
         return( NULL );  // Just a comment so return NULL
      }

   while (*input == ' ')
      input++; // Remove leading spaces (if any)
      
   if (*input == '|' || *input == '[' || *input == ']')
      return( NULL );

   i = 0;
         
   while (i < 80 && *input != ':' && *input != '\0' && *input != ' ')
      {
      *(output + i) = *input;
      input++;
      i++;
      }

   *(output + i) = '\0';
   
   return( output );
}

SUBFUNC int updateMethodSrcLV( char *className, char *methodName )
{
   FILE   *filep    = NULL;
   CLASS  *classPtr = NULL;
   SYMBOL *classFN  = NULL;
   char   *fileName = NULL;
   char    cp[ METHODSRC_ELEMENTSIZE ] = { 0, }, *copy = &cp[0];
   char    c2[80] = { 0, }, *token = &c2[0];
   int     i = 0, lines = 0;
   
   lines = getFileLineCount( className );

   while (i < 80 && *(methodName + i) != ':'
                 && *(methodName + i) != '\0')
      {
      *(token + i) = *(methodName + i);
      i++;
      }

   *(token + i) = '\0';

   if (methodSrcLVM->lvm_NumItems >= lines)
      goto JustUpdateList;   // No need to change the list size.
         
   Guarded_FreeLV( methodSrcLVM ); // Free old listview space
   
   // Now get a new listview space:
   if (!(methodSrcLVM = Guarded_AllocLV( lines, METHODSRC_ELEMENTSIZE ))) // == NULL)
      {
      return( ERROR_NO_FREE_STORE ); // Aaarrgghh!!!
      }

   SetupList( &methodSrcList, methodSrcLVM ); // Re-setup the listview Gadget Space

JustUpdateList:

   classPtr = lookup_class( className );
   
   if (!classPtr || (classPtr == (CLASS *) o_nil))
      {
      // User Class was not included into runtime environment:
      UserInfo( CMsgATB( MSG_NO_CLASSNAME, MSG_NO_CLASSNAME_STR ),
                CMsgATB( MSG_RQTITLE_USER_ERROR, MSG_RQTITLE_USER_ERROR_STR )
              );
              
      return( TRUE );
      }
   else
      {
      classFN  = (SYMBOL *) classPtr->file_name;
      fileName = symbol_value( classFN );
      }
      
   if (!(filep =fopen( fileName, "r" ))) // == NULL)
      {
      return( IoErr() );
      }
      
   for (i = 0; i < lines; i++)
      {
      if (FGetS( copy, METHODSRC_ELEMENTSIZE, filep ) != NULL)
         {
         StringNCopy( &methodSrcLVM->lvm_NodeStrs[ i * METHODSRC_ELEMENTSIZE ], 
                      copy, METHODSRC_ELEMENTSIZE
                    );
         }
      }

   if (filep) // != NULL)
      fclose( filep );

   // Make sure that we display the line containing token:

   i = 0;

   while (i < methodSrcLVM->lvm_NumItems)
      {
      char *msgStr = massageString( &methodSrcLVM->lvm_NodeStrs[ i * METHODSRC_ELEMENTSIZE ] );

      if (msgStr) // != NULL)   
         if (StringNComp( token, msgStr, StringLength( token )) == 0)
            break;
         
      i++;
      } 

   GT_SetGadgetAttrs( METHOD_GAD, ATBWnd, NULL, 
                      GTLV_Labels,      &methodSrcList,
                      GTLV_Selected,    i, 
                      GTLV_MakeVisible, i,
                      TAG_DONE 
                    );

   lastMethodIndex = lines;

   return( 0 );
}

SUBFUNC void displayByteCodesLV( struct ListViewMem *lvm, int index, OBJECT *methods )
{
   OBJECT *bytes = methods->inst_var[ index ];
   char   *codes = NULL;
   char    cp[4] = { 0, },  *buffer = &cp[0];
   char    c2[ METHODSRC_ELEMENTSIZE ] = { 0, }, *rval = &c2[0];
   int     size  = 0, i, j, line = 0;
   
   if (!bytes || (bytes == o_nil))
      return;

   // Don't know why another level of indirection is here:
   size  = ((BYTEARRAY *) bytes->inst_var[0])->bsize;
   codes = ((BYTEARRAY *) bytes->inst_var[0])->bytes;
   
   if (lvm->lvm_NumItems < (size / METHODSRC_ELEMENTSIZE))
      {
      // Highly unlikely, but we need more space:

      line = size / METHODSRC_ELEMENTSIZE + 2;
      
      Guarded_FreeLV( methodSrcLVM ); // Free old listview space
   
      // Now get a new listview space:
      if (!(methodSrcLVM = Guarded_AllocLV( line, METHODSRC_ELEMENTSIZE ))) // == NULL)
         {
         return; // Aaarrgghh!!!
         }

      SetupList( &methodSrcList, methodSrcLVM ); // Re-setup the listview Gadget Space
      }

   for (i = 0, j = 0, line = 0; i < size; i++, j += 3)
      {
      *rval = '\0';
      
      // Byt2Str is from CommonFuncs.o
      StringCat( rval, Byt2Str( buffer, (UBYTE) codes[i] ) );

      if (j > 70) // j flags when to send out a newline.
         {
         StringNCopy( &lvm->lvm_NodeStrs[ line * METHODSRC_ELEMENTSIZE ], 
                      rval, METHODSRC_ELEMENTSIZE 
                    );
         
         line++;

         j = 0;
         }
      else
         {
         StringCat( rval, " " ); // ONE_SPACE );
         
         StringCat( &lvm->lvm_NodeStrs[ line * METHODSRC_ELEMENTSIZE ], rval );
         }
      }
   
   return;   
}      

// List of methods:

PRIVATE int MethodsLVClicked( int whichItem )
{
   CLASS  *classPtr   = NULL;
   char   *className  = NULL;
   char   *methodName = NULL;

   methodsIndex = whichItem;

   methodName = &methodsLVM->lvm_NodeStrs[ whichItem * METHODS_ELEMENTSIZE ];
   className  = &classesLVM->lvm_NodeStrs[ classesIndex * CLASSES_ELEMENTSIZE ];

   while (*className == ' ')
      className++;           // Remove indentation spaces (if any)
      
   classPtr = lookup_class( className );

   if (!classPtr || (classPtr == (CLASS *) o_nil))
      {
      // User Class was not included into runtime environment:
      UserInfo( CMsgATB( MSG_NO_CLASSNAME, MSG_NO_CLASSNAME_STR ),
                CMsgATB( MSG_RQTITLE_USER_ERROR, MSG_RQTITLE_USER_ERROR_STR )
              );
              
      return( TRUE );
      }

   // Update the Method Source viewer:

   if (displaySource == TRUE)
      (void) updateMethodSrcLV( className, methodName );
   else
      {
      // User wants to see ByteCodes instead of source:
      OBJECT *methods = classPtr->methods;
      
      // Just send out the classPtr->methods->inst_var[ whichItem ] byteCodes:
      ClearLVMNodeStrs( methodSrcLVM );
      
      displayByteCodesLV( methodSrcLVM, whichItem, methods );
   
      ModifyListView( METHOD_GAD,  ATBWnd, &methodSrcList, NULL );
      }

   GT_SetGadgetAttrs( METHODS_GAD, ATBWnd, NULL, 
                      GTLV_Labels,      &methodsList,
                      GTLV_Selected,    methodsIndex, 
                      GTLV_MakeVisible, methodsIndex,
                      TAG_DONE 
                    );

//   (void) ActivateGadget( METHOD_GAD, ATBWnd, NULL ); // Activate Source Code LV

   lastSelectedGad = GD_METHODS_LV;
   
   return( TRUE );
}

PRIVATE int MethodSrcLVClicked( int whichItem )
{
   // Method Source code ListViewer:

   methodIndex = whichItem;

   GT_SetGadgetAttrs( METHOD_GAD, ATBWnd, NULL, 
                      GTLV_Labels,      &methodSrcList,
                      GTLV_Selected,    methodIndex, 
                      GTLV_MakeVisible, methodIndex,
                      TAG_DONE 
                    );

   lastSelectedGad = GD_METHODSRC_LV;

   return( TRUE );
}

PRIVATE int CommandStrClicked( int dummy )
{
   char c[128] = { 0, }, *command = &c[0];
   int  rval = RETURN_OK;
   
   StringNCopy( command, COMMAND_STRING, 128 );

   if ((rval = System( command, TAG_DONE )) != RETURN_OK)
      {
      sprintf( ErrMsg, CMsgATB( MSG_FORMAT_CMD_ERR, MSG_FORMAT_CMD_ERR_STR ),
                       command, rval 
             );
             
      Aaarrgg( ErrMsg, 
               CMsgATB( MSG_RQTITLE_USER_ERROR, MSG_RQTITLE_USER_ERROR_STR ) 
             );
      }

   lastSelectedGad = GD_CMD_STRING;
      
   return( TRUE );
}

// --------------------------------------------------------------

PRIVATE int ATBLoadFile( void )
{
   /* routine when (sub)item "Load..." is selected. */
   UserInfo( CMsgATB( MSG_NOT_IMPL, MSG_NOT_IMPL_STR ),
             CMsgATB( MSG_RQTITLE_ATALK_PROBLEM, MSG_RQTITLE_ATALK_PROBLEM_STR )
           );
   
   return( TRUE );
}

PRIVATE int ATBSaveFile( void )
{
   /* routine when (sub)item "Save" is selected. */
   UserInfo( CMsgATB( MSG_NOT_IMPL, MSG_NOT_IMPL_STR ),
             CMsgATB( MSG_RQTITLE_ATALK_PROBLEM, MSG_RQTITLE_ATALK_PROBLEM_STR )
           );
   
   return( TRUE );
}

PRIVATE int ATBSaveAsFile( void )
{
   /* routine when (sub)item "Save As..." is selected. */
   UserInfo( CMsgATB( MSG_NOT_IMPL, MSG_NOT_IMPL_STR ),
             CMsgATB( MSG_RQTITLE_ATALK_PROBLEM, MSG_RQTITLE_ATALK_PROBLEM_STR )
           );
   
   return( TRUE );
}

PRIVATE int ATBToolTypesEditor( void )
{
   char command[512] = { 0, };
   
   sprintf( command, "%s %s", TTToolEditor, ATBPgmName );

   if (System( command, TAG_DONE ) != 0)
      {
      UserInfo( CMsgATB( MSG_BAD_TOOLTYPE, MSG_BAD_TOOLTYPE_STR ),
                CMsgATB( MSG_RQTITLE_ATALK_PROBLEM, MSG_RQTITLE_ATALK_PROBLEM_STR )
              );
      }

   return( TRUE );
}

PRIVATE int ATBDisplayInstances( void )
{
   /* routine when (sub)item "Display Instances..." is selected. */
   
   UserInfo( CMsgATB( MSG_NOT_IMPL, MSG_NOT_IMPL_STR ),
             CMsgATB( MSG_RQTITLE_ATALK_PROBLEM, MSG_RQTITLE_ATALK_PROBLEM_STR )
           );
   
   return( TRUE );
}

PRIVATE int ATBAboutDisplay( void )
{
   IMPORT UBYTE *Version;
   IMPORT UBYTE  PgmName[];
   
   char title[80] = { 0, };
   
   sprintf( ErrMsg, CMsgATB( MSG_FORMAT_AR_ABOUT, MSG_FORMAT_AR_ABOUT_STR ), 
            ATBPgmName, Version, PgmName, authorName, authorEMail
          );

   sprintf( title, CMsgATB( MSG_FORMAT_AR_TITLE, MSG_FORMAT_AR_TITLE_STR ), 
                   ATBPgmName, Version
          );

   Aaarrgg( ErrMsg, title );

   return( TRUE );
}

PRIVATE int ATBQuitProgram( void )
{
   return( ATBCloseWindow() );
}

/****i* ATBAddClassReq() [3.0] **********************************
*
* NAME 
*    ATBAddClassReq()
*
* DESCRIPTION
*    User selected the "Add  Class.." menu item, so open the
*    AddClass Requester.
*****************************************************************
*
*/

PRIVATE int ATBAddClassReq( void )
{
   char *parentClass = &classesLVM->lvm_NodeStrs[ classesIndex * CLASSES_ELEMENTSIZE ];
   int   chk         = 0;
   
   while (*parentClass == ' ')
      parentClass++;
      
   chk = browserAddReq( parentClass, classesLVM, &classesList );

   if (chk > TRUE) // what is truth?
      {
      // User added a Class, so update our display, etc:
      }
   else if (chk < 0)
      {
      CannotCreate( CMsgATB( MSG_ADD_REQ, MSG_ADD_REQ_STR ) );
      }

   return( TRUE );
}

PRIVATE int ATBAddMethodReq( void )
{
   /* routine when item "Add  Method.." is selected. */
   UserInfo( CMsgATB( MSG_NOT_IMPL, MSG_NOT_IMPL_STR ),
             CMsgATB( MSG_RQTITLE_ATALK_PROBLEM, MSG_RQTITLE_ATALK_PROBLEM_STR )
           );
   
   return( TRUE );
}

PRIVATE int ATBGotoEditor( void )
{
   IMPORT struct TagItem LoadTags[]; // in Global.c
    
   CLASS *classPtr = NULL;
   
   char  *className     = &classesLVM->lvm_NodeStrs[ classesIndex * CLASSES_ELEMENTSIZE ];
   char   fileName[512] = { 0, };
   char   command[1024] = { 0, };
   
   while (*className == ' ')
      className++;
   
   if (!(classPtr = lookup_class( className ))) // == NULL)
      {
      // This should never happen:
      SetTagItem( LoadTags, ASLFR_TitleText, 
                  (ULONG) CMsgATB( MSG_SELCLASS_RQTITLE, MSG_SELCLASS_RQTITLE_STR ) 
                );

      SetTagItem( LoadTags, ASLFR_InitialDrawer, (ULONG) "Amigatalk:" );
      SetTagItem( LoadTags, ASLFR_Window, (ULONG) ATBWnd );

      if (FileReq( fileName, LoadTags ) < 1)
         return( TRUE ); // User did NOT give us a fileName!
      }
   else
      {
      char *file = symbol_value( (SYMBOL *) classPtr->file_name );
      
      StringNCopy( fileName, file, 512 );
      }

   sprintf( command, "%s %s", TTExtEditor, fileName );

   if (System( command, TAG_DONE ) != RETURN_OK)
      {
      UserInfo( CMsgATB( MSG_BAD_EDITOR, MSG_BAD_EDITOR_STR ),
                CMsgATB( MSG_RQTITLE_ATALK_PROBLEM, MSG_RQTITLE_ATALK_PROBLEM_STR )
              );
      }

   return( TRUE );
}

PRIVATE int ATBDelClassReq( void )
{
   char *className = &classesLVM->lvm_NodeStrs[ classesIndex * CLASSES_ELEMENTSIZE ];
   int   chk       = 0;
   
   while (*className == ' ')
      className++;

   chk = browserDelReq( className, classesLVM, &classesList );
      
   if (chk > TRUE) // what is truth?
      {
      // User deleted a Class, so update our display, etc:
      }
   else if (chk < 0)
      {
      // Error encountered:
      }

   return( TRUE );
}

/****i* SetItemFlags() [3.0] ******************************************
*
* NAME
*    SetItemFlags()
*
* DESCRIPTION
*    Set the flags for the given menu item (usually CHECKED or ~CHECKED)
***********************************************************************
*
*/

SUBFUNC void SetItemFlags( char *itemTitle, int newFlags )
{
   struct MenuItem *sub = NULL;
   UWORD            oldFlags = 0;
   ULONG            ilock    = 0L;
                                  // CommonFuncs function:   
   if (!(sub = (struct MenuItem *) CFFindMenuPtr( ATBMenus, itemTitle ))) // == NULL)
      return;

   ilock = LockIBase( 0 );
   
      // oldFlags only contains the flags under Intuition control:

      oldFlags   = sub->Flags & 0x30C0; // Mask off User flags. 

      // Restore oldFlags & add new ones:

      sub->Flags = (newFlags & 0xCF3F) | oldFlags; 
   
   UnlockIBase( ilock );
      
   return;
}

// ========= OPTIONS MenuItems: =========================================

SUBFUNC void resetOptionChecks( void )
{
   SetItemFlags( CMsgATB( MSG_ATB_SHOWSRC_MENU, MSG_ATB_SHOWSRC_MENU_STR ), 
                 CHECKIT | MENUTOGGLE | ITEMTEXT | ITEMENABLED
               );

   SetItemFlags( CMsgATB( MSG_ATB_SHOWBYTES_MENU, MSG_ATB_SHOWBYTES_MENU_STR ), 
                 CHECKIT | MENUTOGGLE | ITEMTEXT | ITEMENABLED
               );
   return;
}

PRIVATE int ATBDisplaySource( void )
{
   resetOptionChecks();

   SetItemFlags( CMsgATB( MSG_ATB_SHOWSRC_MENU, MSG_ATB_SHOWSRC_MENU_STR ),
                 CHECKED | CHECKIT | MENUTOGGLE | ITEMTEXT | ITEMENABLED
               );

   displaySource = TRUE; // FALSE means display ByteCodes

   // Now make sure we are displaying source code:
   (void) MethodsLVClicked( methodsIndex );

   return( TRUE );
}

PRIVATE int ATBDisplayByteCodes( void )
{
   resetOptionChecks();

   SetItemFlags( CMsgATB( MSG_ATB_SHOWBYTES_MENU, MSG_ATB_SHOWBYTES_MENU_STR ), 
                 CHECKED | CHECKIT | MENUTOGGLE | ITEMTEXT | ITEMENABLED
               );

   displaySource = FALSE;

   // Now make sure we are displaying bytecodes:
   (void) MethodsLVClicked( methodsIndex );

   return( TRUE );
}

// ======================================================================

SUBFUNC void resetViewChecks( void )
{
   SetItemFlags( CMsgATB( MSG_ATB_VIEWALL_MENU, MSG_ATB_VIEWALL_MENU_STR ), 
                 CHECKIT | MENUTOGGLE | ITEMTEXT | ITEMENABLED
               );

   SetItemFlags( CMsgATB( MSG_ATB_VIEWSYS_MENU, MSG_ATB_VIEWSYS_MENU_STR ), 
                 CHECKIT | MENUTOGGLE | ITEMTEXT | ITEMENABLED
               );

   SetItemFlags( CMsgATB( MSG_ATB_VIEWGEN_MENU, MSG_ATB_VIEWGEN_MENU_STR ), 
                 CHECKIT | MENUTOGGLE | ITEMTEXT | ITEMENABLED
               );

   SetItemFlags( CMsgATB( MSG_ATB_VIEWINT_MENU, MSG_ATB_VIEWINT_MENU_STR ), 
                 CHECKIT | MENUTOGGLE | ITEMTEXT | ITEMENABLED
               );

   SetItemFlags( CMsgATB( MSG_ATB_VIEWUSR_MENU, MSG_ATB_VIEWUSR_MENU_STR ), 
                 CHECKIT | MENUTOGGLE | ITEMTEXT | ITEMENABLED
               );
   return;
}

SUBFUNC int countTheseClasses( int vType )
{
   int rval = 0;
   
   switch (vType)
      {
      case VIEW_GEN:
         rval = countATBClasses( TTgenClassFN );
         break;
         
      case VIEW_SYS:
         rval = countATBClasses( TTsysClassFN );
         break;
         
      case VIEW_INT:
         rval = countATBClasses( TTintClassFN );
         break;
         
      case VIEW_USR:
         rval = countATBClasses( TTusrClassFN );
         break;
         
      default:
      case VIEW_ALL:
         rval  = countATBClasses( TTgenClassFN );
         rval += countATBClasses( TTsysClassFN );
         rval += countATBClasses( TTintClassFN );
         rval += countATBClasses( TTusrClassFN );
         break;
      }

   return( rval );
}

SUBFUNC int allocSrcParentArray( int howMany )
{
   int rval = 0;
   
   if (allocSrcParentArrays == TRUE)
      {
      if (arraySize < howMany)
         {
//         FreeVec( sourceFileNames );
         FreeVec( parentClassNames );
         
         arraySize = 0; // Reset 
         }
      else
         goto skipAllocations; // we already have enough elements.
      }

   // else allocSrcParentArrays was FALSE or arrays were too small:
/*
   if ((sourceFileNames = (char **) 
                          AllocVec( howMany * sizeof( char * ),
                                    MEMF_CLEAR | MEMF_ANY )) == NULL)
      {
      rval = -1;
      
      goto skipAllocations;
      }   
*/
   if (!(parentClassNames = (char **) AllocVec( howMany * sizeof( char * ),
                                                MEMF_CLEAR | MEMF_ANY ))) // == NULL)
      {
//      FreeVec( sourceFileNames );
      
      rval = -2;
      
      goto skipAllocations;
      }   

   arraySize            = howMany; // Keep track of our allocation Size
   allocSrcParentArrays = TRUE;    // Set guard
   
skipAllocations:
      
   return( rval );
}

PRIVATE int ViewAllClicked( void )
{
   int numClasses = 0;
   
   resetViewChecks();

   ClearLVMNodeStrs( classesLVM );

   SetItemFlags( CMsgATB( MSG_ATB_VIEWALL_MENU, MSG_ATB_VIEWALL_MENU_STR ),
                 CHECKED | CHECKIT | MENUTOGGLE | ITEMTEXT | ITEMENABLED
               );

   viewType   = VIEW_ALL;
   numClasses = countTheseClasses( viewType );
   
   if (allocSrcParentArray( numClasses ) < 0)
      {
      UserInfo( CMsgATB( MSG_NO_MEMORY, MSG_NO_MEMORY_STR ),
                CMsgATB( MSG_RQTITLE_SYSTEM_PROBLEM, MSG_RQTITLE_SYSTEM_PROBLEM_STR )
              );
      }
      
   if (updateClassesLV( classesLVM, numClasses ) != 0)
      {
      UserInfo( CMsgATB( MSG_NO_MEMORY, MSG_NO_MEMORY_STR ),
                CMsgATB( MSG_RQTITLE_SYSTEM_PROBLEM, MSG_RQTITLE_SYSTEM_PROBLEM_STR )
              );
      }

   return( TRUE );
}

PRIVATE int ViewGeneralClicked( void )
{
   int numClasses = 0;
   
   resetViewChecks();
   ClearLVMNodeStrs( classesLVM );

   SetItemFlags( CMsgATB( MSG_ATB_VIEWGEN_MENU, MSG_ATB_VIEWGEN_MENU_STR ),
                 CHECKED | CHECKIT | MENUTOGGLE | ITEMTEXT | ITEMENABLED
               );

   viewType   = VIEW_GEN;
   numClasses = countTheseClasses( viewType );
   
   if (allocSrcParentArray( numClasses ) < 0)
      {
      UserInfo( CMsgATB( MSG_NO_MEMORY, MSG_NO_MEMORY_STR ),
                CMsgATB( MSG_RQTITLE_SYSTEM_PROBLEM, MSG_RQTITLE_SYSTEM_PROBLEM_STR )
              );
      }

   if (updateClassesLV( classesLVM, numClasses ) != 0)
      {
      UserInfo( CMsgATB( MSG_NO_MEMORY, MSG_NO_MEMORY_STR ),
                CMsgATB( MSG_RQTITLE_SYSTEM_PROBLEM, MSG_RQTITLE_SYSTEM_PROBLEM_STR )
              );
      }

   return( TRUE );
}

PRIVATE int ViewSystemClicked( void )
{
   int numClasses = 0;
   
   resetViewChecks();
   ClearLVMNodeStrs( classesLVM );

   SetItemFlags( CMsgATB( MSG_ATB_VIEWSYS_MENU, MSG_ATB_VIEWSYS_MENU_STR ),
                 CHECKED | CHECKIT | MENUTOGGLE | ITEMTEXT | ITEMENABLED
               );

   viewType   = VIEW_SYS;
   numClasses = countTheseClasses( viewType );
   
   if (allocSrcParentArray( numClasses ) < 0)
      {
      UserInfo( CMsgATB( MSG_NO_MEMORY, MSG_NO_MEMORY_STR ),
                CMsgATB( MSG_RQTITLE_SYSTEM_PROBLEM, MSG_RQTITLE_SYSTEM_PROBLEM_STR )
              );
      }

   if (updateClassesLV( classesLVM, numClasses ) != 0)
      {
      UserInfo( CMsgATB( MSG_NO_MEMORY, MSG_NO_MEMORY_STR ),
                CMsgATB( MSG_RQTITLE_SYSTEM_PROBLEM, MSG_RQTITLE_SYSTEM_PROBLEM_STR )
              );
      }

   return( TRUE );
}

PRIVATE int ViewIntuiClicked( void )
{
   int numClasses = 0;
   
   resetViewChecks();
   ClearLVMNodeStrs( classesLVM );

   SetItemFlags( CMsgATB( MSG_ATB_VIEWINT_MENU, MSG_ATB_VIEWINT_MENU_STR ),
                 CHECKED | CHECKIT | MENUTOGGLE | ITEMTEXT | ITEMENABLED
               );

   viewType   = VIEW_INT;
   numClasses = countTheseClasses( viewType );
   
   if (allocSrcParentArray( numClasses ) < 0)
      {
      UserInfo( CMsgATB( MSG_NO_MEMORY, MSG_NO_MEMORY_STR ),
                CMsgATB( MSG_RQTITLE_SYSTEM_PROBLEM, MSG_RQTITLE_SYSTEM_PROBLEM_STR )
              );
      }

   if (updateClassesLV( classesLVM, numClasses ) != 0)
      {
      UserInfo( CMsgATB( MSG_NO_MEMORY, MSG_NO_MEMORY_STR ),
                CMsgATB( MSG_RQTITLE_SYSTEM_PROBLEM, MSG_RQTITLE_SYSTEM_PROBLEM_STR )
              );
      }

   return( TRUE );
}

PRIVATE int ViewUserClicked( void )
{
   int numClasses = 0;
   
   resetViewChecks();
   ClearLVMNodeStrs( classesLVM );

   SetItemFlags( CMsgATB( MSG_ATB_VIEWUSR_MENU, MSG_ATB_VIEWUSR_MENU_STR ),
                 CHECKED | CHECKIT | MENUTOGGLE | ITEMTEXT | ITEMENABLED
               );

   viewType   = VIEW_USR;
   numClasses = countTheseClasses( viewType );
   
   if (allocSrcParentArray( numClasses ) < 0)
      {
      UserInfo( CMsgATB( MSG_NO_MEMORY, MSG_NO_MEMORY_STR ),
                CMsgATB( MSG_RQTITLE_SYSTEM_PROBLEM, MSG_RQTITLE_SYSTEM_PROBLEM_STR )
              );
      }
      
   if (updateClassesLV( classesLVM, numClasses ) != 0)
      {
      UserInfo( CMsgATB( MSG_NO_MEMORY, MSG_NO_MEMORY_STR ),
                CMsgATB( MSG_RQTITLE_SYSTEM_PROBLEM, MSG_RQTITLE_SYSTEM_PROBLEM_STR )
              );
      }

   return( TRUE );
}

// -------- END of Menu functions! -------------------------------------

/****i* SetupATBGadget() [3.0] *****************************************
*
* NAME
*    SetupATBGadget()
*
* DESCRIPTION
*    Unrolled the setup gadgets loop that GadToolsBox generated in 
*    OpenATBWindow() so that each gadget can be sized differently.
************************************************************************
*
*/

PRIVATE int tagcount = 0;

SUBFUNC struct Gadget *SetupATBGadget( struct Gadget *g, int idx, int x, int y, int w, int h )
{
   struct NewGadget ng = { 0, };

   CopyMem( (char *) &ATBNGad[ idx ], (char *) &ng, 
            (long) sizeof( struct NewGadget )
          );

   ng.ng_VisualInfo = VisualInfo;
   ng.ng_TextAttr   = Font;

   ng.ng_LeftEdge   = x; // CFont.OffX + ComputeX( CFont.FontX, ng.ng_LeftEdge );
   ng.ng_TopEdge    = y; // CFont.OffY + ComputeY( CFont.FontY, ng.ng_TopEdge );
   ng.ng_Width      = w; // ComputeX( CFont.FontX, w );
   ng.ng_Height     = h; // ComputeY( CFont.FontY, h );

   ATBGadgets[ idx ] = g 
                     = CreateGadgetA( (ULONG) ATBGTypes[ idx ], 
                                      g, 
                                      &ng, 
                                      (struct TagItem *) &ATBGTags[ tagcount ] 
                                    );
   if (!g) // == NULL)
      {
      sprintf( ErrMsg, CMsgATB( MSG_FORMAT_ATBGADGETS, MSG_FORMAT_ATBGADGETS_STR ), idx );

      CannotCreate( ErrMsg );

      return( NULL );
      }

   while (ATBGTags[ tagcount ] != TAG_DONE)
      tagcount += 2;

   tagcount++; // Go past the TAG_DONE tag.

   return( g );
}

// How long is the Command String Gadget GadgetText??

PUBLIC int LabelHSize( UBYTE *gadgetLabel )
{
   struct IntuiText t = { 0, };
    
   t.IText     = gadgetLabel;
   t.ITextFont = Scr->Font;
   
   return( IntuiTextLength( &t ) );
}

PRIVATE int OpenATBWindow( void )
{
   struct Gadget    *g;
   UWORD             wleft = ATBLeft, wtop = ATBTop, ww, wh;

   DBG( fprintf( stderr, "OpenATBWindow(): setting ATBWidth & ATBHeight...\n" ) );
   ATBWidth  = ATBWidth  < Scr->Width  ? ATBWidth  : Scr->Width;
   ATBHeight = ATBHeight < Scr->Height ? ATBHeight : Scr->Height;

   ComputeFont( Scr, Font, &CFont, ATBWidth, ATBHeight );

   ww = ComputeX( CFont.FontX, ATBWidth );
   wh = ComputeY( CFont.FontY, ATBHeight );

   wleft = (Scr->Width  - ww) / 2;
   wtop  = (Scr->Height - wh) / 2;

   DBG( fprintf( stderr, "OpenATBWindow(): calling CreateContext( 0x%08LX )...\n", &ATBGList ) );
   if (!(g = CreateContext( &ATBGList )))
      return( -1 );

   DBG( fprintf( stderr, "OpenATBWindow(): calling SetupATBGadget( GD_Classes_LV )...\n" ) );
   if (!(g = SetupATBGadget( g, GD_CLASSES_LV, 
                                10,
				                    Scr->BarHeight + 24,
                                ATBWidth / 2 - 30, 
                                ATBHeight / 2 )))
      {
      CannotCreate( CMsgATB( MSG_CLASSES_LV, MSG_CLASSES_LV_STR ) );

      return( -2 );
      }

   DBG( fprintf( stderr, "OpenATBWindow(): calling SetupATBGadget( GD_Methods_LV )...\n" ) );
   if (!(g = SetupATBGadget( g, GD_METHODS_LV, 
                                ATBWidth - ATBWidth / 2,
				                    Scr->BarHeight + 24,
                                ATBWidth / 2 - 20, 
                                ATBHeight / 2 )))
      {
      CannotCreate( CMsgATB( MSG_METHODS_LV, MSG_METHODS_LV_STR ) );

      return( -2 );
      }

   DBG( fprintf( stderr, "OpenATBWindow(): calling SetupATBGadget( GD_MethodsSrc_LV )...\n" ) );
   if (!(g = SetupATBGadget( g, GD_METHODSRC_LV, 
                                10,
				                    ATBHeight - ATBHeight / 2 + 70, // CLASSES_GAD->Height + 52,
				                    ATBWidth - 30, 
                                ATBHeight / 3 + 10 )))
      {
      CannotCreate( CMsgATB( MSG_METHSRC_LV, MSG_METHSRC_LV_STR ) );

      return( -2 );
      }

   DBG( fprintf( stderr, "OpenATBWindow(): calling SetupATBGadget( GD_CMD_STRING )...\n" ) );
   if (!(g = SetupATBGadget( g, GD_CMD_STRING,
                                
				                     LabelHSize( CMsgATB( MSG_ATB_COMMAND_STR_GAD, MSG_ATB_COMMAND_STR_GAD_STR ))
                                 + ATBWnd->BorderLeft - 10,
				
 				                     ATBHeight - Scr->WBorBottom - 38,
                                 ATBWidth - ATBNGad[ GD_CMD_STRING ].ng_LeftEdge - 40, // -20, 
                                 20 )))
      {
      CannotCreate( CMsgATB( MSG_CMDSTR, MSG_CMDSTR_STR ) );

      return( -2 );
      }

   DBG( fprintf( stderr, "OpenATBWindow(): calling CreateMenus()...\n" ) );
   if (!(ATBMenus = CreateMenus( ATBNewMenu, GTMN_FrontPen, 0L, TAG_DONE ))) // == NULL)
      return( -3 );

   DBG( fprintf( stderr, "OpenATBWindow(): calling LayoutMenus()...\n" ) );
   LayoutMenus( ATBMenus, VisualInfo, TAG_DONE );

   DBG( fprintf( stderr, "OpenATBWindow(): calling OpenWindowTags()...\n" ) );
   if (!(ATBWnd = OpenWindowTags( NULL,

            WA_Left,      wleft,
            WA_Top,       wtop,
            WA_Width,     ww + CFont.OffX + Scr->WBorRight,
            WA_Height,    wh + CFont.OffY + Scr->WBorBottom,
            
            WA_IDCMP,     LISTVIEWIDCMP | STRINGIDCMP | IDCMP_MENUPICK
              | IDCMP_CLOSEWINDOW | IDCMP_REFRESHWINDOW | IDCMP_RAWKEY,
              
            WA_Flags,     WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET
              | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_SIZEGADGET,

            WA_Gadgets,      ATBGList,
            WA_Title,        ATBWdt,
            WA_MinWidth,     640,
            WA_MinHeight,    480,
            WA_MaxWidth,     Scr->Width,
            WA_MaxHeight,    Scr->Height,
            WA_CustomScreen, Scr,
            
            TAG_DONE )))
		{		
      return( -4 );
	   }

   DBG( fprintf( stderr, "OpenATBWindow(): calling SetMenuStrip( 0x%08LX, 0x%08LX )...\n", ATBWnd, ATBMenus ) );
   SetMenuStrip( ATBWnd, ATBMenus );
   GT_RefreshWindow( ATBWnd, NULL );

   DBG( fprintf( stderr, "Exiting OpenATBWindow().\n" ) );

   return( 0 );
}

SUBFUNC void unhighlightGadgets( void )
{
   struct Gadget *gptr  = CLASSES_GAD;

   GT_SetGadgetAttrs( gptr, ATBWnd, NULL,
                      GTLV_Selected, ~0,
                      TAG_DONE
                    );

   gptr = METHODS_GAD;   

   GT_SetGadgetAttrs( gptr, ATBWnd, NULL,
                      GTLV_Selected, ~0,
                      TAG_DONE
                    );

   gptr = METHOD_GAD;   

   GT_SetGadgetAttrs( gptr, ATBWnd, NULL,
                      GTLV_Selected, ~0,
                      TAG_DONE
                    );

   GT_RefreshWindow( ATBWnd, NULL );

   return;
}

SUBFUNC void highlightGadget( struct Gadget *gptr )
{
   if (!gptr) // == NULL)
      return;

   if (gptr == COMMAND_GAD)
      GT_SetGadgetAttrs( gptr, ATBWnd, NULL, GTST_String, "", TAG_DONE );

   else if (gptr == CLASSES_GAD)
      GT_SetGadgetAttrs( gptr, ATBWnd, NULL,
                         GTLV_Labels,   &classesList,
                         GTLV_Selected, classesIndex,
                         TAG_DONE
                       );

   else if (gptr == METHODS_GAD)
      GT_SetGadgetAttrs( gptr, ATBWnd, NULL,
                         GTLV_Labels,   &methodsList,
                         GTLV_Selected, methodsIndex,
                         TAG_DONE
                       );

   else if (gptr == METHOD_GAD)
      GT_SetGadgetAttrs( gptr, ATBWnd, NULL,
                         GTLV_Labels,   &methodSrcList,
                         GTLV_Selected, methodIndex,
                         TAG_DONE
                       );

   GT_RefreshWindow( ATBWnd, NULL );

   return;
}

PRIVATE void LeftArrow( void )
{
   unhighlightGadgets();
   
   if (lastSelectedGad == GD_CLASSES_LV)
      {
      highlightGadget( COMMAND_GAD );
      
      (void) ActivateGadget( COMMAND_GAD, ATBWnd, NULL );

      lastSelectedGad = GD_CMD_STRING;
      }
   else if (lastSelectedGad == GD_METHODS_LV)
      {
      highlightGadget( CLASSES_GAD );
      
      (void) ActivateGadget( CLASSES_GAD, ATBWnd, NULL );

      lastSelectedGad = GD_CLASSES_LV;
      }
   else if (lastSelectedGad == GD_METHODSRC_LV)
      {
      highlightGadget( METHODS_GAD );
      
      (void) ActivateGadget( METHODS_GAD, ATBWnd, NULL );

      lastSelectedGad = GD_METHODS_LV;
      }
   else if (lastSelectedGad == GD_CMD_STRING)
      {
      highlightGadget( METHOD_GAD );
      
      (void) ActivateGadget( METHOD_GAD, ATBWnd, NULL );

      lastSelectedGad = GD_METHODSRC_LV;
      }
      
   return;
}

PRIVATE void RightArrow( void )
{
   unhighlightGadgets();
   
   if (lastSelectedGad == GD_CLASSES_LV)
      {
      highlightGadget( METHODS_GAD );

      (void) ActivateGadget( METHODS_GAD, ATBWnd, NULL );

      lastSelectedGad = GD_METHODS_LV; 
      }
   else if (lastSelectedGad == GD_METHODS_LV)
      {
      highlightGadget( METHOD_GAD );
      
      (void) ActivateGadget( METHOD_GAD, ATBWnd, NULL );

      lastSelectedGad = GD_METHODSRC_LV;
      }
   else if (lastSelectedGad == GD_METHODSRC_LV)
      {
      highlightGadget( COMMAND_GAD );
      
      (void) ActivateGadget( COMMAND_GAD, ATBWnd, NULL );

      lastSelectedGad = GD_CMD_STRING;
      }
   else if (lastSelectedGad == GD_CMD_STRING)
      {
      highlightGadget( CLASSES_GAD );
      
      (void) ActivateGadget( CLASSES_GAD, ATBWnd, NULL );

      lastSelectedGad = GD_CLASSES_LV;
      }

   return;
}

SUBFUNC int UpArrow( void )
{
   int rval = TRUE;
   
   if (lastSelectedGad == GD_CLASSES_LV)
      rval = SelectLVItem( CLASSES_GAD, ClassesLVClicked, 
                           GO_UP, &classesIndex, lastClassIndex
                         );
                               
   else if (lastSelectedGad == GD_METHODS_LV)
      rval = SelectLVItem( METHODS_GAD, MethodsLVClicked, GO_UP,
                           &methodsIndex, lastMethodsIndex
                         );
                               
   else if (lastSelectedGad == GD_METHODSRC_LV)
      rval = SelectLVItem( METHOD_GAD, MethodSrcLVClicked, GO_UP,
                           &methodIndex, lastMethodIndex
                         );

   return( rval );
}

SUBFUNC int DownArrow( void )
{
   int rval = TRUE;

   if (lastSelectedGad == GD_CLASSES_LV)
      rval = SelectLVItem( CLASSES_GAD, ClassesLVClicked, GO_DN,
                           &classesIndex, lastClassIndex
                         );

   else if (lastSelectedGad == GD_METHODS_LV)
      rval = SelectLVItem( METHODS_GAD, MethodsLVClicked, GO_DN,
                           &methodsIndex, lastMethodsIndex
                         );

   else if (lastSelectedGad == GD_METHODSRC_LV)
      rval = SelectLVItem( METHOD_GAD, MethodSrcLVClicked, GO_DN,
                           &methodIndex, lastMethodIndex
                         );
   return( rval );
}
   
PRIVATE int ATBRawKey( int whichKey )
{
   IMPORT int ATHelpProgram( void );
   
   int rval = TRUE;
   
   switch (whichKey)
      {
      case 0x28: // 'l' or 'L'
         rval = ATBLoadFile();
         break;
         
      case 0x21: // 's' or 'S'
         rval = ATBSaveFile();
         break;
         
      case 0x20: // 'a' or 'A'
         rval = ATBSaveAsFile();
         break;
         
      case 0x17: // 'i' or 'I'
         rval = ATBAboutDisplay();
         break;
         
      case 0x10: // 'q' or 'Q'
         rval = ATBQuitProgram();
         break;

      case 0x4F: // Left Arrow:
         LeftArrow();
         break;
         
      case 0x4E: // Right Arrow:
         RightArrow();
         break;
         
      case 0x4C: // Up Arrow:
         rval = UpArrow();
         break;
      
      case 0x4D: // Down Arrow:
         rval = DownArrow();
         break;

      case 0x5F: // Help key
         rval = ATHelpProgram();
         break;
         
      default:
         break; // Unknown key press
      }
      
   return( rval );
}

PRIVATE int HandleATBIDCMP( void )
{
   struct IntuiMessage *m;
   struct MenuItem     *n;
   int                (*func)( int );
   int                (*mfunc)( void );
   BOOL                 running = TRUE;

   while (running == TRUE)
      {
      if (!(m = GT_GetIMsg( ATBWnd->UserPort ))) // == NULL) 
         {
         (void) Wait( 1L << ATBWnd->UserPort->mp_SigBit );

         continue;
         }

        CopyMem( (char *) m, (char *) &ATBMsg, 
                 (long) sizeof( struct IntuiMessage )
               );

        GT_ReplyIMsg( m );

        switch (ATBMsg.Class) 
           {
            case IDCMP_REFRESHWINDOW:
               GT_BeginRefresh( ATBWnd );
               GT_EndRefresh( ATBWnd, TRUE );
               break;

            case IDCMP_CLOSEWINDOW:
               running = ATBCloseWindow();
               break;

            case IDCMP_RAWKEY:
               running = ATBRawKey( ATBMsg.Code );
               break;
               
            case IDCMP_GADGETUP:
            case IDCMP_GADGETDOWN:
               lastSelectedGad = ((struct Gadget *)ATBMsg.IAddress)->GadgetID;
               
               func = (int (*)( int )) ((struct Gadget *)ATBMsg.IAddress)->UserData;

               if (func) // != NULL)
                  running = func( ATBMsg.Code );

               break;

            case IDCMP_MENUPICK:
               if (ATBMsg.Code != MENUNULL)
                  {
                  n = ItemAddress( ATBMenus, ATBMsg.Code );

                  if (!n) // == NULL)
                     break;

                  mfunc = (int (*) ( void )) (GTMENUITEM_USERDATA( n ));

                  if (!mfunc) // == NULL)
                     break;

                  running = mfunc();
                  }
       
               break;
            }
         }

   return( running );
}

PRIVATE int setupATBCatalog( void )
{
   StringNCopy( &genClassFN[0], CMsgATB( MSG_TT_ATB_genClassFN, MSG_TT_ATB_genClassFN_STR ), 80 );
   StringNCopy( &sysClassFN[0], CMsgATB( MSG_TT_ATB_sysClassFN, MSG_TT_ATB_sysClassFN_STR ), 80 );
   StringNCopy( &intClassFN[0], CMsgATB( MSG_TT_ATB_intClassFN, MSG_TT_ATB_intClassFN_STR ), 80 );
   StringNCopy( &usrClassFN[0], CMsgATB( MSG_TT_ATB_usrClassFN, MSG_TT_ATB_usrClassFN_STR ), 80 );
   StringNCopy( &ExtEditor[0],  CMsgATB( MSG_TT_ATB_ExtEditor,  MSG_TT_ATB_ExtEditor_STR  ), 80 );
   StringNCopy( &ToolEditor[0], CMsgATB( MSG_TT_ATB_ToolEditor, MSG_TT_ATB_ToolEditor_STR ), 80 );

   StringNCopy( ATBWdt, CMsgATB( MSG_ATB_WTITLE, MSG_ATB_WTITLE_STR ), 80 );

   ATBNewMenu[0].nm_Label  = CMsgATB( MSG_ATB_PROJECT_MENU,    MSG_ATB_PROJECT_MENU_STR  );
   ATBNewMenu[1].nm_Label  = CMsgATB( MSG_ATB_LOAD_MENU,       MSG_ATB_LOAD_MENU_STR     );
   ATBNewMenu[2].nm_Label  = CMsgATB( MSG_ATB_SAVE_MENU,       MSG_ATB_SAVE_MENU_STR     );
   ATBNewMenu[3].nm_Label  = CMsgATB( MSG_ATB_SAVEAS_MENU,     MSG_ATB_SAVEAS_MENU_STR   );
   ATBNewMenu[5].nm_Label  = CMsgATB( MSG_ATB_TTEDITOR_MENU,   MSG_ATB_TTEDITOR_MENU_STR );
   ATBNewMenu[6].nm_Label  = CMsgATB( MSG_ATB_DISPLAY_MENU,    MSG_ATB_DISPLAY_MENU_STR  );
   ATBNewMenu[8].nm_Label  = CMsgATB( MSG_ATB_ABOUT_MENU,      MSG_ATB_ABOUT_MENU_STR    );
   ATBNewMenu[9].nm_Label  = CMsgATB( MSG_ATB_QUIT_MENU,       MSG_ATB_QUIT_MENU_STR     );

   ATBNewMenu[10].nm_Label = CMsgATB( MSG_ATB_VIEW_MENU,       MSG_ATB_VIEW_MENU_STR  );
   ATBNewMenu[11].nm_Label = CMsgATB( MSG_ATB_VIEWALL_MENU,    MSG_ATB_VIEWALL_MENU_STR  );
   ATBNewMenu[12].nm_Label = CMsgATB( MSG_ATB_VIEWGEN_MENU,    MSG_ATB_VIEWGEN_MENU_STR  );
   ATBNewMenu[13].nm_Label = CMsgATB( MSG_ATB_VIEWSYS_MENU,    MSG_ATB_VIEWSYS_MENU_STR  );
   ATBNewMenu[14].nm_Label = CMsgATB( MSG_ATB_VIEWINT_MENU,    MSG_ATB_VIEWINT_MENU_STR  );
   ATBNewMenu[15].nm_Label = CMsgATB( MSG_ATB_VIEWUSR_MENU,    MSG_ATB_VIEWUSR_MENU_STR  );
       
   ATBNewMenu[16].nm_Label = CMsgATB( MSG_ATB_EDITING_MENU,    MSG_ATB_EDITING_MENU_STR    );
   ATBNewMenu[17].nm_Label = CMsgATB( MSG_ATB_ADDCLASS_MENU,   MSG_ATB_ADDCLASS_MENU_STR   );
   ATBNewMenu[18].nm_Label = CMsgATB( MSG_ATB_ADDMETHOD_MENU,  MSG_ATB_ADDMETHOD_MENU_STR  );
   ATBNewMenu[19].nm_Label = CMsgATB( MSG_ATB_EDITMETHOD_MENU, MSG_ATB_EDITMETHOD_MENU_STR );
   ATBNewMenu[20].nm_Label = CMsgATB( MSG_ATB_DELCLASS_MENU,   MSG_ATB_DELCLASS_MENU_STR   );
   ATBNewMenu[21].nm_Label = CMsgATB( MSG_ATB_OPTIONS_MENU,    MSG_ATB_OPTIONS_MENU_STR    );
   ATBNewMenu[22].nm_Label = CMsgATB( MSG_ATB_SHOWSRC_MENU,    MSG_ATB_SHOWSRC_MENU_STR    );
   ATBNewMenu[23].nm_Label = CMsgATB( MSG_ATB_SHOWBYTES_MENU,  MSG_ATB_SHOWBYTES_MENU_STR  );

   ATBNewMenu[1].nm_CommKey = CMsgATB( MSG_AM_LOAD_MENUKEY,   MSG_AM_LOAD_MENUKEY_STR   );
   ATBNewMenu[2].nm_CommKey = CMsgATB( MSG_AM_SAVE_MENUKEY,   MSG_AM_SAVE_MENUKEY_STR   );
   ATBNewMenu[3].nm_CommKey = CMsgATB( MSG_AM_SAVEAS_MENUKEY, MSG_AM_SAVEAS_MENUKEY_STR );
   ATBNewMenu[8].nm_CommKey = CMsgATB( MSG_AM_ABOUT_MENUKEY,  MSG_AM_ABOUT_MENUKEY_STR  );
   ATBNewMenu[9].nm_CommKey = CMsgATB( MSG_AM_QUIT_MENUKEY,   MSG_AM_QUIT_MENUKEY_STR   );
      
   ATBNGad[0].ng_GadgetText = CMsgATB( MSG_ATB_CLASSES_LV_GAD,  MSG_ATB_CLASSES_LV_GAD_STR  );
   ATBNGad[1].ng_GadgetText = CMsgATB( MSG_ATB_METHODS_LV_GAD,  MSG_ATB_METHODS_LV_GAD_STR  );
   ATBNGad[2].ng_GadgetText = CMsgATB( MSG_ATB_METHOD_LV_GAD,   MSG_ATB_METHOD_LV_GAD_STR   );
   ATBNGad[3].ng_GadgetText = CMsgATB( MSG_ATB_COMMAND_STR_GAD, MSG_ATB_COMMAND_STR_GAD_STR );

   return( 0 );
}

SUBFUNC int allocateLVMs( void )
{
   int numMethods    = getNumberMethods( "Object" ); // In Global.c
   int fileLineCount = getFileLineCount( "Object" ); // In Global.c
   int rval          = RETURN_OK;
   
   if (!(classesLVM = Guarded_AllocLV( countTheseClasses( VIEW_ALL ),
                                       CLASSES_ELEMENTSIZE ))) // == NULL)
      {
      rval = ERROR_NO_FREE_STORE;
      
      goto exitAllocations;
      }

   SetupList( &classesList, classesLVM ); // setup the listview Gadget Space

   if (!(methodsLVM = Guarded_AllocLV( numMethods, METHODS_ELEMENTSIZE ))) // == NULL)
      {
      Guarded_FreeLV( classesLVM ); // Free old listview space
      
      rval = ERROR_NO_FREE_STORE;
      
      goto exitAllocations;
      }
   
   SetupList( &methodsList, methodsLVM );
   
   if (!(methodSrcLVM = Guarded_AllocLV( fileLineCount, METHODSRC_ELEMENTSIZE ))) // == NULL)
      {
      Guarded_FreeLV( classesLVM ); // Free old listview space
      Guarded_FreeLV( methodsLVM ); // Free old listview space
      
      rval = ERROR_NO_FREE_STORE;
      
      goto exitAllocations;
      }
   
   SetupList( &methodSrcList, methodSrcLVM );

exitAllocations:
      
   return( rval );
}

PRIVATE BOOL openedLocaleBase = FALSE;

PRIVATE int setupBrowser( char *browserName )
{
   int rval = RETURN_OK;

//   DBG( fprintf( stderr, "Entering setupBrowser()...\n" ) );
	
   if (!LocaleBase) // == NULL)
      {
#     ifdef __SASC
      if (!(LocaleBase = (struct LocaleBase *) OpenLibrary( "locale.library", 39L ))) // == NULL)
         {
         Aaarrgg( CMsgATB( MSG_LOCALE_ERROR, MSG_LOCALE_ERROR_STR ), 
                  CMsgATB( MSG_RQTITLE_SYSTEM_PROBLEM, MSG_RQTITLE_SYSTEM_PROBLEM_STR ) 
                );

         rval = ERROR_INVALID_RESIDENT_LIBRARY;
         
         goto exitBrowser;
         }
      else
         openedLocaleBase = TRUE;
#     else
      if ((LocaleBase = OpenLibrary( "locale.library", 50L ))) // != NULL)
         {
	      if (!(ILocale = (struct LocaleIFace *) GetInterface( LocaleBase, "main", 1, NULL )))
	         {
            CloseLibrary( LocaleBase );
	         LocaleBase = NULL;
	         }
	      else
	         openedLocaleBase = TRUE;   
	      }
#     endif
      }
   else
      openedLocaleBase = FALSE;
            
   // NULL is for the Locale (from OpenLocale()): 
   browserCatalog = OpenCatalog( NULL, "atalkbrowser.catalog",
                                 OC_BuiltInLanguage, MY_LANGUAGE,
                                 TAG_DONE 
                               );

//   DBG( fprintf( stderr, "setupBrowser(): Calling setupATBCatalog()...\n" ) );

   if (setupATBCatalog() != 0)
      {
      Aaarrgg( CMsgATB( MSG_CATALOG_PROBLEM, MSG_CATALOG_PROBLEM_STR ), 
               CMsgATB( MSG_RQTITLE_ATALK_PROBLEM, MSG_RQTITLE_ATALK_PROBLEM_STR ) 
             );
      
      CloseCatalog( browserCatalog );
      
      if (openedLocaleBase == TRUE)
         {
#        ifdef __amigaos4__
         DropInterface( (struct Interface *) ILocale );
#        endif

         CloseLibrary( (struct Library *) LocaleBase );
  	      }
         
      rval = IoErr();
      
      goto exitBrowser;
      }

//   DBG( fprintf( stderr, "setupBrowser(): Calling OpenATBWindow()...\n" ) );
   if (OpenATBWindow() < 0)
      {
      Aaarrgg( CMsgATB( MSG_ATB_WINDOW_ERROR, MSG_ATB_WINDOW_ERROR_STR ), 
               CMsgATB( MSG_RQTITLE_ATALK_PROBLEM, MSG_RQTITLE_ATALK_PROBLEM_STR ) 
             );

      rval = ERROR_ON_OPENING_WINDOW;
            
      goto exitBrowser;
      }

   DBG( fprintf( stderr, "setupBrowser(): Calling SetNotifyWindow( 0x%08LX )...\n", ATBWnd ) );
   SetNotifyWindow( ATBWnd );

   // Disable unused menu items (for now!):
   SetItemFlags( CMsgATB( MSG_ATB_SAVE_MENU, MSG_ATB_SAVE_MENU_STR ),
                 (HIGHCOMP | COMMSEQ | ITEMTEXT) & ~ITEMENABLED 
               );

   SetItemFlags( CMsgATB( MSG_ATB_SAVEAS_MENU, MSG_ATB_SAVEAS_MENU_STR ),
                 (HIGHCOMP | COMMSEQ | ITEMTEXT) & ~ITEMENABLED 
               );

   SetItemFlags( CMsgATB( MSG_ATB_DISPLAY_MENU, MSG_ATB_DISPLAY_MENU_STR ),
                 (HIGHCOMP | COMMSEQ | ITEMTEXT) & ~ITEMENABLED 
               );

   StringNCopy( ATBPgmName, browserName, 256 ); 

//   DBG( fprintf( stderr, "setupBrowser(): Calling FindIcon()...\n" ) );
   (void) FindIcon( &processATBTools, brIcon_do, browserName );

   // Now, load in ALL Classes, & the Methods for Object, etc:

   if (allocateLVMs() != RETURN_OK)
      {
      UserInfo( CMsgATB( MSG_NO_MEMORY, MSG_NO_MEMORY_STR ),
                CMsgATB( MSG_RQTITLE_SYSTEM_PROBLEM, MSG_RQTITLE_SYSTEM_PROBLEM_STR )
              );

      rval = ERROR_NO_FREE_STORE;
      
      goto exitBrowser;
      }

   lastClassIndex = 0;

   // Tie the Lists to the ListView Gadgets:

   GT_SetGadgetAttrs( CLASSES_GAD, ATBWnd, NULL, 
                      GTLV_Labels,       &classesList,
                      GTLV_Selected,     0, 
                      GTLV_MakeVisible,  0,
                      TAG_DONE 
                    );

   GT_SetGadgetAttrs( METHODS_GAD, ATBWnd, NULL, 
                      GTLV_Labels,      &methodsList,
                      GTLV_Selected,     0, 
                      GTLV_MakeVisible,  0,
                      TAG_DONE 
                    );
   
   GT_SetGadgetAttrs( METHOD_GAD, ATBWnd, NULL, 
                      GTLV_Labels,      &methodSrcList,
                      GTLV_Selected,     0, 
                      GTLV_MakeVisible,  0,
                      TAG_DONE 
                    );

//   DBG( fprintf( stderr, "setupBrowser(): Calling ViewAllClicked()...\n" ) );

   ViewAllClicked();             // Setup Classes ListView.
   (void) ClassesLVClicked( 0 ); // Pretend User selected Object Class
       
exitBrowser:

   return( rval );
}

PRIVATE void FreeLists( void )
{
   int i = 0;
/*
   if (sourceFileNames != NULL)
      {
      while (i < arraySize)
         {
         if (sourceFileNames[i] != NULL)
            FreeVec( sourceFileNames[i] );
            
         i++;
         }   
      
      FreeVec( sourceFileNames );
      }
*/
   i = 0;

   if (parentClassNames) // != NULL)
      {
      while (i < arraySize)
         {
         if (parentClassNames[i] != NULL)
            FreeVec( parentClassNames[i] );
            
         i++;
         }   
   
      FreeVec( parentClassNames );

      allocSrcParentArrays = FALSE;    // Reset guard
      }

   Guarded_FreeLV( classesLVM   ); // Free old listview space
   Guarded_FreeLV( methodsLVM   ); // Free old listview space
   Guarded_FreeLV( methodSrcLVM ); // Free old listview space

   return;
}

PUBLIC int useBrowser( struct Window *parentW, char *browserName )
{
   int rval = TRUE;

   if (!parentW) // == NULL)
      return( rval = NULL_POINTER_FOUND ); // Keep program sane!
      
   SetNotifyWindow( parentW );

   if (setupBrowser( browserName ) != RETURN_OK)
      goto exitBrowser;

   (void) HandleATBIDCMP();
   
   CloseATBWindow(); // Just in case

exitBrowser:

   if (browserCatalog) // != NULL)        // catalog can be NULL!
      CloseCatalog( browserCatalog );

   if (openedLocaleBase == TRUE)
      {
#     ifdef __amigaos4__
      DropInterface( (struct Interface *) ILocale );
#     endif

      CloseLibrary( (struct Library *) LocaleBase );
      }
      
   SetNotifyWindow( parentW );

   FreeLists();

   if (brIcon_do) // != NULL)
      FreeDiskObject( brIcon_do );
      
   return( rval );
}

/* --------------------- END of ATalkBrowser.c file! ------------ */
