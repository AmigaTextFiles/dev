/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/AutoDrawArea.cxx,v $
 **   $Revision: 1.12 $
 **   $Date: 1994/07/31 13:14:21 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/


#include <APlusPlus/environment/APPObject.h>
#include <APlusPlus/graphics/AutoDrawArea.h>
#include <APlusPlus/intuition/IntuiMessageC.h>
#include <APlusPlus/intuition/GWindow.h>


static const char rcs_id[] = "$Id: AutoDrawArea.cxx,v 1.12 1994/07/31 13:14:21 Armin_Vogt Exp Armin_Vogt $";

intui_typeinfo(AutoDrawArea, derived(from(StdGadget)), rcs_id)


AutoDrawArea::AutoDrawArea(GraphicObject *owner,AttrList& attrs)
   : StdGadget(owner,attrs)   // StdGadget defaults to a boolean gadget
{
   if (Ok())
   {
      GWindow* homeWindow;

      if (NULL != (homeWindow = getHomeWindow()) )
      {
         setGWindow(homeWindow);
         bgFillPen = 0;
         setIOType(IOTYPE_AUTODRAWAREA);
      }
      else _ierror(AUTODRAWAREA_HAS_NO_GWINDOW_ROOT);
   }
}

AutoDrawArea::~AutoDrawArea()
{
   // for future use
}

APTR AutoDrawArea::redrawSelf(GWindow *home,ULONG& returnType)
{
   _dprintf("AutoDrawArea::redrawSelf( )\n");

   APTR rv = StdGadget::redrawSelf(home,returnType);
   if (isValid())
   {
      adjustStdClip();
      setStdClip();
      clear();
      drawSelf();
      resetStdClip();
   }
   else puterr("AutoDrawArea::redrawSelf() : draw area not valid!\n");
   return rv;
}

ULONG AutoDrawArea::setAttributes(AttrList& attrs)
{
   return StdGadget::setAttributes(attrs);
}

ULONG AutoDrawArea::getAttribute(Tag tag,ULONG& dataStore)
{
   return StdGadget::getAttribute(tag,dataStore);
}

void AutoDrawArea::clear()
{
   setAPen(bgFillPen);
   setOPen(bgFillPen);
   setDrMd(JAM2);
   rectFill(0,0,iWidth(),iHeight());    // clear draw area
}

void AutoDrawArea::callback(const IntuiMessageC *imsg)
{
   // for all IDCMP events adjust the MouseX,MouseY values relative to the
   // AutoDrawArea view
   ((IntuiMessageC*)imsg)->MouseX -= iLeft();
   ((IntuiMessageC*)imsg)->MouseY -= iTop();
}
