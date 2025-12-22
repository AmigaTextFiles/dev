/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/GT_Listview.cxx,v $
 **   $Revision: 1.9 $
 **   $Date: 1994/07/27 11:48:45 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/


extern "C" {
#ifdef __GNUG__
#endif

#ifdef __SASC
#endif
}
#include <APlusPlus/gadtools/GT_Listview.h>
#include <APlusPlus/intuition/IntuiMessageC.h>


static const char rcs_id[] = "$Id: GT_Listview.cxx,v 1.9 1994/07/27 11:48:45 Armin_Vogt Exp Armin_Vogt $";

//runtime type inquiry support
intui_typeinfo(GT_Listview, derived(from(GT_Gadget)), rcs_id)


GT_Listview::GT_Listview(GOB_OWNER,AttrList& attrs)
   : GT_Gadget(gob_owner,LISTVIEW_KIND,attrs)
{
}

void GT_Listview::callback(const IntuiMessageC* imsg)
   /* Listview gadgets will send GADGETUP only for each user selection.
      The Code field will contain the selected field ordinal number.
   */
{
   // since GT_Gadget sets IDCMP to LISTVIEW_IDCMP per default,
   // also INTUITICKS, which hold no information in the Code field,will arive here!
   if (imsg->getClass()!=CLASS_INTUITICKS)
   {
      setAttrs( AttrList(GTLV_Top,(WORD)imsg->Code, GA_ID,gadgetPtr()->GadgetID, TAG_END) );
   }
}
