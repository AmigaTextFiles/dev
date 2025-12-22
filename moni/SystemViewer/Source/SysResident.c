/****h* SystemViewer/SysResident.c [1.0] ********************************
*
* NAME
*    SysResident.c
*
* DESCRIPTION
*    Show the user a GUI of the system-resident programs.
*
* NOTES
*    GUI Designed by : Jim Steichen
*************************************************************************
*
*/

#include <string.h>

#include <exec/types.h>
#include <exec/execbase.h>
#include <exec/resident.h>

#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/gadgetclass.h>

#include <libraries/gadtools.h>

#include <graphics/displayinfo.h>
#include <graphics/gfxbase.h>

#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/graphics_protos.h>
#include <clib/utility_protos.h>
#include <clib/diskfont_protos.h>

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "SysLists.h"

#define SLV       0
#define Update    1
#define AddBt     2
#define RemoveBt  3
#define ReplaceBt 4
#define Cancel    5

#define SLVGADGET SRGadgets[ SLV ]

#define SR_CNT    6

IMPORT struct ExecBase *SysBase;

// -------------------------------------------------------------------

PRIVATE char vr[] = "$VER: SysResident 1.0 (15-Feb-2001) by J.T. Steichen";

// -------------------------------------------------------------------

PRIVATE struct TextFont     *SRFont  = NULL;
PRIVATE struct Window       *SRWnd   = NULL;
PRIVATE struct Gadget       *SRGList = NULL;
PRIVATE struct IntuiMessage  SRMsg;
PRIVATE struct Gadget       *SRGadgets[ SR_CNT ];

PRIVATE UWORD  SRLeft   = 0;
PRIVATE UWORD  SRTop    = 16;
PRIVATE UWORD  SRWidth  = 632;
PRIVATE UWORD  SRHeight = 228;
PRIVATE UBYTE *SRWdt    = (UBYTE *) "System Residents Info:";

PRIVATE UBYTE *ttl = "Address  Type     Pri   Ver  Flags     Name";
PRIVATE UBYTE *fmt = "%08LX %-8.8s %4d %3d   %08LX  %-32.32s";

PRIVATE ULONG Residents = 0L; // SysBase->ResModules.

// -------------------------------------------------------------------

#define NODELENGTH 80

PRIVATE struct List         SRList     = { 0, };
PRIVATE struct Node        *SRNodes    = NULL;
PRIVATE struct ListViewMem *Reslvm     = NULL; //{ 0, 0, 0, NODELENGTH };

PRIVATE UBYTE              *NodeStrs   = NULL;

// -------------------------------------------------------------------

PRIVATE UWORD SRGTypes[] = {

   LISTVIEW_KIND, BUTTON_KIND, BUTTON_KIND,
   BUTTON_KIND,   BUTTON_KIND, BUTTON_KIND,
};

PRIVATE int SLVClicked(       int whichitem );
PRIVATE int UpdateClicked(    int dummy     );
PRIVATE int CancelClicked(    int dummy     );
PRIVATE int AddBtClicked(     int dummy     );
PRIVATE int RemoveBtClicked(  int dummy     );
PRIVATE int ReplaceBtClicked( int dummy     );

PRIVATE struct NewGadget SRNGad[] = {

     2,   3, 627, 200,                NULL, NULL, SLV,               0, 
   NULL, (APTR) SLVClicked,

     4, 205,  72,  17, (UBYTE *) "_Update", NULL, Update, PLACETEXT_IN, 
   NULL, (APTR) UpdateClicked,

    80, 205,  72,  17, (UBYTE *) "Add", NULL, AddBt, PLACETEXT_IN, 
   NULL, (APTR) AddBtClicked,

   155, 205,  72,  17, (UBYTE *) "Remove", NULL, RemoveBt, PLACETEXT_IN, 
   NULL, (APTR) RemoveBtClicked,

   230, 205,  72,  17, (UBYTE *) "Replace", NULL, ReplaceBt, PLACETEXT_IN, 
   NULL, (APTR) ReplaceBtClicked,

   554, 205,  72,  17, (UBYTE *) "_Cancel", NULL, Cancel, PLACETEXT_IN, 
   NULL, (APTR) CancelClicked
};

