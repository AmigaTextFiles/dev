/****h* AmigaTalk/MsgPort.c [3.0] ************************************
*
* NAME
*    MsgPort.c
*
* FUNCTIONAL INTERFACE:
*
*    PUBLIC OBJECT *HandleMsgPorts( int numargs, OBJECT **args );
*    PUBLIC OBJECT *getMsgPortAddressList( void );
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    07-Jan-2003 - Moved all string constants to StringConstants.h
*
*    27-Nov-2002 - Added the code for <primitive 250 0 8>.
*
* NOTES
*    Once a port has been made, all messages to & from the port
*    are supposed to be the given size (atport->atp_MsgSize).
*
*    $VER: AmigaTalk:Src/MsgPort.c 3.0 (25-Oct-2004) by J.T Steichen
**********************************************************************
*
*/

#include <stdio.h>
#include <string.h>

#include <exec/types.h>

#include <AmigaDOSErrs.h>

#include <exec/nodes.h>
#include <exec/lists.h>
#include <exec/ports.h>
#include <exec/io.h>

#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/gadgetclass.h>

#include <libraries/gadtools.h>

#include <graphics/displayinfo.h>
#include <graphics/gfxbase.h>

#ifdef __SASC

# include <clib/intuition_protos.h>
# include <clib/gadtools_protos.h>
# include <clib/graphics_protos.h>
# include <clib/utility_protos.h>
# include <clib/diskfont_protos.h>
# include <clib/exec_protos.h>

IMPORT struct IntuitionBase *IntuitionBase;
IMPORT struct Library       *GadToolsBase;

#else

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/intuition.h>
# include <proto/gadtools.h>
# include <proto/graphics.h>
# include <proto/diskfont.h>
# include <proto/utility.h>

IMPORT struct Library *IntuitionBase;
IMPORT struct Library *GadToolsBase;
#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ATStructs.h"
#include "Object.h"
#include "Constants.h"

#include "StringConstants.h"
#include "StringIndexes.h"
#include "FuncProtos.h"

IMPORT OBJECT *o_nil, *o_true, *o_false;

IMPORT UBYTE  *AllocProblem;
IMPORT UBYTE  *UserProblem;
IMPORT UBYTE  *SystemProblem;

IMPORT UBYTE  *ErrMsg;

IMPORT OBJECT *PrintArgTypeError( int primnumber );

/*
struct Node {

   struct Node *ln_Succ; // Pointer to next (successor)
   struct Node *ln_Pred; // Pointer to previous (predecessor)
   UBYTE        ln_Type;
   BYTE         ln_Pri;	 // Priority, for sorting
   char        *ln_Name; // ID string, null terminated

};	// Note: word aligned

struct Message {

   struct Node     mn_Node;
   struct MsgPort *mn_ReplyPort;
   UWORD           mn_Length;
};

struct MsgPort {

   struct Node  mp_Node;
   UBYTE        mp_Flags;
   UBYTE        mp_SigBit;
   struct Task *mp_SigTask;
   struct List  mp_MsgList;
};
*/

// ---- <primitive 250 0 8> code: ----------------------------------

#define MPLV      0
#define SelectTxt 1
#define DoneBt    2
#define CancelBt  3
#define UpdateBt  4

#define MP_CNT    5

#define SelectGadget MPGadgets[ SelectTxt ]
#define ListGadget   MPGadgets[ MPLV ]

IMPORT struct Screen        *Scr;
IMPORT UBYTE                *PubScreenName;
IMPORT APTR                  VisualInfo;

IMPORT struct TextAttr      *Font;
IMPORT struct CompFont       CFont;

// ---------------------------------------------------------------------

PUBLIC  UBYTE *MPWdt = NULL; // Visible to CatalogMsgPort();

// ---------------------------------------------------------------------
 
PRIVATE struct Window *MPWnd   = NULL;
PRIVATE struct Gadget *MPGList = NULL;
PRIVATE struct Gadget *MPGadgets[ MP_CNT ] = { NULL, };

PRIVATE struct IntuiMessage MPMsg;

PRIVATE UWORD  MPLeft   = 0;
PRIVATE UWORD  MPTop    = 95;
PRIVATE UWORD  MPWidth  = 640;
PRIVATE UWORD  MPHeight = 345;

PRIVATE struct TextFont *MPFont = NULL;

// ---------------------------------------------------------------------

#define STRLENGTH 80

PRIVATE struct ListViewMem *lvm = NULL;

PRIVATE struct List         MPList = { 0, };

PRIVATE int                 NodeCount = 0;

PRIVATE char PortName[25] = { 0, };
PRIVATE char PortType[8]  = { 0, };
PRIVATE char PortTask[48] = { 0, };

// ---------------------------------------------------------------------

PRIVATE UWORD MPGTypes[ MP_CNT ] = {

   LISTVIEW_KIND, TEXT_KIND, BUTTON_KIND, BUTTON_KIND, BUTTON_KIND
};

