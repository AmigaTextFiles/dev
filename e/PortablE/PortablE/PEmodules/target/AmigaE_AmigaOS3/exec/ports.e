/* $VER: ports.h 39.0 (15.10.1991) */
OPT NATIVE, INLINE
MODULE 'target/exec/nodes', 'target/exec/lists'->, 'target/exec/tasks'
MODULE 'target/exec/types'
{
MODULE 'exec/ports'
->fixed version of IsMsgPortEmpty()
#define IsMsgPortEmpty2(x) (x::mp.ln::lh.tailpred = x::mp.ln)
}
NATIVE {IsMsgPortEmpty2} PROC

NATIVE {MP_SOFTINT} CONST MP_SOFTINT = 16

->IsMsgPortEmpty() is taken from 'exec/lists' where it can't refer to the MsgPort
PROC IsMsgPortEmpty(port:PTR TO mp) IS NATIVE {IsMsgPortEmpty2(} port {)} ENDNATIVE !!BOOL


/****** MsgPort *****************************************************/

NATIVE {mp} OBJECT mp
    {ln}	ln	:ln
    {flags}	flags	:UBYTE
    {sigbit}	sigbit	:UBYTE		/* signal bit number	*/
    {sigtask}	sigtask	:PTR		/* object to be signalled */
    {msglist}	msglist	:lh	/* message linked list	*/
ENDOBJECT

/* mp_Flags: Port arrival actions (PutMsg) */
NATIVE {PF_ACTION}	CONST PF_ACTION	= 3	/* Mask */
NATIVE {PA_SIGNAL}	CONST PA_SIGNAL	= 0	/* Signal task in mp_SigTask */
NATIVE {PA_SOFTINT}	CONST PA_SOFTINT	= 1	/* Signal SoftInt in mp_SoftInt/mp_SigTask */
NATIVE {PA_IGNORE}	CONST PA_IGNORE	= 2	/* Ignore arrival */


/****** Message *****************************************************/

NATIVE {mn} OBJECT mn
    {ln}	ln	:ln
    {replyport}	replyport	:PTR TO mp  /* message reply port */
    {length}	length	:UINT		    /* total message length, in bytes */
				    /* (include the size of the Message */
				    /* structure in the length) */
ENDOBJECT
