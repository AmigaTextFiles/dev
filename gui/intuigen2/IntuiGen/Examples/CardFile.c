#include <stddef.h>
#include <stdlib.h>
#include <exec/exec.h>	   /* These 4 files are system includes */
#include <intuition/intuition.h>
#include <IntuiGen/IntuiGen.h>
#include <IntuiGen/IGRequest.h>

/* APTR is defined as a void * */

APTR IntuitionBase,GfxBase;  /* These will be initialized to point to
				system library structures facilitating
				the use of system routines */

struct Person {   /* This is our data structure which we will be storing
			data IGRequest gets from the user into */
    struct Person *Next,*Prev;
    UBYTE	   Name[100],
		   Address[100],
		   CityStateZip[100];
    SHORT	   Age;
};

/* IGRequest uses information about the offsets of fields and field type
    that is supplied to it in the linked lists/trees of data structures
    passed to it
*/


/* struct Person is the data struct that will store the information typed
    into each card */

struct Remember *CardKey=0;  /* Remember keys are a convenient way to keep
			       track of allocated memory on the Amiga */

struct Person CardBase,*OnScreen=0;
BOOL QuitFlag=0;  /* BOOL is typedefed to ULONG (unsigned long) */

/* The preceding variable declarations are for management of the linked list
    used to store data, memory allocation, and deciding when it is time
    to terminate program execution
*/



void LoadStuff(struct IGRequest *,struct IntuiMessage *);
void SaveStuff(struct IGRequest *,struct IntuiMessage *);
void Quit     (struct IGRequest *,struct IntuiMessage *);

/* The preceding are function prototypes which describe functions that
    we will enter later, the return value they give, and the type
    of arguments they require.
*/

/*  Everything after this is IntuiGen generated */


/* for simplicity, and to save time, we will copy code from a finished version
    of this program to this file instead of manually typing it
*/

/* Note however that IntuiGen generated 905 lines of code (Line numbers
    are in the top left corner of the windows title bar)
*/

/* I just deleted out the old, incorrect code */
/* We just inserted the new, mostly correct version */
/* One small change to make... */

struct TextAttr TextAttributes0 =
{
	"topaz.font",
	TOPAZ_EIGHTY,
	NULL,
	FPF_ROMFONT
};

struct IntuiText ProjectItem3Text =
{
	0,1,
	JAM2,
	18,1,
	&TextAttributes0,
	(UBYTE *)"Quit",
	NULL
};

struct MenuItem ProjectItem3 =
{
	NULL,
	1,30,
	92,10,
	ITEMENABLED | ITEMTEXT | HIGHCOMP,
	0,
	(APTR)&ProjectItem3Text,
	NULL,
	0,
	NULL,
	0
};

struct IntuiText ProjectItem1Text =
{
	0,1,
	JAM2,
	18,1,
	&TextAttributes0,
	(UBYTE *)"Save",
	NULL
};

struct MenuItem ProjectItem1 =
{
	&ProjectItem3,
	1,10,
	92,10,
	ITEMENABLED | ITEMTEXT | HIGHCOMP,
	0,
	(APTR)&ProjectItem1Text,
	NULL,
	0,
	NULL,
	0
};

struct IntuiText ProjectItem0Text =
{
	0,1,
	JAM2,
	18,1,
	&TextAttributes0,
	(UBYTE *)"Load",
	NULL
};

struct MenuItem ProjectItem0 =
{
	&ProjectItem1,
	1,0,
	92,10,
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

SHORT CardFileBorderValues1[] = {0,124,0,0,425,0,424,1,1,1,1,123};

SHORT CardFileBorderValues2[] = {0,124,425,124,425,0,424,1,424,123,1,123};

struct Border CardFileBorderB2 =
{
	11,14,
	2,0,
	JAM1,
	6,
	CardFileBorderValues1,
	NULL
};

struct Border CardFileBorderB1 =
{
	11,14,
	1,0,
	JAM1,
	6,
	CardFileBorderValues2,
	&CardFileBorderB2
};

struct TextAttr TextAttributes1 =
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
	28,17,
	&TextAttributes1,
	(UBYTE *)"IntuiGen Generated Card File",
	NULL
};

