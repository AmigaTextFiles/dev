
/* PowerCache.c - The GUI of my 'PowerCache' program
 *
 * This is a GUIFront example GUI. To build an example, compile and link this
 * file with Generic.o (also supplied).
 * Everything prefixed with DEMO_ is exported to Generic.o.
 */

#include <libraries/guifront.h>

/* First, some Gadget ID's */

enum
{
    GID_CACHEABLE,
    GID_INSTALL,
    GID_RESCAN,
    GID_INFO,
    GID_CURRENTLYCACHED,
    GID_REMOVE,
    GID_PURGE,
    GID_EDIT,
    GID_STATS,
    GID_ACTIVE,
    GID_SHOW,
    GID_ENABLE,
    GID_DISABLE,
    GID_POPUP,
    GID_BEEP,
    GID_SAVE,
    GID_USE,
    GID_CANCEL,
};

/* Some data and tag items we'll be needing later */

extern struct MinList cacheablelabels;

static struct Node cacheablenodes[] =
{
    {&cacheablenodes[1], (struct Node *)&cacheablelabels.mlh_Head, 0, 0, "CD0: (icddisk.device, unit 3)"},
    {&cacheablenodes[2], &cacheablenodes[0], 0, 0, "DF0: (trackdisk.device, unit 0)"},
    {&cacheablenodes[3], &cacheablenodes[1], 0, 0, "DF2: (trackdisk.device, unit 2)"},
    {&cacheablenodes[4], &cacheablenodes[2], 0, 0, "DH0: (icddisk.device, unit 0)"},
    {&cacheablenodes[5], &cacheablenodes[3], 0, 0, "DH1: (icddisk.device, unit 0)"},
    {&cacheablenodes[6], &cacheablenodes[4], 0, 0, "DH2: (icddisk.device, unit 6)"},
    {&cacheablenodes[7], &cacheablenodes[5], 0, 0, "FF0: (devs:fmsdisk.device, unit 0)"},
    {(struct Node *)&cacheablelabels.mlh_Tail, &cacheablenodes[6], 0, 0, "FF1: (devs:fmsdisk.device, unit 1)"},
};

struct MinList cacheablelabels =
{
    (struct MinNode *)&cacheablenodes[0], NULL,(struct MinNode *)&cacheablenodes[7]
};

static const struct TagItem cacheabletags[] =
{
    {GTLV_ShowSelected, NULL},
    {GTLV_Labels, &cacheablelabels},
    {TAG_DONE},
};

extern struct MinList currentlycachedlabels;

static struct Node currentlycachednodes[] =
{
    {&currentlycachednodes[1], (struct Node *)&currentlycachedlabels.mlh_Head, 0, 0, "DH0: (10 x 64 x 4, R/W, MEM)"},
    {&currentlycachednodes[2], &currentlycachednodes[0], 0, 0, "DH1: (10 x 64 x 4, R/O, MEM)"},
    {(struct Node *)&currentlycachedlabels.mlh_Tail, &currentlycachednodes[1], 0, 0, "DF0: (5 x 32 x 4, R/O, MEM)"},
};

struct MinList currentlycachedlabels =
{
    (struct MinNode *)&currentlycachednodes[0], NULL,(struct MinNode *)&currentlycachednodes[2]
};

static const struct TagItem currentlycachedtags[] =
{
    {GTLV_ShowSelected, NULL},
    {GTLV_Labels, &currentlycachedlabels},
    {TAG_DONE},
};

/* Now, the GadgetSpec's we'll be needing for this GUI */

