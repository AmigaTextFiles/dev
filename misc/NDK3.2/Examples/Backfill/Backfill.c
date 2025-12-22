;/*
sc Backfill.c ImageBackFill.c LINK LIB lib:reaction.lib NOSTACKCHECK
quit
*/

#include <exec/types.h>
#include <exec/memory.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <intuition/icclass.h>
#include <libraries/gadtools.h>
#include <graphics/gfxbase.h>
#include <graphics/text.h>
#include <graphics/gfxmacros.h>
#include <utility/tagitem.h>
#include <workbench/startup.h>
#include <workbench/workbench.h>
#include <datatypes/datatypes.h>
#include <datatypes/datatypesclass.h>
#include <reaction/reaction.h>
#include <reaction/reaction_macros.h>

#include <images/label.h>
#include <gadgets/layout.h>
#include <classes/window.h>

#include <proto/datatypes.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/diskfont.h>
#include <proto/utility.h>
#include <proto/wb.h>
#include <proto/icon.h>
#include <clib/alib_protos.h>

#include <proto/button.h>
#include <proto/label.h>
#include <proto/layout.h>
#include <proto/window.h>
#include <clib/reaction_lib_protos.h>

#include "imagebackfill.h"

/*************************************************************************
 * Backfill options
 * We're using the public domain LayerHook here.
 */
struct BackFillOptions Options =
{
	256,256,
	// !!! 0,0,
	TRUE,FALSE,
	0,0,
	TRUE
};

struct BackFillInfo BF1, BF2, *Backfill;

UBYTE name[256];

/*************************************************************************
 * Gadget list
 * This wouldn't be strictly necessary, but it's an easy way of keeping
 * the gadget pointers for when we need to access the gadgets.
 */
typedef enum { G_Backfill = 1, G_Datatype, G_MAX } GadgetIDs;
 
struct Gadget *GL[G_MAX+1];

/*************************************************************************
 * App message hook.
 * Workbench App messages can be caught with a callback hook such as this.
 * We'll not worry about the app message type in this hook. Objects dropped
 * on the window or on the icon (while iconified) will be added to the 
 * listview.
 */

void __asm __saveds AppMsgFunc(	register __a0 struct Hook *Hook,
								register __a2 Object *Window,
								register __a1 struct AppMessage *Msg )
{
	struct Window *Win;
	struct WBArg *arg = Msg->am_ArgList;
	Object *dt;
	
	GetAttr( WINDOW_Window, Window, (ULONG *)&Win );

	NameFromLock( arg->wa_Lock, name, sizeof(name) );
	AddPart( name, arg->wa_Name, sizeof(name) );
	
	dt = NewDTObject( name, 
					DTA_GroupID, GID_PICTURE, 
					ICA_TARGET, ICTARGET_IDCMP,
					TAG_END );
	
	if (dt)
	{
		SetGadgetAttrs( (struct Gadget *)Hook->h_Data, Win, NULL,
						LAYOUT_ModifyChild, GL[G_Datatype],
						CHILD_ReplaceObject, dt,
						TAG_END );
		GL[G_Datatype] = (struct Gadget *)dt;
		RethinkLayout( (struct Gadget *)Hook->h_Data, Win, NULL, FALSE );
	}
}

struct Hook apphook;

/*************************************************************************
 * IDCMP hook
 */

void __asm __saveds IDCMPFunc(	register __a0 struct Hook *Hook,
								register __a2 Object *Window,
								register __a1 struct IntuiMessage *Msg )
{
	struct Window *Win;
	
	GetAttr( WINDOW_Window, Window, (ULONG *)&Win );

	if (Msg->Class == IDCMP_IDCMPUPDATE)
	{
		if ( GetTagData( DTA_Sync, FALSE, Msg->IAddress ) )
		{
			RefreshGList( (struct Gadget *)Hook->h_Data, Win, NULL, 1 );
		}
	}
}

struct Hook idcmphook;

/*************************************************************************
 * This function creates our gadgets for the window.
 */
