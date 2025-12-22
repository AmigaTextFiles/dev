/****h* ATalkEnviron.c [3.0] *******************************************
*
* NAME
*    ATalkEnviron.c
*
* DESCRIPTION
*    ATalkEnviron.c is a GUI for setting the Environment for
*    AmigaTalkPPC in AmigaTalk.ini
*
* SYNOPSIS
*    int success = ATalkEnvironEditor( UBYTE *iniFileName );
*
* HISTORY
*    Dec-30-2004 - Created this file.
*
* COPYRIGHT
*    ATalkEnviron.c Dec-30-2004  by J.T. Steichen
*
* NOTES
*    Program set up to compile with gcc & AmigaOS4 also.
*
*    $VER: ATalkEnviron.c 3.0 (Dec-30-2004) by J.T. Steichen
************************************************************************
*
*/

#include <stdio.h>
#include <string.h>

#include <exec/types.h>

#include <AmigaDOSErrs.h>           // All AmigaDOS error numbers in one file!

#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/gadgetclass.h>

#include <libraries/gadtools.h>

#define USE_ASL_REQ        1

#ifdef     USE_ASL_REQ
# include <utility/tagitem.h>
# include <dos/dostags.h>
# include <libraries/asl.h>
#endif

#include <graphics/displayinfo.h>
#include <graphics/gfxbase.h>

#ifdef __SASC

# include <proto/locale.h>

# include <clib/exec_protos.h>
# include <clib/intuition_protos.h>
# include <clib/gadtools_protos.h>
# include <clib/graphics_protos.h>
# include <clib/utility_protos.h>
# include <clib/diskfont_protos.h>

#else

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/dos.h>
# include <proto/intuition.h>
# include <proto/gadtools.h>
# include <proto/graphics.h>
# include <proto/utility.h>
# include <proto/diskfont.h>
# include <proto/locale.h>

#endif

PUBLIC struct Catalog *ATECatalog = NULL;

#define   CATCOMP_ARRAY    1
#include "ATalkEnvironLocale.h"

#include "CPGM:GlobalObjects/CommonFuncs.h" // Available on osdepot.net as CommonFuncsPPC.lha
#include "CPGM:GlobalObjects/IniFuncs.h"    // Available on osdepot.net as IniFuncs.lha

#define ID_ATalkGroupsMX  0
#define ID_ItemsLV 	  1
#define ID_ItemTxt        2
#define ID_ValueStr       3
#define ID_SelectBt       4
#define ID_FormatTxt      5
#define ID_DoneBt         6
#define ID_RestoreBt      7
#define ID_AbortBt        8
#define ID_HelpBt         9

#define ATI_CNT 	  10

#define GROUP_MX_GAD   ATIGadgets[ ID_ATalkGroupsMX ]
#define ITEMS_LV_GAD   ATIGadgets[ ID_ItemsLV ]

#define ITEMNAME_GAD   ATIGadgets[ ID_ItemTxt ]
#define ITEMVALUE_GAD  ATIGadgets[ ID_ValueStr ]
#define ITEMFORMAT_GAD ATIGadgets[ ID_FormatTxt ]

#define SELECT_GAD     ATIGadgets[ ID_SelectBt ]

// ----------------------------------------------------

#ifdef __SASC

struct IntuitionBase *IntuitionBase;
struct GfxBase       *GfxBase;
struct Library       *GadToolsBase;
struct LocaleBase    *LocaleBase;

#else

// IMPORT -> #define IMPORT extern

IMPORT struct Library *SysBase;
IMPORT struct Library *DOSBase;
IMPORT struct Library *IntuitionBase;
IMPORT struct Library *GfxBase;
IMPORT struct Library *UtilityBase;
IMPORT struct Library *DiskfontBase;
IMPORT struct Library *LocaleBase;

// PUBLIC -> #define PUBLIC // empty declaration!
PUBLIC struct Library *GadToolsBase;

IMPORT struct ExecIFace      *IExec;
IMPORT struct DOSIFace       *IDOS;
IMPORT struct IntuitionIFace *IIntuition;
IMPORT struct GraphicsIFace  *IGraphics;
IMPORT struct UtilityIFace   *IUtility;
IMPORT struct DiskfontIFace  *IDiskfont;
IMPORT struct LocaleIFace    *ILocale;

PUBLIC struct GadToolsIFace  *IGadTools;

#endif

// ------------------------------------------------------
#ifndef STANDALONE
IMPORT struct Window *ATWnd;
IMPORT struct Screen *Scr;
IMPORT UBYTE         *PubScreenName;
IMPORT APTR           VisualInfo;

IMPORT struct TagItem   FontTags[];
IMPORT struct TagItem   ScreenTags[];
IMPORT struct TagItem   LoadTags[];

IMPORT struct TextAttr  helvetica13;
IMPORT struct TextFont *ATFont;
IMPORT struct TextAttr *Font;
IMPORT struct CompFont  CFont;
IMPORT UBYTE           *ErrMsg;
IMPORT UBYTE           *scrtitle;

#else

// PRIVATE -> #define PRIVATE static

PRIVATE struct Screen   *Scr           = NULL;
PRIVATE UBYTE           *PubScreenName = "Workbench";
PRIVATE APTR             VisualInfo    = (APTR) NULL;

PRIVATE struct TextAttr  helvetica13   = { "helvetica.font", 13, 0, FPF_DISKFONT };
PRIVATE struct TextFont *ATFont;
PRIVATE struct TextAttr *Font, Attr;
PRIVATE struct CompFont  CFont;
PRIVATE UBYTE            em[512], *ErrMsg = &em[0];
PRIVATE UBYTE           *scrtitle;

PRIVATE struct TagItem FontTags[] = {

    ASLFO_Window,          0L,   
    ASLFO_Screen,          0L,
    ASLFO_TitleText,       0L,
    ASLFO_InitialHeight,   500,
    ASLFO_InitialWidth,    500,
    ASLFO_InitialTopEdge,  25,
    ASLFO_InitialLeftEdge, 100,
    ASLFO_PositiveText,    0L,
    ASLFO_NegativeText,    0L,
    ASLFO_Flags,           FOF_DOSTYLE | FOF_DODRAWMODE,

    ASLFO_SampleText,      0L,
    ASLFO_DoDrawMode,      1, // Display DrawMode Cycle Gadget.
    ASLFO_DoStyle,         1, // Display Style Checkboxes.
    ASLFO_SleepWindow,     1,
    ASLFO_PrivateIDCMP,    1,
    ASLFO_PopToFront,      1,
    ASLFO_Activate,        1,
    TAG_DONE 
};

