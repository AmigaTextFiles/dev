@DATABASE "gg:doc/NDK/Guide/Include/proto/timer.h"
@MASTER   "gg:os-include/proto/timer.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:10
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/timer.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/timer.h" LINK File}

@ENDNODE
@NODE File "proto/timer.h"
#ifndef _PROTO_TIMER_H
#define _PROTO_TIMER_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_TIMER_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/timer_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/timer_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Device" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File" 24} *TimerBase;
#endif

#ifdef __GNUC__
#include <@{"inline/timer.h" LINK "gg:doc/NDK/Guide/Include/inline/timer.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/timer_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/timer_lib.h/File"}>
#endif

#endif  /*  _PROTO_TIMER_H  */
@ENDNODE
