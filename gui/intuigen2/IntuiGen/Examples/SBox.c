#include <stddef.h>
#include <stdlib.h>
#include <exec/exec.h>
#include <intuition/intuition.h>
#include <IntuiGen/IntuiGen.h>
#include <IntuiGen/IGRequest.h>
#include <IntuiGen/IGSBox.h>


ULONG OpenLibrary ();

ULONG IntuitionBase;
ULONG GfxBase;

void Quit ();
void AddCity ();


USHORT UpArrowData[] = {

	/* BitPlane 0 */

	0x0000,
	0x0004,
	0x0004,
	0x0304,
	0x0784,
	0x0CC4,
	0x1864,
	0x1024,
	0x0004,
	0x0004,
	0xFFFC,

	/* BitPlane 1 */

	0xFFFF,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x0000
};

USHORT DownArrowData[] = {

	/* BitPlane 0 */

	0x0000,
	0x0004,
	0x0004,
	0x1024,
	0x1864,
	0x0CC4,
	0x0784,
	0x0304,
	0x0004,
	0x0004,
	0xFFFC,

	/* BitPlane 1 */

	0xFFFF,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x0000
};

struct TextAttr TextAttributes0 =
{
	"topaz.font",
	TOPAZ_EIGHTY,
	NULL,
	FPF_ROMFONT
};

struct IntuiText ProjectItem0Text =
{
	0,1,
	JAM2,
	1,1,
	&TextAttributes0,
	(UBYTE *)"Quit",
	NULL
};

struct MenuItem ProjectItem0 =
{
	NULL,
	1,0,
	34,10,
	ITEMENABLED | ITEMTEXT | HIGHCOMP,
	0,
	(APTR)&ProjectItem0Text,
	NULL,
	0,
	NULL,
	0
};

struct Menu Project =
{
	NULL,
	2,0,
	60,10,
	MENUENABLED,
	(BYTE *)"Project",
	&ProjectItem0,
	0,0,0,0
};

struct Image SBoxScrollDownArrowImage =
{
	0,0,
	14,11,
	2,
	DownArrowData,
	3,0,
	NULL
};

struct IGPropArrowInfo SBoxScrollDownArrowGadIGInfo =
{
	GADG_ARROW,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL
};

struct Gadget SBoxScrollDownArrowGad =
{
	NULL,
	257,170,
	14,11,
	GFLG_GADGHCOMP | GFLG_GADGIMAGE,
	GACT_RELVERIFY | GACT_IMMEDIATE,
	GTYP_BOOLGADGET,
	(APTR)&SBoxScrollDownArrowImage,
	NULL,
	NULL,
	NULL,
	NULL,
	2,
	(APTR)&SBoxScrollDownArrowGadIGInfo
};

struct Image SBoxScrollUpArrowImage =
{
	0,0,
	14,11,
	2,
	UpArrowData,
	3,0,
	NULL
};

struct IGPropArrowInfo SBoxScrollUpArrowGadIGInfo =
{
	GADG_ARROW,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL
};

struct Gadget SBoxScrollUpArrowGad =
{
	&SBoxScrollDownArrowGad,
	257,158,
	14,11,
	GFLG_GADGHCOMP | GFLG_GADGIMAGE,
	GACT_RELVERIFY | GACT_IMMEDIATE,
	GTYP_BOOLGADGET,
	(APTR)&SBoxScrollUpArrowImage,
	NULL,
	NULL,
	NULL,
	NULL,
	1,
	(APTR)&SBoxScrollUpArrowGadIGInfo
};

struct SelectBox SBox =
{
	NULL,
	9,25,
	246,15,
	0,
	SB_TOGGLEONE,
	2,1,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	0,
	NULL,
	NULL,
	NULL,
	NULL
};

struct IGPropInfo SBoxScrollIGInfo =
{
	GADG_PROP,
	UpdateSBox,
	&SBox,
	&SBoxScrollUpArrowGad,&SBoxScrollDownArrowGad,
	0,0,
	0,15,
	0,0,
	NULL,
	NULL
};

WORD SBoxScrollKnobBuffer[4];

struct PropInfo SBoxScrollPropInfo =
{
	AUTOKNOB | FREEVERT,0,0,0x0800,0x0800,0,0,0,0,0,0
};

struct Gadget SBoxScroll =
{
	&SBoxScrollUpArrowGad,
	257,25,
	14,132,
	GFLG_GADGHNONE,
	GACT_RELVERIFY | GACT_IMMEDIATE,
	GTYP_PROPGADGET,
	(APTR)SBoxScrollKnobBuffer,
	NULL,
	NULL,
	NULL,
	(APTR)&SBoxScrollPropInfo,
	0,
	(APTR)&SBoxScrollIGInfo
};

struct Window *SBWindow;

