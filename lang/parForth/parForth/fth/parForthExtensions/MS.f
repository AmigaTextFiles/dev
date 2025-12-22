include? parForthExt.f parForthExt.f		\ using parForth instead of pForth

\ ndh 1/29/23 rewrote for reuseability with Timers
\ end of changes from parForth 0.1 to parForth 0.2

ANEW MS.f

\ ANS Forth millisecond wait function
:STRUCT _Node				\ Exec/Nodes
	APTR	ln_Succ
	APTR 	ln_Pred
	APTR 	ln_Name			\ "special handling" in AROS nodes.h
	UBYTE 	ln_Type			\ mazze said it will be fixed in AROS v1 API todo
	BYTE 	ln_Pri
	SHORT	ln_ndh_pad		\ goofiness afoot
;STRUCT

:STRUCT Message				\ Exec/Ports
	STRUCT	_Node mn_Node
	APTR	mn_ReplyPort
	USHORT 	mn_Length
;STRUCT

:STRUCT IOStdReq			\ exec/io
	STRUCT 	Message io_Message
	APTR 	io_Device
	APTR 	io_Unit
	USHORT 	io_Command
	UBYTE 	io_Flags
	BYTE 	io_Error
	ULONG 	io_Actual		\ also used to send seconds for timer requests
	ULONG 	io_Length		\ also used to send micros for timer requests
	APTR 	io_Data
	ULONG 	io_Offset
;STRUCT
0 CONSTANT UNIT_MICROHZ	\ devices/timer
1 CONSTANT UNIT_VBLANK
9 CONSTANT TR_ADDREQUEST

: _CreateMsgPort   ( -- mp|0 )              111 EXEC_SYSBASE CALL0 ;		\ 0=failure
: _DeleteMsgPort   ( mp -- )                112 EXEC_SYSBASE CALL1NR ;		\ port=0 is OK
: _WaitPort        ( mp -- msg )             64 EXEC_SYSBASE CALL1 ;		\ first msg received by port
: _GetMsg          ( mp -- msg )			 62 EXEC_SYSBASE CALL1 ;
: _OpenDevice	   ( 0$ unit io flags -- f ) 74 EXEC_SYSBASE CALL4 ;		\ 0=success
: _CloseDevice	   ( io -- )                 75 EXEC_SYSBASE CALL1NR ;
: _SendIO		   ( io -- )                 77 EXEC_SYSBASE CALL1NR ;
: _CreateIORequest ( mp size -- io|0 )      109 EXEC_SYSBASE CALL2 ;		\ 0=failure
: _DeleteIORequest ( io -- )                110 EXEC_SYSBASE CALL1NR ;

: CreateMsgPort      ( -- mp ) _CreateMsgPort DUP 0= ABORT" Can't create port" ;
: CreateIOStdRequest ( mp -- io ) DUP IOStdReq _CreateIORequest
	?DUP IF NIP ELSE _DeleteMsgPort TRUE ABORT" Can't create IO" THEN ;
: PrepareIO          ( -- io ) CreateMsgPort CreateIOStdRequest ;

: OpenTimer  ( unit -- io ) PrepareIO >R 0" timer.device" SWAP R@ 0 _OpenDevice ABORT" Can't open timer.device" R> ;
: WaitTimer  ( secs micros io -- ) >R R@ S! io_Actual R@ S! io_Length TR_ADDREQUEST R@ S! io_Command R@ _SendIO
	R@ S@ mn_ReplyPort _WaitPort DROP R> S@ mn_ReplyPort _GetMsg DROP ;
: CloseTimer ( io -- ) DUP S@ mn_ReplyPort OVER _CloseDevice SWAP _DeleteIORequest _DeleteMsgPort ;
: MS         ( millis -- ) 1000 /MOD UNIT_MICROHZ OpenTimer >R R@ WaitTimer R> CloseTimer ;

