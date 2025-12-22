/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/DrawArea.cxx,v $
 **   $Revision: 1.12 $
 **   $Date: 1994/07/31 13:16:16 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/


extern "C" {
#ifdef __GNUG__
#include <inline/graphics.h>
#include <inline/layers.h>
#include <inline/gadtools.h>
#endif

#ifdef __SASC
#include <proto/graphics.h>
#include <proto/layers.h>
#include <proto/gadtools.h>
#endif
#include <string.h>
#include <libraries/gadtools.h>
}

#include <APlusPlus/graphics/DrawArea.h>
#include <APlusPlus/intuition/GWindow.h>
#include <APlusPlus/intuition/ScreenC.h>
#include <APlusPlus/graphics/FontC.h>


static const char rcs_id[] = "$Id: DrawArea.cxx,v 1.12 1994/07/31 13:16:16 Armin_Vogt Exp Armin_Vogt $";


DrawArea::DrawArea(GWindow* homeWindow)
{
   ownClippingInstalled = FALSE;
   oldRegion = NULL;
   regionPtr = NewRegion();
   setGWindow(homeWindow); // initialise rastPort
}

void DrawArea::setGWindow(GWindow* homeWindow)
{
   gWindowPtr = homeWindow;
   if (homeWindow)   rastPort = gwindow()->windowPtr()->RPort;
   else rastPort = NULL;
}

DrawArea::~DrawArea()
{
   if (isValid())
   {
      DisposeRegion(regionPtr);
      regionPtr = NULL;
   }
}


/********************* RastPort draw routines *******************************************/


void DrawArea::setAPen(UBYTE pen)
{
   SetAPen(rp(),pen);
}
void DrawArea::setBPen(UBYTE pen)
{
   SetBPen(rp(),pen);
}
void DrawArea::setDrMd(UBYTE mode)
{
   SetDrMd(rp(),mode);
}

void DrawArea::polyDraw(LONG count,WORD* polyTable)
{
   WORD* pt      = polyTable;
   WORD* const p = new WORD[count*2];
   WORD* pp      = p;

   for (LONG i=count; i>0; i--) { *pp++=(WORD)abs_X(*pt++); *pp++= (WORD)abs_Y(*pt++); }
   Move(rp(),*p,*(p+1));
   PolyDraw(rp(),count,p);
   delete [] p;
}

void DrawArea::rectFill(XYVAL xmin,XYVAL ymin,XYVAL xmax,XYVAL ymax)
{
   xmax = abs_X(xmax);
   ymax = abs_Y(ymax);

   if (xmin<xmax && ymin<ymax)   // negative width/height causes GURU MEDITATION!
      RectFill(rp(),abs_X(xmin),abs_Y(ymin),xmax,ymax);
}

void DrawArea::scrollRaster(LONG dx,LONG dy,XYVAL xmin,XYVAL ymin,XYVAL xmax,XYVAL ymax)
{
   xmax = abs_X(xmax);
   ymax = abs_Y(ymax);

   if (xmin<xmax && ymin<ymax)
      ScrollRaster(rp(),dx,dy,abs_X(xmin),abs_Y(ymin),xmax,ymax);
}

void DrawArea::move(XYVAL x,XYVAL y)
{
   Move(rp(),abs_X(x),abs_Y(y));
}
void DrawArea::moveTx(XYVAL x,XYVAL y)
{
   Move(rp(),abs_X(x),abs_Y(y)+rp()->Font->tf_Baseline);
}

void DrawArea::draw(XYVAL x,XYVAL y)
{
   Draw(rp(),abs_X(x),abs_Y(y));
}

void DrawArea::drawBevelBox(XYVAL xmin,XYVAL ymin,WHVAL width,WHVAL height,BOOL recessed)
{
   /* The taglist usage of DrawBevelBox is a bit weird since the GTBB_Recessed tag only
      needs to be present (regardless of the data value) to get a recessed box,
      while the box is drawn raised just when the GTBB_Recessed tag is totally missing!
   */
   struct TagItem tags[] = {  GT_VisualInfo,(LONG)gwindow()->screenC()->getVisualInfo(),
                              GTBB_Recessed,TRUE,
                              TAG_END};
   if (recessed==FALSE) tags[1].ti_Tag = TAG_END;

   DrawBevelBoxA(rp(),abs_X(xmin),abs_Y(ymin),width,height,&tags[0]);
}

