#ifndef	CLIB_PPCT_H
#define	CLIB_PPCT_H

#include <extensions/ppct.h>

struct ppct *MakePPCT(struct TagItem *tags);
void FreePPCT(struct ppct *ppct);
ULONG FallPPCT(struct ppct *ppct,ULONG color);
void ImagePPCT(struct ppct *ppct,ULONG *trueimage,UBYTE *chunkyimage,ULONG numofpixels);
ULONG *PaletteToRGB32(ULONG *palette,ULONG numofcols,ULONG firstcol);
void FreeRGB32(ULONG *rgb32);
ULONG *RGB32ToPalette(ULONG *rgb32);
void FreePalette(ULONG *palette);
#endif