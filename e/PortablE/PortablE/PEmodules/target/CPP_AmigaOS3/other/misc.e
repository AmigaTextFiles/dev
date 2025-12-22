/* $VER: misc_protos.h 40.1 (17.5.1996) */
OPT NATIVE
MODULE 'target/exec/types'
MODULE 'target/exec/libraries'
{
#include <clib/misc_protos.h>
struct Library *MiscBase = NULL;
}
NATIVE {CLIB_MISC_PROTOS_H} CONST

NATIVE {MiscBase} DEF miscbase:PTR TO lib

NATIVE {AllocMiscResource} PROC
PROC allocMiscResource( unitNum:ULONG, name:ARRAY OF CHAR /*STRPTR*/ ) IS NATIVE {AllocMiscResource(} unitNum {,} name {)} ENDNATIVE !!PTR TO UBYTE
NATIVE {FreeMiscResource} PROC
PROC freeMiscResource( unitNum:ULONG ) IS NATIVE {FreeMiscResource(} unitNum {)} ENDNATIVE
