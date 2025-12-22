;/*
cc GTCardFile.c GTRequest.c -o CTCardFile
stop
*/

#include <stddef.h>
#include <stdlib.h>
#include <exec/exec.h>	   /* These two files are system includes */
#include <intuition/intuition.h>
#include <libraries/GadTools.h>
#include <intuition/gadgetclass.h>
#include <IntuiGen/IntuiGen.h>
#include <IntuiGen/GTRequest.h>

APTR IntuitionBase,GfxBase,GadToolsBase;

struct Person {
    struct Person *Next,*Prev;
    UBYTE	   Name[100],
		   Address[100],
		   CityStateZip[100],
		   Phone[13];
};

/* struct Person is the data struct that will store the information typed
    into each card */

struct Remember *CardKey=0;

struct Person CardBase,*OnScreen=0;

/* The preceding variable declarations are for management of the linked list
    used to store data, memory allocation.
*/


/* Inserted 34 lines of code above */
/* The following is IntuiGen generated */

struct TextAttr TextAttributes0 =
{
	"topaz.font",
	TOPAZ_EIGHTY,
	NULL,
	FPF_ROMFONT
};

struct TagItem QuitGadTags[]=
{
	{  GT_Underscore,'_'  },
	{  TAG_DONE,0  }
};

struct NewGadget NewQuitGad=
{
	313,95,
	84,13,
	(UBYTE *)"_Quit",
	&TextAttributes0,
	3,
	0,
	0,
	0
};

struct MessageHandler QuitGadEndFillGadgetUp =
{
	NULL,
	"EndFillGadgetUp",
	NULL,
	NULL
};

struct GTControl QuitGad =
{
	NULL,
	BUTTON_KIND,
	INITFROMDATA | STOREDATA,
	QuitGadTags,
	NULL,
	&NewQuitGad,
	NULL,
	&QuitGadEndFillGadgetUp,
	'q',
	0,
	0,
	0,0,
	NULL,
	NULL,
	NULL,
	0,0,
	0,
	0,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL
};

struct TagItem PreviousGadTags[]=
{
	{  GT_Underscore,'_'  },
	{  TAG_DONE,0  }
};

struct NewGadget NewPreviousGad=
{
	228,95,
	84,13,
	(UBYTE *)"_Previous",
	&TextAttributes0,
	2,
	0,
	0,
	0
};

struct MessageHandler PreviousGadEndFillGadgetUp =
{
	NULL,
	"EndFillGadgetUp",
	NULL,
	NULL
};

struct GTControl PreviousGad =
{
	&QuitGad,
	BUTTON_KIND,
	INITFROMDATA | STOREDATA,
	PreviousGadTags,
	NULL,
	&NewPreviousGad,
	NULL,
	&PreviousGadEndFillGadgetUp,
	'p',
	0,
	0,
	0,0,
	NULL,
	NULL,
	NULL,
	0,0,
	0,
	0,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL
};

struct TagItem NextGadTags[]=
{
	{  GT_Underscore,'_'  },
	{  TAG_DONE,0  }
};

struct NewGadget NewNextGad=
{
	143,95,
	84,13,
	(UBYTE *)"Ne_xt",
	&TextAttributes0,
	1,
	0,
	0,
	0
};

struct MessageHandler NextGadEndFillGadgetUp =
{
	NULL,
	"EndFillGadgetUp",
	NULL,
	NULL
};

struct GTControl NextGad =
{
	&PreviousGad,
	BUTTON_KIND,
	INITFROMDATA | STOREDATA,
	NextGadTags,
	NULL,
	&NewNextGad,
	NULL,
	&NextGadEndFillGadgetUp,
	'x',
	0,
	0,
	0,0,
	NULL,
	NULL,
	NULL,
	0,0,
	0,
	0,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL
};

struct TagItem NewGadTags[]=
{
	{  GT_Underscore,'_'  },
	{  TAG_DONE,0  }
};

