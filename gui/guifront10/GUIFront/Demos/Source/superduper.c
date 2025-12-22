
/* SuperDuper.c - The GUI from this outstanding disk duplicator
 *
 * This is a GUIFront example GUI. To build an example, compile and link this
 * file with Generic.o (also supplied).
 * Everything prefixed with DEMO_ is exported to Generic.o.
 */

#include <libraries/guifront.h>

/* First, some Gadget ID's */

enum
{
    GID_STOP,
    GID_COPY,
    GID_READ,
    GID_WRITE,
    GID_CHECK,
    GID_FORMAT,
    GID_OPTIONS,
    GID_INFO,
    GID_AREXX,
    GID_NOWB,
    GID_SAVECON,
    GID_ICONIFY,
    GID_SOURCEDF0,
    GID_SOURCEDF1,
    GID_SOURCEDF2,
    GID_SOURCEDF3,
    GID_DESTDF0,
    GID_DESTDF1,
    GID_DESTDF2,
    GID_DESTDF3,
    GID_MODE,
    GID_PROGRESS,
};

/* Some data and tag items we'll be needing later */

static const STRPTR modemxlabels[] =
{
    "_Disk2Disk",
    "_Buffer",
    "_HD Buffer",
    "_VD Buffer",
    NULL
};

static const struct TagItem modemxtags[] =
{
    {GTMX_Labels, modemxlabels},
    {TAG_DONE},
};

static const struct TagItem progresstags[] =
{
    {GTTX_Border, TRUE},
    {TAG_DONE},
};

/* Now, the GadgetSpec's we'll be needing for this GUI */

