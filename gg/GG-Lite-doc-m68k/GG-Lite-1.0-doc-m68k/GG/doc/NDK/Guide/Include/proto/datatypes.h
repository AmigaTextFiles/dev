@DATABASE "gg:doc/NDK/Guide/Include/proto/datatypes.h"
@MASTER   "gg:os-include/proto/datatypes.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:03
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/datatypes.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/datatypes.h" LINK File}

@ENDNODE
@NODE File "proto/datatypes.h"
#ifndef _PROTO_DATATYPES_H
#define _PROTO_DATATYPES_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_DATATYPES_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/datatypes_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/datatypes_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *DataTypesBase;
#endif

#ifdef __GNUC__
#include <@{"inline/datatypes.h" LINK "gg:doc/NDK/Guide/Include/inline/datatypes.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/datatypes_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/datatypes_lib.h/File"}>
#endif

#endif  /*  _PROTO_DATATYPES_H  */
@ENDNODE
