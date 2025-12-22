; :ts=8

;
; C Language Interface Routines For Low-Memory Server Library
;
; Copyright 1987 By ASDG Incorporated
;
; For non-commercial distribution only. Commercial distribution
; or use is strictly  forbidden except under license from ASDG.
; 
; Author: Perry S. Kivolowitz
; 
; ASDG shall in no way be held responsible for any damage or loss
; of data which may result from the use or misuse of this program
; or data. ASDG makes no warranty with respect to the correct and
; proper functioning of this code or data. However, it is the be-
; lief of ASDG that this  program and  data is  correct and shall
; function properly with correct use.
;
; These modules were written for  use  with  Manx C.  Manx C is a
; product  of  the  Manx  Software Systems company whose language
; tools are used  exclusively by  ASDG  for all its software pro-
; ducts. Yes - this is an unsolicited plug for Manx - Perry K.
;
	dseg
;
; you must provide  a LowMemBase  in your  C programs similar in
; concept to ExecBase or IntuitionBase etc.
;

	public	_LowMemBase

;
; RegLowMemReq
;
; Register a message port with the low-memory notification service. From
; C this routine would be called as in:
;
;	res = RegLowMemReq(PortName , Space)
;			      A0        A1
;	where:
;
;	PortName is  a pointer  to a null terminated string representing 
;		 the name  of  your port to which the low-memory service
;		 will attempt to send a message.
;	Space	 is a pointer to an initialized LowMemMessage.
;
;	res	 if false means  your  registration has  been  accepted.
;		 Currently, the only  reason  your  request would be re-
;		 jected is  if  the  low-memory server itself ran out of 
;		 memory (oh my!) or the port name  you requested has al-
;		 ready been registered. The value of the returned  error
;		 code can be used to determine why the call failed.
;

	cseg
	public	_RegLowMemReq

_RegLowMemReq
	move.l	4(sp),a0	; load PortName into a0
	move.l	8(sp),a1	; load Space into a1
	move.l	_LowMemBase,a6	; load library pointer
	jmp	-30(a6)		; actually make call

;
; DeRegLowMemReq
;
; Undo the effect of a previous RegLowMemReq. You absolutely positively
; must call this routine before  exiting  your program (or  closing the
; library) 
;
;	
	public	_DeRegLowMemReq

_DeRegLowMemReq
	move.l	4(sp),a0	; load PortName into a0
	move.l	_LowMemBase,a6	; load library pointer
	jmp	-36(a6)		; actually make call

