/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/GWindow.cxx,v $
 **   $Revision: 1.12 $
 **   $Date: 1994/08/02 17:51:53 $
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
#include <APlusPlus/intuition/GWindow.h>
#include <APlusPlus/intuition/GadgetCV.h>
#include <APlusPlus/intuition/IntuiMessageC.h>


static const char rcs_id[] = "$Id: GWindow.cxx,v 1.12 1994/08/02 17:51:53 Armin_Vogt Exp Armin_Vogt $";


// runtime type inquiry support
intui_typeinfo(GWindow, derived(from(WindowCV)), rcs_id)


/*************************************************************************************************
      GWindow methods
 *************************************************************************************************/
#include <graphics/GfxBase.h>
extern struct GfxBase* GfxBase;

GWindow::GWindow(IntuiObject* owner,AttrList& attrs)
   : WindowCV(owner,attrs), DrawArea(this),
     screenFont(windowPtr()->WScreen->Font), defaultFont(GfxBase->DefaultFont)
{
   if (!Ok()) return;   // WindowCV creation failed

   setIOType(IOTYPE_GWINDOW);

   activeGadget = defaultGadget = NULL;
   firstUserGad = GT_context = GT_last = NULL;
   modifyIDCMP(CLASS_GADGETDOWN|CLASS_GADGETUP|CLASS_NEWSIZE|CLASS_CLOSEWINDOW
      |CLASS_SIZEVERIFY//|CLASS_REFRESHWINDOW
      |CLASS_IDCMPUPDATE|CLASS_MOUSEMOVE);
   _dprintf("GWindow:create() done.\n");
}

GWindow::~GWindow()
{
   RemoveGList(window(),firstUserGad,-1);  // remove the entire user gadget list from the window

   FreeGadgets(GT_context);        // free GadTools gadgets
   _dprintf("~GWindow\n");
}

void GWindow::handleIntuiMsg(const IntuiMessageC* imsg)
{
   switch (imsg->getClass())
   {
      case CLASS_GADGETDOWN :
         GWindow::On_GADGETDOWN(imsg);
         break;
      case CLASS_GADGETUP :
         GWindow::On_GADGETUP(imsg);
         break;
      case CLASS_SIZEVERIFY:
         GWindow::On_SIZEVERIFY(imsg);
         break;
      case CLASS_NEWSIZE :
         GWindow::On_NEWSIZE(imsg);
         break;
      case CLASS_REFRESHWINDOW :
         GWindow::On_REFRESHWINDOW(imsg);
         break;

      default :
      /* All messages except GADGETUP and GADGETDOWN run towards the Active Gadget.
       * If there is no gadget active, the default will be used. If there is no
       * default, nothing will happen, the message will be replied without further
       * consideration.
       */
      {
         _dprintf("default_IMsgCallback()..\n");

         GadgetCV* gadObj;

         // try to get the sending object: this is only possible with GadTools gadgets.
         if (NULL != (gadObj = imsg->decodeGadgetCV()))
         {
            activeGadget = gadObj;
            gadObj->callback(imsg);
         }
         else  // ATTENTION! : active or default gadget may have been deleted
            if (APPOK(activeGadget)) activeGadget->callback(imsg);
               else { activeGadget = NULL; if (APPOK(defaultGadget)) defaultGadget->callback(imsg);
                  else defaultGadget = NULL; }
      }
      break;
   }
}

void GWindow::On_GADGETDOWN(const IntuiMessageC* imsg)
   /* Is invoked on every GADGTEDOWN message from the window's IDCMP.
      GADGETDOWN is ALWAYS triggered by a gadget and can be classed with one definite
      GadgetCV-derived object.
   */
{
   GadgetCV* gadObj;
   if (NULL != (gadObj = imsg->decodeGadgetCV()))
   {
      if (activeGadget && activeGadget != gadObj)  // Active Gadget changes
      {
         defaultGadget = activeGadget;    // default gadget will become active after active has resigned
         IntuiMessageC tmp(CLASS_GADGETUP);
         defaultGadget->callback(&tmp);
      }
      activeGadget = gadObj;           // become last active gadget
      _dprintf("active gadget status=%ld\n",gadObj->status());
      gadObj->callback(imsg);          // deliver message to the gadget
   }
}

void GWindow::On_GADGETUP(const IntuiMessageC* imsg)
   /* Is invoked on every GADGETUP message from the window's IDCMP.
      GADGETUP is ALWAYS triggered by a gadget and can be classed with one definite
      GadgetCV-derived object.
   */
{
   GadgetCV* gadObj;
   if (NULL != (gadObj = imsg->decodeGadgetCV()))
   {
      activeGadget = defaultGadget;    // previously active gadget becomes active again
      gadObj->callback(imsg);          // 'gadObj' may force staying the active gadget here
      if (activeGadget)
         if (gadObj != activeGadget)      // if active switched to default tell default about it with GADGETDOWN
         {
            IntuiMessageC tmp(CLASS_GADGETDOWN);
            activeGadget->callback(&tmp);
         }
         else defaultGadget = NULL;
   }
}

