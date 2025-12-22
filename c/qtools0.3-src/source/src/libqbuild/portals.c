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

#define	LIBQBUILD_CORE
#include "../include/libqbuild.h"

struct node outside_node;					/* 76                                          // portals outside the world face this */

staticvar FILE *pf;						/* 4 */
int num_visportals;						/* 4 */
int num_visleafs;						/* 4                                           // leafs the player can be in */
struct visportal *portals;
struct visleaf **leafs;

/*============================================================================= */

/*
 * =============
 * AddPortalToNodes
 * =============
 */
staticfnc void AddPortalToNodes(register struct portal *p, register struct node *front, register struct node *back)
{
  if (p->nodes[0] || p->nodes[1])
    Error("AddPortalToNode: allready included");

  p->nodes[0] = front;
  p->next[0] = front->portals;
  front->portals = p;

  p->nodes[1] = back;
  p->next[1] = back->portals;
  back->portals = p;
}

/*
 * =============
 * RemovePortalFromNode
 * =============
 */
staticfnc void RemovePortalFromNode(register struct portal *portal, register struct node *l)
{
  struct portal **pp, *t;

  /* remove reference to the current portal */
  pp = &l->portals;
  while (1) {
    t = *pp;
    if (!t)
      Error("RemovePortalFromNode: portal not in leaf");

    if (t == portal)
      break;

    if (t->nodes[0] == l)
      pp = &t->next[0];
    else if (t->nodes[1] == l)
      pp = &t->next[1];
    else
      Error("RemovePortalFromNode: portal not bounding leaf");
  }

  if (portal->nodes[0] == l) {
    *pp = portal->next[0];
    portal->nodes[0] = NULL;
  }
  else if (portal->nodes[1] == l) {
    *pp = portal->next[1];
    portal->nodes[1] = NULL;
  }
}

/*============================================================================ */

staticfnc void PrintPortal(register struct portal *p)
{
  int i;
  struct winding *w;

  w = p->winding;
  for (i = 0; i < w->numpoints; i++)
    mprintf("( " VEC_CONV3D " )\n", w->points[i][0], w->points[i][1], w->points[i][2]);
}

/*
 * ================
 * MakeHeadnodePortals
 * 
 * The created portals will face the global outside_node
 * ================
 */
staticfnc void MakeHeadnodePortals(mapBase mapMem, register struct node *node)
{
  vec3D bounds[2];
  short int i, j, n;
  struct portal *p, *portals[6];
  struct plane bplanes[6], *pl;
  int side;

  Draw_ClearWindow();

  /* pad with some space so there will never be null volume leafs */
  for (i = 0; i < 3; i++) {
    bounds[0][i] = brushset->mins[i] - SIDESPACE;
    bounds[1][i] = brushset->maxs[i] + SIDESPACE;
  }

  outside_node.contents = CONTENTS_SOLID;
  outside_node.portals = NULL;

  for (i = 0; i < 3; i++)
    for (j = 0; j < 2; j++) {
      n = j * 3 + i;

      p = AllocPortal();
      portals[n] = p;

      pl = &bplanes[n];
      __bzero(pl, sizeof(*pl));
      if (j) {
	pl->normal[i] = -1;
	pl->dist = -bounds[j][i];
      }
      else {
	pl->normal[i] = 1;
	pl->dist = bounds[j][i];
      }
      p->planenum = FindPlane(mapMem, pl, &side);

      p->winding = BaseWindingForPlane(pl);
      if (side)
	AddPortalToNodes(p, &outside_node, node);
      else
	AddPortalToNodes(p, node, &outside_node);
    }

  /* clip the basewindings by all the other planes */
  for (i = 0; i < 6; i++) {
    for (j = 0; j < 6; j++) {
      if (j == i)
	continue;
      portals[i]->winding = ClipWinding(portals[i]->winding, &bplanes[j], TRUE);
    }
  }
}

/*============================================================================ */

