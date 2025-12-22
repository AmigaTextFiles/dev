#ifndef _WRAPPER_PWD_H
#define _WRAPPER_PWD_H 1

/*
 * $Id: pwd.h 1.2 2000/05/22 19:09:18 olsen Exp olsen $
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

typedef long             gid_t;
typedef long             uid_t;
typedef unsigned short   mode_t;
typedef unsigned long    pid_t;

struct passwd
{
    char *    pw_name;    /* Username */
    char *    pw_passwd;    /* Encrypted password */
    uid_t    pw_uid;        /* User ID */
    gid_t    pw_gid;        /* Group ID */
    char *    pw_gecos;    /* Real name etc */
    char *    pw_dir;        /* Home directory */
    char *    pw_shell;    /* Shell */
};

/****************************************************************************/

#endif /* _WRAPPER_PWD_H */
