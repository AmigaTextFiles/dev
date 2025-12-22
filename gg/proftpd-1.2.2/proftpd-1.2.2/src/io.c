/*
 * ProFTPD - FTP server daemon
 * Copyright (c) 1997, 1998 Public Flood Software
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

#include "conf.h"

#include <signal.h>

#ifndef IAC
#define IAC	255
#endif
#ifndef DONT
#define DONT	254
#endif
#ifndef DO
#define DO	253
#endif
#ifndef WONT
#define WONT	252
#endif
#ifndef WILL
#define WILL	251
#endif

void init_io()
{
  signal(SIGPIPE,SIG_IGN);
  signal(SIGURG,SIG_IGN);
}

IOFILE *io_create(pool *p)
{
  IOFILE *res;
  pool *newp;

  newp = make_sub_pool(p);
  res = (IOFILE*)pcalloc(newp,sizeof(IOFILE));
  res->pool = newp;
  res->fd = -1;
  return res;
}

IOBUF *io_newbuf(IOFILE *f)
{
  IOBUF *newbuf;

  newbuf = pcalloc(f->pool,sizeof(IOBUF));
  newbuf->buf = newbuf->cp = palloc(f->pool,TUNABLE_BUFFER_SIZE);
  newbuf->left = newbuf->bufsize = TUNABLE_BUFFER_SIZE;

  f->buf = newbuf;
  return newbuf;
}

IOFILE *io_open(pool *p, int fd, int mode)
{
  IOFILE *res;

  res = io_create(p);
  res->fd = fd;
  res->mode = mode;
  return res;
}

IOFILE *io_reopen(IOFILE *f, int fd, int mode)
{
  if(f->fd != -1)
    close(f->fd);

  f->fd = fd;
  f->mode = mode;

  return f;
}

int io_close(IOFILE *f)
{
  int res;

  res = close(f->fd);
  f->fd = -1;

  destroy_pool(f->pool);
  return res;
}

void io_set_errno(IOFILE *f, int xerrno)
{
  f->xerrno = xerrno;
}

void io_abort(IOFILE *f)
{
  f->flags |= IO_ABORT;
}

#if 0
void io_set_restart(IOFILE *f, int bool)
{
  if(bool)
    f->flags &= ~IO_NORESTART;
  else
    f->flags |= IO_NORESTART;
}
#endif

void io_set_poll_sleep(IOFILE *f, unsigned int secs)
{
  f->flags |= IO_INTR;
  f->restart_secs = secs;
}

/* io_poll is needed instead of simply blocking read/write because
 * there is a race condition if the syscall _should_ be interrupted
 * inside read(), or write(), but the signal is received before we
 * actually hit the read or write call.  select() elleviates this
 * problem by timing out (configurable by io_set_restart_interval()),
 * restarting the syscall if IO_INTR is not set, or returning if it
 * is set and we were interrupted by a signal.  If after the timeout
 * IO_ABORT is set (presumably by a signal handler) or IO_INTR &
 * errno == EINTR, we return 1.  Otherwise, return when data
 * is available retunr 0 or -1 on other errors
 */

int io_poll(IOFILE *f)
{
  fd_set rs,ws,*rfds = NULL,*wfds = NULL;
  struct timeval tv;
  int res;

  if(f->fd == -1) {
    errno = EBADF;
    return -1;
  }

  if(f->flags & IO_ABORT) {
    f->flags &= ~IO_ABORT;
    return 1;
  }

  while(1) {
    run_schedule();
    FD_ZERO(&rs); FD_ZERO(&ws);

    if(f->mode == IO_READ) {
      FD_SET(f->fd,&rs);
      rfds = &rs;
    } else {
      FD_SET(f->fd,&ws);
      wfds = &ws;
    }

    tv.tv_sec = ((f->flags & IO_INTR) ? f->restart_secs : 60);
    tv.tv_usec = 0;

    res = select(f->fd + 1,rfds,wfds,NULL,&tv);
    switch(res) {
    case -1:
      if(errno == EINTR) {
        if(f->flags & IO_ABORT) {
          f->flags &= ~IO_ABORT;
          return 1;
        }

	/* otherwise, restart the call */
        continue;
      }
      /* some other error occured */
      io_set_errno(f,errno);
      return -1;
    case 0:
      /* in case the kernel doesn't support interrupted syscalls */
      if(f->flags & IO_ABORT) {
        f->flags &= ~IO_ABORT;
        return 1;
      }
      continue;
    default:
      return 0;
    }
  }

  /* this will never be reached */
  return -1;
}

