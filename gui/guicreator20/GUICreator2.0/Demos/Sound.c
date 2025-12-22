/*************************************************************************/
/*                                                                       */
/*   Includes                                                            */
/*                                                                       */
/*************************************************************************/
#include "Sound_Includes.h"
#include "Sound.h"

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
struct SoundPrefsWindowData
	{
	BOOL    gd_Disabled_Gadget10;
	BOOL    gd_Checked_Gadget10;
	BOOL    gd_Disabled_Gadget11;
	BOOL    gd_Checked_Gadget11;
	BOOL    gd_Disabled_Gadget12;
	UWORD   gd_Active_Gadget12;
	char * *gd_Labels_Gadget12;
	BOOL    gd_Disabled_Gadget14;
	UWORD   gd_Level_Gadget14;
	UWORD   gd_Max_Gadget14;
	UWORD   gd_Min_Gadget14;
	BOOL    gd_Disabled_Gadget15;
	UWORD   gd_Level_Gadget15;
	UWORD   gd_Max_Gadget15;
	UWORD   gd_Min_Gadget15;
	BOOL    gd_Disabled_Gadget1;
	UWORD   gd_Level_Gadget1;
	UWORD   gd_Max_Gadget1;
	UWORD   gd_Min_Gadget1;
	BOOL    gd_Disabled_Gadget4;
	char    gd_String_Gadget4[256];
	BOOL    gd_Disabled_Gadget3;
	BOOL    gd_Disabled_Gadget5;
	BOOL    gd_Disabled_Gadget6;
	BOOL    gd_Disabled_Gadget8;
	BOOL    gd_Disabled_Gadget9;
	};

/*************************************************************************/
/*                                                                       */
/*   Routines to handle gadgets                                          */
/*                                                                       */
/*************************************************************************/
void HandleGadgetsSoundPrefsWindow(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,struct SoundPrefsWindowData *gadgetdata,APTR userdata)
{
	switch(gadgetid)
		{
		case CBID_Gadget10:
			Gadget10Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case CBID_Gadget11:
			Gadget11Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case CYID_Gadget12:
			Gadget12Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case SLID_Gadget14:
			Gadget14Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case SLID_Gadget15:
			Gadget15Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case SLID_Gadget1:
			Gadget1Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case STID_Gadget4:
			Gadget4Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case BTID_Gadget3:
			Gadget3Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case BTID_Gadget5:
			Gadget5Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case BTID_Gadget6:
			Gadget6Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case BTID_Gadget8:
			Gadget8Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		case BTID_Gadget9:
			Gadget9Clicked(win,wingads,gadgetid,messagecode,userdata);
			break;
		};
}

