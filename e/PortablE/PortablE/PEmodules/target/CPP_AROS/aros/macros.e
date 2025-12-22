/* $Id: macros.h 21499 2004-04-08 11:32:48Z falemagn $ */
OPT NATIVE
MODULE 'target/aros/system'
/*{#include <AROS/macros.h>}*/
NATIVE {AROS_MACROS_H} CONST

/* Reverse the bits in a byte */
NATIVE {AROS_SWAP_BITS_BYTE_GENERIC} CONST	->AROS_SWAP_BITS_BYTE_GENERIC(_b)

/* Reverse the bits in a word */
NATIVE {AROS_SWAP_BITS_WORD_GENERIC} CONST	->AROS_SWAP_BITS_WORD_GENERIC(_w)

/* Reverse the bits in a long */
NATIVE {AROS_SWAP_BITS_LONG_GENERIC} CONST	->AROS_SWAP_BITS_LONG_GENERIC(_l)

/* Reverse the bits in a quad */
NATIVE {AROS_SWAP_BITS_QUAD_GENERIC} CONST	->AROS_SWAP_BITS_QUAD_GENERIC(_q)

/* Reverse the bytes in a word */
NATIVE {AROS_SWAP_BYTES_WORD_GENERIC} CONST	->AROS_SWAP_BYTES_WORD_GENERIC(_w)

/* Reverse the bytes in a long */
NATIVE {AROS_SWAP_BYTES_LONG_GENERIC} CONST	->AROS_SWAP_BYTES_LONG_GENERIC(_l)

/* Reverse the bytes in a quad */
NATIVE {AROS_SWAP_BYTES_QUAD_GENERIC} CONST	->AROS_SWAP_BYTES_QUAD_GENERIC(_q)

/* Reverse the words in a long */
NATIVE {AROS_SWAP_WORDS_LONG_GENERIC} CONST	->AROS_SWAP_WORDS_LONG_GENERIC(_l)

/* Reverse the words in a quad */
NATIVE {AROS_SWAP_WORDS_QUAD_GENERIC} CONST	->AROS_SWAP_WORDS_QUAD_GENERIC(_q)

/* Reverse the longs in a quad */
NATIVE {AROS_SWAP_LONGS_QUAD_GENERIC} CONST	->AROS_SWAP_LONGS_QUAD_GENERIC(_q)

/* Use the CPU-specific definitions of the above macros, if they exist, but reuse
   the generic macros in case the given value is a compile-time constant, because
   the compiler will optimize things out for us.  */
   NATIVE {AROS_SWAP_BITS_BYTE} CONST	->AROS_SWAP_BITS_BYTE(b)

   NATIVE {AROS_SWAP_BITS_WORD} CONST	->AROS_SWAP_BITS_WORD(w)

   NATIVE {AROS_SWAP_BITS_LONG} CONST	->AROS_SWAP_BITS_LONG(l)

   NATIVE {AROS_SWAP_BITS_QUAD} CONST	->AROS_SWAP_BITS_QUAD(q)

/* Just for consistency... */
NATIVE {AROS_SWAP_BYTES_BYTE} CONST	->AROS_SWAP_BYTES_BYTE(b)  ((UBYTE)b)
NATIVE {AROS_SWAP_WORDS_WORD} CONST	->AROS_SWAP_WORDS_WORD(w)  ((ULONG)l)
NATIVE {AROS_SWAP_LONGS_LONG} CONST	->AROS_SWAP_LONGS_LONG(l)  ((UWORD)l)
NATIVE {AROS_SWAP_QUADS_QUAD} CONST	->AROS_SWAP_QUADS_QUAD(q) ((UQUAD)q)

   NATIVE {AROS_SWAP_BYTES_WORD} CONST	->AROS_SWAP_BYTES_WORD(w)

   NATIVE {AROS_SWAP_BYTES_LONG} CONST	->AROS_SWAP_BYTES_LONG(l)

   NATIVE {AROS_SWAP_BYTES_QUAD} CONST	->AROS_SWAP_BYTES_QUAD(q)

   NATIVE {AROS_SWAP_WORDS_LONG} CONST	->AROS_SWAP_WORDS_LONG(l)

   NATIVE {AROS_SWAP_WORDS_QUAD} CONST	->AROS_SWAP_WORDS_QUAD(q)

   NATIVE {AROS_SWAP_LONGS_QUAD} CONST	->AROS_SWAP_LONGS_QUAD(q)

    NATIVE {AROS_BE} CONST	->AROS_BE(type)
    NATIVE {AROS_LE} CONST	->AROS_LE(type)

