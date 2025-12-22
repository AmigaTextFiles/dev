/*
** encrypt.c - providing 56 bit DES encryption
**
** Copyright (C) 1991 Jochen Obalek
** Revision  (C) 2014 RhoSigma, Roland Heyder
**
** Changes done by RhoSigma, Roland Heyder:
**   (1) general cleanup (bad tab usage, function/variable names were
**       mixed half english half german, bad readable layout of
**       conditionals etc. etc.)
**   (2) complete rework of typing, only using common types defined in
**       the header file to make the source easier portable to another
**       hardware platform
**   (3) function crypt() renamed -> cryptpass() and changed to use
**       the new function makekey() for password conversion
**   (4) some low-level functions added:
**       - sumalgo()    - simple checksumming of LONG-Arrays
**       - cyrptfile()  - core function for en-/decryptfile()
**       - makekey()    - conversion Password -> Key Bits
**       - splitbytes() - conversion Data(byte)chunk -> Data Bits
**       - joinbytes()  - conversion Data Bits -> Data(byte)chunk
**   (5) some high-level functions added:
**       - encryptfile() - encrypt a file with given password of
**                         unlimited length
**       - decryptfile() - decrypt a file with given password of
**                         unlimited length
**
** This program is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation; either version 2, or (at your option)
** any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program; if not, write to the Free Software
** Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
**
*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "encrypt.h"

#define BS  64	/* block size */
#define BS2 32	/* half block */
#define KS  48	/* key size   */
#define KS2 24	/* half key   */
#define IS  56	/* input size */
#define IS2 28	/* half input */

#define FBUF_SIZE 10240	/* file buffer size (in multiples of 16) */

/* 16x48 Bits */
static INT8 keyBlock[16][KS];

/* 56 Bits */
static INT8 PC1[] =
{
	56, 48, 40, 32, 24, 16,  8,  0,
	57, 49, 41, 33, 25, 17,  9,  1,
	58, 50, 42, 34, 26, 18, 10,  2,
	59, 51, 43, 35,
	62, 54, 46, 38, 30, 22, 14,  6,
	61, 53, 45, 37, 29, 21, 13,  5,
	60, 52, 44, 36, 28, 20, 12,  4,
	27, 19, 11,  3
};

/* 48 Bits */
static INT8 PC2[] =
{
	13, 16, 10, 23,  0,  4,  2, 27,
	14,  5, 20,  9, 22, 18, 11,  3,
	25,  7, 15,  6, 26, 19, 12,  1,
	40, 51, 30, 36, 46, 54, 29, 39,
	50, 44, 32, 47, 43, 48, 38, 55,
	33, 52, 45, 41, 49, 35, 28, 31
};

/* 64 Bits */
static INT8 IP[] =
{
	57, 49, 41, 33, 25, 17,  9,  1,
	59, 51, 43, 35, 27, 19, 11,  3,
	61, 53, 45, 37, 29, 21, 13,  5,
	63, 55, 47, 39, 31, 23, 15,  7,
	56, 48, 40, 32, 24, 16,  8,  0,
	58, 50, 42, 34, 26, 18, 10,  2,
	60, 52, 44, 36, 28, 20, 12,  4,
	62, 54, 46, 38, 30, 22, 14,  6
};

/* 64 Bits */
static INT8 EP[] =
{
	 7, 39, 15, 47, 23, 55, 31, 63,
	 6, 38, 14, 46, 22, 54, 30, 62,
	 5, 37, 13, 45, 21, 53, 29, 61,
	 4, 36, 12, 44, 20, 52, 28, 60,
	 3, 35, 11, 43, 19, 51, 27, 59,
	 2, 34, 10, 42, 18, 50, 26, 58,
	 1, 33,  9, 41, 17, 49, 25, 57,
	 0, 32,  8, 40, 16, 48, 24, 56
};

/* 48 Bits */
static INT8 E0[] =
{
	31,  0,  1,  2,  3,  4,  3,  4,
	 5,  6,  7,  8,  7,  8,  9, 10,
	11, 12, 11, 12, 13, 14, 15, 16,
	15, 16, 17, 18, 19, 20, 19, 20,
	21, 22, 23, 24, 23, 24, 25, 26,
	27, 28, 27, 28, 29, 30, 31,  0
};

/* 48 Bits */
static INT8 E[KS];

/* 24 Bits */
static INT8 PERM[] =
{
	15,  6, 19, 20, 28, 11, 27, 16,
	 0, 14, 22, 25,  4, 17, 30,  9,
	 1,  7, 23, 13, 31, 26,  2,  8,
	18, 12, 29,  5, 21, 10,  3, 24
};

