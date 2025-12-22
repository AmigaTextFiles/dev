/* $Id: rexxsyslib_protos.h,v 1.11 2005/11/10 15:30:32 hjfrieden Exp $ */
OPT NATIVE, INLINE
PUBLIC MODULE 'target/rexx/errors', 'target/rexx/rexxio', 'target/rexx/rxslib', 'target/rexx/storage'
MODULE 'target/PEalias/exec', 'target/exec/types', 'target/exec/libraries', 'target/exec/ports' /*, 'target/rexx/rxslib', 'target/rexx/rexxio'*/
{
#include <proto/rexxsyslib.h>
}
{
struct Library* RexxSysBase = NULL;
struct RexxSysIFace* IRexxSys = NULL;
}
NATIVE {CLIB_REXXSYSLIB_PROTOS_H} CONST
NATIVE {PROTO_REXXSYSLIB_H} CONST
NATIVE {PRAGMA_REXXSYSLIB_H} CONST
NATIVE {INLINE4_REXXSYSLIB_H} CONST
NATIVE {REXXSYSLIB_INTERFACE_DEF_H} CONST

NATIVE {RexxSysBase} DEF rexxsysbase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IRexxSys}    DEF

PROC new()
	InitLibrary('rexxsyslib.library', NATIVE {(struct Interface **) &IRexxSys} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

/*--- functions in V33 or higher (Release 1.2) ---*/
->NATIVE {CreateArgstring} PROC
PROC CreateArgstring( string:/*CONST_STRPTR*/ ARRAY OF CHAR, length:ULONG ) IS NATIVE {IRexxSys->CreateArgstring(} string {,} length {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
->NATIVE {DeleteArgstring} PROC
PROC DeleteArgstring( argstring:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {IRexxSys->DeleteArgstring(} argstring {)} ENDNATIVE
->NATIVE {LengthArgstring} PROC
PROC LengthArgstring( argstring:/*CONST_STRPTR*/ ARRAY OF CHAR ) IS NATIVE {IRexxSys->LengthArgstring(} argstring {)} ENDNATIVE !!ULONG
->NATIVE {CreateRexxMsg} PROC
PROC CreateRexxMsg( port:PTR TO mp, extension:/*CONST_STRPTR*/ ARRAY OF CHAR, host:/*CONST_STRPTR*/ ARRAY OF CHAR ) IS NATIVE {IRexxSys->CreateRexxMsg(} port {,} extension {,} host {)} ENDNATIVE !!PTR TO rexxmsg
->NATIVE {DeleteRexxMsg} PROC
PROC DeleteRexxMsg( packet:PTR TO rexxmsg ) IS NATIVE {IRexxSys->DeleteRexxMsg(} packet {)} ENDNATIVE
->NATIVE {ClearRexxMsg} PROC
PROC ClearRexxMsg( msgptr:PTR TO rexxmsg, count:ULONG ) IS NATIVE {IRexxSys->ClearRexxMsg(} msgptr {,} count {)} ENDNATIVE
->NATIVE {FillRexxMsg} PROC
PROC FillRexxMsg( msgptr:PTR TO rexxmsg, count:ULONG, mask:ULONG ) IS NATIVE {-IRexxSys->FillRexxMsg(} msgptr {,} count {,} mask {)} ENDNATIVE !!INT
->NATIVE {IsRexxMsg} PROC
PROC IsRexxMsg( msgptr:PTR TO rexxmsg ) IS NATIVE {-IRexxSys->IsRexxMsg(} msgptr {)} ENDNATIVE !!INT


->NATIVE {LockRexxBase} PROC
PROC LockRexxBase( resource:ULONG ) IS NATIVE {IRexxSys->LockRexxBase(} resource {)} ENDNATIVE
->NATIVE {UnlockRexxBase} PROC
PROC UnlockRexxBase( resource:ULONG ) IS NATIVE {IRexxSys->UnlockRexxBase(} resource {)} ENDNATIVE
