/*------------------------------------------------------------------------**
**              My gadutil.library example translated into C              **
**                                          P-O Yliniemi 24-Dec-94        **
** Compile with SAS/C 6.x:                                                **
**        sc BetterTest.c                                                 **
**        slink lib:c.o BetterTest.o led.o to BetterTest LIB lib:sc.lib   **
**              lib:amiga.lib SMALLDATA SMALLCODE NODEBUG                 **
**------------------------------------------------------------------------*/
#define INTUI_V36_NAMES_ONLY

#include <exec/types.h>
#include <exec/execbase.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <libraries/gadtools.h>

#include <libraries/gadutil.h>
#include <proto/gadutil.h>
#include <gadutil_20to30comp.h>

#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>

#include <stdio.h>

#ifdef LATTICE
int CXBRK(void)     { return(0); }
int chkabort(void)  { return(0); }
#endif

extern struct ExecBase *SysBase;

#define DRIVE_MX_GAD	11
/*--------------------- Start of localized data --------------------------*/

#define MSG_NEXTDRIVE	0
#define MSG_PREVDRIVE	1
#define MSG_DRIVE	2
#define MSG_CHECKME	3
#define MSG_REQUESTER	4
#define MSG_FILENAME	5
#define MSG_INTEGER	6
#define MSG_DRAGME	7
#define MSG_SCROLLME	8
#define MSG_SELECTITEM	9
#define MSG_SELECTCOL	10
#define MNU_1_TITLE	100
#define MNI_1_IT1	101
#define MNI_1_IT2	102
#define MNI_1_IT3	103
#define MNS_1_IT3_1	104
#define MNS_1_IT3_2	105
#define MNI_1_IT4	106

static const struct AppString AppStrings[] =
{
	MSG_NEXTDRIVE, (STRPTR)"_Next drive",
	MSG_PREVDRIVE, (STRPTR)"_Prev drive",
	MSG_DRIVE, (STRPTR)"_Drive",
	MSG_CHECKME, (STRPTR)"C_heck me:",
	MSG_REQUESTER, (STRPTR)"_Requester",
	MSG_FILENAME, (STRPTR)"_Filename:",
	MSG_INTEGER, (STRPTR)"_Integer:",
	MSG_DRAGME, (STRPTR)"D_rag me:",
	MSG_SCROLLME, (STRPTR)"Scr_oll me:",
	MSG_SELECTITEM, (STRPTR)"_Select an item:",
	MSG_SELECTCOL, (STRPTR)"Select _Color:",
	MNU_1_TITLE, (STRPTR)" \000Project",
	MNI_1_IT1, (STRPTR)"O\000Open...",
	MNI_1_IT2, (STRPTR)"S\000Save",
	MNI_1_IT3, (STRPTR)" \000Print",
	MNS_1_IT3_1, (STRPTR)" \000Draft",
	MNS_1_IT3_2, (STRPTR)" \000NLQ",
	MNI_1_IT4, (STRPTR)"Q\000Quit",
};

#define catalogname "BetterTest.catalog"

/*---------------------- End of localized data ---------------------------*/

struct TagItem layoutmenutags[] = {
	GTMN_NewLookMenus,	TRUE,
	TAG_DONE
};

#define LEFT_OFFSET	6
#define TOP_OFFSET	3

struct TagItem StdGTTags[] = {
	GT_Underscore, '_',
	TAG_DONE
};

struct TagItem StdButtonTags[] = {
	GU_Flags,	PLACETEXT_IN,	GU_LabelHotkey,	TRUE,	TAG_DONE
};

struct TagItem StdGadTags[] = {
	GU_LabelHotkey,	TRUE,	TAG_DONE
};

struct TagItem NextDriveGad[] = {
	GU_GadgetKind,	BUTTON_KIND,	GU_LocaleText,	MSG_NEXTDRIVE,
	GU_Left,	LEFT_OFFSET,	GU_Top,		TOP_OFFSET,
	GU_AutoHeight,	4,		GU_AutoWidth,	20,
	TAG_MORE,	(ULONG)StdButtonTags
};

struct TagItem PrevDriveGad[] = {
	GU_GadgetKind,	BUTTON_KIND,	GU_LocaleText,	MSG_PREVDRIVE,
	GU_DupeWidth,	MSG_NEXTDRIVE,	GU_LeftRel,	MSG_NEXTDRIVE,
	GU_AddLeft,	INTERWIDTH,	TAG_MORE,	(ULONG)StdButtonTags
};

struct TagItem DriveGad[] = {
	GU_GadgetKind,	CYCLE_KIND,	GU_LocaleText,	MSG_DRIVE,
	GU_TopRel,	MSG_PREVDRIVE,	GU_AddTop,		INTERHEIGHT,
	GU_Flags,	PLACETEXT_LEFT,	TAG_MORE,		(ULONG)StdGadTags
};

