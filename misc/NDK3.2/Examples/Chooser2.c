;/* Hidden Chooser Example
sc LINK Chooser2.c LIB lib:reaction.lib NOSTACKCHECK
quit
 */

/** This example demonstrates the "hidden mode" mode of the chooser gadget.
 ** You *must* have at least V41.101 or later installed.
 **
 ** Hidden choosers currently need to be handled differently than visible
 ** gadget objects. Since they are NOT added to the window, or layout group,
 ** they do not trigger a GADGETUP. So, you must use an IDCMPUPDATE hook
 ** and use the CHOOSER_Active notifications to get the selection.
 **/

#define USE_BUILTIN_MATH
#define USE_SYSBASE

#include <stdio.h>
#include <string.h>
#include <math.h>

#define	INTUI_V36_NAMES_ONLY

#include <exec/types.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <dos/dosextens.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <intuition/intuitionbase.h>
#include <intuition/classusr.h>
#include <intuition/imageclass.h>
#include <intuition/gadgetclass.h>
#include <intuition/icclass.h>
#include <intuition/cghooks.h>
#include <intuition/classes.h>
#include <graphics/gfxbase.h>
#include <graphics/text.h>
#include <graphics/gfxmacros.h>
#include <utility/tagitem.h>
#include <utility/hooks.h>
#include <reaction/reaction.h>
#include <reaction/reaction_macros.h>

#include <gadgets/chooser.h>
#include <images/label.h>
#include <gadgets/layout.h>
#include <classes/window.h>

#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/utility.h>
#include <clib/alib_protos.h>
#include <clib/macros.h>

#include <proto/button.h>
#include <proto/chooser.h>
#include <proto/label.h>
#include <proto/layout.h>
#include <proto/window.h>
#include <clib/reaction_lib_protos.h>

#define ID_BUTTON		1
#define ID_HIDDEN		2

/* Labels for the popup.
 */
UBYTE *chooser_strs[] =
{
	"Save Image",
	"Load Image",
	"Follow URL",
	"Save to HotList",
	NULL
};

/*************************************************************************
 * IDCMP hook
 */

void __asm __saveds IDCMPFunc(	register __a0 struct Hook *Hook,
								register __a2 Object *Window,
								register __a1 struct IntuiMessage *Msg )
{
	ULONG active;

	if (Msg->Class == IDCMP_IDCMPUPDATE)
	{
		/* The notification might include one of the tags we want to look at...
		 */
		if      (GetTagData(GA_ID, 0, Msg->IAddress) == ID_HIDDEN)
		{
			active = GetTagData(CHOOSER_Active, -1, Msg->IAddress);
			printf("active: %ld\n", active);
		}
	}
}


int main( int argc, char *argv[] )
{
	if (ButtonBase)
	{
		Object *Chooser_Object_Hidden;
		Object *Window_Object;
		struct Window *window;
		struct List *chooserlist;
		struct Hook idcmphook;

		idcmphook.h_Entry = (ULONG (* )())IDCMPFunc;
		idcmphook.h_SubEntry = NULL;

		chooserlist = ChooserLabelsA(chooser_strs);

		if (chooserlist)
		{
			/*	Create an instance of the chooser class that will remain hidden.
			*/
			Chooser_Object_Hidden = ChooserObject,
				GA_RelVerify, TRUE,
				GA_ID, ID_HIDDEN,
				CHOOSER_Labels, chooserlist,
				CHOOSER_DropDown, TRUE,
				CHOOSER_AutoFit, TRUE,
				CHOOSER_Hidden, TRUE,
				ICA_TARGET, ICTARGET_IDCMP,
			ChooserEnd;

			/* Create the window object. */
			Window_Object = WindowObject,
				WA_ScreenTitle, "ReAction",
				WA_Title, "ReAction Chooser Example 2",
				WA_SizeGadget, TRUE,
				WA_Left, 40,
				WA_Top, 30,
				WA_DepthGadget, TRUE,
				WA_DragBar, TRUE,
				WA_CloseGadget, TRUE,
				WA_Activate, TRUE,
				WA_SmartRefresh, TRUE,
				WA_IDCMP, IDCMP_GADGETUP|IDCMP_GADGETDOWN|IDCMP_IDCMPUPDATE,
				WINDOW_IDCMPHook, &idcmphook,	/* For BOOPSI notification */
				WINDOW_IDCMPHookBits, IDCMP_IDCMPUPDATE,
				WINDOW_ParentGroup, VGroupObject,
					LAYOUT_SpaceOuter, TRUE,
					LAYOUT_DeferLayout, TRUE,

					LAYOUT_AddChild, ButtonObject,
						GA_RelVerify, TRUE,
						GA_ID, ID_BUTTON,
						GA_Text, "Press me to show the hidden chooser!",
					ButtonEnd,
					CHILD_WeightedHeight, 0,

					LAYOUT_AddChild, VGroupObject,
						LAYOUT_BackFill, NULL,
						LAYOUT_SpaceOuter, TRUE,
						LAYOUT_VertAlignment, LALIGN_CENTER,
						LAYOUT_HorizAlignment, LALIGN_CENTER,
						LAYOUT_BevelStyle, BVS_FIELD,

						LAYOUT_AddImage, LabelObject,
							LABEL_Text, "Selecting the button above will\n",
							LABEL_Text, "reveal the hidden popup chooser!\n\n",
							LABEL_Text, "Hidden choosers are useful for\n",
							LABEL_Text, "context sensitive quick menus.",
						LabelEnd,

					LayoutEnd,
				LayoutEnd,
			WindowEnd;

			/*  Object creation sucessful?
			 */
			if( Window_Object )
			{
				/*  Open the window.
				 */
				if( window = (struct Window *) RA_OpenWindow(Window_Object) )
				{
					ULONG wait, signal, result, done = FALSE;
					WORD Code;
					
					/* Obtain the window wait signal mask.
					 */
					GetAttr( WINDOW_SigMask, Window_Object, &signal );

					/* Input Event Loop
					 */
					while( !done )
					{
						wait = Wait(signal|SIGBREAKF_CTRL_C);
						
						if (wait & SIGBREAKF_CTRL_C) done = TRUE;
						else

						while ((result = RA_HandleInput(Window_Object,&Code)) != WMHI_LASTMSG)
						{
							switch (result & WMHI_CLASSMASK)
							{
								case WMHI_CLOSEWINDOW:
									done = TRUE;
									break;

								case WMHI_GADGETUP:
									switch(result & WMHI_GADGETMASK)
									{
										case ID_BUTTON:
											ActivateGadget((struct Gadget *)Chooser_Object_Hidden, window, NULL);
											break;

									}
									break;
							}
						}
					}
				}

				/* Disposing of the window object will also close the window if it is
				 * already opened and it will dispose of all objects attached to it.
				 */
				DisposeObject( Window_Object );

				/* The hidden chooser isn't attached to anything, so we must dispose
				 * it ourselves...
				 */
				DisposeObject( Chooser_Object_Hidden );
			}
		}
		FreeChooserLabels(chooserlist);
	}
}
