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

#ifndef	MDL_H
#define	MDL_H

/*
 * ============================================================================
 * structures
 * ============================================================================
 */
#define MAGIC_MDL_Q1	MKID('I','D','P','O')	/* 0x4944504F */
#define MAGIC_MDL_Q2	MKID('I','D','P','2')	/* 0x4944504F */

#define MDL_VERSION_Q1	6
#define MDL_VERSION_Q2	8

#define MDL_ONSEAM	0x0020

typedef enum {
  ST_SYNC = 0, ST_RAND
} synctype_t;

typedef enum {
  MDL_SINGLE = 0, MDL_GROUP
} aliasframetype_t;

typedef enum {
  MDL_SKIN_SINGLE = 0, MDL_SKIN_GROUP
} aliasskintype_t;

struct dmdlheader {
  int ident;
  int version;
  float scale[3];
  float scale_origin[3];
  float boundingradius;
  float eyeposition[3];
  int numskins;
  int skinwidth;
  int skinheight;
  int numverts;
  int numtris;
  int numframes;
  synctype_t synctype;
  int flags;
  float size;
};

/*
 * the glcmd format:
 * a positive integer starts a tristrip command, followed by that many
 * vertex structures.
 * a negative integer starts a trifan command, followed by -x vertexes
 * a zero indicates the end of the command list.
 * a vertex consists of a floating point s, a floating point t,
 * and an integer vertex index.
 */
struct dmdlheader2 {
  int ident;
  int version;
  int skinwidth;
  int skinheight;
  int framesize;							       /* byte size of each frame */
  int num_skins;
  int num_xyz;
  int num_st;								       /* greater than num_xyz for seams */
  int num_tris;
  int num_glcmds;							       /* dwords in strip/fan command list */
  int num_frames;
  int ofs_skins;							       /* each skin is a MAX_SKINNAME string */
  int ofs_st;								       /* byte offset from start for stverts */
  int ofs_tris;								       /* offset for dtriangles */
  int ofs_frames;							       /* offset for first frame */
  int ofs_glcmds;
  int ofs_end;								       /* end of file */
};

struct stvert {
  int onseam;
  int s;
  int t;
};

struct stvert2 {
  int s;
  int t;
};

/*
 * disk-structures
 */

struct dtriangle {
  int facesfront;
  int vertindex[3];
};

struct dtriangle2 {
  short index_xyz[3];
  short index_st[3];
};

#define DT_FACES_FRONT	0x0010

#define DTRIVERTX_V0	0
#define DTRIVERTX_V1	1
#define DTRIVERTX_V2	2
#define DTRIVERTX_LNI	3
#define DTRIVERTX_SIZE	4

struct trivertex {
  unsigned char v[3];
  unsigned char lightnormalindex;
};

struct daliasframe {
  struct trivertex bboxmin;					/* lightnormal isn't used */
  struct trivertex bboxmax;					/* lightnormal isn't used */

  char name[16];						/* frame name from grabbing */
};

struct daliasframe2 {
  float scale[3];						/* multiply byte verts by this */
  float translate[3];						/* then add this */

  char name[16];						/* frame name from grabbing */
  struct trivertex verts[1];					/* variable sized */
};

struct daliasgroup {
  int numframes;

  struct trivertex bboxmin;					/* lightnormal isn't used */
  struct trivertex bboxmax;					/* lightnormal isn't used */
};

struct daliasskingroup {
  int numskins;
};

struct daliasinterval {
  float interval;
};

struct daliasskininterval {
  float interval;
};

struct daliasframetype {
  aliasframetype_t type;
};

struct daliasskintype {
  aliasskintype_t type;
};

/*
 * local program-structures
 */

struct aliaspackage {
  /* single frame or group of frames */
  aliasframetype_t type;
  /* either a daliasframe_t or group info */
  void *pdata;
  /* only used for frames in groups */
  vec1D interval;
  /* only used by group headers */
  int numgroupframes;

  char name[16];
} __packed;

struct aliasskinpackage {
  /* single skin or group of skiins */
  aliasskintype_t type;
  /* either a daliasskinframe_t or group info */
  void *pdata;
  /* only used for skins in groups */
  vec1D interval;
  /* only used by group headers */
  int numgroupskins;
} __packed;

struct vertexnormals {
  int numnormals;
  vec1D normals[20][3];
} __packed;

struct trivert {
  vec3D v;

  int lightnormalindex;
} __packed;

/*
 * ============================================================================
 * globals
 * ============================================================================
 */

/*
 * ============================================================================
 * prototypes
 * ============================================================================
 */

#endif
