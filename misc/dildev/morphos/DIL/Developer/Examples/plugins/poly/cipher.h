/*
 * poly.dilp - Polymorphic-cipher plugin for DIL
 * Copyright ©2004-2007 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 */

#ifndef CIPHER_H
#define CIPHER_H 1

//-----------------------------------------------------------------------------

#if defined(__GNUC__)
#pragma pack(2)
#endif

//-----------------------------------------------------------------------------

typedef struct CIPHER_Instance
{
	//setup
	ULONG  ci_Size;          //blocksize/seedsize in bytes
	ULONG  ci_SizeWords;     //blocksize/seedsize in words (ci_Size>>2)
	APTR   ci_Seed;          //pointer to the seed-buffer, ci_Size bytes long

	APTR (*ci_Setup  )(struct CIPHER_Instance *); //pointer to the setup-function
	void (*ci_Cleanup)(struct CIPHER_Instance *); //pointer to the cleanup-function
	BOOL (*ci_Decrypt)(struct CIPHER_Instance *); //pointer to the decrypt-function
	BOOL (*ci_Encrypt)(struct CIPHER_Instance *); //pointer to the encrypt-function

	APTR   ci_User;          //result of private ci_Setup-function

	//current request
	APTR   ci_Source;        //pointer to the src-buffer, ci_Size * ci_CurrentBlocks bytes long
	APTR   ci_Destination;   //pointer to the dst-buffer, ci_Size * ci_CurrentBlocks bytes long

	ULONG  ci_CurrentBlock;  //logical block address (LBA)
	ULONG  ci_CurrentBlocks; //number of blocks
	ULONG  ci_CurrentWords;  //number of blocks in words
	
	UBYTE  ci_Mode;          //1=read/decrypt, 2=write/encrypt
} CIPHER_Instance;

//-----------------------------------------------------------------------------

#if defined(__GNUC__)
#pragma pack()
#endif

//-----------------------------------------------------------------------------

CIPHER_Instance *CIPHER_Init(ULONG size);
void CIPHER_Exit(CIPHER_Instance *ci);

void CIPHER_Fill(CIPHER_Instance *ci, APTR src, APTR dst, APTR seed, ULONG block, ULONG blocks, UBYTE mode);

BOOL CIPHER_Process(CIPHER_Instance *ci);

//-----------------------------------------------------------------------------

#endif /* CIPHER_H */

