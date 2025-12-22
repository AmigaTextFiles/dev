/*
 * ProFTPD - FTP server daemon
 * Copyright (c) 1997, 1998 Public Flood Software
 * Copyright (C) 1999, 2000 MacGyver aka Habeeb J. Dihu <macgyver@tos.net>
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
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
 *
 * As a special exemption, Public Flood Software/MacGyver aka Habeeb J. Dihu
 * and other respective copyright holders give permission to link this program
 * with OpenSSL, and distribute the resulting executable, without including
 * the source code for OpenSSL in the source distribution.
 */

/* Connection streams, ring-buffers and other goodies related to 
 * non-blocking I/O 
 * $Id: io.h,v 1.4 2001/06/18 17:12:45 flood Exp $
 */

#ifndef __IO_H
#define __IO_H

#define IO_READ		0
#define IO_WRITE	1

#define IOR_REMOVE	(1 << 0)	/* Request scheduled for removal */
#define IOR_CLOSED	(1 << 1)	/* File is closed */
#define IOR_ERROR	(1 << 2)	/* Request resulted in error */
#define IOR_REMOVE_FILE (1 << 3)	/* Destroy associated file */

#define IO_NONBLOCK	(1 << 0)	/* No longer used?!? */
#define IO_INTR		(1 << 1)	/* Indicates that io_* funcs are
                                           allowed to be interrupted
                                           by EINTR, and return -2
                                         */
#define IO_NORESTART	(1 << 2)	/* Indicates that io_* funcs should
                                           not automagically restart
                                           if read() or write() should
                                           return EWOULDBLOCK/EAGAIN
                                           The default is to restart.
                                         */
#define IO_ABORT	(1 << 3)        /* temporary internal flag used
                                           to indicated that i/o on
                                           an IOFILE has been been
                                           aborted and should return -2
                                           at the next possible instant.
                                           In combintation with IO_INTR
                                           and interruptable syscalls
                                           this should be near instantly.
                                           This flag cannot be tested
                                           for as it is cleared immediately
                                           after being detected
                                          */


typedef struct IO_File IOFILE;
typedef struct IO_Buffer IOBUF;
typedef struct IO_Request IOREQ;

struct IO_File {
  pool *pool;				/* Each one has it's own pool */
  int  fd;				/* File descriptor */
  int  mode;				/* 0 == read, 1 == write */
  int  xerrno;				/* errno if applicable */

  int  flags;
  unsigned int restart_secs;

  IOBUF *buf;
  IOREQ *req;				/* Request buffer */
  int  bufsize;				/* Default size of request buffer */
};

struct IO_Buffer {
  char *buf,*cp;
  int left,bufsize;
};

/* cl_read can be used during write operations to asyncronously gather
 * data from a function.  If cl_read returns -1, an error is assumed,
 * otherwise 0 == EOF (write completed)
 */

struct IO_Request {
  IOREQ *next,*prev;

  pool *pool;

  int req_type;				/* Read or Write */
  int req_flags;			/* Request flags */
  IOFILE *file;

  char *buf;
  char *bp,*bufnext;
  int bufsize;				/* Buffer size */

  char *cl_buf,*cl_bp;			/* Client buffer, and head pointer */
  int cl_bytes;				/* Bytes remaining in client buffer */
  int (*cl_io)(IOREQ*,char*,int);	/* Client io function (for async operations) */
  void (*cl_err)(IOREQ*,int);		/* Error occured */
  void (*cl_close)(IOREQ*);		/* Remote side closed */
};

/* Prototypes */

void init_io();
IOFILE *io_open(pool*,int,int);
IOFILE *io_reopen(IOFILE*,int,int);
int io_poll(IOFILE*);
int io_close(IOFILE*);
int io_write(IOFILE*,char*,int);
int io_write_async(IOFILE*,char*,int);
int io_read(IOFILE*,char*,int,int);
int io_printf(IOFILE*,char*,...);
int io_printf_async(IOFILE*,char*,...);
void io_abort(IOFILE*);
void io_set_restart(IOFILE*,int);
void io_set_poll_sleep(IOFILE*,unsigned int);
char *io_gets(char*,int,IOFILE*);
char *io_telnet_gets(char*,int,IOFILE*,IOFILE*);
void io_set_errno(IOFILE *f, int xerrno);

#endif /* __IO_H */
