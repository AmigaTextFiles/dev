
/* Areas2.c - The GUI of the 'Areas' window of Spot - with some frames
 *
 * This is a GUIFront example GUI. To build an example, compile and link this
 * file with Generic.o (also supplied).
 * Everything prefixed with DEMO_ is exported to Generic.o.
 */

#include <libraries/guifront.h>

/* First, some Gadget ID's */

enum
{
    GID_AREAS,
    GID_ADD,
    GID_DELETE,
    GID_UP,
    GID_DOWN,
    GID_SORT,
    GID_ADDRESS,
    GID_EXPORTTO,
    GID_KEEP,
    GID_KEEPNUM,
    GID_READONLY,
    GID_KEEPTOYOU,
    GID_ALIAS,
    GID_CHARSET,
    GID_WRITE,
    GID_ORIGIN,
    GID_GETORIGIN,
    GID_REPLY,
    GID_GETREPLY,
    GID_SIGNATURE,
    GID_GETSIGNATURE,
    GID_TAGLINES,
};

/* Some data and tag items we'll be needing later */

extern struct MinList areaslabels;

static struct Node areasnodes[] =
{
    {&areasnodes[1], (struct Node *)&areaslabels.mlh_Head, 0, 0, "-!=Spot Beta----------"},
    {&areasnodes[2], &areasnodes[0], 0, 0, "Spot Beta"},
    {&areasnodes[3], &areasnodes[1], 0, 0, "ANet Announce"},
    {&areasnodes[4], &areasnodes[2], 0, 0, "-!=Internet-------------"},
    {&areasnodes[5], &areasnodes[3], 0, 0, "C.S.AMIGA.GRAPHICS"},
    {&areasnodes[6], &areasnodes[4], 0, 0, "C.S.AMIGA.PROGRAMMER"},
    {&areasnodes[7], &areasnodes[5], 0, 0, "C.S.AMIGA.MISC"},
    {&areasnodes[8], &areasnodes[6], 0, 0, "C.S.AMIGA.HARDWARE"},
    {&areasnodes[9], &areasnodes[7], 0, 0, "C.S.AMIGA.ANNOUNCE"},
    {(struct Node *)&areaslabels.mlh_Tail, &areasnodes[8], 0, 0, "C.S.AMIGA.REVIEWS"},
};

struct MinList areaslabels =
{
    (struct MinNode *)&areasnodes[0], NULL,(struct MinNode *)&areasnodes[9]
};

static GadgetSpec showsel_str =
{
    STRING_KIND, 0,0, {0,0,0,0,NULL,NULL,0,0},NULL,0
};

static const struct TagItem areastags[] =
{
    {GTLV_ShowSelected, &showsel_str},
    {GTLV_Labels, &areaslabels},
    {TAG_DONE},
};

static const STRPTR addresslabels[] =
{
    "1:111/111.1",
    "2:222/222.2",
    "3:222/222.3",
    "4:444/444.4",
    NULL,
};

static const struct TagItem addresstags[] =
{
    {GTCY_Labels, addresslabels},
    {TAG_DONE},
};

static const STRPTR keeplabels[] =
{
    "All",
    "Number of days",
    "Number of messages",
    NULL,
};

static const struct TagItem keeptags[] =
{
    {GTCY_Labels, keeplabels},
    {TAG_DONE},
};

static const STRPTR charsetlabels[] =
{
    "LATIN-1",
    "IBMPC",
    "SWEDISH",
    "ASCII",
    "DEFAULT",
    NULL,
};

static const struct TagItem charsettags[] =
{
    {GTCY_Labels, charsetlabels},
    {TAG_DONE},
};

static const STRPTR writelabels[] =
{
    "LATIN-1",
    "IBMPC",
    "SWEDISH",
    "ASCII",
    NULL,
};

static const struct TagItem writetags[] =
{
    {GTCY_Labels, writelabels},
    {TAG_DONE},
};

static const STRPTR taglineslabels[] =
{
    "Off",
    "All",
    "International",
    NULL,
};

static const struct TagItem taglinestags[] =
{
    {GTCY_Labels, taglineslabels},
    {TAG_DONE},
};

static const struct TagItem getorigintags[] =
{
	{ALT_Image, ALTI_GetMisc},
	{TAG_DONE},
};

