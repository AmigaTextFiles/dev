;/*
sc Requester.c LINK NOSTACKCHECK
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

#include <clib/macros.h>
#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/utility_protos.h>
#include <clib/requester_protos.h>
#include <clib/button_protos.h>
#include <clib/alib_protos.h>

#include <pragmas/intuition_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/exec_pragmas.h>
#include <pragmas/gadtools_pragmas.h>
#include <pragmas/utility_pragmas.h>
#include <pragmas/requester_pragmas.h>
#include <pragmas/button_pragmas.h>

#define ALL_REACTION_CLASSES
#define ALL_REACTION_MACROS
#include <reaction/reaction.h>
// #include <reaction/reaction_author.h>

#include <classes/requester.h>
#include <classes/window.h>
#include <gadgets/button.h>
#include <gadgets/layout.h>

struct Library *WindowBase;
struct Library *LayoutBase;
struct Library *RequesterBase;
struct Library *ButtonBase;
struct Library *LabelBase;
struct IntuitionBase *IntuitionBase;

#define ID_BUTTON		1

ULONG OpenRequesterTags(Object *obj, struct Window *win, Tag, ...);

UBYTE *chooserlabels[] =
{
	"Label 1",
	"Label 2",
	"Label 3",
	"Label 4",
	NULL,
};

int main( int argc, char *argv[] )
{
	struct Window *window;
	Object *But_Object, *Req_Object;
	Object *Win_Object;
	UBYTE buffer[128] = "Edit me!";
	ULONG number = 0;

        IntuitionBase = (struct IntuitionBase*) OpenLibrary("intuition.library",36L);

	/* Open the classes - typically not required to be done manually.
	 * SAS/C or DICE AutoInit can do this for you if linked with the
	 * supplied classact.lib
	 */
	WindowBase = OpenLibrary("window.class",0L);
	RequesterBase = OpenLibrary("requester.class",0L);
	LayoutBase = OpenLibrary("gadgets/layout.gadget",0L);
	ButtonBase = OpenLibrary("gadgets/button.gadget",0L);
	LabelBase = OpenLibrary("images/label.image",0L);

	if(IntuitionBase && WindowBase && LayoutBase && RequesterBase && ButtonBase && LabelBase)
	{
		Req_Object = RequesterObject,
			REQ_TitleText, "Simple requester.class example",
		EndMember,

		/* Create the window object. */
		Win_Object = WindowObject,
			WA_ScreenTitle, "ReAction",
			WA_Title, "ReAction Requester Example",
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
				StartMember, But_Object = ButtonObject,
					GA_RelVerify, TRUE,
					GA_ID, ID_BUTTON,
					GA_Text, "_Press Me!",
				ButtonEnd,
				CHILD_MinWidth, 100,
				CHILD_WeightedHeight, 0,
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
				ULONG wait, signal, result, done = FALSE, retval;
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
									case ID_BUTTON:
										/* IMPORTANT: Note how the \33 sequence is not used for selecting pens! */
										retval = OpenRequesterTags(Req_Object, window, 
													REQ_Type, REQTYPE_INFO, 
													REQ_BodyText, "\33b\33c\33f[cgtimes.font/50]Information\nfor\nyou.",
													REQ_GadgetText, "_Ok", TAG_DONE);
										printf("returned: %ld\n", retval);
										retval = OpenRequesterTags(Req_Object, window, 
													REQ_Type, REQTYPE_INFO, 
													REQ_BodyText, "\33c\33iSome fancy text here just to show off.\33n\n\n\33bReAction\33n rules!\n\n5\33b\33f[helvetica.font/15]ReAction\33n3  is magic!",
													REQ_GadgetText, "_Ok|_Roll the bones!|_Whee!, get me out of here", TAG_DONE);
										printf("returned: %ld\n", retval);
										retval = OpenRequesterTags(Req_Object, window, 
													REQ_Type, REQTYPE_STRING, 
													REQS_Buffer, buffer,
													REQS_ShowDefault, FALSE,
													REQS_MaxChars, 127,
													REQ_GadgetText, "_Ok|_Cancel",
													REQ_BodyText, "Enter a string:", TAG_DONE);
										printf("returned: %ld, string: '%s'\n", retval, buffer);
										retval = OpenRequesterTags(Req_Object, window, 
													REQ_Type, REQTYPE_STRING, 
													REQS_Buffer, buffer,
													REQS_ShowDefault, TRUE,
													REQS_MaxChars, 127,
													REQS_ChooserArray, chooserlabels,
													REQS_ChooserActive, 2,
													REQ_GadgetText, "_Ok|_Patricia!|_Cancel",
													REQ_BodyText, "Edit the string:", TAG_DONE);
										GetAttr(REQS_ChooserActive, Req_Object, &number);
										printf("returned: %ld, string: '%s', active: %ld\n", retval, buffer, number);
										retval = OpenRequesterTags(Req_Object, window, 
													REQ_Type, REQTYPE_INTEGER, 
													REQI_Number, number,
													REQI_Arrows, TRUE,
													REQS_ChooserArray, NULL, /* reset the labels */
													REQ_GadgetText, "_Ok|_Cancel",
													REQ_BodyText, "Enter a number:", TAG_DONE);
										GetAttr(REQI_Number, Req_Object, &number);
										printf("returned: %ld, number: %ld\n", retval, number);
										retval = OpenRequesterTags(Req_Object, window, 
													REQ_Type, REQTYPE_INTEGER, 
													REQI_Number, number,
													REQI_Maximum, 1000,
													REQI_Minimum, -1000,
													REQI_Arrows, FALSE,
													REQ_GadgetText, "_Ok|_Cancel",
													REQ_BodyText, "Enter a number:", TAG_DONE);
										GetAttr(REQI_Number, Req_Object, &number);
										printf("returned: %ld, number: %ld\n", retval, number);
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
		DisposeObject( Req_Object );
	}
	else
		printf("Missing libraries/classes.\n");
	/* Close the classes.
	 */
	if (LabelBase)		CloseLibrary( (struct Library *)LabelBase );
	if (ButtonBase)		CloseLibrary( (struct Library *)ButtonBase );
	if (RequesterBase)	CloseLibrary( (struct Library *)RequesterBase );
	if (LayoutBase)		CloseLibrary( (struct Library *)LayoutBase );
	if (WindowBase)		CloseLibrary( (struct Library *)WindowBase );

        if (IntuitionBase)	CloseLibrary( (struct Library *)IntuitionBase );
}

ULONG OpenRequesterTags(Object *obj, struct Window *win, ULONG Tag1, ...)
{
	struct orRequest msg[1];
	msg->MethodID = RM_OPENREQ;
	msg->or_Window = win;	/* window OR screen is REQUIRED */
	msg->or_Screen = NULL;
	msg->or_Attrs = (struct TagItem *)&Tag1;
	return(DoMethodA(obj, (Msg)msg));
}
