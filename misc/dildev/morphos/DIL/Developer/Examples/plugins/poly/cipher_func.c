/*
 * poly.dilp - Polymorphic-cipher plugin for DIL
 * Copyright ©2004-2007 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 */

#include <exec/types.h>

#include <clib/debug_protos.h>
#include <proto/exec.h>

#include "cipher.h"
#include "cipher_func.h"

//-----------------------------------------------------------------------------

#if defined(__GNUC__)
#pragma pack(2)
#endif

//-----------------------------------------------------------------------------

typedef void (*FPTR)(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size);

typedef struct func_Data
{
	FPTR f_Table[45];
	FPTR f_Func[32768>>2];
	APTR f_Temp;
} func_Data;

//-----------------------------------------------------------------------------

#if defined(__GNUC__)
#pragma pack()
#endif

//-----------------------------------------------------------------------------
/*
 * 36 mixing functions
 *  8 rotating functions
 *  1 blind function
 * ----------------
 * 45 functions
 */

#define MAX32 0xfffffffful

/* 36 mixing */
#define MIX1(x, y, z)  ((x) ^  (y)  ^    (z))
#define MIX2(x, y, z)  ((y) ^ ((x)  |   ~(z)))
#define MIX3(x, y, z) (((x) &  (y)) ^ ((~(x)) &  (z)))
#define MIX4(x, y, z) (((x) &  (y)) |  (~(x)  &  (z)))
#define MIX5(x, y, z) (((x) &  (z)) |   ((y)  & ~(z)))
#define MIX6(x, y, z) (((x) &  (y)) ^   ((x)  &  (z)) ^ ((y) & (z)))

static void func_A1(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX1(seed[pos], seed[size - pos - 1], tmp[pos]) & MAX32;
}

static void func_A2(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX1(seed[pos], tmp[pos], seed[size - pos - 1]) & MAX32;
}

static void func_A3(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX1(seed[size - pos - 1], seed[pos], tmp[pos]) & MAX32;
}

static void func_A4(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX1(seed[size - pos - 1], tmp[pos], seed[pos]) & MAX32;
}

static void func_A5(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX1(tmp[pos], seed[pos], seed[size - pos - 1]) & MAX32;
}

static void func_A6(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX1(tmp[pos], seed[size - pos - 1], seed[pos]) & MAX32;
}

static void func_B1(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX2(seed[pos], seed[size - pos - 1], tmp[pos]) & MAX32;
}

static void func_B2(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX2(seed[pos], tmp[pos], seed[size - pos - 1]) & MAX32;
}

static void func_B3(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX2(seed[size - pos - 1], seed[pos], tmp[pos]) & MAX32;
}

static void func_B4(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX2(seed[size - pos - 1], tmp[pos], seed[pos]) & MAX32;
}

static void func_B5(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX2(tmp[pos], seed[pos], seed[size - pos - 1]) & MAX32;
}

static void func_B6(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX2(tmp[pos], seed[size - pos - 1], seed[pos]) & MAX32;
}

static void func_C1(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX3(seed[pos], seed[size - pos - 1], tmp[pos]) & MAX32;
}

static void func_C2(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX3(seed[pos], tmp[pos], seed[size - pos - 1]) & MAX32;
}

static void func_C3(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX3(seed[size - pos - 1], seed[pos], tmp[pos]) & MAX32;
}

static void func_C4(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX3(seed[size - pos - 1], tmp[pos], seed[pos]) & MAX32;
}

static void func_C5(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX3(tmp[pos], seed[pos], seed[size - pos - 1]) & MAX32;
}

static void func_C6(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX3(tmp[pos], seed[size - pos - 1], seed[pos]) & MAX32;
}

static void func_D1(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX4(seed[pos], seed[size - pos - 1], tmp[pos]) & MAX32;
}

static void func_D2(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX4(seed[pos], tmp[pos], seed[size - pos - 1]) & MAX32;
}

static void func_D3(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX4(seed[size - pos - 1], seed[pos], tmp[pos]) & MAX32;
}

