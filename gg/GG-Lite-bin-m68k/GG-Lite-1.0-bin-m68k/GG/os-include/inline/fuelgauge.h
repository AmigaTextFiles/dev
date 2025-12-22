#ifndef _INLINE_FUELGAUGE_H
#define _INLINE_FUELGAUGE_H

#ifndef CLIB_FUELGAUGE_PROTOS_H
#define CLIB_FUELGAUGE_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif
#ifndef  INTUITION_CLASSES_H
#include <intuition/classes.h>
#endif

#ifndef FUELGAUGE_BASE_NAME
#define FUELGAUGE_BASE_NAME FuelGaugeBase
#endif

#define FUELGAUGE_GetClass() \
	LP0(0x1e, Class *, FUELGAUGE_GetClass, \
	, FUELGAUGE_BASE_NAME)

#endif /*  _INLINE_FUELGAUGE_H  */
