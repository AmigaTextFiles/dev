/*
 * default.dilp - Default plugin for DIL
 * Copyright ©2004-2007 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 */

//-----------------------------------------------------------------------------

#define VERSION 			1
#define REVISION 			11
#define VERSION_STR 		"1"
#define REVISION_STR 	"11"

#define NAME_SHORT 		"default"
#define NAME_LONG 		"Default function"

#define NAME 				NAME_SHORT".dilp"

#define DESC            "Demonstrates the principle of function of plugins for the dil.device.\n"\
                        "Does nothing that being loaded :)"

#define AUTHOR 			"Rupert Hausberger <naTmeg@gmx.net>"
#define COPY 				"©2004-"__YEAR__" "AUTHOR
#define URL 				"http://naTmeg.webhop.net"

#define LICENCE 			"freeware | opensource"

//-----------------------------------------------------------------------------

#define VSTRING			NAME" "VERSION_STR"."REVISION_STR" ("__AMIGADATE__") "COPY
#define VERSTAG			"\0$VER:"VSTRING"\0"

//-----------------------------------------------------------------------------