/* 8x64 Bits */
static INT8 S_BOX[][64] =
{
	{
		14,  0,  4, 15, 13,  7,  1,  4,  2, 14, 15,  2, 11, 13,  8,  1,
		 3, 10, 10,  6,  6, 12, 12, 11,  5,  9,  9,  5,  0,  3,  7,  8,
		 4, 15,  1, 12, 14,  8,  8,  2, 13,  4,  6,  9,  2,  1, 11,  7,
		15,  5, 12, 11,  9,  3,  7, 14,  3, 10, 10,  0,  5,  6,  0, 13
	},
	{
		15,  3,  1, 13,  8,  4, 14,  7,  6, 15, 11,  2,  3,  8,  4, 14,
		 9, 12,  7,  0,  2,  1, 13, 10, 12,  6,  0,  9,  5, 11, 10,  5,
		 0, 13, 14,  8,  7, 10, 11,  1, 10,  3,  4, 15, 13,  4,  1,  2,
		 5, 11,  8,  6, 12,  7,  6, 12,  9,  0,  3,  5,  2, 14, 15,  9
	},
	{
		10, 13,  0,  7,  9,  0, 14,  9,  6,  3,  3,  4, 15,  6,  5, 10,
		 1,  2, 13,  8, 12,  5,  7, 14, 11, 12,  4, 11,  2, 15,  8,  1,
		13,  1,  6, 10,  4, 13,  9,  0,  8,  6, 15,  9,  3,  8,  0,  7,
		11,  4,  1, 15,  2, 14, 12,  3,  5, 11, 10,  5, 14,  2,  7, 12
	},
	{
		 7, 13, 13,  8, 14, 11,  3,  5,  0,  6,  6, 15,  9,  0, 10,  3,
		 1,  4,  2,  7,  8,  2,  5, 12, 11,  1, 12, 10,  4, 14, 15,  9,
		10,  3,  6, 15,  9,  0,  0,  6, 12, 10, 11,  1,  7, 13, 13,  8,
		15,  9,  1,  4,  3,  5, 14, 11,  5, 12,  2,  7,  8,  2,  4, 14
	},
	{
		 2, 14, 12, 11,  4,  2,  1, 12,  7,  4, 10,  7, 11, 13,  6,  1,
		 8,  5,  5,  0,  3, 15, 15, 10, 13,  3,  0,  9, 14,  8,  9,  6,
		 4, 11,  2,  8,  1, 12, 11,  7, 10,  1, 13, 14,  7,  2,  8, 13,
		15,  6,  9, 15, 12,  0,  5,  9,  6, 10,  3,  4,  0,  5, 14,  3
	},
	{
		12, 10,  1, 15, 10,  4, 15,  2,  9,  7,  2, 12,  6,  9,  8,  5,
		 0,  6, 13,  1,  3, 13,  4, 14, 14,  0,  7, 11,  5,  3, 11,  8,
		 9,  4, 14,  3, 15,  2,  5, 12,  2,  9,  8,  5, 12, 15,  3, 10,
		 7, 11,  0, 14,  4,  1, 10,  7,  1,  6, 13,  0, 11,  8,  6, 13
	},
	{
		 4, 13, 11,  0,  2, 11, 14,  7, 15,  4,  0,  9,  8,  1, 13, 10,
		 3, 14, 12,  3,  9,  5,  7, 12,  5,  2, 10, 15,  6,  8,  1,  6,
		 1,  6,  4, 11, 11, 13, 13,  8, 12,  1,  3,  4,  7, 10, 14,  7,
		10,  9, 15,  5,  6,  0,  8, 15,  0, 14,  5,  2,  9,  3,  2, 12
	},
	{
		13,  1,  2, 15,  8, 13,  4,  8,  6, 10, 15,  3, 11,  7,  1,  4,
		10, 12,  9,  5,  3,  6, 14, 11,  5,  0,  0, 14, 12,  9,  7,  2,
		 7,  2, 11,  1,  4, 14,  1,  7,  9,  4, 12, 10, 14,  8,  2, 13,
		 0, 15,  6, 12, 10,  9, 13,  0, 15,  3,  3,  5,  5,  6,  8, 11
	}
};

/* Lowest Level (internal help) Functions (not called from outside) */
static void transpose(INT8 *dest, INT8 *source, INT8 *trans, UINT32 numBits)
{
	for (; numBits--; trans++, dest++)
	 *dest = source[*trans];
}

