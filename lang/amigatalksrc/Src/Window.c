/****h* AmigaTalk/Window.c [2.3] ***************************************
*
* NAME
*    Window.c 
* 
* DESCRIPTION
*    Functions that handle AmigaTalk window primitives.
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    03-Jan-2003 - Moved all Error & message strings to ReportErrs.c
*
*    27-Feb-2002 - Added HelpControl() primitive.
*    25-Feb-2002 - Added a method to obtain the Window Signal Bit.
*
* NOTES
*    $VER: AmigaTalk:Src/Window.c 2.3 (25-Oct-2004) by J.T. Steichen
************************************************************************
*
*/

#include <stdio.h>

#include <exec/types.h>
#include <exec/memory.h>

#include <AmigaDOSErrs.h>

#include <graphics/sprite.h>

#ifdef __SASC

# include <clib/intuition_protos.h>
# include <clib/gadtools_protos.h>

IMPORT struct IntuitionBase *IntuitionBase;

#else

# define __USE_INLINE__

# include <proto/intuition.h>
# include <proto/gadtools.h>

IMPORT struct Library *IntuitionBase;
IMPORT struct IntuitionIFace *IIntuition;

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ATStructs.h"

#include "Object.h"
#include "Constants.h"
#include "IStructs.h"
#include "FuncProtos.h"

IMPORT struct Window *ATWnd;

IMPORT OBJECT *o_true, *o_false, *o_nil;

IMPORT UBYTE  *DefaultButtons;
IMPORT UBYTE  *ErrMsg;

IMPORT int      ChkArgCount( int need, int numargs, int primnumber );
IMPORT OBJECT  *ReturnError( void );
IMPORT OBJECT  *PrintArgTypeError( int primnumber );

IMPORT struct Window *FindWindowPtr( char *windowname );

#define  CHIPMEM  MEMF_CLEAR | MEMF_CHIP
#define  FASTMEM  MEMF_CLEAR | MEMF_FAST | MEMF_PUBLIC

// --------------------------------------------------------------------

/****i* CloseAWindow() [1.9] *****************************************
*
* NAME
*    CloseAWindow()
*
* DESCRIPTION
*    <primitive 181 0 private>
**********************************************************************
*
*/

METHODFUNC void CloseAWindow( struct Window *wp )
{
   if (wp->MenuStrip) // != NULL)
      ClearMenuStrip( wp );

   CloseWindow( wp );

   return;
}

PRIVATE struct	NewWindow hidden_nw = {

   0, 0, 640, 480, 0xFF, 0xFF, IDCMP_CLOSEWINDOW,
   WFLG_CLOSEGADGET | WFLG_ACTIVATE | WFLG_SMART_REFRESH | WFLG_RMBTRAP,
   NULL, NULL, NULL, NULL, NULL,
   10, 10, 640, 480, CUSTOMSCREEN
};

/****i* CopyDefaultWindow() [1.0] ************************************
*
* NAME
*    CopyDefaultWindow()
*
* DESCRIPTION
*    Copy hidden_nw defaults to newwind.
**********************************************************************
*
*/

SUBFUNC void CopyDefaultWindow( struct NewWindow *newwind )
{
   // ( src, dest, size )

   CopyMem( (char *) &hidden_nw, (char *) newwind, 
            (long) sizeof( struct NewWindow ) 
          );

   return;
}

/****i* OpenAWindow() [1.9] ******************************************
*
* NAME
*    OpenAWindow()
*
* DESCRIPTION
*    private <- <primitive 181 1 screenObj savedTitle>
**********************************************************************
*
*/
  
METHODFUNC OBJECT *OpenAWindow( struct Screen *sp, char *windowtitle )
{
   struct Window *wp = FindWindowPtr( windowtitle );

   struct NewWindow  newwind;

   OBJECT *rval = o_nil;
   
   if (!wp) // == NULL)
      {
      CopyDefaultWindow( &newwind );     // Copy hidden_nw to newwind.

      newwind.Type = sp->ViewPort.Modes;

      wp = OpenWindowTags( &newwind, 
    
                           WA_ScreenTitle,  sp->Title,
                           WA_Title,        windowtitle,
                           WA_CustomScreen, sp,
                           TAG_END
                         );
      if (wp) // != NULL)
         {
         rval = AssignObj( new_address( (ULONG) wp ) );
   
         return( rval ); // Window is in the system!
         }
      else
         {
         NotOpened( 1 ); // Window did not open!

         return( rval );
         }
      }
   else
      {
      AlreadyOpen( windowtitle );

      rval = AssignObj( new_address( (ULONG) wp ) );
      }

   return( rval );  
}

