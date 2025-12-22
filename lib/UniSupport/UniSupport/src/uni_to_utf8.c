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
#include <exec/memory.h>
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
 * This one used for the input text - in case it's a singlebyte character set.
 * ASM, SAVEDS and explicit register specification only used for 68k code.
 */
ASM SAVEDS static unsigned int UniLatinToUTF8HookCode( REG(a0, struct Hook *h), REG(a2, APTR obj), REG(a1, unsigned int lchar) )
{
	struct MapTableSBCES *mt;
	ULONG i;

	mt = (struct MapTableSBCES *) h->h_Data;

	/* Tables do only cover character codes in range from 0xA1 to 0xFF -
	   mt_SbcCodes */
	if (lchar > 0xA0 && lchar < 0x100)
	{
		i = lchar - 0xA1;
		lchar = mt[i].mt_UniCode;	/* Get it's Unicode pendant */
	}

	return lchar;
}


/*
 * UniConvertToUTF8() converts any type of plain text to UTF-8.
 *
 * @src		 - (POINTER) the memory location where the text starts.
 * @inlength - size in bytes of 'src' (amount bytes 'src' is made of).
 * @iana_id	 - one of the IANA IDs that specifies the type of singlebyte
 * 			   character encoding scheme, i.e. you can specify what kind of
 *			   encoding scheme was used to encode the input string - if none
 *			   is set, IANA_ISO_8859_1 is assumed. For OS4 you should specify
 *			   IANA_ISO_8859_15 since it is default here.
 *			   *WARNING*  If UTF8_GUESSED is returned by UniCheckEncoding()
 *			   and setting an IANA ID, it means that the input data will be
 *			   interpreted as singlebyte character encoding scheme and not as
 *			   UTF-8 encoded! With that you force UniConvertToUTF8() to ignore
 *			   the result of UniCheckEncoding()!
 * @encoding - unmodified result of UniCheckEncoding()
 * @dest	 - Pointer to a 32-bit variable that contains after successful
 *			   transcoding the memory location where the UTF-8 encoded texts
 *			   can be found.
 *			   'dest' will be allocated by using AllocVec()!
 *			   You have to FreeVec() it once you don't need it anymore.
 *			   *NOTE*  In case UTF-32 was encountered 'dest' is zeroed because
 *			   the initial buffer ('src') contains the new UTF-8 sequences. :)
 *			   The same applies if UniCheckEncoding() returned as encoding
 *			   UTF8_ENCODED.
 * @outlen	 - Pointer to a 32-bit variable that informs how many bytes 'dest'
 *			   contains.
 * @cps		 - Pointer to a 32-bit variable that informs how many code points
 *			   (equal to number of UTF-8 multibyte sequences) 'dest' contains.
 *
 * RESULT	 - TRUE if transcoding could be successfully performed.
 *			   Would return FALSE in case it runs out of memory or a decoding
 *			   error occurs.
 *			   *NOTE*:  Only in case the result can be found in 'dest' the new
 *			   text is zero byte terminated!
 *
 *			   Finally note: If the encoding is UTF8_GUESSED and 'inlength' and
 *			   outlen differ it means that you have passed in a stream where
 *			   some trail bytes at the end of this stream were missing. In
 *			   order to process now the left octets and the mssing trail octets
 *			   you should copy from:
 * 				(src + outlen) of size (inlength - outlen) the left processed
 *				octets to a new location and process them further once you
 *				retrieve the additional and missing octets.
 */

