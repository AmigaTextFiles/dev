/* Demonstration der Einbindung "Wizardfremder" Gadgets.

   (geschrieben unter StormC V1.1)

   $VER:              1.0 (12.06.96)

   Autor:             Thomas Mittelsdorf

   © 1996 HAAGE & PARTNER Computer GmbH,  All Rights Reserved

*/

#include	<stdio.h>
#include	<stdlib.h>
#include	<string.h>

#include	<clib/alib_protos.h>
#include	<pragma/dos_lib.h>
#include	<pragma/exec_lib.h>
#include	<pragma/graphics_lib.h>
#include	<pragma/intuition_lib.h>
#include	<pragma/utility_lib.h>
#include	<pragma/wizard_lib.h>

#include	<exec/exec.h>
#include	<exec/memory.h>
#include	<gadgets/colorwheel.h>
#include	<gadgets/gradientslider.h>
#include	<intuition/gadgetclass.h>
#include	<intuition/intuition.h>
#include	<utility/utility.h>
#include	<libraries/wizard.h>

struct Library *UtilityBase;
struct Library *WizardBase;
struct Library *ColorWheelBase;

APTR	MySurface;
struct Screen *MyScreen;
struct DrawInfo *MyDrInfo;

struct WizardWindowHandle *MyWinHandle;
struct NewWindow *MyNewWindow;
struct Window *MyWindow;

struct Gadget *MyGadgets[40];

struct Gadget *MyColorWheel;

struct TextAttr MyTextAttr=
{
	"topaz.font",
	8,0,0
};

struct MyListNode
{
	struct WizardDefaultNode WNode;
	char Name[256];
};

struct MinList MyList;

BOOL CreateNode(char *name,UWORD Pen,UWORD SPen)
{
	BOOL Flag=FALSE;

	struct MyListNode *NewNode;

	if (NewNode=AllocVec(sizeof(MyListNode),MEMF_CLEAR|MEMF_PUBLIC))
	{
		Flag=TRUE;

		WZ_InitNode(&NewNode->WNode.WizardNode,1,TAG_DONE);

		strcpy(NewNode->Name,name);

		WZ_InitNodeEntry(&NewNode->WNode.WizardNode,0,WENTRYA_Type,WNE_TEXT,
																				WENTRYA_TextPen,WZRD_TEXTPEN,
																				WENTRYA_TextSPen,WZRD_FILLTEXTPEN,
																				WENTRYA_TextString,NewNode->Name,
																				TAG_DONE);


		AddTail((struct List *)&MyList,(struct Node *)NewNode);
	}

	return(Flag);
}