staticfnc void CheckLeafPortalConsistancy(mapBase mapMem, register struct node *node)
{
  int side, side2;
  struct portal *p, *p2;
  struct plane plane, plane2;
  int i;
  struct winding *w;
  vec1D dist;

  side = side2 = 0;						/* quiet compiler warning */

  for (p = node->portals; p; p = p->next[side]) {
    if (p->nodes[0] == node)
      side = 0;
    else if (p->nodes[1] == node)
      side = 1;
    else
      Error("CutNodePortals_r: mislinked portal");
    CheckWindingInNode(p->winding, node);
    CheckWindingArea(p->winding);

    /* check that the side orders are correct */
#ifdef EXHAUSIVE_CHECK
    if (p->planenum >= mapMem->numbrushplanes || p->planenum < 0)
      Error("looking for nonexisting plane %d\n", p->planenum);
#endif
    plane = mapMem->brushplanes[p->planenum];
    PlaneFromWinding(p->winding, &plane2);

    for (p2 = node->portals; p2; p2 = p2->next[side2]) {
      if (p2->nodes[0] == node)
	side2 = 0;
      else if (p2->nodes[1] == node)
	side2 = 1;
      else
	Error("CutNodePortals_r: mislinked portal");
      w = p2->winding;
      for (i = 0; i < w->numpoints; i++) {
	dist = DotProduct(w->points[i], plane.normal) - plane.dist;
	if ((side == 0 && dist < -1) || (side == 1 && dist > 1)) {
	  eprintf("portal siding direction is wrong\n");
	  return;
	}
      }
    }
  }
}

/*
 * ================
 * CutNodePortals_r
 * 
 * ================
 */
staticfnc void CutNodePortals_r(mapBase mapMem, register struct node *node)
{
  struct plane *plane, clipplane;
  struct node *f, *b, *other_node;
  struct portal *p, *new_portal, *next_portal;
  struct winding *w, *frontwinding, *backwinding;
  int side;

  /* CheckLeafPortalConsistancy (node); */

  /* seperate the portals on node into it's children */
  if (node->contents)
    return;							/* at a leaf, no more dividing */

#ifdef EXHAUSIVE_CHECK
  if (node->planenum >= mapMem->numbrushplanes || node->planenum < 0)
    Error("looking for nonexisting plane %d\n", node->planenum);
#endif
  plane = &mapMem->brushplanes[node->planenum];

  f = node->children[0];
  b = node->children[1];

  /*
   * create the new portal by taking the full plane winding for the cutting plane
   * and clipping it by all of the planes from the other portals
   */
  new_portal = AllocPortal();
  new_portal->planenum = node->planenum;

  w = BaseWindingForPlane(&mapMem->brushplanes[node->planenum]);
  side = 0;							/* shut up compiler warning */

  for (p = node->portals; p; p = p->next[side]) {
    clipplane = mapMem->brushplanes[p->planenum];
    if (p->nodes[0] == node)
      side = 0;
    else if (p->nodes[1] == node) {
      clipplane.dist = -clipplane.dist;
      VectorNegate(clipplane.normal);
      side = 1;
    }
    else
      Error("CutNodePortals_r: mislinked portal");

    w = ClipWinding(w, &clipplane, TRUE);
    if (!w) {
      eprintf("CutNodePortals_r: new portal was clipped away\n");
      break;
    }
  }

  if (w) {
    /* if the plane was not clipped on all sides, there was an error */
    new_portal->winding = w;
    AddPortalToNodes(new_portal, f, b);
  }

  /* partition the portals */
  for (p = node->portals; p; p = next_portal) {
    if (p->nodes[0] == node)
      side = 0;
    else if (p->nodes[1] == node)
      side = 1;
    else
      Error("CutNodePortals_r: mislinked portal");
    next_portal = p->next[side];

    other_node = p->nodes[!side];
    RemovePortalFromNode(p, p->nodes[0]);
    RemovePortalFromNode(p, p->nodes[1]);

    /* cut the portal into two portals, one on each side of the cut plane */
    DivideWinding(p->winding, plane, &frontwinding, &backwinding);

    if (!frontwinding) {
      if (side == 0)
	AddPortalToNodes(p, b, other_node);
      else
	AddPortalToNodes(p, other_node, b);
      continue;
    }
    if (!backwinding) {
      if (side == 0)
	AddPortalToNodes(p, f, other_node);
      else
	AddPortalToNodes(p, other_node, f);
      continue;
    }

    /* the winding is split */
    new_portal = AllocPortal();
    *new_portal = *p;
    new_portal->winding = backwinding;
    FreeWinding(p->winding);
    p->winding = frontwinding;

    if (side == 0) {
      AddPortalToNodes(p, f, other_node);
      AddPortalToNodes(new_portal, b, other_node);
    }
    else {
      AddPortalToNodes(p, other_node, f);
      AddPortalToNodes(new_portal, other_node, b);
    }
  }

  DrawLeaf(f, 1);
  DrawLeaf(b, 2);

  CutNodePortals_r(mapMem, f);
  CutNodePortals_r(mapMem, b);

}