static GadgetSpec gadgetspecs[] =
{
    {BUTTON_KIND,  0,0, {0,0,0,0,"_Stop", NULL, GID_STOP,PLACETEXT_IN},NULL,GS_DefaultTags},
    {BUTTON_KIND,  0,0, {0,0,0,0,"_Copy", NULL, GID_COPY,PLACETEXT_IN},NULL,GS_DefaultTags},
    {BUTTON_KIND,  0,0, {0,0,0,0,"_Read", NULL, GID_READ,PLACETEXT_IN},NULL,GS_DefaultTags},
    {BUTTON_KIND,  0,0, {0,0,0,0,"_Write", NULL, GID_WRITE,PLACETEXT_IN},NULL,GS_DefaultTags},
    {BUTTON_KIND,  0,0, {0,0,0,0,"Chec_k", NULL, GID_CHECK,PLACETEXT_IN},NULL,GS_DefaultTags},
    {BUTTON_KIND,  0,0, {0,0,0,0,"_Format", NULL, GID_FORMAT,PLACETEXT_IN},NULL,GS_DefaultTags},
    {BUTTON_KIND,  0,0, {0,0,0,0,"_Options", NULL, GID_OPTIONS,PLACETEXT_IN},NULL,GS_DefaultTags},
    {BUTTON_KIND,  0,0, {0,0,0,0,"_Info", NULL, GID_INFO,PLACETEXT_IN},NULL,GS_DefaultTags},
    {BUTTON_KIND,  0,0, {0,0,0,0,"ARe_xx", NULL, GID_AREXX,PLACETEXT_IN},NULL,GS_DefaultTags},
    {BUTTON_KIND,  0,0, {0,0,0,0,"_NoWB", NULL, GID_NOWB,PLACETEXT_IN},NULL,GS_DefaultTags},
    {BUTTON_KIND,  0,0, {0,0,0,0,"S_aveCon", NULL, GID_SAVECON,PLACETEXT_IN},NULL,GS_DefaultTags},
    {BUTTON_KIND,  0,0, {0,0,0,0,"Iconif_y", NULL, GID_ICONIFY,PLACETEXT_IN},NULL,GS_DefaultTags},
    {CHECKBOX_KIND,0,0, {0,0,0,0,NULL, NULL, GID_SOURCEDF0, PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {CHECKBOX_KIND,0,0, {0,0,0,0,NULL, NULL, GID_SOURCEDF1, PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {CHECKBOX_KIND,0,0, {0,0,0,0,NULL, NULL, GID_SOURCEDF2, PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {CHECKBOX_KIND,0,0, {0,0,0,0,NULL, NULL, GID_SOURCEDF3, PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {CHECKBOX_KIND,0,0, {0,0,0,0,"DF_0:", NULL, GID_DESTDF0, PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {CHECKBOX_KIND,0,0, {0,0,0,0,"DF_1:", NULL, GID_DESTDF1, PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {CHECKBOX_KIND,0,0, {0,0,0,0,"DF_2:", NULL, GID_DESTDF2, PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {CHECKBOX_KIND,0,0, {0,0,0,0,"DF_3:", NULL, GID_DESTDF3, PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {MX_KIND,      0,0, {0,0,0,0,NULL, NULL,GID_MODE,PLACETEXT_LEFT},modemxtags,GS_DefaultTags},
    {TEXT_KIND,    0,0, {0,0,0,0,NULL, NULL,GID_PROGRESS,PLACETEXT_IN},progresstags,GS_DefaultTags},
};

/* Now, we group all of these GadgetSpecs into an array of pointers, so the
 * layout engine can locate gadgets merely by their Gadget IDs.
 */

GadgetSpec *DEMO_GadgetSpecList[] =
{
    &gadgetspecs[0],  &gadgetspecs[1],  &gadgetspecs[2],  &gadgetspecs[2],
    &gadgetspecs[3],  &gadgetspecs[4],  &gadgetspecs[5],  &gadgetspecs[6],
    &gadgetspecs[7],  &gadgetspecs[8],  &gadgetspecs[9],  &gadgetspecs[10],
    &gadgetspecs[11], &gadgetspecs[12], &gadgetspecs[13], &gadgetspecs[14],
    &gadgetspecs[15], &gadgetspecs[16], &gadgetspecs[17], &gadgetspecs[18],
    &gadgetspecs[19], &gadgetspecs[20], &gadgetspecs[21], NULL,
};

/* Finally, the layout tag list itself. This is where most of the work is
 * done. This list completely describes how the above gadgets are arranged
 * in groups in the GUI.
 */

ULONG DEMO_LayoutList[] =
{
    GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,

    GUIL_VertGroup, 1,
        GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth,

        GUIL_FrameType, GUILFT_Ridge,
        GUIL_FrameHeadline, "Control Panel",

        GUIL_GadgetSpecID, GID_PROGRESS,

        GUIL_HorizGroup, 1,
            GUIL_Flags, GUILF_EqualShare | GUILF_EqualHeight,
            GUIL_GadgetSpecID, GID_STOP,
            GUIL_GadgetSpecID, GID_COPY,
            GUIL_GadgetSpecID, GID_READ,
            GUIL_GadgetSpecID, GID_WRITE,
        TAG_DONE,

        GUIL_HorizGroup, 1,
            GUIL_Flags, GUILF_EqualShare | GUILF_EqualHeight,
            GUIL_GadgetSpecID, GID_CHECK,
            GUIL_GadgetSpecID, GID_FORMAT,
            GUIL_GadgetSpecID, GID_OPTIONS,
            GUIL_GadgetSpecID, GID_INFO,
        TAG_DONE,

        GUIL_HorizGroup, 1,
            GUIL_Flags, GUILF_EqualShare | GUILF_EqualHeight,
            GUIL_GadgetSpecID, GID_AREXX,
            GUIL_GadgetSpecID, GID_NOWB,
            GUIL_GadgetSpecID, GID_SAVECON,
            GUIL_GadgetSpecID, GID_ICONIFY,
        TAG_DONE,
    TAG_DONE,

    GUIL_HorizGroup, 1,
        GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,

        GUIL_FrameType, GUILFT_Ridge,
        GUIL_FrameHeadline, "Src/Dest",

        GUIL_VertGroup, 1,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth,
            GUIL_GadgetSpecID, GID_SOURCEDF0,
            GUIL_GadgetSpecID, GID_SOURCEDF1,
            GUIL_GadgetSpecID, GID_SOURCEDF2,
            GUIL_GadgetSpecID, GID_SOURCEDF3,
        TAG_DONE,

        GUIL_VertGroup, 1,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth | GUILF_LabelAlign,
            GUIL_GadgetSpecID, GID_DESTDF0,
            GUIL_GadgetSpecID, GID_DESTDF1,
            GUIL_GadgetSpecID, GID_DESTDF2,
            GUIL_GadgetSpecID, GID_DESTDF3,
        TAG_DONE,
    TAG_DONE,

    GUIL_VertGroup, 1,
        GUIL_Flags, GUILF_PropShare,
        GUIL_FrameType, GUILFT_Ridge,
        GUIL_FrameHeadline, "Mode",
        GUIL_GadgetSpecID, GID_MODE,
    TAG_DONE,

    TAG_DONE,
};

/* Now, some globals used by Generic.o during the call to GF_CreateGUIA() */

int DEMO_InitialOrientation = GUIL_HorizGroup;

STRPTR DEMO_WindowTitle = "SuperDuper GUI";
STRPTR DEMO_AppID       = "SuperDuper";

STRPTR DEMO_Version     = "1.0",
       DEMO_LongDesc    = "Demo program - Super Duper",
       DEMO_Author      = "Michael Berg",
       DEMO_Date        = __AMIGADATE__;
