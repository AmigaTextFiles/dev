MODULE	'exec/libraries',
			'exec/ports'

OBJECT Device|DD
	Library|Lib:Lib

OBJECT Unit
	MsgPort|MP:MP,
	Flags:UBYTE,
	Pad:UBYTE,
	OpenCnt:UWORD

SET	UNITF_ACTIVE,
		UNITF_INTASK
