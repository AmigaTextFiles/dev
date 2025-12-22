/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/StdGadget.cxx,v $
 **   $Revision: 1.6 $
 **   $Date: 1994/07/27 11:52:03 $
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

#include <intuition/intuition.h>
}
#include <APlusPlus/intuition/StdGadget.h>


static const char rcs_id[] = "$Id: StdGadget.cxx,v 1.6 1994/07/27 11:52:03 Armin_Vogt Exp Armin_Vogt $";

//runtime type inquiry support
intui_typeinfo(StdGadget, derived(from(GadgetCV)), rcs_id)


StdGadget::StdGadget(GOB_OWNER, UWORD flags,UWORD activation,UWORD gadgetType,
                        APTR gadgetRender,APTR selectRender,struct IntuiText *gadgetText,
                        LONG mutualExclude,APTR specialInfo,UWORD gadgetID,AttrList& attrs)
   : GadgetCV(gob_owner,attrs)
{
   gadget.Flags      = flags;
   gadget.Activation = activation;
   gadget.GadgetType = gadgetType;
   gadget.GadgetRender  = gadgetRender;
   gadget.SelectRender  = selectRender;
   gadget.GadgetText    = gadgetText;
   gadget.MutualExclude = mutualExclude;
   gadget.SpecialInfo   = specialInfo;
   gadget.GadgetID      = gadgetID;

   storeGadget(&gadget);

   setIOType(IOTYPE_STDGADGET);
}

StdGadget::StdGadget(GOB_OWNER, AttrList& attrs) : GadgetCV(gob_owner,attrs)
{
   gadget.Flags      = (UWORD)attrs.getTagData( SGA_Flags, GFLG_GADGHNONE);
   gadget.Activation = (UWORD)attrs.getTagData( SGA_Activation, GACT_IMMEDIATE|GACT_RELVERIFY);
   gadget.GadgetType = (UWORD)attrs.getTagData( SGA_GadgetType, GTYP_BOOLGADGET);
   gadget.GadgetRender  = (APTR)attrs.getTagData( SGA_GadgetRender, NULL);
   gadget.SelectRender  = (APTR)attrs.getTagData( SGA_SelectRender, NULL);
   gadget.GadgetText    = (struct IntuiText*)attrs.getTagData( GA_Text, NULL);
   gadget.MutualExclude = attrs.getTagData( SGA_MutualExclude, 0);
   gadget.SpecialInfo   = (APTR)attrs.getTagData( SGA_SpecialInfo, NULL);
   gadget.GadgetID      = (UWORD)attrs.getTagData( GA_ID, 0);

   storeGadget(&gadget);

   setIOType(IOTYPE_STDGADGET);
}


APTR StdGadget::redrawSelf(GWindow *homeWindow,ULONG& returnType)
{
   gadget.LeftEdge   = (WORD)iLeft();
   gadget.TopEdge    = (WORD)iTop();
   gadget.Width      = (WORD) iWidth();
   gadget.Height     = (WORD)iHeight();

   gadget.NextGadget = NULL;     // clear the link

   GadgetCV::redrawSelf(homeWindow,returnType);

   returnType = IOTYPE_STDGADGET;
   return gadgetPtr();
}

ULONG StdGadget::setAttributes(AttrList& attrs)
{
   return GadgetCV::setAttributes(attrs);
}

ULONG StdGadget::getAttribute(Tag tag,ULONG& dataStore)
{
   return GadgetCV::getAttribute(tag,dataStore);
}
