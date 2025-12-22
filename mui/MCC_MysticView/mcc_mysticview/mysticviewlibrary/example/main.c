/*********************************************************************
----------------------------------------------------------------------

	mysticlib test

----------------------------------------------------------------------
*********************************************************************/

#include <stdio.h>
#include <string.h>

#include <guigfx/guigfx.h>
#include <exec/memory.h>
#include <libraries/mysticview.h>
#include <dos/dos.h>

#include <clib/macros.h>

#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/utility.h>
#include <proto/guigfx.h>
#include <proto/mysticview.h>

#include "defs.h"
#include "global.h"
#include "window.h"



/*********************************************************************
----------------------------------------------------------------------

	setmysticview(mysticview, win)
	
	update view parameters

----------------------------------------------------------------------
*********************************************************************/

void setmysticview(APTR mysticview, struct mywindow *win)
{
	updatewindowparameters(win);

	MV_SetAttrs(mysticview, 
		MVIEW_DestX, win->innerleft,
		MVIEW_DestY, win->innertop,
		MVIEW_DestWidth, win->innerwidth,
		MVIEW_DestHeight, win->innerheight,
		TAG_DONE);
}



/*********************************************************************
----------------------------------------------------------------------

	mainloop

----------------------------------------------------------------------
*********************************************************************/

ULONG mainloop(struct Screen *scr, struct mywindow *win)
{
	ULONG returncode = RETURN_FAIL;

	BOOL finish = FALSE;
	struct IntuiMessage *imsg;
	struct IntuiMessage myimsg;
	ULONG signals;

	APTR mysticview = NULL;
	APTR picture;
	
	picture = LoadPicture("PROGDIR:testpic", TAG_DONE);

	
	if (picture)
	{
		mysticview = MV_Create(scr, win->window->RPort, 
			MVIEW_Picture, picture, TAG_DONE);
	}
	else
	{
		printf("*** could not load PROGDIR:testpic\n");
	}


	if (mysticview)
	{
		returncode = RETURN_OK;

		MV_DrawOn(mysticview);
		setmysticview(mysticview, win);

		do
		{
			BOOL refreshwindow = FALSE;

			signals = Wait(win->idcmpSignal);

			if (signals & win->idcmpSignal)
			{
				while (imsg = (struct IntuiMessage *) GetMsg(win->window->UserPort))
				{
					memcpy(&myimsg, imsg, sizeof(struct IntuiMessage));

					switch (myimsg.Class)
					{
						case CLOSEWINDOW:
							finish = TRUE;
							break;

						case REFRESHWINDOW:
							BeginRefresh(win->window);
							EndRefresh(win->window, TRUE);
							refreshwindow = TRUE;
							break;

						case NEWSIZE:
							refreshwindow = TRUE;
							break;

						case VANILLAKEY:
							switch (myimsg.Code)
							{
								case 27:
									finish = TRUE;
									break;
							}
					}
				}
			}

			if (refreshwindow)
			{
				setmysticview(mysticview, win);
			}

		} while (!finish);

		MV_Delete(mysticview);
	}
	else
	{
		printf("*** could not create mysticview instance\n");		
	}



	if (picture)
	{
		DeletePicture(picture);
	}


	return returncode;
}






/*********************************************************************
----------------------------------------------------------------------

	main

----------------------------------------------------------------------
*********************************************************************/

ULONG main (int argc, char **argv)
{
	ULONG result;

	if (InitGlobal())
	{
		struct mywindow *window;
		struct Screen *defscreen;

		if (defscreen = LockPubScreen(NULL))
		{
			if (window = createwindow(defscreen))
			{
				mainloop(defscreen, window);
				deletewindow(window);
				result = 0;
			}
			else
			{
				printf("*** window could not be opened\n");
				result = 20;
			}

			UnlockPubScreen(NULL, defscreen);
		}
		else
		{
			printf("*** pubscreen could not be locked\n");
			result = 20;
		}

		CloseGlobal();
	}
	else
	{
		printf("*** global initialization failed\n");
		result = 20;
	}

	return result;
}
