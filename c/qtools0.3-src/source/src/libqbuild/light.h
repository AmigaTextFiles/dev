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

#ifndef	LIGHT_H
#define	LIGHT_H
/*
 * ============================================================================
 * structures
 * ============================================================================
 */

typedef enum {
  emit_surface,
  emit_point,
  emit_spotlight
} __packed emittype_t;

#define	MAXLIGHTS			1024
#define	SINGLEMAP			(18*18*4)
/*#define       SINGLEMAP               (64*64*4) */
#define	MAX_STYLES			32
#define	DIRECT_LIGHT			3
#define	MAX_LSTYLES			256

struct lightinfo {
  vec1D lightmaps[MAXLIGHTMAPS][SINGLEMAP];
  int numlightstyles;
  vec1D *light;
  vec1D facedist;
  vec3D facenormal;
  int numsurfpt;
  vec3D surfpt[SINGLEMAP];
  vec3D modelorg;						/* for origined bmodels */
  vec3D texorg;
  vec3D worldtotex[2];						/* s = (world - texorg) . worldtotex[0] */
  vec3D textoworld[2];						/* world = texorg + s * textoworld[0] */
  vec1D exactmins[2], exactmaxs[2];
  int texmins[2], texsize[2];
  int lightstyles[256];
  int surfnum;
  struct dface_t *face;
} __packed;

struct facelight {
  int numsamples;
  vec1D *origins;
  int numstyles;
  int stylenums[MAX_STYLES];
  vec1D *samples[MAX_STYLES];
} __packed;

struct directlight {
  struct directlight *next;
  emittype_t type;
  vec1D intensity;
  int style;
  vec3D origin;
  vec3D color;
  vec3D normal;						/* for surfaces and spotlights */
  vec1D stopdot;						/* for spotlights */
} __packed;

typedef struct {
  vec3D backpt;
  int side;
  int node;
} __packed tracestack_t;

struct tnode {
  int type;
  vec3D normal;
  vec1D dist;
  int children[2];
  int pad;
} __packed;

/*
 * ============================================================================
 * globals
 * ============================================================================
 */

extern vec3D *faceoffset;
extern int bspfileface;						/* next surface to dispatch */

/*
 * ============================================================================
 * prototypes
 * ============================================================================
 */

int TestLine_r(register int node, vec3D start, vec3D stop);
void CalcFaceVectors(bspBase bspMem, register struct lightinfo *l);
void CalcPoints(bspBase bspMem, struct lightinfo *l, register vec1D sofs, register vec1D tofs);

#endif
