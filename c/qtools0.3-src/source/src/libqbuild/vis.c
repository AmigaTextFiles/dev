/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 1998  Niels Froehling <Niels.Froehling@Informatik.Uni-Oldenburg.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Library General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#define	LIBQBUILD_CORE
#include "../include/libqbuild.h"

staticvar int bitbytes;							/* (num_visleafs+63)>>3 */
staticvar int bitlongs;
staticvar int c_chains;
staticvar int c_leafsee, c_portalsee;
staticvar int c_portalskip, c_leafskip;
staticvar int c_portaltest, c_portalpass, c_portalcheck;
staticvar int c_vistest, c_mighttest;
staticvar int count_sep;
staticvar int leafon;							/* the next leaf to be given to a thread to process */
staticvar int originalvismapsize;
staticvar int testvislevel = 2;
staticvar int testvisfastlevel = 3;
staticvar int totalvis;
staticvar unsigned char *uncompressed;					/* [bitbytes*num_visleafs] */

/*
 * These variables are used by both BasePortalVis and SimpleFlood.
 * portalsee is an array of bytes. When running BasePortalVis,
 * the array is filled with a 'mightsee' indicator
 * c_* is counters.
 */
staticvar unsigned char *portalsee;	/* [MAX_MAP_PORTALS]; */

staticfnc void CheckStack(register struct visleaf *leaf, register threaddata_t * thread)
{
  pstack_t *p;

  for (p = thread->pstack_head.next; p; p = p->next)
    if (p->leaf == leaf)
      Error("CheckStack: leaf recursion");
}

/*
 * ==============
 * ClipToSeperators
 * 
 * Source, pass, and target are an ordering of portals.
 * 
 * Generates seperating planes canidates by taking two points from source and one
 * point from pass, and clips target by them.
 * 
 * If target is totally clipped away, that portal can not be seen through.
 * 
 * Normal clip keeps target on the same side as pass, which is correct if the
 * order goes source, pass, target.  If the order goes pass, source, target then
 * flipclip should be set.
 * ==============
 */
#ifndef NEWVIS
staticfnc struct winding *ClipToSeperators(register struct winding *source, register struct winding *pass, register struct winding *target, register bool flipclip)
{
  int i, j, k, l;
  struct plane plane;
  vec3D v1, v2;
  vec1D d;
  vec1D length;
  int counts[3];
  bool fliptest;

  /* check all combinations        */
  for (i = 0; i < source->numpoints; i++) {
    l = (i + 1) % source->numpoints;
    VectorSubtract(source->points[l], source->points[i], v1);

    /*
     * fing a vertex of pass that makes a plane that puts all of the
     * vertexes of pass on the front side and all of the vertexes of
     * source on the back side
     */
    for (j = 0; j < pass->numpoints; j++) {
      VectorSubtract(pass->points[j], source->points[i], v2);

      plane.normal[0] = v1[1] * v2[2] - v1[2] * v2[1];
      plane.normal[1] = v1[2] * v2[0] - v1[0] * v2[2];
      plane.normal[2] = v1[0] * v2[1] - v1[1] * v2[0];

      /* if points don't make a valid plane, skip it */
      length = plane.normal[0] * plane.normal[0]
	+ plane.normal[1] * plane.normal[1]
	+ plane.normal[2] * plane.normal[2];

      if (length < ON_EPSILON)
	continue;

      length = 1 / sqrt(length);

      plane.normal[0] *= length;
      plane.normal[1] *= length;
      plane.normal[2] *= length;

      plane.dist = DotProduct(pass->points[j], plane.normal);

      /*
       * find out which side of the generated seperating plane has the
       * source portal
       */
      fliptest = FALSE;
      for (k = 0; k < source->numpoints; k++) {
	if (k == i || k == l)
	  continue;
	d = DotProduct(source->points[k], plane.normal) - plane.dist;
	if (d < -ON_EPSILON) {					/* source is on the negative side, so we want all */
	  /* pass and target on the positive side */
	  fliptest = FALSE;
	  break;
	}
	else if (d > ON_EPSILON) {				/* source is on the positive side, so we want all */
	  /* pass and target on the negative side */
	  fliptest = TRUE;
	  break;
	}
      }
      if (k == source->numpoints)
	continue;						/* planar with source portal */

      /* flip the normal if the source portal is backwards */
      if (fliptest) {
	VectorNegate(plane.normal);
	plane.dist = -plane.dist;
      }

      /*
       * if all of the pass portal points are now on the positive side,
       * this is the seperating plane
       */
      counts[0] = counts[1] = counts[2] = 0;
      for (k = 0; k < pass->numpoints; k++) {
	if (k == j)
	  continue;
	d = DotProduct(pass->points[k], plane.normal) - plane.dist;
	if (d < -ON_EPSILON)
	  break;
	else if (d > ON_EPSILON)
	  counts[0]++;
	else
	  counts[2]++;
      }
      if (k != pass->numpoints)
	continue;						/* points on negative side, not a seperating plane */

      if (!counts[0]) {
	continue;						/* planar with seperating plane */

      }

      /* flip the normal if we want the back side */
      if (flipclip) {
	VectorNegate(plane.normal);
	plane.dist = -plane.dist;
      }

      /* clip target by the seperating plane */
      target = ClipWinding(target, &plane, FALSE);
      if (!target)
	return NULL;						/* target is not visible */

    }
  }

  return target;
}
#else
staticfnc struct winding *ClipToSeperators(struct winding *SourceWinding, struct winding *PassWinding,
				 struct winding *TargetWinding, bool flipclip)
{
  int i, j, k, l;
  struct plane ClipPlane;
  vec3D v1, v2;
  vec1D d;
  vec1D length;
  bool ContFlag;
  bool fliptest;

  /*
   * Zero'th idea: Only one j point can make a candidate plane. (RVis).
   *
   * First idea: A good candidate for the next point, would be the same
   * point. ::: Didn't show up as an improvement.
   *
   * Second idea: If one combination of the points gives a planar test
   * agains the source portal, all points will (approximatly. Some might
   * not (the ON_EPSILON 'error'), but the planes constructed from this
   * is either behind the PassWinding (and will therefore not interfere with
   * the TargetWinding), or on the same side of PassWinding as the SourceWinding.
   * (In the last case, the plane will be rejected in any case).
   * I don't know if this logic is OK....
   * :::: Very very bad idea. Time went up, correctness went down.
   * Logic must have been broke....
   */

