///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////                                        ////////////////////
///////////////////           file : crastporthdl.cc       ////////////////////
///////////////////                                        ////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////


#include <intuition/intuitionbase.h>
#include <graphics/gfxbase.h>
#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
#include <string.h>


#include "ipp/crastporthdl.h"




CRastPortHdl :: CRastPortHdl()
{
	raster=NULL;
}


CRastPortHdl :: CRastPortHdl(struct RastPort *newraster)
{
	raster=newraster;
}


CRastPortHdl :: ~CRastPortHdl()
{
	rfont.close();
}


BOOL CRastPortHdl :: hdlon(struct RastPort *newraster)
{
	raster=newraster;
	if (raster) resetfont();
	return hdlison();
}


void CRastPortHdl :: hdloff()
{
	raster=NULL;
}


BOOL CRastPortHdl :: hdlison()
{
	return (raster!=NULL);
}


void CRastPortHdl :: clear()
{
	if (hdlison()) SetRast(raster,background);
}

void CRastPortHdl :: setpenpos(int x, int y)
{
	if (hdlison()) Move(raster,(long)x,(long)y);
}

void CRastPortHdl :: writepixel(int x, int y)
{
	if (hdlison()) WritePixel(raster,(long)x,(long)y);
}

void CRastPortHdl :: drawline(int x1, int y1, int x2, int y2)
{
	if (hdlison())
	{
		Move(raster, x1, y1);
		Draw(raster, x2, y2);
	}
}

void CRastPortHdl :: drawlineto(int x, int y)
{
	if (hdlison()) Draw(raster,x,y);
}


void CRastPortHdl :: writetext(int x, int y, char *text)
{
	if (hdlison())
	{
		Move(raster,x,y);
		Text(raster,(STRPTR)text,strlen(text));
	}
}


void CRastPortHdl :: writetext(char *text)
{
	if (hdlison()) Text(raster,(STRPTR)text,strlen(text));
}


void CRastPortHdl :: setfont(STRPTR fontname, UWORD fontsize, UBYTE style, UBYTE flags)
{
	if (rfont.open(fontname, fontsize, style, flags))
		if (hdlison()) SetFont(raster,rfont.font);
}


void CRastPortHdl :: setfont(struct TextAttr *tattr)
{
	if (rfont.open(tattr->ta_Name,tattr->ta_YSize,tattr->ta_Style,tattr->ta_Flags))
		if (hdlison()) SetFont(raster,rfont.font);
}


void CRastPortHdl :: resetfont()
{
	if (rfont.isopen())
		if (hdlison()) SetFont(raster,rfont.font);
}


void CRastPortHdl :: drawrect(int x1, int y1, int x2, int y2)
{
	if (hdlison())
	{
		Move(raster,x1,y1);
		Draw(raster,x1,y2);
		Draw(raster,x2,y2);
		Draw(raster,x2,y1);
		Draw(raster,x1,y1);
	}
}

void CRastPortHdl :: drawrectfill(int x1, int y1, int x2, int y2)
{
	if (hdlison()) RectFill(raster,x1,y1,x2,y2);
}

void CRastPortHdl :: drawcircle(int x, int y, int radius)
{
	if (hdlison()) DrawEllipse(raster,x,y,radius,radius);
}

void CRastPortHdl :: drawellipse(int x, int y, int rx, int ry)
{
	if (hdlison()) DrawEllipse(raster,x,y,rx,ry);
}

void CRastPortHdl :: drawimage(struct Image *image, int x, int y)
{
	if (hdlison()) DrawImage(raster,image,x,y);
}

void CRastPortHdl :: flood(int x, int y)
{
	if (hdlison()) Flood(raster,1,x,y);
}

void CRastPortHdl :: setdrmd(int mode)
{
	if (hdlison()) SetDrMd(raster,mode);
}

void CRastPortHdl :: setdrpt(int pattern)
{
	if (hdlison()) SetDrPt(raster,pattern);
}

void CRastPortHdl :: setapen(int color)
{
	if (hdlison()) SetAPen(raster,color);
	foreground=color;
}

void CRastPortHdl :: setbpen(int color)
{
	if (hdlison()) SetBPen(raster,color);
	background=color;
}

int CRastPortHdl :: readpixel(int x, int y)
{
	if (hdlison()) return ReadPixel(raster,x,y);
	else return 0;
}


void CRastPortHdl :: setrast(int color)
{
	if (hdlison()) SetRast(raster, color); 
}

ULONG CRastPortHdl :: setwritemask(ULONG mask)
{
	if (hdlison()) return SetWriteMask(raster, mask);
	else return 0;
}

WORD CRastPortHdl :: textlength(STRPTR string, WORD length)
{
	if (hdlison()) return TextLength(raster, string, length);
	else return 0;
}

ULONG CRastPortHdl :: asksoftstyle()
{
	if (hdlison()) return AskSoftStyle(raster);
	else return 0;
}

ULONG CRastPortHdl :: setsoftstyle(ULONG mask, ULONG enable)
{
	if (hdlison()) return SetSoftStyle(raster, mask, enable);
	else return 0;
}

void CRastPortHdl :: cleareol()
{
	if (hdlison()) ClearEOL(raster);
}

void CRastPortHdl :: printItext(struct IntuiText *text, WORD x, WORD y)
{
	if (hdlison()) PrintIText(raster, text, x, y);
}

void CRastPortHdl :: polydraw(WORD count, WORD *array)
{
	if (hdlison()) PolyDraw(raster, count, array);
}

void CRastPortHdl :: scrollraster(WORD dx, WORD dy, WORD xmin, WORD ymin, WORD xmax, WORD ymax)
{
	if (hdlison()) ScrollRaster(raster, dx, dy, xmin, ymin, xmax, ymax);
}
