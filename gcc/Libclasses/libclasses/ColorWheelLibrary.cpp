
#ifndef _COLORWHEELLIBRARY_CPP
#define _COLORWHEELLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/ColorWheelLibrary.h>

ColorWheelLibrary::ColorWheelLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("colorwheel.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open colorwheel.library") );
	}
}

ColorWheelLibrary::~ColorWheelLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

VOID ColorWheelLibrary::ConvertHSBToRGB(struct ColorWheelHSB * hsb, struct ColorWheelRGB * rgb)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = hsb;
	register void * a1 __asm("a1") = rgb;

	__asm volatile ("jsr a6@(-30)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

VOID ColorWheelLibrary::ConvertRGBToHSB(struct ColorWheelRGB * rgb, struct ColorWheelHSB * hsb)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = rgb;
	register void * a1 __asm("a1") = hsb;

	__asm volatile ("jsr a6@(-36)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}


#endif

