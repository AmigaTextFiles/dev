@DATABASE "gg:doc/NDK/Guide/Include/graphics/coerce.h"
@MASTER   "gg:os-include/graphics/coerce.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:51
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "graphics/coerce.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"graphics/coerce.h" LINK File}


@{b}#defines@{ub}

@{"AVOID_FLICKER" LINK "gg:doc/NDK/Guide/Include/graphics/coerce.h/File" 23}  @{"BIDTAG_COERCE" LINK "gg:doc/NDK/Guide/Include/graphics/coerce.h/File" 29}  @{"IGNORE_MCOMPAT" LINK "gg:doc/NDK/Guide/Include/graphics/coerce.h/File" 26}  @{"PRESERVE_COLORS" LINK "gg:doc/NDK/Guide/Include/graphics/coerce.h/File" 20}

@ENDNODE
@NODE File "graphics/coerce.h"
#ifndef GRAPHICS_COERCE_H
#define GRAPHICS_COERCE_H
/*
**      $VER: coerce.h 39.3 (15.2.1993)
**      Includes Release 45.1
**
**      mode coercion definitions
**
**      (C) Copyright 1992-2001 Amiga, Inc.
**          All Rights Reserved
*/

/* These flags are passed (in combination) to @{"CoerceMode()" LINK "gg:doc/NDK/Guide/graphics/CoerceMode"} to determine the
 * type of coercion required.
 */

/* Ensure that the mode coerced to can display just as many colours as the
 * ViewPort being coerced.
 */
#define PRESERVE_COLORS 1

/* Ensure that the mode coerced to is not interlaced. */
#define AVOID_FLICKER 2

/* Coercion should ignore monitor compatibility issues. */
#define IGNORE_MCOMPAT 4


#define BIDTAG_COERCE 1 /* Private */

#endif
@ENDNODE