  /* check all combinations */
  for (i = 0; i < SourceWinding->numpoints; i++) {
    l = (i + 1) % SourceWinding->numpoints;
    /* We now have two points. Make a vector from them. (v1). */
    VectorSubtract(SourceWinding->points[l], SourceWinding->points[i], v1);

    /*
     * Find a vertex of PassWinding that makes a ClipPlane that puts all of the
     * vertexes of PassWinding on the front side and all of the vertexes of
     * SourceWinding on the back side
     */
    for (j = 0; (j < PassWinding->numpoints); j++) {
      /* Set j. Overflow rightly. */
      /*      j = (Next + Count)%PassWinding->numpoints; */

      /*
       * Make another vector from one point, and this point.
       * The two vectors now defines a plane. 
       */
      VectorSubtract(PassWinding->points[j], SourceWinding->points[i], v2);

      /* Define a plane normal, with the crossproduct. */
      ClipPlane.normal[0] = v1[1] * v2[2] - v1[2] * v2[1];
      ClipPlane.normal[1] = v1[2] * v2[0] - v1[0] * v2[2];
      ClipPlane.normal[2] = v1[0] * v2[1] - v1[1] * v2[0];

      /*
       * if points don't make a valid ClipPlane, skip it
       * Get the normals lenght
       */
      length = ClipPlane.normal[0] * ClipPlane.normal[0]
	+ ClipPlane.normal[1] * ClipPlane.normal[1]
	+ ClipPlane.normal[2] * ClipPlane.normal[2];
      /* If too small, skip it. */
      if (length < ON_EPSILON)
	continue;

      /* Normalize the plane. */
      length = 1 / sqrt(length);
      ClipPlane.normal[0] *= length;
      ClipPlane.normal[1] *= length;
      ClipPlane.normal[2] *= length;

      ClipPlane.dist = DotProduct(PassWinding->points[j], ClipPlane.normal);

      /*
       * find out which side of the generated seperating ClipPlane has the
       * SourceWinding portal
       */
      fliptest = FALSE;
      for (k = 0; k < SourceWinding->numpoints; k++) {
	if (k == i || k == l)
	  continue;
	d = DotProduct(SourceWinding->points[k], ClipPlane.normal) - ClipPlane.dist;
	if (d < -ON_EPSILON) {					/* SourceWinding is on the negative side, so we want all */
	  /* PassWinding and TargetWinding on the positive side */
	  fliptest = FALSE;
	  break;
	}
	else if (d > ON_EPSILON) {				/* SourceWinding is on the positive side, so we want all */
	  /* PassWinding and TargetWinding on the negative side */
	  fliptest = TRUE;
	  break;
	}
      }
      if (k == SourceWinding->numpoints)
	continue;						/* planar with SourceWinding portal */

      /* flip the normal if the SourceWinding portal is backwards */
      if (fliptest) {
	VectorSubtract(vec3_origin, ClipPlane.normal, ClipPlane.normal);
	ClipPlane.dist = -ClipPlane.dist;
      }

      /*
       * if all of the PassWinding portal points are now on the positive side,
       * this is the seperating ClipPlane
       *
       * We want t0 calculate further, if no points behind, and at least one in front
       */
      ContFlag = TRUE;

      for (k = 0; k < PassWinding->numpoints; k++) {
	if (k == j)
	  continue;
	d = DotProduct(PassWinding->points[k], ClipPlane.normal) - ClipPlane.dist;
	if (d < -ON_EPSILON) {
	  ContFlag = TRUE;
	  break;
	}
	/* If at least one point is above the plane, then */
	/* we can calculate. */
	else if (d > ON_EPSILON) {
	  ContFlag = FALSE;
	}
      }
      /*
       * We want to calculate further, if
       * a) No points with d < -ON_EPSILON
       * b) At least one point with non planar.
       */
      if (ContFlag)
	continue;

      /* flip the normal if we want the back side */
      if (flipclip) {
	VectorSubtract(vec3_origin, ClipPlane.normal, ClipPlane.normal);
	ClipPlane.dist = -ClipPlane.dist;
      }

      /* clip TargetWinding by the seperating ClipPlane */
      TargetWinding = ClipWinding(TargetWinding, &ClipPlane, FALSE);
      if (!TargetWinding)
	return NULL;						/* TargetWinding is not visible */
      /* RVIS modification.
       *
       * Observation:
       * For any given vector, beeing part of the SourceWinding, at most
       * one point in PassWinding, together with the vector, defines a uniqe
       * plane with all points of SourceWinding on one side, and all
       * points of PassWinding at the other.
       * There may be other points, that fullfill the criteria, but
       * the plane generated will be the same.
       * Therefore, further search is fruitless.
       */
      break;
    }								/* j For loop. */
  }								/* i for loop */
  return TargetWinding;
}
#endif

/*
 * ==================
 * RecursiveLeafFlow
 * 
 * Flood fill through the leafs
 * If src_portal is NULL, this is the originating leaf
 * ==================
 *
 * Called from PortalFlow.
 * This is a huge procedure, and probably the one that contains all the meat
 * of the program.
 * In here, the testlevel parameter is used.
 * ClipToSeperators are called testlevel times, with different parameters.
 */
