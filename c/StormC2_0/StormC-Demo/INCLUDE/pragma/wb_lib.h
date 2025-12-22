#ifndef _INCLUDE_PRAGMA_WB_LIB_H
#define _INCLUDE_PRAGMA_WB_LIB_H

/*
**  $VER: wb_lib.h 10.2 (29.12.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_WB_PROTOS_H
#include <clib/wb_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(WorkbenchBase, 0x30, AddAppWindowA(d0,d1,a0,a1,a2))
#pragma tagcall(WorkbenchBase, 0x30, AddAppWindow(d0,d1,a0,a1,a2)) // New
#pragma amicall(WorkbenchBase, 0x36, RemoveAppWindow(a0))
#pragma amicall(WorkbenchBase, 0x3c, AddAppIconA(d0,d1,a0,a1,a2,a3,a4))
#pragma tagcall(WorkbenchBase, 0x3c, AddAppIcon(d0,d1,a0,a1,a2,a3,a4)) // New
#pragma amicall(WorkbenchBase, 0x42, RemoveAppIcon(a0))
#pragma amicall(WorkbenchBase, 0x48, AddAppMenuItemA(d0,d1,a0,a1,a2))
#pragma tagcall(WorkbenchBase, 0x48, AddAppMenuItem(d0,d1,a0,a1,a2)) // New
#pragma amicall(WorkbenchBase, 0x4e, RemoveAppMenuItem(a0))
#pragma amicall(WorkbenchBase, 0x5a, WBInfo(a0,a1,a2))

#ifdef __cplusplus
}
#endif

#endif
