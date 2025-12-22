/*
** gadtools1.c:  Complex GadTools example.
**
** (C) Copyright 1990, Commodore-Amiga, Inc.
**
** Executables based on this information may be used in software
** for Commodore Amiga computers.  All other rights reserved.
** This information is provided "as is"; no warranties are made.  All
** use is at your own risk. No liability or responsibility is assumed.
**
*/

#include <exec/types.h>
#include <exec/memory.h>
#include <intuition/gadgetclass.h>
#include <utility/tagitem.h>
#include <clib/macros.h>
#include <string.h>
#include <stdio.h>

#include <libraries/gadtools.h>

#include <pragma/exec_lib.h>
#include <pragma/graphics_lib.h>
#include <pragma/intuition_lib.h>
#include <pragma/gadtools_lib.h>
#include <clib/alib_protos.h>

#include <graphics/gfxmacros.h>

#include <wbstartup.h>

extern struct Library *GadToolsBase;

/*------------------------------------------------------------------------*/

int main(void);
void bail_out(int code, STRPTR error);
BOOL HandleMenuEvent(UWORD code);
BOOL OpenFunc(UWORD code);
BOOL SaveFunc(UWORD code);
BOOL SaveAsFunc(UWORD code);
BOOL PrintFunc(UWORD code);
BOOL QuitFunc(UWORD code);
BOOL HandleMouseMove(struct Gadget *gad, UWORD code);
BOOL HandleGadgetEvent(struct Gadget *gad, UWORD code);
struct Gadget *CreateAllGadgets(struct Gadget **glistptr, 
    void *vi, UWORD topborder);

/*------------------------------------------------------------------------*/

/*/ Gadget defines of our choosing, to be used as GadgetID's: */

#define GAD_BUTTON	1
#define GAD_INTEGER	2
#define GAD_CHECKBOX1	3
#define GAD_CHECKBOX2	4
#define GAD_CYCLE	5
#define GAD_MX		6
#define GAD_SLIDER	7
#define GAD_SCROLLER	8
#define GAD_LVSTRING	9
#define GAD_LISTVIEW	10
#define GAD_PALETTE	11


/* Menu defines of our choosing, to be placed in the NewMenu's UserData
 * field:
 */
#define MENU_FOO_SET	1
#define MENU_FOO_CLEAR	2
#define MENU_FOO_TOGGLE	3
#define MENU_INCREASE	4
#define MENU_DECREASE	5
#define MENU_BY1	6
#define MENU_BY5	7
#define MENU_BY10	8
#define MENU_CONNECTED	9
#define MENU_NEVER	10

/* Since NewMenu.nm_UserData are supposed to be of type (void *), we
 * make this abbreviation do our casting.
 */

#define V(x) ((void *)x)

/*------------------------------------------------------------------------*/

/* Here we specify what we want our menus to contain: */

struct NewMenu mynewmenu[] =
{
    { NM_TITLE, "Project",	 0 , 0, 0, 0,},
    {  NM_ITEM, "Open...",	"O", 0, 0, OpenFunc,},
    {  NM_ITEM, "Save",		 0 , 0, 0, SaveFunc,},
    {  NM_ITEM, "Save As...",	0 , 0, 0, SaveAsFunc,},
    {  NM_ITEM, NM_BARLABEL,	 0 , 0, 0, 0,},
    {  NM_ITEM, "Print",	 0 , 0, 0, 0,},
    {   NM_SUB, "NLQ",		 0 , 0, 0, PrintFunc,},
    {   NM_SUB, "Draft",	 0 , 0, 0, PrintFunc,},
    {  NM_ITEM, NM_BARLABEL,	 0 , 0, 0, 0,},
    {  NM_ITEM, "Quit...",	"Q", 0, 0, QuitFunc,},

