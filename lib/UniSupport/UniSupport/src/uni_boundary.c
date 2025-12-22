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

/*
 * Ensure that the last character of a UTF-8 multibyte sequence ends on a
 * legal boundary, i.e. that it is either a ordinary US-ASCII character code
 * or the last trail octet of a UTF-8 multibyte sequence.
 *
 * @src		- (POINTER) the memory location where the text starts.
 * @stop	- (POINTER) points one byte behind last character code of your
 *			- buffer (src + amount_characters = stop)
 *
 * RESULT	- modified 'stop'-pointer - which points now (if not already) one
 *			  byte behind last valid character or points to 'src' if an error
 *			  occurred.
 */

const TEXT * UniLegalUTF8Boundary( const TEXT *src, const TEXT *stop)
{
	const TEXT *tmp;
	ULONG seq;

	/* 'stop' points one byte behind last octet to convert - and stop - 1 has
	   to be either US-ASCII or the last trail octet of a UTF-8 multibyte
	   sequence.
	   We have to test it! */


	if ( !(UTF8IsLegal( &stop[-1])) )
	{
		/* It's a trail byte! Move now to it's lead octet. */
		tmp = &stop[-1];
		seq = 0;

		/* As long as a trail octet is found */
		while ( (*tmp & 0xC0) == 0x80 && tmp >= src)
			tmp --;

		seq = &stop[-1] - tmp;	/* Amount trail octets */
		/* Ensure that the trail octet that was found is within range and does
		   not exceed limit of amount trail octets */
		if (tmp >= src && seq < MAX_OCTETS_PER_UTF8_SEQUENCE)
		{
			/* Get amount trail octets which will follow the lead octet. */
			#if MAX_OCTETS_PER_UTF8_SEQUENCE > 4
				#error FIXME: 5 or more octets per UTF-8 sequence not supported
			#endif

			if (*tmp > 0xC3)
				seq = ((*tmp & 0x1F) >> 1);
			else
				seq = (((*tmp & 0x1F) + 1) >> 1);

			/* Error if more than 3 octets follow or US-ASCII character
			   encountered - US-ASCII succeeded by trail octets is an
			   error! */
			if (seq > (MAX_OCTETS_PER_UTF8_SEQUENCE - 1) || seq == 0)
			{
				tmp = src;
			}
			else	/* Amount trail octets (seq) within range */
			{
				/* Would it exceed 'stop' when reading whole sequence in? */
				if (&tmp[seq] < stop)
				{
					tmp = &tmp[seq];	/* No, it's valid - we could also use:
										   tmp = stop; */
				}
				/* It exceeds 'stop' upon reading the whole sequence! */

				/* Remember: 'tmp' points to a lead octet - so this lead
				   octet forms the new 'stop' */
			}
		}
		else
		{
			tmp = src;					/* ERROR: First trail octet in front
										   of 'src' or too many trail octets */
		}
	}
	else	/* It's either US-ASCII or a lead octet */
	{
		tmp = stop;

		/* If it's not US-ASCII */
		if (tmp[-1] > UNICODE_SELF)
			tmp --;		/* ...skip lead octet */
	}

	return tmp;
}
