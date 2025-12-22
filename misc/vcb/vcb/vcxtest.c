#include <functions.h>
#include "vcx.h"

/* #define VERTICAL */

struct Library *GfxBase, *IntuitionBase, *UtilityBase;

void main( void )
{
	Class *class;
	Object *object;
	struct Gadget *glist = NULL;
	struct Screen *screen;
	struct Window *window;

	if( GfxBase = OpenLibrary( "graphics.library", 0 ) )
	{
		if( IntuitionBase = OpenLibrary( "intuition.library", 0 ) )
		{
			if( UtilityBase = OpenLibrary( "utility.library", 0 ) )
			{
				if( screen = LockPubScreen( NULL ) )
				{
					if( class = initVCXClass() )
					{
						if( object = NewObject( class, NULL,
#ifdef VERTICAL
							GA_RelRight, -17,
							GA_Top, screen->WBorTop + screen->Font->ta_YSize + 1,
#else
							GA_RelBottom, -9,
							GA_Left, screen->WBorLeft,
#endif
#ifdef VERTICAL
							GA_RelHeight, - screen->WBorTop - screen->Font->ta_YSize - 1 - 9,
#else
							GA_RelWidth, - screen->WBorLeft - 17,
#endif
							GA_Previous, (ULONG)&glist,
#ifdef VERTICAL
							GA_RightBorder, 1,
#else
							GA_BottomBorder, 1,
#endif
							PGA_Total, 3,
							PGA_Top, 1,
							PGA_Visible, 1,
#ifdef VERTICAL
							PGA_Freedom, FREEVERT,
#else
							PGA_Freedom, FREEHORIZ,
#endif
							SYSIA_DrawInfo, GetScreenDrawInfo( screen ),
							TAG_DONE ) )
						{
							if( window = OpenWindowTags( NULL,
								WA_Gadgets, glist,
								WA_Height, 250,
								WA_MinWidth, 200,
								WA_MinHeight, 100,
								WA_CloseGadget, 1,
								WA_SizeGadget, 1,
								WA_DepthGadget, 1,
								WA_DragBar, 1,
								WA_IDCMP, IDCMP_CLOSEWINDOW,
								TAG_DONE ) )
							{
								WaitPort( window->UserPort );
								ReplyMsg( GetMsg( window->UserPort ) );
								SetGadgetAttrs( (struct Gadget *)object, window, NULL,
									PGA_Total, 5, TAG_DONE );
								WaitPort( window->UserPort );
								ReplyMsg( GetMsg( window->UserPort ) );
								SetGadgetAttrs( (struct Gadget *)object, window, NULL,
									PGA_Total, 25, TAG_DONE );
								WaitPort( window->UserPort );
								ReplyMsg( GetMsg( window->UserPort ) );
								SetGadgetAttrs( (struct Gadget *)object, window, NULL,
									PGA_Total, 1, TAG_DONE );
								WaitPort( window->UserPort );
								ReplyMsg( GetMsg( window->UserPort ) );
								SetGadgetAttrs( (struct Gadget *)object, window, NULL,
									PGA_Total, 5, TAG_DONE );
								WaitPort( window->UserPort );
								ReplyMsg( GetMsg( window->UserPort ) );
								SetGadgetAttrs( (struct Gadget *)object, window, NULL,
									PGA_Top, 0, TAG_DONE );
								WaitPort( window->UserPort );
								ReplyMsg( GetMsg( window->UserPort ) );
								CloseWindow( window );
							}
							DisposeObject( object );
						}
						freeVCXClass( class );
					}
					UnlockPubScreen( NULL, screen );
				}
				CloseLibrary( UtilityBase );
			}
			CloseLibrary( IntuitionBase );
		}
		CloseLibrary( GfxBase );
	}
}
