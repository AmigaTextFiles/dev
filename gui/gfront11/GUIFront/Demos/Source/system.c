
/* System.c - The GUI of the 'System' window of Spot
 *
 * This is a GUIFront example GUI. To build an example, compile and link this
 * file with Generic.o (also supplied).
 * Everything prefixed with DEMO_ is exported to Generic.o.
 */

#include <libraries/guifront.h>

/* First, some Gadget ID's */

enum
{
    GID_NAME,
    GID_ADDRESS,
    GID_ADD,
    GID_DELETE,
    GID_FAKENET,
    GID_DOMAIN,
    GID_DOMAININMSGID,
    GID_DOMAININORIGIN,
    GID_BBSNAME,
    GID_PACKER,
    GID_UNPACKER,
    GID_PACKNETMAIL,
    GID_POLL,
    GID_ASYNC,
    GID_PASSWORD,
    GID_EXPORTTO,
    GID_FORCEINTL,
};

/* Some data and tag items we'll be needing later */

extern struct MinList addrlistlabels;

static struct Node addrlistnodes[] =
{
    {&addrlistnodes[1], (struct Node *)&addrlistlabels.mlh_Head, 0, 0, "1:111/111.1"},
    {&addrlistnodes[2], &addrlistnodes[0], 0, 0, "2:222/222.2"},
    {&addrlistnodes[3], &addrlistnodes[1], 0, 0, "3:333/333.3"},
    {&addrlistnodes[4], &addrlistnodes[2], 0, 0, "4:444/444.4"},
    {&addrlistnodes[5], &addrlistnodes[3], 0, 0, "5:555/555.5"},
    {(struct Node *)&addrlistlabels.mlh_Tail, &addrlistnodes[4], 0, 0, "6:666/666.7"},
};

struct MinList addrlistlabels =
{
    (struct MinNode *)&addrlistnodes[0], NULL,(struct MinNode *)&addrlistnodes[5]
};

static const struct TagItem addrlisttags[] =
{
    {GTLV_ShowSelected, NULL},
    {GTLV_Labels, &addrlistlabels},
    {TAG_DONE},
};

/* Now, the GadgetSpec's we'll be needing for this GUI */

static GadgetSpec gadgetspecs[] =
{
    {STRING_KIND,  20,0, {0,0,0,0,"_Name",NULL,GID_NAME,PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {LISTVIEW_KIND,20,4, {0,0,0,0,"Address", NULL, GID_ADDRESS, PLACETEXT_LEFT}, addrlisttags, GS_DefaultTags},
    {BUTTON_KIND,   0,0, {0,0,0,0,"_Add...", NULL, GID_ADD, PLACETEXT_IN}, NULL, GS_DefaultTags},
    {BUTTON_KIND,   0,0, {0,0,0,0,"_Delete...", NULL, GID_DELETE, PLACETEXT_IN}, NULL, GS_DefaultTags},
    {STRING_KIND,   0,0, {0,0,0,0,"_Fakenet",NULL,GID_FAKENET,PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {STRING_KIND,   0,0, {0,0,0,0,"Doma_in",NULL,GID_DOMAIN,PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {CHECKBOX_KIND, 0,0, {0,0,0,0,"Domain in _MSGID",NULL,GID_DOMAININMSGID,PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {CHECKBOX_KIND, 0,0, {0,0,0,0,"Domain in _origin",NULL,GID_DOMAININORIGIN,PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {STRING_KIND,  20,0, {0,0,0,0,"_BBS Name",NULL,GID_BBSNAME,PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {STRING_KIND,   0,0, {0,0,0,0,"Pa_cker",NULL,GID_PACKER,PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {STRING_KIND,   0,0, {0,0,0,0,"_Unpacker",NULL,GID_UNPACKER,PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {CHECKBOX_KIND, 0,0, {0,0,0,0,"Pac_k netmail",NULL,GID_PACKNETMAIL,PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {STRING_KIND,   0,0, {0,0,0,0,"_Poll",NULL,GID_POLL,PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {CHECKBOX_KIND, 0,0, {0,0,0,0,"A_synchronous",NULL,GID_ASYNC,PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {STRING_KIND,   0,0, {0,0,0,0,"Pass_word",NULL,GID_PASSWORD,PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {STRING_KIND,   0,0, {0,0,0,0,"E_xport to",NULL,GID_EXPORTTO,PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {CHECKBOX_KIND, 0,0, {0,0,0,0,"Fo_rce INTL",NULL,GID_FORCEINTL,PLACETEXT_LEFT},NULL,GS_DefaultTags},
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
    &gadgetspecs[15], &gadgetspecs[16], NULL,
};

/* Finally, the layout tag list itself. This is where most of the work is
 * done. This list completely describes how the above gadgets are arranged
 * in groups in the GUI.
 */

ULONG DEMO_LayoutList[] =
{
    GUIL_Flags, GUILF_PropShare,

    GUIL_VertGroup, 1,
        GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth | GUILF_LabelAlign,

        GUIL_GadgetSpecID, GID_NAME,

        GUIL_GadgetSpecID, GID_ADDRESS,

        GUIL_HorizGroup, 0,
            GUIL_Flags, GUILF_EqualShare | GUILF_EqualHeight,
            GUIL_GadgetSpecID, GID_ADD,
            GUIL_GadgetSpecID, GID_DELETE,
        TAG_DONE,

        GUIL_GadgetSpecID, GID_FAKENET,
        GUIL_GadgetSpecID, GID_DOMAIN,

        GUIL_GadgetSpecID, GID_DOMAININMSGID,
        GUIL_GadgetSpecID, GID_DOMAININORIGIN,
    TAG_DONE,

    GUIL_VertGroup, 1,
        GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth | GUILF_LabelAlign,

        GUIL_GadgetSpecID, GID_BBSNAME,
        GUIL_GadgetSpecID, GID_PACKER,
        GUIL_GadgetSpecID, GID_UNPACKER,
        GUIL_GadgetSpecID, GID_PACKNETMAIL,
        GUIL_GadgetSpecID, GID_POLL,
        GUIL_GadgetSpecID, GID_ASYNC,
        GUIL_GadgetSpecID, GID_PASSWORD,
        GUIL_GadgetSpecID, GID_EXPORTTO,
        GUIL_GadgetSpecID, GID_FORCEINTL,
    TAG_DONE,

    TAG_DONE,
};

/* Obligatory version tag */

static const char ver[] = "$VER: System 1.0 " __AMIGADATE__;

/* Now, some globals used by Generic.o during the call to GF_CreateGUIA() */

int DEMO_InitialOrientation = GUIL_HorizGroup;

STRPTR DEMO_WindowTitle = "Spot/System GUI";
STRPTR DEMO_AppID       = "Spot.System";

STRPTR DEMO_Version     = "1.0",
       DEMO_LongDesc    = "Demo program - The 'System' GUI of Spot",
       DEMO_Author      = "Michael Berg",
       DEMO_Date        = __AMIGADATE__;

BOOL   DEMO_Backfill    = FALSE;