PRIVATE int MPLVClicked(     int whichOne );
PRIVATE int DoneBtClicked(   int dummy    );
PRIVATE int UpdateBtClicked( int dummy    );
PRIVATE int CancelBtClicked( int dummy    );

PUBLIC struct NewGadget MPNGad[] = { // Visible to CatalogMsgPort();

    15,  24, 610, 270, NULL, NULL, MPLV,      
   PLACETEXT_ABOVE | NG_HIGHLABEL, NULL, (APTR) MPLVClicked,

    15, 290, 610,  20, NULL, NULL, SelectTxt, 0, NULL, NULL,

    15, 314,  63,  25, NULL,  NULL, DoneBt,    
   PLACETEXT_IN, NULL, (APTR) DoneBtClicked,
   
   155, 314,  63,  25, NULL,  NULL, UpdateBt,    
   PLACETEXT_IN, NULL, (APTR) UpdateBtClicked,
   
   540, 314,  75,  25, NULL, NULL, CancelBt,  
   PLACETEXT_IN, NULL, (APTR) CancelBtClicked
};

PRIVATE ULONG MPGTags[] = {

   GTLV_Labels,       (ULONG) &MPList, 
   GTLV_ShowSelected, 0L, 
   LAYOUTA_Spacing,   2, 
   TAG_DONE,
   
   GTTX_Border,  TRUE, TAG_DONE,
   GT_Underscore, UNDERSCORE_CHAR, TAG_DONE,
   GT_Underscore, UNDERSCORE_CHAR, TAG_DONE,
   GT_Underscore, UNDERSCORE_CHAR, TAG_DONE
};

// --------------------------------------------------------------------

PRIVATE void CloseMPWindow( void )
{
   if (MPWnd) // != NULL) 
      {
      CloseWindow( MPWnd );
      
      MPWnd = NULL;
      }

   if (MPGList) // != NULL) 
      {
      FreeGadgets( MPGList );
      
      MPGList = NULL;
      }

   if (MPFont) // != NULL) 
      {
      CloseFont( MPFont );
      
      MPFont = NULL;
      }

   return;
}

PRIVATE int OpenMPWindow( void )
{
   struct NewGadget  ng;
   struct Gadget    *g;
   UWORD             lc, tc;
   UWORD             wleft = MPLeft, wtop = MPTop, ww, wh;

   ComputeFont( Scr, Font, &CFont, MPWidth, MPHeight );

   ww = ComputeX( CFont.FontX, MPWidth );
   wh = ComputeY( CFont.FontY, MPHeight );

   wleft = (Scr->Width  - MPWidth ) / 2;
   wtop  = (Scr->Height - MPHeight) / 2;

   if (!(MPFont = OpenDiskFont( Font ))) // == NULL)
      return( -5 );

   if (!(g = CreateContext( &MPGList ))) // == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < MP_CNT; lc++) 
      {
      CopyMem( (char *) &MPNGad[ lc ], (char *) &ng, 
               (long) sizeof( struct NewGadget )
             );

      ng.ng_VisualInfo = VisualInfo;
      ng.ng_TextAttr   = Font;

      ng.ng_LeftEdge   = CFont.OffX + ComputeX( CFont.FontX, ng.ng_LeftEdge );
      ng.ng_TopEdge    = CFont.OffY + ComputeY( CFont.FontY, ng.ng_TopEdge );

      ng.ng_Width      = ComputeX( CFont.FontX, ng.ng_Width );
      ng.ng_Height     = ComputeY( CFont.FontY, ng.ng_Height);

      MPGadgets[ lc ] = g 
                      = CreateGadgetA( (ULONG) MPGTypes[ lc ], 
                                       g, 
                                       &ng, 
                                       (struct TagItem *) &MPGTags[ tc ] 
                                     );

      while (MPGTags[ tc ] != TAG_DONE)
         tc += 2;
      
      tc++;

      if (!g) // == NULL)
         return( -2 );
      }

   if (!(MPWnd = OpenWindowTags( NULL,

            WA_Left,      wleft,
            WA_Top,       wtop,
            WA_Width,     ww + CFont.OffX + Scr->WBorRight,
            WA_Height,    wh + CFont.OffY + Scr->WBorBottom,

            WA_IDCMP,     LISTVIEWIDCMP | TEXTIDCMP | BUTTONIDCMP 
              | IDCMP_VANILLAKEY | IDCMP_REFRESHWINDOW,

            WA_Flags,     WFLG_DRAGBAR | WFLG_DEPTHGADGET 
              | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,

            WA_Gadgets,   MPGList,
            WA_Title,     MPWdt,
            WA_PubScreen, Scr,
            TAG_DONE )

      )) // == NULL)
      return( -4 );

   GT_RefreshWindow( MPWnd, NULL );

   return( 0 );
}

// ----------------------------------------------------------------

