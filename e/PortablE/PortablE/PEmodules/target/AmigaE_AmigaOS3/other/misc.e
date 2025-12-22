/* $VER: misc_protos.h 40.1 (17.5.1996) */
OPT NATIVE
MODULE 'target/exec/types'
MODULE 'target/exec/libraries'
{MODULE 'other/misc'}

NATIVE {miscbase} DEF miscbase:PTR TO lib

NATIVE {allocMiscResource} PROC
PROC allocMiscResource( unitNum:ULONG, name:ARRAY OF CHAR /*STRPTR*/ ) IS NATIVE {allocMiscResource(} unitNum {,} name {)} ENDNATIVE !!PTR TO UBYTE
NATIVE {freeMiscResource} PROC
PROC freeMiscResource( unitNum:ULONG ) IS NATIVE {freeMiscResource(} unitNum {)} ENDNATIVE
