
#ifndef _VISUAL_ELATE_H
#define _VISUAL_ELATE_H	1

#include "tek/type.h"

struct visual_elate
{
	TAPTR buffer;
	TAPTR buffer2;
	TAPTR pixmap;
	TAPTR pixmap2;
	TAPTR ave;
	TAPTR app;
	TAPTR toolkit;
	TAPTR window;
	TAPTR scrollpane;
	TAPTR content;
	TAPTR font;
	TUINT backcolor;
	TINT width;
	TINT height;
	TINT fontwidth;
	TINT fontheight;
	TINT pixelx;
	TINT pixely;
	TINT bgcolor;
	TINT fgcolor;
	TINT textx;
	TINT texty;

		TUINT currentbuttonstate;

		TINT pendingevent;
		TINT pendingx;
		TINT pendingy;
		TUINT pendingkeycooked;
		TBOOL pendingresize;
		TUINT pendingbuttonstate;
		TBOOL evtpending;
		
};


extern TINT getevent(TAPTR visual, TINT *ev, TINT *xp, TINT *yp, TUINT *keycooked, TBOOL *resize, TUINT *buttonstate) __attribute__
((
	"qcall lib/tek/kn/visual/getevent"
));



#endif
