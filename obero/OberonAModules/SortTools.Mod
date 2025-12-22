(*
SortTools.MOD ©1998-99 Morten Bjergstrøm
EMail: mbjergstroem@hotmail.com
*)

<*MAIN-*>
MODULE SortTools;



PROCEDURE SwapInt(VAR n1,n2:INTEGER);

VAR
  n:INTEGER;

BEGIN

  n:=n1;
  n1:=n2;
  n2:=n;
  

END SwapInt;


PROCEDURE SwapLong(VAR n1,n2:LONGINT);

VAR
  n:LONGINT;

BEGIN

  n:=n1;
  n1:=n2;
  n2:=n;
  

END SwapLong;


PROCEDURE SelectSortL*(VAR values:ARRAY OF LONGINT);

VAR
  min,x,y:LONGINT;
  size:LONGINT;

BEGIN

  size:=LEN(values)-1;

  min:=0;

  FOR x:=1 TO size DO
    IF values[x]<values[min] THEN
      min:=x;
    END;
  END;
  SwapLong(values[min],values[0]);

  FOR y:=1 TO size-1 DO
    min:=y;
    FOR x:=y+1 TO size DO
      IF values[x]<=values[min] THEN
        min:=x;
        IF values[min]=values[y-1] THEN x:=size END;
      END;
    END;
    SwapLong(values[y],values[min]);
  END;

END SelectSortL;


PROCEDURE SelectSortInt*(VAR values:ARRAY OF INTEGER);

VAR
  min,x,y:LONGINT;
  size:LONGINT;

BEGIN

  size:=LEN(values)-1;

  min:=0;

  FOR x:=1 TO size DO
    IF values[x]<values[min] THEN
      min:=x;
    END;
  END;
  SwapInt(values[min],values[0]);

  FOR y:=1 TO size-1 DO
    min:=y;
    FOR x:=y+1 TO size DO
      IF values[x]<=values[min] THEN
        min:=x;
        IF values[min]=values[y-1] THEN x:=size END;
      END;
    END;
    SwapInt(values[y],values[min]);
  END;

END SelectSortInt;


PROCEDURE BubbleSortL*(VAR values:ARRAY OF LONGINT);

VAR
  t,l:LONGINT;
  slut:BOOLEAN;

BEGIN

  l:=LEN(values);
  slut:=TRUE;;

  REPEAT
    FOR t:=1 TO l-1 DO
      IF values[t-1]>values[t] THEN
        SwapLong(values[t-1],values[t]);
        slut:=FALSE;
      END;
    END;
    DEC(l);
    IF l=0 THEN
      slut:=TRUE;
    END;
  UNTIL slut;

END BubbleSortL;


PROCEDURE BubbleSortInt*(VAR values:ARRAY OF INTEGER);

VAR
  t,l:LONGINT;
  slut:BOOLEAN;

BEGIN

  l:=LEN(values);
  slut:=TRUE;;

  REPEAT
    FOR t:=1 TO l-1 DO
      IF values[t-1]>values[t] THEN
        SwapInt(values[t-1],values[t]);
        slut:=FALSE;
      END;
    END;
    DEC(l);
    IF l=0 THEN
      slut:=TRUE;
    END;
  UNTIL slut;

END BubbleSortInt;



PROCEDURE QSortInt*(l,r:INTEGER; VAR values:ARRAY OF INTEGER);

VAR
  i,j,x,y:INTEGER;

BEGIN
  i:=l;
  j:=r;
  x:=values[(l+r) DIV 2];
  REPEAT
    WHILE values[i]<x DO
      INC(i);
    END;
    WHILE x<values[j] DO
      DEC(j);
    END;
    IF i<=j THEN
      y:=values[i]; values[i]:=values[j]; values[j]:=y;
      INC(i); DEC(j);
    END;
  UNTIL i>j;
  IF l<j THEN QSortInt(l,j,values) END;
  IF i<r THEN QSortInt(i,r,values) END;

END QSortInt;


PROCEDURE QSortL*(l,r:LONGINT; VAR values:ARRAY OF LONGINT);

VAR
  i,j,x,y:LONGINT;

BEGIN
  i:=l;
  j:=r;
  x:=values[(l+r) DIV 2];
  REPEAT
    WHILE values[i]<x DO
      INC(i);
    END;
    WHILE x<values[j] DO
      DEC(j);
    END;
    IF i<=j THEN
      y:=values[i]; values[i]:=values[j]; values[j]:=y;
      INC(i); DEC(j);
    END;
  UNTIL i>j;
  IF l<j THEN QSortL(l,j,values) END;
  IF i<r THEN QSortL(i,r,values) END;

END QSortL;


END SortTools.
