
/* ThreeBut.c - Three simple buttons
 *
 * This is a GUIFront example GUI. To build an example, compile and link this
 * file with Generic.o (also supplied).
 * Everything prefixed with DEMO_ is exported to Generic.o.
 */

#include <libraries/guifront.h>

/* First, some Gadget ID's */

enum
{
    GID_BUTTON1,
    GID_BUTTON2,
    GID_BUTTON3,
};

/* Now, the GadgetSpec's we'll be needing for this GUI */

static GadgetSpec gadgetspecs[] =
{
    {BUTTON_KIND, 0,0, {0,0,0,0, "_A button",       NULL, GID_BUTTON1, PLACETEXT_IN}, NULL, GS_DefaultTags},
    {BUTTON_KIND, 0,0, {0,0,0,0, "Another _button", NULL, GID_BUTTON2, PLACETEXT_IN}, NULL, GS_DefaultTags},
    {BUTTON_KIND, 0,0, {0,0,0,0, "_One more",       NULL, GID_BUTTON3, PLACETEXT_IN}, NULL, GS_DefaultTags},
};

/* Now, we group all of these GadgetSpecs into an array of pointers, so the
 * layout engine can locate gadgets merely by their Gadget IDs.
 */

GadgetSpec *DEMO_GadgetSpecList[] =
{
    &gadgetspecs[0], &gadgetspecs[1], &gadgetspecs[2], NULL
};

/* Finally, the layout tag list itself. This is where most of the work is
 * done. This list completely describes how the above gadgets are arranged
 * in groups in the GUI.
 */

ULONG DEMO_LayoutList[] =
{
    GUIL_Flags, GUILF_PropShare | GUILF_EqualWidth,

    GUIL_GadgetSpecID, GID_BUTTON1,
    GUIL_GadgetSpecID, GID_BUTTON2,
    GUIL_GadgetSpecID, GID_BUTTON3,

    TAG_DONE,
};

/* Now, some globals used by Generic.o during the call to GF_CreateGUIA() */

/* The initial orientation of the GUI. In this case, it's vertical. This means
 * the three button gadgets, which we just grouped together, will be placed
 * in a vertical group. Alternatively, we could have used GUIL_HorizGroup
 * to make the initial orientation horizontal (surprise :-)
 */

int DEMO_InitialOrientation = GUIL_VertGroup;

STRPTR DEMO_WindowTitle = "Threebut GUI";
STRPTR DEMO_AppID       = "Threebut";

STRPTR DEMO_Version     = "1.0",
       DEMO_LongDesc    = "Demo program - Three buttons",
       DEMO_Author      = "Michael Berg",
       DEMO_Date        = __AMIGADATE__;
