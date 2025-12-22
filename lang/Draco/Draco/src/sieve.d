/* Eratosthenes Sieve Prime Number Program in Draco */

int
    SIZE = 8190,
    ITERATIONS = 100;

proc main()void:
    [SIZE + 1] bool flags;
    unsigned ITERATIONS iter;
    uint k, i, count, prime;

    writeln(ITERATIONS, " iterations.");
    for iter from 1 upto ITERATIONS do
	count := 0;
	for i from 0 upto SIZE do
	    flags[i] := true;
	od;
	for i from 0 upto SIZE do
	    if flags[i] then
		prime := 2 * i + 3;
		for k from i + prime by prime upto SIZE do
		    flags[k] := false;
		od;
		count := count + 1;
	    fi;
	od;
    od;
    writeln(count, " primes.");
corp;
