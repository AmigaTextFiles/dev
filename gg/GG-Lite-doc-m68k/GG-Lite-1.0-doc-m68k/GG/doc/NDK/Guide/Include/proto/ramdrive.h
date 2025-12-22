@DATABASE "gg:doc/NDK/Guide/Include/proto/ramdrive.h"
@MASTER   "gg:os-include/proto/ramdrive.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:09
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/ramdrive.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/ramdrive.h" LINK File}

@ENDNODE
@NODE File "proto/ramdrive.h"
#ifndef _PROTO_RAMDRIVE_H
#define _PROTO_RAMDRIVE_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_RAMDRIVE_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/ramdrive_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/ramdrive_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Device" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File" 24} *RamdriveDevice;
#endif

#ifdef __GNUC__
#include <@{"inline/ramdrive.h" LINK "gg:doc/NDK/Guide/Include/inline/ramdrive.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/ramdrive_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/ramdrive_lib.h/File"}>
#endif

#endif  /*  _PROTO_RAMDRIVE_H  */
@ENDNODE
