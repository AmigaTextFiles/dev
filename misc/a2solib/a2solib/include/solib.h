#ifndef _SOLIB_H_
#define _SOLIB_H_

#include <exec/types.h>
#include <exec/lists.h>

struct SolibContext
{
	struct List				Interfaces;
	struct SignalSemaphore  Lock;
};

#endif
