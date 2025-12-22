OPT NATIVE, INLINE
MODULE 'intuition/classes', 'intuition/classusr', 'utility/hooks', 'exec/types', 'target/utility/tagitem'
{MODULE 'amigalib/boopsi'}

NATIVE {callHookA} PROC
PROC callHookA( hookPtr:PTR TO hook, obj:PTR TO INTUIOBJECT, message:APTR ) IS NATIVE {callHookA(} hookPtr {,} obj {,} message {)} ENDNATIVE !!ULONG

NATIVE {coerceMethodA} PROC
PROC coerceMethodA( cl:PTR TO iclass, obj:PTR TO INTUIOBJECT, message/*:PTR TO msg*/ ) IS NATIVE {coerceMethodA(} cl {,} obj {,} message {)} ENDNATIVE !!ULONG

NATIVE {setSuperAttrsA} PROC
PROC setSuperAttrsA(cl:PTR TO iclass, obj:PTR TO INTUIOBJECT, msg:ARRAY OF tagitem) IS NATIVE {setSuperAttrsA(} cl {,} obj {,} msg {)} ENDNATIVE

NATIVE {doSuperMethodA} PROC
PROC doSuperMethodA( cl:PTR TO iclass, obj:PTR TO INTUIOBJECT, message/*:PTR TO msg*/ ) IS NATIVE {doSuperMethodA(} cl {,} obj {,} message {)} ENDNATIVE !!ULONG

NATIVE {doMethodA} PROC
PROC doMethodA( obj:PTR TO INTUIOBJECT, message/*:PTR TO msg*/ ) IS NATIVE {doMethodA(} obj {,} message {)} ENDNATIVE !!ULONG