PRIVATE int countPorts( void )
{
#  ifdef  __SASC
   IMPORT struct ExecBase *SysBase;
#  endif
   
   struct MsgPort *mport = NULL;
   struct Node    *ptr   = NULL;
   struct List    *ports = NULL;
   int             rval  = 0;

   Forbid();

#    ifdef   __SASC
     ports = &SysBase->PortList;
#    else
     ports = &((struct ExecBase *) IExec->Data.LibBase)->PortList;
#    endif

     ptr   = ports->lh_Head;
     mport = (struct MsgPort *) ptr;
     
     while (mport) // != NULL)
        {
        rval++;
        
        mport = (struct MsgPort *) mport->mp_Node.ln_Succ;
        }
   
   Permit();

   return( rval );
}

PRIVATE char *GetPortType( struct Node *port )
{
   switch (port->ln_Type)
      {
      case NT_MSGPORT:
         StringCopy( &PortType[0], MPortCMsg( MSG_MP_MSGPORTCLASSNAME_MPORT ) );
         break;
         
      case NT_UNKNOWN:
      default:
         StringCopy( &PortType[0], MPortCMsg( MSG_MP_UNKNOWN_MPORT ) );
         break;
      }
      
   return( &PortType[0] );
}

PRIVATE char *GetPortTaskName( struct Node *port )
{
   struct MsgPort *mp    = (struct MsgPort *) port;
   struct Task    *ptask = NULL;
   
   if (mp) // != NULL)
      ptask = (struct Task *) mp->mp_SigTask;

   if (ptask) // != NULL)
      { 
      if (ptask->tc_Node.ln_Type == NT_TASK ||
          ptask->tc_Node.ln_Type == NT_PROCESS)
         {
         if (StringLength( ptask->tc_Node.ln_Name ) > 1)
            StringCopy( &PortTask[0], ptask->tc_Node.ln_Name );
         else
            StringCopy( &PortTask[0], MPortCMsg( MSG_MP_NO_TASKNAME_MPORT ) );  
         } 
      else
         StringCopy( &PortTask[0], MPortCMsg( MSG_MP_NO_TASKNODE_MPORT ) );   
      }
   else
      StringCopy( &PortTask[0], MPortCMsg( MSG_MP_NO_TASKPTR_MPORT ) );   

   return( &PortTask[0] );
}


PRIVATE int MakePortList( void )
{
#  ifdef  __SASC
   IMPORT struct ExecBase *SysBase;
#  endif

   struct List    *portslist;
   struct Node    *ptr;   
   struct MsgPort *mport;
   
   char *nm = NULL;
   int   i  = 0;
   
   HideListFromView( ListGadget, MPWnd );

   Forbid();

#    ifdef   __SASC
     portslist = &SysBase->PortList;
#    else
     portslist = &((struct ExecBase *) IExec->Data.LibBase)->PortList;
#    endif

     ptr       = portslist->lh_Head;
     mport     = (struct MsgPort *) ptr;

     while ((i < NodeCount) && mport) // != NULL))
        {
        nm = mport->mp_Node.ln_Name;

        if (StringLength( nm ) < 1)
           goto SkipBlankPortName;

        // "PortName Type TaskName";
        sprintf( &lvm->lvm_NodeStrs[ STRLENGTH * i++ ], 
                 "%-24.24s %-7.7s %-46.46s",
                 (nm == NULL ? MPortCMsg( MSG_MP_NO_STARNAME_MPORT ) : nm),
                 GetPortType(     (struct Node *) mport ),
                 GetPortTaskName( (struct Node *) mport )
               );

SkipBlankPortName:
         
        mport = (struct MsgPort *) mport->mp_Node.ln_Succ;
        } 

   Permit();

   GT_SetGadgetAttrs( ListGadget, MPWnd, NULL,
                      GTLV_Labels,       &MPList,
                      GTLV_Selected,     1,
                      TAG_END
                    );

   return( i );
}

// ----------------------------------------------------------------

PRIVATE OBJECT *UserSelectionPort = NULL; // Only DoneBtClicked() changes this! 

PRIVATE int MPLVClicked( int whichOne )
{
   StringNCopy( PortName, lvm->lvm_Nodes[ whichOne ].ln_Name, 24 );
   
   GT_SetGadgetAttrs( SelectGadget, MPWnd, NULL,
                      GTTX_Text, lvm->lvm_Nodes[ whichOne ].ln_Name, 
                      TAG_DONE 
                    );
   
   return( TRUE );
}

METHODFUNC OBJECT *GetNamedSystemPort( char *findName );

PRIVATE int DoneBtClicked( int dummy )
{
   UserSelectionPort = GetNamedSystemPort( &PortName[0] );
   
   CloseMPWindow();

   return( FALSE );
}

