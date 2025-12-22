/****h *SysTemViewer/SystemViewer.c *************************************
**
** NAME
**    SystemViewer
**
** DESCRIPTION
**    The main GUI for various System Information Displayers & 
**    Requesters.
**
**  GUI Designed by : Jim Steichen
*************************************************************************
*/

#include <string.h>

#include <exec/types.h>

#include <AmigaDOSErrs.h>

#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/gadgetclass.h>

#include <workbench/workbench.h>
#include <workbench/startup.h>
#include <workbench/icon.h>

#include <dos/dostags.h> // for SYS_Asynch, etc.

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

#define AssignBt     0
#define LockBt       1
#define MountBt      2
#define MemoryBt     3
#define ScreenBt     4
#define TaskBt       5
#define VectorBt     6
#define DeviceBt     7
#define FontBt       8
#define HardwareBt   9
#define InterruptBt  10
#define PortBt       11
#define ResidentBt   12
#define SemaphoreBt  13

#define Sys_CNT      14

PRIVATE char v[] = "$VER: SystemViewer 1.0 (18-Sep-2000) by J.T. Steichen";

// ----------------------------------------------------------------------
IMPORT struct WBStartup *_WBenchMsg;
 
// ----------------------------------------------------------------------

struct IntuitionBase *IntuitionBase;
struct GfxBase       *GfxBase;
struct Library       *GadToolsBase;
struct Library       *IconBase = NULL;

// ----------------------------------------------------------------------

PRIVATE struct Screen         *Scr      = NULL;
PRIVATE struct Window         *SysWnd   = NULL;
PRIVATE struct Gadget         *SysGList = NULL;
PRIVATE struct IntuiMessage    SysMsg;
PRIVATE struct Gadget         *SysGadgets[ Sys_CNT ];

PRIVATE UBYTE                 *PubScreenName = "Workbench";
PRIVATE APTR                   VisualInfo    = NULL;

PRIVATE UWORD  SysLeft     = 189;
PRIVATE UWORD  SysTop      = 16;
PRIVATE UWORD  SysWidth    = 290;
PRIVATE UWORD  SysHeight   = 170;
PRIVATE UBYTE *SysWdt      = "System Viewer ©1999-2001:";
PRIVATE UBYTE *SysScrTitle = "SystemViewer ©1999-2001 by J.T. Steichen";

PRIVATE struct TextFont *SysFont = NULL;
PRIVATE struct CompFont  CFont   = { 0, };
PRIVATE struct TextAttr  Attr    = { 0, };
PRIVATE struct TextAttr *Font    = NULL;

PRIVATE UBYTE em[256], *ErrMsg = &em[0];

// TTTTTTTTT ToolTypes: TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT

PRIVATE char AssignCmd[]    = "ASSIGNCMD";
PRIVATE char LockCmd[]      = "LOCKCMD";
PRIVATE char MountCmd[]     = "MOUNTCMD";
PRIVATE char MemoryCmd[]    = "MEMORYCMD";
PRIVATE char ScreenCmd[]    = "SCREENCMD";
PRIVATE char TaskCmd[]      = "TASKCMD";
PRIVATE char VectorCmd[]    = "VECTORCMD";
PRIVATE char DeviceCmd[]    = "DEVICECMD";
PRIVATE char FontCmd[]      = "FONTCMD";
PRIVATE char HardwareCmd[]  = "HARDWARECMD";
PRIVATE char InterruptCmd[] = "INTERRUPTCMD";
PRIVATE char PortCmd[]      = "PORTCMD";
PRIVATE char ResidentCmd[]  = "RESIDENTCMD";
PRIVATE char SemaphoreCmd[] = "SEMAPHORECMD";

PRIVATE char DefAssignCmd[32]    = "SysAssigns";
PRIVATE char DefLockCmd[32]      = "SysLocks";
PRIVATE char DefMountCmd[32]     = "SysMounts";
PRIVATE char DefMemoryCmd[32]    = "SysMemory";
PRIVATE char DefScreenCmd[32]    = "SysScreens";
PRIVATE char DefTaskCmd[32]      = "SysTasks";
PRIVATE char DefVectorCmd[32]    = "SysVectors";
PRIVATE char DefDeviceCmd[32]    = "SysDevices";
PRIVATE char DefFontCmd[32]      = "SysFonts";
PRIVATE char DefHardwareCmd[32]  = "SysHardware";
PRIVATE char DefInterruptCmd[32] = "SysInterrupts";
PRIVATE char DefPortCmd[32]      = "SysPorts";
PRIVATE char DefResidentCmd[32]  = "SysResidents";
PRIVATE char DefSemaphoreCmd[32] = "SysSemaphores";

