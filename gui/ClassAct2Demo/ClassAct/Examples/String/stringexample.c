;/* String Example
sc link stringexample.c lib lib:classact.lib
quit
*/

/**
 **  StringExample.c -- String class Example.
 **
 **  This is a simple example testing some of the capabilities of the
 **  String gadget class.
 **
 **  This code opens a window and then creates 2 String gadgets which
 **  are subsequently attached to the window's gadget list.  One uses
 **  and edit hook, and the other does not.  Notice that you can tab
 **  cycle between them.
 **/

/* system includes
 */
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

#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/utility.h>
#include <proto/wb.h>
#include <proto/icon.h>

/* ClassAct includes
 */
#include <classact.h>


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
			CA_SetUpHook(edithook1, PasswordHook, (STRPTR)hookdata1);

			/* copy real string data into the hidden buffer */
			strcpy(hookdata1, (STRPTR)initialstring);

			/* re-initialize real/visible string with password chars */
			memset((void *)initialstring, PASSWORDCHAR, strlen((STRPTR)initialstring));

			/* Create the window object.
			 */
			objects[OID_MAIN] = WindowObject,
				WA_ScreenTitle, "ClassAct Release 2.0",
				WA_Title, "ClassAct String Example",
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
				if (windows[WID_MAIN] = (struct Window *) CA_OpenWindow(objects[OID_MAIN]))
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
					ActivateLayoutGadget( gadgets[GID_MAIN], windows[WID_MAIN], NULL, gadgets[GID_STRING1] );

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
							while ( (result = CA_HandleInput(objects[OID_MAIN], &code) ) != WMHI_LASTMSG )
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
										CA_Iconify(objects[OID_MAIN]);
										windows[WID_MAIN] = NULL;
										break;

									case WMHI_UNICONIFY:
										windows[WID_MAIN] = (struct Window *) CA_OpenWindow(objects[OID_MAIN]);

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

	sgw->BufferPos = sgw->NumChars;

	if(*msg == SGH_KEY)
	{
		switch (sgw->EditOp)
		{
			case EO_INSERTCHAR:
				if(pass_ptr)
				{
					pass_ptr[sgw->BufferPos - 1] = sgw->WorkBuffer[sgw->BufferPos - 1];
					pass_ptr[sgw->BufferPos] = '\0';
				}
    			sgw->WorkBuffer[sgw->BufferPos - 1] = (UBYTE)PASSWORDCHAR;
				break;

			case EO_DELBACKWARD:
				if(pass_ptr)
				{
					pass_ptr[sgw->BufferPos] = '\0';
				}
				break;

			default:
				sgw->Actions &= ~SGA_USE;
				break;
		}

        sgw->Actions |= SGA_REDISPLAY;
		return (~0L);
	}
	if(*msg == SGH_CLICK)
	{
		sgw->BufferPos = sgw->NumChars;
		return (~0L);
	}
	return(0L);
}
