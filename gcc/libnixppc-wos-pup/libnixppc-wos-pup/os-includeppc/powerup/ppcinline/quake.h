/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_QUAKE_H
#define _PPCINLINE_QUAKE_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef QUAKE_BASE_NAME
#define QUAKE_BASE_NAME QuakeBase
#endif /* !QUAKE_BASE_NAME */

#define Quake_QueryInput(ReadJoy, port, qinfo) \
	LP3NR(0x1e, Quake_QueryInput, BOOL, ReadJoy, d1, struct MsgPort *, port, a0, struct InputInfo *, qinfo, a1, \
	, QUAKE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_QUAKE_H */
