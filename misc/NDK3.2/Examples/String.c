;/* String Example
;NOSTACKCHECK is vital or the hook will crash when called!
sc LINK String.c LIB lib:reaction.lib NOSTACKCHECK
quit
*/

/**
 **  This is a simple example testing some of the capabilities of the
 **  string.gadget class.
 **
 **  This code opens a window and then creates 2 String gadgets which
 **  are subsequently attached to the window's gadget list.  One uses
 **  and edit hook, and the other does not.  Notice that you can tab
 **  cycle between them.
 **
 **  Note that string.gadget already provides a built-in SHK_PASSWORD
 **  hook; this example does not make use of it and instead
 **  demonstrates the use of a custom hook.
 **/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <exec/types.h>
#include <exec/memory.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <intuition/sghooks.h>	/* required for string hooks */
#include <graphics/gfxbase.h>
#include <graphics/text.h>
#include <graphics/gfxmacros.h>
#include <utility/tagitem.h>
#include <workbench/startup.h>
#include <workbench/workbench.h>
#include <reaction/reaction.h>
#include <reaction/reaction_macros.h>

#include <images/label.h>
#include <gadgets/string.h>
#include <classes/window.h>

#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/utility.h>
#include <proto/wb.h>
#include <proto/icon.h>
#include <clib/alib_protos.h>

#include <proto/button.h>
#include <proto/label.h>
#include <proto/layout.h>
#include <proto/string.h>
#include <proto/window.h>

enum
{
	GID_MAIN=0,
	GID_STRING1,
	GID_STRING2,
	GID_DOWN,
	GID_UP,
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


/* hook function typedef
 */
typedef ULONG (*HookFunction)(VOID);

/* hook function prototype
 */
ULONG __saveds __asm PasswordHook(
	register __a0 struct Hook *hook,
	register __a2 struct SGWork *sgw,
	register __a1 ULONG *msg);

#define SMAX 24

#define PASSWORDCHAR '*'

UBYTE initialstring[] = "Testing";

int main(void)
{
	struct MsgPort *AppPort;

	struct Window *windows[WID_LAST];

	struct Gadget *gadgets[GID_LAST];

	Object *objects[OID_LAST];

	/* make sure our classes opened... */
	if (!ButtonBase || !StringBase || !WindowBase || !LayoutBase)
		return(30);
	else if ( AppPort = CreateMsgPort() )
	{
		struct Hook edithook1;
		STRPTR hookdata1;

		/* The password edit hook needs special care, we need to look at
		 * edithook.h_Data to set/get the real password text. Additionally,
		 * we need to Alloc/Free maxchars bytes for its buffer!
		 */
		hookdata1 = (STRPTR)AllocVec( (SMAX + 2), MEMF_ANY | MEMF_CLEAR);

		if (hookdata1)
		{
			RA_SetUpHook(edithook1, PasswordHook, (STRPTR)hookdata1);

			/* copy real string data into the hidden buffer */
			strcpy(hookdata1, (STRPTR)initialstring);

			/* re-initialize real/visible string with password chars */
			memset((void *)initialstring, PASSWORDCHAR, strlen((STRPTR)initialstring));

			/* Create the window object.
			 */
			objects[OID_MAIN] = WindowObject,
				WA_ScreenTitle, "ReAction",
				WA_Title, "ReAction String Example",
				WA_Activate, TRUE,
				WA_DepthGadget, TRUE,
				WA_DragBar, TRUE,
				WA_CloseGadget, TRUE,
				WA_SizeGadget, TRUE,
				WINDOW_IconifyGadget, TRUE,
				WINDOW_IconTitle, "String",
				WINDOW_AppPort, AppPort,
				WINDOW_Position, WPOS_CENTERMOUSE,
				WINDOW_ParentGroup, gadgets[GID_MAIN] = VGroupObject,
					LAYOUT_SpaceOuter, TRUE,
					LAYOUT_DeferLayout, TRUE,

					LAYOUT_AddChild, gadgets[GID_STRING1] = StringObject,
						GA_ID, GID_STRING1,
						GA_RelVerify, TRUE,
						GA_TabCycle, TRUE,
						STRINGA_MinVisible, 10,
						STRINGA_MaxChars, SMAX,
					StringEnd,
					CHILD_NominalSize, TRUE,
					CHILD_Label, LabelObject, LABEL_Text, "String _1", LabelEnd,

					LAYOUT_AddChild, gadgets[GID_STRING2] = StringObject,
						GA_ID, GID_STRING2,
						GA_RelVerify, TRUE,
						GA_TabCycle, TRUE,
						STRINGA_MinVisible, 10,
						STRINGA_MaxChars, SMAX,
						STRINGA_EditHook, &edithook1,
						STRINGA_TextVal, initialstring,
					StringEnd,
					CHILD_Label, LabelObject, LABEL_Text, "String _2", LabelEnd,

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

					/* Activate the first string gadget!
					 */
					ActivateLayoutGadget( gadgets[GID_MAIN], windows[WID_MAIN], NULL, (Object) gadgets[GID_STRING1] );

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
											case GID_STRING1:
												printf( "Contents: %s\n", ((struct StringInfo *)(gadgets[GID_STRING1]->SpecialInfo))->Buffer);

												break;

											case GID_STRING2:
												printf( "Contents: %s\n", hookdata1 );
												break;

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

			/* free the password hook buffer
			 */
			FreeVec(hookdata1);
		}

		DeleteMsgPort(AppPort);
	}

	return(0);
}



/** Password Entry Hook
 **/

ULONG __saveds __asm PasswordHook(register __a0 struct Hook *hook, register __a2 struct SGWork *sgw, register __a1 ULONG *msg)
{
	STRPTR pass_ptr = (STRPTR)hook->h_Data;
	int    i;

	if(*msg == SGH_KEY)
	{
		switch (sgw->EditOp)
		{
			case EO_INSERTCHAR:
				if(pass_ptr)
				{
					for (i = sgw->NumChars; i >= sgw->BufferPos; i--)
					{	pass_ptr[i] = pass_ptr[i - 1];
					}
					pass_ptr[sgw->BufferPos - 1] = sgw->WorkBuffer[sgw->BufferPos - 1];
				}
    				sgw->WorkBuffer[sgw->BufferPos - 1] = (UBYTE)PASSWORDCHAR;
				break;

			case EO_DELBACKWARD:
			case EO_DELFORWARD:
				if(pass_ptr)
				{
					for (i = sgw->BufferPos; i <= sgw->NumChars; i++)
					{	pass_ptr[i] = pass_ptr[i + 1];
					}
				}
				break;

			default:
				if (sgw->EditOp != EO_MOVECURSOR)
				{
					sgw->Actions &= ~SGA_USE;
				}
		}

	        sgw->Actions |= SGA_REDISPLAY;
		return (~0L);
	}

	return 0L;
}