PRIVATE struct TagItem ScreenTags[] = {

    ASLSM_Window,           0L,   
    ASLSM_Screen,           0L,
    ASLSM_TitleText,        0L,
    ASLSM_InitialHeight,    500,
    ASLSM_InitialWidth,     500,
    ASLSM_InitialTopEdge,   25,
    ASLSM_InitialLeftEdge,  100,

#   ifdef __SASC    
    ASLSM_InitialDisplayID,     0x40D20001,
    ASLSM_InitialDisplayWidth,  640,
    ASLSM_InitialDisplayHeight, 480,
#   else
    ASLSM_InitialDisplayID,     0x50031100,
    ASLSM_InitialDisplayWidth,  1024,
    ASLSM_InitialDisplayHeight, 768,
#   endif
    ASLSM_InitialDisplayDepth,  8,

    ASLSM_DoWidth,          1,
    ASLSM_DoHeight,         1,
    ASLSM_DoDepth,          1,
    
    ASLSM_MinWidth,         640, 
    ASLSM_MinHeight,        400, 

    ASLSM_PositiveText,     0L,
    ASLSM_NegativeText,     0L,

    ASLSM_SleepWindow,      1,
    ASLSM_PrivateIDCMP,     1,
    ASLSM_PopToFront,       1,
    ASLSM_Activate,         1,
    TAG_DONE 
};

PRIVATE struct TagItem LoadTags[] = {

    ASLFR_Window,          0L,   
    ASLFR_Screen,          0L,
    ASLFR_TitleText,       0L,
    ASLFR_InitialHeight,   500,
    ASLFR_InitialWidth,    400,
    ASLFR_InitialTopEdge,  25,
    ASLFR_InitialLeftEdge, 100,
    ASLFR_PositiveText,    0L,
    ASLFR_NegativeText,    0L,
    ASLFR_InitialPattern,  (ULONG) "#?",
    ASLFR_InitialFile,     (ULONG) "",
    ASLFR_InitialDrawer,   (ULONG) "AmigaTalk:",
    ASLFR_Flags1,          FRF_DOPATTERNS,
    ASLFR_Flags2,          FRF_REJECTICONS,
    ASLFR_SleepWindow,     1,
    ASLFR_PrivateIDCMP,    1,
    ASLFR_PopToFront,      1,
    ASLFR_Activate,        1,

    TAG_DONE 
};
#endif

// ------------------------------------------------------

PRIVATE aiPTR ai               = NULL;
PRIVATE UBYTE INIFileName[512] = { 0, };

PRIVATE struct Window       *ATIWnd   = NULL;
PRIVATE struct Gadget       *ATIGList = NULL;
PRIVATE struct Gadget       *ATIGadgets[ ATI_CNT ] = { 0, };

PRIVATE struct IntuiMessage  ATIMsg = { 0, };

PRIVATE UWORD  ATILeft   = 163;
PRIVATE UWORD  ATITop    = 43;
PRIVATE UWORD  ATIWidth  = 725;
PRIVATE UWORD  ATIHeight = 650;
PRIVATE UBYTE *ATIWdt    = NULL;   // WA_Title

PRIVATE UWORD ATIGTypes[ ATI_CNT ] = {

          MX_KIND,    LISTVIEW_KIND,        TEXT_KIND,
      STRING_KIND,      BUTTON_KIND,        TEXT_KIND,
      BUTTON_KIND,      BUTTON_KIND,      BUTTON_KIND,
      BUTTON_KIND,
};

PRIVATE int ATalkGroupsMXClicked( int whichOne  );
PRIVATE int ItemsLVClicked(       int whichItem );
PRIVATE int ValueStrClicked(      int dummy );
PRIVATE int SelectBtClicked(      int dummy );
PRIVATE int DoneBtClicked(        int dummy );
PRIVATE int RestoreBtClicked(     int dummy );
PRIVATE int AbortBtClicked(       int dummy );
PRIVATE int HelpBtClicked(        int dummy );

PRIVATE struct NewGadget ATINGad[ ATI_CNT ] = {

    30,  60,  17,   9, NULL, NULL,
   ID_ATalkGroupsMX, PLACETEXT_RIGHT, NULL, (APTR) ATalkGroupsMXClicked,

   235,  60, 400, 442, "Group Items:", NULL,
   ID_ItemsLV, NG_HIGHLABEL | PLACETEXT_ABOVE, NULL, (APTR) ItemsLVClicked,

   235, 505, 345,  20, "Item Name:", NULL,
   ID_ItemTxt, PLACETEXT_LEFT, NULL, (APTR) NULL,

   235, 535, 345,  20, "Item Value:", NULL,
   ID_ValueStr, NG_HIGHLABEL | PLACETEXT_LEFT, NULL, (APTR) ValueStrClicked,

   590, 535, 100,  20, "_Select..", NULL,
   ID_SelectBt, PLACETEXT_IN, NULL, (APTR) SelectBtClicked,

   235, 565, 345,  20, "Value Format:", NULL,
   ID_FormatTxt, PLACETEXT_LEFT, NULL, (APTR) NULL,

    30, 610, 100,  20, "D_ONE!", NULL,
   ID_DoneBt, PLACETEXT_IN, NULL, (APTR) DoneBtClicked,

   315, 610, 100,  20, "_RESTORE!", NULL,
   ID_RestoreBt, PLACETEXT_IN, NULL, (APTR) RestoreBtClicked,

   590, 610, 100,  20, "_ABORT!", NULL,
   ID_AbortBt, PLACETEXT_IN, NULL, (APTR) AbortBtClicked,

    30, 550, 100,  20, "_HELP!", NULL,
   ID_HelpBt, PLACETEXT_IN, NULL, (APTR) HelpBtClicked,
};

PRIVATE UBYTE label0[80] = { 0, };
PRIVATE UBYTE label1[80] = { 0, };
PRIVATE UBYTE label2[80] = { 0, };
PRIVATE UBYTE label3[80] = { 0, };
PRIVATE UBYTE label4[80] = { 0, };
PRIVATE UBYTE label5[80] = { 0, };
    
PRIVATE STRPTR MX_ATalkGroupsMX0Lbls[] = {

   (STRPTR) &label0[0], // "[AmigaTalkMemorySpaces]",    //MSG_ATEGRP_MEMORY (//80)
   (STRPTR) &label1[0], // "[AmigaTalkPathNames]",       //MSG_ATEGRP_PATHS (//80)
   (STRPTR) &label2[0], // "[AmigaTalkSupportPrograms]", //MSG_ATEGRP_SUPPORT (//80)
   (STRPTR) &label3[0], // "[AmigaTalkMisc]",            //MSG_ATEGRP_MISC (//80)
   (STRPTR) &label4[0], // "[AmigaTalkGUI]",             //MSG_ATEGRP_GUI (//80)
   (STRPTR) &label5[0], // "[AmigaTalkPalette]",         //MSG_ATEGRP_PALETTE (//80)
   NULL
};

