/*
 *	File:					TASK_Text.c
 *	Description:	Window for texts
 *
 *	(C) 1994,1995 Ketil Hunn
 *
 */

#ifndef	TASK_TEXT_C
#define	TASK_TEXT_C

/*** PRIVATE INCLUDES ****************************************************************/
#include "System_Prefs.h"
#include "Clipboard.h"
#include "MainMenu.h"
#include "Asl.h"
#include "cursorHook.h"

/*** DEFINES *************************************************************************/
#define	DAYS							0
#define	MONTHS						1
#define	YEARS							2
#define	HOURS							3
#define	MINUTES						4
#define	WEEKDAY						5
#define	DATE_NOW					6
#define	TIME_NOW					7
#define	DAY_NOW						8
#define	MONTH_NOW					9
#define	YEAR_NOW					10
#define	HOUR_NOW					11
#define	MINUTE_NOW				12
#define	WEEKDAY_NOW				13

#define	GID_ADDTEXT				1
#define	GID_COPYTEXT			2
#define	GID_CUTTEXT				3
#define	GID_PASTETEXT			4
#define	GID_GETFILE				5
#define	GID_FIELDSPOPUP		6
#define	GID_TEXTLISTVIEW	7
#define	GID_TEXTSTRING		8

/*** GLOBALS *************************************************************************/
struct egTask		textTask;
struct List			*textlist;

WORD textbtsize;
struct Node *textnode,
						*oldtextnode;
UBYTE textname[MAXCHARS];

struct egGadget	*addtext,
								*cuttext,
								*copytext,
								*pastetext,
								*textlistview,
								*textstring,
								*getfile,
								*fieldspopup;

UWORD activetext=EG_LISTVIEW_NONE;

