/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/ScreenC.cxx,v $
 **   $Revision: 1.6 $
 **   $Date: 1994/07/27 11:51:51 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/


extern "C" {
#ifdef __GNUG__
#include <inline/intuition.h>
#include <inline/gadtools.h>
#endif

#ifdef __SASC
#include <proto/intuition.h>
#include <proto/gadtools.h>
#endif
}
#include <APlusPlus/intuition/ScreenC.h>


static const char rcs_id[] = "$Id: ScreenC.cxx,v 1.6 1994/07/27 11:51:51 Armin_Vogt Exp Armin_Vogt $";

//runtime type inquiry support
intui_typeinfo(ScreenC, derived(from(GraphicObject)), rcs_id)


BOOL ScreenC::fillInfo()
   /* Gets the often used info data for the screen, DrawInfo and GadTools's VisualInfo.
      Returns TRUE for success.
   */
{
   drawInfo = GetScreenDrawInfo(screen());
   _dprintf("got DrawInfo.\n");
   visualInfo = GetVisualInfo(screen(),TAG_END);
   _dprintf("got VisualInfo.\n");
   return (drawInfo && visualInfo);
}

ScreenC::ScreenC(OWNER,AttrList& attrs) : GraphicObject((GraphicObject*)owner,attrs)
{
   lockOnPublic = FALSE;
   drawInfo = NULL;
   visualInfo = NULL;
   if (Ok())
   if (NULL != (screen_ref() = OpenScreenTagList(NULL,intuiAttrs()) ) )
   {
      if (fillInfo())
         setIOType(IOTYPE_SCREEN);
      else
         _ierror(SCREENC_NOINFO);
   }
   else _ierror(SCREENC_OPENSCREEN_FAILED);
}

ScreenC::ScreenC(IntuiObject *owner, UBYTE *screenTitle)
   : GraphicObject((GraphicObject*)owner,AttrList(NULL))
   /* Tries to get a lock on the public screen with the given screenTitle. Use NULL as STRPTR to
      get a lock on the default public screen.
      The established lock will last for the lifetime of the ScreenC object. So, release
      the lock in deleting the ScreenC object when you have no further use for it.
   */
{
   if (Ok())
   if ( NULL != (screen_ref() = LockPubScreen( (UBYTE*) screenTitle)) )
   {
      _dprintf("  screen locked.\n");
      if (fillInfo())
      {
         lockOnPublic = TRUE;
         _dprintf("  public screen locked. this = %lx\n",this);
         setIOType(IOTYPE_SCREEN);
         return;
      }
      else
         _ierror(SCREENC_NOINFO);

      UnlockPubScreen(NULL,screen());
   }
   else _ierror(SCREENC_PUBLICSCREEN_NOT_FOUND);
   drawInfo = NULL;
   visualInfo = NULL;
   lockOnPublic = FALSE;
}

ScreenC::~ScreenC()
   /* Unlock previously locked public screen, free DrawInfo and VisualInfo, and close screen.
      Public screens will resist being closed as long as they have windows opened.
   */
{
   if (drawInfo)  FreeScreenDrawInfo(screen(),drawInfo);
   if (visualInfo)  FreeVisualInfo(visualInfo);
   if (lockOnPublic)  UnlockPubScreen(NULL,screen());
   else CloseScreen(screen());
}

ULONG ScreenC::setAttributes(AttrList& attrs)
{
   return GraphicObject::setAttributes(attrs);
}

ULONG ScreenC::getAttribute(Tag attr,ULONG& dataStore)
{
   return GraphicObject::getAttribute(attr,dataStore);
}
struct DrawInfo *ScreenC::getScreenDrawInfo()
{
   return drawInfo;
}

APTR ScreenC::getVisualInfo()
{
   _dprintf("getVisualInfo from this=%lx\n",this);
   return visualInfo;
}
