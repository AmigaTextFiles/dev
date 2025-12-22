

/*
 * CHECKBREAK()
 *
 *	Return	1 = break pressed,
 *		0 = break not pressed
 */

#include <local/typedefs.h>

#define SBF  (SIGBREAKF_CTRL_C|SIGBREAKF_CTRL_D)

int
checkbreak()
{
    return(SetSignal(0,0) & SBF);
}

