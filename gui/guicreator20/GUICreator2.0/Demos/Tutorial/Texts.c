/*************************************************************************/
/*                                                                       */
/*   Includes                                                            */
/*                                                                       */
/*************************************************************************/
#include "Texts_Includes.h"
#include "Texts.h"

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
	BOOL    gd_Disabled_TXText1;
	char    gd_Text_TXText1[256];
	BOOL    gd_Disabled_TXText2;
	char    gd_Text_TXText2[256];
	BOOL    gd_Disabled_TXText3;
	char    gd_Text_TXText3[256];
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
		wingads[TXID_Text1]=gadget=CreateGadget(TEXT_KIND,gadget,&newgad[TXID_Text1],GA_Disabled,gadgetdata->gd_Disabled_TXText1,GTTX_Border,TRUE,GTTX_CopyText,TRUE,GTTX_Text,(ULONG)gadgetdata->gd_Text_TXText1,TAG_END);
		wingads[TXID_Text2]=gadget=CreateGadget(TEXT_KIND,gadget,&newgad[TXID_Text2],GA_Disabled,gadgetdata->gd_Disabled_TXText2,GTTX_Border,FALSE,GTTX_CopyText,TRUE,GTTX_Text,(ULONG)gadgetdata->gd_Text_TXText2,TAG_END);
		wingads[TXID_Text3]=gadget=CreateGadget(TEXT_KIND,gadget,&newgad[TXID_Text3],GA_Disabled,gadgetdata->gd_Disabled_TXText3,GTTX_Border,TRUE,GTTX_CopyText,TRUE,GTTX_Text,(ULONG)gadgetdata->gd_Text_TXText3,TAG_END);
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
	struct Gadget   *wingads[7];
	struct TextAttr  textattr     = { NULL,8,FS_NORMAL,FPF_DISKFONT };
	ULONG  height=13,width=26,maxheight=1024,maxwidth=1280;

	textattr.ta_Name  = ((struct GfxBase *)GfxBase)->DefaultFont->tf_Message.mn_Node.ln_Name;
	textattr.ta_YSize = ((struct GfxBase *)GfxBase)->DefaultFont->tf_YSize;
	visualinfo        = GetVisualInfo(customscreen,TAG_DONE);

	if (visualinfo)
		{
		struct BevelFrame bevels[] = {
			XPOS(1),YPOS(1),XSIZE(24),YSIZE(11),"Palette",3,
			};
		struct NewGadget newgad[] = {
			XPOS(3),YPOS(3),XSIZE(20),YSIZE(2),NULL,&textattr, TXID_Text1,PLACETEXT_LEFT,visualinfo,NULL,
			XPOS(3),YPOS(6),XSIZE(20),YSIZE(2),NULL,&textattr, TXID_Text2,PLACETEXT_LEFT,visualinfo,NULL,
			XPOS(3),YPOS(9),XSIZE(20),YSIZE(2),NULL,&textattr, TXID_Text3,PLACETEXT_LEFT,visualinfo,NULL,
			};
		struct WindowData gadgetdata = {
			/* belongs to a text gadget */
			FALSE,
			"Text number 1",
			/* belongs to a text gadget */
			FALSE,
			"Text number 2",
			/* belongs to a text gadget */
			FALSE,
			"Text Number 3",
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
						WA_IDCMP,            IDCMP_CLOSEWINDOW|IDCMP_NEWSIZE|IDCMP_VANILLAKEY|IDCMP_REFRESHWINDOW|IDCMP_GADGETUP,
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
