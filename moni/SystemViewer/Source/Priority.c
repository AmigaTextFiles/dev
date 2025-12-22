/****h *Priority/Priority.c *******************************************
**
** NAME
**    Priority.c
**
** DESCRIPTION
**    Change the priority of a given system object.
**
** FUNCTIONAL INTERFACE:
**    PUBLIC int ChangePriorityHandler( char *name, 
**                                      int ObjType,
**                                      int frompri 
**                                    );
**
***********************************************************************
*/

#include <string.h>

#include <exec/types.h>
#include <exec/nodes.h>
#include <exec/devices.h>
#include <exec/resident.h>
#include <exec/execbase.h>

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
#include <clib/diskfont_protos.h>

#include "SysLists.h"

#include "CPGM:GlobalObjects/CommonFuncs.h"

#define IntBfPtr( g ) (((struct StringInfo *)g->SpecialInfo)->LongInt)

#define ObjNameTxt  0
#define FromPriNum  1
#define ToPriInt    2
#define OkayBt      3
#define CancelBt    4

#define PRIORITYGADGET PrGadgets[ ToPriInt ]

#define TO_PRIORITY    IntBfPtr( PrGadgets[ ToPriInt ] )

#define Pr_CNT      5

// -------- See SysCommon.c file: --------------------------------
IMPORT int  SetupSystemList( int (*OpenWindowFunc)( void ) );
IMPORT void ShutdownSystemList( void );

// ---------------------------------------------------------------

IMPORT struct TextAttr *Font;
IMPORT struct ExecBase *SysBase;

// ---------------------------------------------------------------

PRIVATE struct TextFont *PrFont        = NULL;

PRIVATE struct Window         *PrWnd   = NULL;
PRIVATE struct Gadget         *PrGList = NULL;
PRIVATE struct IntuiMessage    PrMsg;
PRIVATE struct Gadget         *PrGadgets[ Pr_CNT ];

PRIVATE UWORD  PrLeft   = 70;
PRIVATE UWORD  PrTop    = 32;
PRIVATE UWORD  PrWidth  = 475;
PRIVATE UWORD  PrHeight = 115;
PRIVATE UBYTE *PrWdt    = (UBYTE *) "Priority Changer:";

PRIVATE int   ObjectType  = 0; // described by NT_DEVICE, NT_LIBRARY, etc.
PRIVATE int   NewPriority = 0;
PRIVATE char *Object_Name = NULL;

PRIVATE struct IntuiText PrIText[1] = {
   
   2, 0, JAM1,235, 12, NULL, 
   (UBYTE *) "DANGER!  Know what you're doing!", NULL 
};

PRIVATE UWORD PrGTypes[] = {

   TEXT_KIND,   NUMBER_KIND, INTEGER_KIND,
   BUTTON_KIND, BUTTON_KIND
};

PRIVATE int ToPriIntClicked( void );
PRIVATE int OkayBtClicked(   void );
PRIVATE int CancelBtClicked( void );

PRIVATE struct NewGadget PrNGad[] = {

    70, 40, 350, 17, (UBYTE *) "Change Priority of: ", NULL, ObjNameTxt, 
  PLACETEXT_ABOVE, NULL, NULL,
  
    70, 64,  50, 17, (UBYTE *) "From:",                NULL, FromPriNum, 
   PLACETEXT_LEFT, NULL, NULL,
   
   370, 64,  50, 17, (UBYTE *) "To:",                  NULL, ToPriInt, 
   PLACETEXT_LEFT, NULL, (APTR) ToPriIntClicked,

    70, 90, 120, 17, (UBYTE *) "CHANGE IT!",           NULL, OkayBt, 
   PLACETEXT_IN, NULL, (APTR) OkayBtClicked,

   350, 90,  70, 17, (UBYTE *) "_CANCEL",              NULL, CancelBt, 
   PLACETEXT_IN, NULL, (APTR) CancelBtClicked
};

