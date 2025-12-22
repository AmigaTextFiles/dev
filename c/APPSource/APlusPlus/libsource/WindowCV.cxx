/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/WindowCV.cxx,v $
 **   $Revision: 1.12 $
 **   $Date: 1994/08/02 18:02:27 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/


extern "C" {
#ifdef __GNUG__
#include <inline/intuition.h>
#include <inline/gadtools.h>
#endif

#ifdef __SASC
#include <proto/intuition.h>
#include <proto/gadtools.h>
#endif
}

#include <APlusPlus/intuition/WindowCV.h>
#include <APlusPlus/intuition/ScreenC.h>
#include <APlusPlus/intuition/IntuiMessageC.h>


static const char rcs_id[] = "$Id: WindowCV.cxx,v 1.12 1994/08/02 18:02:27 Armin_Vogt Exp Armin_Vogt $";

//runtime type inquiry support
intui_typeinfo(WindowCV, derived(from(GraphicObject)), rcs_id)


/*************************************************************************************************
      WindowCV methods
 *************************************************************************************************/


WindowCV::WindowCV(IntuiObject* owner,AttrList& attrs) : GraphicObject((GraphicObject*)owner,attrs)
{
   ULONG IDCMPflags = 0;

   // initialise for safety
   window_rsp = (IntuitionResponder*)NULL;
   AttrManipulator next(intuiAttrs());

   if (next.findTagItem(WCV_SharePortWithWindow))
   {
      // share IDCMP port with another window.
      WindowCV* shareWindow;

      // cast 'next.data()' into the type that was 'confirmed' with WindowCV::confirm()!
      if ( NULL != (shareWindow = ptr_cast(WindowCV, (WindowCV*)next.data())) )
      {
         // if the port sharing window has no port, create an own UserPort.
         if (NULL == (window_rsp = shareWindow->getIntuiResponder()))
         {
            puterr("window to share port with has no port.");
         }
         else
         {
            if (next.findTagItem(WA_IDCMP))
            {
               IDCMPflags = next.data();
               next.writeData(0L);   // prevent Intuition from creating a userport for our window
            }
         }
      }
      else puterr("WindowCV: object to share port with is no WindowCV type.");
   }

   _dprintf("getting root screen..\n");
   ScreenC* screen = screenC();
   if (screen==NULL)
   { 
      puterr("FATAL ERROR: no screen available!"); 
      _ierror(WINDOWCV_OPENWINDOW_FAILED);
      return; 
   }
   else
   {

      // Make sure that these tags are present in the attribute tag list.
      // If the following attributes are not specified, add them with
      // these default values..
      applyDefaultAttrs( attrs,AttrList(
         WA_CustomScreen,0,
         WA_IDCMP,0,
         WA_SmartRefresh,0,
         WA_DragBar, TRUE,
         WA_SizeGadget, TRUE,
         WA_DepthGadget, TRUE,
         WA_CloseGadget, TRUE,
         TAG_END ));

      // and initialise those who shall be overwritten..
      intuiAttrs().updateAttrs( AttrList(
         WA_CustomScreen,screen->screenPtr(),
         WA_IDCMP,IDCMPflags|=CLASS_CLOSEWINDOW,
         WA_SmartRefresh, TRUE,
         TAG_END));

      _dprintf("Root screen found.\n");

      // open window
      if (NULL != (window_ref() = OpenWindowTagList(NULL,intuiAttrs()) ) )
      {
         window()->UserData = (BYTE*)this;
         // store the covering C++ object in the window structure
         {
            if (window_rsp)   // window uses another intuition responder
            {
               // get the userport from the shared IntuitionResponder
               // and tell him we are sharing
               window()->UserPort = ((IntuitionResponder*)
                     (window_rsp->participate()))->getMsgPort();

               ModifyIDCMP(window(),IDCMPflags);
               // now Intuition shall create a windowport
            }
            else if (window()->UserPort)  // create intui rsp only if the window has an IDCMP port.
            {
               /* create own IntuitionResponder for the window userport
                * other windows may share this port but IntuitionResponder class handles this.
                */
               window_rsp = new IntuitionResponder(window()->UserPort);
               if (!APPOK(window_rsp))
                  _ierror(OUT_OF_MEMORY);
            }
            else _dprintf("WindowCV without IDCMP created.\n");
         }
         newsize(NULL);

         _dprintf( ("WindowCV status = %ld\n",status()) );
         setIOType(IOTYPE_WINDOWCV);
         _dprintf( ("\tWindowCV(status=%ld) object at %lx created.\n",status(),(APTR)window()) );
      }
      else _ierror(WINDOWCV_OPENWINDOW_FAILED);
   }
}