/*** FUNCTIONS ***********************************************************************/
__asm __saveds ULONG RenderTextTask(register __a0 struct Hook *hook,
																		register __a2 APTR	      object,
																		register __a1 APTR	      message)
{
	BYTE	nosel=(textnode==NULL),
				flag=((eventnode==NULL | DIRTYPE) ? TRUE:FALSE);

	geta4();

#ifdef MYDEBUG_H
	DebugOut("RenderTextWindow");
#endif
	egCreateContext(eg, &textTask);

	addtext=egCreateGadget(eg,
								EG_Window,			textTask.window,
								EG_Flags,				0,
								EG_GadgetKind,	BUTTON_KIND,
								EG_TextAttr,		fontattr,
								EG_Width,				textbtsize,
								EG_DefaultHeight,	TRUE,
								EG_PlaceWindowTop,	TRUE,
								EG_PlaceWindowRight,	TRUE,
								EG_GadgetText,	GetString(&li, MSG__ADD),
								EG_GadgetID,		GID_ADDTEXT,
								EG_HelpNode,		"NewText",
								GA_Disabled,		flag,
								TAG_DONE);

	copytext=egCreateGadget(eg,
								EG_PlaceBelow,	addtext,
								EG_GadgetText,	GetString(&li, MSG__COPY),
								EG_GadgetID,		GID_COPYTEXT,
								EG_HelpNode,		"Copy",
								GA_Disabled,		nosel,
								TAG_DONE);
	cuttext=egCreateGadget(eg,
								EG_PlaceBelow,	copytext,
								EG_GadgetText,	GetString(&li, MSG__CUT),
								EG_GadgetID,		GID_CUTTEXT,
								EG_HelpNode,		"Cut",
								GA_Disabled,		nosel,
								TAG_DONE);
	pastetext=egCreateGadget(eg,
								EG_PlaceBelow,	cuttext,
								EG_GadgetText,	GetString(&li, MSG__PASTE),
								EG_GadgetID,		GID_PASTETEXT,
								EG_HelpNode,		"Paste",
								GA_Disabled,		flag,
								TAG_DONE);

	textlistview=egCreateGadget(eg,
								EG_GadgetKind,			LISTVIEW_KIND,
								EG_PlaceWindowLeft,	TRUE,
								EG_PlaceWindowTop,	TRUE,
								EG_Width,						X1(addtext)-LeftMargin-4,
								EG_Height,					textTask.window->Height-TopMargin-BottomMargin-GadDefHeight,
								EG_GadgetText,			NULL,
								EG_GadgetID,				GID_TEXTLISTVIEW,
								EG_Arrows,					TRUE,
								GTLV_MakeVisible,		activetext,
								GTLV_Selected,			activetext,
								GTLV_Labels,				textlist,
								EG_HelpNode,				"NewText",
								(KickStart>38 ? GTLV_ShowSelected : TAG_IGNORE),	NULL,
								TAG_DONE);

	flag=(IsType(CLI_TYPE) | IsType(WB_TYPE) | IsType(AREXX_TYPE) ? FALSE:TRUE);
	getfile=egCreateGadget(eg,
								EG_GadgetKind,			EG_GETFILE_KIND,
								EG_TopEdge,					Y2(textlistview),
								EG_Width,						EG_GetfileWidth,
								EG_DefaultHeight,		TRUE,
								EG_GadgetID,				GID_GETFILE,
								EG_HelpNode,				"GetFile",
								EG_Link,						textlistview,
								GA_Disabled,				(nosel ? TRUE:flag),
								TAG_DONE);

	fieldspopup=egCreateGadget(eg,
								EG_GadgetKind,	EG_POPUP_KIND,
								EG_LeftEdge,		X2(textlistview)-EG_PopupWidth,
								EG_Width,				EG_PopupWidth,
								EG_GadgetText,	NULL,
								EG_GadgetID,		GID_FIELDSPOPUP,
								EG_HelpNode,		"GetField",
								GA_Disabled,		nosel,
								TAG_DONE);

	if(textnode==NULL)
		*textname='\0';
	textstring=egCreateGadget(eg,
								EG_GadgetKind,	STRING_KIND,
								EG_LeftEdge,		X2(getfile),
								EG_Width,				X1(fieldspopup)-X2(getfile),
								EG_GadgetText,	NULL,
								EG_GadgetID,		GID_TEXTSTRING,
								EG_HelpNode,		"NewText",
								GTST_MaxChars,	MAXCHARS,
								GTST_String,		textname,
								GA_Disabled,		(activetext==EG_LISTVIEW_NONE ? TRUE:FALSE),
								GTST_EditHook,	(ULONG)&cursorHook,
								TAG_DONE);

	return 1L;
}

__asm __saveds ULONG OpenTextTask(register __a0 struct Hook *hook,
																	register __a2 APTR	      object,
																	register __a1 APTR	      message)
{
	WORD minwidth, minheight;

	geta4();

#ifdef MYDEBUG_H
	DebugOut("OpenTextTask");
#endif

	textbtsize=egMaxLen(eg,	egGetString(MSG__ADD),
													egGetString(MSG__COPY),
													egGetString(MSG__CUT),
													egGetString(MSG__PASTE),
													NULL)+GadHInside;

	minwidth=LeftMargin+EG_GetfileWidth+egTextWidth(eg, egGetString(MSG_TEXTPOPUPGADGETS))+
						GadHInside*2+EG_PopupWidth+textbtsize+GadHSpace+RightMargin;
	minheight=TopMargin+GadDefHeight*4+GadVSpace*3+BottomMargin;

	activetext=EG_LISTVIEW_NONE;
	*textname='\0';
	textnode=NULL;

	if(egOpenTask(&textTask,
										WA_Title,					egGetString(MSG_TEXTS),
										WA_Width,					MAX(minwidth, textTask.coords.Width),
										WA_Height,				MAX(minheight, textTask.coords.Height),
										WA_MinWidth,			minwidth,
										WA_MinHeight,			minheight,
										WA_MaxWidth,			~0,
										WA_MaxHeight,			~0,
										WA_AutoAdjust,		TRUE,
										WA_Activate,			TRUE,
										WA_DragBar,				TRUE,
										WA_DepthGadget,		TRUE,
										WA_SizeGadget,		TRUE,
										WA_SizeBBottom,		TRUE,
										WA_CloseGadget,		TRUE,
										WA_NewLookMenus,	TRUE,
										WA_SimpleRefresh,	env.simplerefresh,
										WA_MenuHelp,			TRUE,
										WA_PubScreen,			mainTask.screen,
										EG_LendMenu,			mainMenu,
										EG_OpenFunc,			(ULONG)OpenTextTask,
										EG_RenderFunc,		(ULONG)RenderTextTask,
										EG_HandleFunc,		(ULONG)HandleTextTask,
										EG_IconifyGadget,	TRUE,
										EG_IDCMP,					IDCMP_MENUPICK|
																			IDCMP_CLOSEWINDOW|
																			IDCMP_MOUSEBUTTONS|
																			BUTTONIDCMP|
																			LISTVIEWIDCMP,
										EG_InitialCentre,	TRUE,
										TAG_END))
	{
		oldtextnode=NOTEXT;
		GetFirstText();
		return TRUE;
	}
	return 1L;
}