PRIVATE ULONG PrGTags[] = {

   (GTTX_Border), TRUE, (TAG_DONE),  // Object Name.
   (GTNM_Border), TRUE, (TAG_DONE),  // From Priority.

   (GA_TabCycle), FALSE, (GTIN_Number), 0, // To Priority Integer.
   (GTIN_MaxChars), 10, 
   (STRINGA_Justification), (GACT_STRINGCENTER), (TAG_DONE),

   (TAG_DONE),                      // Okay button.
   (GT_Underscore), '_', (TAG_DONE) // Cancel button.
};

// -------------------------------------------------------------------

PRIVATE void ClosePrWindow( void )
{
   if (PrWnd != NULL) 
      {
      CloseWindow( PrWnd );
      PrWnd = NULL;
      }

   if (PrGList != NULL) 
      {
      FreeGadgets( PrGList );
      PrGList = NULL;
      }

   if (PrFont != NULL) 
      {
      CloseFont( PrFont );
      PrFont = NULL;
      }

   return;
}

PRIVATE void *FindNamedNode( struct Node *node, char *name )
{
   void *rval = NULL;

   while (node != NULL)
      {
      if (strcmp( node->ln_Name, name ) == 0)
         {
         rval = (void *) node;
         break;
         }
              
      node = node->ln_Succ;  
      }

   return( rval );   
}

PRIVATE void *GetNodePtr( int objtype )
{
   struct List *DevListPtr = NULL;
   struct Node *ptr        = NULL;

   void *rval = NULL;

   if (strlen( Object_Name ) < 1)
      {
      UserInfo( "No name given to GetNodePtr()!", "Program ERROR:" );

      return( rval );
      }

   switch (objtype)
      {
      case NT_DEVICE:
         {
         struct Device *d = NULL;

         Forbid();         

            DevListPtr = &SysBase->DeviceList;
            ptr        = DevListPtr->lh_Head;
            d          = (struct Device  *) ptr;

            while (d != NULL)
               {
               if (strcmp( d->dd_Library.lib_Node.ln_Name, 
                           Object_Name ) == 0)
                  {
                  rval = (void *) (&(d->dd_Library.lib_Node));
                  break;
                  }
               
               d = (struct Device *) d->dd_Library.lib_Node.ln_Succ;  
               }
               
         Permit();
         }
         break;

      case NT_LIBRARY:
         {
         struct Library *d;
         
         Forbid();         

            DevListPtr = &SysBase->LibList;
            ptr        = DevListPtr->lh_Head;
            d          = (struct Library *) ptr;

            rval       = FindNamedNode( &(d->lib_Node), Object_Name );
               
         Permit();
         }
         break;

      case NT_RESOURCE:
         {
         struct Library *d;
         
         Forbid();         

            DevListPtr = &SysBase->ResourceList;
            ptr        = DevListPtr->lh_Head;
            d          = (struct Library *) ptr;

            rval       = FindNamedNode( &(d->lib_Node), Object_Name );
               
         Permit();
         }
         break;

      case NT_MEMORY:
         {
         struct Node *d = NULL;
         
         Forbid();         

            DevListPtr = &SysBase->LibList;
            d          = DevListPtr->lh_Head;

            rval       = FindNamedNode( d, Object_Name );
               
         Permit();
         }
         break;

      case NT_TASK:
      case NT_PROCESS:
         {
         struct Task *d = SysBase->ThisTask;

         Forbid();         

            rval = FindNamedNode( &(d->tc_Node), Object_Name );
               
         Permit();
         }
         break;

      case NT_INTERRUPT:
         {
         struct Node *d = NULL;
         
         Forbid();         

            DevListPtr = &SysBase->IntrList;
            d          = DevListPtr->lh_Head;

            rval       = FindNamedNode( d, Object_Name );
               
         Permit();
         }
         break;

      case NT_MSGPORT:
         {
         struct Node *d = NULL;
         
         Forbid();         

            DevListPtr = &SysBase->PortList;
            d          = DevListPtr->lh_Head;

            rval       = FindNamedNode( d, Object_Name );
               
         Permit();
         }
         break;

      default:
         {
         // struct Resident looks like a Library ROMTag:
         struct Resident *d = SysBase->ResModules;
         
         Forbid();         

            while (d != NULL)
               {
               if (strcmp( d->rt_Name, Object_Name ) == 0) // rt_IdString??
                  {
                  // Residents are other types of system objects:

                  rval = GetNodePtr( d->rt_Type ); // Recursion!!
                  break;
                  }
               
               d++;
               }

         Permit();
         }
         break;
      }

   return( rval );
}

