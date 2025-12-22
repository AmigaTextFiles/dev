/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/GT_Boolean.cxx,v $
 **   $Revision: 1.7 $
 **   $Date: 1994/07/27 11:48:31 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/

extern "C" {
#ifdef __GNUG__
#endif

#ifdef __SASC
#endif
}

#include <APlusPlus/gadtools/GT_Boolean.h>
#include <APlusPlus/intuition/IntuiMessageC.h>


static const char rcs_id[] = "$Id: GT_Boolean.cxx,v 1.7 1994/07/27 11:48:31 Armin_Vogt Exp Armin_Vogt $";

//runtime type inquiry support
intui_typeinfo(GT_Boolean, derived(from(GT_Gadget)), rcs_id)


GT_Boolean::GT_Boolean(GOB_OWNER,AttrList& attrs)
   : GT_Gadget(gob_owner,BUTTON_KIND,attrs)
{
}

void GT_Boolean::callback(const IntuiMessageC* imsg)
{
   // when the user selects the button the GA_ID attribute tag is touched to
   // cause a notification stream composed of GA_ID,<this_ID>.
   // GA_ID is set by the class user on the constructor Attribute Taglist.
   if (imsg->getClass()==CLASS_GADGETUP)
   {
      setAttrs( AttrList(GA_ID,intuiAttrs().getTagData(GA_ID,4711),TAG_END) );
   }
}
