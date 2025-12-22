#ifndef  STORMAMIGAINLINE_H
#define  STORMAMIGAINLINE_H

/*
**   $VER: stormamigainline.h 42.10ß (04.03.1997)
**
**              B E T A V E R S I O N
**
**        Copyright © 1996/97 by COMPIUTECK
**            written by Matthias Henze
**               All Rights Reserved
*/

#ifndef  _INCLUDE_STDLIB_H
  #include <stdlib.h>
#endif
#ifndef  _INCLUDE_SIGNAL_H
  #include <signal.h>
#endif
#ifndef _INCLUDE_ERRNO_H
  #include <errno.h>
#endif
#ifndef _INCLUDE_FILEDEFS_H
  #include <filedefs.h>
#endif
#ifndef HARDWARE_INTBITS_H
  #include <hardware/intbits.h>
#endif
#ifndef _INCLUDE_PRAGMA_EXEC_LIB_H
  #include <pragma/exec_lib.h>
#endif
#ifndef _INCLUDE_PRAGMA_DOS_LIB_H
  #include <pragma/dos_lib.h>
#endif
#ifndef _INCLUDE_PRAGMA_GRAPHICS_LIB_H
  #include <pragma/graphics_lib.h>
#endif
#ifndef  CLIB_ALIB_PROTOS_H
  #include <clib/alib_protos.h>
#endif
#ifndef  STORMAMIGA_H
  #include <stormamiga.h>
#endif

