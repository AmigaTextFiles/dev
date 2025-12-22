/******************************************************************************
 *
 *    $Source: apphome:RCS/testprgs/intuition/GT_test.cxx,v $
 *
 *    Demo for the A++ Library
 *    Copyright (C) 1994 by Armin Vogt, EMail: armin@uni-paderborn.de
 *
 *    $Revision: 1.8 $
 *    $Date: 1994/07/23 19:15:33 $
 *    $Author: Armin_Vogt $
 *
 ******************************************************************************/


#include <APlusPlus/exec/SignalResponder.h>
#include <APlusPlus/intuition/GWindow.h>
#include <APlusPlus/gadtools/GT_Scroller.h>
#include <APlusPlus/gadtools/GT_String.h>
#include <APlusPlus/gadtools/GT_Boolean.h>
#include <APlusPlus/intuition/BoopsiGadget.h>
#include <APlusPlus/graphics/AutoDrawArea.h>
#include <APlusPlus/intuition/ITransponder.h>
#include <APlusPlus/intuition/IntuiMessageC.h>
#include <APlusPlus/graphics/GBorder.h>


extern "C" {
#include <dos/dos.h>
}


static const char rcs_id[] = "$Id: GT_test.cxx,v 1.8 1994/07/23 19:15:33 Armin_Vogt Exp Armin_Vogt $";


BOOL running = TRUE;
BOOL close2 = FALSE;
GWindow *stop_window;


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


class MyWindow : public GWindow
{
   private:
      void init()
      {
         modifyIDCMP(CLASS_NEWSIZE|CLASS_CLOSEWINDOW|CLASS_ACTIVEWINDOW|CLASS_SIZEVERIFY);
      }

   public:
      MyWindow(OWNER,AttrList& attrs) : GWindow(owner,attrs) { init(); }
      ~MyWindow() {}

      void On_CLOSEWINDOW(const IntuiMessageC *msg)
      {
         puts("CLOSEWINDOW.\n");
         if (this == stop_window) running = FALSE;
         else close2 = TRUE;
      }
      void On_ACTIVEWINDOW(const IntuiMessageC *msg)
      {
         ULONG dummy=0;
         printf("%s is ACTIVE.\n",getAttribute(WA_Title,dummy));
      }
      void On_SIZEVERIFY(const IntuiMessageC *msg)
      {
         puts("SIZEVERIFY. \n");
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

};

class BoolGadget : public GT_Boolean, public ITransponder
{
   protected:
      // this method will be called each time the user clicks on the button
      // the attrs contains the Attribute Tag GA_ID,<gadget_id> to identify the sending gadget.
      // <gadget_id> is the value that has been given on the constructor attribute list
      // of an object of this class.
      void sendNotification(AttrList& attrs)
      {
         printf("GT_Boolean hit: GA_ID=%ld\n",attrs.getTagData(GA_ID,-1));
      }
   public:
      BoolGadget(GOB_OWNER,AttrList& attrs) : GT_Boolean(gob_owner,attrs)
      {
         // since this class is composed of a Gadget plus its ITransponder
         // it has to announce its ITransponder to the Gadget.
         // Due to the use of 'setAttributes()' both base class AND class user
         // ITransponder settings will be overwritten!
         // IMPORTANT: the call of a virtual method within a CONSTRUCTOR is
         // UNDEFINED! Therefore you MUST qualify the base class with the 
         // scope resolution operator '::' to suppress the virtual mechanism.
         GT_Boolean::setAttributes( AttrList(ITRANSPONDER(this), TAG_END) );
      }
      ~BoolGadget() {}
   
