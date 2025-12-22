#ifndef __TEXTURES_H
#define __TEXTURES_H

void TEXTURE_Init(void);
BOOL TEXTURE_MakeTexture(int tnum, int alpha, int size, void *memory);
void TEXTURE_FreeTexture(int tnum);
BOOL TEXTURE_MakeTexturePNG(int tnum, char* filename);
void TEXTURE_GetSize(int tnum, ULONG* Size, BOOL* HasAlpha);
void TEXTURE_FreeAll(void);
void TEXTURE_SetFilter(BOOL onoff);
void TEXTURE_FlipWindowColor(UWORD Color);
#endif
