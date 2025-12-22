/******************************************************************************
 *
 *    $Source: apphome:RCS/testprgs/intuition/SimpleWindow_test.cxx,v $
 *
 *    Demo for the A++ Library
 *    Copyright (C) 1994 by Armin Vogt, EMail: armin@uni-paderborn.de
 *
 *    $Revision: 1.8 $
 *    $Date: 1994/07/23 19:15:49 $
 *    $Author: Armin_Vogt $
 *
 ******************************************************************************/


#include <APlusPlus/exec/SignalResponder.h>
#include <APlusPlus/intuition/GWindow.h>
#include <APlusPlus/intuition/IntuiMessageC.h>
#include <APlusPlus/intuition/ScreenC.h>


extern "C" {
#include <dos/dos.h>
}


static const char rcs_id[]="$Id: SimpleWindow_test.cxx,v 1.8 1994/07/23 19:15:49 Armin_Vogt Exp Armin_Vogt $";


// a CTRL-C signal responder from the example in the docs
class MySRSP : public SignalResponder
{
   private:
      BOOL running;  // indicates a received user break to object users
   public:
      MySRSP() : SignalResponder(SIGBREAKB_CTRL_C,0)
      { running = TRUE; }
      ~MySRSP() {}

      //  overload the virtual 'signal received' action callback method.
      void actionCallback()
      {
         running = FALSE;  // end WaitSignal loop
      }

      // object users can check with this method if a user break has occurred
      BOOL hasNotOccured() { return running==TRUE; }
};



class MyWindow : public GWindow
{
   public:
      MyWindow(OWNER,AttrList& attrs) : GWindow(owner,attrs)
      {
         modifyIDCMP(CLASS_NEWSIZE|CLASS_CLOSEWINDOW|CLASS_ACTIVEWINDOW|CLASS_NEWSIZE);
      }

      void On_CLOSEWINDOW(const IntuiMessageC* msg);
      void On_ACTIVEWINDOW(const IntuiMessageC* msg);
      void On_NEWSIZE(const IntuiMessageC* msg);

      void putText(const char* string);

      void handleIntuiMsg(const IntuiMessageC* imsg);

      // runtime type inquiry support
      static const Intui_Type_info info_obj;
      virtual const Type_info& get_info() const     // get the 'type_id' to an existing object
         { return info_obj; }
      static const Type_info& info()                // get the 'type_id' of a specific class
         { return info_obj; }

};

intui_typeinfo(MyWindow, derived(from(GWindow)), rcs_id);


void MyWindow::On_CLOSEWINDOW(const IntuiMessageC* msg)
      {
         putText("CLOSEWINDOW.");
         delete this;   // it is allowed for WindowCV class to destroy itself
      }
void MyWindow::On_ACTIVEWINDOW(const IntuiMessageC* msg)
      {
         ULONG dummy=0;
         char* e[40];
         sprintf((char*)e,"%s is ACTIVE.",(char*)getAttribute(WA_Title,dummy));
         putText((char*)e);
      }
void MyWindow::On_NEWSIZE(const IntuiMessageC* msg)
      {         
         adjustStdClip(); 
         setStdClip();
         putText("NEWSIZE. ");
      }
void MyWindow::handleIntuiMsg(const IntuiMessageC* imsg)
      {
         switch (imsg->getClass())
         {
            case CLASS_CLOSEWINDOW :
               On_CLOSEWINDOW(imsg); break;
            case CLASS_ACTIVEWINDOW :
               On_ACTIVEWINDOW(imsg); break;
            case CLASS_NEWSIZE :
               On_NEWSIZE(imsg); break;
         }
         GWindow::handleIntuiMsg(imsg);
}

void MyWindow::putText(const char* string)
{
   moveTx(0,0);
   setDrMd(JAM2);
   setAPen(1);
   setBPen(0);
   text((UBYTE*)string);
}

void APPmain(int argc,char* argv[])
{
   MySRSP userBreak;

   ScreenC* screen  = new ScreenC(OWNER_NULL, AttrList(TAG_END) );
   
   MyWindow* little = new MyWindow(screen,
   AttrList(
      WA_Title,"WindowC - close this to stop.",
      WA_Width,300,
      WA_Height,150,
      WA_MinHeight,50,
      WA_MinWidth,80,
      TAG_END) );

   little->putText("Welcome!");

   while (userBreak.hasNotOccured() && APPOK(little))
      // APPOK(little) expands to (little!=NULL && little->Ok())
   {
      SignalResponder::WaitSignal();
   }
}
