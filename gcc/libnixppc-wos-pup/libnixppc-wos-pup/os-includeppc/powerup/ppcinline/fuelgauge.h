/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_FUELGAUGE_H
#define _PPCINLINE_FUELGAUGE_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef FUELGAUGE_BASE_NAME
#define FUELGAUGE_BASE_NAME FuelGaugeBase
#endif /* !FUELGAUGE_BASE_NAME */

#define FUELGAUGE_GetClass() \
	LP0(0x1e, Class *, FUELGAUGE_GetClass, \
	, FUELGAUGE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_FUELGAUGE_H */
