/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/RectObject.cxx,v $
 **   $Revision: 1.4 $
 **   $Date: 1994/07/31 13:32:03 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/


#include <APlusPlus/environment/APPObject.h>
#include <APlusPlus/graphics/RectObject.h>


static const char rcs_id[] = "$Id: RectObject.cxx,v 1.4 1994/07/31 13:32:03 Armin_Vogt Exp Armin_Vogt $";


RectObject::RectObject()
{
   setRect(0,0,0,0);
   setBorders(0,0,0,0);
}

RectObject::RectObject(XYVAL minx,XYVAL miny,XYVAL maxx,XYVAL maxy)
{
   setRect(minx,miny,maxx,maxy);
}

RectObject::~RectObject()
{
}

void RectObject::setRect(XYVAL minx,XYVAL miny,XYVAL maxx,XYVAL maxy)
{
   MinX = minx; MinY = miny;
   MaxX = max(maxx,minx);
   MaxY = max(maxy,miny);
}
XYVAL RectObject::iLeft()
{
   return (MinX+leftBorder >= MaxX-rightBorder) ? MinX : MinX+leftBorder;
}
XYVAL RectObject::iTop()
{
   return (MinY+topBorder >= MaxY-bottomBorder) ? MinY : MinY+topBorder;
}
XYVAL RectObject::iRight()
{
   return (MinX+leftBorder >= MaxX-rightBorder) ? MaxX : MaxX-rightBorder;
}

XYVAL RectObject::iBottom()
{
   return (MinY+topBorder >= MaxY-bottomBorder) ? MaxY : MaxY-bottomBorder;
}

WHVAL RectObject::iWidth()
{
   if (iRight()>iLeft())
      return iRight()-iLeft()+1;
   else return 0;
}

WHVAL RectObject::iHeight()
{
   if (iBottom()>iTop())
      return iBottom()-iTop()+1;
   else return 0;
}
