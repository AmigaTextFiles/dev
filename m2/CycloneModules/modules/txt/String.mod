IMPLEMENTATION MODULE String;

(* (C) Copyright 1994 Marcel Timmermans. All rights reserved. *)

FROM SYSTEM IMPORT ASSEMBLE;

PROCEDURE Length(s:ARRAY OF CHAR):INTEGER;
(*$ EntryExitCode- *)
BEGIN
  ASSEMBLE(
    MOVE.L  (A7)+,A0 (* return address *)
    MOVE.L  (A7)+,A1 (* s *)
    MOVE.L  (A7)+,D0 (* HIGH(s) *)
    MOVE.L  D0,D1
  l:
    TST.B   (A1)+
    DBEQ    D1,l
    SUB.W   D1,D0     (* len:=HIGH(s)-D1 *)
    JMP     (A0)
  END);
END Length;

PROCEDURE Compare(a,b: ARRAY OF CHAR): INTEGER;
(*$ EntryExitCode- *)
BEGIN 
ASSEMBLE(
		MOVEM.L	D2-D7,-(A7)
		LEA	4+24(A7),A2
		MOVE.L	(A2)+,A0    (* b *)
		MOVE.L	(A2)+,D6    (* HIGH(b) *)
		MOVE.L	(A2)+,A1    (* a *)
		MOVE.L	(A2)+,D7    (* HIGH(a) *)

        	MOVE.W	D7,D4
        	SUB.W	D6,D4
        	MOVE.W	D4,D5
        	TST.W	D5
        	BLT.S	c1
        	MOVE.W	D6,D7
c1:
        	MOVEQ	#0,D6
loop:
        	CMP.W	D7,D6
        	BGT.S	exit
        	MOVE.B	0(A1,D6.W),D3
        	MOVE.B	0(A0,D6.W),D2
        	SUB.B	D2,D3
        	TST.B	D3
        	BNE.S	c2
        	TST.B	0(A1,D6.W)
        	BNE.S	c3
c2:
                MOVEQ   #0,D0
        	MOVE.B	D3,D0
        	BRA.S	end
c3:
        	ADDQ.W	#1,D6
        	BVC.S	loop
exit:
        	ADDQ.W	#1,D7
        	TST.W	D5
        	BGE.S	c5
        	TST.B	0(A0,D7.W)
        	BEQ.S	c5
        	BRA.S	c7
c5:
        	TST.W	D5
        	BLE.S	c6
        	TST.B	0(A1,D7.W)
        	BEQ.S	c6
        	BRA.S	c7
c6:
        	MOVEQ	#0,D0
        	BRA.S	end
c7:
        	MOVE.W	D5,D0
        	EXT.L	D0
end:
		MOVEM.L	(A7)+,D2-D7
                MOVE.L	(A7)+,A0
                LEA	16(A7),A7
                JMP	(A0)
                
END);
END Compare;


PROCEDURE Copy(VAR dest:ARRAY OF CHAR; src:ARRAY OF CHAR);
(*$ EntryExitCode- *)
BEGIN
  ASSEMBLE(
    MOVE.L  4(A7),A0    (* dest *)
    MOVE.L  8(A7),D0    (* HIGH(dest) *)     
    MOVE.L  12(A7),A1   (* src *)
    MOVE.L  16(A7),D1   (* HIGH(src) *)
    CMP.L   D1,D0
    BLE.S   n
    MOVE.L  D1,D0
  n:
    MOVE.B  (A0)+,(A1)+
    DBEQ    D0,n
    CLR.B  (A1)
    MOVEA.L (A7)+,A0
    LEA     4*4(A7),A7
    JMP	    (A0)
  END);  
END Copy;

