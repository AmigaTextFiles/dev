/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/Canvas.cxx,v $
 **   $Revision: 1.8 $
 **   $Date: 1994/07/27 11:47:47 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/


#include <APlusPlus/graphics/Canvas.h>
#include <APlusPlus/intuition/IntuiMessageC.h>


static const char rcs_id[] = "$Id: Canvas.cxx,v 1.8 1994/07/27 11:47:47 Armin_Vogt Exp Armin_Vogt $";

//runtime type inquiry support
intui_typeinfo(Canvas, derived(from(AutoDrawArea)), rcs_id)


#define VISIBLE_X (iWidth()/iGranularityX)
#define VISIBLE_Y (iHeight()/iGranularityY)
#define SCROLLWIDTH (iWidth()-(scrollGratX()==TRUE?(iWidth()%granularityX()):0))
#define SCROLLHEIGHT (iHeight()-(scrollGratY()==TRUE?(iHeight()%granularityY()):0))


Canvas::Canvas(GOB_OWNER,AttrList& attrs) : AutoDrawArea(gob_owner,attrs)
   /* Note that ViewX and ViewY values are only stored in the IntuiObject attributes.
      The relation is: xy_offset = xy_view * xy_granularity.
   */
{
   if (Ok())
   {
   _dprintf("Canvas::create()\n");
   xOffset = yOffset = 0;

   // read init values. If no were specified use default values.
   widthG  = (UWORD)intuiAttrs().getTagData(CNV_Width,iWidth());
   heightG = (UWORD)intuiAttrs().getTagData(CNV_Height,iHeight());
   iGranularityX = (UWORD)intuiAttrs().getTagData(CNV_GranularityX,1);
   iGranularityY = (UWORD)intuiAttrs().getTagData(CNV_GranularityY,1);
   iViewX = (UWORD)intuiAttrs().getTagData(CNV_ViewX);   if (iViewX >= widthG) iViewX = widthG;
   iViewY = (UWORD)intuiAttrs().getTagData(CNV_ViewY);   if (iViewY >= heightG) iViewY = heightG;
   scrollGratingX = (UBYTE)intuiAttrs().getTagData(CNV_ScrollGratX,FALSE);
   scrollGratingY = (UBYTE)intuiAttrs().getTagData(CNV_ScrollGratY,FALSE);
   iVisibleX = 0;
   iVisibleY = 0;

   setIOType(IOTYPE_CANVAS);
   }
}

Canvas::~Canvas()
{
}

APTR Canvas::redrawSelf(GWindow *home,ULONG& returnType)
   /* Computes CNV_VisibleX/Y values and propagates 'redrawSelf' request to base classes.
   */
{
   setAttrs( AttrList(CNV_VisibleX,iVisibleX=(UWORD)VISIBLE_X,
                      CNV_VisibleY,iVisibleY=(UWORD)VISIBLE_Y, TAG_END));
   return AutoDrawArea::redrawSelf(home,returnType);
}

