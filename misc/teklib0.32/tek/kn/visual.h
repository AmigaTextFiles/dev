
#ifndef _TEK_KERNEL_VISUAL_H
#define	_TEK_KERNEL_VISUAL_H

/* 
**	tek/kn/visual.h
**	TEKlib kernel visual interface
*/

#include "tek/type.h"
#include "tek/exec.h"
#include "tek/visual.h"
#include "tek/kn/exec.h"

#ifdef KNVISDEBUG
	#define	dbvprintf(l,x)		{if (l > 0 && l >= KNVISDEBUG) platform_dbprintf(x);}
	#define	dbvprintf1(l,x,a)	{if (l > 0 && l >= KNVISDEBUG) platform_dbprintf1(x,a);}
	#define	dbvprintf2(l,x,a,b)	{if (l > 0 && l >= KNVISDEBUG) platform_dbprintf2(x,a,b);}
#else
	#define	dbvprintf(l,x)
	#define	dbvprintf1(l,x,a)
	#define	dbvprintf2(l,x,a,b)
#endif


struct knvisual_parameters
{
	TUINT pixelwidth, pixelheight;
	TUINT textwidth, textheight;
	TUINT fontwidth, fontheight;
};


extern TAPTR kn_createvisual(TAPTR mmu, TSTRPTR preftitle, TINT prefw, TINT prefh)			__ELATE_QCALL__(("qcall lib/tek/kn/visual/createvisual"));
extern TVOID kn_destroyvisual(TAPTR visual)													__ELATE_QCALL__(("qcall lib/tek/kn/visual/destroyvisual"));
extern TBOOL kn_getnextinput(TAPTR visual, TIMSG *newimsg, TUINT eventmask)					__ELATE_QCALL__(("qcall lib/tek/kn/visual/getnextinput"));
extern TVOID kn_setinputmask(TAPTR v, TUINT eventmask)										__ELATE_QCALL__(("qcall lib/tek/kn/visual/setinputmask"));
extern TAPTR kn_allocpen(TAPTR visual, TUINT rgb)											__ELATE_QCALL__(("qcall lib/tek/kn/visual/allocpen"));
extern TVOID kn_freepen(TAPTR visual, TAPTR pen)											__ELATE_QCALL__(("qcall lib/tek/kn/visual/freepen"));
extern TVOID kn_setfgpen(TAPTR visual, TAPTR pen)											__ELATE_QCALL__(("qcall lib/tek/kn/visual/setfgpen"));
extern TVOID kn_setbgpen(TAPTR visual, TAPTR pen)											__ELATE_QCALL__(("qcall lib/tek/kn/visual/setbgpen"));
extern TVOID kn_line(TAPTR visual, TINT x1, TINT y1, TINT x2, TINT y2)						__ELATE_QCALL__(("qcall lib/tek/kn/visual/line"));
extern TVOID kn_rect(TAPTR visual, TINT x1, TINT y1, TINT x2, TINT y2)						__ELATE_QCALL__(("qcall lib/tek/kn/visual/rect"));
extern TVOID kn_frect(TAPTR visual, TINT x1, TINT y1, TINT x2, TINT y2)						__ELATE_QCALL__(("qcall lib/tek/kn/visual/frect"));
extern TVOID kn_plot(TAPTR v, TINT x, TINT y)												__ELATE_QCALL__(("qcall lib/tek/kn/visual/plot"));
extern TVOID kn_getparameters(TAPTR v, struct knvisual_parameters *p)						__ELATE_QCALL__(("qcall lib/tek/kn/visual/getparameters"));
extern TVOID kn_scroll(TAPTR v, TINT posx, TINT posy, TINT w, TINT h, TINT dx, TINT dy)		__ELATE_QCALL__(("qcall lib/tek/kn/visual/scroll"));
extern TVOID kn_drawtext(TAPTR v, TINT x, TINT y, TSTRPTR text, TUINT len)					__ELATE_QCALL__(("qcall lib/tek/kn/visual/drawtext"));
extern TBOOL kn_waitvisual(TAPTR v, TKNOB *timer, TKNOB *evt)								__ELATE_QCALL__(("qcall lib/tek/kn/visual/waitvisual"));
extern TVOID kn_flush(TAPTR v, TINT x, TINT y, TINT w, TINT h)								__ELATE_QCALL__(("qcall lib/tek/kn/visual/flush"));
extern TVOID kn_drawrgb(TAPTR v, TUINT *buf, TINT x, TINT y, TINT w, TINT h, TINT totwidth)	__ELATE_QCALL__(("qcall lib/tek/kn/visual/drawrgb"));

#endif
