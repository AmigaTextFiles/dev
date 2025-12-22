#include <exec/execbase.h>

#include "RawIO2Parallel.h"


void *ResidentInit(__reg("d0") void *zero, __reg("a0") segList, __reg("a6") struct ExecBase *SysBase) {
	RawIO2Parallel(SysBase);

	// The basic resident init init function is more or less a library init
	// function, but with no library base supplied. We should be receiving a
	// NULL in the zero argument, which is just forwarded as return value when
	// done.
	//
	// Returning NULL is technically an indication of error according to the
	// documentation for InitResident(), but there is no need to allocate
	// anything for this patch, so there is nothing allocated to return.
	//
	// Also, for resident modules of type 0 (not a regular library, device or
	// resource which would be added a list), this value doesn't appear to be
	// checked as I have yet to see any tool refusing to load it or failure
	// of the OS to initialize it (it would be initialized before the OS can
	// inspect the return value anyway).
	//
	// If you have any more information on this topic, please get back to me :)
	return zero;
}
