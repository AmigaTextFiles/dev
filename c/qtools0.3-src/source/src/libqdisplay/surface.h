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

#ifndef SURFACES_H
#define SURFACES_H

#define ABS(a) ((a) >= 0 ? (a) : -(a))

#define WALL_TYPE	0x01	/*(~CONTENTS_SOLID)			/* -2 */
#define WATER_TYPE	0x02	/*(~CONTENTS_WATER)			/* -3 */
#define SLIME_TYPE	0x03	/*(~CONTENTS_SLIME)			/* -4 */
#define LAVA_TYPE	0x04	/*(~CONTENTS_LAVA)			/* -5 */
#define SKY_TYPE	0x05	/*(~CONTENTS_SKY)			/* -6 */
#define TELEPORT_TYPE	0x06	/*(~(-7))*/
#define OTHER_TYPE	0x07	/*(~(-8))*/
/* important!!! anims are or'd */
#define ANIM_TYPE	0x08	/*(~(-9))*/
/* invisible or not animatable */
#define CLIP_TYPE	0x10	/*(~(-10))*/
#define MIRROR_TYPE	0x11	/*(~(-11))*/

#define	srfWall(flag)	((flag & (~ANIM_TYPE)) == WALL_TYPE    )
#define	srfWater(flag)	((flag & (~ANIM_TYPE)) == WATER_TYPE   )
#define	srfSlime(flag)	((flag & (~ANIM_TYPE)) == SLIME_TYPE   )
#define	srfLava(flag)	((flag & (~ANIM_TYPE)) == LAVA_TYPE    )
#define	srfSky(flag)	((flag & (~ANIM_TYPE)) == SKY_TYPE     )
#define	srfTele(flag)	((flag & (~ANIM_TYPE)) == TELEPORT_TYPE)
#define	srfOther(flag)	((flag & (~ANIM_TYPE)) == OTHER_TYPE   )
#define	srfAnim(flag)	((flag & ( ANIM_TYPE))                 )
#define	srfClip(flag)	((flag               ) == CLIP_TYPE    )
#define	srfMirror(flag)	((flag               ) == MIRROR_TYPE  )

short int lightstyleStrings[16][64];
int lightstyleLengths[11];

void GetTMap(bspBase bspMem, struct texture *Text, short int mip);

#endif
