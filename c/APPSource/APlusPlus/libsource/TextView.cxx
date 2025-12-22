/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/TextView.cxx,v $
 **   $Revision: 1.10 $
 **   $Date: 1994/07/27 11:52:18 $
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
}

#include <APlusPlus/graphics/TextView.h>
#include <APlusPlus/intuition/IntuiMessageC.h>


static const char rcs_id[] = "$Id: TextView.cxx,v 1.10 1994/07/27 11:52:18 Armin_Vogt Exp Armin_Vogt $";

//runtime type inquiry support
intui_typeinfo(TextView, derived(from(Canvas)), rcs_id)


TextView::TextView(GOB_OWNER, AttrList& attrs)
   : Canvas(gob_owner,attrs), font((UBYTE*)intuiAttrs().getTagData(TXV_FontName),
            (UWORD)intuiAttrs().getTagData(TXV_FontSize))
{
   if (Ok())
   {
      Canvas::setAttributes( AttrList(CNV_GranularityY,font.ySize(),
            CNV_ScrollGratX,FALSE,CNV_ScrollGratY,TRUE,TAG_END) );
      setFont(font);
      crsrx = intuiAttrs().getTagData(TXV_CursorX,1);
      crsrx = max(crsrx,1);
      crsry = intuiAttrs().getTagData(TXV_CursorY,1);
      crsry = max(crsry,1);
      lineCount = intuiAttrs().getTagData(TXV_Lines,0);
      crsrOn = (UBYTE)intuiAttrs().getTagData(TXV_CursorOn,FALSE);
      cBoxLeft = cBoxRight = 0;
      cviewx = 1; cviewy = 1;
      setIOType(IOTYPE_TEXTVIEW);
   }
}

TextView::~TextView()
{

}

ULONG TextView::setAttributes(AttrList& attrs)
{
   Canvas::setAttributes(attrs);

   AttrIterator next(attrs);
   while (next())
   {
      switch (next.tag())
      {
         case TXV_CursorY : setCursor(next.data(),-1); break;
         case TXV_CursorX : setCursor(-1,next.data()); break;
         case TXV_Lines : lineCount = next.data(); break;
         case TXV_CursorOn : crsrOn = (UBYTE)next.data(); break;
      }
   }
   return 1L;
}

ULONG TextView::getAttribute(Tag tag,ULONG& dataStore)
{
   return Canvas::getAttribute(tag,dataStore);
}

void TextView::writeLine(LONG line)
{
   setStdClip();

   moveTx((line-1)*granularityY(),0);
   UWORD len;
   UBYTE *str = getLineString(line,len);
   formatOutput(str,len);

   resetStdClip();
}

void TextView::print(UBYTE *partString,UWORD length)
{
   text(partString,length);
}

void TextView::formatOutput(UBYTE *textString, UWORD length)
{
   setAPen(1);setDrMd(JAM1);
   text(textString,length);
}

void TextView::drawSelf()
{
   _dprintf( ("TextView::drawSelf(viewY=%ld, visibleY=%ld, granularityY=%ld\n",viewY(),visibleY(),granularityY()) );
   for (LONG ll=1,line=viewY()+1; ll<=visibleY() && line <= lines(); ll++,line++)
   {
      moveTx(0,(line-1)*granularityY());
      UWORD len;
      UBYTE *str = getLineString(line,len);
      formatOutput(str,len);
   }
   // prevent erasing a cursor that is already drawn over.
   cBoxRight = 0;
}

