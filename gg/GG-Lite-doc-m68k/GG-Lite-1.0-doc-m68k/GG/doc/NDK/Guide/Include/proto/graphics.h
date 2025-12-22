@DATABASE "gg:doc/NDK/Guide/Include/proto/graphics.h"
@MASTER   "gg:os-include/proto/graphics.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:05
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/graphics.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/graphics.h" LINK File}

@ENDNODE
@NODE File "proto/graphics.h"
#ifndef _PROTO_GRAPHICS_H
#define _PROTO_GRAPHICS_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_GRAPHICS_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/graphics_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/graphics_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct GfxBase" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 26} *GfxBase;
#endif

#ifdef __GNUC__
#include <@{"inline/graphics.h" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/graphics_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/graphics_lib.h/File"}>
#endif

#endif  /*  _PROTO_GRAPHICS_H  */
@ENDNODE
