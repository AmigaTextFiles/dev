@DATABASE "gg:doc/NDK/Guide/Include/proto/mathieeedoubbas.h"
@MASTER   "gg:os-include/proto/mathieeedoubbas.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:07
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/mathieeedoubbas.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/mathieeedoubbas.h" LINK File}

@ENDNODE
@NODE File "proto/mathieeedoubbas.h"
#ifndef _PROTO_MATHIEEEDOUBBAS_H
#define _PROTO_MATHIEEEDOUBBAS_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_MATHIEEEDOUBBAS_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/mathieeedoubbas_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/mathieeedoubbas_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19} *MathIeeeDoubBasBase;
#endif

#ifdef __GNUC__
#include <@{"inline/mathieeedoubbas.h" LINK "gg:doc/NDK/Guide/Include/inline/mathieeedoubbas.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/mathieeedoubbas_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/mathieeedoubbas_lib.h/File"}>
#endif

#endif  /*  _PROTO_MATHIEEEDOUBBAS_H  */
@ENDNODE
