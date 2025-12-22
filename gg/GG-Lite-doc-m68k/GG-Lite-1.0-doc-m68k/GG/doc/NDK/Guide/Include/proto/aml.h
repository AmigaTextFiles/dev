@DATABASE "gg:doc/NDK/Guide/Include/proto/aml.h"
@MASTER   "gg:os-include/proto/aml.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:00
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/aml.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/aml.h" LINK File}

@ENDNODE
@NODE File "proto/aml.h"
#ifndef _PROTO_AML_H
#define _PROTO_AML_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_AML_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/aml_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/aml_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *AmlBase;
#endif

#ifdef __GNUC__
#include <@{"inline/aml.h" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/aml_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/aml_lib.h/File"}>
#endif

#endif  /*  _PROTO_AML_H  */
@ENDNODE
