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

#ifndef	BRUSH_H
#define	BRUSH_H

/* brush.c */

#define	NUM_HULLS	2					/* normal and +16 */
#define	NUM_CONTENTS	2					/* solid and water */

struct brush {
  struct brush *next;
  vec3D mins, maxs;
  struct visfacet *faces;
  int contents;
} __packed;

struct brushset {
  vec3D mins, maxs;
  struct brush *brushes;					/* NULL terminated list */
  /* PROGRESS-ONLY! */
  int numbrushes;
} __packed;

/*============================================================================= */

struct brushset *Brush_LoadEntity(bspBase bspMem, mapBase mapMem, struct entity *ent, int hullNum, bool worldModel);
void CheckFace(mapBase mapMem, register struct visfacet *f);
int PlaneTypeForNormal(vec3D normal);
int FindPlane(mapBase mapMem, register struct plane *dplane, register int *side);

#endif
