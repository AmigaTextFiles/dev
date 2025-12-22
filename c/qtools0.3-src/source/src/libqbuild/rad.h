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

#ifndef	RAD_H
#define	RAD_H
/*
 * ============================================================================
 * structures
 * ============================================================================
 */

/* the sum of all tranfer->transfer values for a given patch */
/* should equal exactly 0x10000, showing that all radiance */
/* reaches other patches */
struct transfer {
  unsigned short int patch;
  unsigned short int transfer;
} __packed;

struct patch {
  struct winding *winding;
  struct patch *next;						/* next in face */
  int numtransfers;
  struct transfer *transfers;
  int cluster;							/* for pvs checking */
  vec3D origin;
  struct dplane_t *plane;
  bool sky;
  vec3D totallight;						/* accumulated by radiosity */
  /* does NOT include light */
  /* accounted for by direct lighting */
  vec1D area;
  /* illuminance * reflectivity = radiosity */
  vec3D reflectivity;
  vec3D baselight;						/* emissivity only */
  /* each style 0 lightmap sample in the patch will be */
  /* added up to get the average illuminance of the entire patch */
  vec3D samplelight;
  int samples;							/* for averaging direct light */
} __packed;

struct triedge {
  int p0, p1;
  vec3D normal;
  vec1D dist;
  struct tripoly *tri;
} __packed;

struct tripoly {
  struct triedge *edges[3];
} __packed;

#define	MAX_TRI_POINTS		1024
#define	MAX_TRI_EDGES		(MAX_TRI_POINTS*6)
#define	MAX_TRI_TRIS		(MAX_TRI_POINTS*2)

struct triangulation {
  struct dplane_t *plane;
  int matrixsquare;
  struct triedge **edgematrix;
  int numpoints;
  struct patch **points;
  int numedges;
  struct triedge *edges;
  int numtris;
  struct tripoly *tris;
} __packed;

/*
 * ============================================================================
 * globals
 * ============================================================================
 */

extern vec3D *texreflectivity;
extern vec3D *radiosity;
extern vec3D *illumination;
extern struct patch **facepatches;
extern struct entity **faceentity;
extern struct patch *patches;
extern int numpatches;
extern struct dplane_t *backplanes;
extern int fakeplanes;
extern int *leafparents;
extern int *nodeparents;
extern vec1D subdiv;
extern struct directlight **directlights;
extern struct facelight *facelights;
extern int numdlights;
extern int numbounce;
extern bool dumppatches;
extern int junk;
extern vec1D ambient;
extern vec1D maxlight;
extern vec1D lightscale;
extern vec1D direct_scale;
extern vec1D entity_scale;

/*
 * ============================================================================
 * prototypes
 * ============================================================================
 */

void RadWorld(bspBase bspMem, mapBase mapMem);

#endif
