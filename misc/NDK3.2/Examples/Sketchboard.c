;/*
sc Sketchboard.c LINK NOSTACKCHECK
quit
*/

#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <gadgets/sketchboard.h>

#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/intuition_protos.h>
#include <clib/sketchboard_protos.h>

#include <pragmas/exec_pragmas.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/sketchboard_pragmas.h>

extern struct IntuitionBase* IntuitionBase;
extern struct SysBase*       SysBase;

int main( void )
{
	struct Library	*SketchBoardBase;
	struct Window	*win;
	struct Gadget	*firstG;

	if( ! ( SketchBoardBase = OpenLibrary( "gadgets/sketchboard.gadget", 0L ) ) )
		return 0L;

	firstG = (struct Gadget *) NewObject( SKETCHBOARD_GetClass(), NULL,
		GA_Left, 4,
		GA_Top, 2,
//		GA_Width, 64*3 + 8,
//		GA_Height, 64*3 + 8,
		GA_RelWidth, -75,
		GA_RelHeight, -50,
		SGA_Width, 64,
		SGA_Height, 64,
		SGA_Scale, 3,
		TAG_DONE );

	if( win = OpenWindowTags( NULL,
		WA_GimmeZeroZero, TRUE,
		WA_Width, 320,
		WA_Height, 256,
		WA_DragBar, TRUE,
		WA_Activate, TRUE,
		WA_CloseGadget, TRUE,
		WA_IDCMP, IDCMP_CLOSEWINDOW|IDCMP_VANILLAKEY,
		WA_Gadgets, (ULONG) firstG,
		WA_SizeGadget, TRUE,
		WA_MinWidth, 20,
		WA_MinHeight, 20,
		WA_MaxWidth, 7000,
		WA_MaxHeight, 7000,
		TAG_DONE ) )
	{
		BOOL	done = FALSE;
		UBYTE	apen = 1, scale = 3;

		do
		{
			struct IntuiMessage	*imsg;

			WaitPort( win->UserPort );

			while( imsg = (struct IntuiMessage *) GetMsg( win->UserPort ) )
			{
				if( imsg->Class == IDCMP_CLOSEWINDOW )
				{
					done = TRUE;
				}
				else if( imsg->Class == IDCMP_VANILLAKEY )
				{
					switch( imsg->Code )
					{
						case 'e':
							SetAttrs( firstG, SGA_Tool, SGTOOL_ELLIPSE, TAG_DONE );
						break;

						case 'E':
							SetAttrs( firstG, SGA_Tool, SGTOOL_ELLIPSE_FILLED, TAG_DONE );
						break;

						case 'r':
							SetAttrs( firstG, SGA_Tool, SGTOOL_RECT, TAG_DONE );
						break;

						case 'R':
							SetAttrs( firstG, SGA_Tool, SGTOOL_RECT_FILLED, TAG_DONE );
						break;

						case 'l':
							SetAttrs( firstG, SGA_Tool, SGTOOL_LINE, TAG_DONE );
						break;

						case 'F':
							SetAttrs( firstG, SGA_Tool, SGTOOL_FREEHAND, TAG_DONE );
						break;

						case 'f':
							SetAttrs( firstG, SGA_Tool, SGTOOL_FREEHAND_DOTS, TAG_DONE );
						break;

						case 'i':
							SetAttrs( firstG, SGA_Tool, SGTOOL_FILL, TAG_DONE );
						break;

						case '+':
							SetAttrs( firstG, SGA_APen, ++apen, TAG_DONE );
						break;

						case '-':
							SetAttrs( firstG, SGA_APen, --apen, TAG_DONE );
						break;

						case 'u':
							DoGadgetMethod( firstG, win, NULL, SGM_Undo, NULL );
						break;

						case 'z':
							DoGadgetMethod( firstG, win, NULL, SGM_Redo, NULL );
						break;

						case 'c':
							DoGadgetMethod( firstG, win, NULL, SGM_Clear, NULL );
						break;

						case '<':
							if( scale > 1 ) SetGadgetAttrs( firstG, win, NULL, SGA_Scale, --scale, TAG_DONE );
							RefreshGList( firstG, win, NULL, 1L );
						break;

						case '>':
							SetGadgetAttrs( firstG, win, NULL, SGA_Scale, ++scale, TAG_DONE );
							RefreshGList( firstG, win, NULL, 1L );
						break;
						
						case 'g':
							SetGadgetAttrs( firstG, win, NULL, SGA_ShowGrid, FALSE, TAG_DONE );
							RefreshGList( firstG, win, NULL, 1L );						
						break;
						
						case 'G':
							SetGadgetAttrs( firstG, win, NULL, SGA_ShowGrid, TRUE, TAG_DONE );
							RefreshGList( firstG, win, NULL, 1L );						
						break;
					}
				}

				ReplyMsg( (struct Message *) imsg );
			}
		}
		while( ! done );

		CloseWindow( win );
	}
	DisposeObject( (Object *) firstG );

	CloseLibrary( SketchBoardBase );

	return 0L;
}
