/* $VER: interrupts.h 39.1 (18.9.1992) */
OPT NATIVE
MODULE 'target/exec/nodes', 'target/exec/lists'
MODULE 'target/exec/types'
{MODULE 'exec/interrupts'}

NATIVE {SF_SAR}     CONST SF_SAR  = $8000
NATIVE {SIH_QUEUES} CONST SIH_QUEUES = 5
NATIVE {SF_SINT}    CONST SF_SINT = $2000
NATIVE {SF_TQE}     CONST SF_TQE  = $4000


NATIVE {is} OBJECT is
    {ln}	ln	:ln
    {data}	data	:APTR		    /* server data segment  */
    {code}	code	:PTR /*VOID    (*is_Code)()*/	    /* server code entry    */
ENDOBJECT


NATIVE {iv} OBJECT iv		/* For EXEC use ONLY! */
    {data}	data	:APTR
    {code}	code	:PTR /*VOID    (*iv_Code)()*/
    {node}	node	:PTR TO ln
ENDOBJECT


NATIVE {sh} OBJECT sh		/* For EXEC use ONLY! */
    {lh}	lh	:lh
    {pad}	pad	:UINT
ENDOBJECT

NATIVE {SIH_PRIMASK} CONST SIH_PRIMASK = $f0

/* this is a fake INT definition, used only for AddIntServer and the like */
NATIVE {INTB_NMI}	CONST INTB_NMI	= 15
NATIVE {INTF_NMI}	CONST INTF_NMI	= $8000
