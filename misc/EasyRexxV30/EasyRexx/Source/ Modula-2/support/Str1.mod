
(*
TODO
        1.Test "IF Start+PatternLen > Slen" in StrPos can fail because of
          integer overflow in the addition. Others also?
*)

(*#########################*)
 IMPLEMENTATION MODULE Str1;             (* v2.2amiga-091695 *)
(*#########################*)
(*$R-*) (*$D-*)
(*
   (c) Copyright 1984 Tom Breeden, All Rights Reserved

                           Aglet Software
                           PO Box 3314
                           Charlottesville, VA 22903
*)

FROM Str0 IMPORT StrAsg, StrLen, StrSet;

(* VERSION HISTORY

v1.0-012584       -Original, used for PDP11 and Sage for UCSD compilers

v2.0amiga-062286  -Null delimited string implementation.
                  -All open array params are VAR, as required by TDI
                   compiler.

v2.1amiga-021989  -For Benchmark compiler, removed VAR where appropriate.
                  -Use compiler switch to disable param copying.

v2.2amiga-091695  -Added StrLower().
                  -Removed IF test for 'a' to 'z' in StrCap().

*)

(*=================================================*)
 PROCEDURE ChrAsg(c:CHAR; VAR OutStr:ARRAY OF CHAR);
(*=================================================*)

VAR   temp    :ARRAY[0..0] OF CHAR;

BEGIN

temp[0] := c;
StrAsg(temp, OutStr);

END ChrAsg;

(*=================================================*)
 PROCEDURE ChrCat(c:CHAR; VAR OutStr:ARRAY OF CHAR);
(*=================================================*)

VAR   temp    :ARRAY[0..0] OF CHAR;

BEGIN

temp[0] := c;
StrCat(temp,OutStr);

END ChrCat;

(*================================================================*)
 PROCEDURE ChrPos(S:ARRAY OF CHAR; c:CHAR; Start:INTEGER) :INTEGER;
(*================================================================*)

VAR   temp    :ARRAY[0..0] OF CHAR;

BEGIN

temp[0] := c;
RETURN StrPos(S,temp,Start);

END ChrPos;

(*=================================================*)
 PROCEDURE ChrPre(c:CHAR; VAR OutStr:ARRAY OF CHAR);
(*=================================================*)

VAR   temp    :ARRAY[0..0] OF CHAR;

BEGIN

temp[0] := c;
StrPre(temp,OutStr);

END ChrPre;

(*====================================*)
 PROCEDURE StrCap(VAR S:ARRAY OF CHAR);
(*====================================*)

VAR   i   :INTEGER;

BEGIN

FOR i := 0 TO INTEGER(StrLen(S))-1 DO  (* Index error if StrLen is 0 and i is CARDINAL *)
     (*IF (S[i] >= 'a') AND (S[i] <= 'z') THEN*)
          S[i] := CAP(S[i]);
     (*END;*)
     END;

END StrCap;

(*======================================*)
 PROCEDURE StrLower(VAR S:ARRAY OF CHAR);
(*======================================*)

VAR i   :INTEGER;

BEGIN

FOR i := 0 TO INTEGER(StrLen(S))-1 DO
   IF (S[i] >= 'A') AND (S[i] <= 'Z') THEN
      S[i] := CHR(ORD(S[i])+32);
   END;
END;

END StrLower;

(*===============================================================*)
 PROCEDURE StrCat(Suffix:ARRAY OF CHAR; VAR OutStr:ARRAY OF CHAR);
(*===============================================================*)

VAR  SuffixLen,
     OutStrAvailSpace,
     CharsMoved,
     OutStrLen,
     ExtraSpace         :INTEGER;

BEGIN

SuffixLen := StrLen(Suffix);
OutStrLen := StrLen(OutStr);
OutStrAvailSpace := HIGH(OutStr)+1;
ExtraSpace := OutStrAvailSpace - SuffixLen - OutStrLen;

IF ExtraSpace < 0 THEN
   SuffixLen := SuffixLen + ExtraSpace;       (*i.e. subtract deficit*)
END;

CharsMoved := 0;
WHILE CharsMoved < SuffixLen DO
   OutStr[CharsMoved+OutStrLen] := Suffix[CharsMoved];
   INC(CharsMoved);
END;

StrSet(OutStr, OutStrLen+CharsMoved);

END StrCat;

(*====================================*)
 PROCEDURE StrClr(VAR S:ARRAY OF CHAR);
(*====================================*)

BEGIN

S[0] := 0C;

END StrClr;

(*==============================================*)
 PROCEDURE StrCmp(S1,S2:ARRAY OF CHAR) :INTEGER;
(*==============================================*)

(*
     This function compares two "strings".

OUTPUT
     <function value>    +1 = S1 > S2
                          0 = equality
                         -1 = S1 < S2

*)

VAR  S1Limit,S2Limit,
     i                  :INTEGER;

BEGIN

S1Limit := StrLen(S1)-1;
S2Limit := StrLen(S2)-1;
i := 0;

WHILE (i<=S1Limit) AND (i<=S2Limit) DO

   IF S1[i] > S2[i] THEN
      RETURN 1;
   ELSIF S1[i] < S2[i] THEN
      RETURN -1;
   END;

   INC(i);

END;

IF S1Limit > S2Limit THEN
   RETURN 1;
ELSIF S1Limit < S2Limit THEN
   RETURN -1;
ELSE
   RETURN 0;
END;

END StrCmp;

(*====================================*)
 PROCEDURE StrCut(VAR S:ARRAY OF CHAR);
(*====================================*)

(*
     This proc removes trailing blanks or null chars from the string parameter.

*)

VAR  i  :INTEGER;

BEGIN

i := StrLen(S);

REPEAT
   DEC(i);
UNTIL (i < 0) OR (S[i] <> ' ');

INC(i);

StrSet(S,i);

END StrCut;

(*=============================================*)
 PROCEDURE StrFill(c:CHAR; VAR S:ARRAY OF CHAR);
(*=============================================*)
(*
     StrFill fills the entire array of char with the indicated char.
*)

VAR  i          :CARDINAL;

BEGIN

FOR i := 0 TO HIGH(S) DO
   S[i] := c;
END;

END StrFill;

(*============================================*)
 PROCEDURE StrPad(c:CHAR; VAR S:ARRAY OF CHAR);
(*============================================*)
(*
        StrPad pads the entire "string" with the indicated char.
*)

VAR  i          :INTEGER;

BEGIN

FOR i := INTEGER(StrLen(S)) TO INTEGER(HIGH(S)) DO
   S[i] := c;
END;

END StrPad;

(*================================================================*)
 PROCEDURE StrPos(S,Pattern:ARRAY OF CHAR; Start:INTEGER) :INTEGER;
(*================================================================*)
(*

NOTE
        1.Nothing is ever found within the nullstr.
        2.Nothing is ever found if Start is beyond the end of the
          searched string.
        3.Otherwise, the nullstr is always found as a Pattern at Start.
*)

VAR  SLen,
     PatternLen,
     i,j                :INTEGER;
     Equal              :BOOLEAN;

BEGIN

IF Start < 0 THEN
   Start := 0
END;

SLen := StrLen(S);
PatternLen := StrLen(Pattern);

IF (Start+PatternLen) > SLen
   THEN RETURN -1

ELSIF PatternLen = 0 THEN
   IF Start < SLen THEN
      RETURN Start
   ELSE RETURN -1
   END;

ELSE
   i := Start-1;
   REPEAT
      INC(i);
      j := -1;
      REPEAT
         INC(j);
         Equal := (S[i+j] = Pattern[j]);
      UNTIL NOT Equal OR (j = PatternLen-1);
   UNTIL (Equal) OR (i = SLen - PatternLen);
   IF NOT Equal THEN
      RETURN -1
   ELSE RETURN i
   END;
END;

END StrPos;

(*===============================================================*)
 PROCEDURE StrPre(Prefix:ARRAY OF CHAR; VAR OutStr:ARRAY OF CHAR);
(*===============================================================*)

(*
     STRPRE puts Prefix in front of OutStr.

*)

VAR  PrefixLen,
     OutStrLen,
     OutStrSize,
     i,itemp,
     CharsToMove    :INTEGER;

BEGIN

PrefixLen := StrLen(Prefix);
OutStrLen := StrLen(OutStr);
OutStrSize := HIGH(OutStr)+1;

CharsToMove := OutStrLen;
itemp := (PrefixLen + OutStrLen) - OutStrSize;
IF itemp > 0 THEN
   CharsToMove := CharsToMove - itemp;
END;

(* Set length *)
StrSet(OutStr, PrefixLen + CharsToMove);

i := CharsToMove;
WHILE i > 0 DO
   OutStr[i-1+PrefixLen] := OutStr[i-1];
   DEC(i);
END;

CharsToMove := PrefixLen;
itemp := PrefixLen - OutStrSize;
IF itemp > 0 THEN
   CharsToMove := CharsToMove - itemp;
END;

i := CharsToMove;
WHILE i > 0 DO
   OutStr[i-1] := Prefix[i-1];
   DEC(i);
END;

END StrPre;

(*=======================================================*)
 PROCEDURE StrSeg(InStr:ARRAY OF CHAR; Start,Stop:INTEGER;
                  VAR OutStr:ARRAY OF CHAR);
(*=======================================================*)
(*

NOTE
        1.Always ok to assign a segment to itself.
*)

VAR  i,
     InStrLen,
     EndLoop,
     OutStrSize    :INTEGER;

BEGIN

InStrLen := StrLen(InStr);
OutStrSize := HIGH(OutStr)+1;
i := 0;

IF Start < 0 THEN
   Start := 0;
END;

IF (Start < InStrLen) AND (Stop >= 0) THEN

   IF Stop >= InStrLen THEN
      Stop := InStrLen-1;
   END;

   EndLoop := Stop - Start;
   IF EndLoop >= OutStrSize THEN
      EndLoop := OutStrSize-1;
   END;

   WHILE i <= EndLoop DO
      OutStr[i] := InStr[i+Start];
      INC(i);
   END;

END;

StrSet(OutStr,i);

END StrSeg;

END Str1.

