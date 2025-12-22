(*   For those of us who dont belive in our own luck,			      *)
(*   this program generates six unique random numbers between 1..49 for the   *)
(*   british national lottery coupons.					      *)

MODULE Lottery ;

IMPORT
  RN := RandomNumbers, InOut, Intuition ;

VAR
  x , y : [0..05] ;
  rnd   : [0..49] ;
  list  : ARRAY [0..5] OF INTEGER ;
  again : BOOLEAN ;

BEGIN
  list := [0,0,0,0,0,0] ;
  RN.SetSeed( Intuition.IntuitionBase^.Micros ) ;
  FOR x := 0 TO 5 DO
    LOOP
      again := FALSE ;
      rnd := TRUNC( RN.Uniform()*50.0 ) ;
      FOR y := 0 TO 5 DO
        (* Check for duplicates. 0's already in list so wont get chosen *)
        IF list[y] = rnd THEN again := TRUE END
      END ;
      IF ~again THEN EXIT END
    END ;
    list[x] := rnd ;
    InOut.WriteInt( rnd, 4 )
  END
END Lottery.
