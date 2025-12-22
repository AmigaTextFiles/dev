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

#define	LIBQTOOLS_CORE
#include "../include/libqtools.h"

/*#undef        oprintf */
/*#define       oprintf printf */

/*
 * =============
 * PrintBSPFileSizes
 * 
 * Dumps info about current file
 * =============
 */
void PrintClusters(memBase baseMem, int printType, bool toDisk) {
  /* TODO: loop through list */
}

void PrintBSPClusters(bspBase bspMem, int printType, bool toDisk)
{
  if (bspMem) {
    int newprint = printType ? printType : bspMem->availHeaders;
  
    if (!bspMem->bspVersion)
      bspMem->bspVersion = BSP_VERSION_Q1;

    oprintf("printmask: %lx\n", newprint);

    mprintf("----- Statistics --------\n");
    if (bspMem->availHeaders & newprint & LUMP_PLANES)
      mprintf("%5i planes       %6i\n", bspMem->shared.all.numplanes, (int)(bspMem->shared.all.numplanes * sizeof(struct dplane_t)));
    if (bspMem->availHeaders & newprint & LUMP_VERTEXES)
      mprintf("%5i vertexes     %6i\n", bspMem->shared.all.numvertexes, (int)(bspMem->shared.all.numvertexes * sizeof(struct dvertex_t)));
    if (bspMem->availHeaders & newprint & LUMP_FACES)
      mprintf("%5i faces        %6i\n", bspMem->shared.all.numfaces, (int)(bspMem->shared.all.numfaces * sizeof(struct dface_t)));
    if (bspMem->availHeaders & newprint & LUMP_SURFEDGES)
      mprintf("%5i surfedges    %6i\n", bspMem->shared.all.numsurfedges, (int)(bspMem->shared.all.numsurfedges * sizeof(int)));
    if (bspMem->availHeaders & newprint & LUMP_EDGES)
      mprintf("%5i edges        %6i\n", bspMem->shared.all.numedges, (int)(bspMem->shared.all.numedges * sizeof(struct dedge_t)));
    if (bspMem->availHeaders & newprint & LUMP_LIGHTING)
      mprintf("      lightdata    %6i\n", bspMem->shared.all.lightdatasize);
    if (bspMem->availHeaders & newprint & LUMP_ENTITIES)
      mprintf("      entdata      %6i\n", bspMem->shared.all.entdatasize);
    if(bspMem->bspVersion == BSP_VERSION_Q1) {
      if (bspMem->availHeaders & newprint & LUMP_VISIBILITY)
        mprintf("      visdata      %6i\n", bspMem->shared.quake1.visdatasize);
      if (bspMem->availHeaders & newprint & LUMP_NODES)
        mprintf("%5i nodes        %6i\n", bspMem->shared.quake1.numnodes, (int)(bspMem->shared.quake1.numnodes * sizeof(struct dnode_t)));
      if (bspMem->availHeaders & newprint & LUMP_MODELS)
        mprintf("%5i models       %6i\n", bspMem->shared.quake1.nummodels, (int)(bspMem->shared.quake1.nummodels * sizeof(struct dmodel_t)));
      if (bspMem->availHeaders & newprint & LUMP_TEXINFO)
        mprintf("%5i texinfo      %6i\n", bspMem->shared.quake1.numtexinfo, (int)(bspMem->shared.quake1.numtexinfo * sizeof(struct texinfo)));
      if (bspMem->availHeaders & newprint & LUMP_LEAFS)
        mprintf("%5i leafs        %6i\n", bspMem->shared.quake1.numleafs, (int)(bspMem->shared.quake1.numleafs * sizeof(struct dleaf_t)));
      if (bspMem->availHeaders & newprint & LUMP_MARKSURFACES)
        mprintf("%5i %s %6i\n", bspMem->shared.quake1.nummarksurfaces, "marksurfaces", (int)(bspMem->shared.quake1.nummarksurfaces * sizeof(unsigned short int)));
      if (bspMem->availHeaders & newprint & LUMP_CLIPNODES)
        mprintf("%5i clipnodes    %6i\n", bspMem->shared.quake1.numclipnodes, (int)(bspMem->shared.quake1.numclipnodes * sizeof(struct dclipnode_t)));
      if (bspMem->availHeaders & newprint & LUMP_TEXTURES) {
        if (!bspMem->shared.quake1.texdatasize)
	  mprintf("    0 textures          0\n");
        else
	  mprintf("%5i textures     %6i\n", toDisk ? LittleLong(((struct dmiptexlump_t *)bspMem->shared.quake1.dtexdata)->nummiptex) : ((struct dmiptexlump_t *)bspMem->shared.quake1.dtexdata)->nummiptex, bspMem->shared.quake1.texdatasize);
      }
    }
    else if(bspMem->bspVersion == BSP_VERSION_Q2) {
      if (bspMem->availHeaders & newprint & LUMP_VISIBILITY)
        mprintf("      visdata      %6i\n", (int)(bspMem->shared.quake2.numclusters * sizeof(struct dvis2_t)));
      if (bspMem->availHeaders & newprint & LUMP_NODES)
        mprintf("%5i nodes        %6i\n", bspMem->shared.quake2.numnodes, (int)(bspMem->shared.quake2.numnodes * sizeof(struct dnode2_t)));
      if (bspMem->availHeaders & newprint & LUMP_MODELS)
        mprintf("%5i models       %6i\n", bspMem->shared.quake2.nummodels, (int)(bspMem->shared.quake2.nummodels * sizeof(struct dmodel2_t)));
      if (bspMem->availHeaders & newprint & LUMP_TEXINFO)
        mprintf("%5i texinfo      %6i\n", bspMem->shared.quake2.numtexinfo, (int)(bspMem->shared.quake2.numtexinfo * sizeof(struct texinfo2)));
      if (bspMem->availHeaders & newprint & LUMP_LEAFS)
        mprintf("%5i leafs        %6i\n", bspMem->shared.quake2.numleafs, (int)(bspMem->shared.quake2.numleafs * sizeof(struct dleaf2_t)));
      if (bspMem->availHeaders & newprint & LUMP_LEAFFACES)
        mprintf("%5i %s %6i\n", bspMem->shared.quake2.numleaffaces, "leaffaces   ", (int)(bspMem->shared.quake2.numleaffaces * sizeof(unsigned short int)));
      if (bspMem->availHeaders & newprint & LUMP_AREAS)
        mprintf("%5i areas        %6i\n", bspMem->shared.quake2.numareas, (int)(bspMem->shared.quake2.numareas * sizeof(struct darea2_t)));
      if (bspMem->availHeaders & newprint & LUMP_AREAPORTALS)
        mprintf("%5i areaportals  %6i\n", bspMem->shared.quake2.numareaportals, (int)(bspMem->shared.quake2.numareaportals * sizeof(struct dareaportal2_t)));
      if (bspMem->availHeaders & newprint & LUMP_BRUSHES)
        mprintf("%5i brushes      %6i\n", bspMem->shared.quake2.numbrushes, (int)(bspMem->shared.quake2.numbrushes * sizeof(struct dbrush2_t)));
      if (bspMem->availHeaders & newprint & LUMP_BRUSHSIDES)
        mprintf("%5i brushsides   %6i\n", bspMem->shared.quake2.numbrushsides, (int)(bspMem->shared.quake2.numbrushsides * sizeof(struct dbrushside2_t)));
      if (bspMem->availHeaders & newprint & LUMP_LEAFBRUSHES)
        mprintf("%5i leafbrushes  %6i\n", bspMem->shared.quake2.numleafbrushes, (int)(bspMem->shared.quake2.numleafbrushes * sizeof(unsigned short int)));
    }
  }
}

void PrintMapClusters(mapBase mapMem, int printType, bool toDisk)
{
  if (mapMem) {
    int newprint = printType ? printType : mapMem->availHeaders;

    if (mapMem->availHeaders & newprint & MAP_ENTITIES)
      mprintf("%5i entities     %6i\n", mapMem->nummapentities, (int)(mapMem->nummapentities * sizeof(struct entity)));

    if (mapMem->availHeaders & newprint & MAP_TEXSTRINGS)
      mprintf("%5i texstrings   %6i\n", mapMem->nummaptexstrings, (int)(mapMem->nummaptexstrings * (sizeof(char *) + 16)));

    if (mapMem->availHeaders & newprint & MAP_BRUSHFACES)
      mprintf("%5i brushfaces   %6i\n", mapMem->numbrushfaces, (int)(mapMem->numbrushfaces * sizeof(struct mface)));

    if (mapMem->availHeaders & newprint & MAP_BRUSHPLANES)
      mprintf("%5i brushplanes  %6i\n", mapMem->numbrushplanes, (int)(mapMem->numbrushplanes * sizeof(struct plane)));
  }
}

