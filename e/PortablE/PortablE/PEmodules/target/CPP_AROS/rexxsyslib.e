OPT NATIVE
PUBLIC MODULE 'target/rexx/errors', 'target/rexx/rexxcall', 'target/rexx/rxslib', 'target/rexx/storage'
MODULE 'target/aros/libcall' /*, 'target/rexx/storage'*/
MODULE 'target/exec/libraries', 'target/exec/types', 'target/exec/ports'
{
#include <proto/rexxsyslib.h>
}
{
struct RxsLib* RexxSysBase = NULL;
}
NATIVE {CLIB_REXXSYSLIB_PROTOS_H} CONST
NATIVE {PROTO_REXXSYSLIB_H} CONST

NATIVE {RexxSysBase} DEF rexxsysbase:NATIVE {struct RxsLib*} PTR TO lib		->AmigaE does not automatically initialise this

NATIVE {CreateArgstring} PROC
PROC CreateArgstring(string:ARRAY OF UBYTE, length:ULONG) IS NATIVE {CreateArgstring(} string {,} length {)} ENDNATIVE !!ARRAY OF UBYTE
NATIVE {DeleteArgstring} PROC
PROC DeleteArgstring(argstring:ARRAY OF UBYTE) IS NATIVE {DeleteArgstring(} argstring {)} ENDNATIVE
NATIVE {LengthArgstring} PROC
PROC LengthArgstring(argstring:ARRAY OF UBYTE) IS NATIVE {LengthArgstring(} argstring {)} ENDNATIVE !!ULONG
NATIVE {CreateRexxMsg} PROC
PROC CreateRexxMsg(port:PTR TO mp, extension:ARRAY OF UBYTE, host:ARRAY OF UBYTE) IS NATIVE {CreateRexxMsg(} port {,} extension {,} host {)} ENDNATIVE !!PTR TO rexxmsg
NATIVE {DeleteRexxMsg} PROC
PROC DeleteRexxMsg(packet:PTR TO rexxmsg) IS NATIVE {DeleteRexxMsg(} packet {)} ENDNATIVE
NATIVE {ClearRexxMsg} PROC
PROC ClearRexxMsg(msgptr:PTR TO rexxmsg, count:ULONG) IS NATIVE {ClearRexxMsg(} msgptr {,} count {)} ENDNATIVE
NATIVE {FillRexxMsg} PROC
PROC FillRexxMsg(msgptr:PTR TO rexxmsg, count:ULONG, mask:ULONG) IS NATIVE {-FillRexxMsg(} msgptr {,} count {,} mask {)} ENDNATIVE !!INT
NATIVE {IsRexxMsg} PROC
PROC IsRexxMsg(msgptr:PTR TO rexxmsg) IS NATIVE {-IsRexxMsg(} msgptr {)} ENDNATIVE !!INT
NATIVE {LockRexxBase} PROC
PROC LockRexxBase(resource:ULONG) IS NATIVE {LockRexxBase(} resource {)} ENDNATIVE
NATIVE {UnlockRexxBase} PROC
PROC UnlockRexxBase(resource:ULONG) IS NATIVE {UnlockRexxBase(} resource {)} ENDNATIVE
