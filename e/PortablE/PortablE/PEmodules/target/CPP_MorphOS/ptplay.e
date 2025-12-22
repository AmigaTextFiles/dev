OPT NATIVE
PUBLIC MODULE 'target/libraries/ptplay'
MODULE 'target/exec/types', 'target/utility/tagitem'
MODULE 'target/exec/libraries'
{
#include <proto/ptplay.h>
}
{
struct Library* PtPlayBase = NULL;
}
NATIVE {CLIB_PTPLAY_PROTOS_H} CONST
NATIVE {PROTO_PTPLAY_H} CONST

NATIVE {PtPlayBase} DEF ptplaybase:PTR TO lib		->AmigaE does not automatically initialise this

NATIVE {PtInit} PROC
PROC PtInit(buf:ARRAY OF BYTE, bufsize:VALUE, freq:VALUE, modtype:ULONG) IS NATIVE {PtInit((UBYTE*) } buf {,} bufsize {,} freq {,} modtype {)} ENDNATIVE !!APTR
NATIVE {PtRender} PROC
PROC PtRender(mod:APTR, destbuf1:ARRAY OF BYTE, destbuf2:ARRAY OF BYTE, bufmodulo:VALUE, numsmp:VALUE, scale:VALUE, depth:VALUE, channels:VALUE) IS NATIVE {PtRender(} mod {,} destbuf1 {,} destbuf2 {,} bufmodulo {,} numsmp {,} scale {,} depth {,} channels {)} ENDNATIVE
NATIVE {PtTest} PROC
PROC PtTest(filename:/*CONST_STRPTR*/ ARRAY OF CHAR, buf:ARRAY OF BYTE, bufsize:VALUE) IS NATIVE {PtTest(} filename {, (UBYTE*) } buf {,} bufsize {)} ENDNATIVE !!ULONG
NATIVE {PtCleanup} PROC
PROC PtCleanup(mod:APTR) IS NATIVE {PtCleanup(} mod {)} ENDNATIVE
NATIVE {PtSetAttrs} PROC
PROC PtSetAttrs(mod:APTR, taglist:ARRAY OF tagitem) IS NATIVE {PtSetAttrs(} mod {,} taglist {)} ENDNATIVE
NATIVE {PtGetAttr} PROC
PROC PtGetAttr(mod:APTR, tagitem:ULONG, StoragePtr:ARRAY OF VALUE) IS NATIVE {PtGetAttr(} mod {,} tagitem {, (ULONG*) } StoragePtr {)} ENDNATIVE !!ULONG
NATIVE {PtSeek} PROC
PROC PtSeek(mod:APTR, time:ULONG) IS NATIVE {PtSeek(} mod {,} time {)} ENDNATIVE !!ULONG