void PrintMDLClusters(mdlBase mdlMem, int printType, bool toDisk)
{
  if (mdlMem) {
    int newprint = printType ? printType : mdlMem->availHeaders;

    if (mdlMem->availHeaders & newprint & TRIANGLES)
      mprintf("%5i triangles    %6i\n", mdlMem->numtriangles, (int)(mdlMem->numtriangles * sizeof(struct triangle)));

    if (mdlMem->availHeaders & newprint & MODEL_TVERTS)
      mprintf("%5i tverts       %6i\n", mdlMem->numverts, (int)(mdlMem->numverts * sizeof(struct trivert)));

    if (mdlMem->availHeaders & newprint & MODEL_FRAMES)
      mprintf("%5i frames       %6i\n", mdlMem->numframes, (int)(mdlMem->numframes * sizeof(struct aliaspackage)));

    if (mdlMem->availHeaders & newprint & MODEL_SKINS)
      mprintf("%5i skins        %6i\n", mdlMem->numskins, (int)(mdlMem->numskins * sizeof(struct aliasskinpackage)));
  }
}

void PrintSPRClusters(sprBase sprMem, int printType, bool toDisk)
{
  if (sprMem) {
    int newprint = printType ? printType : sprMem->availHeaders;

    if (sprMem->availHeaders & newprint & SPRITE_FRAMES)
      mprintf("%5i frames       %6i\n", sprMem->numframes, (int)(sprMem->numframes * sizeof(struct spritepackage)));
  }
}

/*
 * =============
 * AllocBSP
 * =============
 */
void AllocClusters(memBase baseMem, int allocType)
{
}

