;/*
sc LED.c LINK NOSTACKCHECK
quit
*/

#include <dos/dos.h>
#include <exec/types.h>
#include <exec/libraries.h>
#include <intuition/intuition.h>
#include <intuition/imageclass.h>
#include <intuition/intuitionbase.h>
#include <reaction/reaction_macros.h>
#include <stdlib.h>
#include <stdio.h>

#include <classes/window.h>
#include <gadgets/layout.h>
#include <images/led.h>

#include <clib/macros.h>
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/alib_protos.h>

#include <pragmas/dos_pragmas.h>
#include <pragmas/exec_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/layout_pragmas.h>
#include <pragmas/window_pragmas.h>

/*****************************************************************************/

static void anykey(void);

extern struct Library *SysBase,
                      *DOSBase;
struct Library        *IntuitionBase = NULL;
Object                *WinObject = NULL;

/*****************************************************************************/

int main(int argc, char **argv)
{
    struct ClassLibrary *LayoutBase = NULL,
                        *LEDBase    = NULL,
                        *WindowBase = NULL;
    struct DrawInfo *DrawInfoPtr;
    struct Screen   *ScreenPtr;
    struct Window   *win;
    struct Image    *im;
    WORD ledvalues[4][8] = { {     26,     50,     44,     89,     12,     34,     56,     78 }, // "2650448912345678"
                             {   0xDE,   0xAD,   0xBE,   0xEF,   0xC0,   0xDE,   0xDB,   0xAD }, // "dEAdbEEFC0dEdbAd"
                             { 0x0000, 0x000C, 0x5F37, 0x3700, 0x7676, 0x0F1F, 0x6D00, 0x0000 }, // "   raUU NNodE   "
                             { 0x776B, 0x5B5D, 0x002F, 0x0F02, 0x0E7B, 0x002F, 0x5F7B, 0x0012 }, // "OS32 boing bag 1"
                           };

    if
    (   (IntuitionBase =                        OpenLibrary("intuition.library",     37))
     && (WindowBase    = (struct ClassLibrary*) OpenLibrary("window.class",          47))
     && (LayoutBase    = (struct ClassLibrary*) OpenLibrary("gadgets/layout.gadget", 37))
     && (LEDBase       = (struct ClassLibrary*) OpenLibrary("images/led.image",      37))
    )
    {   if ((WinObject = WindowObject,
            WA_PubScreen,                 NULL,
            WA_Title,                     "Press any key",
            WA_Activate,                  TRUE,
            WA_DepthGadget,               TRUE,
            WA_DragBar,                   TRUE,
            WA_CloseGadget,               TRUE,
            WA_SizeGadget,                TRUE,
            WA_IDCMP,                     IDCMP_NEWSIZE,
            WINDOW_Position,              WPOS_CENTERMOUSE,
            WINDOW_ParentGroup,
            VLayoutObject,
                LAYOUT_AddImage,          im = (struct Image*)
                NewObject(NULL, "led.image",
                    IA_FGPen,             1,
                    IA_BGPen,             0,
                    LED_Pairs,            8,
                    LED_Signed,           TRUE,
                    LED_Negative,         TRUE,
                    LED_Time,             FALSE,
                    LED_Colon,            FALSE,
                    LED_Raw,              FALSE,
                    LED_Values,           &ledvalues[0],
                LedEnd,
                CHILD_MinWidth,           288,
                CHILD_MinHeight,          64,
            LayoutEnd,
        WindowEnd))
        {   if (win = (struct Window*) RA_OpenWindow(WinObject))
            {   ScreenPtr = LockPubScreen(NULL);
                DrawInfoPtr = GetScreenDrawInfo(ScreenPtr);
                UnlockPubScreen(NULL, ScreenPtr);
                anykey();

                if
                (    LEDBase->cl_Lib.lib_Version >  47
                 || (LEDBase->cl_Lib.lib_Version == 47 && LEDBase->cl_Lib.lib_Revision >= 3)
                )
                {   SetAttrs
                    (   im, (ULONG) win, NULL,
                        LED_Negative,         FALSE,
                        LED_Hexadecimal,      TRUE,
                        LED_Values,           &ledvalues[1],
                    TAG_DONE);
                    DrawImageState(win->RPort, im, 0, 0, IDS_NORMAL, DrawInfoPtr);
                    anykey();

                    SetAttrs
                    (   im, (ULONG) win, NULL,
                        LED_Raw,              TRUE,
                        LED_Values,           &ledvalues[2],
                    TAG_DONE);
                    DrawImageState(win->RPort, im, 0, 0, IDS_NORMAL, DrawInfoPtr);
                    anykey();

                    SetAttrs
                    (   im, (ULONG) win, NULL,
                        LED_Values,           &ledvalues[3],
                    TAG_DONE);
                    DrawImageState(win->RPort, im, 0, 0, IDS_NORMAL, DrawInfoPtr);
                    anykey();
            }   }
            DisposeObject(WinObject);
    }   }

    CloseLibrary((struct Library*) LEDBase);
    CloseLibrary((struct Library*) LayoutBase);
    CloseLibrary((struct Library*) WindowBase);
    CloseLibrary(                  IntuitionBase);

    return 0;
}

static void anykey(void)
{   BOOL  going = TRUE;
    UWORD code;
    ULONG qual,
          result,
          thesignal;

    GetAttr(WINDOW_SigMask, WinObject, &thesignal);
    while (going)
    {   if ((Wait(thesignal | SIGBREAKF_CTRL_C)) & SIGBREAKF_CTRL_C)
        {   going = FALSE;
        }

        while ((result = DoMethod(WinObject, WM_HANDLEINPUT, &code)) != WMHI_LASTMSG)
        {   switch (result & WMHI_CLASSMASK)
            {
            case WMHI_CLOSEWINDOW:
                going = FALSE;
                break;
            case WMHI_RAWKEY:
                GetAttr(WINDOW_Qualifier, WinObject, &qual);
                if (code < 128 && !(qual & IEQUALIFIER_REPEAT))
                {   going = FALSE;
}   }   }   }   }