PRIVATE int ToPriIntClicked( void )
{
   NewPriority = IntBfPtr( PRIORITYGADGET );

   return( (int) TRUE );
}

PRIVATE int OkayBtClicked( void )
{
   struct Node *node = (struct Node *) GetNodePtr( ObjectType );

   struct Node  savednode = { 0, };

    
   if (node == NULL)
      {
      sprintf( ErrMsg, "Couldn't find %s in System Lists!", Object_Name );

      UserInfo( ErrMsg, "User ERROR?" );
      
      return( (int) TRUE );
      }

   CopyMem( node, (APTR) &savednode, (long) sizeof( struct Node ) );

   savednode.ln_Pri = NewPriority;

   if ((node->ln_Type == NT_TASK) || (node->ln_Type == NT_PROCESS))
      {
      (void) SetTaskPri( (struct Task *) node, NewPriority );
      // Throw away old priority.
      }
   else
      {
      Forbid();

         if (node->ln_Type == NT_INTERRUPT)
            {
            Disable();

               Remove( node );
               Enqueue( &SysBase->IntrList, &savednode );

            Enable();
            }
         else
            {
            Remove( node );

            switch (node->ln_Type)
               {
               case NT_LIBRARY:
                  Enqueue( &SysBase->LibList, &savednode );
                  break;
      
               case NT_RESOURCE:
                  Enqueue( &SysBase->ResourceList, &savednode );
                  break;
         
               case NT_DEVICE:
                  Enqueue( &SysBase->DeviceList, &savednode );
                  break;

               case NT_MEMORY:
                  Enqueue( &SysBase->MemList, &savednode );
                  break;

               case NT_MSGPORT:
                  Enqueue( &SysBase->PortList, &savednode );

               default:
                  break;
               }
            }

      Permit(); 
      }

   ClosePrWindow();
   return( (int) FALSE );
}

PRIVATE int CancelBtClicked( void )
{
   ClosePrWindow();
   return( (int) FALSE );
}

PRIVATE int PrVanillaKey( int whichkey )
{
   int rval = TRUE;

   switch (whichkey)
      {
      case 'c':
      case 'C':
      case 'x':
      case 'X':
      case 'q':
      case 'Q':
         rval = CancelBtClicked();
         
      default:
         break;
      }

   return( rval );
}

// --------------------------------------------------------------

PRIVATE void PrRender( void )
{
   struct IntuiText it;

   ComputeFont( Scr, Font, &CFont, PrWidth, PrHeight );


   CopyMem( (char *) PrIText, (char *) &it, 
            (long) sizeof( struct IntuiText )
          );

   it.ITextFont = Font;

   it.LeftEdge  = CFont.OffX + ComputeX( CFont.FontX, it.LeftEdge ) 
                  - (IntuiTextLength( &it ) >> 1);

   it.TopEdge   = CFont.OffY + ComputeY( CFont.FontY, it.TopEdge ) 
                  - (Font->ta_YSize >> 1);

   PrintIText( PrWnd->RPort, &it, 0, 0 );

   return;
}

