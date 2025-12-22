
/* General2.c - The GUI of the 'General' window of Spot - beautified a bit
 *
 * This is a GUIFront example GUI. To build an example, compile and link this
 * file with Generic.o (also supplied).
 * Everything prefixed with DEMO_ is exported to Generic.o.
 */

#include <libraries/guifront.h>

/* First, some Gadget ID's */

enum
{
    GID_EDITOR,
    GID_EDITFILE,
    GID_GETEDITFILE,
    GID_WBTOFRONT,
    GID_CHECKDATE,
    GID_DUPECHECKING,
    GID_SPOTTOFRONT,
    GID_CRUNCHBUFFER,
    GID_AREAS,
    GID_GETAREAS,
    GID_INBOUND,
    GID_GETINBOUND,
    GID_OUTBOUND,
    GID_GETOUTBOUND,
    GID_WORK,
    GID_GETWORK,
    GID_NODELIST,
    GID_GETNODELIST,
    GID_FATTACH,
    GID_GETFATTACH,
    GID_SAVE,
    GID_GETSAVE,
    GID_AREXX,
    GID_GETAREXX,
    GID_LOGFILE,
    GID_GETLOGFILE,
    GID_OPTIMIZE,
};

/* Some data and tag items we'll be needing later */

static const STRPTR dupechecklabels[] =
{
    "Off",
    "Toss in BAD",
    "Kill",
    NULL,
};

static const struct TagItem dupechecktags[] =
{
    {GTCY_Labels, dupechecklabels},
    {TAG_DONE},
};

static const STRPTR crunchbufferlabels[] =
{
    "No Crunching",
    "Large (256K)",
    "Medium (65K)",
    "Small (33K)",
    NULL,
};

static const struct TagItem crunchbuffertags[] =
{
    {GTCY_Labels, crunchbufferlabels},
    {TAG_DONE},
};

static const STRPTR optimizelabels[] =
{
    "Areas path",
    "RAM:T",
    NULL,
};

static const struct TagItem optimizetags[] =
{
    {GTCY_Labels, optimizelabels},
    {TAG_DONE},
};

static const struct TagItem geteditfiletags[] =
{
	{ALT_Image, ALTI_GetFile},
	{ALT_AslRequester, TRUE},
	{TAG_DONE},
};

static const struct TagItem getareastags[] =
{
	{ALT_Image, ALTI_GetDir},
	{ALT_AslRequester, TRUE},
	{TAG_DONE},
};

static const struct TagItem getinboundtags[] =
{
	{ALT_Image, ALTI_GetDir},
	{ALT_AslRequester, TRUE},
	{TAG_DONE},
};

static const struct TagItem getoutboundtags[] =
{
	{ALT_Image, ALTI_GetDir},
	{ALT_AslRequester, TRUE},
	{TAG_DONE},
};

static const struct TagItem getworktags[] =
{
	{ALT_Image, ALTI_GetDir},
	{ALT_AslRequester, TRUE},
	{TAG_DONE},
};

static const struct TagItem getnodelisttags[] =
{
	{ALT_Image, ALTI_GetDir},
	{ALT_AslRequester, TRUE},
	{TAG_DONE},
};

static const struct TagItem getfattachtags[] =
{
	{ALT_Image, ALTI_GetDir},
	{ALT_AslRequester, TRUE},
	{TAG_DONE},
};

static const struct TagItem getsavetags[] =
{
	{ALT_Image, ALTI_GetDir},
	{ALT_AslRequester, TRUE},
	{TAG_DONE},
};

static const struct TagItem getarexxtags[] =
{
	{ALT_Image, ALTI_GetDir},
	{ALT_AslRequester, TRUE},
	{TAG_DONE},
};

static const struct TagItem getlogfiletags[] =
{
	{ALT_Image, ALTI_GetFile},
	{ALT_AslRequester, TRUE},
	{TAG_DONE},
};

/* Now, the GadgetSpec's we'll be needing for this GUI */