struct IntuiText NewGadText1 =
{
	1,0,
	JAM2,
	30,3,
	&TextAttributes0,
	(UBYTE *)"Ne",
	NULL
};

struct TextAttr TextAttributes2 =
{
	"topaz.font",
	TOPAZ_EIGHTY,
	FSF_UNDERLINED,
	FPF_ROMFONT
};

struct IntuiText NewGadText2 =
{
	1,0,
	JAM2,
	46,3,
	&TextAttributes2,
	(UBYTE *)"w",
	&NewGadText1
};

SHORT NewGadValues1[] = {0,13,0,0,84,0,83,1,1,1,1,12};

SHORT NewGadValues2[] = {0,13,84,13,84,0,83,1,83,12,1,12};

struct Border NewGadB2 =
{
	0,0,
	2,0,
	JAM1,
	6,
	NewGadValues1,
	NULL
};

struct Border NewGadB1 =
{
	0,0,
	1,0,
	JAM1,
	6,
	NewGadValues2,
	&NewGadB2
};

struct Border NewGadSelectedB2 =
{
	0,0,
	1,0,
	JAM1,
	6,
	NewGadValues1,
	NULL
};

struct Border NewGadSelectedB1 =
{
	0,0,
	2,0,
	JAM1,
	6,
	NewGadValues2,
	&NewGadSelectedB2
};

struct IGBoolInfo NewGadIGInfo =
{
	GADG_BOOL,
	NULL,
	0,0,
	NULL,
	NULL,
	NULL,
	NULL,
	(UBYTE *)"New",
	NULL
};

struct Gadget NewGad =
{
	NULL,
	332,106,
	84,13,
	GFLG_GADGHIMAGE,
	GACT_RELVERIFY,
	GTYP_BOOLGADGET,
	(APTR)&NewGadB1,
	(APTR)&NewGadSelectedB1,
	&NewGadText2,
	NULL,
	NULL,
	2,
	(APTR)&NewGadIGInfo
};

struct IntuiText PreviousGadText1 =
{
	1,0,
	JAM2,
	10,3,
	&TextAttributes2,
	(UBYTE *)"P",
	NULL
};

struct IntuiText PreviousGadText2 =
{
	1,0,
	JAM2,
	18,3,
	&TextAttributes0,
	(UBYTE *)"revious",
	&PreviousGadText1
};

SHORT PreviousGadValues1[] = {0,13,0,0,84,0,83,1,1,1,1,12};

SHORT PreviousGadValues2[] = {0,13,84,13,84,0,83,1,83,12,1,12};

struct Border PreviousGadB2 =
{
	0,0,
	2,0,
	JAM1,
	6,
	PreviousGadValues1,
	NULL
};

struct Border PreviousGadB1 =
{
	0,0,
	1,0,
	JAM1,
	6,
	PreviousGadValues2,
	&PreviousGadB2
};

struct Border PreviousGadSelectedB2 =
{
	0,0,
	1,0,
	JAM1,
	6,
	PreviousGadValues1,
	NULL
};

struct Border PreviousGadSelectedB1 =
{
	0,0,
	2,0,
	JAM1,
	6,
	PreviousGadValues2,
	&PreviousGadSelectedB2
};

struct IGBoolInfo PreviousGadIGInfo =
{
	GADG_BOOL,
	NULL,
	0,0,
	NULL,
	NULL,
	NULL,
	NULL,
	(UBYTE *)"Previous",
	NULL
};

struct Gadget PreviousGad =
{
	&NewGad,
	247,106,
	84,13,
	GFLG_GADGHIMAGE,
	GACT_RELVERIFY,
	GTYP_BOOLGADGET,
	(APTR)&PreviousGadB1,
	(APTR)&PreviousGadSelectedB1,
	&PreviousGadText2,
	NULL,
	NULL,
	1,
	(APTR)&PreviousGadIGInfo
};

struct IntuiText NextGadText1 =
{
	1,0,
	JAM2,
	26,3,
	&TextAttributes0,
	(UBYTE *)"Ne",
	NULL
};

