
#include <local/typedefs.h>

/*
 * reset the break signal and return the break status
 */

#define SBF (SIGBREAKF_CTRL_C|SIGBREAKF_CTRL_D)

long
resetbreak()
{
    return(SetSignal(0,SBF) & SBF);
}

