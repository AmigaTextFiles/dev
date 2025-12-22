
#ifndef _SLIDERLIBRARY_H
#define _SLIDERLIBRARY_H

#include <exec/types.h>
#include <intuition/classes.h>

class SliderLibrary
{
public:
	SliderLibrary();
	~SliderLibrary();

	static class SliderLibrary Default;

	Class * SLIDER_GetClass();

private:
	struct Library *Base;
};

SliderLibrary SliderLibrary::Default;

#endif

