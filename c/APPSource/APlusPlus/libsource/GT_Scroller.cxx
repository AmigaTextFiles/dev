/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/GT_Scroller.cxx,v $
 **   $Revision: 1.9 $
 **   $Date: 1994/07/27 11:48:51 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/


extern "C" {
#ifdef __GNUG__
#endif

#ifdef __SASC
#endif
}
#include <APlusPlus/gadtools/GT_Scroller.h>
#include <APlusPlus/intuition/IntuiMessageC.h>


static const char rcs_id[] = "$Id: GT_Scroller.cxx,v 1.9 1994/07/27 11:48:51 Armin_Vogt Exp Armin_Vogt $";

//runtime type inquiry support
intui_typeinfo(GT_Scroller, derived(from(GT_Gadget)), rcs_id)


GT_Scroller::GT_Scroller(GraphicObject* owner,AttrList& attrs)
   : GT_Gadget(owner,SCROLLER_KIND,attrs)
{
}

void GT_Scroller::callback(const IntuiMessageC* imsg)
   /* Scroller gadgets may send GADGETUP,GADGETDOWN and MOUSEMOVE. For all of these messages
      the Code field will contain the new Top value.
   */
{
   // since GT_Gadget sets IDCMP to LISTVIEW_IDCMP per default,
   // also INTUITICKS, which hold no information in the Code field,will arive here!
   if (imsg->getClass()!=CLASS_INTUITICKS)
   {
      setAttrs( AttrList(GTSC_Top,(WORD)imsg->Code, GA_ID,gadgetPtr()->GadgetID, TAG_END) );
   }
}
