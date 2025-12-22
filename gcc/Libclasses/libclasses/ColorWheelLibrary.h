
#ifndef _COLORWHEELLIBRARY_H
#define _COLORWHEELLIBRARY_H

#include <exec/types.h>
#include <gadgets/colorwheel.h>

class ColorWheelLibrary
{
public:
	ColorWheelLibrary();
	~ColorWheelLibrary();

	static class ColorWheelLibrary Default;

	VOID ConvertHSBToRGB(struct ColorWheelHSB * hsb, struct ColorWheelRGB * rgb);
	VOID ConvertRGBToHSB(struct ColorWheelRGB * rgb, struct ColorWheelHSB * hsb);

private:
	struct Library *Base;
};

ColorWheelLibrary ColorWheelLibrary::Default;

#endif

