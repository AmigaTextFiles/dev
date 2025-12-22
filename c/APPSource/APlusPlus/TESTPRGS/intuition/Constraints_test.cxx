/******************************************************************************
 *
 *    $Source: apphome:RCS/testprgs/intuition/Constraints_test.cxx,v $
 *
 *    Demo for the A++ Library
 *    Copyright (C) 1994 by Armin Vogt, EMail: armin@uni-paderborn.de
 *
 *    $Revision: 1.6 $
 *    $Date: 1994/07/23 19:15:19 $
 *    $Author: Armin_Vogt $
 *
 ******************************************************************************/


#include <APlusPlus/exec/SignalResponder.h>
#include <APlusPlus/intuition/GWindow.h>
#include <APlusPlus/intuition/IntuiMessageC.h>
#include <APlusPlus/intuition/BoopsiGadget.h>
#include <APlusPlus/intuition/StdGadget.h>
#include <APlusPlus/graphics/GBorder.h>

extern "C" {
#include <dos/dos.h>
}

#include <iostream.h>


static const char rcs_id[] = "$Id: Constraints_test.cxx,v 1.6 1994/07/23 19:15:19 Armin_Vogt Exp Armin_Vogt $";


class MyBoopsi : public BoopsiGadget
{
   public:
      MyBoopsi(GOB_OWNER,UBYTE *name,AttrList& attrs)
      : BoopsiGadget(gob_owner,name,attrs) { }
      ~MyBoopsi() {}

      // runtime type inquiry support
      static const Intui_Type_info info_obj;
      virtual const Type_info& get_info() const     // get the 'type_id' to an existing object
         { return info_obj; }
      static const Type_info& info()                // get the 'type_id' of a specific class
         { return info_obj; }

};

intui_typeinfo(MyBoopsi, derived(from(BoopsiGadget)), rcs_id);


BOOL running = TRUE;
BOOL close2 = FALSE;
GWindow *stop_window;


class MySRSP : public SignalResponder
{
   public:
      MySRSP(BYTE signal) : SignalResponder(signal,0) {}

      void actionCallback();
};

// overload the virtual 'signal received' action callback method.
void MySRSP::actionCallback()
{
   cout << "**Break\n";
   running = FALSE;
}

class MyWindow : public GWindow
{
   private:
      void init();

   public:
      MyWindow(OWNER,AttrList& attrs) : GWindow(owner,attrs) { init(); }
      void On_CLOSEWINDOW(const IntuiMessageC *msg);
      void On_ACTIVEWINDOW(const IntuiMessageC *msg);
      void On_SIZEVERIFY(const IntuiMessageC *msg);
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
   modifyIDCMP(CLASS_NEWSIZE|CLASS_CLOSEWINDOW|CLASS_ACTIVEWINDOW|CLASS_SIZEVERIFY);
}

void MyWindow::On_CLOSEWINDOW(const IntuiMessageC *msg)
      {
         cout << "CLOSEWINDOW.\n";
         if (this == stop_window) running = FALSE;
         delete this;
      }
void MyWindow::On_ACTIVEWINDOW(const IntuiMessageC *msg)
      {
         cout << title() << " is ACTIVE.\n";
      }
void MyWindow::On_SIZEVERIFY(const IntuiMessageC *msg)
      {
         cout << "SIZEVERIFY. \n";
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


void APPmain(int argc,char* argv[])
{
   MySRSP sr(SIGBREAKB_CTRL_C);

   LineBorder LBorder;

   MyWindow *little = new MyWindow(OWNER_NULL,
      AttrList( WA_Title,(ULONG)"Window - close this to stop.",
      WA_Left,200,
      WA_Top,200,
      WA_Width,300,
      WA_Height,150,
      WA_MinHeight,40,
      WA_MaxHeight,1600,
      WA_MaxWidth,1600,
      WA_DragBar,TRUE,
      WA_SizeGadget,TRUE,
      WA_DepthGadget,TRUE,
      WA_CloseGadget,TRUE,
//    GOB_BorderObj(&border),
      TAG_END) );

   cout<<"TEST: little window created.\n";

   MyBoopsi *prop1 = new MyBoopsi(little,
      (UBYTE*)"propgclass",
      AttrList( GOB_LeftFromRightOfParent,-10,
      GOB_TopFromTopOfParent,0,
      GOB_RightFromRightOfParent,-1,
      GOB_BottomFromBottomOfParent,0,
      GA_Immediate,TRUE,
      GA_RelVerify,TRUE,
      PGA_Freedom,FREEVERT,
      PGA_Top,200,
      PGA_Total,2000,
      PGA_Visible,300,
      ICA_TARGET,ICTARGET_IDCMP,
      PGA_NewLook,TRUE,
      GOB_BorderObj(&LBorder),
      TAG_END) );

   BevelBox BBorder;

   MyBoopsi *prop2 = new MyBoopsi(little,
      (UBYTE*)"propgclass",
      AttrList(
      GOB_LeftFromLeftOfParent,2,
      GOB_TopFromTopOfParent,2,
      GOB_RightFromLeftOfParent,15,
      GOB_BottomFromBottomOfParent,-10,
      GA_Immediate,TRUE,
      GA_RelVerify,TRUE,
      PGA_Freedom,FREEVERT,
      CONSTRAINT( PGA_Top,prop1,PGA_Top ),
      PGA_Total,2000,
      PGA_Visible,1000,
      ICA_TARGET,ICTARGET_IDCMP,
      PGA_NewLook,TRUE,
      GOB_BorderObj(&BBorder),
      TAG_END) );

   prop1->setAttributes( AttrList( CONSTRAINT( PGA_Top,prop2,PGA_Top ), TAG_END) );

   if (! APPOK(prop2) )
      cerr << " APPOK() on "<<(APTR)prop2<<" failed, status "<<(LONG)prop2->status()<<"\n";
   if (! APPOK(prop1) )
      cerr << "prop1 invalid\n";

   stop_window = little;
   cout << little <<endl;
   cout << "sizeof( )"<<"\nBoopsigadget\t"<<sizeof(MyBoopsi)<<endl<<"\nGWindow\t"<<sizeof(GWindow)<<endl;
   little->refreshGList();

   while (running)
   {
      SignalResponder::WaitSignal();
   }

   cout << "cleaned up. goodbye.\n";
}