    { NM_TITLE, "Gadgets",	 0 , 0, 0, 0,},
    {  NM_ITEM, "Foo",		 0 , 0, 0, 0,},
    {   NM_SUB, "Set",		"S", 0, 0, V(MENU_FOO_SET),},
    {   NM_SUB, "Clear",	"C", 0, 0, V(MENU_FOO_CLEAR),},
    {   NM_SUB, "Toggle",	"T", 0, 0, V(MENU_FOO_TOGGLE),},
    {  NM_ITEM, "Slider",	 0 , 0, 0, 0,},
    {   NM_SUB, "Increase",	"I", 0, 0, V(MENU_INCREASE),},
    {   NM_SUB, "Decrease",	"D", 0, 0, V(MENU_DECREASE),},
    {   NM_SUB, NM_BARLABEL,	 0 , 0, 0, 0,},
    {   NM_SUB, "By 1s",	 0 , CHECKIT|CHECKED, ~0x0008, V(MENU_BY1),},
    {   NM_SUB, "By 5s",	 0 , CHECKIT, ~0x0010, V(MENU_BY5),},
    {   NM_SUB, "By 10s",	 0 , CHECKIT, ~0x0020, V(MENU_BY10),},
    {  NM_ITEM, "MX Gadgets",	 0 , 0, 0, 0,},
    {   NM_SUB, "Connected?",	 0 , CHECKIT|MENUTOGGLE, 0, V(MENU_CONNECTED),},
    {  NM_ITEM, "Not Me!",	 0 , NM_ITEMDISABLED, 0, V(MENU_NEVER)},

    {   NM_END, 0,		 0 , 0, 0, 0},
};

/*------------------------------------------------------------------------*/

struct NewWindow mynewwin =
{
    0, 0,		/* LeftEdge, TopEdge */
    600, 166,		/* Width, Height */
    -1, -1,             /* DetailPen, BlockPen */
    MENUPICK | MOUSEBUTTONS | GADGETUP | GADGETDOWN | MOUSEMOVE |
	CLOSEWINDOW | REFRESHWINDOW | INTUITICKS, /* IDCMPFlags */
    ACTIVATE | WINDOWDRAG | WINDOWSIZING | WINDOWDEPTH | WINDOWCLOSE |
	SIMPLE_REFRESH,	/* Flags */
    NULL,		/* FirstGadget */
    NULL,		/* CheckMark */
    "Fancy GadTools Demo",	/* Title */
    NULL,		/* Screen */
    NULL,		/* BitMap */    
    50, 50,	/* MinWidth, MinHeight */
    640, 200,	/* MaxWidth, MaxHeight */
    WBENCHSCREEN,	/* Type */
};

struct TextAttr Topaz80 =
{
    "topaz.font",	/* Name */
    8,			/* YSize */
    0,			/* Style */
    0,			/* Flags */
};

/*------------------------------------------------------------------------*/

STRPTR MonthLabels[] =
{
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
    NULL,
};

STRPTR DayLabels[] =
{
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
    NULL,
};

struct List lh;

/*------------------------------------------------------------------------*/

/* These are all the things to be allocated/opened, and later
 * freed/closed:
 */

struct GfxBase *GfxBase = NULL;
struct IntuitionBase *IntuitionBase = NULL;
struct Library *GadToolsBase = NULL;
struct TextFont *font = NULL;
struct Screen *mysc = NULL;
struct Remember *RKey = NULL;
struct Gadget *glist = NULL;
struct Menu *menu = NULL;
struct Window *mywin = NULL;
void *vi = NULL;

/*------------------------------------------------------------------------*/

BOOL terminated;

/*------------------------------------------------------------------------*/

/* We need the following information about individual gadgets to
 * demonstrate our ability to manipulate them with the GT_SetGadgetAttrs()
 * function:
 */

WORD sliderlevel = 7;
WORD incr = 1;
struct Gadget *integergad, *mxgad, *checkgad, *slidergad, *cyclegad,
    *lvgad, *stringgad;
BOOL foochecked = TRUE;
BOOL connected = FALSE;

#define SLIDER_MIN	0
#define SLIDER_MAX	49

