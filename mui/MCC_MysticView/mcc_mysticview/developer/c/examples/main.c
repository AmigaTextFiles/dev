/*
** main.c - a module in MysticView-Demo
** © Steve Quartly 1999
**
** This code demonstrates the use of MysticView.mcc
**
** When writing in MUI, use sub classes!
**
*/

#include <stdio.h>

#include <exec/memory.h>

#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/alib_protos.h>
#include <clib/iffparse_protos.h>
#include <clib/muimaster_protos.h>
#include <pragmas/muimaster_pragmas.h>
#include <libraries/mui.h>

#include <mui/mysticview_mcc.h>

struct Library *MUIMasterBase, *IntuitionBase;

/* Make sure MUI has enough stack.*/
LONG __stack = 10000;

char *version = "$VER: MysticView-Demo 1.0 (16.06.99)";

/*
**
** main
**
*/

int main( int argc, char *argv[] )
{
	Object *appObj, *winObj, *mouseDrag, *mvObj, *showArrows, *showCursor, *displayMode;
	Object *refreshMode, *staticPalette, *resetAll, *up, *left, *center, *right, *down;
	Object *rotateLeft, *rotateRight, *resetRotate;
	Object *zoomIn, *zoomOut, *resetZoom;

	/* Open the required libraries.*/
	MUIMasterBase = OpenLibrary ( MUIMASTER_NAME, MUIMASTER_VMIN );
	IntuitionBase = OpenLibrary ( "intuition.library", 39L );

	if ( MUIMasterBase && IntuitionBase )
	{
		/* Has the user given us a filename?*/
		if ( argv[1] )
		{	
			BPTR lock;

			lock = Lock( argv[1], ACCESS_READ );

			/* Is it a valid filename?*/
			if ( lock )
			{
				UnLock( lock );

				/* Now build the application.*/
				appObj = ApplicationObject,
					MUIA_Application_Title, "MysticView-Demo",
					MUIA_Application_Version, version,
					MUIA_Application_Copyright, "© 1999 Steve Quartly & Timm S. Müller",
					MUIA_Application_Author, "Steve Quartly & Timm S. Müller",
					MUIA_Application_Description, "Demonstrates the use of MysticView.mcc",
					MUIA_Application_Base, "MysticView-Demo",

					SubWindow, winObj = WindowObject,
						MUIA_Window_ID, MAKE_ID('M','Y','S','T' ),
						MUIA_Window_Title, "MysticView - Demo, written by Steve Quartly, © 1999",
						WindowContents,	VGroup,

							Child, VGroup, GroupFrameT( "MysticView" ),

								/* This is the MysticView object.*/
								Child, mvObj = MysticViewObject,
									MUIA_MysticView_FileName, argv[1],
									MUIA_MysticView_DisplayMode, MVDISPMODE_IGNOREASPECT,
									MUIA_MysticView_ShowArrows, TRUE,
									MUIA_MysticView_ShowCursor, TRUE,
									MUIA_MysticView_MouseDrag, TRUE,
									MUIA_MysticView_RefreshMode, MVPREVMODE_NONE,
									MUIA_MysticView_StaticPalette, TRUE,
									MUIA_MysticView_Text, FilePart( argv[1] ),
								End,
							End,

							/* Now set up a few gadgets to demonstarte some of the features.*/
							Child, HGroup, GroupFrameT( "Controls" ),
								Child, RectangleObject, End,

								Child, VGroup,
									MUIA_Group_Columns, 2,

									Child, Label( "Mouse Drag" ),
									Child, mouseDrag = ImageObject,
										ImageButtonFrame,
										MUIA_InputMode, MUIV_InputMode_Toggle,
										MUIA_Image_Spec, MUII_CheckMark,
										MUIA_Image_FreeVert, TRUE,
										MUIA_Selected, TRUE,
										MUIA_Background, MUII_ButtonBack,
										MUIA_ShowSelState, FALSE,
										MUIA_CycleChain, 1,
									End,

									Child, Label( "Show Cursor" ),
									Child, showCursor = ImageObject,
										ImageButtonFrame,
										MUIA_InputMode, MUIV_InputMode_Toggle,
										MUIA_Image_Spec, MUII_CheckMark,
										MUIA_Image_FreeVert, TRUE,
										MUIA_Selected, TRUE,
										MUIA_Background, MUII_ButtonBack,
										MUIA_ShowSelState, FALSE,
										MUIA_CycleChain, 1,
									End,

									Child, Label( "Opaque Refresh" ),
									Child, refreshMode = ImageObject,
										ImageButtonFrame,
										MUIA_InputMode, MUIV_InputMode_Toggle,
										MUIA_Image_Spec, MUII_CheckMark,
										MUIA_Image_FreeVert, TRUE,
										MUIA_Selected, FALSE,
										MUIA_Background, MUII_ButtonBack,
										MUIA_ShowSelState, FALSE,
										MUIA_CycleChain, 1,
									End,

								End,

								Child, VGroup,
									MUIA_Group_Columns, 2,

									Child, Label( "Show Arrows" ),
									Child, showArrows = ImageObject,
										ImageButtonFrame,
										MUIA_InputMode, MUIV_InputMode_Toggle,
										MUIA_Image_Spec, MUII_CheckMark,
										MUIA_Image_FreeVert, TRUE,
										MUIA_Selected, TRUE,
										MUIA_Background, MUII_ButtonBack,
										MUIA_ShowSelState, FALSE,
										MUIA_CycleChain, 1,
									End,

									Child, Label( "Display 1:1" ),
									Child, displayMode = ImageObject,
										ImageButtonFrame,
										MUIA_InputMode, MUIV_InputMode_Toggle,
										MUIA_Image_Spec, MUII_CheckMark,
										MUIA_Image_FreeVert, TRUE,
										MUIA_Selected, TRUE,
										MUIA_Background, MUII_ButtonBack,
										MUIA_ShowSelState, FALSE,
										MUIA_CycleChain, 1,
									End,

									Child, Label( "Static Palette" ),
									Child, staticPalette = ImageObject,
										ImageButtonFrame,
										MUIA_InputMode, MUIV_InputMode_Toggle,
										MUIA_Image_Spec, MUII_CheckMark,
										MUIA_Image_FreeVert, TRUE,
										MUIA_Selected, TRUE,
										MUIA_Background, MUII_ButtonBack,
										MUIA_ShowSelState, FALSE,
										MUIA_CycleChain, 1,
									End,

								End,

								Child, RectangleObject, End,
							End,

							Child, HGroup, GroupFrameT( "Position" ),

								Child, VGroup, GroupFrameT( "Move" ),

									Child, HGroup,
										Child, RectangleObject, End,
										Child, up = KeyButton( "U", 'u' ),
										Child, RectangleObject, End,
									End,

									Child, HGroup,
										Child, left = KeyButton( "L", 'l' ),
										Child, center = KeyButton( "C", 'c' ),
										Child, right = KeyButton( "R", 'r' ),
									End,

									Child, HGroup,
										Child, RectangleObject, End,
										Child, down = KeyButton( "D", 'd' ),
										Child, RectangleObject, End,
									End,

								End,

								Child, VGroup, GroupFrameT( "Rotation" ),
									Child, rotateLeft = KeyButton( "Rotate Left", 'e' ),
									Child, rotateRight = KeyButton( "Rotate Right", 'h' ),
									Child, resetRotate = KeyButton( "Reset Rotate", 't' ),
								End,

								Child, VGroup, GroupFrameT( "Zoom" ),
									Child, zoomIn = KeyButton( "Zoom In", 'i' ),
									Child, zoomOut = KeyButton( "Zoom Out", 'o' ),
									Child, resetZoom = KeyButton( "Reset Zoom", 'z' ),
								End,

							End,

							Child, resetAll = KeyButton( "Reset All", 's' ),
						End,
					End,
				End;

				if ( appObj )
				{
					ULONG signals = 0;

					/* The nofitication on the main window's close gadget.*/
					DoMethod( winObj, MUIM_Notify, MUIA_Window_CloseRequest, TRUE, appObj, 2, MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit );

					/* This turns mouse dragging on and off.*/
					DoMethod( mouseDrag, MUIM_Notify, MUIA_Selected, MUIV_EveryTime, mvObj, 3, MUIM_Set, MUIA_MysticView_MouseDrag, MUIV_TriggerValue );

					/* This turns the arrows on and off.*/
					DoMethod( showArrows, MUIM_Notify, MUIA_Selected, MUIV_EveryTime, mvObj, 3, MUIM_Set, MUIA_MysticView_ShowArrows, MUIV_TriggerValue );

					/* This turns the cursor on and off.*/
					DoMethod( showCursor, MUIM_Notify, MUIA_Selected, MUIV_EveryTime, mvObj, 3, MUIM_Set, MUIA_MysticView_ShowCursor, MUIV_TriggerValue );

					/* This changes the displaymode.*/
					DoMethod( displayMode, MUIM_Notify, MUIA_Selected, TRUE, mvObj, 3, MUIM_Set, MUIA_MysticView_DisplayMode, MVDISPMODE_IGNOREASPECT );
					DoMethod( displayMode, MUIM_Notify, MUIA_Selected, FALSE, mvObj, 3, MUIM_Set, MUIA_MysticView_DisplayMode, MVDISPMODE_KEEPASPECT_MIN );

					/* This changes the refresh mode.*/
					DoMethod( refreshMode, MUIM_Notify, MUIA_Selected, TRUE, mvObj, 3, MUIM_Set, MUIA_MysticView_RefreshMode, MVPREVMODE_OPAQUE );
					DoMethod( refreshMode, MUIM_Notify, MUIA_Selected, FALSE, mvObj, 3, MUIM_Set, MUIA_MysticView_RefreshMode, MVPREVMODE_NONE );

					/* This turns the static palette on and off.*/
					DoMethod( staticPalette, MUIM_Notify, MUIA_Selected, MUIV_EveryTime, mvObj, 3, MUIM_Set, MUIA_MysticView_StaticPalette, MUIV_TriggerValue );

					/* Reset the position of the zoom, move and rotation.*/
					DoMethod( resetAll, MUIM_Notify, MUIA_Pressed, FALSE, mvObj, 3, MUIM_Set, MUIA_MysticView_ResetAll, NULL );

					/* Zoom in and out etc.*/
					DoMethod( zoomIn, MUIM_Notify, MUIA_Pressed, FALSE, mvObj, 3, MUIM_Set, MUIA_MysticView_ZoomInRelative, 16384 );
					DoMethod( zoomOut, MUIM_Notify, MUIA_Pressed, FALSE, mvObj, 3, MUIM_Set, MUIA_MysticView_ZoomOutRelative, 16384 );
					DoMethod( resetZoom, MUIM_Notify, MUIA_Pressed, FALSE, mvObj, 3, MUIM_Set, MUIA_MysticView_ResetZoom, NULL );

					/* Rotate left and right.*/
					DoMethod( rotateLeft, MUIM_Notify, MUIA_Pressed, FALSE, mvObj, 3, MUIM_Set, MUIA_MysticView_RotateLeftRelative, 5461 );
					DoMethod( rotateRight, MUIM_Notify, MUIA_Pressed, FALSE, mvObj, 3, MUIM_Set, MUIA_MysticView_RotateRightRelative, 5461 );
					DoMethod( resetRotate, MUIM_Notify, MUIA_Pressed, FALSE, mvObj, 3, MUIM_Set, MUIA_MysticView_ResetRotate, NULL );

					/* Move around the image.*/
					DoMethod( left, MUIM_Notify, MUIA_Pressed, FALSE, mvObj, 3, MUIM_Set, MUIA_MysticView_MoveLeftRelative, 2622 );
					DoMethod( right, MUIM_Notify, MUIA_Pressed, FALSE, mvObj, 3, MUIM_Set, MUIA_MysticView_MoveRightRelative, 2622 );
					DoMethod( up, MUIM_Notify, MUIA_Pressed, FALSE, mvObj, 3, MUIM_Set, MUIA_MysticView_MoveUpRelative, 2622 );
					DoMethod( down, MUIM_Notify, MUIA_Pressed, FALSE, mvObj, 3, MUIM_Set, MUIA_MysticView_MoveDownRelative, 2622 );
					DoMethod( center, MUIM_Notify, MUIA_Pressed, FALSE, mvObj, 3, MUIM_Set, MUIA_MysticView_Center, NULL );

					/* Open the main window.*/
					set( winObj, MUIA_Window_Open, TRUE );

					/* Our input loop.*/
					while ( DoMethod( appObj, MUIM_Application_NewInput, &signals ) != MUIV_Application_ReturnID_Quit )
					{
						if ( signals )
						{
							signals = Wait( signals | SIGBREAKF_CTRL_C );

							if ( signals & SIGBREAKF_CTRL_C ) break;
						}
					}

					/* All done, close the main window... not that we need to.*/
					set( winObj, MUIA_Window_Open, FALSE );

					/* Dispose of the application.*/
					MUI_DisposeObject( appObj );
				}

				else printf("Error: Unable to create application!\n" );
			}

			else printf("Error: Unable to open the file\n" );
		}

		else printf("Error: No file name supplied.\n" );
	}

	/* Close our libraries.*/
	if ( MUIMasterBase ) CloseLibrary ( MUIMasterBase );
	if ( IntuitionBase ) CloseLibrary ( IntuitionBase );

	/* We're outta here!.*/
}

