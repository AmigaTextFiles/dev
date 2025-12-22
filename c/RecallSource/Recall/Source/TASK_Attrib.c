/*
 *	File:					TASK_Attrib.c
 *	Description:	Window for attributes
 *
 *	(C) 1994,1995 Ketil Hunn
 *
 */

#ifndef	TASK_ATTRIB_C
#define	TASK_ATTRIB_C

/*** PRIVATE INCLUDES ****************************************************************/
#include "System.h"
#include "System_Prefs.h"
#include "MainMenu.h"
#include "Asl.h"

/*** DEFINES *************************************************************************/
#define	GID_GROUPCHECK				1
#define	GID_FLASHCHECK				2
#define	GID_CONFIRMCHECK			3
#define	GID_POSTPONECHECK			4
#define	GID_MULTITASKCHECK		5
#define	GID_CENTRECHECK				6
#define	GID_TYPECYCLE					7
#define	GID_SHOWCYCLE					8
#define	GID_GETSCREEN					9
#define	GID_SCREENSTRING			10
#define	GID_GETDIR						11
#define	GID_DIRSTRING					12
#define	GID_STACKSTRING				13
#define	GID_PRIORITYSTRING		14
#define	GID_TIMEOUTSTRING			15

/*** GLOBALS *************************************************************************/
char	*typecl[]={"","","","","","","",NULL},
			*showcl[]={"","","","",NULL};

LONG lattribsize, mattribsize, rattribsize;
BYTE attribdisabled=-1;

struct egGadget	*group,
								*flash,
								*confirm,
								*postpone,
								*multitask,
								*centre,
								*type,
								*show,
								*getscreen,
								*screenstring,
								*getdir,
								*dirstring,
								*stackstring,
								*prioritystring,
								*timeoutstring;

struct egTask	attribTask;
UBYTE arexxname[]="AREXX";