PRIVATE ULONG ATIGTags[] = {

   GTMX_Labels,  (ULONG) MX_ATalkGroupsMX0Lbls, 
   GTMX_Spacing, 4, 
   GTMX_Active,  0, 
   TAG_DONE,

   LAYOUTA_Spacing, 2, GTLV_ShowSelected, 0, TAG_DONE,

   GTTX_Border, TRUE, TAG_DONE,

   GTST_MaxChars, 256, TAG_DONE,

   GT_Underscore, '_', TAG_DONE,

   GTTX_Text, (ULONG) "0x12345678", TAG_DONE, // Value Format:

   GT_Underscore, '_', TAG_DONE,

   GT_Underscore, '_', TAG_DONE,

   GT_Underscore, '_', TAG_DONE,

   GT_Underscore, '_', TAG_DONE,
};

// ----------------------------------------------------

/****i* SetupEnvironCatalog() [1.0] *****************************************
*
* NAME
*    SetupEnvironCatalog()
*
* DESCRIPTION
**********************************************************************
*
*/

PRIVATE void SetupEnvironCatalog( void )
{
   ATIWdt = EnvCMsg( MSG_ATI_WTITLE_ENV ); // WA_Title

#  ifdef STANDALONE
   scrtitle = EnvCMsg( MSG_ATI_STITLE_ENV );
#  endif

   StringNCopy( label0, EnvCMsg( MSG_ATEGRP_MEMORY_ENV  ), 80 );
   StringNCopy( label1, EnvCMsg( MSG_ATEGRP_PATHS_ENV   ), 80 );
   StringNCopy( label2, EnvCMsg( MSG_ATEGRP_SUPPORT_ENV ), 80 );
   StringNCopy( label3, EnvCMsg( MSG_ATEGRP_MISC_ENV    ), 80 );
   StringNCopy( label4, EnvCMsg( MSG_ATEGRP_GUI_ENV     ), 80 );
   StringNCopy( label5, EnvCMsg( MSG_ATEGRP_PALETTE_ENV ), 80 );

   ATINGad[ 1 ].ng_GadgetText = EnvCMsg( MSG_GAD_ItemsLV_ENV   );
   ATINGad[ 2 ].ng_GadgetText = EnvCMsg( MSG_GAD_ItemTxt_ENV   );
   ATINGad[ 3 ].ng_GadgetText = EnvCMsg( MSG_GAD_ValueStr_ENV  );
   ATINGad[ 4 ].ng_GadgetText = EnvCMsg( MSG_GAD_SelectBt_ENV  );
   ATINGad[ 5 ].ng_GadgetText = EnvCMsg( MSG_GAD_FormatTxt_ENV );
   ATINGad[ 6 ].ng_GadgetText = EnvCMsg( MSG_GAD_DoneBt_ENV    );
   ATINGad[ 7 ].ng_GadgetText = EnvCMsg( MSG_GAD_RestoreBt_ENV );
   ATINGad[ 8 ].ng_GadgetText = EnvCMsg( MSG_GAD_AbortBt_ENV   );
   ATINGad[ 9 ].ng_GadgetText = EnvCMsg( MSG_GAD_HelpBt_ENV    );

   return;
}

// ----------------------------------------------------------------

PRIVATE void CloseATIWindow( void )
{
   if (ATIWnd) // != NULL
      {
      CloseWindow( ATIWnd );

      ATIWnd = NULL;
      }

   if (ATIGList) // != NULL
      {
      FreeGadgets( ATIGList );

      ATIGList = NULL;
      }

   return;
}

// ----------------------------------------------------------------

#define ELEMENT_SIZE 256
#define NUM_ELEMENTS 256 // The Palette Group can have up to 256 entries

PRIVATE struct ListViewMem *lvm       = NULL;
PRIVATE struct List         itemsList = { 0, };
    
#define MEMORY_MX_GROUP   0
#define PATHS_MX_GROUP    1
#define PROGRAMS_MX_GROUP 2
#define MISC_MX_GROUP     3
#define GUI_MX_GROUP      4
#define PALETTE_MX_GROUP  5

// SUBFUNC -> #define SUBFUNC static

SUBFUNC void clearListView( void )
{
   int i;

   HideListFromView( ITEMS_LV_GAD, ATIWnd );

      for (i = 0; i < lvm->lvm_NumItems; i++)
         lvm->lvm_NodeStrs[ i * lvm->lvm_NodeLength ] = '\0';

   ModifyListView( ITEMS_LV_GAD, ATIWnd, &itemsList, NULL );      

   return;
}

PRIVATE int currentSelectedItem = 0;

SUBFUNC void loadInGroup( int lineNum )
{
   UBYTE *itemName, *itemValue;
   int    i = 1;

   HideListFromView( ITEMS_LV_GAD, ATIWnd );
   
   if (itemName = (UBYTE *) iniGetItemName( ai, lineNum ))
      GT_SetGadgetAttrs( ITEMNAME_GAD, ATIWnd, NULL, GTTX_Text, itemName, TAG_DONE );

   if (itemValue = (UBYTE *) iniGetItemValue( ai, lineNum ))
      GT_SetGadgetAttrs( ITEMVALUE_GAD, ATIWnd, NULL, GTST_String, itemValue, TAG_DONE );
  
   if (itemName)
      StringCopy( &lvm->lvm_NodeStrs[0], itemName );

   if (itemValue)
      {
      StringCat( &lvm->lvm_NodeStrs[0], " = " );
      StringCat( &lvm->lvm_NodeStrs[0], itemValue );
      }

   while ((lineNum + i) <= numberOfElements)
      {
      if (iniIsGroup( ai, lineNum + i ) == TRUE)
         break;

      itemName  = (UBYTE *) iniGetItemName(  ai, lineNum + i );
      itemValue = (UBYTE *) iniGetItemValue( ai, lineNum + i );

      if (itemName)
         StringCopy( &lvm->lvm_NodeStrs[ i * lvm->lvm_NodeLength ], itemName );

      if (itemValue)
         {
         StringCat( &lvm->lvm_NodeStrs[ i * lvm->lvm_NodeLength ], " = " );
         StringCat( &lvm->lvm_NodeStrs[ i * lvm->lvm_NodeLength ], itemValue );
         }

      i++;
      }

   GT_SetGadgetAttrs( ITEMS_LV_GAD, ATIWnd, NULL, 
                       GTLV_Labels,      &itemsList, 
		       GTLV_Selected,    0, 
		       GTLV_MakeVisible, 0,
		       TAG_DONE
		    );      

   currentSelectedItem = 0;      
  
   return;
}

PRIVATE int currentATGroup = MEMORY_MX_GROUP;