PRIVATE int UpdateBtClicked( int dummy )
{
   int i;

   DisplayTitle( MPWnd, MPortCMsg( MSG_MP_UPDATEPORTLV_MPORT ) );

   HideListFromView( ListGadget, MPWnd );   

      for (i = 0; i < NodeCount; i++)
         lvm->lvm_NodeStrs[ i * lvm->lvm_NodeLength ] = NIL_CHAR; // Kill old ListView strings.

      (void) MakePortList();

   ModifyListView( ListGadget, MPWnd, &MPList, NULL );

   DisplayTitle( MPWnd, MPWdt );

   GT_RefreshWindow( MPWnd, NULL );

   return( (int) TRUE );
}

PRIVATE int CancelBtClicked( int dummy )
{
   CloseMPWindow();

   return( FALSE );
}

PRIVATE int MPVanillaKey( int WhichKey )
{
   int rval = TRUE;
   
   switch (WhichKey)
      {
      case SMALL_D_CHAR:
      case CAP_D_CHAR:
         rval = DoneBtClicked( 0 );
         break;

      case SMALL_U_CHAR:
      case CAP_U_CHAR:
         rval = UpdateBtClicked( 0 );
         break;
               
      case SMALL_C_CHAR:
      case CAP_C_CHAR:
         rval = CancelBtClicked( 0 );    
         break;
         
      default:
         break;
      }
      
   return( rval ); 
}

