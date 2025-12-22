/*
 *	File:					test.c
 *	Description:	
 *
 *	(C) 1994, Ketil Hunn
 *
 */

#include <intuition/intuitionbase.h>
#include <libraries/gadtools.h>

#include <clib/alib_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <dos.h>
#include <clib/macros.h>

#include <stdio.h>

#include "myinclude:myDebug.h"

#include "myinclude:mylist.h"
//#include "MoreReq.c"
#include "morereq:/include/MoreReq.h"
#include "morereq:/proto/MoreReq_protos.h"
#include "morereq:MoreReq_pragmas.h"

#define	POPUPGAD_ID	777

int main(int argc, char **argv)
{
	struct IntuitionBase			*IntuitionBase;
	struct Library						*GadToolsBase,	*MoreReqBase;
	struct ListviewRequester	*lvreq;
	struct List								*list;

#ifdef MYDEBUG_H
	debugarg=argc;
#endif

if(MoreReqBase=OpenLibrary("morereq.library", 0))
{
	if(IntuitionBase=(struct IntuitionBase *)OpenLibrary("intuition.library", 37L))
	{
//		if(GadToolsBase=OpenLibrary("gadtools.library", 37L))
		{
//			if(UtilityBase=OpenLibrary("utility.library", 37L))
			{
				if(list=InitList())
				{
					struct Screen		*screen;
					register LONG retvalue;

					if(screen=LockPubScreen(NULL))
					{

						if(lvreq=mrAllocRequest(	MR_ListviewRequest,
																			MR_Screen,						screen,
																			MR_SizeGadget,				TRUE,
																			MR_CloseGadget,				TRUE,
																			MRLV_Labels,					list,
																			MR_UserData,					(APTR)777,
																			TAG_DONE))
						{
							AddNode(list, "This is a small example");
							AddNode(list, "just to show how the");
							AddNode(list, MOREREQNAME " functions works.");
							AddNode(list, "");
							AddNode(list, "The requester may be centred");
							AddNode(list, "horizontally and vertically,");
							AddNode(list, "or be positioned anywhere on");
							AddNode(list, "the screen.");

							mrRequest(	lvreq,
													MR_InitialPercentH,		30,
													MR_InitialPercentV,		30,
													MR_InitialCentreH,		TRUE,
													MR_InitialCentreV,		TRUE,
													MR_Gadgets,						"_Continue",
													MRLV_ReadOnly,				TRUE,
													TAG_DONE);

							ClearList(list);
							AddNode(list, MOREREQNAME " is handled like the asl requesters");
							AddNode(list, "(using mrAllocRequest() and mrFreeRequest())");
							AddNode(list, "and takes the similar tags as parameters.");
							AddNode(list, "");
							AddNode(list, MOREREQNAME " is font-adaptable and sizeable");
							AddNode(list, "(both may be overridden) and will look");
							AddNode(list, "good on any Worbench V2.04 and higher.");
							AddNode(list, "");
							AddNode(list, "Do you understand?");
							while(0==mrRequest(lvreq,
																	MR_Gadgets,	"_Yes|Que? I'm from _Barcelona",
																	TAG_DONE))
								;

							ClearList(list);
							AddNode(list, MOREREQNAME" makes it easy for the user");
							AddNode(list, "to select among a variety of options");
							AddNode(list, "and makes it easy to pop up small");
							AddNode(list, "requesters like those in ToolManager");
							AddNode(list, "");
							AddNode(list, "But " MOREREQNAME " adds MORE flexibility:");
							AddNode(list, "- Unlimited number of buttons may be");
							AddNode(list, "  displayed below the listview to");
							AddNode(list, "  allow different actions on the");
							AddNode(list, "  selected item.");
							AddNode(list, "- The listview accepts doubleclicking");
							AddNode(list, "  on items.");
							AddNode(list, "- Remembers its position, height, width,");
							AddNode(list, "  as well as all other settings.");
							AddNode(list, "- Note that item 4 is pre-selected.");
							AddNode(list, "");
							AddNode(list, "Select one item and press a button.");

							retvalue=mrRequest(lvreq,
																	MR_InitialPercentH,	20,
																	MR_InitialPercentV,	60,
																	MR_InitialCentreH,	TRUE,
																	MR_InitialCentreV,	TRUE,
																	MR_Gadgets,					"_Let's|_see|_more|_of|_this|_Cancel",
																	MRLV_ReadOnly,			FALSE,
																	MRLV_Selected,			3,
																	TAG_DONE);

							printf("You pressed button %ld.\n", retvalue);
							if(lvreq->selectednode==NULL)
								printf("You did not select a list item.\n");
							else
								printf("You selected node »%s«\n", lvreq->selectednode->ln_Name);


							ClearList(list);
							AddNode(list, MOREREQNAME " may also display");
							AddNode(list, "its requester as a popup");
							AddNode(list, "menu.");
							mrRequest(	lvreq,
													MRLV_DropDown,			TRUE,
													MR_InitialPercentV,	25,
													MR_InitialPercentH,	1,
													MR_InitialCentreH,	TRUE,
													MR_InitialCentreV,	TRUE,
													MRLV_ReadOnly,			FALSE,
													MR_Gadgets,					"_OK|_<|_>|_Edit|_Delete|_Cancel",
													MRLV_Selected,			~0,
													TAG_DONE);

							ClearList(list);
							AddNode(list, MOREREQNAME " may also display");
							AddNode(list, "its requester as a popup");
							AddNode(list, "menu.");
							AddNode(list, "");
							AddNode(list, "Here's the same requester");
							AddNode(list, "with all buttons of the");
							AddNode(list, "same width.");

							mrRequest(	lvreq,
													MR_SameGadgetWidth,	TRUE,
													MR_InitialCentreH,	TRUE,
													MR_InitialCentreV,	TRUE,
													TAG_DONE);
							{
								struct Window				*win;
								struct DrawInfo			*dri;
								void								*vi;
								struct Gadget				*text, *gad, *glist;
								struct NewGadget		ng;
								struct PopUpGadget	popup;
								UBYTE								name[256];

								ClearList(list);
								AddNode(list, "Bacon");
								AddNode(list, "Lettuce");
								AddNode(list, "Tomatoes");
								AddNode(list, "Salt");
								AddNode(list, "Milk");
								AddNode(list, "Bread");
								AddNode(list, "Eggs");
								AddNode(list, "Juice");
								AddNode(list, "Stimulants");

								if(vi=GetVisualInfo(screen, TAG_END))
								{
									if(dri=GetScreenDrawInfo(screen))
									{
										gad=CreateContext(&glist);

										ng.ng_TextAttr		=lvreq->textattr;
										ng.ng_VisualInfo	=vi;
										ng.ng_Flags				=0;

										/* no fancy resizable stuff - mostly hard coordinates */
										ng.ng_TopEdge			=22;
										ng.ng_LeftEdge		=10;
										ng.ng_Width				=150;
										ng.ng_Height			=MAX(13, lvreq->textattr->ta_YSize+4);
										ng.ng_GadgetText	=NULL;
										text=gad=CreateGadget(TEXT_KIND, gad, &ng, 
																					GTTX_Border,	TRUE,
																					GTTX_Text,		name,
																					TAG_DONE);

										ng.ng_LeftEdge		=161;
										ng.ng_Width				=MR_PopUpGadgetWidth;
										ng.ng_GadgetID		=POPUPGAD_ID;

										mrCreateGadget(POPUP_KIND, gad, &ng, &popup, dri, TAG_DONE);

										if(win=OpenWindowTags(NULL,
																WA_Title,					"PopUpGadget example",
																WA_Left,					screen->Width/2-186/2,
																WA_Top,						screen->Height/2-50/2,
																WA_Width,					186,
																WA_Height,				50,
																WA_AutoAdjust,		TRUE,
																WA_Activate,			TRUE,
																WA_DragBar,				TRUE,
																WA_DepthGadget,		TRUE,
																WA_CloseGadget,		TRUE,
																WA_Gadgets,				glist,
																WA_IDCMP,					IDCMP_REFRESHWINDOW|
																									IDCMP_CLOSEWINDOW|
																									IDCMP_GADGETUP,
																WA_CustomScreen,	screen,
																TAG_DONE))
										{
											struct IntuiMessage *msg;
											BOOL								done=FALSE;

											/* quick'n dirty */
											while(!done)
											{
												Wait(1L<<win->UserPort->mp_SigBit);
												msg=GT_GetIMsg(win->UserPort);
											
												switch(msg->Class)
												{
													case IDCMP_REFRESHWINDOW:
														GT_BeginRefresh(win);
														GT_EndRefresh(win, TRUE);
														break;
													case IDCMP_CLOSEWINDOW:
														done=TRUE;
														break;
													case IDCMP_GADGETUP:
														switch(((struct Gadget *)msg->IAddress)->GadgetID)
														{
															case POPUPGAD_ID:
																if(mrRequest(lvreq,
																						MR_Window,					win,
																						MR_InitialLeftEdge,	win->LeftEdge+10,
																						MR_InitialTopEdge,	win->TopEdge+22+ng.ng_Height,
																						MR_InitialWidth,		168,
																						MR_InitialPercentV,	25,
																						MR_Gadgets,					NULL,
																						MR_SameGadgetWidth,	FALSE,
																						MR_SleepWindow,			TRUE,
																						MRLV_DropDown,			TRUE,
																						TAG_DONE))
																	if(lvreq->selectednode!=NULL) /* always check if NULL */
																	{
																		strcpy(name, lvreq->selectednode->ln_Name);
																		GT_SetGadgetAttrs(text, win, NULL,
																										GTTX_Text,	name,
																										TAG_DONE);
																	}
																break;
														}
														break;
												}
												GT_ReplyIMsg(msg);
											}
											CloseWindow(win);
										}
										else
											printf("Could not open window\n");											
										FreeGadgets(glist);
										mrFreeGadget((APTR)&popup);	
										FreeScreenDrawInfo(screen, dri);
									}
									else
										printf("Could not get drawinfo for screen\n");
									FreeVisualInfo(vi);
								}
								else
									printf("Could not get visual info\n");
							}

							ClearList(list);
							AddNode(list, MOREREQNAME " is © 1994 to:");
							AddNode(list, "");
							AddNode(list, "Ketil Hunn");
							AddNode(list, "Ketil.Hunn@hiMolde.no");
							AddNode(list, "");
							AddNode(list, "See docs for further information");
							AddNode(list, "and distributability.");

							mrRequest(	lvreq,
													MR_Window,					NULL,				/* MR remembers last window, but we closed it */
													MRLV_DropDown,			FALSE,
													MR_Gadgets,					"Be _well",
													MR_InitialPercentH,	35,
													MR_InitialPercentV,	30,
													MR_InitialCentreH,	TRUE,
													MR_InitialCentreV,	TRUE,
													MRLV_ReadOnly,			TRUE,
													MR_TitleText,				"Copyrights",
													MR_SizeGadget,			FALSE,
													MR_CloseGadget,			FALSE,
													TAG_DONE);

							FreeList(list);
							mrFreeRequest(lvreq);
						}
						else
							printf("Could not allocate ListviewRequester\n");

						UnlockPubScreen(NULL, screen);
					}
					else
						printf("Could not lock default public scsreen\n");
				}
				else
					printf("Could not allocate memory for list\n");

			}
		}
		CloseLibrary((struct Library *)IntuitionBase);
	}
	CloseLibrary(MoreReqBase);
}
else
	printf("Could not open morereq.library V1\n");
}
