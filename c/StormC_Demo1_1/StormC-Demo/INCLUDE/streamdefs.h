#ifndef _INCLUDE_IO_STREAM
#define _INCLUDE_IO_STREAM

/*
**  $VER: streamdefs.h 10.1 (19.7.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

struct streambuffer;

struct stream
{ unsigned Filehandle;
  char UngetCh, UngetBuf;
  signed char Mode, Error;
  struct streambuffer *bufptr;
  struct { int f_freemem:1, f_closefile:1 } flags;
};

struct streambuffer
{ stream *streamptr;
  short size, fill, pos;
  signed char mode, own;
  int (*read)(register streambuffer *a0, register void *d2, register unsigned d3);
  int (*write)(register streambuffer *a0, register void *d2, register unsigned d3);
  int (*flush)(register streambuffer *a0);
  int (*close)(register streambuffer *a0);
  void *buf;
};

stream *allocstream(unsigned Handle);

#endif

