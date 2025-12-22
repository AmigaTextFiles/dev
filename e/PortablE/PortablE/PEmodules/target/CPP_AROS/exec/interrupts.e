/* $Id: interrupts.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE
MODULE 'target/exec/lists', 'target/exec/nodes'
MODULE 'target/exec/types'
{#include <exec/interrupts.h>}
NATIVE {EXEC_INTERRUPTS_H} CONST

CONST SF_SAR  = $8000
CONST SIH_QUEUES = 5
CONST SF_SINT = $2000
CONST SF_TQE  = $4000

NATIVE {Interrupt} OBJECT is
    {is_Node}	ln	:ln
    {is_Data}	data	:APTR
    {is_Code}	code	:NATIVE {VOID     (*)()} PTR /* server code entry */
ENDOBJECT

/* PRIVATE */
NATIVE {IntVector} OBJECT iv
    {iv_Data}	data	:APTR
    {iv_Code}	code	:NATIVE {VOID       (*)()} PTR
    {iv_Node}	node	:PTR TO ln
ENDOBJECT

/* PRIVATE */
NATIVE {SoftIntList} OBJECT sh
    {sh_List}	lh	:lh
    {sh_Pad}	pad	:UINT
ENDOBJECT

NATIVE {SIH_PRIMASK} CONST SIH_PRIMASK = ($f0)

NATIVE {INTB_NMI}      CONST INTB_NMI      = 15
NATIVE {INTF_NMI} CONST INTF_NMI = $8000
