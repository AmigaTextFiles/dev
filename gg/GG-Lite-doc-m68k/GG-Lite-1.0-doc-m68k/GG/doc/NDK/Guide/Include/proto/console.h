@DATABASE "gg:doc/NDK/Guide/Include/proto/console.h"
@MASTER   "gg:os-include/proto/console.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:02
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/console.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/console.h" LINK File}

@ENDNODE
@NODE File "proto/console.h"
#ifndef _PROTO_CONSOLE_H
#define _PROTO_CONSOLE_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_CONSOLE_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/console_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/console_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Device" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File" 24} *ConsoleDevice;
#endif

#ifdef __GNUC__
#include <@{"inline/console.h" LINK "gg:doc/NDK/Guide/Include/inline/console.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/console_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/console_lib.h/File"}>
#endif

#endif  /*  _PROTO_CONSOLE_H  */
@ENDNODE
