/*
** main.c - a module in VLab-Demo
** © Steve Quartly 1999
**
** This code demonstrates the use of VLab.mcc
**
** In it I build a custom class, based on MUIC_Window so I can invoke methods on my class.
** This is MUCH better than using hooks.
**
** When writing in MUI, use sub classes!
**
*/

#include <stdio.h>

#include <exec/memory.h>

#include <clib/exec_protos.h>
#include <clib/alib_protos.h>
#include <clib/iffparse_protos.h>
#include <clib/muimaster_protos.h>
#include <pragmas/muimaster_pragmas.h>
#include <libraries/mui.h>

#include <mui/vlab_mcc.h>

#include "vlabwinclass.h"

struct Library *MUIMasterBase, *IntuitionBase;

/* The dispatcher for our custom class, VLabWinClass.*/
extern ULONG __saveds __asm VLabWinDispatcher( register __a0 struct IClass *cl, register __a2 Object *obj, register __a1 Msg msg );

struct MUI_CustomClass *mccVLabWin;

/* Make sure MUI has enough stack.*/
LONG __stack = 10000;

char *version = "$VER: VLab-Demo 1.0 (17.05.99)";

/*
**
** main
**
*/

int main( int argc, char *argv[] )
{
	Object *appObj, *winObj;

	/* Open the required libraries.*/
	MUIMasterBase = OpenLibrary ( MUIMASTER_NAME, MUIMASTER_VMIN );
	IntuitionBase = OpenLibrary ( "intuition.library", 39L );

	if ( MUIMasterBase && IntuitionBase )
	{
		/* Create our custom class, VLabWinClass.*/
		mccVLabWin = MUI_CreateCustomClass( NULL, MUIC_Window, NULL, sizeof( struct VLabWinData ), VLabWinDispatcher );

		if ( mccVLabWin )
		{
			Object *vlabObj;

			/* Create our VLab.mcc object. This object does all the hard work for us and we
				 should pass it to any objects that require it.*/
			vlabObj = VLabObject, End;

			/* Now build the application.*/
			appObj = ApplicationObject,
				MUIA_Application_Title, "VLab-Demo",
				MUIA_Application_Version, version,
				MUIA_Application_Copyright, "© 1999 Steve Quartly",
				MUIA_Application_Author, "Steve Quartly",
				MUIA_Application_Description, "Demonstrates the use of VLab.mcc",
				MUIA_Application_Base, "VLab-Demo",

				/* Create an instance of our custom class, VLabWinClass, and pass into it
					 our VLab.mcc object. It is a child of MUIC_Window, so it is effectively
					 a WindowObject. This class is the back bone of this demo.*/
				SubWindow, winObj = NewObject( mccVLabWin->mcc_Class, NULL,
					VLAB_Object, vlabObj,
				TAG_DONE ),

			End;

			if ( appObj )
			{
				ULONG signals = 0;

				/* Now add the VLab.mcc object to the application.
					 This MUST be done before any calls are made to this object.*/
				DoMethod( appObj, OM_ADDMEMBER, vlabObj );

				/* The nofitication on the main window's close gadget.*/
				DoMethod( winObj, MUIM_Notify, MUIA_Window_CloseRequest, TRUE, appObj, 2, MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit );

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

			/* Delete our custom class.*/
			MUI_DeleteCustomClass( mccVLabWin );
		}
	}

	/* Close our libraries.*/
	if ( MUIMasterBase ) CloseLibrary ( MUIMasterBase );
	if ( IntuitionBase ) CloseLibrary ( IntuitionBase );

	/* We're outta here!.*/
}

