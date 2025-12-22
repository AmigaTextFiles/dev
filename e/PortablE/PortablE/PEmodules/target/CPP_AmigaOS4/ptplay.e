OPT NATIVE
PUBLIC MODULE 'target/libraries/ptplay'
MODULE 'target/exec/types', 'target/exec', 'target/exec/interfaces', 'target/utility/tagitem'
MODULE 'target/PEalias/exec'
{
#include <proto/ptplay.h>
}
{
struct Library* PtPlayBase = NULL;
struct PtPlayIFace* IPtPlay = NULL;
}
NATIVE {PROTO_PTPLAY_H} CONST
NATIVE {_PPCINLINE_PTPLAY_H} CONST

NATIVE {PtPlayBase} DEF ptplaybase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IPtPlay} DEF

PROC new()
	InitLibrary('ptplay.library', NATIVE {(struct Interface **) &IPtPlay} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

/*
/* Inline macros for Interface "main" */
NATIVE {PtInit} PROC
NATIVE {PtRender} PROC
NATIVE {PtTest} PROC
NATIVE {PtCleanup} PROC
NATIVE {PtSetAttrs} PROC
NATIVE {PtGetAttr} PROC
NATIVE {PtSeek} PROC
*/

PROC PtInit(buf:ARRAY OF BYTE, bufsize:VALUE, freq:VALUE, modtype:ULONG) IS NATIVE {IPtPlay->PtInit((UBYTE*) } buf {,} bufsize {,} freq {,} modtype {)} ENDNATIVE !!APTR
PROC PtRender(mod:APTR, destbuf1:ARRAY OF BYTE, destbuf2:ARRAY OF BYTE, bufmodulo:VALUE, numsmp:VALUE, scale:VALUE, depth:VALUE, channels:VALUE) IS NATIVE {IPtPlay->PtRender(} mod {,} destbuf1 {,} destbuf2 {,} bufmodulo {,} numsmp {,} scale {,} depth {,} channels {)} ENDNATIVE
PROC PtTest(filename:/*CONST_STRPTR*/ ARRAY OF CHAR, buf:ARRAY OF BYTE, bufsize:VALUE) IS NATIVE {IPtPlay->PtTest(} filename {, (UBYTE*) } buf {,} bufsize {)} ENDNATIVE !!ULONG
PROC PtCleanup(mod:APTR) IS NATIVE {IPtPlay->PtCleanup(} mod {)} ENDNATIVE
PROC PtSetAttrs(mod:APTR, taglist:ARRAY OF tagitem) IS NATIVE {IPtPlay->PtSetAttrs(} mod {,} taglist {)} ENDNATIVE
PROC PtGetAttr(mod:APTR, tagitem:ULONG, StoragePtr:ARRAY OF VALUE) IS NATIVE {IPtPlay->PtGetAttr(} mod {,} tagitem {, (ULONG*) } StoragePtr {)} ENDNATIVE !!ULONG
PROC PtSeek(mod:APTR, time:ULONG) IS NATIVE {IPtPlay->PtSeek(} mod {,} time {)} ENDNATIVE !!ULONG
