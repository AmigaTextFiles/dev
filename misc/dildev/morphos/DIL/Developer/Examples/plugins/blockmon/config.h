/*
 * blockmon.dilp - Block Monitor plugin for DIL
 * Copyright ©2004-2007 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 */

#ifndef CONFIG_H
#define CONFIG_H 1

//------------------------------------------------------------------------------
//en/disable some debug output

#define D(x) /* x */

//------------------------------------------------------------------------------

#define FMT_PROCESS						NAME" [dil.device:%lu]"

#define FMT_CACHE_UNIT					"unit[%lu].cch"
#define FMT_CONFIG_CACHEMAXLENGTH	"cachemaxlength[%lu].cfg"

#define CACHE_MAXLENGTH 				10000

//------------------------------------------------------------------------------

#endif /* CONFIG_H */