/*** FUNCTIONS ***********************************************************************/
__asm ULONG RenderAttribTask(	register __a0 struct Hook *hook,
															register __a2 APTR	      object,
															register __a1 APTR	      message)
{
	geta4();
	{
	BYTE flag=(eventnode==NULL | DIRTYPE);
	WORD width, leftedge;
	struct EventNode tmpnode;

#ifdef MYDEBUG_H
	DebugOut( "RenderAttribWindow()");
#endif

	if(flag)
		memset(&tmpnode, 0, sizeof(struct EventNode));
	else
		CopyMem(eventnode, &tmpnode, sizeof(struct EventNode));

	egCreateContext(eg, &attribTask);

	group=egCreateGadget(eg,
						EG_Window,			attribTask.window,
						EG_GadgetKind,	CHECKBOX_KIND,
						EG_TextAttr,		fontattr,
						EG_Flags,				0,
						EG_LeftEdge,		LeftMargin+lattribsize,
						EG_TopEdge,			TopMargin,
						EG_DefaultWidth,	TRUE,
						EG_DefaultHeight,	TRUE,
						EG_GadgetText,	egGetString(MSG__GROUP),
						EG_GadgetID,		GID_GROUPCHECK,
						EG_HelpNode,		"Group",
						GTCB_Checked,		ISBITSET(tmpnode.flags, GROUP),
						TAG_END);
	flash=egCreateGadget(eg,
						EG_PlaceBelow,	group,
						EG_GadgetText,	egGetString(MSG__FLASH),
						EG_GadgetID,		GID_FLASHCHECK,
						EG_HelpNode,		"Flash",
						GTCB_Checked,		ISBITSET(tmpnode.flags, FLASH),
						TAG_END);
	confirm=egCreateGadget(eg,
						EG_PlaceBelow,	flash,
						EG_GadgetText,	egGetString(MSG__CONFIRM),
						EG_GadgetID,		GID_CONFIRMCHECK,
						EG_HelpNode,		"Confirm",
						GTCB_Checked,		ISBITSET(tmpnode.flags, CONFIRM),
						TAG_END);
	postpone=egCreateGadget(eg,
						EG_PlaceBelow,	confirm,
						EG_GadgetText,	egGetString(MSG__POSTPONE),
						EG_GadgetID,		GID_POSTPONECHECK,
						EG_HelpNode,		"Postpone",
						GTCB_Checked,		ISBITSET(tmpnode.flags, POSTPONE),
						TAG_END);
	multitask=egCreateGadget(eg,
						EG_PlaceBelow,	postpone,
						EG_GadgetText,	egGetString(MSG__MULTITASK),
						EG_GadgetID,		GID_MULTITASKCHECK,
						EG_HelpNode,		"Multitask",
						GTCB_Checked,		ISBITSET(tmpnode.flags, MULTITASK),
						TAG_END);

	centre=egCreateGadget(eg,
						EG_PlaceBelow,	multitask,
						EG_GadgetText,	egGetString(MSG__CENTRE),
						EG_GadgetID,		GID_CENTRECHECK,
						EG_HelpNode,		"Centre",
						GTCB_Checked,		ISBITSET(tmpnode.flags, CENTRE),
						TAG_END);

	type=egCreateGadget(eg,
						EG_GadgetKind,	CYCLE_KIND,
						EG_LeftEdge,		leftedge=X2(group)+GadHSpace*2+mattribsize,
						EG_DefaultHeight,	TRUE,
						EG_PlaceWindowTop,	TRUE,
						EG_Width,				attribTask.window->Width-leftedge-RightMargin,
						EG_GadgetText,	egGetString(MSG__TYPE),
						EG_GadgetID,		GID_TYPECYCLE,
						EG_HelpNode,		"Type",
						GTCY_Labels,		typecl,
						GTCY_Active,		tmpnode.type,
						TAG_END);
	show=egCreateGadget(eg,
						EG_PlaceBelow,	type,
						EG_GadgetText,	egGetString(MSG__SHOW),
						EG_GadgetID,		GID_SHOWCYCLE,
						EG_HelpNode,		"Show",
						GTCY_Labels,		showcl,
						GTCY_Active,		tmpnode.show,
						TAG_END);

	screenstring=egCreateGadget(eg,
						EG_GadgetKind,	STRING_KIND,
						EG_PlaceBelow,	show,
						EG_Width,				W(show)-EG_PopupWidth,
						EG_GadgetText,	egGetString(MSG__SCREEN),
						EG_GadgetID,		GID_SCREENSTRING,
						EG_HelpNode,		"Screen",
						GTST_MaxChars,	MAXCHARS,
						GTST_String,		tmpnode.screen,
						TAG_END);
	getscreen=egCreateGadget(eg,
						EG_GadgetKind,	EG_POPUP_KIND,
						EG_LeftEdge,		X2(show)-EG_PopupWidth,
						EG_Width,				EG_PopupWidth,
						EG_GadgetText,	NULL,
						EG_GadgetID,		GID_GETSCREEN,
						EG_HelpNode,		"Screen",
						TAG_END);

	dirstring=egCreateGadget(eg,
						EG_GadgetKind,	STRING_KIND,
						EG_PlaceBelow,	getscreen,
						EG_LeftEdge,		X1(show),
						EG_Width,				W(show)-EG_GetdirWidth,
						EG_GadgetText,	egGetString(MSG__DIR),
						EG_GadgetID,		GID_DIRSTRING,
						EG_HelpNode,		"Dir",
						GTST_MaxChars,	MAXCHARS,
						GTST_String,		tmpnode.dir,
						TAG_END);

	getdir=egCreateGadget(eg,
						EG_GadgetKind,	EG_GETDIR_KIND,
						EG_LeftEdge,		X2(show)-EG_GetdirWidth,
						EG_Width,				EG_GetdirWidth,
						EG_GadgetText,	NULL,
						EG_GadgetID,		GID_GETDIR,
						EG_HelpNode,		"Dir",
						TAG_END);

	stackstring=egCreateGadget(eg,
						EG_GadgetKind,	INTEGER_KIND,
						EG_LeftEdge,		X1(show),
						EG_Width,				width=W(show),
						EG_PlaceBelow,	getdir,
						EG_GadgetText,	egGetString(MSG__STACK),
						EG_GadgetID,		GID_STACKSTRING,
						GTIN_MaxChars,	6,
						EG_HelpNode,		"Stack",
						GTIN_Number,		tmpnode.stack,
						TAG_END);
	prioritystring=egCreateGadget(eg,
						EG_PlaceBelow,	stackstring,
						EG_GadgetText,	egGetString(MSG__PRIORITY),
						EG_GadgetID,		GID_PRIORITYSTRING,
						EG_HelpNode,		"Priority",
						GTIN_MaxChars,	3,
						GTIN_Number,		tmpnode.priority,
						TAG_END);

	timeoutstring=egCreateGadget(eg,
						EG_PlaceBelow,	prioritystring,
						EG_GadgetText,	egGetString(MSG__TIMEOUT),
						EG_GadgetID,		GID_TIMEOUTSTRING,
						EG_HelpNode,		"Timeout",
						GTIN_MaxChars,	10,
						GTIN_Number,		tmpnode.timeout,
						TAG_END);

	}
	return 1L;
}

