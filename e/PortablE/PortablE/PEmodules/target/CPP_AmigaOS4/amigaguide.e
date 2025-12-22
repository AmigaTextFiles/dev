/* $Id: amigaguide_protos.h,v 1.7 2005/11/10 15:30:32 hjfrieden Exp $ */
OPT NATIVE
PUBLIC MODULE 'target/libraries/amigaguide'
MODULE 'target/exec/types', 'target/exec/ports', 'target/dos/dos', /*'target/libraries/amigaguide',*/ 'target/utility/tagitem', 'target/utility/hooks', 'target/rexx/storage'
MODULE 'target/PEalias/exec', 'target/exec/libraries'
{
#include <proto/amigaguide.h>
}
{
struct Library* AmigaGuideBase = NULL;
struct AmigaGuideIFace* IAmigaGuide = NULL;
}
NATIVE {CLIB_AMIGAGUIDE_PROTOS_H} CONST
NATIVE {PROTO_AMIGAGUIDE_H} CONST
NATIVE {PRAGMA_AMIGAGUIDE_H} CONST
NATIVE {INLINE4_AMIGAGUIDE_H} CONST
NATIVE {AMIGAGUIDE_INTERFACE_DEF_H} CONST

NATIVE {AmigaGuideBase} DEF amigaguidebase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IAmigaGuide} DEF