PRIVATE char *TTAssignCmd    = &DefAssignCmd[0];
PRIVATE char *TTLockCmd      = &DefLockCmd[0];
PRIVATE char *TTMountCmd     = &DefMountCmd[0];
PRIVATE char *TTMemoryCmd    = &DefMemoryCmd[0];
PRIVATE char *TTScreenCmd    = &DefScreenCmd[0];
PRIVATE char *TTTaskCmd      = &DefTaskCmd[0];
PRIVATE char *TTVectorCmd    = &DefVectorCmd[0];
PRIVATE char *TTDeviceCmd    = &DefDeviceCmd[0];
PRIVATE char *TTFontCmd      = &DefFontCmd[0];
PRIVATE char *TTHardwareCmd  = &DefHardwareCmd[0];
PRIVATE char *TTInterruptCmd = &DefInterruptCmd[0];
PRIVATE char *TTPortCmd      = &DefPortCmd[0];
PRIVATE char *TTResidentCmd  = &DefResidentCmd[0];
PRIVATE char *TTSemaphoreCmd = &DefSemaphoreCmd[0];

// TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT

PRIVATE struct DiskObject *diskobj = NULL;

PRIVATE struct IntuiText SysIText = {

   2, 0, JAM1,143, 12, NULL, 
   (UBYTE *) "Pick what you want to check out:", NULL 
};

PRIVATE UWORD SysGTypes[] = {

   BUTTON_KIND,   BUTTON_KIND,   BUTTON_KIND,
   BUTTON_KIND,   BUTTON_KIND,   BUTTON_KIND,
   BUTTON_KIND,   BUTTON_KIND,   BUTTON_KIND,
   BUTTON_KIND,   BUTTON_KIND,   BUTTON_KIND,
   BUTTON_KIND,   BUTTON_KIND
};

PRIVATE int AssignBtClicked(    void );
PRIVATE int LockBtClicked(      void );
PRIVATE int MountBtClicked(     void );
PRIVATE int MemoryBtClicked(    void );
PRIVATE int ScreenBtClicked(    void );
PRIVATE int TaskBtClicked(      void );
PRIVATE int VectorBtClicked(    void );
PRIVATE int DeviceBtClicked(    void );
PRIVATE int FontBtClicked(      void );
PRIVATE int HardwareBtClicked(  void );
PRIVATE int InterruptBtClicked( void );
PRIVATE int PortBtClicked(      void );
PRIVATE int ResidentBtClicked(  void );
PRIVATE int SemaphoreBtClicked( void );

PRIVATE struct NewGadget SysNGad[] = {

   146 , 44, 90, 17, (UBYTE *) "_Assignments", NULL, AssignBt,    
   PLACETEXT_IN, NULL, (APTR) AssignBtClicked,
   
   146,  24, 90, 17, (UBYTE *) "_Locks",       NULL, LockBt,      
   PLACETEXT_IN, NULL, (APTR) LockBtClicked,

   146,  64, 90, 17, (UBYTE *) "Mou_nts",      NULL, MountBt,
   PLACETEXT_IN, NULL, (APTR) MountBtClicked,

    40,  64, 90, 17, (UBYTE *) "_Memory",      NULL, MemoryBt,    
   PLACETEXT_IN, NULL, (APTR) MemoryBtClicked,

    40,  24, 90, 17, (UBYTE *) "_Screens",     NULL, ScreenBt,    
   PLACETEXT_IN, NULL, (APTR) ScreenBtClicked,

    40,  44, 90, 17, (UBYTE *) "_Tasks",       NULL, TaskBt,      
   PLACETEXT_IN, NULL, (APTR) TaskBtClicked,

   146, 144, 90, 17, (UBYTE *) "_Vectors",     NULL, VectorBt,    
   PLACETEXT_IN, NULL, (APTR) VectorBtClicked,

    40,  84, 90, 17, (UBYTE *) "_Devices",     NULL, DeviceBt,    
   PLACETEXT_IN, NULL, (APTR) DeviceBtClicked,

    40, 104, 90, 17, (UBYTE *) "_Fonts",       NULL, FontBt,      
   PLACETEXT_IN, NULL, (APTR) FontBtClicked,

   146, 104, 90, 17, (UBYTE *) "_Hardware",    NULL, HardwareBt,  
   PLACETEXT_IN, NULL, (APTR) HardwareBtClicked,
   
   146, 124, 90, 17, (UBYTE *) "_Interrupts",  NULL, InterruptBt, 
   PLACETEXT_IN, NULL, (APTR) InterruptBtClicked,

    40, 124, 90, 17, (UBYTE *) "_Ports",       NULL, PortBt,     
   PLACETEXT_IN, NULL, (APTR) PortBtClicked,

   146,  84, 90, 17, (UBYTE *) "_Residents",   NULL, ResidentBt,  
   PLACETEXT_IN, NULL, (APTR) ResidentBtClicked,
 
    40, 144, 90, 17, (UBYTE *) "S_emaphores",  NULL, SemaphoreBt, 
   PLACETEXT_IN, NULL, (APTR) SemaphoreBtClicked
};