static const struct TagItem getreplytags[] =
{
	{ALT_Image, ALTI_GetMisc},
	{TAG_DONE},
};

static const struct TagItem getsignaturetags[] =
{
	{ALT_Image, ALTI_GetMisc},
	{TAG_DONE},
};

static const struct TagItem txtags[] =
{
    {GTTX_Border, TRUE},
    {TAG_DONE},
};

/* Now, the GadgetSpec's we'll be needing for this GUI */

static GadgetSpec gadgetspecs[] =
{
    {LISTVIEW_KIND,24,7, {0,0,0,0,NULL,NULL,GID_AREAS,PLACETEXT_LEFT},areastags,GS_DefaultTags},
    {BUTTON_KIND,   0,0, {0,0,0,0,"_Add...", NULL, GID_ADD, PLACETEXT_IN}, NULL, GS_DefaultTags},
    {BUTTON_KIND,   0,0, {0,0,0,0,"D_elete...", NULL, GID_DELETE, PLACETEXT_IN}, NULL, GS_DefaultTags},
    {BUTTON_KIND,   0,0, {0,0,0,0,"_Up", NULL, GID_UP, PLACETEXT_IN}, NULL, GS_DefaultTags},
    {BUTTON_KIND,   0,0, {0,0,0,0,"_Down", NULL, GID_DOWN, PLACETEXT_IN}, NULL, GS_DefaultTags},
    {BUTTON_KIND,   0,0, {0,0,0,0,"_Sort by name", NULL, GID_SORT, PLACETEXT_IN}, NULL, GS_DefaultTags},
    {CYCLE_KIND,    0,0, {0,0,0,0,"Add_ress",NULL,GID_ADDRESS,PLACETEXT_LEFT},addresstags, GS_DefaultTags},
    {STRING_KIND,   0,0, {0,0,0,0,"E_xport to",NULL,GID_EXPORTTO,PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {CYCLE_KIND,    0,0, {0,0,0,0,"_Keep",NULL,GID_KEEP,PLACETEXT_LEFT},keeptags,GS_DefaultTags},
    {INTEGER_KIND,  4,0, {0,0,0,0,NULL,   NULL,GID_KEEPNUM,PLACETEXT_IN},NULL,GS_DefaultTags | GS_NoWidthExtend},
    {CHECKBOX_KIND, 0,0, {0,0,0,0,"Read _only",NULL,GID_READONLY,PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {CHECKBOX_KIND, 0,0, {0,0,0,0,"Kee_p to you",NULL,GID_KEEPTOYOU,PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {STRING_KIND,   0,0, {0,0,0,0,"Al_ias",NULL,GID_ALIAS,PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {CYCLE_KIND,    0,0, {0,0,0,0,"_Charset",NULL,GID_CHARSET,PLACETEXT_LEFT},charsettags,GS_DefaultTags | GS_NoWidthExtend},
    {CYCLE_KIND,    0,0, {0,0,0,0,"_Write",NULL,GID_WRITE,PLACETEXT_LEFT},writetags,GS_DefaultTags | GS_NoWidthExtend},
    {TEXT_KIND,    20,0, {0,0,0,0,"Origi_n",NULL,GID_ORIGIN,PLACETEXT_LEFT},txtags,GS_DefaultTags},
    {GETALT_KIND,   0,0, {0,0,0,0,NULL,NULL,GID_GETORIGIN,PLACETEXT_IN},getorigintags,GS_DefaultTags},
    {TEXT_KIND,     0,0, {0,0,0,0,"Repl_y",NULL,GID_REPLY,PLACETEXT_LEFT},txtags,GS_DefaultTags},
    {GETALT_KIND,   0,0, {0,0,0,0,NULL,NULL,GID_GETREPLY,PLACETEXT_IN},getreplytags,GS_DefaultTags},
    {TEXT_KIND,     0,0, {0,0,0,0,"Signa_ture",NULL,GID_SIGNATURE,PLACETEXT_LEFT},txtags,GS_DefaultTags},
    {GETALT_KIND,   0,0, {0,0,0,0,NULL,NULL,GID_GETSIGNATURE,PLACETEXT_IN},getsignaturetags,GS_DefaultTags},
    {CYCLE_KIND,    0,0, {0,0,0,0,"Tag _Lines",NULL,GID_TAGLINES,PLACETEXT_LEFT},taglinestags,GS_DefaultTags},
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
    &gadgetspecs[15], &gadgetspecs[16], &gadgetspecs[17], &gadgetspecs[18], 
    &gadgetspecs[19], &gadgetspecs[20], &gadgetspecs[21], NULL
};

/* Finally, the layout tag list itself. This is where most of the work is
 * done. This list completely describes how the above gadgets are arranged
 * in groups in the GUI.
 */

ULONG DEMO_LayoutList[] =
{
    GUIL_Flags, GUILF_PropShare,

    GUIL_VertGroup, 1,
        GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth,

        GUIL_VertGroup,0,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth,

            GUIL_FrameType, GUILFT_Ridge,
            GUIL_FrameHeadline, "Areas",

            GUIL_GadgetSpecID, GID_AREAS,
            GUIL_HorizGroup,0,
                GUIL_Flags, GUILF_EqualShare | GUILF_EqualHeight,
                GUIL_GadgetSpecID, GID_ADD,
                GUIL_GadgetSpecID, GID_DELETE,
            TAG_DONE,

            GUIL_HorizGroup,0,
                GUIL_Flags, GUILF_EqualShare | GUILF_EqualHeight,
                GUIL_GadgetSpecID, GID_UP,
                GUIL_GadgetSpecID, GID_DOWN,
            TAG_DONE,
            GUIL_GadgetSpecID, GID_SORT,
        TAG_DONE,

        GUIL_VertGroup,1,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth | GUILF_LabelAlign,
            GUIL_FrameType, GUILFT_Ridge,
            GUIL_GadgetSpecID, GID_ADDRESS,
            GUIL_GadgetSpecID, GID_EXPORTTO,
            GUIL_GadgetSpecID, GID_READONLY,
        TAG_DONE,

    TAG_DONE,

    GUIL_VertGroup, 1,
        GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth,

        GUIL_VertGroup, 1,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth | GUILF_LabelAlign,
            GUIL_FrameType, GUILFT_Ridge,
            GUIL_FrameHeadline, "Keep",
            GUIL_GadgetSpecID, GID_KEEP,
            GUIL_GadgetSpecID, GID_KEEPNUM,
            GUIL_GadgetSpecID, GID_KEEPTOYOU,
        TAG_DONE,

        GUIL_HorizGroup, 1,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,
            GUIL_FrameType, GUILFT_Ridge,
            GUIL_FrameHeadline, "Charsets",
            GUIL_GadgetSpecID, GID_CHARSET,
            GUIL_GadgetSpecID, GID_WRITE,
        TAG_DONE,

        GUIL_VertGroup, 1,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth | GUILF_LabelAlign,
            GUIL_FrameType, GUILFT_Ridge,
            GUIL_FrameHeadline, "Headers",
            GUIL_HorizGroup,0,
                GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,
                GUIL_GadgetSpecID, GID_ORIGIN,
                GUIL_GadgetSpecID, GID_GETORIGIN,
            TAG_DONE,

            GUIL_HorizGroup,0,
                GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,
                GUIL_GadgetSpecID, GID_REPLY,
                GUIL_GadgetSpecID, GID_GETREPLY,
            TAG_DONE,

            GUIL_HorizGroup,0,
                GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,
                GUIL_GadgetSpecID, GID_SIGNATURE,
                GUIL_GadgetSpecID, GID_GETSIGNATURE,
            TAG_DONE,
        TAG_DONE,

        GUIL_VertGroup, 1,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth | GUILF_LabelAlign,
            GUIL_FrameType, GUILFT_Ridge,
            GUIL_GadgetSpecID, GID_ALIAS,
            GUIL_GadgetSpecID, GID_TAGLINES,
        TAG_DONE,
    TAG_DONE,

    TAG_DONE,
};

/* Now, some globals used by Generic.o during the call to GF_CreateGUIA() */

int DEMO_InitialOrientation = GUIL_HorizGroup;

STRPTR DEMO_WindowTitle = "Spot/Areas GUI";
STRPTR DEMO_AppID       = "Spot.Areas2";

STRPTR DEMO_Version     = "1.0",
       DEMO_LongDesc    = "Demo program - The 'Areas' GUI of Spot (2)",
       DEMO_Author      = "Michael Berg",
       DEMO_Date        = __AMIGADATE__;

BOOL   DEMO_Backfill    = FALSE;
