/* $Id: disk_protos.h,v 1.7 2005/11/10 15:30:32 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/resources/disk'
MODULE 'target/resources/disk', 'target/exec/libraries', 'target/exec'
{
#include <proto/disk.h>
}
{
struct Library *DiskBase = NULL;
}

NATIVE {AllocUnit} PROC
->Not supported for some reason: PROC allocUnit( unitNum:VALUE ) IS NATIVE {-AllocUnit(} unitNum {)} ENDNATIVE !!INT
NATIVE {FreeUnit} PROC
->Not supported for some reason: PROC freeUnit( unitNum:VALUE ) IS NATIVE {FreeUnit(} unitNum {)} ENDNATIVE
NATIVE {GetUnit} PROC
->Not supported for some reason: PROC getUnit( unitPointer:PTR TO discresourceunit ) IS NATIVE {GetUnit(} unitPointer {)} ENDNATIVE !!PTR TO discresourceunit
NATIVE {GiveUnit} PROC
->Not supported for some reason: PROC giveUnit( ) IS NATIVE {GiveUnit()} ENDNATIVE
NATIVE {GetUnitID} PROC
->Not supported for some reason: PROC getUnitID( unitNum:VALUE ) IS NATIVE {GetUnitID(} unitNum {)} ENDNATIVE !!LONG
/*------ new for V37 ------*/
NATIVE {ReadUnitID} PROC
->Not supported for some reason: PROC readUnitID( unitNum:VALUE ) IS NATIVE {ReadUnitID(} unitNum {)} ENDNATIVE !!LONG
