/***************************************************************************
 *   Copyright (C) 2005 by Konstantinos Margaritis                         *
 *   markos@debian.gr                                                      *
 *                                                                         *
 *   This code is distributed under the LGPL license                       *
 *   See http://www.gnu.org/copyleft/lesser.html                           *
 ***************************************************************************/
 
#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#include <sys/types.h>
#include <stdint.h>
#include <stdio.h>

#ifdef HAVE_ALTIVEC_H 
#include <altivec.h>

#include "libfreevec.h"
#include "macros/memcpy.h"

void bmove512(void *to, const void *from, uint32_t len) {
    
    // dst and src are assumed to be 32-bit aligned and length to be a multiple of 512.
    // Now dst is word aligned but we want to align it to 16-byte boundaries as well.
    const uint8_t *src = from;
    uint8_t *dst = to;
    
    // Prefetch some stuff
    vec_dst(src, DST_CTRL(2,1,16), DST_CHAN_SRC);
    vec_dstst(dst, DST_CTRL(2,1,16), DST_CHAN_DEST);

    // both dst and src are word aligned. We'll continue by word copying, but 
    // for this we have to know the word-alignment of src also.

    // Take the word-aligned long pointers of src and dest.
    uint32_t *dstl = (uint32_t *)(dst);
    const uint32_t *srcl = (uint32_t *)(src);

    // While we're not 16-byte aligned, move in 4-byte long steps.
    MYCOPY_FWD_UNTIL_DEST_IS_ALTIVEC_ALIGNED(dstl, srcl, len, 0);
    
    // Now, dst is 16byte aligned. We will use Altivec for the rest.
    src = (uint8_t *) srcl;

    int blocks = 7;
    if (((uint32_t)(src) & 15) == 0) {
        MYCOPY_FWD_LOOP_QUADWORD_ALTIVEC_ALIGNED(dstl, src, blocks);
    } else {
        MYCOPY_FWD_LOOP_QUADWORD_ALTIVEC_UNALIGNED(dstl, src, blocks);
    }
    
    if (len >= 2*ALTIVECWORD_SIZE) {
        if (((uint32_t)(src) & 15) == 0) {
            MYCOPY_SINGLEQUADWORD_ALTIVEC_ALIGNED(dstl, src, 0);
            MYCOPY_SINGLEQUADWORD_ALTIVEC_ALIGNED(dstl, src, 16);
            dstl += 8; src += 32; len -= 32;
        } else {
            vector uint8_t MSQ, LSQ, mask;
            MYCOPY_SINGLEQUADWORD_ALTIVEC_UNALIGNED(dstl, src, 0);
            MYCOPY_SINGLEQUADWORD_ALTIVEC_UNALIGNED(dstl, src, 16);
            dstl += 8; src += 32; len -= 32;
        }
    }
    if (len >= ALTIVECWORD_SIZE) {
        if (((uint32_t)(src) & 15) == 0) {
            MYCOPY_SINGLEQUADWORD_ALTIVEC_ALIGNED(dstl, src, 0);
            dstl += 4; src += 16; len -= 16;
        } else {
            vector uint8_t MSQ, LSQ, mask;
            MYCOPY_SINGLEQUADWORD_ALTIVEC_UNALIGNED(dstl, src, 0);
            dstl += 4; src += 16; len -= 16;
        }
    }
    srcl = (uint32_t *)(src);
    // Copy the remaining bytes using word-copying
    // Handle alignment as appropriate
    MYCOPY_FWD_REST_WORDS(dstl, srcl, len, 0);
    
    vec_dss(DST_CHAN_SRC);
    vec_dss(DST_CHAN_DEST);
    
    return;
}
#endif
