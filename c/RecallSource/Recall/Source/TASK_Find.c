/*
 *	File:					TASK_Find.c
 *	Description:	Window for find
 *
 *	(C) 1994,1995 Ketil Hunn
 *
 */

#ifndef	TASK_FIND_C
#define	TASK_FIND_C

/*** INCLUDES ************************************************************************/
#include "System.h"
#include "System_Prefs.h"
#include "Find.h"
#include "MainMenu.h"

/*** DEFINES *************************************************************************/
#define	FINDER_IGNORECASE			1
#define	FINDER_ONLYWHOLEWORDS	2
#define	FINDER_REPLACEMODE		4
#define	FINDER_DONE						8
#define	FINDER_REPLACEALL			16
#define	FINDER_FOUND					32

#define	GID_FINDSTRING				1
#define	GID_REPLACESTRING			2
#define	GID_FINDBUTTON				3
#define	GID_CANCELFIND				4
#define	GID_IGNORECASE				5
#define	GID_ONLYWHOLEWORDS		6
#define	GID_REPLACEMODE				7

/*** GLOBALS *************************************************************************/
struct egTask	findTask;
struct FinderStruct finder;

WORD findlabelssize, findcheckssize;

struct egGadget	*findstring,
								*replacestring,
								*ignorecase,
								*onlywholewords,
								*replacemode,
								*find,
								*cancelfind;

/*** FUNCTIONS ***********************************************************************/
__asm __saveds ULONG RenderFindTask(register __a0 struct Hook *hook,
																		register __a2 APTR	      object,
																		register __a1 APTR	      message)
{
#ifdef MYDEBUG_H
	DebugOut( "RenderFindWindow");
#endif

	geta4();
	egCreateContext(eg, &findTask);

	ignorecase=egCreateGadget(eg,
											EG_Window,				findTask.window,
											EG_Flags,					PLACETEXT_RIGHT,
											EG_GadgetKind,		CHECKBOX_KIND,
											EG_TextAttr,			fontattr,
											EG_LeftEdge,			findTask.window->Width-RightMargin-findcheckssize,
											EG_DefaultWidth,	TRUE,
											EG_DefaultHeight,	TRUE,
											EG_PlaceWindowTop,	TRUE,
											EG_GadgetText,		egGetString(MSG__IGNORECASE),
											EG_GadgetID,			GID_IGNORECASE,
											EG_HelpNode,			"FindAttributes",
											GTCB_Checked,			finder.ignorecase,
											TAG_END);

	onlywholewords=egCreateGadget(eg,
											EG_PlaceBelow,	ignorecase,
											EG_GadgetText,	egGetString(MSG__ONLYWHOLEWORDS),
											EG_GadgetID,		GID_ONLYWHOLEWORDS,
											GTCB_Checked,		finder.onlywholewords,
											TAG_END);

	replacemode=egCreateGadget(eg,
											EG_PlaceBelow,	onlywholewords,
											EG_GadgetText,	egGetString(MSG__REPLACEMODE),
											EG_GadgetID,		GID_REPLACEMODE,
											GTCB_Checked,		finder.replacemode,
											TAG_END);

	findstring=egCreateGadget(eg,
											EG_GadgetKind,	STRING_KIND,
											EG_LeftEdge,		LeftMargin+findlabelssize,
											EG_Flags,				PLACETEXT_LEFT,
											EG_PlaceWindowTop,		TRUE,
											EG_Width,				X1(ignorecase)-GadVSpace-LeftMargin-findlabelssize-GBR,
											EG_DefaultHeight,	TRUE,
											EG_GadgetText,	egGetString(MSG__FINDSTRING),
											EG_GadgetID,		GID_FINDSTRING,
											EG_HelpNode,		"Menu_Find",
											GTST_String,		finder.findstring,
											TAG_END);

	replacestring=egCreateGadget(eg,
											EG_PlaceBelow,	findstring,
											EG_GadgetText,	egGetString(MSG__REPLACESTRING),
											EG_GadgetID,		GID_REPLACESTRING,
											GTST_String,		finder.replacestring,
											GA_Disabled,		!finder.replacemode,
											TAG_END);

	find=egCreateGadget(eg,
											EG_GadgetKind,	BUTTON_KIND,
											EG_PlaceWindowBottom,	TRUE,
											EG_Width,				egTextWidth(eg, egGetString(MSG__FIND))+GadHInside,
											EG_GadgetText,	egGetString(MSG__FIND),
											EG_GadgetID,		GID_FINDBUTTON,
											EG_Flags,				0,
											TAG_END);

	cancelfind=egCreateGadget(eg,
											EG_Width,				egTextWidth(eg, egGetString(MSG__CANCEL))+GadHInside,
											EG_AlignRight,	replacestring,
											EG_GadgetText,	egGetString(MSG__CANCEL),
											EG_GadgetID,		GID_CANCELFIND,
											TAG_END);
	return 1L;
}

