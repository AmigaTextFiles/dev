/*
**  Chunky 2 Planar routine (C) 2009 Fredrik Wikstrom
**/

#ifndef C2P_H
#define C2P_H

#include <stdint.h>

void chunky2planar (const uint8_t *chunky, uint16_t *planar, uint32_t plane_size,
	uint32_t width, uint32_t height, uint32_t depth);

#endif