main()
{
	BOOL Flag=FALSE;

	struct IntuiMessage *msg;

	NewList((struct List *)&MyList);

	if (UtilityBase=OpenLibrary("utility.library",0L))
	{
		if (WizardBase=OpenLibrary("wizard.library",0L))
		{
			if (ColorWheelBase=OpenLibrary("gadgets/colorwheel.gadget",0L))
				{
					if (MySurface=WZ_OpenSurface("palette.wizard",0,TAG_DONE))
					{
						if (MyScreen=OpenScreenTags(0L,SA_LikeWorkbench,TRUE,
																						SA_Width,640,
																						SA_Height,304,
																						SA_Depth,8,
																						SA_SharePens,TRUE,
																						SA_Font,&MyTextAttr,
																						SA_Title,"Palette Preferences",
																						TAG_DONE))
						{
							ULONG RGBValues[3*4];

							GetRGB32(MyScreen->ViewPort.ColorMap,252,4,(ULONG *)&RGBValues);

							SetRGB32(&MyScreen->ViewPort,4,RGBValues[0],RGBValues[1],RGBValues[2]);
							SetRGB32(&MyScreen->ViewPort,5,RGBValues[3],RGBValues[4],RGBValues[5]);
							SetRGB32(&MyScreen->ViewPort,6,RGBValues[6],RGBValues[7],RGBValues[8]);
							SetRGB32(&MyScreen->ViewPort,7,RGBValues[9],RGBValues[10],RGBValues[11]);


							if (MyDrInfo=GetScreenDrawInfo(MyScreen))
							{
								if (MyColorWheel=NewObject(0L,"colorwheel.gadget",
																							GA_ID,50,

																							GA_Left,95,
																							GA_Top,41,
																							GA_Width,141,
																							GA_Height,85,

																							GA_DrawInfo,MyDrInfo,
																							WHEEL_Screen,MyScreen,
																							TAG_DONE))
								{
									if (MyWinHandle=WZ_AllocWindowHandle(MyScreen,0,MySurface,TAG_DONE))
										{
											if (MyNewWindow=WZ_CreateWindowObj(MyWinHandle,1,
																								WWH_GadgetArray,&MyGadgets,
																								WWH_GadgetArraySize,sizeof(MyGadgets),
																								WWH_PreviousGadget,MyColorWheel,
																								TAG_DONE))
											{
												MyNewWindow->TopEdge=MyScreen->BarHeight;

												MyNewWindow->FirstGadget=MyColorWheel;
												/* Wir wollen schließlich unsere eigenen **
												** Gadgets auch beim Betriebssystem       **
												** angemeldet wissen !  		            */

												if (CreateNode("Background",WZRD_BACKGROUNDPEN,WZRD_BACKGROUNDPEN))
													if (CreateNode("Text",WZRD_TEXTPEN,WZRD_TEXTPEN))
														if (CreateNode("Important Text",WZRD_HIGHLIGHTTEXTPEN,WZRD_HIGHLIGHTTEXTPEN))
															if (CreateNode("Bright Edges",WZRD_SHINEPEN,WZRD_SHINEPEN))
																if (CreateNode("Dark Edges",WZRD_SHADOWPEN,WZRD_SHADOWPEN))
																	if (CreateNode("Active Windowtitle Bars",WZRD_FILLPEN,WZRD_FILLPEN))
																		if (CreateNode("Active Window Titles",WZRD_FILLTEXTPEN,WZRD_FILLTEXTPEN))
																			if (CreateNode("Menu Background",WZRD_BARBLOCKPEN,WZRD_BARBLOCKPEN))
																				if (CreateNode("Menu Text",WZRD_BARDETAILPEN,WZRD_BARDETAILPEN))
																					{
																						SetGadgetAttrs(MyGadgets[19],0L,0L,WLISTVIEWA_List,&MyList,
																																								WLISTVIEWA_Top,FALSE,
																																								TAG_DONE);

																						if (MyWindow=WZ_OpenWindow(MyWinHandle,MyNewWindow,
																								WA_AutoAdjust,TRUE,
																								TAG_DONE))
																						{
																							do
																							{
																								WaitPort(MyWindow->UserPort); /* Auf CloseWindow warten*/

																								if (msg=(struct IntuiMessage *)GetMsg(MyWindow->UserPort))
																								{
																									switch (msg->Class)
																									{
																										case IDCMP_MENUPICK:
																										{
																											if (msg->Code==FULLMENUNUM(0,3,-1))
																												Flag=TRUE;
																										}
																										break;
																									}
																									ReplyMsg((struct Message *)msg);
																								}
																							} while (Flag!=TRUE);

																							WZ_CloseWindow(MyWinHandle);
																						}
																					}



												while (MyList.mlh_Head->mln_Succ)
												{
													struct Node *t=(struct Node*)MyList.mlh_Head;

													Remove(t);
													FreeVec((APTR)t)
												}
											}
											WZ_FreeWindowHandle(MyWinHandle);
										}
									DisposeObject(MyColorWheel);
								}
								FreeScreenDrawInfo(MyScreen,MyDrInfo);
							}
							CloseScreen(MyScreen);
						}

						WZ_CloseSurface(MySurface);
					}
					CloseLibrary(ColorWheelBase);
				}
				CloseLibrary(WizardBase);
			}
			CloseLibrary(UtilityBase);
		}
};