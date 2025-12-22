#include <exec/exec.h>
#include <proto/exec.h>

#include "Parallel.h"

extern LONG LVORawIOInit;
extern LONG LVORawPutChar;
extern LONG LVORawMayGetChar;

// Putting SysBase in a6 is not necessary here, it is just to make vbcc
// produce simpler/better code.
void RawIO2Parallel(__reg("a6") void *SysBase) {
	SetFunction(SysBase, &LVORawIOInit, GetParallelIOInitAddr());
	SetFunction(SysBase, &LVORawPutChar, GetParallelPutCharAddr());
	SetFunction(SysBase, &LVORawMayGetChar, GetParallelMayGetCharAddr());
}
