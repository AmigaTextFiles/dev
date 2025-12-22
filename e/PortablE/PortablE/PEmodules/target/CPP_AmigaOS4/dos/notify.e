/* $Id: notify.h,v 1.18 2005/11/10 15:32:20 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/ports', 'target/exec/tasks','target/utility/hooks'
{#include <dos/notify.h>}
NATIVE {DOS_NOTIFY_H} CONST

/* --- NotifyMessage Class ------------------------------------------------ */
NATIVE {NOTIFY_CLASS}    CONST NOTIFY_CLASS    = $40000000

/* --- NotifyMessage Codes ------------------------------------------------ */
NATIVE {NOTIFY_CODE}     CONST NOTIFY_CODE     = $1234

/* Sent to the application if SEND_MESSAGE is specified. */
NATIVE {NotifyMessage} OBJECT notifymessage
    {nm_ExecMessage}	execmessage	:mn
    {nm_Class}	class	:ULONG
    {nm_Code}	code	:UINT
    {nm_NReq}	nreq	:PTR TO notifyrequest          /* don't modify the request! */
    {nm_DoNotTouch}	donottouch	:ULONG    /* like it says! For use by handlers */
    {nm_DoNotTouch2}	donottouch2	:ULONG   /* ditto */
ENDOBJECT

/****************************************************************************/

/* Do not modify or reuse the NotifyRequest while it is active. */
NATIVE {NotifyRequest} OBJECT notifyrequest
    {nr_Name}	name	:ARRAY OF CHAR /*STRPTR*/         /* the name of object for notification */
    {nr_FullName}	fullname	:ARRAY OF CHAR /*STRPTR*/     /* PRIVATE: set by dos - don't touch */
    {nr_UserData}	userdata	:ULONG     /* for the applications use */
    {nr_Flags}	flags	:ULONG        /* notify method flags NRF_xxx  */

    {nr_stuff.nr_Signal.nr_Task}	task	:PTR TO tc       /* for SEND_SIGNAL */
    {nr_stuff.nr_Msg.nr_Port}	port	:PTR TO mp       /* for SEND_MESSAGE */

    {nr_stuff.nr_Signal.nr_SignalNum}	signalnum	:UBYTE  /* for SEND_SIGNAL */
    {nr_stuff.nr_Signal.nr_pad}	pad[3]	:ARRAY OF UBYTE     /* PRIVATE  */

    {nr_stuff.nr_CallHook.nr_Hook}	hook	:PTR TO hook       /* for CALL_HOOK */

    {nr_Reserved}	reserved[2]	:ARRAY OF ULONG        /* 2 left - leave as 0 for now */

    {nr_DosPrivate}	dosprivate	:VALUE         /* PRIVATE: DOS use only. !! -  V51.30 */

    /* internal use by handlers */
    {nr_FSPrivate}	fsprivate	:APTR          /* PRIVATE: FileSystem use only. !! - V51.30 */

    {nr_MsgCount}	msgcount	:ULONG           /* PRIVATE: # of outstanding msgs */
    {nr_Handler}	handler	:PTR TO mp            /* PRIVATE: handler sent to (for EndNotify) */

    {nr_Expansion}	expansion[4]	:ARRAY OF ULONG       /* expansion space - added V51.30 */
ENDOBJECT

/* bit numbers */
NATIVE {NRB_SEND_MESSAGE}       CONST NRB_SEND_MESSAGE       = 0
NATIVE {NRB_SEND_SIGNAL}        CONST NRB_SEND_SIGNAL        = 1
NATIVE {NRB_WAIT_REPLY}         CONST NRB_WAIT_REPLY         = 3
NATIVE {NRB_NOTIFY_INITIAL}     CONST NRB_NOTIFY_INITIAL     = 4
NATIVE {NRB_CALL_HOOK}          CONST NRB_CALL_HOOK          = 5
NATIVE {NRB_MAGIC}             CONST NRB_MAGIC             = 31

/* --- NotifyRequest Flags ------------------------------------------------ */
NATIVE {NRF_SEND_MESSAGE}      CONST NRF_SEND_MESSAGE      = $1
NATIVE {NRF_SEND_SIGNAL}       CONST NRF_SEND_SIGNAL       = $2
NATIVE {NRF_WAIT_REPLY}        CONST NRF_WAIT_REPLY        = $8
NATIVE {NRF_NOTIFY_INITIAL}    CONST NRF_NOTIFY_INITIAL    = $10
NATIVE {NRF_CALL_HOOK}         CONST NRF_CALL_HOOK         = $20

/* do NOT set or remove NRF_MAGIC!  Only for use by handlers! */
NATIVE {NRF_MAGIC}             CONST NRF_MAGIC             = $80000000

/* Flags reserved for private use by the handler: */
NATIVE {NR_HANDLER_FLAGS}      CONST NR_HANDLER_FLAGS      = $ffff0000

/* --- NotifyHook data ---------------------------------------------------- */

NATIVE {NotifyHookMsg} OBJECT notifyhookmsg
    {nhm_Size}	size	:VALUE        /* Size of data structure */
    {nhm_Action}	action	:VALUE      /* What happened (see below) */
    {nhm_Name}	name	:ARRAY OF CHAR /*STRPTR*/        /* The name of the object */
ENDOBJECT

NATIVE {NHM_ACTION_INITIAL}    CONST NHM_ACTION_INITIAL    = -1    /* Initial invocation */
NATIVE {NHM_ACTION_ADD}         CONST NHM_ACTION_ADD         = 0    /* Object was added */
NATIVE {NHM_ACTION_CHANGE}      CONST NHM_ACTION_CHANGE      = 1    /* Object has changed */
NATIVE {NHM_ACTION_DELETE}      CONST NHM_ACTION_DELETE      = 2    /* Object was removed */