/****i* GetWindowPart() [2.0] ****************************************
*
* NAME
*    GetWindowpart()
*
* DESCRIPTION
*    ^ <primitive 181 2 whichPart private>
**********************************************************************
*
*/

METHODFUNC OBJECT *GetWindowPart( int whichpart, struct Window *wp )
{
   OBJECT *rval = o_nil;

   switch (whichpart)
      {
      case 0:  
         rval = AssignObj( new_int( wp->LeftEdge ) );
         break;

      case 1:  
         rval = AssignObj( new_int( wp->TopEdge ) );
         break;

      case 2:  
         rval = AssignObj( new_int( wp->Width ) );
         break;

      case 3:  
         rval = AssignObj( new_int( wp->Height ) );
         break;

      case 4:  
         rval = AssignObj( new_int( wp->DetailPen ) );
         break;

      case 5:  
         rval = AssignObj( new_int( wp->BlockPen ) );
         break;

      case 6:  
         rval = AssignObj( new_int( wp->Flags ) );
         break;

      case 7:  
         rval = AssignObj( new_int( wp->IDCMPFlags ) );
         break;

      case 8:  
         rval = AssignObj( new_int( wp->MouseX ) );
         break;

      case 9:  
         rval = AssignObj( new_int( wp->MouseY ) );
         break;

      case 10: 
         rval = AssignObj( new_str( wp->Title ) );
         break;

      case 11: 
         rval = AssignObj( new_int( wp->ReqCount ) );
         break;

      case 12: 
         rval = AssignObj( new_int( wp->PtrWidth ) );
         break;

      case 13: 
         rval = AssignObj( new_int( wp->PtrHeight ) );
         break;

      case 14: 
         rval = AssignObj( new_int( wp->XOffset ) );
         break;

      case 15: 
         rval = AssignObj( new_int( wp->YOffset ) );
         break;

      case 16: 
         rval = AssignObj( new_str( wp->ScreenTitle ) );
         break;
      
      case 17: // getWindowSignal method added on 25-Feb-2002:
         rval = AssignObj( new_int( (int) (1L << wp->UserPort->mp_SigBit) ) );
         break;

      case 18: // getBorderLeft added on 27-Feb-2002:
         rval = AssignObj( new_int( (int) wp->BorderLeft ) );
         break;
         
      case 19: // getBorderTop
         rval = AssignObj( new_int( (int) wp->BorderTop ) );
         break;
         
      case 20: // getBorderRight
         rval = AssignObj( new_int( (int) wp->BorderRight ) );
         break;
         
      case 21: // getBorderBottom
         rval = AssignObj( new_int( (int) wp->BorderBottom ) );
         break;

      case 22: // getCheckMarkImage
         rval = AssignObj( new_address( (ULONG) wp->CheckMark ) );
         break;
                 
      case 23: // getUserData
         rval = AssignObj( new_address( (ULONG) wp->UserData ) );
         break;
          
      default: break;
      }

   return( rval );
}

/****i* SetWindowPart() [1.9] ****************************************
*
* NAME
*    SetWindowpart()
*
* DESCRIPTION
*    <primitive 181 3 whichPart newObject>
**********************************************************************
*
*/

METHODFUNC void SetWindowPart( int whichpart, OBJECT *whatvalue )
{
   if (whichpart > 14 || whichpart < 0)
      return;
   
   if (NullChk( whatvalue ) == TRUE)
      return;

   switch (whichpart)
      {
      case 0: hidden_nw.LeftEdge    = int_value( whatvalue );
              break;
      case 1: hidden_nw.TopEdge     = int_value( whatvalue );
              break;
      case 2: hidden_nw.Width       = int_value( whatvalue );
              break;
      case 3: hidden_nw.Height      = int_value( whatvalue );
              break;
      case 4: hidden_nw.DetailPen   = int_value( whatvalue );
              break;
      case 5: hidden_nw.BlockPen    = int_value( whatvalue );
              break;
      case 6: hidden_nw.Flags       = int_value( whatvalue );
              break;
      case 7: hidden_nw.IDCMPFlags  = int_value( whatvalue );
              break;
      case 8: hidden_nw.MinWidth    = int_value( whatvalue );
              break;
      case 9: hidden_nw.MinHeight   = int_value( whatvalue );
              break;

      case 10: hidden_nw.MaxWidth   = int_value( whatvalue );
               break;
      case 11: hidden_nw.MaxHeight  = int_value( whatvalue );
               break;

      case 12:
         {
         struct Gadget *gp = (struct Gadget *) CheckObject( whatvalue );
         
         if (gp) // != NULL)
            hidden_nw.FirstGadget = gp;
         }

         break;

      case 13:
         {
         struct Image *ip = (struct Image *) CheckObject( whatvalue );
         
         if (ip) // != NULL)
            hidden_nw.CheckMark = ip;
         }

         break;
               
      case 14:
         {
         struct BitMap *bp = (struct BitMap *) CheckObject( whatvalue );
         
         if (bp) // != NULL)
            hidden_nw.BitMap = bp;
         }

      default: 
         break;
      }

   return;
}