struct NewWindow NewSBWindow =
{
	21,0,
	322,200,
	0,1,
	IDCMP_GADGETDOWN | IDCMP_GADGETUP | IDCMP_MENUPICK | IDCMP_RAWKEY |
	IDCMP_INTUITICKS,
	WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_SMART_REFRESH | WFLG_ACTIVATE,
	NULL,
	NULL,
	(UBYTE *)"Select Box Window",
	NULL,
	NULL,
	322,180,
	483,210,
	WBENCHSCREEN
};

struct IGEndList SBoxRequestEndList[] =
{
	{ IDCMP_RAWKEY,51,8,NULL,NULL,NULL,0 },
	{ 0xffffffff,0,0,0,0,0 }
};

struct IGKeyCommand SBoxRequestCommands[] =
{
	{ 0, 0, 0 }
};

struct IGMenu SBoxRequestIGMenuInfo[] =
{
	{ 63488, Quit }, { 0, 0 }
};

struct IGRequest SBoxRequest =
{
	&NewSBWindow,		/* NewWindow */
	NULL,		/* Window */
	"Select Box Example", /* ScreenName */
	NULL,		/* RequesterToOpen */
	NULL,		/* Requester */
	SBoxRequestIGMenuInfo,		/* Menus */
	SBoxRequestEndList,		/* EndList */
	SBoxRequestCommands,		/* KeyCommands */
	&SBoxScroll,		/* Gadgets */
	IG_ADDGADGETS,		    /* Flags */
	NULL,		/* StringToActivate */
	&Project,		/* MenuStrip */
	NULL,		/* Borders */
	NULL,		/* Images */
	NULL,		/* ITexts */
	&SBox,		 /* SBoxes */
	NULL,		/* IGObjects */
	NULL,		/* DataStruct */
	NULL,		/* ReqKey */
	NULL,		/* InitFunction */
	0,		/* Terminate */
	NULL,		/* IComPort */
	NULL,		/* InternalData */
	NULL,		/* DSelectFunction */
	NULL,		/* EndFunction */
	NULL,		/* LoopFunction */
	0,0,		/* CallLoop, LoopBitsUsed */
	NULL, NULL,	/* ArexxPort, ArexxFunction */
	0,NULL, 	/* AdditionalSignals, SignalFunction */
	NULL,		/* GUpFunction */
	NULL,		/* GDownFunction */
	NULL,		/* MouseButtons */
	NULL,		/* MouseMove */
	NULL,		/* DeltaMove */
	NULL,		/* RawKey */
	AddCity,	/* IntuiTicks */
	NULL,		/* DiskInserted */
	NULL,		/* DiskRemoved */
	NULL,		/* MenuVerify */
	NULL,		/* MenuPick */
	NULL,		/* SizeVerify */
	NULL,		/* NewSize */
	NULL,		/* ReqVerify */
	NULL,		/* ReqSet */
	NULL,		/* ReqClear */
	NULL,		/* ActiveWindow */
	NULL,		/* InActiveWindow */
	NULL,		/* RefreshWindow */
	NULL,		/* NewPrefs */
	NULL,		/* CloseWindow */
	NULL,		/* DoubleClick */
	NULL,		/* OtherMessages */
	NULL		/* UserData */
};

char *items[]={"New York","Chicago","Boston","Los Angeles",
	       "San Francisco","Philadelphia","Denver",
	       "Salt Lake City","Des Moines","Cincinatti",
	       "Santa Clara","Miami","London","Tokyo",
	       "Moscow","Berlin","Paris","Venice",
	       "Hong Kong","Kyoto","Prague","Portland",
	       "Reno","Austin","Mexico City","Vancouver",
	       "Barcelona","Calgary","Stolkholm","Constantinople",
	       "Petersburg","Chattanooga","Washington, D.C.",
	       "Nashville","Fairbanks","Anchorage","Baton Rouge",
	       "Jefferson City","Rome","Florence"};

	      /* 40 items */

void Quit (struct IGRequest *req,struct IntuiMessage *msg)
{
    SBoxRequest.Terminate=1;
}

void AddCity (struct IGRequest *req,struct IntuiMessage *msg)
{
    static USHORT i=0;

    AddEntryAlpha (&SBox,items[i],0);
    RefreshSBox (&SBoxRequest,&SBox);
    ++i;
    if (i==40)
	SBoxRequest.IntuiTicks=0;
}

main ()
{
    struct SelectBoxEntry *entry,*prev;

    IntuitionBase=OpenLibrary ("intuition.library",0);
    GfxBase=OpenLibrary ("graphics.library",0);

    IGRequest (&SBoxRequest);


    entry=SBox.Entries;
    while (entry) {
	prev=entry;
	entry=entry->Next;
	FreeSBEntry (prev);
    }

    CloseLibrary (IntuitionBase);
    CloseLibrary (GfxBase);
}