staticfnc void RecursiveLeafFlow(register int leafnum, register threaddata_t * thread, register pstack_t * prevstack)
{
  pstack_t stack;
  struct visportal *p;
  struct plane backplane;
  struct winding *source, *target;
  struct visleaf *leaf;
  int i, j;

  /*
   * only on some systems "long int" is 64bits,
   * but on all "long long int" is 64bits
   */
  long long int *test, *might, *vis;
  bool more;

  c_chains++;

  leaf = leafs[leafnum];
  CheckStack(leaf, thread);

  /* mark the leaf as visible */
  if (!(thread->leafvis[leafnum >> 3] & (1 << (leafnum & 7)))) {
    thread->leafvis[leafnum >> 3] |= 1 << (leafnum & 7);
    thread->base->numcansee++;
  }

  prevstack->next = &stack;
  stack.next = NULL;
  stack.leaf = leaf;
  stack.portal = NULL;
  if (!(stack.mightsee = (unsigned char *)tmalloc(bitbytes)))
    Error(failed_memoryunsize, "bitbytes");
  might = (long long int *)stack.mightsee;
  vis = (long long int *)thread->leafvis;

  /* check all portals for flowing into other leafs        */
  for (i = 0; i < leaf->numportals; i++) {
    p = leaf->portals[i];

    if (!(prevstack->mightsee[p->leaf >> 3] & (1 << (p->leaf & 7)))) {
      c_leafskip++;
      continue;							/* can't possibly see it */

    }

    /* if the portal can't see anything we haven't allready seen, skip it */
    if (p->status == stat_done) {
      c_vistest++;
      test = (long long int *)p->visbits;
    }
    else {
      c_mighttest++;
      test = (long long int *)p->mightsee;
    }
    more = FALSE;
    for (j = 0; j < bitlongs; j++) {
      might[j] = ((long long int *)prevstack->mightsee)[j] & test[j];
      if (might[j] & ~vis[j])
	more = TRUE;
    }

    if (!more) {						/* can't see anything new */

      c_portalskip++;
      continue;
    }

    /* get plane of portal, point normal into the neighbor leaf */
    stack.portalplane = p->plane;
    VectorNegateTo(p->plane.normal, backplane.normal);
    backplane.dist = -p->plane.dist;

    if (VectorCompare(prevstack->portalplane.normal, backplane.normal))
      continue;							/* can't go out a coplanar face */

    c_portalcheck++;

    stack.portal = p;
    stack.next = NULL;

    target = ClipWinding(p->winding, &thread->pstack_head.portalplane, FALSE);
    if (!target)
      continue;

    if (!prevstack->pass) {					/* the second leaf can only be blocked if coplanar */
      stack.source = prevstack->source;
      stack.pass = target;
      RecursiveLeafFlow(p->leaf, thread, &stack);
      FreeWinding(target);
      continue;
    }

    target = ClipWinding(target, &prevstack->portalplane, FALSE);
    if (!target)
      continue;

    source = CopyWinding(prevstack->source);
    source = ClipWinding(source, &backplane, FALSE);
    if (!source) {
      FreeWinding(target);
      continue;
    }

    c_portaltest++;

    if (testvislevel > 0) {
      target = ClipToSeperators(source, prevstack->pass, target, FALSE);
      if (!target) {
	FreeWinding(source);
	continue;
      }
    }

    if (testvislevel > 1) {
      target = ClipToSeperators(prevstack->pass, source, target, TRUE);
      if (!target) {
	FreeWinding(source);
	continue;
      }
    }

    if (testvislevel > 2) {
      source = ClipToSeperators(target, prevstack->pass, source, FALSE);
      if (!source) {
	FreeWinding(target);
	continue;
      }
    }

    if (testvislevel > 3) {
      source = ClipToSeperators(prevstack->pass, target, source, TRUE);
      if (!source) {
	FreeWinding(target);
	continue;
      }
    }

    /*
     * The reason why, this level, and > 3 is beeing run, is because "non-aligned"
     * portals will generate different planes
     * This also means, that "aligned" portals, need not run this.
     * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     * Since a great deal IS aligned, it might be worth trying!!!
     */
    stack.source = source;
    stack.pass = target;

    c_portalpass++;

    /* flow through it for real */
    RecursiveLeafFlow(p->leaf, thread, &stack);

    FreeWinding(source);
    FreeWinding(target);
  }

  tfree(stack.mightsee);
}

/*
 * ===============
 * PortalFlow
 * 
 * ===============
 */
staticfnc void PortalFlow(register struct visportal *p)
{
  threaddata_t data;

  if (p->status != stat_working)
    Error("PortalFlow: reflowed\n");
  p->status = stat_working;

  if (!(p->visbits = (unsigned char *)kmalloc(bitbytes)))
    Error(failed_memoryunsize, "bitbytes");

  __bzero(&data, sizeof(data));
  data.leafvis = p->visbits;
  data.base = p;

  data.pstack_head.portal = p;
  data.pstack_head.source = p->winding;
  data.pstack_head.portalplane = p->plane;
  data.pstack_head.mightsee = p->mightsee;

  RecursiveLeafFlow(p->leaf, &data, &data.pstack_head);

  p->status = stat_done;
}

/*
 * ===============================================================================
 * This is a rough first-order aproximation that is used to trivially reject some
 * of the final calculations.
 * ===============================================================================
 *
 * This procedure flows out of a source leaf entering from portal scrportal.
 * First, the portal's mightsee array is set to 1, for the leafnum leaf
 * Then, for each portal leaving the leaf, it is checked if the srcportal can see
 * this portal. If that is the case, the procedure is called recursively.
 */

staticfnc void SimpleFlood(register struct visportal *srcportal, register int leafnum)
{
  int i;
  struct visleaf *leaf;
  struct visportal *p;

  /* Catchs circular references. */
  if (srcportal->mightsee[leafnum >> 3] & (1 << (leafnum & 7)))
    return;
  /* Set the current leaf to visible. */
  srcportal->mightsee[leafnum >> 3] |= (1 << (leafnum & 7));
  c_leafsee++;

  /* Get the portals leaving this leaf. */
  leaf = leafs[leafnum];

  /* Check each portal away from leaf */
  for (i = 0; i < leaf->numportals; i++) {
    p = leaf->portals[i];
    /* If the portal is visible from srcportal */
    if (!portalsee[p - portals])
      continue;
    /* then call recursivly. */
    SimpleFlood(srcportal, p->leaf);
  }
}

/*
 * ==============
 * BasePortalVis
 * ==============
 * 
 * It performs a trivial reject of some portal connections.
 * The criteria is, that one portal has to be able to look through, in the
 * loosest sense, another portal.
 * In effect, this means, that portal b need to be in front of a, and portal
 * a need to be behind b.
 */
