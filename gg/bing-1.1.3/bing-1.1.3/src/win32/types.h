#ifndef bing_types_h_
#define bing_types_h_

#include <sys/types.h>

/*
 * Missing in Microsoft's types.h
 */

typedef unsigned short	u_short;
typedef unsigned long	u_long;

typedef char* caddr_t;
typedef u_short n_short;		/* short as received from the net */
typedef u_long	n_long;			/* long as received from the net */

typedef	u_long	n_time;			/* ms since 00:00 GMT, byte rev */

#endif	/* End of File */
