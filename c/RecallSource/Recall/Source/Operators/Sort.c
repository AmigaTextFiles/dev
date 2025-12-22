/*
 *	File:					Sort.c
 *	Description:	Sorts a Recall project by name
 *
 *	(C) 1994,1995, Ketil Hunn
 *
 */

#ifndef	SORTBYNAME_H
#define	SORTBYNAME_H

#include <exec/types.h>
#include <exec/ports.h>
#include <exec/lists.h>
#include <exec/memory.h>
#include <utility/utility.h>
#include <intuition/intuition.h>
#include <libraries/gadtools.h>

//#include <stdio.h>
#include <clib/exec_protos.h>
#include <clib/alib_protos.h>
#include <clib/alib_stdio_protos.h>
#include <clib/utility_protos.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/macros.h>

struct Library	*UtilityBase, *EasyGadgetsBase, *TimerBase;
BYTE parsedirs=0;
struct Screen *screen=NULL;
struct List *list=NULL;
struct MsgPort	*port, *ioport;
struct RecallMsg	*recmsg;
struct timerequest		*timerIO;
struct MsgPort				*timerport;

#include "Modules.h"
#include "ProjectStructures.h"
#include "AdjustYear.h"
#include "MakeDate.h"

#include "Sort_rev.h"
char version[]=VERSTAG;
#include "myinclude:mylist.h"

#include <clib/easygadgets_protos.h>
#include <libraries/easygadgets.h>
#include "EG:Macros.h"
struct EasyGadgets	*eg;

struct egTask	sortTask;
struct egGadget	*sortby,
								*dirs,
								*sort,
								*cancel;

#define	SORTBYTXT	"Sort _by"
#define	NAMETXT		"Name"
#define	DATETXT		"Date"

#define	DIRSTXT		"_Dirs"
#define	FIRSTTXT	"First"
#define	LASTTXT		"Last"

#define	SORTTXT		"_Sort"
#define	CANCELTXT	"C_ancel"

char	*sortbylabels[]={NAMETXT,DATETXT,NULL},
			*dirslabels[]={FIRSTTXT,LASTTXT,NULL};

#define	GID_SORTBY	1
#define	GID_DIRS		2
#define	GID_SORT		3
#define	GID_CANCEL	4

WORD lsize, rsize, bsize;
BYTE type, method, changed=FALSE;

__asm ULONG FindMinDate(register __a0 struct List *list)
{
	struct Node *node;
	ULONG mindate=~0;

	for(every_node)
		mindate=MIN(mindate, MakeDate((struct DateNode *)node));

	return mindate;
}

__asm struct Node *FindMinNode(	register __a0 struct List *list,
																register __a1 struct Node *node)
{
	register struct Node *minnode=node;
	ULONG mindate;

	if(node->ln_Type!=REC_DIR)
		mindate=FindMinDate(((struct EventNode *)node)->datelist);
	while(TRUE)
	{
		if(type==0)
		{
			if(Stricmp(node->ln_Name, minnode->ln_Name)<0)
				minnode=node;
		}
		else
		{
			ULONG tmpdate;

			if(node->ln_Type!=REC_DIR)
			{
//printf("sjekker %s\n", node->ln_Name);
				if(mindate>(tmpdate=FindMinDate(((struct EventNode *)node)->datelist)))
				{
					minnode=node;
					mindate=tmpdate;
				}
			}
		}
		if(NULL==(node=GetSucc(list, node)))
			break;
	}
//printf("%s er minst\n", minnode->ln_Name);
	return minnode;
}

__asm __stackext void SelectSort(register __a0 struct List *list)
{
	register ULONG i=0;

	if(!IsNil(list))
	{
		register struct Node *node, *minnode;

		for(every_node)
		{
			if(node->ln_Type==REC_DIR && parsedirs==TRUE)
				SelectSort(((struct EventNode *)node)->children);
			if(minnode=FindMinNode(list, node))
			{
				BYTE swap;

				if(type==0)
				{
					if(Stricmp(node->ln_Name, minnode->ln_Name)>0)
						swap=TRUE;
				}
				else
				{
					ULONG stamp1=0, stamp2=0;

					if(node->ln_Type!=REC_DIR)
						stamp1=MakeDate((struct DateNode *)(((struct EventNode *)node)->datelist->lh_Head));
					if(minnode->ln_Type!=REC_DIR)
						stamp2=MakeDate((struct DateNode *)(((struct EventNode *)minnode)->datelist->lh_Head));

					if(stamp1>stamp2)
						swap=TRUE;

//printf("sjekker %ld - %ld\n", stamp1, stamp2);
				}

				if(swap)
				{
//printf("bytter %s - %s\n", node->ln_Name, minnode->ln_Name);
					SwapNodes(list, node, minnode);
					node=minnode;
				}
			}
			++i;
		}

		switch(method)
		{
			case 0:
				{
					register struct Node *tmp;

					node=list->lh_TailPred;
					while(i--)
						if(node->ln_Type==REC_DIR)
						{
							tmp=node->ln_Pred;
							Remove(node);
							AddHead(list, node);
							node=tmp;
						}
				}
				break;
			case 1:
				{
					register struct Node *tmp;

					node=list->lh_Head;
					while(i--)
						if(node->ln_Type==REC_DIR)
						{
							tmp=node->ln_Succ;
							Remove(node);
							AddTail(list, node);
							node=tmp;
						}
				}
				break;
		}
	}
}