#ifndef NEWVIS
#define	BasePortalVis_1 BasePortalVis
#define	BasePortalVis_2 BasePortalVis
#define	BasePortalVis_3 BasePortalVis
#define	BasePortalVis_4 BasePortalVis
staticfnc void BasePortalVis(void)
{
  int i, j, k;
  struct visportal *tp, *p;
  vec1D d;
  struct winding *w;

  for (i = 0, p = portals; i < num_visportals * 2; i++, p++) {
    if (!(p->mightsee = (unsigned char *)kmalloc(bitbytes)))
      Error(failed_memoryunsize, "bitbytes");
    c_portalsee = 0;
    portalsee = kmalloc(num_visportals * 2 * sizeof(unsigned char)); /* __bzero(portalsee, num_visportals * 2); */

    for (j = 0, tp = portals; j < num_visportals * 2; j++, tp++) {
      if (j == i)
	continue;
      w = tp->winding;
      for (k = 0; k < w->numpoints; k++) {
	d = DotProduct(w->points[k], p->plane.normal) - p->plane.dist;
	if (d > ON_EPSILON)
	  break;
      }
      if (k == w->numpoints)
	continue;						/* no points on front */

      w = p->winding;
      for (k = 0; k < w->numpoints; k++) {
	d = DotProduct(w->points[k], tp->plane.normal) - tp->plane.dist;
	if (d < -ON_EPSILON)
	  break;
      }
      if (k == w->numpoints)
	continue;						/* no points on front */

      portalsee[j] = 1;
      c_portalsee++;

    }

    c_leafsee = 0;
    SimpleFlood(p, p->leaf);
    p->nummightsee = c_leafsee;
  }
}
#else
/*
 * PortalFrontPortal returns true if at least one of the points of TestPortals
 * windings is in front if SourcePortal
 */
staticfnc bool PortalFrontBackPortal_3(struct visportal *SourcePortal, struct visportal *TestPortal)
{
  int i;
  vec1D d;
  struct winding *Winding;

  /* Test front */
  Winding = TestPortal->winding;
  for (i = 0; i < Winding->numpoints; i++) {
    d = DotProduct(Winding->points[i], SourcePortal->plane.normal)
      - SourcePortal->plane.dist;
    if (d > ON_EPSILON)						/* Test if back */
      break;
  }
  if (i == Winding->numpoints)
    return FALSE;
  /* Test back */
  Winding = SourcePortal->winding;
  for (i = 0; i < Winding->numpoints; i++) {
    d = DotProduct(Winding->points[i], TestPortal->plane.normal)
      - TestPortal->plane.dist;
    if (d < -ON_EPSILON)
      return TRUE;
  }
  return FALSE;
}								/* PortalFrontPortal */

/*
 * 4:
 * This version of BasePortalVis uses a DFS approach to find the
 * mightsee set.
 * Besides that, it also uses a stronger test-criterium to lower
 * the upper limit recorded in the mightsee set.
 */
/* For now; allocate a hell of a lot of pointers; */

staticvar struct visportal *ThroughPortals[MAX_MAP_PORTALS];
staticvar int ThroughCount;

/* Returns true, if NOT in array. */
staticfnc bool PortalCircularCheck(struct visportal *TestPortal)
{
  int k;

  for (k = 0; k < ThroughCount; k++)
    if (ThroughPortals[k] == TestPortal)
      return FALSE;
  return TRUE;
}

/* Test TestPortal with all portals in ThroughPortals */
staticfnc bool PortalThroughPortals_4(struct visportal * TestPortal)
{
  int k;

  for (k = 0; k < ThroughCount; k++)
    if (!(PortalFrontBackPortal_3(ThroughPortals[k], TestPortal)))
      return FALSE;
  return TRUE;
}

/*
 * PortalThroughLeaf_4 returns TRUE, IF all portals leaving leafnum,
 * does not fullfill the standard test criterium.
 */
staticfnc void PortalThroughLeaf_4(int leafnum, bool LastOut)
{
  int i;

  struct visleaf *leaf;
  struct visportal *TestPortal;
  bool IsLast;

  /* Catchs circular references. */
  if (ThroughPortals[0]->mightsee[leafnum >> 3] & (1 << (leafnum & 7)))
    return;
  /* Set the current leaf to visible. */
  ThroughPortals[0]->mightsee[leafnum >> 3] |= (1 << (leafnum & 7));
  c_leafsee++;
  /* Get the portals leaving this leaf. */
  leaf = &leafs[leafnum];
  for (i = 0; i < leaf->numportals; i++) {			/* Check each portal away from leaf */
    TestPortal = leaf->portals[i];
    if (LastOut) {						/* Can use strict testing. */
      if (PortalThroughPortals_4(TestPortal)) {
	if (i == (leaf->numportals - 1))
	  IsLast = TRUE;
	else
	  IsLast = FALSE;
	ThroughPortals[ThroughCount++] = TestPortal;
	PortalThroughLeaf_4(TestPortal->leaf, IsLast);		/* then call recursivly. */
	ThroughCount--;
      }
    }
    else {							/* Can not use strict testing. */
      if (PortalFrontBackPortal_3(ThroughPortals[0], TestPortal)) {
	ThroughPortals[ThroughCount++] = TestPortal;
	PortalThroughLeaf_4(TestPortal->leaf, FALSE);
	ThroughCount--;
      }
    }
  }								/* For each portal */
}								/* PortalThroughLeaf(...) */

/* Simply call PortalFollowPortals for each portal. */
staticfnc void BasePortalVis_4(void)
{
  int i;
  struct visportal *SourcePortal;

  /* For each portal            repeat */
  for (i = 0, SourcePortal = portals; i < numportals * 2; i++, SourcePortal++) {
    /* Allocate memory to the mightsee array */
    SourcePortal->mightsee = kmalloc(bitbytes);	/* __bzero(SourcePortal->mightsee, bitbytes); */
    /* SimpleFloof tags all the leafs, that SourcePortal might see. */
    ThroughPortals[0] = SourcePortal;
    ThroughCount = 1;
    c_leafsee = 0;
    PortalThroughLeaf_4(SourcePortal->leaf, TRUE);
    SourcePortal->nummightsee = c_leafsee;
  }								/* For each portal */
}

/*
 * 3:
 * This version of BasePortalVis uses a DFS approach to find the
 * mightsee set.
 * It thereby hopes, that it can perform fewer calculations than
 * the standard version. It could result in -worse- performance,
 * but so far, it has been running in 35-55% of original time.
 * It uses a helper funtion, that appears first:
 */
