#include <stddef.h>
#include <exec/exec.h>
#include <intuition/intuition.h>
#include <IntuiGen/IntuiGen.h>
#include <IntuiGen/IGRequest.h>
#include <IntuiGen/IGFR.h>

static USHORT UpArrowDataFast[] = {

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

static USHORT DownArrowDataFast[] = {

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

USHORT *UpArrowData,*DownArrowData;

BOOL GetChipData (void)
{
    UpArrowData=(USHORT *)AllocMem (44,MEMF_CHIP);
    DownArrowData=(USHORT *)AllocMem (44,MEMF_CHIP);

    if (!UpArrowData || !DownArrowData) return (0);

    CopyMem (UpArrowDataFast,UpArrowData,44);
    CopyMem (DownArrowDataFast,DownArrowData,44);

    return(1);
}

void FreeChipData (void)
{
    if (UpArrowData) FreeMem (UpArrowData,44);
    if (DownArrowData) FreeMem (DownArrowData,44);
}

APTR DosBase;
APTR IntuitionBase;

struct TextAttr TextAttributes0 =
{
	"topaz.font",
	TOPAZ_SIXTY,
	FSF_UNDERLINED | FSF_BOLD | FSF_ITALIC | FSF_EXTENDED,
	FPF_ROMFONT
};

struct IntuiText Title =
{
	1,0,
	JAM2,
	4,12,
	&TextAttributes0,
	(UBYTE *)"IntuiGen File Requester",
	NULL
};

struct Window *FileWindow;

struct NewWindow NewFileWindow =
{
	0,15,
	639,140,
	0,1,
	IDCMP_GADGETDOWN | IDCMP_GADGETUP | IDCMP_RAWKEY | IDCMP_DISKINSERTED | IDCMP_DISKREMOVED,
	WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_SMART_REFRESH | WFLG_ACTIVATE,
	NULL,
	NULL,
	(UBYTE *)"IG File Window",
	NULL,
	NULL,
	339,180,
	483,265,
	WBENCHSCREEN
};

struct IGFileRequest IGFileRequest = {
    5,12,"","",1,2,IGFR_OKCANCEL | IGFR_NOINFO | IGFR_CURRENTDIR,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
};

struct IGFileRequest IGFileRequest2 = {
    320,12,"","",1,2,IGFR_MULTISELECT | IGFR_NOINFO | IGFR_CURRENTDIR,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
};

struct IGObject FR2Obj = {
    MakeIGFileRequest,0,0,0,0,(APTR)&IGFileRequest2,0,0,0,0,0,0,0
};

struct IGObject FRObj = {
    MakeIGFileRequest,0,0,0,0,(APTR)&IGFileRequest,0,0,0,&FR2Obj,0,0,0
};

struct IGEndList FileRequestEndList[] =
{
	{ IDCMP_RAWKEY,51,8,NULL,NULL,NULL,0 },
	{ 0xffffffff,0,0,0,0,0 }
};

struct IGKeyCommand FileRequestCommands[] =
{
	{ 0, 0, 0, 0 }
};

struct IGMenu FileRequestIGMenuInfo[] =
{
	{ 0, 0, 0 }
};

struct IGRequest FileRequest =
{
	&NewFileWindow, 	/* NewWindow */
	NULL,		/* Window */
	(UBYTE *)"File Request",           /* ScreenName */
	NULL,		/* RequesterToOpen */
	NULL,		/* Requester */
	FileRequestIGMenuInfo,		/* Menus */
	FileRequestEndList,		/* EndList */
	FileRequestCommands,		/* KeyCommands */
	NULL,		/* Gadgets */
	IG_ADDGADGETS | IG_RECORDWINDOWPOS,		/* Flags */
	NULL,		/* StringToActivate */
	NULL,		/* MenuStrip */
	NULL,		/* Borders */
	NULL,		/* Images */
	NULL,		/* ITexts */
	NULL,		/* SBoxes */
	&FRObj, 	  /* IGObjects */
	NULL,		/* DataStruct */
	NULL,		/* ReqKey */
	NULL,		/* InitFunction */
	0,		/* Terminate */
	NULL,		/* IComPort */
	NULL,		/* InternalData */
	NULL,		/* DSelectFunction */
	NULL,		/* EndFunction */
	NULL,		/* LoopFunction */
	NULL,0, 	/* CallLoop, LoopBitsUsed */
	NULL,		/* ArexxPort */
	NULL,		/* ArexxFunction */
	0,NULL, 	/* AdditionalSignals, SignalFunction */
	NULL,		/* GUpFunction */
	NULL,		/* GDownFunction */
	NULL,		/* MouseButtons */
	NULL,		/* MouseMove */
	NULL,		/* DeltaMove */
	NULL,		/* RawKey */
	NULL,		/* IntuiTicks */
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

main ()
{
    struct IGDirEntry *e;

    DosBase=(APTR)OpenLibrary ("dos.library",0);
    IntuitionBase=(APTR)OpenLibrary ("intuition.library",0);

    if (GetChipData()) {

	IGRequest (&FileRequest);
	puts (IGFileRequest.FileName);
	puts (IGFileRequest2.FileName);
	for (e=IGFileRequest2.First;e;e=e->Next)
	    if (e->Flags & IGDE_SELECTED) printf ("\t%s\n",e->FileName,e->Flags);

	FreeRemember (&IGFileRequest2.DirKey,1);
	FreeRemember (&FileRequest.ReqKey,1);

	FreeChipData();
    }

    CloseLibrary (DosBase);
    CloseLibrary (IntuitionBase);
}
