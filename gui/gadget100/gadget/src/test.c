#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/exec_protos.h>
#include <intuition/intuition.h>

#include "Gadget.h"
#define RETURN 13

#ifdef LIBRARY
#include "Gadget_lib.h"
#else
#ifdef STATIC
#undef STATIC
#endif
#define STATIC
#endif

#define SetArgs(arg, Tag, Data) (arg).ti_Tag = Tag; (arg).ti_Data = (ULONG)Data;

struct TagItem args[20];

void main(void);
void Error(char *);
void CloseAll(void);

struct Library *UtilityBase = NULL, *GadgetBase = NULL, *GadToolsBase = NULL;
struct IntuitionBase *IntuitionBase = NULL;
struct Window *window = NULL;
struct IntuiMessage *imsg;
LONG class;
struct Gadget *first = NULL;

#define ANZNODES 100
struct List list;
struct Node node[ANZNODES];
BYTE text[ANZNODES][21];

int global;

STATIC void propout(struct Gadget *gad, struct Window *w, struct Requester *req, struct gadScrollerInfo *pgi, ULONG class)
{
/*	printf("Gadget: %p, Window: %p, Req: %p, Special: %p, Message: %lx\n",
	gad, w, req, special, class); */

	printf("global: %d\n", global++);
}

STATIC void arrowout(struct Gadget *gad, struct Window *w, struct Requester *req, struct gadScrollerInfo *pgi, ULONG class)
{
	printf("%08lx\n", class);
}

BYTE *cyclabels[]=
{
	"Januar", "Februar", "März", "Wer", "das", "liest", "wird", "blöd", NULL
};

BYTE *mxlabels[]=
{
	"_8 Bit", "_7 Bit", "_6 Bit", "other", NULL,
};

struct Gadget *lv = NULL;

void boolcallback(struct Gadget *gad, struct Window *w, struct Requester *req)
{
	static LONG disable = 1L;

	gadSetGadgetAttrs(lv, w, req, GA_Disabled, disable = !disable, TAG_DONE);
}

void mxcallback(struct Gadget *gad, struct Window *w, struct Requester *req, struct gadMXInfo *mxi)
{
	printf("Active: %d\n", mxi->active);

	gadSetGadgetAttrs(gad, w, req, GADMX_Active, 3L, TAG_DONE);
}

