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


#ifndef UNI_LOCAL_PROTOS_H
#define UNI_LOCAL_PROTOS_H

#include <exec/types.h>
#include <utility/hooks.h>
#include "mapping_table.h"
#include "SDI_compiler.h"

struct MapTableSBCES * GetMappingTable( ULONG iana_id);
void InitLocalHook( struct Hook *hook, HOOKFUNC callbackfunc, APTR data);
const TEXT * UniLegalUTF8Boundary( const TEXT *src, const TEXT *stop);
ULONG UniAccuUTF8StrLen( const void *src, const ULONG inlength, const ULONG encoding, const struct MapTableSBCES *mt);

/* #define MULTIPLIER		-- If set, it uses a fixed multiplier for
							   allocation rather than accumulating the required
							   storage size that must be provided in case a
							   string shall be transcoded to UTF-8 */

/*
 * Macro to align the size for memory allocations to a certain byte size
 * boundary.
 * The ALIGNTOSIZEBYTES must be a multiple of 8 e.g. 8, 16, 32, 64 and so on.
 */
#define ALIGNTOSIZEBYTES	(32)
#define SIZEOFWITHALIGN(x)	((x + (ALIGNTOSIZEBYTES - 1)) & (-ALIGNTOSIZEBYTES))

#endif