char  *WinFuncs0[10] = {
   
   "BeginRefresh", "EndRefresh", "RemakeDisplay", "RethinkDisplay", 
   "RemoveDMRequest", "WindowToBack", "WindowToFront", "RemoveMenuStrip",
   "RefreshGadgets", "RefreshWindowFrame"
};

/****i* ExecWindowFunc0() [1.0] **************************************
*
* NAME
*    ExecWindowFunc0()
*
* DESCRIPTION
*    <primitive 181 4 'functionName' private>
**********************************************************************
*
*/

METHODFUNC void ExecWindowFunc0( char *funcname, struct Window *wp )
{
   int whichfunc = 0;

   while (whichfunc < 10)
      if (StringComp( WinFuncs0[ whichfunc ], funcname ) == 0)
         break;
      else
         whichfunc++;
   
   switch (whichfunc)
      {
      case 0:  BeginRefresh( wp );
               break;
      case 1:  EndRefresh( wp, TRUE );
               break;
      case 2:  RemakeDisplay();
               break;
      case 3:  RethinkDisplay();
               break;
      case 4:  ClearDMRequest( wp ); 
               break;
      case 5:  WindowToBack( wp );
               break;
      case 6:  WindowToFront( wp ); 
               break;
      case 7:  ClearMenuStrip( wp );
               break;
      case 8:  RefreshGadgets( wp->FirstGadget, wp, NULL );
               break;
      case 9:  RefreshWindowFrame( wp );
               break;
      default: break;
      }

   return;
}

char  *WinFuncs1[3] = { "ShowRequester", "AddDMRequest", "AddMenuStrip" };

/****i* ExecWindowFunc1() [1.0] **************************************
*
* NAME
*    ExecWindowFunc1()
*
* DESCRIPTION
*    <primitive 181 5 'functionName' argObject private>
**********************************************************************
*
*/

METHODFUNC void ExecWindowFunc1( char *funcname, OBJECT *arg1, struct Window *wp )
{
   struct Requester *rq;
   struct Menu      *mp;
   int               whichfunc = 0;

   while (whichfunc < 3)
      if (StringComp( WinFuncs1[ whichfunc ], funcname ) == 0)
         break;
      else
         whichfunc++;
   
   switch (whichfunc)
      {
      case 0: // ShowRequester
         rq = (struct Requester *) CheckObject( arg1 );

         if (rq) // != NULL)
            Request( rq, wp );

         break;
               
      case 1: // AddDMRequest (OBSOLETE!!)
         rq = (struct Requester *) CheckObject( arg1 );

         if (rq) // != NULL)
            SetDMRequest( wp, rq );

         break;

      case 2: // AddMenuStrip
         mp = (struct Menu *) CheckObject( arg1 );

         if (mp) // != NULL)
            SetMenuStrip( wp, mp );

         break;
      
      default:
         break;
      }

   return;
}

char  *WinFuncs2[2] = { "MoveWindow", "SetWindowSize" };

/****i* ExecWindowFunc2() [1.0] **************************************
*
* NAME
*    ExecWindowFunc2()
*
* DESCRIPTION
*    <primitive 181 6 'functionName' arg1 arg2 private>
**********************************************************************
*
*/

METHODFUNC void ExecWindowFunc2( char *funcname, int arg1, int arg2, 
                                 struct Window *wp
                               )
{
   int whichfunc = 0;
   
   while (whichfunc < 2)
      if (StringComp( WinFuncs2[ whichfunc ], funcname ) == 0)
         break;
      else
         whichfunc++;
   
   switch (whichfunc)
      {
      case 0:
         MoveWindow( wp, arg1, arg2 );
         break;
      
      case 1:
         SizeWindow( wp, arg1, arg2 );

      default: 
         break;
      }

   return;
}

