
/* ToolManager.c - The GUI of the 'ToolManager' program
 *
 * This is a GUIFront example GUI. To build an example, compile and link this
 * file with Generic.o (also supplied).
 * Everything prefixed with DEMO_ is exported to Generic.o.
 */

#include <libraries/guifront.h>

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
    GID_LEADING,
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

static const STRPTR alignmentlabels[] =
{
	"_Above",
	"_Centered",
	NULL,
};

static const struct TagItem alignmenttags[] =
{
	{GTMX_Labels, alignmentlabels},
	{TAG_DONE},
};

static const STRPTR leadinglabels[] =
{
    "_Left",
    "_Center",
    "_Right",
	NULL,
};

static const struct TagItem leadingtags[] =
{
	{GTMX_Labels, leadinglabels},
	{TAG_DONE},
};


static const struct TagItem patags[] =
{
	{GTPA_Depth, 2},
	{TAG_DONE},
};


/* Now, the GadgetSpec's we'll be needing for this GUI */

static GadgetSpec gadgetspecs[] =
{
	{CHECKBOX_KIND,  0,0,{0,0,0,0, "_Screen Font",NULL,GID_SCREENFONT,PLACETEXT_LEFT}, NULL, GS_DefaultTags},
	{TEXT_KIND,		20,0,{0,0,0,0, "Font",        NULL,GID_FONT, PLACETEXT_LEFT}, txtags, GS_DefaultTags},
	{GETALT_KIND,	 0,0,{0,0,0,0, NULL,          NULL,GID_GETFONT,PLACETEXT_IN}, getalttags, GS_DefaultTags},
	{PALETTE_KIND,	20,0,{0,0,0,0, "C_olor",      NULL,GID_COLOR,PLACETEXT_LEFT}, patags, GS_DefaultTags},
	{MX_KIND,		 0,0,{0,0,0,0, NULL,          NULL,GID_ALIGNMENT, PLACETEXT_RIGHT}, alignmenttags, GS_DefaultTags},
	{CHECKBOX_KIND,	 0,0,{0,0,0,0, "_Bold",       NULL,GID_BOLD,PLACETEXT_RIGHT}, NULL, GS_DefaultTags},
	{CHECKBOX_KIND,	 0,0,{0,0,0,0, "_Italics",    NULL,GID_ITALICS,PLACETEXT_RIGHT}, NULL, GS_DefaultTags},
	{CHECKBOX_KIND,	 0,0,{0,0,0,0, "_3D",         NULL,GID_3D,PLACETEXT_RIGHT}, NULL, GS_DefaultTags},
	{MX_KIND,		 0,0,{0,0,0,0, NULL,          NULL,GID_LEADING, PLACETEXT_RIGHT}, leadingtags, GS_DefaultTags},
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
            GUIL_FrameHeadline, "Alignment",
            GUIL_GadgetSpecID, GID_ALIGNMENT,
        TAG_DONE,
        GUIL_VertGroup, 1,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,
            GUIL_FrameType, GUILFT_Ridge,
            GUIL_FrameHeadline, "Attributes",
            GUIL_GadgetSpecID, GID_BOLD,
            GUIL_GadgetSpecID, GID_ITALICS,
            GUIL_GadgetSpecID, GID_3D,
        TAG_DONE,
        GUIL_VertGroup, 1,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,
            GUIL_FrameType, GUILFT_Ridge,
            GUIL_FrameHeadline, "Leading",
            GUIL_GadgetSpecID, GID_LEADING,
        TAG_DONE,

    TAG_DONE,

    TAG_DONE,
};

/* Now, some globals used by Generic.o during the call to GF_CreateGUIA() */

int DEMO_InitialOrientation = GUIL_VertGroup;

STRPTR DEMO_WindowTitle = "Frame Preferences GUI";
STRPTR DEMO_AppID       = "FramePrefs";

STRPTR DEMO_Version     = "1.0",
       DEMO_LongDesc    = "Demo program - Frame Preferences",
       DEMO_Author      = "Michael Berg",
       DEMO_Date        = __AMIGADATE__;