BOOL UniConvertToUTF8( void *src, ULONG inlength, ULONG iana_id, ULONG encoding, TEXT **dest, ULONG *outlen, ULONG *cps)
{
	#define IANA_ISO_8859_1 (4)
	#define IANA_UTF_8		(106)

	struct Hook inMapCharHook, *inHook;
	struct MapTableSBCES *mappingTableIn;
	ULONG initial_len;
	BOOL retval = FALSE;
	LONG length;
	TEXT *temp;
	const TEXT *stop;

	/* Clear them in first place... */
	*dest	= NULL;
	*outlen = 0;
	*cps	= 0;

	/* Because of a set BOM which we might remove and update therewith
	   'inlength' accordingly, we have to keep track of the original
	   buffer ('src') length. */
	initial_len = inlength;

	/* Ensure that it is not already UTF-8 encoded but if it is (by guessing
	   (UTF8_GUESSED)), make sure that the caller really wants this UTF-8
	   string to be interpreted as a singlebyte character set. */
	if (encoding == UTF8_GUESSED && iana_id && iana_id != IANA_UTF_8)
		encoding = LATIN1_ENCODED;	/* Force new input type */


	/* Special case: Text is already UTF-8 encoded - but since there is a BOM
	   we have to remove it in order to treat the text as plain text */
	if (encoding == UTF8_ENCODED)
	{ 
		/* Remove the BOM */
		temp = ((unsigned char *) src) + UniBomHasSize( encoding); 
		memmove( src, (void *) temp, inlength - UniBomHasSize( encoding));
		/* Update amount of code points */
		inlength -= UniBomHasSize( encoding);

		temp = (TEXT *) src;
		/* In case it's a stream, ensure that the last character code is valid. */ 
		stop = UniLegalUTF8Boundary( temp, temp + inlength);
		UTF8StrInfo( temp, stop, NULL, cps, NULL);
		*outlen = stop - temp;
		if (stop - temp)	/* Only in case UniLegalUTF8Boundary() did not fail! */
			retval = TRUE;
	}


	/* Special cases: Text is either ASCII or UTF-8 encoded - but we have to
	   avoid abnormal termination (pass through 'as it')*/
	if (encoding == UTF8_GUESSED || encoding == ASCII_ENCODED)
	{
		if (encoding == UTF8_GUESSED)
		{
			temp = (TEXT *) src;
			/* In case it's a stream, ensure that the last character code is valid. */ 
			stop = UniLegalUTF8Boundary( temp, temp + inlength);
			UTF8StrInfo( temp, stop, NULL, cps, NULL);
			*outlen = stop - temp;
			if (stop - temp)	/* Only in case UniLegalUTF8Boundary() did not fail! */
				retval = TRUE;
		}
		else	/* ASCII */
		{
			*outlen = inlength;
			*cps = inlength;
			retval = TRUE;
		}
	}

	/* Do not transcode a UTF-8/ASCII encoded string/stream */
	if (encoding != UTF8_ENCODED && encoding != UTF8_GUESSED && encoding != ASCII_ENCODED)
	{
		if (iana_id == 0)
			iana_id = IANA_ISO_8859_1;		/* Default if nothing has been picked */

		/* Get the transcoding table */
		mappingTableIn = GetMappingTable( iana_id);		/* Get the mapping table */

		/* Initialize the hook accordingly */
		if (mappingTableIn)
		{
			InitLocalHook( &inMapCharHook, (HOOKFUNC) &UniLatinToUTF8HookCode, (APTR) mappingTableIn);
			inHook = &inMapCharHook;
		}
		else
		{
			inHook = NULL;	/* No mapping table, no hook! */
		}


		/* Now, let's check whether we have to strip the BOM and to adopt
		   endianess to our machine (UTF-32 and UTF-16). */
		if (encoding > UTF8_ENCODED && encoding < UTF8_GUESSED)
		{
			/* Remove the BOM */
			temp = ((unsigned char *) src) + UniBomHasSize( encoding); 
			memmove( src, (void *) temp, inlength - UniBomHasSize( encoding));
			/* Update amount of code points */
			inlength -= UniBomHasSize( encoding);
			/* Use correct endianess */
			UniSwitchEncoding( src, ((unsigned char *) src) + inlength, encoding);
		}


		/* Now, let's check what kind of input stream we're faced with */
		switch (encoding)
		{
			case UTF32LE_ENCODED:
			case UTF32BE_ENCODED:
			{
				temp = (TEXT *) src;	/* Default: It's safe to use the same
										   buffer for UTF-8 although here the
									       UTF-32 code points have been stored */

				/* Only allocate RAM in case the amount of UTF-8 multibyte
				   sequences would exceed the capacity of the initial buffer */
				length = UniAccuUTF8StrLen( src, inlength, encoding, NULL);
				length = SIZEOFWITHALIGN( length + 1);
				if (length > initial_len)
				{
					temp = (TEXT *) AllocVec( length, MEMF_CLEAR);
				}

				/* 'temp' is either equal to src (default) or temp points the
				   new allocated memory region or is NULL in case we ran out
				   of RAM. */
				if (temp)
				{
					length = UTF32ToUTF8( (LONG *) src, inlength / 4, temp, inlength, NULL);
					if ( !ISBLUNDER(length) )
					{
						retval = TRUE;
						*outlen = (ULONG) length;
						UTF8StrInfo( temp, temp + length, NULL, cps, NULL);
						if (temp != src)	/* If they differ, we did allocate RAM! */
						{
							/* Because we used MEMF_CLEAR for allocation, there
							   is a zero byte at the end of the UTF-8 character
							   sequences. */
							*dest = temp;
						}
					}
					else
					{
						if (temp != src)	/* If they differ, we did allocate RAM! */
						{
							FreeVec( temp);
						}
					}
				}
			}
			break;

			case UTF16LE_ENCODED:
			case UTF16BE_ENCODED:
			{
				/* Accumulate the needed storage size by examining the string */
				length = UniAccuUTF8StrLen( src, inlength, encoding, NULL);
				length = SIZEOFWITHALIGN( length + 1);

				/* We have to allocate a new buffer for the UTF-8 multibyte
				   sequences because we might end up using 3 bytes instead of
				   2 for a certain UTF-16 code point */
				if ( (temp = (TEXT *) AllocVec( length, MEMF_CLEAR)) )
				{
					length = UTF16ToUTF8( (UWORD *) src, inlength / 2, temp, length, NULL);
					if ( !ISBLUNDER(length) )
					{
						retval = TRUE;
						*outlen = (ULONG) length;
						/* Because we used MEMF_CLEAR for allocation, there
						   is a zero byte at the end of the UTF-8 character
						   sequences. */
						*cps = UTF8StrLen( temp);
						*dest = temp;
					}
					else
					{
						FreeVec( temp);
					}
				}
			}
			break;

			default:
			{
				/* Accumulate the needed storage size by examining the string */
				length = UniAccuUTF8StrLen( src, inlength, encoding, mappingTableIn);
				length = SIZEOFWITHALIGN( length + 1);

				/* We cannot use the initial buffer for storing the UTF-8
				   multibyte sequences because any character code in range
				   from 128 to 255 ends up using two byte in UTF-8 */
				if ( (temp = (TEXT *) AllocVec( length, MEMF_CLEAR)) )
				{
					/* Transcode ISO-8859-x/Amiga-1251 to UTF-8 using a
					   Hook that transcodes the character codes.
					   NOTE: inHook may NULL 'cause of an unsupported
					   encoding scheme! */
					length = LatinToUTF8(  (TEXT *) src, inlength, temp, length, inHook);
					if ( !ISBLUNDER(length) )
					{
						retval = TRUE;
						*outlen = (ULONG) length;
						/* Because we used MEMF_CLEAR for allocation, there
						   is a zero byte at the end of the UTF-8 character
						   sequences. */
						*cps = UTF8StrLen( temp);
						*dest = temp;
					}
					else
					{
						FreeVec( temp);
					}
				}
			}
			break;

		}	/* end >>switch (encoding)<< */
	}

	return retval;
}
