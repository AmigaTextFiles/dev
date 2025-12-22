/*
 * aes.dilp - AES cipher plugin for DIL
 * Copyright ©2004-2009 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 */

#ifndef MISC_H
#define MISC_H 1

//------------------------------------------------------------------------------

void memclr(APTR data, ULONG size);

//------------------------------------------------------------------------------

ULONG dec2str(ULONG value, UBYTE *buffer, ULONG base);

//------------------------------------------------------------------------------

#endif /* MISC_H */