int io_write(IOFILE *f, char *buf, int size)
{
  int written,total = 0;

  if(f->fd == -1) {
    errno = (f->xerrno ? f->xerrno : EBADF);
    return -1;
  }

  while(size) {
    switch(io_poll(f)) {
      case 1: return -2;
      case -1: return -1;
      default:
        /* we have to potentially restart here as well, in case
         * we get EINTR.
         */
        do {
          run_schedule();
          written = write(f->fd,buf,size);
        } while(written == -1 && errno == EINTR);
        break;
    }

    if(written == -1) {
      io_set_errno(f,errno);
      return -1;
    }

    buf += written; total += written;
    size -= written;

#if 0
    /* if IO_NORESTART is set, drop out of the loop now and simply
     * return the data received
     */

    if(f->flags & IO_NORESTART)
      break;
#endif
  }

  return total;
}

/* This is a bit odd, because io_ functions are opaque, we can't be sure
 * we are dealing with a conn_t or that it is in O_NONBLOCK mode.  Trying
 * to do this without O_NONBLOCK would cause the kernel itself to block
 * here, and thus invalidate the whole principal.  Instead we save
 * the flags and put the fd in O_NONBLOCK mode.
 */

int io_write_async(IOFILE *f, char *buf, int size)
{
  int flags;
  int written,total = 0;

  if(f->fd == -1) {
    errno = (f->xerrno ? f->xerrno : EBADF);
    return -1;
  }
  
  if((flags = fcntl(f->fd,F_GETFL)) == -1)
    return -1;

  if(fcntl(f->fd,F_SETFL,flags|O_NONBLOCK) == -1)
    return -1;

  while(size) {
    do {
      written = write(f->fd,buf,size);
    } while(written == -1 && errno == EINTR);
    
    if(written < 0) {
      io_set_errno(f,errno);

      fcntl(f->fd,F_SETFL,flags);
      if(f->xerrno == EWOULDBLOCK)
        /* Give up ... */
        return total;
   
      return -1;
    }

    buf += written; total += written;
    size -= written;
  }

  fcntl(f->fd,F_SETFL,flags);
  return total;
}

/* size - buffer size
 * min  - min. octets to read before returning (1 or >)
 *        (ignored if IO_NORESTART is set for the file)
 */

int io_read(IOFILE *f, char *buf, int size, int min)
{
  int bread = 0,total = 0;

  if(!f || f->fd == -1) {
    errno = (f->xerrno ? f->xerrno : EBADF);
    return -1;
  }

  if(min < 1)
    min = 1;
  if(min > size)
    min = size;

  while(min > 0) {
    switch(io_poll(f)) {
      case 1: return -2;
      case -1: return -1;
      default:
        do {
#if 0
	  if(bread == 1 && errno == EINTR)
		log_debug(DEBUG4,"io_read: interrupted syscall");
#endif
          run_schedule();
          bread = read(f->fd,buf,size);
        } while(bread == -1 && errno == EINTR);
        break;
    }

    if(bread == -1) {
      io_set_errno(f,errno);
      return -1;
    }

    /* EOF? */
    if(bread == 0) {
      io_set_errno(f,0);
      break;
    }
    
    buf += bread; total += bread;
    min -= bread;
    size -= bread;

#if 0
    /* minimum octets to receive is ignored if IO_NORESTART is set */
    if(f->flags & IO_NORESTART)
      break;
#endif
  }

  return total;
}

int io_printf(IOFILE *f, char *fmt, ...)
{
  va_list msg;
  char buf[1025] = {'\0'};

  va_start(msg,fmt);
  vsnprintf(buf,sizeof(buf),fmt,msg);
  va_end(msg);

  buf[sizeof(buf)-1] = '\0';

  return io_write(f,buf,strlen(buf));
}

