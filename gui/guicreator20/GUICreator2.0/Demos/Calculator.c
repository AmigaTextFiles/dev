/*************************************************************************/
/*                                                                       */
/*   Includes                                                            */
/*                                                                       */
/*************************************************************************/
#include "Calculator_Includes.h"
#include "Calculator.h"

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
struct CalculatorWindowData
	{
	BOOL    gd_Disabled_Gadget1;
	BOOL    gd_Disabled_Gadget2;
	BOOL    gd_Disabled_Gadget3;
	BOOL    gd_Disabled_Gadget4;
	BOOL    gd_Disabled_Gadget5;
	BOOL    gd_Disabled_Gadget6;
	BOOL    gd_Disabled_Gadget7;
	BOOL    gd_Disabled_Gadget8;
	BOOL    gd_Disabled_Gadget9;
	BOOL    gd_Disabled_Gadget10;
	BOOL    gd_Disabled_Gadget11;
	BOOL    gd_Disabled_Gadget12;
	BOOL    gd_Disabled_Gadget13;
	BOOL    gd_Disabled_Gadget14;
	BOOL    gd_Disabled_Gadget15;
	BOOL    gd_Disabled_Gadget16;
	BOOL    gd_Disabled_Gadget17;
	BOOL    gd_Disabled_Gadget18;
	BOOL    gd_Disabled_Gadget19;
	BOOL    gd_Disabled_Gadget20;
	BOOL    gd_Disabled_Gadget21;
	LONG    gd_Number_Gadget21;
	};

/*************************************************************************/
/*                                                                       */
/*   Routines to handle gadgets                                          */
/*                                                                       */
/*************************************************************************/
void HandleGadgetsCalculatorWindow(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,struct CalculatorWindowData *gadgetdata,APTR userdata)
{
	switch(gadgetid)
		{
		case BTID_Gadget1:
			Gadget1Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case BTID_Gadget2:
			Gadget2Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case BTID_Gadget3:
			Gadget3Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case BTID_Gadget4:
			Gadget4Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case BTID_Gadget5:
			Gadget5Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case BTID_Gadget6:
			Gadget6Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case BTID_Gadget7:
			Gadget7Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case BTID_Gadget8:
			Gadget8Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case BTID_Gadget9:
			Gadget9Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case BTID_Gadget10:
			Gadget10Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case BTID_Gadget11:
			Gadget11Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case BTID_Gadget12:
			Gadget12Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case BTID_Gadget13:
			Gadget13Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case BTID_Gadget14:
			Gadget14Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case BTID_Gadget15:
			Gadget15Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case BTID_Gadget16:
			Gadget16Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case BTID_Gadget17:
			Gadget17Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case BTID_Gadget18:
			Gadget18Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case BTID_Gadget19:
			Gadget19Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case BTID_Gadget20:
			Gadget20Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case NBID_Gadget21:
			Gadget21Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		};
}

