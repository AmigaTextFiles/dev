/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_BUTTON_H
#define _PPCINLINE_BUTTON_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef BUTTON_BASE_NAME
#define BUTTON_BASE_NAME ButtonBase
#endif /* !BUTTON_BASE_NAME */

#define BUTTON_GetClass() \
	LP0(0x1e, Class *, BUTTON_GetClass, \
	, BUTTON_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_BUTTON_H */
