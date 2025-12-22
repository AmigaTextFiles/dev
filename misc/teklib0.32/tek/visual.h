
#ifndef _TEK_VISUAL_H
#define	_TEK_VISUAL_H

/*
**	tek/visual.h
**	visuals (prototype)
**
**	this section is considered experimental. there is no
**	documentation available yet, you must refer to the
**	example sources, and the comments in the respective
**	functions' implementations (see visual/ for more details)
**
**	basic theory is as follows: 
**
** 	- a 'visual' translates to a scalable window on currently
**	  supported platforms, but it may well translate to a
**	  fixed-size, double buffered chunk of memory in graphics
**	  hardware in the future.
**	- any number of tasks may attach and draw to a visual,
**	  with no explicit locking required. only the creator
**	  may receive input events, though.
**	- create a visual, and for each child task that needs
**	  to draw to it, call TAttachVisual(). use the handle
**	  returned by this function to draw to the visual in your
**	  current context. only the creator may use the handle
**	  returned from TCreateVisual() directly.
**	- some drawing functions are blocking (or synchronous),
**	  others are nonblocking (or asychronous). use TVSync()
**	  to ensure that all drawing commands issued in your
**	  current context have been executed.
**	- syncing does not imply that the visual or an area is
**	  actually exposed. to ensure that any modified buffers
**	  are exposed, use TVFlush() or TVFlushArea(). flush will
**	  synchronize also.
*/

#include <tek/msg.h>


typedef TAPTR TVPEN;

typedef struct _tvisual
{
	THNDL handle;			/* object handle */

	TAPTR parenttask;		/* creator */
	TAPTR task;				/* visual task */
	TBOOL main;				/* is this the main instance? */
	
	TPORT *asyncport;		/* replyport for asynchronous drawjobs, and cache for free drawnodes */


	/*	init data */

	TINT prefwidth, prefheight;
	TSTRPTR preftitle;


	/* main instance only: */

	TAPTR knvisual;			/* kernel visual */
	TPORT *iport;			/* input port (parent context) */
	TPORT *ireplyport;		/* input replyport (child context) */
	
	TKNOB lock;
	TUINT refcount;

	/* attached instance only: */
	
	struct _tvisual *parentvisual;

} TVISUAL;



/*
**	tag items.
**
*/

#define TVISTAGS_					(TTAG_USER + 0x600)
#define TVisual_PixWidth			(TTAG) (TVISTAGS_ + 0)
#define TVisual_PixHeight			(TTAG) (TVISTAGS_ + 1)
#define TVisual_TextWidth			(TTAG) (TVISTAGS_ + 2)
#define TVisual_TextHeight			(TTAG) (TVISTAGS_ + 3)
#define TVisual_FontWidth			(TTAG) (TVISTAGS_ + 4)
#define TVisual_FontHeight			(TTAG) (TVISTAGS_ + 5)
#define TVisual_Title				(TTAG) (TVISTAGS_ + 6)


#define TVISUAL_NUMDRMSG		200
#define TVISUAL_NUMIMSG			200


TBEGIN_C_API

extern TVISUAL *TCreateVisual(TAPTR task, TTAGITEM *tags)								__ELATE_QCALL__(("qcall lib/tek/visual/createvisual"));
extern TVISUAL *TAttachVisual(TAPTR task, TAPTR visual, TTAGITEM *tags)					__ELATE_QCALL__(("qcall lib/tek/visual/attachvisual"));
extern TVPEN TVAllocPen(TAPTR visual, TUINT rgb)										__ELATE_QCALL__(("qcall lib/tek/visual/allocpen"));
extern TVOID TVFreePen(TAPTR visual, TVPEN pen)											__ELATE_QCALL__(("qcall lib/tek/visual/freepen"));
extern TVOID TVRect(TAPTR visual, TINT x, TINT y, TINT w, TINT h, TVPEN pen)			__ELATE_QCALL__(("qcall lib/tek/visual/rect"));
extern TVOID TVFRect(TAPTR visual, TINT x, TINT y, TINT w, TINT h, TVPEN pen)			__ELATE_QCALL__(("qcall lib/tek/visual/frect"));
extern TVOID TVLine(TAPTR visual, TINT x1, TINT y1, TINT x2, TINT y2, TVPEN pen)		__ELATE_QCALL__(("qcall lib/tek/visual/line"));
extern TVOID TVLineArray(TAPTR visual, TINT *array, TINT num, TVPEN pen)				__ELATE_QCALL__(("qcall lib/tek/visual/linearray"));
extern TVOID TVPlot(TAPTR visual, TINT x, TINT y, TVPEN pen)							__ELATE_QCALL__(("qcall lib/tek/visual/plot"));
extern TVOID TVScroll(TAPTR visual, TINT x, TINT y, TINT w, TINT h, TINT dx, TINT dy)	__ELATE_QCALL__(("qcall lib/tek/visual/scroll"));
extern TVOID TVClear(TAPTR visual, TVPEN pen)											__ELATE_QCALL__(("qcall lib/tek/visual/clear"));
extern TVOID TVText(TAPTR visual, TINT x, TINT y, TSTRPTR text, TUINT len, TVPEN bgpen, TVPEN fgpen)	__ELATE_QCALL__(("qcall lib/tek/visual/text"));
extern TVOID TVFlush(TAPTR visual)														__ELATE_QCALL__(("qcall lib/tek/visual/flush"));
extern TVOID TVFlushArea(TAPTR visual, TINT x, TINT y, TINT w, TINT h)					__ELATE_QCALL__(("qcall lib/tek/visual/flusharea"));
extern TVOID TVSync(TAPTR visual)														__ELATE_QCALL__(("qcall lib/tek/visual/sync"));
extern TUINT TVSetInput(TAPTR visual, TUINT clearmask, TUINT setmask)					__ELATE_QCALL__(("qcall lib/tek/visual/setinput"));
extern TVOID TVDrawRGB(TAPTR visual, TINT x, TINT y, TUINT *buffer, TINT w, TINT h, TINT totw)	__ELATE_QCALL__(("qcall lib/tek/visual/drawrgb"));
extern TUINT TVGetAttrs(TAPTR visual, TTAGITEM *tags)									__ELATE_QCALL__(("qcall lib/tek/visual/getattrs"));


