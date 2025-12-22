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

#ifndef D3_H
#define	D3_H

/*
 * ============================================================================
 * structures
 * ============================================================================
 */

#define CC_OFF_LEFT    1
#define CC_OFF_RIGHT   2
#define CC_OFF_TOP     4
#define CC_OFF_BOT     8
#define CC_BEHIND      16

/*#define       FIX_INT(x)      (((x) + 32768) >> 16) */
/*#define       FLOAT_TO_INT(x) ((int)((x) + 0.5)) */
/*#define       FLOAT_TO_FIX(x) (FLOAT_TO_INT(scalw((x), 16))) */
#define	FIX_INT(x)	(((x) + 65535) >> 16)
#define	FLOAT_TO_INT(x)	((int)(x))
#define	FLOAT_TO_FIX(x)	((int)((x) * 65536))

typedef int fix;

typedef struct {
  int tx, ty, tz;
} angvec;

typedef struct {
  vec3D p;
  unsigned char ccodes;
  unsigned char pad0, pad1, pad2;
  fix sx, sy;
  vec1D u, v;
} point_3d;

struct extplane {
  vec3D normal;
  vec1D dist;
  bool positive[3];
};

struct camera {
  vec3D cameraLocation;
  
  bool changedLocation, changedAngles, changedMatrix;
  angvec cameraAngles, lastAngles;	/* this and last angles */
  struct extplane planes[4];

  vec3D mainMatrix[3], viewMatrix[3], translate;
};

#define	NEAR_CLIP	0.01
#define	NEAR_CODE	16.0
struct view {
  struct DisplayDimension *viewDim;
  struct camera viewCamera;
  
  int displayType;

  int clipXLow, clipXHigh, clipYLow, clipYHigh;
  vec1D projScaleX, projScaleY;
  vec1D clipScaleX, clipScaleY, incSpeed, maxSpeed, decSpeed;
  vec1D xCenter, yCenter;
  vec3D currentSpeed;
};

/*
 * ============================================================================
 * globals
 * ============================================================================
 */

extern vec3D currentSpeed;

/*
 * ============================================================================
 * prototypes
 * ============================================================================
 */

void compute_view_frustrum(void);
vec1D dist2_from_viewer(vec1D *in);
void init_tables(void);
void set_clip_values(int offsX, int offsY, int sizeX, int sizeY)
void set_view_info(void);
void transform_point(point_3d *p, vec1D *v);
void transform_point_raw(vec1D *out, vec1D *in);
void transform_rotated_point(point_3d * p);
void transform_vector(vec1D *out, vec1D *in);

#endif