APTR CycleText[] = { "DF0:", "DF1:", "DF2:", "DF3:", NULL };

struct TagItem DriveGTTags[] = {
	GTCY_Labels,	(ULONG)CycleText,	TAG_MORE,	(ULONG)StdGTTags
};

struct TagItem ReqGad[] = {
	GU_GadgetKind,	BUTTON_KIND,	GU_LocaleText,	MSG_REQUESTER,
	GU_TopRel,	MSG_DRIVE,	GU_AddTop,	INTERHEIGHT,
	TAG_MORE,	(ULONG)StdButtonTags
};

struct TagItem CheckBoxGad[] = {
	GU_Width,	CHECKBOX_WIDTH,	GU_Height,	CHECKBOX_HEIGHT,
	GU_GadgetKind,	CHECKBOX_KIND,	GU_LocaleText,	MSG_CHECKME,
	GU_AlignRight,	MSG_NEXTDRIVE,	GU_Flags,	PLACETEXT_LEFT,
	TAG_MORE,	(ULONG)StdGadTags
};

struct TagItem FileNameGad[] = {
	GU_GadgetKind,	STRING_KIND,	GU_TopRel,	MSG_REQUESTER,
	GU_LocaleText,	MSG_FILENAME,	GU_AutoHeight,	4,
	GU_AlignLeft,	MSG_CHECKME,	GU_AlignRight,	DRIVE_MX_GAD,
	GU_AddTop,	INTERHEIGHT,	GU_AddWidth,	4,
	TAG_MORE,	(ULONG)StdGadTags
};

struct TagItem IntegerGad[] = {
	GU_GadgetKind,	INTEGER_KIND,	GU_TopRel,	MSG_FILENAME,
	GU_LocaleText,	MSG_INTEGER,	GU_AddTop,	INTERHEIGHT,
	TAG_MORE,	(ULONG)StdGadTags
};

struct TagItem DriveMxGad[] = {
	GU_GadgetKind,	MX_KIND,	GU_AlignTop,	MSG_NEXTDRIVE,
	GU_Width,	MX_WIDTH,	GU_Height,	MX_HEIGHT,
	GU_AdjustTop,	2,		GU_Flags,	PLACETEXT_LEFT|NG_HIGHLABEL,
	GU_LeftRel,	MSG_PREVDRIVE,	GU_AddLeftChar,	7,
	GU_GadgetText,	(ULONG)"Driv_e",GU_LabelHotkey,	TRUE,
	TAG_DONE
};

struct TagItem MXGadGTTags[] = {
	GTMX_Labels,	(ULONG)CycleText,	GTMX_Spacing,	2,
	GTMX_Active,	2,			TAG_DONE
};

struct TagItem SliderGad[] = {
	GU_GadgetKind,	SLIDER_KIND,	GU_AlignLeft,	MSG_FILENAME,
	GU_AlignRight,	MSG_FILENAME,	GU_AutoHeight,	4,
	GU_TopRel,	MSG_INTEGER,	GU_AddTop,	INTERHEIGHT,
	GU_AddWidth,	-13,		GU_Flags,	PLACETEXT_LEFT,
	GU_LocaleText,	MSG_DRAGME,	TAG_MORE,	(ULONG)StdGadTags
};

struct TagItem SliderGTTags[] = {
	GTSL_Min,		-50,			GTSL_Max,	50,
	GTSL_Level,		10,			GTSL_MaxLevelLen, 3,
	GTSL_LevelFormat,	(ULONG)"%3ld",
	GTSL_LevelPlace,	PLACETEXT_RIGHT,
	TAG_MORE,		(ULONG)StdGTTags
};

struct TagItem ListViewGad[] = {
	GU_GadgetKind,	LISTVIEW_KIND,	GU_AlignTop,	MSG_DRIVE,
	GU_AlignBottom,	MSG_INTEGER,	GU_LocaleText,	MSG_SELECTITEM,
	GU_LeftRel,	MSG_INTEGER,	GU_Columns,	26,
	GU_Flags,	PLACETEXT_ABOVE|NG_HIGHLABEL,
	GU_AddLeft,	10,		TAG_MORE,	(ULONG)StdGadTags
};

struct TagItem LVGTTags[] = {
	GTLV_Labels,	NULL,		GTLV_ShowSelected,	-1L,
	TAG_MORE,	(ULONG)StdGTTags
};

struct TagItem ScrollGad[] = {
	GU_GadgetKind,	SCROLLER_KIND,	GU_LocaleText,	MSG_SCROLLME,
	GU_AlignLeft,	MSG_DRAGME,	GU_AlignRight,	MSG_INTEGER,
	GU_TopRel,	MSG_DRAGME,	GU_AddTop,	INTERHEIGHT,
	GU_Flags,	PLACETEXT_LEFT,	GU_AddWidth,	20,
	GU_DupeHeight,	MSG_DRAGME,	TAG_MORE,	(ULONG)StdGadTags
};