__asm ULONG OpenAttribTask(	register __a0 struct Hook *hook,
														register __a2 APTR	      object,
														register __a1 APTR	      message)
{
	WORD minwidth, minheight;

#ifdef MYDEBUG_H
	DebugOut( "OpenAttribTask");
#endif

	geta4();

	typecl[0]=egGetString(MSG_REQUESTER);
	typecl[1]=egGetString(MSG_RECOVERYALERT);
	typecl[2]=egGetString(MSG_DEADENDALERT);
	typecl[3]=egGetString(MSG_CLI);
	typecl[4]=egGetString(MSG_WB);
	typecl[5]=arexxname;
	typecl[6]=egGetString(MSG_INPUT);

	showcl[0]=egGetString(MSG_ALWAYS);
	showcl[1]=egGetString(MSG_DAILY);
	showcl[2]=egGetString(MSG_STARTUP);
	showcl[3]=egGetString(MSG_NEVER);

	lattribsize=egMaxLen(eg,	egGetString(MSG__GROUP),
														egGetString(MSG__FLASH),
														egGetString(MSG__CONFIRM),
														egGetString(MSG__POSTPONE),
														egGetString(MSG__MULTITASK),
														egGetString(MSG__CENTRE),
														NULL)+EG_LabelSpace;
	mattribsize=egMaxLen(eg,	egGetString(MSG__TYPE),
														egGetString(MSG__SHOW),
														egGetString(MSG__SCREEN),
														egGetString(MSG__DIR),
														egGetString(MSG__STACK),
														egGetString(MSG__PRIORITY),
														egGetString(MSG__TIMEOUT),
														NULL)+EG_LabelSpace+GadHSpace*2;

	rattribsize=EG_CycleWidth+
							MAX(egMaxLen(eg,	egGetString(MSG_REQUESTER),
																egGetString(MSG_RECOVERYALERT),
																egGetString(MSG_DEADENDALERT),
																egGetString(MSG_CLI),
																egGetString(MSG_WB),
																egGetString(MSG_INPUT),
																NULL),
									egMaxLen(eg,	egGetString(MSG_ALWAYS),
																egGetString(MSG_DAILY),
																egGetString(MSG_STARTUP),
																egGetString(MSG_NEVER),
																NULL));

	minwidth=lattribsize+mattribsize+rattribsize+GadHSpace*2+LeftMargin+RightMargin;
	minheight=TopMargin+GadDefHeight*7+GadVSpace*6+BottomMargin;

	if(egOpenTask(&attribTask,
										WA_Title,					egGetString(MSG_ATTRIBUTES),
										WA_Width,					attribTask.coords.Width,
										WA_Height,				minheight,
										WA_MinWidth,			minwidth,
										WA_MinHeight,			minheight,
										WA_MaxWidth,			~0,
										WA_MaxHeight,			minheight,
										WA_AutoAdjust,		TRUE,
										WA_Activate,			!(eventnode==NULL | DIRTYPE),
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
										EG_Blocked,				(eventnode==NULL | DIRTYPE),
										EG_GhostWhenBlocked,	TRUE,
										EG_InitialCentre,	TRUE,
										EG_OpenFunc,			(ULONG)OpenAttribTask,
										EG_RenderFunc,		(ULONG)RenderAttribTask,
										EG_HandleFunc,		(ULONG)HandleAttribTask,
										EG_IconifyGadget,	TRUE,
										EG_IDCMP,					STRINGIDCMP|
																			IDCMP_MENUPICK|
																			IDCMP_CLOSEWINDOW|
																			IDCMP_GADGETDOWN|
																			IDCMP_MOUSEBUTTONS,
										TAG_END))
		return TRUE;
	return FALSE;
}