/****i* SetWPointer() [1.0] ******************************************
*
* NAME
*    SetWPointer()
*
* DESCRIPTION  OBSOLETE!!!!
*    <primitive 181 8 spriteObj h w x y private> 
**********************************************************************
*
*/

METHODFUNC void SetWPointer( OBJECT        *spriteObj, 
                             int            height, 
                             int            width,
                             int            xoffset, 
                             int            yoffset, 
                             struct Window *wp
                           )
{
   struct SimpleSprite *sp = (struct SimpleSprite *) CheckObject( spriteObj );

   if (!sp) // == NULL)
      return;

   SetPointer( wp, (UWORD *) sp, height, width, xoffset, yoffset );

   return;
}

/****i* setWindowPointer() [1.0] *************************************
*
* NAME
*    setWindowPointer()
*
* DESCRIPTION
*    <primitive 181 20 private tagArray> 
**********************************************************************
*
*/

METHODFUNC void setWindowPointer( OBJECT *winObj, OBJECT *tagArray )
{
   IMPORT struct TagItem *ArrayToTagList( OBJECT *inArray );

   struct Window  *wptr = (struct Window *) CheckObject( winObj );
   struct TagItem *tags = NULL;
   
   if (!wptr) // == NULL)
      return;

   if (NullChk( tagArray ) == FALSE)
      tags = ArrayToTagList( tagArray );
   
   SetWindowPointerA( wptr, tags );

   if (tags) // != NULL)
      AT_FreeVec( tags, "windowPointerTags", TRUE );
   
   return;
}


/****i* AddWGadget() [1.0] *******************************************
*
* NAME
*    AddWGadget()
*
* DESCRIPTION
*    <primitive 181 9 gadgetObject private>
**********************************************************************
*
*/

METHODFUNC void AddWGadget( OBJECT *GadgetObj, struct Window *wp )
{
   struct Gadget *gptr = (struct Gadget *) CheckObject( GadgetObj );

   if (!gptr) // == NULL)
      return;
   
   (void) AddGadget( wp, gptr, -1 );

   RefreshGadgets( gptr, wp, 0L );

   return;
}

/****i* RemoveWGadget() [1.0] ****************************************
*
* NAME
*    RemoveWGadget()
*
* DESCRIPTION
*    <primitive 181 10 gadgetObject private>
**********************************************************************
*
*/

METHODFUNC void RemoveWGadget( OBJECT *GadgetObj, struct Window *wp )
{
   struct Gadget *gptr = (struct Gadget *) CheckObject( GadgetObj );
   
   if (!gptr) // == NULL)
      return;

   (void) RemoveGadget( wp, gptr );

   RefreshGadgets( wp->FirstGadget, wp, 0L );

   return;
}

/****i* ReportWMouse() [1.0] *****************************************
*
* NAME
*    ReportWMouse()
*
* DESCRIPTION
*    <primitive 181 11 boolValue private>
**********************************************************************
*
*/

METHODFUNC void ReportWMouse( int on_off, struct Window *wp )
{
   ReportMouse( on_off, wp );

   return;
}

/****i* ChangeWindowTitle() [1.0] ************************************
*
* NAME
*    ChangeWindowTitle()
*
* DESCRIPTION
*    <primitive 181 12 newTitle private>
**********************************************************************
*
*/

METHODFUNC void ChangeWindowTitle( char *newTitle, struct Window *wp )
{
   DisplayTitle( wp, newTitle ); // CommonFuncs.o 

   return;
}

/****i* PrintIntuiText() [1.0] ***************************************
*
* NAME
*    PrintIntuiText()
*
* DESCRIPTION
*    <primitive 181 14 iTextObj x y private>
**********************************************************************
*
*/

METHODFUNC void PrintIntuiText( OBJECT *itextObj, int xoff, int yoff, 
                                struct Window *wp
                              )
{
   struct IntuiText *tp = (struct IntuiText *) CheckObject( itextObj );
   
   if (!tp) // == NULL)
      return;

   PrintIText( wp->RPort, tp, xoff, yoff );
 
   return;
}

IMPORT int ConvertToInt( USHORT fixedpoint );


/****h* Handle_Intuition() [1.5] *************************************
*
* NAME
*    Handle_Intuition()
*
* DESCRIPTION
*
* NOTES
*    Smalltalk code has to call this <primitive 181 16 private>
*    inside a loop if there is more than one IDCMP event expected.
*    rval <- window handleIntuition.
*    ^ <primitive 181 16 private>
**********************************************************************
*
*/

