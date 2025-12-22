/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_DTCLASS_H
#define _PPCINLINE_DTCLASS_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef DTCLASS_BASE_NAME
#define DTCLASS_BASE_NAME DTClassBase
#endif /* !DTCLASS_BASE_NAME */

#define ObtainEngine() \
	LP0(0x1e, Class *, ObtainEngine, \
	, DTCLASS_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_DTCLASS_H */
