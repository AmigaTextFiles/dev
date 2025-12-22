@DATABASE "gg:doc/NDK/Guide/Include/proto/space.h"
@MASTER   "gg:os-include/proto/space.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:10
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/space.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/space.h" LINK File}

@ENDNODE
@NODE File "proto/space.h"
#ifndef _PROTO_SPACE_H
#define _PROTO_SPACE_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_SPACE_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/space_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/space_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *SpaceBase;
#endif

#ifdef __GNUC__
#include <@{"inline/space.h" LINK "gg:doc/NDK/Guide/Include/inline/space.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/space_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/space_lib.h/File"}>
#endif

#endif  /*  _PROTO_SPACE_H  */
@ENDNODE