void AllocBSPClusters(bspBase bspMem, int allocType)
{
  if (bspMem) {
    if (!bspMem->bspVersion)
      bspMem->bspVersion = BSP_VERSION_Q1;

    oprintf("allocmask: %lx\n", allocType);

    if (allocType & LUMP_ENTITIES) {
      if (bspMem->shared.all.dentdata)
	tfree(bspMem->shared.all.dentdata);
      if (!(bspMem->shared.all.dentdata = tmalloc((bspMem->shared.all.max_entdatasize = CLUSTER_ENTSTRING) * sizeof(char))))
	  Error(failed_memoryunsize, "entities");

      bspMem->shared.all.entdatasize = 0;
      oprintf("first cluster for entities allocated: %7d bytes (%lx)\n", CLUSTER_ENTSTRING * sizeof(char), bspMem->shared.all.dentdata);
    }
    if (allocType & LUMP_PLANES) {
      if (bspMem->shared.all.dplanes)
	tfree(bspMem->shared.all.dplanes);
      if (!(bspMem->shared.all.dplanes = tmalloc((bspMem->shared.all.max_numplanes = CLUSTER_PLANES) * sizeof(struct dplane_t))))
	  Error(failed_memoryunsize, "planes");

      bspMem->shared.all.numplanes = 0;
      oprintf("first cluster for planes allocated: %7d bytes (%lx)\n", CLUSTER_PLANES * sizeof(struct dplane_t), bspMem->shared.all.dplanes);
    }
    if (allocType & LUMP_VERTEXES) {
      if (bspMem->shared.all.dvertexes)
	tfree(bspMem->shared.all.dvertexes);
      if (!(bspMem->shared.all.dvertexes = tmalloc((bspMem->shared.all.max_numvertexes = CLUSTER_VERTS) * sizeof(struct dvertex_t))))
	  Error(failed_memoryunsize, "vertexes");

      bspMem->shared.all.numvertexes = 0;
      oprintf("first cluster for vertexes allocated: %7d bytes (%lx)\n", CLUSTER_VERTS * sizeof(struct dvertex_t), bspMem->shared.all.dvertexes);
    }
    if (allocType & LUMP_FACES) {
      if (bspMem->shared.all.dfaces)
	tfree(bspMem->shared.all.dfaces);
      if (!(bspMem->shared.all.dfaces = tmalloc((bspMem->shared.all.max_numfaces = CLUSTER_FACES) * sizeof(struct dface_t))))
	  Error(failed_memoryunsize, "faces");

      bspMem->shared.all.numfaces = 0;
      oprintf("first cluster for faces allocated: %7d bytes (%lx)\n", CLUSTER_FACES * sizeof(struct dface_t), bspMem->shared.all.dfaces);
    }
    if (allocType & LUMP_LIGHTING) {
      if (bspMem->shared.all.dlightdata)
	tfree(bspMem->shared.all.dlightdata);
      if (!(bspMem->shared.all.dlightdata = tmalloc((bspMem->shared.all.max_lightdatasize = CLUSTER_LIGHTING) * sizeof(char))))
	  Error(failed_memoryunsize, "lightdata");

      bspMem->shared.all.lightdatasize = 0;
      oprintf("first cluster for lighting allocated: %7d bytes (%lx)\n", CLUSTER_LIGHTING * sizeof(char), bspMem->shared.all.dlightdata);
    }
    if (allocType & LUMP_EDGES) {
      if (bspMem->shared.all.dedges)
	tfree(bspMem->shared.all.dedges);
      if (bspMem->edgefaces[0])
	tfree(bspMem->edgefaces[0]);
      if (bspMem->edgefaces[1])
	tfree(bspMem->edgefaces[1]);

      if (!(bspMem->shared.all.dedges = tmalloc((bspMem->shared.all.max_numedges = CLUSTER_EDGES) * sizeof(struct dedge_t))))
	Error(failed_memoryunsize, "edges");
      if (!(bspMem->edgefaces[0] = tmalloc(CLUSTER_EDGES * sizeof(struct visfacet **))))
	Error(failed_memoryunsize, "edgefaces[0]");
      if (!(bspMem->edgefaces[1] = tmalloc(CLUSTER_EDGES * sizeof(struct visfacet **))))
	Error(failed_memoryunsize, "edgefaces[1]");

      bspMem->shared.all.numedges = 0;
      oprintf("first cluster for edges allocated: %7d bytes (%lx)\n", CLUSTER_EDGES * sizeof(struct dedge_t), bspMem->shared.all.dedges);
      oprintf("first cluster for edgefaces[0] allocated: %7d bytes (%lx)\n", CLUSTER_EDGES * sizeof(struct visfacet **), bspMem->edgefaces[0]);
      oprintf("first cluster for edgefaces[1] allocated: %7d bytes (%lx)\n", CLUSTER_EDGES * sizeof(struct visfacet **), bspMem->edgefaces[1]);
    }
    if (allocType & LUMP_SURFEDGES) {
      if (bspMem->shared.all.dsurfedges)
	tfree(bspMem->shared.all.dsurfedges);
      if (!(bspMem->shared.all.dsurfedges = tmalloc((bspMem->shared.all.max_numsurfedges = CLUSTER_SURFEDGES) * sizeof(int))))
	Error(failed_memoryunsize, "surfedges");

      bspMem->shared.all.numsurfedges = 0;
      oprintf("first cluster for surfedges allocated: %7d bytes (%lx)\n", CLUSTER_SURFEDGES * sizeof(int), bspMem->shared.all.dsurfedges);
    }

    if(bspMem->bspVersion == BSP_VERSION_Q1) {
      if (allocType & LUMP_VISIBILITY) {
        if (bspMem->shared.quake1.dvisdata)
  	  tfree(bspMem->shared.quake1.dvisdata);
        if (!(bspMem->shared.quake1.dvisdata = tmalloc((bspMem->shared.quake1.max_visdatasize = CLUSTER_VISIBILITY) * sizeof(char))))
  	  Error(failed_memoryunsize, "visibility");
  
        bspMem->shared.quake1.visdatasize = 0;
        oprintf("first cluster for visibility allocated: %7d bytes (%lx)\n", CLUSTER_VISIBILITY * sizeof(char), bspMem->shared.quake1.dvisdata);
      }
      if (allocType & LUMP_NODES) {
        if (bspMem->shared.quake1.dnodes)
  	  tfree(bspMem->shared.quake1.dnodes);
        if (!(bspMem->shared.quake1.dnodes = tmalloc((bspMem->shared.quake1.max_numnodes = CLUSTER_NODES) * sizeof(struct dnode_t))))
  	  Error(failed_memoryunsize, "nodes");
  
        bspMem->shared.quake1.numnodes = 0;
        oprintf("first cluster for nodes allocated: %7d bytes (%lx)\n", CLUSTER_NODES * sizeof(struct dnode_t), bspMem->shared.quake1.dnodes);
      }
      if (allocType & LUMP_MODELS) {
        if (bspMem->shared.quake1.dmodels)
  	  tfree(bspMem->shared.quake1.dmodels);
        if (!(bspMem->shared.quake1.dmodels = tmalloc((bspMem->shared.quake1.max_nummodels = CLUSTER_MODELS) * sizeof(struct dmodel_t))))
  	  Error(failed_memoryunsize, "models");
  
        bspMem->shared.quake1.nummodels = 0;
        oprintf("first cluster for models allocated: %7d bytes (%lx)\n", CLUSTER_MODELS * sizeof(struct dmodel_t), bspMem->shared.quake1.dmodels);
      }
      if (allocType & LUMP_TEXINFO) {
        if (bspMem->shared.quake1.texinfo)
  	  tfree(bspMem->shared.quake1.texinfo);
        if (!(bspMem->shared.quake1.texinfo = tmalloc((bspMem->shared.quake1.max_numtexinfo = CLUSTER_TEXINFO) * sizeof(struct texinfo))))
  	  Error(failed_memoryunsize, "texinfo");
  
        bspMem->shared.quake1.numtexinfo = 0;
        oprintf("first cluster for texinfo allocated: %7d bytes (%lx)\n", CLUSTER_TEXINFO * sizeof(struct texinfo), bspMem->shared.quake1.texinfo);
      }
      if (allocType & LUMP_LEAFS) {
        if (bspMem->shared.quake1.dleafs)
  	  tfree(bspMem->shared.quake1.dleafs);
        if (!(bspMem->shared.quake1.dleafs = tmalloc((bspMem->shared.quake1.max_numleafs = CLUSTER_LEAFS) * sizeof(struct dleaf_t))))
  	  Error(failed_memoryunsize, "leafs");
  
        bspMem->shared.quake1.numleafs = 0;
        oprintf("first cluster for leafs allocated: %7d bytes (%lx)\n", CLUSTER_LEAFS * sizeof(struct dleaf_t), bspMem->shared.quake1.dleafs);
      }
      if (allocType & LUMP_MARKSURFACES) {
        if (bspMem->shared.quake1.dmarksurfaces)
  	  tfree(bspMem->shared.quake1.dmarksurfaces);
        if (!(bspMem->shared.quake1.dmarksurfaces = tmalloc((bspMem->shared.quake1.max_nummarksurfaces = CLUSTER_MARKSURFACES) * sizeof(unsigned short int))))
  	  Error(failed_memoryunsize, "marksurfaces");
  
        bspMem->shared.quake1.nummarksurfaces = 0;
        oprintf("first cluster for marksurfaces allocated: %7d bytes (%lx)\n", CLUSTER_MARKSURFACES * sizeof(unsigned short int), bspMem->shared.quake1.dmarksurfaces);
      }
    }
    else if(bspMem->bspVersion == BSP_VERSION_Q2) {
      if (allocType & LUMP_VISIBILITY) {
        if (bspMem->shared.quake2.clusters)
  	  tfree(bspMem->shared.quake2.clusters);
        if (!(bspMem->shared.quake2.clusters = tmalloc((bspMem->shared.quake2.max_numclusters = CLUSTER_VISIBILITY) * sizeof(struct dvis2_t)))) 
  	  Error(failed_memoryunsize, "visibility");
  
        bspMem->shared.quake2.numclusters = 0;
        oprintf("first cluster for visibility allocated: %7d bytes (%lx)\n", CLUSTER_VISIBILITY * sizeof(char), bspMem->shared.quake2.clusters);
      }
      if (allocType & LUMP_NODES) {
        if (bspMem->shared.quake2.dnodes)
  	  tfree(bspMem->shared.quake2.dnodes);
        if (!(bspMem->shared.quake2.dnodes = tmalloc((bspMem->shared.quake2.max_numnodes = CLUSTER_NODES) * sizeof(struct dnode2_t))))
  	  Error(failed_memoryunsize, "nodes");
  
        bspMem->shared.quake2.numnodes = 0;
        oprintf("first cluster for nodes allocated: %7d bytes (%lx)\n", CLUSTER_NODES * sizeof(struct dnode2_t), bspMem->shared.quake2.dnodes);
      }
      if (allocType & LUMP_MODELS) {
        if (bspMem->shared.quake2.dmodels)
  	  tfree(bspMem->shared.quake2.dmodels);
        if (!(bspMem->shared.quake2.dmodels = tmalloc((bspMem->shared.quake2.max_nummodels = CLUSTER_MODELS) * sizeof(struct dmodel2_t))))
  	  Error(failed_memoryunsize, "models");
  
        bspMem->shared.quake2.nummodels = 0;
        oprintf("first cluster for models allocated: %7d bytes (%lx)\n", CLUSTER_MODELS * sizeof(struct dmodel2_t), bspMem->shared.quake2.dmodels);
      }
      if (allocType & LUMP_TEXINFO) {
        if (bspMem->shared.quake2.texinfo)
  	  tfree(bspMem->shared.quake2.texinfo);
        if (!(bspMem->shared.quake2.texinfo = tmalloc((bspMem->shared.quake2.max_numtexinfo = CLUSTER_TEXINFO) * sizeof(struct texinfo2))))
  	  Error(failed_memoryunsize, "texinfo");
  
        bspMem->shared.quake2.numtexinfo = 0;
        oprintf("first cluster for texinfo allocated: %7d bytes (%lx)\n", CLUSTER_TEXINFO * sizeof(struct texinfo2), bspMem->shared.quake2.texinfo);
      }
      if (allocType & LUMP_LEAFS) {
        if (bspMem->shared.quake2.dleafs)
  	  tfree(bspMem->shared.quake2.dleafs);
        if (!(bspMem->shared.quake2.dleafs = tmalloc((bspMem->shared.quake2.max_numleafs = CLUSTER_LEAFS) * sizeof(struct dleaf2_t))))
  	  Error(failed_memoryunsize, "leafs");
  
        bspMem->shared.quake2.numleafs = 0;
        oprintf("first cluster for leafs allocated: %7d bytes (%lx)\n", CLUSTER_LEAFS * sizeof(struct dleaf2_t), bspMem->shared.quake2.dleafs);
      }
      if (allocType & LUMP_LEAFFACES) {
        if (bspMem->shared.quake2.dleaffaces)
  	tfree(bspMem->shared.quake2.dleaffaces);
        if (!(bspMem->shared.quake2.dleaffaces = tmalloc((bspMem->shared.quake2.max_numleaffaces = CLUSTER_LEAFFACES) * sizeof(unsigned short int))))
  	  Error(failed_memoryunsize, "marksurfaces");
  
        bspMem->shared.quake2.numleaffaces = 0;
        oprintf("first cluster for marksurfaces allocated: %7d bytes (%lx)\n", CLUSTER_LEAFFACES * sizeof(unsigned short int), bspMem->shared.quake2.dleaffaces);
      }
    }

    if (allocType & LUMP_TEXTURES) {
      if (bspMem->shared.quake1.dtexdata)
	tfree(bspMem->shared.quake1.dtexdata);
      if (!(bspMem->shared.quake1.dtexdata = tmalloc((bspMem->shared.quake1.max_texdatasize = CLUSTER_TEXTURES) * sizeof(char))))
	  Error(failed_memoryunsize, "textures");
  
      bspMem->shared.quake1.texdatasize = 0;
      oprintf("first cluster for textures allocated: %7d bytes (%lx)\n", CLUSTER_TEXTURES * sizeof(char), bspMem->shared.quake1.dtexdata);
    }
    if (allocType & LUMP_CLIPNODES) {
      if (bspMem->shared.quake1.dclipnodes)
	tfree(bspMem->shared.quake1.dclipnodes);
      if (!(bspMem->shared.quake1.dclipnodes = tmalloc((bspMem->shared.quake1.max_numclipnodes = CLUSTER_CLIPNODES) * sizeof(struct dclipnode_t))))
	  Error(failed_memoryunsize, "clipnodes");
  
      bspMem->shared.quake1.numclipnodes = 0;
      oprintf("first cluster for clipnodes allocated: %7d bytes (%lx)\n", CLUSTER_CLIPNODES * sizeof(struct dclipnode_t), bspMem->shared.quake1.dclipnodes);
    }

    if (allocType & LUMP_AREAS) {
      if (bspMem->shared.quake2.dareas)
	tfree(bspMem->shared.quake2.dareas);
      if (!(bspMem->shared.quake2.dareas = tmalloc((bspMem->shared.quake2.max_numareas = CLUSTER_AREAS) * sizeof(struct darea2_t))))
	  Error(failed_memoryunsize, "areas");

      bspMem->shared.quake2.numareas = 0;
      oprintf("first cluster for areas allocated: %7d bytes (%lx)\n", CLUSTER_AREAS * sizeof(struct darea2_t), bspMem->shared.quake2.dareas);
    }
    if (allocType & LUMP_AREAPORTALS) {
      if (bspMem->shared.quake2.dareaportals)
	tfree(bspMem->shared.quake2.dareaportals);
      if (!(bspMem->shared.quake2.dareaportals = tmalloc((bspMem->shared.quake2.max_numareaportals = CLUSTER_AREAPORTALS) * sizeof(struct dareaportal2_t))))
	  Error(failed_memoryunsize, "areaportals");

      bspMem->shared.quake2.numareaportals = 0;
      oprintf("first cluster for areaportals allocated: %7d bytes (%lx)\n", CLUSTER_AREAPORTALS * sizeof(struct dareaportal2_t), bspMem->shared.quake2.dareaportals);
    }
    if (allocType & LUMP_BRUSHES) {
      if (bspMem->shared.quake2.dbrushes)
	tfree(bspMem->shared.quake2.dbrushes);
      if (!(bspMem->shared.quake2.dbrushes = tmalloc((bspMem->shared.quake2.max_numbrushes = CLUSTER_BRUSHES) * sizeof(struct dbrush2_t))))
	  Error(failed_memoryunsize, "brushes");

      bspMem->shared.quake2.numbrushes = 0;
      oprintf("first cluster for brushes allocated: %7d bytes (%lx)\n", CLUSTER_BRUSHES * sizeof(struct dbrush2_t), bspMem->shared.quake2.dbrushes);
    }
    if (allocType & LUMP_BRUSHSIDES) {
      if (bspMem->shared.quake2.dbrushsides)
	tfree(bspMem->shared.quake2.dbrushsides);
      if (!(bspMem->shared.quake2.dbrushsides = tmalloc((bspMem->shared.quake2.max_numbrushsides = CLUSTER_BRUSHSIDES) * sizeof(struct dbrushside2_t))))
	  Error(failed_memoryunsize, "brushsides");

      bspMem->shared.quake2.numbrushsides = 0;
      oprintf("first cluster for brushsides allocated: %7d bytes (%lx)\n", CLUSTER_BRUSHSIDES * sizeof(struct dbrushside2_t), bspMem->shared.quake2.dbrushsides);
    }
    if (allocType & LUMP_LEAFBRUSHES) {
      if (bspMem->shared.quake2.dleafbrushes)
	tfree(bspMem->shared.quake2.dleafbrushes);
      if (!(bspMem->shared.quake2.dleafbrushes = tmalloc((bspMem->shared.quake2.max_numleafbrushes = CLUSTER_LEAFBRUSHES) * sizeof(unsigned short int))))
	  Error(failed_memoryunsize, "leafbrushes");

      bspMem->shared.quake2.numleafbrushes = 0;
      oprintf("first cluster for leafbrushes allocated: %7d bytes (%lx)\n", CLUSTER_LEAFBRUSHES * sizeof(unsigned short int), bspMem->shared.quake2.dleafbrushes);
    }

#ifdef	CUSTOM_MAXIMA
    if (!bspMem->maxpoints)
      bspMem->maxpoints = DEFPOINTS;
    if (!bspMem->maxedges)
      bspMem->maxedges = DEFEDGES;
    if (!bspMem->maxedges_in_region)
      bspMem->maxedges_in_region = DEF_EDGES_IN_REGION;
    if (!bspMem->maxportals)
      bspMem->maxportals = DEF_PORTALS;
    if (!bspMem->maxportals_in_leaf)
      bspMem->maxportals_in_leaf = DEF_PORTALS_IN_LEAF;
#endif

    bspMem->availHeaders |= allocType;
  }
}

