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

#ifndef	WINDING_H
#define	WINDING_H
/*
 * ============================================================================
 * structures
 * ============================================================================
 */

struct winding {
  bool original;
  int numpoints;
  vec3D points[8];						/* variable sized */
} __packed;

#define MAX_POINTS_ON_WINDING		64

/*
 * ============================================================================
 * globals
 * ============================================================================
 */

extern int c_activewindings, c_peakwindings;

/*
 * ============================================================================
 * prototypes
 * ============================================================================
 */

void WindingBounds(register struct winding *w, vec3D mins, vec3D maxs);
void WindingCenter(register struct winding *w, vec3D center);
vec1D WindingArea(register struct winding *w);
struct winding *BaseWindingForPlane(register struct plane *p);
struct winding *WindingFromFace(bspBase bspMem, register struct dface_t *f);
void CheckWinding(register struct winding *w);
void CheckWindingInNode(register struct winding *w, register struct node *node);
void CheckWindingArea(register struct winding *w);
void PlaneFromWinding(register struct winding *w, register struct plane *plane);
struct winding *ClipWinding(register struct winding *in, register struct plane *split, register bool keepon);
void ClipWindingEpsilon(struct winding *in, vec3D normal, vec1D dist,
		vec1D epsilon, struct winding **front, struct winding **back);
struct winding *CopyWinding(register struct winding *w);
void DivideWinding(struct winding *in, struct plane *split, struct winding **front, struct winding **back);
void FreeWinding(register struct winding *w);
struct winding *NewWinding(register int points);

#endif
