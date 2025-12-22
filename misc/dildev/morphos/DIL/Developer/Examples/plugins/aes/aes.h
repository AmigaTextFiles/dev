/*
 * aes.dilp - AES cipher plugin for DIL
 * Copyright ©2004-2009 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 *
 *
 * Based on 7z v4.58, 2008-03-26 Igor Pavlov
 * Ported to MorphOS, 2008-10-01 Rupert Hausberger <naTmeg@gmx.net>
 */

#ifndef _AES_H
#define _AES_H 1

//-----------------------------------------------------------------------------

#if defined(__GNUC__)
#pragma pack(2)
#endif

//-----------------------------------------------------------------------------

#define AES_BLOCK_SIZE 16

typedef struct
{
	ULONG 	rkey[(14 + 1) * 4];
	unsigned numRounds2;
} AESContext;

void AES_Init(void);

void AES_SetKeyEncode(AESContext *p, const UBYTE *key, unsigned keySize);
void AES_SetKeyDecode(AESContext *p, const UBYTE *key, unsigned keySize);

void AES_Encode32(const AESContext *p, const ULONG *src, ULONG *dest);
void AES_Decode32(const AESContext *p, const ULONG *src, ULONG *dest);

//-----------------------------------------------------------------------------

typedef struct
{
	ULONG 		prev[4];
	AESContext 	aes;
} AESContextCbc;

void AES_InitCbc(AESContextCbc *p, const UBYTE *iv);
void AES_InitCbc4(AESContextCbc *p, const ULONG *iv);

ULONG AES_EncodeCbc(AESContextCbc *p, const UBYTE *src, UBYTE *dst, ULONG size);
ULONG AES_DecodeCbc(AESContextCbc *p, const UBYTE *src, UBYTE *dst, ULONG size);

//-----------------------------------------------------------------------------

#if defined(__GNUC__)
#pragma pack()
#endif

//-----------------------------------------------------------------------------

#endif /* _AES_H */