void AllocMapClusters(mapBase mapMem, int allocType)
{
  if (mapMem) {
    if (allocType & MAP_ENTITIES) {
      if (mapMem->mapentities)
	tfree(mapMem->mapentities);
      if (!(mapMem->mapentities = tmalloc((mapMem->max_nummapentities = CLUSTER_ENTITIES) * sizeof(struct entity))))
	  Error(failed_memoryunsize, "entities");

      mapMem->nummapentities = 0;
      oprintf("first cluster for brushes allocated: %7d bytes (%lx)\n", CLUSTER_ENTITIES * sizeof(struct entity), mapMem->mapentities);
    }
    if (allocType & MAP_TEXSTRINGS) {
      int i;
      char *text;

      if (mapMem->maptexstrings)
	tfree(mapMem->maptexstrings);
      if (!(mapMem->maptexstrings = tmalloc((mapMem->max_nummaptexstrings = CLUSTER_TEXSTRINGS) * (sizeof(char *) + 16))))
	  Error(failed_memoryunsize, "texstrings");

      mapMem->nummaptexstrings = 0;
      for (i = 0, text = (char *)&mapMem->maptexstrings[mapMem->max_nummaptexstrings]; i < mapMem->max_nummaptexstrings; i++, text += 16)
	mapMem->maptexstrings[i] = text;
      oprintf("first cluster for texstrings allocated: %7d bytes (%lx)\n", CLUSTER_TEXSTRINGS * (sizeof(char *) + 16), mapMem->maptexstrings);
    }
    if (allocType & MAP_BRUSHFACES) {
      if (mapMem->brushfaces)
	tfree(mapMem->brushfaces);
      if (!(mapMem->brushfaces = tmalloc((mapMem->max_numbrushfaces = CLUSTER_BRUSHFACES) * sizeof(struct mface))))
	  Error(failed_memoryunsize, "brushfaces");

      mapMem->numbrushfaces = 0;
      oprintf("first cluster for brushfaces allocated: %7d bytes (%lx)\n", CLUSTER_BRUSHFACES * sizeof(struct mface), mapMem->brushfaces);
    }
    if (allocType & MAP_BRUSHPLANES) {
      if (mapMem->brushplanes)
	tfree(mapMem->brushplanes);
      if (!(mapMem->brushplanes = tmalloc((mapMem->max_numbrushplanes = CLUSTER_BRUSHPLANES) * sizeof(struct plane))))
	  Error(failed_memoryunsize, "brushplanes");

      mapMem->numbrushplanes = 0;
      oprintf("first cluster for brushes allocated: %7d bytes (%lx)\n", CLUSTER_BRUSHPLANES * sizeof(struct plane), mapMem->brushplanes);
    }

    mapMem->availHeaders |= allocType;
  }
}

void AllocMDLClusters(mdlBase mdlMem, int allocType)
{
  if (mdlMem) {
    if (allocType & TRIANGLES) {
      if (mdlMem->tris)
	tfree(mdlMem->tris);
      if (mdlMem->triangles)
	tfree(mdlMem->triangles);
      if (mdlMem->degenerate)
	tfree(mdlMem->degenerate);

      if (!(mdlMem->tris = tmalloc((mdlMem->max_numtriangles = CLUSTER_TRIANGLES) * sizeof(struct triangle))))
	Error(failed_memoryunsize, "tris");
      if (!(mdlMem->triangles = tmalloc(CLUSTER_TRIANGLES * sizeof(struct dtriangle))))
	Error(failed_memoryunsize, "triangles");
      if (!(mdlMem->degenerate = tmalloc(CLUSTER_TRIANGLES * sizeof(bool))))
	Error(failed_memoryunsize, "triangle degenerates");

      mdlMem->numtriangles = 0;
      oprintf("first cluster for tris allocated: %7d bytes (%lx)\n", CLUSTER_TRIANGLES * sizeof(struct triangle), mdlMem->tris);
      oprintf("first cluster for triangles allocated: %7d bytes (%lx)\n", CLUSTER_TRIANGLES * sizeof(struct dtriangle), mdlMem->triangles);
      oprintf("first cluster for triangle degenerates allocated: %7d bytes (%lx)\n", CLUSTER_TRIANGLES * sizeof(int), mdlMem->degenerate);
    }
    if (allocType & MODEL_TVERTS) {
      if (mdlMem->verts)
	tfree(mdlMem->verts);
      if (mdlMem->tarray)
	tfree(mdlMem->tarray);
      if (mdlMem->stverts)
	tfree(mdlMem->stverts);
      if (mdlMem->baseverts)
	tfree(mdlMem->baseverts);
      if (mdlMem->vnorms)
	tfree(mdlMem->vnorms);

      if (!(mdlMem->verts = tmalloc((mdlMem->max_numverts = CLUSTER_TVERTS) * sizeof(struct trivert *))))
	Error(failed_memoryunsize, "verts");
      if (!(mdlMem->tarray = tmalloc(CLUSTER_TVERTS * sizeof(struct trivertex))))
	Error(failed_memoryunsize, "tarray");
      if (!(mdlMem->stverts = tmalloc(CLUSTER_TVERTS * sizeof(struct stvert))))
	Error(failed_memoryunsize, "stverts");
      if (!(mdlMem->baseverts = tmalloc(CLUSTER_TVERTS * sizeof(vec3D))))
	Error(failed_memoryunsize, "baseverts");
      if (!(mdlMem->vnorms = tmalloc(CLUSTER_TVERTS * sizeof(struct vertexnormals))))
	Error(failed_memoryunsize, "vnorms");

      mdlMem->numverts = 0;
      oprintf("first cluster for verts allocated: %7d bytes (%lx)\n", CLUSTER_TVERTS * sizeof(struct trivert *), mdlMem->verts);
      oprintf("first cluster for tarray allocated: %7d bytes (%lx)\n", CLUSTER_TVERTS * sizeof(struct trivertex), mdlMem->tarray);
      oprintf("first cluster for stverts allocated: %7d bytes (%lx)\n", CLUSTER_TVERTS * sizeof(struct stvert), mdlMem->stverts);
      oprintf("first cluster for baseverts allocated: %7d bytes (%lx)\n", CLUSTER_TVERTS * sizeof(vec3D), mdlMem->baseverts);
      oprintf("first cluster for vnorms allocated: %7d bytes (%lx)\n", CLUSTER_TVERTS * sizeof(struct vertexnormals), mdlMem->vnorms);
    }
    if (allocType & MODEL_FRAMES) {
      if (mdlMem->frames)
	tfree(mdlMem->frames);

      if (!(mdlMem->frames = tmalloc((mdlMem->max_numframes = CLUSTER_FRAMES) * sizeof(struct aliaspackage))))
	Error(failed_memoryunsize, "frames");

      mdlMem->numframes = 0;
      oprintf("first cluster for frames allocated: %7d bytes (%lx)\n", CLUSTER_FRAMES * sizeof(struct aliaspackage), mdlMem->frames);
    }
    if (allocType & MODEL_SKINS) {
      if (mdlMem->skins)
	tfree(mdlMem->skins);

      if (!(mdlMem->skins = tmalloc((mdlMem->max_numskins = CLUSTER_SKINS) * sizeof(struct aliasskinpackage))))
	Error(failed_memoryunsize, "skins");

      mdlMem->numskins = 0;
      oprintf("first cluster for skins allocated: %7d bytes (%lx)\n", CLUSTER_SKINS * sizeof(struct aliasskinpackage), mdlMem->skins);
    }

    mdlMem->availHeaders |= allocType;
  }
}

