/*
 * aes.dilp - AES cipher plugin for DIL
 * Copyright ©2004-2009 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 */

//-----------------------------------------------------------------------------

#define VERSION 			1
#define REVISION 			0
#define VERSION_STR 		"1"
#define REVISION_STR 	"0"

#define NAME_SHORT 		"aes"
#define NAME_LONG 		"Advanced Encryption Standard"

#define NAME 				NAME_SHORT".dilp"

#define DESC "\n"\
	"In cryptography, the Advanced Encryption Standard (AES), also known as Rijndael,\n" \
	"is a block cipher adopted as an encryption standard by the U.S. government.\n" \
	"It has been analyzed extensively and is now used worldwide, as was the case with\n" \
	"its predecessor, the Data Encryption Standard (DES). AES was announced by National\n" \
	"Institute of Standards and Technology (NIST) as U.S. FIPS PUB 197 (FIPS 197) on\n" \
	"November 26, 2001 after a 5-year standardization process in which fifteen competing\n" \
	"designs were presented and evaluated before Rijndael was selected as the most suitable.\n" \
	"It became effective as a standard May 26, 2002. As of 2006, AES is one of the most\n" \
	"popular algorithms used in symmetric key cryptography. It is available by choice in\n" \
	"many different encryption packages. This marks the first time that the public has\n" \
	"had access to a cipher approved by NSA for top secret information."

#define AUTHOR 			"Rupert Hausberger <naTmeg@gmx.net>"
#define COPY 				"©2004-"__YEAR__" "AUTHOR
#define URL 				"http://naTmeg.strangled.net"

#define LICENCE 			"freeware | opensource"

//-----------------------------------------------------------------------------

#define VSTRING			NAME" "VERSION_STR"."REVISION_STR" ("__AMIGADATE__") "COPY
#define VERSTAG			"\0$VER:"VSTRING"\0"

//-----------------------------------------------------------------------------

