/*
 * BMFD: BitMapFontDisassembler.
 *
 * © Copyright 1993 by Olaf 'Rhialto' Seibert. All rights reserved.
 *
 * For use with BMFC (BitMapFontCompiler) by Adam M. Costello.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define INTUI_V36_NAMES_ONLY
#include <utility/tagitem.h>
#include <intuition/intuition.h>
#include <clib/exec_protos.h>
#include <clib/alib_protos.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>
#include <clib/diskfont_protos.h>
#include <clib/utility_protos.h>

void	       *IntuitionBase;
void	       *GfxBase;
void	       *DiskFontBase;
void	       *UtilityBase;

struct BitMap	BitMap;
struct RastPort DeepRastPort;
struct RastPort *RastPort;
struct Window  *Window;
struct TextFont *Font;
struct TextFont *OldFont;
int		PlanePick = -1;

int		linelength;
int		stretch;
int		verbose;

struct TagItem WindowTags[] = {
    WA_InnerHeight, 0,	    /* (Calculated and set) */
    TAG_END
};
struct ExtNewWindow NewWindow = {
    0, 20,		    /* LeftEdge, TopEdge */
    640, 0,		    /* Width, Height (calculated and set) */
    1, 1,		    /* DetailPen, BlockPen */
    0,			    /* IDCMPFlags */
    WFLG_SUPER_BITMAP | WFLG_GIMMEZEROZERO | WFLG_NOCAREREFRESH |
	WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_SIZEGADGET |
       WFLG_SIZEBRIGHT | WFLG_NW_EXTENDED, /* Flags */
    NULL,		    /* FirstGadget */
    NULL,		    /* CheckMark */
    NULL,		    /* Title */
    NULL,		    /* Screen */
    &BitMap,		    /* BitMap */
    20,20, -1,-1,	    /* Min/Max Width/Height */
    WBENCHSCREEN,	    /* Type */
    WindowTags
};

struct TagItem TextTags[] = {
    TAG_IGNORE, 0,
    TAG_END
};
struct TTextAttr TextAttr = {
    "topaz.font", 8, FSF_TAGGED, 0, TextTags
};

char ColorChars[] = "_#23456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
			      "abcdefghijklmnopqrstuvwxyz"
			      "=+";

#define RASTERWIDTH	    640
#define min(x, y)           ((x) < (y)? (x): (y))

void
openall(void)
{
    int 	    depth;
    int 	    i;

    /* Libraries */
    IntuitionBase = OpenLibrary("intuition.library", 33);
    if (IntuitionBase == NULL) {
	fprintf(stderr, "Needs intuition V33+.\n");
	exit(10);
    }
    GfxBase = OpenLibrary("graphics.library", 33);
    if (GfxBase == NULL) {
	fprintf(stderr, "Needs gfx V33+.\n");
	exit(10);
    }
    DiskFontBase = OpenLibrary("diskfont.library", 34);
    if (DiskFontBase == NULL) {
	fprintf(stderr, "Needs diskfont V34+.\n");
	exit(10);
    }
    UtilityBase = OpenLibrary("utility.library", 34);
    if (UtilityBase == NULL) {
	fprintf(stderr, "Not a 2.0+ system, eh? We'll do without, then...\n");
    }
    /* Font for window; sorry for the strange order */
    Font = OpenDiskFont((struct TextAttr *)&TextAttr);
    if (Font == NULL) {
	fprintf(stderr, "No %s %d!\n", TextAttr.tta_Name, TextAttr.tta_YSize);
	exit(10);
    }
    NewWindow.Height = Font->tf_YSize + 16; /* slight safety fudge */
    WindowTags[0].ti_Data = Font->tf_YSize; /* this is the right way */
    /* Raster for text */
    if (Font->tf_Style & FSF_COLORFONT) {
	struct ColorTextFont *ctf = (struct ColorTextFont *)Font;

	depth = ctf->ctf_Depth;
    } else
	depth = 1;

    InitBitMap(&BitMap, depth, RASTERWIDTH, NewWindow.Height);

    for(i = 0; i < depth; i++) {
	if ((BitMap.Planes[i] = AllocRaster(RASTERWIDTH, BitMap.Rows)) == NULL) {
	    fprintf(stderr, "No plane %d\n", i);
	    exit(10);
	}
    }
    /* Window for raster. For showing-off purposes only. */
    if ((Window = OpenWindow(&NewWindow)) == NULL) {
	fprintf(stderr, "No window (probably too large). Will do without.\n");
    }
    if (Window && Window->WScreen->RastPort.BitMap->Depth >= depth) {
	/* If possible, use the safely clipped/layered RastPort */
	RastPort = Window->RPort;
    } else {
	/* Otherwise, use the one which has the risk of overrunning */
	RastPort = &DeepRastPort;
	InitRastPort(RastPort);
	RastPort->BitMap = &BitMap;
    }
    OldFont = RastPort->Font;
    SetFont(RastPort, Font);
    SetAPen(RastPort, 1);
    SetBPen(RastPort, 0);
    SetDrMd(RastPort, JAM2);

#if 0
    /* testing stuff: */
    {
	int i;

	for (i = 0; i < Font->tf_HiChar-Font->tf_LoChar+1; i++)
	    printf("%d data %08lx space %04x kern %04x\n",
		i + Font->tf_LoChar,
		*((long *)Font->tf_CharLoc + i),
		*((short *)Font->tf_CharSpace + i),
		*((short *)Font->tf_CharKern + i)
		);
    }
#endif
}