struct IntuiText NextGadText2 =
{
	1,0,
	JAM2,
	42,3,
	&TextAttributes2,
	(UBYTE *)"x",
	&NextGadText1
};

struct IntuiText NextGadText3 =
{
	1,0,
	JAM2,
	50,3,
	&TextAttributes0,
	(UBYTE *)"t",
	&NextGadText2
};

SHORT NextGadValues1[] = {0,13,0,0,84,0,83,1,1,1,1,12};

SHORT NextGadValues2[] = {0,13,84,13,84,0,83,1,83,12,1,12};

struct Border NextGadB2 =
{
	0,0,
	2,0,
	JAM1,
	6,
	NextGadValues1,
	NULL
};

struct Border NextGadB1 =
{
	0,0,
	1,0,
	JAM1,
	6,
	NextGadValues2,
	&NextGadB2
};

struct Border NextGadSelectedB2 =
{
	0,0,
	1,0,
	JAM1,
	6,
	NextGadValues1,
	NULL
};

struct Border NextGadSelectedB1 =
{
	0,0,
	2,0,
	JAM1,
	6,
	NextGadValues2,
	&NextGadSelectedB2
};

struct IGBoolInfo NextGadIGInfo =
{
	GADG_BOOL,
	NULL,
	0,0,
	NULL,
	NULL,
	NULL,
	NULL,
	(UBYTE *)"Next",
	NULL
};

struct Gadget NextGad =
{
	&PreviousGad,
	162,106,
	84,13,
	GFLG_GADGHIMAGE,
	GACT_RELVERIFY,
	GTYP_BOOLGADGET,
	(APTR)&NextGadB1,
	(APTR)&NextGadSelectedB1,
	&NextGadText3,
	NULL,
	NULL,
	0,
	(APTR)&NextGadIGInfo
};

struct IntuiText AgeGadText1 =
{
	1,0,
	JAM2,
	-42,0,
	&TextAttributes0,
	(UBYTE *)"A",
	NULL
};

struct IntuiText AgeGadText2 =
{
	1,0,
	JAM2,
	-34,0,
	&TextAttributes2,
	(UBYTE *)"g",
	&AgeGadText1
};

struct IntuiText AgeGadText3 =
{
	1,0,
	JAM2,
	-26,0,
	&TextAttributes0,
	(UBYTE *)"e:",
	&AgeGadText2
};

SHORT AgeGadValues1[] = {3,12,197,12,197,2,197,12,198,12,198,1,199,0,
		1,0,1,12,0,13,0,0};

SHORT AgeGadValues2[] = {197,1,3,1,3,11,3,1,2,1,2,12,1,13,
		199,13,199,1,200,0,200,13};

struct Border AgeGadB2 =
{
	-5,-3,
	2,0,
	JAM1,
	11,
	AgeGadValues1,
	NULL
};

struct Border AgeGadB1 =
{
	-5,-3,
	1,0,
	JAM1,
	11,
	AgeGadValues2,
	&AgeGadB2
};

struct IGStringInfo AgeGadIGInfo =
{
	GADG_STRING | STRING_SHORT | STRING_FILL | STRING_HIGHLIMIT |
	STRING_LOWLIMIT,
	NULL,
	NULL,
	offsetof (struct Person,Age),
	150,1,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	(UBYTE *)"Age:",
	NULL
};

struct StringInfo AgeGadInfo =
{
	0,0,0,5,0,0,0,0,0,0,0,0,0
};

struct Gadget AgeGad =
{
	&NextGad,
	180,80,
	192,10,
	GFLG_GADGHCOMP | GFLG_TABCYCLE,
	GACT_RELVERIFY | GACT_IMMEDIATE | GACT_LONGINT,
	GTYP_STRGADGET,
	(APTR)&AgeGadB1,
	NULL,
	&AgeGadText3,
	NULL,
	(APTR)&AgeGadInfo,
	3,
	(APTR)&AgeGadIGInfo
};

struct IntuiText CityStateZipGadText1 =
{
	1,0,
	JAM2,
	-146,0,
	&TextAttributes2,
	(UBYTE *)"C",
	NULL
};

