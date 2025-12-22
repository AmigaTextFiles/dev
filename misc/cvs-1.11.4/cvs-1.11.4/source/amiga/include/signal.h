#ifndef _WRAPPER_SIGNAL_H
#define _WRAPPER_SIGNAL_H 1

/*
 * $Id: signal.h 1.2 2000/05/22 19:09:25 olsen Exp olsen $
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

#include "include:signal.h"

#define SIGHUP	7	/* Hangup */
#define SIGPIPE	8	/* Write on a pipe with no one to read it */
#define SIGCHLD	9	/* To parent on child stop or exit */
#define SIGALRM	10	/* Alarm clock */

/****************************************************************************/

#endif /* _WRAPPER_SIGNAL_H */
