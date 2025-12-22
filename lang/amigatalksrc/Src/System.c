/****h* AmigaTalk/System.c [3.0] ***************************************
*
* NAME
*    System.c
*
* DESCRIPTION 
*    This file contains functions that obtain information from the
*    OS via ExecBase.
*
* FUNCTIONAL INTERFACE:
*
*    PUBLIC OBJECT *HandleSystem( int numargs, OBJECT **args ); // 250
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    10-Dec-2003 - Added <250 5 1 self> (xxxReport) primitive.
*
*    04-Jan-2003 - Moved all string constants to StringConstants.h
*
* NOTES
*    $VER: AmigaTalk:Src/System.c 3.0 (25-Oct-2004) by J.T. Steichen
************************************************************************
*
*/

#include <stdio.h>
#include <string.h>

#include <AmigaDOSErrs.h>

#include <exec/execbase.h>
#include <exec/types.h>

#include <intuition/intuitionbase.h>
#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/gadgetclass.h>

#include <libraries/gadtools.h>

#include <graphics/displayinfo.h>

#ifdef __SASC

# include <clib/exec_protos.h>
# include <clib/alib_protos.h>
# include <clib/dos_protos.h>
# include <clib/intuition_protos.h>
# include <clib/gadtools_protos.h>

IMPORT struct IntuitionBase *IntuitionBase;
IMPORT struct ExecBase      *SysBase;

#else

# define __USE_INLINE__

# include <proto/dos.h>
# include <proto/exec.h>
# include <proto/intuition.h>
# include <proto/gadtools.h>

IMPORT struct Library *IntuitionBase;
IMPORT struct Library *SysBase;

IMPORT struct IntuitionIFace *IIntuition;
IMPORT struct ExecIFace      *IExec;

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "Constants.h"
#include "Object.h"

#include "FuncProtos.h"

#include "IStructs.h"

#include "StringConstants.h"
#include "StringIndexes.h"

#define MAXNODE    100

#define SCREEN_DATA  0
#define WINDOW_DATA  1
#define TASK_DATA    2
#define PROCESS_DATA 3

IMPORT OBJECT *PrintArgTypeError( int primnumber );

IMPORT struct Screen        *Scr;
IMPORT struct Window        *ATWnd;
IMPORT struct TextAttr      *Font;
IMPORT struct CompFont       CFont;
IMPORT APTR                  VisualInfo; // In Main.c

IMPORT UBYTE       *AaarrggButton;  // From Global.c
IMPORT UBYTE       *DefaultButtons;
IMPORT UBYTE       *AllocProblem;

IMPORT OBJECT      *o_nil, *o_false, *o_true, *o_drive; 

// ----------- Info ListViewer stuff: --------------------------------

PRIVATE UWORD WLeft   = 0;
PRIVATE UWORD WTop    = 16;
PRIVATE UWORD WWidth  = 632;
PRIVATE UWORD WHeight = 250;

PRIVATE ULONG TaskAddress = 0L;
PRIVATE ULONG SWinAddress = 0L;

#define TASK_PROC_TYPE 0
#define SCRN_WIND_TYPE 1

PRIVATE int InfoType = TASK_PROC_TYPE;

#define SCRN_TYPE 0
#define WIND_TYPE 1

PRIVATE int SWinType = SCRN_TYPE;

#define InfoLV     0
#define IUpdateBt  1
#define IMoreBt    2
#define ISelection 3

#define I_CNT      4

PRIVATE struct Gadget *InfoGadgets[ I_CNT ] = { NULL, };
PRIVATE struct Gadget *GList = NULL;

PRIVATE struct MinList InfoLVList;

PRIVATE struct Node InfoLVNode;
PRIVATE struct Node InfoLVNodes[ MAXNODE ] = { NULL, };

PRIVATE UBYTE       NodeStrs[ MAXNODE * 80 ] = { 0, };

PRIVATE UWORD InfoGTypes[ I_CNT ] = {

   LISTVIEW_KIND, BUTTON_KIND, BUTTON_KIND, TEXT_KIND
};

PRIVATE int ILVClicked(      int itemnum );
PRIVATE int UpdateClicked(   int dummy   );
PRIVATE int MoreClicked(     int dummy   );

/* Since this is an array, the gadgets are in numerical order 
** (by GadgetID number).
*/

PUBLIC struct NewGadget InfoNGad[ I_CNT ] = {

     2,   3, 627, 200, NULL, NULL, InfoLV, 0, NULL, (APTR) ILVClicked,
   
     4, 205,  71,  17, NULL, NULL, IUpdateBt, 
   PLACETEXT_IN, NULL, (APTR) UpdateClicked,
   
    89, 205,  71,  17, NULL, NULL, IMoreBt, 
   PLACETEXT_IN, NULL, (APTR) MoreClicked,
   
     5, 228, 620,  17, NULL, NULL, ISelection, 0, NULL, NULL
};

PRIVATE ULONG InfoGTags[] = {

   GTLV_ShowSelected, 0L, (LAYOUTA_Spacing), 2, (TAG_DONE),

   (GT_Underscore), UNDERSCORE_CHAR, (TAG_DONE),
   (GT_Underscore), UNDERSCORE_CHAR, (TAG_DONE),

   (GTTX_Border),  TRUE, TAG_DONE
};

PUBLIC UBYTE  WTitle[80] = { 0, };

PRIVATE struct Window *Wnd = NULL;

// ----------- Information Window stuff: ------------------------------

PRIVATE struct Window *IWnd = NULL;

PRIVATE struct IntuiMessage IMsg = { 0, };

PRIVATE UWORD ILeft   = 0;
PRIVATE UWORD ITop    = 32;
PRIVATE UWORD IWidth  = 640;
PRIVATE UWORD IHeight = 480;

PUBLIC UBYTE IWTitle[80] = { 0, };

#define YPOS_MAX 32

PRIVATE UWORD StrYPos[ YPOS_MAX ] = { 0, };

// -------------------------------------------------------------------


// --------- Task & Process functions: -------------------------------

SUBFUNC OBJECT *getTPAddress( char *name, int type  )
{
#  ifdef  __SASC
   IMPORT struct ExecBase *SysBase;
#  endif
   
   struct Task *crnttask = NULL;
   OBJECT      *rval     = o_nil;

   Forbid();

#    ifdef  __SASC
     crnttask = SysBase->ThisTask;
#    else
     crnttask = ((struct ExecBase *) IExec->Data.LibBase)->ThisTask;
#    endif

     while (crnttask) // != NULL)
        {
        if (crnttask->tc_Node.ln_Type == type)
           {
           if (crnttask->tc_Node.ln_Name) // != NULL)
              {
              if (StringComp( crnttask->tc_Node.ln_Name, name) == 0)
                 {
                 rval = new_address( (ULONG) crnttask );
                 break;
                 }
              }
           }
        
        crnttask = (struct Task *) crnttask->tc_Node.ln_Succ;
        }
   
   Permit();

   return( rval );
}

SUBFUNC void WriteText( char *string, int xpos, int ypos, int color ) 
{
   struct RastPort  *rp = IWnd->RPort;
   struct IntuiText  outtxt;

   outtxt.FrontPen  = color;
   outtxt.BackPen   = 0;
   outtxt.DrawMode  = JAM1;
   outtxt.LeftEdge  = 0;
   outtxt.TopEdge   = 0;
   outtxt.ITextFont = Font;
   outtxt.NextText  = NULL;
   outtxt.IText     = (UBYTE *) string;

   PrintIText( rp, &outtxt, xpos, ypos );

   return;
}

SUBFUNC void CloseIWindow( void )
{
   if (IWnd) // != NULL) 
      {
      CloseWindow( IWnd );
      IWnd = NULL;
      }

   return;
}

SUBFUNC int ICloseWindow( void )
{
   CloseIWindow();
   return( (int) FALSE );
}

SUBFUNC BOOL CheckBit( int flags, int bit )
{
   if ((flags & bit) == bit)
      return( TRUE );
   else
      return( FALSE );
}

SUBFUNC int OpenIWindow( int numlines )
{
   UWORD wleft = ILeft, wtop = ITop, ww, wh;
   int   i;
   int   Offset = Scr->BarHeight + Scr->WBorTop;

   ComputeFont( Scr, Font, &CFont, IWidth, IHeight );

   IHeight = (numlines + 1) * (CFont.FontY + 3) + 2;

   if (IHeight > Scr->Height)
      IHeight = Scr->Height;

   for (i = 0; i < YPOS_MAX; i++)
      StrYPos[i] = Offset + i * (CFont.FontY + 3);
         
   ww = ComputeX( CFont.FontX, IWidth  );
   wh = ComputeY( CFont.FontY, IHeight );

   if ((wleft + ww + CFont.OffX + Scr->WBorRight) > Scr->Width) 
      wleft = Scr->Width - ww;

   if ((wtop + wh + CFont.OffY + Scr->WBorBottom) > Scr->Height) 
      wtop = Scr->Height - wh;

   if (!(IWnd = OpenWindowTags( NULL,

                   WA_Left,        wleft,
                   WA_Top,         wtop,
                   WA_Width,       ww + CFont.OffX + Scr->WBorRight,
                   WA_Height,      wh + CFont.OffY + Scr->WBorBottom,

                   WA_IDCMP,       IDCMP_GADGETUP | IDCMP_VANILLAKEY
                     | IDCMP_REFRESHWINDOW | IDCMP_CLOSEWINDOW,

                   WA_Flags,       WFLG_SMART_REFRESH | WFLG_CLOSEGADGET 
                     | WFLG_ACTIVATE | WFLG_RMBTRAP,

                   WA_Gadgets,      NULL,
                   WA_CustomScreen, Scr,     // AmigaTalk Screen.
                   WA_Title,        IWTitle,
                   TAG_DONE )
      )) // == NULL)
      return( -4 );

   SetNotifyWindow( IWnd );
   return( 0 );
}

PRIVATE int FIVanillaKey( int whichkey )
{
   int rval = TRUE;
   
   switch (whichkey)
      {
      case CAP_Q_CHAR:
      case CAP_D_CHAR:
      case CAP_X_CHAR:
      case SMALL_D_CHAR:
      case SMALL_Q_CHAR:
      case SMALL_X_CHAR:

         rval = FALSE;
         break;
         
      default:
         break;
      }
      
   return( rval );
}

PRIVATE int HandleFullInfoIDCMP( void )
{
   struct IntuiMessage *m       = NULL;
   BOOL                 running = TRUE;

   while (running == TRUE)
      {
      if (!(m = GT_GetIMsg( IWnd->UserPort ))) // == NULL)
         {
         (void) Wait( 1L << IWnd->UserPort->mp_SigBit );
 
         continue;
         }

      CopyMem( (char *) m, (char *) &IMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (IMsg.Class) 
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( IWnd );
            GT_EndRefresh( IWnd, TRUE );
            break;

         case IDCMP_VANILLAKEY:
            if ((running = FIVanillaKey( IMsg.Code )) == FALSE)
               (void) ICloseWindow();

            break;
            
         case IDCMP_CLOSEWINDOW:
   	    running = ICloseWindow();
            break;
         }
      }

   SetNotifyWindow( Wnd );
   return( running );
}

PRIVATE char ts[20] = { 0, }, *taskstate = &ts[0];
PRIVATE BOOL DispTaskFlag = TRUE;

PRIVATE char *GetTaskState( struct Task *t )
{
   if (!t) // == NULL)
      return( SysCMsg( MSG_TASKSTATE_INVALID_SYS ) );

   switch (t->tc_State)
      {
      case TS_INVALID:
         // Stack won''t be right.
         StringNCopy( taskstate, SysCMsg( MSG_TASKSTATE_INVALID_SYS ), 20 );  
         DispTaskFlag = FALSE;
         break;
         
      case TS_ADDED:
         StringNCopy( taskstate, SysCMsg( MSG_TASKSTATE_ADDED_SYS ), 20 );
         DispTaskFlag = TRUE;
         break;
         
      case TS_RUN:
         StringNCopy( taskstate, SysCMsg( MSG_TASKSTATE_RUNNING_SYS ), 20 );
         DispTaskFlag = TRUE;
         break;
         
      case TS_READY:
         StringNCopy( taskstate, SysCMsg( MSG_PROC_READY_SYS ), 20 );
         DispTaskFlag = TRUE;
         break;
         
      case TS_WAIT:
         StringNCopy( taskstate, SysCMsg( MSG_TASKSTATE_WAITING_SYS ), 20 );
         DispTaskFlag = TRUE;
         break;
         
      case TS_EXCEPT:
         StringNCopy( taskstate, SysCMsg( MSG_TASKSTATE_EXCEPTION_SYS ), 20 );

         DispTaskFlag = TRUE;
         break;
         
      case TS_REMOVED:
         StringNCopy( taskstate, SysCMsg( MSG_TASKSTATE_REMOVED_SYS ), 20 );
         DispTaskFlag = TRUE;
         break;
      }

   return( taskstate );
}

