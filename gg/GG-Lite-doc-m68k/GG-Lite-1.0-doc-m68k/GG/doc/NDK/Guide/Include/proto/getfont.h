@DATABASE "gg:doc/NDK/Guide/Include/proto/getfont.h"
@MASTER   "gg:os-include/proto/getfont.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:04
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/getfont.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/getfont.h" LINK File}

@ENDNODE
@NODE File "proto/getfont.h"
#ifndef _PROTO_GETFONT_H
#define _PROTO_GETFONT_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_GETFONT_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/getfont_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/getfont_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *GetFontBase;
#endif

#ifdef __GNUC__
#include <@{"inline/getfont.h" LINK "gg:doc/NDK/Guide/Include/inline/getfont.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/getfont_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/getfont_lib.h/File"}>
#endif

#endif  /*  _PROTO_GETFONT_H  */
@ENDNODE