staticfnc void PortalThroughLeaf_3(struct visportal *SourcePortal, int leafnum)
{
  int i;
  struct visleaf *leaf;
  struct visportal *TestPortal;

  /* Catchs circular references. */
  if (SourcePortal->mightsee[leafnum >> 3] & (1 << (leafnum & 7)))
    return;
  /* Set the current leaf to visible. */
  SourcePortal->mightsee[leafnum >> 3] |= (1 << (leafnum & 7));
  c_leafsee++;
  /* Get the portals leaving this leaf. */
  leaf = &leafs[leafnum];
  for (i = 0; i < leaf->numportals; i++) {			/* Check each portal away from leaf */
    TestPortal = leaf->portals[i];
    if (PortalFrontBackPortal_3(SourcePortal, TestPortal))
      PortalThroughLeaf_3(SourcePortal, TestPortal->leaf);	/* then call recursivly. */
  }
}								/* PortalThroughLeaf(...) */

/* Simply call PortalFollowPortals for each portal. */
staticfnc void BasePortalVis_3(void)
{
  int i;
  struct visportal *SourcePortal;				/*, EndPortal; */

  /* For each portal            repeat */
  for (i = 0, SourcePortal = portals; i < numportals * 2; i++, SourcePortal++) {
    /* Allocate memory to the mightsee array */
    SourcePortal->mightsee = kmalloc(bitbytes);	/* __bzero(SourcePortal->mightsee, bitbytes); */
    c_leafsee = 0;
    /* SimpleFloof tags all the leafs, that SourcePortal might see. */
    PortalThroughLeaf_3(SourcePortal, SourcePortal->leaf);
    SourcePortal->nummightsee = c_leafsee;
  }								/* For each portal */

}

/*
 * 2:
 * This is the first modified version of baseportal vis.
 * Some algoritmic improvements, based on the observation, that for i even, the
 * points of the windings of portal i and i+1 are the same.
 * It runs in approc 66-75% of the time the standard needs.
 * 
 */
staticfnc void BasePortalVis_2(void)
{								/* Faster then standard, one row, same result */
  int i, j, k;
  struct visportal *TestPortal, *SourcePortal;
  vec1D d;
  struct winding *w;
  bool TP1, TP2;

  /*
   * For each global Portal, we check if it might be able to see TestPortal
   * Information is stored in the portalsee array.
   */
  for (i = 0, SourcePortal = portals; i < numportals * 2; i++, SourcePortal++) {
    c_portalsee = 0;						/* This is how many other portals, p can see. */
    portalsee = kmalloc(numportals * 2 * sizeof(unsigned char)); /* __bzero(portalsee, numportals * 2); */ /* We clear the array. */

    /*
     * For each other portal, test if SourcePortal might be able to see it.
     * Very loose bound. Front/Back
     * Since the points of j and j+1 are the same, when j are even, some
     * calculations can be spared. 
     */
    for (j = 0, TestPortal = portals;
	 j < numportals * 2;
	 j++, j++, TestPortal++, TestPortal++) {
      if (i == j)						/* This only catches i even, i=j and i=j+1 */
	continue;
      /* First, check if any point from TestPortal is in front of SourcePortal */
      w = TestPortal->winding;
      for (k = 0; k < w->numpoints; k++) {
	d = DotProduct(w->points[k], SourcePortal->plane.normal) - SourcePortal->plane.dist;
	if (d > ON_EPSILON)
	  break;
      }
      if (k == w->numpoints) {
	/* Same points, so same test will fail. */
	continue;						/* no points on front */
      }
      /*
       * If we reached here, for j = x, j even, then we are also
       * going to reach this point for j = x + 1, since same points.
       * And vice versa, the other way around. If we did NOT reach here,
       * for j = x, j even, we are NOT going to get here for j = x + 1
       * 
       * Reaching this point, means that SourcePortal can see either
       * TestPortal, or TestPortal++
       */
      /* Now check, if SourcePortal is behind TestPortal */
      TP1 = TP2 = FALSE;
      w = SourcePortal->winding;
      for (k = 0; k < w->numpoints; k++) {
	d = DotProduct(w->points[k], TestPortal->plane.normal) - TestPortal->plane.dist;
	if (d < -ON_EPSILON)
	  TP1 = TRUE;
	else if (d > ON_EPSILON)
	  TP2 = TRUE;
	if (TP1 && TP2)
	  break;
      }
      if (TP1) {
	portalsee[j] = 1;
	c_portalsee++;
      }
      /* We never want to set the portal to see it self. */
      if (i == j + 1)
	continue;						/* This catches the odd i's, with i == j */
      /* Check, if SourcePortal is behind TestPortal++ */

      if (TP2) {
	portalsee[j + 1] = 1;
	c_portalsee++;
      }
    }								/* End of TestPortal loop. */

    c_leafsee = 0;						/* */
    /* Allocate space for the mightsee array. Filled by SimpleFlood */
    SourcePortal->mightsee = kmalloc(bitbytes);	/* __bzero(SourcePortal->mightsee, bitbytes); */
    /* SimpleFloof tags all the leafs, that SourcePortal might see. */
    SimpleFlood(SourcePortal, SourcePortal->leaf);
    SourcePortal->nummightsee = c_leafsee;
  }
}