struct NewGadget NewNewGad=
{
	58,95,
	84,13,
	(UBYTE *)"Ne_w",
	&TextAttributes0,
	0,
	0,
	0,
	0
};

struct MessageHandler NewGadEndFillGadgetUp =
{
	NULL,
	"EndFillGadgetUp",
	NULL,
	NULL
};

struct GTControl NewGad =
{
	&NextGad,
	BUTTON_KIND,
	INITFROMDATA | STOREDATA,
	NewGadTags,
	NULL,
	&NewNewGad,
	NULL,
	&NewGadEndFillGadgetUp,
	'w',
	0,
	0,
	0,0,
	NULL,
	NULL,
	NULL,
	0,0,
	0,
	0,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL
};

struct TagItem PhoneGadTags[]=
{
	{  GT_Underscore,'_'  },
	{  GA_Immediate,1  },
	{  GTST_MaxChars,50  },
	{  STRINGA_Justification,GACT_STRINGLEFT  },
	{  TAG_DONE,0  }
};

struct NewGadget NewPhoneGad=
{
	150,68,
	192,14,
	(UBYTE *)"P_hone",
	&TextAttributes0,
	3,
	0,
	0,
	0
};

struct GTControl PhoneGad =
{
	&NewGad,
	STRING_KIND,
	INITFROMDATA | STOREDATA,
	PhoneGadTags,
	NULL,
	&NewPhoneGad,
	NULL,
	NULL,
	'h',
	0,
	0,
	0,0,
	NULL,
	offsetof(struct Person,Phone),
	FLD_STRINGINSTRUCT,
	50,0,
	0,
	0,
	GTST_String,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL
};

struct TagItem CityStateZipGadTags[]=
{
	{  GT_Underscore,'_'  },
	{  GA_Immediate,1  },
	{  GTST_MaxChars,50  },
	{  STRINGA_Justification,GACT_STRINGLEFT  },
	{  TAG_DONE,0  }
};

struct NewGadget NewCityStateZipGad=
{
	150,53,
	192,14,
	(UBYTE *)"_City, State, Zip",
	&TextAttributes0,
	2,
	0,
	0,
	0
};

struct GTControl CityStateZipGad =
{
	&PhoneGad,
	STRING_KIND,
	INITFROMDATA | STOREDATA,
	CityStateZipGadTags,
	NULL,
	&NewCityStateZipGad,
	NULL,
	NULL,
	'c',
	0,
	0,
	0,0,
	NULL,
	offsetof(struct Person,CityStateZip),
	FLD_STRINGINSTRUCT,
	50,0,
	0,
	0,
	GTST_String,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL
};

struct TagItem AddressGadTags[]=
{
	{  GT_Underscore,'_'  },
	{  GA_Immediate,1  },
	{  GTST_MaxChars,50  },
	{  STRINGA_Justification,GACT_STRINGLEFT  },
	{  TAG_DONE,0  }
};

struct NewGadget NewAddressGad=
{
	150,38,
	192,14,
	(UBYTE *)"_Address",
	&TextAttributes0,
	1,
	0,
	0,
	0
};

struct GTControl AddressGad =
{
	&CityStateZipGad,
	STRING_KIND,
	INITFROMDATA | STOREDATA,
	AddressGadTags,
	NULL,
	&NewAddressGad,
	NULL,
	NULL,
	'a',
	0,
	0,
	0,0,
	NULL,
	offsetof(struct Person,Address),
	FLD_STRINGINSTRUCT,
	50,0,
	0,
	0,
	GTST_String,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL
};

struct TagItem NameGadTags[]=
{
	{  GT_Underscore,'_'  },
	{  GA_Immediate,1  },
	{  GTST_MaxChars,50  },
	{  STRINGA_Justification,GACT_STRINGLEFT  },
	{  TAG_DONE,0  }
};

struct NewGadget NewNameGad=
{
	150,23,
	192,14,
	(UBYTE *)"_Name",
	&TextAttributes0,
	0,
	0,
	0,
	0
};

