/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/BoopsiGadget.cxx,v $
 **   $Revision: 1.13 $
 **   $Date: 1994/08/02 17:48:52 $
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
#include <APlusPlus/intuition/BoopsiGadget.h>
#include <APlusPlus/intuition/IntuiMessageC.h>
#include <APlusPlus/intuition/GWindow.h>


static const char rcs_id[] = "$Id: BoopsiGadget.cxx,v 1.13 1994/08/02 17:48:52 Armin_Vogt Exp Armin_Vogt $";

//runtime type inquiry support
intui_typeinfo(BoopsiGadget, derived(from(GadgetCV)), rcs_id)


BoopsiGadget::BoopsiGadget(GraphicObject* owner,
                           UBYTE* pubClass,
                           AttrList& attrs) : GadgetCV(owner,attrs)
{
   create(NULL,pubClass,attrs);
}

BoopsiGadget::BoopsiGadget(GraphicObject* owner,
                           Class* privClass,
                           AttrList& attrs) : GadgetCV(owner,attrs)
{
   create(privClass,NULL,attrs);
}

void BoopsiGadget::create(Class* privClass,UBYTE* pubClass,const AttrList& attrs)
{
   if (Ok())
   {
      privateClass = privClass;
      publicClass  = pubClass;

      // add the tags that specify the dimensions to the Boopsigadget
      // and some default attributes..
      applyDefaultAttrs( attrs, AttrList(
         GA_Left,0, GA_Top,0, GA_Width,0, GA_Height,0,
         ICA_TARGET, ICTARGET_IDCMP,
         TAG_END));

      // make sure all events get 'heared'
      getHomeWindow()->modifyIDCMP(CLASS_IDCMPUPDATE|CLASS_GADGETDOWN|CLASS_GADGETUP);

      setIOType(IOTYPE_BOOPSIGADGET);
   }
   _dprintf("Boopsigadget %lx initialised. status = %s\n",(APTR)this,(Ok()?"OK":"ERROR") );
   _dprintf("status = %ld\n",status());
}


APTR BoopsiGadget::redrawSelf(GWindow* homeWindow,ULONG& returnType)
{
   _dprintf("Boopsigadget::redrawSelf()\n");

   GadgetCV::redrawSelf(homeWindow,returnType);

   // destroy old Boopsigadget
   if (gadgetPtr()!=NULL)
   {
      _dprintf("DisposeObject()\n");
      DisposeObject(gadgetPtr());
      _dprintf("\tdone\n");
   }

   // copy GraphicObject rectangle to gadget taglist
   intuiAttrs().updateAttrs(AttrList(GA_Left,iLeft(),GA_Top,iTop(),GA_Width,iWidth(),GA_Height,iHeight(),TAG_END));

   // create new Boopsigadget
   if ( storeGadget((struct Gadget*)NewObjectA(privateClass,publicClass,intuiAttrs()) ) )
   {
      gadgetPtr()->NextGadget = NULL; // important for AddGList() in GWindow::On_NEWSIZE()
      returnType = IOTYPE_BOOPSIGADGET;
   }
   else
   {
      returnType = NULL;
      _ierror(BOOPSIGADGET_NEWOBJECT_FAILED);
   }

   _dprintf("\tdone\n");
   return gadgetPtr();
}

void BoopsiGadget::callback(const IntuiMessageC* imsg)
   /* Boopsigadgets receive IDCMPUPDATE messages in case they have ICA_TARGET set to ICTARGET_IDCMP.
      Each IDCMPUPDATE message contains a taglist of changed attributes in the IAddress field.
      This taglist is used to change the IntuiObject attribute tags, spreading changes through the
      ITransponder in the process.
   */
{
   if (imsg && imsg->getIAddress())
   {
        _dprintf("BoopsiGadget::callback\n");

      switch(imsg->getClass())
      {
         case CLASS_IDCMPUPDATE :
            setAttrs( AttrList((struct TagItem*)imsg->getIAddress()) );
            break;
      }
   }
   else _dprintf("BoopsiGadget::callback() received imsg==null!!\n");
}

ULONG BoopsiGadget::setAttributes(AttrList& attrs)
{
   if (notificationLoop()) return 0L;

   _dprintf("BoopsiGadget(%lx)::setAttributes()\n",(APTR)this);

   if (gadgetPtr())
   {
      SetGadgetAttrsA(gadgetPtr(),(struct Window*)getHomeWindow()->windowPtr(),NULL,attrs);
   }

   return GadgetCV::setAttributes(attrs);
}

ULONG BoopsiGadget::getAttribute(Tag attrID,ULONG& dataStore)
   /* read a specific BOOPSI attribute. If the attribute is recognized by the BOOPSI object
      0L is being returned and dataStore is undefined, otherwise the attribute's value is
      stored in dataStore, a reference to a ULONG variable.
   */
{
   if (gadgetPtr() && GetAttr(attrID,gadgetPtr(),&dataStore))
      return dataStore;
   else
      return GadgetCV::getAttribute(attrID,dataStore);
}

BoopsiGadget::~BoopsiGadget()
   /* Dispose the Boopsi object.
   */
{
   _dprintf("BoopsiGadget::~\n");
   if (gadgetPtr()!=NULL)
   {  _dprintf("DisposeObject()\n");
      DisposeObject(gadgetPtr());
   }
   _dprintf("done\n");
}
