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

#ifndef	VIS_H
#define	VIS_H

/*
 * ============================================================================
 * structures
 * ============================================================================
 */

typedef struct pstack_s {
  struct pstack_s *next;
  struct visleaf *leaf;
  struct visportal *portal;					/* portal exiting */

  struct winding *source, *pass;
  struct plane portalplane;
  unsigned char *mightsee;					/* bit string */
} __packed pstack_t;

typedef struct {
  unsigned char *leafvis;					/* bit string */

  struct visportal *base;
  pstack_t pstack_head;
} __packed threaddata_t;

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