PRIVATE int ATalkGroupsMXClicked( int whichOne )
{
   int idx = -1;
   
   currentATGroup = whichOne;

   clearListView();
   
   (void) iniFirstGroup( ai );
      
   switch (currentATGroup)
      {
      case MEMORY_MX_GROUP:
         idx = 1 + iniFindGroup( ai, EnvCMsg( MSG_ATEGRP_MEMORY_ENV ) );
	 DBG( fprintf( stderr, "Memory Group index = %d\n", idx ) );
	 GT_SetGadgetAttrs( ITEMFORMAT_GAD, ATIWnd, NULL, GTTX_Text, "0x12345678", TAG_DONE );
         GT_SetGadgetAttrs( SELECT_GAD, ATIWnd, NULL, GA_Disabled, TRUE, TAG_DONE );
         break;
	 
      case PATHS_MX_GROUP:
         idx = 1 + iniFindGroup( ai, EnvCMsg( MSG_ATEGRP_PATHS_ENV ) );
	 DBG( fprintf( stderr, "Paths Group index = %d\n", idx ) );
	 GT_SetGadgetAttrs( ITEMFORMAT_GAD, ATIWnd, NULL, GTTX_Text, "Vol:Path/Dir/", TAG_DONE );
         GT_SetGadgetAttrs( SELECT_GAD, ATIWnd, NULL, GA_Disabled, FALSE, TAG_DONE );
         break;
	 
      case PROGRAMS_MX_GROUP:
         idx = 1 + iniFindGroup( ai, EnvCMsg( MSG_ATEGRP_SUPPORT_ENV ) );
	 DBG( fprintf( stderr, "Programs Group index = %d\n", idx ) );
	 GT_SetGadgetAttrs( ITEMFORMAT_GAD, ATIWnd, NULL, GTTX_Text, "Vol:Path/Command", TAG_DONE );
         GT_SetGadgetAttrs( SELECT_GAD, ATIWnd, NULL, GA_Disabled, FALSE, TAG_DONE );
         break;
	 
      case MISC_MX_GROUP:
         idx = 1 + iniFindGroup( ai, EnvCMsg( MSG_ATEGRP_MISC_ENV ) );
	 DBG( fprintf( stderr, "Misc Group index = %d\n", idx ) );
	 GT_SetGadgetAttrs( ITEMFORMAT_GAD, ATIWnd, NULL, GTTX_Text, "Misc String", TAG_DONE );
         GT_SetGadgetAttrs( SELECT_GAD, ATIWnd, NULL, GA_Disabled, TRUE, TAG_DONE );
         break;
	 
      case PALETTE_MX_GROUP:
         idx = 1 + iniFindGroup( ai, EnvCMsg( MSG_ATEGRP_PALETTE_ENV ) );
	 DBG( fprintf( stderr, "Palette Group index = %d\n", idx ) );
	 GT_SetGadgetAttrs( ITEMFORMAT_GAD, ATIWnd, NULL, GTTX_Text, "0xRRGGBB00", TAG_DONE );
         GT_SetGadgetAttrs( SELECT_GAD, ATIWnd, NULL, GA_Disabled, TRUE, TAG_DONE );
         break;
	 
      case GUI_MX_GROUP:
         idx = 1 + iniFindGroup( ai, EnvCMsg( MSG_ATEGRP_GUI_ENV ) );
	 DBG( fprintf( stderr, "GUI Group index = %d\n", idx ) );
	 GT_SetGadgetAttrs( ITEMFORMAT_GAD, ATIWnd, NULL, GTTX_Text, "Size or String", TAG_DONE );
         GT_SetGadgetAttrs( SELECT_GAD, ATIWnd, NULL, GA_Disabled, FALSE, TAG_DONE );
         break;
      }

   loadInGroup( idx );

   return( TRUE );
}

SUBFUNC UBYTE *skipToValueString( UBYTE *inputLine )
{
   int i = 0, j = 0;

   while (*(inputLine + i) != ' ')
      i++;
   
   while (*(inputLine + i) == ' ' || *(inputLine + i) == '=')
      i++;

   return( &inputLine[i] );
}

PRIVATE UBYTE in[ ELEMENT_SIZE ] = { 0, };

SUBFUNC UBYTE *getItemName( UBYTE *inputLine )
{
   int i = 0;

   in[0] = '\0';
      
   for (i = 0; i < ELEMENT_SIZE; i++)
      {
      if (*(inputLine + i) == ' ')
         break;
      else
         in[i] = *(inputLine + i);
      }

   in[i] = '\0';
   
   return( &in[0] );
}

PRIVATE UBYTE iv[ ELEMENT_SIZE ] = { 0, };

SUBFUNC UBYTE *getItemValue( UBYTE *inputLine )
{
   UBYTE *start = skipToValueString( inputLine );
   int    i     = 0, j = 0;

   iv[0] = '\0';
   
   while (*(start + i) != '\0')
      {
      iv[j++] = *(start + i++);
      }

   iv[j] = '\0';
   
   return( &iv[0] );
}


PRIVATE int ItemsLVClicked( int whichItem )
{
   UBYTE *line = &lvm->lvm_NodeStrs[ whichItem * lvm->lvm_NodeLength ];
   
   currentSelectedItem = whichItem;
   
   GT_SetGadgetAttrs(  ITEMNAME_GAD, ATIWnd, NULL, GTTX_Text,   getItemName(  line ), TAG_DONE );

   GT_SetGadgetAttrs( ITEMVALUE_GAD, ATIWnd, NULL, GTST_String, getItemValue( line ), TAG_DONE );

   return( TRUE );
}

SUBFUNC int gotoSelectedGroup( void )
{
   int idx = 0;

   switch (currentATGroup)
      {
      case MEMORY_MX_GROUP:
         idx = 1 + iniFindGroup( ai, EnvCMsg( MSG_ATEGRP_MEMORY_ENV ) );
         break;
	 
      case PATHS_MX_GROUP:
         idx = 1 + iniFindGroup( ai, EnvCMsg( MSG_ATEGRP_PATHS_ENV ) );
         break;
	 
      case PROGRAMS_MX_GROUP:
         idx = 1 + iniFindGroup( ai, EnvCMsg( MSG_ATEGRP_SUPPORT_ENV ) );
         break;
	 
      case MISC_MX_GROUP:
         idx = 1 + iniFindGroup( ai, EnvCMsg( MSG_ATEGRP_MISC_ENV ) );
         break;
	 
      case PALETTE_MX_GROUP:
         idx = 1 + iniFindGroup( ai, EnvCMsg( MSG_ATEGRP_PALETTE_ENV ) );
         break;
	 
      case GUI_MX_GROUP:
         idx = 1 + iniFindGroup( ai, EnvCMsg( MSG_ATEGRP_GUI_ENV ) );
         break;
      }

   return( idx );
}