PROC new()
	InitLibrary('amigaguide.library', NATIVE {(struct Interface **) &IAmigaGuide} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

/*--- functions in V40 or higher (Release 3.1) ---*/

/* Public entries */

->NATIVE {LockAmigaGuideBase} PROC
PROC LockAmigaGuideBase( handle:APTR ) IS NATIVE {IAmigaGuide->LockAmigaGuideBase(} handle {)} ENDNATIVE !!VALUE
->NATIVE {UnlockAmigaGuideBase} PROC
PROC UnlockAmigaGuideBase( key:VALUE ) IS NATIVE {IAmigaGuide->UnlockAmigaGuideBase(} key {)} ENDNATIVE
->NATIVE {OpenAmigaGuideA} PROC
PROC OpenAmigaGuideA( nag:PTR TO newamigaguide, tags:ARRAY OF tagitem ) IS NATIVE {IAmigaGuide->OpenAmigaGuideA(} nag {,} tags {)} ENDNATIVE !!APTR
->NATIVE {OpenAmigaGuide} PROC
PROC OpenAmigaGuide( nag:PTR TO newamigaguide, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IAmigaGuide->OpenAmigaGuide(} nag {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!APTR
->NATIVE {OpenAmigaGuideAsyncA} PROC
PROC OpenAmigaGuideAsyncA( nag:PTR TO newamigaguide, attrs:ARRAY OF tagitem ) IS NATIVE {IAmigaGuide->OpenAmigaGuideAsyncA(} nag {,} attrs {)} ENDNATIVE !!APTR
->NATIVE {OpenAmigaGuideAsync} PROC
PROC OpenAmigaGuideAsync( nag:PTR TO newamigaguide, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IAmigaGuide->OpenAmigaGuideAsync(} nag {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!APTR
->NATIVE {CloseAmigaGuide} PROC
PROC CloseAmigaGuide( cl:APTR ) IS NATIVE {IAmigaGuide->CloseAmigaGuide(} cl {)} ENDNATIVE
->NATIVE {AmigaGuideSignal} PROC
PROC AmigaGuideSignal( cl:APTR ) IS NATIVE {IAmigaGuide->AmigaGuideSignal(} cl {)} ENDNATIVE !!ULONG
->NATIVE {GetAmigaGuideMsg} PROC
PROC GetAmigaGuideMsg( cl:APTR ) IS NATIVE {IAmigaGuide->GetAmigaGuideMsg(} cl {)} ENDNATIVE !!PTR TO amigaguidemsg
->NATIVE {ReplyAmigaGuideMsg} PROC
PROC ReplyAmigaGuideMsg( amsg:PTR TO amigaguidemsg ) IS NATIVE {IAmigaGuide->ReplyAmigaGuideMsg(} amsg {)} ENDNATIVE
->NATIVE {SetAmigaGuideContextA} PROC
PROC SetAmigaGuideContextA( cl:APTR, id:ULONG, attrs:ARRAY OF tagitem ) IS NATIVE {IAmigaGuide->SetAmigaGuideContextA(} cl {,} id {,} attrs {)} ENDNATIVE !!VALUE
->NATIVE {SetAmigaGuideContext} PROC
PROC SetAmigaGuideContext( cl:APTR, id:ULONG, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IAmigaGuide->SetAmigaGuideContext(} cl {,} id {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {SendAmigaGuideContextA} PROC
PROC SendAmigaGuideContextA( cl:APTR, attrs:ARRAY OF tagitem ) IS NATIVE {IAmigaGuide->SendAmigaGuideContextA(} cl {,} attrs {)} ENDNATIVE !!VALUE
->NATIVE {SendAmigaGuideContext} PROC
PROC SendAmigaGuideContext( cl:APTR, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IAmigaGuide->SendAmigaGuideContext(} cl {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {SendAmigaGuideCmdA} PROC
PROC SendAmigaGuideCmdA( cl:APTR, cmd:/*STRPTR*/ ARRAY OF CHAR, attrs:ARRAY OF tagitem ) IS NATIVE {IAmigaGuide->SendAmigaGuideCmdA(} cl {,} cmd {,} attrs {)} ENDNATIVE !!VALUE
->NATIVE {SendAmigaGuideCmd} PROC
PROC SendAmigaGuideCmd( cl:APTR, cmd:/*STRPTR*/ ARRAY OF CHAR, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IAmigaGuide->SendAmigaGuideCmd(} cl {,} cmd {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {SetAmigaGuideAttrsA} PROC
PROC SetAmigaGuideAttrsA( cl:APTR, attrs:ARRAY OF tagitem ) IS NATIVE {IAmigaGuide->SetAmigaGuideAttrsA(} cl {,} attrs {)} ENDNATIVE !!VALUE
->NATIVE {SetAmigaGuideAttrs} PROC
PROC SetAmigaGuideAttrs( cl:APTR, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IAmigaGuide->SetAmigaGuideAttrs(} cl {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {GetAmigaGuideAttr} PROC
PROC GetAmigaGuideAttr( tag:TAG, cl:APTR, storage:PTR TO ULONG ) IS NATIVE {IAmigaGuide->GetAmigaGuideAttr(} tag {,} cl {,} storage {)} ENDNATIVE !!VALUE
->NATIVE {LoadXRef} PROC
PROC LoadXRef( lock:BPTR, name:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {IAmigaGuide->LoadXRef(} lock {,} name {)} ENDNATIVE !!VALUE
->NATIVE {ExpungeXRef} PROC
PROC ExpungeXRef( ) IS NATIVE {IAmigaGuide->ExpungeXRef()} ENDNATIVE
->NATIVE {AddAmigaGuideHostA} PROC
PROC AddAmigaGuideHostA( h:PTR TO hook, name:/*STRPTR*/ ARRAY OF CHAR, attrs:ARRAY OF tagitem ) IS NATIVE {IAmigaGuide->AddAmigaGuideHostA(} h {,} name {,} attrs {)} ENDNATIVE !!APTR
->NATIVE {AddAmigaGuideHost} PROC
PROC AddAmigaGuideHost( h:PTR TO hook, name:/*STRPTR*/ ARRAY OF CHAR, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IAmigaGuide->AddAmigaGuideHost(} h {,} name {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!APTR
->NATIVE {RemoveAmigaGuideHostA} PROC
PROC RemoveAmigaGuideHostA( hh:APTR, attrs:ARRAY OF tagitem ) IS NATIVE {IAmigaGuide->RemoveAmigaGuideHostA(} hh {,} attrs {)} ENDNATIVE !!VALUE
->NATIVE {RemoveAmigaGuideHost} PROC
PROC RemoveAmigaGuideHost( hh:APTR, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IAmigaGuide->RemoveAmigaGuideHost(} hh {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {GetAmigaGuideString} PROC
PROC GetAmigaGuideString( id:VALUE ) IS NATIVE {(char*) IAmigaGuide->GetAmigaGuideString(} id {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
