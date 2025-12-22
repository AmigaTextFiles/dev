/*
 * poly.dilp - Polymorphic-cipher plugin for DIL
 * Copyright ©2004-2007 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 */

#ifndef CIPHER_FUNC_H
#define CIPHER_FUNC_H 1

//-----------------------------------------------------------------------------

APTR func_Setup(CIPHER_Instance *ci);
void func_Cleanup(CIPHER_Instance *ci);

BOOL func_Process(CIPHER_Instance *ci);

#define func_Decrypt func_Process
#define func_Encrypt func_Process

//-----------------------------------------------------------------------------

#endif /* CIPHER_FUNC_H */