__asm ULONG HandleAttribTask(	register __a0 struct Hook *hook,
															register __a2 APTR	      object,
															register __a1 APTR	      message)
{
	struct IntuiMessage *msg;

	geta4();
	msg=(struct IntuiMessage *)hook->h_Data;

	switch(msg->Class)
	{
		case IDCMP_MENUPICK:
			HandleMainMenu(&attribTask, msg->Code);
			break;

		case IDCMP_CLOSEWINDOW:
			egCloseTask(&attribTask);
			break;

		case IDCMP_GADGETUP:
			switch(((struct Gadget *)msg->IAddress)->GadgetID)
			{
				case GID_GROUPCHECK:
					IFTRUESETBIT(msg->Code, eventnode->flags, GROUP);
					++env.changes;
					break;
				case GID_FLASHCHECK:
					IFTRUESETBIT(msg->Code, eventnode->flags, FLASH);
					++env.changes;
					break;
				case GID_CONFIRMCHECK:
					IFTRUESETBIT(msg->Code, eventnode->flags, CONFIRM);
					++env.changes;
					break;
				case GID_POSTPONECHECK:
					IFTRUESETBIT(msg->Code, eventnode->flags, POSTPONE);
					++env.changes;
					break;
				case GID_MULTITASKCHECK:
					IFTRUESETBIT(msg->Code, eventnode->flags, MULTITASK);
					++env.changes;
					break;
				case GID_CENTRECHECK:
					IFTRUESETBIT(msg->Code, eventnode->flags, CENTRE);
					++env.changes;
					break;

				case GID_TYPECYCLE:
					eventnode->type=msg->Code;
					if(textTask.status==STATUS_OPEN)
					{
						BYTE flag=(IsType(CLI_TYPE) | IsType(WB_TYPE) | IsType(AREXX_TYPE) ? FALSE:TRUE);

						egSetGadgetAttrs(getfile, textTask.window, NULL,
														GA_Disabled,	(textnode==NULL ? TRUE:flag),
														TAG_DONE);
					}
					++env.changes;
					break;
				case GID_SHOWCYCLE:
					eventnode->show=msg->Code;
					eventnode->datestamp=0;
					++env.changes;
					break;
				case GID_GETSCREEN:
					if(SelectPubScreen(&eventnode->screen))
					{
						egSetGadgetAttrs(screenstring, attribTask.window, NULL,
															GTST_String, eventnode->screen,
															TAG_DONE);
						++env.changes;
					}
					break;
				case GID_SCREENSTRING:
					RenameText(&eventnode->screen, String(screenstring));
					++env.changes;
					break;
				case GID_GETDIR:
					egLockAllTasks(eg);
					{
						UBYTE string[MAXCHARS];

						strcpy(string, String(dirstring));
						if(FileRequest(	mainTask.window,
														MSG_SELECTDRAWER,
														string,
														NULL,
														FRF_DRAWERSONLY,
														MSG_OK))
						{
							RenameText(&eventnode->dir, string);
							egSetGadgetAttrs(dirstring, attribTask.window, NULL,
																GTST_String,	eventnode->dir,
																TAG_END);
							++env.changes;
						}
					}
					egUnlockAllTasks(eg);
					break;
				case GID_DIRSTRING:
					RenameText(&eventnode->dir, String(dirstring));
					++env.changes;
					break;
				case GID_STACKSTRING:
					eventnode->stack=Number(stackstring);
					++env.changes;
					break;
				case GID_PRIORITYSTRING:
					eventnode->priority=Number(prioritystring);
					++env.changes;
					break;
				case GID_TIMEOUTSTRING:
					eventnode->timeout=Number(timeoutstring);
					++env.changes;
					break;
			}
			break;
	}
	return 1L;
}