void DrawSortBorders(void)
{
	UWORD tmp;

	egGroupFrame(eg, sortTask.window, SORTBYTXT,
			LeftMargin, tmp=Y1(sortby)-GBT,
			LeftMargin+GBL+lsize+EG_LabelSpace,
//			sortTask.window->Height-BottomMargin2-GadDefHeight-GadVSpace
			tmp=GBT+tmp+MXHeight*2+GadVSpace+GBB);
	egGroupFrame(eg, sortTask.window, DIRSTXT,
			X1(dirs)-GBL, Y1(dirs)-GBT,
			sortTask.window->Width-RightMargin,
//			sortTask.window->Height-BottomMargin2-GadDefHeight-GadVSpace);
			tmp);
}

void RenderSortWindow(void)
{
	egCreateContext(eg, &sortTask);

	sortby=egCreateGadget(eg,
								EG_Window,			sortTask.window,
								EG_GadgetKind,	MX_KIND,
								EG_TextAttr,		screen->Font,
								EG_Width,				MXWidth,
								EG_Height,			MXHeight,
								EG_TopEdge,			TopMargin+GBT+FontHeight/2,
								EG_LeftEdge,		LeftMargin+GBL,
								EG_GadgetID,		GID_SORTBY,
								EG_Flags,				PLACETEXT_RIGHT,
								EG_VanillaKey,	egFindVanillaKey(SORTBYTXT),
								GTMX_Labels,		sortbylabels,
								TAG_END);
	dirs=egCreateGadget(eg,
								EG_LeftEdge,		sortTask.window->Width-rsize-GBR-RightMargin,
								EG_GadgetID,		GID_DIRS,
								EG_VanillaKey,	egFindVanillaKey(DIRSTXT),
								GTMX_Labels,		dirslabels,
								TAG_END);

	sort=egCreateGadget(eg,
								EG_GadgetKind,	BUTTON_KIND,
								EG_LeftEdge,		LeftMargin,
								EG_TopEdge,			sortTask.window->Height-BottomMargin2-GadDefHeight,
								EG_Width,				bsize,
								EG_Height,			GadDefHeight,
								EG_GadgetID,		GID_SORT,
								EG_Flags,				0,
								EG_GadgetText,	SORTTXT,
								TAG_END);
	cancel=egCreateGadget(eg,
								EG_LeftEdge,		sortTask.window->Width-bsize-LeftMargin,
								EG_GadgetID,		GID_CANCEL,
								EG_GadgetText,	CANCELTXT,
								TAG_END);
	egRenderGadgets(&sortTask);
	DrawSortBorders();
}