struct TagItem ScrollGTTags[] = {
	GTSC_Top,	110,		GTSC_Total,	9,
	GTSC_Visible,	5,		GTSC_Arrows,	16,
	TAG_MORE,	(ULONG)StdGTTags
};

struct TagItem PaletteGad[] = {
	GU_GadgetKind,	PALETTE_KIND,	GU_LocaleText,	MSG_SELECTCOL,
	GU_LeftRel,	MSG_SCROLLME,	GU_AddLeft,	INTERWIDTH,
	GU_Flags,	PLACETEXT_ABOVE|NG_HIGHLABEL,
	GU_TopRel,	MSG_SELECTITEM,	GU_AdjustTop,	INTERHEIGHT,
	GU_AlignBottom,	MSG_SCROLLME,	GU_AlignRight,	MSG_SELECTITEM,
	TAG_MORE,	(ULONG)StdGadTags
};

struct TagItem PaletteGTTags[] = {
	GTPA_Depth,	2,		GTPA_IndicatorWidth,	36,
	TAG_MORE,	(ULONG)StdGTTags
};

struct LayoutGadget gadgets[] = {
	MSG_NEXTDRIVE,	NextDriveGad,	StdGTTags,	NULL,
	MSG_PREVDRIVE,	PrevDriveGad,	StdGTTags,	NULL,
	MSG_DRIVE,	DriveGad,	DriveGTTags,	NULL,
	MSG_REQUESTER,	ReqGad,		StdGTTags,	NULL,
	MSG_CHECKME,	CheckBoxGad,	StdGTTags,	NULL,
	MSG_FILENAME,	FileNameGad,	StdGTTags,	NULL,
	MSG_INTEGER,	IntegerGad,	StdGTTags,	NULL,
	DRIVE_MX_GAD,	DriveMxGad,	MXGadGTTags,	NULL,
	MSG_DRAGME,	SliderGad,	SliderGTTags,	NULL,
	MSG_SELECTITEM,	ListViewGad,	LVGTTags,	NULL,
	MSG_SCROLLME,	ScrollGad,	ScrollGTTags,	NULL,
	MSG_SELECTCOL,	PaletteGad,	PaletteGTTags,	NULL,
	-1,		NULL,		NULL,		NULL
};

struct NewMenu MyNewMenu[] = {
	 NM_TITLE,	(STRPTR)MNU_1_TITLE,	0,	0,	0,	0,			/* | Project |	*/
	  NM_ITEM,	(STRPTR)MNI_1_IT1,		0,	0,	0,	(APTR)1,	/* Open [O]		*/
	  NM_ITEM,	(STRPTR)MNI_1_IT2,		0,	0,	0,	(APTR)2,	/* Save [S]		*/
	  NM_ITEM,	NM_BARLABEL,			0,	0,	0,	0,			/* -----------	*/
	  NM_ITEM,	(STRPTR)MNI_1_IT3,		0,	0,	0,	0,			/* Print...		*/
	   NM_SUB,	(STRPTR)MNS_1_IT3_1,	0,	0,	0,	(APTR)3,	/*      Draft	*/
	   NM_SUB,	(STRPTR)MNS_1_IT3_2,	0,	0,	0,	(APTR)4,	/*      NLQ		*/
	  NM_ITEM,	NM_BARLABEL,			0,	0,	0,	0,			/* -----------	*/
	  NM_ITEM,	(STRPTR)MNI_1_IT4,		0,	0,	0,	(APTR)5,	/* Quit [Q]		*/
	 NM_END,	NULL,					0,	0,	0,	0
};

LONG farright, farbottom;

struct TagItem LayoutTags[] = {
	GU_RightExtreme,	(ULONG)&farright,
	GU_LowerExtreme,	(ULONG)&farbottom,
	GU_DefTextAttr,		0,
	GU_Catalog,		0,
	GU_AppStrings,		(ULONG)&AppStrings,
	TAG_DONE
};

/*-----------------------------------------------------------------*/
struct Library *GadUtilBase;

struct List	  LibraryList;
struct Screen *screen = NULL;
struct Window *main_win = NULL;
APTR priv_info = NULL;

void process_window_events(struct Window *, struct Menu *);
void ToggleLED(void);

