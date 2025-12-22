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
   10, 10, 250, 170,
   AUTOFRONTPEN, AUTOBACKPEN,
	CLOSEWINDOW | GAD_IDCMPFlags,
	WFLG_CLOSEGADGET | WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_ACTIVATE,
   NULL,
   NULL,
   (UBYTE *)"gadget.library example 3",
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

#define ANZNODES 100
struct List list;
struct Node node[ANZNODES];
BYTE text[ANZNODES][21];

/*
** Callback function which is called when the user plays with the
** listview gadget.
*/
static void listviewcallback(struct Gadget *gad, struct Window *w, struct Requester *req, struct gadListviewInfo *lvi, ULONG class)
{
	printf("Gadget: %p, Window: %p, Req: %p, Special: %p, selected: %d\n",
	gad, w, req, lvi, lvi->selected);
}

/*
** Main
*/
void main()
{
   struct Gadget *gad;
   int i;

	if(!(IntuitionBase = (struct IntuitionBase *)
	OpenLibrary((UBYTE *)"intuition.library", 0L)))
   	Error("No intuition.library V36!");
	if(!(GadgetBase = OpenLibrary((UBYTE *)"gadget.library", 38L)))
		Error("No gadget.library V38");

	NewList(&list);
	for(i=0; i<ANZNODES; i++)
   {
		AddTail(&list, &node[i]);
		node[i].ln_Name = text[i];
		sprintf(text[i], "Text %d", i);
	}

	if(!(gad = gadAllocGadget(GAD_LISTVIEW_KIND,
      GA_Left,       20L,
		GA_Top,        30L,
		GA_Width,      150L,
		GA_Height,     100L,
		GADSC_NewLook, 1L,
		GA_Previous,   &NewWindow.FirstGadget,
		GADLV_Labels,  &list,
		GADLV_ShowSelected, NULL,
      GAD_CallBack,  listviewcallback,
		TAG_DONE)))
      	Error("Can't allocate Gadgets");

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