PRIVATE void SetTaskFlags( struct Task *t, char *str )
{
   *str = NIL_CHAR;

   if (CheckBit( t->tc_Flags, TF_PROCTIME ) == TRUE)
      StringCopy( str, SysCMsg( MSG_TASKFLAG_PROCTIME_SYS ) );
   
   if (CheckBit( t->tc_Flags, TF_ETASK ) == TRUE)
      StringCat( str, SysCMsg( MSG_TASKFLAG_ETASK_SYS ) );

   if (CheckBit( t->tc_Flags, TF_STACKCHK ) == TRUE)
      StringCat( str, SysCMsg( MSG_TASKFLAG_STACKCHK_SYS ) );

   if (CheckBit( t->tc_Flags, TF_EXCEPT ) == TRUE)
      StringCat( str, SysCMsg( MSG_TASKFLAG_EXCEPT_SYS ) );

   if (CheckBit( t->tc_Flags, TF_SWITCH ) == TRUE)
      StringCat( str, SysCMsg( MSG_TASKFLAG_SWITCH_SYS ) );

   if (CheckBit( t->tc_Flags, TF_LAUNCH ) == TRUE)
      StringCat( str, SysCMsg( MSG_TASKFLAG_LAUNCH_SYS ) );

   return;
}

PRIVATE char typ[10] = { 0, }, *pgmtype = &typ[0];

PRIVATE char *GetTask_Process( UBYTE type )
{
   if (type == NT_TASK)
      StringCopy( pgmtype, SysCMsg( MSG_TASKNAME_SYS ) );
   else if (type == NT_PROCESS)
      StringCopy( pgmtype, SysCMsg( MSG_PROCESSNAME_SYS ) );
   else   
      StringCopy( pgmtype, SysCMsg( MSG_TASKNAME_SYS ) );

   return( pgmtype );
}

#define B2APTR( bptr ) ((bptr) << 2)

#define XPOS 6

PRIVATE void WriteTask( void *ptr )
{
   IMPORT UWORD StrYPos[];
   
   struct Task    *task    = (struct Task *) ptr;
   struct Process *process = NULL;

   char t[82] = { 0, }, *title = &t[0];
   char s[82] = { 0, }, *str   = &s[0];

   int  size = 0;
   
   if (!task) // == NULL)
      return; 

   sprintf( title, "%10.10s: (%08LX) -> %-32.32s", 
            GetTask_Process( task->tc_Node.ln_Type ),
            task, task->tc_Node.ln_Name
          );

   StringCopy( IWTitle, title );
   SetWindowTitles( IWnd, IWTitle, (UBYTE *) 0xFFFFFFFF );

   (void) ActivateWindow( IWnd );

   // Common (to Task & Process) data to display:
   if ((task->tc_Node.ln_Type == NT_TASK) 
       || (task->tc_Node.ln_Type == NT_PROCESS))
      {
      sprintf( str, SysCMsg( MSG_FMT_STATE_PRI_SYS ), 
               GetTaskState( task ),
               task->tc_Node.ln_Pri 
             );

      WriteText( str, XPOS, StrYPos[0], 2 );

      sprintf( str, SysCMsg( MSG_FMT_SIGNALS_SYS ), 
               task->tc_SigAlloc, task->tc_SigWait, 
               task->tc_SigRecvd, task->tc_SigExcept
             );

      WriteText( str, XPOS, StrYPos[1], 1 );

      sprintf( str, SysCMsg( MSG_FMT_TRAPS_SYS ),
               task->tc_TrapData, task->tc_TrapCode, 
               task->tc_ETask
             );

      WriteText( str, XPOS, StrYPos[2], 1 );

      sprintf( str, SysCMsg( MSG_FMT_SWITCH_SYS ), 
               task->tc_Switch, task->tc_Launch, 
               task->tc_UserData
             );

      WriteText( str, XPOS, StrYPos[3], 2 );

      sprintf( str, SysCMsg( MSG_FMT_EXCEPTDATA_SYS ), 
               task->tc_ExceptData, task->tc_ExceptCode
             );

      WriteText( str, XPOS, StrYPos[5], 1 );

      size = (int) task->tc_SPUpper - (int) task->tc_SPLower;

      sprintf( str, SysCMsg( MSG_FMT_STKPNTR_SYS ),
               task->tc_SPReg, task->tc_SPUpper, 
               task->tc_SPLower, size
             );

      WriteText( str, XPOS, StrYPos[6], 2 );

      sprintf( str, SysCMsg( MSG_FMT_NESTCOUNT_SYS ),
               task->tc_IDNestCnt, task->tc_TDNestCnt
             );

      WriteText( str, XPOS, StrYPos[8], 1 );

      sprintf( str, SysCMsg( MSG_FMT_MEMENTRY_SYS ),
                    task->tc_MemEntry.lh_Head
             );

      WriteText( str, XPOS, StrYPos[9], 1 );

      WriteText( SysCMsg( MSG_FLAGS_COLON_SYS ),
                 XPOS, StrYPos[10], 3
               );

      SetTaskFlags( task, str );

      WriteText( str, XPOS, StrYPos[11], 1 );

      if (task->tc_Node.ln_Type == NT_TASK) 
         WriteText( SysCMsg( MSG_PRESS_CLOSEGADGET_SYS ),
                    150, StrYPos[12], 2
                  ); 
      }

   // Process additions to display:
   if (task->tc_Node.ln_Type == NT_PROCESS)
      {
      char   pn[512] = { 0, }, *path = &pn[0];
      UBYTE *ttl = NULL;
            
      process = (struct Process *) ptr;

      WriteText( SysCMsg( MSG_PROCESS_STRUCT_SYS ), XPOS, StrYPos[12], 3 );  

      if ((struct Window *) process->pr_WindowPtr) // != NULL)
         ttl = ((struct Window *) process->pr_WindowPtr)->Title;
      else
         ttl = SysCMsg( MSG_NO_TITLE_SYS );

      sprintf( str, SysCMsg( MSG_FMT_WINDOWPTR_SYS ), 
                    process->pr_WindowPtr, 
                    (StringLength( ttl ) > 0) ? ttl 
                                              : (UBYTE *) SysCMsg( MSG_NO_TITLE_SYS )
             );

      WriteText( str, XPOS, StrYPos[13], 2 );

      if (process->pr_CurrentDir) // != NULL)
         (void) NameFromLock( process->pr_CurrentDir, path, 255 );
          
      sprintf( str, SysCMsg( MSG_FMT_CRNTDIR_SYS ), 
               B2APTR( process->pr_CurrentDir ),
               (!path) ? SysCMsg( MSG_NO_PATH_SYS ) : (STRPTR) path
             );

      WriteText( str, XPOS, StrYPos[14], 2 );

      sprintf( str, SysCMsg( MSG_FMT_WINDOWMPORT_SYS ), 
               process->pr_MsgPort,
#              ifdef  __SASC
	       B2APTR( process->pr_SegList )
#              else
	       B2APTR( process->pr_CurrentSeg )
#              endif
             );

      WriteText( str, XPOS, StrYPos[15], 1 );

      sprintf( str, SysCMsg( MSG_FMT_STACKBASE_SYS), 
               B2APTR( process->pr_StackBase ), process->pr_StackSize
             );

      WriteText( str, XPOS, StrYPos[16], 1 );

      sprintf( str, SysCMsg( MSG_FMT_CIS_COS_SYS ), 
               B2APTR( process->pr_CIS ), B2APTR( process->pr_COS )
             );

      WriteText( str, XPOS, StrYPos[17], 1 );

      sprintf( str, SysCMsg( MSG_FMT_CONSTASK_SYS ), 
               process->pr_ConsoleTask, 
               process->pr_FileSystemTask
             );

      WriteText( str, XPOS, StrYPos[18], 1 );

      sprintf( str, SysCMsg( MSG_FMT_PKTWAIT_SYS ), 
               process->pr_PktWait, 
#              ifdef  __SASC
               process->pr_ReturnAddr
#              else
               process->pr_ReturnAddress // Obsolete!!
#              endif	       
             );

      WriteText( str, XPOS, StrYPos[19], 1 );

      sprintf( str, SysCMsg( MSG_FMT_ARGUMENTS_SYS ), 
               (!process->pr_Arguments) ? SysCMsg( MSG_NO_ARGS_SYS ) 
                                        : (STRPTR) process->pr_Arguments
             );

      WriteText( str, XPOS, StrYPos[20], 2 );

#     ifdef  __SASC
      sprintf( str, SysCMsg( MSG_FMT_GLOBVEC_SYS ), 
               process->pr_GlobVec, 
               B2APTR( process->pr_CLI )
             );
#     endif

      WriteText( str, XPOS, StrYPos[21], 1 );

      // CLI additional information: 

      if (process->pr_CLI) // != NULL)
         {
         struct CommandLineInterface *cli = NULL;
         BOOL                         iflag = FALSE, bflag = FALSE;

         cli = (struct CommandLineInterface *) (process->pr_CLI << 2);

         WriteText( SysCMsg( MSG_CLI_STRUCTURE_SYS ), 
                    XPOS, StrYPos[22], 3
                  );

         sprintf( str, SysCMsg( MSG_FMT_CMDDIR_SYS ), 
                  B2APTR( cli->cli_CommandDir )
                );

         WriteText( str, XPOS, StrYPos[23], 1 );

         sprintf( str, SysCMsg( MSG_FMT_STDIO_SYS ), 
                  B2APTR( cli->cli_StandardInput ),
                  B2APTR( cli->cli_StandardOutput )
                );

         WriteText( str, XPOS, StrYPos[24], 1 );

         sprintf( str, SysCMsg( MSG_FMT_CURRENTIO_SYS ), 
                  B2APTR( cli->cli_CurrentInput  ),
                  B2APTR( cli->cli_CurrentOutput )
                );

         WriteText( str, XPOS, StrYPos[25], 1 );

         if (cli->cli_Interactive != FALSE)
            iflag = TRUE;
            
         if (cli->cli_Background != FALSE)
            bflag = TRUE;
            
         sprintf( str, SysCMsg( MSG_FMT_MODULE_SYS ), 
                  B2APTR( cli->cli_Module ),
                  (bflag == TRUE) ? SysCMsg( MSG_BACKGROUND_STR_SYS ) 
                                  : (STRPTR) EMPTY_STRING,
                  
                  (iflag == TRUE) ? SysCMsg( MSG_INTERACTIVE_STR_SYS ) 
                                  : (STRPTR) EMPTY_STRING
                );

         WriteText( str, XPOS, StrYPos[26], 1 );
         }

      WriteText( SysCMsg( MSG_PRESS_CLOSEGADGET_SYS ), 150, StrYPos[27], 2 ); 
      }

   return;
}

// --------- Window & Screen Info functions: --------------------------

PRIVATE void CountGadgets( struct Window *w, int *bgad, 
                           int *sgad, int *pgad
                         )
{
   struct Gadget *first = w->FirstGadget;
   
   while (first) // != NULL)
      {
      switch (first->GadgetType & 0x07)
         {
         case BOOLGADGET:
            *bgad += 1;
            break; 

         case STRGADGET:
            *sgad += 1;
            break; 

         case PROPGADGET:
            *pgad += 1;
            break; 
         }
          
      first = first->NextGadget;
      }

   return;
}

PRIVATE void CountMenus( struct Window *w, int *m, int *mi )
{
   struct Menu     *menu  = w->MenuStrip;
   struct MenuItem *mitem = NULL;

   while (menu) // != NULL)
      {
      *m += 1;
      mitem = menu->FirstItem;
      
      while (mitem) // != NULL)
         {
         *mi += 1;
         
         if (mitem->SubItem) // != NULL)
            {
            struct MenuItem *subs = mitem->SubItem;
            
            while (subs) // != NULL)
               {
               *mi += 1;
               
               subs = subs->NextItem;
               }
            }

         mitem = mitem->NextItem;
         }
      
      menu = menu->NextMenu;
      }

   return;
}