PRIVATE int OpenPrWindow( void )
{
   struct NewGadget  ng;
   struct Gadget    *g;
   UWORD             lc, tc;
   UWORD             wleft = PrLeft, wtop = PrTop, ww, wh;

   ComputeFont( Scr, Font, &CFont, PrWidth, PrHeight );

   ww = ComputeX( CFont.FontX, PrWidth );
   wh = ComputeY( CFont.FontY, PrHeight );

   if ((wleft + ww + CFont.OffX + Scr->WBorRight) > Scr->Width) 
      wleft = Scr->Width - ww;
   
   if ((wtop + wh + CFont.OffY + Scr->WBorBottom) > Scr->Height) 
      wtop = Scr->Height - wh;

   if ((PrFont = OpenDiskFont( Font )) == NULL)
      return( -5 );

   if ((g = CreateContext( &PrGList )) == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < Pr_CNT; lc++) 
      {
      CopyMem( (char *) &PrNGad[ lc ], (char *) &ng, 
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

      PrGadgets[ lc ] = g = CreateGadgetA( (ULONG) PrGTypes[ lc ], 
                              g, 
                              &ng, 
                              (struct TagItem *) &PrGTags[ tc ] );

      while (PrGTags[ tc ] != NULL) 
         tc += 2;
      
      tc++;

      if (g == NULL)
         return( -2 );
      }

   if ((PrWnd = OpenWindowTags( NULL,

            WA_Left,        wleft,
            WA_Top,         wtop,
            WA_Width,       ww + CFont.OffX + Scr->WBorRight,
            WA_Height,      wh + CFont.OffY + Scr->WBorBottom,

            WA_IDCMP,       TEXTIDCMP | NUMBERIDCMP | INTEGERIDCMP
              | BUTTONIDCMP | IDCMP_GADGETDOWN | IDCMP_VANILLAKEY
              | IDCMP_REFRESHWINDOW,

            WA_Flags,       WFLG_DRAGBAR | WFLG_DEPTHGADGET 
              | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,

            WA_Gadgets,     PrGList,
            WA_Title,       PrWdt,
            WA_ScreenTitle, ScrTitle,
            TAG_DONE )

      ) == NULL)
      return( -4 );

   GT_RefreshWindow( PrWnd, NULL );

   PrRender();

   return( 0 );
}

PRIVATE int HandlePrIDCMP( void )
{
   struct IntuiMessage *m;
   int                (*func)( void );
   BOOL                 running = TRUE;

   while (running == TRUE)
      {
      if ((m = GT_GetIMsg( PrWnd->UserPort )) == NULL) 
         {
         (void) Wait( 1L << PrWnd->UserPort->mp_SigBit );
         continue;
         }

      CopyMem( (char *) m, (char *) &PrMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (PrMsg.Class) 
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( PrWnd );
            PrRender();
            GT_EndRefresh( PrWnd, TRUE );
            break;

         case IDCMP_VANILLAKEY:
            running = PrVanillaKey( PrMsg.Code );
            break;

         case IDCMP_GADGETUP:
         case IDCMP_GADGETDOWN:
            func = (void *) ((struct Gadget *)PrMsg.IAddress)->UserData;
            if (func != NULL)
               running = func();
   
            break;
         }
      }

   return( running );
}

PUBLIC int ChangePriorityHandler( char *name, int ObjType, int frompri )
{
   int rval = 0;

   Object_Name = name;   
   ObjectType  = ObjType;

   if (OpenPrWindow() < 0)
      return( rval = -1 );

   SetNotifyWindow( PrWnd );

   GT_SetGadgetAttrs( PrGadgets[ FromPriNum ], PrWnd, NULL,
                      GTNM_Number, frompri, TAG_DONE
                    );

   GT_SetGadgetAttrs( PrGadgets[ ObjNameTxt ], PrWnd, NULL,
                      GTTX_Text, (STRPTR) name, TAG_DONE
                    );

   GT_RefreshWindow( PrWnd, NULL );

   PrRender();

   rval = HandlePrIDCMP();

   if (rval == FALSE)
      rval = 0;
               
   return( rval );
}

#ifdef DEBUG

PUBLIC int main( int argc, char **argv )
{
   int rval = 0;

   if (argc != 4)
      {
      fprintf( stderr, "USAGE:  %s objname objtype oldpri\n", argv[0] );
      return( RETURN_ERROR );
      }

   if (SetupSystemList( &OpenPrWindow ) < 0)
      {
      fprintf( stderr, "Couldn't setup %s!\n", argv[0] );
      return( RETURN_FAIL );
      }

   SetNotifyWindow( PrWnd );      

   rval = ChangePriorityHandler( argv[1],
                                 atoi( argv[2] ),
                                 atoi( argv[3] )
                               );
   ShutdownSystemList();   

   return( rval );
}

#endif

/* ----------------- END of Priority.c file! ------------------- */
