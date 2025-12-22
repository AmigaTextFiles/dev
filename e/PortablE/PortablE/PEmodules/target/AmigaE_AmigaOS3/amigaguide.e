/* $VER: amigaguide_protos.h 39.4 (17.6.1993)/ */
OPT NATIVE
PUBLIC MODULE 'target/libraries/amigaguide'
MODULE 'target/exec/types', 'target/exec/ports', 'target/dos/dos', /*'target/libraries/amigaguide',*/ 'target/utility/tagitem', 'target/utility/hooks', 'target/rexx/storage'
MODULE 'target/exec/libraries'
{MODULE 'amigaguide'}

NATIVE {amigaguidebase} DEF amigaguidebase:NATIVE {LONG} PTR TO lib		->AmigaE does not automatically initialise this

/*--- functions in V40 or higher (Release 3.1) ---*/

/* Public entries */

NATIVE {LockAmigaGuideBase} PROC
PROC LockAmigaGuideBase( handle:APTR ) IS NATIVE {LockAmigaGuideBase(} handle {)} ENDNATIVE !!VALUE
NATIVE {UnlockAmigaGuideBase} PROC
PROC UnlockAmigaGuideBase( key:VALUE ) IS NATIVE {UnlockAmigaGuideBase(} key {)} ENDNATIVE
NATIVE {OpenAmigaGuideA} PROC
PROC OpenAmigaGuideA( nag:PTR TO newamigaguide, tags:ARRAY OF tagitem ) IS NATIVE {OpenAmigaGuideA(} nag {,} tags {)} ENDNATIVE !!APTR
->NATIVE {OpenAmigaGuide} PROC
->PROC OpenAmigaGuide( nag:PTR TO newamigaguide, tag1:TAG, tag12=0:ULONG, tag13=0:ULONG, tag14=0:ULONG, tag15=0:ULONG, tag16=0:ULONG, tag17=0:ULONG, tag18=0:ULONG ) IS NATIVE {OpenAmigaGuide(} nag {,} tag1 {,} tag12 {,} tag13 {,} tag14 {,} tag15 {,} tag16 {,} tag17 {,} tag18 {)} ENDNATIVE !!APTR
NATIVE {OpenAmigaGuideAsyncA} PROC
PROC OpenAmigaGuideAsyncA( nag:PTR TO newamigaguide, attrs:ARRAY OF tagitem ) IS NATIVE {OpenAmigaGuideAsyncA(} nag {,} attrs {)} ENDNATIVE !!APTR
->NATIVE {OpenAmigaGuideAsync} PROC
->PROC OpenAmigaGuideAsync( nag:PTR TO newamigaguide, tag1:TAG, tag12=0:ULONG, tag13=0:ULONG, tag14=0:ULONG, tag15=0:ULONG, tag16=0:ULONG, tag17=0:ULONG, tag18=0:ULONG ) IS NATIVE {OpenAmigaGuideAsync(} nag {,} tag1 {,} tag12 {,} tag13 {,} tag14 {,} tag15 {,} tag16 {,} tag17 {,} tag18 {)} ENDNATIVE !!APTR
NATIVE {CloseAmigaGuide} PROC
PROC CloseAmigaGuide( cl:APTR ) IS NATIVE {CloseAmigaGuide(} cl {)} ENDNATIVE
NATIVE {AmigaGuideSignal} PROC
PROC AmigaGuideSignal( cl:APTR ) IS NATIVE {AmigaGuideSignal(} cl {)} ENDNATIVE !!ULONG
NATIVE {GetAmigaGuideMsg} PROC
PROC GetAmigaGuideMsg( cl:APTR ) IS NATIVE {GetAmigaGuideMsg(} cl {)} ENDNATIVE !!PTR TO amigaguidemsg
NATIVE {ReplyAmigaGuideMsg} PROC
PROC ReplyAmigaGuideMsg( amsg:PTR TO amigaguidemsg ) IS NATIVE {ReplyAmigaGuideMsg(} amsg {)} ENDNATIVE
NATIVE {SetAmigaGuideContextA} PROC
PROC SetAmigaGuideContextA( cl:APTR, id:ULONG, attrs:ARRAY OF tagitem ) IS NATIVE {SetAmigaGuideContextA(} cl {,} id {,} attrs {)} ENDNATIVE !!VALUE
->NATIVE {SetAmigaGuideContext} PROC
->PROC SetAmigaGuideContext( cl:APTR, id:ULONG, tag1:TAG, tag12=0:ULONG, tag13=0:ULONG, tag14=0:ULONG, tag15=0:ULONG, tag16=0:ULONG, tag17=0:ULONG, tag18=0:ULONG ) IS NATIVE {SetAmigaGuideContext(} cl {,} id {,} tag1 {,} tag12 {,} tag13 {,} tag14 {,} tag15 {,} tag16 {,} tag17 {,} tag18 {)} ENDNATIVE !!VALUE
NATIVE {SendAmigaGuideContextA} PROC
PROC SendAmigaGuideContextA( cl:APTR, attrs:ARRAY OF tagitem ) IS NATIVE {SendAmigaGuideContextA(} cl {,} attrs {)} ENDNATIVE !!VALUE
->NATIVE {SendAmigaGuideContext} PROC
->PROC SendAmigaGuideContext( cl:APTR, tag1:TAG, tag12=0:ULONG, tag13=0:ULONG, tag14=0:ULONG, tag15=0:ULONG, tag16=0:ULONG, tag17=0:ULONG, tag18=0:ULONG ) IS NATIVE {SendAmigaGuideContext(} cl {,} tag1 {,} tag12 {,} tag13 {,} tag14 {,} tag15 {,} tag16 {,} tag17 {,} tag18 {)} ENDNATIVE !!VALUE
NATIVE {SendAmigaGuideCmdA} PROC
PROC SendAmigaGuideCmdA( cl:APTR, cmd:/*STRPTR*/ ARRAY OF CHAR, attrs:ARRAY OF tagitem ) IS NATIVE {SendAmigaGuideCmdA(} cl {,} cmd {,} attrs {)} ENDNATIVE !!VALUE
->NATIVE {SendAmigaGuideCmd} PROC
->PROC SendAmigaGuideCmd( cl:APTR, cmd:/*STRPTR*/ ARRAY OF CHAR, tag1:TAG, tag12=0:ULONG, tag13=0:ULONG, tag14=0:ULONG, tag15=0:ULONG, tag16=0:ULONG, tag17=0:ULONG, tag18=0:ULONG ) IS NATIVE {SendAmigaGuideCmd(} cl {,} cmd {,} tag1 {,} tag12 {,} tag13 {,} tag14 {,} tag15 {,} tag16 {,} tag17 {,} tag18 {)} ENDNATIVE !!VALUE
NATIVE {SetAmigaGuideAttrsA} PROC
PROC SetAmigaGuideAttrsA( cl:APTR, attrs:ARRAY OF tagitem ) IS NATIVE {SetAmigaGuideAttrsA(} cl {,} attrs {)} ENDNATIVE !!VALUE
->NATIVE {SetAmigaGuideAttrs} PROC
->PROC SetAmigaGuideAttrs( cl:APTR, tag1:TAG, tag12=0:ULONG, tag13=0:ULONG, tag14=0:ULONG, tag15=0:ULONG, tag16=0:ULONG, tag17=0:ULONG, tag18=0:ULONG ) IS NATIVE {SetAmigaGuideAttrs(} cl {,} tag1 {,} tag12 {,} tag13 {,} tag14 {,} tag15 {,} tag16 {,} tag17 {,} tag18 {)} ENDNATIVE !!VALUE
NATIVE {GetAmigaGuideAttr} PROC
PROC GetAmigaGuideAttr( tag:TAG, cl:APTR, storage:PTR TO ULONG ) IS NATIVE {GetAmigaGuideAttr(} tag {,} cl {,} storage {)} ENDNATIVE !!VALUE
->NATIVE {LoadXRef} PROC
->PROC LoadXRef( lock:BPTR, name:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {LoadXRef(} lock {,} name {)} ENDNATIVE !!VALUE
->NATIVE {ExpungeXRef} PROC
->PROC ExpungeXRef( ) IS NATIVE {ExpungeXRef()} ENDNATIVE
NATIVE {AddAmigaGuideHostA} PROC
PROC AddAmigaGuideHostA( h:PTR TO hook, name:/*STRPTR*/ ARRAY OF CHAR, attrs:ARRAY OF tagitem ) IS NATIVE {AddAmigaGuideHostA(} h {,} name {,} attrs {)} ENDNATIVE !!APTR
->NATIVE {AddAmigaGuideHost} PROC
->PROC AddAmigaGuideHost( h:PTR TO hook, name:/*STRPTR*/ ARRAY OF CHAR, tag1:TAG, tag12=0:ULONG, tag13=0:ULONG, tag14=0:ULONG, tag15=0:ULONG, tag16=0:ULONG, tag17=0:ULONG, tag18=0:ULONG ) IS NATIVE {AddAmigaGuideHost(} h {,} name {,} tag1 {,} tag12 {,} tag13 {,} tag14 {,} tag15 {,} tag16 {,} tag17 {,} tag18 {)} ENDNATIVE !!APTR
NATIVE {RemoveAmigaGuideHostA} PROC
PROC RemoveAmigaGuideHostA( hh:APTR, attrs:ARRAY OF tagitem ) IS NATIVE {RemoveAmigaGuideHostA(} hh {,} attrs {)} ENDNATIVE !!VALUE
->NATIVE {RemoveAmigaGuideHost} PROC
->PROC RemoveAmigaGuideHost( hh:APTR, tag1:TAG, tag12=0:ULONG, tag13=0:ULONG, tag14=0:ULONG, tag15=0:ULONG, tag16=0:ULONG, tag17=0:ULONG, tag18=0:ULONG ) IS NATIVE {RemoveAmigaGuideHost(} hh {,} tag1 {,} tag12 {,} tag13 {,} tag14 {,} tag15 {,} tag16 {,} tag17 {,} tag18 {)} ENDNATIVE !!VALUE
NATIVE {GetAmigaGuideString} PROC
PROC GetAmigaGuideString( id:VALUE ) IS NATIVE {GetAmigaGuideString(} id {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
