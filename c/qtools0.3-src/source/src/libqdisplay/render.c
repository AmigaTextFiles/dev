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
 *   "render" scenes by traversing over the
 *   database, marking already-visited things,
 *   using the PVS information and the "marksurface"
 *   info; use one bsp routine to sort
 */

unsigned char *visibleFaces;					/*[MAX_MAP_FACES / 8 + 1]; */
unsigned char *visibleLeafs;					/*[MAX_MAP_LEAFS / 8 + 1]; */
unsigned char *visibleNodes;					/*[MAX_MAP_NODES]; */

staticfnc bool bbox_inside_plane(register short int *mins, register short int *maxs, register struct extplane *pl)
{
  short int pt[3];

  /* use quick test from graphics gems */
  if (pl->positive[0])
    pt[0] = maxs[0];
  else
    pt[0] = mins[0];

  if (pl->positive[1])
    pt[1] = maxs[1];
  else
    pt[1] = mins[1];

  if (pl->positive[2])
    pt[2] = maxs[2];
  else
    pt[2] = mins[2];

  /*
   * each frustum-plane in hesse-form have a positive and a negative half-space
   * we can check if the distance between frustum-plane and point is positive or
   * negative to check where the points is, in the positive or negative
   * half-space
   *
   * if((DotProduct(frustumNormal, point) - frustumDistance) >= 0) -> if(DotProduct(frustumNormal, point) >= frustumDistance)
   *  if is visible (lies in positive half-space)
   * else
   *  it is invisible (lies in negative half-space)
   */
  return DotProduct(pl->normal, pt) >= pl->dist;
}

/* is the complete node between the frustum-planes? */
bool node_in_frustrum(register struct dnode_t *node)
{
  if (!bbox_inside_plane(node->mins, node->maxs, &actView->viewCamera.planes[0]) ||
      !bbox_inside_plane(node->mins, node->maxs, &actView->viewCamera.planes[1]) ||
      !bbox_inside_plane(node->mins, node->maxs, &actView->viewCamera.planes[2]) ||
      !bbox_inside_plane(node->mins, node->maxs, &actView->viewCamera.planes[3]))
    return FALSE;
  return TRUE;
}

/* is the complete leaf between the frustum-planes? */
bool leaf_in_frustrum(register struct dleaf_t *node)
{
  if (!bbox_inside_plane(node->mins, node->maxs, &actView->viewCamera.planes[0]) ||
      !bbox_inside_plane(node->mins, node->maxs, &actView->viewCamera.planes[1]) ||
      !bbox_inside_plane(node->mins, node->maxs, &actView->viewCamera.planes[2]) ||
      !bbox_inside_plane(node->mins, node->maxs, &actView->viewCamera.planes[3]))
    return FALSE;
  return TRUE;
}

/* mark all faces within a given leaf */
void mark_leaf_faces(bspBase bspMem, register short int leaf)
{
  int contents = bspMem->shared.quake1.dleafs[leaf].contents;
  short int i = bspMem->shared.quake1.dleafs[leaf].nummarksurfaces;
  unsigned short int *dms = &bspMem->shared.quake1.dmarksurfaces[(int)(bspMem->shared.quake1.dleafs[leaf].firstmarksurface + i)];

  for (--i; i >= 0; i--) {
    unsigned short int s = *--dms;

    mark_face(s);
  }
}

