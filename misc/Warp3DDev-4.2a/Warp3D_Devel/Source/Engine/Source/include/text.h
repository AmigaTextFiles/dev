#ifndef __TEXT_H
#define __TEXT_H

#define NUM_GLYPHS 46

typedef struct {
	UBYTE *Glyphs[NUM_GLYPHS];
	int GlyphWidth, GlyphHeight;
	int BytesPerGlyph;
	int GlpyhSpace;
	UBYTE *GlyphData;
} BMFont;

BMFont*     TEXT_LoadFont(char *filename);
void        TEXT_FreeFont(BMFont* font);
void        TEXT_SetFont(BMFont* font);
void        TEXT_SetColor(int r, int g, int b);
void        TEXT_PrintString(int x, int y, char* string);

#endif
