/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/GadgetCV.cxx,v $
 **   $Revision: 1.9 $
 **   $Date: 1994/07/31 13:17:08 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/


extern "C" {
#ifdef __GNUG__
#include <inline/intuition.h>
#endif

#ifdef __SASC
#include <proto/intuition.h>
#endif
}
#include <APlusPlus/intuition/GadgetCV.h>
#include <APlusPlus/intuition/GWindow.h>
#include <APlusPlus/intuition/IntuiMessageC.h>


static const char rcs_id[] = "$Id: GadgetCV.cxx,v 1.9 1994/07/31 13:17:08 Armin_Vogt Exp Armin_Vogt $";


//runtime type inquiry support
intui_typeinfo(GadgetCV, derived(from(GraphicObject)), rcs_id)


GWindow* GadgetCV::redrawSelfHomeWindow = NULL;


GadgetCV::GadgetCV(GraphicObject* owner,AttrList& attrs)
   : GraphicObject(owner,attrs)
{
   // default settings for GadgetCV Attribute Tags
   applyDefaultAttrs( attrs,AttrList(
      GA_Immediate,  TRUE,
      GA_RelVerify,  TRUE,
      TAG_END) );
}

APTR GadgetCV::redrawSelf(GWindow* homeWindow,ULONG& returnType)
{
   return GraphicObject::redrawSelf(homeWindow,returnType);
}

ULONG GadgetCV::setAttributes(AttrList& attrs)
{
   return GraphicObject::setAttributes(attrs);
}

struct Gadget* GadgetCV::storeGadget(struct Gadget* gadget)
{
   IObject() = gadget;
   if (gadget) gadget->UserData = (APTR)this;
   return gadget;
}

struct Gadget* GadgetCV::getGT_Context()
{
   return getHomeWindow()->GT_last;
}

BOOL GadgetCV::forceActiveGadget(const IntuiMessageC* imsg)
{
   if (!(imsg->isFakeMsg()))
   {
      getHomeWindow()->activeGadget = this;
      return TRUE;
   }
   else return FALSE;
}

GWindow* GadgetCV::getHomeWindow()
{
   if (redrawSelfHomeWindow) return redrawSelfHomeWindow;
   else
   {
      GWindow* gwin;
      if (NULL != (gwin = findRootOfClass(GWindow)) )
         return gwin;
      else{ puterr("Fatal error: no gwindow root!\n"); return NULL; }
   }
}

ULONG GadgetCV::getAttribute(Tag tag,ULONG& dataStore)
{
   return GraphicObject::getAttribute(tag,dataStore);
}


