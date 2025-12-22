/*
 * aes.dilp - AES cipher plugin for DIL
 * Copyright ©2004-2009 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * crc128 v1.0 (01.10.2008)
 * Copyright ©2009 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * This package is free software under the Artistic license:
 * see the file COPYING distributed together with this code.
 */

#ifndef CRC128_H
#define CRC128_H 1

/*------------------------------------------------------------------------*/

/* enable 64bit version */
#undef CRC128_64BIT

/*------------------------------------------------------------------------*/

typedef unsigned char 		 u8; /* 1 bytes */
typedef unsigned long 		u32; /* 4 bytes */
typedef unsigned long long u64; /* 8 bytes */

#ifdef CRC128_64BIT
typedef struct { u64 A, B; } u128;
#else
typedef struct { u32 A, B, C, D; } u128;
#endif

/*------------------------------------------------------------------------*/

extern const u128 CRC128_INITIAL;

u128 crc128(u128 crc, const u8 *buf, u32 buflen);

/*------------------------------------------------------------------------*/

#endif /* CR128_H */

