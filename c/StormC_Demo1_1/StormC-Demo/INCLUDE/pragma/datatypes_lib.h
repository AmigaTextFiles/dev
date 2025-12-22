#ifndef _INCLUDE_PRAGMA_DATATYPES_LIB_H
#define _INCLUDE_PRAGMA_DATATYPES_LIB_H

/*
**  $VER: datatypes_lib.h 10.2 (29.12.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_DATATYPES_PROTOS_H
#include <clib/datatypes_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(DataTypesBase, 0x24, ObtainDataTypeA(d0,a0,a1))
#pragma tagcall(DataTypesBase, 0x24, ObtainDataType(d0,a0,a1)) // New
#pragma amicall(DataTypesBase, 0x2a, ReleaseDataType(a0))
#pragma amicall(DataTypesBase, 0x30, NewDTObjectA(d0,a0))
#pragma tagcall(DataTypesBase, 0x30, NewDTObject(d0,a0)) // New
#pragma amicall(DataTypesBase, 0x36, DisposeDTObject(a0))
#pragma amicall(DataTypesBase, 0x3c, SetDTAttrsA(a0,a1,a2,a3))
#pragma tagcall(DataTypesBase, 0x3c, SetDTAttrs(a0,a1,a2,a3)) // New
#pragma amicall(DataTypesBase, 0x42, GetDTAttrsA(a0,a2))
#pragma tagcall(DataTypesBase, 0x42, GetDTAttrs(a0,a2)) // New
#pragma amicall(DataTypesBase, 0x48, AddDTObject(a0,a1,a2,d0))
#pragma amicall(DataTypesBase, 0x4e, RefreshDTObjectA(a0,a1,a2,a3))
#pragma tagcall(DataTypesBase, 0x4e, RefreshDTObjects(a0,a1,a2,a3)) // New
#pragma amicall(DataTypesBase, 0x54, DoAsyncLayout(a0,a1))
#pragma amicall(DataTypesBase, 0x5a, DoDTMethodA(a0,a1,a2,a3))
#pragma tagcall(DataTypesBase, 0x5a, DoDTMethod(a0,a1,a2,a3)) // New
#pragma amicall(DataTypesBase, 0x60, RemoveDTObject(a0,a1))
#pragma amicall(DataTypesBase, 0x66, GetDTMethods(a0))
#pragma amicall(DataTypesBase, 0x6c, GetDTTriggerMethods(a0))
#pragma amicall(DataTypesBase, 0x72, PrintDTObjectA(a0,a1,a2,a3))
#pragma tagcall(DataTypesBase, 0x72, PrintDTObject(a0,a1,a2,a3)) // New
#pragma amicall(DataTypesBase, 0x8a, GetDTString(d0))

#ifdef __cplusplus
}
#endif

#endif