PRIVATE ULONG SysGTags[] = {

   GT_Underscore, '_', TAG_DONE,   GT_Underscore, '_', TAG_DONE,
   GT_Underscore, '_', TAG_DONE,   GT_Underscore, '_', TAG_DONE,
   GT_Underscore, '_', TAG_DONE,   GT_Underscore, '_', TAG_DONE,
   GT_Underscore, '_', TAG_DONE,   GT_Underscore, '_', TAG_DONE,
   GT_Underscore, '_', TAG_DONE,   GT_Underscore, '_', TAG_DONE,
   GT_Underscore, '_', TAG_DONE,   GT_Underscore, '_', TAG_DONE,
   GT_Underscore, '_', TAG_DONE,   GT_Underscore, '_', TAG_DONE
};

// ----------------------------------------------------------------------- 

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

PRIVATE char cmd[256], *command = &cmd[0];

PRIVATE struct TagItem RunTags[] = { SYS_Asynch, TRUE, TAG_DONE }; 

PRIVATE void RunCommand( char *command )
{
   if (System( command, TAG_DONE ) < 0)
      {
      sprintf( ErrMsg,
               "\t%s\ncouldn't be run by the System,\ncheck your spelling!",
               command
             );

      (void) Handle_Problem( ErrMsg, "Invalid ToolType?", NULL );
      }

   return;
}

PRIVATE int AssignBtClicked( void )
{
   strcpy( command, TTAssignCmd );
   RunCommand( command );
   return( (int) TRUE );
}

PRIVATE int LockBtClicked( void )
{
   strcpy( command, TTLockCmd );
   RunCommand( command );
   return( (int) TRUE );
}

PRIVATE int MountBtClicked( void )
{
   strcpy( command, TTMountCmd );
   RunCommand( command );
   return( (int) TRUE );
}

PRIVATE int MemoryBtClicked( void )
{
   strcpy( command, TTMemoryCmd );
   RunCommand( command );
   return( (int) TRUE );
}

PRIVATE int ScreenBtClicked( void )
{
   strcpy( command, TTScreenCmd );
   RunCommand( command );
   return( (int) TRUE );
}

PRIVATE int TaskBtClicked( void )
{
   strcpy( command, TTTaskCmd );
   RunCommand( command );
   return( (int) TRUE );
}

PRIVATE int VectorBtClicked( void )
{
   strcpy( command, TTVectorCmd );
   RunCommand( command );
   return( (int) TRUE );
}

PRIVATE int DeviceBtClicked( void )
{
   strcpy( command, TTDeviceCmd );
   RunCommand( command );
   return( (int) TRUE );
}

PRIVATE int FontBtClicked( void )
{
   strcpy( command, TTFontCmd );
   RunCommand( command );
   return( (int) TRUE );
}

PRIVATE int HardwareBtClicked( void )
{
   strcpy( command, TTHardwareCmd );
   RunCommand( command );
   return( (int) TRUE );
}

PRIVATE int InterruptBtClicked( void )
{
   strcpy( command, TTInterruptCmd );
   RunCommand( command );
   return( (int) TRUE );
}

PRIVATE int PortBtClicked( void )
{
   strcpy( command, TTPortCmd );
   RunCommand( command );
   return( (int) TRUE );
}

PRIVATE int ResidentBtClicked( void )
{
   strcpy( command, TTResidentCmd );
   RunCommand( command );
   return( (int) TRUE );
}

PRIVATE int SemaphoreBtClicked( void )
{
   strcpy( command, TTSemaphoreCmd );
   RunCommand( command );
   return( (int) TRUE );
}

