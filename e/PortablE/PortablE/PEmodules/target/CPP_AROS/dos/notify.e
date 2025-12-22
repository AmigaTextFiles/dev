/* $Id: notify.h 21273 2004-03-18 07:25:48Z chodorowski $ */
OPT NATIVE
MODULE 'target/exec/ports', 'target/exec/tasks', 'target/exec/types'
MODULE 'target/exec/devices'
{#include <dos/notify.h>}
NATIVE {DOS_NOTIFY_H} CONST

NATIVE {NotifyRequest} OBJECT notifyrequest
    {nr_Name}	name	:/*STRPTR*/ ARRAY OF CHAR     /* Name of the watched file. */
    {nr_FullName}	fullname	:/*STRPTR*/ ARRAY OF CHAR /* Fully qualified name of the watched file. This is
                            READ-ONLY! */
    {nr_UserData}	userdata	:IPTR /* Fill in with your own data. */
    {nr_Flags}	flags	:ULONG    /* see below */

    {nr_stuff.nr_Signal.nr_Task}	task	:PTR TO tc      /* Task to notify. */
    {nr_stuff.nr_Msg.nr_Port}	port	:PTR TO mp /* Port to send message to. */
    {nr_stuff.nr_Signal.nr_SignalNum}	signalnum	:UBYTE /* Signal number to set. */
    {nr_stuff.nr_Signal.nr_pad}	pad[3]	:ARRAY OF UBYTE    /* PRIVATE */

    {nr_Reserved}	reserved[4]	:ARRAY OF ULONG /* PRIVATE! Set to 0 for now. */

    /* The following fields are for PRIVATE use by handlers. */
    {nr_MsgCount}	msgcount	:ULONG /* Number of unreplied messages. */

    {nr_Device}	device	:PTR TO dd
ENDOBJECT

/* nr_Flags */
NATIVE {NRB_SEND_MESSAGE}  CONST NRB_SEND_MESSAGE  = 0 /* Send a message to the specified message port. */
NATIVE {NRB_SEND_SIGNAL}   CONST NRB_SEND_SIGNAL   = 1 /* Set a signal of the specified task. */
NATIVE {NRB_WAIT_REPLY}    CONST NRB_WAIT_REPLY    = 3 /* Wait for a reply by the application before
                               going on with watching? */
NATIVE {NRB_NOTIFY_INITIAL} CONST NRB_NOTIFY_INITIAL = 4 /* Notify if the file/directory exists when
                                the notification request is posted */

NATIVE {NRF_SEND_MESSAGE}   CONST NRF_SEND_MESSAGE   = $1
NATIVE {NRF_SEND_SIGNAL}    CONST NRF_SEND_SIGNAL    = $2
NATIVE {NRF_WAIT_REPLY}     CONST NRF_WAIT_REPLY     = $8
NATIVE {NRF_NOTIFY_INITIAL} CONST NRF_NOTIFY_INITIAL = $10

/* The following flags are for use by handlers only! */
NATIVE {NR_HANDLER_FLAGS} CONST NR_HANDLER_FLAGS = $ffff0000
NATIVE {NRB_MAGIC}               CONST NRB_MAGIC               = 31
NATIVE {NRF_MAGIC}          CONST NRF_MAGIC          = $80000000


NATIVE {NotifyMessage} OBJECT notifymessage
      /* Embedded message structure as defined in <exec/ports.h>. */
    {nm_ExecMessage}	execmessage	:mn

    {nm_Class}	class	:ULONG /* see below */
    {nm_Code}	code	:UINT  /* see below */
      /* The notify structure that was passed to StartNotify(). */
    {nm_NReq}	nreq	:PTR TO notifyrequest

    /* The following two fields are for PRIVATE use by handlers. */
    {nm_DoNotTouch}	donottouch	:IPTR
    {nm_DoNotTouch2}	donottouch2	:IPTR
ENDOBJECT

/* nm_Class. Do not use, yet. */
NATIVE {NOTIFY_CLASS} CONST NOTIFY_CLASS = $40000000

/* nm_Code. Do not use, yet. */
NATIVE {NOTIFY_CODE}  CONST NOTIFY_CODE  = $1234
