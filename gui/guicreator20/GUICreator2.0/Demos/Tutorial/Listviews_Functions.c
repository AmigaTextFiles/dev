/*************************************************************************/
/*                                                                       */
/*   Includes                                                            */
/*                                                                       */
/*************************************************************************/

#include "Listviews_Includes.h"
#include "Listviews.h"

/*************************************************************************/
/*                                                                       */
/*   Variables and Structures                                            */
/*                                                                       */
/*************************************************************************/

extern struct IntuitionBase *IntuitionBase;
extern struct GfxBase       *GfxBase;

extern struct UtilityBase   *UtilityBase;

extern struct Library *GadToolsBase;
extern struct Library *AslBase;
extern struct Library *DataTypesBase;

/*************************************************************************/
/*                                                                       */
/*   Defines                                                             */
/*                                                                       */
/*************************************************************************/

#define RASTERX (((struct GfxBase *)GfxBase)->DefaultFont->tf_XSize)
#define RASTERY (((struct GfxBase *)GfxBase)->DefaultFont->tf_YSize)

#define XSIZE(x)  ((x)*RASTERX)
#define YSIZE(x)  ((x)*RASTERY)

#define XPOS(x)   (XSIZE(x)+customscreen->WBorLeft)
#define YPOS(x)   (YSIZE(x)+customscreen->BarHeight+1)

/*************************************************************************/
/*                                                                       */
/*   SleepWindow() und WakenWindow()                                     */
/*                                                                       */
/*************************************************************************/

static struct Requester waitrequest;

void SleepWindow(struct Window *win)
{
	InitRequester(&waitrequest);
	if (win->FirstRequest == NULL ) Request(&waitrequest,win);
	SetWindowPointer(win,WA_BusyPointer,1L,TAG_DONE);
}

void WakenWindow(struct Window *win)
{
	if (win->FirstRequest != NULL) EndRequest(&waitrequest,win);
	SetWindowPointer(win,WA_Pointer,0L,TAG_DONE);
}

/*************************************************************************/
/*                                                                       */
/*   GUIC_ErrorReport()                                                  */
/*                                                                       */
/*************************************************************************/

void GUIC_ErrorReport(struct Window *win,ULONG type)
{
	char error[256];
	struct EasyStruct easystruct = { sizeof(struct EasyStruct),0,"Caution:",NULL,"OK" };
	easystruct.es_TextFormat     = error;

	switch (type)
		{
		case ERROR_NO_WINDOW_OPENED:
			strcpy(error,"Could not open window (no memory?)");
			break;
		case ERROR_NO_PUBSCREEN_LOCKED:;
			strcpy(error,"Could not lock pubscreen");
			break;
		case ERROR_NO_GADGETS_CREATED:
			strcpy(error,"Could not create gadgets");
			break;
		case ERROR_NO_GADGETLIST_CREATED:
			strcpy(error,"Could not create gadgetlist");
			break;
		case ERROR_NO_VISUALINFO:
			strcpy(error,"Could not read visualinfo from screen");
			break;
		case ERROR_NO_PICTURE_LOADED:
			strcpy(error,"Could not read picture data");
			break;
		case ERROR_NO_WINDOW_MENU:
			strcpy(error,"Could not create menu");
			break;
		case ERROR_SCREEN_TOO_SMALL:
			strcpy(error,"This screen is too small for the window");
			break;
		case ERROR_LIST_NOT_INITIALIZED:
			strcpy(error,"The attached list is not initialized!");
			break;
		default:
			Fault(type,"Error",error,sizeof(error));
		}
	if (win && !win->FirstRequest)
		{
		SleepWindow(win);
		EasyRequestArgs(win,&easystruct,NULL,NULL);
		WakenWindow(win);
		}
	else EasyRequestArgs(win,&easystruct,NULL,NULL);
}

/*************************************************************************/
/*                                                                       */
/*   CreateBevelFrames()                                                 */
/*                                                                       */
/*************************************************************************/

void CreateBevelFrames(struct Window *win,APTR visualinfo,ULONG bevelcount,struct BevelFrame bevels[])
{
	ULONG i;
	for (i=0;i<bevelcount;i++)
		{
		DrawBevelBox(win->RPort,bevels[i].bb_LeftEdge,bevels[i].bb_TopEdge,bevels[i].bb_Width,bevels[i].bb_Height,GT_VisualInfo,(ULONG)visualinfo,GTBB_Recessed,TRUE,TAG_END);
		DrawBevelBox(win->RPort,bevels[i].bb_LeftEdge+2,bevels[i].bb_TopEdge+1,bevels[i].bb_Width-4,bevels[i].bb_Height-2,GT_VisualInfo,(ULONG)visualinfo,TAG_END);
		if (bevels[i].bb_Title)
			{
			char title[64];
			sprintf(title," %s ",bevels[i].bb_Title);
			Move(win->RPort,bevels[i].bb_LeftEdge+(bevels[i].bb_Width-XSIZE(strlen(title)))/2,bevels[i].bb_TopEdge+2);
			SetAPen(win->RPort,bevels[i].bb_Color);
			Text(win->RPort,title,strlen(title));
			}
		}
}

/*************************************************************************/
/*                                                                       */
/*   CreateLines()                                                       */
/*                                                                       */
/*************************************************************************/

void CreateLines(struct Window *win,int linecount,struct Line lines[])
{
	ULONG i;
	for (i=0;i<linecount;i++)
		{
		SetAPen(win->RPort,lines[i].li_Color);
		Move(win->RPort,lines[i].li_LeftEdge,lines[i].li_TopEdge);
		Draw(win->RPort,lines[i].li_Width>0?lines[i].li_LeftEdge+lines[i].li_Width-1:lines[i].li_LeftEdge+lines[i].li_Width,lines[i].li_Height>0?lines[i].li_TopEdge+lines[i].li_Height-1:lines[i].li_TopEdge+lines[i].li_Height);
		}
}

/*************************************************************************/
/*                                                                       */
/*   CreateTexts()                                                       */
/*                                                                       */
/*************************************************************************/

void CreateTexts(struct Window *win,int textcount,struct Text texts[], long double xscale,long double yscale)
{
	ULONG i;
	for (i=0;i<textcount;i++)
		{
		SetAPen(win->RPort,texts[i].tx_Color);
		Move(win->RPort,texts[i].tx_LeftEdge,texts[i].tx_TopEdge+(ULONG)(yscale*((struct GfxBase *)GfxBase)->DefaultFont->tf_Baseline));
		Text(win->RPort,texts[i].tx_Text,strlen(texts[i].tx_Text));
		}
}

/*************************************************************************/
/*                                                                       */
/*   ShowGadget()                                                        */
/*                                                                       */
/*************************************************************************/

#define GADGET_DOWN  0
#define GADGET_UP    1

void ShowGadget(struct Window *win, struct Gadget *gad, int type)
{
	if ((gad->Flags & GFLG_DISABLED) == 0)
		{
		int gadpos = RemoveGadget(win, gad);

		if (type == GADGET_DOWN)
			gad->Flags |= GFLG_SELECTED;
		else
			gad->Flags &= ~GFLG_SELECTED;

		AddGadget(win, gad, gadpos);
		RefreshGList(gad, win, NULL, 1);
	}
}

