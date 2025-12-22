/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/GT_String.cxx,v $
 **   $Revision: 1.12 $
 **   $Date: 1994/07/27 11:48:57 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/


extern "C" {
#ifdef __GNUG__
#endif

#ifdef __SASC
#endif
}
#include <APlusPlus/gadtools/GT_String.h>
#include <APlusPlus/intuition/IntuiMessageC.h>


static const char rcs_id[] = "$Id: GT_String.cxx,v 1.12 1994/07/27 11:48:57 Armin_Vogt Exp Armin_Vogt $";

//runtime type inquiry support
intui_typeinfo(GT_String, derived(from(GT_Gadget)), rcs_id)


GT_String::GT_String(GOB_OWNER,AttrList& attrs)
   : GT_Gadget(gob_owner,STRING_KIND,attrs)
{
   
}

void GT_String::callback(const IntuiMessageC* imsg)
   /* String gadgets will send GADGETUP for each RETURN,HELP and TAB.
   */
{
   if (imsg->getClass()==CLASS_GADGETUP)
   {
         setAttrs( AttrList(GTST_String,((struct StringInfo*)gadgetPtr()->SpecialInfo)->Buffer,
                     GA_ID,gadgetPtr()->GadgetID, TAG_END) );
   }
}

ULONG GT_String::getAttribute(Tag tag,ULONG& dataStore)
{
   if (gadgetPtr())
   {
      switch (tag)
      {
         case GTST_String : return (dataStore=(ULONG)((struct StringInfo*)gadgetPtr()->SpecialInfo)->Buffer);
         default : return GT_Gadget::getAttribute(tag,dataStore);
      }
   }
   else return GT_Gadget::getAttribute(tag,dataStore);
}

APTR GT_String::redrawSelf(GWindow *homeWindow,ULONG& returnType)
{
   if (gadgetPtr())
   {
      ULONG dummy;
      intuiAttrs().updateAttrs( AttrList(GTST_String,getAttribute(GTST_String,dummy),TAG_END) );
      // before the GT-string gadget is being deleted the edit buffer address needs to be copied
      // to gadget that will be created in GT_Gadget::redrawSelf(). There, a new edit buffer is
      // allocated and the old one's contents are copied to it.
      // The old gadget will be deleted after this method has returned.
      // AttrList::update() is used since no notification shall be triggered.
   }
   return GT_Gadget::redrawSelf(homeWindow,returnType);
}
