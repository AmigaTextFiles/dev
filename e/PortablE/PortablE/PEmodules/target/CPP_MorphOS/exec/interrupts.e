/* $VER: interrupts.h 39.1 (18.9.1992) */
OPT NATIVE
MODULE 'target/exec/nodes', 'target/exec/lists'
MODULE 'target/exec/types'
{#include <exec/interrupts.h>}
NATIVE {EXEC_INTERRUPTS_H} CONST

CONST SF_SAR  = $8000
CONST SIH_QUEUES = 5
CONST SF_SINT = $2000
CONST SF_TQE  = $4000

NATIVE {Interrupt} OBJECT is
    {is_Node}	ln	:ln
    {is_Data}	data	:APTR		    /* server data segment  */
    {is_Code}	code	:NATIVE {VOID    (*)()} PTR	    /* server code entry    */
ENDOBJECT


NATIVE {IntVector} OBJECT iv		/* For EXEC use ONLY! */
    {iv_Data}	data	:APTR
    {iv_Code}	code	:NATIVE {VOID    (*)()} PTR
    {iv_Node}	node	:PTR TO ln
ENDOBJECT


NATIVE {SoftIntList} OBJECT sh		/* For EXEC use ONLY! */
    {sh_List}	lh	:lh
    {sh_Pad}	pad	:UINT
ENDOBJECT

NATIVE {SIH_PRIMASK} CONST SIH_PRIMASK = $f0

/* this is a fake INT definition, used only for AddIntServer and the like */
NATIVE {INTB_NMI}	CONST INTB_NMI	= 15
NATIVE {INTF_NMI}	CONST INTF_NMI	= $8000