/*------------------------------------------------------------------------*/

int main(void)
{
    struct IntuiMessage *imsg;
    struct Gadget *gad;
    ULONG imsgClass;
    UWORD imsgCode;
    UWORD topborder;

    terminated = FALSE;

    /* Open all libraries: */

    if (!(GfxBase = (struct GfxBase *)
	OpenLibrary("graphics.library", 36L)))
	bail_out(20, "Requires V36 graphics.library");

    if (!(IntuitionBase = (struct IntuitionBase *)
	OpenLibrary("intuition.library", 36L)))
	bail_out(20, "Requires V36 intuition.library");

    if (!(GadToolsBase = OpenLibrary("gadtools.library", 36L)))
	bail_out(20, "Requires V36 gadtools.library");

    /* Open topaz 8 font: */

    if (!(font = OpenFont(&Topaz80)))
	bail_out(20, "Failed to open font");

    if (!(mysc = LockPubScreen(NULL)))
	bail_out(20, "Couldn't lock default public screen");

    if (!(vi = GetVisualInfo(mysc,
	TAG_DONE)))
	bail_out(20, "GetVisualInfo() failed");

    topborder = mysc->WBorTop + (mysc->Font->ta_YSize + 1);

    /* Build and layout menus: */
    if (!(menu = CreateMenus(mynewmenu,
	GTMN_FrontPen, 0,
	TAG_DONE)))
	bail_out(20, "CreateMenus() failed");

    if (!LayoutMenus(menu, vi,
	TAG_DONE))
	bail_out(20, "LayoutMenus() failed");

    if (!CreateAllGadgets(&glist, vi, topborder))
    {
	bail_out(20, "CreateAllGadgets() failed");
    }

    /* I could equally well use the {WA_Gadgets, glist} TagItem */
    mynewwin.FirstGadget = glist;

    /* I've actually put the inner-height in mynewwin.Height, so
     * I'll override that value with a W_INNERHEIGHT:
     */
    /* Open the window: */
    if (!(mywin = OpenWindowTags(&mynewwin,
	WA_InnerHeight, mynewwin.Height,
	WA_AutoAdjust, TRUE,
	WA_PubScreen, mysc,
	TAG_DONE)))
	bail_out(20, "OpenWindow() failed");

    /* After window is open, we must call this GadTools refresh
     * function.
     */
    GT_RefreshWindow(mywin, NULL);

    SetMenuStrip(mywin, menu);

    while (!terminated)
    {
	Wait (1 << mywin->UserPort->mp_SigBit);
	/* GT_GetIMsg() returns a cooked-up IntuiMessage with
	 * more friendly information for complex gadget classes.  Use
	 * it wherever you get IntuiMessages:
	 */
	while ((!terminated) && (imsg = GT_GetIMsg(mywin->UserPort)))
	{
	    imsgClass = imsg->Class;
	    imsgCode = imsg->Code;
	    /* Presuming a gadget, of course, but no harm... */
	    gad = (struct Gadget *)imsg->IAddress;
	    /* Use the toolkit message-replying function here... */
	    GT_ReplyIMsg(imsg);
	    switch (imsgClass)
	    {
		case MENUPICK:
		    terminated = HandleMenuEvent(imsgCode);
		    break;

		case MOUSEMOVE:
		    terminated = HandleMouseMove(gad, imsgCode);
		    break;

		case GADGETUP:
		    printf("GADGETUP.  ");
		    terminated = HandleGadgetEvent(gad, imsgCode);
		    break;

		case GADGETDOWN:
		    printf("GADGETDOWN.  ");
		    terminated = HandleGadgetEvent(gad, imsgCode);
		    break;

		case CLOSEWINDOW:
		    printf("CLOSEWINDOW.\n");
		    terminated = TRUE;
		    break;

		case REFRESHWINDOW:
		    printf("REFRESHWINDOW.\n");
		    /* You must use GT_BeginRefresh() where you would
		     * normally have your first BeginRefresh()
		     */
		    GT_BeginRefresh(mywin);
		    GT_EndRefresh(mywin, TRUE);
		    break;
	    }
	}
    }
    bail_out(0, NULL);
return 0;
}