void AllocSPRClusters(sprBase sprMem, int allocType)
{
  if (sprMem) {
    if (allocType & SPRITE_FRAMES) {
      if (sprMem->frames)
	tfree(sprMem->frames);

      if (!(sprMem->frames = tmalloc((sprMem->max_numframes = CLUSTER_FRAMES) * sizeof(struct spritepackage))))
	Error(failed_memoryunsize, "frames");

      sprMem->numframes = 0;
      oprintf("first cluster for frames allocated: %7d bytes (%lx)\n", CLUSTER_FRAMES * sizeof(struct spritepackage), sprMem->frames);
    }

    sprMem->availHeaders |= allocType;
  }
}

/*
 * =============
 * ExpandBSP
 * =============
 * for all use trealloc instead ?
 */
void ExpandClusters(memBase baseMem, int allocType)
{
}

void ExpandBSPClusters(bspBase bspMem, int allocType)
{
  if (bspMem) {
    if (!bspMem->bspVersion)
      bspMem->bspVersion = BSP_VERSION_Q1;
    oprintf("expandmask: %lx\n", allocType);

    if (allocType & LUMP_ENTITIES) {
      if (!(bspMem->shared.all.dentdata = trealloc(bspMem->shared.all.dentdata, (bspMem->shared.all.max_entdatasize += CLUSTER_ENTSTRING) * sizeof(char))))
	  Error(failed_memoryunsize, "entities");
      oprintf("additional cluster for entities allocated: %7d bytes (%lx)\n", bspMem->shared.all.max_entdatasize * sizeof(char), bspMem->shared.all.dentdata);
    }
    if (allocType & LUMP_PLANES) {
      if (!(bspMem->shared.all.dplanes = trealloc(bspMem->shared.all.dplanes, (bspMem->shared.all.max_numplanes += CLUSTER_PLANES) * sizeof(struct dplane_t))))
	  Error(failed_memoryunsize, "planes");
      oprintf("additional cluster for planes allocated: %7d bytes (%lx)\n", bspMem->shared.all.max_numplanes * sizeof(struct dplane_t), bspMem->shared.all.dplanes);
    }
    if (allocType & LUMP_VERTEXES) {
      if (!(bspMem->shared.all.dvertexes = trealloc(bspMem->shared.all.dvertexes, (bspMem->shared.all.max_numvertexes += CLUSTER_VERTS) * sizeof(struct dvertex_t))))
	  Error(failed_memoryunsize, "vertexes");
      oprintf("additional cluster for vertexes allocated: %7d bytes (%lx)\n", bspMem->shared.all.max_numvertexes * sizeof(struct dvertex_t), bspMem->shared.all.dvertexes);
    }
    if (allocType & LUMP_FACES) {
      if (!(bspMem->shared.all.dfaces = trealloc(bspMem->shared.all.dfaces, (bspMem->shared.all.max_numfaces += CLUSTER_FACES) * sizeof(struct dface_t))))
	  Error(failed_memoryunsize, "faces");
      oprintf("additional cluster for faces allocated: %7d bytes (%lx)\n", bspMem->shared.all.max_numfaces * sizeof(struct dface_t), bspMem->shared.all.dfaces);
    }
    if (allocType & LUMP_LIGHTING) {
      if (!(bspMem->shared.all.dlightdata = trealloc(bspMem->shared.all.dlightdata, (bspMem->shared.all.max_lightdatasize += CLUSTER_LIGHTING) * sizeof(char))))
	  Error(failed_memoryunsize, "lightdata");
      oprintf("additional cluster for lighting allocated: %7d bytes (%lx)\n", bspMem->shared.all.max_lightdatasize * sizeof(char), bspMem->shared.all.dlightdata);
    }
    if (allocType & LUMP_EDGES) {
      if (!(bspMem->shared.all.dedges = trealloc(bspMem->shared.all.dedges, (bspMem->shared.all.max_numedges += CLUSTER_EDGES) * sizeof(struct dedge_t))))
	  Error(failed_memoryunsize, "edges");
      if (!(bspMem->edgefaces[0] = trealloc(bspMem->edgefaces[0], bspMem->shared.all.max_numedges * sizeof(struct visfacet **))))
	  Error(failed_memoryunsize, "edgefaces[0]");
      if (!(bspMem->edgefaces[1] = trealloc(bspMem->edgefaces[1], bspMem->shared.all.max_numedges * sizeof(struct visfacet **))))
	  Error(failed_memoryunsize, "edgefaces[1]");
      oprintf("additional cluster for edges allocated: %7d bytes (%lx)\n", bspMem->shared.all.max_numedges * sizeof(struct dedge_t), bspMem->shared.all.dedges);
      oprintf("additional cluster for edgefaces[0] allocated: %7d bytes (%lx)\n", bspMem->shared.all.max_numedges * sizeof(struct visfacet **), bspMem->edgefaces[0]);
      oprintf("additional cluster for edgefaces[1] allocated: %7d bytes (%lx)\n", bspMem->shared.all.max_numedges * sizeof(struct visfacet **), bspMem->edgefaces[1]);
    }
    if (allocType & LUMP_SURFEDGES) {
      if (!(bspMem->shared.all.dsurfedges = trealloc(bspMem->shared.all.dsurfedges, (bspMem->shared.all.max_numsurfedges += CLUSTER_SURFEDGES) * sizeof(int))))
	  Error(failed_memoryunsize, "surfedges");
      oprintf("additional cluster for surfedges allocated: %7d bytes (%lx)\n", bspMem->shared.all.max_numsurfedges * sizeof(int), bspMem->shared.all.dsurfedges);
    }

    if(bspMem->bspVersion == BSP_VERSION_Q1) {
      if (allocType & LUMP_VISIBILITY) {
        if (!(bspMem->shared.quake1.dvisdata = trealloc(bspMem->shared.quake1.dvisdata, (bspMem->shared.quake1.max_visdatasize += CLUSTER_VISIBILITY) * sizeof(char))))
  	  Error(failed_memoryunsize, "visibility");
        oprintf("additional cluster for visibility allocated: %7d bytes (%lx)\n", bspMem->shared.quake1.max_visdatasize * sizeof(char), bspMem->shared.quake1.dvisdata);
      }
      if (allocType & LUMP_NODES) {
        if ((bspMem->shared.quake1.dnodes = trealloc(bspMem->shared.quake1.dnodes, (bspMem->shared.quake1.max_numnodes += CLUSTER_NODES) * sizeof(struct dnode_t))))
  	  Error(failed_memoryunsize, "nodes");
        oprintf("additional cluster for nodes allocated: %7d bytes (%lx)\n", bspMem->shared.quake1.max_numnodes * sizeof(struct dnode_t), bspMem->shared.quake1.dnodes);
      }
      if (allocType & LUMP_TEXINFO) {
        if (!(bspMem->shared.quake1.texinfo = trealloc(bspMem->shared.quake1.texinfo, (bspMem->shared.quake1.max_numtexinfo += CLUSTER_TEXINFO) * sizeof(struct texinfo))))
  	  Error(failed_memoryunsize, "texinfo");
        oprintf("additional cluster for texinfo allocated: %7d bytes (%lx)\n", bspMem->shared.quake1.max_numtexinfo * sizeof(struct texinfo), bspMem->shared.quake1.texinfo);
      }
      if (allocType & LUMP_MODELS) {
        if (!(bspMem->shared.quake1.dmodels = trealloc(bspMem->shared.quake1.dmodels, (bspMem->shared.quake1.max_nummodels += CLUSTER_MODELS) * sizeof(struct dmodel_t))))
  	  Error(failed_memoryunsize, "models");
        oprintf("additional cluster for models allocated: %7d bytes (%lx)\n", bspMem->shared.quake1.max_nummodels * sizeof(struct dmodel_t), bspMem->shared.quake1.dmodels);
      }
      if (allocType & LUMP_LEAFS) {
        if (!(bspMem->shared.quake1.dleafs = trealloc(bspMem->shared.quake1.dleafs, (bspMem->shared.quake1.max_numleafs += CLUSTER_LEAFS) * sizeof(struct dleaf_t))))
  	  Error(failed_memoryunsize, "leafs");
        oprintf("additional cluster for leafs allocated: %7d bytes (%lx)\n", bspMem->shared.quake1.max_numleafs * sizeof(struct dleaf_t), bspMem->shared.quake1.dleafs);
      }
      if (allocType & LUMP_MARKSURFACES) {
        if (!(bspMem->shared.quake1.dmarksurfaces = trealloc(bspMem->shared.quake1.dmarksurfaces, (bspMem->shared.quake1.max_nummarksurfaces += CLUSTER_MARKSURFACES) * sizeof(unsigned short int))))
  	  Error(failed_memoryunsize, "marksurfaces");
        oprintf("additional cluster for marksurfaces allocated: %7d bytes (%lx)\n", bspMem->shared.quake1.max_nummarksurfaces * sizeof(unsigned short int), bspMem->shared.quake1.dmarksurfaces);
      }
    }
    else if(bspMem->bspVersion == BSP_VERSION_Q2) {
      if (allocType & LUMP_VISIBILITY) {
        if (!(bspMem->shared.quake2.clusters = trealloc(bspMem->shared.quake2.clusters, (bspMem->shared.quake2.max_numclusters += CLUSTER_VISIBILITY) * sizeof(struct dvis2_t)))) 
  	  Error(failed_memoryunsize, "visibility");
        oprintf("additional cluster for visibility allocated: %7d bytes (%lx)\n", bspMem->shared.quake2.max_numclusters * sizeof(char), bspMem->shared.quake2.clusters);
      }
      if (allocType & LUMP_NODES) {
        if ((bspMem->shared.quake2.dnodes = trealloc(bspMem->shared.quake2.dnodes, (bspMem->shared.quake2.max_numnodes += CLUSTER_NODES) * sizeof(struct dnode2_t))))
  	  Error(failed_memoryunsize, "nodes");
        oprintf("additional cluster for nodes allocated: %7d bytes (%lx)\n", bspMem->shared.quake2.max_numnodes * sizeof(struct dnode2_t), bspMem->shared.quake2.dnodes);
      }
      if (allocType & LUMP_TEXINFO) {
        if (!(bspMem->shared.quake2.texinfo = trealloc(bspMem->shared.quake2.texinfo, (bspMem->shared.quake2.max_numtexinfo += CLUSTER_TEXINFO) * sizeof(struct texinfo2))))
  	  Error(failed_memoryunsize, "texinfo");
        oprintf("additional cluster for texinfo allocated: %7d bytes (%lx)\n", bspMem->shared.quake2.max_numtexinfo * sizeof(struct texinfo2), bspMem->shared.quake2.texinfo);
      }
      if (allocType & LUMP_MODELS) {
        if (!(bspMem->shared.quake2.dmodels = trealloc(bspMem->shared.quake2.dmodels, (bspMem->shared.quake2.max_nummodels += CLUSTER_MODELS) * sizeof(struct dmodel2_t))))
  	  Error(failed_memoryunsize, "models");
        oprintf("additional cluster for models allocated: %7d bytes (%lx)\n", bspMem->shared.quake2.max_nummodels * sizeof(struct dmodel2_t), bspMem->shared.quake2.dmodels);
      }
      if (allocType & LUMP_LEAFS) {
        if (!(bspMem->shared.quake2.dleafs = trealloc(bspMem->shared.quake2.dleafs, (bspMem->shared.quake2.max_numleafs += CLUSTER_LEAFS) * sizeof(struct dleaf2_t))))
  	  Error(failed_memoryunsize, "leafs");
        oprintf("additional cluster for leafs allocated: %7d bytes (%lx)\n", bspMem->shared.quake2.max_numleafs * sizeof(struct dleaf2_t), bspMem->shared.quake2.dleafs);
      }
      if (allocType & LUMP_LEAFFACES) {
        if (!(bspMem->shared.quake2.dleaffaces = trealloc(bspMem->shared.quake2.dleaffaces, (bspMem->shared.quake2.max_numleaffaces += CLUSTER_LEAFFACES) * sizeof(unsigned short int))))
  	  Error(failed_memoryunsize, "marksurfaces");
        oprintf("additional cluster for marksurfaces allocated: %7d bytes (%lx)\n", bspMem->shared.quake2.max_numleaffaces * sizeof(unsigned short int), bspMem->shared.quake2.dleaffaces);
      }
    }

    if (allocType & LUMP_TEXTURES) {
      if (!(bspMem->shared.quake1.dtexdata = trealloc(bspMem->shared.quake1.dtexdata, (bspMem->shared.quake1.max_texdatasize += CLUSTER_TEXTURES) * sizeof(char))))
	  Error(failed_memoryunsize, "textures");
      oprintf("additional cluster for textures allocated: %7d bytes (%lx)\n", bspMem->shared.quake1.max_texdatasize * sizeof(char), bspMem->shared.quake1.dtexdata);
    }
    if (allocType & LUMP_CLIPNODES) {
      if (!(bspMem->shared.quake1.dclipnodes = trealloc(bspMem->shared.quake1.dclipnodes, (bspMem->shared.quake1.max_numclipnodes += CLUSTER_CLIPNODES) * sizeof(struct dclipnode_t))))
	  Error(failed_memoryunsize, "clipnodes");
      oprintf("additional cluster for clipnodes allocated: %7d bytes (%lx)\n", bspMem->shared.quake1.max_numclipnodes * sizeof(struct dclipnode_t), bspMem->shared.quake1.dclipnodes);
    }

    if (allocType & LUMP_AREAS) {
      if (!(bspMem->shared.quake2.dareas = trealloc(bspMem->shared.quake2.dareas, (bspMem->shared.quake2.max_numareas += CLUSTER_AREAS) * sizeof(struct darea2_t))))
	  Error(failed_memoryunsize, "areas");
      oprintf("additional cluster for areas allocated: %7d bytes (%lx)\n", bspMem->shared.quake2.max_numareas * sizeof(struct darea2_t), bspMem->shared.quake2.dareas);
    }
    if (allocType & LUMP_AREAPORTALS) {
      if (!(bspMem->shared.quake2.dareaportals = trealloc(bspMem->shared.quake2.dareaportals, (bspMem->shared.quake2.max_numareaportals += CLUSTER_AREAPORTALS) * sizeof(struct dareaportal2_t))))
	  Error(failed_memoryunsize, "areaportals");
      oprintf("additional cluster for areaportals allocated: %7d bytes (%lx)\n", bspMem->shared.quake2.max_numareaportals * sizeof(struct dareaportal2_t), bspMem->shared.quake2.dareaportals);
    }
    if (allocType & LUMP_BRUSHES) {
      if (!(bspMem->shared.quake2.dbrushes = trealloc(bspMem->shared.quake2.dbrushes, (bspMem->shared.quake2.max_numbrushes += CLUSTER_BRUSHES) * sizeof(struct dbrush2_t))))
	  Error(failed_memoryunsize, "brushes");
      oprintf("additional cluster for brushes allocated: %7d bytes (%lx)\n", bspMem->shared.quake2.max_numbrushes * sizeof(struct dbrush2_t), bspMem->shared.quake2.dbrushes);
    }
    if (allocType & LUMP_BRUSHSIDES) {
      if (!(bspMem->shared.quake2.dbrushsides = trealloc(bspMem->shared.quake2.dbrushsides, (bspMem->shared.quake2.max_numbrushsides += CLUSTER_BRUSHSIDES) * sizeof(struct dbrushside2_t))))
	  Error(failed_memoryunsize, "brushsides");
      oprintf("additional cluster for brushsides allocated: %7d bytes (%lx)\n", bspMem->shared.quake2.max_numbrushsides * sizeof(struct dbrushside2_t), bspMem->shared.quake2.dbrushsides);
    }
    if (allocType & LUMP_LEAFBRUSHES) {
      if (!(bspMem->shared.quake2.dleafbrushes = trealloc(bspMem->shared.quake2.dleafbrushes, (bspMem->shared.quake2.max_numleafbrushes += CLUSTER_LEAFBRUSHES) * sizeof(unsigned short int))))
	  Error(failed_memoryunsize, "leafbrushes");
      oprintf("additional cluster for leafbrushes allocated: %7d bytes (%lx)\n", bspMem->shared.quake2.max_numleafbrushes * sizeof(unsigned short int), bspMem->shared.quake2.dleafbrushes);
    }

#ifdef	CUSTOM_MAXIMA
    if (!bspMem->maxpoints)
      bspMem->maxpoints = DEFPOINTS;
    if (!bspMem->maxedges)
      bspMem->maxedges = DEFEDGES;
    if (!bspMem->maxedges_in_region)
      bspMem->maxedges_in_region = DEF_EDGES_IN_REGION;
    if (!bspMem->maxportals)
      bspMem->maxportals = DEF_PORTALS;
    if (!bspMem->maxportals_in_leaf)
      bspMem->maxportals_in_leaf = DEF_PORTALS_IN_LEAF;
#endif

    bspMem->availHeaders |= allocType;
  }
}

