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

#ifndef	DEBUG_H
#define	DEBUG_H

#define	HANDLE	int

#ifndef	ALLPERMS
#define	ALLPERMS	0x0777
#endif

#ifdef	DEBUG_C
# define __assert(file, func, line)	(eprintf("(%s %s %u)\n", file, func, line), abort(), 0)
# ifndef HAVE_LIBDBMALLOC
#  include <malloc.h>
#  define __memset(mem, pat, len)	((void *) ((mem)	    ? memset(mem, pat, len)	 : __assert(__FILE__, __FUNCTION__, __LINE__)))
#  define __memcpy(dst, src, len)	((void *) (((dst) && (src)) ? memcpy(dst, src, len)	 : __assert(__FILE__, __FUNCTION__, __LINE__)))
#  define __bzero(mem, len)		((void)	  ((mem)	    ? bzero(mem, len)		 : __assert(__FILE__, __FUNCTION__, __LINE__)))
#  define __strcpy(dst, src)		((char *) (((dst) && (src)) ? strcpy(dst, src)		 : __assert(__FILE__, __FUNCTION__, __LINE__)))
#  define __strncpy(dst, src, len)	((char *) (((dst) && (src)) ? strncpy(dst, src, len)	 : __assert(__FILE__, __FUNCTION__, __LINE__)))
#  define __strcat(dst, src)		((char *) (((dst) && (src)) ? strcat(dst, src)		 : __assert(__FILE__, __FUNCTION__, __LINE__)))
#  define __strncat(dst, src, len)	((char *) (((dst) && (src)) ? strncat(dst, src, len)	 : __assert(__FILE__, __FUNCTION__, __LINE__)))
#  define __strcmp(dst, src)		((int)	  (((dst) && (src)) ? strcmp(dst, src)		 : __assert(__FILE__, __FUNCTION__, __LINE__)))
#  define __strncmp(dst, src, len)	((int)	  (((dst) && (src)) ? strncmp(dst, src, len)	 : __assert(__FILE__, __FUNCTION__, __LINE__)))
#  define __strlen(str)			((int)	  ((str)	    ? strlen(str)		 : __assert(__FILE__, __FUNCTION__, __LINE__)))
#  define __strchr(mem, pat)		((char *) ((mem)	    ? strchr(mem, pat)		 : __assert(__FILE__, __FUNCTION__, __LINE__)))
#  define __strrchr(mem, pat)		((char *) ((mem)	    ? strrchr(mem, pat)		 : __assert(__FILE__, __FUNCTION__, __LINE__)))
#  define __index(mem, pat)		((char *) ((mem)	    ? index(mem, pat)		 : __assert(__FILE__, __FUNCTION__, __LINE__)))
#  define __rindex(mem, pat)		((char *) ((mem)	    ? rindex(mem, pat)		 : __assert(__FILE__, __FUNCTION__, __LINE__)))
# else
#  include <dbmalloc.h>
#  define __memset	memset
#  define __memcpy	memcpy
#  define __bzero	bzero
#  define __strcpy	strcpy
#  define __strncpy	strncpy
#  define __strcat	strcat
#  define __strncat	strncat
#  define __strcmp	strcmp
#  define __strncmp	strncmp
#  define __strlen	strlen
#  define __strchr	strchr
#  define __strrchr	strrchr
#  define __index	index
#  define __rindex	rindex
# endif
# define __strcasecmp(dst, src)		((int)	  (((dst) && (src)) ? strcasecmp(dst, src)	 : __assert(__FILE__, __FUNCTION__, __LINE__)))
# define __strncasecmp(dst, src, len)	((int)	  (((dst) && (src)) ? strncasecmp(dst, src, len) : __assert(__FILE__, __FUNCTION__, __LINE__)))
# define __fopen(name, mode)		((FILE *) ((name)	    ? fopen(name, mode)		 : __assert(__FILE__, __FUNCTION__, __LINE__)))
# define __fclose(handle)		((int)	  ((handle)	    ? fclose(handle)		 : __assert(__FILE__, __FUNCTION__, __LINE__)))
# define __fread(buf, l1, l2, hl)	((int)	  (((buf) && (hl))  ? fread(buf, l1, l2, hl)	 : __assert(__FILE__, __FUNCTION__, __LINE__)))
# define __fwrite(buf, l1, l2, h)	((int)	  (((buf) && (h))   ? fwrite(buf, l1, l2, h)	 : __assert(__FILE__, __FUNCTION__, __LINE__)))
# define __ftell(handle)		((int)	  ((handle)	    ? ftell(handle)		 : __assert(__FILE__, __FUNCTION__, __LINE__)))
# define __fseek(hdl, offs, mode)	((int)	  ((hdl)	    ? fseek(hdl, offs, mode)	 : __assert(__FILE__, __FUNCTION__, __LINE__)))
# define __open(name, flags)		((HANDLE) ((name)	    ? open(name, flags, ALLPERMS): __assert(__FILE__, __FUNCTION__, __LINE__)))
# define __close(handle)		((int)	  ((handle > 0)	    ? close(handle)		 : __assert(__FILE__, __FUNCTION__, __LINE__)))
# define __read(hl, buf, len)		((int)	  (((buf) && (hl>0))? read(hl, buf, len)	 : __assert(__FILE__, __FUNCTION__, __LINE__)))
# define __write(hl, buf, len)		((int)	  (((buf) && (hl>0))? write(hl, buf,len)	 : __assert(__FILE__, __FUNCTION__, __LINE__)))
# define __ltell(handle)		((int)	  ((handle > 0)	    ? lseek(handle, 0, SEEK_CUR) : __assert(__FILE__, __FUNCTION__, __LINE__)))
# define __lseek(hdl, offs, mode)	((int)	  ((hdl > 0)	    ? lseek(hdl, offs, mode)	 : __assert(__FILE__, __FUNCTION__, __LINE__)))
#else
# define __memset	memset
# define __memcpy	memcpy
# define __bzero	bzero
# define __strcpy	strcpy
# define __strncpy	strncpy
# define __strcat	strcat
# define __strncat	strncat
# define __strcmp	strcmp
# define __strncmp	strncmp
# define __strlen	strlen
# define __strchr	strchr
# define __strrchr	strrchr
# define __index	index
# define __rindex	rindex
# define __strcasecmp	strcasecmp
# define __strncasecmp	strncasecmp
# define __fopen	fopen
# define __fclose	fclose
# define __fread	fread
# define __fwrite	fwrite
# define __ftell	ftell
# define __fseek	fseek
# define __open(h, f)	open(h, f, ALLPERMS)
# define __close	close
# define __read		read
# define __write	write
# define __ltell(hl)	lseek(hl, 0, SEEK_CUR)
# define __lseek	lseek
#endif

#endif