/*
 * The visibility lists are used by BSP Leaves, to
 * determine which other leaves are visible from a given BSP Leaf.
 * The Visibility list can be of size 0, in that case it will not be used.
 * The game will crawl if there is no visibility list in a level.
 *      u_char vislist[numvislist];    / RLE encoded bit array /
 * Basically, the visibility list is an array of bits. There is one such array
 * of bits for each BSP Leaf.  They are all stored in the vislist array, and
 * each leaf has an index to the first byte of it's own array
 * The bit number N, if set to 1, tells that when laying in the tree leaf, one
 * can see the leaf number N.
 * The only complication is that this bit array in run-length encoded:
 * when a set of bytes in the array are all zero, they are coded by zero
 * followed by the number of bytes is the set (always more than 1).
 * Normally, the size of the bit array associated to a leaf should be
 * (numleafs+7)/8, but in fact due to the run length encoding, it's usually
 * much less.
 * When the player is in a leaf, the visibility list is used to tag
 * all the leaves that can possibly be visible, and then only those
 * leaves are rendered.
 * Here is an example of decoding of visibility lists:
 *   / Suppose Leaf is the leaf the player is in. /
 *   v = Leaf.vislist;
 *   for (L = 1; L &lt; numleaves; v++) {
 *     if (visisz[v] == 0) {         / value 0, leaves invisible /
 *       L += 8 * visisz[v + 1]      / skip some leaves /
 *       v++;
 *     }
 *     else {                        / tag 8 leaves, if needed /
 *                                   / examine bits right to left /
 *       for (bit = 1; bit != 0; bit = bit * 2, L++) {
 *         if (visisz[v] & bit)
 *         TagLeafAsVisible(L);
 *       }
 *     }
 *   }
 * Lots of thanks to Tony Myles who fixed the  bit mask formula.
 * There is no necessity to unpack the visibility list in memory,
 * because the code to read them is fast enough.
 */
int visit_visible_leaves(bspBase bspMem)
{
  short int n;
  int i;
  unsigned char *vis;

  n = find_leaf(bspMem);

  if ((!n) || (bspMem->shared.quake1.dleafs[n].visofs < 0)) {
    __memset(visibleLeafs, 0xFF, (bspMem->shared.quake1.dmodels[model].visleafs >> 3) * sizeof(unsigned char));
    return 0;
  }
  else {
    __bzero(visibleLeafs, (bspMem->shared.quake1.dmodels[model].visleafs >> 3) * sizeof(unsigned char));

  vis = bspMem->shared.quake1.dvisdata + bspMem->shared.quake1.dleafs[n].visofs;
  for (i = 1; i < bspMem->shared.quake1.dmodels[model].visleafs;) {
    unsigned char v = *vis++;

    if (!v) {
      i += *vis++ << 3;						/* * 8 */
    }
    else {
      if (v & 1)
	visibleLeafs[i >> 3] |= (1 << (i & 7));
      i++;
      if (v & 2)
	visibleLeafs[i >> 3] |= (1 << (i & 7));
      i++;
      if (v & 4)
	visibleLeafs[i >> 3] |= (1 << (i & 7));
      i++;
      if (v & 8)
	visibleLeafs[i >> 3] |= (1 << (i & 7));
      i++;
      if (v & 16)
	visibleLeafs[i >> 3] |= (1 << (i & 7));
      i++;
      if (v & 32)
	visibleLeafs[i >> 3] |= (1 << (i & 7));
      i++;
      if (v & 64)
	visibleLeafs[i >> 3] |= (1 << (i & 7));
      i++;
      if (v & 128)
	visibleLeafs[i >> 3] |= (1 << (i & 7));
      i++;
    }
  }
  return 1;
  }
}

/*
 * during a bsp recursion, draw all of the faces
 * stored on this node which are visible (i.e. just
 * test their mark flag)
 */
void render_node_faces(bspBase bspMem, register short int node, short register int side)
{
  unsigned short int i, n, f;

  n = bspMem->shared.quake1.dnodes[node].numfaces;
  f = bspMem->shared.quake1.dnodes[node].firstface;

  for (i = 0; i < n; ++i) {
    if (bspMem->shared.quake1.dfaces[f].side == side)
      if (is_marked_face(f))
	draw_face(bspMem, f);
    unmark_face(f);
    ++f;
  }
}

int model = 0;

void renderWorld(bspBase bspMem)
{
  compute_view_frustrum();

  for(model = 0; model < bspMem->shared.quake1.nummodels; model++) {
    visit_visible_leaves(bspMem);
    bsp_find_visible_nodes(bspMem, (short int)bspMem->shared.quake1.dmodels[model].headnode[0]);
    bsp_explore_node(bspMem, (short int)bspMem->shared.quake1.dmodels[model].headnode[0]);
    bsp_render_node(bspMem, (short int)bspMem->shared.quake1.dmodels[model].headnode[0]);
  }
  model = 0;
}
