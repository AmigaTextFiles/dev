@DATABASE "gg:doc/NDK/Guide/Include/exec/types.h"
@MASTER   "gg:os-include/exec/types.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:20
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "exec/types.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"exec/types.h" LINK File}


@{b}Typedefs@{ub}

@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}      @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}   @{"BYTEBITS" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 63}  @{"CONST_APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 73}  @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75}  @{"COUNT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 83}
@{"CPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 85}    @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}    @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}      @{"LONGBITS" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 53}    @{"RPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 64}          @{"SHORT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 81}
@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}  @{"TEXT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 92}      @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}  @{"UCOUNT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 84}    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}       @{"USHORT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 82}        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}
@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    @{"WORDBITS" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 56}  


@{b}#defines@{ub}

@{"__CLIB_PROTOTYPE()" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 117}  @{"APTR_TYPEDEF" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 48}  @{"BYTEMASK" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 105}  @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30}
@{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}               @{"GLOBAL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 17}        @{"IMPORT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 18}    @{"INCLUDE_VERSION" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 13}
@{"LIBRARY_MINIMUM" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 110}     @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}          @{"REGISTER" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 20}  @{"STATIC" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 19}
@{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95}                @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24}          @{"VOLATILE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 38}  

@ENDNODE
@NODE File "exec/types.h"
#ifndef EXEC_TYPES_H
#define EXEC_TYPES_H
/*
**      $Id: types.h,v 45.2 2001/03/12 17:51:53 heinz Exp $
**
**      Data typing.  Must be included before any other Amiga include.
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/


#define INCLUDE_VERSION 45 /* Version of the include files in use. (Do not
                              use this label for @{"OpenLibrary()" LINK "gg:doc/NDK/Guide/exec/OpenLibrary"} calls!) */


#define GLOBAL  extern      /* the declaratory use of an external */
#define IMPORT  extern      /* reference to an external */
#define STATIC  static      /* a local static variable */
#define REGISTER register   /* a (hopefully) register variable */


#ifndef VOID
#define VOID            void
#endif

/* General const support */
#ifndef CONST
#if __STDC__
#define @{"CONST" LINK "File" 32}           const
#else
#define @{"CONST" LINK "File" 30}
#endif
#endif

#ifndef VOLATILE
#if __STDC__
#define @{"VOLATILE" LINK "File" 40}        volatile
#else
#define @{"VOLATILE" LINK "File" 38}
#endif
#endif

  /*  WARNING: @{"APTR" LINK File 49} was redefined for the V36 Includes!  @{"APTR" LINK File 49} is a   */
 /*  32-Bit Absolute Memory Pointer.  C pointer math will not       */
/*  operate on @{"APTR" LINK File 49} --  use "@{"ULONG" LINK File 52} *" instead.                     */
#ifndef APTR_TYPEDEF
#define APTR_TYPEDEF
typedef void           *APTR;       /* 32-bit untyped pointer */
#endif
typedef long            LONG;       /* signed 32-bit quantity */
typedef unsigned long   ULONG;      /* unsigned 32-bit quantity */
typedef unsigned long   LONGBITS;   /* 32 bits manipulated individually */
typedef short           WORD;       /* signed 16-bit quantity */
typedef unsigned short  UWORD;      /* unsigned 16-bit quantity */
typedef unsigned short  WORDBITS;   /* 16 bits manipulated individually */
#if __STDC__
typedef signed char     @{"BYTE" LINK "File" 60};       /* signed 8-bit quantity */
#else
typedef char            @{"BYTE" LINK "File" 58};       /* signed 8-bit quantity */
#endif
typedef unsigned char   UBYTE;      /* unsigned 8-bit quantity */
typedef unsigned char   BYTEBITS;   /* 8 bits manipulated individually */
typedef unsigned short  RPTR;       /* signed relative pointer */

#ifdef __cplusplus
typedef char           *@{"STRPTR" LINK "File" 69};     /* string pointer (@{"NULL" LINK File 101} terminated) */
#else
typedef unsigned char  *@{"STRPTR" LINK "File" 67};     /* string pointer (@{"NULL" LINK File 101} terminated) */
#endif

/* const support for pointer types */
typedef @{"CONST" LINK File 30} void     *CONST_APTR;     /* 32-bit untyped const pointer */
#ifdef __cplusplus
typedef @{"CONST" LINK File 30} char           *@{"CONST_STRPTR" LINK "File" 77}; /* @{"STRPTR" LINK File 67} to const data */
#else
typedef @{"CONST" LINK File 30} unsigned char  *@{"CONST_STRPTR" LINK "File" 75}; /* @{"STRPTR" LINK File 67} to const data */
#endif

/* For compatibility only: (don't use in new code) */
typedef short           SHORT;      /* signed 16-bit quantity (use @{"WORD" LINK File 54}) */
typedef unsigned short  USHORT;     /* unsigned 16-bit quantity (use @{"UWORD" LINK File 55}) */
typedef short           COUNT;
typedef unsigned short  UCOUNT;
typedef @{"ULONG" LINK File 52}           CPTR;


/* Types with specific semantics */
typedef float           FLOAT;
typedef double          DOUBLE;
typedef short           BOOL;
typedef unsigned char   TEXT;

#ifndef TRUE
#define TRUE            1
#endif
#ifndef FALSE
#define FALSE           0
#endif
#ifndef NULL
#define NULL            0L
#endif


#define BYTEMASK        0xFF


 /* #define LIBRARY_VERSION is now obsolete.  Please use @{"LIBRARY_MINIMUM" LINK File 110} */
/* or code the specific minimum library version you require.            */
#define LIBRARY_MINIMUM 40 /* Lowest version supported by Amiga, Inc. */

/* Some structure definitions include prototypes for function pointers.
 * This may not work with `C' compilers that do not comply to the ANSI
 * standard, which we will have to work around.
 */
#if __STDC__
#define @{"__CLIB_PROTOTYPE" LINK "File" 119}(a) a
#else
#define @{"__CLIB_PROTOTYPE" LINK "File" 117}(a)
#endif /* __STDC__ */

#endif  /* EXEC_TYPES_H */
@ENDNODE
