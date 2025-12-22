/* $VER: notify.h 36.8 (29.8.1990) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/ports', 'target/exec/tasks'
{MODULE 'dos/notify'}

/* --- NotifyMessage Class ------------------------------------------------ */
NATIVE {NOTIFY_CLASS}	CONST NOTIFY_CLASS	= $40000000

/* --- NotifyMessage Codes ------------------------------------------------ */
NATIVE {NOTIFY_CODE}	CONST NOTIFY_CODE	= $1234


/* Sent to the application if SEND_MESSAGE is specified.		    */

NATIVE {notifymessage} OBJECT notifymessage
    {execmessage}	execmessage	:mn
    {class}	class	:ULONG
    {code}	code	:UINT
    {nreq}	nreq	:PTR TO notifyrequest	/* don't modify the request! */
    {donottouch}	donottouch	:ULONG		/* like it says!  For use by handlers */
    {donottouch2}	donottouch2	:ULONG		/* ditto */
ENDOBJECT

NATIVE {notifyrequest} OBJECT notifyrequest
	{name}	name	:ARRAY OF UBYTE
	{fullname}	fullname	:ARRAY OF UBYTE		/* set by dos - don't touch */
	{userdata}	userdata	:ULONG		/* for applications use */
	{flags}	flags	:ULONG

	{task}		task	:PTR TO tc		/* for SEND_SIGNAL */
	{port}	port	:PTR TO mp	/* for SEND_MESSAGE */

	{signalnum}	signalnum	:UBYTE		/* for SEND_SIGNAL */
->	{pad}			pad[3]	:ARRAY OF UBYTE

	{reserved}	reserved[4]	:ARRAY OF ULONG		/* leave 0 for now */

	/* internal use by handlers */
	{msgcount}	msgcount	:ULONG		/* # of outstanding msgs */
	{handler}	handler		:PTR TO mp	/* handler sent to (for EndNotify) */
ENDOBJECT

/* --- NotifyRequest Flags ------------------------------------------------ */
NATIVE {NRF_SEND_MESSAGE}	CONST NRF_SEND_MESSAGE	= 1
NATIVE {NRF_SEND_SIGNAL}		CONST NRF_SEND_SIGNAL		= 2
NATIVE {NRF_WAIT_REPLY}		CONST NRF_WAIT_REPLY		= 8
NATIVE {NRF_NOTIFY_INITIAL}	CONST NRF_NOTIFY_INITIAL	= 16

/* do NOT set or remove NRF_MAGIC!  Only for use by handlers! */
NATIVE {NRF_MAGIC}	CONST NRF_MAGIC	= $80000000

/* bit numbers */
NATIVE {NRB_SEND_MESSAGE}	CONST NRB_SEND_MESSAGE	= 0
NATIVE {NRB_SEND_SIGNAL}		CONST NRB_SEND_SIGNAL		= 1
NATIVE {NRB_WAIT_REPLY}		CONST NRB_WAIT_REPLY		= 3
NATIVE {NRB_NOTIFY_INITIAL}	CONST NRB_NOTIFY_INITIAL	= 4

NATIVE {NRB_MAGIC}		CONST NRB_MAGIC		= 31

/* Flags reserved for private use by the handler: */
NATIVE {NR_HANDLER_FLAGS}	CONST NR_HANDLER_FLAGS	= $ffff0000
