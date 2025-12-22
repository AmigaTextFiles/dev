
#ifndef _DTCLASSLIBRARY_H
#define _DTCLASSLIBRARY_H

#include <exec/types.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>

class DTClassLibrary
{
public:
	DTClassLibrary();
	~DTClassLibrary();

	static class DTClassLibrary Default;

	Class * ObtainEngine();

private:
	struct Library *Base;
};

DTClassLibrary DTClassLibrary::Default;

#endif

