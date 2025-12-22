MODULE	'exec/lists',
			'exec/nodes'

OBJECT Interrupt|IS
	Node|LN:LN,
	Data:APTR,
	Code:LONG

OBJECT IntVector|IV
	Data:APTR,
	Code:LONG,
	Node:PTR TO LN

CONST	SF_SAR=$8000,
		SF_TQE=$4000,
		SF_SINT=$2000

OBJECT SoftIntList|SH
	List|LH:LH,
	Pad:UWORD

CONST	SIH_PRIMASK=$F0,
		SIH_QUEUES=5,
		INTB_NMI=15,
		INTF_NMI=$8000
