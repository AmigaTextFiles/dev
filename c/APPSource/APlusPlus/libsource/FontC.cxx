/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/FontC.cxx,v $
 **   $Revision: 1.8 $
 **   $Date: 1994/07/31 13:16:54 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/


extern "C" {
#ifdef __GNUG__
#include <dos/dos.h>
#include <inline/diskfont.h>
#include <inline/graphics.h>
#endif

#ifdef __SASC
#include <proto/diskfont.h>
#include <proto/graphics.h>
#endif
}

#include <APlusPlus/intuition/IntuiRoot.h>
#include <APlusPlus/graphics/FontC.h>


static const char rcs_id[] = "$Id: FontC.cxx,v 1.8 1994/07/31 13:16:54 Armin_Vogt Exp Armin_Vogt $";


void FontC::create(UBYTE *fontName,UWORD ySize,UBYTE style,UBYTE flags)
{
   struct TextAttr ta = { (STRPTR)fontName,ySize,style,flags };
   if (fontName==NULL) ta.ta_Name = IntuiRoot::getRootScreen()->screenPtr()->Font->ta_Name;
   if (ySize==0) ta.ta_YSize = IntuiRoot::getRootScreen()->screenPtr()->Font->ta_YSize;
   font = OpenDiskFont(&ta);
}

FontC::FontC(UBYTE *fontName,UWORD ySize,UBYTE style,UBYTE flags)
{
   create(fontName,ySize,style,flags);
}

FontC::FontC(struct TextAttr *ta)
{
   font = OpenDiskFont(ta);
}

FontC::FontC(struct TextFont *tf)
{
   create((UBYTE*)tf->tf_Message.mn_Node.ln_Name,tf->tf_YSize,tf->tf_Style,tf->tf_Flags);
}
void FontC::copy(const FontC& from)
{
   create((UBYTE*)from.font->tf_Message.mn_Node.ln_Name,from.font->tf_YSize,from.font->tf_Style,from.font->tf_Flags);
}

FontC::FontC(const FontC& from)
{
   copy(from);
}

FontC& FontC::operator = (const FontC& from)
{
   if (this!=&from)
   {
      copy(from);
   }
   return *this;
}

FontC::operator const struct TextAttr * () const
{
   static struct TextAttr ta = {
         (STRPTR)font->tf_Message.mn_Node.ln_Name,
         font->tf_YSize,
         font->tf_Style,
         font->tf_Flags    };
   return &ta;
}

FontC::~FontC()
{
   CloseFont(font);
}
