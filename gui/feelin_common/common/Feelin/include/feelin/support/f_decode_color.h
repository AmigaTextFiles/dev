#ifndef F_FEELIN_SUPPORT_DECODE_COLOR_H
#define F_FEELIN_SUPPORT_DECODE_COLOR_H

enum    {

		FV_COLORTYPE_NONE,
		FV_COLORTYPE_RGB,
		FV_COLORTYPE_PALETTE,
		FV_COLORTYPE_PEN

		};

uint32 f_decode_color(STRPTR Spec, uint32 Length, uint32 *ValuePtr);

#endif
