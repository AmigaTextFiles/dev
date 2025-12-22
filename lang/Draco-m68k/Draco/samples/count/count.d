/*
 * count to 1,000,000.
 * on the 8080 this was a triple loop of ushorts counting to 100.
 * On the 68000 a double loop of uints counting to 1000 should be fastest.
 * On a 68020, a single loop counting to 1000000 should be best.
 */

proc main()void:
    uint i, j;

    write("Press RETURN to start: ");
    readln();
    for i from 1 upto 1000 do
	for j from 1 upto 1000 do
	od;
    od;
    writeln("Done");
corp;
