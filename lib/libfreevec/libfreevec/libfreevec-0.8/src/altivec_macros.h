/***************************************************************************
 *   Copyright (C) 2005 by Konstantinos Margaritis                         *
 *   markos@debian.gr                                                      *
 *                                                                         *
 *   This code is distributed under a BSD-type license                     *
 ***************************************************************************/

#ifdef HAVE_ALTIVEC_H
#include <altivec.h>

#include "libfreevec.h"
 
/* Macro to copy up to 3 bytes */
#define MYNIBBLE_COPY_FWD(dst, src, len) \
    switch (len) {                      \
        case 3:                         \
            *dst++ = *src++;            \
            *dst++ = *src++;            \
            *dst = *src;                \
            break;                      \
        case 2:                         \
            *dst++ = *src++;            \
            *dst = *src;                \
            break;                      \
        case 1:                         \
            *dst = *src;                \
            break;                      \
        case 0:                         \
            break;                      \
    }
    
/* Copy until destination is 32-bit aligned, 
   so again up to 3 bytes, but this time on condition
   */
#define MYCOPY_UNTIL_DEST_IS_WORD_ALIGNED(dst, src, len)    \
    switch (((uint32_t)dst) % sizeof(uint32_t)) {           \
        case 1:                                             \
            *dst++ = *src++;                                \
            *dst++ = *src++;                                \
            *dst++ = *src++;                                \
            len -= 3;                                       \
            break;                                          \
        case 2:                                             \
            *dst++ = *src++;                                \
            *dst++ = *src++;                                \
            len -= 2;                                       \
            break;                                          \
        case 3:                                             \
            *dst++ = *src++;                                \
            len--;                                          \
            break;                                          \
    }

/* Copy until destination is 128-bit aligned. We have to do that
   if we're to use Altivec to copy 128-bit at once. We do word
   copying for increased speed in this case.
   */
#define MYCOPY_UNTIL_DEST_IS_ALTIVEC_ALIGNED(dst, src, len, srcofst) \
    while (((uint32_t)(dst) & 15) && len >= sizeof(uint32_t)) {     \
        switch (srcofst) {                                          \
            case 0:                                                 \
                *dst++ = *src++;                                    \
                break;                                              \
            case 3:                                                 \
                *dst++ = (*(src) << 24) | (*(src+1) >> 8);          \
                src++;                                              \
                break;                                              \
            case 2:                                                 \
                *dst++ = (*(src) << 16) | (*(src+1) >> 16);         \
                src++;                                              \
                break;                                              \
            case 1:                                                 \
                *dst++ = (*(src) << 8) | (*(src+1) >> 24);          \
                src++;                                              \
                break;                                              \
        }                                                           \
        len -= sizeof(uint32_t);                                    \
    }

/* Copy just a single aligned 16-byte chunk. Both src and dst 
   are aligned.
   */
#define MYCOPY_SINGLEQUADWORD_ALTIVEC_ALIGNED(dst, src, step)       \
    vec_st((vector uint8_t) vec_ld(step, (uint8_t *)src),           \
                step, (uint8_t *)dst);

/* Copy just a single unaligned 16-byte chunk. Note: dst is aligned
   while src is known NOT to be aligned. I.e. no check is done.
   */
#define MYCOPY_SINGLEQUADWORD_ALTIVEC_UNALIGNED(dst, src, step)     \
    mask = vec_lvsl(0, src);                                        \
    MSQ = vec_ld(step, src);                                        \
    LSQ = vec_ld(step+15, src);                                     \
    vec_st(vec_perm(MSQ, LSQ, mask), step, (uint8_t *)dst);

/* Copy N 64-byte chunks. Again, both dst and src are aligned. The copy
   does 4 16-byte chunks each iteration for increased speed.
   */
#define MYCOPY_LOOP_QUADWORD_ALTIVEC_ALIGNED(dst, src, blocks)                      \
    len -= blocks << 6;                                                             \
    while (blocks--) {                                                              \
        vec_st((vector uint8_t) vec_ld(0, (uint8_t *)src), 0, (uint8_t *)dst);      \
        vec_st((vector uint8_t) vec_ld(16, (uint8_t *)src), 16, (uint8_t *)dst);    \
        vec_st((vector uint8_t) vec_ld(32, (uint8_t *)src), 32, (uint8_t *)dst);    \
        vec_st((vector uint8_t) vec_ld(48, (uint8_t *)src), 48, (uint8_t *)dst);    \
        dst += 16; src += 64;                                                       \
        vec_dst(src, DST_CTRL(2,2,16), DST_CHAN_SRC);                               \
        vec_dstst(dst, DST_CTRL(2,2,16), DST_CHAN_DEST);                            \
    }