void ExpandMapClusters(mapBase mapMem, int allocType)
{
  if (mapMem) {
    if (allocType & MAP_ENTITIES) {
      if (!(mapMem->mapentities = trealloc(mapMem->mapentities, (mapMem->max_nummapentities += CLUSTER_ENTITIES) * sizeof(struct entity))))
	  Error(failed_memoryunsize, "entities");
      oprintf("additional cluster for mapentities allocated: %7d bytes (%lx)\n", mapMem->max_nummapentities * sizeof(struct entity), mapMem->mapentities);
    }
    if (allocType & MAP_TEXSTRINGS) {
      int i;
      char *text;
      char **maptexstrings = mapMem->maptexstrings;
      if (!(mapMem->maptexstrings = tmalloc((mapMem->max_nummaptexstrings += CLUSTER_TEXSTRINGS) * (sizeof(char *) + 16))))
	  Error(failed_memoryunsize, "texstrings");

      for (i = 0, text = (char *)&mapMem->maptexstrings[mapMem->max_nummaptexstrings]; i < mapMem->max_nummaptexstrings; i++, text += 16)
	mapMem->maptexstrings[i] = text;
      __memcpy(mapMem->maptexstrings[0], maptexstrings[0], mapMem->nummaptexstrings * 16);
      tfree(maptexstrings);
      oprintf("additional cluster for mapstrings allocated: %7d bytes (%lx)\n", mapMem->max_nummaptexstrings * (sizeof(char *) + 16), mapMem->maptexstrings);
    }
    if (allocType & MAP_BRUSHFACES) {
      if (!(mapMem->brushfaces = trealloc(mapMem->brushfaces, (mapMem->max_numbrushplanes += CLUSTER_BRUSHFACES) * sizeof(struct mface))))
	  Error(failed_memoryunsize, "brushfaces");
      oprintf("additional cluster for brushplanes allocated: %7d bytes (%lx)\n", mapMem->max_numbrushplanes * sizeof(struct mface), mapMem->brushfaces);
    }
    if (allocType & MAP_BRUSHPLANES) {
      if (!(mapMem->brushplanes = trealloc(mapMem->brushplanes, (mapMem->max_numbrushplanes += CLUSTER_BRUSHPLANES) * sizeof(struct plane))))
	  Error(failed_memoryunsize, "brushplanes");
      oprintf("additional cluster for brushplanes allocated: %7d bytes (%lx)\n", mapMem->max_numbrushplanes * sizeof(struct plane), mapMem->brushplanes);
    }

    mapMem->availHeaders |= allocType;
  }
}