__asm ULONG OpenFindTask(	register __a0 struct Hook *hook,
													register __a2 APTR	      object,
													register __a1 APTR	      message)
{
	WORD minwidth, minheight;

#ifdef MYDEBUG_H
	DebugOut("OpenFindTask");
#endif

	geta4();
//	finder.replacemode=mode;
	if(egTaskToFront(&findTask))
	{
		UpdateFindTask();
		return FALSE;
	}

	findcheckssize	=egMaxLen(eg,	egGetString(MSG__IGNORECASE),
																egGetString(MSG__ONLYWHOLEWORDS),
																egGetString(MSG__REPLACEMODE),
																NULL)+EG_LabelSpace+CheckboxWidth;
	findlabelssize	=egMaxLen(eg,	egGetString(MSG__FINDSTRING),
																egGetString(MSG__REPLACESTRING),
																NULL)+EG_LabelSpace;

	minwidth=LeftMargin+EG_LabelSpace+findlabelssize+
						+egTextWidth(eg, egGetString(MSG__FIND))
						+egTextWidth(eg, egGetString(MSG__CANCEL))
						+GadHInside*2+GadHSpace*2+findcheckssize+RightMargin;
	minheight=TopMargin+GadDefHeight*3+GadVSpace*3+BottomMargin;

	if(egOpenTask(&findTask,
										WA_Title,					egGetString(MSG_SEARCH),
//										WA_Left,					findTask.coords.LeftEdge,
//										WA_Top,						findTask.coords.TopEdge,
										WA_Width,					MAX(minwidth, findTask.coords.Width),
										WA_Height,				minheight,
										WA_MinWidth,			minwidth,
										WA_MinHeight,			minheight,
										WA_MaxWidth,			~0,
										WA_MaxHeight,			minheight,
										WA_AutoAdjust,		TRUE,
										WA_Activate,			TRUE,
										WA_DragBar,				TRUE,
										WA_DepthGadget,		TRUE,
										WA_SizeGadget,		TRUE,
										WA_SizeBBottom,		TRUE,
										WA_CloseGadget,		TRUE,
										WA_NewLookMenus,	TRUE,
										WA_PubScreen,			mainTask.screen,
										WA_MenuHelp,			TRUE,
										EG_LendMenu,			mainMenu,
										EG_OpenFunc,			(ULONG)OpenFindTask,
										EG_RenderFunc,		(ULONG)RenderFindTask,
										EG_HandleFunc,		(ULONG)HandleFindTask,
										EG_IconifyGadget,	TRUE,
										EG_IDCMP,					STRINGIDCMP|
																			IDCMP_MENUPICK|
																			IDCMP_CLOSEWINDOW|
																			IDCMP_GADGETUP,
										EG_InitialCentre,	TRUE,
										TAG_END))
	{
		UpdateMainMenu();

		return TRUE;
	}
	return FALSE;
}

void FindReplace(void)
{
	finder.done=finder.replaceall=FALSE;

	if(finder.replacemode)
	{
		if(eventnode)
		{
			if(eventnode->nn_Node.ln_Type==REC_DIR)
				ReplaceEvent(eventlist, eventnode);
			else
				ReplaceEvent(eventlist, (struct Node *)eventnode);
		}
		else if(!IsNil(eventlist))
			ReplaceEvent(eventlist, NULL);
	}
	else
		FindEvent(eventlist, eventnode, 0);
	UpdateMainMenu();
}

__asm __saveds ULONG HandleFindTask(register __a0 struct Hook *hook,
																		register __a2 APTR	      object,
																		register __a1 APTR	      message)
{
	struct IntuiMessage *msg;
	BYTE findflag=FALSE;

	geta4();
	msg=(struct IntuiMessage *)hook->h_Data;
	switch(msg->Class)
	{
		case IDCMP_MENUPICK:
			HandleMainMenu(&findTask, msg->Code);
			break;

		case IDCMP_CLOSEWINDOW:
			egCloseTask(&findTask);
			break;

		case IDCMP_GADGETDOWN:
		case IDCMP_GADGETUP:
			switch(((struct Gadget *)msg->IAddress)->GadgetID)
			{
				case GID_FINDSTRING:
					strcpy(finder.findstring, String(findstring));
					if(finder.replacemode==FALSE)
					{
						findTask.status=STATUS_CLOSED;
						findflag=TRUE;
					}
					else
						ActivateGadget(replacestring->gadget, findTask.window, NULL);
					break;
				case GID_REPLACESTRING:
					strcpy(finder.replacestring, String(replacestring));
					findTask.status=STATUS_CLOSED;
					findflag=TRUE;
					break;
				case GID_FINDBUTTON:
					findTask.status=STATUS_CLOSED;
					findflag=TRUE;
					break;
				case GID_CANCELFIND:
					findTask.status=STATUS_CLOSED;
					break;
				case GID_IGNORECASE:
					finder.ignorecase=!finder.ignorecase;
					break;
				case GID_ONLYWHOLEWORDS:
					finder.onlywholewords=!finder.onlywholewords;
					break;
				case GID_REPLACEMODE:
					finder.replacemode=!finder.replacemode;
					UpdateFindTask();
					break;
			}
			break;
	}
	if(findTask.status==STATUS_CLOSED)
	{
		strcpy(finder.findstring, String(findstring));
		strcpy(finder.replacestring, String(replacestring));
		egCloseTask(&findTask);
		UpdateMainMenu();
		if(findflag)
			FindReplace();
	}
	return 1L;
}

void UpdateFindTask(void)
{
	struct Window *win=findTask.window;

#ifdef MYDEBUG_H
	DebugOut( "UpdateFindTask");
#endif
	if(win==NULL)
		return;

	egSetGadgetAttrs(replacestring, win, NULL,
										GA_Disabled,	!finder.replacemode,
										TAG_DONE);
	egSetGadgetAttrs(ignorecase, win, NULL,
										GTCB_Checked,	finder.ignorecase,
										TAG_DONE);
	egSetGadgetAttrs(onlywholewords, win, NULL,
										GTCB_Checked,	finder.onlywholewords,
										TAG_DONE);
	egSetGadgetAttrs(replacemode, win, NULL,
										GTCB_Checked,	finder.replacemode,
										TAG_DONE);
}

#endif
