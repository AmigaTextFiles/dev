MODULE	'utility/hooks'

CONST	ED_NAME=1,
		ED_TYPE=2,
		ED_SIZE=3,
		ED_PROTECTION=4,
		ED_DATE=5,
		ED_COMMENT=6,
		ED_OWNER=7

OBJECT ExAllData
	Next:PTR TO ExAllData,
	Name:PTR TO UBYTE,
	Type:LONG,
	Size:ULONG,
	Prot:ULONG,
	Days:ULONG,
	Mins:ULONG,
	Ticks:ULONG,
	Comment:PTR TO UBYTE,
	OwnerUID:UWORD,
	OwnerGID:UWORD

OBJECT ExAllControl
	Entries:ULONG,
	LastKey:ULONG,
	MatchString:PTR TO UBYTE,
	MatchFunc:PTR TO Hook