PRIVATE void SetScreenFlagString( char *str, struct Screen *s )
{
   if (CheckBit( s->Flags, CUSTOMSCREEN ) == TRUE)
      StringCopy( str, SysCMsg( MSG_SCREENFLAG_CUSTOM_SYS ) );
   else
      StringCopy( str, SysCMsg( MSG_SCREENFLAG_WBENCH_SYS ) );

   if (CheckBit( s->Flags, SHOWTITLE ) == TRUE)
      StringCat( str, SysCMsg( MSG_SCREENFLAG_SHOWTITLE_SYS ) );
 
   if (CheckBit( s->Flags, BEEPING ) == TRUE)
      StringCat( str, SysCMsg( MSG_SCREENFLAG_BEEPING_SYS ) );
 
   if (CheckBit( s->Flags, CUSTOMBITMAP ) == TRUE)
      StringCat( str, SysCMsg( MSG_SCREENFLAG_CBITMAP_SYS ) );
 
   return;
}


PRIVATE void SetScreenViewMode1( char *str, struct Screen *s )
{
   *str = NIL_CHAR;

   if (CheckBit( s->ViewPort.Modes, HIRES ) == TRUE)
      StringCopy( str, SysCMsg( MSG_VIEWMODE_HIRES_SYS ) );

   if (CheckBit( s->ViewPort.Modes, SPRITES ) == TRUE)
      StringCat( str, SysCMsg( MSG_VIEWMODE_SPRITES_SYS ) );

   if (CheckBit( s->ViewPort.Modes, VP_HIDE ) == TRUE)
      StringCat( str, SysCMsg( MSG_VIEWMODE_VP_HIDE_SYS ) );

   if (CheckBit( s->ViewPort.Modes, EXTENDED_MODE ) == TRUE)
      StringCat( str, SysCMsg( MSG_VIEWMODE_EXTENDED_SYS ) );

   if (CheckBit( s->ViewPort.Modes, HAM ) == TRUE)
      StringCat( str, SysCMsg( MSG_VIEWMODE_HAM_SYS ) );

   if (CheckBit( s->ViewPort.Modes, DUALPF ) == TRUE)
      StringCat( str, SysCMsg( MSG_VIEWMODE_DUALPF_SYS ) );

   if (CheckBit( s->ViewPort.Modes, GENLOCK_AUDIO ) == TRUE)
      StringCat( str, SysCMsg( MSG_VIEWMODE_GENLOCKA_SYS ) );

   if (CheckBit( s->ViewPort.Modes, PFBA ) == TRUE)
      StringCat( str, SysCMsg( MSG_VIEWMODE_PFBA_SYS ) );

   return;
}

PRIVATE void SetScreenViewMode2( char *str, struct Screen *s )
{
   *str = NIL_CHAR;
   
   if (CheckBit( s->ViewPort.Modes, LACE ) == TRUE)
      StringCopy( str, SysCMsg( MSG_VIEWMODE_LACE_SYS ) );

   if (CheckBit( s->ViewPort.Modes, DOUBLESCAN ) == TRUE)
      StringCat( str, SysCMsg( MSG_VIEWMODE_DBLSCAN_SYS ) );

   if (CheckBit( s->ViewPort.Modes, SUPERHIRES ) == TRUE)
      StringCat( str, SysCMsg( MSG_VIEWMODE_SUPERHIRES_SYS ) );

   if (CheckBit( s->ViewPort.Modes, EXTRA_HALFBRITE ) == TRUE)
      StringCat( str, SysCMsg( MSG_VIEWMODE_XTRAHALF_SYS ) );

   if (CheckBit( s->ViewPort.Modes, GENLOCK_VIDEO ) == TRUE)
      StringCat( str, SysCMsg( MSG_VIEWMODE_GENLOCKV_SYS ) );

   return;
}

PRIVATE void SetWindowFlags1( struct Window *w, char *str )
{
   *str = NIL_CHAR;

   if (CheckBit( w->Flags, WFLG_SIZEGADGET ) == TRUE)
      StringCopy( str, SysCMsg( MSG_W_SIZEGADGET_STR_SYS ) );

   if (CheckBit( w->Flags, WFLG_DRAGBAR ) == TRUE)
      StringCat( str, SysCMsg( MSG_W_DRAGBAR_STR_SYS ) );

   if (CheckBit( w->Flags, WFLG_DEPTHGADGET ) == TRUE)
      StringCat( str, SysCMsg( MSG_W_DEPTHGADGET_STR_SYS ) );

   if (CheckBit( w->Flags, WFLG_CLOSEGADGET ) == TRUE)
      StringCat( str, SysCMsg( MSG_W_CLOSEGADGET_STR_SYS ) );

   return;
}

PRIVATE void SetWindowFlags2( struct Window *w, char *str )
{
   *str = NIL_CHAR;

   if (CheckBit( w->Flags, WFLG_SMART_REFRESH ) == TRUE)
      StringCopy( str, SysCMsg( MSG_W_SMARTREF_STR_SYS ) );

   if (CheckBit( w->Flags, WFLG_SIMPLE_REFRESH ) == TRUE)
      StringCat( str, SysCMsg( MSG_W_SIMPLEREF_STR_SYS ) );

   if (CheckBit( w->Flags, WFLG_SUPER_BITMAP ) == TRUE)
      StringCat( str, SysCMsg( MSG_W_SUPERBMAP_STR_SYS ) );

   if (CheckBit( w->Flags, WFLG_OTHER_REFRESH ) == TRUE)
      StringCat( str, SysCMsg( MSG_W_OTHERREF_STR_SYS ) );

   if (CheckBit( w->Flags, WFLG_GIMMEZEROZERO ) == TRUE)
      StringCat( str, SysCMsg( MSG_W_GIMMEZERO_STR_SYS ) );

   return;
}

PRIVATE void SetWindowFlags3( struct Window *w, char *str )
{
   *str = NIL_CHAR;

   if (CheckBit( w->Flags, WFLG_BACKDROP ) == TRUE)
      StringCopy( str, SysCMsg( MSG_W_BACKDROP_STR_SYS ) );

   if (CheckBit( w->Flags, WFLG_REPORTMOUSE ) == TRUE)
      StringCat( str, SysCMsg( MSG_W_REPORTMOUSE_STR_SYS ) );

   if (CheckBit( w->Flags, WFLG_BORDERLESS ) == TRUE)
      StringCat( str, SysCMsg( MSG_W_BORDERLESS_STR_SYS ) );

   if (CheckBit( w->Flags, WFLG_ACTIVATE ) == TRUE)
      StringCat( str, SysCMsg( MSG_W_ACTIVATE_STR_SYS ) );

   if (CheckBit( w->Flags, WFLG_SIZEBRIGHT ) == TRUE)
      StringCat( str, SysCMsg( MSG_W_SIZEBRITE_STR_SYS ) );

   if (CheckBit( w->Flags, WFLG_SIZEBBOTTOM ) == TRUE)
      StringCat( str, SysCMsg( MSG_W_SIZEBOTT_STR_SYS ) );

   return;
}

PRIVATE void SetWindowFlags4( struct Window *w, char *str )
{
   *str = NIL_CHAR;

   if (CheckBit( w->Flags, WFLG_RMBTRAP ) == TRUE)
      StringCopy( str, SysCMsg( MSG_W_RMBTRAP_STR_SYS ) );

   if (CheckBit( w->Flags, WFLG_NOCAREREFRESH ) == TRUE)
      StringCat( str, SysCMsg( MSG_W_NOCAREREF_STR_SYS ) );

   if (CheckBit( w->Flags, WFLG_WINDOWACTIVE ) == TRUE)
      StringCat( str, SysCMsg( MSG_W_WINDOWACTIVE_STR_SYS ) );

   if (CheckBit( w->Flags, WFLG_WBENCHWINDOW ) == TRUE)
      StringCat( str, SysCMsg( MSG_W_WBENCHWIN_STR_SYS ) );

   if (CheckBit( w->Flags, WFLG_HASZOOM ) == TRUE)
      StringCat( str, SysCMsg( MSG_W_HASZOOM_STR_SYS ) );

   if (CheckBit( w->Flags, WFLG_ZOOMED ) == TRUE)
      StringCat( str, SysCMsg( MSG_W_ZOOMED_STR_SYS ) );

   return;
}

PRIVATE void SetIDCMPFlags1( struct Window *w, char *str )
{
   *str = NIL_CHAR;

   if (CheckBit( w->IDCMPFlags, IDCMP_SIZEVERIFY ) == TRUE)
      StringCopy( str, SysCMsg( MSG_ID_SIZEVERIFY_STR_SYS ) );

   if (CheckBit( w->IDCMPFlags, IDCMP_NEWSIZE ) == TRUE)
      StringCat( str, SysCMsg( MSG_ID_NEWSIZE_STR_SYS ) );

   if (CheckBit( w->IDCMPFlags, IDCMP_REFRESHWINDOW ) == TRUE)
      StringCat( str, SysCMsg( MSG_ID_REFRESHW_STR_SYS ) );

   if (CheckBit( w->IDCMPFlags, IDCMP_MOUSEBUTTONS ) == TRUE)
      StringCat( str, SysCMsg( MSG_ID_MOUSEBUTTS_STR_SYS ) );

   return;
}

PRIVATE void SetIDCMPFlags2( struct Window *w, char *str )
{
   *str = NIL_CHAR;

   if (CheckBit( w->IDCMPFlags, IDCMP_MOUSEMOVE ) == TRUE)
      StringCopy( str, SysCMsg( MSG_ID_MOUSEMOVE_STR_SYS ) );

   if (CheckBit( w->IDCMPFlags, IDCMP_GADGETDOWN ) == TRUE)
      StringCat( str, SysCMsg( MSG_ID_GADGETDWN_STR_SYS ) );

   if (CheckBit( w->IDCMPFlags, IDCMP_GADGETUP ) == TRUE)
      StringCat( str, SysCMsg( MSG_ID_GADGETUP_STR_SYS ) );

   if (CheckBit( w->IDCMPFlags, IDCMP_REQSET ) == TRUE)
      StringCat( str, SysCMsg( MSG_ID_REQSET_STR_SYS ) );

   return;
}

PRIVATE void SetIDCMPFlags3( struct Window *w, char *str )
{
   *str = NIL_CHAR;

   if (CheckBit( w->IDCMPFlags, IDCMP_MENUPICK ) == TRUE)
      StringCopy( str, SysCMsg( MSG_ID_MENUPICK_STR_SYS ) );

   if (CheckBit( w->IDCMPFlags, IDCMP_CLOSEWINDOW ) == TRUE)
      StringCat( str, SysCMsg( MSG_ID_CLOSEW_STR_SYS ) );

   if (CheckBit( w->IDCMPFlags, IDCMP_RAWKEY ) == TRUE)
      StringCat( str, SysCMsg( MSG_ID_RAWKEY_STR_SYS ) );

   if (CheckBit( w->IDCMPFlags, IDCMP_REQVERIFY ) == TRUE)
      StringCat( str, SysCMsg( MSG_ID_REQVERIFY_STR_SYS ) );

   return;
}

PRIVATE void SetIDCMPFlags4( struct Window *w, char *str )
{
   *str = NIL_CHAR;

   if (CheckBit( w->IDCMPFlags, IDCMP_REQCLEAR ) == TRUE)
      StringCopy( str, SysCMsg( MSG_ID_REQCLEAR_STR_SYS ) );

   if (CheckBit( w->IDCMPFlags, IDCMP_MENUVERIFY ) == TRUE)
      StringCat( str, SysCMsg( MSG_ID_MENUVERIFY_STR_SYS ) );

   if (CheckBit( w->IDCMPFlags, IDCMP_NEWPREFS ) == TRUE)
      StringCat( str, SysCMsg( MSG_ID_NEWPREFS_STR_SYS ) );

   if (CheckBit( w->IDCMPFlags, IDCMP_DISKINSERTED ) == TRUE)
      StringCat( str, SysCMsg( MSG_ID_DISKINS_STR_SYS ) );

   return;
}

PRIVATE void SetIDCMPFlags5( struct Window *w, char *str )
{
   *str = NIL_CHAR;

   if (CheckBit( w->IDCMPFlags, IDCMP_DISKREMOVED ) == TRUE)
      StringCopy( str, SysCMsg( MSG_ID_DISKREM_STR_SYS ) );

   if (CheckBit( w->IDCMPFlags, IDCMP_WBENCHMESSAGE ) == TRUE)
      StringCat( str, SysCMsg( MSG_ID_WBENCHMSG_STR_SYS ) );

   if (CheckBit( w->IDCMPFlags, IDCMP_ACTIVEWINDOW ) == TRUE)
      StringCat( str, SysCMsg( MSG_ID_ACTIVEW_STR_SYS ) );

   if (CheckBit( w->IDCMPFlags, IDCMP_INACTIVEWINDOW ) == TRUE)
      StringCat( str, SysCMsg( MSG_ID_INACTIVEW_STR_SYS ) );

   return;
}

