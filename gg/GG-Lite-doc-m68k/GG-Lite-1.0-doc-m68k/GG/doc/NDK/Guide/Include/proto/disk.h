@DATABASE "gg:doc/NDK/Guide/Include/proto/disk.h"
@MASTER   "gg:os-include/proto/disk.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:03
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/disk.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/disk.h" LINK File}

@ENDNODE
@NODE File "proto/disk.h"
#ifndef _PROTO_DISK_H
#define _PROTO_DISK_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_DISK_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/disk_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/disk_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern struct DiskResource *DiskBase;
#endif

#ifdef __GNUC__
#include <@{"inline/disk.h" LINK "gg:doc/NDK/Guide/Include/inline/disk.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/disk_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/disk_lib.h/File"}>
#endif

#endif  /*  _PROTO_DISK_H  */
@ENDNODE