void DrawArea::drawEllipse(XYVAL x,XYVAL y,WHVAL hr,WHVAL vr)
{
   DrawEllipse(rp(),abs_X(x),abs_Y(y),hr,vr);
}

void DrawArea::setFont(FontC& font)
{
   SetFont(rp(),(struct TextFont*)font);
}

void DrawArea::text(UBYTE* textString,UWORD textLength)
{
   if (textLength==0) textLength = (UWORD)strlen((const char*)textString);
   Text(rp(),(STRPTR)textString,textLength);
}


/*********************** Clipping region routines ***************************************/


void DrawArea::adjustStdClip()
   /* set the clipping rectangle to the dimensions present in the RectObject.
   */
{
   if (isValid())
   {
      if (ownClippingInstalled)    // clip already installed
         InstallClipRegion(layer(),NULL);

      clearRegion();    // free the memory of the rectangles incorporated in the ClipRegion's region.
      orRectRegion(0,0,iWidth()-1,iHeight()-1);   // permit drawing within the RectObject.

      if (ownClippingInstalled)    // clip already installed
         InstallClipRegion(layer(),region());
   }
}

void DrawArea::resetStdClip()
{
   if (isValid())
      InstallClipRegion(layer(),oldRegion);
   oldRegion = NULL; ownClippingInstalled = FALSE;
}

void DrawArea::setStdClip()
{
   if (isValid())
      if (ownClippingInstalled==FALSE)
         oldRegion = InstallClipRegion(layer(),region());
}

void DrawArea::setRectangle(XYVAL minX,XYVAL minY,XYVAL maxX,XYVAL maxY,struct Rectangle& rect)
   /* transform RectObject relative dimensions into RastPort absolute coords
      and store them into the referenced Rectangle structure.
   */
{
   rect.MinX = (WORD)abs_X(minX);
   rect.MinY = (WORD)abs_Y(minY);
   rect.MaxX = (WORD)abs_X(maxX);
   rect.MaxY = (WORD)abs_Y(maxY);
}

void DrawArea::removeClip()
{
   if (ownClippingInstalled)
   {
      InstallClipRegion(layer(),NULL);
   }
}

void DrawArea::insertClip()
{
   if (ownClippingInstalled)
   {
      InstallClipRegion(layer(),region());
   }
}

void DrawArea::andRectRegion(XYVAL minX,XYVAL minY,XYVAL maxX,XYVAL maxY)
{
   if (isValid())
   {
   struct Rectangle rect;
   setRectangle(minX,minY,maxX,maxY,rect);
   removeClip();
   AndRectRegion(region(),&rect);
   insertClip();
   }
}
void DrawArea::orRectRegion(XYVAL minX,XYVAL minY,XYVAL maxX,XYVAL maxY)
{
   if (isValid())
   {
   struct Rectangle rect;
   setRectangle(minX,minY,maxX,maxY,rect);
   removeClip();
   OrRectRegion(region(),&rect);
   insertClip();
   }
}
void DrawArea::xorRectRegion(XYVAL minX,XYVAL minY,XYVAL maxX,XYVAL maxY)
{
   if (isValid())
   {
   struct Rectangle rect;
   setRectangle(minX,minY,maxX,maxY,rect);
   removeClip();
   XorRectRegion(region(),&rect);
   insertClip();
   }
}
void DrawArea::clearRectRegion(XYVAL minX,XYVAL minY,XYVAL maxX,XYVAL maxY)
{
   if (isValid())
   {
   struct Rectangle rect;
   setRectangle(minX,minY,maxX,maxY,rect);
   removeClip();
   ClearRectRegion(region(),&rect);
   insertClip();
   }
}

void DrawArea::clearRegion()
{
   if (isValid())
   {
   removeClip();
   ClearRegion(region());
   insertClip();
   }
}
