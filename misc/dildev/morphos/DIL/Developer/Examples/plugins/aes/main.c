/*
 * aes.dilp - AES cipher plugin for DIL
 * Copyright ©2004-2009 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 */

#include <libraries/dilplugin.h>

#include <proto/exec.h>

#include "aes.h"
#include "crc128.h"
#include "misc.h"
#include "rev.h"

#define D(x) /* x */

//-----------------------------------------------------------------------------

#if defined(__GNUC__)
#pragma pack(2)
#endif

/* Private data */
typedef struct {
	AESContextCbc	p_CBC;	/* chipher context */
	ULONG 		   p_IV[4]; /* IV */
} AESPriv;

#if defined(__GNUC__)
#pragma pack()
#endif

static void MakeIV(ULONG block, ULONG *iv);

//-----------------------------------------------------------------------------

static const struct TagItem tags[] =
{
	{ DILI_Name,			(ULONG)NAME_LONG },
	{ DILI_Version,		(ULONG)VERSION },
	{ DILI_Revision,		(ULONG)REVISION },
	{ DILI_OS,				(ULONG)"MorphOS" },
	{ DILI_CodeType,		(ULONG)"PPC" },
	{ DILI_SaneID,			(ULONG)DIL_SANEID }, /* (1.1) */
	{ DILI_Intervention, (ULONG)TRUE }, /* Enable intervene-mode */
	{ DILI_GenerateSeed, (ULONG)TRUE }, /* Enable seed generation */
	{ DILI_SeedSHA,		(ULONG)TRUE }, /* Enable SHA256 seed (1.2) */
	{ DILI_Description,  (ULONG)DESC },
	{ DILI_Author,       (ULONG)AUTHOR },
	{ DILI_Copyright,    (ULONG)COPY },
	{ DILI_License,      (ULONG)LICENCE },
	{ DILI_URL,          (ULONG)URL },
	{ 0ul, 0ul }
};
    
struct TagItem *dilGetInfo(void)
{
   return ((struct TagItem *)tags);
}

//-----------------------------------------------------------------------------

BOOL dilSetup(void)
{
	DILParams *params = (APTR)REG_A0;
	AESPriv *p;

	if ((p = AllocVec(sizeof(AESPriv), MEMF_PUBLIC | MEMF_CLEAR)))
	{
		AES_Init(); /* init AES */
		params->p_User = p; /* for thread safety use params->p_User to store the data ptr */
		return TRUE;
	}
	return FALSE;
}

void dilCleanup(void)
{
	DILParams *params = (APTR)REG_A0;
	AESPriv *p = (AESPriv *)params->p_User;

	/* flush AESPriv from memory */
	memclr(p, sizeof(AESPriv));

	FreeVec(p);
   params->p_User = NULL;
}

//-----------------------------------------------------------------------------

BOOL dilProcess(void)
{
	DILPlugin *plugin = (APTR)REG_A0;
	AESPriv *p = (AESPriv *)plugin->p_Params->p_User;
	AESContextCbc *cbc = &p->p_CBC;
	AESContext *aes = &cbc->aes;
	UBYTE *src = plugin->p_Source;
	UBYTE *dst = plugin->p_Destination;
	ULONG blocksize = DIL_BLOCKSIZE(plugin->p_Params);
	ULONG i, done = 0ul;

	/* set key */
	if (plugin->p_Flags & DILF_READ)
		AES_SetKeyDecode(aes, plugin->p_Seed, plugin->p_SeedLen);
	else
		AES_SetKeyEncode(aes, plugin->p_Seed, plugin->p_SeedLen);

	/* process each block separate */
	for (i = plugin->p_Block; i < plugin->p_Block + plugin->p_Blocks; i++)
	{
		/* build IV from the current block-number */
		MakeIV(i, p->p_IV);

		/* set IV */
		AES_InitCbc4(cbc, p->p_IV);
		/* process block */
		if (plugin->p_Flags & DILF_READ)
			done += AES_DecodeCbc(cbc, src, dst, blocksize);
		else
			done += AES_EncodeCbc(cbc, src, dst, blocksize);

		src += blocksize;
		dst += blocksize;
	}
	return (done == blocksize * plugin->p_Blocks);
}

//-----------------------------------------------------------------------------

#define LROT(x, n) (((x) << (n)) | ((x) >> (32 - (n))))

static void MakeIV(ULONG block, ULONG *iv)
{
	UBYTE buf[4];
	u128 crc;

	/* increase blocknumber and shift */
	block = LROT(block + 1, 27);

	/* convert block to string */
	buf[0] = (UBYTE)((block >> 24) & 0xff);
	buf[1] = (UBYTE)((block >> 16) & 0xff);
	buf[2] = (UBYTE)((block >>  8) & 0xff);
	buf[3] = (UBYTE)(block & 0xff);

	/* calculate crc */
	crc = CRC128_INITIAL;
	crc = crc128(crc, buf, sizeof(buf));

	/* copy crc to iv */
#ifdef CRC128_64BIT
	iv[0] = (ULONG)((crc.A >> 32) & 0xffffffff);
	iv[1] = (ULONG)(crc.A & 0xffffffff);
	iv[2] = (ULONG)((crc.B >> 32) & 0xffffffff);
	iv[3] = (ULONG)(crc.B & 0xffffffff);
#else
	iv[0] = crc.A;
	iv[1] = crc.B;
	iv[2] = crc.C;
	iv[3] = crc.D;
#endif

#ifdef CRC128_64BIT
	D(kprintf("IV block %5lu, crc %16llx%16llx\n", block, crc.A, crc.B));
#else
	D(kprintf("IV block %5lu, crc %08lx%08lx%08lx%08lx\n", block, crc.A, crc.B, crc.C, crc.D));
#endif
}

//-----------------------------------------------------------------------------



























