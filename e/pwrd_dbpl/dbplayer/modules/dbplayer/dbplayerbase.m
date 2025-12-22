MODULE	'exec/libraries',
			'exec/execbase'

OBJECT DBPlayerBase
	LibNode:Library,
	SegList:PTR,
	SysBase:PTR TO ExecBase,
	AHIBase:PTR TO Library,
	playing:LONG,
	AudioModeID:ULONG,
	AudioFrequency:ULONG,
	Last7Command:ULONG
