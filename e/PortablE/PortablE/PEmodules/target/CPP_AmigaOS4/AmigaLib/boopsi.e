OPT NATIVE, INLINE
/*PUBLIC*/ MODULE /*'target/amigalib',*/ 'target/intuition', 'target/utility'
MODULE 'intuition/classes', 'intuition/classusr', 'utility/hooks', 'exec/types', 'target/utility/tagitem'
MODULE 'exec', 'dos/dos'

PROC new()
	utilitybase := OpenLibrary('utility.library', 39)
	IF utilitybase=NIL THEN CleanUp(RETURN_ERROR)
ENDPROC

PROC end()
	CloseLibrary(utilitybase)
ENDPROC

PROC callHookA( hookPtr:PTR TO hook, obj:PTR TO INTUIOBJECT, message:APTR ) IS NATIVE {IUtility->CallHookPkt(} hookPtr {, (APTR)} obj {,} message {)} ENDNATIVE !!ULONG

PROC coerceMethodA( cl:PTR TO iclass, obj:PTR TO INTUIOBJECT, message/*:PTR TO msg*/ ) IS NATIVE {IIntuition->ICoerceMethodA(} cl {,} obj {, (Msg)} message {)} ENDNATIVE !!ULONG

PROC setSuperAttrsA(cl:PTR TO iclass, obj:PTR TO INTUIOBJECT, msg:ARRAY OF tagitem) IS NATIVE {IIntuition->ISetSuperAttrsA(} cl {,} obj {,} msg {)} ENDNATIVE !!ULONG

PROC doSuperMethodA( cl:PTR TO iclass, obj:PTR TO INTUIOBJECT, message/*:PTR TO msg*/ ) IS NATIVE {IIntuition->IDoSuperMethodA(} cl {,} obj {, (Msg)} message {)} ENDNATIVE !!ULONG

PROC doMethodA( obj:PTR TO INTUIOBJECT, message/*:PTR TO msg*/ ) IS NATIVE {IIntuition->IDoMethodA(} obj {, (Msg)} message {)} ENDNATIVE !!ULONG