__asm __saveds ULONG HandleTextTask(register __a0 struct Hook *hook,
																		register __a2 APTR	      object,
																		register __a1 APTR	      message)
{
	struct IntuiMessage *msg;

	geta4();
	msg=(struct IntuiMessage *)hook->h_Data;
	switch(msg->Class)
	{
		case IDCMP_MENUPICK:
			HandleMainMenu(&textTask, msg->Code);
			break;

		case IDCMP_CLOSEWINDOW:
			egCloseTask(&textTask);
			break;

		case IDCMP_RAWKEY:
			if(textnode)
				switch(egConvertRawKey(msg))
				{
					case RETURN_KEY:
						ActivateGadget(textstring->gadget, textTask.window, NULL);
						break;
				}
			break;

		case IDCMP_LISTVIEWCURSOR:
			switch(((struct Gadget *)msg->IAddress)->GadgetID)
			{
				case GID_TEXTSTRING:
					if(Stricmp(String(textstring), textnode->ln_Name))
						RenameNode(textnode, String(textstring));
					egHandleListviewArrows(textlistview, textTask.window, msg);
					GetSelectedText(textlistview->active);
					egActivateGadget(textstring, textTask.window, NULL);
					break;
			}
			break;

		case IDCMP_GADGETDOWN:
		case IDCMP_GADGETUP:
			switch(((struct Gadget *)msg->IAddress)->GadgetID)
			{
				case GID_ADDTEXT:
					AddText("");
					break;
				case GID_COPYTEXT:
					CopyText();
					break;
				case GID_CUTTEXT:
					CutText();
					break;
				case GID_PASTETEXT:
					PasteText();
					break;

				case GID_TEXTLISTVIEW:
					GetSelectedText(msg->Code);
					break;
				case GID_GETFILE:
					GetFileName();
					break;
				case GID_TEXTSTRING:
					DetachList(textlistview, textTask.window);
					if(textnode)
						RenameNode(textnode, String(textstring));
					else
						textnode=AddNode(textlist, NULL, String(textstring));
					AttachList(textlistview, textTask.window, textlist);
					activetext=
					(UWORD)egSetGadgetAttrs(textlistview, textTask.window, NULL,
																GTLV_SelectedNode,	textnode,
																TAG_DONE);
					strcpy(textname, (textnode ? textnode->ln_Name : NULL));
					UpdateTextTask();
					++env.changes;
					break;
				case GID_FIELDSPOPUP:
					GetField();
					break;
			}
			break;
	}
	return 1L;
}

