OPT NATIVE
PUBLIC MODULE 'target/x86_64-linux-gnu/bits/endian'		->guessed 
->{#include <x86_64-linux-gnu/bits/endianness.h>}
NATIVE {_BITS_ENDIANNESS_H} CONST ->_BITS_ENDIANNESS_H = 1

/* i386/x86_64 are little-endian.  */
NATIVE {__BYTE_ORDER} CONST BYTE_ORDER__ = LITTLE_ENDIAN__