PRIVATE void CloseSysWindow( void )
{
   if (SysWnd != NULL) 
      {
      CloseWindow( SysWnd );
      SysWnd = NULL;
      }

   if (SysGList != NULL) 
      {
      FreeGadgets( SysGList );
      SysGList = NULL;
      }

   if (SysFont != NULL) 
      {
      CloseFont( SysFont );
      SysFont = NULL;
      }

   return;
}

PRIVATE int SysCloseWindow( void )
{
   CloseSysWindow();
   return( (int) FALSE );
}

PRIVATE int SysVanillaKey( int whichkey )
{
   int rval = TRUE;
   
   switch (whichkey)
      {
      case 'A':
      case 'a':
         rval = AssignBtClicked();      break;

      case 'L':
      case 'l':
         rval = LockBtClicked();        break;

      case 'n':
      case 'N':
         rval = MountBtClicked();       break;

      case 'M':
      case 'm':
         rval = MemoryBtClicked();      break;
         
      case 'S':
      case 's':
         rval = ScreenBtClicked();      break;

      case 'T':
      case 't':
         rval = TaskBtClicked();        break;

      case 'V':
      case 'v':
         rval = VectorBtClicked();      break;

      case 'D':
      case 'd':
         rval = DeviceBtClicked();      break;

      case 'F':
      case 'f':
         rval = FontBtClicked();        break;
   
      case 'H':
      case 'h':
         rval = HardwareBtClicked();    break;
      
      case 'I':
      case 'i':
         rval = InterruptBtClicked();   break;

      case 'P':
      case 'p':
         rval = PortBtClicked();        break;

      case 'R':
      case 'r':
         rval = ResidentBtClicked();    break;
      
      case 'e':
      case 'E':
         rval = SemaphoreBtClicked();   break;

      case 'q':  // Exit program keys:
      case 'Q':
      case 'x':
      case 'X':
         rval = FALSE;
         break;
      }

   return( (int) rval );
}

PRIVATE void SysRender( void )
{
   struct IntuiText it;

   ComputeFont( Scr, Font, &CFont, SysWidth, SysHeight );

   CopyMem( (char *) &SysIText, (char *) &it, 
            (long) sizeof( struct IntuiText )
          );

   it.ITextFont = Font;

   it.LeftEdge  = CFont.OffX + ComputeX( CFont.FontX, it.LeftEdge ) 
                  - (IntuiTextLength( &it ) >> 1);
   
   it.TopEdge   = CFont.OffY + ComputeY( CFont.FontY, it.TopEdge ) 
                  - (Font->ta_YSize >> 1);

   PrintIText( SysWnd->RPort, &it, 0, 0 );

   return;
}