void GWindow::setActiveGadget(GadgetCV* newActive)
{
   activeGadget = newActive;
}

void GWindow::On_SIZEVERIFY(const IntuiMessageC* imsg)
{
   _dprintf("GWindow::On_SIZEVERIFY\n");
   RemoveGList(window(),firstUserGad,-1);  // remove the entire user gadget list from the window
   firstUserGad = NULL;
   // removing all gadgets here prevents them from being refreshed after window resizing.
}

void GWindow::On_NEWSIZE(const IntuiMessageC* imsg)
   /* Build up the window display: collect all gadgets from childs and 'send' redrawSelf
      messages to them after having them resized.
   */
{
   WindowCV::newsize(imsg);

   RemoveGList(window(),firstUserGad,-1);  // remove the entire user gadget list from the window
   firstUserGad = NULL;          // pointer to the begin of the list of user defined gadgets

   // set clipping to inner window box 
   clearRegion();
   orRectRegion(-leftB(),-topB(),iWidth()+rightB()-1,iHeight()+bottomB()-1);  
   setStdClip();
   
   // clear the inner window box
   setAPen(0);setOPen(0);setDrMd(JAM2);
   rectFill(-leftB(),-topB(),iWidth()+rightB()-1,iHeight()+bottomB()-1);   
   
   struct Gadget* old_GT_context = GT_context;
   // save old context (with all GadTools gadgets) for later freeing

   if (!CreateContext(&GT_context)) { _ierror(OUT_OF_MEMORY); return; }

   GT_last = GT_context;   // initialise the list of GadTools gadgets.

   _dprintf("adjust child..\n");
   adjustChilds();
   _dprintf("done\n");

   ULONG type;    // reference argument for redrawSelf gets the return type of redrawSelf.
   GadgetCV::redrawSelfHomeWindow = this;
   GraphicObject::redrawSelf(this,type);  // redraw the window i.e. draw border

   adjustStdClip();  // confine clipping to inner GraphicObject dimensions
   
   IOBrowser iobjs(this);

   struct Gadget* gadgets;
   GraphicObject* gob;
   
   while (NULL != (gob = (GraphicObject*)iobjs.getNext(class_type_id(GadgetCV))) )
   {
      _dprintf("got one GadgetCV object.\n");
      if (NULL != (gadgets = (struct Gadget*)gob->redrawSelf(this,type)))
         if (type == IOTYPE_GTGADGET) // GT gadgets are linked seperately.
         {
            /** GadTools gadgets are a linked list of gadgets,
             ** the last gadget is returned by CreateGadget() and subsequently by redrawSelf().
             **/
            GT_last = gadgets;      // trace the end of the GadTools gadgets list.
            if (GT_last) GT_last->NextGadget = NULL;   // make it safe
            _dprintf("GT gadget found\n");
         }
         else if (type == IOTYPE_BOOPSIGADGET || type == IOTYPE_STDGADGET)
         {
            if (firstUserGad==NULL) firstUserGad = gadgets;
            if (gadgets)
               AddGList(window(),gadgets,(UWORD)-1,(UWORD)-1,NULL);
               // add the resized gadget(s) to the window
            _dprintf("Non GT gadget at %lx found\n",gadgets);
         }
   }
   GadgetCV::redrawSelfHomeWindow = NULL;

   FreeGadgets(old_GT_context);
   // free all GadTools gadgets. They shall have been recreated in resizeSelf().

   // now GT_context points to the head of the separately collected GadTools gadgets.
   if (!firstUserGad)
      firstUserGad = GT_context; // no other than GadTools gadgets created.

   AddGList(window(),GT_context,(UWORD)-1,(UWORD)-1,NULL); // append GadTools gadgets at the end
      _dprintf("AddGList done\n");
   RefreshGadgets(firstUserGad,window(),NULL);
      _dprintf("RefreshGadgets done\n");
   GT_RefreshWindow(window(),NULL);
      _dprintf("everything FINE.\n");
   _dprintf("NEWSIZE done.\n");
}

void GWindow::On_REFRESHWINDOW(const IntuiMessageC* imsg)
   /* The minimal refresh routine for GadTools contains the activation of the
      Intuition-intern refreshing.
   */
{
   GT_BeginRefresh(window());
   GT_EndRefresh(window(),TRUE);
}
