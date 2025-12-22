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

#ifndef	BSP_H
#define	BSP_H

/*
 * ============================================================================
 * structures
 * ============================================================================
 */

/* upper design bounds */
#define	MAX_MAP_HULLS		4
#define	MAX_HULL_POINTS		32
#define	MAX_HULL_EDGES		64

#define	MAGIC_BSP_Q2		MKID('I','B','S','P')	/* 0x49425350 */

#define BSP_VERSION_Q1		29
#define BSP_VERSION_Q2		38

struct dmodel_t {
  float mins[3], maxs[3];
  float origin[3];
  int headnode[MAX_MAP_HULLS];
  /* not including the solid leaf 0 */
  int visleafs;
  int firstface, numfaces;
};

struct dmodel2_t {
  float mins[3], maxs[3];
  /* for sounds or lights */
  float origin[3];
  int headnode;
  /*
   * submodels just draw faces
   * without walking the bsp tree
   */
  int firstface, numfaces;
};

struct dmiptexlump_t {
  int nummiptex;
  /* [nummiptex] */
  int dataofs[4];
};

struct dvertex_t {
  float point[3];
};

/* 0-2 are axial planes */
#define	PLANE_X			0
#define	PLANE_Y			1
#define	PLANE_Z			2

/* 3-5 are non-axial planes snapped to the nearest */
#define	PLANE_ANYX		3
#define	PLANE_ANYY		4
#define	PLANE_ANYZ		5

/* planes (x&~1) and (x&~1)+1 are allways opposites */

struct dplane_t {
  float normal[3];
  float dist;
  /* PLANE_X - PLANE_ANYZ ?remove? trivial to regenerate */
  int type;
};

/*
 * contents flags are seperate bits
 * a given brush can contribute multiple content bits
 * multiple brushes can be in a single leaf
 *
 * these definitions also need to be in q_shared.h!
 *
 * lower bits are stronger, and will eat weaker brushes completely
 */
#define	CONTENTS_EMPTY		-1
#define	CONTENTS_SOLID		-2
#define	CONTENTS_WATER		-3
#define	CONTENTS_SLIME		-4
#define	CONTENTS_LAVA		-5
#define	CONTENTS_SKY		-6

#define	CONTENTS2_SOLID		(1<<0)				/* an eye is never valid in a solid */
#define	CONTENTS2_WINDOW	(1<<1)				/* translucent, but not watery */
#define	CONTENTS2_AUX		(1<<2)
#define	CONTENTS2_LAVA		(1<<3)
#define	CONTENTS2_SLIME		(1<<4)
#define	CONTENTS2_WATER		(1<<5)
#define	CONTENTS2_MIST		(1<<6)

/* remaining contents are non-visible, and don't eat brushes */
#define	CONTENTS2_AREAPORTAL	(1<<15)
#define	CONTENTS2_PLAYERCLIP	(1<<16)
#define	CONTENTS2_MONSTERCLIP	(1<<17)
/* currents can be added to any other contents, and may be mixed */
#define	CONTENTS2_CURRENT_0	(1<<18)
#define	CONTENTS2_CURRENT_90	(1<<19)
#define	CONTENTS2_CURRENT_180	(1<<20)
#define	CONTENTS2_CURRENT_270	(1<<21)
#define	CONTENTS2_CURRENT_UP	(1<<22)
#define	CONTENTS2_CURRENT_DOWN	(1<<23)
#define	CONTENTS2_ORIGIN	(1<<24)				/* removed before bsping an entity */
#define	CONTENTS2_MONSTER	(1<<25)				/* should never be on a brush, only in game */
#define	CONTENTS2_DEADMONSTER	(1<<26)
#define	CONTENTS2_DETAIL	(1<<27)				/* brushes to be added after vis leafs */
#define	CONTENTS2_TRANSLUCENT	(1<<28)				/* auto set if any surface has trans */
#define	CONTENTS2_LADDER	(1<<29)

#define	SURF2_LIGHT		(1<<0)				/* value will hold the light strength */
#define	SURF2_SLICK		(1<<1)				/* effects game physics */
#define	SURF2_SKY		(1<<2)				/* don't draw, but add to skybox */
#define	SURF2_WARP		(1<<3)				/* turbulent water warp */
#define	SURF2_TRANS33		(1<<4)
#define	SURF2_TRANS66		(1<<5)
#define	SURF2_FLOWING		(1<<6)				/* scroll towards angle */
#define	SURF2_NODRAW		(1<<7)				/* don't bother referencing the texture */
#define	SURF2_HINT		(1<<8)				/* make a primary bsp splitter */
#define	SURF2_SKIP		(1<<9)				/* completely ignore, allowing non-closed brushes */

