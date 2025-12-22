/****h* SysHardware/SysHardware.c ***********************************
*
* NAME
*    SysHardware.c
*
* DESCRIPTION
*    Display some information about the Amiga Hardware found.
*
* NOTES
*    $VER: SysHardware.c 1.0 (12-Feb-2001) by J.T. Steichen
*********************************************************************
*
*/

#include <stdio.h>
#include <string.h>

#include <exec/types.h>
#include <exec/execbase.h>

#include <AmigaDOSErrs.h>

#include <dos/dosextens.h>

#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/gadgetclass.h>

#include <libraries/gadtools.h>
#include <libraries/expansion.h>
#include <libraries/expansionbase.h>

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

#define HLV     0
#define Cancel  1

#define ATS_CNT 2

IMPORT  struct ExecBase *SysBase; // GfxBase in SysLists.h

PRIVATE struct ExpansionBase *ExpansionBase;

PRIVATE char vr[] = "$VER: SysHardware 1.0 (12-Feb-2001) by J.T. Steichen";

PRIVATE struct TextFont *ATSFont  = NULL;
PRIVATE struct Window   *ATSWnd   = NULL;
PRIVATE struct Gadget   *ATSGList = NULL;
PRIVATE struct Gadget   *ATSGadgets[ ATS_CNT ];

PRIVATE struct IntuiMessage  ATSMsg;

PRIVATE UWORD  ATSLeft   = 0;
PRIVATE UWORD  ATSTop    = 16;
PRIVATE UWORD  ATSWidth  = 640;
PRIVATE UWORD  ATSHeight = 270;
PRIVATE UBYTE *ATSWdt    = (UBYTE *) "System Hardware Info:";

PRIVATE UBYTE *ttl = "Brd.Addr: Brd.Size: Mfg-ID: Prod: Driver: Flags:    S/N: DiagVec:  Type:";

PRIVATE char fmt[] = "$%08LX $%08LX %5d %5d   %-3.3s     $%08LX  %d   $%08LX %d";

// ----------------------------------------------------------------------

#define MAXHVNODES 26
#define NODELENGTH 80

PRIVATE struct Node HLVNodes[ MAXHVNODES ] = { 0, };

PRIVATE struct List HLVList = { 0, };

PRIVATE UBYTE NodeStrs[ MAXHVNODES * NODELENGTH ] = ""; 

// ----------------------------------------------------------------------

PRIVATE int HLVClicked(    void );
PRIVATE int CancelClicked( void );

PRIVATE struct NewGadget ATSNGad[] = {

     2,   3, 627, 250,                NULL, NULL, HLV, 
   0, NULL, (APTR) HLVClicked,

   295, 250,  72,  17, (UBYTE *) "_Cancel", NULL, Cancel, 
   PLACETEXT_IN, NULL, (APTR) CancelClicked

};

PRIVATE ULONG ATSGTags[] = {

   GTLV_ReadOnly, TRUE, GTLV_ShowSelected, NULL,
   LAYOUTA_Spacing, 2, TAG_DONE,
   
   GT_Underscore, '_', TAG_DONE
};

PRIVATE UWORD ATSGTypes[] = { LISTVIEW_KIND, BUTTON_KIND };

// ----------------------------------------------------------------------

SUBFUNC char *GetProcType( void )
{
   if ((SysBase->AttnFlags & AFF_68060) == AFF_68060)
      return( "68060" );

   if ((SysBase->AttnFlags & AFF_68040) == AFF_68040)
      return( "68040" );

   if ((SysBase->AttnFlags & AFF_68030) == AFF_68030)
      return( "68030" );

   if ((SysBase->AttnFlags & AFF_68020) == AFF_68020)
      return( "68020" );

   if ((SysBase->AttnFlags & AFF_68010) == AFF_68010)
      return( "68010" );
   else
      return( "68000" );
}

SUBFUNC char *GetFPUType( void )
{
   if ((SysBase->AttnFlags & AFF_FPU40) == AFF_FPU40)
      {
      if ((SysBase->AttnFlags & AFF_68040) == AFF_68040)
         return( "68882 (68040 FPU)" );
      else
         return( "NONE" );
      }

   if ((SysBase->AttnFlags & AFF_68882) == AFF_68882)
      return( "68882" );

   if ((SysBase->AttnFlags & AFF_68881) == AFF_68881)
      return( "68881" );
   else
      return( "NONE" );
}

SUBFUNC char *GetInstCache( void )
{
   IMPORT int GetCacheReg( void );

   ULONG result = Supervisor( (void *) GetCacheReg );

//   fprintf( stderr, "GetCacheReg() returned 0x%08LX\n", result );

   if ((result & 0x00008000) == 0x00008000) // bit 15 of CACR set??
      return( "ON" );
   else
      return( "OFF" );
}

