/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/IntuiMessageC.cxx,v $
 **   $Revision: 1.7 $
 **   $Date: 1994/07/27 11:49:12 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/


#include <APlusPlus/intuition/IntuiMessageC.h>
#include <APlusPlus/intuition/GadgetCV.h>
#include <APlusPlus/intuition/WindowCV.h>
#include <string.h>


static const char rcs_id[] = "$Id: IntuiMessageC.cxx,v 1.7 1994/07/27 11:49:12 Armin_Vogt Exp Armin_Vogt $";

//runtime type inquiry support
typeinfo(IntuiMessageC, no_bases, rcs_id)


IntuiMessageC::IntuiMessageC(IDCMPClass mclass)
{
   memset(this,0,sizeof(this));
   Class = mclass;
}

WindowCV *IntuiMessageC::decodeWindowCV() const
{
   // test window ptr in WindowCV object against the received message IDCMPWindow
   WindowCV *winC;
   if (IDCMPWindow)
      if (NULL != (winC = (WindowCV*)IDCMPWindow->UserData) )
         if (winC->window() == IDCMPWindow) return winC;

   return NULL;
}

GadgetCV *IntuiMessageC::decodeGadgetCV() const
   /* Gets the sending Gadget object from a received message.
      BE AWARE of the fact that, except for GadTools, all gadgets only supply a reference to
      themselves in ONLY the GADGETDOWN/GADGETUP message's IAddress field!
      GadTools gadgets also supply the gadget address for MOUSEMOVE messages.
      Therefore calling decodeGadgetCV() on a different IntuiMessage will return NULL.
      THIS METHOD IS SAFE TO BE CALLED ON EVERY INTUIMESSAGE CLASS.
      Every GadgetCV derived object stores the address of itself into the encapsulated
      Gadget structure. This makes it easy and fast to get the corresponding GadgetCV
      object to an incoming Gadget IntuiMessage.
   */
{
   GadgetCV *gadgetCV;
   if (getClass() & (CLASS_GADGETDOWN|CLASS_GADGETUP|CLASS_MOUSEMOVE))
      // IDCMPUPDATE messages hold a taglist in IAddress!!
   {
      struct Gadget *gadget;
      if (NULL != (gadget = (struct Gadget*)getIAddress()) )

   /* ENFORCER HITS!! If the presumptive gadget is NO gadget, assuming this unknown address
   ** points to a gadget and further dereferencing UserData to a Gadget object will probably
   ** lead to bus errors!!!
   */
         if (NULL != (gadgetCV = (GadgetCV*)(gadget->UserData)))
            if (gadgetCV->object() == gadget) return gadgetCV;
            else _dprintf(" IntuiMessageC::decodeGadgetCV(): GadgetCV in IAddress INVALID!\n");

      _dprintf(" IntuiMessageC::decodeGadgetCV(): no GadgetCV in IAddress.\n");
   }
   else _dprintf(" IntuiMessageC::decodeGadgetCV(): IDCMPUPDATE\n");
   return NULL;
}

BOOL IntuiMessageC::isFakeMsg() const
{
   if (*(ULONG*)((IntuiMessage*)this) == 0L)
      return TRUE;
   else
      return FALSE;
}
