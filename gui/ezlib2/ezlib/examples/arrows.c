#if LATTICE
USHORT chip ImageData1[] = {
#else
USHORT ImageData1[] = {
#endif
	0xFFFF,0xFE7F,0xF81F,0xE007,0x8001,0xF81F,0xF81F,0xF81F,
	0xFFFF,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,
	0x0000,0x0000
};

struct Image arrow1 = {
	0,0,	/* XY origin relative to container TopLeft */
	16,9,	/* Image width and height in pixels */
	2,	/* number of bitplanes in Image */
	ImageData1,	/* pointer to ImageData */
	0x0003,0x0000,	/* PlanePick and PlaneOnOff */
	NULL	/* next Image structure */
};

#if LATTICE
USHORT chip ImageData2[] = {
#else
USHORT ImageData2[] = {
#endif
	0xFFFF,0xF81F,0xF81F,0xF81F,0x8001,0xE007,0xF81F,0xFE7F,
	0xFFFF,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,
	0x0000,0x0000
};

struct Image arrow2 = {
	0,0,	/* XY origin relative to container TopLeft */
	16,9,	/* Image width and height in pixels */
	2,	/* number of bitplanes in Image */
	ImageData2,	/* pointer to ImageData */
	0x0003,0x0000,	/* PlanePick and PlaneOnOff */
	NULL	/* next Image structure */
};


