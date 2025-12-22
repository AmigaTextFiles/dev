;/* Weighted layout example
sc LINK Layout1.c LIB lib:reaction.lib NOSTACKCHECK
quit
*/

/* In this example we will NOT use window.class - just to show it is possible.
 * Note, we do *NOT* recommend this. Window.class offers automatic prefs refresh,
 * and support for window backfills, iconification and keyboard control!
 */

#include <exec/types.h>
#include <exec/memory.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <intuition/icclass.h>
#include <graphics/gfxbase.h>
#include <graphics/text.h>
#include <graphics/gfxmacros.h>
#include <utility/tagitem.h>
#include <reaction/reaction.h>
#include <reaction/reaction_macros.h>

#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/diskfont.h>
#include <proto/utility.h>

#include <proto/button.h>
#include <proto/layout.h>

/*************************************************************************
 * Main Program
 */
int main(argc,argv)
	int argc;
	char *argv[];
{
	struct Screen *Scr = NULL;
	struct Window *Win = NULL;
	struct Gadget *gParent = NULL;

	if (!ButtonBase)
		return(20);

	if(argc > 1)
		Scr = LockPubScreen(argv[1]);
	else
		Scr = LockPubScreen("Workbench");

	if (Scr == NULL)
	{
		/* Shut down, no screen lock
		 */ 
		Printf("Failed locking public screen.\n");
		return(5);
	}

	/* In this example we will create the layout group before opening
	 * the window, and size the window to the minimum layout size
	 * returned by the LayoutLimits() function, then SetGadgetAttr()
	 * will be used to cause the GREL layout group to resize with the window.
	 */

	gParent = VGroupObject,
		ICA_TARGET, ICTARGET_IDCMP,

		LAYOUT_SpaceOuter, TRUE,
		LAYOUT_BevelStyle, BVS_GROUP,
		LAYOUT_DeferLayout, TRUE,	/* this tag instructs layout.gadget to
									 * defer GM_LAYOUT and GM_RENDER and ask
									 * the application to do them. This
									 * lessens the load on input.device
									 */
		LAYOUT_AddChild, HGroupObject,
				LAYOUT_SpaceOuter, FALSE,
				LAYOUT_AddChild, HGroupObject,
						LAYOUT_SpaceOuter, TRUE,
						/* the first group is three label-less buttons
						 * side by side
						 */
						LAYOUT_BevelStyle, BVS_GROUP,
						LAYOUT_Label, "Horizontal",
						LAYOUT_AddChild, ButtonObject,
							End,
						LAYOUT_AddChild, ButtonObject,
							End,
						LAYOUT_AddChild, ButtonObject,
							End,
					End,

				LAYOUT_AddChild, VGroupObject,
						LAYOUT_SpaceOuter, TRUE,
						/* the second group is three label-less buttons
						 * in a vertical group
						 */
						LAYOUT_BevelStyle, BVS_GROUP,
						LAYOUT_Label, "Vertical",
						LAYOUT_AddChild, ButtonObject,
							End,
						LAYOUT_AddChild, ButtonObject,
							End,
						LAYOUT_AddChild, ButtonObject,
							End,
					End,
			End,

		LAYOUT_AddChild, HGroupObject,
				/* four buttons of varying widths */
				LAYOUT_BevelStyle, BVS_SBAR_VERT,
				LAYOUT_Label, "Free, Fixed and Weighted sizes.",
				LAYOUT_AddChild, ButtonObject,
						GA_Text, "25Kg",
					End,
					CHILD_WeightedWidth, 25,

				LAYOUT_AddChild, ButtonObject,
						GA_Text, "50Kg",
					End,
					CHILD_WeightedWidth, 50,

				LAYOUT_AddChild, ButtonObject,
						GA_Text, "75Kg",
					End,
					CHILD_WeightedWidth, 75,

				LAYOUT_AddChild, ButtonObject,
						GA_Text, "100Kg",
					End,
					CHILD_WeightedWidth, 100,
			End,
			CHILD_WeightedHeight,0,

		LAYOUT_AddChild, HGroupObject,
				/* four buttons sized in another way */
				LAYOUT_AddChild, ButtonObject,
						GA_Text, "Free",
					End,

				LAYOUT_AddChild, ButtonObject,
						GA_Text, "Fixed",
					End,
					CHILD_WeightedWidth, 0,

				LAYOUT_AddChild, ButtonObject,
						GA_Text, "Free",
					End,

				LAYOUT_AddChild, ButtonObject,
						GA_Text, "Fixed",
					End,
					CHILD_WeightedWidth, 0,
			End,
			CHILD_WeightedHeight,0,
			CHILD_MinWidth, 300,

		End;

	if (gParent)
	{
		struct LayoutLimits Limits;
		struct TextFont *font = OpenFont( Scr->Font );

		/* Query parent layout group for min/max layout limits. */
		LayoutLimits( gParent, &Limits, font, Scr );

		CloseFont( font );

		if (Win = OpenWindowTags(NULL,
			WA_Flags, WFLG_DEPTHGADGET | WFLG_DRAGBAR |
				WFLG_CLOSEGADGET | WFLG_ACTIVATE | WFLG_SIZEGADGET,
			WA_IDCMP, IDCMP_CLOSEWINDOW | IDCMP_IDCMPUPDATE,
			WA_Top, 20,
			WA_Left, 20,
			WA_InnerWidth, Limits.MinWidth,		/* open the window at the minimum */
			WA_InnerHeight, Limits.MinHeight,	/* size in which the layout fits */
			WA_NoCareRefresh, TRUE,	/* only BOOPSI here, no need for separate refreshing */
			WA_PubScreen, Scr,
			WA_Title, "ReAction Weighted Layout Example",
			WA_ScreenTitle, "ReAction",
			TAG_END))
		{
			ULONG wsig = 1L << Win->UserPort->mp_SigBit;
			struct IntuiMessage *msg;
			BOOL done = FALSE;

			WORD BorderWidth = Win->BorderLeft + Win->BorderRight;
			WORD BorderHeight = Win->BorderTop + Win->BorderBottom;

			/* set the window minimum and maximum size to the limits of the layout */
			WindowLimits(Win,
						Limits.MinWidth + BorderWidth,
						Limits.MinHeight + BorderHeight,
						Limits.MaxWidth + BorderWidth,
						Limits.MaxHeight + BorderHeight);

			/* make the layout group resize itself relative to window size */
			SetGadgetAttrs( gParent, NULL, NULL, 
						GA_Top, Win->BorderTop,
						GA_Left, Win->BorderLeft,
						GA_RelWidth, -BorderWidth,
						GA_RelHeight, -BorderHeight,
						TAG_END);

			/* make the layout visible */
			AddGadget(Win, gParent, -1);
			RefreshGList(gParent, Win, NULL, 1);

			while (done == FALSE)
			{
				ULONG sig = Wait(wsig | SIGBREAKF_CTRL_C);

				if (sig & wsig)
				{
					while (msg = (struct IntuiMessage *) GetMsg(Win->UserPort))
					{
						/* If you chooser to reply to the message before processing
						 * it, remember that for IDCMP_IDCMPUPDATE the IAddress
						 * field points to a tag list that will get free'd on reply.
						 *
						 * Before replying, check if the message is IDCMPUPDATE
						 * and CloneTagItems(msg->IAddress). Don't forget to
						 * FreeTagItems() your cloned list after you have
						 * processed it.
						 */
					
						switch (msg->Class)
						{
							case IDCMP_CLOSEWINDOW:
								 done = TRUE;
								 break;
								 
							case IDCMP_IDCMPUPDATE:
								{
									/* These are the deferred layout specific event 
									 * handlers. This is not as sophisticated as
									 * window.class's internal logic, but it will suffice.
									 */
									if (FindTagItem(LAYOUT_RequestRefresh,msg->IAddress))
									{
										/*	Intuition attempted to refresh the window,
										 *	layout.gadget sent this message to the application.
										 *	We now do the refresh. This is done here because
										 *	refreshing a very complex layout could take some
										 *	time, and doing it in input.device context makes
										 *	the pointer jumpy.
										 *	RefreshWindowFrame() will refresh not only the
										 *	window border but also all gadgets. 
										 *	RefreshGList(gParent, Win, NULL, 1);
										 */
										RefreshWindowFrame( Win );
										break;
									}
									else if (FindTagItem(LAYOUT_RequestLayout,msg->IAddress))
									{
										/*	GM_LAYOUT can be a slow operation, so we don't
										 *	want it to be done my input.device...
										 */
										RethinkLayout(gParent, Win, NULL, FALSE );
										break;
									}
									else if (FindTagItem(LAYOUT_RelVerify,msg->IAddress))											
									{
										/* LAYOUT_RelVerify matches an IDCMP_GADGETUP,
										 * which is somewhat restricted because of
										 * Intuition limitations....
										 */
										
										switch ( GetTagData(GA_ID,0,msg->IAddress) )
										{
											default:
												done = TRUE;
												break;
										}
										break;
									}
								}
								break;

							default:
								break;
						}

						ReplyMsg((struct Message *) msg);
					}
				}
				else if (sig & SIGBREAKF_CTRL_C)
				{
					done = TRUE;
				}
			}

			RemoveGadget(Win, gParent);
			CloseWindow(Win);
		}

		/* Disposing a layout instance will automatically dispose
		 * all the child objects.
		 */
		DisposeObject(gParent);
	}

	UnlockPubScreen(0, Scr);

	return 0;
}
