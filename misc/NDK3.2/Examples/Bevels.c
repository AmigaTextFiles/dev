;/*
sc Bevels.c LINK NOSTACKCHECK
quit
*/

/* Note that layout.gadget currently turns BVS_BUTTON group frames into
   BVS_STANDARD. */

#include <exec/types.h>
#include <intuition/intuition.h>

#include <reaction/reaction.h>
#include <reaction/reaction_macros.h>
#include <images/label.h>
#include <classes/window.h>

#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/alib_protos.h>

#include <clib/label_protos.h>
#include <clib/layout_protos.h>
#include <clib/window_protos.h>

#include <pragmas/label_pragmas.h>
#include <pragmas/layout_pragmas.h>
#include <pragmas/window_pragmas.h>

#include <stdio.h>

#define GID_LY1 0
#define GID_LY2 1
#define GID_LY3 2
#define GID_LY4 3
#define GID_LY5 4
#define GID_LY6 5
#define GID_LY7 6
#define GIDS    7

typedef UBYTE FLAG;

struct Gadget*  gadget[GIDS];
struct Library *IntuitionBase = NULL,
               *LabelBase     = NULL,
               *LayoutBase    = NULL,
               *WindowBase    = NULL;

int main(void)
{   FLAG           done = FALSE;
    UWORD          code;
    ULONG          MainSignal,
                   result;
    Object*        WinObject;
    struct Window* WindowPtr;

    if
    (   !(IntuitionBase = OpenLibrary("intuition.library"    , 36L))
     || !(LabelBase     = OpenLibrary("images/label.image"   ,  0L))
     || !(LayoutBase    = OpenLibrary("gadgets/layout.gadget",  0L))
     || !(WindowBase    = OpenLibrary("window.class"         ,  0L))
    )
    {   goto DONE;
    }

    if (!(WinObject =
    WindowObject,
        WA_Title,                          "Bevels Demo",
        WA_Activate,                       TRUE,
        WA_DepthGadget,                    TRUE,
        WA_DragBar,                        TRUE,
        WA_CloseGadget,                    TRUE,
        WA_IDCMP,                          IDCMP_RAWKEY,
        WINDOW_Position,                   WPOS_CENTERSCREEN,
        WINDOW_ParentGroup,
        VLayoutObject,
            LAYOUT_SpaceOuter,             TRUE,
            LAYOUT_SpaceInner,             TRUE,
            LAYOUT_AddChild,               gadget[GID_LY1] = (struct Gadget*)
            VLayoutObject,
                LAYOUT_BevelStyle,         BVS_THIN,
                LAYOUT_Label,              "Thin",
                LAYOUT_HorizAlignment,     LALIGN_CENTER,
                LAYOUT_AddImage,
                LabelObject,
                    LABEL_Text,            "Thin",
                LabelEnd,
            LabelEnd,
            LAYOUT_AddChild,               gadget[GID_LY2] = (struct Gadget*)
            VLayoutObject,
                LAYOUT_BevelStyle,         BVS_BUTTON,
                LAYOUT_Label,              "Button",
                LAYOUT_HorizAlignment,     LALIGN_CENTER,
                LAYOUT_AddImage,
                LabelObject,
                    LABEL_Text,            "Button",
                LabelEnd,
            LabelEnd,
            LAYOUT_AddChild,               gadget[GID_LY3] = (struct Gadget*)
            VLayoutObject,
                LAYOUT_BevelStyle,         BVS_GROUP,
                LAYOUT_Label,              "Group",
                LAYOUT_HorizAlignment,     LALIGN_CENTER,
                LAYOUT_AddImage,
                LabelObject,
                    LABEL_Text,            "Group",
                LabelEnd,
            LabelEnd,
            LAYOUT_AddChild,               gadget[GID_LY4] = (struct Gadget*)
            VLayoutObject,
                LAYOUT_BevelStyle,         BVS_FIELD,
                LAYOUT_Label,              "Field",
                LAYOUT_HorizAlignment,     LALIGN_CENTER,
                LAYOUT_AddImage,
                LabelObject,
                    LABEL_Text,            "Field",
                LabelEnd,
            LabelEnd,
            LAYOUT_AddChild,               gadget[GID_LY5] = (struct Gadget*)
            VLayoutObject,
                LAYOUT_BevelStyle,         BVS_NONE,
                LAYOUT_Label,              "None",
                LAYOUT_HorizAlignment,     LALIGN_CENTER,
                LAYOUT_AddImage,
                LabelObject,
                    LABEL_Text,            "None",
                LabelEnd,
            LabelEnd,
            LAYOUT_AddChild,               gadget[GID_LY6] = (struct Gadget*)
            VLayoutObject,
                LAYOUT_BevelStyle,         BVS_DROPBOX,
                LAYOUT_Label,              "Drop Box",
                LAYOUT_HorizAlignment,     LALIGN_CENTER,
                LAYOUT_AddImage,
                LabelObject,
                    LABEL_Text,            "Drop Box",
                LabelEnd,
            LabelEnd,
            LAYOUT_AddChild,               gadget[GID_LY7] = (struct Gadget*)
            VLayoutObject,
                LAYOUT_BevelStyle,         BVS_STANDARD,
                LAYOUT_Label,              "Standard",
                LAYOUT_HorizAlignment,     LALIGN_CENTER,
                LAYOUT_AddImage,
                LabelObject,
                    LABEL_Text,            "Standard",
                LabelEnd,
            LabelEnd,
        LayoutEnd,
    WindowEnd))
    {   goto DONE;
    }

    if (!(WindowPtr = (struct Window*) RA_OpenWindow(WinObject)))
    {   DisposeObject(WinObject);
        goto DONE;
    }
    GetAttr(WINDOW_SigMask, WinObject, &MainSignal);

    printf("Thin:      %ld*%ld\n", gadget[GID_LY1]->Width, gadget[GID_LY1]->Height);
    printf("Button:    %ld*%ld\n", gadget[GID_LY2]->Width, gadget[GID_LY2]->Height);
    printf("Group:     %ld*%ld\n", gadget[GID_LY3]->Width, gadget[GID_LY3]->Height);
    printf("Field:     %ld*%ld\n", gadget[GID_LY4]->Width, gadget[GID_LY4]->Height);
    printf("None:      %ld*%ld\n", gadget[GID_LY5]->Width, gadget[GID_LY5]->Height);
    printf("Drop Box:  %ld*%ld\n", gadget[GID_LY6]->Width, gadget[GID_LY6]->Height);
    printf("Standard:  %ld*%ld\n", gadget[GID_LY7]->Width, gadget[GID_LY7]->Height);

    do
    {   Wait(MainSignal);

        while ((result = DoMethod(WinObject, WM_HANDLEINPUT, &code)) != WMHI_LASTMSG)
        {   switch (result & WMHI_CLASSMASK)
            {
            case WMHI_CLOSEWINDOW:
                done = TRUE;
            break;
            case WMHI_RAWKEY:
                if (code < 0x80) // ie. if key down rather than up
                {   done = TRUE;
    }   }   }   }
    while (!done);

    DisposeObject(WinObject);

DONE:
    if (IntuitionBase) CloseLibrary(IntuitionBase);
    if (LabelBase    ) CloseLibrary(LabelBase    );
    if (LayoutBase   ) CloseLibrary(LayoutBase   );
    if (WindowBase   ) CloseLibrary(WindowBase   );
}