SUBFUNC char *GetDataCache( void )
{
   IMPORT int GetCacheReg( void );

   ULONG result = Supervisor( (void *) GetCacheReg );

//   fprintf( stderr, "GetCacheReg() returned 0x%08LX\n", result );

   if ((result & 0x80000000) == 0x80000000) // bit 31 of CACR set??
      return( "ON" );
   else
      return( "OFF" );
}

SUBFUNC char *GetBurstCache( void )
{
   IMPORT int GetMMUsrReg( void );

   ULONG result = Supervisor( (void *) GetMMUsrReg );

//   fprintf( stderr, "GetMMUsrReg() returned 0x%08LX\n", result );

   if ((result & 0x00000060) == 0x00000040) // burst mode??
      return( "ON" );
   else
      return( "OFF" );
}

SUBFUNC char *GetCopyBackCache( void )
{
   IMPORT int GetMMUsrReg( void );

   ULONG result = Supervisor( (void *) GetMMUsrReg );

//   fprintf( stderr, "GetMMUsrReg() returned 0x%08LX\n", result );

   if ((result & 0x00000060) == 0x00000020) // CopyBack mode??
      return( "ON" );
   else
      return( "OFF" );
}

// Stuff from GfxBase:

SUBFUNC char *GetDMACustomName( void )
{
   if ((GfxBase->ChipRevBits0 & GFXF_AA_ALICE) == GFXF_AA_ALICE)
      return( "Alice" );

   if ((GfxBase->ChipRevBits0 & GFXF_HR_AGNUS) == GFXF_HR_AGNUS)
      return( "Agnus" );
   else
      return( "Agnus" );
}

SUBFUNC char *GetGraphicCustomName( void )
{
   if ((GfxBase->ChipRevBits0 & GFXF_AA_MLISA) == GFXF_AA_MLISA)
      return( "MLisa" );

   if ((GfxBase->ChipRevBits0 & GFXF_AA_LISA) == GFXF_AA_LISA)
      return( "Lisa" );

   if ((GfxBase->ChipRevBits0 & GFXF_HR_DENISE) == GFXF_HR_DENISE)
      return( "Denise" );
   else
      return( "Denise" );
}

SUBFUNC char *GetVideoType( void )
{
   if ((GfxBase->DisplayFlags & NTSC) == NTSC)
      return( "NTSC" );

   if ((GfxBase->DisplayFlags & PAL) == PAL)
      return( "PAL" );

   if ((GfxBase->DisplayFlags & GENLOCK) == GENLOCK)
      return( "GENLOCK" );
   else
      return( "NTSC" );
}

// Version info:

PRIVATE char wbv[24];

SUBFUNC char *GetWorkbenchVersion( void )
{
   struct Library *wbenchbase = NULL;
   
   if ((wbenchbase = OpenLibrary( "workbench.library", 0L )) == NULL)
      return( "Unable to open!" );

   sprintf( wbv, "%d.%d", 
                 wbenchbase->lib_Version, 
                 wbenchbase->lib_Revision 
          );

   CloseLibrary( wbenchbase );

   return( &wbv[0] );
}

PRIVATE char exv[24];

SUBFUNC char *GetExecVersion( void )
{
   sprintf( exv, "%d.%d", SysBase->LibNode.lib_Version,
                          SysBase->LibNode.lib_Revision
          ); 

   return( &exv[0] );
}

PRIVATE char dosv[24];

SUBFUNC char *GetDosVersion( void )
{
   struct DosLibrary *dosbase = NULL; // <dos/dosextens.h>
   
   if ((dosbase = (struct DosLibrary *)
                  OpenLibrary( "dos.library", 0L )) == NULL)
      return( "Unable to open!" );

   sprintf( dosv, "%d.%d", 
                 dosbase->dl_lib.lib_Version, 
                 dosbase->dl_lib.lib_Revision 
          );

   CloseLibrary( (struct Library *) dosbase );

   return( &dosv[0] );
}