PRIVATE int ValueStrClicked( int dummy )
{
   UBYTE *line     = &lvm->lvm_NodeStrs[ currentSelectedItem * lvm->lvm_NodeLength ];
   UBYTE *value    = StrBfPtr( ITEMVALUE_GAD );
   UBYTE *itemName = getItemName( line );
   int    idx      = 0;
      
   HideListFromView( ITEMS_LV_GAD, ATIWnd );

      sprintf( line, "%s = %s", itemName, value );

      (void) iniFirstGroup( ai );

      idx = gotoSelectedGroup();

      if ((idx = iniFindItem( ai, itemName )) > 0)
         {
	 sprintf( ErrMsg, " = %s", value );
         
	 (void) iniSetItemValue( ai, idx, ErrMsg );
	 }
      
   GT_SetGadgetAttrs( ITEMS_LV_GAD, ATIWnd, NULL, GTLV_Labels,      &itemsList, 
                                                  GTLV_Selected,    currentSelectedItem,
                                                  GTLV_MakeVisible, currentSelectedItem,
						  TAG_DONE
		    );      

   return( TRUE );
}

PRIVATE UBYTE fileName[512] = { 0, };
PRIVATE UBYTE pathName[512] = { 0, };
    
SUBFUNC void obtainPathName( void )
{
   UBYTE *line     = &lvm->lvm_NodeStrs[ currentSelectedItem * lvm->lvm_NodeLength ];
   UBYTE *itemName = getItemName( line );
   UBYTE *thePath  = NULL;
   
   fileName[0] = '\0';
   pathName[0] = '\0';

   SetTagItem( LoadTags, ASLFR_TitleText, (ULONG) EnvCMsg( MSG_SELECT_PATH_NAME_ENV ) );
   
   if (File_DirReq( fileName, pathName, LoadTags ) > 0)
      {
      thePath = GetPathName( pathName, fileName, 512 );
      
      if (thePath)
         {
	 int idx = 0;
	 
         HideListFromView( ITEMS_LV_GAD, ATIWnd );

            sprintf( line, "%s = %s", itemName, thePath );

            (void) iniFirstGroup( ai );

            idx = 1 + iniFindGroup( ai, EnvCMsg( MSG_ATEGRP_PATHS_ENV ) );

            if ((idx = iniFindItem( ai, itemName )) > 0)
	       {
    	       sprintf( ErrMsg, " = %s", thePath );
               
	       (void) iniSetItemValue( ai, idx, ErrMsg );
	       }

         GT_SetGadgetAttrs( ITEMVALUE_GAD, ATIWnd, NULL, GTST_String, thePath, TAG_DONE );

         GT_SetGadgetAttrs( ITEMS_LV_GAD, ATIWnd, NULL, GTLV_Labels,      &itemsList, 
                                                        GTLV_Selected,    currentSelectedItem,
                                                        GTLV_MakeVisible, currentSelectedItem,
		    	                                TAG_DONE
		          );      
	 }
      }
      
   return;
}

SUBFUNC void obtainCommandName( void )
{
   UBYTE *line     = &lvm->lvm_NodeStrs[ currentSelectedItem * lvm->lvm_NodeLength ];
   UBYTE *itemName = getItemName( line );

   fileName[0] = '\0';

   SetTagItem( LoadTags, ASLFR_TitleText, (ULONG) EnvCMsg( MSG_SELECT_CMD_NAME_ENV ) );
   
   if (FileReq( fileName, LoadTags ) > 0)
      {
      int idx = 0;
      
      HideListFromView( ITEMS_LV_GAD, ATIWnd );

         sprintf( line, "%s = %s", itemName, fileName );

         (void) iniFirstGroup( ai );

         idx = 1 + iniFindGroup( ai, EnvCMsg( MSG_ATEGRP_SUPPORT_ENV ) );

         if ((idx = iniFindItem( ai, itemName )) > 0)
	    {
            sprintf( ErrMsg, " = %s", fileName );
            
	    (void) iniSetItemValue( ai, idx, ErrMsg );
	    }

      GT_SetGadgetAttrs( ITEMVALUE_GAD, ATIWnd, NULL, GTST_String, fileName, TAG_DONE );

      GT_SetGadgetAttrs( ITEMS_LV_GAD, ATIWnd, NULL, GTLV_Labels,      &itemsList, 
                                                     GTLV_Selected,    currentSelectedItem,
                                                     GTLV_MakeVisible, currentSelectedItem,
	                                             TAG_DONE
		       );      
      }

   return;
} 

SUBFUNC void obtainScreenModeID( void )
{
   UBYTE *line     = &lvm->lvm_NodeStrs[ currentSelectedItem * lvm->lvm_NodeLength ];
   UBYTE *itemName = getItemName( line );
   ULONG  modeID   = 0L;
   int    idx      = 0;

   modeID = getScreenModeID( ScreenTags, Scr, EnvCMsg( MSG_SELECT_SCR_MODE_ENV ) );

   HideListFromView( ITEMS_LV_GAD, ATIWnd );

      sprintf( line, "%s = 0x%08LX", itemName, modeID );

      (void) iniFirstGroup( ai );

      idx = 1 + iniFindGroup( ai, EnvCMsg( MSG_ATEGRP_GUI_ENV ) );

      if ((idx = iniFindItem( ai, itemName )) > 0)
         {
	 sprintf( ErrMsg, " = 0x%08LX", modeID );
         
	 (void) iniSetItemValue( ai, idx, ErrMsg );
      
	 sprintf( ErrMsg, "0x%08LX", modeID );

         GT_SetGadgetAttrs( ITEMVALUE_GAD, ATIWnd, NULL, GTST_String, ErrMsg, TAG_DONE );
	 }

   GT_SetGadgetAttrs( ITEMS_LV_GAD, ATIWnd, NULL, GTLV_Labels,      &itemsList, 
                                                  GTLV_Selected,    currentSelectedItem,
                                                  GTLV_MakeVisible, currentSelectedItem,
						  TAG_DONE
		    );      

   return;
}