TEND_C_API


#define TVJOB_ALLOCPEN		0
#define TVJOB_FREEPEN		1
#define TVJOB_PLOT			2
#define TVJOB_RECT			3
#define TVJOB_FRECT			4
#define TVJOB_LINE			5
#define TVJOB_SCROLL		6
#define TVJOB_CLEAR			7
#define TVJOB_TEXT			8
#define TVJOB_FLUSH			9
#define TVJOB_LINEARRAY		10
#define TVJOB_SETINPUT		11
#define TVJOB_SYNC			12
#define TVJOB_DRAWRGB		13
#define TVJOB_FLUSHAREA		14
#define TVJOB_GETATTRS		15


typedef struct
{
	TUINT jobcode;
	
	union
	{
		struct
		{
			TUINT rgb;
			TVPEN pen;
		} rgbpen;

		struct
		{
			TVPEN pen;
		} pen;
	
		struct
		{
			TINT x,y;
			TVPEN pen;
		} plot;

		struct
		{
			TINT x,y;
			TINT w,h;
		} rect;

		struct
		{
			TINT x,y;
			TINT w,h;
			TVPEN pen;
		} colrect;

		struct
		{
			TINT x,y;
			TINT w,h;
			TINT dx,dy;
		} scroll;
				
		struct
		{
			TINT x,y;
			TSTRPTR text;
			TUINT len;
			TVPEN bgpen, fgpen;
		} text;

		struct
		{
			TINT *array;
			TINT num;
			TVPEN pen;
		} array;
		
		struct
		{
			TUINT setmask;
			TUINT clearmask;
			TUINT oldmask;
		} input;

		struct
		{
			TUINT *rgbbuf;
			TINT x,y;
			TINT w,h,totw;
		} rgb;

		struct
		{
			TINT pixwidth, pixheight;
			TINT fontwidth, fontheight;
			TINT textwidth, textheight;
		} attrs;

	} op;

} TDRAWMSG;





/*
**	input message
*/

typedef struct
{
	TUINT type;						/* input type (see below) */
	TUINT code;						/* input code */
	TUINT qualifier;				/* keyboard qualifier */
	TINT mousex, mousey;			/* mouse position */
	TINT width, height;				/* window dimensions */

} TIMSG;





/*
**	input types
*/

#define TITYPE_NONE				0x00000000
#define TITYPE_ALL				0xffffffff

#define TITYPE_VISUAL_CLOSE		0x00000001		/* close button */
#define TITYPE_VISUAL_FOCUS		0x00000002		/* visual gets focus */
#define TITYPE_VISUAL_UNFOCUS	0x00000004		/* visual is unfocused */
#define TITYPE_VISUAL_NEWSIZE	0x00000008		/* visual is resized */
#define	TITYPE_KEY				0x00000010		/* keystroke (codes see below) */
#define TITYPE_MOUSEMOVE		0x00000020		/* mouse movement */
#define TITYPE_MOUSEBUTTON		0x00000040		/* mouse button (codes see below) */



/*
**	mouse button codes
*/

#define TMBCODE_LEFTDOWN		0x00000001
#define TMBCODE_LEFTUP			0x00000002
#define TMBCODE_RIGHTDOWN		0x00000004
#define TMBCODE_RIGHTUP			0x00000008
#define TMBCODE_MIDDLEDOWN		0x00000010
#define TMBCODE_MIDDLEUP		0x00000020