/*
 * Clean up system stuff in case of exit
 */
void
cleanup(void)
{
    if (Font) {
	if ((Font->tf_Style & FSF_COLORFONT) && PlanePick != -1) {
	    struct ColorTextFont *ctf = (struct ColorTextFont *)Font;

	    ctf->ctf_PlanePick = PlanePick;
	}
	SetFont(RastPort, OldFont);
	CloseFont(Font);
    }
    if (Window) {
	CloseWindow(Window);
    }
    if (GfxBase) {
	int		i;

	for (i = 0; i < BitMap.Depth; i++) {
	    if (BitMap.Planes[i]) {
		FreeRaster(BitMap.Planes[i], RASTERWIDTH, BitMap.Rows);
		BitMap.Planes[i] = NULL;
	    }
	}
	CloseLibrary(GfxBase);
    }
    if (IntuitionBase) {
	CloseLibrary(IntuitionBase);
    }
    if (DiskFontBase) {
	CloseLibrary(DiskFontBase);
    }
    if (UtilityBase) {
	CloseLibrary(UtilityBase);
    }
}

void
header(void)
{
    printf("{********************************\n");
    printf("*                               *\n");
    printf("*   Generated by BMFD 1.00      *\n");
    printf("*                               *\n");
    printf("*    (C) Copyright 1993 by      *\n");
    printf("*   Olaf 'Rhialto' Seibert      *\n");
    printf("*                               *\n");
    printf("********************************}\n");
    printf("\n");
}

