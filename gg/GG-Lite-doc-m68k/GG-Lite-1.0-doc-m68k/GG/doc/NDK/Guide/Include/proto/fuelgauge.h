@DATABASE "gg:doc/NDK/Guide/Include/proto/fuelgauge.h"
@MASTER   "gg:os-include/proto/fuelgauge.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:04
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/fuelgauge.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/fuelgauge.h" LINK File}

@ENDNODE
@NODE File "proto/fuelgauge.h"
#ifndef _PROTO_FUELGAUGE_H
#define _PROTO_FUELGAUGE_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_FUELGAUGE_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/fuelgauge_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/fuelgauge_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *FuelGaugeBase;
#endif

#ifdef __GNUC__
#include <@{"inline/fuelgauge.h" LINK "gg:doc/NDK/Guide/Include/inline/fuelgauge.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/fuelgauge_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/fuelgauge_lib.h/File"}>
#endif

#endif  /*  _PROTO_FUELGAUGE_H  */
@ENDNODE