/*
**	function key codes
*/

#define TKEYCODE_F1				0x00000100
#define TKEYCODE_F2				0x00000101
#define TKEYCODE_F3				0x00000102
#define TKEYCODE_F4				0x00000103
#define TKEYCODE_F5				0x00000104
#define TKEYCODE_F6				0x00000105
#define TKEYCODE_F7				0x00000106
#define TKEYCODE_F8				0x00000107
#define TKEYCODE_F9				0x00000108
#define TKEYCODE_F10			0x00000109
#define TKEYCODE_F11			0x0000010a
#define TKEYCODE_F12			0x0000010b


/*
**	cursor key codes
*/

#define	TKEYCODE_CRSRLEFT		0x00000200
#define	TKEYCODE_CRSRRIGHT		0x00000201
#define	TKEYCODE_CRSRUP			0x00000202
#define	TKEYCODE_CRSRDOWN		0x00000203


/*
**	special key codes
*/

#define TKEYCODE_ESC			0x00000300	/* escape key */
#define TKEYCODE_DEL			0x00000301	/* del key */
#define TKEYCODE_BCKSPC			0x00000302	/* backspace key */
#define TKEYCODE_TAB			0x00000303	/* tab key */
#define TKEYCODE_ENTER			0x00000304	/* return/enter */


/*
**	proprietary key codes
**
**	style guide note:
**
**	whenever your application binds actions to a key from this section,
**	you should offer at least one non-proprietary alternative.
**
**	example: use TKEYQUAL_CONTROL + TKEYCODE_CRSRRIGHT as an alternative
**	to TKEYCODE_POSEND, etc.
**
**	the same applies to the keyboard qualifier TKEYQUAL_PROPRIETARY
**	(see below)
**
*/

#define TKEYCODE_HELP			0x00000400	/* help key (amiga) */
#define TKEYCODE_INSERT			0x00000401	/* insert key (pc) */
#define TKEYCODE_OVERWRITE		0x00000402	/* overwrite key (pc) */
#define	TKEYCODE_PAGEUP			0x00000403	/* page up (pc) */
#define	TKEYCODE_PAGEDOWN		0x00000404	/* page down (pc) */
#define TKEYCODE_POSONE			0x00000405	/* position one key (pc) */
#define TKEYCODE_POSEND			0x00000406	/* position end key (pc) */
#define TKEYCODE_PRINT			0x00000407	/* print key (pc) */
#define TKEYCODE_SCROLL			0x00000408	/* scroll down (pc) */
#define TKEYCODE_PAUSE			0x00000409	/* pause key (pc) */


/*
**	keyboard qualifiers
**
**	style guide notes:
**
**	your application's default or hardcoded key bindings should not
**	rely on TKEYCODE_PROPRIETARY, nor on the LEFT/RIGHT modifiers.
**	usage of the TKEYQUAL_NUMBLOCK qualifier without alternatives
**	is disencouraged, too.
**
*/

#define	TKEYQUAL_NONE				0x0000	/* no qualifier */
#define TKEYQUAL_LEFT				0x0001	/* left modifier */
#define TKEYQUAL_RIGHT				0x0002	/* right modifier */

#define TKEYQUAL_SHIFT				0x0004	/* shift qualifier */
#define TKEYQUAL_LEFT_SHIFT			(TKEYQUAL_SHIFT | TKEYQUAL_LEFT)
#define TKEYQUAL_RIGHT_SHIFT		(TKEYQUAL_SHIFT | TKEYQUAL_RIGHT)

#define TKEYQUAL_CONTROL			0x0008	/* control qualifier */
#define TKEYQUAL_LEFT_CONTROL		(TKEYQUAL_CONTROL | TKEYQUAL_LEFT)
#define TKEYQUAL_RIGHT_CONTROL		(TKEYQUAL_CONTROL | TKEYQUAL_RIGHT)

#define TKEYQUAL_ALT				0x0010	/* alt qualifier */
#define TKEYQUAL_LEFT_ALT			(TKEYQUAL_ALT | TKEYQUAL_LEFT)
#define TKEYQUAL_RIGHT_ALT			(TKEYQUAL_ALT | TKEYQUAL_RIGHT)

#define	TKEYQUAL_PROPRIETARY		0x0020	/* amiga, apple, windows etc. key */
#define TKEYQUAL_LEFT_PROPRIETARY	(TKEYQUAL_PROPRIETARY | TKEYQUAL_LEFT)
#define TKEYQUAL_RIGHT_PROPRIETARY	(TKEYQUAL_PROPRIETARY | TKEYQUAL_RIGHT)

#define TKEYQUAL_NUMBLOCK			0x0040	/* numeric keypad qualifier */



#endif