PRIVATE void SetIDCMPFlags6( struct Window *w, char *str )
{
   *str = NIL_CHAR;

   if (CheckBit( w->IDCMPFlags, IDCMP_DELTAMOVE ) == TRUE)
      StringCopy( str, SysCMsg( MSG_ID_DELTAMOVE_STR_SYS ) );

   if (CheckBit( w->IDCMPFlags, IDCMP_VANILLAKEY ) == TRUE)
      StringCat( str, SysCMsg( MSG_ID_VANILLA_STR_SYS ) );

   if (CheckBit( w->IDCMPFlags, IDCMP_INTUITICKS ) == TRUE)
      StringCat( str, SysCMsg( MSG_ID_INTUITICKS_STR_SYS ) );

   if (CheckBit( w->IDCMPFlags, IDCMP_IDCMPUPDATE ) == TRUE)
      StringCat( str, SysCMsg( MSG_ID_UPDATE_STR_SYS ) );

   return;
}

PRIVATE void SetIDCMPFlags7( struct Window *w, char *str )
{
   *str = NIL_CHAR;

   if (CheckBit( w->IDCMPFlags, IDCMP_MENUHELP ) == TRUE)
      StringCopy( str, SysCMsg( MSG_ID_MENUHELP_STR_SYS ) );

   if (CheckBit( w->IDCMPFlags, IDCMP_CHANGEWINDOW ) == TRUE)
      StringCat( str, SysCMsg( MSG_ID_CHGWINDOW_STR_SYS ) );

   if (CheckBit( w->IDCMPFlags, IDCMP_GADGETHELP ) == TRUE)
      StringCat( str, SysCMsg( MSG_ID_GADGETHELP_STR_SYS ) );

   return;
}

PRIVATE char bf[82] = { 0, }, *itxt  = &bf[0];
PRIVATE char tx[82] = { 0, }, *title = &tx[0];

PRIVATE void DisplayStructure( void *ptr, int struct_type )
{
   struct Screen *s = NULL;
   struct Window *w = NULL;
   struct Task   *t = NULL;
  
   int            bgad, sgad, pgad, m, mi;
  
   bgad = sgad = pgad = m = mi = 0;
   
   switch (struct_type)
      {
      case SCREEN_DATA:
         s = (struct Screen *) ptr;

         sprintf( title, SysCMsg( MSG_FMT_SCREENADDR_SYS ), s, s->Title );

         StringCopy( IWTitle, title );
         SetWindowTitles( IWnd, title, (UBYTE *) -1 );

         sprintf( itxt, SysCMsg( MSG_FMT_DEFAULTTITLE_SYS ), s->DefaultTitle );

         WriteText( itxt, XPOS, StrYPos[0], 2 ); 

         sprintf( itxt, SysCMsg( MSG_FMT_SCRNCOORDS_SYS ), 
                  s->LeftEdge, s->TopEdge, s->Width, s->Height 
                );
                
         WriteText( itxt, XPOS, StrYPos[1], 1 ); 

         sprintf( itxt, SysCMsg( MSG_FMT_SCRNBLEFT_SYS ), 
                  s->WBorLeft, s->WBorTop
                );
                
         WriteText( itxt, XPOS, StrYPos[2], 1 ); 

         sprintf( itxt, SysCMsg( MSG_FMT_SCRNBRITE_SYS ), 
                  s->WBorRight, s->WBorBottom
                );

         WriteText( itxt, XPOS, StrYPos[3], 1 ); 

         sprintf( itxt, SysCMsg( MSG_FMT_SCREENPENS_SYS ), 
                  s->DetailPen, s->BlockPen
                );
                
         WriteText( itxt, XPOS, StrYPos[4], 1 ); 

         sprintf( itxt, SysCMsg( MSG_FMT_SCRNVIEWADDR_SYS ), 
                  s->ViewPort, s->RastPort
                );
                
         WriteText( itxt, XPOS, StrYPos[5], 1 ); 

         sprintf( itxt, SysCMsg( MSG_FMT_SCRNBMAPADDR_SYS ), 
                  s->BitMap, s->LayerInfo
                );
                
         WriteText( itxt, XPOS, StrYPos[6], 1 ); 

         sprintf( itxt, SysCMsg( MSG_FMT_SCRNEXTDATA_SYS ), 
                  s->ExtData, s->UserData
                );
                
         WriteText( itxt, XPOS, StrYPos[7], 1 ); 

         sprintf( itxt, SysCMsg( MSG_FMT_SCRNNEXTADDR_SYS ), 
                  s->NextScreen, s->FirstWindow
                );
                
         WriteText( itxt, XPOS, StrYPos[8], 2 ); 

         sprintf( itxt, SysCMsg( MSG_FMT_SCRNBARS_SYS ), 
                  s->BarHeight, s->BarVBorder, s->BarHBorder
                );
                
         WriteText( itxt, XPOS, StrYPos[9], 1 ); 

         sprintf( itxt, SysCMsg( MSG_FMT_SCRNMENCOORDS_SYS ), 
                  s->MenuVBorder, s->MenuHBorder
                );
                
         WriteText( itxt, XPOS, StrYPos[10], 1 ); 

         WriteText( SysCMsg( MSG_FLAGS_COLON_SYS ), XPOS, StrYPos[11], 3 );
         
         SetScreenFlagString( itxt, s );
         WriteText( itxt, XPOS, StrYPos[12], 1 );

         WriteText( SysCMsg( MSG_VIEWMODES_COLON_SYS ), XPOS, StrYPos[13], 3 );

         SetScreenViewMode1( itxt, s );
         WriteText( itxt, XPOS, StrYPos[14], 1 );

         SetScreenViewMode2( itxt, s );
         WriteText( itxt, XPOS, StrYPos[15], 1 );

         WriteText( SysCMsg( MSG_PRESS_CLOSEGADGET_SYS ), 150, StrYPos[16], 2 ); 
         break;

      case WINDOW_DATA:
         w = (struct Window *) ptr;

         sprintf( title, SysCMsg( MSG_FMT_WINDOWADDR_SYS ), w, w->Title );

         StringCopy( IWTitle, title );

         SetWindowTitles( IWnd, title, (UBYTE *) -1 );

         sprintf( itxt, SysCMsg( MSG_FMT_WSCRNADDR_SYS ), 
                  w->WScreen, w->WScreen->Title 
                );

         WriteText( itxt, XPOS, StrYPos[0], 2 ); 

         sprintf( itxt, SysCMsg( MSG_FMT_WINDOWCOORDS_SYS ),
                  w->LeftEdge, w->TopEdge, w->Width, w->Height 
                );

         WriteText( itxt, XPOS, StrYPos[1], 1 ); 

         sprintf( itxt, SysCMsg( MSG_FMT_WINDOWMINCRDS_SYS ),
                  w->MinWidth, w->MinHeight, w->MaxWidth, w->MaxHeight 
                );

         WriteText( itxt, XPOS, StrYPos[2], 1 ); 

         sprintf( itxt, SysCMsg( MSG_FMT_WINDOWBDRCRDS_SYS ),
                  w->BorderLeft, w->BorderTop, 
                  w->BorderRight, w->BorderBottom
                );

         WriteText( itxt, XPOS, StrYPos[3], 1 ); 

         sprintf( itxt, SysCMsg( MSG_FMT_WINDOWOFFSETS_SYS ),
                  w->XOffset, w->YOffset, w->DetailPen, w->BlockPen
                );

         WriteText( itxt, XPOS, StrYPos[4], 1 ); 

         sprintf( itxt, SysCMsg( MSG_FMT_WINDOWCHKADDR_SYS ),
                  w->CheckMark, w->ExtData, w->UserData
                );

         WriteText( itxt, XPOS, StrYPos[5], 2 ); 

         CountGadgets( w, &bgad, &sgad, &pgad );

         sprintf( itxt, SysCMsg( MSG_FMT_WINDOWGADCNTS_SYS ),
                  bgad, sgad, pgad
                );

         WriteText( itxt, XPOS, StrYPos[6], 1 ); 

         CountMenus( w, &m, &mi );

         sprintf( itxt, SysCMsg( MSG_FMT_WINDOWMENCNTS_SYS ), m, mi );

         WriteText( itxt, XPOS, StrYPos[7], 1 ); 

         t = (struct Task *) w->UserPort->mp_SigTask;

         sprintf( itxt, SysCMsg( MSG_FMT_WINDOWUPORT_SYS ),
                  w->UserPort, w->UserPort->mp_SigTask,
                  (t == NULL ? ONE_SPACE : t->tc_Node.ln_Name)
                );

         WriteText( itxt, XPOS, StrYPos[8], 2 ); 

         t = (struct Task *) w->WindowPort->mp_SigTask;
         
         sprintf( itxt, SysCMsg( MSG_FMT_WINDOWWPORT_SYS ),
                  w->WindowPort, w->WindowPort->mp_SigTask,
                  (t == NULL ? ONE_SPACE : t->tc_Node.ln_Name) 
                );

         WriteText( itxt, XPOS, StrYPos[9], 2 ); 

         sprintf( itxt, SysCMsg( MSG_FMT_WINDOWPTRCRDS_SYS ),
                  w->PtrHeight, w->PtrWidth, w->Pointer
                );

         WriteText( itxt, XPOS, StrYPos[10], 1 ); 

         sprintf( itxt, SysCMsg( MSG_FMT_WINDOWREQCNT_SYS ),
                  w->ReqCount, w->NextWindow
                );
                
         WriteText( itxt, XPOS, StrYPos[11], 1 ); 

         WriteText( SysCMsg( MSG_FLAGS_COLON_SYS ), XPOS, StrYPos[12], 3 );

         SetWindowFlags1( w, itxt );
         WriteText( itxt, XPOS, StrYPos[13], 1 ); 

         SetWindowFlags2( w, itxt );
         WriteText( itxt, XPOS, StrYPos[14], 1 ); 

         SetWindowFlags3( w, itxt );
         WriteText( itxt, XPOS, StrYPos[15], 1 ); 

         SetWindowFlags4( w, itxt );
         WriteText( itxt, XPOS, StrYPos[16], 1 ); 

         WriteText( SysCMsg( MSG_IDCMPFLAGS_COLON_SYS ), XPOS, StrYPos[17], 3 );

         SetIDCMPFlags1( w, itxt );
         WriteText( itxt, XPOS, StrYPos[18], 1 ); 

         SetIDCMPFlags2( w, itxt );
         WriteText( itxt, XPOS, StrYPos[19], 1 ); 

         SetIDCMPFlags3( w, itxt );
         WriteText( itxt, XPOS, StrYPos[20], 1 ); 

         SetIDCMPFlags4( w, itxt );
         WriteText( itxt, XPOS, StrYPos[21], 1 ); 

         SetIDCMPFlags5( w, itxt );
         WriteText( itxt, XPOS, StrYPos[22], 1 ); 

         SetIDCMPFlags6( w, itxt );
         WriteText( itxt, XPOS, StrYPos[23], 1 ); 

         SetIDCMPFlags7( w, itxt );
         WriteText( itxt, XPOS, StrYPos[24], 1 ); 

         WriteText( SysCMsg( MSG_PRESS_CLOSEGADGET_SYS ), 150, StrYPos[25], 2 ); 
         break;
      
      case TASK_DATA:
         WriteTask( ptr );
         SetWindowTitles( IWnd, IWTitle, (UBYTE *) 0xFFFFFFFF );
         break;

      case PROCESS_DATA:
         WriteTask( ptr );
         SetWindowTitles( IWnd, IWTitle, (UBYTE *) 0xFFFFFFFF );
         break;
      }

   return;
}

// ----------------------------------------------------------------------

PRIVATE int HandleWindowInfo( void *structptr, int whichdisplay )
{
   int rval = 0;
   
   switch (whichdisplay)
      {
      case SCREEN_DATA:
         rval = OpenIWindow( 16 );
         break;

      case WINDOW_DATA:
         rval = OpenIWindow( 25 );
         break;

      case TASK_DATA:
         rval = OpenIWindow( 13 );
         break;

      case PROCESS_DATA:
         rval = OpenIWindow( 28 );
         break;
      }
   
   if (rval < 0)
      {
      NotOpened( 1 );

      return( -1 );
      }

   SetNotifyWindow( IWnd );
   DisplayStructure( structptr, whichdisplay );
      
   (void) HandleFullInfoIDCMP();

   return( FALSE );
}

// ----------------------------------------------------------------------