SUBFUNC int WriteBoardInfo( void )
{
   struct ConfigDev *cd = NULL;
   int                i = 1;
   
   if ((ExpansionBase = (struct ExpansionBase *) 
                        OpenLibrary( EXPANSIONNAME, 0 )) == NULL)
      {
      printf( "Couldn't open %s!\n", EXPANSIONNAME );
      return( -1 );
      }

   while (((cd = FindConfigDev( cd, -1, -1 )) != 0) && (i < MAXHVNODES))
      {
      sprintf( &NodeStrs[ i * NODELENGTH ], &fmt[0],
               cd->cd_BoardAddr,
               cd->cd_BoardSize,
               cd->cd_Rom.er_Manufacturer,
               cd->cd_Rom.er_Product,
               cd->cd_Driver == 0 ? "NO" : "YES", 
               cd->cd_Rom.er_Flags,
               cd->cd_Rom.er_SerialNumber,
               cd->cd_Rom.er_InitDiagVec,
               cd->cd_Rom.er_Type 
             );

      i++;
      }

   CloseLibrary( (struct Library *) ExpansionBase );

   return( i ); // Other stuff will be added to the nodes.
}

PRIVATE int SetupHardwareLV( void )
{
   int i = WriteBoardInfo();
      
   if (i < 0)
      i = 3;

   if (i >= MAXHVNODES - 12)
      {
      return( 0 );
      }

   i++;

   sprintf( &NodeStrs[ i++ * NODELENGTH ],
            "Processor -----------: %s", GetProcType()   
          );

   sprintf( &NodeStrs[ i++ * NODELENGTH ],
            "Math --- Co-Processor: %s", GetFPUType()    
          );

   sprintf( &NodeStrs[ i++ * NODELENGTH ],
            "CPU Instruction Cache: %s", GetInstCache()  
          );

   sprintf( &NodeStrs[ i++ * NODELENGTH ],
            "CPU Instruction Burst: %s", GetBurstCache() 
          );

   sprintf( &NodeStrs[ i++ * NODELENGTH ],
            "CPU Data ------ Cache: %s", GetDataCache()  
          );

   sprintf( &NodeStrs[ i++ * NODELENGTH ],
            "CPU Data ------ Burst: %s", GetBurstCache() 
          );

   sprintf( &NodeStrs[ i++ * NODELENGTH ],
            "CPU -------- CopyBack: %s", GetCopyBackCache() 
          );

   sprintf( &NodeStrs[ i++ * NODELENGTH ],
            "DMA ----- Custom Chip: %s (%s)", GetDMACustomName(),
                                              GetVideoType()
          );

   sprintf( &NodeStrs[ i++ * NODELENGTH ],
            "Graphic   Custom Chip: %s", GetGraphicCustomName() 
          );

   sprintf( &NodeStrs[ i++ * NODELENGTH ],
            "WorkBench     Version: %s", GetWorkbenchVersion()
          );   

   sprintf( &NodeStrs[ i++ * NODELENGTH ],
            "Exec          Version: %s", GetExecVersion() 
          );

   sprintf( &NodeStrs[ i++ * NODELENGTH ],
            "Dos           Version: %s", GetDosVersion() 
          );   
      
   return( 0 );
}

// ----------------------------------------------------------------------

