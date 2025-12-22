/*
 * Get some sort of "process id", i.e. address of the Process structure
 */

#include <exec/types.h>
#ifndef _DCC
#include <proto/exec.h>
#else
#include <clib/exec_protos.h>
#endif

int getpid(void) {

  return (int)FindTask(NULL);
}

