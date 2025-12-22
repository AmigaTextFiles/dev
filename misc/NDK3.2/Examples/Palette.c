;/*
sc Palette.c LINK NOSTACKCHECK
quit
*/

/**
 **  This is a simple example testing some of the capabilities of the
 **  palette.gadget class.
 **
 **  This code opens a simple window and then creates a palette.gadget.
 **
 **  Note that we are not using window or layout class here, we are 
 **  using the gadget in a fairly direct form, but that's perfectly legal.
 **
 **/


#include <exec/types.h>
#include <exec/memory.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <libraries/gadtools.h>
#include <utility/tagitem.h>
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>
#include <gadgets/palette.h>
#include <proto/palette.h>
#include <stdio.h>

/* Function prototypes.
 */
struct ClassLibrary * OpenClass(STRPTR, ULONG);

/* Global variables.
 */
struct Library *PaletteBase;
struct Gadget *palette_gad;


/* This is the start of our programme.
 */
main()
{
	struct Screen *screen = NULL;

	/* We'll just open up on the Workbench screen, and use its screen font.
	 */
	if (screen = LockPubScreen("Workbench"))
	{
		struct Window *win = NULL;

		/* Open the window, note how we size the window to perfectly fit
		 * all the gadgets.
		 */
		if (win = OpenWindowTags(NULL,
			WA_Left, 0,
			WA_Top, screen->Font->ta_YSize + 3,
			WA_Width, 200,
			WA_Height, (screen->WBorTop) + 5 + screen->Font->ta_YSize + 100,
			WA_IDCMP, IDCMP_GADGETUP | IDCMP_REFRESHWINDOW |
						IDCMP_CLOSEWINDOW | IDCMP_GADGETDOWN,
			WA_Flags, WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET |
						WFLG_SIZEGADGET | WFLG_ACTIVATE | WFLG_SMART_REFRESH,
			WA_Title, "Palette Demo",
			WA_MinWidth, 60,
			WA_MinHeight, (screen->WBorTop) + 5 + screen->Font->ta_YSize + 60,
			WA_MaxWidth, -1,
			WA_MaxHeight, -1,
			TAG_DONE))
		{
			PutStr("Creating palette.gadget\n");
			if (PaletteBase = (struct Library *)OpenClass("gadgets/palette.gadget", 0))
			{
				PutStr("Creating Palette gadget 1\n");
				if (palette_gad = (struct Gadget *)NewObject(PALETTE_GetClass(), NULL,
														GA_ID, 2,
														GA_Top, (win->BorderTop) + 5,
														GA_Left, 10,
														GA_RelWidth, -36,
														GA_RelHeight, -(win->BorderTop + win->BorderBottom + 10),
														GA_RelVerify, TRUE,
														PALETTE_NumColours, 1 << screen->RastPort.BitMap->Depth,
														TAG_END))
				{
					struct IntuiMessage *imsg;
					BOOL ok = TRUE;
		
					AddGList(win, palette_gad, -1, -1, NULL);
					RefreshGList(palette_gad, win, NULL, -1);

					/* Just wait around until the close gadget is pressed.
					 */
					while (ok)
					{
						struct Gadget *gadget;
		
						WaitPort(win->UserPort);
						while (imsg = (struct IntuiMessage *)GetMsg(win->UserPort))
						{
							switch(imsg->Class)
							{
								case IDCMP_CLOSEWINDOW:
									ok = FALSE;
									break;
		
								case IDCMP_GADGETUP:
									gadget = (struct Gadget *)imsg->IAddress;
									Printf("Gadget: %ld  Code: %ld\n",
									(LONG)gadget->GadgetID, (LONG)imsg->Code );
		
									break;
		
								default:
									break;
							}
							ReplyMsg((struct Message *)imsg);
						}
					}
					RemoveGList(win, palette_gad, -1);
					DisposeObject(palette_gad);
				}
				else
					PutStr("ERROR: Couldn't create Palette gadget\n");

				/* Free the class.
				 */
				PutStr("Freeing Palette class\n");
				CloseLibrary((struct Library *)PaletteBase);
			}
			else
				PutStr("ERROR: Couldn't create Palette class\n");

			CloseWindow(win);
		}
		else
			PutStr("ERROR: Couldn't open window\n");

	    UnlockPubScreen(0, screen);
	}
	else
		PutStr("ERROR: Couldn't lock public screen\n");
}


/* Open a class library.
 */
struct ClassLibrary * OpenClass(STRPTR name, ULONG version)
{
	struct Library *retval;
	UBYTE buffer[256];

	if ((retval = OpenLibrary(name, version)) == NULL)
	{
		sprintf (buffer, ":classes/%s", name);
		if ((retval = OpenLibrary(buffer, version)) == NULL)
		{
			sprintf(buffer, "classes/%s", name);
			retval = OpenLibrary(buffer, version);
		}
	}
	return((struct ClassLibrary *)retval);
}
