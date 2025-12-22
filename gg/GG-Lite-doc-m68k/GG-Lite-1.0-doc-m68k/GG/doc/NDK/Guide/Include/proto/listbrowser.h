@DATABASE "gg:doc/NDK/Guide/Include/proto/listbrowser.h"
@MASTER   "gg:os-include/proto/listbrowser.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:06
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/listbrowser.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/listbrowser.h" LINK File}

@ENDNODE
@NODE File "proto/listbrowser.h"
#ifndef _PROTO_LISTBROWSER_H
#define _PROTO_LISTBROWSER_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_LISTBROWSER_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/listbrowser_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/listbrowser_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *ListBrowserBase;
#endif

#ifdef __GNUC__
#include <@{"inline/listbrowser.h" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/listbrowser_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/listbrowser_lib.h/File"}>
#endif

#endif  /*  _PROTO_LISTBROWSER_H  */
@ENDNODE