void UpdateTextTask(void)
{
	register BYTE nosel	=(textnode==NULL),
								flag	=!(eventnode && eventnode->nn_Node.ln_Type!=REC_DIR);

#ifdef MYDEBUG_H
	DebugOut("UpdateTextTask");
#endif

	if(textTask.window==NULL)
		return;

	egSetGadgetAttrs(textlistview, textTask.window, NULL,
											GTLV_Selected,		activetext,
											GTLV_Labels,			textlist,
											GTLV_MakeVisible,	activetext,
											TAG_DONE);
	if(textnode)
		strcpy(textname, textnode->ln_Name);
	else
		*textname='\0';
	egSetGadgetAttrs(textstring, textTask.window, NULL,
											GTST_String,	textname,
											GA_Disabled,	nosel,
											TAG_DONE);
	egSetGadgetAttrs(copytext, textTask.window, NULL,
											GA_Disabled,	nosel,
											TAG_DONE);
	egSetGadgetAttrs(cuttext, textTask.window, NULL,
											GA_Disabled,	nosel,
											TAG_DONE);
	egSetGadgetAttrs(addtext, textTask.window, NULL,
											GA_Disabled,	flag,
											TAG_DONE);
	egSetGadgetAttrs(pastetext, textTask.window, NULL,
											GA_Disabled,	flag,
											TAG_DONE);

	flag=(IsType(CLI_TYPE) | IsType(WB_TYPE) | IsType(AREXX_TYPE));
	if(textnode!=NULL & flag==TRUE)
		flag=FALSE;
	else
		flag=TRUE;

	egSetGadgetAttrs(getfile, textTask.window, NULL,
					GA_Disabled,	flag,
					TAG_DONE);

	if(textnode)
		flag=FALSE;
	else
		flag=TRUE;
	egSetGadgetAttrs(fieldspopup, textTask.window, NULL,
										GA_Disabled,	flag,
										TAG_DONE);
}

void InsertField(UBYTE *field)
{
	if(strlen(String(textstring))+strlen(field)<MAXCHARS)
	{
		UBYTE before[MAXCHARS], *p, newtext[MAXCHARS];

		strcpy(before, String(textstring));
		p=before+BufferPos(textstring);
		*p='\0';
		sprintf(newtext, "%s%s%s", before, field, String(textstring)+BufferPos(textstring));

		egSetGadgetAttrs(textstring, textTask.window, NULL,
											GTST_String,	newtext,
											TAG_DONE);
		egActivateGadget(textstring, textTask.window, NULL);
	}
	else
		FailRequest(mainTask.window, MSG_BUFFERTOOLARGE, (APTR)MAXCHARS);
}

ULONG textfieldhelp(struct Hook *hook, VOID *o, VOID *m)
{
	struct IntuiMessage *msg;

	geta4();

	msg=(struct IntuiMessage *)hook->h_Data;
	if(msg->Class==IDCMP_RAWKEY & msg->Code==95)
		if(egShowAmigaGuide(eg, "Fields"))
		{
		 	ULONG signal=Wait(eg->AmigaGuideSignal);

			if(signal & eg->AmigaGuideSignal)
				egHandleAmigaGuide(eg);
		}
	return 1;
}

void GetField(void)
{
	register struct List *fieldslist;
	register struct ListviewRequester	*fieldsreq;
	register WORD winleft=textTask.window->LeftEdge,
								wintop=textTask.window->TopEdge;

	static char *fieldnames[]={	"{days:DD/MM/YYYY}",
															"{months:DD/MM/YYYY}",
															"{years:DD/MM/YYYY}",
															"{hours:DD/MM/YYYY HH:MM}",
															"{minutes:DD/MM/YYYY HH:MM}",
															"{timelapse:DD/MM/YYYY HH:MM}",
															"{date}",
															"{time}",
															"{day}",
															"{month}",
															"{year}",
															"{hour}",
															"{minute}",
															"{weekday}",
															NULL};
	if(fieldslist=InitList())
	{
		register i;
		for(i=0; i<14; i++)
			AddNode(fieldslist, NULL, fieldnames[i]);

		if(fieldsreq=mrAllocRequest(MR_ListviewRequest,
									MR_Window,					textTask.window,
									MR_TextAttr,				mainTask.screen->Font,
									MRLV_Labels,				fieldslist,
									MRLV_DropDown,			TRUE,
									MR_Gadgets,					egGetString(MSG_TEXTPOPUPGADGETS),
									MR_SimpleRefresh,		TRUE,
									TAG_DONE))
		{
			if(mrRequest(	fieldsreq,
										MR_InitialLeftEdge,	winleft+X1(textstring),
										MR_InitialTopEdge,	wintop+Y2(textstring),
										MR_InitialPercentV,	20,
										MR_InitialWidth,		W(textstring)+EG_PopupWidth,
										MR_IntuiMsgFunc,		textfieldhelp,
										TAG_DONE))
				InsertField(fieldsreq->selectednode->ln_Name);

			mrFreeRequest(fieldsreq);
			FreeList(fieldslist);
		}
	}
}

