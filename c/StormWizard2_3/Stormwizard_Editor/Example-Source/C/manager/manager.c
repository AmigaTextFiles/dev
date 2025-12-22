#include	<stdio.h>
#include	<stdlib.h>
#include	<string.h>

#include	<clib/alib_protos.h>
#include	<pragma/dos_lib.h>
#include	<pragma/exec_lib.h>
#include	<pragma/intuition_lib.h>
#include	<pragma/utility_lib.h>
#include	<pragma/wizard_lib.h>

#include	<exec/exec.h>
#include	<exec/memory.h>
#include	<intuition/gadgetclass.h>
#include	<intuition/intuition.h>
#include	<utility/utility.h>
#include	<libraries/wizard.h>

#include	"manager.h"

struct Library *UtilityBase;
struct Library *WizardBase;

APTR	MySurface;
struct Screen *MyScreen;

struct Gadget *MyGadgets[WINDOW_GADGETS];
struct WizardWindowHandle *MyWinHandle;
struct Window *MyWindow;

struct MyWinExtension
{
};

/* Diese Struktur wird für dann beim SF_AllocWindowHandle angelegt		**
** und im Feld UserData eingetragen !  Wenn die Größe allerdings			**
** NULL ist, dann darf dieser Zeiger nicht benutzt werden 	!!!				**
** Sie könnten zum Beispiel eine Node-Struktur einbauen und damit     **
** ihre Fensterhandles verketten.																			*/

#define DIRTYPE		0
#define FILETYPE	1

struct MyListNode
{
	struct WizardDefaultNode WNode;
	struct WizardNodeEntry Entry2;

	int Type;
	char FileName[256];

	STRPTR	Format;
	ULONG		FileSize;

};
/* Diese Liste beinhaltet alle wichtigen Daten für einen Eintrag und	**
** besitzt gleichzeitig die WizardListNode, die von den ListView`s 		**
** bzw. in unserem Fall den MultiListViews verlangt wird.							*/

struct MinList DummyList;
struct MinList LeftList;
struct MinList RightList;

struct MinList *QuellList;
struct MinList *ZielList;

struct Gadget *QuellGadget;
struct Gadget *ZielGadget;

struct Gadget *QuellStringGadget;
struct Gadget *ZielStringGadget;

struct Gadget	*QuellToggleGadget;
struct Gadget *ZielToggleGadget;

unsigned long QuellAnzeigeWert,ZielAnzeigeWert;

char QString[256];
char ZString[256];

char *QuellAnzeige=QString;
char *ZielAnzeige=ZString;

struct FileInfoBlock fib;


/* Picture Daten */

struct WizardNewImage *newimage;

struct BitMap *bm,*sbm;
UBYTE Pens[256],SPens[256];