PRIVATE int OpenATSWindow( void )
{
   struct NewGadget  ng;
   struct Gadget    *g;
   UWORD             lc, tc;
   UWORD             wleft = ATSLeft, wtop = ATSTop, ww, wh;

   ComputeFont( Scr, Font, &CFont, ATSWidth, ATSHeight );

   ww = ComputeX( CFont.FontX, ATSWidth  );
   wh = ComputeY( CFont.FontY, ATSHeight );

   if ((wleft + ww + CFont.OffX + Scr->WBorRight) > Scr->Width)
      wleft = Scr->Width - ww;

   if ((wtop + wh + CFont.OffY + Scr->WBorBottom) > Scr->Height)
      wtop = Scr->Height - wh;

   if ((ATSFont = OpenDiskFont( Font )) == NULL)
      return( -5 );

   if ((g = CreateContext( &ATSGList )) == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < ATS_CNT; lc++)
      {
      CopyMem( (char *) &ATSNGad[lc], (char *) &ng, 
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

      ATSGadgets[lc] = g 
                     = CreateGadgetA( (ULONG) ATSGTypes[lc], 
                                      g, 
                                      &ng, 
                                      (struct TagItem *) &ATSGTags[tc]
                                    );

      while (ATSGTags[tc] != TAG_DONE)
         tc += 2;

      tc++;

      if (g == NULL)
         return( -2 );
      }

   if ((ATSWnd = OpenWindowTags( NULL,

                  WA_Left,        wleft,
                  WA_Top,         wtop,
                  WA_Width,       ww + CFont.OffX + Scr->WBorRight,
                  WA_Height,      wh + CFont.OffY + Scr->WBorBottom,
                  
                  WA_IDCMP,       LISTVIEWIDCMP | BUTTONIDCMP 
                    | IDCMP_CLOSEWINDOW | IDCMP_REFRESHWINDOW 
                    | IDCMP_VANILLAKEY,
                  
                  WA_Flags,       WFLG_DRAGBAR | WFLG_DEPTHGADGET 
                    | WFLG_CLOSEGADGET | WFLG_SMART_REFRESH 
                    | WFLG_ACTIVATE | WFLG_RMBTRAP,
                  
                  WA_Gadgets,     ATSGList,
                  WA_Title,       ATSWdt,
                  WA_ScreenTitle, "System Hardware Info:",
                  TAG_DONE )
      ) == NULL)
      return( -4 );

   GT_RefreshWindow( ATSWnd, NULL );

   return( 0 );
}

PRIVATE void CloseATSWindow( void )
{
   if (ATSWnd != NULL)
      {
      CloseWindow( ATSWnd );
      ATSWnd = NULL;
      }

   if (ATSGList != NULL)
      {
      FreeGadgets( ATSGList );
      ATSGList = NULL;
      }

   if (ATSFont != NULL)
      {
      CloseFont( ATSFont );
      ATSFont = NULL;
      }

   return;
}

PRIVATE int ATSCloseWindow( void )
{
   CloseATSWindow();
   return( FALSE );
}

PRIVATE int HLVClicked( void )
{
   // Nothing to do here:
   return( TRUE );
}

PRIVATE int CancelClicked( void )
{
   return( ATSCloseWindow() );
}

PRIVATE int ATSVanillaKey( int whichkey )
{
   int rval = TRUE;
   
   switch (whichkey)
      {
      case 'c':
      case 'C':
         rval = CancelClicked();
         break;
         
      case 'q':
      case 'Q':
      case 'x':
      case 'X':
         rval = FALSE;
         break;
      }
      
   return( rval );
}

PRIVATE int HandleATSIDCMP( void )
{
   struct IntuiMessage  *m;
   int                 (*func)( void );
   BOOL                  running = TRUE;

   while (running == TRUE)
      {
      if ((m = GT_GetIMsg( ATSWnd->UserPort )) == NULL)
         {
         (void) Wait( 1L << ATSWnd->UserPort->mp_SigBit );
         continue;
         }

      CopyMem( (char *) m, (char *) &ATSMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (ATSMsg.Class)
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( ATSWnd );
            GT_EndRefresh( ATSWnd, TRUE );
            break;

         case IDCMP_CLOSEWINDOW:
            running = ATSCloseWindow();
            break;

         case IDCMP_VANILLAKEY:
            running = ATSVanillaKey( ATSMsg.Code );
            break;

         case IDCMP_GADGETUP:
         case IDCMP_GADGETDOWN:
            func = (void *) ((struct Gadget *) ATSMsg.IAddress)->UserData;
            
            if (func != NULL)
               running = func();

            break;
         }
      }

   return( running );
}

PRIVATE int HandleHardware( void )
{
   struct Node ttlNode = { 0, };
   int               i = 0;
    
   ttlNode.ln_Succ = (struct Node *) HLVList.lh_Tail;
   ttlNode.ln_Pred = (struct Node *) HLVList.lh_Head;
   ttlNode.ln_Type = 0;
   ttlNode.ln_Pri  = 127;
   ttlNode.ln_Name = &ttl[0];

   HLVNodes[0] = ttlNode;

   // Open Libraries, Screen & Window:
   if (SetupSystemList( &OpenATSWindow ) < 0)
      {
      fprintf( stderr, "Couldn't open a System ListViewer!\n" );
      return( -1 );
      }
   
   SetNotifyWindow( ATSWnd );

   for (i = 1; i <= MAXHVNODES; i++)
      {
      HLVNodes[i].ln_Name = &NodeStrs[ i * NODELENGTH ];
      HLVNodes[i].ln_Pri  = 127 - i;
      }

   NewList( &HLVList );      

   for (i = 0; i < MAXHVNODES; i++)
      Enqueue( &HLVList, &HLVNodes[ i ] );

   HideListFromView( ATSGadgets[ HLV ], ATSWnd );

   (void) SetupHardwareLV(); // Make the list.

   ModifyListView( ATSGadgets[ HLV ], ATSWnd, 
                   (struct List *) &HLVList, NULL
                 );

   GT_RefreshWindow( ATSWnd, NULL );

   (void) HandleATSIDCMP();
   
   // Close Libraries, Screen & Window:
   ShutdownSystemList();

   return( 0 );
}

PUBLIC int ShowHardware( void )
{
   int rval = 0;

   rval = HandleHardware();
   
   return( rval );
}

#ifdef DEBUG

PUBLIC int main( void )
{
   return( ShowHardware() );
}

#endif

/* -------------------- END of SysHardware.c file! ------------------ */
