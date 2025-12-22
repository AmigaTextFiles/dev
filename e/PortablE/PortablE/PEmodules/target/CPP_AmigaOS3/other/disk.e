/* $VER: disk_protos.h 40.1 (17.5.1996) */
OPT NATIVE
MODULE 'target/resources/disk'
MODULE 'target/exec/libraries'
{
#include <clib/disk_protos.h>
struct DiskResource *DiskBase = NULL;
}
NATIVE {CLIB_DISK_PROTOS_H} CONST

NATIVE {DiskBase} DEF diskbase:PTR TO lib

NATIVE {AllocUnit} PROC
PROC allocUnit( unitNum:VALUE ) IS NATIVE {-AllocUnit(} unitNum {)} ENDNATIVE !!INT
NATIVE {FreeUnit} PROC
PROC freeUnit( unitNum:VALUE ) IS NATIVE {FreeUnit(} unitNum {)} ENDNATIVE
NATIVE {GetUnit} PROC
PROC getUnit( unitPointer:PTR TO discresourceunit ) IS NATIVE {GetUnit(} unitPointer {)} ENDNATIVE !!PTR TO discresourceunit
NATIVE {GiveUnit} PROC
PROC giveUnit( ) IS NATIVE {GiveUnit()} ENDNATIVE
NATIVE {GetUnitID} PROC
PROC getUnitID( unitNum:VALUE ) IS NATIVE {GetUnitID(} unitNum {)} ENDNATIVE !!LONG
/*------ new for V37 ------*/
NATIVE {ReadUnitID} PROC
PROC readUnitID( unitNum:VALUE ) IS NATIVE {ReadUnitID(} unitNum {)} ENDNATIVE !!LONG
