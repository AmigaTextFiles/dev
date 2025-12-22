IMPLEMENTATION MODULE RealConvert;

(* (C) Copyright 1994 Marcel Timmermans. All rights reserved. *)

FROM SYSTEM IMPORT ASSEMBLE;
IMPORT mt:MathIEEESingTrans,
       mb:MathIEEESingBas;

PROCEDURE RealToString(r:REAL; VAR str: ARRAY OF CHAR; m,n:INTEGER;exp:BOOLEAN;VAR err:BOOLEAN);
VAR d,e,j,v:LONGINT;
    neg:BOOLEAN;

PROCEDURE Fill(c:CHAR); 
BEGIN
 str[j]:=c; INC(j);
END Fill;

BEGIN
  err:=TRUE; str[0]:=0C; j:=0; d:=0;  v:=0;
  IF (m<=0) OR (n<0) THEN RETURN END;
  e:=0; 
  neg:=r<0.0; 
  IF neg THEN r:=-r; END;
  IF m>HIGH(str) THEN m:=HIGH(str); END;
  r:=r+(mt.Pow(0.1,REAL(n))/2.0);
  WHILE r>=10.0 DO r:=r/10.0; INC(e); END; (* get exponent *)
  IF exp THEN
    IF r#0.0 THEN
      WHILE r<1.0 DO r:=r*10.0; DEC(e); END; 
    END;
  END;
  d:=e; (* DEC(d,e);*)
  IF neg THEN Fill('-') END;
  LOOP
   v:=TRUNC(r); 
   Fill(CHR(48+v)); 
   r:=(r-REAL(v))*10.0;
   IF d=-n THEN EXIT END;
   IF d=0 THEN Fill('.') END;
   DEC(d);
  END;
  IF exp THEN
   Fill('E'); 
   IF e<0 THEN e:=-e; Fill('-') ELSE Fill('+') END;
   d:=100;
   FOR v:=1 TO 2 DO d:=d DIV 10; Fill(CHR(48+e DIV d)); e:=e MOD d; END
  END;
  IF j<=HIGH(str) THEN Fill(0C) END; err:=FALSE;
END RealToString;


PROCEDURE StringToReal(str:ARRAY OF CHAR;VAR r:REAL;VAR err:BOOLEAN);
VAR ch:CHAR;
     j,m:INTEGER;
    tr:REAL;
    neg:BOOLEAN;

  PROCEDURE next; 
  BEGIN
    REPEAT
      IF j>HIGH(str) THEN ch:=0C; ELSE ch:=str[j]; END;
      INC(j);
    UNTIL ch#' '; 
  END next;
  
  PROCEDURE num():REAL;
  VAR rv:REAL;
  BEGIN
    rv:=0.0; m:=0;
    LOOP 
     IF (ch>='0') & (ch<='9') THEN 
      rv:=rv*10.0+REAL(ORD(ch)-ORD('0'));
     ELSE
      EXIT;
     END;
     next;
     INC(m);
    END;
  END num;

BEGIN
  j:=0; err:=TRUE; next;
  neg:=ch="-"; IF neg OR (ch="+") THEN next; END;
  r:=num();
  IF ch="." THEN next; r:=r+num() / mt.Pow(10.0,REAL(m)) END;
  IF neg THEN r:=-r; END;
  IF CAP(ch)="E" THEN
    next;
    neg:=ch="-"; IF neg OR (ch="+") THEN next; END;
    tr:=num();
    IF neg THEN tr:=-tr; END;
    r:=r*mt.Pow(tr,10.0);
  END;
  err:=ch=0C;
END StringToReal;


END RealConvert.
