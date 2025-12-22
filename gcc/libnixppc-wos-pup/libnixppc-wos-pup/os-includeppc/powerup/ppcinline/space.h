/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_SPACE_H
#define _PPCINLINE_SPACE_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef SPACE_BASE_NAME
#define SPACE_BASE_NAME SpaceBase
#endif /* !SPACE_BASE_NAME */

#define SPACE_GetClass() \
	LP0(0x1e, Class *, SPACE_GetClass, \
	, SPACE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_SPACE_H */