void UpdateAttribTask(void)
{
#ifdef MYDEBUG_H
	DebugOut( "UpdateAttribTask");
#endif

	if(attribTask.window)
	{
		struct EventNode attribnode;
		BYTE flag=(eventnode==NULL | DIRTYPE);

		if(flag)
		{
			if(ISBITCLEARED(attribTask.flags, TASK_BLOCKED))
				egLockTask(&attribTask, TAG_DONE);
			memset(&attribnode, 0, sizeof(struct EventNode));
		}
		else
		{
			if(ISBITSET(attribTask.flags, TASK_BLOCKED))
				egUnlockTask(&attribTask, TAG_DONE);
			CopyMem(eventnode, &attribnode, sizeof(struct EventNode));
		}

		if(ISBITCLEARED(attribTask.flags, TASK_BLOCKED))
		{
			egSetGadgetAttrs(group, attribTask.window, NULL,
												GTCB_Checked,	ISBITSET(attribnode.flags, GROUP),
												TAG_DONE);
			egSetGadgetAttrs(flash, attribTask.window, NULL,
												GTCB_Checked,	ISBITSET(attribnode.flags, FLASH),
												TAG_DONE);
			egSetGadgetAttrs(confirm, attribTask.window, NULL,
												GTCB_Checked,	ISBITSET(attribnode.flags, CONFIRM),
												TAG_DONE);
			egSetGadgetAttrs(postpone, attribTask.window, NULL,
												GTCB_Checked,	ISBITSET(attribnode.flags, POSTPONE),
												TAG_DONE);
			egSetGadgetAttrs(multitask, attribTask.window, NULL,
												GTCB_Checked,	ISBITSET(attribnode.flags, MULTITASK),
												TAG_DONE);
			egSetGadgetAttrs(centre, attribTask.window, NULL,
												GTCB_Checked,	ISBITSET(attribnode.flags, CENTRE),
												TAG_DONE);
			egSetGadgetAttrs(type, attribTask.window, NULL,
												GTCY_Active,	attribnode.type,
												TAG_DONE);
			egSetGadgetAttrs(show, attribTask.window, NULL,
												GTCY_Active,	attribnode.show,
												TAG_DONE);

			egSetGadgetAttrs(screenstring, attribTask.window, NULL,
												GTST_String,	attribnode.screen,
												TAG_DONE);
			egSetGadgetAttrs(getscreen, attribTask.window, NULL,
												TAG_DONE);

			egSetGadgetAttrs(dirstring, attribTask.window, NULL,
												GTST_String,	attribnode.dir,
												TAG_DONE);
			egSetGadgetAttrs(getdir, attribTask.window, NULL,
											TAG_DONE);

			egSetGadgetAttrs(stackstring, attribTask.window, NULL,
												GTIN_Number,	attribnode.stack,
												TAG_DONE);

			egSetGadgetAttrs(prioritystring, attribTask.window, NULL,
												GTIN_Number,	attribnode.priority,
												TAG_DONE);

			egSetGadgetAttrs(timeoutstring, attribTask.window, NULL,
												GTIN_Number,	attribnode.timeout,
												TAG_DONE);
		}
	}
}

ULONG screenhelp(struct Hook *hook, VOID *o, VOID *m)
{
	struct IntuiMessage *msg;

	geta4();

	msg=(struct IntuiMessage *)hook->h_Data;
	if(msg->Class==IDCMP_RAWKEY & msg->Code==95)
		if(egShowAmigaGuide(eg, "Screen"))
		{
			ULONG signal=Wait(eg->AmigaGuideSignal);

			if(signal & eg->AmigaGuideSignal)
				egHandleAmigaGuide(eg);
		}
	return 1;
}

BYTE SelectPubScreen(char **pubname)
{
	struct ListviewRequester	*req;
	struct List								*publist;
	BYTE success=FALSE;

#ifdef MYDEBUG_H
	DebugOut("SelectPubScreen");
#endif

	if(publist=CopyPubScreenList())
	{
		register WORD winleft=attribTask.window->LeftEdge,
									wintop=attribTask.window->TopEdge;

		if(req=mrAllocRequest(MR_ListviewRequest,
													MR_Window,							mainTask.window,
													MR_InitialLeftEdge,			winleft+X1(screenstring),
													MR_InitialTopEdge,			wintop+Y2(screenstring),
													MR_InitialPercentV,			20,
													MR_InitialWidth,				EG_PopupWidth+W(screenstring),
													MR_SimpleRefresh,				TRUE,
													MRLV_Labels,						publist,
													MRLV_DropDown,					TRUE,
													MR_Gadgets,							NULL,
													TAG_END))
		{
			if(mrRequest(req,
										MR_IntuiMsgFunc,				screenhelp,
										TAG_DONE))
				if(req->selectednode!=NULL)
				{
					RenameText(pubname, req->selectednode->ln_Name);
					success=TRUE;
				}

			mrFreeRequest(req);
		}
		FreeList(publist);
	}
	return success;
}

#endif
