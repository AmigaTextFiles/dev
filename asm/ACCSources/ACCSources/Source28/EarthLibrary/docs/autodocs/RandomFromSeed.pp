
NAME
	RandomFromSeed -- Get a random number given a seed value

SYNOPSIS
	number = RandomFromSeed(seed)
	d0                      d0

FUNCTION
	Get a random longword between $00000000 and $FFFFFFFF.

INPUTS
	ULONG seed - The value with which to seed the random number
		generator. Usually you would use the return value from
		a previous call to RandomFromSeed() as the seed for the
		next call. (Use any constant you like for the first
		call). This will result in an identical sequence of
		random numbers each time you run your application.

RESULT
	ULONG number - A random number.

NOTES

SEE ALSO
	Random(), RandomRange()
