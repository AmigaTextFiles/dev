/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/ITransponder.cxx,v $
 **   $Revision: 1.7 $
 **   $Date: 1994/07/27 11:50:43 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/


#include <APlusPlus/intuition/ITransponder.h>
#include <APlusPlus/intuition/IntuiObject.h>


static const char rcs_id[] = "$Id: ITransponder.cxx,v 1.7 1994/07/27 11:50:43 Armin_Vogt Exp Armin_Vogt $";

//runtime type inquiry support
typeinfo(ITransponder, no_bases, rcs_id)


void ITransponder::setReceiver(IntuiObject *newReceiver)
{
   receiver1 = newReceiver;
}

MapITP::MapITP(IntuiObject *iob,AttrList& mapAttrs)
   : ITransponder(iob), mapAttrlist(mapAttrs)
{
}

void MapITP::sendNotification(AttrList& attrs)
{
   attrs.mapAttrs(mapAttrlist);
   if (receiver1)
   {
      receiver1->setAttributes(attrs);
   }
}
