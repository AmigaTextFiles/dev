#ifndef SYSTEM_TYPES_H
#ifndef EXEC_TYPES_H
#define SYSTEM_TYPES_H
#define EXEC_TYPES_H

/*
**  $VER: types.h (January 1998)
**
**  (C) Copyright 1997-1998 DreamWorld Productions
**      All Rights Reserved.
*/

#define GLOBAL   extern        /* The declaratory use of an external */
#define IMPORT   extern        /* Reference to an external */
#define STATIC   static        /* Local static variable */
#define REGISTER register      /* Register variable */

#ifndef VOID
#define VOID void
#endif

typedef void           *APTR;  /* 32-bit untyped pointer */
typedef long           LONG;   /* Signed 32-bit quantity */
typedef unsigned long  ULONG;  /* Unsigned 32-bit quantity */
typedef short          WORD;   /* Signed 16-bit quantity */
typedef unsigned short UWORD;  /* Unsigned 16-bit quantity */
typedef unsigned char  UBYTE;  /* Unsigned 8-bit quantity */
typedef unsigned short RPTR;   /* Signed relative pointer */
typedef long           ECODE;  /* Standard error code */

#if __STDC__
typedef signed char BYTE;      /* Signed 8-bit quantity */
#else
typedef char BYTE;             /* Signed 8-bit quantity */
#endif

#ifdef __cplusplus
typedef char *STRPTR;              /* string pointer (NULL terminated) */
#else
typedef unsigned char *STRPTR;     /* string pointer (NULL terminated) */
#endif

typedef float  FLOAT;
typedef double DOUBLE;
typedef short  BOOL;
typedef unsigned char TEXT;

#ifndef NULL
#define NULL 0
#endif

#ifndef TRUE
#define TRUE 1
#endif

#ifndef FALSE
#define FALSE 0
#endif

#ifndef IS
#define IS ==
#endif

#ifndef AND
#define AND &&
#endif

#ifndef OR
#define OR ||
#endif

#ifndef YES
#define YES TRUE
#endif

#ifndef NO
#define NO FALSE
#endif

#endif  /* EXEC_TYPES_H */
#endif  /* SYSTEM_TYPES_H */