/* io_printf_async() is for use inside alarm handlers, where no io_poll()
 * blocking is allowed.  This is necessary because otherwise, io_poll()
 * can potentially hang forever if the Send-Q is maxed and the socket
 * has been closed.
 */

int io_printf_async(IOFILE *f, char *fmt, ...)
{
  va_list msg;
  char buf[1025] = {'\0'};

  va_start(msg,fmt);
  vsnprintf(buf,sizeof(buf),fmt,msg);
  va_end(msg);

  buf[sizeof(buf)-1] = '\0';

  return io_write_async(f,buf,strlen(buf));
}

char *io_gets(char *buf, int size, IOFILE *f)
{
  char *bp = buf;
  int toread;
  IOBUF *iobuf;
  size--;

  if(!f->buf)
    iobuf = io_newbuf(f);
  else
    iobuf = f->buf;

  while(size) {
    if(!iobuf->cp || iobuf->left == TUNABLE_BUFFER_SIZE) {	/* Empty buffer */
      toread = io_read(f,iobuf->buf,
			(size < TUNABLE_BUFFER_SIZE ? 
			 size : TUNABLE_BUFFER_SIZE),1);
      if(toread <= 0) {
        if(bp != buf) {
          *bp = '\0';
          return buf;
        } else
          return NULL;
      }

      iobuf->left = TUNABLE_BUFFER_SIZE - toread;
      iobuf->cp = iobuf->buf;
    } else
      toread = TUNABLE_BUFFER_SIZE - iobuf->left;

    while(size && *iobuf->cp != '\n' && toread--) {
      if(*iobuf->cp & 0x80)
        iobuf->cp++;
      else {
        *bp++ = *iobuf->cp++;
        size--;
      }
      iobuf->left++;
    }

    if(size && toread && *iobuf->cp == '\n') {
      size--; toread--;
      *bp++ = *iobuf->cp++;
      iobuf->left++;
      break;
    }

    if(!toread)
      iobuf->cp = NULL;
  }

  *bp = '\0';
  return buf;
}

/* io_telnet_gets() is exactly like io_gets, except a few special
 * telnet characters are handled (which takes care of the [IAC]ABOR
 * command, and odd clients
 */

char *io_telnet_gets(char *buf, int size, IOFILE *f, IOFILE *o)
{
  char *bp = buf;
  unsigned char cp;
  static unsigned char mode = 0;
  int toread;
  IOBUF *iobuf;
  size--;

  if(!f->buf)
    iobuf = io_newbuf(f);
  else
    iobuf = f->buf;

  while(size) {
    if(!iobuf->cp || iobuf->left == TUNABLE_BUFFER_SIZE) {	/* Empty buffer */
      toread = io_read(f,iobuf->buf,
		      (size < TUNABLE_BUFFER_SIZE ? 
		       size : TUNABLE_BUFFER_SIZE),1);
      if(toread <= 0) {
        if(bp != buf) {
          *bp = '\0';
          return buf;
        } else
          return NULL;
      }

      iobuf->left = TUNABLE_BUFFER_SIZE - toread;
      iobuf->cp = iobuf->buf;
    } else
      toread = TUNABLE_BUFFER_SIZE - iobuf->left;

    while(size && *iobuf->cp != '\n' && toread--) {
      cp = *iobuf->cp++; iobuf->left++;
      switch(mode) {
      case IAC:
        switch(cp) {
        case WILL:
        case WONT:
        case DO:
        case DONT:
          mode = cp;
          continue;
        case IAC:
          mode = 0;
          break;
        default:
          /* ignore */
          mode = 0;
          continue;
        }       
        break;
      case WILL:
      case WONT:
        io_printf(o,"%c%c%c", IAC, DONT, cp);
        mode = 0;
        continue;
      case DO:
      case DONT:
        io_printf(o,"%c%c%c", IAC, WONT, cp);
        mode = 0;
        continue;
      default:
        if(cp == IAC) {
          mode = cp;
          continue;
        }
        break;
      }

      *bp++ = cp;
      size--;
    }

    if(size && toread && *iobuf->cp == '\n') {
      size--; toread--;
      *bp++ = *iobuf->cp++;
      iobuf->left++;
      break;
    }

    if(!toread)
      iobuf->cp = NULL;
  }

  *bp = '\0';
  return buf;
}
