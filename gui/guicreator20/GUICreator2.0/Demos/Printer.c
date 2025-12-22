/*************************************************************************/
/*                                                                       */
/*   Includes                                                            */
/*                                                                       */
/*************************************************************************/
#include "Printer_Includes.h"
#include "Printer.h"

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
struct PrinterPrefsWindowData
	{
	BOOL    gd_Disabled_Gadget2;
	struct List *gd_Labels_Gadget2;
	UWORD   gd_Selected_Gadget2;
	UWORD   gd_Top_Gadget2;
	BOOL    gd_Disabled_Gadget3;
	BOOL    gd_Disabled_Gadget5;
	BOOL    gd_Disabled_Gadget4;
	BOOL    gd_Disabled_Gadget6;
	UWORD   gd_Active_Gadget6;
	char * *gd_Labels_Gadget6;
	BOOL    gd_Disabled_Gadget7;
	UWORD   gd_Active_Gadget7;
	char * *gd_Labels_Gadget7;
	BOOL    gd_Disabled_Gadget8;
	UWORD   gd_Active_Gadget8;
	char * *gd_Labels_Gadget8;
	BOOL    gd_Disabled_Gadget9;
	UWORD   gd_Active_Gadget9;
	char * *gd_Labels_Gadget9;
	BOOL    gd_Disabled_Gadget10;
	UWORD   gd_Active_Gadget10;
	char * *gd_Labels_Gadget10;
	BOOL    gd_Disabled_Gadget11;
	UWORD   gd_Active_Gadget11;
	char * *gd_Labels_Gadget11;
	BOOL    gd_Disabled_Gadget12;
	ULONG   gd_Number_Gadget12;
	BOOL    gd_Disabled_Gadget13;
	ULONG   gd_Number_Gadget13;
	BOOL    gd_Disabled_Gadget14;
	ULONG   gd_Number_Gadget14;
	};

/*************************************************************************/
/*                                                                       */
/*   Routines to handle gadgets                                          */
/*                                                                       */
/*************************************************************************/
void HandleGadgetsPrinterPrefsWindow(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,struct PrinterPrefsWindowData *gadgetdata,APTR userdata)
{
	switch(gadgetid)
		{
		case LVID_Gadget2:
			Gadget2Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case BTID_Gadget3:
			Gadget3Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case BTID_Gadget5:
			Gadget5Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case BTID_Gadget4:
			Gadget4Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case CYID_Gadget6:
			Gadget6Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case CYID_Gadget7:
			Gadget7Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case CYID_Gadget8:
			Gadget8Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case CYID_Gadget9:
			Gadget9Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case CYID_Gadget10:
			Gadget10Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case CYID_Gadget11:
			Gadget11Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case INID_Gadget12:
			Gadget12Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case INID_Gadget13:
			Gadget13Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case INID_Gadget14:
			Gadget14Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		};
}