/* Copy N 64-byte chunks. Again, dst is aligned while src is known 
   NOT to be aligned. I.e. no check is done. The copy
   does 4 16-byte chunks each iteration for increased speed.
   */
#define MYCOPY_LOOP_QUADWORD_ALTIVEC_UNALIGNED(dst, src, blocks)        \
    vector uint8_t mask, MSQ1, LSQ1, LSQ2, LSQ3, LSQ4;                  \
    mask = vec_lvsl(0, src);                                            \
    len -= blocks << 6;                                                 \
    while (blocks--) {                                                  \
        MSQ1 = vec_ld(0, src);                                          \
        LSQ1 = vec_ld(15, src);                                         \
        LSQ2 = vec_ld(31, src);                                         \
        LSQ3 = vec_ld(47, src);                                         \
        LSQ4 = vec_ld(63, src);                                         \
        vec_st(vec_perm(MSQ1, LSQ1, mask), 0, (uint8_t *)dst);          \
        vec_st(vec_perm(LSQ1, LSQ2, mask), 16, (uint8_t *)dst);         \
        vec_st(vec_perm(LSQ2, LSQ3, mask), 32, (uint8_t *)dst);         \
        vec_st(vec_perm(LSQ3, LSQ4, mask), 48, (uint8_t *)dst);         \
        dst += 16; src += 64;                                           \
        vec_dst(src, DST_CTRL(2,2,16), DST_CHAN_SRC);                   \
        vec_dstst(dst, DST_CTRL(2,2,16), DST_CHAN_DEST);                \
    }

/* Assume dst is aligned, and copy until len becomes smaller than
   4 bytes. Handle src alignment explicitly.
   */
#define MYCOPY_REST_WORDS(dst, src, len, srcofst)               \
    while (len >= sizeof(uint32_t)) {                           \
        switch (srcofst) {                                      \
            case 0:                                             \
                *dst++ = *src++;                                \
                break;                                          \
            case 3:                                             \
                *dst++ = (*(src) << 24) | (*(src+1) >> 8);      \
                src++;                                          \
                break;                                          \
            case 2:                                             \
                *dst++ = (*(src) << 16) | (*(src+1) >> 16);     \
                src++;                                          \
                break;                                          \
            case 1:                                             \
                *dst++ = (*(src) << 8) | (*(src+1) >> 24);      \
                src++;                                          \
                break;                                          \
        }                                                       \
        len -= sizeof(uint32_t);                                \
    }
    
#define MYSET_NIBBLE(ptr, p, lenvar, len)           \
    switch (len) {                                  \
        case 3:                                     \
            *ptr++ = p; *ptr++ = p; *ptr++ = p;     \
            lenvar -= len;                          \
            break;                                  \
        case 2:                                     \
            *ptr++ = p; *ptr++ = p;                 \
            lenvar -= len;                          \
            break;                                  \
        case 1:                                     \
            *ptr++ = p;                             \
            lenvar--;                               \
            break;                                  \
    }

#define MYSET_WORDS(ptr, p, lenvar, loops)          \
    uint32_t p32 = (p << 8) | p;                    \
    p32 |= p32 << 16;                               \
    lenvar -= loops << 2;                           \
    uint32_t *ptr32 = (uint32_t *)(ptr);            \
    while (loops--)                                 \
        *ptr32++ = p32;                             \
    ptr =  (uint8_t *)ptr32;

#define MYFILL_VECTOR(vecname, p)                   \
    union {                                         \
        vector uint8_t v;                           \
        uint8_t c[16];                              \
    } p_env;                                        \
    p_env.c[0] = p;                                 \
    vector uint8_t vecname = vec_splat(p_env.v, 0);
    
#define MYSET_ALTIVECWORD(ptr, p, len)              \
    vec_st(p128, 0, ptr);                           \
    ptr += 16; len -= 16;

#define MYSET_LOOP_ALTIVECWORD(ptr, p, len, loops)          \
    while (loops--) {                                       \
        vec_st(p128, 0, ptr);                               \
        vec_st(p128, 16, ptr);                              \
        ptr += 32; len -= 32;                               \
    } 
    
#endif