METHODFUNC OBJECT *Handle_Intuition( struct Window *wp )
{
   struct Gadget       *gptr = NULL;
   struct IntuiMessage *message, Msg;

   OBJECT              *rval     = o_nil;
   int                  checking = TRUE;
	
   while (checking == TRUE)    
      {
      if (!(message = GT_GetIMsg( wp->UserPort))) // == NULL)
         {
         (void) Wait( 1L << wp->UserPort->mp_SigBit );

         continue;
         }

      CopyMem( (char *) message, (char *) &Msg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( message );

      switch (Msg.Class)   
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( wp );
            GT_EndRefresh( wp, TRUE );

            break;
            
         case IDCMP_GADGETUP:
            gptr     = (struct Gadget *) Msg.IAddress;
            rval     = FindGadgetValue( gptr );
            checking = FALSE; 
            break;

         case IDCMP_MENUPICK:
            if (MENUNUM( Msg.Code ) != MENUNULL)
               {
               rval     = AssignObj( new_str( FindMenuString( Msg.Code, wp ) ) );
               checking = FALSE;
               } 
            break;

         case IDCMP_CLOSEWINDOW:   
            checking = FALSE;
            rval     = o_nil;
            break;

         default:             
            break;
         }
      }                // End of while Loop!!

   return( rval );
}

/****i* DoRequest() [1.0] ********************************************
*
* NAME
*    DoRequest()
*
* DESCRIPTION
*    ^ <primitive 181 13 msg title buttons>
**********************************************************************
*
*/

METHODFUNC OBJECT *DoRequest( char *msg, char *title, char *buttons )
{
   struct Window *activeWindow = NULL;
   OBJECT        *rval         = o_nil;
   ULONG          ibLock       = 0L;
   int            ret          = 0;

   SetReqButtons( buttons );   

   ibLock = LockIBase( 0L );

#     ifdef __SASC
      activeWindow = IntuitionBase->ActiveWindow;
#     else
      activeWindow = ((struct IntuitionBase *) IIntuition->Data.LibBase)->ActiveWindow;
#     endif    

   UnlockIBase( ibLock );

   if (!activeWindow) // == NULL) // How would this be possible?
      activeWindow = ATWnd;

   SetNotifyWindow( activeWindow );   

   ret = Handle_Problem( msg, title, NULL );
         
   SetReqButtons( DefaultButtons );

   SetNotifyWindow( ATWnd );         // Restore to ATWnd.

   rval = AssignObj( new_int( ret ) );

   return( rval );
}

/****i* OpenWindowWithTags() [2.0] ***********************************
*
* NAME
*    OpenWindowWithTags()
*
* DESCRIPTION
*    ^ <primitive 181 17 tagArray>
**********************************************************************
*
*/

METHODFUNC OBJECT *OpenWindowWithTags( OBJECT *tagArray )
{
   IMPORT struct TagItem *ArrayToTagList( OBJECT *inArray );

   OBJECT         *rval = o_nil;
   struct TagItem *tags = ArrayToTagList( tagArray );
   struct Window  *wind = NULL;
   
   if (!tags) // == NULL)
      return( rval ); // Probably an error by the User.
      
   if ((wind = OpenWindowTagList( NULL, tags ))) // != NULL)
      {
      rval = AssignObj( new_address( (ULONG) wind ) );
      }

   if (tags) // != NULL)      
      AT_FreeVec( tags, "windowTags", TRUE );
   
   return( rval );
}

/****i* getWindowParent() [2.0] **************************************
*
* NAME
*    getWindowParent()
*
* DESCRIPTION
*    getParent: windowObject
*       ^ <primitive 181 18 private>
**********************************************************************
*
*/

METHODFUNC OBJECT *getWindowParent( OBJECT *winObj )
{
   struct Window *wptr = (struct Window *) CheckObject( winObj );
   
   if (!wptr) // == NULL)
      return( o_nil );
   else
      return( AssignObj( new_address( (ULONG) wptr->WScreen ) ) ); 
}

/****i* helpControl() [2.0] ******************************************
*
* NAME
*    helpControl()
*
* DESCRIPTION
*    helpControl: [private] helpFlags
*       ^ <primitive 181 19 private helpFlags>
**********************************************************************
*
*/

METHODFUNC void helpControl( OBJECT *winObj, ULONG helpFlags )
{
   struct Window *wptr = (struct Window *) CheckObject( winObj );
   
   if (!wptr) // == NULL)
      return;
   
   HelpControl( wptr, helpFlags );
   
   return;
}

