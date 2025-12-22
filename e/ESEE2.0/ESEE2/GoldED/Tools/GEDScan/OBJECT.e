-> Amiga E OBJECT scanner for GoldED's function-scanning features.
-> This piece of software is part of the ESEE 2.x distribution.

-> ESEE (E Source Editor Environment) is © 1994 by Leon Woestenberg.
-> Email me for comments at 'leon@stack.urc.tue.nl'.

;OPT ASM

  MOVE.L A1,-(A7)
  MOVE.L (A0),A1
test_for_object:
  CMP.B #79,(A1)
  BEQ.S maybe_object
maybe_export:
  CMP.B #69,(A1)
  BNE.W no_object_header
  CMP.B #88,1(A1)
  BNE.W no_object_header
  CMP.B #80,2(A1)
  BNE.W no_object_header
  CMP.B #79,3(A1)
  BNE.W no_object_header
  CMP.B #82,4(A1)
  BNE.W no_object_header
  CMP.B #84,5(A1)
  BNE.W no_object_header
  CMP.B #32,6(A1)
  BNE.W no_object_header
  ADDQ.L #7,(A0)
  ADDQ.L #7,A1
  SUBQ.L #7,D0
maybe_object:
  CMP.B #79,(A1)
  BNE.S no_object_header
  CMP.B #66,1(A1)
  BNE.S no_object_header
  CMP.B #74,2(A1)
  BNE.S no_object_header
  CMP.B #69,3(A1)
  BNE.S no_object_header
  CMP.B #67,4(A1)
  BNE.S no_object_header
  CMP.B #84,5(A1)
  BNE.S no_object_header
  ADDQ.L #6,(A0)
  ADDQ.L #6,A1
  SUBQ.L #6,D0
skip_spaces:
  CMP.B #32,(A1)
  BNE.S find_end_of_objectname
  SUBQ.L #1,D0
  ADDQ.L #1,(A0)
  ADDQ.L #1,A1
  JMP skip_spaces(PC)
find_end_of_objectname:

  ;-> remember linelength in D1, to prevent illegal memory access
  MOVE D0,D1
  ;-> determine the objectname length, keep this length into D0
  CLR.L D0
find_space_or_eol:
  CMP.B #32,(A1)
  BEQ.S finished
  ;-> A1 is the running pointer, and (A0) is frozen to start of objectname
  ADDQ.L #1,A1
  ADDQ.L #1,D0
  CMP.B D0,D1
  BEQ.S finished
  JMP find_space_or_eol(PC)
no_object_header:
  CLR.L D0
finished:
  MOVE.L (A7)+,A1
  RTS

CHAR '$VER: GoldED_OBJECT_Scanner 2.0 (22.10.94)',0
