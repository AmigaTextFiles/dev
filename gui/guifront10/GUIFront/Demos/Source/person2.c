
/* Person.c - Personal data entry form for an employee
 *
/* This is a GUIFront example GUI. To build an example, compile and link this
 * file with Generic.o (also supplied).
 * Everything prefixed with DEMO_ is exported to Generic.o.
 */

#include <libraries/guifront.h>

/* This example is exactly like person.c, only we've added some frames to make
 * it look better
 */

/* First, some Gadget ID's */

enum
{
    GID_NAME,
    GID_ADDRESS,
    GID_ZIP,
    GID_CITY,
    GID_PHONE,
    GID_DEPARTMENT,
    GID_AGE,
    GID_SEX,
    GID_COLOR,
};

/* Some data and tag items we'll be needing later */

static const STRPTR deptcyclelabels[] =
{
    "New York",
    "Sydney",
    "Rio",
    "Port au Prince",
    "Copenhagen",
    NULL,
};

static const struct TagItem deptcycletags[] =
{
    {GTCY_Labels, deptcyclelabels},
    {TAG_DONE},
};

static const STRPTR sexmxlabels[] =
{
    "_Male",
    "_Female",
    NULL
};

static const struct TagItem sexmxtags[] =
{
    {GTMX_Labels, sexmxlabels},
    {GTMX_TitlePlace, PLACETEXT_ABOVE},
    {TAG_DONE},
};

static const struct TagItem colortags[] =
{
	{GTPA_Depth, 2},
	{TAG_DONE},
};

/* Now, the GadgetSpec's we'll be needing for this GUI */

static GadgetSpec gadgetspecs[] =
{
    {STRING_KIND, 20,0, {0,0,0,0,"_Name:",      NULL,GID_NAME,PLACETEXT_LEFT}, NULL, GS_DefaultTags},
    {STRING_KIND, 20,0, {0,0,0,0,"_Address:",   NULL,GID_ADDRESS,PLACETEXT_LEFT}, NULL, GS_DefaultTags},
    {STRING_KIND,  4,0, {0,0,0,0,"_Zip:",       NULL,GID_ZIP,PLACETEXT_LEFT},NULL,GS_DefaultTags | GS_NoWidthExtend},
    {STRING_KIND,  0,0, {0,0,0,0,"_City:",      NULL,GID_CITY,PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {STRING_KIND,  0,0, {0,0,0,0,"_Phone:",     NULL,GID_PHONE,PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {CYCLE_KIND,   0,0, {0,0,0,0,"_Department:",NULL,GID_DEPARTMENT,PLACETEXT_LEFT},deptcycletags,GS_DefaultTags},
    {STRING_KIND,  0,0, {0,0,0,0,"A_ge:",       NULL,GID_AGE,PLACETEXT_LEFT},NULL,GS_DefaultTags},
    {MX_KIND,      0,0, {0,0,0,0, NULL,        NULL,GID_SEX,PLACETEXT_RIGHT},sexmxtags,GS_DefaultTags},
    {PALETTE_KIND,10,0, {0,0,0,0,"Fa_vourite color:",NULL,GID_COLOR,PLACETEXT_LEFT},colortags,GS_DefaultTags},
};

/* Now, we group all of these GadgetSpecs into an array of pointers, so the
 * layout engine can locate gadgets merely by their Gadget IDs.
 */

GadgetSpec *DEMO_GadgetSpecList[] =
{
    &gadgetspecs[0], &gadgetspecs[1], &gadgetspecs[2], &gadgetspecs[2],
    &gadgetspecs[3], &gadgetspecs[4], &gadgetspecs[5], &gadgetspecs[6],
    &gadgetspecs[7], &gadgetspecs[8], NULL,
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

        GUIL_FrameType, GUILFT_Ridge,
        GUIL_FrameHeadline, "Employee",

        GUIL_GadgetSpecID, GID_NAME,
        GUIL_GadgetSpecID, GID_ADDRESS,

        GUIL_HorizGroup, 1,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,
            GUIL_GadgetSpecID, GID_ZIP,
            GUIL_GadgetSpecID, GID_CITY,
        TAG_DONE,

        GUIL_GadgetSpecID, GID_DEPARTMENT,
    TAG_DONE,

    GUIL_HorizGroup, 1,
        GUIL_Flags, GUILF_PropShare,

        GUIL_FrameType, GUILFT_Recess,
        GUIL_FrameHeadline, "Personal Data",

        GUIL_VertGroup, 1,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth | GUILF_LabelAlign,
            GUIL_GadgetSpecID, GID_AGE,
            GUIL_GadgetSpecID, GID_COLOR,
        TAG_DONE,

        GUIL_GadgetSpecID, GID_SEX,
    TAG_DONE,

    TAG_DONE,
};

/* Now, some globals used by Generic.o during the call to GF_CreateGUIA() */

/* The initial orientation of the GUI. In this case, it's vertical. This means
 * the three button gadgets, which we just grouped together, will be placed
 * in a vertical group. Alternatively, we could have used GUIL_HorizGroup
 * to make the initial orientation horizontal (surprise :-)
 */

int DEMO_InitialOrientation = GUIL_VertGroup;

STRPTR DEMO_WindowTitle = "Person GUI";
STRPTR DEMO_AppID       = "Person2";

STRPTR DEMO_Version     = "1.0",
       DEMO_LongDesc    = "Demo program - Personal data entry (2)",
       DEMO_Author      = "Michael Berg",
       DEMO_Date        = __AMIGADATE__;
