/****h* ATalkBrowserDelReq.c [3.0] ***********************************
*
* NAME
*    ATalkBrowserDelReq.c
*
* DESCRIPTION
*    Delete Class Requester for the new AmigaTalk Browser.
*
* NOTES
*    GUI Designed by : Jim Steichen
*    $VER: ATalkBrowserDelReq.c 3.0 (24-Oct-2004) by J.T. Steichen
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
#include <intuition/gadgetclass.h>

#include <libraries/gadtools.h>

#include <graphics/gfxbase.h>

#ifndef __amigaos4__
# include <clib/exec_protos.h>
# include <clib/intuition_protos.h>
# include <clib/gadtools_protos.h>
# include <clib/graphics_protos.h>
# include <clib/utility_protos.h>

IMPORT struct IntuitionBase *IntuitionBase;
IMPORT struct Library       *GadToolsBase;
IMPORT struct LocaleBase    *LocaleBase;

#else

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/intuition.h>
# include <proto/graphics.h>
# include <proto/gadtools.h>
# include <proto/utility.h>

IMPORT struct Library *IntuitionBase;
IMPORT struct Library *GadToolsBase;
IMPORT struct Library *LocaleBase;

#endif

#include <proto/locale.h>

#define   CATCOMP_ARRAY    1

#include "ATBrowserLocale.h"

#include "FuncProtos.h"

#include "CPGM:GlobalObjects/CommonFuncs.h"

#define GD_ClassLV    0
#define GD_CancelBt   1
#define GD_RCBMBt     2
#define GD_DCSFBt     3
#define GD_DeleteTxt  4
#define GD_DeleteBt   5

#define DCR_CNT       6

#define CLASSTEXTGAD  DCRGadgets[ GD_DeleteTxt ]

// ---------------------------------------------------------

IMPORT char *CMsgATB( int msgNum, char *msgStr );

IMPORT struct CompFont  CFont;
IMPORT struct TextAttr *Font;
IMPORT struct Screen   *Scr;
IMPORT struct Window   *ATBWnd;         // Located in ATalkBrowser.c
IMPORT UBYTE           *PubScreenName;
IMPORT APTR             VisualInfo;
IMPORT UBYTE           *ErrMsg;

// ---------------------------------------------------------

PRIVATE struct Window       *DCRWnd   = NULL;
PRIVATE struct Gadget       *DCRGList = NULL;
PRIVATE struct Gadget       *DCRGadgets[ DCR_CNT ] = { 0, };
PRIVATE struct IntuiMessage  DCRMsg;

PRIVATE UWORD DCRLeft    = 100;
PRIVATE UWORD DCRTop     = 32;
PRIVATE UWORD DCRWidth   = 600;
PRIVATE UWORD DCRHeight  = 480;

PRIVATE UBYTE DCRWdt[80] = "DELETE a Class from AmigaTalk:";

#define DCR_TNUM 3

PRIVATE struct IntuiText DCRIText[ DCR_TNUM ] = {

   2, 0, JAM1, 416, 14, NULL, "WARNING:  The Severity of the action", NULL,
   2, 0, JAM1, 416, 28, NULL, "you take increases the lower the ", NULL,
   2, 0, JAM1, 416, 42, NULL, "button is in this Requester!", NULL 
};

PRIVATE UWORD DCRGTypes[ DCR_CNT ] = {

   LISTVIEW_KIND,   BUTTON_KIND,   BUTTON_KIND,
   BUTTON_KIND,     TEXT_KIND,     BUTTON_KIND
};

PRIVATE int ClassLVClicked(  int whichItem ); // Classes ListView
PRIVATE int CancelBtClicked( int dummy     );
PRIVATE int RCBMBtClicked(   int dummy     );
PRIVATE int DCSFBtClicked(   int dummy     );
PRIVATE int DeleteBtClicked( int dummy     );

PRIVATE struct NewGadget DCRNGad[ DCR_CNT ] = {

     8,  19, 293, 460, "Classes:",                          NULL, 
   GD_ClassLV, PLACETEXT_ABOVE, NULL, (APTR) ClassLVClicked,

   310,  95,  90,  20, " CANCEL! ",                        NULL, 
   GD_CancelBt, PLACETEXT_IN, NULL, (APTR) CancelBtClicked,

   310, 130, 270,  20, "Remove Class from Browser Memory ", NULL, 
   GD_RCBMBt, PLACETEXT_IN, NULL, (APTR) RCBMBtClicked,

   310, 170, 270,  20, "Delete Class source file also",     NULL, 
   GD_DCSFBt, PLACETEXT_IN, NULL, (APTR) DCSFBtClicked,

   310, 400, 200,  20, "Class to DELETE:",                  NULL, 
   GD_DeleteTxt, PLACETEXT_ABOVE, NULL, NULL,

   310, 430, 270,  20, "DELETE Selected Class!",            NULL, 
   GD_DeleteBt, PLACETEXT_IN, NULL, (APTR) DeleteBtClicked
};

PRIVATE ULONG DCRGTags[] = {

   GTLV_ShowSelected, 0, LAYOUTA_Spacing, 2, TAG_DONE,

   TAG_DONE, TAG_DONE, TAG_DONE, GTTX_Border, TRUE, TAG_DONE,

   TAG_DONE
};

// ---- Inter-Function variables: --------------------------

PRIVATE struct ListViewMem *lvm         = NULL;
PRIVATE struct List        *classesList = NULL;

PRIVATE char   selectedClassName[80] = { 0, }; // User wants to kill this one!

PRIVATE int    listIndex = 0; // Which item in the ListView are we on?

// ---------------------------------------------------------

PRIVATE void CloseDCRWindow( void )
{
   if (DCRWnd) // != NULL) 
      {
      CloseWindow( DCRWnd );
      DCRWnd = NULL;
      }

   if (DCRGList) // != NULL) 
      {
      FreeGadgets( DCRGList );
      DCRGList = NULL;
      }

   return;
}

PRIVATE int DCRCloseWindow( void )
{
   CloseDCRWindow();

   return( FALSE );
}

PRIVATE int ClassLVClicked( int whichItem )
{
   char *className = &lvm->lvm_NodeStrs[ whichItem * lvm->lvm_NodeLength ];

   while (*className == ' ')
      className++; // Remove indentation (if any)

   StringNCopy( selectedClassName, className, 80 );

   GT_SetGadgetAttrs( CLASSTEXTGAD, DCRWnd, NULL,
                      GTTX_Text, (UBYTE *) className, TAG_DONE 
                    );

   listIndex = whichItem;
   
   return( TRUE );
}

#define MEMORY_DELETE 1
#define SOURCE_DELETE 2
#define CLASS_DELETE  3

PRIVATE int DeleteAction = FALSE;

PRIVATE int CancelBtClicked( int dummy )
{
   DeleteAction = FALSE;
   
   return( DCRCloseWindow() );
}

SUBFUNC void removeFromBrowserList( char *className )
{
   char *nodeStr = NULL;
   int   idx = 0, i = 0;
      
   while (idx <= lvm->lvm_NumItems)
      {
      nodeStr = &lvm->lvm_NodeStrs[ idx * lvm->lvm_NodeLength ];
      
      while (*nodeStr == ' ')
         nodeStr++; // Remove indentation (if any)
         
      if (StringComp( className, nodeStr ) == 0)
         break;
      else   
         idx++;
      }

   if (StringComp( className, nodeStr ) == 0)
      {
      HideListFromView( DCRGadgets[ GD_ClassLV ], DCRWnd );
      
      i = lvm->lvm_NumItems;
      
      // Move classNames up one node in the class List:
      while ((i > 0) && (idx < (lvm->lvm_NumItems - 1))) 
         {
         StringCopy( &lvm->lvm_NodeStrs[ idx * lvm->lvm_NodeLength ],
                     &lvm->lvm_NodeStrs[ (idx + 1) * lvm->lvm_NodeLength ]
                   );

         i--;
         idx++;
         }

      // Blank out the last node, since it's a duplicate:
      lvm->lvm_NodeStrs[ lvm->lvm_NumItems * lvm->lvm_NodeLength ] = '\0';

      // Refresh classList in ListView Gadget:
      ModifyListView( DCRGadgets[ GD_ClassLV ], DCRWnd, classesList, NULL );
      }

   return;
}

// When gadget "Remove Class from Browser Memory " is clicked:

PRIVATE int RCBMBtClicked( int dummy )
{
   int i = 0;

   if (StringLength( selectedClassName ) < 1)
      goto exitRCBM;   
   
   StringNCopy( ErrMsg, CMsgATB( MSG_DELBRW_WARN, MSG_DELBRW_WARN_STR ), 256 );

   SetReqButtons( CMsgATB( MSG_REQ_BUTTONS, MSG_REQ_BUTTONS_STR ) );  

   i = Handle_Problem( ErrMsg, 
                       CMsgATB( MSG_USER_WARNING, MSG_USER_WARNING_STR ), NULL
                     );
   
   SetReqButtons( CMsgATB( MSG_DEFAULT_BUTTONS_STR, MSG_DEFAULT_BUTTONS_STR_STR ) );

   if (i == 0) // Did User ignore warning??
      {
      removeFromBrowserList( selectedClassName );
                    
      DeleteAction = MEMORY_DELETE;
      }

exitRCBM:

   return( TRUE );
}

// When gadget "Delete Class source file also" is clicked:

PRIVATE int DCSFBtClicked( int dummy )
{
   char  *fileName  = NULL;
   CLASS *classPtr  = NULL;
   
   if (StringLength( selectedClassName ) > 0)
      classPtr = lookup_class( selectedClassName );
   
   if (!classPtr) // == NULL)
      goto exitDeleteSrcFile; // Impossible condition!!
   
   fileName = symbol_value( (SYMBOL *) classPtr->file_name );
      
   sprintf( ErrMsg, CMsgATB( MSG_FORMAT_SRCDEL_WARN, MSG_FORMAT_SRCDEL_WARN_STR ), fileName );
   
   if (SanityCheck( ErrMsg ) == FALSE)
      goto exitDeleteSrcFile; // User came to her senses!
   else
      {
      sprintf( ErrMsg, "Delete %s QUIET", fileName );
      
      if (System( ErrMsg, TAG_DONE ) != 0)
         {
         sprintf( ErrMsg, CMsgATB( MSG_FORMAT_NOT_DELETED, 
                                   MSG_FORMAT_NOT_DELETED_STR ), 
                          fileName 
                );

         UserInfo( ErrMsg, CMsgATB( MSG_RQTITLE_USER_INFO,
                                    MSG_RQTITLE_USER_INFO_STR ) 
                 ); 

         goto exitDeleteSrcFile;         
         }
      }

   removeFromBrowserList( selectedClassName ); // Remove the Class from the List also!

   DeleteAction = SOURCE_DELETE;

exitDeleteSrcFile:
   
   return( TRUE );
}

/****i* DeleteBtClicked() [3.0] ********************************
*
* NAME
*    DeleteBtClicked()
*
* DESCRIPTION
*    EXTREMELY DANGEROUS operation that will probably be 
*    removed from the Browser in the future.
****************************************************************
* 
*/

