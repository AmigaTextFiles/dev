/*
 * Get some sort of "process id", i.e. address of the Process structure
 */

#include <exec/types.h>
#include <proto/exec.h>

int getpid(void) {

  return (int)FindTask(NULL);
}

