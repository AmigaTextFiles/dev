/*************************************************************************/
/*                                                                       */
/*   Includes                                                            */
/*                                                                       */
/*************************************************************************/
#include "Cycles_Includes.h"
#include "Cycles.h"

/*************************************************************************/
/*                                                                       */
/*   Variables and Structures                                            */
/*                                                                       */
/*************************************************************************/
extern struct IntuitionBase *IntuitionBase;
extern struct GfxBase       *GfxBase;

extern struct UtilityBase   *UtilityBase;

extern struct Library *GadToolsBase ;
extern struct Library *AslBase      ;
extern struct Library *DataTypesBase;

/*************************************************************************/
/*                                                                       */
/*   Defines                                                             */
/*                                                                       */
/*************************************************************************/
#define GADGET_DOWN  0
#define GADGET_UP    1
#define RASTERX (((struct GfxBase *)GfxBase)->DefaultFont->tf_XSize)
#define RASTERY (((struct GfxBase *)GfxBase)->DefaultFont->tf_YSize/2+4)

#define XSIZE(x)  ((x)*RASTERX)
#define YSIZE(x)  ((x)*RASTERY)

#define XPOS(x)   (XSIZE(x)+customscreen->WBorLeft)
#define YPOS(x)   (YSIZE(x)+customscreen->BarHeight+1)

/*************************************************************************/
/*                                                                       */
/*   WindowStructures                                                    */
/*                                                                       */
/*************************************************************************/
struct WindowData
	{
	BOOL    gd_Disabled_CYCycle1;
	UWORD   gd_Active_CYCycle1;
	char * *gd_Labels_CYCycle1;
	BOOL    gd_Disabled_CYCycle2;
	UWORD   gd_Active_CYCycle2;
	char * *gd_Labels_CYCycle2;
	BOOL    gd_Disabled_CYCycle3;
	UWORD   gd_Active_CYCycle3;
	char * *gd_Labels_CYCycle3;
	};

/*************************************************************************/
/*                                                                       */
/*   Routines to handle gadgets                                          */
/*                                                                       */
/*************************************************************************/
void HandleGadgetsWindow(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,struct WindowData *gadgetdata,APTR userdata)
{
	switch(gadgetid)
		{
		case CYID_Cycle1:
			CYCycle1Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case CYID_Cycle2:
			CYCycle2Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case CYID_Cycle3:
			CYcycle3Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		};
}

