/***************************************************************************
 *   Copyright (C) 2005 by Konstantinos Margaritis                         *
 *   markos@debian.gr                                                      *
 *                                                                         *
 *   This code is distributed under the LGPL license                       *
 *   See http://www.gnu.org/copyleft/lesser.html                           *
 ***************************************************************************/

#include "libfreevec.h"

/* These macros are used in memchr()-type of functions
   DO NOT CHANGE/EDIT THESE MACROS!!!
*/

#define MYMEMCHR_UNTIL_WORD_ALIGNED(ptr, c, len)                \
    while (((uint32_t)(ptr) & (sizeof(uint32_t)-1)) && len--) { \
        if (*++ptr == c) return ptr;                            \
    }

#define MYMEMCHR_SINGLE_WORD(ptr32, c, mask, lw)            \
    lw = *ptr32 ^ mask;                                 \
    if ((( lw + magic_bits32) ^ ~lw) & magic_bits32) {  \
        uint8_t *cptr = (uint8_t *) ptr32;              \
        if (cptr[0] == c ) return &cptr[0];             \
        if (cptr[1] == c ) return &cptr[1];             \
        if (cptr[2] == c ) return &cptr[2];             \
        if (cptr[3] == c ) return &cptr[3];             \
    }                                                   \
    ptr32++;

#define MYMEMCHR_LOOP_WORD(ptr32, c, mask, len)         \
    while (len >= sizeof(uint32_t)) {                   \
        uint32_t lw;                                    \
        MYMEMCHR_SINGLE_WORD(ptr32, c, mask, lw);       \
        len -= sizeof(uint32_t);                        \
    }

#define MYMEMCHR_LOOP_UNTIL_ALTIVEC_ALIGNED(ptr32, c, mask, len)    \
    while ((uint32_t)(ptr32) % ALTIVECWORD_SIZE) {                  \
        uint32_t lw;                                                \
        MYMEMCHR_SINGLE_WORD(ptr32, c, mask, lw);                   \
        len -= sizeof(uint32_t);                                    \
    }

#define MYMEMCHR_SINGLE_ALTIVEC_WORD(vec, vmask, ptr32, c, mask)    \
    vec = vec_ld(0, (uint8_t *)ptr32);                          \
    if (vec_any_eq(vec, vmask)) {                               \
        MYMEMCHR_SINGLE_WORD(ptr32, c, charmask, lw);           \
        MYMEMCHR_SINGLE_WORD(ptr32, c, charmask, lw);           \
        MYMEMCHR_SINGLE_WORD(ptr32, c, charmask, lw);           \
        MYMEMCHR_SINGLE_WORD(ptr32, c, charmask, lw);           \
    }                                                           \
    ptr32 += 4;                                                 \
    len -= 16;
        
#define MYMEMCHR_REST_BYTES(ptr, c, len)    \
    switch (len) {                                  \
        case 3:                                     \
            if (*ptr++ == c) return ptr;            \
            if (*ptr++ == c) return ptr;            \
            if (*ptr == c) return ptr;              \
            break;                                  \
        case 2:                                     \
            if (*ptr++ == c) return ptr;            \
            if (*ptr == c) return ptr;              \
            break;                                  \
        case 1:                                     \
            if (*ptr == c) return ptr;              \
            break;                                  \
    }
    
#define MYMEMRCHR_BACKWARDS_UNTIL_WORD_ALIGNED1(ptr, c, len)     \
    while (((uint32_t)(ptr) % (sizeof(uint32_t))) && len) {     \
        if (*--ptr == c) return ptr;                            \
        len--;                                                  \
    }

#define MYMEMRCHR_BACKWARDS_UNTIL_WORD_ALIGNED(ptr, c, len) \
    while (((uint32_t)(ptr) % sizeof(uint32_t)) && len) {   \
        ptr--;                                              \
        if (*ptr == c) return ptr;                          \
        len--;                                              \
    }

#define MYMEMRCHR_BACKWARDS_SINGLE_WORD(ptr32, c, mask, lw) \
    ptr32--;                                                \
    lw = *ptr32 ^ mask;                                     \
    if ((( lw + magic_bits32) ^ ~lw) & magic_bits32) {      \
        uint8_t *cptr = (uint8_t *) ptr32;                  \
        if (cptr[3] == c ) return &cptr[3];                 \
        if (cptr[2] == c ) return &cptr[2];                 \
        if (cptr[1] == c ) return &cptr[1];                 \
        if (cptr[0] == c ) return &cptr[0];                 \
    }        

#define MYMEMRCHR_BACKWARDS_LOOP_WORD(ptr32, c, mask, len)      \
    while (len >= sizeof(uint32_t)) {                           \
        MYMEMRCHR_BACKWARDS_SINGLE_WORD(ptr32, c, mask, lw);    \
        len -= sizeof(uint32_t);                                \
    }

#define MYMEMRCHR_SINGLE_BACKWARDS_ALTIVEC_WORD(vec, vmask, ptr32, c, mask) \
    v1 = vec_ld(0, (uint8_t *)(ptr32) -16 );                                \
    if (vec_any_eq(vec, vmask)) {                                           \
        MYMEMRCHR_BACKWARDS_SINGLE_WORD(ptr32, c, charmask, lw);            \
        MYMEMRCHR_BACKWARDS_SINGLE_WORD(ptr32, c, charmask, lw);            \
        MYMEMRCHR_BACKWARDS_SINGLE_WORD(ptr32, c, charmask, lw);            \
        MYMEMRCHR_BACKWARDS_SINGLE_WORD(ptr32, c, charmask, lw);            \
    }                                                                       \
    ptr32 -= 4;                                                             \
    len -= 16;

#define MYMEMRCHR_BACKWARDS_LOOP_UNTIL_ALTIVEC_ALIGNED(ptr32, c, mask, len) \
    ptr32--;                                                                \
    while ((uint32_t)(ptr32) % ALTIVECWORD_SIZE) {                          \
        uint32_t lw;                                                        \
        MYMEMRCHR_BACKWARDS_SINGLE_WORD(ptr32, c, mask, lw);                \
        len -= sizeof(uint32_t);                                            \
    }
        
#define MYMEMRCHR_BACKWARDS_REST_BYTES(ptr, c, len) \
    switch (len) {                                  \
        case 3:                                     \
            if (*ptr-- == c) return ptr;            \
            if (*ptr-- == c) return ptr;            \
            if (*ptr == c) return ptr;              \
            break;                                  \
        case 2:                                     \
            if (*ptr-- == c) return ptr;            \
            if (*ptr == c) return ptr;              \
            break;                                  \
        case 1:                                     \
            if (*ptr == c) return ptr;              \
            break;                                  \
    }
