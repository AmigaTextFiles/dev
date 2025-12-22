@DATABASE "gg:doc/NDK/Guide/Include/proto/penmap.h"
@MASTER   "gg:os-include/proto/penmap.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:08
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/penmap.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/penmap.h" LINK File}

@ENDNODE
@NODE File "proto/penmap.h"
#ifndef _PROTO_PENMAP_H
#define _PROTO_PENMAP_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_PENMAP_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/penmap_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/penmap_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *PenMapBase;
#endif

#ifdef __GNUC__
#include <@{"inline/penmap.h" LINK "gg:doc/NDK/Guide/Include/inline/penmap.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/penmap_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/penmap_lib.h/File"}>
#endif

#endif  /*  _PROTO_PENMAP_H  */
@ENDNODE
