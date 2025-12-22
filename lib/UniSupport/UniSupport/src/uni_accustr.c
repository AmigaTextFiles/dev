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

#include <proto/uni.h>

#include "mapping_table.h"

/*
 * Determine the storage size in bytes that a converted string requires when
 * it would be converted to UTF-8.
 *
 * Using a fixed multiplier is drastically faster but we don't want to waste
 * memory like it is standard in the UNIX or Windows worlds.
 *
 * @src		 - (POINTER) the memory location where the text starts.
 *			   (If UTF-16/UTF-32, endianess must have been already adopted to
 *			   the machine's endianess)
 * @inlength - size in bytes of 'src' (amount bytes 'src' is made of).
 * @encoding - compatible attribute as returned by UniCheckEncoding()
 * mt		 - mapping table - used only in case the string is singlebyte
 *			   encoded.
 * RESULT	 - byte size that would be required to store the transcoded
 *			   UTF-8 multibyte sequences.
 */

ULONG UniAccuUTF8StrLen( const void *src, const ULONG inlength, const ULONG encoding, const struct MapTableSBCES *mt)
{
	ULONG keycode, octets;

	octets = 0;

	if (encoding == ASCII_ENCODED || encoding == LATIN1_ENCODED)
	{
		TEXT *curr, *end;

		curr = (TEXT *) src;
		end = curr + inlength;

		while (curr < end)
		{
			keycode = *curr ++;
			if (keycode < UNICODE_SELF)	/* Just US-ASCII? */
			{
				octets ++;				/* We know that it fits into a single
										   byte - we are so clever...*/
			}
			else
			{
				if (mt)		/* Mapping table provided? */
				{
					if (keycode > 0xA0 && keycode < 0x100)
					{
						/* Index current keycode */
						keycode -= 0xA1;	/* Offset in mapping table */
						/* Get the Unicode pendant */
						keycode = mt[keycode].mt_UniCode;
						/* Amount octets used for this Unicode code point when
						   stored as UTF-8 multibyte sequence */
						octets += UTF32CharAsUTF8Len( keycode);
					}
					else
					{
						/* Code points in range from 128 to 160 */
						octets += UTF32CharAsUTF8Len( keycode);
					}
				}
				else
				{
					/* No mapping table available: treat code point as LATIN-1
					   encoded */
					octets += UTF32CharAsUTF8Len( keycode);
				}
			}
		}
	}

	/* Yep, this is really a simple one, UCS-2/UTF-16 */
	if (encoding == UTF16LE_ENCODED || encoding == UTF16BE_ENCODED)
	{
		UWORD *curr, *end;

		curr = (UWORD *) src;
		end = curr + ((inlength & -2) / 2);

		while (curr < end)
		{
			keycode = *curr ++;

			/* Surrogate code points (awkward...) are handled properly by
			   UTF16CharAsUTF8Len().
			   Either it returns 4 in case the hi-surrogate code point was
			   encountered or 0 if it was the lo-surrogate code point. */
			octets += UTF16CharAsUTF8Len( keycode);
		}
	}


	/* Another simple one, UCS-4/UTF-32 */
	if (encoding == UTF32LE_ENCODED || encoding == UTF32BE_ENCODED)
	{
		LONG *curr, *end;

		curr = (LONG *) src;
		end = curr + ((inlength & -4) / 4);

		while (curr < end)
		{
			keycode = *curr ++;
			octets += UTF32CharAsUTF8Len( keycode);
		}
	}

	return octets;
}
