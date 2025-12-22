/*************************************************************************/
/*                                                                       */
/*   Includes                                                            */
/*                                                                       */
/*************************************************************************/

#include "Sound_Includes.h"
#include "Sound.h"

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

/*************************************************************************/
/*                                                                       */
/*   About()                                                             */
/*                                                                       */
/*************************************************************************/

void About(struct Window *hostwin,struct Gadget **wingads,APTR userdata)
{
	APTR visualinfo;
	Object *o;
	struct Gadget   *gadgetlist   = NULL;
	struct Screen   *customscreen = NULL;
	struct Gadget   *gadget       = NULL;
	struct TextAttr  textattr     = { NULL,0,FS_NORMAL,FPF_DISKFONT };
	struct NewGadget newgad;
	struct Gadget   *textfield    = NULL;
	visualinfo=GetVisualInfo(hostwin->WScreen,TAG_DONE);
	if (visualinfo)
		{
		o=NewDTObject("/About.IFF",DTA_SourceType,DTST_FILE,DTA_GroupID,GID_PICTURE,TAG_DONE);
		if (o)
			{
			customscreen = hostwin->WScreen;
			gadget       = CreateContext(&gadgetlist);
			if (gadget)
				{
				ULONG height=24,width=35,left=0,top=0;
				struct Gadget *wingad;
				char * title = "About";
				struct Window *win = NULL;

				textattr.ta_Name     = ((struct GfxBase *)GfxBase)->DefaultFont->tf_Message.mn_Node.ln_Name;
				textattr.ta_YSize    = ((struct GfxBase *)GfxBase)->DefaultFont->tf_YSize;
				newgad.ng_LeftEdge   = XPOS(1);
				newgad.ng_TopEdge    = YPOS(21);
				newgad.ng_Width      = XSIZE(33)+200;
				newgad.ng_Height     = YSIZE(2);
				newgad.ng_GadgetText = "_OK";
				newgad.ng_TextAttr   = &textattr;
				newgad.ng_GadgetID   = 2;
				newgad.ng_Flags      = PLACETEXT_IN;
				newgad.ng_VisualInfo = visualinfo;
				newgad.ng_UserData   = NULL;

				height= YSIZE(height);
				width = XSIZE(width)+200;
				left  = (customscreen->Width-width)/2;
				top   = (customscreen->Height-height)/2;

				wingad = gadget = CreateGadget(BUTTON_KIND,gadget,&newgad,GT_Underscore,'_',TAG_END);

				if (height>customscreen->Height || width>customscreen->Width) GUIC_ErrorReport(hostwin,ERROR_SCREEN_TOO_SMALL);
				win=OpenWindowTags(NULL,WA_Activate,         TRUE,
					WA_CloseGadget,      TRUE,
					WA_DepthGadget,      TRUE,
					WA_SizeGadget,       FALSE,
					WA_DragBar,          TRUE,
					WA_Gadgets,          (ULONG)gadgetlist,
					WA_InnerHeight,      height,
					WA_InnerWidth,       width,
					WA_IDCMP,            IDCMP_CLOSEWINDOW|BUTTONIDCMP|IDCMPUPDATE|IDCMP_VANILLAKEY,
					WA_Left,             left,
					WA_Top,              top,
					WA_SmartRefresh,     TRUE,
					WA_Title,            (ULONG)title,
					WA_CustomScreen,     (ULONG)customscreen,
					TAG_END);
				if (win)
					{
					struct IntuiMessage  *imessage   = NULL;
					struct Gadget        *idcmpgad   = NULL;
					struct BitMap        *bmcopy     = NULL;
					struct TagItem       *tag        = NULL;
					struct TagItem       *tstate     = NULL;
					ULONG  idcmpclass                = 0;
					UWORD  messagecode               = 0;
					BOOL   running                   = TRUE;

					textfield = (struct Gadget *)NewObject(TEXTFIELD_GetClass(), NULL,
						GA_ID,               4711,
						GA_Top,              YPOS(1),
						GA_Left,             XPOS(3)+200,
						GA_Width,            XSIZE(31),
						GA_Height,           YSIZE(19),
						TEXTFIELD_TextAttr,  (ULONG)&textattr,
						TEXTFIELD_Text,      (ULONG)"****************************\n*                          *\n*  This  GUI was designed  *\n*                          *\n*  with GUI-Creator V 1.0  *\n*                          *\n*  © 1995 by               *\n*  Markus Hillenbrand      *\n*                          *\n* ------------------------ *\n*                          *\n* GUI-Creator is Shareware *\n*                          *\n* Please read the docs for *\n*                          *\n* more information!        *\n*                          *\n****************************",
						TEXTFIELD_Border,    TEXTFIELD_BORDER_BEVEL,
						TEXTFIELD_Alignment, TEXTFIELD_ALIGN_CENTER,
						TEXTFIELD_Inverted,  TRUE,
						TEXTFIELD_ReadOnly,  TRUE,
						TAG_END);

					if (textfield)
						{
						AddGadget(win,textfield,-1);
						RefreshGList(textfield,win,NULL,-1);

						SleepWindow(hostwin);
						SetFont(win->RPort,((struct GfxBase *)GfxBase)->DefaultFont);
						DrawBevelBox(win->RPort,XPOS(1),YPOS(1),204,102,GT_VisualInfo,(ULONG)visualinfo,GTBB_Recessed,TRUE,TAG_END);
						SetDTAttrs(o,NULL,NULL,GA_Left,XPOS(1)+2,GA_Top,YPOS(1)+1,GA_Width,200,GA_Height,100,PDTA_Remap,TRUE,PDTA_DestBitMap,(ULONG)&bmcopy,ICA_TARGET,ICTARGET_IDCMP,TAG_DONE);
						AddDTObject(win,NULL,o,-1L);
						GT_RefreshWindow(win,NULL);
						while (running)
							{
							Wait(1L << win->UserPort->mp_SigBit);
							while (imessage=GT_GetIMsg(win->UserPort))
								{
								idcmpgad=(struct Gadget *)imessage->IAddress;
								idcmpclass=imessage->Class;
								messagecode =imessage->Code;
								GT_ReplyIMsg(imessage);
								switch(idcmpclass)
									{
									case IDCMP_VANILLAKEY:
										if (messagecode == 27 || messagecode == 'o' || messagecode == 'O') running=FALSE;
										break;
									case IDCMP_REFRESHWINDOW:
										GT_BeginRefresh(win);
										GT_EndRefresh(win,TRUE);
										break;
									case IDCMP_CLOSEWINDOW:
										running=FALSE;
										break;
									case BUTTONIDCMP:
										running=FALSE;
										break;
									case IDCMP_IDCMPUPDATE:
										tstate=(struct TagItem*)imessage->IAddress;
										while (tag=NextTagItem(&tstate)) if (tag->ti_Tag == DTA_Sync) RefreshDTObjectA(o,win,NULL,NULL);
										break;
									}
								}
							}
						RemoveGadget(win,textfield);
						DisposeObject((APTR)textfield);
						}
					else GUIC_ErrorReport(hostwin,ERROR_NO_GADGETLIST_CREATED);
					CloseWindow(win);
					WakenWindow(hostwin);
					}
				else GUIC_ErrorReport(hostwin,ERROR_NO_WINDOW_OPENED);
				FreeGadgets(gadgetlist);
				}
			else GUIC_ErrorReport(hostwin,ERROR_NO_GADGETLIST_CREATED);
			DisposeDTObject(o);
			}
		else GUIC_ErrorReport(hostwin,ERROR_NO_PICTURE_LOADED);
		FreeVisualInfo(visualinfo);
		}
	else GUIC_ErrorReport(hostwin,ERROR_NO_VISUALINFO);

}