/*
 * ==================
 * PortalizeWorld
 * 
 * Builds the exact polyhedrons for the nodes and leafs
 * ==================
 */
void PortalizeWorld(mapBase mapMem, struct node *headnode)
{
  mprintf("----- Portalize ---------\n");

  MakeHeadnodePortals(mapMem, headnode);
  CutNodePortals_r(mapMem, headnode);
}

/*
 * ==================
 * FreeAllPortals
 * 
 * ==================
 */
void FreeAllPortals(struct node *node)
{
  struct portal *p, *nextp;

  if (!node->contents) {
    FreeAllPortals(node->children[0]);
    FreeAllPortals(node->children[1]);
  }

  for (p = node->portals; p; p = nextp) {
    if (p->nodes[0] == node)
      nextp = p->next[0];
    else
      nextp = p->next[1];
    RemovePortalFromNode(p, p->nodes[0]);
    RemovePortalFromNode(p, p->nodes[1]);
    FreeWinding(p->winding);
    FreePortal(p);
  }
}

/*
 * ==============================================================================
 * 
 * PORTAL FILE GENERATION
 * 
 * ==============================================================================
 */

void WritePortalFile_r(mapBase mapMem, register struct node *node)
{
  int i;
  struct portal *p;
  struct winding *w;
  struct plane *pl, plane2;

  if (!node->contents) {
    WritePortalFile_r(mapMem, node->children[0]);
    WritePortalFile_r(mapMem, node->children[1]);
    return;
  }

  if (node->contents == CONTENTS_SOLID)
    return;

  for (p = node->portals; p;) {
    w = p->winding;
    if (w && p->nodes[0] == node) {
      if (((mapMem->mapOptions & QBSP_WATERVIS) &&
	   ((p->nodes[0]->contents == CONTENTS_WATER && p->nodes[1]->contents == CONTENTS_EMPTY) ||
	    (p->nodes[0]->contents == CONTENTS_EMPTY && p->nodes[1]->contents == CONTENTS_WATER)))
	  || ((mapMem->mapOptions & QBSP_SLIMEVIS) &&
	      ((p->nodes[0]->contents == CONTENTS_SLIME && p->nodes[1]->contents == CONTENTS_EMPTY) ||
	       (p->nodes[0]->contents == CONTENTS_EMPTY && p->nodes[1]->contents == CONTENTS_SLIME)))
	  || ((mapMem->mapOptions & QBSP_WATERVIS) && (mapMem->mapOptions & QBSP_SLIMEVIS) &&
	      ((p->nodes[0]->contents == CONTENTS_WATER && p->nodes[1]->contents == CONTENTS_SLIME) ||
	       (p->nodes[0]->contents == CONTENTS_SLIME && p->nodes[1]->contents == CONTENTS_WATER)))
	  || (p->nodes[0]->contents == p->nodes[1]->contents)) {
	/*
	 * write out to the file
	 *
	 * sometimes planes get turned around when they are very near
	 * the changeover point between different axis.  interpret the
	 * plane the same way vis will, and flip the side orders if needed
	 */
#ifdef EXHAUSIVE_CHECK
	if (p->planenum >= mapMem->numbrushplanes || p->planenum < 0)
	  Error("looking for nonexisting plane %d\n", p->planenum);
#endif
	pl = &mapMem->brushplanes[p->planenum];
	PlaneFromWinding(w, &plane2);

	if (DotProduct(pl->normal, plane2.normal) < 0.99)	/* backwards... */
	  fprintf(pf, "%i %i %i ", w->numpoints, p->nodes[1]->visleafnum, p->nodes[0]->visleafnum);
	else
	  fprintf(pf, "%i %i %i ", w->numpoints, p->nodes[0]->visleafnum, p->nodes[1]->visleafnum);

	for (i = 0; i < w->numpoints; i++)
	  fprintf(pf, "( " VEC_CONV3D " ) ", w->points[i][0], w->points[i][1], w->points[i][2]);
	fprintf(pf, "\n");
      }
    }

    if (p->nodes[0] == node)
      p = p->next[0];
    else
      p = p->next[1];
  }

}

