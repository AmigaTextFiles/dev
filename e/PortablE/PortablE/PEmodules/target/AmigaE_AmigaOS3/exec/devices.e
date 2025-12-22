/* $VER: devices.h 39.0 (15.10.1991) */
OPT NATIVE
MODULE 'target/exec/libraries', 'target/exec/ports'
MODULE 'target/exec/types'
{MODULE 'exec/devices'}

/****** Device ******************************************************/

NATIVE {dd} OBJECT dd
    {lib}	lib	:lib
ENDOBJECT


/****** Unit ********************************************************/

NATIVE {unit} OBJECT unit
    {mp}	mp	:mp	/* queue for unprocessed messages */
					/* instance of msgport is recommended */
    {flags}	flags	:UBYTE
    {pad}	pad	:UBYTE
    {opencnt}	opencnt	:UINT		/* number of active opens */
ENDOBJECT


NATIVE {UNITF_ACTIVE}	CONST UNITF_ACTIVE	= $1
NATIVE {UNITF_INTASK}	CONST UNITF_INTASK	= $2
