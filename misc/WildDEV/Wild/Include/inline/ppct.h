#ifndef _INLINE_PPCT_H
#define _INLINE_PPCT_H

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef PPCT_BASE_NAME
#define PPCT_BASE_NAME PPctExtensionBase
#endif

#define MakePPCT(tags) \
	LP1(0x1E, struct ppct *, MakePPCT, struct TagItem *, tags, a0, \
	, PPCT_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define MakePPCTTags(tags...) \
	({ULONG _tags[] = {tags}; MakePPCT((struct TagItem *) _tags);})
#endif

#define FreePPCT(ppct) \
	LP1NR(0x24, FreePPCT, struct ppct *, ppct, a0, \
	, PPCT_BASE_NAME)

#define FallPPCT(ppct, color) \
	LP2(0x2A, ULONG, FallPPCT, struct ppct *, ppct, a0, ULONG, color, d0, \
	, PPCT_BASE_NAME)

#define ImagePPCT(ppct, trueimage, chunkyimage, numofpixels) \
	LP4NR(0x30, ImagePPCT, struct ppct *, ppct, a0, ULONG *, trueimage, a1, UBYTE *, chunkyimage, a2, ULONG, numofpixels, d0, \
	, PPCT_BASE_NAME)

#define PaletteToRGB32(palette, numofcols, firstcol) \
	LP3(0x36, ULONG *, PaletteToRGB32, ULONG *, palette, a0, ULONG, numofcols, d0, ULONG, firstcol, d1, \
	, PPCT_BASE_NAME)

#define FreeRGB32(rgb32) \
	LP1NR(0x3C, FreeRGB32, ULONG *, rgb32, a0, \
	, PPCT_BASE_NAME)

#define RGB32ToPalette(rgb32) \
	LP1(0x42, ULONG *, RGB32ToPalette, ULONG *, rgb32, a0, \
	, PPCT_BASE_NAME)

#define FreePalette(palette) \
	LP1NR(0x48, FreePalette, ULONG *, palette, a0, \
	, PPCT_BASE_NAME)

#endif /*  _INLINE_PPCT_H  */