/*------------------------------------------------------------------------*/

/*/ bail_out()
 *
 * Function to close down or free any opened or allocated stuff, and then
 * exit.
 *
 */

void bail_out( int code, STRPTR error)
{

    if (mywin)
    {
	ClearMenuStrip(mywin);
	CloseWindow(mywin);
    }

    /* None of these three calls mind a NULL parameter, so it's not
     * necessary to check for non-NULL before calling.  If we do that,
     * we must be certain that the OpenLibrary() of GadTools succeeded,
     * or else we would be jumping into outer space:
     */
    if (GadToolsBase)
    {
	FreeMenus(menu);
	FreeVisualInfo(vi);
	FreeGadgets(glist);
	CloseLibrary(GadToolsBase);
    }

    if (mysc)
    {
	UnlockPubScreen(NULL, mysc);
    }

    if (RKey)
    {
	FreeRemember(&RKey, TRUE);
    }

    if (font)
    {
    	CloseFont(font);
    }


    if (IntuitionBase)
    {
	CloseLibrary( ( struct Library *)IntuitionBase);
    }

    if (GfxBase)
    {
	CloseLibrary( ( struct Library *)GfxBase);
    }

    if (error)
    {
	printf("Error: %s\n", error);
    }
    exit(code);
}


/*------------------------------------------------------------------------*/

/*/ HandleMenuEvent()
 *
 * This function handles IntuiMessage events of type MENUPICK.  It
 * demonstrates the two most common uses for the Menu UserData field
 * provided only by CreateMenus(), namely a place to store
 * pointers-to-functions (for menu # 0), or as a place to store a
 * constant to switch on (for menu # 1).
 *
 */

BOOL HandleMenuEvent( UWORD code)
{
    struct MenuItem *item;
    BOOL terminated = FALSE;

    printf("MENUPICK.  ");
    /* Get all menu events including NextEvents until a terminating
     * selection is made (such as Quit)
     */
    while ((code != MENUNULL) && (!terminated))
    {
	item = ItemAddress(menu, code);
	if (MENUNUM(code) != 0)
	{
	    /* I made menu #1's UserData into constants to switch on.
	     * Note that in C, switch demands an "int":
	     */
	    switch ( (int)MENU_USERDATA(item) )
	    {
	        case MENU_FOO_SET:
		    printf("Foo Set.  ");
		    /* Set the Foo checkbox */
		    GT_SetGadgetAttrs(checkgad, mywin, NULL,
			GTCB_Checked, TRUE,
			TAG_DONE);
		    foochecked = TRUE;
		    break;

		case MENU_FOO_CLEAR:
		    printf("Foo Clear.  ");
		    /* Clear the Foo checkbox */
		    GT_SetGadgetAttrs(checkgad, mywin, NULL,
			GTCB_Checked, FALSE,
			TAG_DONE);
		    foochecked = FALSE;
		    break;

		case MENU_FOO_TOGGLE:
		    printf("Foo Toggle.  ");
		    /* Toggle the foo checkbox */
		    foochecked = !foochecked;
		    GT_SetGadgetAttrs(checkgad, mywin, NULL,
			GTCB_Checked, foochecked,
			TAG_DONE);
		    break;

		case MENU_INCREASE:
		printf("Slider Increase.  ");
		    if (sliderlevel < SLIDER_MAX)
		    {
			sliderlevel += incr;
			if (sliderlevel > SLIDER_MAX)
			    sliderlevel = SLIDER_MAX;
			/* Move the slider */
			GT_SetGadgetAttrs(slidergad, mywin, NULL,
			    GTSL_Level, sliderlevel,
			    TAG_DONE);
		    }
		    break;

		case MENU_DECREASE:
		    printf("Slider Decrease.  ");
		    if (sliderlevel > SLIDER_MIN)
		    {
			sliderlevel -= incr;
			if (sliderlevel < SLIDER_MIN)
			    sliderlevel = SLIDER_MIN;
			/* Move the slider */
			GT_SetGadgetAttrs(slidergad, mywin, NULL,
			    GTSL_Level, sliderlevel,
			    TAG_DONE);
		    }
		    break;

		case MENU_BY1:
		    printf("Change Slider By 1's.  ");
		    incr = 1;
		    break;

		case MENU_BY5:
		    printf("Change Slider By 5's.  ");
		    incr = 5;
		    break;

		case MENU_BY10:
		    printf("Change Slider By 10's.  ");
		    incr = 10;
		    break;

		case MENU_CONNECTED:
		    printf("MX Gadgets Connected?");
		    connected = (item->Flags & CHECKED);
		    break;

		case MENU_NEVER:
		    /* As this item is disabled, this switch can
		     * never happen
		     */
		    printf("Can't Get Me!  ");
		    break;
	    }
	}
	/* There may be more menu selections to process */
	code = item->NextSelect;
    }
    printf("\n");

    return(terminated);
}


