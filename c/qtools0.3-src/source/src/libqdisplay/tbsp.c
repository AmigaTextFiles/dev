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
 * model: a combination of a brush and an entity.
 * 
 * One or more brushes are bound to an entity,
 * which controls the behavior of the brushes.
 * All brushes are contained within models.
 * 
 * The model numbers in the compiled BSP (*x) comes from the order in which
 * the models are stored in the models structure. These numbers are originally
 * derived from the order of the models in the source MAP file.
 * 
 * The worldspawn model is a bounding box that defines the extents of the
 * whole world.
 * 
 * The models are defined by a bounding box of the max and min(x,y,z).
 * Therefore they are always parallel to the horizontal planes.
 * -- (qkspecs.)
 */

/*
 * 
 */
staticfnc bool camera_plane_test(register struct dplane_t *plane)
{
#if (PLANE_X == 0) && (PLANE_Y == 1) && (PLANE_Z == 2)
  vec1D val;

  if (plane->type < PLANE_Z)
    val = cameraLocation[plane->type];
  else
    val = DotProduct(plane->normal, cameraLocation);

  return val < plane->dist;
#else
  switch (plane->type) {
    case PLANE_X:
      return cameraLocation[0] < plane->dist;
      break;
    case PLANE_Y:
      return cameraLocation[1] < plane->dist;
      break;
    case PLANE_Z:
      return cameraLocation[2] < plane->dist;
      break;
    default:
      return DotProduct(plane->normal, cameraLocation) < plane->dist;
      break;
  }
#endif
}

/*
 * there could be three different values in children[]
 *  -1          terminator, references to dleaf[0]      is set if childrens planenum == -1 and CONTENTS_SOLID
 *  negative    what follows are leafs                  is set otherwise
 *  positive    what follows are nodes                  is set if childrens planenum != -1
 */

short int find_leaf(bspBase bspMem)
{
  short int n = (short int)bspMem->shared.quake1.dmodels[model].headnode[0];
  struct dnode_t *node;

  do {
    node = &bspMem->shared.quake1.dnodes[n];
  } while ((n = node->children[camera_plane_test(&bspMem->shared.quake1.dplanes[node->planenum])]) >= 0);

  return ~n;
}

void bsp_render_node(bspBase bspMem, short int node)
{
  if (node >= 0) {
    if (is_marked_node(node)) {
      if (camera_plane_test(&bspMem->shared.quake1.dplanes[bspMem->shared.quake1.dnodes[node].planenum])) {
	bsp_render_node(bspMem, bspMem->shared.quake1.dnodes[node].children[0]);
	render_node_faces(bspMem, node, 1);
	bsp_render_node(bspMem, bspMem->shared.quake1.dnodes[node].children[1]);
      }
      else {
	bsp_render_node(bspMem, bspMem->shared.quake1.dnodes[node].children[1]);
	render_node_faces(bspMem, node, 0);
	bsp_render_node(bspMem, bspMem->shared.quake1.dnodes[node].children[0]);
      }
      unmark_node(node);
    }
  }
}

void bsp_explore_node(bspBase bspMem, short int node)
{
  if (node >= 0) {
    if (is_marked_node(node)) {
      if (!node_in_frustrum(&bspMem->shared.quake1.dnodes[node])) {
	unmark_node(node);
      }
      else {
	bsp_explore_node(bspMem, bspMem->shared.quake1.dnodes[node].children[0]);
	bsp_explore_node(bspMem, bspMem->shared.quake1.dnodes[node].children[1]);
      }
    }
  }
  else {
    /*
     * node is 0 or a valid leaf-node
     * if 0 everything is invisible (leaf 0 is CONTENTS_SOLID)
     * else it is something other
     */
    node = ~node;

    if (is_marked_leaf(node))
      if (leaf_in_frustrum(&bspMem->shared.quake1.dleafs[node]))
	mark_leaf_faces(bspMem, node);
  }
}

/*
 * recursively determine which nodes need exploring (so we
 * don't look for polygons on _every_ node in the level)
 *
 * this need only be called once at the beginning
 */
int bsp_find_visible_nodes(bspBase bspMem, short int node)
{
  if (node >= 0) {
    if (bsp_find_visible_nodes(bspMem, bspMem->shared.quake1.dnodes[node].children[0]) |
	bsp_find_visible_nodes(bspMem, bspMem->shared.quake1.dnodes[node].children[1]))
      return mark_node(node);
    else
      return 0;
  }
  else {
    node = ~node;
    return is_marked_leaf(node);
  }
}
