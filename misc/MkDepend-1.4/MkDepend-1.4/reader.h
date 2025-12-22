/* $Id: reader.h,v 1.2 1997/11/09 23:42:46 lars Exp $ */

#ifndef __READER_H__
#define __READER_H__ 1

extern void reader_init (void);
extern int  reader_open (const char *);
extern int  reader_openrw (const char *, const char *);
extern int  reader_close (void);
extern int  reader_eof (void);
extern const char * reader_get (void);
extern int  reader_writeflush (void);
extern int  reader_writen (const char *, int);
extern int  reader_write (const char *);
extern int  reader_copymake (const char *, int);
extern int  reader_copymake2 (const char *, int);

#endif