static void func_D4(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX4(seed[size - pos - 1], tmp[pos], seed[pos]) & MAX32;
}

static void func_D5(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX4(tmp[pos], seed[pos], seed[size - pos - 1]) & MAX32;
}

static void func_D6(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX4(tmp[pos], seed[size - pos - 1], seed[pos]) & MAX32;
}

static void func_E1(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX5(seed[pos], seed[size - pos - 1], tmp[pos]) & MAX32;
}

static void func_E2(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX5(seed[pos], tmp[pos], seed[size - pos - 1]) & MAX32;
}

static void func_E3(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX5(seed[size - pos - 1], seed[pos], tmp[pos]) & MAX32;
}

static void func_E4(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX5(seed[size - pos - 1], tmp[pos], seed[pos]) & MAX32;
}

static void func_E5(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX5(tmp[pos], seed[pos], seed[size - pos - 1]) & MAX32;
}

static void func_E6(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX5(tmp[pos], seed[size - pos - 1], seed[pos]) & MAX32;
}

static void func_F1(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX6(seed[pos], seed[size - pos - 1], tmp[pos]) & MAX32;
}

static void func_F2(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX6(seed[pos], tmp[pos], seed[size - pos - 1]) & MAX32;
}

static void func_F3(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX6(seed[size - pos - 1], seed[pos], tmp[pos]) & MAX32;
}

static void func_F4(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX6(seed[size - pos - 1], tmp[pos], seed[pos]) & MAX32;
}

static void func_F5(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX6(tmp[pos], seed[pos], seed[size - pos - 1]) & MAX32;
}

static void func_F6(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += MIX6(tmp[pos], seed[size - pos - 1], seed[pos]) & MAX32;
}

/* 8 rotating */
#define LROT(x, n) (((x) << (n)) | ((x) >> (32 - (n))))
#define RROT(x, n) (((x) >> (n)) | ((x) << (32 - (n))))

static void func_G1(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += LROT(seed[size - pos - 1], tmp[pos] % 32 + 1) & MAX32;
}

static void func_G2(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += RROT(seed[size - pos - 1], tmp[pos] % 32 + 1) & MAX32;
}

static void func_H1(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += LROT(seed[pos], tmp[size - pos - 1] % 32 + 1) & MAX32;
}

static void func_H2(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += RROT(seed[pos], tmp[size - pos - 1] % 32 + 1) & MAX32;
}

static void func_I1(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += LROT(tmp[pos], seed[size - pos - 1] % 32 + 1) & MAX32;
}

static void func_I2(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += RROT(tmp[pos], seed[size - pos - 1] % 32 + 1) & MAX32;
}

static void func_J1(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += LROT(tmp[size - pos - 1], seed[pos] % 32 + 1) & MAX32;
}

static void func_J2(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	tmp[pos] += RROT(tmp[size - pos - 1], seed[pos] % 32 + 1) & MAX32;
}

/* 1 blind */
static void func_K0(ULONG *seed, ULONG *tmp, ULONG pos, ULONG size)
{
	/* do nothing */
}

//-----------------------------------------------------------------------------

