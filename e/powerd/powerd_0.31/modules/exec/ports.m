MODULE 'exec/lists',
       'exec/nodes'

OBJECT MsgPort|MP
	Node|LN:LN,
	Flags:UBYTE,
	SigBit:UBYTE,
	SigTask:LONG,
	MsgList:LH

#define mp_SoftInt mp_SigTask	/* Alias */

CONST	MP_SOFTINT=16,
		PF_ACTION=3,
		PA_SIGNAL=0,
		PA_SOFTINT=1,
		PA_IGNORE=2

OBJECT Message|MN
	Node|LN:LN,
	ReplyPort:PTR TO MP,
	Length:UWORD
