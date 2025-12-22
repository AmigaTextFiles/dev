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

#include "crc128.h"

/*------------------------------------------------------------------------*/

/* do not define  */
#undef FORWARD

/*------------------------------------------------------------------------*/

#ifdef CRC128_64BIT
const u128 CRC128_INITIAL = { 0xffffffffffffffffull, 0xffffffffffffffffull }; /* inital value */
static const u128 POLY128REV = { 0xd5ca646569316db3ull, 0x95ac9329ac4bc9b5ull }; /* polynominal */
#else
const u128 CRC128_INITIAL = { 0xfffffffful, 0xfffffffful, 0xfffffffful, 0xfffffffful }; /* inital value */
static const u128 POLY128REV = { 0xd5ca6465ul, 0x69316db3ul, 0x95ac9329ul, 0xac4bc9b5ul }; /* polynominal */
#endif

/* table holding crc-values */
static u128 crctable[256];
static short crctable_init = 0;

/*------------------------------------------------------------------------*/
/* set/get */

#ifdef CRC128_64BIT
	#define BITS_PER_BYTE 64
	#define TYPE_MAX 0xffffffffffffffffull

	#define set32_0(v,d)	{ (v).A = 0ull; (v).B = (u64)(d); }

	#define get32_0(v) ((u32)((v).B))

	#define get8_00(v) ((u8)( (v).B			& 0xff))
	#define get8_15(v) ((u8)(((v).A >> 56) & 0xff))
#else
	#define BITS_PER_BYTE 32
	#define TYPE_MAX 0xfffffffful

	#define set32_0(v,d)	{ (v).A = (v).B = (v).C = 0ul; (v).D = (d); }

	#define get32_0(v) ((u32)((v).D))

	#define get8_00(v) ((u8)( (v).D			& 0xff))
	#define get8_15(v) ((u8)(((v).A >> 24) & 0xff))
#endif

/*------------------------------------------------------------------------*/

#define SHL(x,n) ((x & TYPE_MAX) << (n)) /* shift left */
#define SHR(x,n) ((x & TYPE_MAX) >> (n)) /* shift right */

/* r = v >> bits */
static u128 lshift(u128 v, u32 bits)
{
	u128 r;
	u32 nbits = BITS_PER_BYTE - bits;

	r.A = SHL(v.A, bits) | SHR(v.B, nbits);
#ifdef CRC128_64BIT
	r.B = SHL(v.B, bits);
#else
	r.B = SHL(v.B, bits) | SHR(v.C, nbits);
	r.C = SHL(v.C, bits) | SHR(v.D, nbits);
	r.D = SHL(v.D, bits);
#endif
	return r;
}

/* r = v << bits */
static u128 rshift(u128 v, u32 bits)
{
	u128 r;
	u32 nbits = BITS_PER_BYTE - bits;

	r.A = SHR(v.A, bits);
	r.B = SHR(v.B, bits) | SHL(v.A, nbits);
#ifndef CRC128_64BIT
	r.C = SHR(v.C, bits) | SHL(v.B, nbits);
	r.D = SHR(v.D, bits) | SHL(v.C, nbits);
#endif
	return r;
}

/* r = v1 ^ v2 */
static u128 xor(u128 v1, u128 v2)
{
	u128 r;

	r.A = v1.A ^ v2.A;
	r.B = v1.B ^ v2.B;
#ifndef CRC128_64BIT
	r.C = v1.C ^ v2.C;
	r.D = v1.D ^ v2.D;
#endif
	return r;
}

/*------------------------------------------------------------------------*/

u128 crc128(u128 crc, const u8 *buf, u32 buflen)
{
	if (!crctable_init) {
		u32 i;

		for (i = 0; i < 256; i++) {
			u128 part;
			u32 j;

			set32_0(part, i);
			for (j = 0; j < 8; j++) {
				if (get32_0(part) & 1)
					part = xor(rshift(part, 1), POLY128REV);
				else
					part = rshift(part, 1);
			}
			crctable[i] = part;
		}
		crctable_init = 1;
	}
	if (!buf || !buflen)
		return CRC128_INITIAL;
	else {
		while (buflen--)
#ifdef FORWARD
			crc = xor(crctable[(get8_15(crc) ^ *buf++) & 0xff], lshift(crc, 8));
#else
			crc = xor(crctable[(get8_00(crc) ^ *buf++) & 0xff], rshift(crc, 8));
#endif
		return crc;
	}
}

/*------------------------------------------------------------------------*/

