/******************************************************************************
 *
 *    $Source: apphome:RCS/testprgs/intuition/BoopsiGadget_test.cxx,v $
 *
 *    Demo for the A++ Library
 *    Copyright (C) 1994 by Armin Vogt, EMail: armin@uni-paderborn.de
 *
 *    $Revision: 1.7 $
 *    $Date: 1994/07/23 19:15:11 $
 *    $Author: Armin_Vogt $
 *
 ******************************************************************************/
 

#include <APlusPlus/exec/SignalResponder.h>
#include <APlusPlus/intuition/GWindow.h>
#include <APlusPlus/intuition/BoopsiGadget.h>
#include <APlusPlus/intuition/StdGadget.h>
#include <APlusPlus/intuition/IntuiMessageC.h>
#include <APlusPlus/graphics/GBorder.h>
#include <APlusPlus/intuition/ITransponder.h>

extern "C" {
#include <dos/dos.h>
}
#include <stdio.h>


static const char rcs_id[] = "$Id: BoopsiGadget_test.cxx,v 1.7 1994/07/23 19:15:11 Armin_Vogt Exp Armin_Vogt $";


// A customized Boopsi Proportional Gadget class that defines default attributes.
class MyProp : public BoopsiGadget
{
   public:
      MyProp(GOB_OWNER,AttrList& attrs)
      : BoopsiGadget(gob_owner,(UBYTE*)"propgclass",attrs) 
      {
         // set the default values of class 'MyProp'.
         // Base class values are overwritten! Class-user values do override!
         applyDefaultAttrs( attrs, AttrList(
            GA_Immediate,  TRUE,
            GA_RelVerify,  TRUE,
            ICA_TARGET,    ICTARGET_IDCMP,
            PGA_NewLook,   TRUE,
            TAG_END) );            
      }
      ~MyProp() {}
         
      // runtime type inquiry support
      static const Intui_Type_info info_obj;
      virtual const Type_info& get_info() const     // get the 'type_id' to an existing object
         { return info_obj; }
      static const Type_info& info()                // get the 'type_id' of a specific class
         { return info_obj; }

};

intui_typeinfo(MyProp, derived(from(BoopsiGadget)), rcs_id);


BOOL running = TRUE;
BOOL close2 = FALSE;
GWindow* stop_window;


class MySRSP : public SignalResponder
{
   public:
      MySRSP(BYTE signal) : SignalResponder(signal,0) {}

      void actionCallback();
};

// Overwrite the virtual 'signal received' action callback method.
// This SignalResponder work with a global variable (not so VERY object-oriented).
void MySRSP::actionCallback()
{
   puts("**Break\n");
   running = FALSE;
}

class MyWindow : public GWindow
{
   private:
      void init();

   public:
      MyWindow(OWNER,AttrList& attrs) : GWindow(owner,attrs) { init(); }
      void On_CLOSEWINDOW(const IntuiMessageC* msg);
      void On_ACTIVEWINDOW(const IntuiMessageC* msg);
      void On_SIZEVERIFY(const IntuiMessageC* msg);
      void handleIntuiMsg(const IntuiMessageC* imsg);

      // runtime type inquiry support
      static const Intui_Type_info info_obj;
      virtual const Type_info& get_info() const     // get the 'type_id' to an existing object
         { return info_obj; }
      static const Type_info& info()                // get the 'type_id' of a specific class
         { return info_obj; }

};

intui_typeinfo(MyWindow, derived(from(GWindow)), rcs_id);


void MyWindow::init()
{
   // make sure these IDCMP messages will be received
   modifyIDCMP(CLASS_NEWSIZE|CLASS_CLOSEWINDOW|CLASS_ACTIVEWINDOW|CLASS_SIZEVERIFY);
}

void MyWindow::On_CLOSEWINDOW(const IntuiMessageC* msg)
      {
         puts("CLOSEWINDOW.\n");
         if (this == stop_window) running = FALSE;
         delete this;
      }
void MyWindow::On_ACTIVEWINDOW(const IntuiMessageC* msg)
      {
         ULONG dummy=0;
         printf("%s is ACTIVE.\n",getAttribute(WA_Title,dummy));
      }
