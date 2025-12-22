///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////                                        ////////////////////
///////////////////           file : crastporthdl.h        ////////////////////
///////////////////                                        ////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
//
//	Class CRastPortHdl :
//
//		- RastPort handling.
//
//		- This is just a handler to wich you pass a pointer on a valid
//		RastPort structure. I'll do a real RastPort class with creation
//		and destruction, one day.
//
//		- Pass a pointer to its constructor, or turn it on by passing one
//		with 'hdlon()'.
//
//		- Turn it off when the RastPort is no longer valid with 'hdloff()'
//
//		- Some of the method names has been changed compare to original
//		kernel name, see this file to find the new name.


#ifndef __CRASTPORTHDL__
#define __CRASTPORTHDL__

#include <intuition/intuition.h>
#include <graphics/gfxmacros.h>

#include <ipp/cfont.h>


class CRastPortHdl
{
protected:
	struct RastPort *raster;
	int foreground, background;
	CFont rfont;

	void resetfont();
	BOOL hdlon(struct RastPort *validraster);
	void hdloff();
public:
	CRastPortHdl();
	CRastPortHdl(struct RastPort *validraster);
	~CRastPortHdl();

	BOOL hdlison();

	void clear();
	void setpenpos(int x, int y);
	void setapen(int color);
	void setbpen(int color);
	void setdrmd(int mode);
	void setdrpt(int pattern);
	void setrast(int color);
	ULONG setwritemask(ULONG mask);

	void setfont(STRPTR name, UWORD size, UBYTE style, UBYTE flags);
	void setfont(struct TextAttr *textattr);
	struct TextAttr *askfont(struct TextAttr *textattr);
	void writetext(char *string);
	void writetext(int x, int y, char *string);
	WORD textlength(STRPTR string, WORD stringlength);
	ULONG asksoftstyle();
	ULONG setsoftstyle(ULONG mask, ULONG enable);
	void cleareol();
	void printItext(struct IntuiText *itext, WORD x, WORD y);

	void writepixel(int x, int y);
	int readpixel(int x, int y);
	void drawline(int x1, int y1, int x2, int y2);
	void drawlineto(int x, int y);
	void drawrect(int x1, int y1, int x2, int y2);
	void drawrectfill(int x1, int y1, int x2, int y2);
	void drawcircle(int x, int y, int radius);
	void drawellipse(int x, int y, int radiusx, int radiusy);
	void drawimage(struct Image *image, int x, int y);
	void flood(int x, int y);
	void polydraw(WORD count, WORD *array);

	void scrollraster(WORD dx, WORD dy, WORD xmin, WORD ymin, WORD xmax, WORD ymax);
};

#endif //__CRASTPORTHDL__
