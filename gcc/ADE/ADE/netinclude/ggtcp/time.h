
#ifndef GGTCP_TIME_H
#define GGTCP_TIME_H

#include <sys/time.h>

/* Deleted a bunch of stuff. */

/*
 * We must define the timerequest, because compatible_timeval is not 
 * compatible with old timeval...
 */

#include <devices/timer.h>
/*
#include <proto/timer.h>
*/

/*
 * Operations on timevals.
 *
 */
#define	timerisset(tvp)		((tvp)->tv_sec || (tvp)->tv_usec)
#define	timerclear(tvp)		(tvp)->tv_sec = (tvp)->tv_usec = 0

#endif /* !GGTCP_TIME_H */

