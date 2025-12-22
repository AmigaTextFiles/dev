MODULE alert; (* jr/19sep87 *)

FROM SYSTEM IMPORT
 ADR;
FROM Intuition IMPORT
 DisplayAlert;

VAR
 al: RECORD
  x1: CARDINAL; s1: ARRAY [0..59] OF CHAR; (* even number of chars !! *)
  x2: CARDINAL; s2: ARRAY [0..37] OF CHAR
 END;
BEGIN
 al.s1:="*Software Failure.   Press left mouse button to continue. ";
 al.x1:=96; al.s1[0]:=CHAR(15); al.s1[59]:=CHAR(1);
 al.s2:="* Guru Meditation #00019987.000JR000";
 al.x2:=176; al.s2[0]:=CHAR(28); al.s2[37]:=CHAR(0);
 IF DisplayAlert(0, ADR(al), 40) THEN END
END alert.mod
