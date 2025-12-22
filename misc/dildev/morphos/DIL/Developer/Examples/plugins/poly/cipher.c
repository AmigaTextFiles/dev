/*
 * poly.dilp - Polymorphic-cipher plugin for DIL
 * Copyright ©2004-2007 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 */

#include <proto/debug.h>
#include <proto/exec.h>

#include "cipher.h"
#include "cipher_func.h"

//-----------------------------------------------------------------------------

CIPHER_Instance *CIPHER_Init(ULONG size)
{
	CIPHER_Instance *ci;

	if ((ci = AllocVec(sizeof(CIPHER_Instance), MEMF_PUBLIC | MEMF_CLEAR))) {
		ci->ci_Size = size;
		ci->ci_SizeWords = size >> 2;

		ci->ci_Setup = func_Setup;
		ci->ci_Cleanup = func_Cleanup;
		ci->ci_Decrypt = func_Decrypt;
		ci->ci_Encrypt = func_Encrypt;

		if ((ci->ci_User = ci->ci_Setup(ci)))
			return ci;

		FreeVec(ci);
	}
	return NULL;
}

void CIPHER_Exit(CIPHER_Instance *ci)
{
	if (ci) {
		ci->ci_Cleanup(ci);
		FreeVec(ci);
	}
}

//-----------------------------------------------------------------------------

void CIPHER_Fill(CIPHER_Instance *ci, APTR src, APTR dst, APTR seed, ULONG block, ULONG blocks, UBYTE mode)
{
	ci->ci_Seed = seed;
	
	ci->ci_Source = src;
	ci->ci_Destination = dst;
	
	ci->ci_CurrentBlock = block;
	ci->ci_CurrentBlocks = blocks;
	ci->ci_CurrentWords = ci->ci_SizeWords * blocks;
	
	ci->ci_Mode = mode;
}

//-----------------------------------------------------------------------------

BOOL CIPHER_Process(CIPHER_Instance *ci)
{
	if (ci->ci_Mode == 1)
		ci->ci_Decrypt(ci);
	else
		ci->ci_Encrypt(ci);

	return TRUE;
}

//-----------------------------------------------------------------------------