ULONG Canvas::setAttributes(AttrList& attrs)
{
   if (notificationLoop()) return 0L;

   AttrManipulator next(attrs);
   while (next())
   {
      LONG data = next.data();
      switch (next.tag())
      {
         case CNV_ViewX : // gets data as amount of granularityX units
               {
                  if (data != iViewX && data >= 0 && data < widthG)
                  {
                     adjustStdClip();
                     setStdClip();
                     UWORD deltaViewX = (UWORD)abs((data-(LONG)viewX()));
                     UWORD org_iViewX = iViewX = (UWORD)data;
                     LONG deltaPix = (data*=iGranularityX)-xOffset;
                     xOffset = data;
                     if (deltaViewX < visibleX())
                     {
                        scrollRaster(deltaPix,0,0,0,SCROLLWIDTH-1,SCROLLHEIGHT-1);  // scroll the view rectangle
                        if (deltaPix > 0)    // scroll left, move right
                        {
                           XYVAL right = SCROLLWIDTH;
                           andRectRegion(right-deltaPix-1,0,right-1,iHeight()-1);
                           iViewX += visibleX()-deltaViewX;
                        }
                        else
                        {
                           andRectRegion(0,0,-deltaPix,iHeight()-1);
                        }
                     }
                     else
                     {
                        deltaViewX = visibleX();
                        AutoDrawArea::clear();    // clear draw area
                     }
                     UWORD org_iVisibleX = iVisibleX;
                     iVisibleX = deltaViewX;
                     drawSelf();
                     iViewX = org_iViewX;
                     iVisibleX = org_iVisibleX;
                     resetStdClip();
                  }
               }
               break;

         case CNV_ViewY :
               {
                  if (data != iViewY && data >= 0 && data < heightG)
                  {
                     adjustStdClip();
                     setStdClip();
                     UWORD deltaViewY = (UWORD)abs(data-(LONG)viewY());
                     UWORD org_iViewY = iViewY = (UWORD)data;
                     LONG deltaPix = (data*=iGranularityY)-yOffset;
                     yOffset = data;
                     if (deltaViewY < visibleY())
                     {
                        scrollRaster(0,deltaPix,0,0,SCROLLWIDTH-1,SCROLLHEIGHT-1);  // scroll the view rectangle
                        if (deltaPix > 0)
                        {
                           // the 'bottom' of the writeable drawing area
                           XYVAL bottom = SCROLLHEIGHT;
                           andRectRegion(0,bottom-deltaPix-1,iWidth()-1,bottom-1);
                           iViewY += visibleY()-deltaViewY;
                        }
                        else
                        {
                           andRectRegion(0,0,iWidth()-1,-deltaPix);
                        }
                     }
                     else
                     {
                        deltaViewY = visibleY();
                        AutoDrawArea::clear();    // clear draw area
                     }
                     UWORD org_iVisibleY = iVisibleY;
                     iVisibleY = deltaViewY;
                     drawSelf();
                     iViewY = org_iViewY;
                     iVisibleY = org_iVisibleY;
                     resetStdClip();
                  }
               }
               break;

         case CNV_Width  :
               next.writeData(widthG = (UWORD)((data > MAXPOT)?MAXPOT:data));
               break;

         case CNV_Height :
               next.writeData(heightG = (UWORD)((data > MAXPOT)?MAXPOT:data));
               break;

         case CNV_GranularityX :
               if (data==0) data = 1;
               iGranularityX = (UWORD)data;
               break;

         case CNV_GranularityY :
               if (data==0) data = 1;
               iGranularityY = (UWORD)data;
               break;

         case CNV_ScrollGratX :
               scrollGratingX = (UBYTE)data;
               break;

         case CNV_ScrollGratY :
               scrollGratingY = (UBYTE)data;
               break;

      }

      _dprintf("Canvas: y-offset=%ld\n",yOffset);
   }
   return AutoDrawArea::setAttributes(attrs);
}

ULONG Canvas::getAttribute(Tag tag,ULONG& dataStore)
{
   switch (tag)
   {
      case CNV_ViewX : return (dataStore=iViewX);
      case CNV_ViewY : return (dataStore=iViewY);
      case CNV_VisibleX : return (dataStore=iVisibleX);
      case CNV_VisibleY : return (dataStore=iVisibleY);
      case CNV_Width : return (dataStore=widthG);
      case CNV_Height : return (dataStore=heightG);
      case CNV_GranularityX : return (dataStore=iGranularityX);
      case CNV_GranularityY : return (dataStore=iGranularityY);
      case CNV_ScrollGratX : return (dataStore=scrollGratingX);
      case CNV_ScrollGratY : return (dataStore=scrollGratingY);

      default:
         return AutoDrawArea::getAttribute(tag,dataStore);
   }
}

void Canvas::callback(const IntuiMessageC *imsg)
{
   AutoDrawArea::callback(imsg);

   LONG m = ((LONG)imsg->MouseX + xOffset)/iGranularityX;
   iMouseX = (UWORD) (m<0?0:(m>=widthG?widthG-1:m));
   m = ((LONG)imsg->MouseY + yOffset)/iGranularityY;
   iMouseY = (UWORD) (m<0?0:(m>=heightG?heightG-1:m));
}
