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
   10, 10, 300, 160,
   AUTOFRONTPEN, AUTOBACKPEN,
	CLOSEWINDOW | GAD_IDCMPFlags,
	WFLG_CLOSEGADGET | WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_ACTIVATE,
   NULL,
   NULL,
   (UBYTE *)"gadget.library example 5",
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

BYTE *cyclabels[]=
{
	"January", "February", "March", "April", "May", "June",
   "July", "August", "September", "October", "November", "December",
   NULL,
};

BYTE *mxlabels[]=
{
	"_8 Bit", "_7 Bit", "_6 Bit", "_other", NULL,
};

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

	if(!(gad = gadAllocGadget(GAD_CYCLE_KIND,
   	GA_Left,       100L,
		GA_Top,        20L,
      GA_Text,       "C_ycle",
		GADCYC_Labels, cyclabels,
		GADCYC_Active, 1L,
		GA_Previous,   &NewWindow.FirstGadget,
		TAG_DONE)) ||
	!(gad = gadAllocGadget(GAD_MX_KIND,
		GA_Left,       100L,
		GA_Top,        50L,
		GA_Previous,   &gad->NextGadget,
      GADMX_Labels,  mxlabels,
	   GADMX_Active,  2L,
      TAG_DONE)) ||
   !(gad = gadAllocGadget(GAD_PALETTE_KIND,
      GA_Left,       100L,
		GA_Top,        120L,
		GA_Width,      100L,
		GA_Height,     18L,
		GA_Previous,   &gad->NextGadget,
		GA_Text,       "_Color",
		GADPA_Depth,   2L,
		GADPA_ColorOffset, 1L,
     	GADPA_IndicatorWidth, 36L,
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