static UINT32 sumalgo(UINT32 *block, UINT32 numLongs)
{
	UINT32 slw, shw;
	UINT16 *sptr = (UINT16*) block;

	for (sptr += (numLongs << 1), slw = shw = 0; numLongs--; )
	{
		slw += *--sptr;
		if (slw >= 65536) shw++, slw -= 65536;
		shw += *--sptr;
	}

	shw <<= 16, shw |= slw;
	return -shw;
}

/* Lower Level (internal core) Functions (not called from outside) */
static void scramble(INT8 *leftBlk, INT8 *rightBlk, INT8 *key)
{
	INT8 tmp[KS];
	INT32 sbval;
	INT8 *tp = tmp;
	INT8 *ep = E;
	INT32 i, j;

	for (i = 0; i < 8; i++)
	{
		for (j = 0, sbval = 0; j < 6; j++)
		 sbval = (sbval << 1) | (rightBlk[*ep++] ^ *key++);

		sbval = S_BOX[i][sbval];

		for (tp += 4, j = 4; j--; sbval >>= 1)
		 *--tp = sbval & 1;

		tp += 4;
	}

	ep = PERM;
	for (i = 0; i < BS2; i++)
	 *leftBlk++ ^= tmp[*ep++];
}

static INT16 cryptfile(const INT8 *fname, const INT8 *passw, INT16 edflag, UINT32 bsize, INT16 (*progress)(INT16 percent))
{
	UINT32 form[3];	/* FORM,SIZE,CRYP */
	UINT32 fhdr[6];	/* FHDR,SIZE,BCNT,BSIZ,LSIZ,HCRC */
	UINT32 **bvp = 0, *bpl, dsize;
	FILE *fh = 0;
	UINT64 *dunit;
	INT32 tmp, pwl, cnt, rws, i, j, k, kd, kl;
	INT16 err = ERROR_NONE;

	if (bsize < 96) bsize = 96;
	else if (bsize > 32752) bsize = 32752;
	else bsize = (bsize + 15) & 0xfffffff0;
	dsize = bsize - 16;

	if (progress) progress(PROGRESS_INIT);	/* start */

	if (!(fh = fopen(fname,"rb"))) err = ERROR_NOACCESS;
	else
	{
		if ((passw == 0) || ((pwl = strlen(passw)) == 0)) err = ERROR_NOPASS;

		if (!err && !edflag)
		{
			if (fseek(fh,0,SEEK_END)) err = ERROR_FILEOP;
			else
			{
				if ((tmp = ftell(fh)) == EOF) err = ERROR_FILEOP;
				else
				{
					cnt = tmp / dsize; if (tmp % dsize) cnt++;
					if (fseek(fh,0,SEEK_SET)) err = ERROR_FILEOP;
				}
			}
		}
		else if (!err && edflag)
		{
			if (fread(form,1,12,fh) < 12) err = ERROR_FILEREAD;
			else
			{
				if ((form[0] == 'FORM') && (form[2] == 'CRYP'))
				{
					if (fread(fhdr,1,24,fh) < 24) err = ERROR_FILEREAD;
					else
					{
						if ((fhdr[0] == 'FHDR') && (fhdr[1] == 16))
						{
							if (fhdr[5] != sumalgo(fhdr, 5)) err = ERROR_WRONGCRC;
							else
							{
								cnt = fhdr[2];
								bsize = fhdr[3];
								dsize = bsize - 16;
							}
						}
						else err = ERROR_BADCHUNK;
					}
				}
				else err = WARN_NOTCRYPTED;
			}
		}

		if (!err)
		{
			if (!(bvp = (UINT32**) malloc(cnt * sizeof(UINT32*)))) err = ERROR_LOWMEM;
			else
			{
				memset(bvp,0,cnt * sizeof(UINT32*));
				for (i = 0; (!err) && (i < cnt); i++)
				{
					if (!(bvp[i] = (UINT32*) malloc(bsize))) err = ERROR_LOWMEM;
				}
			}
		}

		if (!err)
		{
			
			rws = edflag ? bsize : dsize;
			for (i = 0; (!err) && (i < cnt); i++)
			{
				bpl = bvp[i]; if (!edflag) bpl += 4;
				if ((tmp = fread(bpl,1,rws,fh)) < rws) err = ERROR_FILEREAD;
				if (err && (i == (cnt - 1)) && (tmp > 0)) err = ERROR_NONE;
				if (!err && !edflag)
				{
					bpl[-4] = 'FBUF';
					bpl[-3] = ((tmp + 7) & 0xfffffff8) + 8;
					bpl[-2] = i;
					bpl[-1] = sumalgo(bpl, (bpl[-3] - 8) / 4);
				}
				else if (!err && edflag)
				{
					if (bpl[0] == 'FBUF')
					{
						if (bpl[2] != i) err = ERROR_TRUNCATED;
					}
					else err = ERROR_BADCHUNK;
				}
				if (!err && progress)
				{
					if (progress(0 + (UINT16)(5.0 / cnt * i))) err = WARN_USERBREAK;
				}
			}
		}
		fclose(fh);
		fh = 0;
	}

	if (!err)
	{
		for (i = 0; (!err) && (i < cnt); i++)
		{
			bpl = bvp[i];
			if (!edflag)
			{
				k  = 0;
				kd = 8;
				kl = (pwl + 7) & 0xfffffff8;
			}
			else
			{
				k  = (pwl - 1) & 0xfffffff8;
				kd = -8;
				kl = -8;
			}
			for (; k != kl; k += kd)
			{
				setkey(makekey(&passw[k]));
				dunit = (UINT64*) bvp[i];
				for (dunit += 2, j = (bpl[1] - 8) / 8; j--; dunit++)
				{
					memcpy(dunit,joinbytes(encrypt(splitbytes((INT8*) dunit),edflag)),8);
				}
			}
			if (edflag)
			{
				if (bpl[3] != sumalgo(&bpl[4], (bpl[1] - 8) / 4)) err = ERROR_WRONGCRC;
			}
			if (!err && progress)
			{
				if (progress(5 + (UINT16)(90.0 / cnt * i))) err = WARN_USERBREAK;
			}
		}
	}

	if (!err)
	{
		if (!(fh = fopen(fname,"wb"))) err = ERROR_FILEWRITE;
		else
		{
			if (!edflag)
			{
				form[0] = 'FORM'; form[2] = 'CRYP';
				if (fwrite(form,1,12,fh) < 12) err = ERROR_FILEWRITE;
				if (!err)
				{
					fhdr[0] = 'FHDR'; fhdr[1] = 16;
					fhdr[2] = cnt; fhdr[3] = bsize; fhdr[4] = tmp;
					fhdr[5] = sumalgo(fhdr, 5);
					if (fwrite(fhdr,1,24,fh) < 24) err = ERROR_FILEWRITE;
				}
			}
			rws = edflag ? dsize : bsize;
			for (i = 0; (!err) && (i < (cnt - 1)); i++)
			{
				bpl = bvp[i]; if (edflag) bpl += 4;
				if (fwrite(bpl,1,rws,fh) < rws) err = ERROR_FILEWRITE;
				if (!err && progress)
				{
					if (progress(95 + (UINT16)(5.0 / cnt * i))) err = WARN_USERBREAK;
				}
			}
			if (!err)
			{
				bpl = bvp[cnt - 1];
				rws = edflag ? fhdr[4] : bpl[1] + 8; if (edflag) bpl += 4;
				if (fwrite(bpl,1,rws,fh) < rws) err = ERROR_FILEWRITE;
				if (!err && progress)
				{
					if (progress(100)) err = WARN_USERBREAK;
				}
			}
			if (!err && !edflag)
			{
				if (fseek(fh,0,SEEK_END)) err = ERROR_FILEOP;
				else
				{
					if ((tmp = ftell(fh)) == EOF) err = ERROR_FILEOP;
					else
					{
						if (fseek(fh,4,SEEK_SET)) err = ERROR_FILEOP;
						else
						{
							tmp -= 8;
							if (fwrite(&tmp,1,4,fh) < 4) err = ERROR_FILEWRITE;
						}
					}
				}
			}
			fclose(fh);
			fh = 0;
		}
	}

	if (bvp)
	{
		for (i = 0; (bvp[i] != 0) && (i < cnt); i++) free(bvp[i]);
		free(bvp);
	}
	if (fh) fclose(fh);

	if (progress) progress(PROGRESS_DONE);	/* done */
	return err;
}