Object *CreateLayout(void)
{
	return VGroupObject, Offset(32,32,32,32),
		LAYOUT_BevelStyle, BVS_THIN,
					
		/* this tag instructs layout.gadget to defer GM_LAYOUT and GM_RENDER and ask
		 * the windowclass to do them. This lessens the load on input.device 
		 */
		LAYOUT_DeferLayout, TRUE,
		
		/* this gives us a backfill
		 */
		LAYOUT_BackFill, Backfill,
		
		/* this dummy object will be replaced with a datatype when we have a picture
		 */
		StartMember, apphook.h_Data = idcmphook.h_Data = LayoutObject, VCentered, HCentered,
			LAYOUT_BevelStyle, BVS_THIN,
			LAYOUT_BevelState, IDS_SELECTED,
			LAYOUT_SpaceOuter, TRUE,
		
			/* We need to install this clearing backfill hook because
			 * most of the datatypes really screw up rendering if the
			 * background isn't color 0.
			 */
			LAYOUT_BackFill, LAYERS_BACKFILL,
			StartImage, GL[G_Datatype] = LabelObject,
				LABEL_Text, "Please drop picture icons on this window",
			EndImage,
			CHILD_MinHeight, 128,
		EndMember,
		
		StartMember, GL[G_Backfill] = ButtonObject,
			GA_Text, "Use as a backfill",
			GA_ID, G_Backfill,
			GA_RelVerify, TRUE,
		EndMember,
		CHILD_WeightedHeight, 0,
	EndGroup;
}
				
/*************************************************************************
 * Main Program
 */