SUBFUNC void obtainFontName( void )
{
   UBYTE           *line     = &lvm->lvm_NodeStrs[ currentSelectedItem * lvm->lvm_NodeLength ];
   UBYTE           *itemName = getItemName( line );
   struct TextAttr *font     = NULL;
   
//   SetTagItem( FontTags,  ASLFO_TitleText, EnvCMsg( MSG_SELECT_FONT_NAME, MSG_SELECT_FONT_NAME_STR ) );

   font = getUserFont( FontTags, Scr, EnvCMsg( MSG_SELECT_FONT_NAME_ENV ) );

   if (font)
      {
      int idx = 0;
      
      HideListFromView( ITEMS_LV_GAD, ATIWnd );

         sprintf( line, "%s = %s", itemName, font->ta_Name );

         (void) iniFirstGroup( ai );

         idx = 1 + iniFindGroup( ai, EnvCMsg( MSG_ATEGRP_GUI_ENV ) );

         if ((idx = iniFindItem( ai, itemName )) > 0)
	    {
            sprintf( ErrMsg, " = %s", font->ta_Name );
	    
            (void) iniSetItemValue( ai, idx, font->ta_Name );
	    }

      GT_SetGadgetAttrs( ITEMVALUE_GAD, ATIWnd, NULL, GTST_String, font->ta_Name, TAG_DONE );

      GT_SetGadgetAttrs( ITEMS_LV_GAD, ATIWnd, NULL, GTLV_Labels,      &itemsList, 
                                                     GTLV_Selected,    currentSelectedItem,
                                                     GTLV_MakeVisible, currentSelectedItem,
						     TAG_DONE
		       );      
      }

   return;
}

SUBFUNC void obtainGUIString( void )
{
   LONG itemName = 0L;
   int  len      = 0;
      
   GT_GetGadgetAttrs( ITEMNAME_GAD, ATIWnd, NULL, GTTX_Text, &itemName, TAG_DONE );
   
   len = StringLength( (UBYTE *) itemName );
   
   if (StringNComp( (UBYTE *) itemName, EnvCMsg( MSG_ATEGRP_ITEM_SCREENMODEID_ENV ), len ) == 0)
      {
      obtainScreenModeID();
      return;
      }
   
   if (StringNComp( (UBYTE *) itemName, EnvCMsg( MSG_ATEGRP_ITEM_FONT_NAME_ENV ), len ) == 0)
      {
      obtainFontName();
      return;
      }
   else
      UserInfo( EnvCMsg( MSG_NO_SELECTION_ENV ), EnvCMsg( MSG_USER_INFO_RQTITLE_ENV ) );
       
   return;
}

PRIVATE int SelectBtClicked( int dummy )
{
   switch (currentATGroup)
      {
      case PATHS_MX_GROUP:
         obtainPathName();
         break;
	 
      case PROGRAMS_MX_GROUP:
         obtainCommandName();
         break;
	 
      case GUI_MX_GROUP:
	 obtainGUIString();
         break;

      case MEMORY_MX_GROUP:
         break;
	 
      case MISC_MX_GROUP:
         break;
	 
      case PALETTE_MX_GROUP:
         break;
      }

   return( TRUE );
}

PRIVATE int DoneBtClicked( int dummy )
{
   if (ai)
      iniWrite( ai );
      
   return( FALSE );
}

PRIVATE int RestoreBtClicked( int dummy )
{
   ULONG whichOne = 0L;
   
   GT_GetGadgetAttrs( GROUP_MX_GAD, ATIWnd, NULL, GTMX_Active, &whichOne, TAG_DONE );

   // Close the .ini file & re-open/load it.
   if (ai)
      {
      iniExit( ai );
      
      if ((ai = iniOpenFile( INIFileName, TRUE, "= ;&" )))
         {
         (void) ATalkGroupsMXClicked( (whichOne & 0x0000FFFF) );

         GT_SetGadgetAttrs( GROUP_MX_GAD, ATIWnd, NULL, GTMX_Active, (whichOne & 0x0000FFFF), TAG_DONE );
	 }
      }

   return( TRUE );
}

PRIVATE int AbortBtClicked( int dummy )
{
   return( FALSE );
}

PRIVATE int HelpBtClicked( int dummy )
{
   UBYTE command[1024] = { 0, };
   int   chk           = RETURN_OK; 
   
   sprintf( command, "%s %s", EnvCMsg( MSG_HELP_VIEWER_CMD_ENV ),
                              EnvCMsg( MSG_HELP_FILE_ENV )
	  );

   if ((chk = System( command, TAG_DONE )) != RETURN_OK)
      {
      sprintf( ErrMsg, "%s\n\n   Returned %d (ERROR!)", command, chk );
      
      UserInfo( ErrMsg, EnvCMsg( MSG_BAD_COMMAND_RQTITLE_ENV ) );
      }
      
   return( TRUE );
}

// ----------------------------------------------------------------

PRIVATE void BBoxRender( void )
{
   ComputeFont( Scr, Font, &CFont, ATIWidth, ATIHeight );

   DrawBevelBox( ATIWnd->RPort,
                 CFont.OffX + ComputeX( CFont.FontX,  15 ),
                 CFont.OffY + ComputeY( CFont.FontY,  30 ),
                 ComputeX( CFont.FontX, 690 ),
                 ComputeY( CFont.FontY, 570 ),
                 GT_VisualInfo, VisualInfo,
                 TAG_DONE
               );

   return;
}

/****i* SetupGadget() [1.0] *******************************************
*
* NAME
*    SetupGadget()
*
* DESCRIPTION
*    Unrolled the setup gadgets loop that GadToolsBox generated in
*    OpenATIWindow() so that each gadget can be sized differently.
************************************************************************
*
*/

PRIVATE int tagcount = 0;

SUBFUNC struct Gadget *SetupGadget( struct Gadget *g, int idx, int w, int h )
{
   struct NewGadget ng = { 0, };

   CopyMem( (char *) &ATINGad[ idx ], (char *) &ng,
            (long) sizeof( struct NewGadget )
          );

   ng.ng_VisualInfo = VisualInfo;
   ng.ng_TextAttr   = &helvetica13;

   ng.ng_LeftEdge   = CFont.OffX + ComputeX( CFont.FontX,
                                             ng.ng_LeftEdge
                                           );

   ng.ng_TopEdge    = CFont.OffY + ComputeY( CFont.FontY,
                                             ng.ng_TopEdge
                                           );

   ng.ng_Width      = ComputeX( CFont.FontX, w );
   ng.ng_Height     = ComputeY( CFont.FontY, h );

   ATIGadgets[ idx ] = g
                     = CreateGadgetA( (ULONG) ATIGTypes[ idx ],
                                      g, 
                                      &ng, 
                                      (struct TagItem *) &ATIGTags[ tagcount ]
                                    );
   if (!g) // == NULL
      {
      return( NULL );
      }

   while (ATIGTags[ tagcount ] != TAG_DONE)
      tagcount += 2;

   tagcount++; // Go past the TAG_DONE tag.

   return( g );
}

