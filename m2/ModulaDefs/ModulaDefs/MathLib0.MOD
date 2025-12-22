(***************************************
 * Name: MathLib0.MOD                  *
 * Author: JSG                         *
 * Purpose: Math Functions             *
 ***************************************)

IMPLEMENTATION MODULE MathLib0;

CONST PI    = 3.1415;
      TWOPI = 6.2831;

PROCEDURE SQRT(x: REAL): REAL;

VAR lb,ub,mid : REAL;
    temp : REAL;

BEGIN
  IF (x<0.0) THEN
    RETURN -1.0;
  ELSE
    lb := 0.0;
    ub := x;
    mid := (lb+ub)/2.0;
    temp := ABS(mid*mid-x);
    WHILE (temp>0.0001) DO
       IF mid*mid>x THEN ub := mid;
       ELSE lb := mid; END;
       mid := (lb+ub)/2.0;
       temp := ABS(mid*mid-x);
   END; (* WHILE *)

   RETURN mid;

  END; (* IF x>=0 *)

END SQRT;




PROCEDURE SIN(x:REAL;VAR neg:BOOLEAN) : REAL;

VAR Deg,D2    : INTEGER;
    sinx,temp : REAL;

BEGIN
   WHILE x<0.0 DO
     x := x + TWOPI;
   END;
   temp := 57.2958*x;
     
   Deg := TRUNC(temp);
   Deg := Deg MOD 360;

   CASE Deg OF

       0..89  : D2 := Deg;
                neg := FALSE;

   | 90..179  : D2 := 180 - Deg;
                neg := FALSE;

   | 180..269 : D2 := Deg - 180;
                neg := TRUE;

   | 270..359 : D2 := 360 - Deg;
                neg := TRUE;

   END; (* CASE *)

   CASE D2 OF

     0 : sinx := 0.0000; |
     1 : sinx := 0.0175; |
     2 : sinx := 0.0349; |
     3 : sinx := 0.0523; |
     4 : sinx := 0.0698; |
     5 : sinx := 0.0872; |
     6 : sinx := 0.1045; |
     7 : sinx := 0.1219; |
     8 : sinx := 0.1392; |
     9 : sinx := 0.1564; |
    10 : sinx := 0.1736; |
    11 : sinx := 0.1908; |
    12 : sinx := 0.2079; |
    13 : sinx := 0.2250; |
    14 : sinx := 0.2419; |
    15 : sinx := 0.2588; |
    16 : sinx := 0.2756; |
    17 : sinx := 0.2924; |
    18 : sinx := 0.3090; |
    19 : sinx := 0.3256; |
    20 : sinx := 0.3420; |
    21 : sinx := 0.3584; |
    22 : sinx := 0.3746; |
    23 : sinx := 0.3907; |
    24 : sinx := 0.4067; |
    25 : sinx := 0.4226; |
    26 : sinx := 0.4384; |
    27 : sinx := 0.4540; |
    28 : sinx := 0.4695; |
    29 : sinx := 0.4848; |
    30 : sinx := 0.5000; |
    31 : sinx := 0.5150; |
    32 : sinx := 0.5299; |
    33 : sinx := 0.5446; |
    34 : sinx := 0.5592; |
    35 : sinx := 0.5736; |
    36 : sinx := 0.5878; |
    37 : sinx := 0.6018; |
    38 : sinx := 0.6157; |
    39 : sinx := 0.6293; |
    40 : sinx := 0.6428; |
    41 : sinx := 0.6561; |
    42 : sinx := 0.6691; |
    43 : sinx := 0.6420; |
    44 : sinx := 0.6947; |
    45 : sinx := 0.7071; |
    46 : sinx := 0.7193; |
    47 : sinx := 0.7314; |
    48 : sinx := 0.7431; |
    49 : sinx := 0.7547; |
    50 : sinx := 0.7660; |
    51 : sinx := 0.7771; |
    52 : sinx := 0.7880; |
    53 : sinx := 0.7986; |
    54 : sinx := 0.8090; |
    55 : sinx := 0.8192; |
    56 : sinx := 0.8290; |
    57 : sinx := 0.8387; |
    58 : sinx := 0.8480; |
    59 : sinx := 0.8572; |
    60 : sinx := 0.8660; |
    61 : sinx := 0.8746; |
    62 : sinx := 0.8829; |
    63 : sinx := 0.8910; |
    64 : sinx := 0.8988; |
    65 : sinx := 0.9063; |
    66 : sinx := 0.9135; |
    67 : sinx := 0.9205; |
    68 : sinx := 0.9272; |
    69 : sinx := 0.9336; |
    70 : sinx := 0.9397; |
    71 : sinx := 0.9455; |
    72 : sinx := 0.9511; |
    73 : sinx := 0.9563; |
    74 : sinx := 0.9613; |
    75 : sinx := 0.9659; |
    76 : sinx := 0.9703; |
    77 : sinx := 0.9744; |
    78 : sinx := 0.9781; |
    79 : sinx := 0.9816; |
    80 : sinx := 0.9848; |
    81 : sinx := 0.9877; |
    82 : sinx := 0.9903; |
    83 : sinx := 0.9925; |
    84 : sinx := 0.9945; |
    85 : sinx := 0.9962; |
    86 : sinx := 0.9976; |
    87 : sinx := 0.9986; |
    88 : sinx := 0.9994; |
    89 : sinx := 0.9998; |
    90 : sinx := 1.0000;
  END; (* CASE *)

  RETURN sinx;

END SIN;


PROCEDURE COS(x: REAL;VAR neg:BOOLEAN) : REAL;

VAR
    cosx,temp : REAL;

BEGIN

  temp := 1.5708 - x;
  WHILE temp< 0.0 DO
    temp := temp + TWOPI;
  END;
  cosx := SIN(temp,neg);
  RETURN cosx;

END COS;


PROCEDURE TAN(x: REAL) : REAL;

VAR tanx,cosx,sinx : REAL;
    neg1,neg2 : BOOLEAN;

BEGIN
  sinx := SIN(x,neg1);
  cosx := COS(x,neg2);
  tanx := sinx/cosx;
  RETURN tanx;
END TAN;


END MathLib0.
