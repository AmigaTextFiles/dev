
NAME
	Random -- Get a random number

SYNOPSIS
	number = Random()
	d0

FUNCTION
	Get a random longword between $00000000 and $FFFFFFFF.

INPUTS
	None

RESULT
	ULONG number - A random number.

NOTES
	It is not necessary (nor is it possible) to seed this random
	number. This is because the Amiga is a multitasking machine,
	and if one process seeded the number, then a second process
	called Random(), then the first process called Random(), the
	first process would not get the expected result.

SEE ALSO
	RandomFromSeed(), RandomRange()
