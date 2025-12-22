@DATABASE "gg:doc/NDK/Guide/Include/proto/button.h"
@MASTER   "gg:os-include/proto/button.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:01
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/button.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/button.h" LINK File}

@ENDNODE
@NODE File "proto/button.h"
#ifndef _PROTO_BUTTON_H
#define _PROTO_BUTTON_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_BUTTON_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/button_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/button_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *ButtonBase;
#endif

#ifdef __GNUC__
#include <@{"inline/button.h" LINK "gg:doc/NDK/Guide/Include/inline/button.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/button_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/button_lib.h/File"}>
#endif

#endif  /*  _PROTO_BUTTON_H  */
@ENDNODE