WindowCV::~WindowCV()
{
   _dprintf("WindowCV::~WindowCV()\n");

   if (window())
   {
      if (window_rsp)   // window may share user port
      {
         // release will reply all messages for our window still in the queue, so forbid sending more
         Forbid();

         /* It is explicitly allowed to destruct a WindowCV within a message callback.
         ** But the replying after message processing, done in actionCallback(), must then be inhibited.
         */
         if (window_rsp->msgInProcess)
         {
            GT_ReplyIMsg(window_rsp->msgInProcess);
            window_rsp->msgInProcess = NULL;          //prevent from being replied twice.
            _dprintf("  msg in process replied.\n");
         }

         if (window_rsp->release(window())>0)  // our intuition responder has more participating windows
         {
            window()->UserPort = NULL;   // the shared IDCMP port is still used by other windows!
            ModifyIDCMP(window(),NULL);  // let Intuition close its WindowPort
         }
         Permit();   // our UserPort is gone..
      }
      if ((WindowCV*)window()->UserData==this)
      {
         window()->UserData = NULL;
         _dprintf( ("closing window(%lx)\n",(APTR)window()) );
         CloseWindow(window());
         _dprintf("..done\n");
      }
      else puterr("WindowCV: invalid window pointer!");
   }
   _dprintf("WindowCV::~WindowCV done\n");
}

ULONG WindowCV::setAttributes(AttrList& attrs)
{
   AttrIterator next(attrs);

   while (next())
   {
      switch (next.tag())
      {
         case WA_Title :
            SetWindowTitles(window(),(UBYTE*)next.data(),(UBYTE*)-1);
            break;

         case WA_ScreenTitle :
            SetWindowTitles(window(),(UBYTE*)-1,(UBYTE*)next.data());
            break;
      }
   }

   return GraphicObject::setAttributes(attrs);
}

ULONG WindowCV::getAttribute(Tag attr,ULONG& dataStore)
{
   switch (attr)
   {
      case WA_Title : return (dataStore=(ULONG)window()->Title);
      case WA_ScreenTitle : return (dataStore=(ULONG)window()->ScreenTitle);
      default : return GraphicObject::getAttribute(attr,dataStore);
   }
}

ScreenC* WindowCV::screenC() 
   // returns the ScreenC object the window is in.
{ 
   return findRootOfClass(ScreenC); 
}

void WindowCV::modifyIDCMP(ULONG flags)
{
   ModifyIDCMP(window(),(ULONG)window()->IDCMPFlags|flags);
}

void WindowCV::newsize(const IntuiMessageC* dummy)
   /* Has to be called from a derived class NEWSIZE callback.
   */
{
   /* GraphicObject holds the position to the window origin and dimensions of the inner window area.
   */
   setRect( window()->BorderLeft,
            window()->BorderTop,
            window()->Width-1-window()->BorderRight,
            window()->Height-1-window()->BorderBottom);

}

/*************************************************************************************************
      WindowCV::IntuitionResponder methods
 *************************************************************************************************/
IntuitionResponder::IntuitionResponder(struct MsgPort* IPort)
      : SignalResponder(IPort->mp_SigBit,50)
{
   _dprintf("IntuitionResponder::\n");
   userPort = IPort;
   msgInProcess = NULL;
}

IntuitionResponder::~IntuitionResponder()
{
   msgInProcess = NULL;    // indicate userport check.
   userPort = NULL;        // indicate userport no longer available.
}

WORD IntuitionResponder::release(Window* win)
   /* unlink a window from this IntuitionResponder in replying all messages addressed to
      that window and  decreasing the window participating counter.
   */
{
   struct IntuiMessage* msg;
   struct Node* succ;

   if (NULL != (msg = (struct IntuiMessage*)userPort->mp_MsgList.lh_Head))
   while (NULL != (succ = msg->ExecMessage.mn_Node.ln_Succ))
   {
      if (msg->IDCMPWindow == win)
      {
         Remove((struct Node*)msg);
         ReplyMsg((struct Message*)msg);
      }
      msg = (struct IntuiMessage*)succ;
   }

   return Shared::release();  // delete IntuitionResponder instance
}

void IntuitionResponder::actionCallback()
   /* is invoked on a signal on the IDCMP port.
   */
{
   WindowCV* winC;

   while (NULL != (msgInProcess = GT_GetIMsg(userPort)) )
   {
      // delegate to the IDCMPWindow
      if (NULL != (winC = ((const IntuiMessageC* )msgInProcess)->decodeWindowCV()))
      {
         winC->handleIntuiMsg((const IntuiMessageC* ) msgInProcess );  // virtual callback
      }
      // reply only if not already replied through ~WindowCV().
      if (msgInProcess) GT_ReplyIMsg(msgInProcess);
      else { _dprintf("actionCallback(): msg already replied.\n");
         if (userPort==NULL) break; // do not get a message from userport == null !!
      }
   }
}