PRIVATE int OpenSysWindow( void )
{
   struct NewGadget  ng;
   struct Gadget    *g;
   UWORD             lc, tc;
   UWORD             wleft = SysLeft, wtop = SysTop, ww, wh;

   ComputeFont( Scr, Font, &CFont, SysWidth, SysHeight );

   ww = ComputeX( CFont.FontX, SysWidth );
   wh = ComputeY( CFont.FontY, SysHeight );

   if ((wleft + ww + CFont.OffX + Scr->WBorRight) > Scr->Width) 
      wleft = Scr->Width - ww;
   
   if ((wtop + wh + CFont.OffY + Scr->WBorBottom) > Scr->Height) 
      wtop = Scr->Height - wh;

   if ((SysFont = OpenDiskFont( Font )) == NULL)
      return( -5 );

   if ((g = CreateContext( &SysGList )) == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < Sys_CNT; lc++) 
      {
      CopyMem( (char *) &SysNGad[ lc ], (char *) &ng, 
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

      SysGadgets[ lc ] = g = CreateGadgetA( (ULONG) SysGTypes[ lc ], 
                               g, 
                               &ng, 
                               (struct TagItem *) &SysGTags[ tc ] );

      while (SysGTags[ tc ] != NULL) 
         tc += 2;
      
      tc++;

      if (g == NULL)
         return( -2 );
      }

   if ((SysWnd = OpenWindowTags( NULL,
             WA_Left,        wleft,
             WA_Top,         wtop,
             WA_Width,       ww + CFont.OffX + Scr->WBorRight,
             WA_Height,      wh + CFont.OffY + Scr->WBorBottom,
             
             WA_IDCMP,       BUTTONIDCMP | IDCMP_CLOSEWINDOW 
               | IDCMP_VANILLAKEY | IDCMP_REFRESHWINDOW,
             
             WA_Flags,       WFLG_DRAGBAR | WFLG_DEPTHGADGET 
               | WFLG_CLOSEGADGET | WFLG_SMART_REFRESH | WFLG_ACTIVATE 
               | WFLG_RMBTRAP,

             WA_Gadgets,     SysGList,
             WA_Title,       SysWdt,
             WA_ScreenTitle, SysScrTitle,
             TAG_DONE )
      ) == NULL)
      return( -4 );

   GT_RefreshWindow( SysWnd, NULL );

   SysRender();

   return( 0 );
}

PRIVATE int HandleSysIDCMP( void )
{
   struct IntuiMessage *m;
   int                (*func)( void );
   BOOL                 running = TRUE;

   while (running == TRUE)
      {
      if ((m = GT_GetIMsg( SysWnd->UserPort )) == NULL) 
         {
         (void) Wait( 1L << SysWnd->UserPort->mp_SigBit );
         continue;
         }

      CopyMem( (char *) m, (char *) &SysMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (SysMsg.Class) 
         {
         case   IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( SysWnd );
            SysRender();
            GT_EndRefresh( SysWnd, TRUE );
            break;

         case   IDCMP_CLOSEWINDOW:
            running = SysCloseWindow();
            break;

         case   IDCMP_VANILLAKEY:
            running = SysVanillaKey( SysMsg.Code );
            break;

         case   IDCMP_GADGETUP:
            func = (void *) ((struct Gadget *)SysMsg.IAddress)->UserData;
            if (func != NULL)
               running = func();
            break;
         }
      }

   return( running );
}

PRIVATE void ShutdownProgram( void )
{
   CloseSysWindow();
   CloseDownScreen();

   if (IconBase != NULL)
      CloseLibrary( IconBase );

   CloseLibs();

   return;
}

// ------------------------------------------------------------------

PRIVATE int SetupProgram( void )
{
   if (OpenLibs() < 0)
      return( -1 );
      
   if ((IconBase = OpenLibrary( "icon.library", 37L )) == NULL)
      {
      CloseLibs();
      return( -3 );
      }

   if (SetupScreen() < 0)
      {
      CloseLibs();
      CloseLibrary( IconBase );
      return( -5 );
      }   

   if (OpenSysWindow() < 0)
      {
      ShutdownProgram();
      return( -6 );
      }   

   return( 0 );   
}

PRIVATE void SetValidGadgets( void )
{
   if (strcmp( TTAssignCmd, "NOT_DONE" ) == 0)
      GT_SetGadgetAttrs( SysGadgets[ AssignBt ], SysWnd, NULL,
                         GA_Disabled, TRUE, TAG_DONE    
                       );

   if (strcmp( TTLockCmd, "NOT_DONE" ) == 0)
      GT_SetGadgetAttrs( SysGadgets[ LockBt ], SysWnd, NULL,
                         GA_Disabled, TRUE, TAG_DONE    
                       );

   if (strcmp( TTMountCmd, "NOT_DONE" ) == 0)
      GT_SetGadgetAttrs( SysGadgets[ MountBt ], SysWnd, NULL,
                         GA_Disabled, TRUE, TAG_DONE    
                       );

   if (strcmp( TTMemoryCmd, "NOT_DONE" ) == 0)
      GT_SetGadgetAttrs( SysGadgets[ MemoryBt ], SysWnd, NULL,
                         GA_Disabled, TRUE, TAG_DONE    
                       );

   if (strcmp( TTScreenCmd, "NOT_DONE" ) == 0)
      GT_SetGadgetAttrs( SysGadgets[ ScreenBt ], SysWnd, NULL,
                         GA_Disabled, TRUE, TAG_DONE    
                       );

   if (strcmp( TTTaskCmd, "NOT_DONE" ) == 0)
      GT_SetGadgetAttrs( SysGadgets[ TaskBt ], SysWnd, NULL,
                         GA_Disabled, TRUE, TAG_DONE    
                       );

   if (strcmp( TTVectorCmd, "NOT_DONE" ) == 0)
      GT_SetGadgetAttrs( SysGadgets[ VectorBt ], SysWnd, NULL,
                         GA_Disabled, TRUE, TAG_DONE    
                       );

   if (strcmp( TTDeviceCmd, "NOT_DONE" ) == 0)
      GT_SetGadgetAttrs( SysGadgets[ DeviceBt ], SysWnd, NULL,
                         GA_Disabled, TRUE, TAG_DONE    
                       );

   if (strcmp( TTFontCmd, "NOT_DONE" ) == 0)
      GT_SetGadgetAttrs( SysGadgets[ FontBt ], SysWnd, NULL,
                         GA_Disabled, TRUE, TAG_DONE    
                       );

   if (strcmp( TTHardwareCmd, "NOT_DONE" ) == 0)
      GT_SetGadgetAttrs( SysGadgets[ HardwareBt ], SysWnd, NULL,
                         GA_Disabled, TRUE, TAG_DONE    
                       );

   if (strcmp( TTInterruptCmd, "NOT_DONE" ) == 0)
      GT_SetGadgetAttrs( SysGadgets[ InterruptBt ], SysWnd, NULL,
                         GA_Disabled, TRUE, TAG_DONE    
                       );

   if (strcmp( TTPortCmd, "NOT_DONE" ) == 0)
      GT_SetGadgetAttrs( SysGadgets[ PortBt ], SysWnd, NULL,
                         GA_Disabled, TRUE, TAG_DONE    
                       );

   if (strcmp( TTResidentCmd, "NOT_DONE" ) == 0)
      GT_SetGadgetAttrs( SysGadgets[ ResidentBt ], SysWnd, NULL,
                         GA_Disabled, TRUE, TAG_DONE    
                       );

   if (strcmp( TTSemaphoreCmd, "NOT_DONE" ) == 0)
      GT_SetGadgetAttrs( SysGadgets[ SemaphoreBt ], SysWnd, NULL,
                         GA_Disabled, TRUE, TAG_DONE    
                       );

   return;
}

PRIVATE void *processToolTypes( char **toolptr )
{
   if (toolptr == NULL)
      return( NULL );

   TTAssignCmd    = GetToolStr( toolptr, AssignCmd,    DefAssignCmd    );
   TTLockCmd      = GetToolStr( toolptr, LockCmd,      DefLockCmd      );
   TTMountCmd     = GetToolStr( toolptr, MountCmd,     DefMountCmd     );
   TTMemoryCmd    = GetToolStr( toolptr, MemoryCmd,    DefMemoryCmd    );
   TTScreenCmd    = GetToolStr( toolptr, ScreenCmd,    DefScreenCmd    );
   TTTaskCmd      = GetToolStr( toolptr, TaskCmd,      DefTaskCmd      );
   TTVectorCmd    = GetToolStr( toolptr, VectorCmd,    DefVectorCmd    );
   TTDeviceCmd    = GetToolStr( toolptr, DeviceCmd,    DefDeviceCmd    );
   TTFontCmd      = GetToolStr( toolptr, FontCmd,      DefFontCmd      );
   TTHardwareCmd  = GetToolStr( toolptr, HardwareCmd,  DefHardwareCmd  );
   TTInterruptCmd = GetToolStr( toolptr, InterruptCmd, DefInterruptCmd );
   TTPortCmd      = GetToolStr( toolptr, PortCmd,      DefPortCmd      );
   TTResidentCmd  = GetToolStr( toolptr, ResidentCmd,  DefResidentCmd  );
   TTSemaphoreCmd = GetToolStr( toolptr, SemaphoreCmd, DefSemaphoreCmd );

   return( NULL );
}

PUBLIC int main( int argc, char **argv )
{
   struct WBArg  *wbarg;
   char         **toolptr = NULL;

   if (SetupProgram() < 0)
      {
      fprintf( stderr, "Couldn't set up %s!\n", argv[0] );
      return( RETURN_FAIL );
      }

   if (argc > 0)    /* from CLI:       */
      {
      // We prefer to use the ToolTypes: 
      (void) FindIcon( &processToolTypes, diskobj, argv[0] );
      }
   else             /* from Workbench: */
      {
      IMPORT char *_WBArgv;
      
      // argc = _WBArgc;
      argv = _WBArgv;
      
      wbarg   = &(_WBenchMsg->sm_ArgList[ _WBenchMsg->sm_NumArgs - 1 ]);
      toolptr = FindTools( diskobj, wbarg->wa_Name, wbarg->wa_Lock );

      (void) processToolTypes( toolptr );
      }

   SetValidGadgets();
   SetNotifyWindow( SysWnd );

   (void) HandleSysIDCMP();

   FreeDiskObject( diskobj );   

   ShutdownProgram();

   return( RETURN_OK );
}

/* ------------------- END of SystemViewer.c file! -------------------- */
