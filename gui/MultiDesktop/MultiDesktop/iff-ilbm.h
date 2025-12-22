/* IFF-ILBM-Strukturen */

struct BMHD
{
 UWORD Width,Height,X,Y;
 UBYTE Depth;
 UBYTE pad01;
 UBYTE Compression;
 UBYTE pad02;
 UWORD pad03;
 UBYTE xAspect,yAspect;
 UWORD PageWidth,PageHeight;
};

struct GRAB
{
 WORD OffsetX,OffsetY;
};

struct PNTR
{
 UWORD PointerCount;
 UWORD pad01;
};

