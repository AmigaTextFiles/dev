;/*
sc TapeDeck.c LINK NOSTACKCHECK
quit
*/

#include <dos/dos.h>
#include <exec/types.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <reaction/reaction_macros.h>

#include <stdio.h>

#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/alib_protos.h>

#include <pragmas/exec_pragmas.h>
#include <pragmas/intuition_pragmas.h>

#include <pragmas/layout_pragmas.h>
#include <pragmas/window_pragmas.h>

#include <gadgets/tapedeck.h>
#include <classes/window.h>

extern struct Library *SysBase, *DOSBase;

struct Library *IntuitionBase,
               *LayoutBase,
               *TapeDeckBase,
               *WindowBase;

void main (int argc, char **argv)
{
	struct Window* win;
	struct Gadget* g;
	Object*        winobj;
	BOOL           going = TRUE;
	UWORD          code;
	ULONG          result,
	               sigr;

	if (!((IntuitionBase = OpenLibrary("intuition.library", 39L))))
	{
		printf("Can't open intuition.library\n");
		return;
	}

	if (!((WindowBase = OpenLibrary("window.class", 39L))))
	{
		printf("Can't open window.class\n");
		goto QUIT5;
	}

	if (!((LayoutBase = OpenLibrary("gadgets/layout.gadget", 39L))))
	{
		printf("Can't open layout.gadget\n");
		goto QUIT4;
	}

	if (!((TapeDeckBase = OpenLibrary("gadgets/tapedeck.gadget", 39L))))
	{
		printf("Can't open tapedeck.gadget\n");
		goto QUIT3;
	}

	if (!((winobj =
	WindowObject,
		WA_InnerWidth,			202,
		WA_InnerHeight,			15,
		WA_DragBar,			TRUE,
		WA_DepthGadget,			TRUE,
		WA_CloseGadget,			TRUE,
		WA_SizeGadget,			TRUE,
		WA_Activate,			TRUE,
		WA_IDCMP,			IDCMP_VANILLAKEY
					      | IDCMP_CLOSEWINDOW
					      | IDCMP_INTUITICKS
					      | IDCMP_MOUSEMOVE
					      | IDCMP_GADGETUP,
		WA_Title,			(ULONG) "TapeDeck Gadget Example",
		WINDOW_ParentGroup,
		VLayoutObject,
			LAYOUT_AddChild,	g =
			NewObject(NULL, "tapedeck.gadget",
				GA_Width,	202,
				GA_Height,	15,
				GA_RelVerify,	TRUE,
				GA_FollowMouse,	TRUE,
				GA_Immediate,	TRUE,
				TDECK_Tape,	(argc > 1) ? TRUE : FALSE,
			End,
		LayoutEnd,
	WindowEnd)))
	{
		printf("Can't create window object\n");
		goto QUIT2;
	}

	if (!((win = (struct Window*) RA_OpenWindow(winobj))))
	{
		printf("Can't open window\n");
		goto QUIT1;
	}

	printf("Press the close gadget to quit.\n");

	do
	{
		sigr = Wait ((1L << win->UserPort->mp_SigBit | SIGBREAKF_CTRL_C));

		if (sigr & SIGBREAKF_CTRL_C)
			going = FALSE;

		while ((result = DoMethod(winobj, WM_HANDLEINPUT, &code)) != WMHI_LASTMSG)
		{
			switch (result & WMHI_CLASSMASK)
			{
			case WMHI_CLOSEWINDOW:
				going = FALSE;
			break;

			case WMHI_VANILLAKEY:
				switch (result & WMHI_KEYMASK)
				{
				case '<':
				    printf ("rewind\n");
				    SetGadgetAttrs (g, win, NULL, TDECK_Mode, BUT_REWIND, TAG_DONE);
				break;
				case 10:
				case 13:
				    printf ("play\n");
				    SetGadgetAttrs (g, win, NULL, TDECK_Mode, BUT_PLAY, TAG_DONE);
				break;
				case '>':
				    printf ("fast forward\n");
				    SetGadgetAttrs (g, win, NULL, TDECK_Mode, BUT_FORWARD, TAG_DONE);
				break;
				case 's':
				    printf ("stop\n");
				    SetGadgetAttrs (g, win, NULL, TDECK_Mode, BUT_STOP, TAG_DONE);
				break;
				case 'p':
				    printf ("pause\n");
				    SetGadgetAttrs (g, win, NULL, TDECK_Mode, BUT_PAUSE, TAG_DONE);
				break;
				case  27:
				case 'q':
				case 'Q':
				    going = FALSE;
				}
			break;

			case WMHI_MOUSEMOVE:
			case WMHI_INTUITICK:
				if (g->Flags & GFLG_SELECTED)
					printf ("code=%04x : %04lx\n", code, g->SpecialInfo);
			break;

			case WMHI_GADGETUP:
				printf ("code=%04x : %04lx\n", code, g->SpecialInfo);
			}
		}
	} while (going);

QUIT1:	DisposeObject(winobj);
QUIT2:	CloseLibrary(TapeDeckBase);
QUIT3:	CloseLibrary(LayoutBase);
QUIT4:	CloseLibrary(WindowBase);
QUIT5:	CloseLibrary(IntuitionBase);
}
