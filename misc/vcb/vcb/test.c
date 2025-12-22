#include <intuition/gadgetclass.h>
#include <intuition/imageclass.h>
#include <intuition/intuition.h>
#include <functions.h>
#include "vcb.h"

struct Library *GfxBase, *IntuitionBase, *UtilityBase;

void exposure( struct Hook *hook, Object *object, struct ExposureMsg *xm )
{
	geta4();	/* needed with Manx/Aztec C's small memory model */

	if( xm->command == VCBCMD_RENDER )
	{
		int xu, yu, x0, y0,
			left, top,
			xmin, ymin, xmax, ymax;

		GetAttr( VCBGA_HUnit, object, (ULONG *)&xu );
		GetAttr( VCBGA_VUnit, object, (ULONG *)&yu );
		GetAttr( VCBGA_XOrigin, object, (ULONG *)&x0 );
		GetAttr( VCBGA_YOrigin, object, (ULONG *)&y0 );
		GetAttr( VCBGA_HOffset, object, (ULONG *)&left );
		GetAttr( VCBGA_VOffset, object, (ULONG *)&top );

		xmin = x0 + xm->left * xu;
		ymin = y0 + xm->top * yu;
		xmax = x0 + ( xm->left + xm->width ) * xu - 1;
		ymax = y0 + ( xm->top + xm->height ) * yu - 1;

		SetAPen( xm->rp, 1 );
		SetDrMd( xm->rp, JAM1 );

		Move( xm->rp, xmin, ymin );
		Draw( xm->rp, xmax, ymax );
		Move( xm->rp, xmin, ymax );
		Draw( xm->rp, xmax, ymin );
	}
}

void test( Object *object, struct Window *window )
{
	SetGadgetAttrs( (struct Gadget *)object, window, NULL,
		VCBGA_HOffset, 2, TAG_DONE );
	WaitPort( window->UserPort );
	ReplyMsg( GetMsg( window->UserPort ) );

	printf( "setting totals to 3\n" );
	SetGadgetAttrs( (struct Gadget *)object, window, NULL,
		VCBGA_HTotal, 3,
		VCBGA_VTotal, 3,
		TAG_DONE );
	WaitPort( window->UserPort );
	ReplyMsg( GetMsg( window->UserPort ) );

	printf( "setting totals to 10\n" );
	SetGadgetAttrs( (struct Gadget *)object, window, NULL,
		VCBGA_HTotal, 10,
		VCBGA_VTotal, 10,
		TAG_DONE );
	WaitPort( window->UserPort );
	ReplyMsg( GetMsg( window->UserPort ) );

	printf( "setting totals to 20\n" );
	SetGadgetAttrs( (struct Gadget *)object, window, NULL,
		VCBGA_HTotal, 20,
		VCBGA_VTotal, 20,
		TAG_DONE );
	WaitPort( window->UserPort );
	ReplyMsg( GetMsg( window->UserPort ) );

	printf( "setting totals to 30\n" );
	SetGadgetAttrs( (struct Gadget *)object, window, NULL,
		VCBGA_HTotal, 30,
		VCBGA_VTotal, 30,
		TAG_DONE );
	WaitPort( window->UserPort );
	ReplyMsg( GetMsg( window->UserPort ) );
}

void main( void )
{
	Class *class;
	struct Hook xh;
	Object *object;
	struct VCB *vcb;
	struct Gadget *glist = NULL, *gadget;
	struct Screen *screen;
	struct DrawInfo *drawinfo;
	APTR vi = NULL;
	struct Window *window;
	struct SignalSemaphore *ss;

	if( GfxBase = OpenLibrary( "graphics.library", 0 ) )
	{
		if( IntuitionBase = OpenLibrary( "intuition.library", 0 ) )
		{
			if( UtilityBase = OpenLibrary( "utility.library", 0 ) )
			{
				if( screen = LockPubScreen( NULL ) )
				{
					if( drawinfo = GetScreenDrawInfo( screen ) )
					{
						if( class = initVCBClass() )
						{
							SetupHook( &xh, exposure, NULL );
							if( object = NewObject( class, NULL,
								VCBGA_ExposureHook, &xh,
								GA_Left, screen->WBorLeft,
								GA_Top, screen->WBorTop + screen->Font->ta_YSize + 1,
								GA_RelWidth, - screen->WBorLeft + 1,
								GA_RelHeight, - screen->WBorTop - screen->Font->ta_YSize,
								GA_Previous, (ULONG)&glist,
								VCBGA_HScroller, 1,
								VCBGA_HBorder, 1,
								VCBGA_HTotal, 10,
								VCBGA_HOffset, 3,
								VCBGA_HUnit, 10,
								VCBGA_VScroller, 1,
								VCBGA_VTotal, 10,
								VCBGA_VOffset, 4,
								VCBGA_VUnit, 10,
								VCBGA_Interim, 1,
								SYSIA_DrawInfo, (ULONG)drawinfo,
								TAG_DONE ) )
							{
								printf( "glist = %08lx\n", glist );
								vcb = INST_DATA( class, object );
								if( window = OpenWindowTags( NULL,
									WA_Gadgets, glist,
									WA_Height, 250,
									WA_MinWidth, 100,
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
									test( object, window );

									GetAttr( VCBGA_Semaphore, object, (ULONG *)&ss );
									printf( "trying to obtain semaphore %08lx...\n", ss );
									ObtainSemaphore( ss );
									printf( "display to the virtual coordinate box is now locked\n" );
									WaitPort( window->UserPort );
									ReplyMsg( GetMsg( window->UserPort ) );

									ReleaseSemaphore( ss );
									printf( "display to the virtual coordinate box is now free\n" );
									RefreshGList( glist, window, NULL, 1 );
									WaitPort( window->UserPort );
									ReplyMsg( GetMsg( window->UserPort ) );

									CloseWindow( window );
								}
								DisposeObject( object );
							}
							freeVCBClass( class );
						}
						FreeScreenDrawInfo( screen, drawinfo );
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