/*************************************************************************/
/*                                                                       */
/*   Routines to create gadgets                                          */
/*                                                                       */
/*************************************************************************/
struct Gadget *CreateGadgetsSoundPrefsWindow(struct Gadget **gadgetlist,struct NewGadget newgad[],struct Gadget *wingads[],struct SoundPrefsWindowData *gadgetdata)
{
	struct Gadget *gadget=CreateContext(gadgetlist);
	if (gadget)
		{
		wingads[LAID_Gadget1]=gadget=CreateGadget(TEXT_KIND,gadget,&newgad[LAID_Gadget1],GT_Underscore,'_',GTTX_Border,FALSE,TAG_END);
		wingads[LAID_Gadget2]=gadget=CreateGadget(TEXT_KIND,gadget,&newgad[LAID_Gadget2],GT_Underscore,'_',GTTX_Border,FALSE,TAG_END);
		wingads[LAID_Gadget3]=gadget=CreateGadget(TEXT_KIND,gadget,&newgad[LAID_Gadget3],GT_Underscore,'_',GTTX_Border,FALSE,TAG_END);
		wingads[LAID_Gadget4]=gadget=CreateGadget(TEXT_KIND,gadget,&newgad[LAID_Gadget4],GT_Underscore,'_',GTTX_Border,FALSE,TAG_END);
		wingads[LAID_Gadget6]=gadget=CreateGadget(TEXT_KIND,gadget,&newgad[LAID_Gadget6],GT_Underscore,'_',GTTX_Border,FALSE,TAG_END);
		wingads[LAID_Gadget8]=gadget=CreateGadget(TEXT_KIND,gadget,&newgad[LAID_Gadget8],GT_Underscore,'_',GTTX_Border,FALSE,TAG_END);
		wingads[LAID_Gadget9]=gadget=CreateGadget(TEXT_KIND,gadget,&newgad[LAID_Gadget9],GT_Underscore,'_',GTTX_Border,FALSE,TAG_END);
		wingads[CBID_Gadget10]=gadget=CreateGadget(CHECKBOX_KIND,gadget,&newgad[CBID_Gadget10],GA_Disabled,gadgetdata->gd_Disabled_Gadget10,GTCB_Scaled,TRUE,GTCB_Checked,gadgetdata->gd_Checked_Gadget10,TAG_END);
		wingads[CBID_Gadget11]=gadget=CreateGadget(CHECKBOX_KIND,gadget,&newgad[CBID_Gadget11],GA_Disabled,gadgetdata->gd_Disabled_Gadget11,GTCB_Scaled,TRUE,GTCB_Checked,gadgetdata->gd_Checked_Gadget11,TAG_END);
		wingads[CYID_Gadget12]=gadget=CreateGadget(CYCLE_KIND,gadget,&newgad[CYID_Gadget12],GA_Disabled,gadgetdata->gd_Disabled_Gadget12,GTCY_Labels,(ULONG)gadgetdata->gd_Labels_Gadget12,GTCY_Active,gadgetdata->gd_Active_Gadget12,TAG_END);
		wingads[SLID_Gadget14]=gadget=CreateGadget(SLIDER_KIND,gadget,&newgad[SLID_Gadget14],GA_Disabled,gadgetdata->gd_Disabled_Gadget14,GA_Immediate,TRUE,GA_RelVerify,TRUE,GTSL_Level,gadgetdata->gd_Level_Gadget14,GTSL_LevelFormat,(ULONG)"%ld",GTSL_LevelPlace,PLACETEXT_RIGHT,GTSL_Max,gadgetdata->gd_Max_Gadget14,GTSL_Min,gadgetdata->gd_Min_Gadget14,GTSL_MaxLevelLen,5,PGA_Freedom,LORIENT_HORIZ,TAG_END);
		wingads[SLID_Gadget15]=gadget=CreateGadget(SLIDER_KIND,gadget,&newgad[SLID_Gadget15],GA_Disabled,gadgetdata->gd_Disabled_Gadget15,GA_Immediate,TRUE,GA_RelVerify,TRUE,GTSL_Level,gadgetdata->gd_Level_Gadget15,GTSL_LevelFormat,(ULONG)"%ld",GTSL_LevelPlace,PLACETEXT_RIGHT,GTSL_Max,gadgetdata->gd_Max_Gadget15,GTSL_Min,gadgetdata->gd_Min_Gadget15,GTSL_MaxLevelLen,5,PGA_Freedom,LORIENT_HORIZ,TAG_END);
		wingads[SLID_Gadget1]=gadget=CreateGadget(SLIDER_KIND,gadget,&newgad[SLID_Gadget1],GA_Disabled,gadgetdata->gd_Disabled_Gadget1,GA_Immediate,TRUE,GA_RelVerify,TRUE,GTSL_Level,gadgetdata->gd_Level_Gadget1,GTSL_LevelFormat,(ULONG)"%ld",GTSL_LevelPlace,PLACETEXT_RIGHT,GTSL_Max,gadgetdata->gd_Max_Gadget1,GTSL_Min,gadgetdata->gd_Min_Gadget1,GTSL_MaxLevelLen,5,PGA_Freedom,LORIENT_HORIZ,TAG_END);
		wingads[STID_Gadget4]=gadget=CreateGadget(STRING_KIND,gadget,&newgad[STID_Gadget4],GA_Disabled,gadgetdata->gd_Disabled_Gadget4,GA_TabCycle,TRUE,GTST_MaxChars,256,GTST_String,(ULONG)gadgetdata->gd_String_Gadget4,GA_TabCycle,TRUE,STRINGA_ExitHelp,TRUE,STRINGA_Justification,GACT_STRINGLEFT,STRINGA_ReplaceMode,FALSE,TAG_END);
		wingads[BTID_Gadget3]=gadget=CreateGadget(BUTTON_KIND,gadget,&newgad[BTID_Gadget3],GA_Disabled,gadgetdata->gd_Disabled_Gadget3,GT_Underscore,'_',TAG_END);
		wingads[BTID_Gadget5]=gadget=CreateGadget(BUTTON_KIND,gadget,&newgad[BTID_Gadget5],GA_Disabled,gadgetdata->gd_Disabled_Gadget5,GT_Underscore,'_',TAG_END);
		wingads[BTID_Gadget6]=gadget=CreateGadget(BUTTON_KIND,gadget,&newgad[BTID_Gadget6],GA_Disabled,gadgetdata->gd_Disabled_Gadget6,GT_Underscore,'_',TAG_END);
		wingads[BTID_Gadget8]=gadget=CreateGadget(BUTTON_KIND,gadget,&newgad[BTID_Gadget8],GA_Disabled,gadgetdata->gd_Disabled_Gadget8,GT_Underscore,'_',TAG_END);
		wingads[BTID_Gadget9]=gadget=CreateGadget(BUTTON_KIND,gadget,&newgad[BTID_Gadget9],GA_Disabled,gadgetdata->gd_Disabled_Gadget9,GT_Underscore,'_',TAG_END);
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
void HandleSoundPrefsWindow(struct Screen *customscreen,LONG left,LONG top,APTR userdata)
{
	APTR             visualinfo   = NULL;
	struct Gadget   *gadgetlist   = NULL;
	char            *title        = "Sound Preferences";
	struct Window   *win          = NULL;
	struct Gadget   *wingads[39];
	struct TextAttr  textattr     = { NULL,8,FS_NORMAL,FPF_DISKFONT };
	struct Menu     *menustrip    = NULL;
	ULONG  height=22,width=42,maxheight=1024,maxwidth=1280;

	textattr.ta_Name  = ((struct GfxBase *)GfxBase)->DefaultFont->tf_Message.mn_Node.ln_Name;
	textattr.ta_YSize = ((struct GfxBase *)GfxBase)->DefaultFont->tf_YSize;
	visualinfo        = GetVisualInfo(customscreen,TAG_DONE);

	if (visualinfo)
		{
		char *LA_Gadget12[]  = { "Beep","Sampled Sound",NULL };
		struct BevelFrame bevels[] = {
			XPOS(1),YPOS(1),XSIZE(40),YSIZE(17),"Sound Preferences",2,
			};
		struct NewMenu menu[] = {
			NM_TITLE, "Program",0,0,0,0,
			NM_ITEM ,"About","A",0,0,0,
			NULL,
			};
		struct NewGadget newgad[] = {
			XPOS(2),YPOS(2),XSIZE(15),YSIZE(2),"_Flash Display:",&textattr, LAID_Gadget1,PLACETEXT_IN,visualinfo,NULL,
			XPOS(25),YPOS(2),XSIZE(12),YSIZE(2),"_Make Sound:",&textattr, LAID_Gadget2,PLACETEXT_IN,visualinfo,NULL,
			XPOS(2),YPOS(4),XSIZE(15),YSIZE(2),"Sound _Type   :",&textattr, LAID_Gadget3,PLACETEXT_IN,visualinfo,NULL,
			XPOS(2),YPOS(6),XSIZE(15),YSIZE(2),"Sound _Volume :",&textattr, LAID_Gadget4,PLACETEXT_IN,visualinfo,NULL,
			XPOS(2),YPOS(8),XSIZE(15),YSIZE(2),"Sound _Pitch  :",&textattr, LAID_Gadget6,PLACETEXT_IN,visualinfo,NULL,
			XPOS(2),YPOS(10),XSIZE(15),YSIZE(2),"_Beep Length  :",&textattr, LAID_Gadget8,PLACETEXT_IN,visualinfo,NULL,
			XPOS(2),YPOS(12),XSIZE(15),YSIZE(2),"Sample _Name  :",&textattr, LAID_Gadget9,PLACETEXT_IN,visualinfo,NULL,
			XPOS(17),YPOS(2),XSIZE(3),YSIZE(2),NULL,&textattr, CBID_Gadget10,PLACETEXT_ABOVE,visualinfo,NULL,
			XPOS(37),YPOS(2),XSIZE(3),YSIZE(2),NULL,&textattr, CBID_Gadget11,PLACETEXT_ABOVE,visualinfo,NULL,
			XPOS(17),YPOS(4),XSIZE(23),YSIZE(2),NULL,&textattr, CYID_Gadget12,PLACETEXT_ABOVE,visualinfo,NULL,
			XPOS(17),YPOS(6),XSIZE(18),YSIZE(2),NULL,&textattr, SLID_Gadget14,PLACETEXT_LEFT,visualinfo,NULL,
			XPOS(17),YPOS(8),XSIZE(18),YSIZE(2),NULL,&textattr, SLID_Gadget15,PLACETEXT_LEFT,visualinfo,NULL,
			XPOS(17),YPOS(10),XSIZE(18),YSIZE(2),NULL,&textattr, SLID_Gadget1,PLACETEXT_LEFT,visualinfo,NULL,
			XPOS(17),YPOS(12),XSIZE(21),YSIZE(2),NULL,&textattr, STID_Gadget4,PLACETEXT_LEFT,visualinfo,NULL,
			XPOS(38),YPOS(12),XSIZE(2),YSIZE(2),"«",&textattr, BTID_Gadget3,PLACETEXT_IN,visualinfo,NULL,
			XPOS(2),YPOS(15),XSIZE(38),YSIZE(2),"Test S_ound",&textattr, BTID_Gadget5,PLACETEXT_IN,visualinfo,NULL,
			XPOS(1),YPOS(19),XSIZE(12),YSIZE(2),"_Save",&textattr, BTID_Gadget6,PLACETEXT_IN,visualinfo,NULL,
			XPOS(15),YPOS(19),XSIZE(12),YSIZE(2),"_Use",&textattr, BTID_Gadget8,PLACETEXT_IN,visualinfo,NULL,
			XPOS(29),YPOS(19),XSIZE(12),YSIZE(2),"_Cancel",&textattr, BTID_Gadget9,PLACETEXT_IN,visualinfo,NULL,
			};
		struct SoundPrefsWindowData gadgetdata = {
			/* belongs to a checkbox gadget */
			FALSE,
			TRUE,
			/* belongs to a checkbox gadget */
			FALSE,
			TRUE,
			/* belongs to a cycle gadget */
			FALSE,
			1,
			(char * *)&LA_Gadget12[0],
			/* belongs to a slider gadget */
			FALSE,
			32,
			64,
			0,
			/* belongs to a slider gadget */
			FALSE,
			1500,
			3000,
			1,
			/* belongs to a slider gadget */
			TRUE,
			50,
			100,
			1,
			/* belongs to a string gadget */
			FALSE,
			"SYS:Prefs/Beep.IFF",
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
			};
		height= YSIZE(height);
		width = XSIZE(width) ;
		if (left == -1) left = (customscreen->Width -width )/2;
		if (top  == -1) top  = (customscreen->Height-height)/2;

		if (CreateGadgetsSoundPrefsWindow(&gadgetlist,newgad,wingads,&gadgetdata) != NULL)
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
						WA_IDCMP,            IDCMP_CLOSEWINDOW|IDCMP_NEWSIZE|IDCMP_VANILLAKEY|IDCMP_REFRESHWINDOW|IDCMP_GADGETUP|IDCMP_MENUPICK|BUTTONIDCMP|STRINGIDCMP|CHECKBOXIDCMP|CYCLEIDCMP|SLIDERIDCMP,
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
							SetFont(win->RPort,((struct GfxBase *)GfxBase)->DefaultFont);
							CreateBevelFrames(win,visualinfo,1,bevels);
							GT_RefreshWindow(win,NULL);
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
											HandleGadgetsSoundPrefsWindow(win,wingads,idcmpgad->GadgetID,messagecode,&gadgetdata,userdata);
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
										case IDCMP_VANILLAKEY:
											switch(messagecode)
												{
												case 'f':
													GT_GetGadgetAttrs(wingads[CBID_Gadget10],win,NULL,GA_Disabled,(ULONG)&longpointer2,GTCB_Checked,(ULONG)&longpointer1,TAG_END);
													if (longpointer2 == 0)
														{
														GT_SetGadgetAttrs(wingads[CBID_Gadget10],win,NULL,GTCB_Checked,(longpointer1 == 0)?TRUE:FALSE,TAG_END);
														HandleGadgetsSoundPrefsWindow(win,wingads,CBID_Gadget10,(longpointer1 == 0)?1:0,&gadgetdata,userdata);
														}
													break;
												case 'm':
													GT_GetGadgetAttrs(wingads[CBID_Gadget11],win,NULL,GA_Disabled,(ULONG)&longpointer2,GTCB_Checked,(ULONG)&longpointer1,TAG_END);
													if (longpointer2 == 0)
														{
														GT_SetGadgetAttrs(wingads[CBID_Gadget11],win,NULL,GTCB_Checked,(longpointer1 == 0)?TRUE:FALSE,TAG_END);
														HandleGadgetsSoundPrefsWindow(win,wingads,CBID_Gadget11,(longpointer1 == 0)?1:0,&gadgetdata,userdata);
														}
													break;
												case 't':
													GT_GetGadgetAttrs(wingads[CYID_Gadget12],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														ShowGadget(win,wingads[CYID_Gadget12],GADGET_DOWN);
														Delay(5);
														ShowGadget(win,wingads[CYID_Gadget12],GADGET_UP  );
														GT_GetGadgetAttrs(wingads[CYID_Gadget12],win,NULL,GTCY_Active,(ULONG)&longpointer1,TAG_END);
														if (++longpointer1 == 2) longpointer1=0;
														GT_SetGadgetAttrs(wingads[CYID_Gadget12],win,NULL,GTCY_Active,longpointer1,TAG_END);
														HandleGadgetsSoundPrefsWindow(win,wingads,CYID_Gadget12,longpointer1,&gadgetdata,userdata);
														}
													break;
												case 'T':
													GT_GetGadgetAttrs(wingads[CYID_Gadget12],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														ShowGadget(win,wingads[CYID_Gadget12],GADGET_DOWN);
														Delay(5);
														ShowGadget(win,wingads[CYID_Gadget12],GADGET_UP  );
														GT_GetGadgetAttrs(wingads[CYID_Gadget12],win,NULL,GTCY_Active,(ULONG)&longpointer1,TAG_END);
														if (longpointer1 == 0) longpointer1=2;
													longpointer1--;
														GT_SetGadgetAttrs(wingads[CYID_Gadget12],win,NULL,GTCY_Active,longpointer1,TAG_END);
														HandleGadgetsSoundPrefsWindow(win,wingads,CYID_Gadget12,longpointer1,&gadgetdata,userdata);
														}
													break;
												case 'v':
													GT_GetGadgetAttrs(wingads[SLID_Gadget14],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														GT_GetGadgetAttrs(wingads[SLID_Gadget14],win,NULL,GTSL_Max,(ULONG)&longpointer1,GTSL_Level,(ULONG)&longpointer2,TAG_END);
														if (longpointer2<longpointer1)
															{
															GT_SetGadgetAttrs(wingads[SLID_Gadget14],win,NULL,GTSL_Level,++longpointer2,TAG_END);
															HandleGadgetsSoundPrefsWindow(win,wingads,SLID_Gadget14,longpointer2,&gadgetdata,userdata);
															}
														}
													break;
												case 'V':
													GT_GetGadgetAttrs(wingads[SLID_Gadget14],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														GT_GetGadgetAttrs(wingads[SLID_Gadget14],win,NULL,GTSL_Min,(ULONG)&longpointer1,GTSL_Level,(ULONG)&longpointer2,TAG_END);
														if (longpointer2>longpointer1)
															{
															GT_SetGadgetAttrs(wingads[SLID_Gadget14],win,NULL,GTSL_Level,--longpointer2,TAG_END);
															HandleGadgetsSoundPrefsWindow(win,wingads,SLID_Gadget14,longpointer2,&gadgetdata,userdata);
															}
														}
													break;
												case 'p':
													GT_GetGadgetAttrs(wingads[SLID_Gadget15],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														GT_GetGadgetAttrs(wingads[SLID_Gadget15],win,NULL,GTSL_Max,(ULONG)&longpointer1,GTSL_Level,(ULONG)&longpointer2,TAG_END);
														if (longpointer2<longpointer1)
															{
															GT_SetGadgetAttrs(wingads[SLID_Gadget15],win,NULL,GTSL_Level,++longpointer2,TAG_END);
															HandleGadgetsSoundPrefsWindow(win,wingads,SLID_Gadget15,longpointer2,&gadgetdata,userdata);
															}
														}
													break;
												case 'P':
													GT_GetGadgetAttrs(wingads[SLID_Gadget15],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														GT_GetGadgetAttrs(wingads[SLID_Gadget15],win,NULL,GTSL_Min,(ULONG)&longpointer1,GTSL_Level,(ULONG)&longpointer2,TAG_END);
														if (longpointer2>longpointer1)
															{
															GT_SetGadgetAttrs(wingads[SLID_Gadget15],win,NULL,GTSL_Level,--longpointer2,TAG_END);
															HandleGadgetsSoundPrefsWindow(win,wingads,SLID_Gadget15,longpointer2,&gadgetdata,userdata);
															}
														}
													break;
												case 'b':
													GT_GetGadgetAttrs(wingads[SLID_Gadget1],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														GT_GetGadgetAttrs(wingads[SLID_Gadget1],win,NULL,GTSL_Max,(ULONG)&longpointer1,GTSL_Level,(ULONG)&longpointer2,TAG_END);
														if (longpointer2<longpointer1)
															{
															GT_SetGadgetAttrs(wingads[SLID_Gadget1],win,NULL,GTSL_Level,++longpointer2,TAG_END);
															HandleGadgetsSoundPrefsWindow(win,wingads,SLID_Gadget1,longpointer2,&gadgetdata,userdata);
															}
														}
													break;
												case 'B':
													GT_GetGadgetAttrs(wingads[SLID_Gadget1],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														GT_GetGadgetAttrs(wingads[SLID_Gadget1],win,NULL,GTSL_Min,(ULONG)&longpointer1,GTSL_Level,(ULONG)&longpointer2,TAG_END);
														if (longpointer2>longpointer1)
															{
															GT_SetGadgetAttrs(wingads[SLID_Gadget1],win,NULL,GTSL_Level,--longpointer2,TAG_END);
															HandleGadgetsSoundPrefsWindow(win,wingads,SLID_Gadget1,longpointer2,&gadgetdata,userdata);
															}
														}
													break;
												case 'n':
													GT_GetGadgetAttrs(wingads[STID_Gadget4],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0) ActivateGadget(wingads[STID_Gadget4],win,NULL);
													break;
												case 'N':
													GT_GetGadgetAttrs(wingads[BTID_Gadget3],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														ShowGadget(win,wingads[BTID_Gadget3],GADGET_DOWN);
														Delay(5);
														ShowGadget(win,wingads[BTID_Gadget3],GADGET_UP  );
														HandleGadgetsSoundPrefsWindow(win,wingads,BTID_Gadget3,messagecode,&gadgetdata,userdata);
														}
													break;
												case 'o':
													GT_GetGadgetAttrs(wingads[BTID_Gadget5],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														ShowGadget(win,wingads[BTID_Gadget5],GADGET_DOWN);
														Delay(5);
														ShowGadget(win,wingads[BTID_Gadget5],GADGET_UP  );
														HandleGadgetsSoundPrefsWindow(win,wingads,BTID_Gadget5,messagecode,&gadgetdata,userdata);
														}
													break;
												case 's':
													GT_GetGadgetAttrs(wingads[BTID_Gadget6],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														ShowGadget(win,wingads[BTID_Gadget6],GADGET_DOWN);
														Delay(5);
														ShowGadget(win,wingads[BTID_Gadget6],GADGET_UP  );
														HandleGadgetsSoundPrefsWindow(win,wingads,BTID_Gadget6,messagecode,&gadgetdata,userdata);
														}
													break;
												case 'u':
													GT_GetGadgetAttrs(wingads[BTID_Gadget8],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														ShowGadget(win,wingads[BTID_Gadget8],GADGET_DOWN);
														Delay(5);
														ShowGadget(win,wingads[BTID_Gadget8],GADGET_UP  );
														HandleGadgetsSoundPrefsWindow(win,wingads,BTID_Gadget8,messagecode,&gadgetdata,userdata);
														}
													break;
												case 'c':
													GT_GetGadgetAttrs(wingads[BTID_Gadget9],win,NULL,GA_Disabled,(ULONG)&longpointer1,TAG_END);
													if (longpointer1 == 0)
														{
														ShowGadget(win,wingads[BTID_Gadget9],GADGET_DOWN);
														Delay(5);
														ShowGadget(win,wingads[BTID_Gadget9],GADGET_UP  );
														HandleGadgetsSoundPrefsWindow(win,wingads,BTID_Gadget9,messagecode,&gadgetdata,userdata);
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
