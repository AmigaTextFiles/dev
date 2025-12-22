OPT NATIVE
PUBLIC MODULE 'target/libraries/amigaguide'
MODULE 'target/aros/libcall' /*, 'target/libraries/amigaguide'*/
MODULE 'target/exec/libraries', 'target/utility/hooks', 'target/utility/tagitem', 'target/exec/types', 'target/dos/dos'
{
#include <proto/amigaguide.h>
}
{
struct Library* AmigaGuideBase = NULL;
}
NATIVE {CLIB_AMIGAGUIDE_PROTOS_H} CONST
NATIVE {PROTO_AMIGAGUIDE_H} CONST

NATIVE {AmigaGuideBase} DEF amigaguidebase:PTR TO lib		->AmigaE does not automatically initialise this

/* Prototypes for stubs in amiga.lib */
NATIVE {AddAmigaGuideHost} PROC
PROC AddAmigaGuideHost(hook:PTR TO hook, name:/*STRPTR*/ ARRAY OF CHAR, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {AddAmigaGuideHost(} hook {,} name {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!AMIGAGUIDEHOST
NATIVE {OpenAmigaGuide} PROC
PROC OpenAmigaGuide(nag:PTR TO newamigaguide, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {OpenAmigaGuide(} nag {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!AMIGAGUIDECONTEXT
NATIVE {OpenAmigaGuideAsync} PROC
PROC OpenAmigaGuideAsync(nag:PTR TO newamigaguide, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {OpenAmigaGuideAsync(} nag {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!AMIGAGUIDECONTEXT
NATIVE {RemoveAmigaGuideHost} PROC
PROC RemoveAmigaGuideHost(key:PTR TO amigaguidehost, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {RemoveAmigaGuideHost(} key {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!VALUE
NATIVE {SendAmigaGuideCmd} PROC
PROC SendAmigaGuideCmd(handle:AMIGAGUIDECONTEXT, cmd:/*STRPTR*/ ARRAY OF CHAR, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {-SendAmigaGuideCmd(} handle {,} cmd {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!INT
NATIVE {SendAmigaGuideContext} PROC
PROC SendAmigaGuideContext(handle:AMIGAGUIDECONTEXT, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {-SendAmigaGuideContext(} handle {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!INT
NATIVE {SetAmigaGuideAttrs} PROC
PROC SetAmigaGuideAttrs(handle:AMIGAGUIDECONTEXT, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {SetAmigaGuideAttrs(} handle {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!VALUE
NATIVE {SetAmigaGuideContext} PROC
PROC SetAmigaGuideContext(handle:AMIGAGUIDECONTEXT, context:ULONG, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {-SetAmigaGuideContext(} handle {,} context {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!INT

NATIVE {LockAmigaGuideBase} PROC
PROC LockAmigaGuideBase(handle:AMIGAGUIDECONTEXT) IS NATIVE {LockAmigaGuideBase(} handle {)} ENDNATIVE !!VALUE
NATIVE {UnlockAmigaGuideBase} PROC
PROC UnlockAmigaGuideBase(key:VALUE) IS NATIVE {UnlockAmigaGuideBase(} key {)} ENDNATIVE
NATIVE {OpenAmigaGuideA} PROC
PROC OpenAmigaGuideA(nag:PTR TO newamigaguide, attrs:ARRAY OF tagitem) IS NATIVE {OpenAmigaGuideA(} nag {,} attrs {)} ENDNATIVE !!AMIGAGUIDECONTEXT
NATIVE {OpenAmigaGuideAsyncA} PROC
PROC OpenAmigaGuideAsyncA(nag:PTR TO newamigaguide, attrs:ARRAY OF tagitem) IS NATIVE {OpenAmigaGuideAsyncA(} nag {,} attrs {)} ENDNATIVE !!AMIGAGUIDECONTEXT
NATIVE {CloseAmigaGuide} PROC
PROC CloseAmigaGuide(handle:AMIGAGUIDECONTEXT) IS NATIVE {CloseAmigaGuide(} handle {)} ENDNATIVE
NATIVE {AmigaGuideSignal} PROC
PROC AmigaGuideSignal(handle:AMIGAGUIDECONTEXT) IS NATIVE {AmigaGuideSignal(} handle {)} ENDNATIVE !!ULONG
NATIVE {GetAmigaGuideMsg} PROC
PROC GetAmigaGuideMsg(handle:AMIGAGUIDECONTEXT) IS NATIVE {GetAmigaGuideMsg(} handle {)} ENDNATIVE !!PTR TO amigaguidemsg
NATIVE {ReplyAmigaGuideMsg} PROC
PROC ReplyAmigaGuideMsg(msg:PTR TO amigaguidemsg) IS NATIVE {ReplyAmigaGuideMsg(} msg {)} ENDNATIVE
NATIVE {SetAmigaGuideContextA} PROC
PROC SetAmigaGuideContextA(handle:AMIGAGUIDECONTEXT, context:ULONG, attrs:ARRAY OF tagitem) IS NATIVE {-SetAmigaGuideContextA(} handle {,} context {,} attrs {)} ENDNATIVE !!INT
NATIVE {SendAmigaGuideContextA} PROC
PROC SendAmigaGuideContextA(handle:AMIGAGUIDECONTEXT, attrs:ARRAY OF tagitem) IS NATIVE {-SendAmigaGuideContextA(} handle {,} attrs {)} ENDNATIVE !!INT
NATIVE {SendAmigaGuideCmdA} PROC
PROC SendAmigaGuideCmdA(handle:AMIGAGUIDECONTEXT, cmd:/*STRPTR*/ ARRAY OF CHAR, attrs:ARRAY OF tagitem) IS NATIVE {-SendAmigaGuideCmdA(} handle {,} cmd {,} attrs {)} ENDNATIVE !!INT
NATIVE {SetAmigaGuideAttrsA} PROC
PROC SetAmigaGuideAttrsA(handle:AMIGAGUIDECONTEXT, attrs:ARRAY OF tagitem) IS NATIVE {SetAmigaGuideAttrsA(} handle {,} attrs {)} ENDNATIVE !!VALUE
NATIVE {GetAmigaGuideAttr} PROC
PROC GetAmigaGuideAttr(tag:TAG, handle:AMIGAGUIDECONTEXT, storage:PTR TO ULONG) IS NATIVE {GetAmigaGuideAttr(} tag {,} handle {,} storage {)} ENDNATIVE !!VALUE
NATIVE {LoadXRef} PROC
PROC LoadXRef(lock:BPTR, name:/*STRPTR*/ ARRAY OF CHAR) IS NATIVE {LoadXRef(} lock {,} name {)} ENDNATIVE !!VALUE
NATIVE {ExpungeXRef} PROC
PROC ExpungeXRef() IS NATIVE {ExpungeXRef()} ENDNATIVE
NATIVE {AddAmigaGuideHostA} PROC
PROC AddAmigaGuideHostA(hook:PTR TO hook, name:/*STRPTR*/ ARRAY OF CHAR, attrs:ARRAY OF tagitem) IS NATIVE {AddAmigaGuideHostA(} hook {,} name {,} attrs {)} ENDNATIVE !!PTR TO amigaguidehost
NATIVE {RemoveAmigaGuideHostA} PROC
PROC RemoveAmigaGuideHostA(key:PTR TO amigaguidehost, attrs:ARRAY OF tagitem) IS NATIVE {RemoveAmigaGuideHostA(} key {,} attrs {)} ENDNATIVE !!VALUE
NATIVE {GetAmigaGuideString} PROC
PROC GetAmigaGuideString(id:ULONG) IS NATIVE {GetAmigaGuideString(} id {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