/*------------------------------------------------------------------------*/

/*/ OpenFunc()
 *
 * Function that prints out a message and returns.
 *
 */

BOOL OpenFunc( UWORD code)
{
    printf("Called Open Function.  ");
    return(FALSE);
}

/*/ SaveFunc()
 *
 * Function that prints out a message and returns.
 *
 */

BOOL SaveFunc( UWORD code)
{
    printf("Called Save Function.  ");
    return(FALSE);
}

/*/ SaveAsFunc()
 *
 * Function that prints out a message and returns.
 *
 */

BOOL SaveAsFunc( UWORD code)
{
    printf("Called SaveAs Function.  ");
    return(FALSE);
}

/*/ PrintFunc()
 *
 * Function that can tell which sub-item was selected, and print
 * different messages accordingly.
 *
 */

BOOL PrintFunc( UWORD code)
{
    printf("Called Print Function - ");
    if (SUBNUM(code) == 0)
	printf("NLQ.  ");
    else
	printf("Draft.  ");
    return(FALSE);
}

/*/ QuitFunc()
 *
 * Function that prints out a message and returns TRUE, which, by our
 * convention, signifies an action which should terminate the program.
 *
 */

BOOL QuitFunc( UWORD code)
{
    printf("Called Quit Function.  ");
    return(TRUE);
}

/*------------------------------------------------------------------------*/

/*/ HandleMouseMove()
 *
 * Function to handle MOUSEMOVE events.  For toolkit gadgets, such events
 * have a pointer to the gadget in the IAddress field of the IntuiMessage.
 * (This is not true for MOUSEMOVEs from Intuition gadgets in general).
 * This function could have been folded into HandleGadgetEvent().
 *
 */

BOOL HandleMouseMove( struct Gadget *gad,  UWORD code)
{
    BOOL terminated = FALSE;

    printf("MOUSEMOVE.  ");
    switch (gad->GadgetID)
    {
	case GAD_SLIDER:
	    /* Slider level is in code.  Note
	     * that level is a SIGNED word, while Code
	     * is a UWORD.  Casting it back to WORD
	     * gives you back the sign.  I know it's
	     * a bit ugly - I'll think about other
	     * ways.
	     */
	    printf("Slider Level: %d\n", (WORD)code);
	    sliderlevel = (WORD)code;
	    break;
	case GAD_SCROLLER:
	    /* Scroller level is in code: */
	    printf("Scroller Level: %d\n", code);
	    break;
    }
    return(terminated);
}


/*------------------------------------------------------------------------*/

/*/ HandleGadgetEvent()
 *
 * Function to handle a GADGETUP or GADGETDOWN event.  For toolkit gadgets,
 * it is possible to use this function to handle MOUSEMOVEs as well, with
 * little or no work.
 *
 */