/*
 * ================
 * NumberLeafs_r
 * ================
 */
staticfnc void NumberLeafs_r(mapBase mapMem, register struct node *node)
{
  struct portal *p;

  if (!node->contents) {					/* decision node */
    node->visleafnum = -99;
    NumberLeafs_r(mapMem, node->children[0]);
    NumberLeafs_r(mapMem, node->children[1]);
    return;
  }

  Draw_ClearWindow();
  DrawLeaf(node, 1);

  if (node->contents == CONTENTS_SOLID) {			/* solid block, viewpoint never inside */
    node->visleafnum = -1;
    return;
  }

  node->visleafnum = num_visleafs++;

  for (p = node->portals; p;) {
    if (p->nodes[0] == node) {					/* only write out from first leaf */
      if (((mapMem->mapOptions & QBSP_WATERVIS) &&
	   ((p->nodes[0]->contents == CONTENTS_WATER && p->nodes[1]->contents == CONTENTS_EMPTY) ||
	    (p->nodes[0]->contents == CONTENTS_EMPTY && p->nodes[1]->contents == CONTENTS_WATER)))
	  || ((mapMem->mapOptions & QBSP_SLIMEVIS) &&
	      ((p->nodes[0]->contents == CONTENTS_SLIME && p->nodes[1]->contents == CONTENTS_EMPTY) ||
	       (p->nodes[0]->contents == CONTENTS_EMPTY && p->nodes[1]->contents == CONTENTS_SLIME)))
	  || ((mapMem->mapOptions & QBSP_WATERVIS) && (mapMem->mapOptions & QBSP_SLIMEVIS) &&
	      ((p->nodes[0]->contents == CONTENTS_WATER && p->nodes[1]->contents == CONTENTS_SLIME) ||
	       (p->nodes[0]->contents == CONTENTS_SLIME && p->nodes[1]->contents == CONTENTS_WATER)))
	  || (p->nodes[0]->contents == p->nodes[1]->contents)) {
	num_visportals++;
      }
      p = p->next[0];
    }
    else
      p = p->next[1];
  }
}

/*
 * ================
 * WritePortalfile
 * ================
 */
void WritePortalfile(mapBase mapMem, struct node *headnode, char *prtName)
{
  /* set the visleafnum field in every leaf and count the total number of portals */
  num_visleafs = 0;
  num_visportals = 0;
  NumberLeafs_r(mapMem, headnode);

  /* write the file */
  mprintf("    - writing %s\n", prtName);
  if (!(pf = __fopen(prtName, "w")))
    Error(failed_fileopen, prtName);

  fprintf(pf, "%s\n", PORTALFILE);
  fprintf(pf, "%i\n", num_visleafs);
  fprintf(pf, "%i\n", num_visportals);

  WritePortalFile_r(mapMem, headnode);

  __fclose(pf);
}

