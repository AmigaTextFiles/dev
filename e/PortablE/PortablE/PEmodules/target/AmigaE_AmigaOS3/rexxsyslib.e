/* $VER: rexxsyslib_protos.h 40.1 (17.5.1996) */
OPT NATIVE, INLINE
PUBLIC MODULE 'target/rexx/errors', 'target/rexx/rexxio', 'target/rexx/rxslib', 'target/rexx/storage'
MODULE 'target/exec/types' /*, 'target/rexx/rxslib', 'target/rexx/rexxio'*/
MODULE 'target/exec/ports', 'target/exec/libraries'
{MODULE 'rexxsyslib'}

NATIVE {rexxsysbase} DEF rexxsysbase:NATIVE {LONG} PTR TO lib		->AmigaE does not automatically initialise this

/*--- functions in V33 or higher (Release 1.2) ---*/

NATIVE {CreateArgstring} PROC
PROC CreateArgstring( string:/*STRPTR*/ ARRAY OF CHAR, length:ULONG ) IS NATIVE {CreateArgstring(} string {,} length {)} ENDNATIVE !!ARRAY OF UBYTE
NATIVE {DeleteArgstring} PROC
PROC DeleteArgstring( argstring:ARRAY OF UBYTE ) IS NATIVE {DeleteArgstring(} argstring {)} ENDNATIVE
NATIVE {LengthArgstring} PROC
PROC LengthArgstring( argstring:ARRAY OF UBYTE ) IS NATIVE {LengthArgstring(} argstring {)} ENDNATIVE !!ULONG
NATIVE {CreateRexxMsg} PROC
PROC CreateRexxMsg( port:PTR TO mp, extension:/*CONST_STRPTR*/ ARRAY OF CHAR, host:/*CONST_STRPTR*/ ARRAY OF CHAR ) IS NATIVE {CreateRexxMsg(} port {,} extension {,} host {)} ENDNATIVE !!PTR TO rexxmsg
NATIVE {DeleteRexxMsg} PROC
PROC DeleteRexxMsg( packet:PTR TO rexxmsg ) IS NATIVE {DeleteRexxMsg(} packet {)} ENDNATIVE
NATIVE {ClearRexxMsg} PROC
PROC ClearRexxMsg( msgptr:PTR TO rexxmsg, count:ULONG ) IS NATIVE {ClearRexxMsg(} msgptr {,} count {)} ENDNATIVE
NATIVE {FillRexxMsg} PROC
PROC FillRexxMsg( msgptr:PTR TO rexxmsg, count:ULONG, mask:ULONG ) IS NATIVE {FillRexxMsg(} msgptr {,} count {,} mask {)} ENDNATIVE !!INT
NATIVE {IsRexxMsg} PROC
PROC IsRexxMsg( msgptr:PTR TO rexxmsg ) IS NATIVE {IsRexxMsg(} msgptr {)} ENDNATIVE !!INT


NATIVE {LockRexxBase} PROC
PROC LockRexxBase( resource:ULONG ) IS NATIVE {LockRexxBase(} resource {)} ENDNATIVE
NATIVE {UnlockRexxBase} PROC
PROC UnlockRexxBase( resource:ULONG ) IS NATIVE {UnlockRexxBase(} resource {)} ENDNATIVE
