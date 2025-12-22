/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/GBorder.cxx,v $
 **   $Revision: 1.13 $
 **   $Date: 1994/07/31 13:18:20 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/


extern "C" {
#ifdef __GNUG__
#include <inline/graphics.h>
#endif

#ifdef __SASC
#include <proto/graphics.h>
#endif
#include <string.h>
}

#include <APlusPlus/graphics/GBorder.h>
#include <APlusPlus/graphics/GraphicObject.h>
#include <APlusPlus/intuition/GWindow.h>


static const char rcs_id[] = "$Id: GBorder.cxx,v 1.13 1994/07/31 13:18:20 Armin_Vogt Exp Armin_Vogt $";


GBorder::~GBorder()
{
}

void GBorder::drawBorder(GraphicObject *graphicObj,GWindow *homeWindow)
{
   ULONG bgCol;
   if (graphicObj->getAttribute(GOB_BackgroundColor,bgCol))
   {
      homeWindow->setAPen(bgCol);
      homeWindow->setOPen(bgCol);
      homeWindow->setDrMd(JAM1);
      homeWindow->rectFill(NORM_X(graphicObj->left()), NORM_Y(graphicObj->top()),
                           NORM_X(graphicObj->right()), NORM_Y(graphicObj->bottom()));

   }
}

BevelBox::BevelBox()
{
}

void BevelBox::makeBorder(GraphicObject *graphicObj)
{
   graphicObj->setBorders(2,1,2,1);
}

void BevelBox::drawBorder(GraphicObject *graphicObj,GWindow *homeWindow)
{
   GBorder::drawBorder(graphicObj,homeWindow);
   ULONG recessed=0;
   graphicObj->getAttribute(GOB_BevelRecessed,(ULONG&)recessed);

   homeWindow->setStdClip();
   homeWindow->drawBevelBox(NORM_X(graphicObj->left()),
                            NORM_Y(graphicObj->top()),
                            graphicObj->width(),graphicObj->height(),recessed);
   homeWindow->resetStdClip();
}


void LineBorder::makeBorder(GraphicObject *graphicObj)
{
   graphicObj->setBorders(1,1,1,1);
}

void LineBorder::drawBorder(GraphicObject *graphicObj,GWindow *homeWindow)
{
   GBorder::drawBorder(graphicObj,homeWindow);

   WORD polyTable[5][2];
      polyTable[0][0] = (WORD)NORM_X(graphicObj->left());
      polyTable[0][1] = (WORD)NORM_Y(graphicObj->top());
      polyTable[1][0] = (WORD)NORM_X(graphicObj->right());
      polyTable[1][1] = (WORD)NORM_Y(graphicObj->top());
      polyTable[2][0] = (WORD)NORM_X(graphicObj->right());
      polyTable[2][1] = (WORD)NORM_Y(graphicObj->bottom());
      polyTable[3][0] = (WORD)NORM_X(graphicObj->left());
      polyTable[3][1] = (WORD)NORM_Y(graphicObj->bottom());
      polyTable[4][0] = (WORD)NORM_X(graphicObj->left());
      polyTable[4][1] = (WORD)NORM_Y(graphicObj->top());
   homeWindow->setStdClip();
   homeWindow->setAPen(1);
   homeWindow->move(polyTable[0][0],polyTable[0][1]);
   homeWindow->polyDraw(5,&polyTable[0][0]);
   homeWindow->resetStdClip();
}


NeXTBorder::NeXTBorder(UBYTE *titleFontName,UBYTE titleFontSize)
   : titleFont(titleFontName,titleFontSize)
{
}

void NeXTBorder::makeBorder(GraphicObject *graphicObj)
{
   UBYTE fontHeight = titleFont.ySize();
   graphicObj->setBorders(fontHeight,fontHeight,fontHeight,fontHeight);
}

void NeXTBorder::drawBorder(GraphicObject *graphicObj,GWindow *homeWindow)
{
   GBorder::drawBorder(graphicObj,homeWindow);

   WORD bWidth = titleFont.ySize(),bHeight = titleFont.ySize();
   #define X 0
   #define Y 1

   homeWindow->setStdClip();
   homeWindow->setDrMd(JAM1);


   WORD polyTable[3][2];
   WORD startX,endX;
   STRPTR title=NULL;
   if (graphicObj->getAttribute(GOB_BorderTitle,(ULONG&)title))
   {
      _dprintf("bordertext = '%s'\n",(char*)title);
      homeWindow->setFont(titleFont);
      // the title is placed in a gap of the top borderline with no space left
      WORD titlePixLen = 1+TextLength(homeWindow->rp(),title,strlen(title));
      startX = (WORD)NORM_X((LONG)graphicObj->left()+(graphicObj->width()-titlePixLen)/2);
      endX = startX+titlePixLen;
      homeWindow->setDrMd(JAM1);
      homeWindow->setAPen(1);
      homeWindow->moveTx(startX+1,(WORD)NORM_Y(graphicObj->top()+1));
      homeWindow->text((UBYTE*)title);
   }
   else startX = endX = (WORD)NORM_X((LONG)graphicObj->left()+bWidth);

   polyTable[0][X] = startX;
   polyTable[0][Y] = (WORD)NORM_Y((LONG)graphicObj->top()+bHeight/2);
   polyTable[1][X] = (WORD)NORM_X((LONG)graphicObj->left()+bWidth/2);
   polyTable[1][Y] = polyTable[0][Y];
   polyTable[2][X] = polyTable[1][X];
   polyTable[2][Y] = (WORD)NORM_Y((LONG)graphicObj->bottom()-bHeight/2);
   homeWindow->setAPen(1);
   homeWindow->polyDraw(3,&polyTable[0][0]);
   polyTable[0][Y]++; polyTable[1][Y]++; polyTable[1][X]++; polyTable[2][X]++;
   homeWindow->setAPen(2);
   homeWindow->polyDraw(3,&polyTable[0][0]);

   polyTable[0][X] = polyTable[2][X]+(WORD)1;
   polyTable[0][Y] = polyTable[2][Y];
   polyTable[1][X] = (WORD)NORM_X((LONG)graphicObj->right()-bWidth/2);
   polyTable[1][Y] = polyTable[0][Y];
   polyTable[2][X] = polyTable[1][X];
   polyTable[2][Y] = (WORD)NORM_Y((LONG)graphicObj->top()+bHeight/2+1);
   homeWindow->polyDraw(3,&polyTable[0][0]);
   homeWindow->setAPen(1);
   polyTable[0][Y]--; polyTable[1][Y]--; polyTable[1][X]--; polyTable[2][X]--;
   homeWindow->polyDraw(3,&polyTable[0][0]);

   polyTable[0][X] = polyTable[2][X]+(WORD)1;
   polyTable[0][Y] = polyTable[2][Y]-(WORD)1;
   polyTable[1][X] = endX;
   polyTable[1][Y] = polyTable[0][Y];
   homeWindow->polyDraw(2,&polyTable[0][0]);
   polyTable[0][Y]++; polyTable[1][Y]++;
   homeWindow->setAPen(2);
   homeWindow->polyDraw(2,&polyTable[0][0]);

   homeWindow->resetStdClip();
}