void
dumpparameters(void)
{
    /* For all fonts: */

    printf("bitmapfont %s %d;\n\n",
	    Font->tf_Message.mn_Node.ln_Name, Font->tf_YSize);

    printf("baseline %d;\n",      Font->tf_Baseline);
    printf("bold %d;\n",         (Font->tf_Style & FSF_BOLD) != 0);
    printf("boldsmear %d;\n",     Font->tf_BoldSmear);
    printf("extended %d;\n",     (Font->tf_Style & FSF_EXTENDED) != 0);
    printf("{ designed %d; }\n", (Font->tf_Flags & FPF_DESIGNED) != 0);
    printf("italic %d;\n",       (Font->tf_Style & FSF_ITALIC) != 0);
    printf("proportional %d;\n", (Font->tf_Flags & FPF_PROPORTIONAL) != 0);
    if (Font->tf_Flags & FPF_DISKFONT) {
	struct DiskFontHeader *df;
	unsigned short *code;

	df = (char *)Font - offsetof(struct DiskFontHeader, dfh_TF);
	code = (unsigned short *)df - 2;

	printf("returncode %d;\n", *code & 0xFF);
	printf("revision %d;\n", df->dfh_Revision);
    } else {
	printf("returncode 100;\n");
	printf("{ no revision } \n");
    }
    printf("revpath %d;\n", (Font->tf_Flags & FPF_REVPATH) != 0);
    printf("talldot %d;\n", (Font->tf_Flags & FPF_TALLDOT) != 0);
    printf("underlined %d;\n", (Font->tf_Style & FSF_UNDERLINED) != 0);
    printf("widedot %d;\n", (Font->tf_Flags & FPF_WIDEDOT) != 0);
    printf("xsize %d;\n", Font->tf_XSize);

    /* For fonts with a TextFontExtension: */

    if (UtilityBase) {
	struct TagItem *tag;
	struct TextFontExtension *te;

	printf("\n");

	te = (void *)Font->tf_Extension;
	if (te->tfe_MatchWord == 0x4E1B &&
	    te->tfe_BackPtr == Font) {

	    printf("{ Font has TextFontExtension; magic word is $%x }\n", te->tfe_MatchWord);
	    if (tag = FindTagItem(TA_DeviceDPI, te->tfe_Tags)) {
		printf("xydpi %d %d;\n",
			tag->ti_Data >> 16,
			tag->ti_Data & 0xFFFF);
	    }
	}
    } else
	printf("{ Font has no TextFontExtension because it's only 1.2/1.3. }\n");

    /* For color fonts: */

    if (Font->tf_Style & FSF_COLORFONT) {
	struct ColorTextFont *ctf = (struct ColorTextFont *)Font;

	printf("\n");

	printf("{ ct_colorfont %d; }\n", (ctf->ctf_Flags & CT_COLORFONT) != 0);
	printf("greyfont %d;\n", (ctf->ctf_Flags & CT_GREYFONT) != 0);
	printf("antialias %d;\n", (ctf->ctf_Flags & CT_ANTIALIAS) != 0);

	{
	    struct ColorFontColors *cfc = ctf->ctf_ColorFontColors;
	    int 	    i;

	    if (cfc && cfc->cfc_Count) {
		printf("colors %d", cfc->cfc_Count);
		for (i = 0; i < cfc->cfc_Count; i++) {
		    printf(" $%03x", cfc->cfc_ColorTable[i]);
		}
		printf(";\n");
	    }
	}
	{
	    int 	    i;
	    int 	    colors;

	    colors = 1 << ctf->ctf_Depth;

	    for (i = 0; i < colors; i++) {
		printf("colorsym %c %d\n", ColorChars[i], i);
	    }
	}
	printf("depth %d;\n", ctf->ctf_Depth);
	printf("fgcolor %d;\n", ctf->ctf_FgColor);
	printf("high %d;\n", ctf->ctf_High);
	printf("low %d;\n", ctf->ctf_Low);
	printf("planeonoff %d;\n", ctf->ctf_PlaneOnOff);
	printf("planepick %d;\n", ctf->ctf_PlanePick);
	PlanePick = ctf->ctf_PlanePick;
	if (PlanePick != (1 << ctf->ctf_Depth) - 1) {
	    fprintf(stderr, "Warning: PlanePick temporarily modified!\n");
	    ctf->ctf_PlanePick = (1 << ctf->ctf_Depth) - 1;
	}
    }

    printf("\n\n");
}

void
dumpsomecharacters(int lo, int hi)
{
    char	    output[RASTERWIDTH + 1];
    unsigned char   ch;
    int 	    i, y;

    SetRast(RastPort, 0);
    Move(RastPort, 0, Font->tf_Baseline);

    /* Generate begin of command */
    printf("; glyph $%x $%x\n\n", lo, hi);
    printf("{");
    for (i = lo; i <= hi; i++) {
	printf("  $%x:  ", i);
    }
    printf("}\n\n");

    memset(output, '_', RASTERWIDTH);
    output[RASTERWIDTH] = '\0';

    if (lo == 0x100) {
	/* Try to get the default glyph) */
	if (Font->tf_LoChar > 0)
	    lo = Font->tf_LoChar - 1;
	else if (Font->tf_HiChar < 255)
	    lo = Font->tf_HiChar + 1;
	else
	    printf("{ No default glyph needed }\n");
	hi = lo;
    }

    /* plot text in RastPort */
    for (i = lo; i <= hi; i++) {
	ch = i;
	Text(RastPort, &ch, 1);
	if (output[RastPort->cp_x] == ' ') {
	    printf("nullglyph $x $x\n", i, i);
	    fprintf(stderr, "nullglyph $x\n", i);
	}

	if (RastPort->cp_x >= RASTERWIDTH - 1) {
	    fprintf(stderr,
"Characters too wide; use -l<n> to specify fewer than %d characters per line.\n",
	    i - lo + 1);
	    exit(10);
	}
	output[RastPort->cp_x] = ' ';
	output[RastPort->cp_x+1] = ' ';
	Move(RastPort, RastPort->cp_x + 2, RastPort->cp_y);
    }

    /* Show off, if needed... */
    if (RastPort == &DeepRastPort)
	CopySBitMap(Window->RPort->Layer);

    /* Convert to printable */
    output[RastPort->cp_x - 2] = '\0';

    for (y = 0; y < Font->tf_YSize; y++) {
	for (i = 0; output[i]; i++) {
	    if (output[i] != ' ') {
		ch = ReadPixel(RastPort, i, y);
		output[i] = ColorChars[ch];
	    }
	}
	printf("%s\n", output);
	if (stretch)
	    printf("%s\n", output);
    }
    printf("\n\n");
}

