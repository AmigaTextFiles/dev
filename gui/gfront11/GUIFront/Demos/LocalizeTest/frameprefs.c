
/* FramePrefs.c - The GUI of the 'FramePrefs' section of the GUIFront
 *                preferences editor.
 *
 * Everything prefixed with DEMO_ is exported to Generic.o.
 */

#include <libraries/guifront.h>

#define CATCOMP_ARRAY
#include "strings.h"

/* First, some Gadget ID's */

enum
{
    GID_SCREENFONT,
    GID_FONT,
    GID_GETFONT,
    GID_COLOR,
    GID_ALIGNMENT,
    GID_BOLD,
    GID_ITALICS,
    GID_3D,
    GID_CENTERING,
};

/* Some data and tag items we'll be needing later */

static const struct TagItem txtags[] =
{
	{GTTX_Border, TRUE},
	{TAG_DONE},
};

static const struct TagItem getalttags[] =
{
	{ALT_Image, ALTI_GetFont},
	{ALT_AslRequester, TRUE},
	{TAG_DONE},
};

/* Note: Localized! */

static const ULONG alignmentlabels[] =
{
	MSG_Above,
	MSG_Centered,
	NULL,
};

static const struct TagItem alignmenttags[] =
{
	{GTMX_Labels, alignmentlabels},
	{TAG_DONE},
};

/* Note: Localized! */

static const ULONG centeringlabels[] =
{
	MSG_Left,
	MSG_Center,
	MSG_Right,
	NULL,
};

static const struct TagItem centeringtags[] =
{
	{GTMX_Labels, centeringlabels},
	{TAG_DONE},
};


/* Now, the GadgetSpec's we'll be needing for this GUI */

/* Note the extra GS_Localized flag! */

static GadgetSpec gadgetspecs[] =
{
	{CHECKBOX_KIND,  0,0,{0,0,0,0, (UBYTE *)MSG_ScreenFont, NULL,GID_SCREENFONT,PLACETEXT_LEFT}, NULL, GS_DefaultTags | GS_Localized},
	{TEXT_KIND,		20,0,{0,0,0,0, (UBYTE *)MSG_Font,       NULL,GID_FONT, PLACETEXT_LEFT}, txtags, GS_DefaultTags | GS_Localized},
	{GETALT_KIND,	 0,0,{0,0,0,0, NULL,                    NULL,GID_GETFONT,PLACETEXT_IN}, getalttags, GS_DefaultTags | GS_Localized},
	{PALETTE_KIND,	20,0,{0,0,0,0, (UBYTE *)MSG_Color,      NULL,GID_COLOR,PLACETEXT_LEFT}, NULL, GS_DefaultTags | GS_Localized},
	{MX_KIND,		 0,0,{0,0,0,0, NULL,                    NULL,GID_ALIGNMENT, PLACETEXT_RIGHT}, alignmenttags, GS_DefaultTags | GS_Localized},
	{CHECKBOX_KIND,	 0,0,{0,0,0,0, (UBYTE *)MSG_Bold,       NULL,GID_BOLD,PLACETEXT_RIGHT}, NULL, GS_DefaultTags | GS_Localized},
	{CHECKBOX_KIND,	 0,0,{0,0,0,0, (UBYTE *)MSG_Italics,    NULL,GID_ITALICS,PLACETEXT_RIGHT}, NULL, GS_DefaultTags | GS_Localized},
	{CHECKBOX_KIND,	 0,0,{0,0,0,0, (UBYTE *)MSG_3D,         NULL,GID_3D,PLACETEXT_RIGHT}, NULL, GS_DefaultTags | GS_Localized},
	{MX_KIND,		 0,0,{0,0,0,0, NULL,                    NULL,GID_CENTERING, PLACETEXT_RIGHT}, centeringtags, GS_DefaultTags | GS_Localized},
};

/* Now, we group all of these GadgetSpecs into an array of pointers, so the
 * layout engine can locate gadgets merely by their Gadget IDs.
 */