PRIVATE int OpenInfoWindow( void )
{
//   IMPORT struct Gadget *CreateContext( struct Gadget ** );

   struct NewGadget  ng = { 0, };
   struct Gadget    *g  = (struct Gadget *) NULL;
   UWORD             lc = 0, tc = 0;
   UWORD             wleft = WLeft, wtop = WTop, ww, wh;

   ComputeFont( Scr, Font, &CFont, WWidth, WHeight );

   ww = ComputeX( CFont.FontX, WWidth );
   wh = ComputeY( CFont.FontY, WHeight );

   if ((wleft + ww + CFont.OffX + Scr->WBorRight) > Scr->Width)
      wleft = Scr->Width - ww;

   if ((wtop + wh + CFont.OffY + Scr->WBorBottom) > Scr->Height)
      wtop = Scr->Height - wh;

   if (!(g = CreateContext( &GList ))) // == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < I_CNT; lc++)
      {
      CopyMem( (char *) &InfoNGad[ lc ], (char *) &ng, 
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

      InfoGadgets[ lc] = 
                    g  = CreateGadgetA( (ULONG) InfoGTypes[ lc ], 
                           g, 
                           &ng, 
                           (struct TagItem *) &InfoGTags[ tc ] );

      while (InfoGTags[tc] != TAG_DONE)
         tc += 2;

      tc++;

      if (!g) // == NULL)
         return( -2 );
      }

   if (InfoType == TASK_PROC_TYPE)
      StringNCopy( &WTitle[0], SysCMsg( MSG_TASKS_TITLE_SYS ), 80 );
   else
      StringNCopy( &WTitle[0], SysCMsg( MSG_SCREENS_TITLE_SYS ), 80 );

   if (!(Wnd = OpenWindowTags( NULL,
                         
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
                  
                  WA_Gadgets,      GList,
                  WA_CustomScreen, Scr,
                  WA_Title,        WTitle,
                  TAG_DONE )
      )) // == NULL)
      return( -4 );

   GT_RefreshWindow( Wnd, NULL );
   SetNotifyWindow( Wnd );

   return( 0 );
}

PRIVATE void ClearNodeStrs( void )
{
   int i;
   
   for (i = 1; i <= MAXNODE; i++)
      NodeStrs[ i * 80 ] = NIL_CHAR; // Kill old ListView strings.

   return;
}


PRIVATE int MakeTaskList( void )
{
   struct Task *readytasks = NULL;
   struct Task *waitgtasks = NULL;
   struct Task *crnttask   = NULL;
   struct Node *ptr        = NULL;

   char        *tskstate = NULL;
   int          numitems = 0, i = 1;
   int          up, down;
        

   ClearNodeStrs();

   Forbid();
#    ifdef  __SASC
     crnttask = SysBase->ThisTask;
#    else
     crnttask = ((struct ExecBase *) IExec->Data.LibBase)->ThisTask;
#    endif

     up   = (int) crnttask->tc_SPUpper;
     down = (int) crnttask->tc_SPLower;

     sprintf( &NodeStrs[ i++ * 80 ], 
              "%08LX+ %4d %6u %08LX %-9.9s %-7.7s %-30.30s",
              crnttask, 
              crnttask->tc_Node.ln_Pri, 
              up - down,
              crnttask->tc_SigAlloc,
              GetTaskState( crnttask ),
              GetTask_Process( crnttask->tc_Node.ln_Type ),
              crnttask->tc_Node.ln_Name
            );
     
     numitems++;

#    ifdef __SASC
     ptr = SysBase->TaskReady.lh_Head;
#    else
     ptr = ((struct ExecBase *) IExec->Data.LibBase)->TaskReady.lh_Head;
#    endif

     readytasks = (struct Task *) ptr;

     while (ptr) // != NULL)
        {
        up   = (int) readytasks->tc_SPUpper;
        down = (int) readytasks->tc_SPLower;

        tskstate = GetTaskState( readytasks );

        if (DispTaskFlag == TRUE)
           sprintf( &NodeStrs[ i++ * 80 ], 
                    "%08LX  %4d %6u %08LX %-9.9s %-7.7s %-30.30s",
                    readytasks, 
                    readytasks->tc_Node.ln_Pri, 
                    up - down,
                    readytasks->tc_SigAlloc,
                    tskstate,
                    GetTask_Process( readytasks->tc_Node.ln_Type ),
                    readytasks->tc_Node.ln_Name
                  );
             
        // point to next node in list:
        ptr        = ptr->ln_Succ;
        readytasks = (struct Task *) ptr;
        numitems++;
        }

#    ifdef __SASC
     ptr = SysBase->TaskWait.lh_Head;
#    else
     ptr = ((struct ExecBase *) IExec->Data.LibBase)->TaskWait.lh_Head;
#    endif

     waitgtasks = (struct Task *) ptr;

     while (ptr) // != NULL)
        {
        up   = (int) waitgtasks->tc_SPUpper;
        down = (int) waitgtasks->tc_SPLower;

        tskstate = GetTaskState( waitgtasks );

        if (DispTaskFlag == TRUE)
           sprintf( &NodeStrs[ i++ * 80 ], 
                    "%08LX  %4d %6u %08LX %-9.9s %-7.7s %-30.30s",
                    waitgtasks, 
                    waitgtasks->tc_Node.ln_Pri, 
                    up - down,
                    waitgtasks->tc_SigAlloc,
                    GetTaskState( waitgtasks ),
                    GetTask_Process( waitgtasks->tc_Node.ln_Type ),
                    waitgtasks->tc_Node.ln_Name
                  );
             
        // point to next node in list:
        ptr        = ptr->ln_Succ;
        waitgtasks = (struct Task *) ptr;

        numitems++;
        }

   Permit();

   return( numitems );
}

PRIVATE int CountWindows( struct Screen *scr )
{
   struct Window *w    = NULL;
   int            rval = 0;
   
   if (scr) // != NULL)
      w = scr->FirstWindow;
   else
      return( rval );

   while (w) // != NULL)
      {
      rval++;
      w = w->NextWindow;
      }

   return( rval );
}

PRIVATE int CountScreens( struct Screen *firstscreen )
{
   int rval = 0;
   
   while (firstscreen) // != NULL)
      {
      rval++;
      firstscreen = firstscreen->NextScreen;
      }

   return( rval );
}

PRIVATE int MakeScrWindowList( void )
{
   struct Screen *firstscr  = NULL;
   struct Screen *tempscr   = NULL;
   struct Screen *activescr = NULL;
   struct Window *activewnd = NULL;
   struct Screen *s         = NULL;

   ULONG          ilock       = 0L;
   int            i, numitems = 0;
   int            j, scrcount = 0;

   ClearNodeStrs();

   /* The following code works without the calls to LockIBase() &
   ** UnlockIBase() just fine.  They are here just in case:
   */

   ilock = LockIBase( 0 );

#    ifdef __SASC
     firstscr  = IntuitionBase->FirstScreen;
     activescr = IntuitionBase->ActiveScreen;
     activewnd = IntuitionBase->ActiveWindow;
#    else
     firstscr  = ((struct IntuitionBase *) IIntuition->Data.LibBase)->FirstScreen;
     activescr = ((struct IntuitionBase *) IIntuition->Data.LibBase)->ActiveScreen;
     activewnd = ((struct IntuitionBase *) IIntuition->Data.LibBase)->ActiveWindow;
#    endif

     scrcount  = CountScreens( firstscr );
     tempscr   = firstscr;     
     numitems  = scrcount;
          
     for (j = 0; j < scrcount; j++)
        {
        numitems += CountWindows( tempscr );
        tempscr   = tempscr->NextScreen;
        }

     s = firstscr;
     i = 1;

     do {
        struct Window *w = s->FirstWindow;

        if (s == activescr)
           sprintf( &NodeStrs[ i++ * 80 ], 
                    "%08LX+ %3u,%3u %4u,%4u %08LX 00000000 S: %-30.30s",
                    s, s->LeftEdge, s->TopEdge, s->Width, s->Height,
                    s->Flags, s->Title
                  );
        else
           sprintf( &NodeStrs[ i++ * 80 ], 
                    "%08LX  %3u,%3u %4u,%4u %08LX 00000000 S: %-30.30s",
                    s, s->LeftEdge, s->TopEdge, s->Width, s->Height,
                    s->Flags, s->Title
                  );
        do {

           if (w == activewnd)
              sprintf( &NodeStrs[ i++ * 80 ], 
                       "%08LX+ %3u,%3u %4u,%4u %08LX %08LX W: %-30.30s",
                       w, w->LeftEdge, w->TopEdge, w->Width, w->Height,
                       w->Flags, w->IDCMPFlags, w->Title
                     );
           else
              sprintf( &NodeStrs[ i++ * 80 ], 
                       "%08LX  %3u,%3u %4u,%4u %08LX %08LX W: %-30.30s",
                       w, w->LeftEdge, w->TopEdge, w->Width, w->Height,
                       w->Flags, w->IDCMPFlags, w->Title
                     );
           
           w = w->NextWindow;

           } while ((w != NULL) && (i <= MAXNODE));

        s = s->NextScreen;

        } while (s && (i <= MAXNODE));
        
   UnlockIBase( ilock );

   return( numitems );
}

// ------------------ InfoList Gadget functions: -----------------------

PRIVATE int ILVClicked( int itemnum )
{
   ULONG addr = 0L;
   
//#  ifdef DEBUG
//   fprintf( stderr, "%-80.80s\n", InfoLVNodes[ itemnum ].ln_Name );
//#  endif

   if (itemnum == 0)   
      {
      GT_SetGadgetAttrs( InfoGadgets[ IMoreBt ], Wnd, NULL,
                         GA_Disabled, TRUE, TAG_DONE 
                       );

      return( (int) TRUE );
      }
   else
      {
#     ifndef __SASC
      char **end = &InfoLVNodes[ itemnum ].ln_Name;
#     endif
 
      GT_SetGadgetAttrs( InfoGadgets[ IMoreBt ], Wnd, NULL,
                         GA_Disabled, FALSE, TAG_DONE 
                       );

      GT_SetGadgetAttrs( InfoGadgets[ ISelection ], Wnd, NULL,
                         GTTX_Text, InfoLVNodes[ itemnum ].ln_Name, 
                         TAG_DONE
                       );

      // Now get address from the item:
#     ifdef __SASC
      (void) stch_l( InfoLVNodes[ itemnum ].ln_Name, (long *) &addr );
#     else
      addr = strtoul( InfoLVNodes[ itemnum ].ln_Name, end, 16 );
#     endif

      TaskAddress = addr;
      SWinAddress = addr;
      }

   if (InfoType == SCRN_WIND_TYPE)
      {
      if (IsScreen( SWinAddress ) == TRUE)
         SWinType = SCRN_TYPE;
      else
         SWinType = WIND_TYPE;
      }

   return( (int) TRUE );
}

PRIVATE void CloseInfoWindow( void )
{
   if (Wnd) // != NULL)
      {
      CloseWindow( Wnd );
      Wnd = NULL;
      }

   if (GList) // != NULL)
      {
      FreeGadgets( GList );
      GList = NULL;
      }
   
   SetNotifyWindow( ATWnd );

   return;
}

PRIVATE int InfoCloseWindow( void )
{
   CloseInfoWindow();
   return( (int) FALSE );
}

PRIVATE int UpdateClicked( int dummy )
{
   GT_SetGadgetAttrs( InfoGadgets[ ISelection ], Wnd, NULL,
                      GTTX_Text, NULL,
                      TAG_DONE
                    );

   ClearNodeStrs();

   // Make the list:
   if (InfoType == TASK_PROC_TYPE)
      (void) MakeTaskList();
   else
      (void) MakeScrWindowList();

   GT_RefreshWindow( Wnd, NULL );

   return( (int) TRUE );
}

PRIVATE int MoreClicked( int dummy )
{
   if (InfoType == TASK_PROC_TYPE)
      {
      if (((struct Task *) TaskAddress)->tc_Node.ln_Type == NT_PROCESS)
         (void) HandleWindowInfo( (void *) TaskAddress, 3 ); // Process
      else
         (void) HandleWindowInfo( (void *) TaskAddress, 2 ); // Task
      }
   else
      {
      if (SWinType == SCRN_TYPE)
         (void) HandleWindowInfo( (void *) SWinAddress, 0 ); // Screen
      else
         (void) HandleWindowInfo( (void *) SWinAddress, 1 ); // Window
      }

   SetWindowTitles( Wnd, WTitle, (UBYTE *) 0xFFFFFFFF );   

   return( (int) TRUE );
}

// ------------------ END of TaskList Gadget functions. ---------------

SUBFUNC int InfoVanillaKey( int whichkey )
{
   int rval = TRUE;
   
   switch (whichkey)
      {
      case CAP_U_CHAR: // Update
      case SMALL_U_CHAR:
         rval = UpdateClicked( 0 );
         break;
            
      case CAP_M_CHAR: // Update
      case SMALL_M_CHAR:
         rval = MoreClicked( 0 );
         break;

      case CAP_X_CHAR: // Close the Window synonyms:
      case SMALL_X_CHAR:
      case CAP_D_CHAR:
      case SMALL_D_CHAR:
      case CAP_Q_CHAR:
      case SMALL_Q_CHAR:
         rval = InfoCloseWindow();
         break;         
      }
   
   return( rval );
}
 
PRIVATE int HandleInfoIDCMP( void )
{
   struct IntuiMessage *m = NULL;
   int                (*func)( int );
   BOOL                 running = TRUE;

   while (running == TRUE)
      {
      if (!(m = GT_GetIMsg( Wnd->UserPort ))) // == NULL)
         {
         (void) Wait( 1L << Wnd->UserPort->mp_SigBit );

         continue;
         }

      CopyMem( (char *) m, (char *) &IMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (IMsg.Class)
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( Wnd );
            GT_EndRefresh( Wnd, TRUE );
            break;

         case IDCMP_VANILLAKEY:
            running = InfoVanillaKey( IMsg.Code );
            break;
             
         case IDCMP_CLOSEWINDOW:
            running = InfoCloseWindow();
            break;

         case IDCMP_GADGETUP:
         case IDCMP_GADGETDOWN:
            func    = (int (*)( int )) ((struct Gadget *) IMsg.IAddress)->UserData;
	    
	    if (func)
               running = func( IMsg.Code );
   
            break;
         }
      }

   return( running );
}

PRIVATE int HandleInfoListView( void )
{
   int i = 0;
   
   InfoLVNode.ln_Succ = (struct Node *) InfoLVList.mlh_Tail;
   InfoLVNode.ln_Pred = (struct Node *) InfoLVList.mlh_Head;
   InfoLVNode.ln_Type = 0;
   InfoLVNode.ln_Pri  = 100;

   if (InfoType == TASK_PROC_TYPE)
      InfoLVNode.ln_Name = SysCMsg( MSG_ADDRESS_PRI_STR_SYS );
   else
      InfoLVNode.ln_Name = SysCMsg( MSG_ADDRESS_POS_STR_SYS );
   
   InfoLVNodes[0] = InfoLVNode;

   if (OpenInfoWindow() < 0)
      {
      NotOpened( 1 );
 
      return( -1 );
      }
   
   SetNotifyWindow( Wnd );

   ClearNodeStrs(); // Kill any old information.

   for (i = 1; i <= MAXNODE; i++)
      {
      InfoLVNodes[i].ln_Name = &NodeStrs[ i * 80 ];
      InfoLVNodes[i].ln_Pri  = MAXNODE - i;
      }

   NewList( (struct List *) &InfoLVList );      

   for (i = 0; i < MAXNODE; i++)
      Enqueue( (struct List *) &InfoLVList, &InfoLVNodes[ i ] );

   // Make the list:
   if (InfoType == TASK_PROC_TYPE)
      (void) MakeTaskList();   
   else
      (void) MakeScrWindowList();
      
   ModifyListView( InfoGadgets[ InfoLV ], Wnd, 
                   (struct List *) &InfoLVList, NULL
                 );

   GT_RefreshWindow( Wnd, NULL );

   (void) HandleInfoIDCMP();

   if (InfoType == TASK_PROC_TYPE)   
      return( TaskAddress ); // The last thing the User selected.
   else
      return( SWinAddress );
}

SUBFUNC int CountTasks_Processes( int whichType )
{
   struct Task *task  = NULL;
   int          count = 0;

#  ifdef __amigaos4__
   struct ExecBase *ebPtr = (struct ExecBase *) IExec->Data.LibBase;
#  else
   struct ExecBase *ebPtr = SysBase;
#  endif
   
   if (whichType == TASK_DATA)
      {
      Forbid();

         if ((task = (struct Task *) ebPtr->ThisTask) && (task->tc_Node.ln_Type == NT_TASK))
            count++;

         task = (struct Task *) (ebPtr->TaskReady.lh_Head);      

         while (task) // != NULL)
            {
            if (task->tc_Node.ln_Type == NT_TASK)
               {
               count++;
               }

            task = (struct Task *) (task->tc_Node.ln_Succ);
            }

         task = (struct Task *) (ebPtr->TaskWait.lh_Head);      

         while (task) // != NULL)
            {
            if (task->tc_Node.ln_Type == NT_TASK)
               {
               count++;
               }

            task = (struct Task *) (task->tc_Node.ln_Succ);
            }

      Permit();
      }
   else // PROCESS_DATA:
      {
      Forbid();

         if ((task = (struct Task *) ebPtr->ThisTask) && (task->tc_Node.ln_Type == NT_PROCESS))
            count++;

         task = (struct Task *) (ebPtr->TaskReady.lh_Head);      

         while (task) // != NULL)
            {
            if (task->tc_Node.ln_Type == NT_PROCESS)
               {
               count++;
               }

            task = (struct Task *) (task->tc_Node.ln_Succ);
            }

         task = (struct Task *) (ebPtr->TaskWait.lh_Head);      

         while (task) // != NULL)
            {
            if (task->tc_Node.ln_Type == NT_PROCESS)
               {
               count++;
               }

            task = (struct Task *) (task->tc_Node.ln_Succ);
            }

      Permit();
      }

   return( count );
}
     
SUBFUNC OBJECT *MakeTaskProcessArray( int whichType )
{
   struct Task *task  = NULL;
   int          count = CountTasks_Processes( whichType );
   OBJECT      *rval  = new_array( count, FALSE );   
   int          i     = 0;

#  ifdef __amigaos4__
   struct ExecBase *ebPtr = (struct ExecBase *) IExec->Data.LibBase;
#  else
   struct ExecBase *ebPtr = SysBase;
#  endif
   
   if (whichType == TASK_DATA)
      {
      Forbid();

         if ((task = (struct Task *) ebPtr->ThisTask) && (task->tc_Node.ln_Type == NT_TASK))
            {
            rval->inst_var[i] = new_int( (int) task );
            i++;
            }
            
         task = (struct Task *) (ebPtr->TaskReady.lh_Head);

         while (task) // != NULL)
            {
            if (task->tc_Node.ln_Type == NT_TASK)
               {
               rval->inst_var[i] = new_int( (int) task );
               i++;
               }

            task = (struct Task *) (task->tc_Node.ln_Succ);
            }

         task = (struct Task *) (ebPtr->TaskWait.lh_Head);

         while (task) // != NULL)
            {
            if (task->tc_Node.ln_Type == NT_TASK)
               {
               rval->inst_var[i] = new_int( (int) task );
               i++;
               }

            task = (struct Task *) (task->tc_Node.ln_Succ);
            }

      Permit();
      }
   else  // PROCESS_DATA:
      {
      Forbid();

         if ((task = (struct Task *) ebPtr->ThisTask) && (task->tc_Node.ln_Type == NT_PROCESS))
            {
            rval->inst_var[i] = new_int( (int) task );
            i++;
            }
            
         task = (struct Task *) (ebPtr->TaskReady.lh_Head);

         while (task) // != NULL)
            {
            if (task->tc_Node.ln_Type == NT_PROCESS)
               {
               rval->inst_var[i] = new_int( (int) task );
               i++;
               }

            task = (struct Task *) (task->tc_Node.ln_Succ);
            }

         task = (struct Task *) (ebPtr->TaskWait.lh_Head);

         while (task) // != NULL)
            {
            if (task->tc_Node.ln_Type == NT_PROCESS)
               {
               rval->inst_var[i] = new_int( (int) task );
               i++;
               }

            task = (struct Task *) (task->tc_Node.ln_Succ);
            }

      Permit();
      }

   return( rval );
}

SUBFUNC OBJECT *MakeScrWindowArray( int whichType )
{
   OBJECT *rval  = o_nil;
   ULONG   ilock = 0L;
   int     count = 0, i = 0;
      
   if (whichType == SCREEN_DATA)
      {
      struct Screen *scr = (struct Screen *) NULL;
      
      ilock = LockIBase( 0 );

#        ifdef __SASC
         scr = IntuitionBase->FirstScreen;
#        else
         scr = ((struct IntuitionBase *) IIntuition->Data.LibBase)->FirstScreen;
#        endif

         count = CountScreens( scr );
         rval  = new_array( count, FALSE );

         for (i = 0; (i < count) && (scr != NULL); i++)
            {
            rval->inst_var[i] = new_int( (int) scr );
            scr               = scr->NextScreen;
            }

      UnlockIBase( ilock );
      }
   else
      {
      // WINDOW_DATA:
      struct Screen *scr = NULL;
      struct Window *win = NULL;
            
      ilock = LockIBase( 0 );

#        ifdef __SASC
         scr = IntuitionBase->FirstScreen;
#        else
         scr = ((struct IntuitionBase *) IIntuition->Data.LibBase)->FirstScreen;
#        endif
 
         while (scr) // != NULL)
            {
            count += CountWindows( scr );
            scr    = scr->NextScreen;
            }

         rval = new_array( count, FALSE );

#        ifdef __SASC
         scr = IntuitionBase->FirstScreen; // Setup next loop...
#        else
         scr = ((struct IntuitionBase *) IIntuition->Data.LibBase)->FirstScreen;
#        endif
         
	 i = 0;
            
         while (scr) // != NULL)
            {
            win = scr->FirstWindow;
               
            while (win) // != NULL)
               {
               rval->inst_var[i] = new_int( (int) win );
               win               = win->NextWindow;
               i++;
               }

            scr = scr->NextScreen;
            }

      UnlockIBase( ilock );
      }

   return( rval );
}

SUBFUNC int CountDevices( void )
{
   struct Node *device = NULL;
   int          count  = 0;

#  ifdef __amigaos4__
   struct ExecBase *ebPtr = (struct ExecBase *) IExec->Data.LibBase;
#  else
   struct ExecBase *ebPtr = SysBase;
#  endif

   Forbid();

      device = ebPtr->DeviceList.lh_Head;

      while (device) // != NULL)
         {
         if (device->ln_Type == NT_DEVICE)
            {
            count++;
            }

         device = device->ln_Succ;
         }

   Permit();

   return( count );
}

// ------------ Method calls: -------------------------------------------

METHODFUNC OBJECT *getDeviceList( void )
{
   struct Node *device = NULL;
   int          count  = CountDevices();
   OBJECT      *rval   = AssignObj( new_array( count, FALSE ) );   
   int          i      = 0;

#  ifdef __amigaos4__
   struct ExecBase *ebPtr = (struct ExecBase *) IExec->Data.LibBase;
#  else
   struct ExecBase *ebPtr = SysBase;
#  endif
   
   Forbid();

      device = ebPtr->DeviceList.lh_Head;

      while (device) // != NULL)
         {
         if (device->ln_Type == NT_DEVICE)
            {
            rval->inst_var[i] = AssignObj( new_address( (ULONG) device ) );
            i++;
            }

         device = device->ln_Succ;
         }

   Permit();

   return( rval );
}

METHODFUNC OBJECT *getAddressList( int whatType )
{
   OBJECT *rval = o_nil;
      
   switch (whatType)
      {
      case PROCESS_DATA:
         rval = MakeTaskProcessArray( PROCESS_DATA );
         break;
               
      case TASK_DATA:
         rval = MakeTaskProcessArray( TASK_DATA );
         break;
               
      case SCREEN_DATA:
         rval = MakeScrWindowArray( SCREEN_DATA );
         break;

      case WINDOW_DATA:
         rval = MakeScrWindowArray( WINDOW_DATA );
         break;
      }

   return( rval );
}

METHODFUNC OBJECT *getProcessAddress( char *name )
{
   return( getTPAddress( name, NT_PROCESS ) );
}
               
METHODFUNC OBJECT *getTaskAddress( char *name )
{
   return( getTPAddress( name, NT_TASK ) );
}

METHODFUNC OBJECT *getScreenAddress( char *name )
{
   struct Screen *scr;
   ULONG          lock = 0L;
   OBJECT        *rval = o_nil;

   lock = LockIBase( 0 );

#  ifdef __SASC
   scr = IntuitionBase->FirstScreen;
#  else
   scr = ((struct IntuitionBase *) IIntuition->Data.LibBase)->FirstScreen;
#  endif
  
   while (scr) // != NULL)
      {
      if (scr->Title) // != NULL)
         {
         if (StringComp( scr->Title, name ) == 0)
            {
            rval = AssignObj( new_address( (ULONG) scr ) );
            break;
            }
         }

      scr = scr->NextScreen;
      }

   UnlockIBase( lock );

   SWinAddress = (ULONG) scr; 

   return( rval );
}

METHODFUNC OBJECT *getWindowAddress( char *name )
{
   struct Window *win, *taskwindow = NULL;
   struct Screen *scr;
   ULONG          lock = 0L;
   OBJECT        *rval = o_nil;
   
   lock = LockIBase( 0 );

#  ifdef __SASC
   scr = IntuitionBase->FirstScreen;
#  else
   scr = ((struct IntuitionBase *) IIntuition->Data.LibBase)->FirstScreen;
#  endif

   while (scr && !taskwindow) // == NULL))
      {
      win = scr->FirstWindow;
     
      while (win) // != NULL)
         {
         if (win->Title) // != NULL)
            if (StringComp( win->Title, name ) == 0) 
               {
               rval = AssignObj( new_address( (ULONG) win ) );

               goto GotWindowAddress;
               }

         win = win->NextWindow;
         }
 
      scr = scr->NextScreen;
      }

GotWindowAddress:

   UnlockIBase( lock );

   SWinAddress = (ULONG) win; 

   return( rval );
}

METHODFUNC void displayScreen( int Address )
{
   InfoType = SCRN_WIND_TYPE;
   SWinType = SCRN_TYPE;
   
   HandleWindowInfo( (void *) Address, 0 );
   SetNotifyWindow( ATWnd );
   
   return;
}

METHODFUNC void displayWindow( int Address )
{
   InfoType = SCRN_WIND_TYPE;
   SWinType = WIND_TYPE;
   
   HandleWindowInfo( (void *) Address, 1 );
   SetNotifyWindow( ATWnd );
   
   return;
}

METHODFUNC void displayTask( int Address )
{
   InfoType = TASK_PROC_TYPE;
   
   HandleWindowInfo( (void *) Address, 2 );
   SetNotifyWindow( ATWnd );
   
   return;
}

METHODFUNC void displayProcess( int Address )
{
   InfoType = TASK_PROC_TYPE;
   
   HandleWindowInfo( (void *) Address, 3 );
   SetNotifyWindow( ATWnd );
   
   return;
}

METHODFUNC int displayTasks_Processes( void )
{
   int rval = 0;
   
   InfoType = TASK_PROC_TYPE;
   rval     = HandleInfoListView();

   SetNotifyWindow( ATWnd );
   
   return( rval );
}

METHODFUNC int displayScreens_Windows( void )
{
   int rval = 0;
   
   InfoType = SCRN_WIND_TYPE;
   SWinType = SCRN_TYPE;             // For now.
   rval     = HandleInfoListView();

   SetNotifyWindow( ATWnd );
   
   return( rval );
}

SUBFUNC char *classNameFromType( OBJECT *obj )
{
   int type = objType( obj );
   
   switch (type)
      {
      case MMF_CLASS:
         return( "Class" );
      case MMF_BYTEARRAY:
         return( "ByteArray" );
      case MMF_SYMBOL:
         return( "Symbol" );
      case MMF_INTERPRETER:
         return( "Interpreter" );
      case MMF_PROCESS:
         return( "Process" );
      case MMF_BLOCK:
         return( "Block" );
      case MMF_FILE:
         return( "File" );
      case MMF_CHARACTER:
         return( "Char" );
      case MMF_INTEGER:
         return( "Integer" );
      case MMF_STRING:
         return( "String" );
      case MMF_FLOAT:
         return( "Float" );
      case MMF_CLASS_SPEC:
         return( "Class_Special" );
      case MMF_CLASS_ENTRY:
         return( "Class_Entry" );
      case MMF_SDICT:
         return( "SDict" );
      case MMF_ADDRESS:
         return( "Address" );
         
      default:
         {
         CLASS  *claz = (CLASS  *) obj->Class;
         SYMBOL *name = (SYMBOL *) claz->class_name;
         
         return( symbol_value( name ) ); 
         }
      }
}

PRIVATE UBYTE rs[1024] = { 0, }, *repStr = &rs[0];
    
PRIVATE OBJECT *ObjectReport( OBJECT *obj )
{
   OBJECT *rval       = o_nil;
   OBJECT *next       = nextObject( obj );
   OBJECT *super      = fnd_super(  obj );
   CLASS  *supClass   = objClass( super );
   OBJECT *inst       = NULL;
   int     size       = objSize(    obj ), i;
   char    insts[204] = { 0, };
   
   sprintf( repStr, "0x%08LX: refcount = %d, size: 0x%08LX, Class = %s\n"
                    "superClass = %s, nextLink = 0x%08LX\n\n", 
                    obj, objRefCount( obj ), obj->size,
                    Class_Name( obj ),
                    symbol_value( (SYMBOL *) supClass->class_name ),
                    next 
          );
   
   if (size > 4)
      size = 4;
   
   for (i = 0; i < size; i++)
      {
      inst = obj->inst_var[i];
      
      sprintf( &insts[ i * 50 ], "ivar[%1d] = 0x%08LX, Class = %s\n", 
                                 i, inst, classNameFromType( inst )
             );
      
      StringNCat( repStr, &insts[ i * 50 ], 50 );
      }
              
   return( rval );
}

PRIVATE OBJECT *ClassReport( OBJECT *obj )
{
   OBJECT *rval       = o_nil;
   CLASS  *thisClass  = (CLASS *) obj;
   CLASS  *next       = thisClass->nextLink;
   OBJECT *super      = fnd_super(  obj );
   CLASS  *supClass   = objClass( super );
   SYMBOL *fileName   = (SYMBOL *) thisClass->file_name;
   
   sprintf( repStr, "Class = 0x%08LX: refcount = %d, size: 0x%08LX\n"
                    "superClass = %s, nextLink = 0x%08LX\n"
                    "ClassName = %s, located in \"%s\"\n",
                    obj, objRefCount( obj ), obj->size,
                    symbol_value( (SYMBOL *) supClass->class_name ),
                    next, symbol_value( (SYMBOL *) thisClass->class_name ), 
                    symbol_value( fileName ) 
          );
   
   return( rval );
}

PRIVATE OBJECT *BytesReport( OBJECT *obj )
{
   OBJECT    *rval     = o_nil;
   BYTEARRAY *ba       = (BYTEARRAY *) obj;
   BYTEARRAY *next     = ba->nextLink;
   OBJECT    *super    = fnd_super(  obj );
   CLASS     *supClass = objClass( super );
   int        bsize    = ba->bsize, i, j;
   
   sprintf( repStr, "ByteArray = 0x%08LX: refcount = %d, size: 0x%08LX\n"
                    "superClass = %s, bsize = %d, nextLink = 0x%08LX\n\n", 
                    obj, objRefCount( obj ), obj->size,
                    symbol_value( (SYMBOL *) supClass->class_name ),
                    bsize, next 
          );
   
   if (bsize > 100)
      bsize = 100;
   
   StringCat( repStr, "byteCodes:  " );

   for (i = 0, j = 0; i < bsize; i++, j += 3)
      {
      char buffer[4] = { 0, };
      int  ch        = ba->bytes[i];

      StringNCat( repStr, Byt2Str( buffer, (UBYTE) ch ), 2 );

      if (j > 60) // j flags when to send out a newline.
         {
         StringCat( repStr, NEWLINE_STR );

         j = 0;
         }
      else
         StringCat( repStr, ONE_SPACE );
      }

   return( rval );
}

PRIVATE OBJECT *SymbolReport( OBJECT *obj )
{
   OBJECT *rval       = o_nil;
   SYMBOL *thisObj    = (SYMBOL *) obj;
   OBJECT *super      = fnd_super(  obj );
   CLASS  *supClass   = objClass( super );
   
   sprintf( repStr, "Symbol = 0x%08LX: refcount = %d, size: 0x%08LX\n"
                    "value = %s, superClass = %s",
                    obj, objRefCount( obj ), obj->size,
                    symbol_value( thisObj ),
                    symbol_value( (SYMBOL *) supClass->class_name )
          );
   
   return( rval );
}

PRIVATE OBJECT *InterpReport( OBJECT *obj )
{
   OBJECT      *rval  = o_nil;
   INTERPRETER *intp  = (INTERPRETER *) obj;
   INTERPRETER *next  = intp->nextLink;
   INTERPRETER *cret  = intp->creator;
   INTERPRETER *send  = intp->sender;
   OBJECT      *rcvr  = intp->receiver;
   int          size  = intp->size;
   char         creator[12];
   char         sender[12];
   char         receiver[12];
   
   if (send == (INTERPRETER *) o_drive)
      StringCopy( &sender[0], "o_drive" );
   else
      sprintf( &sender[0], "0x%08LX", send );

   if (!cret) // == NULL)
      StringCopy( &creator[0], "**NULL**" );
   else
      sprintf( &creator[0], "0x%08LX", cret );

   if (!rcvr) // == NULL)
      StringCopy( &receiver[0], "**NULL**" );
   else
      sprintf( &receiver[0], "0x%08LX", rcvr );
      
   sprintf( repStr, "Interpreter = 0x%08LX: refcount = %d, size: 0x%08LX,\n"
                    "nextLink = 0x%08LX\n\n"
                    "sender = %s, receiver = %s, creator = %s", 
                    obj, objRefCount( obj ), size, next, 
                    &sender[0], &receiver[0], &creator[0]
          );
   
   return( rval );
}

PRIVATE OBJECT *ProcessReport( OBJECT *obj )
{
   OBJECT      *rval = o_nil;
   PROCESS     *proc = (PROCESS *) obj;
   PROCESS     *next = proc->next;
   PROCESS     *prev = proc->prev;
   PROCESS     *nxtL = proc->nextLink;
   INTERPRETER *intp = proc->interp;
   int          size = proc->size;
   char         state[12];

   switch (proc->state)
      {
      default:
      case BLOCKED:
         StringCopy( &state[0], "BLOCKED" );
         break;

      case ACTIVE:
         StringCopy( &state[0], "ACTIVE" );
         break;
         
      case SUSPENDED:
         StringCopy( &state[0], "SUSPENDED" );
         break;
         
      case READY:
         StringCopy( &state[0], "READY" );
         break;
         
      case UNBLOCKED:
         StringCopy( &state[0], "UNBLOCKED" );
         break;
         
      case TERMINATED:
         StringCopy( &state[0], "TERMINATED" );
         break;
      }   
      
   sprintf( repStr, "Process = 0x%08LX: refcount = %d, size: 0x%08LX,\n"
                    "nextLink = 0x%08LX, interpreter = 0x%08LX\n\n"
                    "prev = 0x%08LX, next = 0x%08LX, State = %s", 
                    obj, objRefCount( obj ), size, nxtL, 
                    intp, prev, next, &state[0]
          );
   
   return( rval );
}

PRIVATE OBJECT *BlockReport( OBJECT *obj )
{
   OBJECT      *rval  = o_nil;
   BLOCK       *block = (BLOCK *) obj;
   BLOCK       *next  = block->nextLink;
   INTERPRETER *intp  = block->interpreter;   
   int          size  = block->size;
   
   sprintf( repStr, "Block = 0x%08LX: refcount = %d, size: 0x%08LX\n"
                    "nextLink = 0x%08LX, interpreter = 0x%08LX\n"
                    "# args = %d, location = 0x%08LX", 
                    obj, objRefCount( obj ), size,
                    next,intp, block->numargs, block->arglocation  
          );
   
   return( rval );
}

PRIVATE OBJECT *FileReport( OBJECT *obj )
{
   OBJECT  *rval  = o_nil;
   AT_FILE *phil  = (AT_FILE *) obj;
   AT_FILE *next  = phil->nextLink;
   int      size  = phil->size;
   
   sprintf( repStr, "File = 0x%08LX: refcount = %d, size: 0x%08LX\n"
                    "nextLink = 0x%08LX, FILE * = 0x%08LX\n"
                    "mode = %d", 
                    obj, objRefCount( obj ), size,
                    next, phil->fp, phil->file_mode
          );
   
   return( rval );
}

PRIVATE OBJECT *CharReport( OBJECT *obj )
{
   OBJECT      *rval = o_nil;
   CHARACTER   *chr  = (CHARACTER *) obj;
   int          size = chr->size;
   int          val  = chr->value;
   
   sprintf( repStr, "Char = 0x%08LX: refcount = %d, size: 0x%08LX\n"
                    "value = $%c",
                    obj, objRefCount( obj ), size, val
          );
   
   return( rval );
}

PRIVATE OBJECT *IntegerReport( OBJECT *obj )
{
   OBJECT  *rval = o_nil;
   INTEGER *itg  = (INTEGER *) obj;
   int      size = itg->size;
   int      val  = itg->value;
   
   sprintf( repStr, "Integer = 0x%08LX: refcount = %d, size: 0x%08LX\n"
                    "value = 0x%08LX (%d)",
                    obj, objRefCount( obj ), size, val, val
          );
   
   return( rval );
}

PRIVATE OBJECT *StringReport( OBJECT *obj )
{
   OBJECT *rval = o_nil;
   STRING *str  = (STRING *) obj;
   STRING *next = str->nextLink;
   int     size = str->size;
   
   sprintf( repStr, "String = 0x%08LX: refcount = %d, size: 0x%08LX\n"
                    "next = 0x%08LX,\n  value = \"%60.60s\"",
                    obj, objRefCount( obj ), size, next, str->value
          );
   
   return( rval );
}

PRIVATE OBJECT *FloatReport( OBJECT *obj )
{
   OBJECT *rval = o_nil;
   SFLOAT *flt  = (SFLOAT *) obj;
   SFLOAT *next = flt->nextLink;
   int     size = flt->size;
     
   sprintf( repStr, "Float = 0x%08LX: refcount = %d, size: 0x%08LX\n"
                    "next = 0x%08LX, value = %g",
                    obj, objRefCount( obj ), size, next, flt->value
          );
   
   return( rval );
}

PRIVATE OBJECT *ClassSpecReport( OBJECT *obj )
{
   OBJECT     *rval       = o_nil;
   CLASS_SPEC *thisClass  = (CLASS_SPEC *) obj;
   CLASS_SPEC *next       = thisClass->nextLink;
   SYMBOL     *name       = (SYMBOL *) thisClass->class_name;
   OBJECT     *super      = fnd_super(  obj );
   CLASS      *supClass   = objClass( super );
   OBJECT     *myInst     = thisClass->myInstance;
   
   sprintf( repStr, "%s = 0x%08LX: refcount = %d, size: 0x%08LX\n"
                    "superClass = %s, nextLink = 0x%08LX\n"
                    "myInstance = 0x%08LX",
                    symbol_value( name ),
                    obj, objRefCount( obj ), obj->size,
                    symbol_value( (SYMBOL *) supClass->class_name ),
                    next, myInst
          );
   
   return( rval );
}

PRIVATE OBJECT *ClassEntryReport( OBJECT *obj )
{
   OBJECT      *rval       = o_nil;
   CLASS_ENTRY *thisClass  = (CLASS_ENTRY *) obj;
   CLASS       *clazz      = (CLASS *) thisClass->classObject;
   CLASS_ENTRY *next       = thisClass->nextLink;
   
   sprintf( repStr, "Class_Entry = 0x%08LX: size: 0x%08LX\n"
                    "name = %s, nextLink = 0x%08LX\n"
                    "classObject = 0x%08LX, special = 0x%08LX",
                    obj, thisClass->size,
                    thisClass->className, next,
                    clazz, thisClass->specialObject
          );
   
   return( rval );
}

PRIVATE OBJECT *SDictReport( OBJECT *obj )
{
   OBJECT *rval  = o_nil;
   SDICT  *sdict = (SDICT *) obj;
   
   sprintf( repStr, "SDict = 0x%08LX: filePtr: 0x%08LX,\n"
                    "name = %s, numEntries = %d\n"
                    "sd_Storage = 0x%08LX",
                    obj, sdict->sd_File,
                    sdict->sd_FileName, sdict->sd_NumEntries,
                    sdict->sd_Storage
          );
   
   return( rval );
}

PRIVATE OBJECT *AddressReport( OBJECT *obj )
{
   OBJECT     *rval = o_nil;
   AT_ADDRESS *addr = (AT_ADDRESS *) obj;
   int         size = addr->size;
   int         val  = addr->value;
   
   sprintf( repStr, "Address = 0x%08LX: refcount = %d, size: 0x%08LX\n"
                    "value = 0x%08LX (%d), nextLink = 0x%08LX",
                    obj, objRefCount( obj ), size, val, val, addr->nextLink
          );
   
   return( rval );
}

PRIVATE ULONG Reports[] = {
   
   (ULONG) &ObjectReport,    (ULONG) &ClassReport,      (ULONG) &BytesReport,  (ULONG) &SymbolReport, 
   (ULONG) &InterpReport,    (ULONG) &ProcessReport,    (ULONG) &BlockReport,  (ULONG) &FileReport,  
   (ULONG) &CharReport,      (ULONG) &IntegerReport,    (ULONG) &StringReport, (ULONG) &FloatReport, 
   (ULONG) &ClassSpecReport, (ULONG) &ClassEntryReport, (ULONG) &SDictReport,  (ULONG) &AddressReport
};

METHODFUNC OBJECT *reportInformation( OBJECT *obj )
{
   OBJECT *rval = o_nil;
   
   FBEGIN( printf( "reportInformation( 0x%08LX )\n", obj ) );    

   rval =  ObjActionByType( obj, 
                            (OBJECT * (**)( OBJECT * )) Reports 
                          );
   
   UserInfo( repStr, SysCMsg( MSG_OBJECT_IS_SYS ) );

   FEND( printf( "0x%08LX = reportInformation() exits\n", rval ) );   

   return( rval );   
}

METHODFUNC OBJECT *reportInstance( OBJECT *addr )
{
   if (is_integer( addr ) == TRUE)
      return( reportInformation( (OBJECT *) ((INTEGER *) addr)->value ) );
   else if (is_address( addr ) == TRUE)
      return( reportInformation( (OBJECT *) ((AT_ADDRESS *)addr)->value ) );
   else 
      return( o_nil );
}

/****h* HandleSystem() [1.8] *****************************************
*
* NAME
*    HandleSystem()
*
* DESCRIPTION
*    Translate primitive 250 calls into System functions.  These
*    Methods are used in the AmigaTalk Class (mostly).
**********************************************************************
*
*/

PUBLIC OBJECT *HandleSystem( int numargs, OBJECT **args )
{
   IMPORT OBJECT *getMsgPortAddressList( void ); // In MsgPort.c
   
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 250 );
      return( o_nil );
      }
         
   switch (int_value( args[0] ))
      {
      case 0:
         if (is_integer( args[1] ) == FALSE)
            {
            (void) PrintArgTypeError( 250 );
            break;
            }

         switch (int_value( args[1] ))
            {
            case 0: // getProcessAddress()
               if (is_string( args[2] ) == FALSE)
                  (void) PrintArgTypeError( 250 );
               else
                  rval = getProcessAddress( string_value( (STRING *)args[2]));
   
               break;
               
            case 1: // getTaskAddress()
               if (is_string( args[2] ) == FALSE)
                  (void) PrintArgTypeError( 250 );
               else
                  rval = getTaskAddress( string_value( (STRING *) args[2] ) );
   
               break;
               
            case 2: // getScreenAddress()
               if (is_string( args[2] ) == FALSE)
                  (void) PrintArgTypeError( 250 );
               else
                  rval = getScreenAddress( string_value( (STRING *) args[2]));
   
               break;

            case 3: // getWindowAddress()
               if (is_string( args[2] ) == FALSE)
                  (void) PrintArgTypeError( 250 );
               else
                  rval = getWindowAddress( string_value( (STRING *) args[2]));
   
               break;

            case 4: // getProcessAddressList()
               rval = getAddressList( PROCESS_DATA );
               break;
               
            case 5: // getTaskAddressList()
               rval = getAddressList( TASK_DATA );
               break;
               
            case 6: // getScreenAddressList()
               rval = getAddressList( SCREEN_DATA );
               break;

            case 7: // getWindowAddressList()
               rval = getAddressList( WINDOW_DATA );
               break;
            
            case 8: // getMsgPortFromList()
               rval = getMsgPortAddressList();
               break;
            }

         break;

      case 1:
         if (is_integer( args[1] ) == FALSE)
            {
            (void) PrintArgTypeError( 250 );
            break;
            }

         switch (int_value( args[1] ))
            {
            case 0: // displayProcess( int Address );
               displayProcess( addr_value( args[2] ) );
               break;
               
            case 1: // displayTask( int Address );
               displayTask( addr_value( args[2] ) );
               break;
               
            case 2: // displayScreen( int Address );
               displayScreen( addr_value( args[2] ) );
               break;

            case 3: // displayWindow( int Address );
               displayWindow( addr_value( args[2] ) );
               break;
            
            case 4: // displayTasks_Processes();
               rval = new_int( displayTasks_Processes() );
               break;

            case 5: // displayScreens_Windows();
               rval = new_int( displayScreens_Windows() );
               break;
            }

         break;

      case 2:
         if (is_integer( args[1] ) == FALSE)
            {
            (void) PrintArgTypeError( 250 );
            break;
            }

         switch (int_value( args[1] ))
            {
            case 0: // getProcessAddressList()
               rval = getAddressList( PROCESS_DATA );
               break;
               
            case 1: // getTaskAddressList()
               rval = getAddressList( TASK_DATA );
               break;
               
            case 2: // getScreenAddressList()
               rval = getAddressList( SCREEN_DATA );
               break;

            case 3: // getWindowAddressList()
               rval = getAddressList( WINDOW_DATA );
               break;

            case 4: // getDeviceAddressList
               rval = getDeviceList();
               break;
            }

         break;

      case 3: // get an Address for a smalltalk object:
              // This is definitely NOT Kosher:
         if (is_integer( args[1] ) == FALSE)
            {
            (void) PrintArgTypeError( 250 );
            break;
            }

         switch (int_value( args[1] ))
            {
            case 0: // getIntegerAddress: anInteger
               if (is_integer( args[2] ) == FALSE)
                  {
                  (void) PrintArgTypeError( 250 );
                  break;
                  }

               rval = new_address( (ULONG) &(((INTEGER *) args[2])->value) );
               break;
               
            case 1: // getStringAddress: aString
               if (is_string( args[2] ) == FALSE)
                  {
                  (void) PrintArgTypeError( 250 );
                  break;
                  }

               rval = new_address( (ULONG) &(((STRING *) args[2])->value) );
               break;

            case 2: // getByteArrayAddress: aByteArray
               if (is_bytearray( args[2] ) == FALSE)
                  {
                  (void) PrintArgTypeError( 250 );
                  break;
                  }

               rval = new_address( (ULONG) &(((BYTEARRAY *) args[2])->bytes) );
               break;
            }

         break;

      case 4: // handle Class Special interfacing: 
         if (is_integer( args[1] ) == FALSE)
            {
            (void) PrintArgTypeError( 250 );
            break;
            }

         switch (int_value( args[1] ))
            {
            case 0: // findClassTypeSymbol: classObject  ^ typeSymbol or nil

               //     FindClassTypeSymbol() located in ClDict.c
               rval = FindClassTypeSymbol( (CLASS *) args[2] );
               break;
               
            case 1: // findClassSpecial: className ^specialObject or nil
               if (is_string( args[2] ) == FALSE)
                  {
                  (void) PrintArgTypeError( 250 );
                  break;
                  }
               //     NOT currently used.
               //     FindClassSpecial() located in ClDict.c
               rval = FindClassSpecial( string_value( (STRING *) args[2] ) );
               break;

            case 2: // getClassSpecialFlags: classObject ^integerFlags or nil

               //     GetClassTypeFlags() located in ClDict.c
               rval = GetClassTypeFlags( (CLASS *) args[2] );
               break;

            case 3: // getInstanceVar: classObject ^myInstance or nil

               //     GetInstanceVar() located in ClDict.c
               rval = GetInstanceVar( (CLASS *) args[2] );
               break;

            case 4: // setInstanceVar: classObject to: newObject ^myInstance or nil

               // SetInstanceVar() located in ClDict.c
               SetInstanceVar( (CLASS *) args[2], args[3] );
               break;
            }
   
         break;

      case 5:
         if (is_integer( args[1] ) == FALSE)
            {
            (void) PrintArgTypeError( 250 );

            break;
            }

         switch (int_value( args[1] ))
            {
            case 0: // KillObject()
               KillObject( args[2] );
               break;
            
            case 1: // xxxReport -- located in Object.st
               rval = reportInformation( args[2] );
               break;

            case 2: // xxxAddress -- located in Object.st
               rval = reportInstance( args[2] );
               break;
            }

         break;
                                            
      default:
         (void) PrintArgTypeError( 250 );
         break;
      }

   return( rval );
}

/* ------------------- END of System.c file! ----------------------- */
