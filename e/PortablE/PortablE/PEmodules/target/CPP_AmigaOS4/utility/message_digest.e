/* $Id: message_digest.h,v 1.9 2005/11/10 15:39:42 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types'
{#include <utility/message_digest.h>}
NATIVE {UTILITY_MESSAGE_DIGEST_H} CONST

/* Context information to be passed around between the different SHA-1
   calculation routines. When the digest has been calculated, you fill
   find it stored in the 'mdsha_Code' member (all 160 bits of it). */
NATIVE {MessageDigest_SHA} OBJECT messagedigest_sha
    {mdsha_Code}	code[20]	:ARRAY OF UBYTE
    {mdsha_Reserved}	reserved[328]	:ARRAY OF UBYTE
ENDOBJECT
