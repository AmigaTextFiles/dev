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
#include <proto/Warp3D.h>
#include <3d.h>
#include <vecmat.h>
#include <def.h>
#include <render.h>
#include <readlevel.h>
#include <text.h>
#include <libutil.h>
#include <textures.h>
#include <loadpng.h>

extern struct Library *CyberGfxBase;
extern struct Library *Warp3DBase;
extern struct Screen * screen;
extern struct Window * window;
extern W3D_Context   * context;
extern struct BitMap * bm;
extern BMFont        * font;

UBYTE *images[MAX_TEXTURES];


/*
** Set texture filtering on/off
*/
void TEXTURE_SetFilter(BOOL onoff)
{
	ULONG Filt = W3D_NEAREST;
	int i;

	if (onoff == TRUE) Filt = W3D_LINEAR;
	for (i=0; i<MAX_TEXTURES; i++)
		if (textures[i]) W3D_SetFilter(context, textures[i], Filt, Filt);
}

/*
** Initialize the Textures system
*/
void TEXTURE_Init(void)
{
	int i;
	for (i=0; i<MAX_TEXTURES; i++) {
		images[i]   = 0;
		textures[i] = 0;
	}
}

/*
** Create a texture handle from a memory pointer.
** Stores the memory pointer with the texture object
** (Created via W3D_AllocTexObj).
** Expects an RGB image if alpha is zero,
** expects and ARGB image if alpha is non-zero
*/
BOOL TEXTURE_MakeTexture(int tnum, int alpha, int size, void* memory)
{
	ULONG Cerror;

	if (textures[tnum]) TEXTURE_FreeTexture(tnum);

	images[tnum] = memory;

	if (tnum == 9) {
		UBYTE *x = memory;
		UWORD *y = memory;
		UBYTE r,g,b;
		int i;
		for (i=0; i<size*size; i++) {
			r=*x++;
			g=*x++;
			b=*x++;
			if (r==g==b==0) *y++ = 0xafa0;
			else *y++ = (0xF000 | ((r&0xF0)<<4) | ((g&0xF0)) | ((b&0xF0)>>4));
		}
		textures[tnum] = W3D_AllocTexObjTags(context, &Cerror,
			W3D_ATO_IMAGE,      memory,
			W3D_ATO_FORMAT,     W3D_A4R4G4B4,
			W3D_ATO_WIDTH,      (ULONG)size,
			W3D_ATO_HEIGHT,     (ULONG)size,
		TAG_DONE);
		if (textures[tnum]) W3D_SetBlendMode(context, W3D_SRC_ALPHA, W3D_ZERO);

	}  else

	textures[tnum] = W3D_AllocTexObjTags(context, &Cerror,
		W3D_ATO_IMAGE,      memory,
		W3D_ATO_FORMAT,     (alpha==0)?W3D_R8G8B8:W3D_A8R8G8B8,
		W3D_ATO_WIDTH,      (ULONG)size,
		W3D_ATO_HEIGHT,     (ULONG)size,
	TAG_DONE);

	if (!textures[tnum] || Cerror != W3D_SUCCESS) return FALSE;

	W3D_SetWrapMode(context, (W3D_Texture*)textures[tnum], W3D_REPEAT, W3D_REPEAT, NULL);
	return TRUE;
}

UWORD OldWindow = 0xafa0;

void TEXTURE_FlipWindowColor(UWORD Color)
{
	int i;
	int j = ((W3D_Texture*)(textures[9]))->texwidth;
	UWORD *x = (UWORD*)images[9];
	for (i=0; i<j*j; i++) {
		if (*x == OldWindow) *x = Color;
		x++;
	}
	OldWindow = Color;
	W3D_UpdateTexImage(context, textures[9], images[9], 0, NULL);
}

/*
** Free a texture
*/
void TEXTURE_FreeTexture(int tnum)
{
	W3D_FreeTexObj(context, (W3D_Texture*)textures[tnum]);
	textures[tnum] = 0;
	FreeVec(images[tnum]);
	images[tnum] = 0;
}

/*
** Free ALL textures
*/
void TEXTURE_FreeAll(void)
{
	int i;
	for (i=0; i<MAX_TEXTURES; i++)
		if (textures[i])
			TEXTURE_FreeTexture(i);
}


/*
** Makes a texture from a PNG file
** The string must be stripped from quotes
** The prefix "gfx" is prepended if the file does not exist without it
** Returns FALSE if the texture could not be made
*/
BOOL TEXTURE_MakeTexturePNG(int tnum, char* filename)
{
	FILE *fh;
	int ret;
	UBYTE *image;
	ULONG Width, Height;
	BOOL HasAlpha;
	static char buffer[250];

//    ret = access(filename, R_OK);
	fh = fopen(filename, "r");
	if (fh)
	{
		ret = 0;
		fclose(fh);
	}
	else
	{
		ret = -1;
	}

	if (ret == 0) {
		image = LoadPNG(filename, &Width, &Height, &HasAlpha);
	} else {
		strcpy(buffer, "gfx/");
		strcat(buffer, filename);
		image = LoadPNG(buffer, &Width, &Height, &HasAlpha);
	}

	if (!image) return FALSE;
	if (Width != Height) return FALSE;

	return TEXTURE_MakeTexture(tnum, HasAlpha?1:0, (int)Width, image);
}

/*
** Get the extends of a texture
*/
void TEXTURE_GetSize(int tnum, ULONG* Size, BOOL* HasAlpha)
{
	if (textures[tnum]) {
		*Size       = (ULONG)((W3D_Texture*)textures[tnum])->texwidth;
		*HasAlpha   = (BOOL)(((W3D_Texture*)textures[tnum])->texfmtsrc == W3D_A8R8G8B8);
	} else {
		*Size = 0;
	}
}
