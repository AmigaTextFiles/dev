;
; **
; ** $VER: notify.h 36.8 (29.8.90)
; ** Includes Release 40.15
; **
; ** dos notification definitions
; **
; ** (C) Copyright 1989-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
; **
;
; 27/03/1999
;   Fixed the union stuff

IncludePath   "PureInclude:"
XIncludeFile "exec/types.pb"
XIncludeFile "exec/ports.pb"
XIncludeFile "exec/tasks.pb"

;  use of Class and code is discouraged for the time being - we might want to
;    change things
;  --- NotifyMessage Class ------------------------------------------------
#NOTIFY_CLASS = $40000000

;  --- NotifyMessage Codes ------------------------------------------------
#NOTIFY_CODE = $1234


;  Sent to the application if SEND_MESSAGE is specified.

Structure NotifyMessage
    nm_ExecMessage.Message
    nm_Class.l
    nm_Code.w
    *nm_NReq.NotifyRequest ;  don't modify the request!
    nm_DoNotTouch.l  ;  like it says!  For use by handlers
    nm_DoNotTouch2.l  ;  ditto
EndStructure

;  Do not modify or reuse the notifyrequest while active.
;  note: the first LONG of nr_Data has the length transfered

Structure NotifyRequest
 *nr_Name.b
 *nr_FullName.b  ;  set by dos - don't touch
 nr_UserData.l  ;  for applications use
 nr_Flags.l

 ; Was UNION here
 *nr_Port.MsgPort[0] ;  for SEND_MESSAGE
 *nr_Task.Task       ;  for SEND_SIGNAL
 nr_SignalNum.b      ;  for SEND_SIGNAL
 nr_pad.b[3]

 nr_Reserved.l[4]    ;  leave 0 for now

 ;  internal use by handlers
 nr_MsgCount.l       ;  # of outstanding msgs
 *nr_Handler.MsgPort ;  handler sent to (for EndNotify)

EndStructure

;  --- NotifyRequest Flags ------------------------------------------------
#NRF_SEND_MESSAGE = 1
#NRF_SEND_SIGNAL  = 2
#NRF_WAIT_REPLY  = 8
#NRF_NOTIFY_INITIAL = 16

;  do NOT set or remove NRF_MAGIC!  Only for use by handlers!
#NRF_MAGIC = $80000000

;  bit numbers
#NRB_SEND_MESSAGE = 0
#NRB_SEND_SIGNAL  = 1
#NRB_WAIT_REPLY  = 3
#NRB_NOTIFY_INITIAL = 4

#NRB_MAGIC  = 31

;  Flags reserved for private use by the handler:
#NR_HANDLER_FLAGS = $ffff0000

