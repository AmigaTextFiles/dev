@DATABASE "gg:doc/NDK/Guide/Include/proto/texteditor.h"
@MASTER   "gg:os-include/proto/texteditor.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:10
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/texteditor.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/texteditor.h" LINK File}

@ENDNODE
@NODE File "proto/texteditor.h"
#ifndef _PROTO_TEXTEDITOR_H
#define _PROTO_TEXTEDITOR_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_TEXTEDITOR_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/texteditor_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/texteditor_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *TextFieldBase;
#endif

#ifdef __GNUC__
#include <@{"inline/texteditor.h" LINK "gg:doc/NDK/Guide/Include/inline/texteditor.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/texteditor_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/texteditor_lib.h/File"}>
#endif

#endif  /*  _PROTO_TEXTEDITOR_H  */
@ENDNODE
