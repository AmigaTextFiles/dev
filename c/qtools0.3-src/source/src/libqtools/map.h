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

#ifndef	MAP_H
#define	MAP_H
/*
 * ============================================================================
 * structures
 * ============================================================================
 */

#define	SAVE_BACK		1024

#define MAX_MAPLIGHTLEVEL	300

struct plane {
  vec3D normal;
  vec1D dist;
  int type;
} __packed;							/* 20 */

struct mtext {
  char *textName;						/* short for "mapMem->maptexstrings[t->miptex]" */
  int flags;							/* */
  vec1D scale, rotate, shift;					/* plain copies */
} __packed;

struct mface {
  struct mface *next;
  struct plane plane;
  int texinfo;
  struct mtext textinfo;					/* replacement for texinfo */
  /* added by niels */
  vec3D p0, p1, p2;
} __packed;							/* 48 -> 96 */

struct mbrush {
  struct mbrush *next;
  struct mface *faces;
} __packed;							/* 8 */

struct epair {
  struct epair *next;
  char *key;
  char *value;
} __packed;							/* 12 */

struct entity {
  vec3D origin;
  struct mbrush *brushes;
  struct epair *epairs;

  /* light */
  char *classname;
  vec1D angle;
  int light, style;
  char *target, *targetname;
  struct entity *targetent;

  vec3D targetmangle;						/* ++ Disastry */
  vec1D	scaledist;						/* ++ Disastry */
} __packed;							/* 20 */

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

int FindMiptex(mapBase mapMem, char *name);
int FindTexinfo(bspBase bspMem, mapBase mapMem, struct texinfo *t);
int MakeTexinfo(bspBase bspMem, mapBase mapMem, char *texname, struct mface *f, vec1D *scale, vec1D rotate, vec1D *shift);
struct entity *FindEntityWithKeyPair(mapBase, char *key, char *value);
struct entity *FindTargetEntity(mapBase, char *target);
struct entity *FindEntityWithModel(mapBase, int modnum);
void StartTokenParsing(char *data);
bool GetToken(bool crossline);
void UngetToken(void);
void ParseEpair(void);
void TextureAxisFromPlane(struct plane *pln, vec3D xv, vec3D yv);
void ParseBrush(bspBase bspMem, mapBase mapMem);
bool ParseEntity(bspBase bspMem, mapBase mapMem);
int LightStyleForTargetname(char *targetname, bool alloc);
void MatchTargets(mapBase);
void WriteEntitiesToString(bspBase bspMem, mapBase mapMem);
void PrintEntity(struct entity *ent);
char *ValueForKey(struct entity *ent, char *key);
char *ValueForKeyN(struct entity *ent, char *key);
void SetKeyValue(struct entity *ent, char *key, char *value);
vec1D FloatForKey(struct entity *ent, char *key);
vec1D FloatForKeyN(struct entity *ent, char *key);
void GetVectorForKey(struct entity *ent, char *key, vec3D vec);

#endif