/*
 * ============
 * LoadPortals
 * ============
 */
void LoadPortals(char *prtBuf)
{
  int i, j;
  int read;
  struct visportal *p;
  struct visleaf *l;
  char magic[80];
  int numpoints;
  struct winding *w;
  int leafnums[2];
  struct plane plane;

  mprintf("----- LoadPortals -------\n");

  if (sscanf(prtBuf, "%79s\n%i\n%i\n%n", magic, &num_visleafs, &num_visportals, &read) != 3)
    Error("LoadPortals: failed to read header");
  prtBuf += read;
  if (__strcmp(magic, PORTALFILE))
    Error("LoadPortals: not a portal file");

  /* each file portal is split into two memory portals */
  if (!(portals = (struct visportal *)tmalloc(2 * num_visportals * sizeof(struct visportal))))
      Error(failed_memoryunsize, "visportal");

  /*leafs = (struct visleaf *)tmalloc(num_visleafs * sizeof(struct visleaf)); */
  if (!(leafs = (struct visleaf **)tmalloc(num_visleafs * sizeof(struct visleaf *))))
      Error(failed_memoryunsize, "visleaf");

  for (i = 0, p = portals; i < num_visportals; i++) {
    if (sscanf(prtBuf, "%i %i %i %n", &numpoints, &leafnums[0], &leafnums[1], &read) != 3)
      Error("LoadPortals: reading portal %i\n", i);
    if (numpoints > MAX_POINTS_ON_WINDING)
      Error("LoadPortals: portal %i has too many points\n", i);
    if ((unsigned)leafnums[0] > num_visleafs || (unsigned)leafnums[1] > num_visleafs)
      Error("LoadPortals: reading portal %i\n", i);
    prtBuf += read;

    w = p->winding = NewWinding(numpoints);
    w->original = TRUE;
    w->numpoints = numpoints;

    for (j = 0; j < numpoints; j++) {
      int k;

      /* scanf into double, then assign to vec1D */
      if ((k = sscanf(prtBuf, "( " VEC_CONV3D " ) %n", &w->points[j][0], &w->points[j][1], &w->points[j][2], &read)) != 3)
	Error("LoadPortals: reading portal %i (%i elements)\n", i, k);
      prtBuf += read;
    }
    sscanf(prtBuf, "\n%n", &read);
    prtBuf += read;

    /* calc plane */
    PlaneFromWinding(w, &plane);

    /* create forward portal */
    /*l = &leafs[leafnums[0]]; */
    if (!(l = leafs[leafnums[0]]))
      l = leafs[leafnums[0]] = AllocLeaf(MAX_PORTALS_ON_LEAF);
    else if (l->numportals == MAX_PORTALS_ON_LEAF)
      Error("Leaf with too many portals");
    l->portals[l->numportals] = p;
    l->numportals++;

    p->winding = w;
    VectorNegateTo(plane.normal, p->plane.normal);
    p->plane.dist = -plane.dist;
    p->leaf = leafnums[1];
    p++;

    /* create backwards portal */
    /*l = &leafs[leafnums[1]]; */
    if (!(l = leafs[leafnums[1]]))
      l = leafs[leafnums[1]] = AllocLeaf(MAX_PORTALS_ON_LEAF);
    else if (l->numportals == MAX_PORTALS_ON_LEAF)
      Error("Leaf with too many portals");
    l->portals[l->numportals] = p;
    l->numportals++;

    p->winding = w;
    p->plane = plane;
    p->leaf = leafnums[0];
    p++;

    mprogress(num_visportals, i + 1);
  }

  mprintf("%5i num_visportals\n", num_visportals);
  mprintf("%5i num_visleafs\n", num_visleafs);

  for (i = 0; i < num_visleafs; i++) {
    if (leafs[i])
      RecalcLeaf(leafs[i]);
    else
      leafs[i] = AllocLeaf(MAX_PORTALS_ON_LEAF);
  }
}
