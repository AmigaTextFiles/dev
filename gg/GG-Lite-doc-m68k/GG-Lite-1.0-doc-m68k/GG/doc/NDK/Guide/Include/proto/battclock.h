@DATABASE "gg:doc/NDK/Guide/Include/proto/battclock.h"
@MASTER   "gg:os-include/proto/battclock.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:01
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/battclock.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/battclock.h" LINK File}

@ENDNODE
@NODE File "proto/battclock.h"
#ifndef _PROTO_BATTCLOCK_H
#define _PROTO_BATTCLOCK_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_BATTCLOCK_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/battclock_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/battclock_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *BattClockBase;
#endif

#ifdef __GNUC__
#include <@{"inline/battclock.h" LINK "gg:doc/NDK/Guide/Include/inline/battclock.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/battclock_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/battclock_lib.h/File"}>
#endif

#endif  /*  _PROTO_BATTCLOCK_H  */
@ENDNODE
