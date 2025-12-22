@DATABASE "gg:doc/NDK/Guide/Include/proto/chooser.h"
@MASTER   "gg:os-include/proto/chooser.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:02
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/chooser.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/chooser.h" LINK File}

@ENDNODE
@NODE File "proto/chooser.h"
#ifndef _PROTO_CHOOSER_H
#define _PROTO_CHOOSER_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_CHOOSER_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/chooser_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/chooser_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *ChooserBase;
#endif

#ifdef __GNUC__
#include <@{"inline/chooser.h" LINK "gg:doc/NDK/Guide/Include/inline/chooser.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/chooser_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/chooser_lib.h/File"}>
#endif

#endif  /*  _PROTO_CHOOSER_H  */
@ENDNODE
