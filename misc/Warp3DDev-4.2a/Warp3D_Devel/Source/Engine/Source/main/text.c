#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <exec/types.h>
#include <exec/memory.h>
#include <cybergraphx/cybergraphics.h>
#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/dos.h>
#include <proto/cybergraphics.h>
#include <Warp3D/Warp3D.h>
#include <clib/Warp3D_protos.h>
#include <pragmas/Warp3D_pragmas.h>
#include <3d.h>
#include <vecmat.h>
#include <def.h>
#include <render.h>
#include <readlevel.h>
#include <text.h>

extern struct Library *Warp3DBase;
extern struct Screen * screen;
extern struct Window * window;
extern W3D_Context   * context;
extern struct BitMap * bm;
extern UWORD         * DisplayBase;
extern ULONG           BytesPerRow;
extern int             bufnum;
extern W3D_Scissor     s;
extern BOOL            DoMultiBuffer;

static BMFont *CFont = NULL;
static UWORD CColor;
static char *CharSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789*+-_!\"()#.";

static int CharSetMap[255];
static int CharSetMapReady = 0;

/*
** Initialize the CharSetMap table
*/
static void TEXT_InitCharSetMap(void)
{
	int i,j;
	char *p;

	if (CharSetMapReady == 1) return;
	CharSetMapReady = 1;
	for (i=0; i<256; i++) {
		p=strchr(CharSet, i);
		if (!p) {
			p=strchr(CharSet,toupper(i));
		}
		if (!p) j=NUM_GLYPHS-1;
		else {
			j=(int)(p-CharSet);
		}
		CharSetMap[i] = j;
	}
}


/*
** Load a font from disk
*/
BMFont *TEXT_LoadFont(char *filename)
{
	FILE *f;
	int i;
	int c;
	BMFont *newFont;
	UBYTE *b;

	TEXT_InitCharSetMap();

	f = fopen(filename, "rb");
	if (!f) return NULL;

	newFont = malloc(sizeof(BMFont));
	if (!newFont) goto panic;

	bzero(newFont, sizeof(BMFont));

	c=fgetc(f);
	newFont->GlyphWidth = c;

	c=fgetc(f);
	newFont->GlyphHeight = c;

	newFont->BytesPerGlyph = (newFont->GlyphWidth + 8) / 8;
	newFont->BytesPerGlyph *= newFont->GlyphHeight;

	newFont->GlyphData = (UBYTE *)malloc(NUM_GLYPHS * newFont->BytesPerGlyph);
	if (!newFont->GlyphData) goto panic;

	b=(UBYTE *)(newFont->GlyphData);

	for (i=0; i<NUM_GLYPHS; i++) {
		newFont->Glyphs[i] = b;
		if (1 != fread(newFont->Glyphs[i], newFont->BytesPerGlyph,1,f)) goto panic;
		b+=newFont->BytesPerGlyph;
	}

	fclose(f);
	return newFont;

panic:
	if (f) fclose(f);
	if (newFont && newFont->GlyphData) free(newFont->GlyphData);
	if (newFont) free(newFont);
	return NULL;
}

/*
** Free the font
*/
void TEXT_FreeFont(BMFont *font)
{
	if (font && font->GlyphData) free(font->GlyphData);
	if (font) free(font);
}

/*
** Set the current font
*/
void TEXT_SetFont(BMFont *font)
{
	CFont = font;
}

/*
** Set the current text color
*/
void TEXT_SetColor(int r, int g, int b)
{
	CColor = ((r<<7)&0x7C00) | ((g<<2)&0x02E0) | ((b>>3)&0x1F);
//    printf("CColor = %d\n", CColor);
}

/*
** Preliminary text print routine
**
** x,y are the pixel coordinates of the text.
** if x is -1, the text is centered on screen
**
** String must be null-terminated
*/
void TEXT_PrintString(int x, int y, char *string)
{
	UWORD *dest,*dest2;
	int i,j;
	char *p;
	int iflg = 0;

	if (!CFont) return;

	j=strlen(string);
	if (x==-1) x=160-(j*CFont->GlyphWidth)/2;
	y=BUFFY(y);

	dest = DisplayBase + (BytesPerRow/2)*y+x;

	for (i=0; i<CFont->GlyphHeight; i++) {
		p = string;
		dest2=dest;
		while (*p) {
			UBYTE *ch;
			UBYTE c;
			if (*p == '&') {
				p++;
				switch(*p) {
				case 'i': iflg = 1; break;
				case 'p': iflg = 0; break;
				}
			} else if (*p == ' ') {
				dest += CFont->GlyphWidth;
			} else {
				ch = CFont->Glyphs[CharSetMap[*p]]+i;
				c = *ch;
				if (iflg) c = ~c;
				for (j=0; j<CFont->GlyphWidth+iflg; j++) {
					if (0x80 & c) *dest = CColor;
					dest++;
					c = c<<1;
				}
				if (iflg) dest--;
			}
			p++;
			dest++;
		}
		dest = dest2+(BytesPerRow/2);
	}
}