struct IntuiText CityStateZipGadText2 =
{
	1,0,
	JAM2,
	-138,0,
	&TextAttributes0,
	(UBYTE *)"ity, State, Zip:",
	&CityStateZipGadText1
};

SHORT CityStateZipGadValues1[] = {3,12,197,12,197,2,197,12,198,12,198,1,199,0,
		1,0,1,12,0,13,0,0};

SHORT CityStateZipGadValues2[] = {197,1,3,1,3,11,3,1,2,1,2,12,1,13,
		199,13,199,1,200,0,200,13};

struct Border CityStateZipGadB2 =
{
	-5,-3,
	2,0,
	JAM1,
	11,
	CityStateZipGadValues1,
	NULL
};

struct Border CityStateZipGadB1 =
{
	-5,-3,
	1,0,
	JAM1,
	11,
	CityStateZipGadValues2,
	&CityStateZipGadB2
};

struct IGStringInfo CityStateZipGadIGInfo =
{
	GADG_STRING | STRING_FILL,
	NULL,
	NULL,
	offsetof (struct Person,CityStateZip),
	0,0,
	&AgeGad,
	NULL,
	NULL,
	NULL,
	NULL,
	(UBYTE *)"City, State, Zip:",
	NULL
};

struct StringInfo CityStateZipGadInfo =
{
	0,0,0,50,0,0,0,0,0,0,0,0,0
};

struct Gadget CityStateZipGad =
{
	&AgeGad,
	180,65,
	192,10,
	GFLG_GADGHCOMP | GFLG_TABCYCLE,
	GACT_RELVERIFY | GACT_IMMEDIATE,
	GTYP_STRGADGET,
	(APTR)&CityStateZipGadB1,
	NULL,
	&CityStateZipGadText2,
	NULL,
	(APTR)&CityStateZipGadInfo,
	2,
	(APTR)&CityStateZipGadIGInfo
};

struct IntuiText AddressGadText1 =
{
	1,0,
	JAM2,
	-74,0,
	&TextAttributes0,
	(UBYTE *)"A",
	NULL
};

struct IntuiText AddressGadText2 =
{
	1,0,
	JAM2,
	-66,0,
	&TextAttributes2,
	(UBYTE *)"d",
	&AddressGadText1
};

struct IntuiText AddressGadText3 =
{
	1,0,
	JAM2,
	-58,0,
	&TextAttributes0,
	(UBYTE *)"dress:",
	&AddressGadText2
};

SHORT AddressGadValues1[] = {3,12,197,12,197,2,197,12,198,12,198,1,199,0,
		1,0,1,12,0,13,0,0};

SHORT AddressGadValues2[] = {197,1,3,1,3,11,3,1,2,1,2,12,1,13,
		199,13,199,1,200,0,200,13};

struct Border AddressGadB2 =
{
	-5,-3,
	2,0,
	JAM1,
	11,
	AddressGadValues1,
	NULL
};

struct Border AddressGadB1 =
{
	-5,-3,
	1,0,
	JAM1,
	11,
	AddressGadValues2,
	&AddressGadB2
};

struct IGStringInfo AddressGadIGInfo =
{
	GADG_STRING | STRING_FILL,
	NULL,
	NULL,
	offsetof (struct Person,Address),
	0,0,
	&CityStateZipGad,
	NULL,
	NULL,
	NULL,
	NULL,
	(UBYTE *)"Address:",
	NULL
};

struct StringInfo AddressGadInfo =
{
	0,0,0,50,0,0,0,0,0,0,0,0,0
};

struct Gadget AddressGad =
{
	&CityStateZipGad,
	180,50,
	192,10,
	GFLG_GADGHCOMP | GFLG_TABCYCLE,
	GACT_RELVERIFY | GACT_IMMEDIATE,
	GTYP_STRGADGET,
	(APTR)&AddressGadB1,
	NULL,
	&AddressGadText3,
	NULL,
	(APTR)&AddressGadInfo,
	1,
	(APTR)&AddressGadIGInfo
};

struct IntuiText NameGadText1 =
{
	1,0,
	JAM2,
	-50,0,
	&TextAttributes0,
	(UBYTE *)"N",
	NULL
};