#ifdef __cplusplus
  extern "C" {
#endif


#define uchar         unsigned char
#define ushort        unsigned short
#define lint          long int
#define llint         long long int
#define uint          unsigned int
#define ulint         unsigned long int
#define ullint        unsigned long long int
#define llong         long long
#define ulong         unsigned long
#define ullong        unsigned long long


/*----- stdio-functions -----*/

#define getc             fgetc
#define putc             fputc

__inline int fgetc       (FILE *f)
{ return (*f -> getch)   (f); }

__inline int ungetc      (int ch, FILE *f)
{ return (*f -> ungetch) (f, ch); }

__inline int fputc       (int ch, FILE *f)
{ return (*f->putch)     (f, ch); }

__inline int putchar     (int ch)
{ return fputc           (ch, stdout); }

__inline int feof        (FILE *f)
{ return (*f -> eof)     (f); }

__inline int ferror      (FILE *f)
{ return f -> error; }

__inline void clearerr   (FILE *f)
{ f -> error = 0; }

__inline void perror     (const char *s)
{ PrintFault             (errno, (STRPTR) s); }

__inline int remove      (const char *s)
{ return DeleteFile      ((STRPTR) s) == 0; }

__inline int rename      (const char *s, const char *ns)
{ return Rename          ((STRPTR) s,(STRPTR) ns) == 0; }

__inline void setbuf     (FILE *f, char *buffer)
{ setvbuf                (f, buffer, _IOFBF, BUFSIZ); }

__inline int vprintf     (const char *format, va_list vl)
{ return vfprintf        (stdout, format, vl) }


/*----- Nonstandard-stdio-functions -----*/

__inline int vprintf_    (const char *format, va_list vl)
{ return vfprintf_       (stdout, format, vl) }


/*----- GCC-Nonstandard-stdio-functions -----*/

__inline void setbuffer  (FILE *f, char *buffer, int size)
{ setvbuf                (f, buffer, _IOFBF, size); }

__inline int setlinebuf  (FILE *f)
{
  (void) setvbuf         (f, (char *) NULL, _IOLBF, (size_t) 0);
  return 0;
}


/*----- string-functions -----*/

#define memcpy  memcpy_
#define memmove memmove_
#define memset  memset_
#define memchr  memchr_
#define memcmp  memcmp_

__inline void *memcpy_ (void *d, const void *s, size_t n)
{
  void *r = d;
  while (n)
  {
    *(((uchar*) d)++) = *(((uchar*) s)++);
    n--;
  }
  return r;
}

__inline void *memmove_ (void *d, const void *s, size_t n)
{
 void *r = d;
 if (n)
 {
  if ((uchar *) d < (uchar *) s)
  {
    do
    {
      *(((uchar *) d)++) = *(((uchar *) s)++);
    }
    while (--n);
  };
  else
  {
    (uchar *) d += n;
    (uchar *) s += n;
    do
    {
      *(--((uchar *) d)) = *(--((uchar *) s));
    }
    while (--n);
  };
 }
 return r;
}

__inline void *memset_ (void *d, int c, size_t n)
{
  void *r = d;
  while (n)
  {
    *(((uchar *) d)++) = c;
    n--;
  }
  return r;
}

__inline void *memchr_ (const void *s, int c, size_t n)
{
  while (n)
  {
   if (*(((uchar *) s)++) == (uchar) c)
     return (uchar *) s - 1;
   n--;
  };
  return 0;
}

__inline int memcmp_ (const void *m1, const void *m2, size_t n)
{
 int r = 0;
 char a, b;
 if (n)
 {
   while ((a = *(((uchar *) m1)++)) == (b = *(((uchar *) m2)++)) && --n)
    ;
   r = a - b;
 }
 return r;
}


/*----- stdlib-functions -----*/

#define atoi             atol

__inline long atol       (const char *s)
{ return strtol          (s, NULL, 10); }

__inline long long atoll (const char *s)
{ return strtoll         (s, NULL, 10); }

__inline double atof     (const char *s)
{ return strtod          (s, NULL); }

__inline void abort      (void)
{ raise                  (SIGABRT); }


/*----- time-functions -----*/

__inline struct tm *localtime (const time_t *tp)
{ return gmtime          (tp); }

#ifndef STORMAMIGA_DEUTSCH
  __inline char *ctime     (const time_t *t)
  { return asctime         (localtime (t)); }
#endif

__inline double difftime (time_t t1, time_t t2)
{ return (t1 - t2); }


/*----- Nonstandard-time-functions -----*/

__inline char *ctime_d   (const time_t *t)
{ return asctime_d       (localtime (t)); }


/*----- amiga.lib-functions -----*/

#define DeleteTask       RemTask
#define CreateExtIO      CreateIORequest
#define DeleteExtIO      DeleteIORequest
#define DeleteStdIO      DeleteIORequest

__inline void RemTOF     (struct Isrvstr *intr)
{ RemIntServer           (INTB_VERTB, (struct Interrupt *) intr); }

__inline struct IOStdReq *CreateStdIO (struct MsgPort *port)
{ return (struct IOStdReq *) CreateIORequest (port, sizeof (struct IOStdReq)); }

__inline void waitbeam   (long pos)
{ do {} while (pos > VBeamPos ()); }

__inline void NewList    (struct List *list)
{
  long *p;
  list -> lh_TailPred = (struct Node *) list;
  list = (struct List *)((char *) list + sizeof (LONG));
  *(long *) list = 0;
  p = (long *) list;
  *-- p = (long) list;
}


/*----- Amiga-functions -----*/

#ifdef STORMAMIGA_REGISTER
  #undef Move
  #undef GetAPen
  #undef GetBPen
#endif

#define Move Move_
#define GetAPen GetAPen_
#define GetBPen GetBPen_

__inline void Move_ (struct RastPort *rp, long x, long y)
{
  rp -> cp_x = x;
  rp -> cp_y = y;
}

__inline ulong GetAPen_  (struct RastPort *rp)
{ return rp -> FgPen; }

__inline ulong GetBPen_  (struct RastPort *rp)
{ return rp -> BgPen; }


/*----- Special-functions -----*/

#ifdef STORMAMIGA_REGISTER
  #undef muls
  #undef mulu
  #undef max_Width
  #undef max_Height
#endif

__inline long  muls      (long arg1, long arg2)
{ return (arg1 * arg2); }

__inline ulong mulu      (ulong arg1, ulong arg2)
{ return (arg1 * arg2); }

__inline int max_Width (struct  Window *window)
{ return (window -> Width - window -> BorderLeft - window -> BorderRight); }

__inline int max_Height (struct Window *window)
{ return (window -> Height - window -> BorderTop - window -> BorderBottom); }


/*----- Alpha-functions -----*/

#ifdef STORMAMIGA_ALPHA
  #ifdef STORMAMIGA_REGISTER
    #undef SetAPen
    #undef SetBPen
  #endif
  #define SetAPen SetAPen_
  #define SetBPen SetBPen_

  __inline void SetAPen_ (struct RastPort *rp, ulong c)
  { rp -> FgPen = c; }

  __inline void SetBPen_ (struct RastPort *rp, ulong c)
  { rp -> BgPen = c; }
#endif

#ifdef __cplusplus
  }
#endif

#endif   /* STORMAMIGAINLINE_H */
