/* Demonstration der Hierarchieklasse.

   (geschrieben unter StormC V1.1)

   $VER:              1.0 (12.06.96)

   Autor:             Thomas Mittelsdorf

   © 1996 HAAGE & PARTNER Computer GmbH,  All Rights Reserved

*/

#include	<stdio.h>
#include	<stdlib.h>
#include	<string.h>

#include	<exec/exec.h>
#include	<exec/memory.h>

#include	<clib/alib_protos.h>

#include	<pragma/asl_lib.h>
#include	<pragma/dos_lib.h>
#include	<pragma/exec_lib.h>
#include	<pragma/intuition_lib.h>
#include	<pragma/utility_lib.h>
#include	<pragma/wizard_lib.h>

#include	<dos/dos.h>
#include	<libraries/asl.h>
#include	<libraries/wizard.h>
#include	<intuition/gadgetclass.h>
#include	<intuition/intuition.h>

#define HierarchyID 		2
#define ArgumentID			8
#define VectorButtonID 	9

struct Library *AslBase;
struct Library *WizardBase;
struct Library *UtilityBase;

APTR	MySurface;

struct Gadget *MyGadgets[10];

struct Screen *MyScreen;
struct FileRequester *MyFReq;

struct Window *MyWindow;

struct NewWindow *MyNewWindow;
struct WizardWindowHandle *MyWinHandle;

char ArgumentPuffer[256]="";

struct MyTreeNode
{
	struct WizardDefaultNode WNode;

	struct MinList list;

	char Name[32];
	int Type;
};

struct MinList MyList;
struct MinList DummyList;

void FreeMyTreeList(struct MinList *list)
{
	while (list->mlh_Head->mln_Succ)
	{
		struct MyTreeNode *t=(struct MyTreeNode *)list->mlh_Head;

		FreeMyTreeList(&t->list);

		Remove((struct Node *)t);
		FreeVec(t);
	}
};

void ReadDir(STRPTR dir,struct MinList *list,struct MyTreeNode *parent)
{
	struct FileInfoBlock fib;

	BPTR mylock;

	if ((mylock=Lock(dir,SHARED_LOCK)))
	{
		if (Examine(mylock,&fib))
		{
			while(ExNext(mylock,&fib))
			{
				struct MyTreeNode *NewNode;

				if ((NewNode=(struct MyTreeNode *)AllocVec(sizeof(MyTreeNode),MEMF_CLEAR|MEMF_PUBLIC)))
				{
					long Ready=FALSE;
					struct MyTreeNode *PredNode=(struct MyTreeNode *)list->mlh_Head;

					NewList((struct List *)&NewNode->list);

					strcpy(NewNode->Name,fib.fib_FileName);

					WZ_InitNode(&NewNode->WNode.WizardNode,1,
																WNODEA_Flags,WNF_TREE|WNF_AUTOMATIC,
																TAG_DONE);

					WZ_InitNodeEntry(&NewNode->WNode.WizardNode,0,
																		WENTRYA_Type,WNE_TREE,
																		WENTRYA_TreeParentNode,parent,
																		WENTRYA_TreeString,NewNode->Name,
																		WENTRYA_TreePen,WZRD_TEXTPEN,
																		WENTRYA_TreeSPen,WZRD_FILLTEXTPEN,
																		TAG_DONE);

					if (fib.fib_DirEntryType>=0)
					{
						char NewDir[256];

						WZ_InitNodeEntry(&NewNode->WNode.WizardNode,0,
																			WENTRYA_TreeChilds,&NewNode->list,
																			TAG_DONE);

						WZ_InitNodeEntry(&NewNode->WNode.WizardNode,0,
																			WENTRYA_TreePen,WZRD_HIGHLIGHTTEXTPEN,
																			WENTRYA_TreeSPen,WZRD_HIGHLIGHTTEXTPEN,
																			TAG_DONE);


						NewNode->Type=0;

						strcpy (NewDir,dir);
						if (AddPart(NewDir,fib.fib_FileName,sizeof(NewDir)))
							ReadDir(NewDir,&NewNode->list,NewNode);
					}
					else
					{
						NewNode->Type=1;
					}

					while (!Ready && PredNode->WNode.WizardNode.Node.mln_Succ)
					{
						if (NewNode->Type>=PredNode->Type)
						{
							if (NewNode->Type==PredNode->Type)
							{
								if (Stricmp(NewNode->Name,PredNode->Name)<0)
								{
									PredNode=(struct MyTreeNode *)PredNode->WNode.WizardNode.Node.mln_Pred;
									Ready=TRUE;
								}
								else
									PredNode=(struct MyTreeNode *)PredNode->WNode.WizardNode.Node.mln_Succ;
							}
							else
								PredNode=(struct MyTreeNode *)PredNode->WNode.WizardNode.Node.mln_Succ;
						}
						else
						{
							PredNode=(struct MyTreeNode *)PredNode->WNode.WizardNode.Node.mln_Pred;
							Ready=TRUE;
						}
					};
					Insert((struct List *)list,(struct Node *)NewNode,(struct Node *)PredNode);
				}
			}
		}
		UnLock(mylock);
	}
}

