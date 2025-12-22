/* Eratosthenes Sieve Prime Number Program in Draco */

int
    SIZE = 8190,
    ITERATIONS = 100;

proc main()void:
    [SIZE + 1] bool flags;
    register *[SIZE + 1] bool array;
    register *bool p;
    unsigned ITERATIONS iter;
    register uint k, i, count, prime;

    writeln(ITERATIONS, " iterations.");
    array := &flags;
    for iter from 1 upto ITERATIONS do
	count := 0;
	p := &array*[0];
	for i from SIZE downto 0 do
	    p* := true;
	    p := p + sizeof(bool);
	od;
	for i from 0 upto SIZE do
	    if array*[i] then
		prime := 2 * i + 3;
		for k from i + prime by prime upto SIZE do
		    array*[k] := false;
		od;
		count := count + 1;
	    fi;
	od;
    od;
    writeln(count, " primes.");
corp;
