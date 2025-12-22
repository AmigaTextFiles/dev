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
   10, 10, 300, 80,
   AUTOFRONTPEN, AUTOBACKPEN,
	CLOSEWINDOW | GAD_IDCMPFlags,
	WFLG_CLOSEGADGET | WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_ACTIVATE,
   NULL,
   NULL,
   (UBYTE *)"gadget.library example 4",
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

	if(!(gad = gadAllocGadget(GAD_STRING_KIND,
      GA_Left,       100L,
		GA_Top,        20L,
		GA_Width,      100L,
		GA_Previous,   &NewWindow.FirstGadget,
      GA_Text,       "String",
      GADSTR_TextVal,   "TextVal",
		TAG_DONE)) ||
   !(gad = gadAllocGadget(GAD_INTEGER_KIND,
      GA_Left,       100L,
      GA_Top,        40L,
      GA_Previous,   &gad->NextGadget,
      GA_Text,       "Integer",
      GADSTR_Min,    0L,
      GADSTR_Max,    999L,
      GADSTR_LongVal,   10L,
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

