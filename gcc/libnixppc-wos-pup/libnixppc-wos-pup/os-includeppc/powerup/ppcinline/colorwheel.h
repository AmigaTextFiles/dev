/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_COLORWHEEL_H
#define _PPCINLINE_COLORWHEEL_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef COLORWHEEL_BASE_NAME
#define COLORWHEEL_BASE_NAME ColorWheelBase
#endif /* !COLORWHEEL_BASE_NAME */

#define ConvertHSBToRGB(hsb, rgb) \
	LP2NR(0x1e, ConvertHSBToRGB, struct ColorWheelHSB *, hsb, a0, struct ColorWheelRGB *, rgb, a1, \
	, COLORWHEEL_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ConvertRGBToHSB(rgb, hsb) \
	LP2NR(0x24, ConvertRGBToHSB, struct ColorWheelRGB *, rgb, a0, struct ColorWheelHSB *, hsb, a1, \
	, COLORWHEEL_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_COLORWHEEL_H */
