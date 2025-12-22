/*************************************************************************/
/*                                                                       */
/*   Includes                                                            */
/*                                                                       */
/*************************************************************************/
#include "Textfields_Includes.h"
#include "Textfields.h"

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
		case TFID_Textfield1:
			TFTexfield1Clicked(win,wingads,gadgetid,messagecode,userdata);
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
		return gadget;
		}
	else return NULL;
}
/*************************************************************************/
/*                                                                       */
/*   Routines to create BOOPSI gadgets                                   */
/*                                                                       */
/*************************************************************************/
struct Gadget *CreateBOOPSIGadgetsWindow(struct Window *win,struct NewGadget newgad[],struct Gadget *wingads[])
{
	struct IClass *tfc=NULL;
	struct Gadget *f=NULL,*g=NULL;

	tfc = TEXTFIELD_GetClass();
	f = 
	wingads[TFID_Textfield1] = g = (struct Gadget *)NewObject(tfc,NULL,ICA_TARGET,ICTARGET_IDCMP,GA_Left,newgad[TFID_Textfield1].ng_LeftEdge,GA_Top,newgad[TFID_Textfield1].ng_TopEdge,GA_Width,newgad[TFID_Textfield1].ng_Width,GA_Height,newgad[TFID_Textfield1].ng_Height,GA_ID,TFID_Textfield1,TAG_SKIP,1,GA_Previous,g,GA_Disabled,FALSE,TEXTFIELD_Text,(ULONG)"Texfield gadgets are © by Mark Thomas\n",TEXTFIELD_TextFont,(ULONG)win->IFont,TEXTFIELD_BlockCursor,TRUE,TEXTFIELD_NoGhost,FALSE,TEXTFIELD_ReadOnly,FALSE,TEXTFIELD_RuledPaper,TRUE,TEXTFIELD_Border,TEXTFIELD_BORDER_DOUBLEBEVEL,TEXTFIELD_Inverted,TRUE,TEXTFIELD_BlinkRate,250000,TEXTFIELD_Spacing,1,TEXTFIELD_Alignment,TEXTFIELD_ALIGN_CENTER,TEXTFIELD_FontStyle,FS_NORMAL,TAG_END);
	wingads[TFID_Textfield2] = g = (struct Gadget *)NewObject(tfc,NULL,GA_Left,newgad[TFID_Textfield2].ng_LeftEdge,GA_Top,newgad[TFID_Textfield2].ng_TopEdge,GA_Width,newgad[TFID_Textfield2].ng_Width,GA_Height,newgad[TFID_Textfield2].ng_Height,GA_ID,TFID_Textfield2,GA_Previous,g,GA_Disabled,FALSE,TEXTFIELD_Text,(ULONG)"",TEXTFIELD_TextFont,(ULONG)win->IFont,TEXTFIELD_BlockCursor,FALSE,TEXTFIELD_NoGhost,FALSE,TEXTFIELD_ReadOnly,TRUE,TEXTFIELD_RuledPaper,FALSE,TEXTFIELD_Border,TEXTFIELD_BORDER_DOUBLEBEVEL,TEXTFIELD_Inverted,FALSE,TEXTFIELD_BlinkRate,750000,TEXTFIELD_Spacing,5,TEXTFIELD_Alignment,TEXTFIELD_ALIGN_LEFT,TEXTFIELD_FontStyle,FS_NORMAL|FSF_ITALIC,TAG_END);

	if (wingads[TFID_Textfield1] && wingads[TFID_Textfield2] && TRUE)
		{
		AddGList(win,f,-1,-1,NULL);
		RefreshGadgets(f,win,NULL);
		return f;
		};

	if (wingads[TFID_Textfield1]) DisposeObject(wingads[TFID_Textfield1]);
	if (wingads[TFID_Textfield2]) DisposeObject(wingads[TFID_Textfield2]);
	return NULL;
}
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
	struct Gadget   *wingads[5];
	struct TextAttr  textattr     = { NULL,8,FS_NORMAL,FPF_DISKFONT };
	ULONG  height=26,width=52,maxheight=1024,maxwidth=1280;

	textattr.ta_Name  = ((struct GfxBase *)GfxBase)->DefaultFont->tf_Message.mn_Node.ln_Name;
	textattr.ta_YSize = ((struct GfxBase *)GfxBase)->DefaultFont->tf_YSize;
	visualinfo        = GetVisualInfo(customscreen,TAG_DONE);

	if (visualinfo)
		{
		struct BevelFrame bevels[] = {
			XPOS(1),YPOS(1),XSIZE(50),YSIZE(24),"Textfields",3,
			};
		struct NewGadget newgad[] = {
			XPOS(3),YPOS(3),XSIZE(46),YSIZE(10),NULL,&textattr, TFID_Textfield1,PLACETEXT_LEFT,visualinfo,NULL,
			XPOS(3),YPOS(14),XSIZE(46),YSIZE(10),NULL,&textattr, TFID_Textfield2,PLACETEXT_LEFT,visualinfo,NULL,
			};
		struct WindowData gadgetdata = {
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
						WA_IDCMP,            IDCMP_CLOSEWINDOW|IDCMP_NEWSIZE|IDCMP_VANILLAKEY|IDCMP_REFRESHWINDOW|IDCMP_GADGETUP|IDCMP_IDCMPUPDATE,
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
							firstboopsi=CreateBOOPSIGadgetsWindow(win,newgad,wingads);

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
										case IDCMP_IDCMPUPDATE:
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
			if (wingads[TFID_Textfield1]) DisposeObject(wingads[TFID_Textfield1]);
			if (wingads[TFID_Textfield2]) DisposeObject(wingads[TFID_Textfield2]);
			if (gadgetlist) FreeGadgets(gadgetlist);
			}
		else GUIC_ErrorReport(NULL,ERROR_NO_GADGETS_CREATED);
		if (visualinfo) FreeVisualInfo(visualinfo);
		}
	else GUIC_ErrorReport(NULL,ERROR_NO_VISUALINFO);
}