/****i* setNewMenuStrip() [2.5] **************************************
*
* NAME
*    setNewMenuStrip()
*
* DESCRIPTION
*    Transform a NewMenu array into struct Menu * & SetMenuStrip() it.
*    This primitive is used in the NewMenu.st file only (so far).
*    ^ <primitive 181 21 newMenuArray parentWindow>
**********************************************************************
*
*/

METHODFUNC OBJECT *setNewMenuStrip( OBJECT *newMenuArray, OBJECT *winObj )
{
   OBJECT         *rval = o_false;
   struct Window  *wptr = (struct Window *) CheckObject( winObj );
   struct NewMenu *newM = NULL;
   struct Menu    *menu = NULL;
   APTR            visualinfo = NULL;
   int     size = 0;
   int     i;

   if ((newMenuArray == o_nil) || !newMenuArray) // == NULL)
      return( rval ); // This check probably not necessary.
      
   if (!wptr) // == NULL)
      return( rval );
      
   if (!(visualinfo = GetVisualInfo( wptr->WScreen, TAG_DONE ))) // == NULL)
      {
      // User might have selected an invalid ScreenModeID to get here.
      return( rval );
      }
      
   size = objSize( newMenuArray ) + 1; // in case there's no NM_END

   // This is just temporary:   
   newM = (struct NewMenu *) AT_AllocVec( size * sizeof( struct NewMenu ),
                                          MEMF_CLEAR | MEMF_ANY,
                                          "newMenuStrip", TRUE 
                                        );      
   if (!newM) // == NULL)
      {
      return( rval );
      }
   else
      {
      struct NewMenu *nm = NULL;

      i = 0;
      
      while (i < size)
         {
         nm = (struct NewMenu *) addr_value( newMenuArray->inst_var[i] );
         
         if (nm->nm_Type == NM_END)
            break;
            
         CopyMem( (char *) nm, (char *) &newM[i], 
                  (long) sizeof( struct NewMenu )
                );
         i++;    
         }
      
      if (newM[i].nm_Type != NM_END)
         {
         // Bonehead user did NOT terminate the Array properly:
         newM[i].nm_Type          = NM_END;
         newM[i].nm_Label         = NULL;
         newM[i].nm_CommKey       = NULL;
         newM[i].nm_Flags         = 0;
         newM[i].nm_MutualExclude = 0L;
         newM[i].nm_UserData      = NULL;
         }
            
      if (!(menu = CreateMenus( newM, GTNM_FrontPen, 0L, TAG_DONE ))) // == NULL)
         {
         AT_FreeVec( newM, "newMenuStrip", TRUE );
         
         goto exitSetNewMenuStrip;
         }
      
      LayoutMenus( menu, visualinfo, TAG_DONE );
      
      FreeVisualInfo( visualinfo ); // Weesa done wit dis
      
      SetMenuStrip( wptr, menu );
  
      AT_FreeVec( newM, "newMenuStrip", TRUE ); // Now weesa done with dat
      newM = NULL;
      
      rval = o_true;
      }   

exitSetNewMenuStrip:

   return( rval );
}

/****i* clearNewMenuStrip() [2.5] ************************************
*
* NAME
*    clearNewMenuStrip()
*
* DESCRIPTION
*    Remove & deallocate a MenuStrip.
*    This primitive is used in the NewMenu.st file only (so far).
*    <primitive 181 22 parentWindow>
**********************************************************************
*
*/

METHODFUNC void clearNewMenuStrip( OBJECT *winObj )
{
   struct Window *wptr = (struct Window *) CheckObject( winObj );
   
   if (!wptr) // == NULL)
      return;
      
   ClearMenuStrip( wptr );

   return;
}