struct dnode_t {
  int planenum;
  /* negative numbers are -(leafs+1), not nodes */
  short int children[2];
  /* for sphere culling */
  short int mins[3];
  short int maxs[3];
  unsigned short int firstface;
  /* counting both sides */
  unsigned short int numfaces;
};

struct dnode2_t {
  int planenum;
  /* negative numbers are -(leafs+1), not nodes */
  int children[2];
  /* for sphere culling */
  short int mins[3];
  short int maxs[3];
  unsigned short int firstface;
  /* counting both sides */
  unsigned short int numfaces;
};

struct dclipnode_t {
  int planenum;
  /* negative numbers are contents */
  short int children[2];
};

struct texinfo {
  /* [s/t][xyz offset] */
  float vecs[2][4];
  int miptex;
  int flags;
};

struct texinfo2 {
  /* [s/t][xyz offset] */
  float vecs[2][4];
  /* miptex flags + overrides */
  int flags;
  /* light emission, etc */
  int value;
  /* texture name (textures/.wal) */
  char texture[32];
  /* for animations, -1 = end of chain */
  int nexttexinfo;
};

/* sky or slime, no lightmap or 256 subdivision */
#define	TEX_SPECIAL		(1<<0)				/* aequivalent to 1 */
/* extensions to bsp-type added by niels */
#define	TEX_WATER		(1<<1)
#define	TEX_SLIME		(1<<2)
#define	TEX_LAVA		(1<<3)
#define	TEX_SKY			(1<<4)

/*
 * note that edge 0 is never used, because negative edge nums are used for
 * counterclockwise use of the edge in a face
 */
struct dedge_t {
  /* vertex numbers */
  unsigned short int v[2];
};

#define	MAXLIGHTMAPS		4
struct dface_t {
  short int planenum;
  short int side;
  /* we must support > 64k edges */
  int firstedge;
  short int numedges;
  short int texinfo;
  /* lighting info */
  unsigned char styles[MAXLIGHTMAPS];
  /* start of [numstyles*surfsize] samples */
  int lightofs;
};

#define	AMBIENT_WATER		0
#define	AMBIENT_SKY		1
#define	AMBIENT_SLIME		2
#define	AMBIENT_LAVA		3

/* automatic ambient sounds */
#define	NUM_AMBIENTS		4

/*
 * leaf 0 is the generic CONTENTS_SOLID leaf, used for all solid areas
 * all other leafs need visibility info
 */
struct dleaf_t {
  int contents;
  /* -1 = no visibility info */
  int visofs;
  /* for frustum culling */
  short int mins[3];
  short int maxs[3];
  unsigned short int firstmarksurface;
  unsigned short int nummarksurfaces;
  unsigned char ambient_level[NUM_AMBIENTS];
};

struct dleaf2_t {
  /* OR of all brushes (not needed?) */
  int contents;

  short int cluster;
  short int area;
  /* for frustum culling */
  short int mins[3];
  short int maxs[3];
  unsigned short int firstleafface;
  unsigned short int numleaffaces;
  unsigned short int firstleafbrush;
  unsigned short int numleafbrushes;
};

struct dbrushside2_t {
  /* facing out of the leaf */
  unsigned short int planenum;
  short int texinfo;
};

struct dbrush2_t {
  int firstside;
  int numsides;
  int contents;
};

#define	ANGLE_UP		-1
#define	ANGLE_DOWN		-2

/*
 * the visibility lump consists of a header with a count, then
 * byte offsets for the PVS and PHS of each cluster, then the raw
 * compressed bit vectors
 */
#define	DVIS_PVS		0
#define	DVIS_PHS		1
struct dvis2_t {
  int numclusters;
  /* bitofs[numclusters][2] */
  int bitofs[8][2];
};

/*
 * each area has a list of portals that lead into other areas
 * when portals are closed, other areas may not be visible or
 * hearable even if the vis info says that it should be
 */
struct dareaportal2_t {
  int portalnum;
  int otherarea;
};

struct darea2_t {
  int numareaportals;
  int firstareaportal;
};

struct dpair {
  int offset, size;
};

struct bspheader {
  int version;
  struct dpair entities, planes, miptex, vertices, visilist
   ,nodes, texinfo, faces, lightmaps, clipnodes
   ,leaves, lface, edges, ledges, models;
};

