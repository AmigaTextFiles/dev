@DATABASE "gg:doc/NDK/Guide/Include/proto/glyph.h"
@MASTER   "gg:os-include/proto/glyph.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:05
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/glyph.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/glyph.h" LINK File}

@ENDNODE
@NODE File "proto/glyph.h"
#ifndef _PROTO_GLYPH_H
#define _PROTO_GLYPH_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_GLYPH_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/glyph_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/glyph_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *GlyphBase;
#endif

#ifdef __GNUC__
#include <@{"inline/glyph.h" LINK "gg:doc/NDK/Guide/Include/inline/glyph.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/glyph_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/glyph_lib.h/File"}>
#endif

#endif  /*  _PROTO_GLYPH_H  */
@ENDNODE
