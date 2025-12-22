
NAME
	Unique -- Get a unique number

SYNOPSIS
	number = Unique()
	d0

FUNCTION
	The first time this function is called, the return value will
	be one. The second time this function is called, the return
	value will be two, and so on.

	If multiple tasks call this function simultaneously then each
	will be given a different and unique number. This allows you to
	create uniquely named files, etc.

INPUTS
	None

RESULT
	ULONG number - A unique number.

NOTES
	Note that this number will be unique even if the library is
	closed, expunged, and subsequently re-opened. This is because
	the counter is stored in an environment variable. The number
	will therefore be unique until the next time the machine is
	reset.


SEE ALSO
