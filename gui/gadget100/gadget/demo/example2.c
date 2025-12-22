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
   10, 10, 280, 120,
   AUTOFRONTPEN, AUTOBACKPEN,
	CLOSEWINDOW | GAD_IDCMPFlags,
	WFLG_CLOSEGADGET | WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_ACTIVATE,
   NULL,
   NULL,
   (UBYTE *)"gadget.library example 2",
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
** Callback function which is called when the user clicks into the
** bool gadget.
*/
static void boolcallback(struct Gadget *gad, struct Window *w, struct Requester *req)
{
   printf("bool\n");
}

/*
** Callback function which is called when the user clicks into the
** arrow gadget.
*/
static void arrowcallback(struct Gadget *gad, struct Window *w, struct Requester *req, struct gadScrollerInfo *pgi, ULONG class)
{
	printf("arrow\n");
}

/*
** Callback function which is called when the user clicks into the
** button gadget.
*/
static void buttoncallback(struct Gadget *gad, struct Window *w, struct Requester *req, struct gadScrollerInfo *pgi, ULONG class)
{
	printf("button\n");
}

/*
** Callback function which is called when the user clicks into the
** getfile gadget.
*/
static void getfilecallback(struct Gadget *gad, struct Window *w, struct Requester *req, struct gadScrollerInfo *pgi, ULONG class)
{
	printf("getfile\n");
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

	if(!(gad = gadAllocGadget(GAD_TEXT_KIND,
		GA_Left,       20L,
      GA_Top,        15L,
      GA_Previous,   &NewWindow.FirstGadget,
		GA_Text,       "Test",
		TAG_DONE))  ||
	!(gad = gadAllocGadget(GAD_BOOL_KIND,
   	GA_Left,       100L,
      GA_Top,        15L,
      GA_Width,      160,
      GA_Height,     14,
      GA_Previous,   &gad->NextGadget,
      GA_Text,      "Raw Bool Gadget",
		GAD_CallBack,  boolcallback,
		TAG_DONE)) ||
	!(gad = gadAllocGadget(GAD_ARROW_KIND,
		GA_Left,       20L,
      GA_Top,        40L,
      GA_Previous,   &gad->NextGadget,
		GAD_ShortCut,  (LONG)'x',
		GAD_CallBack,  arrowcallback,
		GADAR_Which,   UPIMAGE,
		TAG_DONE)) ||
	!(gad = gadAllocGadget(GAD_BUTTON_KIND,
		GA_Left,       100L,
		GA_Top,        40L,
		GA_Previous,   &gad->NextGadget,
      GA_Text,       "_Solo",
      GAD_CallBack,  buttoncallback,
      TAG_DONE)) ||
	!(gad = gadAllocGadget(GAD_GETFILE_KIND,
	   GA_Left,       20L,
		GA_Top,        75L,
		GA_Previous,   &gad->NextGadget,
      GAD_CallBack,  getfilecallback,
		TAG_DONE)))
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

