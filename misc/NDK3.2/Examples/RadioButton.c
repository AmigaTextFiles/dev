;/* RadioButton Example
sc RadioButton.c LINK LIB lib:reaction.lib NOSTACKCHECK
quit
*/

/**
 **  RadioButton class example.
 **
 **  This is a simple example testing some of the capabilities of the
 **  radiobutton gadget class.
 **
 **  This opens a window with radio button gadget. We will use reaction.lib's
 **  RadioButtons() and FreeRadioButtons() utility functions to create the
 **  item labels.
 **
 **/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <exec/types.h>
#include <exec/memory.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <graphics/gfxbase.h>
#include <graphics/text.h>
#include <graphics/gfxmacros.h>
#include <utility/tagitem.h>
#include <workbench/startup.h>
#include <workbench/workbench.h>
#include <reaction/reaction.h>
#include <reaction/reaction_macros.h>

#include <gadgets/radiobutton.h>
#include <classes/window.h>

#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/utility.h>
#include <proto/wb.h>
#include <proto/icon.h>
#include <clib/alib_protos.h>
#include <clib/reaction_lib_protos.h>

#include <proto/button.h>
#include <proto/layout.h>
#include <proto/radiobutton.h>
#include <proto/window.h>

/* button option texts
 */
UBYTE *radio[] =
{
	"2400",
	"9600",
	"19200",
	"38400",
	NULL
};

enum
{
	GID_MAIN=0,
	GID_RADIOBUTTON,
	GID_QUIT,
	GID_LAST
};

enum
{
	WID_MAIN=0,
	WID_LAST
};

enum
{
	OID_MAIN=0,
	OID_LAST
};

#define FMIN 0
#define FMAX 100

int main(void)
{
	struct MsgPort *AppPort;

	struct Window *windows[WID_LAST];

	struct Gadget *gadgets[GID_LAST];

	Object *objects[OID_LAST];

	struct List *radiolist;

	/* make sure our classes opened... */
	if (!ButtonBase || !RadioButtonBase || !WindowBase || !LayoutBase)
		return(30);
	else if ( AppPort = CreateMsgPort() )
	{
		/* Create radiobutton label list.
		 */
		radiolist = RadioButtons( "1200","2400","4800","9600","19200","38400","57600", NULL );

		if (radiolist)
		{
			/* Create the window object.
			 */
			objects[OID_MAIN] = WindowObject,
				WA_ScreenTitle, "ReAction",
				WA_Title, "ReAction RadioButton Example",
				WA_Activate, TRUE,
				WA_DepthGadget, TRUE,
				WA_DragBar, TRUE,
				WA_CloseGadget, TRUE,
				WA_SizeGadget, TRUE,
				WINDOW_IconifyGadget, TRUE,
				WINDOW_IconTitle, "RadioButton",
				WINDOW_AppPort, AppPort,
				WINDOW_Position, WPOS_CENTERMOUSE,
				WINDOW_ParentGroup, gadgets[GID_MAIN] = VGroupObject,
					LAYOUT_SpaceOuter, TRUE,
					LAYOUT_DeferLayout, TRUE,

					LAYOUT_AddChild, VGroupObject,
						LAYOUT_SpaceOuter, TRUE,
						LAYOUT_BevelStyle, BVS_GROUP,
						LAYOUT_Label, "Baud Rate",

						LAYOUT_AddChild, gadgets[GID_RADIOBUTTON] = RadioButtonObject,
							GA_ID, GID_RADIOBUTTON,
							GA_RelVerify, TRUE,
							RADIOBUTTON_Labels, radiolist,
							RADIOBUTTON_Selected, 0,
						RadioButtonEnd,
					//	CHILD_WeightedHeight, 0,
					LayoutEnd,

					LAYOUT_AddChild, ButtonObject,
						GA_ID, GID_QUIT,
						GA_RelVerify, TRUE,
						GA_Text,"_Quit",
					ButtonEnd,
					CHILD_WeightedHeight, 0,

				EndGroup,
			EndWindow;

	 	 	/*  Object creation sucessful?
	 	 	 */
			if (objects[OID_MAIN])
			{
				/*  Open the window.
				 */
				if (windows[WID_MAIN] = (struct Window *) RA_OpenWindow(objects[OID_MAIN]))
				{
					ULONG wait, signal, app = (1L << AppPort->mp_SigBit);
					ULONG done = FALSE;
					ULONG result;
					UWORD code;

				 	/* Obtain the window wait signal mask.
					 */
					GetAttr(WINDOW_SigMask, objects[OID_MAIN], &signal);

					/* Input Event Loop
					 */
					while (!done)
					{
						wait = Wait( signal | SIGBREAKF_CTRL_C | app );

						if ( wait & SIGBREAKF_CTRL_C )
						{
							done = TRUE;
						}
						else
						{
							while ( (result = RA_HandleInput(objects[OID_MAIN], &code) ) != WMHI_LASTMSG )
							{
								switch (result & WMHI_CLASSMASK)
								{
									case WMHI_CLOSEWINDOW:
										windows[WID_MAIN] = NULL;
										done = TRUE;
										break;

									case WMHI_GADGETUP:
										switch (result & WMHI_GADGETMASK)
										{
											case GID_QUIT:
												done = TRUE;
												break;
										}
										break;

									case WMHI_ICONIFY:
										RA_Iconify(objects[OID_MAIN]);
										windows[WID_MAIN] = NULL;
										break;

									case WMHI_UNICONIFY:
										windows[WID_MAIN] = (struct Window *) RA_OpenWindow(objects[OID_MAIN]);

										if (windows[WID_MAIN])
										{
											GetAttr(WINDOW_SigMask, objects[OID_MAIN], &signal);
										}
										else
										{
											done = TRUE;	// error re-opening window!
										}
									 	break;
								}
							}
						}
					}
				}

				/* Disposing of the window object will also close the window if it is
				 * already opened, and it will dispose of the layout object attached to it.
				 */
				DisposeObject(objects[OID_MAIN]);
			}

			/* free the radiobutton list
			 */
			FreeRadioButtons(radiolist);
		}

		DeleteMsgPort(AppPort);
	}

	return(0);
}
