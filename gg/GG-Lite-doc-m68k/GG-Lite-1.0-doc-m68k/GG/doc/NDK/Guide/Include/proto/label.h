@DATABASE "gg:doc/NDK/Guide/Include/proto/label.h"
@MASTER   "gg:os-include/proto/label.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:06
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/label.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/label.h" LINK File}

@ENDNODE
@NODE File "proto/label.h"
#ifndef _PROTO_LABEL_H
#define _PROTO_LABEL_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_LABEL_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/label_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/label_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *LabelBase;
#endif

#ifdef __GNUC__
#include <@{"inline/label.h" LINK "gg:doc/NDK/Guide/Include/inline/label.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/label_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/label_lib.h/File"}>
#endif

#endif  /*  _PROTO_LABEL_H  */
@ENDNODE