/*
struct Window *BuildEasyRequestArgs( struct Window *window, 
                                     CONST struct EasyStruct *easyStruct, 
                                     ULONG idcmp, CONST APTR args 
                                   );
                                   
struct Window *BuildSysRequest( struct Window *window, CONST struct IntuiText *body, 
                                CONST struct IntuiText *posText, 
                                CONST struct IntuiText *negText, 
                                ULONG flags, ULONG width, ULONG height 
                              );

BOOL  ClearDMRequest( struct Window *window );
VOID  ClearMenuStrip( struct Window *window );
VOID  ClearPointer( struct Window *window );

BOOL  WindowLimits( struct Window *window, LONG widthMin, LONG heightMin, 
                    ULONG widthMax, ULONG heightMax 
                  );

VOID  ZipWindow( struct Window *window );
VOID  MoveWindowInFrontOf( struct Window *window, struct Window *behindWindow );
VOID  ChangeWindowBox( struct Window *window, LONG left, LONG top, LONG width, LONG height );

LONG  EasyRequestArgs( struct Window *window, CONST struct EasyStruct *easyStruct,
                       ULONG *idcmpPtr, CONST APTR args 
                     );

BOOL  ModifyIDCMP( struct Window *window, ULONG flags );

BOOL  AutoRequest( struct Window *window, CONST struct IntuiText *body, 
                   CONST struct IntuiText *posText, CONST struct IntuiText *negText, 
                   ULONG pFlag, ULONG nFlag, ULONG width, ULONG height 
                 );

VOID  FreeSysRequest( struct Window *window );

VOID  ScrollWindowRaster( struct Window *win, LONG dx, LONG dy, LONG xMin, LONG yMin,
                          LONG xMax, LONG yMax 
                        );

VOID  LendMenus( struct Window *fromwindow, struct Window *towindow );
VOID  ActivateWindow( struct Window *window );
LONG  SetMouseQueue( struct Window *window, ULONG queueLength );
VOID  OnMenu( struct Window *window, ULONG menuNumber );
VOID  OffMenu( struct Window *window, ULONG menuNumber );
VOID  OffGadget( struct Gadget *gadget, struct Window *window, struct Requester *requester );
VOID  OnGadget( struct Gadget *gadget, struct Window *window, struct Requester *requester );
BOOL  SetDMRequest( struct Window *window, struct Requester *requester );

VOID  RefreshGList( struct Gadget *gadgets, struct Window *window, 
                    struct Requester *requester, LONG numGad 
                  );

UWORD AddGList( struct Window *window, struct Gadget *gadget, ULONG position,
                LONG numGad, struct Requester *requester 
              );

UWORD RemoveGList( struct Window *remPtr, struct Gadget *gadget, LONG numGad );

BOOL  ActivateGadget( struct Gadget *gadgets, struct Window *window,
                      struct Requester *requester 
                    );

LONG  SysReqHandler( struct Window *window, ULONG *idcmpPtr, LONG waitInput );
BOOL  ResetMenuStrip( struct Window *window, struct Menu *menu );

*/
        
/****h* HandleWindows() [1.9] ****************************************
*
* NAME
*    HandleWindows()
*
* DESCRIPTION
*    Translate primitive 181 calls to Windows functions.
**********************************************************************
*
*/

