/****h* AmigaTalk/Tracer2.c [3.0] *************************************
*
* NAME
*    Tracer2.c
*
* DESCRIPTION
*
* NOTES
*    GUI Designed by : Jim Steichen
***********************************************************************
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

#else

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/intuition.h>
# include <proto/graphics.h>
# include <proto/gadtools.h>
# include <proto/diskfont.h>
# include <proto/utility.h>

IMPORT struct Library *IntuitionBase;
IMPORT struct IntuitionIFace *IIntuition;
#endif


#include "ATStructs.h"
#include "Constants.h"

#include "FuncProtos.h"

#include "StringConstants.h"
#include "StringIndexes.h"

#include "CPGM:GlobalObjects/CommonFuncs.h"

#ifndef  StrBfPtr
# define StrBfPtr( g ) (((struct StringInfo *)g->SpecialInfo)->Buffer)
#endif

#define ClassTxt    0
#define RefCountTxt 1
#define SizeNum     2
#define ClassBt     3
#define SuperBt     4
#define IVarLV      5

#define Tr2_CNT     6

#define CLASSNAMEGAD Tr2Gadgets[ ClassTxt ]
#define REFCOUNTGAD  Tr2Gadgets[ RefCountTxt ]
#define SIZENUMGAD   Tr2Gadgets[ SizeNum ]
#define IVARLVGAD    Tr2Gadgets[ IVarLV ]

IMPORT struct Library  *GadToolsBase;
IMPORT struct Screen   *Scr;
IMPORT struct TextAttr *Font;
IMPORT struct CompFont  CFont;
IMPORT APTR             VisualInfo;

IMPORT UBYTE *ErrMsg;

IMPORT char  *symbol_value( SYMBOL * );

// ----------------------------------------------------------------------

PRIVATE struct TextFont     *Tr2Font  = NULL;
PRIVATE struct Window       *Tr2Wnd   = NULL;
PRIVATE struct Gadget       *Tr2GList = NULL;
PRIVATE struct IntuiMessage  Tr2Msg;
PRIVATE struct Gadget       *Tr2Gadgets[ Tr2_CNT ] = { NULL, };

PRIVATE UWORD  Tr2Left   = 110;
PRIVATE UWORD  Tr2Top    = 16;
PRIVATE UWORD  Tr2Width  = 370;
PRIVATE UWORD  Tr2Height = 390;

PUBLIC  UBYTE *Tr2Wdt    = NULL; // Visible to CatalogTracer2();

PRIVATE struct Window *ParentWnd = NULL;

// ----------------------------------------------------------------------

#define TXTLENGTH    32

PRIVATE struct List  IVarLVList   = { 0, };

PRIVATE struct Node *IVarLVNodes  = NULL;

PRIVATE UBYTE       *NodeStrs     = NULL;

PRIVATE struct ListViewMem *LVMem = NULL;

// ----------------------------------------------------------------------

PRIVATE UWORD Tr2GTypes[ Tr2_CNT ] = {

   TEXT_KIND,   TEXT_KIND,   NUMBER_KIND,
   BUTTON_KIND, BUTTON_KIND, LISTVIEW_KIND
};

PRIVATE int ClassBtClicked( int dummy     );
PRIVATE int SuperBtClicked( int dummy     );
PRIVATE int IVarLVClicked(  int whichitem );

PUBLIC struct NewGadget Tr2NGad[ Tr2_CNT ] = { // Visible to CatalogTracer2();

    88,  4, 151,  18, NULL, NULL, ClassTxt, 
   PLACETEXT_LEFT, NULL, NULL,
   
    88, 26, 151,  18, NULL, NULL, RefCountTxt, 
   PLACETEXT_LEFT, NULL, NULL,
   
   283, 26,  81,  18, NULL, NULL, SizeNum, 
   PLACETEXT_LEFT, NULL, NULL,
   
     4, 50, 160,  18, NULL, NULL, ClassBt, 
   PLACETEXT_IN, NULL, (APTR) ClassBtClicked,

   204, 50, 160,  18, NULL, NULL, SuperBt, 
   PLACETEXT_IN, NULL, (APTR) SuperBtClicked,

     4, 90, 360, 295, NULL, NULL, IVarLV, 
   PLACETEXT_ABOVE|NG_HIGHLABEL, NULL, (APTR) IVarLVClicked
};

PRIVATE ULONG Tr2GTags[] = {

   (TAG_DONE), // No Borders this time.
   (TAG_DONE),
   (TAG_DONE),

   (GT_Underscore), UNDERSCORE_CHAR, (TAG_DONE),
   (GT_Underscore), UNDERSCORE_CHAR, (TAG_DONE),

   GTLV_ShowSelected, 0L, 
   GTLV_Selected,     0,
   LAYOUTA_Spacing,   2, 
   TAG_DONE
};

// --------------------------------------------------------------------

#define GOT_ADDRESS TRUE + 1

PRIVATE ULONG ReturnAddress = 0L;
PRIVATE ULONG ClassAddress  = 0L;
PRIVATE ULONG SuperAddress  = 0L;

PRIVATE int ClassBtClicked( int dummy )
{
   ReturnAddress = ClassAddress;

   return( GOT_ADDRESS );
}

PRIVATE int SuperBtClicked( int dummy )
{
   ReturnAddress = SuperAddress;
   
   return( GOT_ADDRESS );
}

PRIVATE int IVarLVClicked( int whichitem )
{
   char bf[24] = { 0, }, *addr = &bf[0];
   
   int rval = 0;
   
   StringNCopy( addr, &NodeStrs[ whichitem * TXTLENGTH ], 10 );

#  ifdef  __SASC
   (void) stch_l( addr, (long *) &rval );
#  else
   (void) hexStrToLong( addr, (long *) &rval );
#  endif
   
   ReturnAddress = (ULONG) rval;
   
   return( GOT_ADDRESS );
}

PRIVATE int OpenTr2Window( void )
{
   struct NewGadget  ng;
   struct Gadget    *g;
   UWORD             lc, tc;
   UWORD             wleft = Tr2Left, wtop = Tr2Top, ww, wh;

   ComputeFont( Scr, Font, &CFont, Tr2Width, Tr2Height );

   ww = ComputeX( CFont.FontX, Tr2Width );
   wh = ComputeY( CFont.FontY, Tr2Height );

   if ((wleft + ww + CFont.OffX + Scr->WBorRight) > Scr->Width) 
      wleft = Scr->Width - ww;
   
   if ((wtop + wh + CFont.OffY + Scr->WBorBottom) > Scr->Height) 
      wtop = Scr->Height - wh;

   if (!(Tr2Font = OpenDiskFont( Font ))) // == NULL)
      return( -5 );

   if (!(g = CreateContext( &Tr2GList ))) // == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < Tr2_CNT; lc++) 
      {
      CopyMem( (char *) &Tr2NGad[ lc ], (char *) &ng, 
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

      Tr2Gadgets[ lc ] = g 
                       = CreateGadgetA( (ULONG) Tr2GTypes[ lc ], 
                                        g, 
                                        &ng, 
                                        (struct TagItem *) &Tr2GTags[ tc ]
                                      );

      while (Tr2GTags[ tc ] != TAG_DONE) 
         tc += 2;
      
      tc++;

      if (!g) // == NULL)
         return( -2 );
      }

   if (!(Tr2Wnd = OpenWindowTags( NULL,

            WA_Left,         wleft,
            WA_Top,          wtop,
            WA_Width,        ww + CFont.OffX + Scr->WBorRight,
            WA_Height,       wh + CFont.OffY + Scr->WBorBottom,
            
            WA_IDCMP,        TEXTIDCMP | NUMBERIDCMP | BUTTONIDCMP 
              | LISTVIEWIDCMP | IDCMP_CLOSEWINDOW | IDCMP_VANILLAKEY
              | IDCMP_REFRESHWINDOW,
            
            WA_Flags,        WFLG_DRAGBAR | WFLG_DEPTHGADGET 
              | WFLG_CLOSEGADGET | WFLG_SMART_REFRESH | WFLG_ACTIVATE
              | WFLG_RMBTRAP,
            
            WA_Gadgets,      Tr2GList,
            WA_Title,        Tr2Wdt,
            WA_CustomScreen, Scr,
            TAG_DONE )
       
       )) // == NULL)
       return( -4 );

   GT_RefreshWindow( Tr2Wnd, NULL );

   return( 0 );
}

PRIVATE void CloseTr2Window( void )
{
   if (Tr2Wnd) // != NULL) 
      {
      CloseWindow( Tr2Wnd );
      Tr2Wnd = NULL;
      }

   if (Tr2GList) // != NULL) 
      {
      FreeGadgets( Tr2GList );
      Tr2GList = NULL;
      }

   if (Tr2Font) // != NULL) 
      {
      CloseFont( Tr2Font );
      Tr2Font = NULL;
      }

   return;
}

PRIVATE int Tr2CloseWindow( void )
{
   CloseTr2Window();

   return( FALSE );
}

PRIVATE int Tr2VanillaKey( int whichkey )
{
   int rval = TRUE;
   
   switch (whichkey)
      {
      case CAP_C_CHAR:
      case SMALL_C_CHAR: 
         rval = ClassBtClicked( 0 );
         break;

      case CAP_S_CHAR:
      case SMALL_S_CHAR: 
         rval = SuperBtClicked( 0 );
         break;
         
      case CAP_Q_CHAR:
      case SMALL_Q_CHAR:
      case CAP_X_CHAR:
      case SMALL_X_CHAR:
         rval = FALSE;
         break;
      }
      
   return( rval );
}

PRIVATE int HandleTr2IDCMP( void )
{
   struct IntuiMessage *m;
   int                (*func)( int Code );
   BOOL                 running = TRUE;

   while (running == TRUE)
      {
      if (!(m = GT_GetIMsg( Tr2Wnd->UserPort ))) // == NULL) 
         {
         (void) Wait( 1L << Tr2Wnd->UserPort->mp_SigBit );

         continue;
         }

      CopyMem( (char *) m, (char *) &Tr2Msg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (Tr2Msg.Class) 
         {
         case   IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( Tr2Wnd );
            GT_EndRefresh( Tr2Wnd, TRUE );
            break;

         case   IDCMP_CLOSEWINDOW:
            running = Tr2CloseWindow();
            break;

         case   IDCMP_VANILLAKEY:
            running = Tr2VanillaKey( Tr2Msg.Code );
            break;

         case   IDCMP_GADGETUP:
         case   IDCMP_GADGETDOWN:
            func = (int (*)( int )) ((struct Gadget *)Tr2Msg.IAddress)->UserData;
            
            if (func) // != NULL)
               running = func( Tr2Msg.Code );

            break;
         }
      }

   return( running );
}

// --------------------------------------------------------------------

PRIVATE int InitializeLV( int numitems )
{
   Guarded_FreeLV( LVMem );

   if (!(LVMem = Guarded_AllocLV( numitems, TXTLENGTH ))) // == NULL)
      {
      ReportAllocLVError();

      return( -1 );
      }

   NodeStrs    = LVMem->lvm_NodeStrs;
   IVarLVNodes = LVMem->lvm_Nodes;

   SetupList( &IVarLVList, LVMem );

   return( 0 );
}

PRIVATE void FillInstanceItems( OBJECT *addr, int numitems )
{
   int i;
   
   for (i = 0; i < numitems; i++)
      {
      sprintf( &NodeStrs[ i * TXTLENGTH ],
                TraceCMsg( MSG_INSTANCE_STR_TRACE ),
                addr->inst_var[i], i 
          );
      }

   ModifyListView( IVARLVGAD, Tr2Wnd, &IVarLVList, NULL );

   return;
}

// --------------------------------------------------------------------

PUBLIC ULONG DisplayLargeArray( OBJECT *addr, struct Window *parent )
{
   SYMBOL *classsym = NULL;

   UBYTE   cg[32] = { 0, }, *ClassGadStr = &cg[0];
   UBYTE   sg[32] = { 0, }, *SuperGadStr = &sg[0];

   ULONG rval     = 0L;   
   int   numitems = objSize( addr );
   

   ParentWnd     = parent;
   ReturnAddress = 0L;           // Changed via Gadget Selection.
   ClassAddress  = (ULONG) addr->Class;
   SuperAddress  = (ULONG) addr->super_obj;

   if (addr->Class) // != NULL)
      classsym = (SYMBOL *) (((CLASS *) addr->Class)->class_name);

   sprintf( ClassGadStr, TraceCMsg( MSG_CLASSGAD_STRING_TRACE ), 
                          addr->Class
          );
   
   sprintf( SuperGadStr, TraceCMsg( MSG_SUPERGAD_STRING_TRACE ),
                          addr->super_obj
          );

   Tr2NGad[ ClassBt ].ng_GadgetText = ClassGadStr;
   Tr2NGad[ SuperBt ].ng_GadgetText = SuperGadStr;


   if (!Tr2Wnd) // == NULL) // Make sure Tr2Wnd is only opened once!
      {
      if (OpenTr2Window() < 0)
         {
         NotOpened( 1 ); //TraceCMsg( MSG_DISP_LARGEARRAY_REQ_STR_TRACE ) );

         return( rval );
         }
      }

   SetNotifyWindow( Tr2Wnd );

   if (InitializeLV( numitems ) < 0)
      {
      MemoryOut( TraceCMsg( MSG_DISP_LARGEARRAY_REQ_STR_TRACE ) ); 

      CloseTr2Window();

      return( rval );
      }

   if (classsym) // != NULL)
      StringCopy( ErrMsg, symbol_value( classsym ) );
   else
      StringCopy( ErrMsg, TraceCMsg( MSG_NO_NAME_TRACE ) );
      
   GT_SetGadgetAttrs( CLASSNAMEGAD, Tr2Wnd, NULL,
                      GTTX_Text, (STRPTR) ErrMsg, TAG_DONE 
                    );

   sprintf( ErrMsg, "%d", addr->ref_count );

   GT_SetGadgetAttrs( REFCOUNTGAD, Tr2Wnd, NULL,
                      GTTX_Text, (STRPTR) ErrMsg, 
                      GTTX_Justification, GTJ_LEFT,
                      TAG_DONE 
                    );

   GT_SetGadgetAttrs( SIZENUMGAD, Tr2Wnd, NULL,
                      GTNM_Number, objSize( addr ), 
                      GTNM_Justification, GTJ_LEFT,
                      TAG_DONE
                    );

   FillInstanceItems( addr, numitems ); // Fill in the ListView strings.

   if (HandleTr2IDCMP() == GOT_ADDRESS)
      rval = ReturnAddress;
   // else the User clicked on the Window Close Gadget.
   
   Guarded_FreeLV( LVMem );

   CloseTr2Window(); // Has to be done!
   
   SetNotifyWindow( parent );

   return( rval );
}

/* ------------------- END of Tracer2.c file! ------------------- */