main()
{
	struct Gadget *glist;
	struct Menu *menustrip;
	LibraryList = SysBase->LibList;

	LVGTTags[0].ti_Data = (ULONG)&LibraryList;

	if (GadUtilBase = OpenLibrary("gadutil.library",0))
	{
		LayoutTags[3].ti_Data = (ULONG)GU_OpenCatalog(catalogname,0);

		if (screen = LockPubScreen(NULL))
		{
			LayoutTags[2].ti_Data = (ULONG)screen->Font;

			if (priv_info = GU_LayoutGadgetsA(&glist, gadgets, screen, LayoutTags))
			{
				if (main_win = OpenWindowTags(NULL,
							WA_Left,	0,
							WA_Top,		screen->Font->ta_YSize + 3,
							WA_InnerWidth, farright + LEFT_OFFSET,
							WA_InnerHeight, farbottom + TOP_OFFSET,
							WA_IDCMP,	LISTVIEWIDCMP | IDCMP_MENUPICK | CYCLEIDCMP |
									IDCMP_REFRESHWINDOW | IDCMP_CLOSEWINDOW |
									IDCMP_VANILLAKEY | IDCMP_RAWKEY,
							WA_Flags,	WFLG_DRAGBAR | WFLG_DEPTHGADGET |
									WFLG_CLOSEGADGET | WFLG_ACTIVATE |
									WFLG_SMART_REFRESH | WFLG_REPORTMOUSE,
							WA_Gadgets, glist,	WA_NewLookMenus,	TRUE,
							WA_Title,	"GadUtil library test",
							TAG_DONE))
				{
					GU_RefreshWindow(main_win, NULL);
					if (menustrip = GU_CreateLocMenuA(MyNewMenu, priv_info,
							NULL, layoutmenutags))
					{
						if (SetMenuStrip(main_win, menustrip))
						{
							process_window_events(main_win, menustrip);
							ClearMenuStrip(main_win);
						}
						GU_FreeMenus(menustrip);
					}
					CloseWindow(main_win);
				}
				GU_FreeLayoutGadgets(priv_info);
			}
			UnlockPubScreen(NULL, screen);
		}
		GU_CloseCatalog((struct Catalog *)LayoutTags[3].ti_Data);
		CloseLibrary((struct Library *)GadUtilBase);
	}
}

void process_window_events(struct Window *win, struct Menu *menuStrip)
{
	struct IntuiMessage *imsg;
	struct Gadget *gad, *tempgad;
	struct MenuItem *item;
	BOOL done = FALSE;
	UWORD menunumber;
	ULONG coords;

	while (!done)
	{
		Wait(1 << win->UserPort->mp_SigBit);

		while ((!done) && (imsg = GU_GetIMsg(win->UserPort)))
		{
			switch (imsg->Class)
			{
				case IDCMP_GADGETUP:
					ToggleLED();
					gad = (struct Gadget *)imsg->IAddress;
					switch (gad->GadgetID)
					{
						case MSG_NEXTDRIVE:
							if (tempgad = GU_GetGadgetPtr(DRIVE_MX_GAD, gadgets) )
							{
								if ((LONG)MXGadGTTags[2].ti_Data++ >= 3) MXGadGTTags[2].ti_Data = 0;
								GU_SetGadgetAttrsA(tempgad, win, NULL, &MXGadGTTags[2]);
							}
							break;

						case MSG_PREVDRIVE:
							if (tempgad = GU_GetGadgetPtr(DRIVE_MX_GAD, gadgets) )
							{
								if ((LONG)MXGadGTTags[2].ti_Data-- <= 0) MXGadGTTags[2].ti_Data = 3;
								GU_SetGadgetAttrsA(tempgad, win, NULL, &MXGadGTTags[2]);
							}
							break;

						case MSG_REQUESTER:
							GU_BlockInput(win);
							Delay(50);
							GU_FreeInput(win);
							break;

						case MSG_DRIVE:
							ToggleLED();
							break;
					}

				case IDCMP_GADGETDOWN:
					gad = (struct Gadget *)imsg->IAddress;
					if (gad->GadgetID == DRIVE_MX_GAD)
						MXGadGTTags[2].ti_Data = imsg->Code;
					break;

				case IDCMP_MOUSEMOVE:
					if (tempgad = GU_GetGadgetPtr(MSG_SELECTITEM, gadgets))
					{
						coords = (LONG)imsg->MouseX<<16|imsg->MouseY;

						if (GU_CoordsInGadBox(coords,tempgad))
						{
							ToggleLED();
						}
					}
					break;

				case IDCMP_MENUPICK:
					menunumber = imsg->Code;

					while ((menunumber != MENUNULL) && (!done))
					{
						item = ItemAddress(menuStrip, menunumber);

						if ( (LONG)GTMENUITEM_USERDATA(item) == 5)
							done = TRUE;

						menunumber = item->NextSelect;
					}
					break;

				case IDCMP_CLOSEWINDOW:
					done = TRUE;
					break;

				case IDCMP_REFRESHWINDOW:
					GU_BeginRefresh(win);
					GU_EndRefresh(win, TRUE);
					break;
			}
			GU_ReplyIMsg(imsg);
		}
	}
}
