
/* ReqTools.c - The GUI of the 'ReqTools' preferences utility
 *
 * This is a GUIFront example GUI. To build an example, compile and link this
 * file with Generic.o (also supplied).
 * Everything prefixed with DEMO_ is exported to Generic.o.
 */

#include <libraries/guifront.h>

/* First, some Gadget ID's */

enum
{
    GID_SCREENTOFRONT,
    GID_USEDEFAULT,
    GID_IMMEDIATESORT,
    GID_DRAWERSFIRST,
    GID_MIX,
    GID_DISKLED,
    GID_DEFAULTSFOR,
    GID_SIZE,
    GID_ENTRIESMIN,
    GID_ENTRIESMAX,
    GID_POSITION,
    GID_OFFSETX,
    GID_OFFSETY,
    GID_SAVE,
    GID_USE,
    GID_CANCEL,
    GID_GENERAL,
    GID_FILEREQ,
    GID_SIZETXT,
    GID_NUMBERTXT,
};

/* Some data and tag items we'll be needing later */

static const STRPTR defaultslabels[] =
{
    "File Requester",
    "Font Requester",
    "Palette Requester",
    "Screen Mode Requester",
    "Volume Requester",
    "Other Requesters",
    NULL,
};

static const struct TagItem defaultstags[] =
{
    {GTCY_Labels, defaultslabels},
    {TAG_DONE},
};

static const STRPTR positionlabels[] =
{
    "Mouse Pointer",
    "Center in Window",
    "Center on Screen",
    "Top left of Window",
    "Top left of Screen",
    NULL,
};

static const struct TagItem positiontags[] =
{
    {GTCY_Labels, positionlabels},
    {TAG_DONE},
};

static const struct TagItem sizetags[] =
{
    {GTSL_Min, 25},
    {GTSL_Max, 100},
    {TAG_DONE},
};

/* Now, the GadgetSpec's we'll be needing for this GUI */