void MyWindow::On_SIZEVERIFY(const IntuiMessageC* msg)
      {
         puts("SIZEVERIFY. \n");
      }
void MyWindow::handleIntuiMsg(const IntuiMessageC* imsg)
      {
         switch (imsg->getClass())
         {
            case CLASS_CLOSEWINDOW :
               On_CLOSEWINDOW(imsg); break;
            case CLASS_ACTIVEWINDOW :
               On_ACTIVEWINDOW(imsg); break;
            case CLASS_SIZEVERIFY :
               On_SIZEVERIFY(imsg); break;
         }
         GWindow::handleIntuiMsg(imsg);
}

// This ITransponder multiplies received PGA_Top values with a given factor.
class PropScalarITP : public ITransponder
{
   private:
      FLOAT factor;

      void sendNotification(AttrList& attrs)
      {
         AttrManipulator next(attrs);
         // ONLY transmit those Attribute Tags that you really WANT to change!
         if (next.findTagItem(PGA_Top) )
         {
            if (APPOK(receiver1)) receiver1->setAttributes( AttrList(
               PGA_Top, (LONG)((FLOAT)next.data()*factor),
               TAG_END
               ) );
         }
      }
   public:
      PropScalarITP(FLOAT f,IntuiObject* receiver=NULL) { factor = f; receiver1 = receiver; }
};



void APPmain(int argc,char* argv[])
{
   ULONG l=0;     // dummy variable needed for a getAttribute() call
   MySRSP sr(SIGBREAKB_CTRL_C);

   PropScalarITP prop2to1_itp(0.5);
   PropScalarITP prop1to2_itp(2);

   NeXTBorder border;


   MyWindow* little = new MyWindow(OWNER_NULL,
      AttrList( WA_Title,(ULONG)"Window - close this to stop.",
      WA_Left,    200,
      WA_Top,     50,
      WA_Width,   300,
      WA_Height,  150,
      WA_MinHeight,  100,
      WA_MinWidth,   100,
      WA_MaxHeight,  1600,
      WA_MaxWidth,   1600,
      TAG_END) );


   MyWindow* small = new MyWindow(little,
      AttrList( WCV_SharePortWithWindowObj(little),
      WA_Title,(ULONG)"Window sharing userport",
      WA_Left,    200,
      WA_Top,     200,
      WA_Width,   200,
      WA_Height,  150,
      WA_MinHeight,  100,
      WA_MinWidth,   100,
      WA_MaxHeight,  1600,
      WA_MaxWidth,   1600,
      TAG_END) );


   MyProp* prop1 = new MyProp(small,
      AttrList( GOB_LeftFromRightOfParent,-30,
      GOB_TopFromTopOfParent,       0,
      GOB_RightFromRightOfParent,   -1,
      GOB_BottomFromBottomOfParent, 0,
      PGA_Freedom,   FREEVERT,
      PGA_Top,    10,
      PGA_Total,  100,
      PGA_Visible,50,
      ITRANSPONDER(&prop1to2_itp),
      GOB_BorderObj(&border),
      TAG_END) );


   MyProp* prop2 = new MyProp(little,
      AttrList(
      GOB_LeftFromLeftOfParent,  2,
      GOB_TopFromTopOfParent,    2,
      GOB_RightFromLeftOfParent, 35,
      GOB_BottomFromBottomOfParent, -10,
      PGA_Freedom,   FREEVERT,
      PGA_Top,    prop1->getAttribute(PGA_Top,l)*2,   // initialise from the ITP source
      PGA_Total,  200,
      PGA_Visible,100,
      GOB_BorderObj(&border),
      ITRANSPONDER(&prop2to1_itp),
      TAG_END) );


   prop1to2_itp.setReceiver(prop2);
   prop2to1_itp.setReceiver(prop1);

   stop_window = little;
   
   // redraw the window contents
   little->refreshGList();
   small->refreshGList();

   while (running)
   {
      SignalResponder::WaitSignal();
   }

   puts("cleaned up. goodbye.\n");
}
