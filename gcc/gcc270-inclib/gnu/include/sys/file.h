/*
 *  This file is part of ixemul.library for the Amiga.
 *  Copyright (C) 1991, 1992  Markus M. Wild
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Library General Public
 *  License as published by the Free Software Foundation; either
 *  version 2 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Library General Public License for more details.
 *
 *  You should have received a copy of the GNU Library General Public
 *  License along with this library; if not, write to the Free
 *  Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#ifndef _SYS_FILE_H
#define _SYS_FILE_H

#include <sys/types.h>
#include <sys/fcntl.h>
#include <sys/unistd.h>

#ifdef _INTERNAL_FILE
#include <sys/stat.h>
#include <libraries/dosextens.h>

/* this is the incore representation of a DTYPE_MEM file */
struct mem_file {
  int   mf_offset;
  void *mf_buffer;
};

/* this `glue' makes a tty a subtype of a plain file. Ie f->f_fh will work
   for plain files as well as ttys. */
struct tty_glue {
  struct FileHandle *fh;
  struct tty *tty;	/* internal data of tty.c */
};

/* this will hold basic information about a file, but contrairy to
 * Unix, it will also hold its name */

struct file {
  char *f_name;	     /* the name as used with open() */
  int f_stb_dirty,   /* gets == 1, if changes have been made to 'stb' */
      f_type,	     /* can be a file or some amiga..devices */
      f_flags,	     /* see fcntl.h */
      f_count,	     /* open-count, normally 1, higher after dup() */
      (*f_write)(),    /* functions to perform write,read,etc on this fd */
      (*f_read)(),
      (*f_ioctl)(),
      (*f_select)(),
      (*f_close)();
  union {
    struct FileHandle *fh; /* this is a CPTR to the allocated
			    * FileHandle */
    struct mem_file mf;	   /* current data for incore files */
    struct socket *so;	   /* points to socket when DTYPE_SOCKET */
    struct tmp_pipe *tp;   /* temporary until sockets are here ;-) */
    struct tty_glue tg;
  } f__fh;
#define f_fh  f__fh.fh
#define f_mf  f__fh.mf
#define f_so  f__fh.so
#define f_tp  f__fh.tp
#define f_tty f__fh.tg.tty
  /* WARNING: if you change this struct, take care, that f_sp starts at
   * long (!) alignment in the struct. The file-table will be allocated
   * by AllocMem(), thus by itself it will have DOS-compatible alignment,
   * if you don't follow this, you'll get some nice gurus.. */
  struct StandardPacket f_sp; /* all IO is done thru the Packet-Interface,
			       * not the higher-level DOS-functions */
  char *f_async_buf;
  int   f_async_len;
  struct stat f_stb; /* file-params at open-time, or after changes to fd */
  int	f_sync_flags;	/* for process synchronization */
};


#define FSFB_LOCKED	(0)
#define FSFF_LOCKED	(1<<0)	/* means the fh is in use */
#define FSFB_WANTLOCK	(1)
#define FSFF_WANTLOCK	(1<<1)	/* means a process is sleeping on fh to get free */

#endif /* _INTERNAL_FILE_H */


#if 0 /* now in <sys/fcntl.h> */
#include <fcntl.h>

/*
 * flags - see also fcntl.h
 */
#define	FOPEN		(-1)
#define	FREAD		00001		/* descriptor read/receive'able */
#define	FWRITE		00002		/* descriptor write/send'able */
#define FINDIR		00010		/* result of a dup() call */
#define FEXTOPEN        00020		/* someone else opened this fd for
					 * us, so we shouldn't close it */
#define FTTYRAW		00040		/* did we send a RAW-packet ?? */
#define FUNLINK		00200		/* unlink file after close */

/* bits to save after open */
#define	FMASK		(FREAD|FWRITE|FAPPEND|FSYNC|FASYNC|FNBIO|FINDIR)
#define	FCNTLCANT	(FREAD|FWRITE|FINDIR|FEXTOPEN)
#endif

#if 0  /* now in sys/fcntl.h sys/unistd.h */
/*
 * Access call.
 */
#define	F_OK		0	/* does file exist */
#define	X_OK		1	/* is it executable by caller */
#define	W_OK		2	/* writable by caller */
#define	R_OK		4	/* readable by caller */

/*
 * Lseek call.
 */
#define	L_SET		0	/* absolute offset */
#define	L_INCR		1	/* relative to current offset */
#define	L_XTND		2	/* relative to end of file */
#endif

#define DTYPE_FILE	1	/* 'file' is really a file */
#define DTYPE_PIPE	2	/* it's an incore pipe */
#define DTYPE_MEM	3	/* a RDONLY file completely buffered in memory */
#define DTYPE_TASK_FILE	4	/* is a 'file', but used by a task, not a process !*/
#define DTYPE_SOCKET	5	/* socket (inet.library interface) */
#define DTYPE_USOCKET	6	/* socket (own socket code) */
#define DTYPE_TTY	7	/* amigados file, with special access functions */
/* more to follow.. */

#endif /* _SYS_FILE_H */