/* This is the standard, but commented, version of BasePortalVis */
staticfnc void BasePortalVis_1(void)
{								/* Standard */
  int i, j, k;
  struct visportal *tp, *p;
  vec1D d;
  struct winding *w;

  /* portals are the global portal array */
  for (i = 0, p = portals; i < numportals * 2; i++, p++) {
    p->mightsee = kmalloc(bitbytes); /* __bzero(p->mightsee, bitbytes); */

    /* portalsee is delared in this file. */
    c_portalsee = 0;						/* This is how many other portals, p can see. */
    portalsee = kmalloc(numportals * 2 * sizeof(unsigned char)); /* __bzero(portalsee, numportals * 2); */ /* We clear the array. */

    for (j = 0, tp = portals; j < numportals * 2; j++, tp++) {
      if (j == i)
	continue;
      w = tp->winding;
      /*
       * This for loop, apparently, checks if there is a point on the tp
       * winding, that is in front of the p plane.
       */
      for (k = 0; k < w->numpoints; k++) {
	d = DotProduct(w->points[k], p->plane.normal) - p->plane.dist;
	if (d > ON_EPSILON)
	  break;
      }
      if (k == w->numpoints)
	continue;						/* no points on front */
      /*
       * The skipping here, must be because we have determined, that
       * no points of the portal we checked against lies in 'the direction' in
       * which we look.
       *
       * Same check for the other way around.
       * No! This check must be for be for BEHIND!
       */
      w = p->winding;
      for (k = 0; k < w->numpoints; k++) {
	d = DotProduct(w->points[k], tp->plane.normal) - tp->plane.dist;
	if (d < -ON_EPSILON)
	  break;
      }
      if (k == w->numpoints)
	continue;						/* no points on front <== Must be BACK! */

      /* If we reached this far, portal p (i) can se portal tp (j) */
      portalsee[j] = 1;
      c_portalsee++;

    }
    c_leafsee = 0;						/* */
    SimpleFlood(p, p->leaf);
    p->nummightsee = c_leafsee;
  }
}
#endif

/*
 * 
 * Some textures (sky, water, slime, lava) are considered ambien sound emiters.
 * Find an aproximate distance to the nearest emiter of each class for each leaf.
 * 
 */

/*
 * ====================
 * SurfaceBBox
 * 
 * ====================
 */
staticfnc void SurfaceBBox(bspBase bspMem, register struct dface_t *s, register vec3D mins, register vec3D maxs)
{
  int i;
  short int j;
  int e;
  int vi;
  vec1D *v;

  mins[0] = mins[1] = VEC_POSMAX;
  maxs[0] = maxs[1] = VEC_NEGMAX;

  for (i = 0; i < s->numedges; i++) {
    e = bspMem->shared.quake1.dsurfedges[s->firstedge + i];
    if (e >= 0)
      vi = bspMem->shared.quake1.dedges[e].v[0];
    else
      vi = bspMem->shared.quake1.dedges[-e].v[1];
    v = bspMem->shared.quake1.dvertexes[vi].point;

    for (j = 0; j < 3; j++) {
      if (v[j] < mins[j])
	mins[j] = v[j];
      if (v[j] > maxs[j])
	maxs[j] = v[j];
    }
  }
}

/*
 * ====================
 * CalcAmbientSounds
 * 
 * ====================
 */
staticfnc void CalcAmbientSounds(bspBase bspMem)
{
  int i, j, k;
  short int l;
  struct dleaf_t *leaf, *hit;
  unsigned char *vis;
  struct dface_t *surf;
  vec3D mins, maxs;
  vec1D d, maxd;
  int ambient_type;
  struct texinfo *info;
  struct mipmap *miptex;
  int ofs;
  vec1D dists[NUM_AMBIENTS];
  vec1D vol;

  for (i = 0; i < num_visleafs; i++) {
    leaf = &bspMem->shared.quake1.dleafs[i + 1];

    /* clear ambients */
    for (j = 0; j < NUM_AMBIENTS; j++)
      dists[j] = 1020;

    vis = &uncompressed[i * bitbytes];

    for (j = 0; j < num_visleafs; j++) {
      if (!(vis[j >> 3] & (1 << (j & 7))))
	continue;

      /* check this leaf for sound textures */
      hit = &bspMem->shared.quake1.dleafs[j + 1];

      for (k = 0; k < hit->nummarksurfaces; k++) {
	surf = &bspMem->shared.quake1.dfaces[bspMem->shared.quake1.dmarksurfaces[hit->firstmarksurface + k]];
	info = &bspMem->shared.quake1.texinfo[surf->texinfo];
	ofs = ((struct dmiptexlump_t *)bspMem->shared.quake1.dtexdata)->dataofs[info->miptex];
	miptex = (struct mipmap *)(&bspMem->shared.quake1.dtexdata[ofs]);

	if (isSky(miptex->name))
	  ambient_type = AMBIENT_SKY;
	else if (isSlime(miptex->name))
	  ambient_type = AMBIENT_SLIME;				/* AMBIENT_SLIME; */
	else if (isLava(miptex->name))
	  ambient_type = AMBIENT_LAVA;
	else if (isWarp(miptex->name))
	  ambient_type = AMBIENT_WATER;
	else
	  continue;

	/* find distance from source leaf to polygon */
	SurfaceBBox(bspMem, surf, mins, maxs);
	maxd = 0;
	for (l = 0; l < 3; l++) {
	  if (mins[l] > leaf->maxs[l])
	    d = mins[l] - leaf->maxs[l];
	  else if (maxs[l] < leaf->mins[l])
	    d = leaf->mins[l] - mins[l];
	  else
	    d = 0;
	  if (d > maxd)
	    maxd = d;
	}

	maxd = 0.25;
	if (maxd < dists[ambient_type])
	  dists[ambient_type] = maxd;
      }
    }

    for (j = 0; j < NUM_AMBIENTS; j++) {
      if (dists[j] < 100)
	vol = 1.0;
      else {
	vol = 1.0 - dists[2] * 0.002;
	if (vol < 0)
	  vol = 0;
      }
      leaf->ambient_level[j] = vol * 255;
    }
    mprogress(num_visleafs, i + 1);
  }
}

/*============================================================================= */

/*
 * =============
 * GetNextPortal
 * 
 * Returns the next portal for a thread to work on
 * Returns the portals from the least complex, so the later ones can reuse
 * the earlier information.
 * =============
 */
staticfnc struct visportal *GetNextPortal(void)
{
  int j;
  struct visportal *p, *tp;
  int min;

  min = 999999;
  p = NULL;

  /*
   * Finds the portal with the minimum mightsee number.
   * This operation is probably done quite a few times.
   * So maybe a data structure to update this information
   * would be appropiate? (min heap?)
   * Also, all portals are seeked. If there is no way a portal
   * can stop having status = stat_done, then it would be faster
   * to have another datastructure.
   */
  for (j = 0, tp = portals; j < num_visportals * 2; j++, tp++) {
    if (tp->nummightsee < min && tp->status == stat_none) {
      min = tp->nummightsee;
      p = tp;
    }
  }

  if (p)
    p->status = stat_working;

  return p;
}

