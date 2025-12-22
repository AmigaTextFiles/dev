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

#ifndef	MEMORY_H
#define	MEMORY_H
/*
 * ============================================================================
 * structures
 * ============================================================================
 */

/* key / value pair sizes */
#define	MAX_KEY			32
#define	MAX_VALUE		1024

/* QuakeI */
#define	MAX_MAP_MODELS		256
#define	MAX_MAP_ENTSTRING	65536
#define	MAX_MAP_PLANES		8192				/*    8192 */
#define	MAX_MAP_NODES		9216				/*   32767        // because negative shorts are contents */
#define	MAX_MAP_CLIPNODES	24576				/*   32767        // */
#define	MAX_MAP_LEAFS		6144				/*   32767        // */
#define	MAX_MAP_VERTS		23552				/*   65535 */
#define	MAX_MAP_FACES		18432				/*   65535 */
#define	MAX_MAP_MARKSURFACES	23552				/*   65535 */
#define	MAX_MAP_TEXINFO		1024				/*    4096 */
#define	MAX_MAP_EDGES		43008				/*  256000 */
#define	MAX_MAP_SURFEDGES	82944				/*  512000 */
#define	MAX_MAP_TEXTURES	0x200000
#define	MAX_MAP_LIGHTING	614400				/*0x100000 */
#define	MAX_MAP_VISIBILITY	163840				/*0x100000 */
/* QuakeII */
#define	MAX_MAP_AREAS		32				/*256 */
#define	MAX_MAP_AREAPORTALS	256				/*1024 */
#define	MAX_MAP_BRUSHES		4096				/*65536 */
#define	MAX_MAP_BRUSHSIDES	4096				/*65536 */
#define	MAX_MAP_LEAFFACES	MAX_MAP_MARKSURFACES
#define	MAX_MAP_LEAFBRUSHES	4096				/*65536 */

/* QuakeI */
#define CLUSTER_MODELS		32
#define CLUSTER_ENTSTRING	8192
#define CLUSTER_PLANES		512				/*1024 */
#define CLUSTER_NODES		1024				/*4096 */
#define CLUSTER_CLIPNODES	1024				/*4096 */
#define CLUSTER_LEAFS		1024				/*2048 */
#define CLUSTER_VERTS		2048				/*8192 */
#define CLUSTER_FACES		1024				/*4096 */
#define CLUSTER_MARKSURFACES	512				/*892 */
#define CLUSTER_TEXINFO		512
#define CLUSTER_EDGES		4096				/*16384 */
#define CLUSTER_SURFEDGES	4096				/*16384 */
#define CLUSTER_TEXTURES	65536
#define CLUSTER_LIGHTING	65536
#define CLUSTER_VISIBILITY	32768
/* QuakeII */
#define	CLUSTER_AREAS		8
#define	CLUSTER_AREAPORTALS	64
#define	CLUSTER_BRUSHES		1024
#define	CLUSTER_BRUSHSIDES	1024
#define	CLUSTER_LEAFFACES	CLUSTER_MARKSURFACES
#define	CLUSTER_LEAFBRUSHES	1024

/* QuakeI */
#define	LUMP_ENTITIES		(1<<0)
#define	LUMP_PLANES		(1<<1)
#define	LUMP_TEXTURES		(1<<2)
#define	LUMP_VERTEXES		(1<<3)
#define	LUMP_VISIBILITY		(1<<4)
#define	LUMP_NODES		(1<<5)
#define	LUMP_TEXINFO		(1<<6)
#define	LUMP_FACES		(1<<7)
#define	LUMP_LIGHTING		(1<<8)
#define	LUMP_CLIPNODES		(1<<9)
#define	LUMP_LEAFS		(1<<10)
#define	LUMP_MARKSURFACES	(1<<11)
#define	LUMP_EDGES		(1<<12)
#define	LUMP_SURFEDGES		(1<<13)
#define	LUMP_MODELS		(1<<14)
/* QuakeII */
#define	LUMP_AREAS		(1<<15)
#define	LUMP_AREAPORTALS	(1<<16)
#define	LUMP_BRUSHES		(1<<17)
#define	LUMP_BRUSHSIDES		(1<<18)
#define	LUMP_LEAFFACES		LUMP_MARKSURFACES
#define	LUMP_LEAFBRUSHES	(1<<19)
#define	LUMP_POPS		(1<<20)

