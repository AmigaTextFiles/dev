; LITTEL

PROC main

   COPY 25 D0

   SELECT D0
   CASE 10
      INC d0 1
   CONT 20       ; if CASE 10, CONTinue from CASE 10
      INC  D0 2
   CASE 30
      INC  D0 3
   DEFAULT        ; not compulsory(?) anymore!
      SELECT d1
      CASE 25
         RETURN d1
      CASE 123
         SELECT _G4
         CASE _G3
         CASE 12
         ENDSELECT
      ENDSELECT
   ENDSELECT

   SELECT IF
   CASE d0 > 6
      inc d0
   CONT d1 = d0
      dec d2
   ENDSELECT
ENDPROC
END