BOOL HandleGadgetEvent( struct Gadget *gad, UWORD code)
{
    BOOL terminated = FALSE;

    switch (gad->GadgetID)
    {
	case GAD_BUTTON:
	    /* Buttons always report GADGETUP's, nothing
	     * fancy or different here
	     */
	    printf("Button 'ClickMe'.\n");
	    /* Demonstrating the ability to change the

	     * displayed value in an integer gadget, we do
	     * this on every click of this button:
	     */
	    GT_SetGadgetAttrs(integergad, mywin, NULL,
		GTIN_Number, 271828,
		TAG_DONE);
	    break;

	case GAD_INTEGER:
	    /* String/Integer gadgets report GADGETUP's,
	     * fancy or different here:
	     */
	    printf("Integer gadget: %ld.\n",
		((struct StringInfo *)gad->SpecialInfo)->LongInt);
	    break;

	case GAD_CHECKBOX1:
	    /* Checkboxes report GADGETUP's, nothing
	     * fancy or different here:
	     */
	    printf("Foo is ");
	    if (!(gad->Flags & SELECTED))
	    {
		foochecked = FALSE;
		printf("not ");
	    }
	    else
	    {
		foochecked = TRUE;
	    }
	    printf("selected.\n");
	    break;

	case GAD_CHECKBOX2:
	    printf("Bar is ");
	    if (!(gad->Flags & SELECTED))
		printf("not ");
	    printf("selected.\n");
	    break;

	case GAD_CYCLE:
	    /* Cycle gadgets report the number (0..n-1)
	     * of the new active label in the code
	     * field:
	     */
	    printf("Cycle: '%s'.\n", MonthLabels[code]);
	    /* Here we demonstrate the ability to set
	     * the active choice in a set of Mutually
	     * Exclusive gadgets:
	     */
	    if ((connected) && (code < 7))
		GT_SetGadgetAttrs(mxgad, mywin, NULL,
		    GTMX_Active, code,
		    TAG_DONE);
	    break;

	case GAD_MX:
	    /* MX gadgets report the number (0..n-1)
	     * of the new active label in the code
	     * field:
	     */
	    printf("MX: Day-of-week '%s'\n", DayLabels[code]);
	    /* Here we demonstrate the ability to set
	     * the active choice in an Cycle gadget:
	     */
	    if (connected)
		GT_SetGadgetAttrs(cyclegad, mywin, NULL,
		    GTCY_Active, code,
		    TAG_DONE);
	    break;

	case GAD_SLIDER:
	    /* Slider level is in code.  Note that
	     * level is a signed WORD, while Code is a
	     * UWORD.  Casting it back to WORD gives
	     * you back the sign.
	     */
	    printf("Slider Level: %d\n", (WORD)code);
	    sliderlevel = (WORD)code;
	    if ((sliderlevel >= 0) && (sliderlevel <= 12))
	    {
		GT_SetGadgetAttrs(lvgad, mywin, NULL,
		    GTLV_Selected, code,
		    TAG_DONE);
	    }
	    break;

	case GAD_SCROLLER:
	    /* Scroller level is in code: */
	    printf("Scroller Level: %d\n", code);
	    break;

	case GAD_PALETTE:
	    /* Palette's color is in code: */
	    printf("Palette:  selected color %d\n", code);
	    break;

	case GAD_LVSTRING:
	    /* String gadgets report GADGETUP's, nothing
	     * fancy or different here:
	     */
	    printf("LVString: '%s'.\n",
		((struct StringInfo *)gad->SpecialInfo)->Buffer);
	    break;

	case GAD_LISTVIEW:
	    /* ListView ordinal count is in code: */
	    printf("ListView: clicked on '%s'\n", MonthLabels[code]);
	    break;
    }
    return(terminated);
}


/*------------------------------------------------------------------------*/

