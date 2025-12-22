/*************************************************************************/
/*                                                                       */
/*   Includes                                                            */
/*                                                                       */
/*************************************************************************/
#include "Radios_Includes.h"
#include "Radios.h"

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
	BOOL    gd_Disabled_MXRadio1;
	UWORD   gd_Active_MXRadio1;
	BOOL    gd_Disabled_MXRadio2;
	UWORD   gd_Active_MXRadio2;
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
		case MXID_Radio1:
			MXRadio1Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case MXID_Radio2:
			MXRadio2Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		};
}

/*************************************************************************/
/*                                                                       */
/*   Routines to create gadgets                                          */
/*                                                                       */
/*************************************************************************/
struct Gadget *CreateGadgetsWindow(struct Gadget **gadgetlist,struct NewGadget newgad[],struct Gadget *wingads[],struct WindowData *gadgetdata,char * *LA_MXRadio1,char * *LA_MXRadio2)
{
	struct Gadget *gadget=CreateContext(gadgetlist);
	if (gadget)
		{
		wingads[LAID_Gadget1]=gadget=CreateGadget(TEXT_KIND,gadget,&newgad[LAID_Gadget1],GT_Underscore,'_',GTTX_Border,TRUE,TAG_END);
		wingads[MXID_Radio1]=gadget=CreateGadget(MX_KIND,gadget,&newgad[MXID_Radio1],GA_Disabled,gadgetdata->gd_Disabled_MXRadio1,GTMX_Active,gadgetdata->gd_Active_MXRadio1,GTMX_Scaled,TRUE,GTMX_Labels,(ULONG)LA_MXRadio1,LAYOUTA_Spacing,newgad[MXID_Radio1].ng_Height-YSIZE(1)+1,TAG_END);
		wingads[LAID_Gadget2]=gadget=CreateGadget(TEXT_KIND,gadget,&newgad[LAID_Gadget2],GT_Underscore,'_',GTTX_Border,TRUE,TAG_END);
		wingads[MXID_Radio2]=gadget=CreateGadget(MX_KIND,gadget,&newgad[MXID_Radio2],GA_Disabled,gadgetdata->gd_Disabled_MXRadio2,GTMX_Active,gadgetdata->gd_Active_MXRadio2,GTMX_Scaled,TRUE,GTMX_Labels,(ULONG)LA_MXRadio2,LAYOUTA_Spacing,newgad[MXID_Radio2].ng_Height-YSIZE(1)+1,TAG_END);
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
	struct Gadget   *wingads[9];
	struct TextAttr  textattr     = { NULL,8,FS_NORMAL,FPF_DISKFONT };
	ULONG  height=17,width=39,maxheight=1024,maxwidth=1280;

	textattr.ta_Name  = ((struct GfxBase *)GfxBase)->DefaultFont->tf_Message.mn_Node.ln_Name;
	textattr.ta_YSize = ((struct GfxBase *)GfxBase)->DefaultFont->tf_YSize;
	visualinfo        = GetVisualInfo(customscreen,TAG_DONE);

	if (visualinfo)
		{
		char *LA_MXRadio1[]  = { "Amiga 500","Amiga 600","Amiga 1000","Amiga 1200","Amiga 2000","Amiga 3000","Amiga 4000",NULL };
		char *LA_MXRadio2[]  = { "MC 68000","MC 68020","MC 68030","MC 68040","MC 68060","PowerPC 604","PowerPC 620",NULL };
		struct BevelFrame bevels[] = {
			XPOS(1),YPOS(1),XSIZE(37),YSIZE(15),"Radiobuttons",3,
			};
		struct NewGadget newgad[] = {
			XPOS(3),YPOS(3),XSIZE(16),YSIZE(2),"_Amiga:",&textattr, LAID_Gadget1,PLACETEXT_IN,visualinfo,NULL,
			XPOS(4),YPOS(6),XSIZE(2),YSIZE(1)-1,NULL,&textattr, MXID_Radio1,PLACETEXT_RIGHT,visualinfo,NULL,
			XPOS(20),YPOS(3),XSIZE(16),YSIZE(2),"_Equipment:",&textattr, LAID_Gadget2,PLACETEXT_IN,visualinfo,NULL,
			XPOS(33),YPOS(6),XSIZE(2),YSIZE(1)-1,NULL,&textattr, MXID_Radio2,PLACETEXT_LEFT,visualinfo,NULL,
			};
		struct WindowData gadgetdata = {
			/* belongs to a radio button */
			FALSE,
			5,
			/* belongs to a radio button */
			FALSE,
			4,
			};
		height= YSIZE(height);
		width = XSIZE(width) ;
		if (left == -1) left = (customscreen->Width -width )/2;
		if (top  == -1) top  = (customscreen->Height-height)/2;

		if (CreateGadgetsWindow(&gadgetlist,newgad,wingads,&gadgetdata,LA_MXRadio1,LA_MXRadio2) != NULL)
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
						WA_IDCMP,            IDCMP_CLOSEWINDOW|IDCMP_NEWSIZE|IDCMP_VANILLAKEY|IDCMP_REFRESHWINDOW|IDCMP_GADGETUP|MXIDCMP,
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
												case 'a':
													GT_GetGadgetAttrs(wingads[MXID_Radio1],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														GT_GetGadgetAttrs(wingads[MXID_Radio1],win,NULL,GTMX_Active,(ULONG)&longpointer1,TAG_END);
														if (++longpointer1 == 7) longpointer1=0;
														GT_SetGadgetAttrs(wingads[MXID_Radio1],win,NULL,GTMX_Active,longpointer1,TAG_END);
														HandleGadgetsWindow(win,wingads,MXID_Radio1,longpointer1,&gadgetdata,userdata);
														}
													break;
												case 'A':
													GT_GetGadgetAttrs(wingads[MXID_Radio1],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														GT_GetGadgetAttrs(wingads[MXID_Radio1],win,NULL,GTMX_Active,(ULONG)&longpointer1,TAG_END);
														if (longpointer1 == 0) longpointer1=7;
														longpointer1--;
														GT_SetGadgetAttrs(wingads[MXID_Radio1],win,NULL,GTMX_Active,longpointer1,TAG_END);
														HandleGadgetsWindow(win,wingads,MXID_Radio1,longpointer1,&gadgetdata,userdata);
														}
													break;
												case 'e':
													GT_GetGadgetAttrs(wingads[MXID_Radio2],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														GT_GetGadgetAttrs(wingads[MXID_Radio2],win,NULL,GTMX_Active,(ULONG)&longpointer1,TAG_END);
														if (++longpointer1 == 7) longpointer1=0;
														GT_SetGadgetAttrs(wingads[MXID_Radio2],win,NULL,GTMX_Active,longpointer1,TAG_END);
														HandleGadgetsWindow(win,wingads,MXID_Radio2,longpointer1,&gadgetdata,userdata);
														}
													break;
												case 'E':
													GT_GetGadgetAttrs(wingads[MXID_Radio2],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														GT_GetGadgetAttrs(wingads[MXID_Radio2],win,NULL,GTMX_Active,(ULONG)&longpointer1,TAG_END);
														if (longpointer1 == 0) longpointer1=7;
														longpointer1--;
														GT_SetGadgetAttrs(wingads[MXID_Radio2],win,NULL,GTMX_Active,longpointer1,TAG_END);
														HandleGadgetsWindow(win,wingads,MXID_Radio2,longpointer1,&gadgetdata,userdata);
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