void CutText(void)
{
	DetachList(textlistview, textTask.window);
	StringToClipboard(0, textnode->ln_Name);
	RemoveNode(textnode);
	textnode=egGetNode(textlist, activetext);
	if(textnode==NULL)
		textnode=egGetNode(textlist, --activetext);
	if(textnode==NULL)
		*textname='\0';
	else
		egSetGadgetAttrs(textlistview, textTask.window, NULL,
											GTLV_Selected,	activetext,
											TAG_DONE);
	UpdateTextTask();
	++env.changes;
}

void PasteText(void)
{
	DetachList(textlistview, textTask.window);
	if(textnode=ClipboardToList(0, textlist, textnode))
		activetext=
	(UWORD)egSetGadgetAttrs(textlistview, textTask.window, NULL,
												GTLV_SelectedNode,	textnode,
												TAG_DONE);
	UpdateTextTask();
	++env.changes;
}

void GetFileName(void)
{
	egLockAllTasks(eg);
	if(eventnode!=NULL)
	{
		UBYTE fullcommand[512];

		strcpy(fullcommand, (eventnode->dir==NULL ? "\0":eventnode->dir));
		AddPart(fullcommand, String(textstring), 512);
		if(FileRequest(	mainTask.window,
										MSG_SELECTCOMMAND,
										fullcommand,
										NULL,
										NULL,
										MSG_OK))
			egSetGadgetAttrs(textstring, textTask.window, NULL,
												GTST_String,	fullcommand,
												TAG_DONE);
	}
	egUnlockAllTasks(eg);
	egActivateGadget(textstring, textTask.window, NULL);
}

void CopyText(void)
{
	StringToClipboard(0, textnode->ln_Name);
/*
	if(record)
		AddARexxMacroCommand(	macro,
													ER_Command,	"COPY TEXT",
													TAG_DONE);
*/
}

void GetFirstText(void)
{
#ifdef MYDEBUG_H
	DebugOut("GetFirstText");
#endif

	if(	eventnode &&
			(textlist=(eventnode->nn_Node.ln_Type==REC_DIR ? NULL:eventnode->textlist)) &&
			(textnode=GetHead(textlist)))
	{
		strcpy(textname, textnode->ln_Name);
		activetext=0;
	}
	else
	{
		textlist=(eventnode ? eventnode->textlist:NULL);
		oldtextnode=textnode=NULL;
		activetext=~0;
		*textname='\0';
	}
}

void GetSelectedText(UWORD code)
{
	if(oldtextnode!=(textnode=egGetNode(textlist, activetext=code)))
	{
		if(textnode)
			strcpy(textname, textnode->ln_Name);
		else
			*textname='\0';
		egSetGadgetAttrs(textstring, textTask.window, NULL,
												GTST_String,	textname,
												GA_Disabled,	textnode==NULL,
												TAG_DONE);
//		UpdateTextTask();
		oldtextnode=textnode;

/*
		if(record)
			AddARexxMacroCommand(	macro,
														ER_Command,		"ACTIVATE TEXT %ld",
														ER_Argument,	code+1,
														TAG_DONE);
*/
	}
}

void AddText(UBYTE *name)
{
	if(oldtextnode=textnode=AddNode(textlist, textnode, name))
	{
		if(activetext==~0)
			activetext=MAX(0, Count(textlist)-1);
		else
			++activetext;
		UpdateTextTask();
		egActivateGadget(textstring, textTask.window, NULL);
		++env.changes;
/*
		if(record)
			AddARexxMacroCommand(	macro,
														ER_Command,	"ADD",
														TAG_DONE);
*/
	}
}
#endif
