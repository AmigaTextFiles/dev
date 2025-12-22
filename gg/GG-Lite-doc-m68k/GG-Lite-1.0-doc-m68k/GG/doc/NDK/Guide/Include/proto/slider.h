@DATABASE "gg:doc/NDK/Guide/Include/proto/slider.h"
@MASTER   "gg:os-include/proto/slider.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:10
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/slider.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/slider.h" LINK File}

@ENDNODE
@NODE File "proto/slider.h"
#ifndef _PROTO_SLIDER_H
#define _PROTO_SLIDER_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_SLIDER_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/slider_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/slider_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *SliderBase;
#endif

#ifdef __GNUC__
#include <@{"inline/slider.h" LINK "gg:doc/NDK/Guide/Include/inline/slider.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/slider_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/slider_lib.h/File"}>
#endif

#endif  /*  _PROTO_SLIDER_H  */
@ENDNODE