void TextView::callback(const IntuiMessageC *imsg)
{
   Canvas::callback(imsg);

   switch (imsg->getClass())
   {
      case CLASS_MOUSEBUTTONS :
         _dprintf("TV::MOUSEBUTTONS\n");
         break;
      case CLASS_MOUSEMOVE :
         _dprintf("TV::MOUSEMOVE\n");
         break;
      case CLASS_GADGETDOWN :
         _dprintf("TV:GADGETDOWN\n");
         findCursor();
         break;
      case CLASS_GADGETUP :
         _dprintf("TV:GADGETUP\n");
         if (!forceActiveGadget(imsg))
         {
            _dprintf(" - loose active status..\n");
            eraseCBox();
         }
         break;
      case CLASS_VANILLAKEY :
         break;
      case CLASS_RAWKEY :
         /* subclasses may already have decoded the rawkey into 'key'
          * TextView is the last class to process the keycodes,
          * therefore it clears the 'key' object after processing
          */
         if (key.isEmpty()) key.decode(imsg);
         switch (key.key())
         {
            case CURSOR_UP :
               setCursor(cursorY()-1,-1);
               break;
            case CURSOR_DOWN :
               setCursor(cursorY()+1,-1);
               break;
            case CURSOR_RIGHT :
               setCursor(-1,cursorX()+1);
               break;
            case CURSOR_LEFT :
               setCursor(-1,cursorX()-1);
               break;
         }
         key.clear();   // clear for next RAWKEY message
         break;
   }
}

BOOL TextView::setCursor(LONG lineNr,LONG characterNr)
{
   if (characterNr == -1) characterNr = crsrx;
   if (lineNr == -1) lineNr = crsry;

   if (lineNr >= 1 && lineNr <= lines() && characterNr >= 1)
   {
      eraseCBox();
      // if new pos outside view move view so that cursor remains at his place within view
      if (lineNr < topLine())
      {
         cviewy = crsry-topLine()+1;
         if (lineNr < cviewy) cviewy = lineNr;
         Canvas::setAttributes(AttrList(CNV_ViewY,lineNr-cviewy,TAG_END));
      }
      else if (lineNr > topLine()+visibleLines()-1)
      {
         cviewy = crsry-topLine()+1;
         if (lines()-lineNr < visibleLines()-cviewy) cviewy = visibleLines()-(lines()-lineNr);
         Canvas::setAttributes(AttrList(CNV_ViewY,lineNr-cviewy,TAG_END));
      }
      else cviewy = lineNr-topLine()+1;

      // if new
      UWORD length;
      UBYTE *lineString = getLineString(lineNr,length);
      crsrx = min(characterNr,length); crsry = lineNr;

      XYVAL cpos = cBoxLeft/granularityX()-viewX();
      cBoxRight = TextLength(rp(),(STRPTR)lineString,crsrx);
      cBoxLeft = cBoxRight - TextLength(rp(),(STRPTR)&lineString[crsrx-1],1);

      XYVAL newViewX = cBoxLeft/granularityX();
      XYVAL xOffset = viewX()*granularityX();
      if (cBoxLeft < xOffset || cBoxRight > xOffset+visibleX()*granularityX())
      {
         if (newViewX <= cpos)
         {
            newViewX = 0;
         }
         else
            newViewX -= cpos;
         Canvas::setAttributes(AttrList(CNV_ViewX,newViewX,TAG_END));
         cviewx = newViewX;
      }

      drawCBox();
      return TRUE;
   }
   else return TRUE;
}

void TextView::findCursor()
{
   crsry = topLine()+cviewy-1;
   // find character nearest to the cursor position relative to view boundaries
   struct TextExtent textExtent;
   UWORD length;
   UBYTE *lineString = getLineString(crsry,length);
   crsrx = (LONG)1+TextFit(rp(),(STRPTR)lineString,length,&textExtent,NULL,1,
            (LONG)cBoxLeft+(-((LONG)cviewx)+viewX())*granularityX(),(LONG)font.ySize()+1);

   setCursor(crsry,crsrx);
}
/*
void TextView::cursorPos(UWORD mx,UWORD my)
{
   struct TextExtent textExtent;
   crsry = my+1;

   UWORD length;
   UBYTE *lineString = getLineString(crsry,length);
   cColumn = TextFit(rp(),lineString,length,&textExtent,NULL,1,mx,font.ySize()+1);

   if (cColumn == length){}
}
*/
void TextView::toggleCBox()
{
   // if cursor is on, erase cbox
   adjustStdClip();
   setStdClip();
   setDrMd(COMPLEMENT);
   rectFill(cBoxLeft,(crsry-1)*granularityY(),cBoxRight,crsry*granularityY());
   resetStdClip();
}