/*/ CreateAllGadgets()
 *
 * Here is where all the initialization and creation of toolkit gadgets
 * take place.  This function requires a pointer to a NULL-initialized
 * gadget list pointer.  It returns a pointer to the last created gadget,
 * which can be checked for success/failure.
 *
 */

struct Gadget *CreateAllGadgets( struct Gadget **glistptr, void *vi, UWORD topborder)
{
    struct NewGadget ng;

    struct Gadget *gad;

    WORD index;
    struct Node *node;

    /* All the gadget creation calls accept a pointer to the previous
     * gadget, and link the new gadget to that gadget's NextGadget field.
     * Also, they exit gracefully, returning NULL, if any previous gadget
     * was NULL.  This limits the amount of checking for failure that
     * is needed.  You only need to check before you tweak any gadget
     * structure or use any of its fields, and finally once at the end,
     * before you add the gadgets.
     */

    /* We obligingly perform the following operation, required of
     * any program that uses the toolkit.  It gives the toolkit a
     * place to stuff context data:
     */
    gad = CreateContext(glistptr);
    /* Fill out a NewGadget structure to describe the gadget we want
     * to create:
     */
    /* Create a centered label (read-only) */
    ng.ng_LeftEdge = 300;
    ng.ng_TopEdge = 4+topborder;
    ng.ng_Width = 0;
    ng.ng_Height = 8;
    ng.ng_GadgetText = "Gadget Toolkit Test";
    ng.ng_TextAttr = &Topaz80;
    ng.ng_GadgetID = 0;
    ng.ng_Flags = PLACETEXT_IN | NG_HIGHLABEL;
    ng.ng_VisualInfo = vi;
    /* Text-Only gadget with GadgetText but no other text: */
    gad = CreateGadget(TEXT_KIND, gad, &ng,
	TAG_DONE);

    /* Since the NewGadget structure is unmodified by any of the
     * CreateGadget() calls, we need only change those fields which
     * are different.
     */
    ng.ng_LeftEdge = 10;
    ng.ng_TopEdge = 19+topborder;
    ng.ng_Width = 100;
    ng.ng_Height = 12;
    ng.ng_GadgetText = "ClickMe";
    ng.ng_GadgetID = GAD_BUTTON;
    ng.ng_Flags = 0;
    gad = CreateGadget(BUTTON_KIND, gad, &ng,
	TAG_DONE);

    ng.ng_LeftEdge = 400;
    ng.ng_Height = 14;
    ng.ng_GadgetText = "Month:";
    ng.ng_GadgetID = GAD_CYCLE;
    ng.ng_Flags = NG_HIGHLABEL;
    cyclegad = gad = CreateGadget(CYCLE_KIND, gad, &ng,
	GTCY_Labels, MonthLabels,
	GTCY_Active, 3,
	TAG_DONE);

    ng.ng_TopEdge = 69+topborder;
    ng.ng_LeftEdge = 70;
    ng.ng_GadgetText = "Foo:";
    ng.ng_GadgetID = GAD_CHECKBOX1;
    checkgad = gad = CreateGadget(CHECKBOX_KIND, gad, &ng,
	GTCB_Checked, foochecked,
	TAG_DONE);

    if (gad)
	ng.ng_TopEdge += gad->Height;

    ng.ng_GadgetText = "Bar:";
    ng.ng_GadgetID = GAD_CHECKBOX2;
    gad = CreateGadget(CHECKBOX_KIND, gad, &ng,
	GTCB_Checked, FALSE,
	TAG_DONE);

    ng.ng_TopEdge = 99+topborder;
    ng.ng_Width = 200;
    ng.ng_GadgetText = "Type:";
    ng.ng_GadgetID = GAD_INTEGER;
    integergad = gad = CreateGadget(INTEGER_KIND, gad, &ng,
	GTIN_Number, 54321,
	GTIN_MaxChars, 10,
	TAG_DONE);