PROCEDURE Delete(VAR s:ARRAY OF CHAR; start,len: INTEGER);
(*$ EntryExitCode- *)
BEGIN
ASSEMBLE(
        MOVEM.L D2-D4/A2,-(A7)
        LEA     4*4+4(A7),A0    
        MOVE.W  (A0)+,D2    (* len *)
        MOVE.W  (A0)+,D1    (* start *)
        MOVE.L  (A0)+,A1    (* s *)
        MOVE.L  (A0)+,D0    (* HIGH(s) *)

	ADD.W	D1,D2
L0:
	CMP.W	D0,D2
	BGT.S	L2
	MOVE.B	0(A1,D2.W),0(A1,D1.W)
	TST.B	0(A1,D2.W)
	BNE.S	L1
	BRA.S	L3
L1:
	ADDQ.W	#1,D1
	ADDQ.W	#1,D2
	BRA.S	L0
L2:
	CMP.W	D0,D1
	BGT.S	L3
	CLR.B	0(A1,D1.W)
L3:
        MOVEM.L (A7)+,D2-D4/A2
        MOVE.L  (A7)+,A0        (* return address *)
        LEA     8+2+2(A7),A7    (* fix stack *)
        JMP     (A0)
        END);

END Delete;

PROCEDURE Concat(VAR s1:ARRAY OF CHAR; s2:ARRAY OF CHAR);
(*$ EntryExitCode- *)
BEGIN
  ASSEMBLE(
	LINK    A5,#0
	MOVEM.L D4-D7/A2-A3,-(A7)
	MOVE.L	20(A5),D4
	MOVEA.L 16(A5),A3
	MOVE.L	D4,-(A7)
	MOVE.L  A3,-(A7)
	BSR	    Length
	MOVE.W	D0,D6
	MOVE.L	12(A5),-(A7)
	MOVEA.L 8(A5),A2
	MOVE.L	A2,-(A7)
	BSR	    Length
	MOVE.W	D0,D5
	MOVEQ	#0,D7
	EXT.L	D6
n:
	CMP.L	D4,D6
	BGE.S	n1
	CMP.W	D5,D7
	BGE.S	n1
	MOVE.B	0(A2,D7.W),0(A3,D6.W)
	ADDQ.W	#1,D6
	ADDQ.W	#1,D7
	BRA.S	n
n1:
	CMP.L	D4,D6
	BGE.S	end
	CLR.B	0(A3,D6.W)
end:
	MOVEM.L (A7)+,D5-D7/A2-A3
	UNLK	A5
	MOVEA.L (A7)+,A0
	LEA	16(A7),A7
	JMP	(A0)
  END);
END Concat;

PROCEDURE Occurs(VAR s:ARRAY OF CHAR; subs:ARRAY OF CHAR):INTEGER;
(*$  EntryExitCode- *)
(*  CopyDyn-  *)
(* VAR len,start,sublen,i{7},j{6}:INTEGER; *)
BEGIN
  ASSEMBLE(
    LINK	A5,#-6
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVE.L	20(A5),-(A7)
    MOVE.L	16(A5),-(A7)
    BSR     Length
    MOVE.W	D0,-2(A5)
    MOVE.L	12(A5),-(A7)
    MOVE.L	8(A5),-(A7)
    BSR	    Length
    MOVE.W  D0,-6(A5)
    CLR.W   -4(A5)
    MOVEA.L 16(A5),A3
    MOVEA.L 8(A5),A2
  lp:
    MOVE.W -2(A5),D5
    SUB.W  -6(A5),D5
    MOVE.W -4(A5),D4
    CMP.W  D5,D4
    BGT.S	 n4
    MOVE.W -4(A5),D7
    MOVEQ  #0,D6
n1:
    CMP.W	 -6(A5),D6
    BGE.S	 n2
    MOVE.B 0(A3,D7.W),D5 
    CMP.B	 (A2,D6.W),D5
    BNE.S	 n2
    ADDQ.W #1,D7
    ADDQ.W #1,D6
    BRA.S	 n1
n2:
    CMP.W	-6(A5),D6
    BNE.S	n3
    MOVE.W	-4(A5),D0
    EXT.L	D0
    BRA.S	end
n3:
    ADDQ.W	#1,-4(A5)
    BRA.S	lp
n4:
    MOVEQ	#-1,D0
end:
    MOVEM.L (A7)+,D4-D7/A2-A3
    UNLK	A5
    MOVEA.L (A7)+,A0
    LEA	16(A7),A7
    JMP	(A0)
  END);
(*
 len:=Length(s); sublen:=Length(subs); start:=0;
 WHILE start<=len-sublen DO
  i:=start; j:=0;
  WHILE (j<sublen) & (s[i]=subs[j]) DO INC(i); INC(j); END;
  IF j=sublen THEN RETURN start; END;
  INC(start);
 END;
 RETURN NoOccur; *)