#define	BSP_QUAKE1_LUMPS	(((1<<15)-1) & (~LUMP_TEXTURES) & (~LUMP_LIGHTING) & (~LUMP_VISIBILITY))

#define	ALL_QUAKE1_LUMPS	((1<<15)-1)
#define	ALL_QUAKE2_LUMPS	((1<<21)-1 & (~LUMP_TEXTURES) & (~LUMP_CLIPNODES))

/* ============================================================================ */

/* QuakeI */
#define	MAX_MAP_ENTITIES	1024
#define	MAX_MAP_TEXSTRINGS	MAX_MAP_TEXINFO
#define	MAX_MAP_BRUSHFACES	MAX_MAP_FACES
#define	MAX_MAP_BRUSHPLANES	MAX_MAP_PLANES

/* QuakeI */
#define	CLUSTER_ENTITIES	128
#define	CLUSTER_TEXSTRINGS	CLUSTER_TEXINFO
#define	CLUSTER_BRUSHFACES	CLUSTER_FACES
#define	CLUSTER_BRUSHPLANES	CLUSTER_PLANES

/* QuakeI */
#define	MAP_ENTITIES		(1<<21)
#define	MAP_TEXSTRINGS		(1<<22)
#define	MAP_BRUSHPLANES		(1<<23)
#define	MAP_BRUSHFACES	      	(1<<24)

#define	ALL_MAPS		(((1<<25)-1)-((1<<21)-1))

/* ============================================================================ */

/* QuakeI */
#define	MAX_MAP_PORTALS		32768

/* QuakeI */
#define	CLUSTER_PORTALS		4096

/* QuakeI */
#define	VIS_PORTALS		(1<<25)

#define	ALL_VIS			(((1<<26)-1)-((1<<25)-1))

/* ============================================================================ */

#define MAX_MDL_TVERTS		2048
#define MAX_MDL_FRAMES		256
#define MAX_MDL_SKINS		100

/* QuakeI */
#define CLUSTER_TVERTS		256
#define CLUSTER_FRAMES		32
#define CLUSTER_SKINS		10

/* QuakeI */
#define MODEL_TVERTS		(1<<26)
#define MODEL_FRAMES		(1<<27)
#define MODEL_SKINS		(1<<28)

#define	ALL_MODEL		(((1<<29)-1)-((1<<26)-1))

/* ============================================================================ */

#define MAX_TRIANGLES		2048

#define CLUSTER_TRIANGLES	512

#define TRIANGLES		(1<<29)

#define	ALL_TRIANGLES		(((1<<30)-1)-((1<<29)-1))

/* ============================================================================ */

#define MAX_SPR_FRAMES		MAX_MDL_FRAMES

/* QuakeI */
/* #define CLUSTER_FRAMES	32 */

/* QuakeI */
#define SPRITE_FRAMES		(1<<30)

#define	ALL_SPRITES		(((1<<31)-1)-((1<<30)-1))

/* ============================================================================ */

typedef struct mapmemory {
  struct nnode mapNode;

  int availHeaders;

  unsigned char mapOptions;
  unsigned char mapVersion;

  /* extras for maps */
  int nummapentities,		max_nummapentities;	struct entity *mapentities;
  int nummaptexstrings,		max_nummaptexstrings;	char **maptexstrings;
  int numbrushfaces,		max_numbrushfaces;	struct mface *brushfaces;
  int numbrushplanes,		max_numbrushplanes;	struct plane *brushplanes;
} *mapBase __packed;

