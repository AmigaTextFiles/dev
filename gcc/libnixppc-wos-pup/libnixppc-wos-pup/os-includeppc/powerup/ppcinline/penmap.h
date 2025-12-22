/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_PENMAP_H
#define _PPCINLINE_PENMAP_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef PENMAP_BASE_NAME
#define PENMAP_BASE_NAME PenMapBase
#endif /* !PENMAP_BASE_NAME */

#define PENMAP_GetClass() \
	LP0(0x1e, Class *, PENMAP_GetClass, \
	, PENMAP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_PENMAP_H */
