/* PortablE target module for OPT POINTER */
OPT NATIVE, INLINE, POINTER
MODULE 'target/PE/base'

PROC NewArray(sizeInItems, sizeOfItem:INT) IS NATIVE {calloc(} sizeInItems {,} sizeOfItem {)} ENDNATIVE !!ARRAY

PROC DisposeArray(array:ARRAY) IS NATIVE {free(} array {)} ENDNATIVE BUT NILA

PROC ArrayCopy(target:ARRAY, source:ARRAY, sizeInItems, sizeOfItem:INT, targetOffsetInItems=0, sourceOffsetInItems=0) IS MemCopy(target + (targetOffsetInItems * sizeOfItem), source!!PTR + (sourceOffsetInItems * sizeOfItem), sizeInItems * sizeOfItem)