int 
main(void)
{
	struct MsgPort *appport;
	struct Screen *Scr;

	if (!ButtonBase) /* force it open */
		return 30;
		
	/* By providing a message port you enable windowclass to handle iconification
	 * and appwindows. This port can shared by all the windows of your application.
	 */
	appport = CreateMsgPort();
	Scr = LockPubScreen(NULL);

	if (appport && Scr)
	{
		Object *Window;
		
		apphook.h_Entry = (ULONG (* )())AppMsgFunc;
		apphook.h_SubEntry = NULL;

		idcmphook.h_Entry = (ULONG (* )())IDCMPFunc;
		idcmphook.h_SubEntry = NULL;
		
		/* Create a Window object with a Layout. When Window is asked to open itself,
		 * it will calculate how much space the Layout needs and size itself accordingly.
		 */
	
		Window = WindowObject,
				
				/* these tags describe the window 
				 */
		
				WA_IDCMP, IDCMP_RAWKEY,
				WA_Top, 20,
				WA_Left, 20,
				WA_SizeGadget, TRUE,
				WA_DepthGadget, TRUE,
				WA_DragBar, TRUE,
				WA_CloseGadget, TRUE,
				WA_Activate, TRUE,
				
				WA_Title, "ReAction backfill/datatype example",
				WA_ScreenTitle, "ReAction",
				
				/* Add an iconification gadget. If you have this, you must listen to
				 * WMHI_ICONIFY.
				 */
				 
				WINDOW_IconifyGadget, TRUE,
				
				/* This message port lets windowclass handle the icon and appwindow.
				 */
				 
				WINDOW_AppPort, appport,
				WINDOW_AppWindow, TRUE,
				WINDOW_AppMsgHook, &apphook,
				
				/* This sets up windowclass to relay IDCMPUPDATE messages to the
				 * application's hook.
				 */
				 
				WINDOW_IDCMPHook, &idcmphook,
				WINDOW_IDCMPHookBits, IDCMP_IDCMPUPDATE,
				
				/* The windowclass will automatically free the DiskObject used when
				 * iconifying the window. If you do not provide a valid DiskObject,
				 * windowclass will try to use env:sys/def_window.info or the default
				 * project icon.
				 */
				
				WINDOW_Icon, GetDiskObject( "BackfillExample" ),
				WINDOW_IconTitle, "ReAction Example",
				
				/* Below is the layout of the window 
				 */
				
				WINDOW_Layout, CreateLayout(),
			EndWindow;
	
		if (Window)
		{
			/* Window pointer cache.
			 */
		
			struct Window *Win;
			BOOL changebackfill = FALSE;
		
			if (Win = RA_OpenWindow( Window ))
			{
				ULONG wsig, asig = 1L << appport->mp_SigBit;
				BOOL done = FALSE;
				
				/* Now that the window has been opened, we can get the signal mask
				 * of its user port. If the program supported iconification and didn't
				 * use a shared IDCMP port between all windows, this signal bit
				 * would have to be re-queried before each Wait().
				 */
				
				GetAttr( WINDOW_SigMask, Window, &wsig );
	
				while (done == FALSE)
				{
					ULONG sig = Wait(wsig | asig | SIGBREAKF_CTRL_C);
					ULONG result;
					UWORD code;

					if (sig & (wsig | asig))
					{
						/* Messages waiting at the window's IDCMP port. Loop at WM_HANDLEINPUT
						 * until all have been processed.
						 */
					
						while ((result = RA_HandleInput(Window,&code)) != WMHI_LASTMSG)
						{
							/* The return code of this method is two-part. The upper word describes the
							 * class of the message (gadgetup, menupick, closewindow, iconify, etc),
							 * and the lower word is a class-defined ID, currently in use in the
							 * gadgetup and menupick return codes.
							 * Switch on the class, then on the ID.
							 */
						
							switch(result & WMHI_CLASSMASK)
							{
							case WMHI_GADGETUP:
							
								/* OK, got a gadgetup from something. Lets find out what the something is.
								 * The code WORD to which a pointer was passed to WM_HANDLEINPUT has been
								 * set to the Code value from the IDCMP_GADGETUP, in case we need it.
								 */
							
								switch(result & WMHI_GADGETMASK)
								{
								case G_Backfill:
									changebackfill = TRUE;
									break;
								}
								break;
								
							case WMHI_CLOSEWINDOW:
								/* The window close gadget was hit. Time to die...
								 */
								done = TRUE;
								break;
								
							case WMHI_ICONIFY:
								/* Window requests that it be iconified. Handle this event as
								 * soon as possible. The window is not iconified automatically to
								 * give you a chance to make note that the window pointer will be 
								 * invalid before the window closes. It also allows you to free
								 * resources only needed when the window is open, if you wish to.
								 */
								if (RA_Iconify( Window ))
									Win = NULL;
								break;
								 
							case WMHI_UNICONIFY:
								/* The window should be reopened. If you had free'd something
								 * on iconify, now is the time to re-allocate it, before calling
								 * RA_OpenWindow.
								 */
								Win = RA_OpenWindow( Window );
								break;
							}
						}
					}
					else if (sig & SIGBREAKF_CTRL_C)
					{
						done = TRUE;
					}
					
					if (changebackfill)
					{
						Object *layout;
					
						/* This is a quick&dirty demo using an unmodified LayerHook (on Aminet).
						 * This hook can not change its source bitmap on the fly.
						 * Becaue of this, we have to do a bit of a juggling act to
						 * replace the current backfill.
						 */
						if (Backfill == &BF1)
						{
							Backfill = NULL;
							if (LoadBackgroundImage( &BF2, name, Scr, &Options ))
							{
								Backfill = &BF2;
							}
						}
						else
						{
							Backfill = NULL;
							if (LoadBackgroundImage( &BF1, name, Scr, &Options ))
							{
								Backfill = &BF1;
							}
						}
						if (layout = CreateLayout())
						{
							SetAttrs(Window, WINDOW_Layout, layout, TAG_END);
							/* backfill changed, it's not safe to dispose the old
							 * one. */
							UnloadBackgroundImage((Backfill == &BF1) ? &BF2 : &BF1);
						}
						else
						{
							/* layout failed */
							UnloadBackgroundImage(Backfill);
						}
						changebackfill = FALSE;
					}
				}
				/* Close the window and dispose of all attached gadgets 
				 */
				DisposeObject( Window );
			}
		}
	}
	
	if (appport)
		DeleteMsgPort(appport);
	if (Scr)
		UnlockPubScreen(NULL,Scr);
}
