/*
 * aes.dilp - AES cipher plugin for DIL
 * Copyright ©2004-2009 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 */

#include <exec/rawfmt.h>

#include <proto/exec.h>

#include "misc.h"

//------------------------------------------------------------------------------

void memclr(APTR data, ULONG size)
{
	register UBYTE *p = (UBYTE *)data;

	while (size--)
		*p++ = '\0';
}

//-----------------------------------------------------------------------------

/* function to convert a decimal value to a string by a given base
 * value  = input value
 * buffer = output buffer
 * base   = base factor, 10 for dec, 16 for hex, 8 for oct, 2 for bin
 * len    = strlen of the output buffer
 */
ULONG dec2str(ULONG value, UBYTE *buffer, ULONG base)
{
	static const UBYTE table[] = { '0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f' };
	UBYTE *ptr, tmp[32+1];
	ULONG len = 0;

	ptr = tmp + sizeof(tmp) - 1;
	do {
		*ptr-- = table[value % base];
		value /= base;
		len++;
	} while (value > 0);

	CopyMem(++ptr, buffer, len);
	buffer[len] = '\0';

	return len;
}

//------------------------------------------------------------------------------