void ExpandMDLClusters(mdlBase mdlMem, int allocType)
{
  if (mdlMem) {
    if (allocType & TRIANGLES) {
      if (!(mdlMem->tris = trealloc(mdlMem->tris, (mdlMem->max_numtriangles += CLUSTER_TRIANGLES) * sizeof(struct triangle))))
	Error(failed_memoryunsize, "triangles");
      if (!(mdlMem->triangles = trealloc(mdlMem->triangles, mdlMem->max_numtriangles * sizeof(struct dtriangle))))
	Error(failed_memoryunsize, "triangles");
      if (!(mdlMem->degenerate = trealloc(mdlMem->degenerate, mdlMem->max_numtriangles * sizeof(bool))))
	Error(failed_memoryunsize, "triangle degenerates");

      oprintf("additional cluster for tris allocated: %7d bytes (%lx)\n", mdlMem->max_numtriangles * sizeof(struct triangle), mdlMem->tris);
      oprintf("additional cluster for triangles allocated: %7d bytes (%lx)\n", mdlMem->max_numtriangles * sizeof(struct dtriangle), mdlMem->triangles);
      oprintf("additional cluster for triangle degenerates allocated: %7d bytes (%lx)\n", mdlMem->max_numtriangles * sizeof(int), mdlMem->degenerate);
    }
    if (allocType & MODEL_TVERTS) {
      if (!(mdlMem->verts = trealloc(mdlMem->verts, (mdlMem->max_numverts += CLUSTER_TVERTS) * sizeof(struct trivert *))))
	Error(failed_memoryunsize, "verts");
      if (!(mdlMem->tarray = trealloc(mdlMem->tarray, mdlMem->max_numverts * sizeof(struct trivertex))))
	Error(failed_memoryunsize, "tarray");
      if (!(mdlMem->stverts = trealloc(mdlMem->stverts, mdlMem->max_numverts * sizeof(struct stvert))))
	Error(failed_memoryunsize, "stverts");
      if (!(mdlMem->baseverts = trealloc(mdlMem->baseverts, mdlMem->max_numverts * sizeof(vec3D))))
	Error(failed_memoryunsize, "baseverts");
      if (!(mdlMem->vnorms = trealloc(mdlMem->vnorms, mdlMem->max_numverts * sizeof(struct vertexnormals))))
	Error(failed_memoryunsize, "vnorms");

      oprintf("additional cluster for verts allocated: %7d bytes (%lx)\n", mdlMem->max_numverts * sizeof(struct trivert *), mdlMem->verts);
      oprintf("additional cluster for tarray allocated: %7d bytes (%lx)\n", mdlMem->max_numverts * sizeof(struct trivertex), mdlMem->tarray);
      oprintf("additional cluster for stverts allocated: %7d bytes (%lx)\n", mdlMem->max_numverts * sizeof(struct stvert), mdlMem->stverts);
      oprintf("additional cluster for baseverts allocated: %7d bytes (%lx)\n", mdlMem->max_numverts * sizeof(vec3D), mdlMem->baseverts);
      oprintf("additional cluster for vnorms allocated: %7d bytes (%lx)\n", mdlMem->max_numverts * sizeof(struct vertexnormals), mdlMem->vnorms);
    }
    if (allocType & MODEL_FRAMES) {
      if (!(mdlMem->frames = trealloc(mdlMem->frames, (mdlMem->max_numframes += CLUSTER_FRAMES) * sizeof(struct aliaspackage))))
	Error(failed_memoryunsize, "frames");
      oprintf("additional cluster for frames allocated: %7d bytes (%lx)\n", mdlMem->max_numframes * sizeof(struct aliaspackage), mdlMem->frames);
    }
    if (allocType & MODEL_SKINS) {
      if (!(mdlMem->skins = trealloc(mdlMem->skins, (mdlMem->max_numskins += CLUSTER_SKINS) * sizeof(struct aliasskinpackage))))
	Error(failed_memoryunsize, "skins");
      oprintf("additional cluster for skins allocated: %7d bytes (%lx)\n", mdlMem->max_numskins * sizeof(struct aliasskinpackage), mdlMem->skins);
    }

    mdlMem->availHeaders |= allocType;
  }
}

void ExpandSPRClusters(sprBase sprMem, int allocType)
{
  if (sprMem) {
    if (allocType & SPRITE_FRAMES) {
      if (!(sprMem->frames = trealloc(sprMem->frames, (sprMem->max_numframes += CLUSTER_FRAMES) * sizeof(struct spritepackage))))
	Error(failed_memoryunsize, "frames");
      oprintf("additional cluster for frames allocated: %7d bytes (%lx)\n", sprMem->max_numframes * sizeof(struct spritepackage), sprMem->frames);
    }

    sprMem->availHeaders |= allocType;
  }
}

/*
 * =============
 * FreeBSP
 * =============
 */
void FreeClusters(memBase baseMem, int freeType)
{
}

