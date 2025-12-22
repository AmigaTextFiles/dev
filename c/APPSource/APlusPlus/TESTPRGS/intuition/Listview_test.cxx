/******************************************************************************
 *
 *    $Source: apphome:RCS/testprgs/intuition/Listview_test.cxx,v $
 *
 *    Demo for the A++ Library
 *    Copyright (C) 1994 by Armin Vogt, EMail: armin@uni-paderborn.de
 *
 *    $Revision: 1.6 $
 *    $Date: 1994/07/23 19:15:41 $
 *    $Author: Armin_Vogt $
 *
 ******************************************************************************/


#include <APlusPlus/exec/SignalResponder.h>
#include <APlusPlus/intuition/GWindow.h>
#include <APlusPlus/graphics/GBorder.h>
#include <APlusPlus/gadtools/GT_Scroller.h>
#include <APlusPlus/gadtools/GT_Listview.h>
#include <APlusPlus/graphics/AutoDrawArea.h>
#include <APlusPlus/intuition/IntuiMessageC.h>


#include <stdio.h>

extern "C" {
#include <dos/dos.h>
}


volatile static char rcs_id[] = "$Id: Listview_test.cxx,v 1.6 1994/07/23 19:15:41 Armin_Vogt Exp Armin_Vogt $";



// a CTRL-C signal responder from the example in the docs
class MySRSP : public SignalResponder
{
   private:
      BOOL running;  // indicates a received user break to object users
   public:
      MySRSP() : SignalResponder(SIGBREAKB_CTRL_C,0)
      { running = TRUE; }
      ~MySRSP() {}   // NEVER FORGET DO DEFINE EVEN AN EMPTY DESTRUCTOR WITH SASC 6.51. THIS IS A KNOWN BUG!!

      //  overload the virtual 'signal received' action callback method.
      void actionCallback()
      {
         puts("**Break\n");
         running = FALSE;  // end WaitSignal loop
      }

      // object users can check with this method wether a user break has occurred
      BOOL hasNotOccured() { return running==TRUE; }
};




// derive GWindow and add your specific message actions
class MyWindow : public GWindow
{
   private:
      BOOL running;
   public:
      MyWindow(OWNER,AttrList& attrs) : GWindow(owner,attrs)
      {
         if (Ok())   // always check for the correct execution of all base class constructors
         {
            // It is necessary to announce those messages codes this Window class awaits
            // that are not already preset for WindowCV to the WindowCV base class.
            modifyIDCMP(CLASS_ACTIVEWINDOW);
            running = TRUE;
         }
         else running = TRUE;
      }

      ~MyWindow() {}


      void On_CLOSEWINDOW(const IntuiMessageC *msg)
      {
         puts("CLOSEWINDOW.\n");
         running = FALSE;
      }
      void On_ACTIVEWINDOW(const IntuiMessageC *msg)
      {
         ULONG dummy = 0;
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
         // DO NOT FORGET to hand each message over to the subclass!
      }

      BOOL isNotClosed() { return running==TRUE; }
};



void APPmain(int argc,char* argv[])
{
   MySRSP userBreak;

   NeXTBorder background((UBYTE*)"diamond.font",12);

   MyWindow *mainWindow = new MyWindow(OWNER_NULL,
   AttrList(   WA_Title,(UBYTE*)"WindowC - close this to stop.",
      WA_Width,300,
      WA_Height,150,
      WA_MinHeight,60,
      WA_MinWidth,100,
      WA_MaxHeight,1000,
      WA_MaxWidth,1000,
      GOB_BorderObj(&background),
      GOB_BackgroundColor,4,
      GOB_BorderTitle, (UBYTE*)" GT_Listview & GT_Scroller ",
      TAG_END) );


   ListC labels;
   #define LABEL_CNT (4*6)


   // create a sufficient number of NodeC objects that hold the strings as names
   NodeC lnode[LABEL_CNT]= {
      (UBYTE*)"This ", (UBYTE*)"is ", (UBYTE*)"a ", (UBYTE*)"letter", (UBYTE*)"for", (UBYTE*)"you.",
      (UBYTE*)"Use the ", (UBYTE*)"Scroller gadget", (UBYTE*)"on the right", (UBYTE*)" to scroll ", (UBYTE*)"through ", (UBYTE*)" the entry list..",
      (UBYTE*)"Date 07/17/94", (UBYTE*)" by Armin Vogt", (UBYTE*)"You see a GT_Scroller ", (UBYTE*)"connected", (UBYTE*)"with a", (UBYTE*)"GT_Listview.",
      (UBYTE*)"This", (UBYTE*)"is", (UBYTE*)"only", (UBYTE*)"a simple example.", (UBYTE*)"But take a look", (UBYTE*)"at the code.."
      };
   /* IF YOU DO NOT CAST THE STRINGS INTO (UBYTE*), both SAS and GCC seem not to terminate,
    * at least with 6MB RAM!?
    */

   // add the created nodes to the ListC object
   for (int i=LABEL_CNT-1;i>=0; i--)
      labels.addHead(&lnode[i]);


   GT_Listview *listView = new GT_Listview(mainWindow,
   AttrList(   GOB_LeftFromLeftOfParent,     3,
               GOB_TopFromTopOfParent,       3,
               GOB_RightFromRightOfParent,   -40,
               GOB_BottomFromBottomOfParent, -3,
               GA_Immediate,  TRUE,
               GA_RelVerify,  TRUE,
               GTLV_Top,   1,                      // initialise with 1
               GTLV_Labels,         &labels,       // the ListC object is compatible to a List structure
               GTLV_ShowSelected,   NULL,
               LAYOUTA_Spacing,     2,
               TAG_END) );


   GT_Scroller *scroller = new GT_Scroller(mainWindow,
   AttrList(   GOB_LeftFromRightOfPred,   5,
               GOB_TopFromTopOfPred,      0,
               GOB_RightFromRightOfParent,-5,
               GOB_BottomFromBottomOfPred, 0,
/*      GA_Immediate,TRUE,*/
               GA_RelVerify,  TRUE,
               PGA_Freedom,   LORIENT_VERT,

               CONSTRAINT( GTSC_Top, listView, GTLV_Top),   // initialise with GTLV_Top (=1)
/* This constraint doesn't make sense since Listview does not report about scroll movements */

               GTSC_Total,    LABEL_CNT,
               GTSC_Visible,  1,
               GTSC_Arrows,   16,
               GT_IDCMP,      SLIDERIDCMP,
               TAG_END) );

   // GTLV_Top is initialised from GTSC_Top, which has been initialised from GTLV_Top before
   // ==> GTLV_Top remains 1
   listView->setAttributes(AttrList(CONSTRAINT(GTLV_Top,scroller,GTSC_Top),TAG_END));

   mainWindow->refreshGList();      // display objects

   /* As soon as the mainWindow deletes itself after having received CLASS_CLOSEWINDOW
    * the loop terminates since the Ok() check within APPOK(mainWindow) fails to be TRUE.
    */
   while (userBreak.hasNotOccured() && APPOK(mainWindow) && mainWindow->isNotClosed())
   {
      SignalResponder::WaitSignal();
   }

   puts("cleaned up. goodbye.\n");
}
