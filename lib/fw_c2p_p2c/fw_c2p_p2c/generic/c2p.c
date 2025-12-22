/*
**  Chunky 2 Planar routine (C) 2009 Fredrik Wikstrom
**/

#include "c2p.h"

#if (defined(__PPC__) || defined(__M68K__)) && !defined(WORDS_BIGENDIAN)
#define WORDS_BIGENDIAN 1
#endif

#include "c2p/c2p_1.c"
#include "c2p/c2p_2.c"
#include "c2p/c2p_3.c"
#include "c2p/c2p_4.c"
#include "c2p/c2p_5.c"
#include "c2p/c2p_6.c"
#include "c2p/c2p_7.c"
#include "c2p/c2p_8.c"

typedef void (*c2p_func_ptr)(const uint8_t *chunky, uint16_t *planar, uint32_t plane_size,
	uint32_t width, uint32_t height);

static const c2p_func_ptr c2p_funcs[] = {
	c2p_1, c2p_2, c2p_3, c2p_4, c2p_5, c2p_6, c2p_7, c2p_8
};

void chunky2planar (const uint8_t *chunky, uint16_t *planar, uint32_t plane_size,
	uint32_t width, uint32_t height, uint32_t depth)
{
	c2p_funcs[depth-1](chunky, planar, plane_size, width >> 4, height);
}