static GadgetSpec gadgetspecs[] =
{
    {LISTVIEW_KIND,25,7, {0,0,0,0,"Cac_heable Devices",NULL,GID_CACHEABLE,PLACETEXT_ABOVE | NG_HIGHLABEL},cacheabletags,GS_DefaultTags},
    {LISTVIEW_KIND,25,7, {0,0,0,0,"Currentl_y Cached",NULL,GID_CURRENTLYCACHED,PLACETEXT_ABOVE | NG_HIGHLABEL},currentlycachedtags,GS_DefaultTags},
    {BUTTON_KIND,   0,0, {0,0,0,0,"I_nstall...", NULL, GID_INSTALL, PLACETEXT_IN}, NULL, GS_DefaultTags},
    {BUTTON_KIND,   0,0, {0,0,0,0,"_Rescan", NULL, GID_RESCAN, PLACETEXT_IN}, NULL, GS_DefaultTags},
    {BUTTON_KIND,   0,0, {0,0,0,0,"_Info...", NULL, GID_INFO, PLACETEXT_IN}, NULL, GS_DefaultTags},
    {BUTTON_KIND,   0,0, {0,0,0,0,"Remove", NULL, GID_REMOVE, PLACETEXT_IN}, NULL, GS_DefaultTags},
    {BUTTON_KIND,   0,0, {0,0,0,0,"Purge", NULL, GID_PURGE, PLACETEXT_IN}, NULL, GS_DefaultTags},
    {BUTTON_KIND,   0,0, {0,0,0,0,"Edit...", NULL, GID_EDIT, PLACETEXT_IN}, NULL, GS_DefaultTags},
    {BUTTON_KIND,   0,0, {0,0,0,0,"Stats...", NULL, GID_STATS, PLACETEXT_IN}, NULL, GS_DefaultTags},
    {STRING_KIND,   0,0, {0,0,0,0,"Sh_ow Window",NULL,GID_SHOW,PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {STRING_KIND,   0,0, {0,0,0,0,"Enab_le Caches",NULL,GID_ENABLE,PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {STRING_KIND,   0,0, {0,0,0,0,"_Disable Caches",NULL,GID_DISABLE,PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {CHECKBOX_KIND, 0,0, {0,0,0,0,"Popup _Window",NULL,GID_POPUP,PLACETEXT_RIGHT},NULL,GS_DefaultTags},
    {CHECKBOX_KIND, 0,0, {0,0,0,0,"_Beep",NULL,GID_BEEP,PLACETEXT_RIGHT},NULL,GS_DefaultTags},
    {CHECKBOX_KIND, 0,0, {0,0,0,0,"Ac_tive",NULL,GID_ACTIVE,PLACETEXT_RIGHT},NULL,GS_DefaultTags},
    {BUTTON_KIND,   0,0, {0,0,0,0,"S_ave", NULL, GID_SAVE, PLACETEXT_IN}, NULL, GS_DefaultTags},
    {BUTTON_KIND,   0,0, {0,0,0,0,"_Use", NULL, GID_USE, PLACETEXT_IN}, NULL, GS_DefaultTags},
    {BUTTON_KIND,   0,0, {0,0,0,0,"_Cancel", NULL, GID_CANCEL, PLACETEXT_IN}, NULL, GS_DefaultTags},
};

/* Now, we group all of these GadgetSpecs into an array of pointers, so the
 * layout engine can locate gadgets merely by their Gadget IDs.
 */

GadgetSpec *DEMO_GadgetSpecList[] =
{
    &gadgetspecs[0], &gadgetspecs[1], &gadgetspecs[2], &gadgetspecs[2],
    &gadgetspecs[3], &gadgetspecs[4], &gadgetspecs[5], &gadgetspecs[6],
    &gadgetspecs[7], &gadgetspecs[8], &gadgetspecs[9], &gadgetspecs[10],
    &gadgetspecs[11], &gadgetspecs[12], &gadgetspecs[13], &gadgetspecs[14],
    &gadgetspecs[15], &gadgetspecs[16], &gadgetspecs[17], NULL
};

/* Finally, the layout tag list itself. This is where most of the work is
 * done. This list completely describes how the above gadgets are arranged
 * in groups in the GUI.
 */

ULONG DEMO_LayoutList[] =
{
    GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth,

    GUIL_HorizGroup, 1,
        GUIL_Flags, GUILF_PropShare,
        GUIL_FrameType, GUILFT_Recess,
        GUIL_VertGroup, 1,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth,

            GUIL_GadgetSpecID, GID_CACHEABLE,

            GUIL_HorizGroup,0,
                GUIL_Flags, GUILF_EqualShare | GUILF_EqualHeight,
                GUIL_GadgetSpecID, GID_INSTALL,
                GUIL_GadgetSpecID, GID_RESCAN,
                GUIL_GadgetSpecID, GID_INFO,
            TAG_DONE,

            GUIL_VertGroup, 1,
                GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth | GUILF_LabelAlign,
                GUIL_GadgetSpecID, GID_SHOW,
                GUIL_GadgetSpecID, GID_ENABLE,
                GUIL_GadgetSpecID, GID_DISABLE,
            TAG_DONE,
        TAG_DONE,

        GUIL_VertGroup, 1,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth,

            GUIL_GadgetSpecID, GID_CURRENTLYCACHED,

            GUIL_HorizGroup,0,
                GUIL_Flags, GUILF_EqualSize | GUILF_EqualHeight,
                GUIL_GadgetSpecID, GID_REMOVE,
                GUIL_GadgetSpecID, GID_ACTIVE,
            TAG_DONE,

            GUIL_HorizGroup,0,
                GUIL_Flags, GUILF_EqualShare | GUILF_EqualHeight,
                GUIL_GadgetSpecID, GID_PURGE,
                GUIL_GadgetSpecID, GID_EDIT,
                GUIL_GadgetSpecID, GID_STATS,
            TAG_DONE,

            GUIL_VertGroup,1,
                GUIL_Flags, GUILF_EqualShare | GUILF_EqualWidth,
                GUIL_GadgetSpecID, GID_POPUP,
                GUIL_GadgetSpecID, GID_BEEP,
            TAG_DONE,
        TAG_DONE,
    TAG_DONE,

    GUIL_HorizGroup,1,
        GUIL_Flags, GUILF_EqualSize | GUILF_EqualHeight,
        GUIL_GadgetSpecID, GID_SAVE,
        GUIL_GadgetSpecID, GID_USE,
        GUIL_GadgetSpecID, GID_CANCEL,
    TAG_DONE,

    TAG_DONE,
};

/* Now, some globals used by Generic.o during the call to GF_CreateGUIA() */

int DEMO_InitialOrientation = GUIL_VertGroup;

STRPTR DEMO_WindowTitle = "PowerCache GUI";
STRPTR DEMO_AppID       = "PowerCache";

STRPTR DEMO_Version     = "1.0",
       DEMO_LongDesc    = "Demo program - The GUI from PowerCache",
       DEMO_Author      = "Michael Berg",
       DEMO_Date        = __AMIGADATE__;

BOOL   DEMO_Backfill    = TRUE;
