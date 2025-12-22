#include <dos/dos.h>
#include <intuition/intuition.h>
#include <proto/exec.h>
#include <proto/gadtools.h>
#include <proto/intuition.h>
#include <proto/utility.h>
#include "dialog.h"

VOID setDialogWindow( DialogElement *root, struct Window *window )
{
	root->object = window;
}

struct Window *getDialogWindow( DialogElement *root )
{
	return root->object;
}

/*
 *	will open a window and create the dialog box.
 *	(on the screen specified by DA_Screen as CUSTOMSCREEN; this screen
 *	may not go away until closeDialogWindow() has been called)
 *	The window pointer will be stored in the root element's object field.
 *	Returns window's UserPort or NULL if failure.
 */
ULONG openDialogWindowA( DialogElement *root, struct TagItem *taglist )
{
	LayoutMessage message;
	struct Screen *screen;
	struct Window *window = NULL;
	struct Gadget *glist = NULL, *prev;
	LONG width, winwidth, height, winheight;
	STRPTR title;
	ULONG error = DIALOGERR_BAD_ARGS;

	if( !root )
		goto failure;

	screen = (struct Screen *)GetTagData( DA_Screen, 0, root->taglist );
	if( !screen )
		goto failure;

	winwidth = GetTagData( WA_InnerWidth, 0, taglist );
	winheight = GetTagData( WA_InnerHeight, 0, taglist );

	setupDialogElement( root );

	width = getMinWidth( root );
	if( width < winwidth )
		width = winwidth;
	prepareLayoutNoVBaseline( &message, width );

	height = getMinHeight( root );
	if( height < winheight )
		height = winheight;
	prepareLayoutNoHBaseline( &message, height );

	error = DIALOGERR_NO_MEMORY;

	title = (STRPTR)GetTagData( WA_Title, 0, root->taglist );
	title = (STRPTR)GetTagData( WA_Title, (ULONG)title, taglist );

	window = OpenWindowTags( NULL,
				( title ) ? WA_Title : TAG_IGNORE, title,
				WA_Left, GetTagData( WA_Left, ( screen->Width - width ) / 2, taglist ),
				WA_Top, GetTagData( WA_Top, ( screen->Height - height ) / 2, taglist ),
				WA_InnerWidth, width,
				WA_InnerHeight, height,
				WA_IDCMP, root->idcmp_mask,
				WA_SimpleRefresh, TRUE,
				WA_CustomScreen, screen,
				TAG_MORE, root->taglist );
	if( !window )
		goto failure;

	window->UserData = NULL;

	prepareLayoutX( &message, window->BorderLeft );
	prepareLayoutY( &message, window->BorderTop );

	prev = CreateContext( &glist );
	if( !prev )
		goto failure;

	error = layoutDialogElement( root, &message, &prev );
	if( error )
		goto failure;

	AddGList( window, glist, ~0, -1, NULL );
	RefreshGList( glist, window, NULL, -1 );
	GT_RefreshWindow( window, NULL );

	window->UserData = (BYTE *)glist;
	setDialogWindow( root, window );

	return DIALOGERR_OK;
failure:
	FreeGadgets( glist );
	clearDialogElement( root );
	if( window )
		CloseWindow( window );
	return error;
}

ULONG openDialogWindow( DialogElement *root, ULONG first, ... )
{
	return openDialogWindowA( root, (struct TagItem *)&first );
}

VOID closeDialogWindow( DialogElement *root )
{
	struct Window *window;

	if( window = getDialogWindow( root ) )
	{
		struct Gadget *glist = (struct Gadget *)window->UserData;

		CloseWindow( window );
		setDialogWindow( root, NULL );

		FreeGadgets( glist );
		clearDialogElement( root );
	}
}

/*
 *	conducts a simple dialog.
 *	The dialog is called simple because elements (buttons etc.) cannot trigger
 *	complex actions.
 *	We simply let the user play with the gadgets until one is activated that
 *	has the DA_Termination flag set.
 *	Then we leave the event loop and return the terminating element.
 *	Note however that by means of the DA_SubDialogRoot attribute, an element
 *	can invoke runSimpleDialog() recursively to run a subdialog when activated.
 *	The termination result of that subdialog is stored in the location
 *	specified by DA_Storage (if there).
 *	Although this system allows for quite complex dialogs, you still may need
 *	to do your own event processing in certain cases.
 *	In particular, using runSimpleDialog() you cannot take action depending on
 *	the terminating element of a subdialog immediately. After the topmost
 *	runSimpleDialog() invocation returns control to you, it is impossible
 *	to tell how often exactly the subdialog was run and how it was terminated
 *	each time.
 *	Use runSimpleDialog() as a model from which to start writing your event
 *	handler. Add your code immediately before the call to GT_ReplyIMsg().
 *	At that point of control flow you can examine the match variable to see
 *	which dialog element was activated by the event (if any).
 */
DialogElement *runSimpleDialogA( DialogElement *root, struct TagItem *taglist )
{
	struct IntuiMessage *imsg;
	DialogElement *terminator = NULL;
	struct Window *window;
	struct MsgPort *idcmp;
	ULONG error, idcmp_sigmask, received, run;

	if( !root )
		return NULL;

	error = openDialogWindowA( root, taglist );
	if( error )
		goto cleanup;

	window = getDialogWindow( root );
	idcmp = window->UserPort;
	idcmp_sigmask = ( idcmp ) ? 1L << idcmp->mp_SigBit : 0;

	run = TRUE;
	do
	{
		received = Wait( SIGBREAKF_CTRL_C | idcmp_sigmask );
		if( received & SIGBREAKF_CTRL_C )
			run = FALSE;
		if( received & idcmp_sigmask )
			while( imsg = GT_GetIMsg( idcmp ) )
			{
				DialogElement *match;

#ifdef DEBUG1
				printf( "runSimpleDialog : found IMsg %08lx in IDCMP %08lx\n", imsg, idcmp );
#endif
				match = mapDialogEvent( root, imsg );
				if( match )
					if( GetTagData( DA_Termination, 0, match->taglist ) )
					{
						terminator = match;
						run = FALSE;
					}
				/*** to run a custom dialog, insert additional event processing here ***/
				GT_ReplyIMsg( imsg );
#ifdef DEBUG1
				printf( "runSimpleDialog : replied to IMsg %08lx\n", imsg );
#endif
			}
	}
	while( run );
cleanup:
	if( !error )
		closeDialogWindow( root );
	return terminator;
}

DialogElement *runSimpleDialog( DialogElement *root, ULONG first, ... )
{
	return runSimpleDialogA( root, (struct TagItem *)&first );
}
