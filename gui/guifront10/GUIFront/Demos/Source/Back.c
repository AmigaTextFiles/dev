
/* Back.c - backfill example
 *
 * This is a GUIFront example GUI. To build an example, compile and link this
 * file with Generic.o (also supplied).
 * Everything prefixed with DEMO_ is exported to Generic.o.
 */

#include <libraries/guifront.h>

/* First, some Gadget ID's */

enum
{
    GID_CHECKBOX1,
    GID_CHECKBOX2,
    GID_CHECKBOX3,
    GID_STRING1,
    GID_STRING2,
    GID_STRING3,
    GID_BUTTON1,
    GID_BUTTON2,
};

/* Now, the GadgetSpec's we'll be needing for this GUI */

static GadgetSpec gadgetspecs[] =
{
    {CHECKBOX_KIND, 0,0, {0,0,0,0, "_GUIFront", NULL, GID_CHECKBOX1, PLACETEXT_LEFT}, NULL, GS_DefaultTags},
    {CHECKBOX_KIND, 0,0, {0,0,0,0, "_Is",       NULL, GID_CHECKBOX2, PLACETEXT_LEFT}, NULL, GS_DefaultTags},
    {CHECKBOX_KIND, 0,0, {0,0,0,0, "_Easy",     NULL, GID_CHECKBOX3, PLACETEXT_LEFT}, NULL, GS_DefaultTags},
    {STRING_KIND,   20,0,{0,0,0,0, "E_nter",    NULL, GID_STRING1, PLACETEXT_LEFT}, NULL, GS_DefaultTags},
    {STRING_KIND,   20,0,{0,0,0,0, "_Something",NULL, GID_STRING2, PLACETEXT_LEFT}, NULL, GS_DefaultTags},
    {STRING_KIND,   20,0,{0,0,0,0, "_Here",     NULL, GID_STRING3, PLACETEXT_LEFT}, NULL, GS_DefaultTags},
    {BUTTON_KIND, 0,0, {0,0,0,0, "_Okay",   NULL, GID_BUTTON1, PLACETEXT_IN}, NULL, GS_DefaultTags},
    {BUTTON_KIND, 0,0, {0,0,0,0, "_Cancel", NULL, GID_BUTTON2, PLACETEXT_IN}, NULL, GS_DefaultTags},
};

/* Now, we group all of these GadgetSpecs into an array of pointers, so the
 * layout engine can locate gadgets merely by their Gadget IDs.
 */

GadgetSpec *DEMO_GadgetSpecList[] =
{
    &gadgetspecs[0], &gadgetspecs[1], &gadgetspecs[2], &gadgetspecs[3],
    &gadgetspecs[4], &gadgetspecs[5], &gadgetspecs[6], &gadgetspecs[7],
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
        GUIL_Flags, GUILF_PropShare | GUILF_EqualHeight,

        GUIL_FrameType, GUILFT_Recess,

        GUIL_VertGroup, 1,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth | GUILF_LabelAlign,
            GUIL_GadgetSpecID, GID_CHECKBOX1,
            GUIL_GadgetSpecID, GID_CHECKBOX2,
            GUIL_GadgetSpecID, GID_CHECKBOX3,
        TAG_DONE,

        GUIL_VertGroup, 1,
            GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth | GUILF_LabelAlign,
            GUIL_GadgetSpecID, GID_STRING1,
            GUIL_GadgetSpecID, GID_STRING2,
            GUIL_GadgetSpecID, GID_STRING3,
        TAG_DONE,
    TAG_DONE,

    GUIL_HorizGroup, 1,
        GUIL_Flags, GUILF_EqualSize | GUILF_EqualHeight,
        GUIL_GadgetSpecID, GID_BUTTON1,
        GUIL_GadgetSpecID, GID_BUTTON2,
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

STRPTR DEMO_WindowTitle = "Backfilled GUI";
STRPTR DEMO_AppID       = "Backfilled";

STRPTR DEMO_Version     = "1.0",
       DEMO_LongDesc    = "Demo program - Backfilled GUI",
       DEMO_Author      = "Michael Berg",
       DEMO_Date        = __AMIGADATE__;

BOOL   DEMO_Backfill    = TRUE;
