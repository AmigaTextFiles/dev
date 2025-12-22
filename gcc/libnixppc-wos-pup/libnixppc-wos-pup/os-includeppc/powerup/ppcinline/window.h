/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_WINDOW_H
#define _PPCINLINE_WINDOW_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef WINDOW_BASE_NAME
#define WINDOW_BASE_NAME WindowBase
#endif /* !WINDOW_BASE_NAME */

#define WINDOW_GetClass() \
	LP0(0x1e, Class *, WINDOW_GetClass, \
	, WINDOW_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_WINDOW_H */
