
/* Exchange2.c - The GUI of the 'Exchange' utility
 *
 * This is a GUIFront example GUI. To build an example, compile and link this
 * file with Generic.o (also supplied).
 * Everything prefixed with DEMO_ is exported to Generic.o.
 */

#include <libraries/guifront.h>

/* This GUI is the same as the 'Exchange.c' example, only we've added some
 * frames to make it look better
 */

/* First, some Gadget ID's */

enum
{
    GID_CXLIST,
    GID_INFO,
    GID_SHOW,
    GID_HIDE,
    GID_ACTIVATE,
    GID_REMOVE,
};

/* Some data and tag items we'll be needing later */

static const STRPTR activatelabels[] =
{
    "Active",
    "Inactive",
    NULL,
};

static const struct TagItem activatetags[] =
{
    {GTCY_Labels, activatelabels},
    {TAG_DONE},
};

extern struct MinList cxlistlabels;

static struct Node cxlistnodes[] =
{
    {&cxlistnodes[1], (struct Node *)&cxlistlabels.mlh_Head, 0, 0, "AlertPatch"},
    {&cxlistnodes[2], &cxlistnodes[0], 0, 0, "CScreen"},
    {&cxlistnodes[3], &cxlistnodes[1], 0, 0, "CxAltNum"},
    {&cxlistnodes[4], &cxlistnodes[2], 0, 0, "CxKeyClose"},
    {&cxlistnodes[5], &cxlistnodes[3], 0, 0, "CycleToMenu"},
    {&cxlistnodes[6], &cxlistnodes[4], 0, 0, "Exchange"},
    {&cxlistnodes[7], &cxlistnodes[5], 0, 0, "PowerCache"},
    {&cxlistnodes[8], &cxlistnodes[6], 0, 0, "RetinaComm"},
    {&cxlistnodes[9], &cxlistnodes[7], 0, 0, "RetinaEMU"},
    {&cxlistnodes[10], &cxlistnodes[8], 0, 0, "ToolManager"},
    {(struct Node *)&cxlistlabels.mlh_Tail, &cxlistnodes[9], 0, 0, "WindX"},
};

struct MinList cxlistlabels =
{
    (struct MinNode *)&cxlistnodes[0], NULL,(struct MinNode *)&cxlistnodes[10]
};

static const struct TagItem cxlisttags[] =
{
    {GTLV_ShowSelected, NULL},
    {GTLV_Labels, &cxlistlabels},
    {TAG_DONE},
};

static const struct TagItem infotags[] =
{
    {GTTX_Border, TRUE},
    {TAG_DONE},
};

/* Now, the GadgetSpec's we'll be needing for this GUI */

static GadgetSpec gadgetspecs[] =
{
    {LISTVIEW_KIND,30,6, {0,0,0,0,NULL, NULL, GID_CXLIST, PLACETEXT_ABOVE}, cxlisttags, GS_DefaultTags},
    {TEXT_KIND,     0,2, {0,0,0,0,NULL, NULL, GID_INFO, PLACETEXT_ABOVE}, infotags, GS_DefaultTags},
    {BUTTON_KIND,   0,0, {0,0,0,0,"_Show Interface", NULL, GID_SHOW, PLACETEXT_IN}, NULL, GS_DefaultTags},
    {BUTTON_KIND,   0,0, {0,0,0,0,"_Hide Interface", NULL, GID_HIDE, PLACETEXT_IN}, NULL, GS_DefaultTags},
    {CYCLE_KIND,    0,0, {0,0,0,0,NULL,NULL,GID_ACTIVATE,PLACETEXT_LEFT},activatetags,GS_DefaultTags},
    {BUTTON_KIND,   0,0, {0,0,0,0,"_Remove", NULL, GID_REMOVE, PLACETEXT_IN}, NULL, GS_DefaultTags},
};

/* Now, we group all of these GadgetSpecs into an array of pointers, so the
 * layout engine can locate gadgets merely by their Gadget IDs.
 */

GadgetSpec *DEMO_GadgetSpecList[] =
{
    &gadgetspecs[0], &gadgetspecs[1], &gadgetspecs[2], &gadgetspecs[2],
    &gadgetspecs[3], &gadgetspecs[4], &gadgetspecs[5], NULL,
};

/* Finally, the layout tag list itself. This is where most of the work is
 * done. This list completely describes how the above gadgets are arranged
 * in groups in the GUI.
 */

ULONG DEMO_LayoutList[] =
{
    GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,

    GUIL_VertGroup, 1,
        GUIL_Flags, GUILF_PropShare,
        GUIL_FrameType, GUILFT_Ridge,
        GUIL_FrameHeadline, "Available Commodities",
        GUIL_GadgetSpecID, GID_CXLIST,
    TAG_DONE,

    GUIL_VertGroup, 1,
        GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth,

        GUIL_FrameType, GUILFT_Ridge,
        GUIL_FrameHeadline, "Information",

        GUIL_GadgetSpecID, GID_INFO,

        GUIL_HorizGroup, 1,
            GUIL_Flags, GUILF_EqualShare | GUILF_EqualHeight,
            GUIL_GadgetSpecID, GID_SHOW,
            GUIL_GadgetSpecID, GID_HIDE,
        TAG_DONE,

        GUIL_HorizGroup, 1,
            GUIL_Flags, GUILF_EqualShare,
            GUIL_GadgetSpecID, GID_ACTIVATE,
            GUIL_GadgetSpecID, GID_REMOVE,
        TAG_DONE,
    TAG_DONE,

    TAG_DONE,
};

/* Obligatory version tag */

static const char ver[] = "$VER: Exchange2 1.0 " __AMIGADATE__;

/* Now, some globals used by Generic.o during the call to GF_CreateGUIA() */

int DEMO_InitialOrientation = GUIL_HorizGroup;

STRPTR DEMO_WindowTitle = "Exchange GUI (2)";
STRPTR DEMO_AppID       = "Exchange2";

STRPTR DEMO_Version     = "1.0",
       DEMO_LongDesc    = "Demo program - Exchange with frames",
       DEMO_Author      = "Michael Berg",
       DEMO_Date        = __AMIGADATE__;

BOOL   DEMO_Backfill    = FALSE;
