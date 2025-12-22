@DATABASE "gg:doc/NDK/Guide/Include/proto/checkbox.h"
@MASTER   "gg:os-include/proto/checkbox.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:02
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/checkbox.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/checkbox.h" LINK File}

@ENDNODE
@NODE File "proto/checkbox.h"
#ifndef _PROTO_CHECKBOX_H
#define _PROTO_CHECKBOX_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_CHECKBOX_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/checkbox_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/checkbox_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *CheckBoxBase;
#endif

#ifdef __GNUC__
#include <@{"inline/checkbox.h" LINK "gg:doc/NDK/Guide/Include/inline/checkbox.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/checkbox_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/checkbox_lib.h/File"}>
#endif

#endif  /*  _PROTO_CHECKBOX_H  */
@ENDNODE