void
dumpcharacters(void)
{
    int 	    charsperline;
    int 	    c;
    int 	    cn;

    if (linelength)
	charsperline = linelength;
    else
	((charsperline = 64 / Font->tf_XSize) == 0) ? (charsperline = 1) : 0;


    for (c = Font->tf_LoChar; c <= Font->tf_HiChar; c = cn + 1) {
	cn = min(c + charsperline - 1, Font->tf_HiChar);
	dumpsomecharacters(c, cn);
    }

    printf("{ The default glyph: }\n\n");
    dumpsomecharacters(0x100, 0x100);
    printf(";\n");
}

void
dupglyphdetect(void)
{
    int 	    i;
    int 	    j;
    ULONG	   *pi;
    ULONG	   *pj;
    UWORD	   *pw;
    int 	    numchars;
    int 	    output = 0;

    numchars = Font->tf_HiChar - Font->tf_LoChar + 2;

    for (i = 1; i < numchars; i++) {
	pi = (ULONG *)Font->tf_CharLoc + i;
	for (j = 0; j < i; j++) {
	    pj = (ULONG *)Font->tf_CharLoc +j;
	    if ((*pi == *pj) &&
		(!(pw = Font->tf_CharSpace) || pw[i] == pw[j]) &&
		(!(pw = Font->tf_CharKern) || pw[i] == pw[j])
	    ) {
		if (!output)
		    printf("\n{ Duplicate glyphs: }\n\n");
		printf("dupglyph $%x $%x;\n",
		       Font->tf_LoChar + j, Font->tf_LoChar + i);
		output++;
		break;
	    }
	}
    }
    if (output)
	printf("\n");
}

int
main(int argc, char **argv)
{
    extern char    *optarg;
    extern int	    optind;
    extern int	    getopt(int, char **, char *);
    int 	    errflg = 0;
    int 	    c;

    while ((c = getopt(argc, argv, "f:l:svx:y:")) != -1) {
	switch (c) {
	case 'f':
	    TextAttr.tta_Name = optarg;
	    break;
	case 'l':
	    linelength = atoi(optarg);
	    break;
	case 's':
	    stretch = TRUE;
	    break;
	case 'v':
	    verbose = TRUE;
	    break;
	case 'x':
	    {
		int x, y;
		sscanf(optarg, "%d/%d", &x, &y);
		TextTags[0].ti_Tag = TA_DeviceDPI;
		TextTags[0].ti_Data = (x << 16) | (y & 0xFFFF);
	    }
	    break;
	case 'y':
	    TextAttr.tta_YSize = atoi(optarg);
	    break;
	case '?':
	    errflg++;
	    break;
	}
    }

    if (optind < argc)
	TextAttr.tta_Name = argv[optind++];
    if (optind < argc)
	TextAttr.tta_YSize = atoi(argv[optind++]);

    if (errflg || optind > argc) {
	printf(
"Usage: bmfd -l<linelen> -x<xdpi>/<ydpi> name.font ysize\n");
	exit(EXIT_FAILURE);
    }

    atexit(cleanup);
    openall();

    header();
    dumpparameters();
    dumpcharacters();
    dupglyphdetect();

fail:
    /* atexit function cleans up here */
}