void main( void)
{
	NewList((struct List *)&MyList);
	NewList((struct List *)&DummyList);

	if ((UtilityBase=OpenLibrary("utility.library",0L)))
	{
		if ((WizardBase=OpenLibrary("wizard.library",0L)))
		{
			if ((AslBase=OpenLibrary("asl.library",0L)))
			{
				if ((MySurface=WZ_OpenSurface("tree.wizard",0L,TAG_DONE)))
				{
					if ((MyScreen=LockPubScreen(0L)))
					{
						if ((MyFReq=AllocAslRequestTags(ASL_FileRequest,ASLFR_Screen,MyScreen,
																							ASLFR_TitleText,"Choose Path ...",
																							TAG_DONE)))
						{
							if ((MyWinHandle=WZ_AllocWindowHandle(MyScreen,0L,MySurface,TAG_DONE)))
							{
								if ((MyNewWindow=WZ_CreateWindowObj(MyWinHandle,1,WWH_GadgetArray,&MyGadgets,
																										WWH_GadgetArraySize,sizeof(MyGadgets),
																									TAG_DONE)))
								{
									SetGadgetAttrs(MyGadgets[HierarchyID],0L,0L,WHIERARCHYA_List,&MyList,
																															WHIERARCHYA_Top,TRUE,
																															TAG_DONE);
									SetGadgetAttrs(MyGadgets[ArgumentID],0L,0L,WARGSA_Arg0,&ArgumentPuffer,
																									TAG_DONE);

									if ((MyWindow=WZ_OpenWindow(MyWinHandle,MyNewWindow,
																										WA_AutoAdjust,TRUE,
																										TAG_DONE)))
									{
										unsigned long Flag=FALSE;

										struct IntuiMessage *msg;

										do
										{
											WaitPort(MyWindow->UserPort);

											if ((msg=(struct IntuiMessage *)GetMsg(MyWindow->UserPort)))
											{
												switch (msg->Class)
												{
													case IDCMP_CLOSEWINDOW:
														{
															Flag=TRUE;
														}
														break;

													case IDCMP_IDCMPUPDATE:
														{

															switch (GetTagData(GA_ID,0,(struct TagItem *)msg->IAddress))
															{
																case HierarchyID:
																	{
																		struct MyTreeNode *t;

																		if (t=(struct MyTreeNode *)WZ_GetNode(&MyList,GetTagData(WHIERARCHYA_Selected,0,(struct TagItem *)msg->IAddress)))
																		{
																			strcpy(ArgumentPuffer,t->Name);

																			SetGadgetAttrs(MyGadgets[ArgumentID],MyWindow,0L,
																									WARGSA_Arg0,&ArgumentPuffer,
																									TAG_DONE);
																		}
																	}
																	break;

																case VectorButtonID:
																	{
																		WZ_LockWindow(MyWinHandle);

																		if (AslRequestTags(MyFReq,ASLFR_DrawersOnly,TRUE,
																											TAG_DONE))
																		{
																			SetGadgetAttrs(MyGadgets[HierarchyID],MyWindow,0L,WHIERARCHYA_List,&DummyList,
																													TAG_DONE);

																			FreeMyTreeList(&MyList);

																			ReadDir(MyFReq->fr_Drawer,&MyList,0L);

																			SetGadgetAttrs(MyGadgets[HierarchyID],MyWindow,0L,
																									WHIERARCHYA_List,&MyList,
																									TAG_DONE);
																		}

																		WZ_UnlockWindow(MyWinHandle);

																	}
																	break;
															}

														}
														break;
												}
												ReplyMsg((struct Message *)msg);
											}

										}while (Flag==FALSE);

										WZ_CloseWindow(MyWinHandle);
									}
								}
								WZ_FreeWindowHandle(MyWinHandle);
							}
							FreeAslRequest(MyFReq);
						}
						UnlockPubScreen(0L,MyScreen);
					}
					WZ_CloseSurface(MySurface);
				}
				CloseLibrary(AslBase);
			}
			CloseLibrary(WizardBase);
		}
		CloseLibrary(UtilityBase);
	}
}