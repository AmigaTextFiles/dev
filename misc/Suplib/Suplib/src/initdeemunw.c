
/*
 *  DEEMU NW structure auto init.
 *
 *  Intuition must be openned.
 */

#include <local/typedefs.h>

void
InitDeemuNW(ary, nw)
register short *ary;
register NW *nw;
{
    register short alen = ary[3];
    SCR Scr;

    if (GetScreenData((char *)&Scr, sizeof(Scr), nw->Type, nw->Screen) == 0) {
	Scr.Width = 320;
	Scr.Height= 200;
    }
    if (alen >= 8) {
	if ((nw->Width   = ary[6]) <= 0)
	    nw->Width += Scr.Width;
	if ((nw->Height  = ary[7]) <= 0)
	    nw->Height+= Scr.Height;
    }
    if (alen >= 4) {
	if ((nw->LeftEdge= ary[4]) < 0)
	    nw->LeftEdge += Scr.Width - nw->Width;
	if ((nw->TopEdge = ary[5]) < 0)
	    nw->TopEdge += Scr.Height - nw->Height;
    }
    if (nw->LeftEdge < 0 || nw->TopEdge < 0 || nw->Width <= 0 || nw->Height <= 0 ||
	nw->LeftEdge + nw->Width > Scr.Width || nw->TopEdge + nw->Height > Scr.Height) {

	nw->LeftEdge = nw->TopEdge = 0;
	nw->Width = 320;
	nw->Height= 100;
    }
    if (alen >= 9)
	nw->DetailPen = ary[8] >> 8;
    if (alen >= 10)
	nw->BlockPen  = ary[8];
}


