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

#ifndef	MIP_H
#define	MIP_H
/*
 * ============================================================================
 * structures
 * ============================================================================
 */
struct mipheader {
  int numtex;
  int offset[0];
};

enum mipmapoffset {
  MIPMAP_0 = 0,
  MIPMAP_1 = 1,
  MIPMAP_2 = 2,
  MIPMAP_3 = 3
} __packed;

#define	MIPMAP_MAX	4

#define NAMELEN_MIP	16
struct mipmap {
  char name[16];
  int width, height;
  int offsets[MIPMAP_MAX];
};

#define ANIM_MIPMAP	'+'
#define WARP_MIPMAP	'*'
#define	WARP_SHIFT	6
#define WARP_X		(1 << WARP_SHIFT)
#define WARP_Y		(1 << WARP_SHIFT)
#define	WARP_MASK	((1 << WARP_SHIFT) - 1)
#define SKY_MIPMAP	"sky"
#define SKY_X		256
#define SKY_Y		128
#define CLIP_MIPMAP	"clip"		/* don't load, don't draw */
#define MIRROR_MIPMAP	"mirror"	/* don't load, mirrored draw */
#define TRIGGER_MIPMAP	"trigger"	/* ??? */

#define	MAX_ANIMFRAMES	(10 + ('Z' - 'A'))

/*
 * results in:
 * "+0*" for animated warp
 * "+0sky" for animated skies
 * "clip" for invisibles but blocking
 * "mirror" for visible but dynamicaly generated
 */
#define	isAnim(name)			((name[0] == ANIM_MIPMAP))
#define	isWarp(name)			((name[0] == WARP_MIPMAP) ||	\
			(isAnim(name) && (name[2] == WARP_MIPMAP)))
#define	isWater(name)			((name[0] == WARP_MIPMAP) ||	\
			(isAnim(name) && (name[2] == WARP_MIPMAP)))
#define	isSlime(name)		       (((name[0] == WARP_MIPMAP) && (name[1] == 's')) ||	\
			(isAnim(name) && (name[2] == WARP_MIPMAP) && (name[3] == 's')))
#define	isLava(name)		       (((name[0] == WARP_MIPMAP) && (name[1] == 'l')) ||	\
			(isAnim(name) && (name[2] == WARP_MIPMAP) && (name[3] == 'l')))
#define	isTele(name)		       (((name[0] == WARP_MIPMAP) && (name[1] == 't')) ||	\
			(isAnim(name) && (name[2] == WARP_MIPMAP) && (name[3] == 't')))
#define	isSky(name)		       (((name[0] == 's') && (name[1] == 'k') && (name[2] == 'y')) ||	\
			(isAnim(name) && (name[2] == 's') && (name[3] == 'k') && (name[4] == 'y')))
#define	isClip(name)	(!__strcmp(name, CLIP_MIPMAP))
#define	isMirror(name)	(!__strcmp(name, MIRROR_MIPMAP))
#define	isTrigger(name)	(!__strcmp(name, TRIGGER_MIPMAP))

#define NAMELEN_WAL	32
struct wal {
  char name[NAMELEN_WAL];
  int width, height;
  int offsets[MIPMAP_MAX];
  char animname[NAMELEN_WAL];
  int flags, contents, value;
};

#define	MIP_MULT(x)	((x)+(x/(2*2))+(x/(4*4))+(x/(8*8)))

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

struct palpic *GetMipMap(HANDLE file, enum mipmapoffset MipLevel);
struct palpic *ParseMipMap(struct mipmap *MipMap, enum mipmapoffset MipLevel);
bool PutMipMap(HANDLE file, struct palpic *Picture);
bool PutMipMap0(HANDLE file, struct palpic *Picture);
bool PasteMipMap(struct mipmap *MipMap, struct palpic *Picture);
bool PasteMipMap0(struct mipmap *MipMap, struct palpic *Picture);

#endif
