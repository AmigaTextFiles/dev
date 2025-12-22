@DATABASE "gg:doc/NDK/Guide/Include/clib/macros.h"
@MASTER   "gg:os-include/clib/macros.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:53
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/macros.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/macros.h" LINK File}


@{b}#defines@{ub}

@{"ABS()" LINK "gg:doc/NDK/Guide/Include/clib/macros.h/File" 15}  @{"MAX()" LINK "gg:doc/NDK/Guide/Include/clib/macros.h/File" 13}  @{"MIN()" LINK "gg:doc/NDK/Guide/Include/clib/macros.h/File" 14}

@ENDNODE
@NODE File "clib/macros.h"
#ifndef CLIB_MACROS_H
#define CLIB_MACROS_H
/*
**      $VER: macros.h 36.0 (30.11.1990)
**      Includes Release 45.1
**
**      C prototypes
**
**      (C) Copyright 1990-2001 Amiga, Inc.
**          All Rights Reserved
*/

#define MAX(a,b)    ((a)>(b)?(a):(b))
#define MIN(a,b)    ((a)<(b)?(a):(b))
#define ABS(x)      ((x<0)?(-(x)):(x))

#endif  /* CLIB_MACROS_H */
@ENDNODE
