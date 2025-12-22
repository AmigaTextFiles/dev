/* $VER: devices.h 39.0 (15.10.1991) */
OPT NATIVE
MODULE 'target/exec/libraries', 'target/exec/ports'
MODULE 'target/exec/types'
{#include <exec/devices.h>}
NATIVE {EXEC_DEVICES_H} CONST

/****** Device ******************************************************/

NATIVE {Device} OBJECT dd
    {dd_Library}	lib	:lib
ENDOBJECT


/****** Unit ********************************************************/

NATIVE {Unit} OBJECT unit
    {unit_MsgPort}	mp	:mp	/* queue for unprocessed messages */
					/* instance of msgport is recommended */
    {unit_flags}	flags	:UBYTE
    {unit_pad}	pad	:UBYTE
    {unit_OpenCnt}	opencnt	:UINT		/* number of active opens */
ENDOBJECT


NATIVE {UNITF_ACTIVE}	CONST UNITF_ACTIVE	= $1
NATIVE {UNITF_INTASK}	CONST UNITF_INTASK	= $2
