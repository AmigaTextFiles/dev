/******************************************************************************
 *
 *    $Source: apphome:RCS/testprgs/graphics/Canvas_test.cxx,v $
 *
 *    Demo for the A++ Library
 *    Copyright (C) 1994 by Armin Vogt, EMail: armin@uni-paderborn.de
 *
 *    $Revision: 1.7 $
 *    $Date: 1994/07/23 19:14:56 $
 *    $Author: Armin_Vogt $
 *
 ******************************************************************************/


static const char rcs_id[] = "$Id: Canvas_test.cxx,v 1.7 1994/07/23 19:14:56 Armin_Vogt Exp Armin_Vogt $";


//**  This demo can use ITransponders as alternative to the Constraints.
//**  To compile with ITransponders define USE_ITP.



extern "C" {
#include <dos/dos.h>
}

#include <stdio.h>

#include <APlusPlus/exec/SignalResponder.h>
#include <APlusPlus/intuition/GWindow.h>
#include <APlusPlus/gadtools/GT_Scroller.h>
#include <APlusPlus/intuition/BoopsiGadget.h>
#include <APlusPlus/graphics/Canvas.h>
#include <APlusPlus/intuition/IntuiMessageC.h>
#include <APlusPlus/graphics/GBorder.h>


//------- use ITransponders instead of Constraints --------
#define USE_ITP

#ifdef USE_ITP
#include <APlusPlus/intuition/ITransponder.h>
#endif

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
         puts("**Break\n");
         running = FALSE;
      }
};
class MyCanvas : public Canvas
{
   public:
      MyCanvas(GOB_OWNER,AttrList& attrs) : Canvas(gob_owner,attrs) { }
      ~MyCanvas() {}

      void drawSelf()
      {
         setAPen(1);
         move(10,10);
         text((UBYTE*)"Hey, this is a canvas demo.");
         move(10,30);
         for (XYVAL x=30;x<900;x+=30)
            {
               move(10+x,30+x/6);
               draw(x,200);
               setAPen(1);
            }
         move(30,900);
         text((UBYTE*)"You're still there! Move up..");

      }
      void callback(const IntuiMessageC* imsg)
      {
         puts("Canvas: mouse action!\n");
      }
      // runtime type inquiry support
      static const Intui_Type_info info_obj;
      virtual const Type_info& get_info() const     // get the 'type_id' to an existing object
         { return info_obj; }
      static const Type_info& info()                // get the 'type_id' of a specific class
         { return info_obj; }

};

intui_typeinfo(MyCanvas, derived(from(Canvas)), rcs_id);


class MyWindow : public GWindow
{
   private:
      void init();

   public:
      MyWindow(OWNER,AttrList& attrs) : GWindow(owner,attrs) { init(); }

