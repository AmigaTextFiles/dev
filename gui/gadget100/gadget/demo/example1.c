#include <pragma/exec_lib.h>
#include <intuition/intuition.h>
#include <pragma/intuition_lib.h>
#include <libraries/Gadget.h>
#include <pragma/Gadget_lib.h>

void main(void);
void Error(char *);
void CloseAll(void);

struct NewWindow NewWindow =
{
   10, 10, 300, 200,
   AUTOFRONTPEN, AUTOBACKPEN,
	CLOSEWINDOW | GAD_IDCMPFlags,
	WFLG_CLOSEGADGET | WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_SIZEGADGET | WFLG_ACTIVATE,
   NULL,
   NULL,
   (UBYTE *)"gadget.library example 1",
   NULL,
   NULL,
   100, 50, -1, -1,
   WBENCHSCREEN,
};

struct IntuitionBase *IntuitionBase = NULL;
struct Library *GadgetBase = NULL;

struct Window *window = NULL;
struct IntuiMessage *imsg;
LONG class;

/*
** Callback function which is called when the user plays with a
** scroller gadget.
*/

static void propout(struct Gadget *gad, struct Window *w, struct Requester *req, struct gadScrollerInfo *pgi, ULONG class)
{
	printf("Gadget: %p, Window: %p, Req: %p, Special: %p, value: %d\n",
	gad, w, req, pgi, pgi->top);
}

/*
** Main
*/

void main()
{
   struct Gadget *gad;

	if(!(IntuitionBase = (struct IntuitionBase *)
	OpenLibrary((UBYTE *)"intuition.library", 0L)))
   	Error("No intuition.library V36!");
	if(!(GadgetBase = OpenLibrary((UBYTE *)"gadget.library", 38L)))
		Error("No gadget.library V38");

	if(!(gad = gadAllocGadget(GAD_SCROLLER_KIND,
   	GA_RelRight, -17L,
	   GA_Top, 11L,
		GA_RelHeight, -11L -10L,
		GA_Previous, &NewWindow.FirstGadget,
		GA_RightBorder, 1L,
		PGA_Freedom, (LONG)FREEVERT,
		GADSC_Total, 10L,
		GADSC_Visible, 7L,
		GADSC_Top, 2L,
		GADSC_NewLook, 1L,
		GAD_CallBack, propout,
		TAG_END)) ||
	!(gad = gadAllocGadget(GAD_SCROLLER_KIND,
		GA_Left, 0L,
		GA_RelBottom, -9L,
		GA_RelWidth, -18L,
		GA_Previous, &gad->NextGadget,
		GA_BottomBorder, 1L,
		PGA_Freedom, (LONG)FREEHORIZ,
		GADSC_Total, 20L,
		GADSC_Visible, 10L,
		GADSC_Top, 10L,
		GADSC_NewLook, 1L,
		GAD_CallBack, propout,
		TAG_END)))
         Error("Can't create gadgets");

   if(!(window = OpenWindow(&NewWindow)))
  	   Error("No Window");

	FOREVER
	{
		if(!(imsg = (struct IntuiMessage *)GetMsg(window->UserPort)))
		{
			Wait(1L << window->UserPort->mp_SigBit);
			continue;
		}
	   class = imsg->Class;

		gadFilterMessage(imsg, 0);    /* let gadget.library examine the
                                       message */
  		ReplyMsg((struct Message *)imsg);

	   if(class == CLOSEWINDOW)
			break;
	}

	CloseAll();
	exit(0);
}

void Error(char *text)
{
   puts(text);
	CloseAll();
	exit(1);
}

void CloseAll(void)
{
	if(window)
		CloseWindow(window);
	if(NewWindow.FirstGadget)
		gadFreeGadgetList(NewWindow.FirstGadget);

	if(GadgetBase)
		CloseLibrary(GadgetBase);
	if(IntuitionBase)
		CloseLibrary((struct Library *)IntuitionBase);
}