/*
 * ===============
 * CompressRow
 * 
 * ===============
 */
staticfnc int CompressRow(register unsigned char *vis, register unsigned char *dest)
{
  int j;
  int rep;
  int visrow;
  unsigned char *dest_p;

  dest_p = dest;
  visrow = (num_visleafs + 7) >> 3;

  for (j = 0; j < visrow; j++) {
    *dest_p++ = vis[j];
    if (vis[j])
      continue;

    rep = 1;
    for (j++; j < visrow; j++)
      if (vis[j] || rep == 255)
	break;
      else
	rep++;
    *dest_p++ = rep;
    j--;
  }

  return dest_p - dest;
}

/*
 * =============
 * SortPortals
 * 
 * Sorts the portals from the least complex, so the later ones can reuse
 * the earlier information.
 * =============
 */
/*
 * int PComp(register struct visportal *a, register struct visportal *b)
 * {
 * if (a->nummightsee == b->nummightsee)
 * return 0;
 * if (a->nummightsee < b->nummightsee)
 * return -1;
 * return 1;
 * }
 * 
 * void SortPortals(void)
 * {
 * heapsort(portals, num_visportals * 2, sizeof(struct visportal), PComp);
 * }
 */

/*
 * ===============
 * LeafFlow
 * 
 * Builds the entire visibility list for a leaf
 * ===============
 */
staticfnc void LeafFlow(bspBase bspMem, register int leafnum)
{
  struct visleaf *leaf;
  unsigned char *outbuffer;
  unsigned char compressed[MAX_MAP_LEAFS / 8];
  int i, j;
  int numvis;
  struct visportal *p;

  /* flow through all portals, collecting visible bits */
  outbuffer = uncompressed + leafnum * bitbytes;
  /* Get a pointer to the leafnum leaf */
  leaf = leafs[leafnum];
  /* Iterate over all portals leaving this leaf. */
  for (i = 0; i < leaf->numportals; i++) {
    p = leaf->portals[i];
    if (p->status != stat_done)
      Error("portal not done\n");
    /* Or the leafs visible from this portal to the outbuffer */
    for (j = 0; j < bitbytes; j++)
      outbuffer[j] |= p->visbits[j];
  }

  /* Checks if the source leaf is visible from this leaf. */
  if (outbuffer[leafnum >> 3] & (1 << (leafnum & 7)))
    Error("Leaf portals saw into leaf\n");

  /* Writes the leaf itself to the visible array. */
  outbuffer[leafnum >> 3] |= (1 << (leafnum & 7));

  /* Collects statistical info. */
  numvis = 0;
  for (i = 0; i < num_visleafs; i++)
    if (outbuffer[i >> 3] & (1 << (i & 3)))
      numvis++;

  /* compress the bit string */
  if (bspMem->visOptions & VIS_VERBOSE)
    mprintf("----- leaf %4i ---------\n%5i visible\n", leafnum, numvis);
  totalvis += numvis;

  /* Compress the row to the "compressed" array. */
  i = CompressRow(outbuffer, compressed);

  if ((bspMem->shared.quake1.visdatasize + i) > bspMem->shared.quake1.max_visdatasize)
    ExpandBSPClusters(bspMem, LUMP_VISIBILITY);
  memcpy(bspMem->shared.quake1.dvisdata + bspMem->shared.quake1.visdatasize, compressed, i);
  bspMem->shared.quake1.dleafs[leafnum + 1].visofs = bspMem->shared.quake1.visdatasize;		/* leaf 0 is a common solid */
  bspMem->shared.quake1.visdatasize += i;
}

/*
 * ==================
 * CalcPortalVis
 * ==================
 */
staticfnc void CalcPortalVis(bspBase bspMem)
{
  int i;
  struct visportal *p;

  /* fastvis just uses mightsee for a very loose bound */
  if (bspMem->visOptions & VIS_FAST) {
    for (i = 0; i < num_visportals * 2; i++) {
      portals[i].visbits = portals[i].mightsee;
      portals[i].status = stat_done;
    }
    return;
  }

  leafon = 0;

  while ((p = GetNextPortal())) {
    PortalFlow(p);
    if (bspMem->visOptions & VIS_VERBOSE)
      mprintf("----- portal %4i -------\n %5i mightsee\n%5i cansee\n", (int)(p - portals), p->nummightsee, p->numcansee);
  }

  if (bspMem->visOptions & VIS_VERBOSE) {
    mprintf("%5i portalcheck\n%5i portaltest\n%5i portalpass\n", c_portalcheck, c_portaltest, c_portalpass);
    mprintf("%5i c_vistest\n%5i c_mighttest\n", c_vistest, c_mighttest);
  }

}

/*
 * ==================
 * CalcVis
 * ==================
 */
staticfnc void CalcVis(bspBase bspMem)
{
  int i;

  switch (testvisfastlevel) {
    case 1:
      BasePortalVis_1();
      break;
    case 2:
      BasePortalVis_2();
      break;
    case 3:
      BasePortalVis_3();
      break;
    case 4:
      BasePortalVis_4();
      break;
    default:
      BasePortalVis_3();
      break;
  }

  /*SortPortals(); */
  CalcPortalVis(bspMem);

  /* assemble the leaf vis lists by oring and compressing the portal lists */
  for (i = 0; i < num_visleafs; i++) {
    LeafFlow(bspMem, i);
    mprogress(num_visleafs, i + 1);
  }

  mprintf("%5i average leafs visible\n", totalvis / num_visleafs);
}

/*
 * ==============================================================================
 * 
 * PASSAGE CALCULATION (not used yet...)
 * 
 * ==============================================================================
 */

staticfnc bool PlaneCompare(register struct plane *p1, register struct plane *p2)
{
  int i;

  if (fabs(p1->dist - p2->dist) > 0.01)
    return FALSE;

  for (i = 0; i < 3; i++)
    if (fabs(p1->normal[i] - p2->normal[i]) > 0.001)
      return FALSE;

  return TRUE;
}

