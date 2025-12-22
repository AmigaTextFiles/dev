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

#define	LIBQDISPLAY_CORE
#include "../include/libqdisplay.h"

vec1D sinTable[MAX_ANGLE + 1], cosTable[MAX_ANGLE + 1];

/* pre-calculated sin/cos-tables */
void InitSinCosTables(void)
{
  short int countFlow;
  double piFlow;
  vec1D *sinFlow = &sinTable[MAX_ANGLE] + 1;
  vec1D *cosFlow = &cosTable[MAX_ANGLE] + 1;

  for (countFlow = MAX_ANGLE, piFlow = MAX_ANGLE * M_PI / 180; countFlow >= 0; countFlow--, piFlow -= M_PI / 180) {
    *--sinFlow = sin(piFlow);
    *--cosFlow = cos(piFlow);
  }
}

/* pre-calculated multiplication-tables */
int multTMap[MAX_MULTX][MAX_MULTY];
bool multDone = FALSE;
int *multMuls = &multTMap[0][0];
int *multRows = 0;

void InitMultTables(int width, int height)
{
  int *lmulTables;
  short int i, j;
  int maxX;

  if (!multDone) {
    lmulTables = &multTMap[MAX_MULTX - 1][MAX_MULTY - 1] + 1;
    maxX = (MAX_MULTX - 1) * (MAX_MULTY - 1);

    for (i = MAX_MULTX - 1; i >= 0; i--) {
      int maxY = maxX;

      for (j = MAX_MULTY - 1; j >= 0; j--) {
	*--lmulTables = maxY;
	maxY -= (int)i;
      }
      maxX -= MAX_MULTY - 1;
    }
    multDone = TRUE;
  }

  if ((multRows = (int *)trealloc(sizeof(int) * (height + 1)))) {
    lmulTables = multRows + height + 1;

    for (i = height, maxX = width * height * localDim.frameBPP; i >= 0; i--, maxX -= width * localDim.frameBPP)
      *--lmulTables = maxX;
  }
  else
    Error(failed_memoryunsize, "multiplication-tables");
}

#ifdef	DRIVER_8BIT
/* pre-calculated transparency-tables */
unsigned char *waterTransparency;				/* 50 */
unsigned char *slimeTransparency;				/* 75 */
unsigned char *lavaTransparency;				/* 90 */
unsigned char *teleTransparency;				/* 100 */
unsigned char *preTransparency;					/* do not calculate in the loop */
#endif

/*
 * Warping water.
 * 
 * tx = H_AMPL * sin(2.0 * PI * (y / V_PERIOD + t / T_PERIOD));
 * ty = V_AMPL * cos(2.0 * PI * (x / H_PERIOD + t / T_PERIOD));
 * 
 * - amplitudes: H_AMPL and V_AMPL,
 * - repetition periods: H_PERIOD and V_PERIOD,
 * - time repetition period: T_PERIOD.
 * 
 * - Ex: a period(spacing) of 128 and an amplitude of 8:
 * tx = 8.0 * sin(2.0 * PI * y / 128.0);
 * ty = 8.0 * cos(2.0 * PI * x / 128.0);
 */
int skyMovementX1 = 0, skyMovementY1 = 0;
int skyMovementX2 = 0, skyMovementY2 = 0;

#ifndef	FAST_WARP
int swim_u[256], swim_v[256], swim_phase;
#else
int *swim_u, *swim_v, swim_phase;
int swim_u0[WARP_X >> MIPMAP_0], swim_v0[WARP_X >> MIPMAP_0];
int swim_u1[WARP_X >> MIPMAP_1], swim_v1[WARP_X >> MIPMAP_1];
int swim_u2[WARP_X >> MIPMAP_2], swim_v2[WARP_X >> MIPMAP_2];
int swim_u3[WARP_X >> MIPMAP_3], swim_v3[WARP_X >> MIPMAP_3];
int *swim_um[MIPMAP_MAX] =
{swim_u0, swim_u1, swim_u2, swim_u3};
int *swim_vm[MIPMAP_MAX] =
{swim_v0, swim_v1, swim_v2, swim_v3};
#endif
void updateTimings(void)
{
  short int i;

  swim_phase++;
#ifndef	FAST_WARP
  for (i = 0; i < 256; ++i) {
    /*swim_u[i] = FLOAT_FIX(sin(((i >> 6) + (swim_phase >> 6)) * M_PI * 2.0) * 8.0); */
    /*swim_v[i] = FLOAT_FIX(cos(((i >> 6) + (swim_phase >> 6)) * M_PI * 2.0) * 8.0); */
    /*swim_u[i] = scalw(sin(((i + swim_phase) * .09817477)), 19); */
    /*swim_v[i] = scalw(cos(((i + swim_phase) * .09817477)), 19); */
    double val = (i + swim_phase) * .09817477;
    int val_u = scalw(sin(val), 19);				/* * 524288; */
    int val_v = scalw(cos(val), 19);				/* * 524288; */

    swim_u[i] = val_u;						/* mip0 */
    swim_v[i] = val_v;
  }
#else
  for (i = 0; i < WARP_X; ++i) {
    double val = (i + swim_phase) * .09817477;
    int val_u = scalw(sin(val), 19);				/* * 524288; */
    int val_v = scalw(cos(val), 19);				/* * 524288; */

    swim_u0[i] = val_u;						/* mip0 */
    swim_v0[i] = val_v;
    if (!(i & ((1 << MIPMAP_1) - 1))) {
      swim_u1[i >> MIPMAP_1] = val_u >> MIPMAP_1;		/* mip1 */
      swim_v1[i >> MIPMAP_1] = val_v >> MIPMAP_1;
      if (!(i & ((1 << MIPMAP_2) - 1))) {
	swim_u2[i >> MIPMAP_2] = val_u >> MIPMAP_2;		/* mip2 */
	swim_v2[i >> MIPMAP_2] = val_v >> MIPMAP_2;
	if (!(i & ((1 << MIPMAP_3) - 1))) {
	  swim_u3[i >> MIPMAP_3] = val_u >> MIPMAP_3;		/* mip3 */
	  swim_v3[i >> MIPMAP_3] = val_v >> MIPMAP_3;
	}
      }
    }
  }
#endif

  skyMovementX1 += 0x00000100;
  skyMovementY1 += 0x00000001;
  skyMovementX2 += 0x00000200;
  skyMovementY2 += 0x00000002;
}
