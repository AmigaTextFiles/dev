#ifndef _PPCINLINE_AMIPX_H
#define _PPCINLINE_AMIPX_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif

#ifndef AMIPX_BASE_NAME
#define AMIPX_BASE_NAME AMIPX_Library
#endif

#define AMIPX_OpenSocket(socknum) \
	LP1(0x1E, WORD, AMIPX_OpenSocket, UWORD, socknum, d0, \
	, AMIPX_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define AMIPX_CloseSocket(socknum) \
	LP1NR(0x24, AMIPX_CloseSocket, UWORD, socknum, d0, \
	, AMIPX_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define AMIPX_ListenForPacket(ecb) \
	LP1(0x2A, WORD, AMIPX_ListenForPacket, struct AMIPX_ECB *, ecb, a0, \
	, AMIPX_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define AMIPX_SendPacket(ecb) \
	LP1(0x30, WORD, AMIPX_SendPacket, struct AMIPX_ECB *, ecb, a0, \
	, AMIPX_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define AMIPX_GetLocalAddr(addrspace) \
	LP1NR(0x36, AMIPX_GetLocalAddr, UBYTE, addrspace, a0, \
	, AMIPX_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define AMIPX_RelinquishControl() \
	LP0NR(0x3C, AMIPX_RelinquishControl, \
	, AMIPX_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define AMIPX_GetLocalTarget(address, localtarget) \
	LP2(0x42, WORD, AMIPX_GetLocalTarget, UBYTE, address, a0, UBYTE, localtarget, a1, \
	, AMIPX_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /*  _PPCINLINE_AMIPX_H  */
