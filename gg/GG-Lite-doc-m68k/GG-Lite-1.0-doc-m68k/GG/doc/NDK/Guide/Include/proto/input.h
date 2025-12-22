@DATABASE "gg:doc/NDK/Guide/Include/proto/input.h"
@MASTER   "gg:os-include/proto/input.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:05
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/input.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/input.h" LINK File}

@ENDNODE
@NODE File "proto/input.h"
#ifndef _PROTO_INPUT_H
#define _PROTO_INPUT_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_INPUT_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/input_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/input_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Device" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File" 24} *InputBase;
#endif

#ifdef __GNUC__
#include <@{"inline/input.h" LINK "gg:doc/NDK/Guide/Include/inline/input.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/input_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/input_lib.h/File"}>
#endif

#endif  /*  _PROTO_INPUT_H  */
@ENDNODE