staticfnc struct seperatingplane *Findpassages(register struct winding *source, register struct winding *pass)
{
  int i, j, k, l;
  struct plane plane;
  vec3D v1, v2;
  vec1D d;
  vec1D length;
  int counts[3];
  bool fliptest;
  struct seperatingplane *sep, *list;

  list = NULL;

  /* check all combinations        */
  for (i = 0; i < source->numpoints; i++) {
    l = (i + 1) % source->numpoints;
    VectorSubtract(source->points[l], source->points[i], v1);

    /*
     * fing a vertex of pass that makes a plane that puts all of the
     * vertexes of pass on the front side and all of the vertexes of
     * source on the back side
     */
    for (j = 0; j < pass->numpoints; j++) {
      VectorSubtract(pass->points[j], source->points[i], v2);

      plane.normal[0] = v1[1] * v2[2] - v1[2] * v2[1];
      plane.normal[1] = v1[2] * v2[0] - v1[0] * v2[2];
      plane.normal[2] = v1[0] * v2[1] - v1[1] * v2[0];

      /* if points don't make a valid plane, skip it */

      length = plane.normal[0] * plane.normal[0]
	+ plane.normal[1] * plane.normal[1]
	+ plane.normal[2] * plane.normal[2];

      if (length < ON_EPSILON)
	continue;

      length = 1 / sqrt(length);

      plane.normal[0] *= length;
      plane.normal[1] *= length;
      plane.normal[2] *= length;

      plane.dist = DotProduct(pass->points[j], plane.normal);

      /*
       * find out which side of the generated seperating plane has the 
       * source portal
       */
      fliptest = FALSE;
      for (k = 0; k < source->numpoints; k++) {
	if (k == i || k == l)
	  continue;
	d = DotProduct(source->points[k], plane.normal) - plane.dist;
	if (d < -ON_EPSILON) {					/* source is on the negative side, so we want all */
	  /* pass and target on the positive side */

	  fliptest = FALSE;
	  break;
	}
	else if (d > ON_EPSILON) {				/* source is on the positive side, so we want all */
	  /* pass and target on the negative side */

	  fliptest = TRUE;
	  break;
	}
      }
      if (k == source->numpoints)
	continue;						/* planar with source portal */

      /* flip the normal if the source portal is backwards */
      if (fliptest) {
	VectorNegate(plane.normal);
	plane.dist = -plane.dist;
      }

      /*
       * if all of the pass portal points are now on the positive side,
       * this is the seperating plane
       */
      counts[0] = counts[1] = counts[2] = 0;
      for (k = 0; k < pass->numpoints; k++) {
	if (k == j)
	  continue;
	d = DotProduct(pass->points[k], plane.normal) - plane.dist;
	if (d < -ON_EPSILON)
	  break;
	else if (d > ON_EPSILON)
	  counts[0]++;
	else
	  counts[2]++;
      }
      if (k != pass->numpoints)
	continue;						/* points on negative side, not a seperating plane */

      if (!counts[0])
	continue;						/* planar with pass portal */

      /* save this out */
      count_sep++;

      if (!(sep = (struct seperatingplane *)kmalloc(sizeof(struct seperatingplane))))
	  Error(failed_memoryunsize, "seperate plane");

      sep->next = list;
      list = sep;
      sep->plane = plane;
    }
  }

  return list;
}

/*
 * ============
 * CalcPassages
 * ============
 */
staticfnc void CalcPassages(void)
{
  int i, j, k;
  int count, count2;
  struct visleaf *l;
  struct visportal *p1, *p2;
  struct seperatingplane *sep;
  struct passage *passages;

  mprintf("    - building passages...\n");

  count = count2 = 0;
  for (i = 0; i < num_visleafs; i++) {
    l = leafs[i];

    for (j = 0; j < l->numportals; j++) {
      p1 = l->portals[j];
      for (k = 0; k < l->numportals; k++) {
	if (k == j)
	  continue;

	count++;
	p2 = l->portals[k];

	/* definately can't see into a coplanar portal */
	if (PlaneCompare(&p1->plane, &p2->plane))
	  continue;

	count2++;

	sep = Findpassages(p1->winding, p2->winding);
	if (!sep) {
	  count_sep++;
	  if (!(sep = (struct seperatingplane *)kmalloc(sizeof(struct seperatingplane))))
	      Error(failed_memoryunsize, "seperate plane");

	  sep->next = NULL;
	  sep->plane = p1->plane;
	}
	if (!(passages = (struct passage *)kmalloc(sizeof(struct passage))))
	    Error(failed_memoryunsize, "passage");

	passages->planes = sep;
	passages->from = p1->leaf;
	passages->to = p2->leaf;
	passages->next = l->passages;
	l->passages = passages;
      }
    }
  }

  mprintf("%5i numpassages (%i)\n", count2, count);
  mprintf("%5i total passages\n", count_sep);
}

/*============================================================================= */

bool vis(bspBase bspMem, int level, char *prtBuf)
{
  int i;

  mprintf("----- Vis ---------------\n");

  AllocBSPClusters(bspMem, LUMP_VISIBILITY);

  if (!(bspMem->visOptions & VIS_MEM))
    LoadPortals(prtBuf);
  if (level)
    testvislevel = level;

  originalvismapsize = num_visportals * ((num_visportals + 7) / 8);
  bitbytes = ((num_visportals + 63) & ~63) >> 3;
  bitlongs = bitbytes / sizeof(long long int);

  if (!(uncompressed = (unsigned char *)kmalloc(bitbytes * num_visleafs)))
    Error(failed_memoryunsize, "bitbytes");

  mprintf("----- CalcVis -----------\n");
/*CalcPassages (); */
  CalcVis(bspMem);

  mprintf("%5i c_chains\n", c_chains);
  mprintf("%5i visdatasize (compressed from %i)\n", bspMem->shared.quake1.visdatasize, originalvismapsize);

  mprintf("----- CalcAmbientSounds -\n");
  CalcAmbientSounds(bspMem);

  for (i = 0; i < num_visleafs; i++)
    if (leafs[i])
      FreeLeaf(leafs[i]);
  for (i = 0; i < (num_visportals * 2); i++)
    if (portals[i].winding);
  FreeWinding(portals[i].winding);
  tfree(leafs);
  tfree(portals);
  kfree();

  return TRUE;
}