      void On_CLOSEWINDOW(const IntuiMessageC* msg)
      {
         puts("CLOSEWINDOW.\n");
         delete this;
         running = FALSE;
      }
      void On_ACTIVEWINDOW(const IntuiMessageC* msg)
      {
         printf("%s is ACTIVE.\n",title());
      }
      void On_SIZEVERIFY(const IntuiMessageC* msg)
      {
         puts("SIZEVERIFY. \n");
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
   modifyIDCMP(CLASS_NEWSIZE|CLASS_CLOSEWINDOW|CLASS_ACTIVEWINDOW|CLASS_SIZEVERIFY \
   |CLASS_GADGETDOWN|CLASS_GADGETUP|CLASS_MOUSEMOVE);
}


void APPmain(int argc,char* argv[])
{
   MySRSP sr(SIGBREAKB_CTRL_C);
   BevelBox bevelBoxBorder;
   LineBorder lineBorder;

   MyWindow* little = new MyWindow(OWNER_NULL,
   AttrList(   WA_Title,"WindowC - close this to stop.",
      WA_Width,300,
      WA_Height,150,
      WA_MinWidth,200,
      WA_MinHeight,100,
      WA_MaxHeight,600,
      WA_MaxWidth,600,
      WA_DragBar,TRUE,
      WA_SizeGadget,TRUE,
      WA_DepthGadget,TRUE,
      WA_CloseGadget,TRUE,
      WA_IDCMP,IDCMP_CLOSEWINDOW,
      WA_SmartRefresh,TRUE,
   // GOB_BorderObj(&lineBorder),
      TAG_END) );

#ifdef USE_ITP
   MapITP PGA2Canvas(NULL, AttrList(PGA_Top,CNV_ViewY,TAG_END) ),
          GTSC2Canvas(NULL, AttrList(GTSC_Top,CNV_ViewX,TAG_END) );

   /* special ITransponder with the ability to serve two receiver objects. */
   class C2S : public ITransponder
   {
         IntuiObject* receiver2;

         void sendNotification(AttrList& attrs)
         {
            puts("C2S::sendNotification received n.s. = "); attrs.print();

            attrs.mapAttrs(CNV_Width,GTSC_Total, CNV_VisibleX,GTSC_Visible, CNV_ViewX,GTSC_Top,
                           CNV_Height,PGA_Total, CNV_VisibleY,PGA_Visible,  CNV_ViewY,PGA_Top,
                           TAG_END);
            puts("C2S: map to: "); attrs.print();

            // each receivers gets his own attrs it can work on
            if (APPOK(receiver1))   receiver1->setAttributes(AttrList(attrs));
            if (APPOK(receiver2))   receiver2->setAttributes(attrs);
         }
      public:
            C2S(IntuiObject* rcv1=NULL,IntuiObject* rcv2=NULL)
            {
               setReceivers(rcv1,rcv2);
            }
            void setReceivers(IntuiObject* rcv1,IntuiObject* rcv2)
            {
               receiver1 = rcv1; receiver2 = rcv2;
            }

   };

   C2S canvas2Scrollbars;
#endif

   MyCanvas* canvas = new MyCanvas(little,
   AttrList(  GOB_LeftFromLeftOfParent,0,
      GOB_TopFromTopOfParent,0,
      GOB_RightFromRightOfParent,-18,
      GOB_BottomFromBottomOfParent,-18,
      GOB_BorderObj(&bevelBoxBorder),
      CNV_Width,100,
      CNV_Height,1000,
      CNV_GranularityX,5,
      CNV_ViewX,1,
#ifdef USE_ITP
      ITRANSPONDER(&canvas2Scrollbars),
#endif
      TAG_END) );

#ifdef USE_ITP
   GTSC2Canvas.setReceiver(canvas);
   PGA2Canvas.setReceiver(canvas);
   ULONG dummy = 0;
#endif

   BoopsiGadget* boopsiG = new BoopsiGadget(little,
      (UBYTE*)"propgclass",
   AttrList(   GOB_LeftFromRightOfPred,2,
      GOB_TopFromTopOfParent,0,
      GOB_RightFromRightOfParent,0,
      GOB_BottomFromBottomOfPred,0,
      GOB_BorderObj(&bevelBoxBorder),
      GA_Immediate,TRUE,
      GA_RelVerify,TRUE,
      PGA_Freedom,FREEVERT,
      ICA_TARGET,ICTARGET_IDCMP,
      PGA_NewLook,TRUE,
#ifdef USE_ITP
      PGA_Top,canvas->getAttribute(CNV_ViewY,dummy),
      PGA_Visible,canvas->getAttribute(CNV_VisibleY,dummy),
      PGA_Total,canvas->getAttribute(CNV_Height,dummy),
      ITRANSPONDER(&PGA2Canvas),
#else
      CONSTRAINT(PGA_Top,canvas,CNV_ViewY),
      CONSTRAINT(PGA_Visible,canvas,CNV_VisibleY),
      CONSTRAINT(PGA_Total,canvas,CNV_Height),
#endif
      TAG_END) );

   GT_Scroller* gtscG = new GT_Scroller(little,
   AttrList(   GOB_LeftFromLeftOfParent,0,
      GOB_TopFromBottomOfPred,2,
      GOB_RightFromLeftOfPred,0,
      GOB_BottomFromBottomOfParent,0,
//    GOB_BorderObj(&bevelBoxBorder),
      GA_Immediate,TRUE,
      GA_RelVerify,TRUE,
      PGA_Freedom,LORIENT_HORIZ,
      GTSC_Arrows,16,
#ifdef USE_ITP
      GTSC_Top,canvas->getAttribute(CNV_ViewX,dummy),
      GTSC_Visible,canvas->getAttribute(CNV_VisibleX,dummy),
      GTSC_Total,canvas->getAttribute(CNV_Width,dummy),
      ITRANSPONDER(&GTSC2Canvas),
#else
      CONSTRAINT(GTSC_Top,canvas,CNV_ViewX),
      CONSTRAINT(GTSC_Visible,canvas,CNV_VisibleX),
      CONSTRAINT(GTSC_Total,canvas,CNV_Width),
#endif
      TAG_END) );

#ifdef USE_ITP
   canvas2Scrollbars.setReceivers(boopsiG,gtscG);
#else
   canvas->setAttributes( AttrList(
      CONSTRAINT(CNV_ViewX,gtscG,GTSC_Top),
      CONSTRAINT(CNV_ViewY,boopsiG,PGA_Top),
      TAG_END) );
#endif

   little->refreshGList();    // display the gadgets

   while (running)
   {
      SignalResponder::WaitSignal();
   }

   puts("main() end.\n");
}