PRIVATE ULONG SRGTags[] = {

//   GTLV_ReadOnly,     TRUE, 
   GTLV_ShowSelected, NULL, GTLV_Selected, 1,
   LAYOUTA_Spacing,   2, 
   TAG_DONE,
   
   GT_Underscore, '_', TAG_DONE,
   TAG_DONE,
   TAG_DONE,
   TAG_DONE,
   GT_Underscore, '_', TAG_DONE
};

// -------------------------------------------------------------------

PRIVATE void SetupLV( struct List *list, struct ListViewMem *lvm )
{
   int i, length = lvm->lvm_NodeLength;
   
   lvm->lvm_Nodes[0].ln_Succ = (struct Node *) list->lh_Tail;
   lvm->lvm_Nodes[0].ln_Pred = (struct Node *) list->lh_Head;
   lvm->lvm_Nodes[0].ln_Type = 0;
   lvm->lvm_Nodes[0].ln_Pri  = lvm->lvm_NumItems - 129;
   lvm->lvm_Nodes[0].ln_Name = ttl;

   for (i = 1; i <= lvm->lvm_NumItems; i++)
      {
      lvm->lvm_Nodes[i].ln_Name = &lvm->lvm_NodeStrs[ i * length ];
      lvm->lvm_Nodes[i].ln_Pri  = lvm->lvm_NumItems - i - 129;
      }

   NewList( (struct List *) list );      

   for (i = 0; i < lvm->lvm_NumItems; i++)
      Enqueue( (struct List *) list, &lvm->lvm_Nodes[ i ] );

   return;
}

PRIVATE int InitializeLV( int numitems )
{
   if ((Reslvm = Guarded_AllocLV( numitems, NODELENGTH )) == NULL)
      {
      ReportAllocLVError();

      return( -1 );
      }

   NodeStrs = Reslvm->lvm_NodeStrs;
   SRNodes  = Reslvm->lvm_Nodes;

   SetupLV( &SRList, Reslvm );

   return( 0 );
}

PRIVATE int CountResidents( void )
{
   char **pointer = 0L;
   int    rval    = 0;
   
   Forbid();
   
      if (Residents == NULL)
         Residents = (ULONG *) SysBase->ResModules;
      
      pointer = (char **) Residents;

      while (*pointer != NULL) // pointer->rt_Name != NULL???? 
         {
         pointer++;
         rval++;
         }      
   
   Permit();
   
   return( rval + 2 ); // add some padding.
}

PRIVATE char nt[10] = "", *nodeType = &nt[0];

PRIVATE char *GetType( UBYTE nodetype )
{
   switch (nodetype)
      {
      case NT_LIBRARY:
         strcpy( nodeType, "Library" );
         break;

      case NT_RESOURCE:
         strcpy( nodeType, "Resource" );
         break;

      case NT_DEVICE:
         strcpy( nodeType, "Device" );
         break;

      case NT_TASK:
         strcpy( nodeType, "Task" );
         break;

      default:
         strcpy( nodeType, "Unknown" );
         break;
      }
      
   return( nodeType );
}

PRIVATE void MakeResidentList( void )
{
   char **resident = 0L;
   int    i;

   DisplayTitle( SRWnd, "Making list of Residents..." );
   
   HideListFromView( SLVGADGET, SRWnd );

   Forbid();
      resident = (char **) SysBase->ResModules;
      
      for (i = 1; (*resident != NULL) && (i <= Reslvm->lvm_NumItems); i++)
         {
         //"Address  Type     Pri  Ver  Flags     Name"
         sprintf( &NodeStrs[ i * NODELENGTH ], fmt,
                  *resident, 

                  GetType( ((struct Resident *) *resident)->rt_Type ), 

                  ((struct Resident *) *resident)->rt_Pri,
                  ((struct Resident *) *resident)->rt_Version,
                  ((struct Resident *) *resident)->rt_Flags,
                  ((struct Resident *) *resident)->rt_Name
                );
      
         resident++;
         }

   Permit();

   ModifyListView( SLVGADGET, SRWnd, &SRList, NULL );

   DisplayTitle( SRWnd, SRWdt );

   return;
}

