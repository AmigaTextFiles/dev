@DATABASE "gg:doc/NDK/Guide/Include/proto/layers.h"
@MASTER   "gg:os-include/proto/layers.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:06
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/layers.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/layers.h" LINK File}

@ENDNODE
@NODE File "proto/layers.h"
#ifndef _PROTO_LAYERS_H
#define _PROTO_LAYERS_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_LAYERS_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/layers_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/layers_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *LayersBase;
#endif

#ifdef __GNUC__
#include <@{"inline/layers.h" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/layers_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/layers_lib.h/File"}>
#endif

#endif  /*  _PROTO_LAYERS_H  */
@ENDNODE