/*************************************************************************/
/*                                                                       */
/*   Routines to create gadgets                                          */
/*                                                                       */
/*************************************************************************/
struct Gadget *CreateGadgetsCalculatorWindow(struct Gadget **gadgetlist,struct NewGadget newgad[],struct Gadget *wingads[],struct CalculatorWindowData *gadgetdata)
{
	struct Gadget *gadget=CreateContext(gadgetlist);
	if (gadget)
		{
		wingads[BTID_Gadget1]=gadget=CreateGadget(BUTTON_KIND,gadget,&newgad[BTID_Gadget1],GA_Disabled,gadgetdata->gd_Disabled_Gadget1,GT_Underscore,'_',TAG_END);
		wingads[BTID_Gadget2]=gadget=CreateGadget(BUTTON_KIND,gadget,&newgad[BTID_Gadget2],GA_Disabled,gadgetdata->gd_Disabled_Gadget2,GT_Underscore,'_',TAG_END);
		wingads[BTID_Gadget3]=gadget=CreateGadget(BUTTON_KIND,gadget,&newgad[BTID_Gadget3],GA_Disabled,gadgetdata->gd_Disabled_Gadget3,GT_Underscore,'_',TAG_END);
		wingads[BTID_Gadget4]=gadget=CreateGadget(BUTTON_KIND,gadget,&newgad[BTID_Gadget4],GA_Disabled,gadgetdata->gd_Disabled_Gadget4,GT_Underscore,'_',TAG_END);
		wingads[BTID_Gadget5]=gadget=CreateGadget(BUTTON_KIND,gadget,&newgad[BTID_Gadget5],GA_Disabled,gadgetdata->gd_Disabled_Gadget5,GT_Underscore,'_',TAG_END);
		wingads[BTID_Gadget6]=gadget=CreateGadget(BUTTON_KIND,gadget,&newgad[BTID_Gadget6],GA_Disabled,gadgetdata->gd_Disabled_Gadget6,GT_Underscore,'_',TAG_END);
		wingads[BTID_Gadget7]=gadget=CreateGadget(BUTTON_KIND,gadget,&newgad[BTID_Gadget7],GA_Disabled,gadgetdata->gd_Disabled_Gadget7,GT_Underscore,'_',TAG_END);
		wingads[BTID_Gadget8]=gadget=CreateGadget(BUTTON_KIND,gadget,&newgad[BTID_Gadget8],GA_Disabled,gadgetdata->gd_Disabled_Gadget8,GT_Underscore,'_',TAG_END);
		wingads[BTID_Gadget9]=gadget=CreateGadget(BUTTON_KIND,gadget,&newgad[BTID_Gadget9],GA_Disabled,gadgetdata->gd_Disabled_Gadget9,GT_Underscore,'_',TAG_END);
		wingads[BTID_Gadget10]=gadget=CreateGadget(BUTTON_KIND,gadget,&newgad[BTID_Gadget10],GA_Disabled,gadgetdata->gd_Disabled_Gadget10,GT_Underscore,'_',TAG_END);
		wingads[BTID_Gadget11]=gadget=CreateGadget(BUTTON_KIND,gadget,&newgad[BTID_Gadget11],GA_Disabled,gadgetdata->gd_Disabled_Gadget11,GT_Underscore,'_',TAG_END);
		wingads[BTID_Gadget12]=gadget=CreateGadget(BUTTON_KIND,gadget,&newgad[BTID_Gadget12],GA_Disabled,gadgetdata->gd_Disabled_Gadget12,GT_Underscore,'_',TAG_END);
		wingads[BTID_Gadget13]=gadget=CreateGadget(BUTTON_KIND,gadget,&newgad[BTID_Gadget13],GA_Disabled,gadgetdata->gd_Disabled_Gadget13,GT_Underscore,'_',TAG_END);
		wingads[BTID_Gadget14]=gadget=CreateGadget(BUTTON_KIND,gadget,&newgad[BTID_Gadget14],GA_Disabled,gadgetdata->gd_Disabled_Gadget14,GT_Underscore,'_',TAG_END);
		wingads[BTID_Gadget15]=gadget=CreateGadget(BUTTON_KIND,gadget,&newgad[BTID_Gadget15],GA_Disabled,gadgetdata->gd_Disabled_Gadget15,GT_Underscore,'_',TAG_END);
		wingads[BTID_Gadget16]=gadget=CreateGadget(BUTTON_KIND,gadget,&newgad[BTID_Gadget16],GA_Disabled,gadgetdata->gd_Disabled_Gadget16,GT_Underscore,'_',TAG_END);
		wingads[BTID_Gadget17]=gadget=CreateGadget(BUTTON_KIND,gadget,&newgad[BTID_Gadget17],GA_Disabled,gadgetdata->gd_Disabled_Gadget17,GT_Underscore,'_',TAG_END);
		wingads[BTID_Gadget18]=gadget=CreateGadget(BUTTON_KIND,gadget,&newgad[BTID_Gadget18],GA_Disabled,gadgetdata->gd_Disabled_Gadget18,GT_Underscore,'_',TAG_END);
		wingads[BTID_Gadget19]=gadget=CreateGadget(BUTTON_KIND,gadget,&newgad[BTID_Gadget19],GA_Disabled,gadgetdata->gd_Disabled_Gadget19,GT_Underscore,'_',TAG_END);
		wingads[BTID_Gadget20]=gadget=CreateGadget(BUTTON_KIND,gadget,&newgad[BTID_Gadget20],GA_Disabled,gadgetdata->gd_Disabled_Gadget20,GT_Underscore,'_',TAG_END);
		wingads[NBID_Gadget21]=gadget=CreateGadget(NUMBER_KIND,gadget,&newgad[NBID_Gadget21],GA_Disabled,gadgetdata->gd_Disabled_Gadget21,GTNM_Number,gadgetdata->gd_Number_Gadget21,GTNM_Border,TRUE,GTNM_Justification,GTJ_RIGHT,TAG_END);
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
void HandleCalculatorWindow(struct Screen *customscreen,LONG left,LONG top,APTR userdata)
{
	APTR             visualinfo   = NULL;
	struct Gadget   *gadgetlist   = NULL;
	char            *title        = "Calculator";
	struct Window   *win          = NULL;
	struct Gadget   *wingads[42];
	struct TextAttr  textattr     = { NULL,8,FS_NORMAL,FPF_DISKFONT };
	struct Menu     *menustrip    = NULL;
	ULONG  height=16,width=26,maxheight=1024,maxwidth=1280;

	textattr.ta_Name  = ((struct GfxBase *)GfxBase)->DefaultFont->tf_Message.mn_Node.ln_Name;
	textattr.ta_YSize = ((struct GfxBase *)GfxBase)->DefaultFont->tf_YSize;
	visualinfo        = GetVisualInfo(customscreen,TAG_DONE);

	if (visualinfo)
		{
		struct NewMenu menu[] = {
			NM_TITLE, "Program",0,0,0,0,
			NM_ITEM ,"About","A",0,0,0,
			NULL,
			};
		struct NewGadget newgad[] = {
			XPOS(1),YPOS(4),XSIZE(4),YSIZE(2),"7",&textattr, BTID_Gadget1,PLACETEXT_IN,visualinfo,NULL,
			XPOS(6),YPOS(4),XSIZE(4),YSIZE(2),"8",&textattr, BTID_Gadget2,PLACETEXT_IN,visualinfo,NULL,
			XPOS(11),YPOS(4),XSIZE(4),YSIZE(2),"9",&textattr, BTID_Gadget3,PLACETEXT_IN,visualinfo,NULL,
			XPOS(1),YPOS(7),XSIZE(4),YSIZE(2),"4",&textattr, BTID_Gadget4,PLACETEXT_IN,visualinfo,NULL,
			XPOS(6),YPOS(7),XSIZE(4),YSIZE(2),"5",&textattr, BTID_Gadget5,PLACETEXT_IN,visualinfo,NULL,
			XPOS(11),YPOS(7),XSIZE(4),YSIZE(2),"6",&textattr, BTID_Gadget6,PLACETEXT_IN,visualinfo,NULL,
			XPOS(1),YPOS(10),XSIZE(4),YSIZE(2),"1",&textattr, BTID_Gadget7,PLACETEXT_IN,visualinfo,NULL,
			XPOS(6),YPOS(10),XSIZE(4),YSIZE(2),"2",&textattr, BTID_Gadget8,PLACETEXT_IN,visualinfo,NULL,
			XPOS(11),YPOS(10),XSIZE(4),YSIZE(2),"3",&textattr, BTID_Gadget9,PLACETEXT_IN,visualinfo,NULL,
			XPOS(16),YPOS(4),XSIZE(4),YSIZE(2),"CA",&textattr, BTID_Gadget10,PLACETEXT_IN,visualinfo,NULL,
			XPOS(21),YPOS(4),XSIZE(4),YSIZE(2),"CE",&textattr, BTID_Gadget11,PLACETEXT_IN,visualinfo,NULL,
			XPOS(16),YPOS(7),XSIZE(4),YSIZE(2),"·",&textattr, BTID_Gadget12,PLACETEXT_IN,visualinfo,NULL,
			XPOS(21),YPOS(7),XSIZE(4),YSIZE(2),":",&textattr, BTID_Gadget13,PLACETEXT_IN,visualinfo,NULL,
			XPOS(16),YPOS(10),XSIZE(4),YSIZE(2),"+",&textattr, BTID_Gadget14,PLACETEXT_IN,visualinfo,NULL,
			XPOS(21),YPOS(10),XSIZE(4),YSIZE(2),"-",&textattr, BTID_Gadget15,PLACETEXT_IN,visualinfo,NULL,
			XPOS(1),YPOS(13),XSIZE(4),YSIZE(2),"0",&textattr, BTID_Gadget16,PLACETEXT_IN,visualinfo,NULL,
			XPOS(6),YPOS(13),XSIZE(4),YSIZE(2),".",&textattr, BTID_Gadget17,PLACETEXT_IN,visualinfo,NULL,
			XPOS(11),YPOS(13),XSIZE(4),YSIZE(2),"«",&textattr, BTID_Gadget18,PLACETEXT_IN,visualinfo,NULL,
			XPOS(16),YPOS(13),XSIZE(4),YSIZE(2),"±",&textattr, BTID_Gadget19,PLACETEXT_IN,visualinfo,NULL,
			XPOS(21),YPOS(13),XSIZE(4),YSIZE(2),"=",&textattr, BTID_Gadget20,PLACETEXT_IN,visualinfo,NULL,
			XPOS(1),YPOS(1),XSIZE(24),YSIZE(2),NULL,&textattr, NBID_Gadget21,PLACETEXT_LEFT,visualinfo,NULL,
			};
		struct CalculatorWindowData gadgetdata = {
			/* belongs to a button */
			FALSE,
			/* belongs to a button */
			FALSE,
			/* belongs to a button */
			FALSE,
			/* belongs to a button */
			FALSE,
			/* belongs to a button */
			FALSE,
			/* belongs to a button */
			FALSE,
			/* belongs to a button */
			FALSE,
			/* belongs to a button */
			FALSE,
			/* belongs to a button */
			FALSE,
			/* belongs to a button */
			FALSE,
			/* belongs to a button */
			FALSE,
			/* belongs to a button */
			FALSE,
			/* belongs to a button */
			FALSE,
			/* belongs to a button */
			FALSE,
			/* belongs to a button */
			FALSE,
			/* belongs to a button */
			FALSE,
			/* belongs to a button */
			FALSE,
			/* belongs to a button */
			FALSE,
			/* belongs to a button */
			FALSE,
			/* belongs to a button */
			FALSE,
			/* belongs to a number gadget */
			FALSE,
			0,
			};
		height= YSIZE(height);
		width = XSIZE(width) ;
		if (left == -1) left = (customscreen->Width -width )/2;
		if (top  == -1) top  = (customscreen->Height-height)/2;

		if (CreateGadgetsCalculatorWindow(&gadgetlist,newgad,wingads,&gadgetdata) != NULL)
			{
			if (height>customscreen->Height || width>customscreen->Width) GUIC_ErrorReport(NULL,ERROR_SCREEN_TOO_SMALL);
			win=OpenWindowTags(NULL,WA_Activate,         TRUE,
						WA_CloseGadget,      TRUE,
						WA_DepthGadget,      TRUE,
						WA_SizeGadget,       TRUE,
						WA_DragBar,          TRUE,
						WA_Gadgets,          (ULONG)gadgetlist,
						WA_InnerHeight,      height,
						WA_InnerWidth,       width,
						WA_IDCMP,            IDCMP_CLOSEWINDOW|IDCMP_NEWSIZE|IDCMP_VANILLAKEY|IDCMP_REFRESHWINDOW|IDCMP_GADGETUP|IDCMP_MENUPICK|BUTTONIDCMP,
						WA_Left,             left,
						WA_Top,              top,
						WA_MaxHeight,        maxheight,
						WA_MinHeight,        height,
						WA_MaxWidth,         maxwidth,
						WA_MinWidth,         width,
						WA_SizeBRight,       FALSE,
						WA_SizeBBottom,      TRUE,
						WA_SmartRefresh,     TRUE,
						WA_CustomScreen,     (ULONG)customscreen,
						WA_Title,            (ULONG)title,
						WA_NewLookMenus,     TRUE,
					TAG_END);
			if (win)
				{
				menustrip=CreateMenus(menu,GTMN_NewLookMenus,TRUE,TAG_END);
				if (menustrip)
					{
					if (LayoutMenus(menustrip,visualinfo,GTMN_NewLookMenus,TRUE,TAG_END))
						{
						if (SetMenuStrip(win,menustrip))
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
							long   double        xscale      = 1.0;
							long   double        yscale      = 1.0;
							ULONG                i           = 0;
							struct NewGadget     ngcopy[42];
							CopyMem(newgad,ngcopy,sizeof(ngcopy));
							SetFont(win->RPort,((struct GfxBase *)GfxBase)->DefaultFont);
							GT_RefreshWindow(win,NULL);
							do
								{
								WindowLimits(win,width+win->BorderLeft+win->BorderRight,height+win->BorderTop+win->BorderBottom,maxwidth,maxheight);
								if (running) signal=Wait(SIGBREAKF_CTRL_C | 1L << win->UserPort->mp_SigBit);
								if (signal & SIGBREAKF_CTRL_C) running=FALSE;
								WindowLimits(win,win->Width,win->Height,win->Width,win->Height);
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
											HandleGadgetsCalculatorWindow(win,wingads,idcmpgad->GadgetID,messagecode,&gadgetdata,userdata);
											break;
										case IDCMP_MENUPICK:
											switch(MENUNUM(messagecode))
												{
												case 0:
													switch (ITEMNUM(messagecode))
														{
														case 0:
															About(win,wingads,userdata);
															break;
														}
													break;
												}
											break;
										case IDCMP_NEWSIZE:
											RemoveGList(win,gadgetlist,-1);
											SetAPen(win->RPort,0L);
											RectFill(win->RPort,win->BorderLeft,win->BorderTop,win->Width-win->BorderRight-1,win->Height-win->BorderBottom-1);
											RefreshWindowFrame(win);

											xscale=(long double)win->Width /(long double)(width+win->BorderLeft+win->BorderRight);
											yscale=(long double)win->Height/(long double)(height+win->BorderTop+win->BorderBottom);
											for (i=0;i<42;i++)
												{
												ngcopy[i].ng_LeftEdge=(WORD)((long double)newgad[i].ng_LeftEdge*xscale);
												ngcopy[i].ng_TopEdge =(WORD)((long double)newgad[i].ng_TopEdge *yscale);
												ngcopy[i].ng_Width   =(WORD)((long double)newgad[i].ng_Width   *xscale);
												ngcopy[i].ng_Height  =(WORD)((long double)newgad[i].ng_Height  *yscale);
												}
											GT_GetGadgetAttrs(wingads[BTID_Gadget1],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
											gadgetdata.gd_Disabled_Gadget1=(longpointer1 == 0)?FALSE:TRUE;
											GT_GetGadgetAttrs(wingads[BTID_Gadget2],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
											gadgetdata.gd_Disabled_Gadget2=(longpointer1 == 0)?FALSE:TRUE;
											GT_GetGadgetAttrs(wingads[BTID_Gadget3],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
											gadgetdata.gd_Disabled_Gadget3=(longpointer1 == 0)?FALSE:TRUE;
											GT_GetGadgetAttrs(wingads[BTID_Gadget4],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
											gadgetdata.gd_Disabled_Gadget4=(longpointer1 == 0)?FALSE:TRUE;
											GT_GetGadgetAttrs(wingads[BTID_Gadget5],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
											gadgetdata.gd_Disabled_Gadget5=(longpointer1 == 0)?FALSE:TRUE;
											GT_GetGadgetAttrs(wingads[BTID_Gadget6],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
											gadgetdata.gd_Disabled_Gadget6=(longpointer1 == 0)?FALSE:TRUE;
											GT_GetGadgetAttrs(wingads[BTID_Gadget7],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
											gadgetdata.gd_Disabled_Gadget7=(longpointer1 == 0)?FALSE:TRUE;
											GT_GetGadgetAttrs(wingads[BTID_Gadget8],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
											gadgetdata.gd_Disabled_Gadget8=(longpointer1 == 0)?FALSE:TRUE;
											GT_GetGadgetAttrs(wingads[BTID_Gadget9],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
											gadgetdata.gd_Disabled_Gadget9=(longpointer1 == 0)?FALSE:TRUE;
											GT_GetGadgetAttrs(wingads[BTID_Gadget10],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
											gadgetdata.gd_Disabled_Gadget10=(longpointer1 == 0)?FALSE:TRUE;
											GT_GetGadgetAttrs(wingads[BTID_Gadget11],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
											gadgetdata.gd_Disabled_Gadget11=(longpointer1 == 0)?FALSE:TRUE;
											GT_GetGadgetAttrs(wingads[BTID_Gadget12],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
											gadgetdata.gd_Disabled_Gadget12=(longpointer1 == 0)?FALSE:TRUE;
											GT_GetGadgetAttrs(wingads[BTID_Gadget13],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
											gadgetdata.gd_Disabled_Gadget13=(longpointer1 == 0)?FALSE:TRUE;
											GT_GetGadgetAttrs(wingads[BTID_Gadget14],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
											gadgetdata.gd_Disabled_Gadget14=(longpointer1 == 0)?FALSE:TRUE;
											GT_GetGadgetAttrs(wingads[BTID_Gadget15],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
											gadgetdata.gd_Disabled_Gadget15=(longpointer1 == 0)?FALSE:TRUE;
											GT_GetGadgetAttrs(wingads[BTID_Gadget16],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
											gadgetdata.gd_Disabled_Gadget16=(longpointer1 == 0)?FALSE:TRUE;
											GT_GetGadgetAttrs(wingads[BTID_Gadget17],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
											gadgetdata.gd_Disabled_Gadget17=(longpointer1 == 0)?FALSE:TRUE;
											GT_GetGadgetAttrs(wingads[BTID_Gadget18],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
											gadgetdata.gd_Disabled_Gadget18=(longpointer1 == 0)?FALSE:TRUE;
											GT_GetGadgetAttrs(wingads[BTID_Gadget19],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
											gadgetdata.gd_Disabled_Gadget19=(longpointer1 == 0)?FALSE:TRUE;
											GT_GetGadgetAttrs(wingads[BTID_Gadget20],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
											gadgetdata.gd_Disabled_Gadget20=(longpointer1 == 0)?FALSE:TRUE;
											GT_GetGadgetAttrs(wingads[NBID_Gadget21],win,NULL,GA_Disabled,(ULONG)&longpointer1,GTNM_Number,(ULONG)&longpointer2,TAG_END);
											gadgetdata.gd_Disabled_Gadget21=(longpointer1 == 0)?FALSE:TRUE;
											gadgetdata.gd_Number_Gadget21=longpointer2;
											FreeGadgets(gadgetlist);
											gadgetlist=NULL;

											CreateGadgetsCalculatorWindow(&gadgetlist,ngcopy,wingads,&gadgetdata);
											AddGList(win,gadgetlist,-1,-1,NULL);
											RefreshGList(gadgetlist,win,NULL,-1);
											GT_RefreshWindow(win,NULL);
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
							ClearMenuStrip(win);
							}
						else GUIC_ErrorReport(win,ERROR_NO_WINDOW_MENU);
						}
					else GUIC_ErrorReport(win,ERROR_NO_WINDOW_MENU);
					FreeMenus(menustrip);
					}
				else GUIC_ErrorReport(win,ERROR_NO_WINDOW_MENU);
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