// -------------------------------------------------------------------

PRIVATE BOOL  ResSelected  = FALSE;
PRIVATE ULONG SelectedAddr = 0L;

PRIVATE int SLVClicked( int whichitem )
{
   if (whichitem == 0)
      {
      ResSelected = FALSE;
      return( TRUE );  // Dopey User selected the column titles!
      }
   else
      {
      char t[256];
      long addr = 0L;
      
      strcpy( t, &Reslvm->lvm_NodeStrs[ whichitem * NODELENGTH ] );
      
      (void) stch_l( t, &addr );
      
      sprintf( &t[0], "%s - you selected: 0x%08LX", SRWdt, addr );

      DisplayTitle( SRWnd, &t[0] );

      ResSelected  = TRUE;
      SelectedAddr = (ULONG) addr;
      }

   return( TRUE );
}

PRIVATE void CloseSRWindow( void );

PRIVATE int UpdateClicked( int dummy )
{
   int count = CountResidents();
   
   if (count > Reslvm->lvm_NumItems)
      {
      // Deallocate old memory & reallocate for count variable:
      Guarded_FreeLV( Reslvm );

      if (InitializeLV( count ) < 0)
         {
         sprintf( ErrMsg, "Couldn't get more memory for:\n"
                          "   SysResidents Requester!" 
                );

         UserInfo( ErrMsg, "Allocation Problem:" );
  
         CloseSRWindow();

         return( FALSE );
         }
      }
      
   MakeResidentList();
   
   return( TRUE );
}

PRIVATE int AddBtClicked( int dummy )
{
   // Show the user a string requester:   

   return( TRUE );
}

PRIVATE int RemoveBtClicked( int dummy )
{
   if (ResSelected == FALSE)
      {
      strcpy( ErrMsg, "Select a Resident to remove first!" );

      UserInfo( ErrMsg, "User ERROR:" );
      return( TRUE );
      }
   else
      {
//      char cmd[256];
//      int  ans = 0;
       
      // Give the user a last chance to bail out:
      
//      ans = Handle_Problem();
                   
//      ((struct Resident *) SelectedAddr)->rt_Name
      }
}

PRIVATE int ReplaceBtClicked( int dummy )
{
   // Show the user a string requester:   
   
   return( TRUE );
}

// -------------------------------------------------------------------

PRIVATE void CloseSRWindow( void )
{
   if (SRWnd != NULL)
      {
      CloseWindow( SRWnd );
      SRWnd = NULL;
      }

   if (SRGList != NULL)
      {
      FreeGadgets( SRGList );
      SRGList = NULL;
      }

   if (SRFont != NULL)
      {
      CloseFont( SRFont );
      SRFont = NULL;
      }

   return;
}

PRIVATE int SRCloseWindow( void )
{
   CloseSRWindow();
   return( FALSE );
}

PRIVATE int CancelClicked( int dummy )
{
   return( SRCloseWindow() );
}

// -------------------------------------------------------------------