      // runtime type inquiry support
      static const Intui_Type_info info_obj;
      virtual const Type_info& get_info() const     // get the 'type_id' to an existing object
         { return info_obj; }
      static const Type_info& info()                // get the 'type_id' of a specific class
         { return info_obj; }
};

intui_typeinfo(BoolGadget, derived(from(GT_Boolean)), rcs_id);


void APPmain(int argc,char* argv[])
{
   MySRSP sr(SIGBREAKB_CTRL_C);

   NeXTBorder border;

   MyWindow *little = new MyWindow(OWNER_NULL,
   AttrList(  WA_Title,"WindowC - close this to stop.",
      WA_Width,300,
      WA_Height,150,
      WA_MinHeight,50,
      WA_MinWidth,50,
      WA_MaxHeight,1000,
      WA_MaxWidth,1000,
      WA_DragBar,TRUE,
      WA_SizeGadget,TRUE,
      WA_DepthGadget,TRUE,
      WA_CloseGadget,TRUE,
      WA_IDCMP,TRUE,
      GOB_BorderObj(&border),
      GOB_BorderTitle,(UBYTE*)"Boopsi & GadTools",
      GOB_BackgroundColor,5,
      TAG_END) );


   class Boopsi2GTSC : public ITransponder
   {
      private:
      public:
         virtual void sendNotification(AttrList& attrs)
         {
            attrs.mapAttrs(PGA_Top, GTSC_Top, GA_ID,GA_ID, TAG_END);

            puts("   notification received "); attrs.print();
            if (APPOK(receiver1))
            {
               if(receiver1->setAttributes(attrs)) puts("   visual change\n");
            }
            else printf(" receiver(%lx) is INVALID!\n",(APTR)this);
            puts("   notification forwarded.\n");
         }
   }
   boopsi2GTSC;

   class GTSC2Boopsi : public ITransponder
   {
      private:
      public:
         virtual void sendNotification(AttrList& attrs)
         {
            attrs.mapAttrs( GTSC_Top,PGA_Top, GA_ID,GA_ID,TAG_END);

            puts("   notification received "); attrs.print();
            if (APPOK(receiver1))
            {
               if(receiver1->setAttributes(attrs)) puts("   visual change\n");
            }
            else printf(" receiver(%lx) is INVALID!\n",(APTR)this);
            puts("   notification forwarded.\n");
         }
   } GTSC2boopsi;


   GTSC2boopsi.setReceiver( new BoopsiGadget(little,
      (UBYTE*)"propgclass",
   AttrList(
      GOB_LeftFromRightOfParent,-20,
      GOB_TopFromTopOfParent,1,
      GOB_RightFromRightOfParent,-1,
      GOB_BottomFromBottomOfParent,-1,
      GA_Immediate,TRUE,
      GA_RelVerify,TRUE,
      PGA_Freedom,FREEVERT,
      PGA_Top,1,
      PGA_Total,20,
      PGA_Visible,5,
      ICA_TARGET,ICTARGET_IDCMP,
      PGA_NewLook,TRUE,
      ITRANSPONDER(&boopsi2GTSC),
      TAG_END)) );


   boopsi2GTSC.setReceiver( new GT_Scroller(little,
   AttrList(
      GOB_LeftFromLeftOfPred,-20,
      GOB_TopFromTopOfPred,0,
      GOB_RightFromLeftOfPred,-2,
      GOB_BottomFromBottomOfPred,-10,
      GA_Immediate,TRUE,
      GA_RelVerify,TRUE,
      PGA_Freedom,LORIENT_VERT,
      GTSC_Top,1,
      GTSC_Total,20,
      GTSC_Visible,2,
      GTSC_Arrows,8,
      GT_IDCMP,SLIDERIDCMP,
      ITRANSPONDER(&GTSC2boopsi),
      GA_ID,2344,
      TAG_END)) );


   class StringOut : public ITransponder
   {
      protected:
         // each time the user presses the return key in the string gadget
         // a notification arrives here with the new GTST_String value pointing to
         // the string in the edit buffer
         void sendNotification(AttrList& attrs)
         {
            printf("GT_String: '%s'\n",(char*)attrs.getTagData(GTST_String,NULL));
         }
   } stringOut;

   new GT_String(little,
   AttrList(
      GOB_LeftFromLeftOfParent,10,
      GOB_TopFromTopOfParent,10,
      GOB_RightFromLeftOfPred,-10,
      GOB_BottomFromTopOfParent,30,
      GTST_String,(UBYTE*)"Enter here.",
      GA_RelVerify,TRUE,
      ITRANSPONDER(&stringOut),  // call 'stringOut::sendNotification' on attribute change.
      TAG_END) );


   new BoolGadget(little,
   AttrList(
      GOB_LeftFromLeftOfParent,20,
      GOB_TopFromBottomOfPred,3,
      GOB_Width,90,
      GOB_Height,30,
      GA_Immediate,TRUE,
      GA_RelVerify,TRUE,
      GA_Text,(UBYTE*)" Click ",
      GA_ID, 23,     // will be sent to sendNotification as tag item
      TAG_END) );

   stop_window = little;

   little->refreshGList();

   while (running)
   {
      SignalResponder::WaitSignal();
   }

   puts("cleaned up. goodbye.\n");
}