void ReadDirectoryList(STRPTR device,BOOL newKopf)
{
	BPTR mylock;

	WZ_LockWindow(MyWinHandle);

	if (mylock=Lock(device,SHARED_LOCK))
	{
		if (Examine(mylock,&fib))
		{
			QuellAnzeigeWert=0;

			if (newKopf)
				sprintf(QuellAnzeige,"%s: ( %ldk )",&fib.fib_FileName,fib.fib_Size>>10);

			SetGadgetAttrs(QuellGadget,MyWindow,0L,
																			WLISTVIEWA_List,&DummyList,
																			WLISTVIEWA_Top,0,
																			TAG_DONE);


			while (QuellList->mlh_Head->mln_Succ)
			{
				struct MinNode *t=QuellList->mlh_Head;

				Remove((struct Node *)t);
				FreeVec(t);
			}; /* die alte geschichte löschen */


			while (ExNext(mylock,&fib))
			{
				struct MyListNode *NewNode;

				if (NewNode=AllocVec(sizeof(MyListNode),MEMF_CLEAR|MEMF_PUBLIC))
				{
					BOOL	Ready=FALSE;

					struct MyListNode *PredNode=(struct MyListNode *)QuellList->mlh_Head;

					strcpy(NewNode->FileName,fib.fib_FileName);

					WZ_InitNode(&NewNode->WNode.WizardNode,2,TAG_DONE);

					if (fib.fib_DirEntryType>=0)
					{
						NewNode->FileSize=0;
						NewNode->Type=DIRTYPE;

						WZ_InitNodeEntry(&NewNode->WNode.WizardNode,0,WENTRYA_Type,WNE_TEXT,
																							WENTRYA_TextPen,WZRD_HIGHLIGHTTEXTPEN,
																							WENTRYA_TextSPen,WZRD_HIGHLIGHTTEXTPEN,
																							WENTRYA_TextStyle,FS_NORMAL,
																							WENTRYA_TextSStyle,FS_NORMAL,
																							WENTRYA_TextString,NewNode->FileName,
																							TAG_DONE);
						WZ_InitNodeEntry(&NewNode->WNode.WizardNode,1,WENTRYA_Type,WNE_IMAGE,
																							WENTRYA_ImageBitmap,bm,
																							WENTRYA_ImageSBitmap,sbm,
																							WENTRYA_ImageWidth,newimage->Width,
																							WENTRYA_ImageHeight,newimage->Height,
																							TAG_DONE);


					}
					else
					{
						NewNode->FileSize=fib.fib_Size;
						NewNode->Type=FILETYPE;

						NewNode->Format="%ld";

						WZ_InitNodeEntry(&NewNode->WNode.WizardNode,0,WENTRYA_Type,WNE_TEXT,
																							WENTRYA_TextPen,WZRD_TEXTPEN,
																							WENTRYA_TextSPen,WZRD_FILLTEXTPEN,
																							WENTRYA_TextStyle,FS_NORMAL,
																							WENTRYA_TextSStyle,FS_NORMAL,
																							WENTRYA_TextString,NewNode->FileName,
																							TAG_DONE);

						WZ_InitNodeEntry(&NewNode->WNode.WizardNode,1,WENTRYA_Type,WNE_FORMAT,
																							WENTRYA_FormatStruct,&NewNode->Format,
																							WENTRYA_FormatJustification,WZRDPLACE_RIGHT,
																							TAG_DONE);

					};

					while (!Ready && PredNode->WNode.WizardNode.Node.mln_Succ)
					{
						if (NewNode->Type>=PredNode->Type)
						{
							if (NewNode->Type==PredNode->Type)
							{
								if (Stricmp(NewNode->FileName,PredNode->FileName)<0)
								{
									PredNode=(struct MyListNode *)PredNode->WNode.WizardNode.Node.mln_Pred	;
									Ready=TRUE;
								}
								else
									PredNode=(struct MyListNode *)PredNode->WNode.WizardNode.Node.mln_Succ;
							}
							else
								PredNode=(struct MyListNode *)PredNode->WNode.WizardNode.Node.mln_Succ;
						}
						else
						{
							PredNode=(struct MyListNode *)PredNode->WNode.WizardNode.Node.mln_Pred;
							Ready=TRUE;
						}
					};

					Insert((struct List *)QuellList,(struct Node *)NewNode,(struct Node *)PredNode);

				}
			};

			SetGadgetAttrs(QuellGadget,MyWindow,0L,WLISTVIEWA_List,QuellList,
																						WLISTVIEWA_Columns,2,
																						WLISTVIEWA_Top,0,
																						TAG_DONE);
		}

		if (newKopf)
			SetGadgetAttrs(QuellToggleGadget,MyWindow,0L,WTOGGLEA_Label,QuellAnzeige,
																			TAG_DONE);

		SetGadgetAttrs(QuellStringGadget,MyWindow,0L,WSTRINGA_String,device,
																			TAG_DONE);

		SetGadgetAttrs(MyGadgets[86],MyWindow,0L,WARGSA_Arg0,0,TAG_DONE);

		UnLock(mylock);
	}
	WZ_UnlockWindow(MyWinHandle);
}


