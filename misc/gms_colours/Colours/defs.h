
extern struct GVBase    *GVBase;
extern struct BLTBase   *BLTBase;
extern struct ModPublic *Public;
extern struct Module    *BlitterMod;

LIBFUNC void LIBBlurArea(mreg(__a0) struct Bitmap *Bitmap, mreg(__d0) WORD StartX, mreg(__d1) WORD StartY, mreg(__d2) WORD Width, mreg(__d3) WORD Height, mreg(__d4) WORD Performance);
LIBFUNC LONG LIBCalcBrightness(mreg(__d0) LONG RGB);
LIBFUNC LONG LIBClosestColour(mreg(__d0) LONG RGB, mreg(__a0) struct RGBPalette *Palette);
LIBFUNC LONG LIBConvertHSVToRGB(mreg(__a0) struct HSV *HSV);
LIBFUNC void LIBConvertRGBToHSV(mreg(__d0) LONG rgb, mreg(__a0) struct HSV *HSV);
LIBFUNC LONG LIBCopyPalette(mreg(__a0) LONG argSrcPalette, mreg(__a1) LONG argDestPalette, mreg(__d0) LONG ColStart, mreg(__d1) LONG AmtColours,  mreg(__d2) LONG DestCol);
LIBFUNC void LIBDarkenArea(mreg(__a0) struct Bitmap *Bitmap, mreg(__d0) WORD StartX, mreg(__d1) WORD StartY, mreg(__d2) WORD EndX, mreg(__d3) WORD EndY, mreg(__d4) WORD Percent);
LIBFUNC void LIBDarkenPixel(mreg(__a0) struct Bitmap *Bitmap, mreg(__d0) WORD X, mreg(__d1) WORD Y, mreg(__d2) WORD Percent);
LIBFUNC void LIBLightenArea(mreg(__a0) struct Bitmap *Bitmap, mreg(__d0) WORD StartX, mreg(__d1) WORD StartY, mreg(__d2) WORD EndX, mreg(__d3) WORD EndY, mreg(__d4) WORD Percent);
LIBFUNC void LIBLightenPixel(mreg(__a0) struct Bitmap *Bitmap, mreg(__d0) WORD X, mreg(__d1) WORD Y, mreg(__d2) WORD Percent);
LIBFUNC LONG LIBRemapBitmap(mreg(__a0) LONG Source, mreg(__a1) LONG Dest, mreg(__d0) WORD Performance);

/************************************************************************************
** Prototypes.
*/

void FreeModule(void);