/* Normal Level Functions (user API to DES-56 encryption) */
void setkey(INT8 *key)
{
	INT8 tmp[IS];
	UINT32 magic = 0x7efc;
	INT32 i, j, k;
	INT32 shval = 0;
	INT8 *currKey;

	memcpy(E, E0, KS);
	transpose(tmp, key, PC1, IS);

	for (i = 0; i < 16; i++)
	{
		shval += 1 + (magic & 1);
		currKey = keyBlock[i];

		for (j = 0; j < KS; j++)
		{
			if ((k = PC2[j]) >= IS2)
			{
				if ((k += shval) >= IS)
				 k = (k - IS2) % IS2 + IS2;
			}
			else
			{
				if ((k += shval) >= IS2)
				 k %= IS2;
			}
			*currKey++ = tmp[k];
		}

		magic >>= 1;
	}
}

INT8 *encrypt(INT8 *block, INT16 edflag)
{
	INT8 *key = edflag ? (INT8*) keyBlock + (15 * KS) : (INT8*) keyBlock;
	INT8 tmp[BS];
	INT32 i;

	transpose(tmp, block, IP, BS);

	for (i = 8; i--;)
	{
		scramble(tmp, tmp + BS2, key);
		if (edflag) key -= KS;
		else        key += KS;

		scramble(tmp + BS2, tmp, key);
		if (edflag) key -= KS;
		else        key += KS;
	}

	transpose(block, tmp, EP, BS);
	return block;
}