static void func_Crypt(CIPHER_Instance *ci, ULONG count)
{
	func_Data *F = ci->ci_User;
	register ULONG size = ci->ci_SizeWords;
	register ULONG *src = &((ULONG *)ci->ci_Source)[size * count];
	register ULONG *dst = &((ULONG *)ci->ci_Destination)[size * count];
	register ULONG *seed = (ULONG *)ci->ci_Seed;
	register ULONG *tmp = (ULONG *)F->f_Temp;
	register ULONG i, j = 2ul, block = ci->ci_CurrentBlock + count;

	/* pass 1, initiate the temp-buffer with the seed and the current block-number (LBA) */
	tmp[0] = seed[0] ^ LROT(block, seed[0] % 32 + 1);
	for (i = 1ul; i < size; i++) {
		tmp[i] = (1812433253ul * (tmp[i - 1] ^ (tmp[i - 1] >> 30)) + i) & MAX32;
		tmp[i] += (seed[i - 1] ^ LROT(block, tmp[i - 1] % 32 + 1)) & MAX32;
	}
	tmp[0] = (1812433253ul * (tmp[i - 1] ^ (tmp[i - 1] >> 30)) + i) & MAX32;
	tmp[0] += (seed[i - 1] ^ LROT(block, tmp[i - 1] % 32 + 1)) & MAX32;

	/* pass 2, build and call the dynamic func-table */
	while (j-- > 0) /* run two times */
	{
		/* 57.14%/42.85% chance mixing/rotating */
		/* 88.88%/11.11% chance for rotating/idle */
		for (i = 0ul; i < size; i++)
			F->f_Func[i] = F->f_Table[(tmp[i] % 7 < 4) ? (tmp[size - i - 1] % 36) : (36 + (tmp[size - i - 1] % 9))];

		/* call func-table */
		for (i = 0ul; i < size; i++)
			F->f_Func[i](seed, tmp, i, size);
	}

	/* pass 3, do the en-/decrypt */
	while (size-- > 0)
		*dst++ = *src++ ^ *tmp++; /* destination = source XOR temp */
}

//-----------------------------------------------------------------------------

APTR func_Setup(CIPHER_Instance *ci)
{
	func_Data *F; /* private cipher data */
	UBYTE i = 0;

	if (!(F = AllocVec(sizeof(func_Data), MEMF_PUBLIC | MEMF_CLEAR)))
		return NULL;
	if (!(F->f_Temp = AllocVec(ci->ci_Size, MEMF_PUBLIC | MEMF_CLEAR))) {
		FreeVec(F);
		return NULL;
	}
	F->f_Table[i++] = func_A1;
	F->f_Table[i++] = func_A2;
	F->f_Table[i++] = func_A3;
	F->f_Table[i++] = func_A4;
	F->f_Table[i++] = func_A5;
	F->f_Table[i++] = func_A6;
	F->f_Table[i++] = func_B1;
	F->f_Table[i++] = func_B2;
	F->f_Table[i++] = func_B3;
	F->f_Table[i++] = func_B4;
	F->f_Table[i++] = func_B5;
	F->f_Table[i++] = func_B6;
	F->f_Table[i++] = func_C1;
	F->f_Table[i++] = func_C2;
	F->f_Table[i++] = func_C3;
	F->f_Table[i++] = func_C4;
	F->f_Table[i++] = func_C5;
	F->f_Table[i++] = func_C6;
	F->f_Table[i++] = func_D1;
	F->f_Table[i++] = func_D2;
	F->f_Table[i++] = func_D3;
	F->f_Table[i++] = func_D4;
	F->f_Table[i++] = func_D5;
	F->f_Table[i++] = func_D6;
	F->f_Table[i++] = func_E1;
	F->f_Table[i++] = func_E2;
	F->f_Table[i++] = func_E3;
	F->f_Table[i++] = func_E4;
	F->f_Table[i++] = func_E5;
	F->f_Table[i++] = func_E6;
	F->f_Table[i++] = func_F1;
	F->f_Table[i++] = func_F2;
	F->f_Table[i++] = func_F3;
	F->f_Table[i++] = func_F4;
	F->f_Table[i++] = func_F5;
	F->f_Table[i++] = func_F6;
	F->f_Table[i++] = func_G1;
	F->f_Table[i++] = func_G2;
	F->f_Table[i++] = func_H1;
	F->f_Table[i++] = func_H2;
	F->f_Table[i++] = func_I1;
	F->f_Table[i++] = func_I2;
	F->f_Table[i++] = func_J1;
	F->f_Table[i++] = func_J2;
	F->f_Table[i++] = func_K0;

	return F;
}

void func_Cleanup(CIPHER_Instance *ci)
{
	func_Data *F = ci->ci_User;
	
	FreeVec(F->f_Temp);
	FreeVec(F);
}

BOOL func_Process(CIPHER_Instance *ci)
{
	ULONG block;

	for (block = 0ul; block < ci->ci_CurrentBlocks; block++)
		func_Crypt(ci, block);
	
	return TRUE;
}

//-----------------------------------------------------------------------------



