typedef struct bspmemory {
  struct nnode bspNode;

  int availHeaders;

  unsigned char bspOptions, litOptions, visOptions;
  unsigned char bspVersion, litVersion, visVersion;

  union {
    struct {
      /* all bsps */
      int entdatasize,		max_entdatasize;	char *dentdata;
      int numplanes,		max_numplanes;		struct dplane_t *dplanes;
      int numvertexes,		max_numvertexes;	struct dvertex_t *dvertexes;
      int numfaces,		max_numfaces;		struct dface_t *dfaces;
      int lightdatasize,	max_lightdatasize;	unsigned char *dlightdata;
      int numedges,		max_numedges;		struct dedge_t *dedges;
      int numsurfedges,		max_numsurfedges;	int *dsurfedges;

      /* all models */
    } all;

    struct {
      /* standard bsp 29 */
      int entdatasize,		max_entdatasize;	char *dentdata;
      int numplanes,		max_numplanes;		struct dplane_t *dplanes;
      int numvertexes,		max_numvertexes;	struct dvertex_t *dvertexes;
      int numfaces,		max_numfaces;		struct dface_t *dfaces;
      int lightdatasize,	max_lightdatasize;	unsigned char *dlightdata;
      int numedges,		max_numedges;		struct dedge_t *dedges;
      int numsurfedges,		max_numsurfedges;	int *dsurfedges;

      int visdatasize,		max_visdatasize;	unsigned char *dvisdata;
      int numnodes,		max_numnodes;		struct dnode_t *dnodes;
      int numtexinfo,		max_numtexinfo;		struct texinfo *texinfo;
      int numleafs,		max_numleafs;		struct dleaf_t *dleafs;
      int nummarksurfaces,	max_nummarksurfaces;	unsigned short int *dmarksurfaces;
      int nummodels,		max_nummodels;		struct dmodel_t *dmodels;

      int texdatasize,		max_texdatasize;	unsigned char *dtexdata;
      int numclipnodes,		max_numclipnodes;	struct dclipnode_t *dclipnodes;

      /* standard model 6 */
    } quake1;

    struct {
      /* standard bsp 38 */
      int entdatasize,		max_entdatasize;	char *dentdata;
      int numplanes,		max_numplanes;		struct dplane_t *dplanes;
      int numvertexes,		max_numvertexes;	struct dvertex_t *dvertexes;
      int numfaces,		max_numfaces;		struct dface_t *dfaces;
      int lightdatasize,	max_lightdatasize;	unsigned char *dlightdata;
      int numedges,		max_numedges;		struct dedge_t *dedges;
      int numsurfedges,		max_numsurfedges;	int *dsurfedges;

      int numclusters,		max_numclusters;	struct dvis2_t *clusters;
      int numnodes,		max_numnodes;		struct dnode2_t *dnodes;
      int numtexinfo,		max_numtexinfo;		struct texinfo2 *texinfo;
      int numleafs,		max_numleafs;		struct dleaf2_t *dleafs;
      int numleaffaces,		max_numleaffaces;	unsigned short int *dleaffaces;
      int nummodels,		max_nummodels;		struct dmodel2_t *dmodels;

      int numleafbrushes,	max_numleafbrushes;	unsigned short int *dleafbrushes;
      int numbrushes,		max_numbrushes;		struct dbrush2_t *dbrushes;
      int numbrushsides,	max_numbrushsides;	struct dbrushside2_t *dbrushsides;
      int numpops,		max_numpops;		unsigned char *dpops;
      int numareas,		max_numareas;		struct darea2_t *dareas;
      int numareaportals,	max_numareaportals;	struct dareaportal2_t *dareaportals;

      /* standard model 8 */
    } quake2;
  } shared;

  /* extras */
							struct visfacet **edgefaces[2];

  /* extras for light */

  /* extras for vis */
  int numportals,		max_numportals;		unsigned char *portalsee;

  /* configureable maxima */
#ifndef	CUSTOM_MAXIMA
# define	MAXEDGES		32			/* 64     32 */
# define	MAXPOINTS		28			/* 56     28                         dont let a base face get past this */
  /* because it can be split more later */
# define	MAX_EDGES_IN_REGION	32
# define	MAX_PORTALS_ON_LEAF	128
#else
# define	DEFEDGES		32
# define	DEFPOINTS		28
# define	DEF_EDGES_IN_REGION	32
# define	DEF_PORTALS_ON_LEAF	128
# define	MAXEDGES		bspMem->maxedges
# define	MAXPOINTS		bspMem->maxpoints
# define	MAX_EDGES_IN_REGION	bspMem->maxedges_in_region
# define	MAX_PORTALS_ON_LEAF	bspMem->maxportals_on_leaf
  int maxpoints;
  int maxedges;
  int maxedges_in_region;
  int maxportals_on_leaf;
#endif
} *bspBase __packed;