struct GTControl NameGad =
{
	&AddressGad,
	STRING_KIND,
	INITFROMDATA | STOREDATA,
	NameGadTags,
	NULL,
	&NewNameGad,
	NULL,
	NULL,
	'n',
	0,
	0,
	0,0,
	NULL,
	offsetof(struct Person,Name),
	FLD_STRINGINSTRUCT,
	50,0,
	0,
	0,
	GTST_String,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL
};

struct TagItem NewCardFileTags[]=
{
	{  WA_Left, 112  },
	{  WA_Top, 89  },
	{  WA_InnerWidth, 414  },
	{  WA_InnerHeight, 111	},
	{  WA_IDCMP,
		IDCMP_GADGETUP | IDCMP_RAWKEY  },
	{  WA_Title, "IntuiGen Card File"  },
	{  WA_MinWidth, 420  },
	{  WA_MinHeight, 124  },
	{  WA_MaxWidth, 420  },
	{  WA_MaxHeight, 124  },
	{  WA_AutoAdjust, 1  },
	{  WA_Flags,
		WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_SMART_REFRESH | WFLG_ACTIVATE  }
};


struct GTRequest CardRequest =
{
	NewCardFileTags,
	NULL,
	NULL,
	NULL,
	&NameGad,		/* Controls */
	INITFROMDATA | STOREDATA,		/* Flags */
	NULL,		/* RequestTags */
	NULL,		/* Borders */
	NULL,		/* Images */
	NULL,		/* ITexts */
	NULL,		/* InitFunc */
	0,
	NULL,
	NULL,		/* DataStruct */
	NULL,		/* EndFunction */
	NULL,		/* LoopFunction */
	0,0,		/* CallLoop, LoopBitsUsed */
	0,0,		/* AdditionalSignals, SignalFunction */
	NULL,		/* LocalMsgClassList */
	NULL,		/* LocalPKindCassList */
	NULL,		/* MsgHandlerList */
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL
};

/* Current line is 519 (in title bar above) */
/* End of IntuiGen generated code */

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
    IntuitionBase=OpenLibrary("intuition.library",36);
    GfxBase=OpenLibrary ("graphics.library",0);
    GadToolsBase=OpenLibrary("gadtools.library",0);

    if (!IntuitionBase || !GfxBase) goto done;

    CardRequest.Window=OpenWindowTagList (NULL,CardRequest.NewWindowTags);
    if (!(CardRequest.Window)) goto done;

    OnScreen=&CardBase;
    NewCard ();

    while (1) {
	CardRequest.DataStruct=(APTR)OnScreen;
	GTRequest (&CardRequest);
	if (!(CardRequest.Terminate)) break; /* If there is an error, break */
	else {
	    if (CardRequest.EndControl==&NewGad) NewCard ();
	    else if (CardRequest.EndControl==&NextGad && OnScreen->Next)
		OnScreen=OnScreen->Next;
	    else if (CardRequest.EndControl==&PreviousGad && OnScreen->Prev!=&CardBase)
		OnScreen=OnScreen->Prev;
	    else if (CardRequest.EndControl==&QuitGad) break;
	}
    }
done:
    if (IntuitionBase) {
	FreeRemember (&CardKey,1);
	if (CardRequest.Window) CloseWindow (CardRequest.Window);
	CloseLibrary(IntuitionBase);
    }
    if (GfxBase) CloseLibrary(GfxBase);
    if (GadToolsBase) CloseLibrary(GadToolsBase);
}

/* This function (which is where the program will start) initializes
   the global variables, handles the display of different cards,
   Calls NewCard to add additional cards to the linked list when
   necessary, and calls GTRequest.  GTRequest is part of the IntuiGen
   link time library code (These libraries could easily be made into system
   run time libraries) and handles all the details of the Intuition user
   interface using the data stored in the IntuiGen structures generated
   above (by IntuiGen). This makes implementing something simple like a
   card file, truly simple as the user interface worries are already
   accounted for.
*/


/* Current line is 589.  This means that the above inserted code is 70 lines
    long.
*/

/* the program is now ready to compile */

