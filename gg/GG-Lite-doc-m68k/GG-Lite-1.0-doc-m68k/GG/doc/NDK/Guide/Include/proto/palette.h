@DATABASE "gg:doc/NDK/Guide/Include/proto/palette.h"
@MASTER   "gg:os-include/proto/palette.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:08
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/palette.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/palette.h" LINK File}

@ENDNODE
@NODE File "proto/palette.h"
#ifndef _PROTO_PALETTE_H
#define _PROTO_PALETTE_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_PALETTE_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/palette_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/palette_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *PaletteBase;
#endif

#ifdef __GNUC__
#include <@{"inline/palette.h" LINK "gg:doc/NDK/Guide/Include/inline/palette.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/palette_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/palette_lib.h/File"}>
#endif

#endif  /*  _PROTO_PALETTE_H  */
@ENDNODE
