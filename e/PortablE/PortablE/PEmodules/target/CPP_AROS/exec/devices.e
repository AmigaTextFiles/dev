/* $Id: devices.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE
MODULE 'target/exec/libraries', 'target/exec/ports'
MODULE 'target/exec/types'
{#include <exec/devices.h>}
NATIVE {EXEC_DEVICES_H} CONST

NATIVE {Device} OBJECT dd
    {dd_Library}	lib	:lib
ENDOBJECT

NATIVE {Unit} OBJECT unit
    {unit_MsgPort}	mp	:mp
    {unit_flags}	flags	:UBYTE
    {unit_pad}	pad	:UBYTE
    {unit_OpenCnt}	opencnt	:UINT
ENDOBJECT

NATIVE {UNITF_ACTIVE} CONST UNITF_ACTIVE = $1
NATIVE {UNITF_INTASK} CONST UNITF_INTASK = $2