static GadgetSpec gadgetspecs[] =
{
    {STRING_KIND, 20,0,{0,0,0,0, "_Editor", NULL, GID_EDITOR, PLACETEXT_LEFT}, NULL, GS_DefaultTags},
    {STRING_KIND, 20,0,{0,0,0,0, "Edi_t file", NULL, GID_EDITFILE, PLACETEXT_LEFT}, NULL, GS_DefaultTags},
    {GETALT_KIND, 0,0, {0,0,0,0, NULL, NULL, GID_GETEDITFILE, PLACETEXT_IN},geteditfiletags,GS_DefaultTags},
    {CHECKBOX_KIND,0,0,{0,0,0,0, "W_B to front",NULL, GID_WBTOFRONT,PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {CHECKBOX_KIND,0,0,{0,0,0,0, "_Check date",NULL,GID_CHECKDATE,PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {CYCLE_KIND,  0,0, {0,0,0,0, "_Dupe checking", NULL,GID_DUPECHECKING, PLACETEXT_LEFT}, dupechecktags, GS_DefaultTags},
    {STRING_KIND, 0,0,{0,0,0,0, "_Spot to front", NULL, GID_SPOTTOFRONT, PLACETEXT_LEFT}, NULL, GS_DefaultTags},
    {CYCLE_KIND,  0,0, {0,0,0,0, "Cr_unch buffer", NULL,GID_CRUNCHBUFFER, PLACETEXT_LEFT}, crunchbuffertags, GS_DefaultTags},
    {STRING_KIND, 20,0,{0,0,0,0, "_Areas", NULL, GID_AREAS, PLACETEXT_LEFT}, NULL, GS_DefaultTags},
    {GETALT_KIND, 0,0, {0,0,0,0, NULL, NULL, GID_GETAREAS, PLACETEXT_IN},getareastags,GS_DefaultTags},
    {STRING_KIND, 20,0,{0,0,0,0, "_Inbound", NULL, GID_INBOUND, PLACETEXT_LEFT}, NULL, GS_DefaultTags},
    {GETALT_KIND, 0,0, {0,0,0,0, NULL, NULL, GID_GETINBOUND, PLACETEXT_IN},getinboundtags,GS_DefaultTags},
    {STRING_KIND, 20,0,{0,0,0,0, "_Outbound", NULL, GID_OUTBOUND, PLACETEXT_LEFT}, NULL, GS_DefaultTags},
    {GETALT_KIND, 0,0, {0,0,0,0, NULL, NULL, GID_GETOUTBOUND, PLACETEXT_IN},getoutboundtags,GS_DefaultTags},
    {STRING_KIND, 20,0,{0,0,0,0, "_Work", NULL, GID_WORK, PLACETEXT_LEFT}, NULL, GS_DefaultTags},
    {GETALT_KIND, 0,0, {0,0,0,0, NULL, NULL, GID_GETWORK, PLACETEXT_IN},getworktags,GS_DefaultTags},
    {STRING_KIND, 20,0,{0,0,0,0, "_Nodelist", NULL, GID_NODELIST, PLACETEXT_LEFT}, NULL, GS_DefaultTags},
    {GETALT_KIND, 0,0, {0,0,0,0, NULL, NULL, GID_GETNODELIST, PLACETEXT_IN},getnodelisttags,GS_DefaultTags},
    {STRING_KIND, 20,0,{0,0,0,0, "_FAttach", NULL, GID_FATTACH, PLACETEXT_LEFT}, NULL, GS_DefaultTags},
    {GETALT_KIND, 0,0, {0,0,0,0, NULL, NULL, GID_GETFATTACH, PLACETEXT_IN},getfattachtags,GS_DefaultTags},
    {STRING_KIND, 20,0,{0,0,0,0, "Sa_ve", NULL, GID_SAVE, PLACETEXT_LEFT}, NULL, GS_DefaultTags},
    {GETALT_KIND, 0,0, {0,0,0,0, NULL, NULL, GID_GETSAVE, PLACETEXT_IN},getsavetags,GS_DefaultTags},
    {STRING_KIND, 20,0,{0,0,0,0, "ARe_xx", NULL, GID_AREXX, PLACETEXT_LEFT}, NULL, GS_DefaultTags},
    {GETALT_KIND, 0,0, {0,0,0,0, NULL, NULL, GID_GETAREXX, PLACETEXT_IN},getarexxtags,GS_DefaultTags},
    {STRING_KIND, 20,0,{0,0,0,0, "_Log file", NULL, GID_LOGFILE, PLACETEXT_LEFT}, NULL, GS_DefaultTags},
    {GETALT_KIND, 0,0, {0,0,0,0, NULL, NULL, GID_GETLOGFILE, PLACETEXT_IN},getlogfiletags,GS_DefaultTags},
    {CYCLE_KIND,  0,0, {0,0,0,0, "Optimi_ze", NULL, GID_OPTIMIZE, PLACETEXT_LEFT},optimizetags,GS_DefaultTags},
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
    &gadgetspecs[19], &gadgetspecs[20], &gadgetspecs[21], &gadgetspecs[22],
    &gadgetspecs[23], &gadgetspecs[24], &gadgetspecs[25], &gadgetspecs[26],
    &gadgetspecs[27], &gadgetspecs[28], &gadgetspecs[29], &gadgetspecs[30],
    &gadgetspecs[31], NULL,
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

        GUIL_VertGroup,1,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth | GUILF_LabelAlign,
            GUIL_FrameType, GUILFT_Ridge,
            GUIL_FrameHeadline, "Commands",

            GUIL_GadgetSpecID, GID_EDITOR,

            GUIL_HorizGroup, 0,
                GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,
                GUIL_GadgetSpecID, GID_EDITFILE,
                GUIL_GadgetSpecID, GID_GETEDITFILE,
            TAG_DONE,

            GUIL_GadgetSpecID, GID_WBTOFRONT,
            GUIL_GadgetSpecID, GID_CHECKDATE,
        TAG_DONE,

        GUIL_VertGroup,1,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth,
            GUIL_FrameType, GUILFT_Ridge,
            GUIL_FrameHeadline, "Tosser",
            GUIL_GadgetSpecID, GID_DUPECHECKING,
        TAG_DONE,

        GUIL_VertGroup,1,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth,
            GUIL_FrameType, GUILFT_Ridge,
            GUIL_FrameHeadline, "Hotkeys",
            GUIL_GadgetSpecID, GID_SPOTTOFRONT,
        TAG_DONE,

        GUIL_VertGroup,1,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth,
            GUIL_FrameType, GUILFT_Ridge,
            GUIL_FrameHeadline, "Message base crunching",

            GUIL_GadgetSpecID, GID_CRUNCHBUFFER,
        TAG_DONE,
    TAG_DONE,

    GUIL_VertGroup, 1,
        GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth | GUILF_LabelAlign,

        GUIL_FrameType, GUILFT_Ridge,
        GUIL_FrameHeadline, "Paths/files",

        GUIL_HorizGroup, 0,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,
            GUIL_GadgetSpecID, GID_AREAS,
            GUIL_GadgetSpecID, GID_GETAREAS,
        TAG_DONE,

        GUIL_HorizGroup, 0,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,
            GUIL_GadgetSpecID, GID_INBOUND,
            GUIL_GadgetSpecID, GID_GETINBOUND,
        TAG_DONE,

        GUIL_HorizGroup, 0,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,
            GUIL_GadgetSpecID, GID_OUTBOUND,
            GUIL_GadgetSpecID, GID_GETOUTBOUND,
        TAG_DONE,

        GUIL_HorizGroup, 0,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,
            GUIL_GadgetSpecID, GID_WORK,
            GUIL_GadgetSpecID, GID_GETWORK,
        TAG_DONE,

        GUIL_HorizGroup, 0,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,
            GUIL_GadgetSpecID, GID_NODELIST,
            GUIL_GadgetSpecID, GID_GETNODELIST,
        TAG_DONE,

        GUIL_HorizGroup, 0,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,
            GUIL_GadgetSpecID, GID_FATTACH,
            GUIL_GadgetSpecID, GID_GETFATTACH,
        TAG_DONE,

        GUIL_HorizGroup, 0,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,
            GUIL_GadgetSpecID, GID_SAVE,
            GUIL_GadgetSpecID, GID_GETSAVE,
        TAG_DONE,

        GUIL_HorizGroup, 0,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,
            GUIL_GadgetSpecID, GID_AREXX,
            GUIL_GadgetSpecID, GID_GETAREXX,
        TAG_DONE,

        GUIL_HorizGroup, 0,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,
            GUIL_GadgetSpecID, GID_LOGFILE,
            GUIL_GadgetSpecID, GID_GETLOGFILE,
        TAG_DONE,

        GUIL_GadgetSpecID, GID_OPTIMIZE,
    TAG_DONE,

    TAG_DONE
};

/* Obligatory version tag */

static const char ver[] = "$VER: General2 1.0 " __AMIGADATE__;

/* Now, some globals used by Generic.o during the call to GF_CreateGUIA() */

int DEMO_InitialOrientation = GUIL_HorizGroup;

STRPTR DEMO_WindowTitle = "Spot/General GUI (2)";
STRPTR DEMO_AppID       = "Spot.General2";

STRPTR DEMO_Version     = "1.0",
       DEMO_LongDesc    = "Demo program - The 'General' GUI of Spot (2)",
       DEMO_Author      = "Michael Berg",
       DEMO_Date        = __AMIGADATE__;

BOOL   DEMO_Backfill    = FALSE;
