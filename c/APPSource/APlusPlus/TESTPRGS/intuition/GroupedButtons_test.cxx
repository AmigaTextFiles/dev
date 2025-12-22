/******************************************************************************
 *
 *    $Source: apphome:RCS/TESTPRGS/intuition/GroupedButtons_test.cxx,v $
 *
 *    Demo for the A++ Library
 *    Copyright (C) 1994 by Armin Vogt, EMail: armin@uni-paderborn.de
 *
 *    $Revision: 1.7 $
 *    $Date: 1994/08/01 16:10:54 $
 *    $Author: Armin_Vogt $
 *
 ******************************************************************************/


#include <APlusPlus/exec/SignalResponder.h>
#include <APlusPlus/intuition/GWindow.h>
#include <APlusPlus/intuition/IntuiMessageC.h>
#include <APlusPlus/intuition/ITransponder.h>
#include <APlusPlus/graphics/GBorder.h>
#include <APlusPlus/gadtools/GT_Boolean.h>
#include <APlusPlus/graphics/RowColumnGroup.h>


extern "C" {
#include <dos/dos.h>
}


static const char rcs_id[] = "$Id: GroupedButtons_test.cxx,v 1.7 1994/08/01 16:10:54 Armin_Vogt Exp Armin_Vogt $";


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
         puts("**Break");
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
         modifyIDCMP(CLASS_NEWSIZE|CLASS_CLOSEWINDOW|CLASS_ACTIVEWINDOW|CLASS_SIZEVERIFY);
      }

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




void MyWindow::On_CLOSEWINDOW(const IntuiMessageC *msg)
{
   puts("CLOSEWINDOW.");
   delete this;   // it is allowed for WindowCV class to destroy itself
}

void MyWindow::On_ACTIVEWINDOW(const IntuiMessageC *msg)
{
   puts(title()); puts(" is ACTIVE.");
}

void MyWindow::On_SIZEVERIFY(const IntuiMessageC *msg)
{
   puts("SIZEVERIFY. ");
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



void APPmain(int argc,char* argv[]) // this is NOT "main()" !!
{
   MySRSP userBreak;

   NeXTBorder border;

   /* Per default a Window object has an IDCMP for CLOSEWINDOW
    */
   MyWindow *little = new MyWindow(OWNER_NULL,
   AttrList(   WA_Title,"Window - close this to stop.",
      WA_Width,300,
      WA_Height,150,
      WA_MinHeight,40,
      WA_MinWidth,90,
      WA_MaxHeight,1600,
      WA_MaxWidth,1600,
      /* These are already default values..
      WA_DragBar,TRUE,
      WA_SizeGadget,TRUE,
      WA_DepthGadget,TRUE,
      WA_CloseGadget,TRUE,
      */
      GOB_BorderObj(&border), // GBorder object defining the border/background rendering
      GOB_BorderTitle,(UBYTE*)"RowColumnGroup", // these two tags go with
      GOB_BackgroundColor,4,                    // the GBorder object.
      TAG_END) );

   /* The child GraphicObjects of a Group gadget are placed within the
    * Group gadget depending on the geometry management implemented in that
    * very Group gadget class.
    * 'RowColumnGroup' lines its childs up in a row considering their width
    * and height in the arrangement.
    */
   RowColumnGroup *rcg = new RowColumnGroup(little,
   AttrList(
      GOB_LeftFromLeftOfParent,0,
      GOB_TopFromBottomOfParent,-40,
      GOB_RightFromRightOfParent,0,
      GOB_BottomFromBottomOfParent,0,
      TAG_END) );

   /* The object 'collector' collects all notification streams from the
    * three GT_Boolean gadgets. These send an AttrList containing the 'GA_ID'
    * attribute with the gadget ID.
    */
   class Collector : public ITransponder
   {
      protected:
         void sendNotification(AttrList& attrs)
         {
            printf("GT_Boolean hit: GA_ID = %ld\n",attrs.getTagData(GA_ID,-1));
         }
   } collector;


   /* For the GT_Boolean gadgets <GA_ID,1> will arive at the 'collector' for
    * each button press
    */
   new GT_Boolean(rcg,
   AttrList(
      GOB_Width,80,
      GOB_Height,20,
      GA_Immediate,TRUE,
      GA_RelVerify,TRUE,
      GA_Text,(UBYTE*)" Save ",
      GA_ID,1,                   // <GA_ID,1> will arive at the 'collector'
      ITRANSPONDER(&collector),
      TAG_END) );

   new GT_Boolean(rcg,
   AttrList(
      GOB_Width,80,
      GOB_Height,20,
      GA_Immediate,TRUE,
      GA_RelVerify,TRUE,
      GA_Text,(UBYTE*)" Use ",
      GA_ID,2,
      ITRANSPONDER(&collector),
      TAG_END) );

   new GT_Boolean(rcg,
   AttrList(
      GOB_Width,80,
      GOB_Height,20,
      GA_Immediate,TRUE,
      GA_RelVerify,TRUE,
      GA_Text,(UBYTE*)" Cancel ",
      GA_ID,3,
      ITRANSPONDER(&collector),
      TAG_END) );

   little->refreshGList();    // display all GraphicObjects


   // Notice: "APPOK(little)" expands to "(little!=NULL && little->Ok())"

   while (userBreak.hasNotOccured() && APPOK(little))
      SignalResponder::WaitSignal();

   puts("main() end.\n");
}
