/*
 * poly.dilp - Polymorphic-cipher plugin for DIL
 * Copyright ©2004-2007 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 */

#include <exec/types.h>
#include <exec/lists.h>
#include <libraries/dilplugin.h>
#include <utility/tagitem.h>

#include <proto/debug.h>
#include <proto/exec.h>

#include "rev.h"
#include "cipher.h"

//-----------------------------------------------------------------------------

static const struct TagItem tags[] =
{
	{ DILI_Name,			(ULONG)NAME_LONG },
	{ DILI_Version,		(ULONG)VERSION },
	{ DILI_Revision,		(ULONG)REVISION },
	{ DILI_OS,				(ULONG)"MorphOS" },
	{ DILI_CodeType,		(ULONG)"PPC" },
	{ DILI_SaneID,			(ULONG)DIL_SANEID }, /* (1.1) */
	{ DILI_Intervention, (ULONG)TRUE },
	{ DILI_GenerateSeed, (ULONG)TRUE },
	{ DILI_SeedDIL,		(ULONG)TRUE }, /* (1.2) */
	{ DILI_Description,  (ULONG)DESC },
	{ DILI_Author,       (ULONG)AUTHOR },
	{ DILI_Copyright,    (ULONG)COPY },
	{ DILI_License,      (ULONG)LICENCE },
	{ DILI_URL,          (ULONG)URL },
	{ 0ul, 0ul }
};

//-----------------------------------------------------------------------------
    
struct TagItem *dilGetInfo(void)
{
   return ((struct TagItem *)tags);
}

//-----------------------------------------------------------------------------

BOOL dilSetup(void)
{
	DILParams *params = (APTR)REG_A0;
	ULONG blocksize = params->p_DosEnvec.de_SizeBlock << 2;

	if (blocksize >= 512 && blocksize <= 32768) {
		if ((params->p_User = CIPHER_Init(blocksize)))
			return TRUE;
	}
	return FALSE;
}

void dilCleanup(void)
{
	DILParams *params = (APTR)REG_A0;
	
   CIPHER_Exit((CIPHER_Instance *)params->p_User);
   params->p_User = NULL;
}

//-----------------------------------------------------------------------------

BOOL dilProcess(void)
{
	DILPlugin *plugin = (APTR)REG_A0;

	CIPHER_Fill((CIPHER_Instance *)plugin->p_Params->p_User,
   	plugin->p_Source,
      plugin->p_Destination,
      plugin->p_Seed,
		plugin->p_Block,
		plugin->p_Blocks,
		(plugin->p_Flags & DILF_READ) ? 1 : 2
	);
   return CIPHER_Process((CIPHER_Instance *)plugin->p_Params->p_User);
}

//-----------------------------------------------------------------------------