PRIVATE int OpenATIWindow( void )
{
   struct NewGadget  ng;
   struct Gadget    *g;
   UWORD             tc;
   UWORD             wleft, wtop, ww, wh;

   ComputeFont( Scr, Font, &CFont, ATIWidth, ATIHeight );

   ww = ComputeX( CFont.FontX, ATIWidth  );
   wh = ComputeY( CFont.FontY, ATIHeight );

   wleft = (Scr->Width  - ATIWidth ) / 2;
   wtop  = (Scr->Height - ATIHeight) / 2;

   if (!(g = CreateContext( &ATIGList ))) // == NULL
      return( -1 );

         // Customize the width & height here:
      if (!(g = SetupGadget( g, ID_ATalkGroupsMX, 17, 9 ))) // == NULL
         {
         return( -2 );
         }

         // Customize the width & height here:
      if (!(g = SetupGadget( g, ID_ItemsLV, 400, 442 ))) // == NULL
         {
         return( -2 );
         }

         // Customize the width & height here:
      if (!(g = SetupGadget( g, ID_ItemTxt, 346, 20 ))) // == NULL
         {
         return( -2 );
         }

         // Customize the width & height here:
      if (!(g = SetupGadget( g, ID_ValueStr, 346, 20 ))) // == NULL
         {
         return( -2 );
         }

         // Customize the width & height here:
      if (!(g = SetupGadget( g, ID_SelectBt, 100, 20 ))) // == NULL
         {
         return( -2 );
         }

         // Customize the width & height here:
      if (!(g = SetupGadget( g, ID_FormatTxt, 346, 20 ))) // == NULL
         {
         return( -2 );
         }

         // Customize the width & height here:
      if (!(g = SetupGadget( g, ID_DoneBt, 100, 20 ))) // == NULL
         {
         return( -2 );
         }

         // Customize the width & height here:
      if (!(g = SetupGadget( g, ID_RestoreBt, 100, 20 ))) // == NULL
         {
         return( -2 );
         }

         // Customize the width & height here:
      if (!(g = SetupGadget( g, ID_AbortBt, 100, 20 ))) // == NULL
         {
         return( -2 );
         }

      if (!(g = SetupGadget( g, ID_HelpBt, 100, 20 ))) // == NULL
         {
         return( -2 );
         }

   if (!(ATIWnd = OpenWindowTags( NULL,

         WA_Left,          wleft,
         WA_Top,           wtop,
         WA_Width,         ww + CFont.OffX + Scr->WBorRight,
         WA_Height,        wh + CFont.OffY + Scr->WBorBottom,
         WA_MinWidth,      200,
	 WA_MinHeight,     50,
	 
         WA_IDCMP,        STRINGIDCMP | TEXTIDCMP | BUTTONIDCMP | LISTVIEWIDCMP
           | IDCMP_VANILLAKEY | IDCMP_RAWKEY | IDCMP_REFRESHWINDOW, // | IDCMP_CHANGEWINDOW,

         WA_Flags,         WFLG_ACTIVATE | WFLG_DRAGBAR | WFLG_DEPTHGADGET
           | WFLG_RMBTRAP | WFLG_SMART_REFRESH, // | WFLG_HASZOOM,

         WA_Gadgets,       ATIGList,
         WA_Title,         ATIWdt,
         WA_ScreenTitle,   scrtitle,
         WA_CustomScreen,  Scr,
         TAG_DONE ))) // == NULL
      {
      return( -4 );
      }

   GT_RefreshWindow( ATIWnd, NULL );

   return( 0 );
}

PRIVATE int ATIVanillaKey( int whichKey )
{
   int rval = TRUE;

   switch (whichKey)
      {
      case 's':
      case 'S': // _Select.. Button
         rval = SelectBtClicked( 0 );
         break;
	 
      case 'o':
      case 'O': // D_ONE! Button
         rval = DoneBtClicked( 0 );
	 break;

      case 'r':
      case 'R': // _RESTORE! Button
         rval = RestoreBtClicked( 0 );
	 break;

      case 'a':
      case 'A': // _ABORT! button
         rval = AbortBtClicked( 0 );
         break;

      case 'h':
      case 'H': // _Help Button
         rval = HelpBtClicked( 0 );
	 break;

      default:
         break;
      }

   return( rval );
}

PRIVATE int ATIRawKey( struct IntuiMessage *m )
{
   int rval = TRUE;

   switch (m->Code)
      {
      case HELP: // 0x5F == 95
         break;

      case UP_ARROW:
         if (currentSelectedItem > 0)
	    {
	    rval = ItemsLVClicked( --currentSelectedItem );
         
	    GT_SetGadgetAttrs( ITEMS_LV_GAD, ATIWnd, NULL,
                                             GTLV_Selected,    currentSelectedItem,
                                             GTLV_MakeVisible, currentSelectedItem,
                                             TAG_DONE
                             );      
	    }
	 else
	    {
	    rval = ItemsLVClicked( 0 );

	    GT_SetGadgetAttrs( ITEMS_LV_GAD, ATIWnd, NULL,
                                             GTLV_Selected,    0,
                                             GTLV_MakeVisible, 0,
                                             TAG_DONE
                             );      
	    }

         break;
	 
      case DOWN_ARROW:
         if (currentSelectedItem < lvm->lvm_NumItems)
	    {
	    rval = ItemsLVClicked( ++currentSelectedItem );

	    GT_SetGadgetAttrs( ITEMS_LV_GAD, ATIWnd, NULL,
                                             GTLV_Selected,    currentSelectedItem,
                                             GTLV_MakeVisible, currentSelectedItem,
                                             TAG_DONE
                             );      
	    }
	 else
	    {
	    rval = ItemsLVClicked( lvm->lvm_NumItems );

	    GT_SetGadgetAttrs( ITEMS_LV_GAD, ATIWnd, NULL,
                                             GTLV_Selected,    lvm->lvm_NumItems,
                                             GTLV_MakeVisible, lvm->lvm_NumItems,
                                             TAG_DONE
                             );      
	    }
	    
         break;
	 
      default:
         break;

      }

   return( rval );
}

