/***************************************************************************
 *   Copyright (C) 2005 by Konstantinos Margaritis                         *
 *   markos@debian.gr                                                      *
 *                                                                         *
 *   This code is distributed under the LGPL license                       *
 *   See http://www.gnu.org/copyleft/lesser.html                           *
 ***************************************************************************/

#include "libfreevec.h"

#define MYSTRCPY_UNTIL_DEST_WORD_ALIGNED(dstpp, dst, src)   \
    while (((uint32_t)(dst) % sizeof(uint32_t))) {          \
        if ((*dst++ = *src++) == '\0') return dstpp;        \
    }

#define MYSTRCPY_SRC_TO_SRC_ALIGNED(src, srct, srcoffset)       \
    switch (srcoffset) {                                        \
        case 0:                                                 \
            srct = *srcl;                                       \
            break;                                              \
        case 3:                                                 \
            srct = (*(srcl) << 24) | (*(srcl+1) >> 8);          \
            break;                                              \
        case 2:                                                 \
            srct = (*(srcl) << 16) | (*(srcl+1) >> 16);         \
            break;                                              \
        case 1:                                                 \
            srct = (*(srcl) << 8) | (*(srcl+1) >> 24);          \
            break;                                              \
    }                                                           \

#define MYSTRCPY_SINGLE_WORD(dstpp, dst, dstl, src, srcl, srct, srcoffset)      \
    {                                                                           \
        if (( *srcl - lomagic) & himagic) {                                     \
            src = (uint8_t *) srcl +srcoffset;                                  \
            dst = (uint8_t *) dstl;                                             \
            if ((*dst++ = *src++) == '\0' ) { VEC_DSS(); return dstpp; }        \
            if ((*dst++ = *src++) == '\0' ) { VEC_DSS(); return dstpp; }        \
            if ((*dst++ = *src++) == '\0' ) { VEC_DSS(); return dstpp; }        \
            if ((*dst++ = *src++) == '\0' ) { VEC_DSS(); return dstpp; }        \
        }                                                                       \
    }                                                                           \
    *dstl++ = srct;                                                             \
    srcl++;

#define MYSTRCPY_QUADWORD(dstpp, dst, dstl, src, srcl, srcoffset)                   \
    int i;                                                                          \
    for (i=0; i < 4; i++) {                                                         \
        uint32_t srct = 0;                                                          \
        MYSTRCPY_SRC_TO_SRC_ALIGNED(src, srct, srcoffset);                          \
        MYSTRCPY_SINGLE_WORD(dstpp, dst, dstl, src, srcl, srct, srcoffset);         \
    }
    
#define MYSTRCPY_UNTIL_DEST_IS_ALTIVEC_ALIGNED(dstpp, dst, dstl, src, srcl, srcoffset)      \
    while (((uint32_t)(dstl) % ALTIVECWORD_SIZE)) {                                         \
        uint32_t srct = 0;                                                                  \
        MYSTRCPY_SRC_TO_SRC_ALIGNED(src, srct, srcoffset);                                  \
        MYSTRCPY_SINGLE_WORD(dstpp, dst, dstl, src, srcl, srct, srcoffset);                 \
    }

#define MYSTRCPY_SINGLE_ALTIVEC_WORD_ALIGNED(dstpp, dst, dstl, src, srcl, srcoffset, v0)    \
    {                                                                                       \
        vector uint8_t vsrc = (vector uint8_t) vec_ld(0, (uint8_t *)src);                   \
        if (vec_any_eq(vsrc, v0)) {                                                         \
            srcl = (uint32_t *)(src -srcoffset4);                                           \
            MYSTRCPY_QUADWORD(dstpp, dst, dstl, src, srcl, srcoffset);                      \
        }                                                                                   \
        vec_st(vsrc, 0, (uint8_t *)dstl);                                                   \
    }

#define MYSTRCPY_SINGLE_ALTIVEC_WORD_UNALIGNED(dstpp, dst, dstl, src, srcl, srcoffset, v0)  \
    {                                                                                       \
        vector uint8_t vsrc, MSQ, LSQ, vmask;                                               \
        vmask = vec_lvsl(0, src);                                                           \
        MSQ = vec_ld(0, src);                                                               \
        LSQ = vec_ld(15, src);                                                              \
        vsrc = vec_perm(MSQ, LSQ, vmask);                                                   \
        if (vec_any_eq(vsrc, v0)) {                                                         \
            srcl = (uint32_t *)(src -srcoffset4);                                           \
            MYSTRCPY_QUADWORD(dstpp, dst, dstl, src, srcl, srcoffset);                      \
        }                                                                                   \
        vec_st(vsrc, 0, (uint8_t *)dstl);                                                   \
    }

#define MYSTRCPY_LOOP_SINGLE_ALTIVEC_WORD_ALIGNED(dstpp, dst, dstl, src, srcl, srcoffset, v0)   \
    while (1) {                                                                                 \
        MYSTRCPY_SINGLE_ALTIVEC_WORD_ALIGNED(dstpp, dst, dstl, src, srcl, srcoffset, v0);       \
        dstl += 4; src += ALTIVECWORD_SIZE;                                                     \
        vec_dst(src, DST_CTRL(2,2,16), DST_CHAN_SRC);                                           \
        vec_dstst(dst, DST_CTRL(2,2,16), DST_CHAN_DEST);                                        \
    }

#define MYSTRCPY_LOOP_SINGLE_ALTIVEC_WORD_UNALIGNED(dstpp, dst, dstl, src, srcl, srcoffset, v0) \
    while (1) {                                                                                 \
        MYSTRCPY_SINGLE_ALTIVEC_WORD_UNALIGNED(dstpp, dst, dstl, src, srcl, srcoffset, v0);     \
        dstl += 4; src += ALTIVECWORD_SIZE;                                                     \
        vec_dst(src, DST_CTRL(2,2,16), DST_CHAN_SRC);                                           \
        vec_dstst(dst, DST_CTRL(2,2,16), DST_CHAN_DEST);                                        \
    }
    
