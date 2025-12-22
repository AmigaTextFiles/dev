/*

		Busy.mcc (c) 1994-96 by kmel, Klaus Melchior

		Example for Busy.mcc

		busy-demo.c

*/

/* DMAKE */


#ifdef __KMEL
	#include <kmel/kmel.h>
	#include <kmel/kmel_debug.h>

	#include <mui/busy_mcc.h>

	#include "rev/Busy-Demo.rev"

	extern char *vers_string;
#else
	#include <clib/alib_protos.h>
	#include <clib/exec_protos.h>
	#include <clib/graphics_protos.h>
	#include <clib/utility_protos.h>
	#include <clib/muimaster_protos.h>
	#include <pragmas/muimaster_pragmas.h>
	#include <libraries/mui.h>
	#include <stdio.h>

	#include "mui/busy_mcc.h"
	#include "rev/Busy-Demo.rev"

	#define DB / ## /
	#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))

	char *vers_string  = __VSTRING;
	char *vers_tag = __VERSTAG;
#endif

/*** externals ***/
extern struct Library *SysBase;

/*** main ***/
int main(int argc,char *argv[])
{
	struct Library *IntuitionBase;
	int ret=RETURN_ERROR;

	if(IntuitionBase = OpenLibrary("intuition.library", 36))
	{
		struct Library *MUIMasterBase;

		if(MUIMasterBase = OpenLibrary(MUIMASTER_NAME, 13))
		{
			Object *app;
			Object *window;
			Object *by_user, *bt_off, *bt_user;
			Object *by_move, *bt_move;

			ULONG signals;
			BOOL running = TRUE;

			app = ApplicationObject,
				MUIA_Application_Title      , "BusyClass Demo",
				MUIA_Application_Version    , vers_string,
				MUIA_Application_Copyright  , __VERSCR,
				MUIA_Application_Author     , "Klaus Melchior",
				MUIA_Application_Description, "Demonstrates the busy class.",
				MUIA_Application_Base       , "BUSYDEMO",

				SubWindow, window = WindowObject,
					MUIA_Window_Title, "BusyClass",
					MUIA_Window_ID   , MAKE_ID('B','U','S','Y'),
					WindowContents, VGroup,

						/*** create a busy bar with a gaugeframe ***/
						Child, MUI_MakeObject(MUIO_BarTitle, "Speed: 20"),
						Child, BusyObject,
							MUIA_Busy_Speed, 20,
							End,

						Child, VSpace(8),
						Child, MUI_MakeObject(MUIO_BarTitle, "Speed: User"),
						Child, by_user = BusyBar,
						Child, HGroup,
							Child, bt_off = KeyButton("Off", 'o'),
							Child, bt_user = KeyButton("User", 'u'),
							End,

						Child, VSpace(8),
						Child, MUI_MakeObject(MUIO_BarTitle, "Speed: Manually"),
						Child, by_move = BusyObject,
							MUIA_Busy_Speed, MUIV_Busy_Speed_Off,
							End,
						Child, bt_move = KeyButton("Move ...", 'm'),

						End,

					End,
				End;

			if(app)
			{
				/*** generate notifies ***/
				DoMethod(window, MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
					app, 2,
					MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit);

				DoMethod(bt_off, MUIM_Notify, MUIA_Pressed, FALSE,
					by_user, 3,
					MUIM_Set, MUIA_Busy_Speed, MUIV_Busy_Speed_Off);
				DoMethod(bt_user, MUIM_Notify, MUIA_Pressed, FALSE,
					by_user, 3,
					MUIM_Set, MUIA_Busy_Speed, MUIV_Busy_Speed_User);

				DoMethod(bt_move, MUIM_Notify, MUIA_Timer, MUIV_EveryTime,
					by_move, 2,
					MUIM_Busy_Move, TRUE);

				/*** ready to open the window ... ***/
				set(window,MUIA_Window_Open,TRUE);

				while (running)
				{
					switch (DoMethod(app,MUIM_Application_Input,&signals))
					{
						case MUIV_Application_ReturnID_Quit:
							running = FALSE;
							break;
					}

					if (running && signals)
						Wait(signals);
				}

				set(window, MUIA_Window_Open, FALSE);

				/*** shutdown ***/
				MUI_DisposeObject(app);      /* dispose all objects. */

				ret = RETURN_OK;
			}
			else
			{
				puts("Could not open application!");
				ret = RETURN_FAIL;
			}

			CloseLibrary(MUIMasterBase);
		}
		else
		{
			puts("Could not open muimaster.library v13!");
			ret = RETURN_FAIL;
		}

		CloseLibrary(IntuitionBase);
	}
	else
	{
		puts("Could not open intuition.library v36!");
		ret = RETURN_FAIL;
	}

	return(ret);
}