PRIVATE int HandleATIIDCMP( void )
{
   struct IntuiMessage *m;
   int                (*func)( int code );
   BOOL                 running = TRUE;

   while (running == TRUE)
      {
      if (!(m = GT_GetIMsg( ATIWnd->UserPort ))) // == NULL
         {
         (void) Wait( 1L << ATIWnd->UserPort->mp_SigBit );

         continue;
         }

      CopyMem( (char *) m, (char *) &ATIMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (ATIMsg.Class)
         {
            case IDCMP_GADGETUP:
            case IDCMP_GADGETDOWN:
               func = (int (*)( int )) ((struct Gadget *) ATIMsg.IAddress)->UserData;

               if (func) // != NULL
                  running = func( ATIMsg.Code );

               break;

            case IDCMP_VANILLAKEY:
               running = ATIVanillaKey( ATIMsg.Code );
               break;

            case IDCMP_RAWKEY:
               running = ATIRawKey( &ATIMsg );
               break;

//            case IDCMP_CHANGEWINDOW:
            case IDCMP_REFRESHWINDOW:
               GT_BeginRefresh( ATIWnd );
                  BBoxRender();
               GT_EndRefresh( ATIWnd, TRUE );

               break;
         }
      }

   return( running );
}

// ----------------------------------------------------------------

PRIVATE void ShutdownProgram( void )
{
   CloseATIWindow();

   if (ATECatalog)
      CloseCatalog( ATECatalog );

   if (ai)
      iniExit( ai );
            
   if (lvm)
      {   
      Guarded_FreeLV( lvm );

      lvm = NULL;
      }

   return;
}

PRIVATE int SetupProgram( UBYTE *iniFileName )
{
   int rval = RETURN_OK;

   if (!(ai = iniOpenFile( iniFileName, TRUE, "= ;&" )))
      {
      rval = RETURN_FAIL;

      DBG( fprintf( stderr, "Could NOT open %s file!\n", iniFileName ) );

      goto exitSetup;
      }
   
   if (LocaleBase)
      ATECatalog = (struct Catalog *) OpenCatalog( NULL, "atalkenviron.catalog",
                                                   OC_BuiltInLanguage, "english", 
                                                   TAG_DONE 
                                                 );
         
   (void) SetupEnvironCatalog();

   if (OpenATIWindow() != RETURN_OK)
      {
      rval = ERROR_ON_OPENING_WINDOW;

      ShutdownProgram();

      goto exitSetup;
      }

   if (!(lvm = Guarded_AllocLV( NUM_ELEMENTS, ELEMENT_SIZE )))
      {
      ReportAllocLVError();

      rval = ERROR_NO_FREE_STORE;

      goto exitSetup;
      }
   else
      {
      SetupList( &itemsList, lvm );
      
      GT_SetGadgetAttrs( ATIGadgets[ID_ItemsLV], ATIWnd, NULL, 
                         GTLV_Labels,       (ULONG) &itemsList, 
			 GTLV_ShowSelected, 0,
			 GTLV_Selected,     0, 
			 TAG_DONE 
		       );
      }

exitSetup:

   return( rval );
}

#ifndef STANDALONE
PUBLIC int ATalkEnvironEditor( UBYTE *iniFileName )
{
   int rval = RETURN_OK;

   StringNCopy( INIFileName, iniFileName, 512 );

   if ((rval = SetupProgram( iniFileName )) != RETURN_OK)
      {
      return( rval );
      }
      
   SetNotifyWindow( ATIWnd );

   (void) ATalkGroupsMXClicked( 0 );

   (void) HandleATIIDCMP();

   ShutdownProgram();
 
   SetNotifyWindow( ATWnd );
   
   return( rval );
}

#else // STANDALONE is defined!!

PRIVATE void closeLibraries( void )
{
#  ifdef __SASC
   CloseLibs();
#  else
   if (IGadTools)
      DropInterface( (struct Interface *) IGadTools );
      
   if (GadToolsBase)
      CloseLibrary( GadToolsBase );   
#  endif
   
   return;
}

PRIVATE int openLibraries( void )
{
   int rval = RETURN_OK;

#  ifdef __SASC
   if (OpenLibs() < 0)
      rval = ERROR_INVALID_RESIDENT_LIBRARY;
#  else
   if ((GadToolsBase = OpenLibrary( "gadtools.library", 50L )))
      {
      if (!(IGadTools = (struct GadToolsIFace *) GetInterface( GadToolsBase, "main", 1, NULL )))
         {
	 closeLibraries();
	 
         rval = ERROR_INVALID_RESIDENT_LIBRARY;
	 }
      }
   else
      rval = ERROR_INVALID_RESIDENT_LIBRARY;
#  endif
   
   return( rval );
}

PRIVATE BOOL UnlockFlag = FALSE;

PRIVATE void CloseDownScreen( void )
{
   if (VisualInfo) // != NULL) 
      {
      FreeVisualInfo( VisualInfo );
      VisualInfo = NULL;
      }

   if ((UnlockFlag == TRUE) && Scr) // != NULL))
      {
      UnlockPubScreen( NULL, Scr );

      Scr = NULL;
      }

   if (ATFont) // != NULL) 
      {
      CloseFont( ATFont );

      ATFont = NULL;
      }

   return;
}

PRIVATE int SetupScreen( void )
{
   struct Screen *chk = GetActiveScreen();

   if (!(ATFont = OpenDiskFont( &helvetica13 ))) // == NULL)
      return( -5 );

   Font = &Attr;

   if (!(Scr = LockPubScreen( PubScreenName ))) // == NULL)
      return( -1 );

   if (chk != Scr)
      {
      UnlockPubScreen( NULL, Scr );
      Scr = chk;
      UnlockFlag = FALSE;
      }
   else
      UnlockFlag = TRUE;

   ComputeFont( Scr, Font, &CFont, 0, 0 );

   if (!(VisualInfo = GetVisualInfo( Scr, TAG_DONE ))) // == NULL)
      return( -2 );

   return( RETURN_OK );
}

PRIVATE void closeProgram( void )
{
   ShutdownProgram();
   CloseDownScreen();
   closeLibraries();
   
   return;
}

PRIVATE int initProgram( UBYTE *fileName )
{
   int rval = RETURN_OK;
   
   if (SetupScreen() != RETURN_OK)
      {
      rval = ERROR_ON_OPENING_SCREEN;
      
      goto exitInitProgram;
      }

   StringNCopy( INIFileName, fileName, 512 );

   if ((rval = SetupProgram( fileName )) != RETURN_OK)
      {
      return( rval );
      }
      
   SetNotifyWindow( ATIWnd );

   (void) ATalkGroupsMXClicked( 0 );

exitInitProgram:

   return( rval );
}

PUBLIC int main( int argc, char **argv )
{
   int rval = RETURN_OK;

   if (argc != 2)
      {
      rval = ERROR_REQUIRED_ARG_MISSING;

      fprintf( stderr, "USAGE:  ATalkEnvironPPC filename.ini\n" );

      goto exitProgram;
      }

   if ((rval = openLibraries()) != RETURN_OK)
      goto exitProgram;

   if ((rval = initProgram( argv[1] )) != RETURN_OK)
      {
      closeLibraries();

      goto exitProgram;
      }
	      
   SetTagItem( FontTags,   ASLFO_Window, (ULONG) ATIWnd );
   SetTagItem( ScreenTags, ASLSM_Window, (ULONG) ATIWnd );
   SetTagItem( LoadTags,   ASLFR_Window, (ULONG) ATIWnd );

   // SetTagItem() in gcc has a problem, so we do ASLFR_TitleText the hard way here:
   LoadTags[2].ti_Data = (ULONG) EnvCMsg( MSG_SELECT_PATH_NAME_ENV );
   
   (void) HandleATIIDCMP();

   closeProgram();
   
exitProgram:

   return( rval );
}

#endif

/* --------------- END of ATalkEnviron.c file! ------------------ */