static GadgetSpec gadgetspecs[] =
{
    {CHECKBOX_KIND, 0,0, {0,0,0,0,"_Pop screen to front",NULL,GID_SCREENTOFRONT, PLACETEXT_RIGHT}, NULL, GS_DefaultTags},
    {CHECKBOX_KIND, 0,0, {0,0,0,0,"Us_e system default font",NULL,GID_USEDEFAULT, PLACETEXT_RIGHT}, NULL, GS_DefaultTags},
    {CHECKBOX_KIND, 0,0, {0,0,0,0,"_Immediate sort",NULL,GID_IMMEDIATESORT, PLACETEXT_RIGHT}, NULL, GS_DefaultTags},
    {CHECKBOX_KIND, 0,0, {0,0,0,0,"_Display drawers first",NULL,GID_DRAWERSFIRST, PLACETEXT_RIGHT}, NULL, GS_DefaultTags},
    {CHECKBOX_KIND, 0,0, {0,0,0,0,"Mi_x files and drawers",NULL,GID_MIX, PLACETEXT_RIGHT}, NULL, GS_DefaultTags},
    {CHECKBOX_KIND, 0,0, {0,0,0,0,"Di_sk activity LED",NULL,GID_DISKLED, PLACETEXT_RIGHT}, NULL, GS_DefaultTags},
    {CYCLE_KIND,    0,0, {0,0,0,0,"De_faults for",NULL,GID_DEFAULTSFOR,PLACETEXT_LEFT | NG_HIGHLABEL},defaultstags,GS_DefaultTags},
    {SLIDER_KIND,   0,0, {0,0,0,0,"70%",NULL,GID_SIZE,PLACETEXT_LEFT},sizetags,GS_DefaultTags},
    {INTEGER_KIND,   4,0, {0,0,0,0,"_Minimum",NULL,GID_ENTRIESMIN,PLACETEXT_LEFT},NULL,GS_DefaultTags | GS_NoWidthExtend},
    {INTEGER_KIND,   4,0, {0,0,0,0,"M_aximum",NULL,GID_ENTRIESMAX,PLACETEXT_LEFT},NULL,GS_DefaultTags | GS_NoWidthExtend},
    {CYCLE_KIND,    0,0, {0,0,0,0,"P_osition:",NULL,GID_POSITION,PLACETEXT_LEFT},positiontags,GS_DefaultTags},
    {INTEGER_KIND,   4,0, {0,0,0,0,"Offse_t:",NULL,GID_OFFSETX, PLACETEXT_LEFT},NULL,GS_DefaultTags | GS_NoWidthExtend},
    {INTEGER_KIND,   4,0, {0,0,0,0,NULL,NULL,GID_OFFSETY, PLACETEXT_LEFT},NULL,GS_DefaultTags | GS_NoWidthExtend},
    {BUTTON_KIND,   0,0, {0,0,0,0,"_Save", NULL, GID_SAVE, PLACETEXT_IN}, NULL, GS_DefaultTags},
    {BUTTON_KIND,   0,0, {0,0,0,0,"_Use", NULL, GID_USE, PLACETEXT_IN}, NULL, GS_DefaultTags},
    {BUTTON_KIND,   0,0, {0,0,0,0,"_Cancel", NULL, GID_CANCEL, PLACETEXT_IN}, NULL, GS_DefaultTags},
    {TEXT_KIND,     0,0, {0,0,0,0,"General",NULL,GID_GENERAL,PLACETEXT_IN | NG_HIGHLABEL},NULL,GS_DefaultTags},
    {TEXT_KIND,     0,0, {0,0,0,0,"File Requester",NULL,GID_FILEREQ,PLACETEXT_IN | NG_HIGHLABEL},NULL,GS_DefaultTags},
    {TEXT_KIND,     0,0, {0,0,0,0,"Size (% of visible height):",NULL,GID_SIZETXT,PLACETEXT_IN  | NG_HIGHLABEL},NULL,GS_DefaultTags},
    {TEXT_KIND,     0,0, {0,0,0,0,"Number of visible entries:",NULL,GID_NUMBERTXT,PLACETEXT_IN | NG_HIGHLABEL},NULL,GS_DefaultTags},
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
    &gadgetspecs[19],
    NULL,
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

        GUIL_VertGroup, 1,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth,
            GUIL_GadgetSpecID, GID_GENERAL,
            GUIL_GadgetSpecID, GID_SCREENTOFRONT,
            GUIL_GadgetSpecID, GID_USEDEFAULT,

            GUIL_GadgetSpecID, GID_FILEREQ,
            GUIL_GadgetSpecID, GID_IMMEDIATESORT,
            GUIL_GadgetSpecID, GID_DRAWERSFIRST,
            GUIL_GadgetSpecID, GID_MIX,
            GUIL_GadgetSpecID, GID_DISKLED,
        TAG_DONE,

        GUIL_VertGroup, 1,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth,
            GUIL_GadgetSpecID, GID_DEFAULTSFOR,

            GUIL_VertGroup, 1,
                GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth,
                GUIL_FrameType, GUILFT_Recess,
                GUIL_GadgetSpecID, GID_SIZETXT,
                GUIL_GadgetSpecID, GID_SIZE,
                GUIL_GadgetSpecID, GID_NUMBERTXT,
                GUIL_VertGroup, 1,
                    GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth | GUILF_LabelAlign,
                    GUIL_HorizGroup, 1,
                        GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,
                        GUIL_GadgetSpecID, GID_ENTRIESMIN,
                        GUIL_GadgetSpecID, GID_ENTRIESMAX,
                    TAG_DONE,
                    GUIL_GadgetSpecID, GID_POSITION,
                    GUIL_HorizGroup, 0,
                        GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,
                        GUIL_GadgetSpecID, GID_OFFSETX,
                        GUIL_GadgetSpecID, GID_OFFSETY,
                    TAG_DONE,
                TAG_DONE,
            TAG_DONE,
        TAG_DONE,
    TAG_DONE,

    GUIL_HorizGroup, 1,
        GUIL_Flags, GUILF_EqualSize | GUILF_EqualHeight,
        GUIL_GadgetSpecID, GID_SAVE,
        GUIL_GadgetSpecID, GID_USE,
        GUIL_GadgetSpecID, GID_CANCEL,
    TAG_DONE,

    TAG_DONE,
};

/* Now, some globals used by Generic.o during the call to GF_CreateGUIA() */

int DEMO_InitialOrientation = GUIL_VertGroup;

STRPTR DEMO_WindowTitle = "ReqTools Preferences' GUI";
STRPTR DEMO_AppID       = "ReqTools";

STRPTR DEMO_Version     = "1.0",
       DEMO_LongDesc    = "Demo program - ReqTools prefs editor",
       DEMO_Author      = "Michael Berg",
       DEMO_Date        = __AMIGADATE__;
