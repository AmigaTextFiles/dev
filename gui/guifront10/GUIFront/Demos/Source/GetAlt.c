
/* getalt.c - Show off GetAlt kind and automatic ASL requester feature
 *
 * This is a GUIFront example GUI. To build an example, compile and link this
 * file with Generic.o (also supplied).
 * Everything prefixed with DEMO_ is exported to Generic.o.
 */

#include <libraries/guifront.h>

/* First, some Gadget ID's */

enum
{
    GID_FONT,
    GID_GETFONT,
    GID_FILE,
    GID_GETFILE,
    GID_DIR,
    GID_GETDIR,
    GID_OTHER,
    GID_GETOTHER,
    GID_OK,
};

/* Some data and tag items we'll be needing later */

static const struct TagItem txtags[] =
{
	{GTTX_Border, TRUE},
	{TAG_DONE},
};

static const struct TagItem getfonttags[] =
{
	{ALT_Image, ALTI_GetFont},
	{ALT_AslRequester, TRUE},
	{TAG_DONE},
};

static const struct TagItem getfiletags[] =
{
	{ALT_Image, ALTI_GetFile},
	{ALT_AslRequester, TRUE},
	{TAG_DONE},
};

static const struct TagItem getdirtags[] =
{
	{ALT_Image, ALTI_GetDir},
	{ALT_AslRequester, TRUE},
	{TAG_DONE},
};

static const struct TagItem getothertags[] =
{
	{ALT_Image, ALTI_GetMisc},
	{ALT_AslRequester, TRUE},
	{TAG_DONE},
};

/* Now, the GadgetSpec's we'll be needing for this GUI */

static GadgetSpec gadgetspecs[] =
{
    {TEXT_KIND,      25,0,{0,0,0,0, "File:", NULL, GID_FILE, PLACETEXT_LEFT}, txtags, GS_DefaultTags},
    {GETALT_KIND,    0,0,{0,0,0,0, NULL,    NULL, GID_GETFILE, PLACETEXT_IN}, getfiletags, GS_DefaultTags},
    {TEXT_KIND,      25,0,{0,0,0,0, "Font:", NULL, GID_FONT, PLACETEXT_LEFT}, txtags, GS_DefaultTags},
    {GETALT_KIND,    0,0,{0,0,0,0, NULL,    NULL, GID_GETFONT, PLACETEXT_IN}, getfonttags, GS_DefaultTags},
    {TEXT_KIND,      25,0,{0,0,0,0, "Dir:", NULL, GID_DIR, PLACETEXT_LEFT}, txtags, GS_DefaultTags},
    {GETALT_KIND,    0,0,{0,0,0,0, NULL,    NULL, GID_GETDIR, PLACETEXT_IN}, getdirtags, GS_DefaultTags},
    {TEXT_KIND,      25,0,{0,0,0,0, "Other:", NULL, GID_OTHER, PLACETEXT_LEFT}, txtags, GS_DefaultTags},
    {GETALT_KIND,    0,0,{0,0,0,0, NULL,    NULL, GID_GETOTHER, PLACETEXT_IN}, getothertags, GS_DefaultTags},
    {BUTTON_KIND,    0,0,{0,0,0,0, " Ok ",  NULL, GID_OK, PLACETEXT_IN}, NULL, GS_DefaultTags | GS_BoldLabel},
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

        GUIL_FrameType, GUILFT_Recess,

        GUIL_HorizGroup, 0,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,
            GUIL_GadgetSpecID, GID_FILE,
            GUIL_GadgetSpecID, GID_GETFILE,
        TAG_DONE,

        GUIL_HorizGroup, 0,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,
            GUIL_GadgetSpecID, GID_DIR,
            GUIL_GadgetSpecID, GID_GETDIR,
        TAG_DONE,

        GUIL_HorizGroup, 0,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,
            GUIL_GadgetSpecID, GID_FONT,
            GUIL_GadgetSpecID, GID_GETFONT,
        TAG_DONE,

        GUIL_HorizGroup, 0,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,
            GUIL_GadgetSpecID, GID_OTHER,
            GUIL_GadgetSpecID, GID_GETOTHER,
        TAG_DONE,
    TAG_DONE,

    GUIL_HorizGroup, 1,
        GUIL_Flags, GUILF_EqualSize,
        GUIL_GadgetSpecID, GID_OK,
    TAG_DONE,

    TAG_DONE,
};

/* Now, some globals used by Generic.o during the call to GF_CreateGUIA() */

int DEMO_InitialOrientation = GUIL_VertGroup;

STRPTR DEMO_WindowTitle = "GetAlt Demo GUI";
STRPTR DEMO_AppID       = "GetAltDemo";

STRPTR DEMO_Version     = "1.0",
       DEMO_LongDesc    = "Demo program - GetAlt and Automatic ASL Requesters",
       DEMO_Author      = "Michael Berg",
       DEMO_Date        = __AMIGADATE__;

BOOL   DEMO_Backfill    = TRUE;