/* Convert a word, long or quad to big endian and vice versa on the current hardware */
NATIVE {AROS_WORD2BE} CONST	->AROS_WORD2BE(w) AROS_BE(WORD)(w)
NATIVE {AROS_LONG2BE} CONST	->AROS_LONG2BE(l) AROS_BE(LONG)(l)
NATIVE {AROS_QUAD2BE} CONST	->AROS_QUAD2BE(q) AROS_BE(QUAD)(q)
NATIVE {AROS_BE2WORD} CONST	->AROS_BE2WORD(w) AROS_BE(WORD)(w)
NATIVE {AROS_BE2LONG} CONST	->AROS_BE2LONG(l) AROS_BE(LONG)(l)
NATIVE {AROS_BE2QUAD} CONST	->AROS_BE2QUAD(q) AROS_BE(QUAD)(q)

/* Convert a word, long or quad to little endian and vice versa on the current hardware */
NATIVE {AROS_WORD2LE} CONST	->AROS_WORD2LE(w) AROS_LE(WORD)(w)
NATIVE {AROS_LONG2LE} CONST	->AROS_LONG2LE(l) AROS_LE(LONG)(l)
NATIVE {AROS_QUAD2LE} CONST	->AROS_QUAD2LE(q) AROS_LE(QUAD)(q)
NATIVE {AROS_LE2WORD} CONST	->AROS_LE2WORD(w) AROS_LE(WORD)(w)
NATIVE {AROS_LE2LONG} CONST	->AROS_LE2LONG(l) AROS_LE(LONG)(l)
NATIVE {AROS_LE2QUAD} CONST	->AROS_LE2QUAD(q) AROS_LE(QUAD)(q)

/* Return the least set bit, ie. 0xFF00 will return 0x0100 */
   NATIVE {AROS_LEAST_BIT} CONST	->AROS_LEAST_BIT(l)    ((l) & -(l))

/* Check if an int is a power of two */
   NATIVE {AROS_IS_POWER_OF_2} CONST	->AROS_IS_POWER_OF_2(l)    (((l) & -(l)) == (l))

/* Round down <x> to a multiple of <r>. <r> must be a power of two */
   NATIVE {AROS_ROUNDDOWN2} CONST	->AROS_ROUNDDOWN2(x,r) ((x) & ~((r) - 1))

/* Round up <x> to a multiple of <r>. <r> must be a power of two */
   NATIVE {AROS_ROUNDUP2} CONST	->AROS_ROUNDUP2(x,r) (((x) + ((r) - 1)) &  ~((r) - 1))

/* Return the number of the least set bit, ie. 0xFF00 will return 8 */
   NATIVE {AROS_LEAST_BIT_POS} CONST	->AROS_LEAST_BIT_POS(l)

/* Swap two integer variables */
   NATIVE {AROS_SWAP} CONST	->AROS_SWAP(x,y)       (x) ^= (y) ^= (x) ^= (y)

/* Build an 'ID' as used by iffparse.library and some other libraries as well. */
NATIVE {AROS_MAKE_ID} CONST	->AROS_MAKE_ID(a,b,c,d) (((ULONG) (a)<<24) | ((ULONG) (b)<<16) | ((ULONG) (c)<<8)  | ((ULONG) (d)))
