#ifndef _RESIDENTINIT_H_
#define _RESIDENTINIT_H_

#include <exec/execbase.h>

void *ResidentInit(__reg("d0") zero, __reg("a0") segList, __reg("a6") struct ExecBase *SysBase);

#endif
