#ifndef _INLINE_POTGO_H
#define _INLINE_POTGO_H

#ifndef CLIB_POTGO_PROTOS_H
#define CLIB_POTGO_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef POTGO_BASE_NAME
#define POTGO_BASE_NAME PotgoBase
#endif

#define AllocPotBits(bits) \
	LP1(0x6, UWORD, AllocPotBits, ULONG, bits, d0, \
	, POTGO_BASE_NAME)

#define FreePotBits(bits) \
	LP1NR(0xc, FreePotBits, ULONG, bits, d0, \
	, POTGO_BASE_NAME)

#define WritePotgo(word, mask) \
	LP2NR(0x12, WritePotgo, ULONG, word, d0, ULONG, mask, d1, \
	, POTGO_BASE_NAME)

#endif /*  _INLINE_POTGO_H  */
