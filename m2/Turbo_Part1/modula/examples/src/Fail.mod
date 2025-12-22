(* @B+ turn on array bounds checking *)
MODULE Fail ;

VAR x : INTEGER ; array : ARRAY [0..9] OF INTEGER ;

BEGIN
  x := 42 ;
  array[x] := x
END Fail.
