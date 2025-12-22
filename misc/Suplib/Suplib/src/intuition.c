
/*
 *  INTUITION.C
 */

#include <local/typedefs.h>

extern struct IntuitionBase *IntuitionBase;

void
SetNewScreen(ns, type, xscr)
NS *ns;
ulong type;
SCR *xscr;
{
    SCR scr;

    if (!IntuitionBase)
	OpenIntuitionLibrary();

    scr.ViewPort.Modes = HIRES;
    scr.Width  = 640;
    scr.Height = 200;
    scr.BitMap.Depth = 2;
    GetScreenData((char *)&scr, sizeof(scr), type, xscr);
    if (!ns->Height) {
	ns->Height= scr.Height;
	if ((ns->ViewModes & LACE) != (scr.ViewPort.Modes & LACE)) {
	    if (ns->ViewModes & LACE)
		ns->Height <<= 1;
	    else
		ns->Height >>= 1;
	}
    }
    if (!ns->Width) {
	ns->Width = scr.Width;
	if ((ns->ViewModes & HIRES) != (scr.ViewPort.Modes & HIRES)) {
	    if (ns->ViewModes & HIRES)
		ns->Width <<= 1;
	    else
		ns->Width >>= 1;
	}
    }
    if (ns->Depth == 0 && (ns->Type & CUSTOMBITMAP) && ns->CustomBitMap)
	ns->Depth = ns->CustomBitMap->Depth;
    if (ns->Depth == 0)
	ns->Depth = scr.BitMap.Depth;
}

/*
 *  GetStdWidth()
 *
 *  Returns standard screen width for HIRES mode
 */

int
GetStdWidth()
{
    SCR scr;

    if (!IntuitionBase)
	OpenIntuitionLibrary();
    GetScreenData((char *)&scr, sizeof(scr), WBENCHSCREEN, NULL);
    if (scr.ViewPort.Modes & HIRES)
	return((int)scr.Width);
    return(scr.Width << 1);
}


/*
 *  GetStdHeight()
 *
 *  Returns standard screen height for non-interlace mode
 *  (whether or not the workbench is interlaced)
 */

int
GetStdHeight()
{
    SCR scr;
    if (!IntuitionBase)
	OpenIntuitionLibrary();
    GetScreenData((char *)&scr, sizeof(scr), WBENCHSCREEN, NULL);
    if (scr.ViewPort.Modes & LACE)
	return((int)scr.Height >> 1);
    return((int)scr.Height);
}

void
OpenIntuitionLibrary()
{
    IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library", 0);
}


