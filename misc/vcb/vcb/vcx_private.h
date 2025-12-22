#ifndef VCX_PRIVATE_H
#define VCX_PRIVATE_H

#include "vcx.h"

/* instance data structure */
struct VCX
{
	int total, top, visible;
	UWORD freedom;
	APTR less_image;
	APTR more_image;
	APTR prop, less, more;
	APTR target;
};

/* button IDs */
#define LESS_ID	1
#define MORE_ID	2

#endif
