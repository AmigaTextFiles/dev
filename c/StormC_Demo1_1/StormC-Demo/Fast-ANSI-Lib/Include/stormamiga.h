#ifndef  STORMAMIGA_H
#define  STORMAMIGA_H

/*
**   $VER: stormamiga.h 41.013 (12.07.1996)
**
**       Copyright © 1996 by COMPIUTECK
**         written by Matthias Henze
**            All Rights Reserved
*/

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef  _INCLUDE_STDIO_H
#include <stdio.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#ifndef NULL
#define NULL 0
#endif


/*----- Nonstandard-AmigaLib-functions -----*/

LONG SPRINTF( STRPTR buffer, STRPTR fmt, ...);
LONG VSPRINTF( STRPTR buffer, STRPTR fmt, APTR argarray);


/*----- Nonstandard-stdio-functions -----*/

int printf_(const char *, ...);
int printf__(const char *, ...);
int fprintf_(FILE *, const char *, ...);
int fprintf__(FILE *, const char *, ...);
int sprintf_(char *, const char *, ...);
int sprintf__(char *, const char *, ...);

int vprintf_(const char *, va_list);
int vprintf__(const char *, va_list);
int vfprintf_(FILE *, const char *, va_list);
int vfprintf__(FILE *, const char *, va_list);
int vsprintf_(char *, const char *, va_list);
int vsprintf__(char *, const char *, va_list);

int scanf_(const char *, ...);
int scanf__(const char *, ...);
int fscanf_(FILE *, const char *, ...);
int fscanf__(FILE *, const char *, ...);
int sscanf_(const char *, const char *, ...);
int sscanf__(const char *, const char *, ...);

int vscanf(const char *, va_list);
int vscanf_(const char *, va_list);
int vscanf__(const char *, va_list);
int vfscanf(FILE *, const char *, va_list);
int vfscanf_(FILE *, const char *, va_list);
int vfscanf__(FILE *, const char *, va_list);
int vsscanf(const char *, const char *, va_list);
int vsscanf_(const char *, const char *, va_list);
int vsscanf__(const char *, const char *, va_list);


/*----- GCC-string-functions -----*/

int      strcoll (const char *, const char *);
size_t   strxfrm (char *, const char *, size_t);

/*----- GCC-Nonstandard-string-functions -----*/

int      bcmp (const void *, const void *, size_t);
void     bcopy (const void *, void *, size_t);
#ifdef bzero
#undef bzero
void     bzero (void *, size_t);
#endif
int      ffs (int);
char    *index (const char *, int);
char    *rindex (const char *, int);
void    *memccpy (void *, const void *, int, size_t);
char    *strsep (char **, const char *);
void     swab (const void *, void *, size_t);


/*----- Special-functions -----*/

LONG muls( register __d0 long arg1, register __d1 long arg2 );
ULONG mulu( register __d0 unsigned long arg1, register __d1 unsigned long arg2 );
LONG divsl( register __d0 long dividend, register __d1 long divisor );
ULONG divul( register __d0 unsigned long dividend, register __d1 unsigned long divisor );


#ifdef __cplusplus
}
#endif

#endif   /* STORMAMIGA_H */
