
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <utility/tagitem.h>
#include <intuition/intuition.h>

#include <clib/macros.h>

#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/utility.h>
#include <proto/intuition.h>

#include "defs.h"
#include "global.h"
#include "window.h"


/*********************************************************************
----------------------------------------------------------------------

	void updateWindowparameters(mywindow)

	get current window parameters

----------------------------------------------------------------------
*********************************************************************/

void updatewindowparameters(struct mywindow *win)
{
	win->winleft = win->window->LeftEdge;
	win->wintop = win->window->TopEdge;
	win->winwidth = win->window->Width;
	win->winheight = win->window->Height;
	win->innerleft = 0;
	win->innertop = 0;
	win->innerwidth = win->winwidth - win->window->BorderLeft - win->window->BorderRight;
	win->innerheight = win->winheight - win->window->BorderTop - win->window->BorderBottom;
}


/*********************************************************************
----------------------------------------------------------------------

	deletewindow (mywindow)

----------------------------------------------------------------------
*********************************************************************/

void deletewindow (struct mywindow *win)
{
	if (win)
	{
		if (win->window)
		{
			CloseWindow(win->window);
		}

		Free(win);
	}
}



/*********************************************************************
----------------------------------------------------------------------

	mywindow = createwindow (screen)

----------------------------------------------------------------------
*********************************************************************/

#define inserttag(x,t,d) {(x)->ti_Tag=(t);((x)++)->ti_Data=(ULONG)(d);}

struct mywindow *createwindow (struct Screen *scr)
{
	struct mywindow *win;

	if (win = Malloclear(sizeof(struct mywindow)))
	{
		BOOL success = FALSE;
		struct TagItem *taglist;

		win->screen = scr;


		if(taglist = AllocateTagItems(20))
		{
			UWORD visibleWidth, visibleHeight, visibleMidX, visibleMidY;
			UWORD visibleLeft, visibleTop;
			WORD winwidth, winheight, wintop, winleft;
			struct TagItem *tp = taglist;
			ULONG modeID;

			visibleWidth = scr->Width;
			visibleHeight = scr->Height;

			if ((modeID = GetVPModeID(&scr->ViewPort)) != INVALID_ID)
			{
				DisplayInfoHandle dih;

				if(dih = FindDisplayInfo(modeID))
				{
					struct DimensionInfo di;

					if(GetDisplayInfoData(dih, (UBYTE*) &di, sizeof(di), DTAG_DIMS, modeID))
					{
						visibleWidth = di.TxtOScan.MaxX - di.TxtOScan.MinX;
						visibleHeight = di.TxtOScan.MaxY - di.TxtOScan.MinY;
					}
				}
			}

			visibleLeft = -scr->ViewPort.DxOffset;
			visibleTop = -scr->ViewPort.DyOffset;

			visibleMidX = visibleWidth/2 - scr->ViewPort.DxOffset;
			visibleMidY = visibleHeight/2 - scr->ViewPort.DyOffset;

			winwidth = MAX(visibleWidth * 3 / 7, DEFAULT_MINWIDTH);
			winheight = MAX(visibleHeight * 3 / 7, DEFAULT_MINHEIGHT);
			inserttag(tp, WA_Width, winwidth);
			inserttag(tp, WA_Height, winheight);

			winleft = visibleMidX - winwidth/2;
			wintop = visibleMidY - winheight/2;
			inserttag(tp, WA_Left, winleft);
			inserttag(tp, WA_Top, wintop);

			win->otherwinpos[0] = visibleLeft;
			win->otherwinpos[1] = visibleTop;
			win->otherwinpos[2] = visibleWidth;
			win->otherwinpos[3] = visibleHeight;

			inserttag(tp, WA_Zoom, &win->otherwinpos);

			inserttag(tp, WA_PubScreen, scr);

			inserttag(tp, WA_Title, DEFAULT_WINTITLE);

			inserttag(tp, WA_NewLookMenus, TRUE);


			inserttag(tp, WA_Flags,
						WFLG_GIMMEZEROZERO |
						WFLG_SIZEBBOTTOM | WFLG_DRAGBAR |
						WFLG_SIZEGADGET | WFLG_DEPTHGADGET | WFLG_ACTIVATE |
						WFLG_CLOSEGADGET | WFLG_SIMPLE_REFRESH);

			inserttag(tp, WA_IDCMP,
						IDCMP_CLOSEWINDOW | IDCMP_REFRESHWINDOW |
						IDCMP_NEWSIZE | IDCMP_VANILLAKEY);

			inserttag(tp, WA_MinWidth, DEFAULT_MINWIDTH);
			inserttag(tp, WA_MinHeight, DEFAULT_MINHEIGHT);
			inserttag(tp, WA_MaxWidth, DEFAULT_MAXWIDTH);
			inserttag(tp, WA_MaxHeight, DEFAULT_MAXHEIGHT);

			inserttag(tp, TAG_DONE, 0);

			if(win->window = OpenWindowTagList(NULL, taglist))
			{
				win->idcmpSignal = 1L << win->window->UserPort->mp_SigBit;

				success = TRUE;
			}

			FreeTagItems(taglist);
		}


		if (!success)
		{
			deletewindow(win);
			win = NULL;
		}
	}

	return win;
}

#undef inserttag
