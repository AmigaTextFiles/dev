MODULE	'intuition/intuition',
			'intuition/screens',
			'exec/libraries',
			'graphics/view'

CONST	DMODECOUNT=2,
		HIRESPICK=0,
		LOWRESPICK=1,
		EVENTMAX=10,
		RESCOUNT=2,
		HIRESGADGET=0,
		LOWRESGADGET=1,
		GADGETCOUNT=8,
		UPFRONTGADGET=0,
		DOWNBACKGADGET=1,
		SIZEGADGET=2,
		CLOSEGADGET=3,
		DRAGGADGET=4,
		SUPFRONTGADGET=5,
		SDOWNBACKGADGET=6,
		SDRAGGADGET=7

OBJECT IntuitionBase
	LibNode:Lib,
	ViewLord:View,
	ActiveWindow:PTR TO Window,
	ActiveScreen:PTR TO Screen,
	FirstScreen:PTR TO Screen,
	Flags:ULONG,
	MouseY:WORD,
	MouseX:WORD,
	Seconds:ULONG,
	Micros:ULONG
