#ifndef _RAWIO2PARALLEL_H_
#define _RAWIO2PARALLEL_H_

#include <exec/execbase.h>

// Putting SysBase in a6 is not necessary here, it is just to make vbcc
// produce simpler/better code.
void RawIO2Parallel(__reg("a6") void *SysBase);

#endif
