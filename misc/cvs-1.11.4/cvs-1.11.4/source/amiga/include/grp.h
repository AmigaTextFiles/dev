#ifndef _WRAPPER_GRP_H
#define _WRAPPER_GRP_H 1

/*
 * $Id: grp.h 1.2 2000/05/22 19:09:10 olsen Exp olsen $
 *
 * :ts=4
 *
 * AmigaOS wrapper routines for GNU CVS, using the AmiTCP V3 API
 * and the SAS/C V6.58 compiler.
 *
 * Written by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
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

/****************************************************************************/

#include "sys/types.h"

struct group
{
	char *	gr_name;	/* group name */
	char *	gr_passwd;	/* group password */
	gid_t	gr_gid;		/* group id */
	char **	gr_mem;		/* group members */
};

/****************************************************************************/

#endif /* _WRAPPER_GRP_H */