END Occurs;

PROCEDURE Insert(VAR s:ARRAY OF CHAR; at:INTEGER; str:ARRAY OF CHAR);
(*$  EntryExitCode- *)
BEGIN
ASSEMBLE(
        MOVEM.L D2-D7/A2/A3,-(A7)
        LEA     8*4+4(A7),A0
        MOVE.L  (A0)+,A3        (* str *)
        MOVE.L  (A0)+,D2        (* HIGH(str) *)
        MOVE.W  (A0)+,D7        (* at *)
        MOVE.L  (A0)+,A2        (* s *)
        MOVE.L  (A0)+,D3        (* HIGH s *)        

        MOVE.L  D2,-(A7)
        MOVE.L  A3,-(A7)
        BSR     Length
        MOVE.L  D0,D4
        MOVE.L  D3,-(A7)
        MOVE.L  A2,-(A7)
        BSR     Length
        ADD.W   D4,D0           (* D4 = Distance *)
        MOVE.W  D0,D5           (* D5 = End *)
        CMP.W   D3,D5
        BLE.S   L2
        MOVE.W  D3,D5
L2:
        MOVE.W  D5,D6
        SUB.W   D4,D6           (* D6 = Start *)
L3:
        CMP.W   D7,D6
        BLT.S   L4
        MOVE.B  0(A2,D6.W),0(A2,D5.W)
        SUBQ.W  #1,D5
        SUBQ.W  #1,D6
        BVC.S   L3
L4:
        SUBQ.W  #1,D4
        MOVE.W  D7,D0
        ADD.W   D4,D0
        CMP.W   D3,D0
        BLE.S   L5
        MOVE.W  D3,D4
        SUB.W   D7,D4
L5:
        MOVEQ   #0,D6
L6:
        CMP.W   D4,D6
        BGT.S   L7
        MOVE.B  0(A3,D6.W),0(A2,D7.W)
        ADDQ.W  #1,D7
        ADDQ.W  #1,D6
        BVC.S   L6
L7:
        MOVEM.L (A7)+,D2-D7/A2/A3
        MOVE.L  (A7)+,A0        (* return address *)
        LEA     8+2+8(A7),A7    (* fix stack *)
        JMP     (A0)
     END);
END Insert;


PROCEDURE AppendChar(VAR String:ARRAY OF CHAR;Char:CHAR);
VAR
  Len:INTEGER;
BEGIN
  Len:=Length(String);
  IF Len<=HIGH(String) THEN
   String[Len]:=Char;
   IF Len<HIGH(String) THEN
     String[Len+1]:=0C;
   END;
  END;
END AppendChar;

PROCEDURE CapIntl(VAR Char:CHAR);
BEGIN
 CASE Char OF
  |"a".."z", "à".."ö","ø".."þ": DEC(Char,32);
 ELSE
 END;
END CapIntl;

PROCEDURE Upper(VAR s:ARRAY OF CHAR);
VAR
  i:INTEGER;
BEGIN
  i:=0;
  WHILE (i<=HIGH(s)) AND (s[i]#0C) DO s[i]:=CAP(s[i]); INC(i); END;
END Upper;

PROCEDURE UpperIntl(VAR s:ARRAY OF CHAR);
VAR
  i:INTEGER;
BEGIN
  i:=0;
  WHILE (i<=HIGH(s)) AND (s[i]#0C) DO CapIntl(s[i]);INC(i); END;
END UpperIntl;

PROCEDURE FindChar(s:ARRAY OF CHAR;ch:CHAR;Start:INTEGER):INTEGER;
(*$ CopyDyn- *)
VAR
  Step:INTEGER;
BEGIN
  IF Start<0 THEN
    Start:=-Start;
    Step:=-1;
  ELSE
    Step:=1;
  END;
  WHILE (Start<=HIGH(s)) AND (Start>=0) AND (s[Start]#0C) DO
    IF s[Start]=ch THEN
      RETURN Start
    END;
    INC(Start,Step);
  END;
  RETURN -1;
END FindChar;

END String.