    ng.ng_TopEdge = 117+topborder;
    ng.ng_Height = 12;
    ng.ng_GadgetText = "L:   ";
    ng.ng_GadgetID = GAD_SLIDER;
    slidergad = gad = CreateGadget(SLIDER_KIND, gad, &ng,
	GTSL_Min, SLIDER_MIN,
	GTSL_Max, SLIDER_MAX,
	GTSL_Level, sliderlevel,
	GTSL_LevelFormat, "%2ld",
	GTSL_LevelPlace, PLACETEXT_LEFT,
	GTSL_MaxLevelLen, 2,
	GA_IMMEDIATE, TRUE,
	GA_RELVERIFY, TRUE,
	TAG_DONE);

    ng.ng_TopEdge = 133+topborder;
    ng.ng_GadgetText = "Scroll:";
    ng.ng_GadgetID = GAD_SCROLLER;
    gad = CreateGadget(SCROLLER_KIND, gad, &ng,
	GTSC_Top, 5,
	GTSC_Total, 30,
	GTSC_Visible, 10,
	GTSC_Arrows, 13,
	GA_RELVERIFY, TRUE,
	TAG_DONE);

    ng.ng_TopEdge = 149+topborder;
    ng.ng_Height = 8;
    ng.ng_GadgetText = "Number:";
    gad = CreateGadget(NUMBER_KIND, gad, &ng,
	GTNM_Number, 314159,
	TAG_DONE);

    ng.ng_LeftEdge = 400;
    ng.ng_GadgetText = "Read:";
    gad = CreateGadget(TEXT_KIND, gad, &ng,
	GTTX_Text, "Read-Only Field!",
	TAG_DONE);

    ng.ng_LeftEdge = 470;
    ng.ng_TopEdge = 49+topborder;
    ng.ng_GadgetID = GAD_MX;
    mxgad = gad = CreateGadget(MX_KIND, gad, &ng,
	GTMX_Labels, DayLabels,
	GTMX_Active, 0,
	GTMX_Spacing, 4,
	TAG_DONE);

    NewList(&lh);
    index = 0;
    while (MonthLabels[index])
    {
	node = (struct Node *)AllocRemember(&RKey, sizeof(struct Node), MEMF_CLEAR);
	node->ln_Name = MonthLabels[index++];
 	AddTail(&lh, node);
    }

    /* Here's a string gadget to be attached to the listview: */
    ng.ng_Width = 150;
    ng.ng_Height = 14;
    ng.ng_GadgetText = NULL;
    ng.ng_GadgetID = GAD_LVSTRING;
    stringgad = gad = CreateGadget(STRING_KIND, gad, &ng,
	GTST_MaxChars, 50,
	TAG_DONE);

    ng.ng_LeftEdge = 130;
    ng.ng_TopEdge = 19+topborder;
    ng.ng_Width = 150;
    ng.ng_Height = 57;
    ng.ng_GadgetText = "Months:";
    ng.ng_GadgetID = GAD_LISTVIEW;
    ng.ng_Flags = NG_HIGHLABEL|PLACETEXT_LEFT;
    lvgad = gad = CreateGadget(LISTVIEW_KIND, gad, &ng,
	GTLV_Labels, &lh,
	GTLV_Top, 1,
	LAYOUTA_SPACING, 1,
	GTLV_ShowSelected, stringgad,
	GTLV_Selected, 3,
	GTLV_ScrollWidth, 18,
	TAG_DONE);

    ng.ng_LeftEdge = 320;
    ng.ng_TopEdge = 49+topborder;
    ng.ng_Width = 40;
    ng.ng_Height = 75;
    ng.ng_GadgetText = "Colors";
    ng.ng_GadgetID = GAD_PALETTE;
    ng.ng_Flags = NG_HIGHLABEL;

    gad = CreateGadget(PALETTE_KIND, gad, &ng,
	GTPA_Depth, mysc->BitMap.Depth,
	GTPA_Color, 1,
	GTPA_ColorOffset, 0,
	GTPA_IndicatorHeight, 15,
	TAG_DONE);

    return(gad);
}

/*------------------------------------------------------------------------*/
