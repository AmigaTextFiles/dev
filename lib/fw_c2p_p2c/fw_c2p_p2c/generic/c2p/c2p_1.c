/*
**  Chunky 2 Planar routine (C) 2009 Fredrik Wikstrom
**/

static void c2p_1 (const uint8_t *chunky, uint16_t *planar, uint32_t plane_size,
	uint32_t width, uint32_t height)
{
	const uint32_t *cp;
	uint16_t *pp1;
	uint32_t cd1, cd2, cd3, cd4;
	uint16_t pd1;
	uint32_t x, y;
	cp = (const uint32_t *)chunky;
	pp1 = planar;
	for (y = 0; y < height; y++) {
		for (x = 0; x < width; x++) {
			cd1 = *cp++;
			cd2 = *cp++;
			cd3 = *cp++;
			cd4 = *cp++;
			
#ifdef WORDS_BIGENDIAN
			pd1  = ((cd1 >> 9 ) & 0x8000)|((cd2 >> 13) & 0x800)|((cd3 >> 17) & 0x80)|((cd4 >> 21) & 0x8);
			
			pd1 |= ((cd1 >> 2 ) & 0x4000)|((cd2 >> 6 ) & 0x400)|((cd3 >> 10) & 0x40)|((cd4 >> 14) & 0x4);
			
			pd1 |= ((cd1 << 5 ) & 0x2000)|((cd2 << 1 ) & 0x200)|((cd3 >> 3 ) & 0x20)|((cd4 >> 7 ) & 0x2);
			
			pd1 |= ((cd1 << 12) & 0x1000)|((cd2 << 8 ) & 0x100)|((cd3 << 4 ) & 0x10)|((cd4      ) & 0x1);
#else
			pd1  = ((cd1 << 7 ) & 0x80)|((cd2 << 3 ) & 0x8)|((cd3 << 15) & 0x8000)|((cd4 << 11) & 0x800);
			
			pd1 |= ((cd1 >> 2 ) & 0x40)|((cd2 >> 6 ) & 0x4)|((cd3 << 6 ) & 0x4000)|((cd4 << 2 ) & 0x400);
			
			pd1 |= ((cd1 >> 11) & 0x20)|((cd2 >> 15) & 0x2)|((cd3 >> 3 ) & 0x2000)|((cd4 >> 7 ) & 0x200);
			
			pd1 |= ((cd1 >> 20) & 0x10)|((cd2 >> 24) & 0x1)|((cd3 >> 12) & 0x1000)|((cd4 >> 16) & 0x100);
#endif
			
			*pp1++ = pd1;
		}
	}
}
