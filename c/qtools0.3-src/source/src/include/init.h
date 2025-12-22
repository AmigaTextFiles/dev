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

#ifndef	INIT_H
#define	INIT_H

#ifdef	HAVE_CONFIG_H
# include "./config.h"
#endif
#ifdef	STDC_HEADERS
# include <stdlib.h>
# include <stdarg.h>
# include <string.h>
#endif
#ifdef	HAVE_UNISTD_H
# include <unistd.h>						/* open, close */
#endif
#ifdef	HAVE_CTYPE_H
# include <ctype.h>						/* isupper, tolower */
#endif
#ifdef	HAVE_FNMATCH_H						/* fnmatch */
# include <fnmatch.h>
#else /* valid replacement */
# define fnmatch	__strncasecmp
# define FNM_PATHNAME	NAMELEN_PATH
#endif
#ifdef	HAVE_SETJMP_H
# include <setjmp.h>
#endif
#ifdef	HAVE_STDIO_H
# include <stdio.h>
#endif
#ifdef	HAVE_SYS_FCNTL_H
# include <sys/fcntl.h>						/* read, write */
#endif
#ifdef	HAVE_SYS_STAT_H
# include <sys/stat.h>						/* mkdir */
#endif
#ifdef HAVE_DIRENT_H
# include <dirent.h>
#endif

#ifdef	HAVE_LIBLISTS_H
#include <liblists.h>
#else
#include "../liblists/liblists.h"
#endif

#define	strlower(str)		{ int lenn; for (lenn = 0; str[lenn]                ; str[lenn++] = tolower(str[lenn])); }
#define	strnlower(str, len)	{ int lenn; for (lenn = 0; str[lenn] && (lenn < len); str[lenn++] = tolower(str[lenn])); }

#endif
