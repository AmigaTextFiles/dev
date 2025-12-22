/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 1998  Niels Froehling <Niels.Froehling@Informatik.Uni-Oldenburg.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#ifndef	TABLES_H
#define	TABLES_H

#define	MAX_ANGLE	360

extern vec1D sinTable[MAX_ANGLE + 1], cosTable[MAX_ANGLE + 1];

#define	MAX_MULTX	512
#define	MAX_LOGX	9
#define	MAX_MASKX	0x0001FF00
#define	MAX_MULTY	256
#define	MAX_LOGY	8
#define	MAX_MASKY	0x000000FF

extern int multTMap[MAX_MULTX][MAX_MULTY];
extern int *multMuls;
extern int *multRows;
extern unsigned char *cachedTransparency;

#define	lookup(x, y)	multTMap[y][x]

void InitSinCosTables(void);
void InitMultTables(int width, int height);

#define	DENSITY_WATER		50
#define	DENSITY_SLIME		75
#define	DENSITY_LAVA		90
#define	DENSITY_TELEPORT	100
extern unsigned char *waterTransparency;			/* 50 */
extern unsigned char *slimeTransparency;			/* 75 */
extern unsigned char *lavaTransparency;				/* 90 */
extern unsigned char *teleTransparency;				/* 100 */
extern unsigned char *preTransparency;				/*  */

#define	watertransp(x, y)	(waterTransparency[(((int)(y)) << 8) + ((int)(x))])
#define	slimetransp(x, y)	(slimeTransparency[(((int)(y)) << 8) + ((int)(x))])
#define	lavatransp(x, y)	(lavaTransparency[(((int)(y)) << 8) + ((int)(x))])
#define	teletransp(x, y)	(teleTransparency[(((int)(y)) << 8) + ((int)(x))])
#define	pretransp(x, y)		(preTransparency[(((int)(y)) << 8) + ((int)(x))])

extern int skyMovementX1, skyMovementY1;
extern int skyMovementX2, skyMovementY2;

#ifndef	FAST_WARP
extern int swim_u[256], swim_v[256], swim_phase;
#else
extern int *swim_u, *swim_v, swim_phase;
extern int swim_u0[WARP_X >> MIPMAP_0], swim_v0[WARP_X >> MIPMAP_0];
extern int swim_u1[WARP_X >> MIPMAP_1], swim_v1[WARP_X >> MIPMAP_1];
extern int swim_u2[WARP_X >> MIPMAP_2], swim_v2[WARP_X >> MIPMAP_2];
extern int swim_u3[WARP_X >> MIPMAP_3], swim_v3[WARP_X >> MIPMAP_3];
extern int *swim_um[MIPMAP_MAX];
extern int *swim_vm[MIPMAP_MAX];
#endif

void updateTimings(void);

#endif
