(********************************************************************************

Name         : date.MOD
Version      : 1.0
Purpose      : Date Conversion
Author       : ms
Modified     : 13.3.86  21:10  ms

********************************************************************************)

MODULE date;

FROM Terminal   IMPORT BusyRead, Write, WriteLn, WriteString;
FROM AMIGADos   IMPORT AMIGADateStamp, DateStamp, Delay;
FROM Breaks     IMPORT BreakFlags, DetectBreak;

(* By the way, this routine will fail on March 1, 2100. *)

VAR b: ARRAY [0..99] OF CHAR;
    j: CARDINAL;

PROCEDURE Put(s: CHAR);
BEGIN
  b[j]:=s; INC(j)
END Put;  

PROCEDURE PutS(s: ARRAY OF CHAR);
  VAR i: CARDINAL;
BEGIN
  i:=0;
  WHILE (i<=HIGH(s)) DO
    b[j]:=s[i]; INC(i); INC(j)
  END
END PutS;  

PROCEDURE WriteInt(int, size: INTEGER; leadingZeros: BOOLEAN);
CONST stLen = 9;
VAR   s: ARRAY [0..stLen] OF CHAR;
      i: INTEGER;
      minus: BOOLEAN;
      fillchar: CHAR;
BEGIN
  IF leadingZeros THEN fillchar:='0' ELSE fillchar:=' ' END;
  i:=stLen;
  minus:=int<0;
  int:=ABS(int);
  REPEAT
    s[i]:=CHR(ORD('0')+ORD(int MOD 10)); int:=int DIV 10; DEC(i)
  UNTIL int=0;
  IF minus THEN
    s[i]:='-'; DEC(i)
  END;
  WHILE size>stLen-i DO
    Put(fillchar); DEC(size)
  END;
  REPEAT
    INC(i); Put(s[i])
  UNTIL i=stLen;
END WriteInt;

VAR v: AMIGADateStamp;
    n, y, m, d: INTEGER;
    ch: CHAR;
BEGIN
  Write(14C);
  WriteString('Current Date and Time');
  WriteLn; 
  REPEAT
    j:=0;
    Put(' ');
    DateStamp(v);
    WITH v DO
      n:=SHORT(days)-2251;
      y:=(4*n+3) DIV 1461;
      n:=n-1461*y DIV 4;
      y:=y+1984;
      m:=(5*n+2) DIV 153;
      d:=n-(153*m+2) DIV 5 +1;
      m:=m+3;
      IF m>12 THEN y:=y+1 END;
      WriteInt(d, 2, FALSE); Put(' ');
      CASE m OF
      | 1: PutS('January');
      | 2: PutS('February');
      | 3: PutS('March');
      | 4: PutS('April');
      | 5: PutS('May');
      | 6: PutS('June');
      | 7: PutS('July');
      | 8: PutS('August');
      | 9: PutS('September');
      |10: PutS('October');
      |11: PutS('November');
      |12: PutS('December');
      ELSE PutS('unknown');
      END;
      Put(' ');
      WriteInt(y, 4, FALSE);
      PutS('   ');
      m:=SHORT(minutes);
      WriteInt(m DIV 60, 2, FALSE);
      Put(':');
      WriteInt(m MOD 60, 2, TRUE);
      Put(':');
      WriteInt(SHORT(ticks) DIV 50, 2, TRUE);
      Put(15C);
      Put(0C);
      WriteString(b);
      Delay(25)
    END;
  UNTIL DetectBreak(breakC)
END date.MOD