void GoToDir(STRPTR addpath)
{
	char *Dir;
	char NewDir[256];

	if (GetAttr(WSTRINGA_String,QuellStringGadget,(ULONG *)&Dir))
	{
		strcpy(NewDir,Dir);
		AddPart(NewDir,addpath,256);

		ReadDirectoryList(NewDir,FALSE);
	}

}

struct WizardDefaultNode	MyHeaderNode;

/* Main - Programm */

main()
{
	struct NewWindow *MyNewWindow;

	struct IntuiMessage *msg;

	ULONG MsgClass;
	UWORD MsgGadgetID;

	APTR	GadgetHelpIAddress;
	struct WizardWindowHandle *GadgetHelpWinHandle;

	struct DateStamp MyDateStamp;
	struct ClockData MyClockData;

	ULONG FreeChip;
	ULONG FreeFast;

	NewList((struct List *)&LeftList);
	NewList((struct List *)&RightList);
	NewList((struct List *)&DummyList);

	if (UtilityBase=OpenLibrary("utility.library",0L))
	{
		if (WizardBase=OpenLibrary("wizard.library",0L))
		{
			if (MyScreen=LockPubScreen(0L))
			{
				if (MySurface=WZ_OpenSurface("manager.wizard",0L,TAG_DONE))
				{
						if (MyWinHandle=WZ_AllocWindowHandle(MyScreen,
																								sizeof(MyWinExtension),
																								MySurface,TAG_DONE))
						{
							if (MyNewWindow=WZ_CreateWindowObj(MyWinHandle,WINDOW,WWH_GadgetArray,MyGadgets,
																																WWH_GadgetArraySize,sizeof(MyGadgets),
																																TAG_DONE))
							{
								QuellList=&LeftList;
								ZielList=&RightList;

								FreeChip=AvailMem(MEMF_CHIP)>>10;
								FreeFast=AvailMem(MEMF_FAST)>>10;

								DateStamp(&MyDateStamp);
								Amiga2Date(MyDateStamp.ds_Days*24*3600+MyDateStamp.ds_Minute*60+MyDateStamp.ds_Tick/50,&MyClockData);

								SetGadgetAttrs(MyGadgets[StatusID],0L,0L,WARGSA_Arg0,FreeChip,
																			WARGSA_Arg1,FreeFast,
																			WARGSA_Arg2,FreeChip+FreeFast,
																			WARGSA_Arg3,MyClockData.mday,
																			WARGSA_Arg4,MyClockData.month,
																			WARGSA_Arg5,MyClockData.year,
																			WARGSA_Arg6,MyClockData.hour,
																			WARGSA_Arg7,MyClockData.min,
																			WARGSA_Arg8,MyClockData.sec,
																			TAG_DONE);
								SetGadgetAttrs(MyGadgets[LViewID],0L,0L,WLISTVIEWA_List,QuellList,
																						TAG_DONE);
								SetGadgetAttrs(MyGadgets[RViewID],0L,0L,WLISTVIEWA_List,ZielList,
																						TAG_DONE);

								QuellGadget=MyGadgets[LViewID];
								ZielGadget=MyGadgets[RViewID];

								QuellStringGadget=MyGadgets[LStringID];
								ZielStringGadget=MyGadgets[RStringID];

								QuellToggleGadget=MyGadgets[LToggleID];
								ZielToggleGadget=MyGadgets[RToggleID];

								MyNewWindow->LeftEdge=0;
								MyNewWindow->TopEdge=MyScreen->BarHeight;
								MyNewWindow->Width=MyScreen->Width;
								MyNewWindow->Height=MyScreen->Height-MyScreen->BarHeight;


								if ((newimage=(struct WizardNewImage *)WZ_GetDataAddress(MySurface,WDATA_IMAGE,IMAGE_WIZARD)))
								{
									if ((bm=WZ_CreateImageBitMap(0,MyWinHandle->DrawInfo,newimage,MyScreen,Pens)))
									{
										if ((sbm=WZ_CreateImageBitMap(WZRD_FILLPEN,MyWinHandle->DrawInfo,newimage,MyScreen,SPens)))
										{

											if (MyWindow=WZ_OpenWindow(MyWinHandle,MyNewWindow,WA_AutoAdjust ,TRUE,
																																				WA_MenuHelp,TRUE,
																																				TAG_DONE))
											{
												MyWindow->UserData=(BYTE *)MyWinHandle;
												/* Wir wollen es uns schliesslich einfach machen oder ? */

												HelpControl(MyWindow,HC_GADGETHELP);

												do
												{
													WaitPort(MyWindow->UserPort); /* Auf CloseWindow warten*/

													if (msg=(struct IntuiMessage *)GetMsg(MyWindow->UserPort))
													{
														MsgClass=msg->Class;

														switch (MsgClass)
														{
															case IDCMP_IDCMPUPDATE:
																switch (MsgGadgetID=GetTagData(GA_ID,0,(struct TagItem *)msg->IAddress))
																{
																	unsigned long TWert;
																	struct MyListNode *SelNode;

																	case 30:		/* die ganzen Laufwerksknöpfe */
																	case 31:
																	case 32:
																	case 33:
																	case 34:
																	case 35:
																	case 36:
																	case 37:
																	case 38:
																	case 39:
																	case 40:
																		ReadDirectoryList(WZ_GadgetConfig(MyWinHandle,MyGadgets[MsgGadgetID]),TRUE);
																		break;

																	case LToggleID:              /* linkes Toggle */
																		{
																			STRPTR s;
																			GetAttr(WSTRINGA_String,MyGadgets[LToggleID],(ULONG *) &s);
																		}
																		TWert=ZielAnzeigeWert;
																		ZielAnzeigeWert=QuellAnzeigeWert;
																		QuellAnzeigeWert=TWert;

																		QuellList=&LeftList;
																		ZielList=&RightList;

																		QuellGadget=MyGadgets[LViewID];
																		ZielGadget=MyGadgets[RViewID];

																		QuellStringGadget=MyGadgets[LStringID];
																		ZielStringGadget=MyGadgets[RStringID];

																		QuellToggleGadget=MyGadgets[LToggleID];
																		ZielToggleGadget=MyGadgets[RToggleID];

																		QuellAnzeige=QString;
																		ZielAnzeige=ZString;

																		SetGadgetAttrs(MyGadgets[86],MyWindow,0L,
																			WARGSA_Arg0,QuellAnzeigeWert,TAG_DONE);
																		break;

																	case RToggleID:						/* rechtes Toogle */
																		TWert=ZielAnzeigeWert;
																		ZielAnzeigeWert=QuellAnzeigeWert;
																		QuellAnzeigeWert=TWert;

																		ZielList=&LeftList;
																		QuellList=&RightList;

																		ZielGadget=MyGadgets[LViewID];
																		QuellGadget=MyGadgets[RViewID];

																		ZielStringGadget=MyGadgets[LStringID];
																		QuellStringGadget=MyGadgets[RStringID];

																		ZielToggleGadget=MyGadgets[LToggleID];
																		QuellToggleGadget=MyGadgets[RToggleID];

																		ZielAnzeige=QString;
																		QuellAnzeige=ZString;

																		SetGadgetAttrs(MyGadgets[AnzeigeID],MyWindow,0L,
																			WARGSA_Arg0,QuellAnzeigeWert,TAG_DONE);
																		break;

																	case LViewID:										/* linkes MultiView */
																		if (QuellList!=&LeftList)
																		{
																			TWert=ZielAnzeigeWert;
																			ZielAnzeigeWert=QuellAnzeigeWert;
																			QuellAnzeigeWert=TWert;

																			QuellList=&LeftList;
																			ZielList=&RightList;

																			QuellGadget=MyGadgets[LViewID];
																			ZielGadget=MyGadgets[RViewID];

																			QuellStringGadget=MyGadgets[LStringID];
																			ZielStringGadget=MyGadgets[RStringID];

																			QuellToggleGadget=MyGadgets[LToggleID];
																			ZielToggleGadget=MyGadgets[RToggleID];

																			QuellAnzeige=QString;
																			ZielAnzeige=ZString;

																			SetGadgetAttrs(QuellToggleGadget,MyWindow,0L,
																				WTOGGLEA_Checked,TRUE,TAG_DONE);

																			SetGadgetAttrs(ZielToggleGadget,MyWindow,0L,
																				WTOGGLEA_Checked,FALSE,TAG_DONE);

																			SetGadgetAttrs(MyGadgets[AnzeigeID],MyWindow,0L,
																				WARGSA_Arg0,QuellAnzeigeWert,TAG_DONE);
																		}

																		SelNode=(struct MyListNode *)
																			WZ_GetNode(QuellList,GetTagData(WLISTVIEWA_Selected,0,msg->IAddress));

																		if (!GetTagData(WLISTVIEWA_DoubleClick,FALSE,msg->IAddress))
																		{
																			if (SelNode->Type==FILETYPE)
																			{
																				if (SelNode->WNode.WizardNode.Flags&WNF_SELECTED)
																					QuellAnzeigeWert+=SelNode->FileSize;
																				else
																					QuellAnzeigeWert-=SelNode->FileSize;

																					SetGadgetAttrs(MyGadgets[AnzeigeID],MyWindow,0L,
																						WARGSA_Arg0,QuellAnzeigeWert,TAG_DONE);
																			}
																		}
																		else
																			if (SelNode->Type==DIRTYPE)
																				GoToDir(SelNode->FileName);

																		break;

																	case RViewID:									/*rechtes MultiView */
																		if (QuellList!=&RightList)
																		{
																			TWert=ZielAnzeigeWert;
																			ZielAnzeigeWert=QuellAnzeigeWert;
																			QuellAnzeigeWert=TWert;

																			ZielList=&LeftList;
																			QuellList=&RightList;

																			ZielGadget=MyGadgets[LViewID];
																			QuellGadget=MyGadgets[RViewID];

																			ZielStringGadget=MyGadgets[LStringID];
																			QuellStringGadget=MyGadgets[RStringID];

																			ZielToggleGadget=MyGadgets[LToggleID];
																			QuellToggleGadget=MyGadgets[RToggleID];

																			ZielAnzeige=QString;
																			QuellAnzeige=ZString;

																			SetGadgetAttrs(QuellToggleGadget,MyWindow,0L,WTOGGLEA_Checked,TRUE,
																																					TAG_DONE);
																			SetGadgetAttrs(ZielToggleGadget,MyWindow,0L,WTOGGLEA_Checked,FALSE,
																																					TAG_DONE);
																			SetGadgetAttrs(MyGadgets[AnzeigeID],MyWindow,0L,
																				WARGSA_Arg0,QuellAnzeigeWert,TAG_DONE);
																		}

																		SelNode=(struct MyListNode *)
																			WZ_GetNode(QuellList,GetTagData(WLISTVIEWA_Selected,0,msg->IAddress));

																		if (!GetTagData(WLISTVIEWA_DoubleClick,FALSE,msg->IAddress))
																		{
																			if (SelNode->Type==FILETYPE)
																			{
																				if (SelNode->WNode.WizardNode.Flags&WNF_SELECTED)
																					QuellAnzeigeWert+=SelNode->FileSize;
																				else
																					QuellAnzeigeWert-=SelNode->FileSize;

																					SetGadgetAttrs(MyGadgets[AnzeigeID],MyWindow,0L,
																						WARGSA_Arg0,QuellAnzeigeWert,TAG_DONE);
																			}
																		}
																		else
																			if (SelNode->Type==DIRTYPE)
																				GoToDir(SelNode->FileName);

																		break;

																	case ParentID:
																		{
																			char NewDir[256],*Dir;

																			if (GetAttr(WSTRINGA_String,QuellStringGadget,(ULONG *)&Dir))
																				{
																					strcpy(NewDir,Dir);

																					*(PathPart(NewDir))=0;
																					ReadDirectoryList(NewDir,FALSE);

																					WZ_InitNode((struct WizardNode *)&MyHeaderNode,1,TAG_DONE);
																					WZ_InitNodeEntry((struct WizardNode *)&MyHeaderNode,0,
																							WENTRYA_Type,WNE_TEXT,
																							WENTRYA_TextString,"Das ist der Header",
																							TAG_DONE);
																					SetGadgetAttrs(MyGadgets[LViewID],MyWindow,0,
																							WLISTVIEWA_HeaderNode,&MyHeaderNode,
																							TAG_DONE);
																				}
																		}
																		break
																}
																break;

															case IDCMP_MENUPICK:

																switch(msg->Code)
																{
																	case FULLMENUNUM(0,0,-1):
																		{
																			ULONG Dummy;

																			WZ_LockWindow(MyWinHandle);

																			WZ_EasyRequestArgs(MySurface,MyWindow,REQ_ABOUT,&Dummy);

																			WZ_UnlockWindow(MyWinHandle);
																		}
																		break;

																	case FULLMENUNUM(0,2,-1):
																		MsgClass=IDCMP_CLOSEWINDOW;
																		break;
																}
																break;

															case IDCMP_MENUHELP :
																SetWindowTitles(MyWindow,WZ_MenuHelp(MyWinHandle,msg->Code),(char *)-1L);
																Delay(50L);
																break;

															case IDCMP_GADGETHELP:
																if (msg->IAddress)
																{
																		SetWindowTitles(MyWindow,WZ_GadgetHelp(MyWinHandle,msg->IAddress),(char *)-1L);
																}
																break;
															case IDCMP_MOUSEMOVE:
																/* Falls wir unter 2.0 oder 2.1 laufen !!! */
																if (WZ_GadgetHelpMsg(MyWinHandle,&GadgetHelpWinHandle,&GadgetHelpIAddress,msg->MouseX,msg->MouseY,0))
																	{
																		SetWindowTitles(MyWindow,WZ_GadgetHelp(GadgetHelpWinHandle,GadgetHelpIAddress),(char *)-1L);
																	}
																break;
															case IDCMP_INTUITICKS:

																		FreeChip=AvailMem(MEMF_CHIP)>>10;
																		FreeFast=AvailMem(MEMF_FAST)>>10;

																		DateStamp(&MyDateStamp);
																		Amiga2Date(MyDateStamp.ds_Days*24*3600+MyDateStamp.ds_Minute*60+(MyDateStamp.ds_Tick/50),&MyClockData);

																		SetGadgetAttrs(MyGadgets[StatusID],MyWindow,0L,
																						WARGSA_Arg0,FreeChip,
																						WARGSA_Arg1,FreeFast,
																						WARGSA_Arg2,FreeChip+FreeFast,
																						WARGSA_Arg3,MyClockData.mday,
																						WARGSA_Arg4,MyClockData.month,
																						WARGSA_Arg5,MyClockData.year,
																						WARGSA_Arg6,MyClockData.hour,
																						WARGSA_Arg7,MyClockData.min,
																						WARGSA_Arg8,MyClockData.sec,
																						TAG_DONE);
																		break;

														}
														ReplyMsg((struct Message *)msg);
													}
												} while (MsgClass != IDCMP_CLOSEWINDOW);

											WZ_CloseWindow(MyWinHandle);
										}
										WZ_DeleteImageBitMap(sbm,newimage,MyScreen,SPens);
									}
									WZ_DeleteImageBitMap(bm,newimage,MyScreen,Pens);
								}
							}

							while (QuellList->mlh_Head->mln_Succ)
							{
								struct MinNode *t=QuellList->mlh_Head;

								Remove((struct Node *)t);
								FreeVec(t);
							};

							while (ZielList->mlh_Head->mln_Succ)
							{
								struct MinNode *t=ZielList->mlh_Head;

								Remove((struct Node *)t);
								FreeVec(t);
							};
						}
						WZ_FreeWindowHandle(MyWinHandle)
					}
					WZ_CloseSurface(MySurface);
				}
				UnlockPubScreen(0L,MyScreen);
			}
			CloseLibrary(WizardBase);
		}
		CloseLibrary(UtilityBase);
	}
}
