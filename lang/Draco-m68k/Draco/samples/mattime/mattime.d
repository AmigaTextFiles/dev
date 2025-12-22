/* BEWARE, space required is SIZE * SIZE * 2 * sizeof(TYPE) bytes!!! */

int SIZE = 125;
type TYPE = uint;

/* declare arrays as global, since they likely won't fit on the stack */

[SIZE, SIZE] TYPE a, b;

proc matrixMultiply([*, *] TYPE x; [*, *] TYPE y; [*, *] TYPE z)void:
    TYPE i, j, k, sum;

    for i from 0 upto dim(z, 1) - 1 do
	for j from 0 upto dim(z, 2) - 1 do
	    sum := 0;
	    for k from 0 upto dim(x, 2) - 1 do
		sum := sum + x[i, k] * y[k, j];
	    od;
	    z[i, j] := sum;
	od;
    od;
corp;

proc main()void:
    TYPE i, j;

    writeln("Size of matrixes: ", SIZE, " x ", SIZE);
    for i from 0 upto SIZE - 1 do
	for j from 0 upto SIZE - 1 do
	    a[i, j] := i + j;
	od;
    od;
    writeln("Starting square:");
    matrixMultiply(a, a, b);
    writeln("Squaring done. Diagonal of squared matrix is:");
    for i from 0 upto SIZE - 1 do
	write(b[i, i], ' ');
    od;
    writeln();
corp;
