IMPLEMENTATION MODULE Convert;

(* (C) Copyright 1993 Marcel Timmermans. All rights reserved. *)

FROM String IMPORT Length;

PROCEDURE IntToStr(int:LONGINT; VAR str:ARRAY OF CHAR; len:INTEGER; VAR success:BOOLEAN);
CONST base = 10;
      maxstr = 31;
VAR minus : BOOLEAN;
    i,j,l:INTEGER;
    s:ARRAY[0..maxstr] OF CHAR;
BEGIN
 str[0]:=0C; success:=FALSE;
 minus := int<0; IF minus THEN int:=-int; END;
 i:=0; 
 REPEAT 
  s[i]:= CHR(int MOD base + ORD("0"));
  int:=int DIV base;
  INC(i);
 UNTIL int=0;
 IF minus THEN s[i]:='-'; INC(i); END;
 IF i>HIGH(str) THEN RETURN END; (* too many digit's *)
 j:=0; l:=i;
 WHILE l<len DO str[j]:=' '; INC(j); INC(l); END;
 WHILE i>0 DO DEC(i); str[j]:=s[i]; INC(j); END;
 str[j]:=0C;
 success:=TRUE;
END IntToStr;

PROCEDURE CardToStr(int:LONGCARD; VAR str:ARRAY OF CHAR; len:INTEGER; VAR success:BOOLEAN);
CONST base = 10;
      maxstr = 31;
VAR minus : BOOLEAN;
    i,j,l:INTEGER;
    s:ARRAY[0..maxstr] OF CHAR;
BEGIN
 str[0]:=0C; success:=FALSE;
 i:=0; 
 REPEAT 
  s[i]:= CHR(int MOD base + ORD("0"));
  int:=int DIV base;
  INC(i);
 UNTIL int=0;
 IF i>HIGH(str) THEN RETURN END; (* too many digit's *)
 j:=0; l:=i;
 WHILE l<len DO str[j]:=' '; INC(j); INC(l); END;
 WHILE i>0 DO DEC(i); str[j]:=s[i]; INC(j); END;
 str[j]:=0C;
 success:=TRUE;
END CardToStr;

PROCEDURE StrToInt(str:ARRAY OF CHAR; VAR int:LONGINT;  VAR success:BOOLEAN);
VAR
  i,l,n: INTEGER;
  ch   : CHAR;
  neg  : BOOLEAN;
  hex  : BOOLEAN;

  PROCEDURE Next;
  BEGIN
    IF i=l THEN ch := 0C ELSE ch := CAP(str[i]); INC(i) END;
  END Next;

BEGIN 
 success:=TRUE;
 l:=Length(str);
 WHILE (l>0) AND (str[l-1]=' ') DO DEC(l); END;
 hex := (l>0) AND (str[l-1]='H');
 i:=0; int:=0;
 REPEAT Next UNTIL ch#' ';
 IF hex THEN
   n:=0;
   LOOP
    CASE ch OF
       '0'..'9' : IF n=8 THEN success:=FALSE; EXIT END;
                  int:=16*int+ORD(ch)-ORD('0');
     | 'A'..'F' : IF n=8 THEN success:=FALSE; EXIT END;
                  int:=16*int+ORD(ch)+(10-ORD('A'));
    ELSE
     success:=ch='H';
     EXIT;
    END;
    Next; INC(n);
   END;
 ELSE
   neg:=FALSE;
   CASE ch OF 
    '-','+' : neg:=ch='-'; Next 
   ELSE END;
   LOOP
    CASE ch OF
     '0'..'9': n:=ORD(ch)-ORD('0');
               IF int>(MAX(LONGINT)-n) DIV 10 THEN 
                 success:=FALSE;
                 EXIT;
               ELSE 
                 int:=10*int+n;
               END;
    ELSE
     IF neg THEN int:=-int END;
     success:=ch=0C;
     EXIT;
    END;
    Next;
   END;
 END;
END StrToInt;

BEGIN
END Convert.
