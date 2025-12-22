/* $VER: disk_protos.h 40.1 (17.5.1996) */
OPT NATIVE
MODULE 'target/resources/disk'
MODULE 'target/exec/libraries'
{MODULE 'other/disk'}

NATIVE {diskbase} DEF diskbase:PTR TO lib

NATIVE {allocUnit} PROC
PROC allocUnit( unitNum:VALUE ) IS NATIVE {allocUnit(} unitNum {)} ENDNATIVE !!INT
NATIVE {freeUnit} PROC
PROC freeUnit( unitNum:VALUE ) IS NATIVE {freeUnit(} unitNum {)} ENDNATIVE
NATIVE {getUnit} PROC
PROC getUnit( unitPointer:PTR TO discresourceunit ) IS NATIVE {getUnit(} unitPointer {)} ENDNATIVE !!PTR TO discresourceunit
NATIVE {giveUnit} PROC
PROC giveUnit( ) IS NATIVE {giveUnit()} ENDNATIVE
NATIVE {getUnitID} PROC
PROC getUnitID( unitNum:VALUE ) IS NATIVE {getUnitID(} unitNum {)} ENDNATIVE !!LONG
/*------ new for V37 ------*/
NATIVE {readUnitID} PROC
PROC readUnitID( unitNum:VALUE ) IS NATIVE {readUnitID(} unitNum {)} ENDNATIVE !!LONG