void FreeBSPClusters(bspBase bspMem, int freeType)
{
  if (bspMem) {
    int newfree = freeType ? freeType : bspMem->availHeaders;
  
    if (!bspMem->bspVersion)
      bspMem->bspVersion = BSP_VERSION_Q1;

    oprintf("freemask: %lx\n", newfree);

    if ((bspMem->availHeaders & newfree & LUMP_ENTITIES)) {
      oprintf("free entities\n");
      tfree(bspMem->shared.all.dentdata);
    }
    if ((bspMem->availHeaders & newfree & LUMP_PLANES)) {
      oprintf("free planes\n");
      tfree(bspMem->shared.all.dplanes);
    }
    if ((bspMem->availHeaders & newfree & LUMP_VERTEXES)) {
      oprintf("free vertexes\n");
      tfree(bspMem->shared.all.dvertexes);
    }
    if ((bspMem->availHeaders & newfree & LUMP_FACES)) {
      oprintf("free faces\n");
      tfree(bspMem->shared.all.dfaces);
    }
    if ((bspMem->availHeaders & newfree & LUMP_LIGHTING)) {
      oprintf("free lighting\n");
      tfree(bspMem->shared.all.dlightdata);
    }
    if ((bspMem->availHeaders & newfree & LUMP_EDGES)) {
      oprintf("free edges\n");
      tfree(bspMem->shared.all.dedges);
      if (bspMem->edgefaces[0])
	tfree(bspMem->edgefaces[0]);
      if (bspMem->edgefaces[1])
	tfree(bspMem->edgefaces[1]);
    }
    if ((bspMem->availHeaders & newfree & LUMP_SURFEDGES)) {
      oprintf("free surfedges\n");
      tfree(bspMem->shared.all.dsurfedges);
    }

    if(bspMem->bspVersion == BSP_VERSION_Q1) {
      if ((bspMem->availHeaders & newfree & LUMP_VISIBILITY)) {
        oprintf("free visibility\n");
        tfree(bspMem->shared.quake1.dvisdata);
      }
      if ((bspMem->availHeaders & newfree & LUMP_NODES)) {
        oprintf("free nodes\n");
        tfree(bspMem->shared.quake1.dnodes);
      }
      if ((bspMem->availHeaders & newfree & LUMP_TEXINFO)) {
        oprintf("free texinfo\n");
        tfree(bspMem->shared.quake1.texinfo);
      }
      if ((bspMem->availHeaders & newfree & LUMP_LEAFS)) {
        oprintf("free leafs\n");
        tfree(bspMem->shared.quake1.dleafs);
      }
      if ((bspMem->availHeaders & newfree & LUMP_MODELS)) {
        oprintf("free models\n");
        tfree(bspMem->shared.quake1.dmodels);
      }
      if ((bspMem->availHeaders & newfree & LUMP_MARKSURFACES)) {
        oprintf("free marksurfaces\n");
        tfree(bspMem->shared.quake1.dmarksurfaces);
      }
    }
    else if(bspMem->bspVersion == BSP_VERSION_Q2) {
      if ((bspMem->availHeaders & newfree & LUMP_VISIBILITY)) {
        oprintf("free visibility\n");
        tfree(bspMem->shared.quake2.clusters);
      }
      if ((bspMem->availHeaders & newfree & LUMP_NODES)) {
        oprintf("free nodes\n");
        tfree(bspMem->shared.quake2.dnodes);
      }
      if ((bspMem->availHeaders & newfree & LUMP_TEXINFO)) {
        oprintf("free texinfo\n");
        tfree(bspMem->shared.quake2.texinfo);
      }
      if ((bspMem->availHeaders & newfree & LUMP_LEAFS)) {
        oprintf("free leafs\n");
        tfree(bspMem->shared.quake2.dleafs);
      }
      if ((bspMem->availHeaders & newfree & LUMP_MODELS)) {
        oprintf("free models\n");
        tfree(bspMem->shared.quake2.dmodels);
      }
      if ((bspMem->availHeaders & newfree & LUMP_LEAFFACES)) {
        oprintf("free marksurfaces\n");
        tfree(bspMem->shared.quake2.dleaffaces);
      }
    }

    if ((bspMem->availHeaders & newfree & LUMP_TEXTURES)) {
      oprintf("free textures\n");
      tfree(bspMem->shared.quake1.dtexdata);
    }
    if ((bspMem->availHeaders & newfree & LUMP_CLIPNODES)) {
      oprintf("free clipnodes\n");
      tfree(bspMem->shared.quake1.dclipnodes);
    }

    if ((bspMem->availHeaders & newfree & LUMP_AREAS)) {
      oprintf("free areas\n");
      tfree(bspMem->shared.quake2.dareas);
    }
    if ((bspMem->availHeaders & newfree & LUMP_AREAPORTALS)) {
      oprintf("free areaportals\n");
      tfree(bspMem->shared.quake2.dareaportals);
    }
    if ((bspMem->availHeaders & newfree & LUMP_BRUSHES)) {
      oprintf("free brushes\n");
      tfree(bspMem->shared.quake2.dbrushes);
    }
    if ((bspMem->availHeaders & newfree & LUMP_BRUSHSIDES)) {
      oprintf("free brushsides\n");
      tfree(bspMem->shared.quake2.dbrushsides);
    }
    if ((bspMem->availHeaders & newfree & LUMP_LEAFBRUSHES)) {
      oprintf("free leafbrushes\n");
      tfree(bspMem->shared.quake2.dleafbrushes);
    }

    bspMem->availHeaders &= ~newfree;
  }
}

void FreeMapClusters(mapBase mapMem, int freeType)
{
  if (mapMem) {
    int newfree = freeType ? freeType : mapMem->availHeaders;
  
    if ((mapMem->availHeaders & newfree & MAP_ENTITIES)) {
      struct entity *ent;
      int i;

      oprintf("free entities\n");
      for (i = 0, ent = mapMem->mapentities; i < mapMem->nummapentities; i++, ent++) {
	struct epair *ep = ent->epairs;
	struct mbrush *mbr = ent->brushes;

	while (ep) {
	  struct epair *en = ep->next;

	  tfree(ep->key);
	  tfree(ep->value);
	  tfree(ep);
	  ep = en;
	}
	while (mbr) {
	  struct mbrush *mbn = mbr->next;
	  struct mface *mfc = mbr->faces;

	  while (mfc) {
	    struct mface *mfn = mfc->next;

	    tfree(mfc);
	    mfc = mfn;
	  }
	  tfree(mbr);
	  mbr = mbn;
	}
      }
      tfree(mapMem->mapentities);
    }
    if ((mapMem->availHeaders & newfree & MAP_TEXSTRINGS)) {
      oprintf("free texstrings\n");
      tfree(mapMem->maptexstrings);
    }
    if ((mapMem->availHeaders & newfree & MAP_BRUSHFACES)) {
      oprintf("free brushfaces\n");
      tfree(mapMem->brushfaces);
    }
    if ((mapMem->availHeaders & newfree & MAP_BRUSHPLANES)) {
      oprintf("free brushmaps\n");
      tfree(mapMem->brushplanes);
    }

    mapMem->availHeaders &= ~newfree;
  }
}

void FreeMDLClusters(mdlBase mdlMem, int freeType)
{
  if (mdlMem) {
    int newfree = freeType ? freeType : mdlMem->availHeaders;
  
    if (mdlMem->availHeaders & freeType & TRIANGLES) {
      tfree(mdlMem->tris);
      tfree(mdlMem->triangles);
      tfree(mdlMem->degenerate);
      oprintf("free tris\n");
      oprintf("free triangles\n");
      oprintf("free triangle degenerates\n");
    }
    if (mdlMem->availHeaders & freeType & MODEL_TVERTS) {
      tfree(mdlMem->verts);
      tfree(mdlMem->tarray);
      tfree(mdlMem->stverts);
      tfree(mdlMem->baseverts);
      tfree(mdlMem->vnorms);
      oprintf("free verts\n");
      oprintf("free tarray\n");
      oprintf("free stverts\n");
      oprintf("free baseverts\n");
      oprintf("free vnorms\n");
    }
    if (mdlMem->availHeaders & freeType & MODEL_FRAMES) {
      tfree(mdlMem->frames);
      oprintf("free frames\n");
    }
    if (mdlMem->availHeaders & freeType & MODEL_SKINS) {
      tfree(mdlMem->skins);
      oprintf("free skins\n");
    }

    mdlMem->availHeaders &= ~newfree;
  }
}

void FreeSPRClusters(sprBase sprMem, int freeType)
{
  if (sprMem) {
    int newfree = freeType ? freeType : sprMem->availHeaders;
  
    if (sprMem->availHeaders & freeType & SPRITE_FRAMES) {
      tfree(sprMem->frames);
      oprintf("free frames\n");
    }

    sprMem->availHeaders &= ~newfree;
  }
}
