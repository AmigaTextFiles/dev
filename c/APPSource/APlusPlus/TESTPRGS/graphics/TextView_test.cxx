/******************************************************************************
 *
 *    $Source: apphome:RCS/testprgs/graphics/TextView_test.cxx,v $
 *
 *    Demo for the A++ Library
 *    Copyright (C) 1994 by Armin Vogt, EMail: armin@uni-paderborn.de
 *
 *    $Revision: 1.7 $
 *    $Date: 1994/07/23 19:15:03 $
 *    $Author: Armin_Vogt $
 *
 ******************************************************************************/


extern "C" {
#include <dos/dos.h>
#include <stdio.h>
}

#include <APlusPlus/exec/SignalResponder.h>
#include <APlusPlus/intuition/GWindow.h>
#include <APlusPlus/gadtools/GT_Scroller.h>
#include <APlusPlus/intuition/BoopsiGadget.h>
#include <APlusPlus/graphics/TextView.h>
#include <APlusPlus/intuition/IntuiMessageC.h>
#include <APlusPlus/graphics/GBorder.h>
#include <iostream.h>

static const char rcs_id[] = "$Id: TextView_test.cxx,v 1.7 1994/07/23 19:15:03 Armin_Vogt Exp Armin_Vogt $";


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
class MyTv : public TextView
{
   public:
      MyTv(GOB_OWNER,AttrList& attrs) : TextView(gob_owner,attrs) { }
      ~MyTv() {}
      
      // runtime type inquiry support
      static const Intui_Type_info info_obj;
      virtual const Type_info& get_info() const     // get the 'type_id' to an existing object
         { return info_obj; }
      static const Type_info& info()                // get the 'type_id' of a specific class
         { return info_obj; }

   protected:
      UBYTE *getLineString(LONG line,UWORD& len)
      {
         static UBYTE string[60];
         sprintf((char*)&string[0],"This is line %3ld of a text displayed in a TextView in Times 15p.",line);
         len = strlen((char*)string);
         return string;
      }
      void formatOutput(UBYTE *lineText,UWORD length)
      {
         if (length>17)
         {
            setDrMd(JAM1);
            setAPen(1);
            text(lineText,8);
            setAPen(3);
            text(lineText+8,9);
            setAPen(1);
            text(lineText+8+9,length-8-9);
         }
      }
      void callback(const IntuiMessageC *imsg)
      {
         TextView::callback(imsg);

      }

};

intui_typeinfo(MyTv, derived(from(TextView)), rcs_id)


/******************************************************************************

      MyWindow class is a window containing a TextView with two scrollers
      attached to

 ******************************************************************************/
class MyWindow : public GWindow
{
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
      void handleIntuiMsg(const IntuiMessageC* imsg)
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

   private:
      void init();
      BevelBox bevel;
};

intui_typeinfo(MyWindow, derived(from(GWindow)), rcs_id);


void MyWindow::init()
{
   modifyIDCMP(CLASS_NEWSIZE|CLASS_CLOSEWINDOW|CLASS_ACTIVEWINDOW|CLASS_SIZEVERIFY \
   |CLASS_GADGETDOWN|CLASS_GADGETUP|CLASS_MOUSEMOVE|CLASS_RAWKEY|CLASS_VANILLAKEY);

   MyTv *myTextView = new MyTv(this, AttrList(
      GOB_LeftFromLeftOfParent,0,
      GOB_TopFromTopOfParent,0,
      GOB_RightFromRightOfParent,-18,
      GOB_BottomFromBottomOfParent,-18,
      GOB_BorderObj(&bevel),
      CNV_Width, 1000,
      CNV_GranularityX, 30,
      TXV_Lines, 50,
      TXV_FontName, "times.font",
      TXV_FontSize, 15,
      TXV_CursorOn, TRUE,
      TAG_END) );

   BoopsiGadget *boopsiG = new BoopsiGadget(this,
      (UBYTE*)"propgclass", AttrList(
      GOB_LeftFromRightOfPred,2,
      GOB_TopFromTopOfParent,0,
      GOB_RightFromRightOfParent,0,
      GOB_BottomFromBottomOfPred,0,
      GOB_BorderObj(&bevel),
      GA_Immediate,TRUE,
      GA_RelVerify,TRUE,
      PGA_Freedom,FREEVERT,
      ICA_TARGET,ICTARGET_IDCMP,
      PGA_NewLook,TRUE,
      CONSTRAINT(PGA_Top,myTextView,CNV_ViewY),
      CONSTRAINT(PGA_Visible,myTextView,CNV_VisibleY),
      CONSTRAINT(PGA_Total,myTextView,CNV_Height),
      TAG_END) );

   GT_Scroller *gtscG = new GT_Scroller(this,
   AttrList(   GOB_LeftFromLeftOfParent,0,
      GOB_TopFromBottomOfPred,2,
      GOB_RightFromLeftOfPred,0,
      GOB_BottomFromBottomOfParent,0,
      GA_Immediate,TRUE,
      GA_RelVerify,TRUE,
      PGA_Freedom,LORIENT_HORIZ,
      GTSC_Arrows,16,
      CONSTRAINT(GTSC_Top,myTextView,CNV_ViewX),
      CONSTRAINT(GTSC_Visible,myTextView,CNV_VisibleX),
      CONSTRAINT(GTSC_Total,myTextView,CNV_Width),
      TAG_END) );

   myTextView->setAttributes( AttrList(
      CONSTRAINT(CNV_ViewX,gtscG,GTSC_Top),
      CONSTRAINT(CNV_ViewY,boopsiG,PGA_Top),
      TAG_END) );

   refreshGList();   // display the gadgets

}


void APPmain(int argc,char* argv[])
{
   MySRSP sr(SIGBREAKB_CTRL_C);
      LineBorder lineBorder;

   new MyWindow(OWNER_NULL,
   AttrList(   WA_Title,"WindowC - close this to stop.",
      WA_Width,300,
      WA_Height,150,
      WA_MinWidth,200,
      WA_MinHeight,100,
      WA_MaxHeight,1600,
      WA_MaxWidth,1600,
      WA_DragBar,TRUE,
      WA_SizeGadget,TRUE,
      WA_DepthGadget,TRUE,
      WA_CloseGadget,TRUE,
      WA_IDCMP,IDCMP_CLOSEWINDOW,
      WA_SmartRefresh,TRUE,
      GOB_BorderObj(&lineBorder),
      TAG_END) );



   while (running)
   {
      SignalResponder::WaitSignal();
   }

   cout << "main() end.\n";
}
