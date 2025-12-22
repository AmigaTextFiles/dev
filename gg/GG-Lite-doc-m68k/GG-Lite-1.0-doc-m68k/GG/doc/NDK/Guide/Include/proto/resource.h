@DATABASE "gg:doc/NDK/Guide/Include/proto/resource.h"
@MASTER   "gg:os-include/proto/resource.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:09
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/resource.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/resource.h" LINK File}

@ENDNODE
@NODE File "proto/resource.h"
#ifndef _PROTO_RESOURCE_H
#define _PROTO_RESOURCE_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_RESOURCE_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/resource_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/resource_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *ResourceBase;
#endif

#ifdef __GNUC__
#include <@{"inline/resource.h" LINK "gg:doc/NDK/Guide/Include/inline/resource.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/resource_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/resource_lib.h/File"}>
#endif

#endif  /*  _PROTO_RESOURCE_H  */
@ENDNODE
