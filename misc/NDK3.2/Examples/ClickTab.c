;/*
sc ClickTab.c LINK NOSTACKCHECK
quit
*/

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
#include <intuition/cghooks.h>
#include <intuition/icclass.h>
#include <intuition/classes.h>
#include <intuition/sghooks.h>
#include <graphics/gfxbase.h>
#include <graphics/text.h>
#include <graphics/gfxmacros.h>
#include <utility/tagitem.h>
#include <utility/hooks.h>
#include <reaction/reaction.h>
#include <reaction/reaction_macros.h>

#include <gadgets/clicktab.h>
#include <gadgets/layout.h>
#include <classes/window.h>

#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/gadtools.h>
#include <proto/utility.h>
#include <clib/alib_protos.h>
#include <clib/macros.h>

#include <proto/clicktab.h>
#include <proto/layout.h>
#include <proto/window.h>

#define ID_CLICKTAB		1

struct Library *ClickTabBase,
               *LayoutBase,
               *WindowBase;

struct List listitems;
UBYTE *names[] = 
{
    "Tab_1",
    "Tab_2",
    "Tab_3",
    "Tab_4",
    NULL
};

BOOL ClickTabNodes(struct List *list, UBYTE **labels)
{
	struct Node *node;
	WORD i = 0;

	NewList(list);

	while (*labels)
	{
		if (node = (struct Node *)AllocClickTabNode(
			TNA_Text, *labels,
			TNA_Number, i,
			TNA_Enabled, TRUE,
			TNA_Spacing, 6,
			TAG_DONE))
		{
			AddTail(list, node);
		}
		labels++;
		i++;
	}
	return(TRUE);
}

VOID FreeClickTabNodes(struct List *list)
{
	struct Node *node, *nextnode;

	node = list->lh_Head;
	while (nextnode = node->ln_Succ)
	{
		FreeClickTabNode(node);
		node = nextnode;
	}
	NewList(list);
}

int main( int argc, char *argv[] )
{
	struct Window *window;
	Object *Tab_Object;
	Object *Win_Object;

	/* Open the classes - typically not required to be done manually.
	 * SAS/C or DICE AutoInit can do this for you if linked with the
	 * supplied reaction.lib
	 */
	WindowBase   = OpenLibrary("window.class",            0L);
	LayoutBase   = OpenLibrary("gadgets/layout.gadget",   0L);
	ClickTabBase = OpenLibrary("gadgets/clicktab.gadget", 0L);

	if(WindowBase && LayoutBase && ClickTabBase)
	{
		ClickTabNodes(&listitems, names);

		/* Create the window object.
		 */
		Win_Object = WindowObject,
			WA_ScreenTitle, "ReAction",
			WA_Title, "ReAction clicktab.gadget Example",
			WA_SizeGadget, TRUE,
			WA_Left, 40,
			WA_Top, 30,
			WA_DepthGadget, TRUE,
			WA_DragBar, TRUE,
			WA_CloseGadget, TRUE,
			WA_Activate, TRUE,
			WA_SmartRefresh, TRUE,
			WINDOW_ParentGroup, VLayoutObject,
				LAYOUT_SpaceOuter, TRUE,
				LAYOUT_DeferLayout, TRUE,
				StartMember, Tab_Object = ClickTabObject,
					GA_ID, ID_CLICKTAB,
					CLICKTAB_Labels, &listitems,
					CLICKTAB_Current, 0L,
				EndMember,
			EndMember,
		EndWindow;

		/*  Object creation sucessful?
		 */
		if( Win_Object )
		{
			/*  Open the window.
			 */
			if( window = (struct Window *) RA_OpenWindow(Win_Object) )
			{
				ULONG wait, signal, result, done = FALSE;
				WORD Code;
				
				/* Obtain the window wait signal mask.
				 */
				GetAttr( WINDOW_SigMask, Win_Object, &signal );

				/* Input Event Loop
				 */
				while( !done )
				{
					wait = Wait(signal|SIGBREAKF_CTRL_C);
					
					if (wait & SIGBREAKF_CTRL_C) done = TRUE;
					else

					while ((result = RA_HandleInput(Win_Object,&Code)) != WMHI_LASTMSG)
					{
						switch (result & WMHI_CLASSMASK)
						{
							case WMHI_CLOSEWINDOW:
								done = TRUE;
								break;

							case WMHI_GADGETUP:
								switch(result & WMHI_GADGETMASK)
								{
									case ID_CLICKTAB:
										break;
								}
								break;
						}
					}
				}
			}

			/* Disposing of the window object will
			 * also close the window if it is
			 * already opened and it will dispose of
			 * all objects attached to it.
			 */
			DisposeObject( Win_Object );
		}

		FreeClickTabNodes(&listitems);
	}

	/* Close the classes.
	 */
	if (ClickTabBase)	CloseLibrary( (struct Library *)ClickTabBase );
	if (LayoutBase)		CloseLibrary( (struct Library *)LayoutBase );
	if (WindowBase)		CloseLibrary( (struct Library *)WindowBase );
}

#ifdef _DCC
int wbmain( struct WBStartup *wbs )
{
	return( main( 0, NULL ));
}
#endif
