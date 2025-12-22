/******************************************************************************
 *
 *    $Source: apphome:RCS/testprgs/graphics/AutoDrawArea_test.cxx,v $
 *
 *    Demo for the A++ Library
 *    Copyright (C) 1994 by Armin Vogt, EMail: armin@uni-paderborn.de
 *
 *    $Revision: 1.7 $
 *    $Date: 1994/07/23 19:14:49 $
 *    $Author: Armin_Vogt $
 *
 ******************************************************************************/


extern "C" {
#include <dos/dos.h>
}
#include <APlusPlus/exec/SignalResponder.h>
#include <APlusPlus/intuition/GWindow.h>
#include <APlusPlus/graphics/AutoDrawArea.h>
#include <APlusPlus/intuition/IntuiMessageC.h>
#include <APlusPlus/graphics/GBorder.h>

#include <iostream.h>

static const char rcs_id[] = "$Id: AutoDrawArea_test.cxx,v 1.7 1994/07/23 19:14:49 Armin_Vogt Exp Armin_Vogt $";


BOOL running = TRUE;
BOOL close2 = FALSE;

class MySRSP : public SignalResponder
{
   public:
      MySRSP(BYTE signal) : SignalResponder(signal,0) {}
      ~MySRSP() {}
      // overload the virtual 'signal received' action callback method.
      void actionCallback()
      {
         cout << "**Break\n";
         running = FALSE;
      }
};

// This customized AutoDrawArea class draw somethin within its boundary box
// according to its personal 'drawSelf()' method.
// Create as much of these as you like within a GWindow - they will all look
// the same.

class MyAutoDrawArea : public AutoDrawArea
{
   public:
      MyAutoDrawArea(GraphicObject *owner,AttrList& attrs) : AutoDrawArea(owner,attrs) { }
      ~MyAutoDrawArea() {}

      void drawSelf()
      {
         setDrMd(JAM2);
         setDrPt(~0);
         setAPen(2);
         setOPen(3);
         rectFill(0,0,iWidth()-1,iHeight()-1);
         setAPen(3);
         drawEllipse(iWidth()/2,iHeight()/2,iWidth()/2,iHeight()/2);
         setAPen(1);
         WORD polyTable[] = {10,10,40,10,40,40,10,40,10,10};
         polyDraw(5,polyTable);
      }
      
      // runtime type inquiry support
      static const Intui_Type_info info_obj;
      virtual const Type_info& get_info() const     // get the 'type_id' to an existing object
         { return info_obj; }
      static const Type_info& info()                // get the 'type_id' of a specific class
         { return info_obj; }

};

intui_typeinfo(MyAutoDrawArea, derived(from(AutoDrawArea)), rcs_id);


class MyWindow : public GWindow
{
   private:
      void init();

   public:
      MyWindow(OWNER,AttrList& attrs) : GWindow(owner,attrs) { init(); }


      void On_CLOSEWINDOW(const IntuiMessageC *msg)
      {
         cout << "CLOSEWINDOW.\n";
         delete this;
         running = FALSE;
      }
      void On_ACTIVEWINDOW(const IntuiMessageC *msg)
      {
         cout << title() << " is ACTIVE.\n";
      }
      void On_SIZEVERIFY(const IntuiMessageC *msg)
      {
         cout << "SIZEVERIFY. \n";
      }
      virtual void handleIntuiMsg(const IntuiMessageC* imsg)
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


void APPmain(int argc,char* argv[])
{
   MySRSP sr(SIGBREAKB_CTRL_C);


   NeXTBorder lineBorder;


   MyWindow *little = new MyWindow(OWNER_NULL,
   AttrList( WA_Title,"WindowC - close this to stop.",
      WA_Left,300,
      WA_Top,200,
      WA_Width,300,
      WA_Height,150,
      WA_MinHeight,100,
      WA_MinWidth,200,
      WA_MaxHeight,1600,
      WA_MaxWidth,1600,
      WA_DragBar,TRUE,
      WA_SizeGadget,TRUE,
      WA_DepthGadget,TRUE,
      WA_CloseGadget,TRUE,
      WA_IDCMP,IDCMP_CLOSEWINDOW,
      GOB_BorderObj(&lineBorder),
      GOB_BorderTitle, (UBYTE*)" AutoDrawArea ",
      GOB_BackgroundColor, 4,
      TAG_END) );

   new MyAutoDrawArea(little,
   AttrList( GOB_LeftFromLeftOfParent,0,
             GOB_TopFromTopOfParent,0,
             GOB_RightFromRightOfParent,0,
             GOB_BottomFromBottomOfParent,0,
             TAG_END) );

   new MyAutoDrawArea(little,
   AttrList( GOB_LeftFromRightOfParent,-50,
             GOB_TopFromTopOfParent,10,
             GOB_RightFromRightOfParent,-10,
             GOB_BottomFromBottomOfParent,-1,
             GOB_BorderObj(&lineBorder),
             TAG_END) );

   new MyAutoDrawArea(little,
   AttrList( GOB_LeftFromLeftOfPred,-50,
             GOB_TopFromTopOfParent,10,
             GOB_RightFromLeftOfPred,-1,
             GOB_BottomFromBottomOfParent,-2,
             GOB_BorderObj(&lineBorder),
             TAG_END) );

   little->refreshGList();    // display objects

   while (running)
   {
      SignalResponder::WaitSignal();
   }

   cout << "cleaned up. goodbye.\n";
}