/*************************************************************************/
/*                                                                       */
/*   Routines to create gadgets                                          */
/*                                                                       */
/*************************************************************************/
struct Gadget *CreateGadgetsPrinterPrefsWindow(struct Gadget **gadgetlist,struct NewGadget newgad[],struct Gadget *wingads[],struct PrinterPrefsWindowData *gadgetdata)
{
	struct Gadget *gadget=CreateContext(gadgetlist);
	if (gadget)
		{
		wingads[LAID_Gadget1]=gadget=CreateGadget(TEXT_KIND,gadget,&newgad[LAID_Gadget1],GT_Underscore,'_',GTTX_Border,FALSE,TAG_END);
		wingads[LVID_Gadget2]=gadget=CreateGadget(LISTVIEW_KIND,gadget,&newgad[LVID_Gadget2],GA_Disabled,gadgetdata->gd_Disabled_Gadget2,GTLV_Labels,(ULONG)gadgetdata->gd_Labels_Gadget2,GTLV_ReadOnly,FALSE,GTLV_Selected,gadgetdata->gd_Selected_Gadget2,GTLV_ShowSelected,NULL,GTLV_Top,gadgetdata->gd_Top_Gadget2,LAYOUTA_Spacing,0,TAG_END);
		wingads[BTID_Gadget3]=gadget=CreateGadget(BUTTON_KIND,gadget,&newgad[BTID_Gadget3],GA_Disabled,gadgetdata->gd_Disabled_Gadget3,GT_Underscore,'_',TAG_END);
		wingads[BTID_Gadget5]=gadget=CreateGadget(BUTTON_KIND,gadget,&newgad[BTID_Gadget5],GA_Disabled,gadgetdata->gd_Disabled_Gadget5,GT_Underscore,'_',TAG_END);
		wingads[BTID_Gadget4]=gadget=CreateGadget(BUTTON_KIND,gadget,&newgad[BTID_Gadget4],GA_Disabled,gadgetdata->gd_Disabled_Gadget4,GT_Underscore,'_',TAG_END);
		wingads[CYID_Gadget6]=gadget=CreateGadget(CYCLE_KIND,gadget,&newgad[CYID_Gadget6],GA_Disabled,gadgetdata->gd_Disabled_Gadget6,GTCY_Labels,(ULONG)gadgetdata->gd_Labels_Gadget6,GTCY_Active,gadgetdata->gd_Active_Gadget6,TAG_END);
		wingads[CYID_Gadget7]=gadget=CreateGadget(CYCLE_KIND,gadget,&newgad[CYID_Gadget7],GA_Disabled,gadgetdata->gd_Disabled_Gadget7,GTCY_Labels,(ULONG)gadgetdata->gd_Labels_Gadget7,GTCY_Active,gadgetdata->gd_Active_Gadget7,TAG_END);
		wingads[CYID_Gadget8]=gadget=CreateGadget(CYCLE_KIND,gadget,&newgad[CYID_Gadget8],GA_Disabled,gadgetdata->gd_Disabled_Gadget8,GTCY_Labels,(ULONG)gadgetdata->gd_Labels_Gadget8,GTCY_Active,gadgetdata->gd_Active_Gadget8,TAG_END);
		wingads[CYID_Gadget9]=gadget=CreateGadget(CYCLE_KIND,gadget,&newgad[CYID_Gadget9],GA_Disabled,gadgetdata->gd_Disabled_Gadget9,GTCY_Labels,(ULONG)gadgetdata->gd_Labels_Gadget9,GTCY_Active,gadgetdata->gd_Active_Gadget9,TAG_END);
		wingads[CYID_Gadget10]=gadget=CreateGadget(CYCLE_KIND,gadget,&newgad[CYID_Gadget10],GA_Disabled,gadgetdata->gd_Disabled_Gadget10,GTCY_Labels,(ULONG)gadgetdata->gd_Labels_Gadget10,GTCY_Active,gadgetdata->gd_Active_Gadget10,TAG_END);
		wingads[CYID_Gadget11]=gadget=CreateGadget(CYCLE_KIND,gadget,&newgad[CYID_Gadget11],GA_Disabled,gadgetdata->gd_Disabled_Gadget11,GTCY_Labels,(ULONG)gadgetdata->gd_Labels_Gadget11,GTCY_Active,gadgetdata->gd_Active_Gadget11,TAG_END);
		wingads[INID_Gadget12]=gadget=CreateGadget(INTEGER_KIND,gadget,&newgad[INID_Gadget12],GA_Disabled,gadgetdata->gd_Disabled_Gadget12,GA_TabCycle,TRUE,GTIN_MaxChars,2,GTIN_Number,gadgetdata->gd_Number_Gadget12,STRINGA_ExitHelp,TRUE,STRINGA_Justification,GACT_STRINGCENTER,STRINGA_ReplaceMode,FALSE,TAG_END);
		wingads[INID_Gadget13]=gadget=CreateGadget(INTEGER_KIND,gadget,&newgad[INID_Gadget13],GA_Disabled,gadgetdata->gd_Disabled_Gadget13,GA_TabCycle,TRUE,GTIN_MaxChars,2,GTIN_Number,gadgetdata->gd_Number_Gadget13,STRINGA_ExitHelp,TRUE,STRINGA_Justification,GACT_STRINGCENTER,STRINGA_ReplaceMode,FALSE,TAG_END);
		wingads[INID_Gadget14]=gadget=CreateGadget(INTEGER_KIND,gadget,&newgad[INID_Gadget14],GA_Disabled,gadgetdata->gd_Disabled_Gadget14,GA_TabCycle,TRUE,GTIN_MaxChars,3,GTIN_Number,gadgetdata->gd_Number_Gadget14,STRINGA_ExitHelp,TRUE,STRINGA_Justification,GACT_STRINGCENTER,STRINGA_ReplaceMode,FALSE,TAG_END);
		wingads[LAID_Gadget15]=gadget=CreateGadget(TEXT_KIND,gadget,&newgad[LAID_Gadget15],GT_Underscore,'_',GTTX_Border,FALSE,TAG_END);
		wingads[LAID_Gadget16]=gadget=CreateGadget(TEXT_KIND,gadget,&newgad[LAID_Gadget16],GT_Underscore,'_',GTTX_Border,FALSE,TAG_END);
		wingads[LAID_Gadget18]=gadget=CreateGadget(TEXT_KIND,gadget,&newgad[LAID_Gadget18],GT_Underscore,'_',GTTX_Border,FALSE,TAG_END);
		wingads[LAID_Gadget19]=gadget=CreateGadget(TEXT_KIND,gadget,&newgad[LAID_Gadget19],GT_Underscore,'_',GTTX_Border,FALSE,TAG_END);
		wingads[LAID_Gadget20]=gadget=CreateGadget(TEXT_KIND,gadget,&newgad[LAID_Gadget20],GT_Underscore,'_',GTTX_Border,FALSE,TAG_END);
		wingads[LAID_Gadget21]=gadget=CreateGadget(TEXT_KIND,gadget,&newgad[LAID_Gadget21],GT_Underscore,'_',GTTX_Border,FALSE,TAG_END);
		wingads[LAID_Gadget22]=gadget=CreateGadget(TEXT_KIND,gadget,&newgad[LAID_Gadget22],GT_Underscore,'_',GTTX_Border,FALSE,TAG_END);
		wingads[LAID_Gadget23]=gadget=CreateGadget(TEXT_KIND,gadget,&newgad[LAID_Gadget23],GT_Underscore,'_',GTTX_Border,FALSE,TAG_END);
		wingads[LAID_Gadget24]=gadget=CreateGadget(TEXT_KIND,gadget,&newgad[LAID_Gadget24],GT_Underscore,'_',GTTX_Border,FALSE,TAG_END);
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
void HandlePrinterPrefsWindow(struct Screen *customscreen,LONG left,LONG top,APTR userdata)
{
	APTR             visualinfo   = NULL;
	struct Gadget   *gadgetlist   = NULL;
	char            *title        = "Printer Preferences";
	struct Window   *win          = NULL;
	struct Gadget   *wingads[46];
	struct TextAttr  textattr     = { NULL,8,FS_NORMAL,FPF_DISKFONT };
	struct Menu     *menustrip    = NULL;
	ULONG  height=26,width=63,maxheight=1024,maxwidth=1280;

	textattr.ta_Name  = ((struct GfxBase *)GfxBase)->DefaultFont->tf_Message.mn_Node.ln_Name;
	textattr.ta_YSize = ((struct GfxBase *)GfxBase)->DefaultFont->tf_YSize;
	visualinfo        = GetVisualInfo(customscreen,TAG_DONE);

	if (visualinfo)
		{
		char *LA_Gadget6[]  = { "Parallel","Serial",NULL };
		char *LA_Gadget7[]  = { "Pica (10 cpi)","Elite (12 cpi)","Fine (15-17 cpi)",NULL };
		char *LA_Gadget8[]  = { "6 Lines Per Inch","8 Lines Per Inch",NULL };
		char *LA_Gadget9[]  = { "Letter","Draft",NULL };
		char *LA_Gadget10[]  = { "Single","Continuous",NULL };
		char *LA_Gadget11[]  = { "U.S. Letter","U.S. Legal","Narrow Tractor","Wide Tractor","DIN A4",NULL };
		struct NewMenu menu[] = {
			NM_TITLE, "Project",0,0,0,0,
			NM_ITEM ,"Open","O",0,0,0,
			NM_ITEM ,"Save As ...","a",0,0,0,
			NM_ITEM ,NM_BARLABEL,0,0,0,0,
			NM_ITEM ,"Quit ...","q",0,0,0,
			NM_TITLE, "Edit",0,0,0,0,
			NM_ITEM ,"Reset To Defaults","d",0,0,0,
			NM_ITEM ,"Last Saved","l",0,0,0,
			NM_ITEM ,"Restore","r",0,0,0,
			NM_TITLE, "Settings",0,0,0,0,
			NM_ITEM ,"Create Icons ?","i",0|CHECKIT|CHECKED,0,0,
			NULL,
			};
		struct NewGadget newgad[] = {
			XPOS(1),YPOS(0),XSIZE(21),YSIZE(2),"_Printer Type:",&textattr, LAID_Gadget1,PLACETEXT_IN,visualinfo,NULL,
			XPOS(1),YPOS(2),XSIZE(21),YSIZE(20),NULL,&textattr, LVID_Gadget2,PLACETEXT_ABOVE,visualinfo,NULL,
			XPOS(1),YPOS(23),XSIZE(15),YSIZE(2),"_Save",&textattr, BTID_Gadget3,PLACETEXT_IN,visualinfo,NULL,
			XPOS(24),YPOS(23),XSIZE(16),YSIZE(2),"_Use",&textattr, BTID_Gadget5,PLACETEXT_IN,visualinfo,NULL,
			XPOS(47),YPOS(23),XSIZE(15),YSIZE(2),"_Cancel",&textattr, BTID_Gadget4,PLACETEXT_IN,visualinfo,NULL,
			XPOS(41),YPOS(1),XSIZE(21),YSIZE(2),NULL,&textattr, CYID_Gadget6,PLACETEXT_ABOVE,visualinfo,NULL,
			XPOS(41),YPOS(4),XSIZE(21),YSIZE(2),NULL,&textattr, CYID_Gadget7,PLACETEXT_ABOVE,visualinfo,NULL,
			XPOS(41),YPOS(6),XSIZE(21),YSIZE(2),NULL,&textattr, CYID_Gadget8,PLACETEXT_ABOVE,visualinfo,NULL,
			XPOS(41),YPOS(8),XSIZE(21),YSIZE(2),NULL,&textattr, CYID_Gadget9,PLACETEXT_ABOVE,visualinfo,NULL,
			XPOS(41),YPOS(11),XSIZE(21),YSIZE(2),NULL,&textattr, CYID_Gadget10,PLACETEXT_ABOVE,visualinfo,NULL,
			XPOS(41),YPOS(13),XSIZE(21),YSIZE(2),NULL,&textattr, CYID_Gadget11,PLACETEXT_ABOVE,visualinfo,NULL,
			XPOS(52),YPOS(16),XSIZE(10),YSIZE(2),NULL,&textattr, INID_Gadget12,PLACETEXT_LEFT,visualinfo,NULL,
			XPOS(52),YPOS(18),XSIZE(10),YSIZE(2),NULL,&textattr, INID_Gadget13,PLACETEXT_LEFT,visualinfo,NULL,
			XPOS(52),YPOS(20),XSIZE(10),YSIZE(2),NULL,&textattr, INID_Gadget14,PLACETEXT_LEFT,visualinfo,NULL,
			XPOS(24),YPOS(1),XSIZE(16),YSIZE(2),"Printer P_ort   :",&textattr, LAID_Gadget15,PLACETEXT_IN,visualinfo,NULL,
			XPOS(24),YPOS(4),XSIZE(16),YSIZE(2),"Print P_itch    :",&textattr, LAID_Gadget16,PLACETEXT_IN,visualinfo,NULL,
			XPOS(24),YPOS(6),XSIZE(16),YSIZE(2),"Print Sp_acing  :",&textattr, LAID_Gadget18,PLACETEXT_IN,visualinfo,NULL,
			XPOS(24),YPOS(8),XSIZE(16),YSIZE(2),"Print _Quality  :",&textattr, LAID_Gadget19,PLACETEXT_IN,visualinfo,NULL,
			XPOS(24),YPOS(11),XSIZE(16),YSIZE(2),"Paper Typ_e     :",&textattr, LAID_Gadget20,PLACETEXT_IN,visualinfo,NULL,
			XPOS(24),YPOS(13),XSIZE(16),YSIZE(2),"Paper _Format   :",&textattr, LAID_Gadget21,PLACETEXT_IN,visualinfo,NULL,
			XPOS(24),YPOS(16),XSIZE(27),YSIZE(2),"Paper _Length (lines)      :",&textattr, LAID_Gadget22,PLACETEXT_IN,visualinfo,NULL,
			XPOS(24),YPOS(18),XSIZE(27),YSIZE(2),"Left  Ma_rgin (characters) :",&textattr, LAID_Gadget23,PLACETEXT_IN,visualinfo,NULL,
			XPOS(24),YPOS(20),XSIZE(27),YSIZE(2),"Right Margi_n (characters) :",&textattr, LAID_Gadget24,PLACETEXT_IN,visualinfo,NULL,
			};
		struct PrinterPrefsWindowData gadgetdata = {
			/* belongs to a listview gadget */
			FALSE,
			(struct List *)~0,
			0,
			0,
			/* belongs to a button */
			FALSE,
			/* belongs to a button */
			FALSE,
			/* belongs to a button */
			FALSE,
			/* belongs to a cycle gadget */
			FALSE,
			0,
			(char * *)&LA_Gadget6[0],
			/* belongs to a cycle gadget */
			FALSE,
			0,
			(char * *)&LA_Gadget7[0],
			/* belongs to a cycle gadget */
			FALSE,
			0,
			(char * *)&LA_Gadget8[0],
			/* belongs to a cycle gadget */
			FALSE,
			0,
			(char * *)&LA_Gadget9[0],
			/* belongs to a cycle gadget */
			FALSE,
			0,
			(char * *)&LA_Gadget10[0],
			/* belongs to a cycle gadget */
			FALSE,
			0,
			(char * *)&LA_Gadget11[0],
			/* belongs to an integer gadget */
			FALSE,
			64,
			/* belongs to an integer gadget */
			FALSE,
			8,
			/* belongs to an integer gadget */
			FALSE,
			100,
			};
		height= YSIZE(height);
		width = XSIZE(width) ;
		if (left == -1) left = (customscreen->Width -width )/2;
		if (top  == -1) top  = (customscreen->Height-height)/2;

		if (CreateGadgetsPrinterPrefsWindow(&gadgetlist,newgad,wingads,&gadgetdata) != NULL)
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
						WA_IDCMP,            IDCMP_CLOSEWINDOW|IDCMP_NEWSIZE|IDCMP_VANILLAKEY|IDCMP_REFRESHWINDOW|IDCMP_GADGETUP|IDCMP_MENUPICK|BUTTONIDCMP|INTEGERIDCMP|CYCLEIDCMP|LISTVIEWIDCMP,
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
							struct NewGadget     ngcopy[46];
							CopyMem(newgad,ngcopy,sizeof(ngcopy));
							SetFont(win->RPort,((struct GfxBase *)GfxBase)->DefaultFont);
							GT_RefreshWindow(win,NULL);
							UserSetupPrinterPrefsWindow(win,wingads,userdata);
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
											HandleGadgetsPrinterPrefsWindow(win,wingads,idcmpgad->GadgetID,messagecode,&gadgetdata,userdata);
											break;
										case IDCMP_MENUPICK:
											switch(MENUNUM(messagecode))
												{
												case 0:
													switch (ITEMNUM(messagecode))
														{
														case 0:
															ItemOpenClicked(win,wingads,userdata);
															break;
														case 1:
															ItemSaveClicked(win,wingads,userdata);
															break;
														case 3:
															ItemQuitClicked(win,wingads,userdata);
															break;
														}
													break;
												case 1:
													switch (ITEMNUM(messagecode))
														{
														}
													break;
												case 2:
													switch (ITEMNUM(messagecode))
														{
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
											for (i=0;i<46;i++)
												{
												ngcopy[i].ng_LeftEdge=(WORD)((long double)newgad[i].ng_LeftEdge*xscale);
												ngcopy[i].ng_TopEdge =(WORD)((long double)newgad[i].ng_TopEdge *yscale);
												ngcopy[i].ng_Width   =(WORD)((long double)newgad[i].ng_Width   *xscale);
												ngcopy[i].ng_Height  =(WORD)((long double)newgad[i].ng_Height  *yscale);
												}
											GT_GetGadgetAttrs(wingads[LVID_Gadget2],win,NULL,GA_Disabled,(ULONG)&longpointer1,GTLV_Labels,(ULONG)&longpointer2,TAG_END);
											gadgetdata.gd_Disabled_Gadget2=(longpointer1 == 0)?FALSE:TRUE;
											gadgetdata.gd_Labels_Gadget2=(struct List *)longpointer2;
											GT_GetGadgetAttrs(wingads[LVID_Gadget2],win,NULL,GTLV_Top,(ULONG)&longpointer1,GTLV_Selected,(ULONG)&longpointer2,TAG_END);
											gadgetdata.gd_Top_Gadget2=longpointer1;
											gadgetdata.gd_Selected_Gadget2=longpointer2;
											GT_GetGadgetAttrs(wingads[BTID_Gadget3],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
											gadgetdata.gd_Disabled_Gadget3=(longpointer1 == 0)?FALSE:TRUE;
											GT_GetGadgetAttrs(wingads[BTID_Gadget5],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
											gadgetdata.gd_Disabled_Gadget5=(longpointer1 == 0)?FALSE:TRUE;
											GT_GetGadgetAttrs(wingads[BTID_Gadget4],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
											gadgetdata.gd_Disabled_Gadget4=(longpointer1 == 0)?FALSE:TRUE;
											GT_GetGadgetAttrs(wingads[CYID_Gadget6],win,NULL,GA_Disabled,(ULONG)&longpointer1,GTCY_Active,(ULONG)&longpointer2,TAG_END);
											gadgetdata.gd_Disabled_Gadget6=(longpointer1 == 0)?FALSE:TRUE;
											gadgetdata.gd_Active_Gadget6=longpointer2;
											GT_GetGadgetAttrs(wingads[CYID_Gadget6],win,NULL,GTCY_Labels,(ULONG)&longpointer1,TAG_END);
											gadgetdata.gd_Labels_Gadget6=(char * *)longpointer1;
											GT_GetGadgetAttrs(wingads[CYID_Gadget7],win,NULL,GA_Disabled,(ULONG)&longpointer1,GTCY_Active,(ULONG)&longpointer2,TAG_END);
											gadgetdata.gd_Disabled_Gadget7=(longpointer1 == 0)?FALSE:TRUE;
											gadgetdata.gd_Active_Gadget7=longpointer2;
											GT_GetGadgetAttrs(wingads[CYID_Gadget7],win,NULL,GTCY_Labels,(ULONG)&longpointer1,TAG_END);
											gadgetdata.gd_Labels_Gadget7=(char * *)longpointer1;
											GT_GetGadgetAttrs(wingads[CYID_Gadget8],win,NULL,GA_Disabled,(ULONG)&longpointer1,GTCY_Active,(ULONG)&longpointer2,TAG_END);
											gadgetdata.gd_Disabled_Gadget8=(longpointer1 == 0)?FALSE:TRUE;
											gadgetdata.gd_Active_Gadget8=longpointer2;
											GT_GetGadgetAttrs(wingads[CYID_Gadget8],win,NULL,GTCY_Labels,(ULONG)&longpointer1,TAG_END);
											gadgetdata.gd_Labels_Gadget8=(char * *)longpointer1;
											GT_GetGadgetAttrs(wingads[CYID_Gadget9],win,NULL,GA_Disabled,(ULONG)&longpointer1,GTCY_Active,(ULONG)&longpointer2,TAG_END);
											gadgetdata.gd_Disabled_Gadget9=(longpointer1 == 0)?FALSE:TRUE;
											gadgetdata.gd_Active_Gadget9=longpointer2;
											GT_GetGadgetAttrs(wingads[CYID_Gadget9],win,NULL,GTCY_Labels,(ULONG)&longpointer1,TAG_END);
											gadgetdata.gd_Labels_Gadget9=(char * *)longpointer1;
											GT_GetGadgetAttrs(wingads[CYID_Gadget10],win,NULL,GA_Disabled,(ULONG)&longpointer1,GTCY_Active,(ULONG)&longpointer2,TAG_END);
											gadgetdata.gd_Disabled_Gadget10=(longpointer1 == 0)?FALSE:TRUE;
											gadgetdata.gd_Active_Gadget10=longpointer2;
											GT_GetGadgetAttrs(wingads[CYID_Gadget10],win,NULL,GTCY_Labels,(ULONG)&longpointer1,TAG_END);
											gadgetdata.gd_Labels_Gadget10=(char * *)longpointer1;
											GT_GetGadgetAttrs(wingads[CYID_Gadget11],win,NULL,GA_Disabled,(ULONG)&longpointer1,GTCY_Active,(ULONG)&longpointer2,TAG_END);
											gadgetdata.gd_Disabled_Gadget11=(longpointer1 == 0)?FALSE:TRUE;
											gadgetdata.gd_Active_Gadget11=longpointer2;
											GT_GetGadgetAttrs(wingads[CYID_Gadget11],win,NULL,GTCY_Labels,(ULONG)&longpointer1,TAG_END);
											gadgetdata.gd_Labels_Gadget11=(char * *)longpointer1;
											GT_GetGadgetAttrs(wingads[INID_Gadget12],win,NULL,GA_Disabled,(ULONG)&longpointer1,GTIN_Number,(ULONG)&longpointer2,TAG_END);
											gadgetdata.gd_Disabled_Gadget12=(longpointer1 == 0)?FALSE:TRUE;
											gadgetdata.gd_Number_Gadget12=longpointer2;
											GT_GetGadgetAttrs(wingads[INID_Gadget13],win,NULL,GA_Disabled,(ULONG)&longpointer1,GTIN_Number,(ULONG)&longpointer2,TAG_END);
											gadgetdata.gd_Disabled_Gadget13=(longpointer1 == 0)?FALSE:TRUE;
											gadgetdata.gd_Number_Gadget13=longpointer2;
											GT_GetGadgetAttrs(wingads[INID_Gadget14],win,NULL,GA_Disabled,(ULONG)&longpointer1,GTIN_Number,(ULONG)&longpointer2,TAG_END);
											gadgetdata.gd_Disabled_Gadget14=(longpointer1 == 0)?FALSE:TRUE;
											gadgetdata.gd_Number_Gadget14=longpointer2;
											FreeGadgets(gadgetlist);
											gadgetlist=NULL;

											CreateGadgetsPrinterPrefsWindow(&gadgetlist,ngcopy,wingads,&gadgetdata);
											AddGList(win,gadgetlist,-1,-1,NULL);
											RefreshGList(gadgetlist,win,NULL,-1);
											GT_RefreshWindow(win,NULL);
											UserRefreshPrinterPrefsWindow(win,wingads,userdata);
											break;
										case IDCMP_VANILLAKEY:
											switch(messagecode)
												{
												case 'p':
													GT_GetGadgetAttrs(wingads[LVID_Gadget2],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														GT_GetGadgetAttrs(wingads[LVID_Gadget2],win,NULL,GTLV_Selected,(ULONG)&longpointer1,TAG_END);
														GT_SetGadgetAttrs(wingads[LVID_Gadget2],win,NULL,GTLV_Selected,longpointer1+1,TAG_END);
														GT_GetGadgetAttrs(wingads[LVID_Gadget2],win,NULL,GTLV_Selected,(ULONG)&longpointer2,TAG_END);
														if (longpointer2 != longpointer1)
															{
															HandleGadgetsPrinterPrefsWindow(win,wingads,LVID_Gadget2,longpointer2,&gadgetdata,userdata);
															}
														}
													break;
												case 'P':
													GT_GetGadgetAttrs(wingads[LVID_Gadget2],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														GT_GetGadgetAttrs(wingads[LVID_Gadget2],win,NULL,GTLV_Selected,(ULONG)&longpointer1,TAG_END);
														if (longpointer1 != 0)
															{
															GT_SetGadgetAttrs(wingads[LVID_Gadget2],win,NULL,GTLV_Selected,longpointer1-1,TAG_END);
															HandleGadgetsPrinterPrefsWindow(win,wingads,LVID_Gadget2,longpointer1-1,&gadgetdata,userdata);
															}
														}
													break;
												case 's':
													GT_GetGadgetAttrs(wingads[BTID_Gadget3],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														ShowGadget(win,wingads[BTID_Gadget3],GADGET_DOWN);
														Delay(5);
														ShowGadget(win,wingads[BTID_Gadget3],GADGET_UP  );
														HandleGadgetsPrinterPrefsWindow(win,wingads,BTID_Gadget3,messagecode,&gadgetdata,userdata);
														}
													break;
												case 'u':
													GT_GetGadgetAttrs(wingads[BTID_Gadget5],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														ShowGadget(win,wingads[BTID_Gadget5],GADGET_DOWN);
														Delay(5);
														ShowGadget(win,wingads[BTID_Gadget5],GADGET_UP  );
														HandleGadgetsPrinterPrefsWindow(win,wingads,BTID_Gadget5,messagecode,&gadgetdata,userdata);
														}
													break;
												case 'c':
													GT_GetGadgetAttrs(wingads[BTID_Gadget4],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														ShowGadget(win,wingads[BTID_Gadget4],GADGET_DOWN);
														Delay(5);
														ShowGadget(win,wingads[BTID_Gadget4],GADGET_UP  );
														HandleGadgetsPrinterPrefsWindow(win,wingads,BTID_Gadget4,messagecode,&gadgetdata,userdata);
														}
													break;
												case 'o':
													GT_GetGadgetAttrs(wingads[CYID_Gadget6],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														ShowGadget(win,wingads[CYID_Gadget6],GADGET_DOWN);
														Delay(5);
														ShowGadget(win,wingads[CYID_Gadget6],GADGET_UP  );
														GT_GetGadgetAttrs(wingads[CYID_Gadget6],win,NULL,GTCY_Active,(ULONG)&longpointer1,TAG_END);
														if (++longpointer1 == 2) longpointer1=0;
														GT_SetGadgetAttrs(wingads[CYID_Gadget6],win,NULL,GTCY_Active,longpointer1,TAG_END);
														HandleGadgetsPrinterPrefsWindow(win,wingads,CYID_Gadget6,longpointer1,&gadgetdata,userdata);
														}
													break;
												case 'O':
													GT_GetGadgetAttrs(wingads[CYID_Gadget6],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														ShowGadget(win,wingads[CYID_Gadget6],GADGET_DOWN);
														Delay(5);
														ShowGadget(win,wingads[CYID_Gadget6],GADGET_UP  );
														GT_GetGadgetAttrs(wingads[CYID_Gadget6],win,NULL,GTCY_Active,(ULONG)&longpointer1,TAG_END);
														if (longpointer1 == 0) longpointer1=2;
													longpointer1--;
														GT_SetGadgetAttrs(wingads[CYID_Gadget6],win,NULL,GTCY_Active,longpointer1,TAG_END);
														HandleGadgetsPrinterPrefsWindow(win,wingads,CYID_Gadget6,longpointer1,&gadgetdata,userdata);
														}
													break;
												case 'i':
													GT_GetGadgetAttrs(wingads[CYID_Gadget7],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														ShowGadget(win,wingads[CYID_Gadget7],GADGET_DOWN);
														Delay(5);
														ShowGadget(win,wingads[CYID_Gadget7],GADGET_UP  );
														GT_GetGadgetAttrs(wingads[CYID_Gadget7],win,NULL,GTCY_Active,(ULONG)&longpointer1,TAG_END);
														if (++longpointer1 == 3) longpointer1=0;
														GT_SetGadgetAttrs(wingads[CYID_Gadget7],win,NULL,GTCY_Active,longpointer1,TAG_END);
														HandleGadgetsPrinterPrefsWindow(win,wingads,CYID_Gadget7,longpointer1,&gadgetdata,userdata);
														}
													break;
												case 'I':
													GT_GetGadgetAttrs(wingads[CYID_Gadget7],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														ShowGadget(win,wingads[CYID_Gadget7],GADGET_DOWN);
														Delay(5);
														ShowGadget(win,wingads[CYID_Gadget7],GADGET_UP  );
														GT_GetGadgetAttrs(wingads[CYID_Gadget7],win,NULL,GTCY_Active,(ULONG)&longpointer1,TAG_END);
														if (longpointer1 == 0) longpointer1=3;
													longpointer1--;
														GT_SetGadgetAttrs(wingads[CYID_Gadget7],win,NULL,GTCY_Active,longpointer1,TAG_END);
														HandleGadgetsPrinterPrefsWindow(win,wingads,CYID_Gadget7,longpointer1,&gadgetdata,userdata);
														}
													break;
												case 'a':
													GT_GetGadgetAttrs(wingads[CYID_Gadget8],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														ShowGadget(win,wingads[CYID_Gadget8],GADGET_DOWN);
														Delay(5);
														ShowGadget(win,wingads[CYID_Gadget8],GADGET_UP  );
														GT_GetGadgetAttrs(wingads[CYID_Gadget8],win,NULL,GTCY_Active,(ULONG)&longpointer1,TAG_END);
														if (++longpointer1 == 2) longpointer1=0;
														GT_SetGadgetAttrs(wingads[CYID_Gadget8],win,NULL,GTCY_Active,longpointer1,TAG_END);
														HandleGadgetsPrinterPrefsWindow(win,wingads,CYID_Gadget8,longpointer1,&gadgetdata,userdata);
														}
													break;
												case 'A':
													GT_GetGadgetAttrs(wingads[CYID_Gadget8],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														ShowGadget(win,wingads[CYID_Gadget8],GADGET_DOWN);
														Delay(5);
														ShowGadget(win,wingads[CYID_Gadget8],GADGET_UP  );
														GT_GetGadgetAttrs(wingads[CYID_Gadget8],win,NULL,GTCY_Active,(ULONG)&longpointer1,TAG_END);
														if (longpointer1 == 0) longpointer1=2;
													longpointer1--;
														GT_SetGadgetAttrs(wingads[CYID_Gadget8],win,NULL,GTCY_Active,longpointer1,TAG_END);
														HandleGadgetsPrinterPrefsWindow(win,wingads,CYID_Gadget8,longpointer1,&gadgetdata,userdata);
														}
													break;
												case 'q':
													GT_GetGadgetAttrs(wingads[CYID_Gadget9],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														ShowGadget(win,wingads[CYID_Gadget9],GADGET_DOWN);
														Delay(5);
														ShowGadget(win,wingads[CYID_Gadget9],GADGET_UP  );
														GT_GetGadgetAttrs(wingads[CYID_Gadget9],win,NULL,GTCY_Active,(ULONG)&longpointer1,TAG_END);
														if (++longpointer1 == 2) longpointer1=0;
														GT_SetGadgetAttrs(wingads[CYID_Gadget9],win,NULL,GTCY_Active,longpointer1,TAG_END);
														HandleGadgetsPrinterPrefsWindow(win,wingads,CYID_Gadget9,longpointer1,&gadgetdata,userdata);
														}
													break;
												case 'Q':
													GT_GetGadgetAttrs(wingads[CYID_Gadget9],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														ShowGadget(win,wingads[CYID_Gadget9],GADGET_DOWN);
														Delay(5);
														ShowGadget(win,wingads[CYID_Gadget9],GADGET_UP  );
														GT_GetGadgetAttrs(wingads[CYID_Gadget9],win,NULL,GTCY_Active,(ULONG)&longpointer1,TAG_END);
														if (longpointer1 == 0) longpointer1=2;
													longpointer1--;
														GT_SetGadgetAttrs(wingads[CYID_Gadget9],win,NULL,GTCY_Active,longpointer1,TAG_END);
														HandleGadgetsPrinterPrefsWindow(win,wingads,CYID_Gadget9,longpointer1,&gadgetdata,userdata);
														}
													break;
												case 'e':
													GT_GetGadgetAttrs(wingads[CYID_Gadget10],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														ShowGadget(win,wingads[CYID_Gadget10],GADGET_DOWN);
														Delay(5);
														ShowGadget(win,wingads[CYID_Gadget10],GADGET_UP  );
														GT_GetGadgetAttrs(wingads[CYID_Gadget10],win,NULL,GTCY_Active,(ULONG)&longpointer1,TAG_END);
														if (++longpointer1 == 2) longpointer1=0;
														GT_SetGadgetAttrs(wingads[CYID_Gadget10],win,NULL,GTCY_Active,longpointer1,TAG_END);
														HandleGadgetsPrinterPrefsWindow(win,wingads,CYID_Gadget10,longpointer1,&gadgetdata,userdata);
														}
													break;
												case 'E':
													GT_GetGadgetAttrs(wingads[CYID_Gadget10],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														ShowGadget(win,wingads[CYID_Gadget10],GADGET_DOWN);
														Delay(5);
														ShowGadget(win,wingads[CYID_Gadget10],GADGET_UP  );
														GT_GetGadgetAttrs(wingads[CYID_Gadget10],win,NULL,GTCY_Active,(ULONG)&longpointer1,TAG_END);
														if (longpointer1 == 0) longpointer1=2;
													longpointer1--;
														GT_SetGadgetAttrs(wingads[CYID_Gadget10],win,NULL,GTCY_Active,longpointer1,TAG_END);
														HandleGadgetsPrinterPrefsWindow(win,wingads,CYID_Gadget10,longpointer1,&gadgetdata,userdata);
														}
													break;
												case 'f':
													GT_GetGadgetAttrs(wingads[CYID_Gadget11],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														ShowGadget(win,wingads[CYID_Gadget11],GADGET_DOWN);
														Delay(5);
														ShowGadget(win,wingads[CYID_Gadget11],GADGET_UP  );
														GT_GetGadgetAttrs(wingads[CYID_Gadget11],win,NULL,GTCY_Active,(ULONG)&longpointer1,TAG_END);
														if (++longpointer1 == 5) longpointer1=0;
														GT_SetGadgetAttrs(wingads[CYID_Gadget11],win,NULL,GTCY_Active,longpointer1,TAG_END);
														HandleGadgetsPrinterPrefsWindow(win,wingads,CYID_Gadget11,longpointer1,&gadgetdata,userdata);
														}
													break;
												case 'F':
													GT_GetGadgetAttrs(wingads[CYID_Gadget11],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														ShowGadget(win,wingads[CYID_Gadget11],GADGET_DOWN);
														Delay(5);
														ShowGadget(win,wingads[CYID_Gadget11],GADGET_UP  );
														GT_GetGadgetAttrs(wingads[CYID_Gadget11],win,NULL,GTCY_Active,(ULONG)&longpointer1,TAG_END);
														if (longpointer1 == 0) longpointer1=5;
													longpointer1--;
														GT_SetGadgetAttrs(wingads[CYID_Gadget11],win,NULL,GTCY_Active,longpointer1,TAG_END);
														HandleGadgetsPrinterPrefsWindow(win,wingads,CYID_Gadget11,longpointer1,&gadgetdata,userdata);
														}
													break;
												case 'l':
													GT_GetGadgetAttrs(wingads[INID_Gadget12],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0) ActivateGadget(wingads[INID_Gadget12],win,NULL);
													break;
												case 'r':
													GT_GetGadgetAttrs(wingads[INID_Gadget13],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0) ActivateGadget(wingads[INID_Gadget13],win,NULL);
													break;
												case 'n':
													GT_GetGadgetAttrs(wingads[INID_Gadget14],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0) ActivateGadget(wingads[INID_Gadget14],win,NULL);
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
