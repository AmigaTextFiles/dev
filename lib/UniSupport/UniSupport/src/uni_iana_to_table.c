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

#include "mapping_table.h"

extern struct MapTableSBCES MT_ISO_8859_1[];
extern struct MapTableSBCES MT_ISO_8859_2[];
extern struct MapTableSBCES MT_ISO_8859_3[];
extern struct MapTableSBCES MT_ISO_8859_4[];
extern struct MapTableSBCES MT_ISO_8859_5[];
extern struct MapTableSBCES MT_ISO_8859_6[];
extern struct MapTableSBCES MT_ISO_8859_7[];
extern struct MapTableSBCES MT_ISO_8859_8[];
extern struct MapTableSBCES MT_ISO_8859_9[];
extern struct MapTableSBCES MT_ISO_8859_10[];
extern struct MapTableSBCES MT_ISO_8859_11[];
extern struct MapTableSBCES MT_ISO_8859_13[];
extern struct MapTableSBCES MT_ISO_8859_14[];
extern struct MapTableSBCES MT_ISO_8859_15[];
extern struct MapTableSBCES MT_ISO_8859_16[];
extern struct MapTableSBCES MT_Amiga_1251[];

/*
 * Get the table which belongs to the used character set.
 */

struct MapTableSBCES * GetMappingTable( ULONG iana_id)
{
	/* IANA IDs as to be found in Locale library, too */
	#define IANA_ANSI_X3_4	(3)		/* ANSI 3.4 */
	#define IANA_ASCII		IANA_ANSI_X3_4
	#define IANA_US_ASCII	IANA_ANSI_X3_4
	#define IANA_ISO_8859_1 (4)
	#define IANA_ISO_8859_2 (5)
	#define IANA_ISO_8859_3 (6)
	#define IANA_ISO_8859_4 (7)
	#define IANA_ISO_8859_5 (8)
	#define IANA_ISO_8859_6 (9)
	#define IANA_ISO_8859_7 (10)
	#define IANA_ISO_8859_8 (11)
	#define IANA_ISO_8859_9 (12)
	#define IANA_ISO_8859_10 (13)
	#define IANA_ISO_8859_11 (2259)		/* Almost identical to TIS-620 - and strictly, not in IANA! */
	#define IANA_UTF_8		(106)
	#define IANA_ISO_8859_13 (109)
	#define IANA_ISO_8859_14 (110)
	#define IANA_ISO_8859_15 (111)
	#define IANA_ISO_8859_16 (112)
	#define IANA_UTF_16BE	(1013)
	#define IANA_UTF_16LE	(1014)
	#define IANA_UTF_16		(1015)
	#define IANA_UTF_32		(1017)
	#define IANA_UTF_32BE	(1018)
	#define IANA_UTF_32LE	(1019)
	#define IANA_Amiga_1251	(2104)
	#define IANA_TIS_620	(2259)

	struct MapTableSBCES *mt;


	switch (iana_id)
	{
		case IANA_US_ASCII:
		case IANA_ISO_8859_1:
			mt = MT_ISO_8859_1;
			break;

		case IANA_ISO_8859_2:
			mt = MT_ISO_8859_2;
			break;

		case IANA_ISO_8859_3:
			mt = MT_ISO_8859_3;
			break;

		case IANA_ISO_8859_4:
			mt = MT_ISO_8859_4;
			break;

		case IANA_ISO_8859_5:
			mt = MT_ISO_8859_5;
			break;

		case IANA_ISO_8859_6:
			mt = MT_ISO_8859_6;
			break;

		case IANA_ISO_8859_7:
			mt = MT_ISO_8859_7;
			break;

		case IANA_ISO_8859_8:
			mt = MT_ISO_8859_8;
			break;

		case IANA_ISO_8859_9:
			mt = MT_ISO_8859_9;
			break;

		case IANA_ISO_8859_10:
			mt = MT_ISO_8859_10;
			break;

		case IANA_TIS_620:
			mt = MT_ISO_8859_11;
			break;

		case IANA_ISO_8859_13:
			mt = MT_ISO_8859_13;
			break;

		case IANA_ISO_8859_14:
			mt = MT_ISO_8859_14;
			break;

		case IANA_ISO_8859_15:
			mt = MT_ISO_8859_15;
			break;

		case IANA_ISO_8859_16:
			mt = MT_ISO_8859_16;
			break;

		case IANA_Amiga_1251:
			mt = MT_Amiga_1251;
			break;

		default:
			mt = NULL;
			break;			
	}

	return mt;
}
