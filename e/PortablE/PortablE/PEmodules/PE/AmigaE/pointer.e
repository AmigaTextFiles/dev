/* PortablE target module for OPT POINTER */
OPT NATIVE, INLINE, POINTER
MODULE 'target/PE/base'

PROC NewArray(a, b:INT) IS NATIVE {New(} a*b {)} ENDNATIVE !!ARRAY

PROC DisposeArray(a:ARRAY) IS NATIVE {Dispose(} a {)} ENDNATIVE BUT NILA

PROC ArrayCopy(target:ARRAY, source:ARRAY, sizeInItems, sizeOfItem:INT, targetOffsetInItems=0, sourceOffsetInItems=0) IS MemCopy(target + (targetOffsetInItems * sizeOfItem), source!!PTR + (sourceOffsetInItems * sizeOfItem), sizeInItems * sizeOfItem)