PRIVATE int HandleMPIDCMP( void )
{
   struct IntuiMessage *m;
   int                (*func)( int );
   BOOL                 running = TRUE;

   while (running == TRUE)
      {
      if (!(m = GT_GetIMsg( MPWnd->UserPort ))) // == NULL) 
         {
         (void) Wait( 1L << MPWnd->UserPort->mp_SigBit );

         continue;
         }

      CopyMem( (char *) m, (char *) &MPMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (MPMsg.Class) 
         {
         case   IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( MPWnd );
            GT_EndRefresh( MPWnd, TRUE );
            break;

         case   IDCMP_VANILLAKEY:
            running = MPVanillaKey( MPMsg.Code );
            break;

         case IDCMP_GADGETUP:
         case IDCMP_GADGETDOWN:
            func = (int (*)( int )) ((struct Gadget *) MPMsg.IAddress)->UserData;

            if (func) // != NULL)
               running = func( MPMsg.Code );

            break;
         }
      }

   return( running );
}

PRIVATE int setupMPDisplay( int numElements )
{
   if (!(lvm = Guarded_AllocLV( numElements, STRLENGTH ))) // == NULL)
      return( -1 );

   if (OpenMPWindow() < 0)
      {
      Guarded_FreeLV( lvm );

      return( -2 );
      }
      
   SetupList( &MPList, lvm );

   UserSelectionPort = o_nil; // Only DoneBtClicked() changes this! 

   return( 0 );   
}

/****h* getMsgPortAddressList() [3.0] ********************************
*
* NAME
*    getMsgPortAddressList()
*
* DESCRIPTION
*    Display a ListView of all known message Ports so that
*    the User can select a msgPortObj to send messages to.
*
*    selectMessagePort
*      ^ <primitive 250 0 8>
**********************************************************************
*
*/

PUBLIC OBJECT *getMsgPortAddressList( void )
{
   int howMany = countPorts() + 20; // Pad list size for Update button
   
   if (setupMPDisplay( howMany ) < 0)
      {
      sprintf( ErrMsg, MPortCMsg( MSG_MP_CANT_SETUP_MPORT) );

      UserInfo( ErrMsg, AllocProblem );
      
      return( o_nil );
      }

   NodeCount = howMany;

   (void) UpdateBtClicked( 0 );
         
   (void) HandleMPIDCMP();

   Guarded_FreeLV( lvm );
   
   CloseMPWindow(); // Just in case.
   
   return( UserSelectionPort );   
}

// ---- The rest of MsgPort.c file: ----------------------------------

struct ATPort  {
   
   struct MsgPort *atp_MsgPort;
   char           *atp_PortName; // Duplicate of atp_MsgPort->mp_Node.ln_Name
   ULONG           atp_MsgSize;

   struct Message *atp_Message;  // anything after this is user data.
};

METHODFUNC OBJECT *PortInSystem( OBJECT *portObj );

/****i* KillPort() [1.9] *********************************************
*
* NAME
*    KillPort()
*
* DESCRIPTION
*    <primitive 191 0 private>
**********************************************************************
*
*/

METHODFUNC void KillPort( OBJECT *portObj )
{
   struct ATPort *atport = (struct ATPort *) CheckObject( portObj );

   if (NullChk( (OBJECT *) atport ) == TRUE)
      {
      NullFound( MPortCMsg( MSG_MP_KILLPORT_FUNC_MPORT ) );

      return;
      }

   // Clean off Message Queue:

   while (GetMsg( atport->atp_MsgPort )) // != NULL)
      ReplyMsg( atport->atp_Message );
      
   RemPort( atport->atp_MsgPort ); // Remove port from Amiga exec list.

   // Death!  Death to you all!!
   DeleteMsgPort( atport->atp_MsgPort );

   AT_FreeVec( atport->atp_Message,  "atport->Message",  TRUE );
   AT_FreeVec( atport->atp_PortName, "atport->PortName", TRUE );
   AT_FreeVec( atport,               "atport",           TRUE );
   
   atport = NULL; // Kill them all!!
      
   return;
}

/****i* MakePort() [1.9] *********************************************
*
* NAME
*    MakePort()
*
* DESCRIPTION
*    Add a MsgPort to the Amiga System PortList.
*    ^ <primitive 191 1 private msgSize priority>
**********************************************************************
*
*/

METHODFUNC OBJECT *MakePort( OBJECT *portObj, int msgsize, int priority )
{
   struct ATPort *atport = (struct ATPort *) CheckObject( portObj );
   OBJECT        *rval   = o_nil;

   if (NullChk( (OBJECT *) atport ) == TRUE)
      return( rval );
            
   if (PortInSystem( portObj ) == o_true)
      {
      AlreadyOpen( atport->atp_PortName );

      return( rval );
      }
      
   atport->atp_Message->mn_Node.ln_Type = NT_MESSAGE;
   atport->atp_Message->mn_Length       = msgsize + sizeof( struct Message );
   atport->atp_Message->mn_ReplyPort    = atport->atp_MsgPort;


   atport->atp_MsgPort->mp_Node.ln_Name = atport->atp_PortName;
   atport->atp_MsgPort->mp_Node.ln_Pri  = priority;

   AddPort( atport->atp_MsgPort ); // Add port to Amiga exec list.

   atport->atp_MsgSize = msgsize + sizeof( struct Message );

   return( portObj );
}

/****i* GetMessage() [1.9] *******************************************
*
* NAME
*    GetMessage()
*
* DESCRIPTION
*    ^ <primitive 191 2 private>
**********************************************************************
*
*/

METHODFUNC OBJECT *GetMessage( OBJECT *portObj )
{
   IMPORT OBJECT *new_bytearray( uchar *values, int size );

   struct ATPort  *atport = (struct ATPort *) CheckObject( portObj );
   struct Message *saved  = NULL;
   struct Message *tmsg   = NULL;
   void           *msg    = NULL;
   OBJECT         *rval   = o_nil;
   ULONG           addr   = 0;
   
   // This function needs to be debugged!
   
   if (NullChk( (OBJECT *) atport ) == TRUE)
      {
      NullFound( MPortCMsg( MSG_MP_GETMSG_FUNC_MPORT ) );

      return( rval );
      }

   /* We cannot share Message space for sending & receiving, so
   ** we have to make a temporary reception area:
   */   
   saved = atport->atp_Message;
   
   if (!(tmsg = (struct Message *) AT_AllocVec( atport->atp_MsgSize,
                                                MEMF_CLEAR | MEMF_ANY, 
                                                "portMessage", TRUE ))) // == NULL)
      { 
      MemoryOut( MPortCMsg( MSG_MP_GETMSG_FUNC_MPORT ) );

      return( rval );
      }

   tmsg->mn_Node.ln_Type = NT_MESSAGE;
   tmsg->mn_Length       = atport->atp_MsgSize;
   tmsg->mn_ReplyPort    = atport->atp_Message->mn_ReplyPort;
   
   atport->atp_Message   = tmsg;
                 
   WaitPort( atport->atp_MsgPort ); // We could die here if no message arrives!

   msg = (void *) GetMsg( atport->atp_MsgPort );

      // Note the struct Message offsets:
      addr = sizeof( struct Message ) + (ULONG) msg;
   
      // the byteArray will not have struct Message in it:
      rval = AssignObj( new_bytearray( (uchar *) addr, 
                                       (int) atport->atp_MsgSize - sizeof( struct Message )
                                     )
                      );
   
   ReplyMsg( (struct Message *) msg ); // Absolutely necessary!

   atport->atp_Message = saved; // Restore the sending Message Space

   AT_FreeVec( tmsg, "portMessage", TRUE );
   
   return( rval );
}

/****i* SendMessage() [1.9] ******************************************
*
* NAME
*    SendMessage()
*
* DESCRIPTION
*    <primitive 191 3 private destPortObject byteArray>
**********************************************************************
*
*/

METHODFUNC void SendMessage( OBJECT    *srcPortObj, 
                             OBJECT    *dstPortObj,
                             BYTEARRAY *barray 
                           )
{
   struct ATPort *atport  = (struct ATPort *) CheckObject( srcPortObj );
   struct ATPort *dstport = (struct ATPort *) CheckObject( dstPortObj );
   char          *cptr    = NULL;
   char          *array   = barray->bytes;
   int            size, bsize = barray->bsize;
   int            i, j;

   // This function needs to be debugged!
   
   if (NullChk( (OBJECT *) atport ) == TRUE)
      {
      NullFound( MPortCMsg( MSG_MP_SENDMSG_FUNC_MPORT ) );

      return;
      }

   size = bsize + sizeof( struct Message );

   if (!(cptr = (char *) AT_AllocVec( size, MEMF_ANY | MEMF_CLEAR, 
                                      "msgString", TRUE ))) // == NULL)
      {
      sprintf( ErrMsg, MPortCMsg( MSG_MP_NO_SNDMSG_SPC_MPORT ), size );
      
      MemoryOut( ErrMsg );
      
      return;
      }
   
   // Copy the struct Message data to cptr:
   CopyMem( (char *) atport->atp_Message, cptr, (long) sizeof( struct Message ) );

   // Copy the user message data:
   for (j = 0, i = sizeof( struct Message ); i < size; j++, i++)
      *(cptr + i) = *(array + j);


   PutMsg( dstport->atp_MsgPort, atport->atp_Message );

   WaitPort( atport->atp_Message->mn_ReplyPort );

   (void) GetMsg( atport->atp_Message->mn_ReplyPort );

   if (cptr) // != NULL)
      AT_FreeVec( cptr, "msgString", TRUE );
      
   return;
}

/****i* portInTheSystem() [3.0] **************************************
*
* NAME
*    portInTheSystem()
*
* DESCRIPTION
*    Return a Boolean indicating whether the Port address supplied is
*    in the PortList in ExecBase.  Called only by PortInSystem().
**********************************************************************
*
*/

SUBFUNC OBJECT *portInTheSystem( struct MsgPort *port )
{
#  ifdef  __SASC
   IMPORT struct ExecBase *SysBase;
#  endif

   struct List    *portsList;
   struct Node    *ptr;
   struct MsgPort *mport;
   OBJECT         *rval = o_false;

   if (NullChk( (OBJECT *) port ) == TRUE)
      return( rval );
         
   Forbid();

#     ifdef  __SASC
      portsList = &SysBase->PortList;
#     else
      portsList = &((struct ExecBase *) IExec->Data.LibBase)->PortList;
#     endif

      ptr       = portsList->lh_Head;
      mport     = (struct MsgPort *) ptr;
      
      while (mport) // != NULL)
         {
         if (mport == port)
            {
            rval = o_true;
            
            Permit();
            
            return( rval );
            }

         mport = (struct MsgPort *) ((struct MsgPort *) mport)->mp_Node.ln_Succ;
         }
         
   Permit();
   
   return( rval );
}

/****i* PortInSystem() [3.0] *****************************************
*
* NAME
*    PortInSystem()
*
* DESCRIPTION
*    Return a Boolean indicating whether the Port address supplied is
*    in the PortList in ExecBase.
*    ^ <primitive 191 4 private>
**********************************************************************
*
*/

METHODFUNC OBJECT *PortInSystem( OBJECT *portObj )
{
   struct MsgPort *findPort = (struct MsgPort *) CheckObject( portObj );
   OBJECT         *rval     = o_false;

   if (NullChk( (OBJECT *) findPort ) == TRUE)
      return( rval );
   else
      return( portInTheSystem( findPort ) );
}

/****i* GetNamedSystemPort() [1.9] ***********************************
*
* NAME
*    GetNamedSystemPort()
*
* DESCRIPTION
*    Return the Port Address as an Integer if found in the PortList,
*    nil otherwise.
*    ^ <primitive 191 5 findName>
**********************************************************************
*
*/

METHODFUNC OBJECT *GetNamedSystemPort( char *findName )
{
#  ifdef  __SASC
   IMPORT struct ExecBase *SysBase;
#  endif
   
   struct List    *portsList;
   struct Node    *ptr;
   struct MsgPort *mport;

   OBJECT         *rval  = o_nil;
   char           *pname = NULL;
   
   Forbid();

#     ifdef  __SASC
      portsList = &SysBase->PortList;
#     else
      portsList = &((struct ExecBase *) IExec->Data.LibBase)->PortList;
#     endif

      ptr       = portsList->lh_Head;
      mport     = (struct MsgPort *) ptr;
      
      while (mport) // != NULL)
         {
         int len = 0;
         
         pname = mport->mp_Node.ln_Name;
         len   = StringLength( pname );
         
         if (len < 1)
            goto skipBlankPortName;

         // findName might have spaces after it, hence the strncmp() call.            
         if (StringNComp( pname, findName, len ) == 0)
            {
            rval = AssignObj( new_address( (ULONG) mport ) );
            
            Permit();
            
            return( rval );
            }

skipBlankPortName:

         mport = (struct MsgPort *) ((struct MsgPort *) mport)->mp_Node.ln_Succ;
         }
         
   Permit();
   
   return( rval );
}

/****i* NewPort() [3.0] **********************************************
*
* NAME
*    NewPort()
*
* DESCRIPTION
*    ^ <primitive 191 6 portName>
**********************************************************************
*
*/

METHODFUNC OBJECT *NewPort( char *portName )
{
   struct Message *message;
   char           *name;
   
   struct ATPort  *atport;
   OBJECT         *rval = o_nil;
   
   if (!(atport = (struct ATPort *) AT_AllocVec( sizeof( struct ATPort ), 
                                                 MEMF_CLEAR | MEMF_PUBLIC,
                                                 "atport", TRUE ))) // == NULL)
      {
      MemoryOut( MPortCMsg( MSG_MP_NEWPORT_FUNC_MPORT ) );

      return( rval );
      }

   if (!(atport->atp_MsgPort = CreateMsgPort())) // == NULL)
      {
      CannotCreatePort( MPortCMsg( MSG_MP_NEWPORT_FUNC_MPORT ) );

      AT_FreeVec( atport, "atport", TRUE );
      
      return( rval );
      }

   if (!(message = (struct Message *) AT_AllocVec( sizeof( struct Message ), 
                                                   MEMF_CLEAR | MEMF_PUBLIC,
                                                   "atMessage", TRUE ))) // == NULL)
      {
      MemoryOut( MPortCMsg( MSG_MP_NEWPORT_FUNC_MPORT ) );

      DeleteMsgPort( atport->atp_MsgPort );      

      AT_FreeVec( atport, "atport", TRUE );
      
      return( rval );
      }

   if (!(name = (char *) AT_AllocVec( 1 + StringLength( portName ), 
                                      MEMF_CLEAR | MEMF_PUBLIC,
                                      "msgString", TRUE ))) // == NULL)
      {
      MemoryOut( MPortCMsg( MSG_MP_NEWPORT_FUNC_MPORT ) );

      DeleteMsgPort( atport->atp_MsgPort );      

      AT_FreeVec( message, "atMessage", TRUE );
      AT_FreeVec( atport,  "atport",    TRUE );
      
      return( rval );
      }
   
   StringCopy( name, portName );
   
   atport->atp_PortName = name;
   atport->atp_Message  = message;
   atport->atp_MsgSize  = 0;        // For now.

   return( rval = AssignObj( new_address( (ULONG) atport ) ) );   
}

/****i* SendMessageOutside() [1.9] ***********************************
*
* NAME
*    SendMessageOutside()
*
* DESCRIPTION
*    <primitive 191 7 private toPortObj byteArray>
**********************************************************************
*
*/

METHODFUNC void SendMessageOutside( OBJECT    *portObj, 
                                    OBJECT    *dstPortObj, 
                                    BYTEARRAY *barray 
                                  )
{
   struct ATPort  *atport  = (struct ATPort  *) CheckObject( portObj );
   struct MsgPort *portout = (struct MsgPort *) CheckObject( dstPortObj );

   OBJECT *srcPortObj = o_nil;
   char   *array      = barray->bytes;
   char   *cptr       = NULL;
   int     size       = barray->bsize + sizeof( struct Message );
   int     i, j;

   if (NullChk( (OBJECT *) atport ) == TRUE)
      {
      NullFound( MPortCMsg( MSG_MP_SNDMSGOUT_SRC_MPORT ) );

      return; // ( rval );
      }
   else
      {
      struct MsgPort *src = atport->atp_MsgPort;
      
      srcPortObj = new_int( (int) src );
      }
      
   if (NullChk( (OBJECT *) portout ) == TRUE)
      {
      NullFound( MPortCMsg( MSG_MP_SNDMSGOUT_DST_MPORT ) );

      return; // ( rval );
      }

   if (PortInSystem( dstPortObj ) == o_false)
      {
      UserInfo( MPortCMsg( MSG_MP_NO_DESTPORT_MPORT ), UserProblem );

      return; // ( rval );
      }

   if (PortInSystem( srcPortObj ) == o_false)
      {
      UserInfo( MPortCMsg( MSG_MP_NO_SRCPORT_MPORT ), UserProblem );

      return; // ( rval );
      }

   if (!(cptr = (char *) AT_AllocVec( size, MEMF_ANY | MEMF_CLEAR, 
                                      "msgString", TRUE ))) // == NULL)
      {
      sprintf( ErrMsg, MPortCMsg( MSG_FMT_MP_MSG_MPORT ), size );
      
      MemoryOut( ErrMsg );
      
      return; // ( rval );
      }
   
   atport->atp_Message->mn_ReplyPort = atport->atp_MsgPort;
   atport->atp_Message->mn_Length    = size;

   // Copy the struct Message data to cptr:
   CopyMem( (char *) atport->atp_Message, cptr, (long) sizeof( struct Message ) );

   // Copy the user message data:
   for (j = 0, i = sizeof( struct Message ); i < size; j++, i++)
      *(cptr + i) = *(array + j);

   PutMsg( portout, (struct Message *) cptr ); // Send out kludged-up Message

   WaitPort( atport->atp_Message->mn_ReplyPort );

   (void) GetMsg( atport->atp_Message->mn_ReplyPort ); // ignore Reply.

   if (cptr) // != NULL)
      AT_FreeVec( cptr, "msgString", TRUE );
   
   return;
}

/****i* getMsgPort() [2.1] *******************************************
*
* NAME
*    getMsgPort()
*
* DESCRIPTION
*    Return the ATPort->atp_MsgPort field.
*    ^ <primitive 191 8 private>
**********************************************************************
*
*/

METHODFUNC OBJECT *getMsgPort( OBJECT *atPortObj )
{
   struct ATPort *atport = (struct ATPort  *) CheckObject( atPortObj );
  
   if (NullChk( (OBJECT *) atport ) == TRUE)
      return( o_nil );
      
   return( AssignObj( new_address( (ULONG) atport->atp_MsgPort )));
}

/****i* getMsgField() [2.1] ******************************************
*
* NAME
*    getMsgField()
*
* DESCRIPTION
*    Return the ATPort->atp_Message field.
*    ^ <primitive 191 9 private>
**********************************************************************
*
*/

METHODFUNC OBJECT *getMsgField( OBJECT *atPortObj )
{
   struct ATPort *atport = (struct ATPort  *) CheckObject( atPortObj );
  
   if (NullChk( (OBJECT *) atport ) == TRUE)
      return( o_nil );
      
   return( AssignObj( new_address( (ULONG) atport->atp_Message )));
}

/****i* replyMessage() [3.0] *****************************************
*
* NAME
*    replyMessage()
*
* DESCRIPTION
*    Reply to a sent message.
*    ^ <primitive 191 10 private>
**********************************************************************
*
*/

METHODFUNC void replyMessage( OBJECT *atportObj )
{
   struct ATPort *atport = (struct ATPort *) CheckObject( atportObj );
   
   if (NullChk( (OBJECT *) atport ) == TRUE)
      return;

   ReplyMsg( (struct Message *) atport->atp_Message );
   
   return;
}

/****h* HandleMsgPorts() [3.0] ***************************************
*
* NAME
*    HandleMsgPorts()
*
* DESCRIPTION
*    Implement primitive 191 to the System MsgPorts.
**********************************************************************
*
*/

PUBLIC OBJECT *HandleMsgPorts( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
      
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 191 );
      return( rval );
      }
         
   switch (int_value( args[0] ))
      {
      case 0: // killPort [private] <primitive 191 0 private> 
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 191 );
         else
            {
            KillPort( args[1] );
            }

         break;
      
      case 1: // addPort: [private] msgSize priority: p
              // ^ <primitive 191 1 private msgSize p>
         if ( !is_address( args[1] ) || !is_integer( args[2] )
                                     || !is_integer( args[3] ))
            (void) PrintArgTypeError( 191 );
         else
            rval = MakePort( args[1], int_value( args[2] ), 
                                      int_value( args[3] )
                           );

         break;

      case 2: // getMessage [private]
              // ^ <primitive 191 2 private>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 191 );
         else
            rval = GetMessage( args[1] );
   
         break;

      case 3: // sendMessage: [private] aTalkMsgPortObj msg: byteArray
              // <primitive 191 3 private destPortObject byteArray>
         if (  !is_address( args[1] ) || !is_address( args[2] )
            || !is_bytearray( args[3] ))
            (void) PrintArgTypeError( 191 );
         else
            SendMessage( args[1], args[2], (BYTEARRAY *) args[3] );

         break;
      
      case 4:// checkForPort [private]
             //   ^ <primtive 191 4 private> "Return either true or false."
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 191 );
         else
            {
            struct ATPort  *atport = (struct ATPort *) CheckObject( args[1] );
            struct MsgPort *src    = atport->atp_MsgPort;
      
            rval = PortInSystem( new_address( (ULONG) src ) );
            }

         break;
  
      case 5: // getNamedSystemPort: sysPortName
              //   ^ <primitive 191 5 sysPortName>
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 191 );
         else
            rval = GetNamedSystemPort( string_value( (STRING *) args[1] ) );
            
         break;

      case 6: // new: newPortName
              //   private  <- <primitive 191 6 newPortName>.
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 191 );
         else
            rval = NewPort( string_value( (STRING *) args[1] ) );

         break;

      case 7: // sendMessageOutsideTo: [private] systemPortObj msg: byteArray
              // <primitive 191 7 private systemPortObj byteArray>
         if ( !is_address( args[1] ) || !is_address(   args[2] )
                                     || !is_bytearray( args[3] ))
            (void) PrintArgTypeError( 191 );
         else
            SendMessageOutside( args[1], args[2], (BYTEARRAY *) args[3] );

         break;

      case 8: // getMsgPort [private]
              // ^ <primitive 191 8 private>.
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 191 );
         else
            rval = getMsgPort( args[1] );
   
         break;

      case 9: // getMsgField [private]
              // ^ <primitive 191 9 private>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 191 );
         else
            rval = getMsgField( args[1] );
   
         break;

      case 10: // replyMessage [private]  <primitive 191 10 private>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 191 );
         else
            replyMessage( args[1] );
   
         break;

      default:
         (void) PrintArgTypeError( 191 );
         break;
      }

   return( rval );
}

/* ------------------ END of MsgPort.c file! ------------------------- */
