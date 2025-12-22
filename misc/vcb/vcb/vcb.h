#ifndef VCB_H
#define VCB_H

/* This material is Copyright 1992 Stefan Reisner */

#include <intuition/classes.h>
#include <utility/tagitem.h>

/* VCB-specific tag values */
/*
 *	The tag base may be redefined externally if this one happens
 *	to conflict with another one.
 *	Of course you will have to re-compile the class implementation
 *	module then.
 */
#ifndef VCBGA_TagBase
	#define VCBGA_TagBase		(TAG_USER + 0x1000)
#endif
/********************* Attributes ****************************/
/**** settable and gettable ****/
#define VCBGA_ExposureHook	(VCBGA_TagBase + 0x01)
#define VCBGA_HTotal		(VCBGA_TagBase + 0x02)
#define VCBGA_HOffset		(VCBGA_TagBase + 0x03)
#define VCBGA_HUnit			(VCBGA_TagBase + 0x04)
#define VCBGA_VTotal		(VCBGA_TagBase + 0x05)
#define VCBGA_VOffset		(VCBGA_TagBase + 0x06)
#define VCBGA_VUnit			(VCBGA_TagBase + 0x07)
#define VCBGA_Flags			(VCBGA_TagBase + 0x08)	/* only settable with OM_NEW */
#define VCBGA_Interim		(VCBGA_TagBase + 0x09)
#define VCBGA_HScroller		(VCBGA_TagBase + 0x0a)	/* only settable with OM_NEW */
#define VCBGA_VScroller		(VCBGA_TagBase + 0x0b)	/* only settable with OM_NEW */
#define VCBGA_HBorder		(VCBGA_TagBase + 0x0c)	/* only settable with OM_NEW */
#define VCBGA_VBorder		(VCBGA_TagBase + 0x0d)	/* only settable with OM_NEW */
/**** only gettable ****/
#define VCBGA_HSize			(VCBGA_TagBase + 0x0e)
#define VCBGA_VSize			(VCBGA_TagBase + 0x0f)
#define VCBGA_XOrigin		(VCBGA_TagBase + 0x10)
#define VCBGA_YOrigin		(VCBGA_TagBase + 0x11)
#define VCBGA_Semaphore		(VCBGA_TagBase + 0x12)

/* VCB flags */
#define VCBB_INTERIM		0				/* consider redisplay even on interim updates */
#define VCBF_INTERIM		(1<<(VCBB_INTERIM))
#define VCBB_HSCROLLER		1				/* want a horizontal scroller */
#define VCBF_HSCROLLER		(1<<(VCBB_HSCROLLER))
#define VCBB_VSCROLLER		2				/* want a vertical scroller */
#define VCBF_VSCROLLER		(1<<(VCBB_VSCROLLER))
#define VCBB_HBORDER		3				/* put horizontal scroller into bottom border */
#define VCBF_HBORDER		(1<<(VCBB_HBORDER))
#define VCBB_VBORDER		4				/* put vertical scroller into right border */
#define VCBF_VBORDER		(1<<(VCBB_VBORDER))

struct ExposureMsg
{
	ULONG command;
/* command ID for exposure callback */
#define VCBCMD_RENDER		0
	struct RastPort *rp;
	int left, top, width, height;
};

extern Class *initVCBClass( void );
extern int freeVCBClass( Class * );

#endif