/* Normal Level Functions (user API support for Byte <-> Bit conversion) */
INT8 *makekey(const INT8 *passw)
{
	static INT8 keyChain[BS];
	INT8 *kp;
	INT32 keyByte;
	INT32 i, j;

	memset(keyChain, 0, BS);
	for (kp = keyChain, i = 0; i < BS; i++)
	{
		if (!(keyByte = *passw++)) break;
		kp += 7;
		for (j = 0; j < 7; j++, i++)
		{
			*--kp = keyByte & 1;
			keyByte >>= 1;
		}
		kp += 8;
	}

	return keyChain;
}

INT8 *splitbytes(INT8 *block)
{
	static INT8 bitChain[BS];
	INT8 *bp;
	INT32 datByte;
	INT32 i, j;

	for (bp = bitChain, i = 0; i < 8; i++)
	{
		datByte = *block++;
		bp += 8;
		for (j = 0; j < 8; j++)
		{
			*--bp = datByte & 1;
			datByte >>= 1;
		}
		bp += 8;
	}

	return bitChain;
}

INT8 *joinbytes(INT8 *block)
{
	static INT8 byteChain[8];
	INT8 *bp;
	INT32 datByte;
	INT32 i, j;

	for (bp = block, i = 0; i < 8; i++)
	{
		for (j = datByte = 0; j < 8; j++)
		{
			datByte <<= 1;
			datByte |= *bp++;
		}
		byteChain[i] = datByte;
	}

	return byteChain;
}

/* Higher Level Functions (user API support for specific tasks) */
INT8 *cryptpass(const INT8 *passw, const INT8 *salt)
{
	static INT8 retKey[14];
	INT8 key[BS + 2];
	INT8 *kp;
	INT32 tmp, keyByte;
	INT32 i, j;

	setkey(makekey(passw));

	for (kp = E, i = 0; i < 2; i++)
	{
		retKey[i] = keyByte = *salt++;
		if (keyByte > 'Z') keyByte -= 'a' - 'Z' - 1;
		if (keyByte > '9') keyByte -= 'A' - '9' - 1;
		keyByte -= '.';

		for (j = 0; j < 6; j++, keyByte >>= 1, kp++)
		{
			if (!(keyByte & 1)) continue;

			tmp = *kp;
			*kp = kp[24];
			kp[24] = tmp;
		}
	}

	memset(key, 0, BS + 2);
	for (i = 0; i < 25; i++)
	 encrypt(key, 0);

	for (kp = key, i = 0; i < 11; i++)
	{
		for (j = keyByte = 0; j < 6; j++)
		{
			keyByte <<= 1;
			keyByte |= *kp++;
		}

		keyByte += '.';
		if (keyByte > '9') keyByte += 'A' - '9' - 1;
		if (keyByte > 'Z') keyByte += 'a' - 'Z' - 1;
		retKey[i + 2] = keyByte;
	}
	retKey[i + 2] = 0;

	if (!retKey[1])
	 retKey[1] = *retKey;

	return retKey;
}

INT16 encryptfile(const INT8 *fname, const INT8 *passw, INT16 (*progress)(INT16 percent))
{
	return cryptfile(fname,passw,0,FBUF_SIZE,progress);
}

INT16 decryptfile(const INT8 *fname, const INT8 *passw, INT16 (*progress)(INT16 percent))
{
	return cryptfile(fname,passw,1,0,progress);
}

