#ifndef VCB_PRIVATE_H
#define VCB_PRIVATE_H

#include <exec/semaphores.h>
#include <exec/types.h>
#include "vcb.h"

/* this structure contains the per-class data */
struct VCBperClassData
{
	Class *VCXClass;
};

/* this structure describes an interval by its lower (`left´) bound and its size (diameter) */
struct interval
{
	int offset, size;
};

/* this structure contains all information about one virtual coordinate axis */
struct axis
{
	struct interval real, virtual;
	int total, unit;
	APTR scroller;
};

/* the instance data structure of a Virtual Coordinate Box */
struct VCB
{
	struct axis horiz, vert;
	struct SignalSemaphore semaphore;
	struct Hook *exposure;
	ULONG flags;
	int size_width, size_height;
};

/* gadget IDs for the scrollers */
#define HORIZ_ID	1
#define VERT_ID		2

#endif