struct IntuiText NameGadText2 =
{
	1,0,
	JAM2,
	-42,0,
	&TextAttributes2,
	(UBYTE *)"a",
	&NameGadText1
};

struct IntuiText NameGadText3 =
{
	1,0,
	JAM2,
	-34,0,
	&TextAttributes0,
	(UBYTE *)"me:",
	&NameGadText2
};

SHORT NameGadValues1[] = {3,12,197,12,197,2,197,12,198,12,198,1,199,0,
		1,0,1,12,0,13,0,0};

SHORT NameGadValues2[] = {197,1,3,1,3,11,3,1,2,1,2,12,1,13,
		199,13,199,1,200,0,200,13};

struct Border NameGadB2 =
{
	-5,-3,
	2,0,
	JAM1,
	11,
	NameGadValues1,
	NULL
};

struct Border NameGadB1 =
{
	-5,-3,
	1,0,
	JAM1,
	11,
	NameGadValues2,
	&NameGadB2
};

struct IGStringInfo NameGadIGInfo =
{
	GADG_STRING | STRING_FILL,
	NULL,
	NULL,
	offsetof (struct Person,Name),
	0,0,
	&AddressGad,
	NULL,
	NULL,
	NULL,
	NULL,
	(UBYTE *)"Name:",
	NULL
};

struct StringInfo NameGadInfo =
{
	0,0,0,50,0,0,0,0,0,0,0,0,0
};

struct Gadget NameGad =
{
	&AddressGad,
	180,35,
	192,10,
	GFLG_GADGHCOMP | GFLG_TABCYCLE,
	GACT_RELVERIFY | GACT_IMMEDIATE,
	GTYP_STRGADGET,
	(APTR)&NameGadB1,
	NULL,
	&NameGadText3,
	NULL,
	(APTR)&NameGadInfo,
	0,
	(APTR)&NameGadIGInfo
};

struct Window *CardFileWindow;

struct NewWindow NewCardFileWindow =
{
	21,15,
	449,149,
	0,1,
	IDCMP_GADGETDOWN | IDCMP_GADGETUP | IDCMP_MENUPICK | IDCMP_RAWKEY,
	WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_SMART_REFRESH | WFLG_ACTIVATE,
	NULL,
	NULL,
	(UBYTE *)"IG Card File",
	NULL,
	NULL,
	449,149,
	449,149,
	WBENCHSCREEN
};

struct IGEndList CardRequestEndList[] =
{
	{ IDCMP_GADGETUP,0,0,&NewGad,NULL,NULL,1 },
	{ IDCMP_GADGETUP,0,0,&PreviousGad,NULL,NULL,1 },
	{ IDCMP_GADGETUP,0,0,&NextGad,NULL,NULL,1 },
	{ IDCMP_RAWKEY,51,8,NULL,NULL,NULL,1 },
	{ 0xffffffff,0,0,0,0,0 }
};

struct IGKeyCommand CardRequestCommands[] =
{
	{ 0,'w',0,&NewGad },
	{ 0,'p',0,&PreviousGad },
	{ 0,'x',0,&NextGad },
	{ 0,'g',0,&AgeGad },
	{ 0,'c',0,&CityStateZipGad },
	{ 0,'d',0,&AddressGad },
	{ 0,'a',0,&NameGad },
	{ 0, 0, 0, 0 }
};

struct IGMenu CardRequestIGMenuInfo[] =
{
	{ 63488, LoadStuff, (UBYTE *)"Project|ProjectItem0" },
{ 63520, SaveStuff, (UBYTE *)"Project|ProjectItem1" },
{ 63552, Quit, (UBYTE *)"Project|ProjectItem3" },
{ 0, 0, 0 }
};