PRIVATE int DeleteBtClicked( int dummy )
{
   if (StringLength( selectedClassName ) < 1)
      goto exitDeleteAll;   

   sprintf( ErrMsg, 
            CMsgATB( MSG_FORMAT_DANGER, MSG_FORMAT_DANGER_STR ),
            selectedClassName
          );
   
   if (SanityCheck( ErrMsg ) == FALSE)
      goto exitDeleteAll; // User came to her senses!
   else
      {
      struct class_entry *clDict = getClassDictionary();
      
      // First delete the source file & class from the Browser:
      (void) DCSFBtClicked( 0 );
      
      // Now delete it from the class dictionary:
      
      for ( ; clDict != NULL; clDict = clDict->nextLink)
         {
         if (StringComp( selectedClassName, clDict->className ) == 0)
            {
            struct class_entry *dict = getClassDictionary();
            struct class_entry *next = clDict->nextLink;
            
            if (next == NULL) // Last dictionary entry?
               {
               free_obj( clDict->classObject, TRUE );
               
               while (dict->nextLink != clDict)
                  dict = dict->nextLink;
                  
               dict->nextLink = NULL; // Chop off removed node.
               }
            else
               {
               // Found entry, now remove it:

               free_obj( clDict->classObject, TRUE );
            
               for ( ; next != NULL; next = next->nextLink)
                  {
                  // Move all other Class entries over the deleted one:
                  
                  CopyMem( (char *) clDict, (char *) next, 
                           (long) sizeof( struct class_entry )
                         );
                  
                  clDict = next;
                  }
               
               while (dict->nextLink != NULL)
                  dict = dict->nextLink;

               dict = NULL; // Chop off last node.
               }
            }
         }
      }
      
   DeleteAction = CLASS_DELETE;

exitDeleteAll:
   
   return( TRUE );
}