typedef struct mdlmemory {
  struct nnode mdlNode;

  int availHeaders;

  unsigned char mdlOptions;
  unsigned char mdlVersion;

  /* disk structures */
  struct dmdlheader header;

  /* extras for triangles */
  int numtriangles,		max_numtriangles;	struct triangle *tris;
							struct dtriangle *triangles;
							bool *degenerate;

  /* extras for models */
  int numverts,			max_numverts;		struct trivert **verts;
							struct trivertex *tarray;
							struct stvert *stverts;
							vec3D *baseverts;
							struct vertexnormals *vnorms;
  int numframes,		max_numframes;		struct aliaspackage *frames;
  int numskins,			max_numskins;		struct aliasskinpackage *skins;
} *mdlBase __packed;

typedef struct sprmemory {
  struct nnode sprNode;

  int availHeaders;

  unsigned char sprOptions;
  unsigned char sprVersion;

  /* disk structures */
  struct dsprite_t header;

  /* */
  int numframes,		max_numframes;		struct spritepackage *frames;
  int framesmaxs[2];
} *sprBase __packed;

typedef struct dspmemory {
  struct nnode dspNode;

  int availHeaders;

  unsigned char dspOptions;
  unsigned char dspVersion;
} *dspBase __packed;

typedef struct memory {
  struct nlist *maps;		/* all maps */
  struct nlist *bsps;		/* all bsps */
  struct nlist *mdls;		/* all models */
  struct nlist *sprs;		/* all sprites */
  struct nlist *dsps;		/* all displays */

  struct mapmemory *actMap;
  struct bspmemory *actBSP;
  struct mdlmemory *actModel;
  struct sprmemory *actSprite;
  struct dspmemory *actDisplay;
} *memBase __packed;

/*
 * ============================================================================
 * prototypes
 * ============================================================================
 */

void PrintClusters(memBase, int printType, bool toDisk);
void PrintBSPClusters(bspBase, int printType, bool toDisk);
void PrintMapClusters(mapBase, int printType, bool toDisk);
void PrintMDLClusters(mdlBase, int printType, bool toDisk);
void PrintSPRClusters(sprBase, int printType, bool toDisk);

void AllocClusters(memBase, int allocType);
void AllocBSPClusters(bspBase, int allocType);
void AllocMapClusters(mapBase, int allocType);
void AllocMDLClusters(mdlBase, int allocType);
void AllocSPRClusters(sprBase, int allocType);

void ExpandClusters(memBase, int allocType);
void ExpandBSPClusters(bspBase, int allocType);
void ExpandMapClusters(mapBase, int allocType);
void ExpandMDLClusters(mdlBase, int allocType);
void ExpandSPRClusters(sprBase, int allocType);

void FreeClusters(memBase, int freeType);
void FreeBSPClusters(bspBase, int freeType);
void FreeMapClusters(mapBase, int freeType);
void FreeMDLClusters(mdlBase, int freeType);
void FreeSPRClusters(sprBase, int freeType);

#endif