struct bspheader2 {
  int identifier, version;
  struct dpair entities, planes, vertices, visilist
   ,nodes, texinfo, faces, lightmaps
   ,leaves, lface, leafbrushes, edges, ledges, models
   ,brushes, brushsides, pops, areas, areaportals;
};

struct visdata {
  char procName[32];
  int size;
};

/*
 * ============================================================================
 * bsp-tree related
 * ============================================================================
 */

/* the exact bounding box of the brushes is expanded some for the headnode */
/* volume.  is this still needed? */
#define	SIDESPACE			24

#define ON_EPSILON			0.05
#define	POINT_EPSILON			0.01
#define	DISTEPSILON			0.01
#define	T_EPSILON			0.01
#define	ZERO_EPSILON			0.001
#define CONTINUOUS_EPSILON		0.001
#define	ANGLE_EPSILON			0.00001

#define BOGUS_RANGE			18000

#ifdef DYNAMIC_EDGES
struct visfacet {
  struct visfacet *next;
  int planenum;
  int planeside;						/* which side is the front of the face */
  int texturenum;
  int contents[2];						/* 0 = front side */
  struct visfacet *original;					/* face on node */
  int outputnumber;						/* only valid for original faces after */
  /* write surfaces */
  short int numpoints;
  vec3D *pts;							/* FIXME: change to use winding_t */
  int *edges;
} __packed;							/* 36 + 384 + 128 = 548 */

#else
struct visfacet {
  struct visfacet *next;
  int planenum;
  int planeside;						/* which side is the front of the face */
  int texturenum;
  int contents[2];						/* 0 = front side */
  struct visfacet *original;					/* face on node */
  int outputnumber;						/* only valid for original faces after */
  /* write surfaces */
  /*int numpoints; */
  short int numpoints;						/* maximum is MAXEDGES */
  vec3D pts[MAXEDGES];						/* FIXME: change to use winding_t */
  int edges[MAXEDGES];
} __packed;							/* 36 + 384 + 128 = 548 */

					/* 34 + 120 +  36 = 190 */
#endif

struct surface {
  struct surface *next;
  struct surface *original;					/* before BSP cuts it up */
  int planenum;
  int outputplanenum;						/* only valid after WriteSurfacePlanes */
  vec3D mins, maxs;
  bool onnode;							/* true if surface has already been used */
  /* as a splitting node */
  struct visfacet *faces;					/* links to all the faces on either side of the surf */
} __packed;							/* 48 */

/*
 * there is a node_t structure for every node and leaf in the bsp tree
 */
#define	PLANENUM_LEAF			-1

struct node {
  vec3D mins, maxs;						/* bounding volume, not just points inside */
  /* information for decision nodes */
  int planenum;							/* -1 = leaf node */
  int outputplanenum;						/* only valid after WriteNodePlanes */
  int firstface;						/* decision node only */
  int numfaces;							/* decision node only */
  struct node *children[2];					/* only valid for decision nodes */
  struct visfacet *faces;					/* decision nodes only, list for both sides */
  /* information for leafs */
  int contents;							/* leaf nodes (0 for decision nodes) */
  struct visfacet **markfaces;					/* leaf nodes only, point to node faces */
  struct portal *portals;
  int visleafnum;						/* -1 = solid */
  int valid;							/* for flood filling */
  /*int occupied;                                                              / light number in leaf for outside filling / */
  short int occupied;						/* maximum in number of entities */
} __packed;							/* 76 */

					/* 74 */

/*
 * ============================================================================
 * globals
 * ============================================================================
 */

extern bool newBsp, newLit, newVis;

/* light */
extern bool waterlit, extra, doradiosity;
extern vec1D scale, range;

/* qbsp */
extern bool watervis, slimevis;
extern bool nofill, notjunc, noclip, onlyents, usehulls;
extern int subdivide, hullnum;

/* vis */
extern bool fastvis;
extern int vislevel;

/*
 * ============================================================================
 * prototypes
 * ============================================================================
 */

#include "memory.h"

bool AddBSP(struct palpic *inPic, struct rawdata *inData, char *bspName, operation procOper, filetype inType);
bool ExtractMipTex(bspBase bspMem, FILE * script, char *destDir, char *destPath, char *entryName, filetype outType, operation procOper, bool recurse, bool toWad);
bool ExtractBSP(HANDLE file, FILE * script, char *destDir, char *entryName, filetype outType, operation procOper, bool recurse);
struct bspmemory *LoadBSP(HANDLE bspFile, int availLoad, unsigned char versionLoad);
void WriteBSP(struct bspmemory *bspMem, HANDLE bspFile, unsigned char versionSave);

#endif
