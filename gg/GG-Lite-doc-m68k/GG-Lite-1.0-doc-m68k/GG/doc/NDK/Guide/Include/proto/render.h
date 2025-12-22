@DATABASE "gg:doc/NDK/Guide/Include/proto/render.h"
@MASTER   "gg:os-include/proto/render.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:09
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/render.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/render.h" LINK File}

@ENDNODE
@NODE File "proto/render.h"
#ifndef _PROTO_RENDER_H
#define _PROTO_RENDER_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_RENDER_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/render_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/render_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *RenderBase;
#endif

#ifdef __GNUC__
#include <@{"inline/render.h" LINK "gg:doc/NDK/Guide/Include/inline/render.h/File"}>
#elif !defined(__VBCC__)
#include <pragma/render_lib.h>
#endif

#endif  /*  _PROTO_RENDER_H  */
@ENDNODE