void OpenSortTask(void)
{
	WORD minwidth, minheight, tmp;
	struct MsgPort	*port;

	lsize=egMaxLen(eg->RPort, NAMETXT, DATETXT, NULL)+EG_LabelSpace+MXWidth;
	rsize=egMaxLen(eg->RPort, FIRSTTXT, LASTTXT, NULL)+EG_LabelSpace+MXWidth;
	bsize=egMaxLen(eg->RPort, SORTTXT, CANCELTXT, NULL)+GadHInside;

	rsize=MAX(rsize, egTextWidth(eg->RPort, SORTBYTXT)+5);
	lsize=MAX(lsize, egTextWidth(eg->RPort, DIRSTXT)+5);

	tmp=MAX(GBL*2+rsize+lsize+GBR*2, bsize*2+GadHSpace);

	minwidth=LeftMargin+tmp+GadHSpace*2+RightMargin;
	minheight=TopMargin+GBT+FontHeight*3+GadVSpace+GadDefHeight+GBB+BottomMargin2;

	if(port=CreateMsgPort())
	{
		if(egOpenTask(&sortTask, screen, NULL,
										WA_Title,					VSTRING,
										WA_Left,					(screen->Width-minwidth)/2,
										WA_Top,						(screen->Height-minheight)/2,
										WA_Width,					minwidth,
										WA_Height,				minheight,
										WA_AutoAdjust,		TRUE,
										WA_Activate,			TRUE,
										WA_DragBar,				TRUE,
										WA_DepthGadget,		TRUE,
										WA_CloseGadget,		TRUE,
										WA_RMBTrap,				TRUE,
										WA_PubScreen,			screen,
//										EG_InitialCentre,	TRUE,
										TAG_END))
		{
			RenderSortWindow();

			sortTask.window->UserPort=port;
			ModifyIDCMP(sortTask.window,	IDCMP_REFRESHWINDOW|
																		BUTTONIDCMP|
																		IDCMP_CLOSEWINDOW|
																		MXIDCMP|
																		EG_IDCMPS);
			sortTask.status=STATUS_OPEN;
			while(sortTask.status==STATUS_OPEN)
			{
				struct IntuiMessage *msg;

				egWait(eg, 1L<<sortTask.window->UserPort->mp_SigBit);
			  while(msg=egGetMsg(eg, port, &sortTask))
					switch(msg->Class)
					{
						case IDCMP_REFRESHWINDOW:
							GT_BeginRefresh(sortTask.window);
							DrawSortBorders();
							GT_EndRefresh(sortTask.window, TRUE);
							break;
						case IDCMP_CLOSEWINDOW:
							sortTask.status=STATUS_CLOSED;
							break;
						case IDCMP_GADGETDOWN:
						case IDCMP_GADGETUP:
							switch(((struct Gadget *)msg->IAddress==NULL ? 0: ((struct Gadget *)msg->IAddress)->GadgetID))
							{
								case GID_SORTBY:
									type=(BYTE)msg->Code;
									break;
								case GID_DIRS:
									method=(BYTE)msg->Code;
									break;
								case GID_SORT:
									{
										struct SignalSemaphore	*semaphore;

										Forbid();
										if(semaphore=FindSemaphore(EVENTSEMAPHORE))
											if(AttemptSemaphore(semaphore)==FALSE)
												semaphore=NULL;
										Permit();

										if(semaphore)
										{
											SelectSort(list);
											ReleaseSemaphore(semaphore);
											sortTask.status=STATUS_CLOSED;
											changed=TRUE;
										}
										else
											egRequest(sortTask.window,
																NAME " "VERS,
																"Cannot perform.\nList locked by another module",
																"OK", NULL);
									}
									break;
								case GID_CANCEL:
									sortTask.status=STATUS_CLOSED;
									break;
							}
							break;
					}
			}
			egCloseTask(&sortTask);
		}
		DeleteMsgPort(port);
	}
}

BYTE SortWindow(void)
{
	if(eg=egAllocEasyGadgets(screen,	TAG_DONE))
	{
		OpenSortTask();

		egFreeEasyGadgets(eg);
		return TRUE;
	}
	return FALSE;
}

void __main(char *BE_NICE)
{
	struct Message	*msg;

	if(UtilityBase=OpenLibrary("utility.library", 37L))
	{
		if(EasyGadgetsBase=OpenLibrary("easygadgets.library", 1L))
		{
			if(timerport=CreateMsgPort())
			{
				if(timerIO=(struct timerequest *)CreateExtIO(timerport, sizeof(struct timerequest)))
				{
					if(0==(OpenDevice(TIMERNAME, UNIT_VBLANK, (struct IORequest *)timerIO, 0L)))
					{
						TimerBase=(struct Library *)timerIO->tr_node.io_Device;

						Forbid();
						ioport=FindPort(RECALL_PORT);
						Permit();

						if(ioport)
						{
							if(port=CreateMsgPort())
							{
								if(recmsg=AllocMessage(port, OPERATOR_TYPE))
								{
									SendMessage(ioport, recmsg,
															REC_InitMessage,	TRUE,
															REC_GetEventList,	&list,
															REC_GetScreen,		&screen,
															TAG_DONE);
									parsedirs=(recmsg->flags & PARSEDIRS);

									egLinkTasks(&sortTask, NULL);

									if(screen && list)
										SortWindow();

									if(changed)
										SendMessage(ioport, recmsg,
																REC_UpdateData,		TRUE,
																TAG_DONE);
									FreeVec(recmsg);
								}
								DeleteMsgPort(port);
							}
							CloseDevice((struct IORequest *)timerIO);
						}
						DeleteExtIO((struct IORequest *)timerIO);
					}
					while(msg=GetMsg(timerport))
						ReplyMsg(msg);
					DeleteMsgPort(timerport);
				}
			}
			CloseLibrary(EasyGadgetsBase);
		}
		CloseLibrary(UtilityBase);
	}
}

#endif