/*************************************************************************/
/*                                                                       */
/*   Routines to create gadgets                                          */
/*                                                                       */
/*************************************************************************/
struct Gadget *CreateGadgetsWindow(struct Gadget **gadgetlist,struct NewGadget newgad[],struct Gadget *wingads[],struct WindowData *gadgetdata)
{
	struct Gadget *gadget=CreateContext(gadgetlist);
	if (gadget)
		{
		wingads[LAID_Gadget1]=gadget=CreateGadget(TEXT_KIND,gadget,&newgad[LAID_Gadget1],GT_Underscore,'_',GTTX_Border,FALSE,TAG_END);
		wingads[LAID_Gadget2]=gadget=CreateGadget(TEXT_KIND,gadget,&newgad[LAID_Gadget2],GT_Underscore,'_',GTTX_Border,FALSE,TAG_END);
		wingads[LAID_Gadget3]=gadget=CreateGadget(TEXT_KIND,gadget,&newgad[LAID_Gadget3],GT_Underscore,'_',GTTX_Border,FALSE,TAG_END);
		wingads[CYID_Cycle1]=gadget=CreateGadget(CYCLE_KIND,gadget,&newgad[CYID_Cycle1],GA_Disabled,gadgetdata->gd_Disabled_CYCycle1,GTCY_Labels,(ULONG)gadgetdata->gd_Labels_CYCycle1,GTCY_Active,gadgetdata->gd_Active_CYCycle1,TAG_END);
		wingads[CYID_Cycle2]=gadget=CreateGadget(CYCLE_KIND,gadget,&newgad[CYID_Cycle2],GA_Disabled,gadgetdata->gd_Disabled_CYCycle2,GTCY_Labels,(ULONG)gadgetdata->gd_Labels_CYCycle2,GTCY_Active,gadgetdata->gd_Active_CYCycle2,TAG_END);
		wingads[CYID_Cycle3]=gadget=CreateGadget(CYCLE_KIND,gadget,&newgad[CYID_Cycle3],GA_Disabled,gadgetdata->gd_Disabled_CYCycle3,GTCY_Labels,(ULONG)gadgetdata->gd_Labels_CYCycle3,GTCY_Active,gadgetdata->gd_Active_CYCycle3,TAG_END);
		return gadget;
		}
	else return NULL;
}
/*************************************************************************/
/*                                                                       */
/*   Routines to create BOOPSI gadgets                                   */
/*                                                                       */
/*************************************************************************/
/*************************************************************************/
/*                                                                       */
/*   Routines to handle windows                                          */
/*                                                                       */
/*************************************************************************/
void HandleWindow(struct Screen *customscreen,LONG left,LONG top,APTR userdata)
{
	APTR             visualinfo   = NULL;
	struct Gadget   *gadgetlist   = NULL;
	char            *title        = "Title";
	struct Window   *win          = NULL;
	struct Gadget   *wingads[13];
	struct TextAttr  textattr     = { NULL,8,FS_NORMAL,FPF_DISKFONT };
	ULONG  height=14,width=32,maxheight=1024,maxwidth=1280;

	textattr.ta_Name  = ((struct GfxBase *)GfxBase)->DefaultFont->tf_Message.mn_Node.ln_Name;
	textattr.ta_YSize = ((struct GfxBase *)GfxBase)->DefaultFont->tf_YSize;
	visualinfo        = GetVisualInfo(customscreen,TAG_DONE);

	if (visualinfo)
		{
		char *LA_CYCycle1[]  = { "Amiga 500","Amiga 600","Amiga 1000","Amiga 1200","Amiga 2000","Amiga 3000","Amiga 4000","Amiga CD32",NULL };
		char *LA_CYCycle2[]  = { "OS 1.0","OS 1.2","OS 1.3","OS 2.04","OS 2.1","OS 3.0","OS 3.1",NULL };
		char *LA_CYCycle3[]  = { "Harddisk","Chip-RAM","Fast-RAM","CD-ROM","ZIP-Drive","GFX Card",NULL };
		struct BevelFrame bevels[] = {
			XPOS(1),YPOS(1),XSIZE(30),YSIZE(12),"Cycles",3,
			};
		struct NewGadget newgad[] = {
			XPOS(3),YPOS(3),XSIZE(8),YSIZE(2),"_Cycle 1:",&textattr, LAID_Gadget1,PLACETEXT_IN,visualinfo,NULL,
			XPOS(3),YPOS(6),XSIZE(8),YSIZE(2),"C_ycle 2:",&textattr, LAID_Gadget2,PLACETEXT_IN,visualinfo,NULL,
			XPOS(3),YPOS(9),XSIZE(8),YSIZE(2),"Cyc_le 3:",&textattr, LAID_Gadget3,PLACETEXT_IN,visualinfo,NULL,
			XPOS(12),YPOS(3),XSIZE(17),YSIZE(2),NULL,&textattr, CYID_Cycle1,PLACETEXT_ABOVE,visualinfo,NULL,
			XPOS(12),YPOS(6),XSIZE(17),YSIZE(2),NULL,&textattr, CYID_Cycle2,PLACETEXT_ABOVE,visualinfo,NULL,
			XPOS(12),YPOS(9),XSIZE(17),YSIZE(2),NULL,&textattr, CYID_Cycle3,PLACETEXT_ABOVE,visualinfo,NULL,
			};
		struct WindowData gadgetdata = {
			/* belongs to a cycle gadget */
			FALSE,
			6,
			(char * *)&LA_CYCycle1[0],
			/* belongs to a cycle gadget */
			FALSE,
			5,
			(char * *)&LA_CYCycle2[0],
			/* belongs to a cycle gadget */
			FALSE,
			5,
			(char * *)&LA_CYCycle3[0],
			};
		height= YSIZE(height);
		width = XSIZE(width) ;
		if (left == -1) left = (customscreen->Width -width )/2;
		if (top  == -1) top  = (customscreen->Height-height)/2;

		if (CreateGadgetsWindow(&gadgetlist,newgad,wingads,&gadgetdata) != NULL)
			{
			if (height>customscreen->Height || width>customscreen->Width) GUIC_ErrorReport(NULL,ERROR_SCREEN_TOO_SMALL);
			win=OpenWindowTags(NULL,WA_Activate,         TRUE,
						WA_CloseGadget,      TRUE,
						WA_DepthGadget,      TRUE,
						WA_SizeGadget,       FALSE,
						WA_DragBar,          TRUE,
						WA_Gadgets,          (ULONG)gadgetlist,
						WA_InnerHeight,      height,
						WA_InnerWidth,       width,
						WA_IDCMP,            IDCMP_CLOSEWINDOW|IDCMP_NEWSIZE|IDCMP_VANILLAKEY|IDCMP_REFRESHWINDOW|IDCMP_GADGETUP|CYCLEIDCMP,
						WA_Left,             left,
						WA_Top,              top,
						WA_MaxHeight,        maxheight,
						WA_MinHeight,        height,
						WA_MaxWidth,         maxwidth,
						WA_MinWidth,         width,
						WA_SizeBRight,       FALSE,
						WA_SizeBBottom,      FALSE,
						WA_SmartRefresh,     TRUE,
						WA_CustomScreen,     (ULONG)customscreen,
						WA_Title,            (ULONG)title,
						WA_NewLookMenus,     TRUE,
					TAG_END);
			if (win)
				{
							struct IntuiMessage  *imessage   = NULL;
							struct Gadget        *idcmpgad   = NULL;
							struct Gadget        *firstboopsi= 0;
							ULONG  idcmpclass                = 0;
							UWORD  messagecode               = 0;
							BOOL   running                   = TRUE;
							ULONG  signal                    = 0;
							ULONG  longpointer1              = 0;
							ULONG  longpointer2              = 0;
							SetFont(win->RPort,((struct GfxBase *)GfxBase)->DefaultFont);
							CreateBevelFrames(win,visualinfo,1,bevels);
							GT_RefreshWindow(win,NULL);
							UserSetupWindow(win,wingads,userdata);
							do
								{
								if (running) signal=Wait(SIGBREAKF_CTRL_C | 1L << win->UserPort->mp_SigBit);
								if (signal & SIGBREAKF_CTRL_C) running=FALSE;
								while (running && (imessage=GT_GetIMsg(win->UserPort)))
									{
									idcmpgad=(struct Gadget *)imessage->IAddress;
									idcmpclass=imessage->Class;
									messagecode =imessage->Code;

									GT_ReplyIMsg(imessage);

									switch(idcmpclass)
										{
										case IDCMP_REFRESHWINDOW:
											GT_BeginRefresh(win);
											GT_EndRefresh(win,TRUE);
											break;
										case IDCMP_CLOSEWINDOW:
											running=FALSE;
											break;
										case IDCMP_GADGETUP:
										case MXIDCMP:
											HandleGadgetsWindow(win,wingads,idcmpgad->GadgetID,messagecode,&gadgetdata,userdata);
											break;
										case IDCMP_VANILLAKEY:
											switch(messagecode)
												{
												case 'c':
													GT_GetGadgetAttrs(wingads[CYID_Cycle1],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														ShowGadget(win,wingads[CYID_Cycle1],GADGET_DOWN);
														Delay(5);
														ShowGadget(win,wingads[CYID_Cycle1],GADGET_UP  );
														GT_GetGadgetAttrs(wingads[CYID_Cycle1],win,NULL,GTCY_Active,(ULONG)&longpointer1,TAG_END);
														if (++longpointer1 == 8) longpointer1=0;
														GT_SetGadgetAttrs(wingads[CYID_Cycle1],win,NULL,GTCY_Active,longpointer1,TAG_END);
														HandleGadgetsWindow(win,wingads,CYID_Cycle1,longpointer1,&gadgetdata,userdata);
														}
													break;
												case 'C':
													GT_GetGadgetAttrs(wingads[CYID_Cycle1],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														ShowGadget(win,wingads[CYID_Cycle1],GADGET_DOWN);
														Delay(5);
														ShowGadget(win,wingads[CYID_Cycle1],GADGET_UP  );
														GT_GetGadgetAttrs(wingads[CYID_Cycle1],win,NULL,GTCY_Active,(ULONG)&longpointer1,TAG_END);
														if (longpointer1 == 0) longpointer1=8;
													longpointer1--;
														GT_SetGadgetAttrs(wingads[CYID_Cycle1],win,NULL,GTCY_Active,longpointer1,TAG_END);
														HandleGadgetsWindow(win,wingads,CYID_Cycle1,longpointer1,&gadgetdata,userdata);
														}
													break;
												case 'y':
													GT_GetGadgetAttrs(wingads[CYID_Cycle2],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														ShowGadget(win,wingads[CYID_Cycle2],GADGET_DOWN);
														Delay(5);
														ShowGadget(win,wingads[CYID_Cycle2],GADGET_UP  );
														GT_GetGadgetAttrs(wingads[CYID_Cycle2],win,NULL,GTCY_Active,(ULONG)&longpointer1,TAG_END);
														if (++longpointer1 == 7) longpointer1=0;
														GT_SetGadgetAttrs(wingads[CYID_Cycle2],win,NULL,GTCY_Active,longpointer1,TAG_END);
														HandleGadgetsWindow(win,wingads,CYID_Cycle2,longpointer1,&gadgetdata,userdata);
														}
													break;
												case 'Y':
													GT_GetGadgetAttrs(wingads[CYID_Cycle2],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														ShowGadget(win,wingads[CYID_Cycle2],GADGET_DOWN);
														Delay(5);
														ShowGadget(win,wingads[CYID_Cycle2],GADGET_UP  );
														GT_GetGadgetAttrs(wingads[CYID_Cycle2],win,NULL,GTCY_Active,(ULONG)&longpointer1,TAG_END);
														if (longpointer1 == 0) longpointer1=7;
													longpointer1--;
														GT_SetGadgetAttrs(wingads[CYID_Cycle2],win,NULL,GTCY_Active,longpointer1,TAG_END);
														HandleGadgetsWindow(win,wingads,CYID_Cycle2,longpointer1,&gadgetdata,userdata);
														}
													break;
												case 'l':
													GT_GetGadgetAttrs(wingads[CYID_Cycle3],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														ShowGadget(win,wingads[CYID_Cycle3],GADGET_DOWN);
														Delay(5);
														ShowGadget(win,wingads[CYID_Cycle3],GADGET_UP  );
														GT_GetGadgetAttrs(wingads[CYID_Cycle3],win,NULL,GTCY_Active,(ULONG)&longpointer1,TAG_END);
														if (++longpointer1 == 6) longpointer1=0;
														GT_SetGadgetAttrs(wingads[CYID_Cycle3],win,NULL,GTCY_Active,longpointer1,TAG_END);
														HandleGadgetsWindow(win,wingads,CYID_Cycle3,longpointer1,&gadgetdata,userdata);
														}
													break;
												case 'L':
													GT_GetGadgetAttrs(wingads[CYID_Cycle3],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														ShowGadget(win,wingads[CYID_Cycle3],GADGET_DOWN);
														Delay(5);
														ShowGadget(win,wingads[CYID_Cycle3],GADGET_UP  );
														GT_GetGadgetAttrs(wingads[CYID_Cycle3],win,NULL,GTCY_Active,(ULONG)&longpointer1,TAG_END);
														if (longpointer1 == 0) longpointer1=6;
													longpointer1--;
														GT_SetGadgetAttrs(wingads[CYID_Cycle3],win,NULL,GTCY_Active,longpointer1,TAG_END);
														HandleGadgetsWindow(win,wingads,CYID_Cycle3,longpointer1,&gadgetdata,userdata);
														}
													break;
												case 27:
													running=FALSE;
													break;
												}
											break;
										}
									/* end-switch */
									}
								/* end-while */
								}
							while (running);
				if (win) CloseWindow(win);
				}
			else GUIC_ErrorReport(win,ERROR_NO_WINDOW_OPENED);
			if (gadgetlist) FreeGadgets(gadgetlist);
			}
		else GUIC_ErrorReport(NULL,ERROR_NO_GADGETS_CREATED);
		if (visualinfo) FreeVisualInfo(visualinfo);
		}
	else GUIC_ErrorReport(NULL,ERROR_NO_VISUALINFO);
}
