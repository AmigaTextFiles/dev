
NAME
	RandomRange -- Get a random number within a range.

SYNOPSIS
	number = RandomRange(limit)
	d0                   d0

FUNCTION
	Get a random longword between 0 and (limit-1).

INPUTS
	ULONG limit - This is number of possible values which the
		random return value is allowed to take. The return
		value is then guaranteed to be less than this limit.

RESULT
	ULONG number - A random number between 0 and (limit-1).

NOTES
	It is not necessary (nor is it possible) to seed this random
	number. This is because the Amiga is a multitasking machine,
	and if one process seeded the number, then a second process
	called Random(), then the first process called Random(), the
	first process would not get the expected result.

SEE ALSO
	Random(), RandomFromSeed()
