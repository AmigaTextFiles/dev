/*
 * default.dilp - Default plugin for DIL
 * Copyright ©2004-2007 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 */

#include <exec/types.h>
#include <libraries/dilplugin.h>
#include <utility/tagitem.h>

#include <clib/debug_protos.h>
#include <proto/exec.h>

#include "main.h"
#include "rev.h"

/*---------------------------------------------------------------------------*/

#define D(x) /* x */

#if 1
	#define INTERVENTION
#else
	#undef INTERVENTION
#endif

/*-----------------------------------------------------------------------------
 * The first function called. We reply some needed infos and configs via tags... */

static const struct TagItem tags[] =
{
/* Basic */
	{ DILI_Name,         (ULONG)NAME_LONG },
	{ DILI_Description,  (ULONG)DESC },
	{ DILI_Warning,      (ULONG)"<maybe some warning to the user, concerning this plugin>" },

/* VerRev */
   { DILI_Version,      (ULONG)VERSION },  /* mandatory */
	{ DILI_Revision,     (ULONG)REVISION }, /* mandatory */
	{ DILI_OS,           (ULONG)"MorphOS" },
	{ DILI_CodeType,     (ULONG)"PPC" },
	{ DILI_SaneID,       (ULONG)DIL_SANEID }, /* mandatory (1.1) */

/* Preferences (all mandatory) */
	/* If the plugin does'nt touch the data, set to FALSE, else to TRUE */
#ifdef INTERVENTION
	{ DILI_Intervention, (ULONG)TRUE },
#else
	{ DILI_Intervention, (ULONG)FALSE },
#endif
   /* If a seed (passphrase-request) is needed, set to TRUE, else to FALSE */
	{ DILI_GenerateSeed, (ULONG)FALSE },

/* Author */
	{ DILI_Author,       (ULONG)AUTHOR },
	{ DILI_Copyright,    (ULONG)COPY },
	{ DILI_License,      (ULONG)LICENCE },
	{ DILI_URL,          (ULONG)URL },
	
   { 0ul, 0ul }
};

struct TagItem *dilGetInfo(void)
{
	D(kprintf("dilGetInfo()\n"));

	return ((struct TagItem *)tags);
}

/*-----------------------------------------------------------------------------
 * The setup-/cleanup-pair. dilSetup() is called after dilGetInfo()...
 * You can use this function to setup your private stuff, needed by your plugin.
 * You will receive a initiated "DILParams *" structure in A0.
 *
 * See <devices/dil.h> for details
 *
 * Note: Always check, that a pointer is'nt NULL before using it
 * Note: All values are read only! */

BOOL dilSetup(void)
{
	DILParams *params = (APTR)REG_A0;

	D(kprintf("dilSetup() params at 0x%p\n", params));

	/* If your private setup-routine fails, return FALSE, else TRUE */
	return TRUE;
}

/* Free your stuff here */
void dilCleanup(void)
{
	DILParams *params = (APTR)REG_A0;
	
   D(kprintf("dilCleanup() params at 0x%p\n", params));
}

/*-----------------------------------------------------------------------------
 * The main processing function. It's called everytime dil.device receives a
 * read-/write-request. Do your main-processing here.
 * In A0, you will receive a initiated "DILPlugin *" structure:
 *
 * typedef struct DILPlugin
 * {
 *    DILParams *p_Params;      //Pointer to the parameters from dilSetup()
 *
 *    APTR       p_Seed;        //Pointer to the seed (NULL if not a cipher!)
 *    APTR       p_Source;      //Pointer to the src-buffer
 *    APTR       p_Destination; //Pointer to the dst-buffer (NULL if not a cipher!)
 *
 *    ULONG      p_BlockOffset; //Current block offset (Logical Block Address (LBA))
 *    ULONG      p_BlockCount;  //Current number of blocks
 *
 *    ULONG      p_Flags;       //Current flags (DILF_#?)
 * } DILPlugin;
 *
 * See <devices/dil.h> for details
 *
 * Note: All values, except p_Destination are read only! */

BOOL dilProcess(void)
{
	DILPlugin *plugin = (APTR)REG_A0;
	
	D(kprintf("dilProcess() plugin at 0x%p\n", plugin));
	
	/* do nothing */
#ifdef INTERVENTION
	{
		ULONG size = (plugin->p_Params->p_DosEnvec.de_SizeBlock << 2) * plugin->p_Blocks;
		
		CopyMem(plugin->p_Source, plugin->p_Destination, size);
   }
#endif
	
   /* If the processing was successfull, return TRUE, else FALSE */
	return TRUE;
}

/*---------------------------------------------------------------------------*/































