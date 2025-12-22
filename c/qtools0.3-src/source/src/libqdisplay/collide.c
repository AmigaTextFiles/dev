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

/*
 * clipping-hulls
 *
 *  hull[0] drawing-hull
 *  hull[1] player-hull		((-16,-16,-24),(16,16,32))
 *  hull[2] shambler-hull	((-32,-32,-24),(32,32,64))
 */

staticfnc bool point_plane_test(register vec3D point, register struct dplane_t *plane)
{
#if (PLANE_X == 0) && (PLANE_Y == 1) && (PLANE_Z == 2)
  vec1D val;

  if (plane->type < PLANE_Z)
    val = point[plane->type];
  else
    val = DotProduct(plane->normal, point);

  return val < plane->dist;
#else
  switch (plane->type) {
    case PLANE_X:
      return point[0] < plane->dist;
      break;
    case PLANE_Y:
      return point[1] < plane->dist;
      break;
    case PLANE_Z:
      return point[2] < plane->dist;
      break;
    default:
      return DotProduct(plane->normal, point) < plane->dist;
      break;
  }
#endif
}

short int find_clipcontents(bspBase bspMem, register short int n)
{
  struct dclipnode_t *node;

  do {
    node = &bspMem->shared.quake1.dclipnodes[n];
  } while ((n = node->children[point_plane_test(&bspMem->shared.quake1.dplanes[node->planenum])]) >= 0);

  return n;
}

/*
 * we execute as long as bsp_clip_node returns FALSE,
 * that means we get a dead-lock (endless loop) if we cannot
 * break the line any more, so we dont continue in that case
 *
 * the splitting is as follows
 *  we calculate the length between start and end point, if its 0 we break
 *  else we check for intersection, if nothing intersects we break
 *  else we check how long is the way we can go (which MUST be less than
 *  length), we go that length
 *  now we rotate the direction of the leaved move to the plane ones (not
 *  the direction of the planes normal, the direction of the planes plane),
 *  set the new player start and end and recall the splitting
 */

vec3D player_position;
vec3D player_target;
struct dplane_t *split_plane;

void ClipMove(void) {
  if(!VectorCompare(player_target, player_position)) {
    short int node;						/* how to calculate the node? */
  
    if(!bsp_clip_node(node)) {
      player_position = player_target;
    }
    else {
      vec3D move_line, new_move;
      vec1D diff, angle;

      VectorSubtract(player_target, player_position, move_line);
#if 0
      player_position = Intersect(move_line, split_plane);
#else
/*
 * math

 line-equation

  alpha * n_x + b_x
  alpha * n_y + b_y
  alpha * n_z + b_z

 plane-equation
 
  distance = DotProduct(point, plane_normal) + plane_dist;
           = point_x * plane_normal_x + point_y * plane_normal_y + point_z * plane_normal_z + plane_dist;
 
 point could be solved with the line-equation

           = (alpha * n_x + b_x) * plane_normal_x + 
	     (alpha * n_y + b_y) * plane_normal_y +
	     (alpha * n_z + b_z) * plane_normal_z +
	      plane_dist;

           = (alpha * n_x * plane_normal_x) + (b_x * plane_normal_x) +
	     (alpha * n_y * plane_normal_y) + (b_y * plane_normal_y) +
	     (alpha * n_z * plane_normal_z) + (b_z * plane_normal_z) +
	      plane_dist;

	   = alpha * DotProduct(n, plane_normal) + DotProduct(b, plane_normal) + plane_dist;

 the intersection point must be on the plane, so distance must be 0

				    0 = alpha * DotProduct(n, plane_normal) + DotProduct(b, plane_normal) + plane_dist;
  alpha * DotProduct(n, plane_normal) = (-DotProduct(b, plane_normal) - plane_dist);
				alpha = (-DotProduct(b, plane_normal) - plane_dist) / DotProduct(n, plane_normal)

 */
      /* how much of move_line can we go */
      diff = (-DotProduct(player_position, split_plane->normal) - plane->dist) / DotProduct(move_line, split_plane->normal);
      VectorScale(move_line, diff, new_move);
      VectorAdd(new_move, player_position);
#endif
      VectorSubtract(player_target, player_position, move_line);
#if 0
      player_target = Rotate(moveline, split_plane);
#else
      /* without rotate, dont know how to do with */
      diff = DotProduct(player_target, split_plane->normal) + split_plane->dist;
      VectorMA(player_target, -diff, split_plane->normal, player_target);
#endif
      ClipMove();
    }
  }
}

bool bsp_clip_node(bspBase bspMem, short int node)
{
  if (node >= 0) {
    /* positivity of start and end points */
    bool pos_start, pos_end;
    struct dplane_t *plane;
    
    plane = &bspMem->shared.quake1.dplanes[node->planenum];
    pos_start = point_plane_test(player_position, plane);
    pos_end = point_plane_test(player_target, plane);
  
    /* we are on our side of the plane, both are positive */
    if (pos_start && pos_end)
      return bsp_clip_node(bspMem, bspMem->shared.quake1.dclipnodes[node].children[0]);
    /*
     * we are on the other side of the plane, both are negative
     * I think that is not possible, cause we cant be IN solid?
     */
    else if (!pos_start && !pos_end)
      return bsp_clip_node(bspMem, bspMem->shared.quake1.dclipnodes[node].children[1]);
    /* we are in the plane, one is positive and one is negative */
    else {
      /*
       * we split the move, do the partial move and return
       * must ever be positive, cause we cant be IN solid?
       */
      split_plane = plane
      return TRUE;
    }
  }
  else {
    /* we are in solid and must clip the movement */
    if (node == CONTENTS_SOLID)
      return TRUE;
    else
      return FALSE;
  }
}
