@DATABASE "gg:doc/NDK/Guide/Include/proto/guigfx.h"
@MASTER   "gg:os-include/proto/guigfx.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:05
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/guigfx.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/guigfx.h" LINK File}

@ENDNODE
@NODE File "proto/guigfx.h"
#ifndef _PROTO_GUIGFX_H
#define _PROTO_GUIGFX_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_GUIGFX_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/guigfx_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/guigfx_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *GuiGFXBase;
#endif

#ifdef __GNUC__
#include <@{"inline/guigfx.h" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File"}>
#elif !defined(__VBCC__)
#include <pragma/guigfx_lib.h>
#endif

#endif  /*  _PROTO_GUIGFX_H  */
@ENDNODE
