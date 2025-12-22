/* $Id: notify.h,v 1.11 2005/11/10 15:39:41 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/ports', 'target/devices/timer'
MODULE 'target/utility/tagitem'
{#include <intuition/notify.h>}
NATIVE {INTUITION_NOTIFY_H} CONST

NATIVE {SNA_PubName}  CONST SNA_PUBNAME  = (TAG_USER + $01) /* public screen to watch,
                                          NULL for all screens */
NATIVE {SNA_Notify}   CONST SNA_NOTIFY   = (TAG_USER + $02) /* see below */
NATIVE {SNA_UserData} CONST SNA_USERDATA = (TAG_USER + $03) /* for your use */
NATIVE {SNA_SigTask}  CONST SNA_SIGTASK  = (TAG_USER + $04) /* task to signal */
NATIVE {SNA_SigBit}   CONST SNA_SIGBIT   = (TAG_USER + $05) /* signal bit */
NATIVE {SNA_MsgPort}  CONST SNA_MSGPORT  = (TAG_USER + $06) /* send message to this port */
NATIVE {SNA_Priority} CONST SNA_PRIORITY = (TAG_USER + $07) /* priority of your request */
NATIVE {SNA_Hook}     CONST SNA_HOOK     = (TAG_USER + $08)

/* SNA_Notify (all unassigned bits are reserved for system use) */
NATIVE {SNOTIFY_AFTER_OPENSCREEN}   CONST SNOTIFY_AFTER_OPENSCREEN   = $1  /* screen has been opened */
NATIVE {SNOTIFY_BEFORE_CLOSESCREEN} CONST SNOTIFY_BEFORE_CLOSESCREEN = $2  /* going to close screen */
NATIVE {SNOTIFY_AFTER_OPENWB}       CONST SNOTIFY_AFTER_OPENWB       = $4  /* Workbench is open */
NATIVE {SNOTIFY_BEFORE_CLOSEWB}     CONST SNOTIFY_BEFORE_CLOSEWB     = $8  /* Workbench is going to be closed*/
NATIVE {SNOTIFY_AFTER_OPENWINDOW}   CONST SNOTIFY_AFTER_OPENWINDOW   = $10  /* new window */
NATIVE {SNOTIFY_BEFORE_CLOSEWINDOW} CONST SNOTIFY_BEFORE_CLOSEWINDOW = $20  /* window is going to be closed */
NATIVE {SNOTIFY_PUBSCREENSTATE}     CONST SNOTIFY_PUBSCREENSTATE     = $40  /* PubScreenState() */
NATIVE {SNOTIFY_LOCKPUBSCREEN}      CONST SNOTIFY_LOCKPUBSCREEN      = $80  /* LockPubScreen() */
NATIVE {SNOTIFY_SCREENDEPTH}        CONST SNOTIFY_SCREENDEPTH        = $100  /* ScreenDepth() */
NATIVE {SNOTIFY_AFTER_CLOSESCREEN}  CONST SNOTIFY_AFTER_CLOSESCREEN  = $200  /* notify after CloseScreen() */
NATIVE {SNOTIFY_AFTER_CLOSEWINDOW}  CONST SNOTIFY_AFTER_CLOSEWINDOW  = $400 /* dto. CloseWindow() */
NATIVE {SNOTIFY_BEFORE_OPENSCREEN}  CONST SNOTIFY_BEFORE_OPENSCREEN  = $800 /* notify before OpenScreen() */
NATIVE {SNOTIFY_BEFORE_OPENWINDOW}  CONST SNOTIFY_BEFORE_OPENWINDOW  = $1000 /* dto. OpenWindow() */
NATIVE {SNOTIFY_BEFORE_OPENWB}      CONST SNOTIFY_BEFORE_OPENWB      = $2000 /* like OPENSCREEN */
NATIVE {SNOTIFY_AFTER_CLOSEWB}      CONST SNOTIFY_AFTER_CLOSEWB      = $4000 /* like CLOSESCREEN */
NATIVE {SNOTIFY_WAIT_REPLY}         CONST SNOTIFY_WAIT_REPLY         = $8000 /* wait for reply before
                                            * taking action
                                            */
NATIVE {SNOTIFY_UNLOCKPUBSCREEN}    CONST SNOTIFY_UNLOCKPUBSCREEN    = $10000 /* UnlockPubScreen() */

NATIVE {ScreenNotifyMessage} OBJECT screennotifymessage
    {snm_Message}	message	:mn     /* embedded message */
    {snm_Class}	class	:ULONG       /* see above */
    {snm_Code}	code	:ULONG
    {snm_Object}	object	:APTR      /* either a pointer to struct Window
                                     * or struct Screen (READ-ONLY).
                                     * For SNRF_#?PUBSCREEN this the
                                     * name of the public screen
                                     */
    {snm_UserData}	userdata	:APTR    /* SNA_UserData */
    {snm_Request}	request	:APTR     /* pointer returned by
                                     * StartScreenNotify()
                                     */
    {snm_Reserved}	reserved[5]	:ARRAY OF ULONG /* don't touch! */
ENDOBJECT
