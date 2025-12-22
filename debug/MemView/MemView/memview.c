/*  :ts=8 bk=0
 * memview:  A window into memory.
 * Jon would call this a parlor trick, too.
 *
 * Leo L. Schwab		8608.5
 */

/*  I shouldn't have to include graphics/copper.h myself  */
#include <exec/types.h>
#include <exec/memory.h>
#include <graphics/gfxbase.h>
#include <graphics/copper.h>
#include <graphics/view.h>
#include <graphics/rastport.h>
#include <devices/gameport.h>
#include <devices/inputevent.h>

#define REV		0L
#define DEPTH		1L
#define WIDTH		320L
#define	HEIGHT		200L
#define ever		(;;)

extern void	*OpenLibrary(), *AllocMem(), *GetColorMap(), *CreateStdIO(),
		*CreatePort();
extern long	OpenDevice(), DoIO();


struct GamePortTrigger	gpt = {
	GPTF_UPKEYS | GPTF_DOWNKEYS,
	0,
	1, 1
};
UWORD		colors[] = { 0, 0xfff };

struct View	v, *oldview;
struct ViewPort	vp;
struct ColorMap	*cm;
struct RasInfo	ri;
struct BitMap	*bm;
struct GfxBase	*GfxBase;
struct InputEvent	joyreport;
struct IOStdReq	*gameio;
struct MsgPort	*gameport;



main ()
{
	int inc = 40, lx;

	openstuff ();
	makescreen ();		/*  NOT Intuition call  */
	initjoystick ();

	SendIO (gameio);
	for ever {
		WaitIO (gameio);
		if (joyreport.ie_Code == IECODE_LBUTTON)
			/*  Fire button pressed; exit program  */
			break;

		if (joyreport.ie_X != lx) {
			lx = joyreport.ie_X;
			if (joyreport.ie_X < 0)
				inc = 40;
			else if (joyreport.ie_X > 0)
				inc = 80;
			if (lx)
				remakedisp (inc);
		}

		if (joyreport.ie_Y) {
			if (joyreport.ie_Y > 0)
				bm -> Planes[0] += inc;
			else if (joyreport.ie_Y < 0)
				bm -> Planes[0] -= inc;
			WaitTOF ();
			ScrollVPort (&vp);
		}
		SendIO (gameio);
	}
	closeeverything ();
}


openstuff ()
{
	long err;

	if (!(GfxBase = OpenLibrary ("graphics.library", REV)))
		die ("Art shop closed.\n");

	if (!(gameport = CreatePort (0L, 0L)))
		die ("Can't make msgport.\n");

	if (!(gameio = CreateStdIO (gameport)))
		die ("Can't make IO packet.\n");

	if (err = OpenDevice ("gameport.device", 1L, gameio, 0L))
		die ("Games closed.\n");

	if (!(bm = AllocMem ((long) sizeof (*bm), MEMF_CHIP | MEMF_CLEAR)))
		die ("Can't allocate BitMap.\n");
}

makescreen ()
{
	InitView (&v);
	InitVPort (&vp);
	InitBitMap (bm, DEPTH, WIDTH, HEIGHT);

	v.ViewPort = &vp;

	ri.BitMap = bm;
	ri.RxOffset = ri.RyOffset = ri.Next = NULL;

	vp.DWidth = WIDTH;
	vp.DHeight = HEIGHT;
	vp.RasInfo = &ri;
	vp.ColorMap = GetColorMap (2L);

	bm -> Planes[0] = NULL;    /*  Start looking at address 0  */

	MakeVPort (&v, &vp);
	MrgCop (&v);
	LoadRGB4 (&vp, colors, 2L);
	oldview = GfxBase -> ActiView;
	LoadView (&v);
}

closeeverything ()
{
	register int i;

	if (oldview) {
		LoadView (oldview);
		WaitTOF ();	/*  Make sure copper is using old view  */
		FreeVPortCopLists (&vp);
		FreeCprList (v.LOFCprList);
	}
	if (vp.ColorMap)
		FreeColorMap (vp.ColorMap);
	if (bm)
		FreeMem (bm, (long) sizeof (*bm));
	if (gameio) {
		if (gameio -> io_Device)
			CloseDevice (gameio);
		DeleteStdIO (gameio);
	}
	if (gameport)
		DeletePort (gameport);
	if (GfxBase)
		CloseLibrary (GfxBase);
}

die (str)
char *str;
{
	puts (str);
	closeeverything ();
	exit (100);
}

initjoystick ()
{
	UBYTE type = GPCT_RELJOYSTICK;

	gameio -> io_Command = GPD_SETCTYPE;
	gameio -> io_Length = 1;
	gameio -> io_Data = &type;
	if (DoIO (gameio))
		die ("Error in setting controller type.\n");

	gameio -> io_Command = GPD_SETTRIGGER;
	gameio -> io_Length = sizeof (gpt);
	gameio -> io_Data = &gpt;
	if (DoIO (gameio))
		die ("Error in setting trigger values.\n");

	gameio -> io_Command = GPD_READEVENT;
	gameio -> io_Length = sizeof (joyreport);
	gameio -> io_Data = &joyreport;
}

remakedisp (line)
int line;
{
	void *sav1, *sav2;

	LoadView (oldview);
	WaitTOF ();	/*  Make sure copper is using old view  */
	FreeVPortCopLists (&vp);
	FreeCprList (v.LOFCprList);
	sav1 = bm -> Planes[0];
	sav2 = vp.ColorMap;

	InitView (&v);
	InitVPort (&vp);

	v.ViewPort = &vp;

	vp.DHeight = HEIGHT;
	vp.RasInfo = &ri;
	vp.ColorMap = sav2;

	if (line == 80) {
		InitBitMap (bm, DEPTH, WIDTH+WIDTH, HEIGHT);
		vp.Modes |= HIRES;
		vp.DWidth = WIDTH + WIDTH;
	} else {
		InitBitMap (bm, DEPTH, WIDTH, HEIGHT);
		vp.Modes &= ~HIRES;
		vp.DWidth = WIDTH;
	}
	bm -> Planes[0] = sav1;

	MakeVPort (&v, &vp);
	MrgCop (&v);
	LoadRGB4 (&vp, colors, 2L);
	oldview = GfxBase -> ActiView;
	LoadView (&v);
}
