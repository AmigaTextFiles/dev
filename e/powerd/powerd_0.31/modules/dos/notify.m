MODULE	'exec/ports',
			'exec/tasks'

CONST	NOTIFY_CLASS=$40000000,
		NOTIFY_CODE=$1234

OBJECT NotifyMessage
	ExecMessage:MN,
	Class:ULONG,
	Code:UWORD,
	NReq:PTR TO NotifyRequest,
	DoNotTouch:ULONG,
	DoNotTouch2:ULONG

OBJECT NotifyRequest
	Name:PTR TO UBYTE,
	FullName:PTR TO UBYTE,
	UserData:ULONG,
	Flags:ULONG,
-> a) next LONG is unioned with "task:PTR TO tc"
	Port|Task:PTR TO MP,
	SignalNum:UBYTE,
	pada:UBYTE,
	padb[2]:UBYTE,
	reserved[4]:ULONG,
	Msgcount:ULONG,
	Handler:PTR TO MP

CONST	NRF_SEND_MESSAGE=1,
		NRF_SEND_SIGNAL=2,
		NRF_WAIT_REPLY=8,
		NRF_NOTIFY_INITIAL=16,
		NRF_MAGIC=$80000000,
		NRB_SEND_MESSAGE=0,
		NRB_SEND_SIGNAL=1,
		NRB_WAIT_REPLY=3,
		NRB_NOTIFY_INITIAL=4,
		NRB_MAGIC=31,
		NR_HANDLER_FLAGS=$FFFF0000
