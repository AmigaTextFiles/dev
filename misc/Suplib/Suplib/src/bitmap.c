
/*
 *  BITMAP.C
 */

#include <local/typedefs.h>

extern struct GfxBase *GfxBase;

int
MakeRastPortBitMap(rp, bm, depth, width, height, tmprassize, numai)
RP *rp;
BM *bm;
short depth, width, height, numai;
long tmprassize;
{
    if (MakeBitMap(bm, depth, width, height, MEMF_PUBLIC|MEMF_CHIP|MEMF_CLEAR)) {
	if (MakeRastPort(rp, bm, tmprassize, numai))
	    return(1);
	FreeBitMap(bm);
    }
    return(0);
}

void
FreeRastPortBitMap(rp)
RP *rp;
{
    if (rp) {
	BM *bm = rp->BitMap;
	FreeRastPort(rp);
	if (bm)
	    FreeBitMap(bm);
    }
}

int
MakeBitMap(bm, depth, width, height, memflags)
register BM *bm;
short depth;
short width;
short height;
ulong memflags;
{
    register short i;
    register ulong rassize;
    register PLANEPTR *ptr;

    if (!bm)
	return(0);
    if (!GfxBase)
	OpenGfxLibrary();
    InitBitMap(bm, depth, width, height);
    rassize = bm->Rows * bm->BytesPerRow;
    for (i = 0, ptr = bm->Planes; i < bm->Depth; ++i, ++ptr) {
	if ((*ptr = AllocMem(rassize, memflags)) == NULL)
	    break;
    }
    if (i != bm->Depth) {
	while (--i >= 0) {
	    --ptr;
	    FreeMem(*ptr, rassize);
	    *ptr = NULL;
	}
	return(0);
    }
    return(1);
}

void
FreeBitMap(bm)
register BM *bm;
{
    PLANEPTR lastptr = NULL;

    WaitBlit();
    if (bm) {
	register short i;
	register PLANEPTR *ptr;
	register ulong rassize = bm->Rows * bm->BytesPerRow;

	for (i = 0, ptr = bm->Planes; i < bm->Depth; ++i, ++ptr) {
	    if (*ptr && *ptr != lastptr) {
		lastptr = *ptr;
		FreeMem(*ptr, rassize);
		*ptr = NULL;
	    }
	    *ptr = NULL;
	}
    }
}

void
OpenGfxLibrary()
{
    GfxBase = (struct GfxBase *)OpenLibrary("graphics.library", 0);
}