struct IGRequest CardRequest =
{
	&NewCardFileWindow,		/* NewWindow */
	NULL,		/* Window */
	(UBYTE *)"Screen Title Here",           /* ScreenName */
	NULL,		/* RequesterToOpen */
	NULL,		/* Requester */
	CardRequestIGMenuInfo,		/* Menus */
	CardRequestEndList,		/* EndList */
	CardRequestCommands,		/* KeyCommands */
	&NameGad,		/* Gadgets */
	IG_ADDGADGETS | IG_RECORDWINDOWPOS,		/* Flags */
	&NameGad,		/* StringToActivate */
	&Project,		/* MenuStrip */
	&CardFileBorderB1,		/* Borders */
	NULL,		/* Images */
	&Title, 	/* ITexts */
	NULL,		/* SBoxes */
	NULL,		/* IGObjects */
	NULL,		     /* DataStruct */ /* This will be filled in in the main loop */
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



/* We are now at the bottom of the file.  We will import more code here. */

/* This is the end of IntuiGen generated code. */

void LoadStuff(struct IGRequest *x,struct IntuiMessage *y)
{
    puts ("Loadstuff");
}

void SaveStuff(struct IGRequest *x,struct IntuiMessage *y)
{
    puts ("SaveStuff");
}

void Quit(struct IGRequest *x,struct IntuiMessage *y)
{
    x->Terminate=1;
    QuitFlag=1;
}

/* The preceding functions are the finished versions of the functions
    we prototyped above.  For simplicity, no loading and saving code
    was written, when those menu items are chose, it will just print
    "LoadStuff" and "SaveStuff" respectively.
*/

BOOL NewCard ()
{
    struct Person *new;

    new=(void *)AllocRemember(&CardKey,sizeof(struct Person), MEMF_PUBLIC | MEMF_CLEAR);
    if (!new) return (1);
    if (OnScreen->Next) OnScreen->Next->Prev=new;
    new->Next=OnScreen->Next;
    new->Prev=OnScreen;
    OnScreen->Next=new;
    OnScreen=new;
    return (0);
}

/* The Preceding function allocates memory for a new "Card" and adds it
    to the linked list of cards */

main ()
{
    struct IGEndList *el;

    /* These two lines are necessary in order to use system library
	calls on the Amiga */

    IntuitionBase=OpenLibrary("intuition.library",0);
    GfxBase=OpenLibrary ("graphics.library",0);

    if (!IntuitionBase || !GfxBase) goto done;

    /* Here we open the window (The NewCardFileWindow structure
	was generated above by IntuiGen). */

    CardRequest.Window=OpenWindow (&NewCardFileWindow);
    if (!(CardRequest.Window)) goto done;

    /* Here we set up our linked list of cards */
    OnScreen=&CardBase;
    NewCard ();

    /* This is the main loop of our program which calls IGRequest
	to display the current card, will cycle to the next or previous
	cards if the user chooses gadgets that correspond to those
	functions, or will create a new card if the user chooses the
	"New Gadget"
    */

    while (!QuitFlag) {
	CardRequest.DataStruct=(APTR)OnScreen;
	el=IGRequest (&CardRequest); /* Note that we only
		have to pass IGRequest one top level structure
		which has pointers to all the other IntuiGen Generated
		structures that IGRequest requires to display the requester */

	if (el->Gadget==&NewGad) NewCard ();
	else if (el->Gadget==&NextGad && OnScreen->Next)
	    OnScreen=OnScreen->Next;
	else if (el->Gadget==&PreviousGad && OnScreen->Prev!=&CardBase)
	    OnScreen=OnScreen->Prev;
    }

    /* this is our cleaning up code.  It frees the memory, closes the window
	and closes the system libraries */
done:
    if (IntuitionBase) {
	FreeRemember (&CardRequest.ReqKey,1);
	FreeRemember (&CardKey,1);
	if (CardRequest.Window) CloseWindow (CardRequest.Window);
	CloseLibrary(IntuitionBase);
    }
    if (GfxBase) CloseLibrary(GfxBase);
}

/* This function, main, (which is where the program will start) initializes
   the global variables, handles the display of different cards,
   Calls NewCard to add additional cards to the linked list when
   necessary, and calls IGRequest.  IGRequest, part of the IntuiGen
   code, handles all the details of the user interface using the
   data stored in the IntuiGen functions generated above (by IntuiGen).
   This makes implementing something simple like a card file, truly simple
   as the user interface worries are already accounted for.

   We will now compile this module, and link it with IGRequest.o
*/