PUBLIC OBJECT *HandleWindows( int numargs, OBJECT **args )
{
   struct Window *wp   = NULL;
   OBJECT        *rval = o_nil;
      
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 181 );
      return( rval );
      }

   wp = (struct Window *) CheckObject( args[1] );
            
   switch (int_value( args[0] ))
      {
      case 0: // close [private]
         if (!wp) // == NULL)
            (void) PrintArgTypeError( 181 );
         else
            {
            CloseAWindow( wp );
            }
            
         break;

      case 1: // private <- openOnScreen: screenObj [savedTitle]
         if (is_string( args[2] ) == FALSE)
            (void) PrintArgTypeError( 181 );
         else
            {
            struct Screen *sp = (struct Screen *) CheckObject( args[1] );

            if (sp) // != NULL)            
               rval = OpenAWindow( sp, string_value( (STRING *) args[2] ) );
            }

         break;

      case 2: // ^ getWindowPart: whichPart [private]
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 181 );
         else
            {
            if ((wp = (struct Window *) CheckObject( args[2] ))) // != NULL)
               rval = GetWindowPart( int_value( args[1] ), wp );
            }

         break;

      case 3: // setWindowPart: part to: newObject
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 181 );
         else
            SetWindowPart( int_value( args[1] ), args[2] );

         break;

      case 4:
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 181 );
         else
            {
            if ((wp = (struct Window *) CheckObject( args[2] ))) // != NULL)
               ExecWindowFunc0( string_value( (STRING *) args[1] ), wp );
            }

         break;

      case 5:
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 181 );
         else
            {
            if ((wp = (struct Window *) CheckObject( args[3] ))) // != NULL)
               ExecWindowFunc1( string_value( (STRING *) args[1] ),
                                                         args[2],
                                                         wp
                              );
            }

         break;

      case 6:
         if (ChkArgCount( 5, numargs, 181 ) != 0)
            return( ReturnError() );

         if ( !is_string( args[1] ) || !is_integer( args[2] )
                                    || !is_integer( args[3] ))
            (void) PrintArgTypeError( 181 );
         else
            {
            if ((wp = (struct Window *) CheckObject( args[4] ))) // != NULL)
               ExecWindowFunc2(                string_value( (STRING *) args[1] ),
                                                  int_value( args[2] ),
                                                  int_value( args[3] ),
                                                             wp
                              );
            }

         break;

      // case 7: // used to be AutoRequest().

      case 8: // setPointer:size:offset: [private]   see <181 20> OBSOLETE!!
          if (ChkArgCount( 7, numargs, 181 ) != 0)
            return( ReturnError() );

         if ( !is_integer( args[2] ) || !is_integer( args[3] )
                                     || !is_integer( args[4] )
                                     || !is_integer( args[5] ))
            (void) PrintArgTypeError( 181 );
         else
            {
            if ((wp = (struct Window *) CheckObject( args[6] ))) // != NULL)
               SetWPointer(            args[1],   // struct SimpleSprite *
                            int_value( args[2] ), // height
                            int_value( args[3] ), // width   
                            int_value( args[4] ), // xOffset
                            int_value( args[5] ), // yOffset
                                              wp  // wptr
                          );
            }

         break;

      case 9:
         if ((wp = (struct Window *) CheckObject( args[2] ))) // != NULL)
            AddWGadget( args[1], wp );

         break;

      case 10:
         if ((wp = (struct Window *) CheckObject( args[2] ))) // != NULL)
            RemoveWGadget( args[1], wp );

         break;

      case 11: // reportMouse: boolvalue [private]
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 181 );
         else
            {
            if ((wp = (struct Window *) CheckObject( args[2] ))) // != NULL)
               ReportWMouse( int_value( args[1] ), wp ); 
            }

         break;

      case 12:
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 181 );
         else
            {
            if ((wp = (struct Window *) CheckObject( args[2] ))) // != NULL)
               ChangeWindowTitle( string_value( (STRING *) args[1] ), wp );
            }

         break;

      case 13: // <181 13 msg title buttons>
         if (ChkArgCount( 4, numargs, 181 ) != 0)
            return( ReturnError() );

         if ( !is_string( args[1] ) || !is_string( args[2] )
                                    || !is_string( args[3] ))
            (void) PrintArgTypeError( 181 );
         else
            rval = DoRequest( string_value( (STRING *) args[1] ), 
                              string_value( (STRING *) args[2] ),
                              string_value( (STRING *) args[3] )
                            );
         break;

      case 14: // printIText: itextObj at: aPoint [private]
         if (ChkArgCount( 5, numargs, 181 ) != 0)
            return( ReturnError() );
 
         if ( !is_integer( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 181 );
         else
            {
            if ((wp = (struct Window *) CheckObject( args[4] ))) // != NULL)
               PrintIntuiText( args[1], int_value( args[2] ),
                                        int_value( args[3] ), 
                                    wp
                             );
            }

         break;
                                           
      // case 15: // was ReOpenWindow()

      case 16: // ^ <181 16 private>
         if ((wp = (struct Window *) CheckObject( args[1] ))) // != NULL)
            rval = Handle_Intuition( wp );

         break;                                  

      case 17: // openWindowTags: tagArray  ^ <primitive 181 17 tagArray>
         if (is_array( args[1] ) == FALSE)
            (void) PrintArgTypeError( 181 );
         else
            rval = OpenWindowWithTags( args[1] );

         break;
      
      case 18: // getParent: windowObject  ^ <primitive 181 18 private>
         rval = getWindowParent( args[1] );
         break;

      case 19: // helpControl: helpFlags <primitive 181 19 private helpFlags>             
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 181 );
         else
            helpControl( args[1], (ULONG) int_value( args[2] ) );
         
         break;

      case 20: // setWindowPointer: [private] tagArray 
               // <primitive 181 20 private tagArray> 
         if (is_array( args[2] ) == FALSE)
            (void) PrintArgTypeError( 181 );
         else
            setWindowPointer( args[1], args[2] );
   
         break;
      
      case 21: // attachTo: aWindow [menuStripArray] 
               //  private <- (SetMenuStrip() with NewMenus array)      
         if (!is_array( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 181 );
         else
            rval = setNewMenuStrip( args[1], args[2] );

         break;
          
      case 22: // hide [window] (ClearMenuStrip())
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 181 );
         else
            clearNewMenuStrip( args[1] );

         break;
          
      default:
         (void) PrintArgTypeError( 181 );
         break;
      }

   return( rval );
}

/* ------------------ END of Window.c file! ------------------------- */
