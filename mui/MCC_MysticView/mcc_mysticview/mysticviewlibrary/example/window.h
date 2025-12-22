
#ifndef __WINDOW__
#define __WINDOW__ 1


#include <intuition/intuition.h>

/*********************************************************************
----------------------------------------------------------------------

	structures

----------------------------------------------------------------------
*********************************************************************/

struct mywindow
{
	struct Screen *screen;
	struct Window *window;
	ULONG idcmpSignal;

	UWORD winleft, wintop;
	UWORD winwidth, winheight;
	UWORD innerwidth, innerheight;
	UWORD innerleft, innertop;

	WORD otherwinpos[4];			/* alternate window position x,y,w,h */
};



/*********************************************************************
----------------------------------------------------------------------

	prototypes

----------------------------------------------------------------------
*********************************************************************/


void updatewindowparameters(struct mywindow *win);
void deletewindow (struct mywindow *win);
struct mywindow *createwindow (struct Screen *scr);

#endif
