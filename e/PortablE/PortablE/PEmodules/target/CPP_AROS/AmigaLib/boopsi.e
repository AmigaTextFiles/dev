OPT NATIVE, INLINE, POINTER
/*PUBLIC*/ MODULE 'target/amigalib'
MODULE 'intuition/classes', 'intuition/classusr', 'utility/hooks', 'exec/types', 'target/utility/tagitem'

PROC callHookA(hook:PTR TO hook, obj:APTR, param:APTR) IS NATIVE {CallHookA(} hook {,} obj {,} param {)} ENDNATIVE !!IPTR

PROC coerceMethodA( cl:PTR TO iclass, obj:PTR TO INTUIOBJECT, message/*:PTR TO msg*/ ) IS NATIVE {CoerceMethodA(} cl {,} obj {, (Msg)} message {)} ENDNATIVE !!ULONG

PROC setSuperAttrsA(cl:PTR TO iclass, obj:PTR TO INTUIOBJECT, msg:ARRAY OF tagitem) IS doSuperMethodA(cl, obj, [OM_SET, msg, NIL]:opset !!ARRAY!!ARRAY OF msg)

PROC doSuperMethodA( cl:PTR TO iclass, obj:PTR TO INTUIOBJECT, message/*:PTR TO msg*/ ) IS NATIVE {DoSuperMethodA(} cl {,} obj {, (Msg)} message {)} ENDNATIVE !!ULONG

PROC doMethodA( obj:PTR TO INTUIOBJECT, message/*:PTR TO msg*/ ) IS NATIVE {DoMethodA(} obj {, (Msg)} message {)} ENDNATIVE !!ULONG
