
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
    GID_OBJTYPE,
    GID_OBJLIST,
    GID_TOP,
    GID_UP,
    GID_DOWN,
    GID_BOTTOM,
    GID_SORT,
    GID_NEW,
    GID_EDIT,
    GID_COPY,
    GID_REMOVE,
    GID_SAVE,
    GID_USE,
    GID_TEST,
    GID_CANCEL,
};

/* Some data and tag items we'll be needing later */

static const STRPTR objtypelabels[] =
{
    "Exec",
    "Image",
    "Sound",
    "Menu",
    "Icon",
    "Dock",
    "Access",
    NULL,
};

static const struct TagItem objtypetags[] =
{
    {GTCY_Labels, objtypelabels},
    {TAG_DONE},
};

extern struct MinList objlistlabels;

static struct Node objlistnodes[] =
{
    {&objlistnodes[1], (struct Node *)&objlistlabels.mlh_Head, 0, 0, "Shell"},
    {&objlistnodes[2], &objlistnodes[0], 0, 0, "FlushMem"},
    {&objlistnodes[3], &objlistnodes[1], 0, 0, "FileReader"},
    {&objlistnodes[4], &objlistnodes[2], 0, 0, "ToolManager"},
    {&objlistnodes[5], &objlistnodes[3], 0, 0, "OpenPubScreen"},
    {&objlistnodes[6], &objlistnodes[4], 0, 0, "ClosePubScreen"},
    {&objlistnodes[7], &objlistnodes[5], 0, 0, "LockDH0"},
    {&objlistnodes[8], &objlistnodes[6], 0, 0, "LockDH1"},
    {&objlistnodes[9], &objlistnodes[7], 0, 0, "UnlockDH1"},
    {&objlistnodes[10], &objlistnodes[8], 0, 0, "UnlockDH0"},
    {(struct Node *)&objlistlabels.mlh_Tail, &objlistnodes[9], 0, 0, "EditFile"},
};

struct MinList objlistlabels =
{
    (struct MinNode *)&objlistnodes[0], NULL,(struct MinNode *)&objlistnodes[10]
};

static const struct TagItem objlisttags[] =
{
    {GTLV_ShowSelected, NULL},
    {GTLV_Labels, &objlistlabels},
    {TAG_DONE},
};

/* Now, the GadgetSpec's we'll be needing for this GUI */

static GadgetSpec gadgetspecs[] =
{
    {CYCLE_KIND,    0, 0, {0,0,0,0,"_Object Type:",NULL,GID_OBJTYPE,PLACETEXT_LEFT},objtypetags,GS_DefaultTags},
    {LISTVIEW_KIND, 30,8, {0,0,0,0,NULL,NULL,GID_OBJLIST,PLACETEXT_ABOVE},objlisttags,GS_DefaultTags},
    {BUTTON_KIND,   0, 0, {0,0,0,0,"Top", NULL, GID_TOP, PLACETEXT_IN},NULL,GS_DefaultTags},
    {BUTTON_KIND,   0, 0, {0,0,0,0,"Up", NULL, GID_UP, PLACETEXT_IN},NULL,GS_DefaultTags},
    {BUTTON_KIND,   0, 0, {0,0,0,0,"Down", NULL, GID_DOWN, PLACETEXT_IN},NULL,GS_DefaultTags},
    {BUTTON_KIND,   0, 0, {0,0,0,0,"Bottom", NULL, GID_BOTTOM, PLACETEXT_IN},NULL,GS_DefaultTags},
    {BUTTON_KIND,   0, 0, {0,0,0,0,"So_rt", NULL, GID_SORT, PLACETEXT_IN},NULL,GS_DefaultTags},
    {BUTTON_KIND,   0, 0, {0,0,0,0,"_New...", NULL, GID_NEW, PLACETEXT_IN},NULL,GS_DefaultTags},
    {BUTTON_KIND,   0, 0, {0,0,0,0,"_Edit...", NULL, GID_EDIT, PLACETEXT_IN},NULL,GS_DefaultTags},
    {BUTTON_KIND,   0, 0, {0,0,0,0,"Co_py", NULL, GID_COPY, PLACETEXT_IN},NULL,GS_DefaultTags},
    {BUTTON_KIND,   0, 0, {0,0,0,0,"Remove", NULL, GID_REMOVE, PLACETEXT_IN},NULL,GS_DefaultTags},
    {BUTTON_KIND,   0, 0, {0,0,0,0,"_Save", NULL, GID_SAVE, PLACETEXT_IN},NULL,GS_DefaultTags},
    {BUTTON_KIND,   0, 0, {0,0,0,0,"_Use", NULL, GID_USE, PLACETEXT_IN},NULL,GS_DefaultTags},
    {BUTTON_KIND,   0, 0, {0,0,0,0,"_Test", NULL, GID_TEST, PLACETEXT_IN},NULL,GS_DefaultTags},
    {BUTTON_KIND,   0, 0, {0,0,0,0,"_Cancel", NULL, GID_CANCEL, PLACETEXT_IN},NULL,GS_DefaultTags},
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
    NULL,
};

/* Finally, the layout tag list itself. This is where most of the work is
 * done. This list completely describes how the above gadgets are arranged
 * in groups in the GUI.
 */

ULONG DEMO_LayoutList[] =
{
    GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth,

    GUIL_GadgetSpecID, GID_OBJTYPE,

    GUIL_HorizGroup, 1,
        GUIL_Flags, GUILF_PropShare,
        GUIL_FrameType, GUILFT_Ridge,
        GUIL_FrameHeadline, "Object List",
        GUIL_GadgetSpecID, GID_OBJLIST,
        GUIL_VertGroup, 1,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth,
            GUIL_GadgetSpecID, GID_TOP,
            GUIL_GadgetSpecID, GID_UP,
            GUIL_GadgetSpecID, GID_DOWN,
            GUIL_GadgetSpecID, GID_BOTTOM,
            GUIL_GadgetSpecID, GID_SORT,
        TAG_DONE,
    TAG_DONE,

    GUIL_HorizGroup, 1,
        GUIL_Flags, GUILF_EqualShare | GUILF_EqualHeight,

        GUIL_GadgetSpecID, GID_NEW,
        GUIL_GadgetSpecID, GID_EDIT,
        GUIL_GadgetSpecID, GID_COPY,
        GUIL_GadgetSpecID, GID_REMOVE,
    TAG_DONE,

    GUIL_HorizGroup, 1,
        GUIL_Flags, GUILF_EqualShare | GUILF_EqualHeight,
        GUIL_GadgetSpecID, GID_SAVE,
        GUIL_GadgetSpecID, GID_USE,
        GUIL_GadgetSpecID, GID_TEST,
        GUIL_GadgetSpecID, GID_CANCEL,
    TAG_DONE,

    TAG_DONE,
};

/* Now, some globals used by Generic.o during the call to GF_CreateGUIA() */

int DEMO_InitialOrientation = GUIL_VertGroup;

STRPTR DEMO_WindowTitle = "ToolManager GUI";
STRPTR DEMO_AppID       = "ToolManager";

STRPTR DEMO_Version     = "1.0",
       DEMO_LongDesc    = "Demo program - Toolmanager prefs editor",
       DEMO_Author      = "Michael Berg",
       DEMO_Date        = __AMIGADATE__;