void main()
{
	int i;
	struct IntuiText *it;
	struct Gadget *gad;

#ifdef LIBRARY
	if(!(IntuitionBase = (struct IntuitionBase *)
	OpenLibrary((UBYTE *)"intuition.library", 36L)))
   	Error("No intuition.library V36!");
	if(!(GadgetBase = OpenLibrary((UBYTE *)"gadget.library", 0L)))
		Error("No gadget.library");
#else
	if(!gadOpenGadget())
		Error("Cannot open gadget");
#endif

	NewList(&list);
	for(i=0; i<ANZNODES; i++)
   {
		AddTail(&list, &node[i]);
		node[i].ln_Name = text[i];
		sprintf(text[i], "Text %d", i);
	}

	if(!(1 &&
	(gad = gadAllocGadget(GAD_BOOL_KIND,
							GA_Left, 20L, GA_Top, 20L,
							GA_Width, 48L, GA_Height, 10L,
                     GA_Previous, &first,
							GAD_CallBack, boolcallback,
							TAG_DONE)) &&
/*	(gad = gadAllocGadget(GAD_BUTTON_KIND, GA_Left, 6L,
														GA_Top, 12L,
														GA_Width, 19L,
														GA_Height, 10L,
														GA_Text, "\\",
                                          GA_Previous,   &gad->NextGadget,
														GAD_ShortCut, (LONG)ESC,
                                          TAG_DONE)) &&
	(gad = gadAllocGadget(GAD_TEXT_KIND,
							GA_Left, 20L, GA_Top, 150L,
                     GA_Previous, &gad->NextGadget,
							GA_Text, "Test",
							TAG_DONE)) &&

	(gad = gadAllocGadget(GAD_ARROW_KIND,
							GA_Left, 20L, GA_Top, 40L,
                     GA_Previous, &gad->NextGadget,
							GAD_ShortCut, (LONG)'x',
							GAD_CallBack, arrowout,
							GADAR_Which, UPIMAGE,
							TAG_DONE)) &&
	(gad = gadAllocGadget(GAD_SCROLLER_KIND,
									GA_Left, 130L,
									GA_Top, 20L,
									GA_Height, 100L,
									GA_Previous, &gad->NextGadget,
									PGA_Freedom, (LONG)FREEVERT,
									GADSC_Total, 20L,
									GADSC_Visible, 5L,
									GADSC_Top, 10L,
									GADSC_NewLook, 1L,
									GAD_CallBack, propout,
									TAG_END)) &&

	(gad = gadAllocGadget(GAD_BUTTON_KIND,
									GA_Left, 160L,
									GA_Top, 60L,
									GA_Previous, &gad->NextGadget,
                           GA_Text, "Solo",
									GAD_ShortCut, RETURN,
									TAG_DONE)) &&

	(gad = gadAllocGadget(GAD_BUTTON_KIND,
									GA_Left, 160L,
									GA_Top, 90L,
									GA_Previous, &gad->NextGadget,
                           GA_Text, "_Quatsch",
									TAG_DONE)) &&

	(gad = gadAllocGadget(GAD_LISTVIEW_KIND,
									GA_Left, 20L,
									GA_Top, 30L,
									GA_Width, 150L,
									GA_Height, 100L,
									GADSC_NewLook, 1L,
									GA_Previous, &gad->NextGadget,
									GADLV_Labels, &list,
									GADLV_ShowSelected, NULL,
									TAG_DONE)) &&
	(gad = gadAllocGadget(GAD_GETFILE_KIND,
									GA_Left, 20L,
									GA_Top, 50L,
									GA_Previous, &gad->NextGadget,
									TAG_DONE)) &&
	(gad = gadAllocGadget(GAD_STRING_KIND,
									GA_Left, 40L,
									GA_Top, 50L,
									GA_Width, 100L,
									GA_Previous, &gad->NextGadget,
									TAG_DONE)) &&

	(gad = gadAllocGadget(GAD_CYCLE_KIND,
									GA_Left, 100L,
									GA_Top, 30L,
                           GA_Text, "Tes_t",
									GADCYC_Labels, cyclabels,
									GADCYC_Active, 1L,
									GA_Previous, &gad->NextGadget,
									TAG_DONE)) && */

   (gad = gadAllocGadget(GAD_PALETTE_KIND,
									GA_Left, 100L,
									GA_Top, 20L,
									GA_Width, 100L,
									GA_Height, 18L,
									GA_Previous, &gad->NextGadget,
									GA_Text, "_Color",
									GADPA_Depth, 2L,
									GADPA_ColorOffset, 1L,
                          	GADPA_IndicatorWidth, 36L,
									TAG_DONE))	&&

/*	(gad = gadAllocGadget(GAD_MX_KIND,
									GA_Left, 200L,
									GA_Top, 30L,
									GA_Previous, &gad->NextGadget,
                           GADMX_Labels, mxlabels,
									GADMX_Active, 2L,
									GAD_CallBack, mxcallback,
                           TAG_DONE)) && */

	(gad = gadAllocGadget(GAD_SCROLLER_KIND,
									GA_RelRight, -17L,
									GA_Top, 11L,
									GA_RelHeight, -11L -10L,
									GA_Previous, &gad->NextGadget,
									GA_RightBorder, 1L,
									PGA_Freedom, (LONG)FREEVERT,
									GADSC_Total, 20L,
									GADSC_Visible, 5L,
									GADSC_Top, 10L,
									GADSC_NewLook, 1L,
									GAD_CallBack, propout,
									TAG_END)) &&
	(gad = gadAllocGadget(GAD_SCROLLER_KIND,
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
									TAG_END)) &&
	1))
		Error("Can't allocate Gadgets");

	i = 0;
	SetArgs(args[i], WA_Title, "Gadget - Test"); i++;
   SetArgs(args[i], WA_Left, 20);	i++;
   SetArgs(args[i], WA_Top,20); i++;
   SetArgs(args[i], WA_Width, 300);	i++;
   SetArgs(args[i], WA_Height,160); i++;
	SetArgs(args[i], WA_IDCMP, IDCMP_CLOSEWINDOW | GAD_IDCMPFlags); i++;
	SetArgs(args[i], WA_Flags, REPORTMOUSE | WFLG_CLOSEGADGET | WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_SIZEGADGET); i++;
   SetArgs(args[i], WA_MinWidth, 100);	i++;
   SetArgs(args[i], WA_MinHeight,50); i++;
   SetArgs(args[i], WA_MaxWidth, -1);	i++;
   SetArgs(args[i], WA_MaxHeight,-1); i++;
	SetArgs(args[i], WA_Gadgets, first); i++;
	SetArgs(args[i], TAG_END, 0); i++;
   if(!(window = (struct Window *)OpenWindowTagList(NULL, args)))
		Error("No Window");

	{
		RefreshGList(first, window, NULL, -1L);
		FOREVER
		{
			if(!(imsg = (struct IntuiMessage *)GetMsg(window->UserPort)))
			{
				Wait(1L << window->UserPort->mp_SigBit);
				continue;
			}
			if(!gadFilterMessage(imsg, 0))
				class = imsg->Class;

    		ReplyMsg((struct Message *)imsg);

			if(class == CLOSEWINDOW)
				break;
		}
	}
   for(i=0; i<50; i++)
	   if(!(gad = gadAllocGadget(GAD_LISTVIEW_KIND,
									GA_Left, 20L,
									GA_Top, 30L,
									GA_Width, 150L,
									GA_Height, 100L,
									GADSC_NewLook, 1L,
									GA_Previous, &gad->NextGadget,
									GADLV_Labels, &list,
									GADLV_ShowSelected, NULL,
									TAG_DONE)))
         break;

ende:
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
		CloseWindow(window);	window = NULL;
	if(first)
		gadFreeGadgetList(first);

#ifdef LIBRARY
	if(GadgetBase)
		CloseLibrary(GadgetBase);
	if(IntuitionBase)
		CloseLibrary((struct Library *)IntuitionBase);	IntuitionBase = NULL;
#else
	gadCloseGadget();
#endif
}


