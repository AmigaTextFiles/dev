->wrapper
MODULE 'amigalib/boopsi', 'exec/types', 'intuition/classusr'

/* example call: domethod(myobj,[METHODID,...]) */

PROC domethod( obj:PTR TO INTUIOBJECT, message/*:PTR TO msg*/ ) RETURNS result:ULONG IS doMethodA(obj, message)