// ---------------------------------------------------------

PRIVATE void DCRRender( void )
{
   struct IntuiText it   = { 0, };
   UWORD            cnt  = 0;
   UWORD            left = 0;

   ComputeFont( Scr, Font, &CFont, DCRWidth, DCRHeight );

   left = Scr->Width - IntuiTextLength( &DCRIText[0] ) - 60;
    
   for (cnt = 0; cnt < DCR_TNUM; cnt++) 
      {
      CopyMem( (char *) &DCRIText[ cnt ], (char *) &it, 
               (long) sizeof( struct IntuiText )
             );
   
      it.ITextFont = Font;
   
      it.LeftEdge  = left; 
      // CFont.OffX + ComputeX( CFont.FontX, it.LeftEdge ) - (IntuiTextLength( &it ) >> 1);
   
      it.TopEdge   = CFont.OffY + ComputeY( CFont.FontY, it.TopEdge ) 
                     - (Font->ta_YSize >> 1);
   
      PrintIText( DCRWnd->RPort, &it, 0, 0 );
      }

   return;
}

/****i* setupDCRGadget() [3.0] *****************************************
*
* NAME
*    setupDCRGadget()
*
* DESCRIPTION
*    Unrolled the setup gadgets loop that GadToolsBox generated in 
*    OpenDCRWindow() so that each gadget can be sized differently.
************************************************************************
*
*/

