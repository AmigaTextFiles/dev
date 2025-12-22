/*
 * :ts = 4
 *
 * This is a "2-clause" Berkeley-style license.
 *
 *
 * Copyright (c) 2008 J.v.d.Loo.
 * All rights reserved.
 *
 * This code is comprehended as contribution to Uni-Library.
 * Author: J.v.d.Loo
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * This  software  is  provided by the above named author and if named,
 * additional   parties,   "as   is"   and  any  expressed  or  implied
 * warranties,  including,  but  not limited to, the implied warranties
 * of   merchantability  and  fitness  for  a  particular  purpose  are
 * disclaimed.  In  no  event  shall  the  above  named  author nor any
 * additionally  named  party  be  liable  for  any  direct,  indirect,
 * incidental,    special,    exemplary,   or   consequential   damages
 * (including,  but  not limited to, procurement of substitute goods or
 * services;  loss  of use, data, or profits; or business interruption)
 * however  caused and on any theory of liability, whether in contract,
 * strict  liability,  or  tort  (including  negligence  or  otherwise)
 * arising  in any way out of the use of this software, even if advised
 * of the possibility of such damage.
 */


#include <exec/types.h>
#include <libraries/uni.h>
#include <utility/hooks.h>
#include <libraries/uni.h>

#include <proto/exec.h>
#include <proto/utility.h>
#include <proto/uni.h>

#include <string.h>

#include "mapping_table.h"
#include "SDI_compiler.h"
#include "uni_local_protos.h"


/*
 * This one used for the destination text (Latin-1/ISO).
 * Searches the provided table for the supplied character code ('lchar',
 * Unicode UTF-32) and returns its pendant as found in the mapping table or
 * the replacement character code if it not exists in the mapping table.
 * Because the ISO encodings are all placed in the BMP we need only table
 * entries with 16-bit code units (UWORDs, mt_UniCodes). 
 */
ASM SAVEDS static unsigned int UniUTF8ToLatinHookCode( REG(a0, struct Hook *h), REG(a2, APTR obj), REG(a1, unsigned int lchar) )
{
	#define MT_PAIRS (95)

	struct MapTableSBCES *mt;
	ULONG i = 0;

	mt = (struct MapTableSBCES *) h->h_Data;

	while (i < MT_PAIRS)	/* Amount mapping table pairs of {mt_SbcCode, mt_UniCode} */
	{
		if (lchar == mt[i].mt_UniCode)	/* Find the code point in this table */
		{
			lchar = mt[i].mt_SbcCode;	/* and map it! */
			break;
		}

		i ++;
	}


	/* Let's use a replacement for the default replacement
	   character code (191) */
	if (lchar > 255)
		lchar = (UBYTE) '?';

	return lchar;
}


/*
 * UniFromUTF8ToSces() transcodes the input text of type UTF-8 into the
 * equivalent singlebyte character encoding scheme by taking into
 * account the IANA ID.
 *
 * @src		 - the text encoded in UTF-8.
 * @inlength - amount in bytes 'src' is made of.
 * @cps		 - amount code points (UTF-8 multibyte sequences) that 'src'
 *			   contains.
 * @dest	 - Pointer to a 32-bit variable that contains after successful
 *			   transcoding the memory location where the singlebyte encoded
 *			   text can be found.
 *			   'dest' will be allocated by using AllocVec()!
 *			   You have to FreeVec() it once you don't need it anymore.
 * @outlen	 - Pointer to a 32-bit variable that informs how many bytes 'dest'
 *			   contains (equal to number of characters).
 * @iana_id	 - one of the IANA IDs that specifies the type of single byte
 * 			   character encoding scheme, i.e. you can specify what kind of
 *			   encoding scheme should be used to encode the input string - if
 *			   none is set, IANA_ISO_8859_1 is assumed. For OS4 you should
 *			   specify IANA_ISO_8859_15 since it is default here.
 *
 * RESULT	 - TRUE if transcoding could be successfully performed.
 *			   If FALSE is returned you may not access 'dest' and 'outlen'.
 */


BOOL UniFromUTF8ToSces( const TEXT *src, const ULONG inlength, const ULONG cps, TEXT **dest, ULONG *outlen, ULONG iana_id)
{
	#define IANA_ISO_8859_1 (4)

	struct Hook outMapCharHook, *outHook;
	struct MapTableSBCES *mappingTableOut;
	BOOL retval = FALSE;
	TEXT *temp;
	LONG length;

	/* Clear them... */
	*dest = NULL;
	*outlen = 0;

	if (iana_id == 0)
		iana_id = IANA_ISO_8859_1;		/* Default if nothing has been picked */

	/* Get the transcoding table */
	mappingTableOut = GetMappingTable( iana_id);		/* Get the mapping table */

	/* Initialize the hook accordingly */
	if (mappingTableOut)
	{
		InitLocalHook( &outMapCharHook, (HOOKFUNC) &UniUTF8ToLatinHookCode, (APTR) mappingTableOut);
		outHook = &outMapCharHook;
	}
	else
	{
		outHook = NULL;
	}

	if ( (temp = (TEXT *) AllocVec( SIZEOFWITHALIGN( cps + 1), MEMF_CLEAR)) )
	{
		length = UTF8ToLatin( src, inlength, temp, cps + 1, outHook);
		if ( !ISBLUNDER(length) )
		{
			retval = TRUE;
			*dest = temp;
			*outlen = (ULONG) length;
		}
		else
		{
			FreeVec( temp);
		}

	}

	return retval;
}
