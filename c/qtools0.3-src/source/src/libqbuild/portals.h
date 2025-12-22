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

#ifndef	PORTALS_H
#define	PORTALS_H
#include "winding.h"

/*
 * ============================================================================
 * structures
 * ============================================================================
 */

#define	PORTALFILE		"PRT1"

struct portal {
  int planenum;
  struct node *nodes[2];					/* [0] = front side of planenum */
  struct portal *next[2];
  struct winding *winding;
} __packed;

enum visstatus {
  stat_none, stat_working, stat_done
} __packed;

struct visportal {
  struct plane plane;						/* normal pointing into neighbor */
  int leaf;							/* neighbor */

  struct winding *winding;
  enum visstatus status;
  unsigned char *visbits;
  unsigned char *mightsee;
  int nummightsee;
  int numcansee;
} __packed;

struct seperatingplane {
  struct seperatingplane *next;
  struct plane plane;						/* from portal is on positive side */
} __packed;

struct passage {
  struct passage *next;
  int from, to;							/* leaf numbers */
  struct seperatingplane *planes;
} __packed;

struct visleaf {
  struct passage *passages;
  int numportals;
  struct visportal **portals;					/*[MAX_PORTALS_ON_LEAF]; */
} __packed;

/*
 * ============================================================================
 * globals
 * ============================================================================
 */

extern struct node outside_node;				/* portals outside the world face this */
extern int num_visleafs;					/* leafs the player can be in */
extern int num_visportals;
extern struct visportal *portals;
extern struct visleaf **leafs;

/*
 * ============================================================================
 * prototypes
 * ============================================================================
 */

void PortalizeWorld(mapBase mapMem, struct node *headnode);
void FreeAllPortals(struct node *node);
void WritePortalfile(mapBase mapMem, struct node *headnode, char *prtName);
void LoadPortals(char *prtBuf);

#endif