PRIVATE int tagCount = 0;

SUBFUNC struct Gadget *setupDCRGadget( struct Gadget *g, int idx, int w, int h )
{
   struct NewGadget ng = { 0, };

   CopyMem( (char *) &DCRNGad[ idx ], (char *) &ng, 
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

   ng.ng_Width      = ComputeX( CFont.FontX, w );
   ng.ng_Height     = ComputeY( CFont.FontY, h );

   DCRGadgets[ idx ] = g 
                     = CreateGadgetA( (ULONG) DCRGTypes[ idx ], 
                                      g, 
                                      &ng, 
                                      (struct TagItem *) &DCRGTags[ tagCount ] 
                                    );
   if (!g) // == NULL)
      {
      sprintf( ErrMsg, CMsgATB( MSG_FORMAT_DCR_GADGETS, MSG_FORMAT_DCR_GADGETS_STR ), idx );

      CannotCreate( ErrMsg );

      return( NULL );
      }

   while (DCRGTags[ tagCount ] != TAG_DONE)
      tagCount += 2;

   tagCount++; // Go past the TAG_DONE tag.

   return( g );

}

SUBFUNC int initGadgets( struct Gadget *g )
{
   IMPORT int LabelHSize( char *gadgetLabel );

   DCRNGad[ GD_ClassLV ].ng_LeftEdge = DCRWnd->BorderLeft - 8;
   DCRNGad[ GD_ClassLV ].ng_TopEdge  = Scr->BarHeight + 6;
   
   if (!(g = setupDCRGadget( g, GD_ClassLV, Scr->Width / 2 - 50,
                                            Scr->Height - 30 ))) // == NULL)
      {
      CannotCreate( CMsgATB( MSG_CLASS, MSG_CLASS_STR ) );

      return( -2 );
      }

   DCRNGad[ GD_CancelBt ].ng_LeftEdge = Scr->Width  / 2 - 10;
   DCRNGad[ GD_CancelBt ].ng_TopEdge  = Scr->Height / 5;

   if (!(g = setupDCRGadget( g, GD_CancelBt, 
                                LabelHSize( CMsgATB( MSG_CANCEL_GAD, 
                                                     MSG_CANCEL_GAD_STR )) + 20,
                                20 ))) // == NULL)
      {
      CannotCreate( CMsgATB( MSG_CANCEL, MSG_CANCEL_STR ) );

      return( -2 );
      }

   DCRNGad[ GD_RCBMBt ].ng_LeftEdge = Scr->Width  / 2 - 10;
   DCRNGad[ GD_RCBMBt ].ng_TopEdge  = Scr->Height / 4;
    
   if (!(g = setupDCRGadget( g, GD_RCBMBt, 
                                LabelHSize( CMsgATB( MSG_MEMDEL_GAD, 
                                                     MSG_MEMDEL_GAD_STR )) + 20,
                                20 ))) // == NULL)
      {
      CannotCreate( CMsgATB( MSG_MEMORY_DELETE, MSG_MEMORY_DELETE_STR ) );

      return( -2 );
      }

   DCRNGad[ GD_DCSFBt ].ng_LeftEdge = Scr->Width  / 2 - 10;
   DCRNGad[ GD_DCSFBt ].ng_TopEdge  = DCRNGad[ GD_RCBMBt ].ng_TopEdge + 38;
                                              
   if (!(g = setupDCRGadget( g, GD_DCSFBt, 
                                LabelHSize( CMsgATB( MSG_MEMDEL_GAD, 
                                                     MSG_MEMDEL_GAD_STR )) + 20,
                                20 ))) // == NULL)
      {
      CannotCreate( CMsgATB( MSG_SOURCE_DELETE, MSG_SOURCE_DELETE_STR ) );

      return( -2 );
      }

   DCRNGad[ GD_DeleteTxt ].ng_LeftEdge = Scr->Width / 2 - 10;
   DCRNGad[ GD_DeleteTxt ].ng_TopEdge  = Scr->Height - 70;
   
   if (!(g = setupDCRGadget( g, GD_DeleteTxt, 
                                LabelHSize( CMsgATB( MSG_CLSDEL_GAD, 
                                                     MSG_CLSDEL_GAD_STR ) ) + 50,
                                20 ))) // == NULL)
      {
      CannotCreate( CMsgATB( MSG_DELETE_TXT, MSG_DELETE_TXT_STR ) );

      return( -2 );
      }

   DCRNGad[ GD_DeleteBt ].ng_LeftEdge = Scr->Width / 2 - 10;
   DCRNGad[ GD_DeleteBt ].ng_TopEdge  = Scr->Height - 40;
   
   if (!(g = setupDCRGadget( g, GD_DeleteBt, 
                                LabelHSize( CMsgATB( MSG_DELETE_GAD,
                                                     MSG_DELETE_GAD_STR ) ) + 20,
                                20 ))) // == NULL)
      {
      CannotCreate( CMsgATB( MSG_DELETEBT, MSG_DELETEBT_STR ) );

      return( -2 );
      }

   return( 0 );
}

PRIVATE int OpenDCRWindow( void )
{
   struct Gadget *g;
   UWORD          wleft = DCRLeft, wtop = DCRTop, ww, wh;

   ComputeFont( Scr, Font, &CFont, DCRWidth, DCRHeight );

   ww = Scr->Width;  // ComputeX( CFont.FontX, DCRWidth );
   wh = Scr->Height; // ComputeY( CFont.FontY, DCRHeight );

   if ((wleft + ww + CFont.OffX + Scr->WBorRight) > Scr->Width) 
      wleft = (Scr->Width - ww) / 2;
   else
      wleft = 0;
         
   if ((wtop + wh + CFont.OffY + Scr->WBorBottom) > Scr->Height) 
      wtop = (Scr->Height - wh) / 2;
   else
      wtop = 0;
      
   if (!(g = CreateContext( &DCRGList ))) // == NULL)
      return( -1 );

   if (initGadgets( g ) < 0)
      return( -2 );
      
   if (!(DCRWnd = OpenWindowTags( NULL,

            WA_Left,         wleft,
            WA_Top,          wtop,
            WA_Width,        ww, // + CFont.OffX + Scr->WBorRight,
            WA_Height,       wh, // + CFont.OffY + Scr->WBorBottom,

            WA_IDCMP,        LISTVIEWIDCMP | BUTTONIDCMP | TEXTIDCMP 
              | IDCMP_CLOSEWINDOW | IDCMP_RAWKEY 
              | IDCMP_REFRESHWINDOW,

            WA_Flags,        WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET
              | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,

            WA_Gadgets,      DCRGList,
            WA_Title,        DCRWdt,
            WA_CustomScreen, Scr,
            TAG_DONE )
      
      )) // == NULL)
      return( -4 );

   GT_RefreshWindow( DCRWnd, NULL );

   DCRRender();

   return( 0 );
}

/*
PRIVATE int DCRVanillaKey( int whichKey )
{
   int rval = TRUE;
   
   switch (whichKey)
      {
      case 'c':  // Cancel Button!
      case 'C':
         rval = CancelBtClicked( 0 );
         break;
         
      default:
         break;
      }

   return( rval );
}
*/

SUBFUNC void UpArrow( void )
{
   if (listIndex > 0)
      listIndex--;
   else
      listIndex = 0;

   GT_SetGadgetAttrs( DCRGadgets[ GD_ClassLV ], DCRWnd, NULL, 
                      GTLV_Selected,    listIndex, 
                      GTLV_MakeVisible, listIndex,
                      TAG_DONE 
                    );
   
   (void) ClassLVClicked( listIndex ); // Update the ListView Gadget

   return;
}

SUBFUNC void DownArrow( void )
{
   if (listIndex <= lvm->lvm_NumItems - 1)
      listIndex++;
   else
      listIndex = lvm->lvm_NumItems - 1;

   GT_SetGadgetAttrs( DCRGadgets[ GD_ClassLV ], DCRWnd, NULL, 
                      GTLV_Selected,    listIndex, 
                      GTLV_MakeVisible, listIndex,
                      TAG_DONE 
                    );
   
   (void) ClassLVClicked( listIndex ); // Update the ListView Gadget

   return;
}

PRIVATE int DCRRawKey( int whichKey )
{
   int rval = TRUE;

   switch (whichKey)
      {
      case 0x4C: // Up Arrow:
         UpArrow();
         break;
         
      case 0x4D: // Down Arrow:
         DownArrow();
         break;

      default:
         break;
      }
           
   return( rval );
}

PRIVATE int HandleDCRIDCMP( void )
{
   struct IntuiMessage *m;
   int                (*func)( int );
   BOOL                 running = TRUE;

   while (running == TRUE)
      {
      if (!(m = GT_GetIMsg( DCRWnd->UserPort ))) // == NULL) 
         {
         (void) Wait( 1L << DCRWnd->UserPort->mp_SigBit );

         continue;
         }

      CopyMem( (char *) m, (char *) &DCRMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (DCRMsg.Class) 
         {
         case   IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( DCRWnd );
               DCRRender();
            GT_EndRefresh( DCRWnd, TRUE );
            break;

         case   IDCMP_CLOSEWINDOW:
            running = DCRCloseWindow();
            break;
/*
         case   IDCMP_VANILLAKEY:
            running = DCRVanillaKey( DCRMsg.Code );
            break;
*/
         case   IDCMP_RAWKEY:
            running = DCRRawKey( DCRMsg.Code );
            break;

         case   IDCMP_GADGETUP:
         case   IDCMP_GADGETDOWN:
            func = (int (*)(int)) ((struct Gadget *)DCRMsg.IAddress)->UserData;

            if (func) // != NULL)
               running = func( DCRMsg.Code );

            break;
         }
      }

   return( running );
}

PRIVATE void setupDCRCatalogStrs( void )
{
   strncpy( DCRWdt, CMsgATB( MSG_DCR_WTITLE, MSG_DCR_WTITLE_STR ), 80 );

   DCRIText[ 0 ].IText = CMsgATB( MSG_WARN1, MSG_WARN1_STR );
   DCRIText[ 1 ].IText = CMsgATB( MSG_WARN2, MSG_WARN2_STR );
   DCRIText[ 2 ].IText = CMsgATB( MSG_WARN3, MSG_WARN3_STR );

   DCRNGad[0].ng_GadgetText = CMsgATB( MSG_CLASSES_GAD, MSG_CLASSES_GAD_STR ); // "Classes:"
   DCRNGad[1].ng_GadgetText = CMsgATB( MSG_CANCEL_GAD,  MSG_CANCEL_GAD_STR  ); // " CANCEL! "
   
   // "Remove Class from Browser Memory "
   DCRNGad[2].ng_GadgetText = CMsgATB( MSG_MEMDEL_GAD,  MSG_MEMDEL_GAD_STR  );    
   
   // "Delete Class source file also" 
   DCRNGad[3].ng_GadgetText = CMsgATB( MSG_SRCDEL_GAD,  MSG_SRCDEL_GAD_STR  ); 
   
   // "Class to DELETE:" 
   DCRNGad[4].ng_GadgetText = CMsgATB( MSG_CLSDEL_GAD,  MSG_CLSDEL_GAD_STR  ); 
   
   // "DELETE Selected Class!" 
   DCRNGad[5].ng_GadgetText = CMsgATB( MSG_DELETE_GAD,  MSG_DELETE_GAD_STR  ); 
   
   return;
}

SUBFUNC int setLVIndex( char *className )
{
   int   i      = 0; 
   int   len    = strlen( className );
   char *aClass = &lvm->lvm_NodeStrs[0];
   
   while (*aClass == ' ')
      aClass++; // Skip over any indentations
      
   while (StringNComp( className, aClass, len ) != 0)
      {
      i++;

      aClass = &lvm->lvm_NodeStrs[ i * lvm->lvm_NodeLength ];
      
      while (*aClass == ' ')
         aClass++; // Skip over any indentations

      if (i > lvm->lvm_NumItems)
         return( 0 );
      }
   
   listIndex = i;
      
   return( i );
}

PUBLIC int browserDelReq( char               *className, 
                          struct ListViewMem *classesLVM, 
                          struct List        *classList
                        )
{
   int selection = 0;
   
   setupDCRCatalogStrs();
   
   if (OpenDCRWindow() < 0)
      {
      NotOpened( 1 ); // Window did NOT open!
      
      return( -1 );
      }

   lvm         = classesLVM;
   classesList = classList;
    
   while (*className == ' ')
      className++; // Skip over indentation (if any)

   StringNCopy( selectedClassName, className, 80 );
      
   GT_SetGadgetAttrs( CLASSTEXTGAD, DCRWnd, NULL, 
                      GTTX_Text, (UBYTE *) className, TAG_DONE
                    );

   // Display the classList:   

   ModifyListView( DCRGadgets[ GD_ClassLV ], DCRWnd, classesList, NULL );

   selection = setLVIndex( className );
     
   // Highlight given className:

   GT_SetGadgetAttrs( DCRGadgets[ GD_ClassLV ], DCRWnd, NULL,
                      GTLV_Selected,    selection,
                      GTLV_MakeVisible, selection,
                      TAG_DONE
                    );
      
   SetNotifyWindow( DCRWnd );
      
      (void) HandleDCRIDCMP();
   
      CloseDCRWindow();

   SetNotifyWindow( ATBWnd );
            
   return( DeleteAction );
}

/* ---------------- END of ATalkBrowserDelReq.c file! ------------ */