GadgetSpec *DEMO_GadgetSpecList[] =
{
    &gadgetspecs[0], &gadgetspecs[1], &gadgetspecs[2], &gadgetspecs[2],
    &gadgetspecs[3], &gadgetspecs[4], &gadgetspecs[5], &gadgetspecs[6],
    &gadgetspecs[7], &gadgetspecs[8],
    NULL,
};

/* Finally, the layout tag list itself. This is where most of the work is
 * done. This list completely describes how the above gadgets are arranged
 * in groups in the GUI.
 */

ULONG DEMO_LayoutList[] =
{
    GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth,

    GUIL_VertGroup, 1,
        GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth | GUILF_LabelAlign,

        GUIL_GadgetSpecID, GID_SCREENFONT,

        GUIL_HorizGroup, 0,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,
            GUIL_GadgetSpecID, GID_FONT,
            GUIL_GadgetSpecID, GID_GETFONT,
        TAG_DONE,

        GUIL_GadgetSpecID, GID_COLOR,
    TAG_DONE,

    GUIL_HorizGroup, 1,
        GUIL_Flags, GUILF_EqualShare | GUILF_EqualHeight,
        GUIL_VertGroup, 1,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,
            GUIL_FrameType, GUILFT_Ridge,
            GUIL_FrameHeadlineLoc, MSG_Alignment,  /* Localized! */
            GUIL_GadgetSpecID, GID_ALIGNMENT,
        TAG_DONE,
        GUIL_VertGroup, 1,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,
            GUIL_FrameType, GUILFT_Ridge,
            GUIL_FrameHeadlineLoc, MSG_Attributes, /* Localized! */
            GUIL_GadgetSpecID, GID_BOLD,
            GUIL_GadgetSpecID, GID_ITALICS,
            GUIL_GadgetSpecID, GID_3D,
        TAG_DONE,
        GUIL_VertGroup, 1,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,
            GUIL_FrameType, GUILFT_Ridge,
            GUIL_FrameHeadlineLoc, MSG_Centering, /* Localized! */
            GUIL_GadgetSpecID, GID_CENTERING,
        TAG_DONE,

    TAG_DONE,

    TAG_DONE,
};

/* A localized array of NewMenus */

struct NewMenu DEMO_NewMenu[] =
{
	{NM_TITLE, (STRPTR)MSG_Project},
		{NM_ITEM, (STRPTR)MSG_Open},
		{NM_ITEM, (STRPTR)MSG_SaveAs},
		{NM_ITEM, NM_BARLABEL},
		{NM_ITEM, (STRPTR)MSG_About},
		{NM_ITEM, NM_BARLABEL},
		{NM_ITEM, (STRPTR)MSG_Quit},

	{NM_TITLE, (STRPTR)MSG_Edit},
		{NM_ITEM, (STRPTR)MSG_ResetToDefaults},
			{NM_SUB, (STRPTR)MSG_ThisEntry},
			{NM_SUB, (STRPTR)MSG_AllEntries},
		{NM_ITEM, (STRPTR)MSG_LastSaved},
		{NM_ITEM, (STRPTR)MSG_Restore},

	{NM_TITLE, (STRPTR)MSG_Options},
		{NM_ITEM, (STRPTR)MSG_CreateIcons, NULL,CHECKIT | CHECKED},
		{NM_END},
};

/* Obligatory version tag */

static const char ver[] = "$VER: FramePrefsLoc 1.0 " __AMIGADATE__;

/* Now, some globals used by Generic.o during the call to GF_CreateGUIA() */

int DEMO_InitialOrientation = GUIL_VertGroup;

STRPTR DEMO_AppID       = "FramePrefsLoc";

STRPTR DEMO_Version     = "1.0",
       DEMO_LongDesc    = "Demo program - Frame Preferences, localized",
       DEMO_Author      = "Michael Berg",
       DEMO_Date        = __AMIGADATE__;

BOOL   DEMO_Backfill    = FALSE;