PRIVATE int OpenSRWindow( void )
{
   struct NewGadget  ng;
   struct Gadget    *g;
   UWORD             lc, tc;
   UWORD             wleft = SRLeft, wtop = SRTop, ww, wh;

   ComputeFont( Scr, Font, &CFont, SRWidth, SRHeight );

   ww = ComputeX( CFont.FontX, SRWidth );
   wh = ComputeY( CFont.FontY, SRHeight );

   if ((wleft + ww + CFont.OffX + Scr->WBorRight) > Scr->Width)
      wleft = Scr->Width - ww;

   if ((wtop + wh + CFont.OffY + Scr->WBorBottom) > Scr->Height)
      wtop = Scr->Height - wh;

   if ((SRFont = OpenDiskFont( Font )) == NULL)
      return( -5 );

   if ((g = CreateContext( &SRGList )) == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < SR_CNT; lc++)
      {
      CopyMem( (char *) &SRNGad[lc], (char *) &ng, 
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
      ng.ng_Height     = ComputeY( CFont.FontY, ng.ng_Height );

      SRGadgets[lc] = g 
                    = CreateGadgetA( (ULONG) SRGTypes[lc], 
                                     g, 
                                     &ng, 
                                     (struct TagItem *) &SRGTags[tc]
                                   );

      while (SRGTags[tc] != TAG_DONE)
         tc += 2;

      tc++;

      if (g == NULL)
         return( -2 );
      }

   if ((SRWnd = OpenWindowTags( NULL,

                  WA_Left,    wleft,
                  WA_Top,     wtop,
                  WA_Width,   ww + CFont.OffX + Scr->WBorRight,
                  WA_Height,  wh + CFont.OffY + Scr->WBorBottom,
                  
                  WA_IDCMP,   LISTVIEWIDCMP | BUTTONIDCMP 
                    | IDCMP_CLOSEWINDOW | IDCMP_REFRESHWINDOW 
                    | IDCMP_VANILLAKEY,
                  
                  WA_Flags,   WFLG_DRAGBAR | WFLG_DEPTHGADGET 
                    | WFLG_CLOSEGADGET | WFLG_SMART_REFRESH 
                    | WFLG_ACTIVATE | WFLG_RMBTRAP,

                  WA_Gadgets, SRGList,
                  WA_Title,   SRWdt,
                  TAG_DONE )
      ) == NULL)
      return( -4 );

   GT_RefreshWindow( SRWnd, NULL );

   return( 0 );
}

PRIVATE int SRVanillaKey( int whichkey )
{
   int rval = TRUE;
   
   switch (whichkey)
      {
      case 'c':
      case 'C':
      case 'q':
      case 'Q':
      case 'x':
      case 'X':
         rval = CancelClicked( 0 );
         break;
         
      case 'u':
      case 'U':
         rval = UpdateClicked( 0 );
         break;
      }
      
   return( rval );
}

PRIVATE int HandleSRIDCMP( void )
{
   struct IntuiMessage  *m;
   int                 (*func)( int code );
   BOOL                  running = TRUE;

   while (running == TRUE)
      {
      if ((m = GT_GetIMsg( SRWnd->UserPort )) == NULL)
         {
         (void) Wait( 1L << SRWnd->UserPort->mp_SigBit );
         continue;
         }

      CopyMem( (char *) m, (char *) &SRMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (SRMsg.Class)
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( SRWnd );
            GT_EndRefresh( SRWnd, TRUE );
            break;

         case IDCMP_CLOSEWINDOW:
            running = SRCloseWindow();
            break;

         case IDCMP_VANILLAKEY:
            running = SRVanillaKey( SRMsg.Code );
            break;
            
         case IDCMP_GADGETUP:
         case IDCMP_GADGETDOWN:
            func = (void *) ((struct Gadget *) SRMsg.IAddress)->UserData;
            
            if (func != NULL)
               running = func( SRMsg.Code );
            break;
         }
      }

   return( running );
}

PUBLIC int SystemResidents( void )
{
   int numitems = 0;

   if (SetupSystemList( &OpenSRWindow ) < 0)
      {
      fprintf( stderr, "Couldn't open a System ListViewer!\n" );
      return( RETURN_FAIL );
      }

   SetNotifyWindow( SRWnd );
         
   Forbid();
      Residents = SysBase->ResModules;
   Permit();

   numitems = CountResidents();

   if (InitializeLV( numitems ) < 0)
      {
      sprintf( ErrMsg, "Couldn't get memory for:\n"
                       "   SysResidents Requester!" 
             );

      UserInfo( ErrMsg, "Allocation Problem:" );

      CloseSRWindow();

      return( RETURN_FAIL );
      }

   MakeResidentList();
      
   GT_RefreshWindow( SRWnd, NULL );

   (void) HandleSRIDCMP();

   Guarded_FreeLV( Reslvm );

   CloseSRWindow();         // Just in case.   

   ShutdownSystemList();
      
   return( RETURN_OK );
}

#ifdef DEBUG

PUBLIC int main( void )
{
   return( SystemResidents() );
}

#endif

/* ----------------- END of SysResident.c file! ------------------------ */
