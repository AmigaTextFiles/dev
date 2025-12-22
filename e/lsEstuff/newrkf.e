OPT MODULE

EXPORT CONST RKF_NOKEY=-1
EXPORT CONST RKFF_NOUP=%00000001,
             RKFF_NODOWN=%00000010,
             RKFF_NOREP=%00000100,
             RKFF_HEXNUM=%00001000,
             RKFF_DECNUM=%00010000

EXPORT OBJECT rkf
   PRIVATE
   filter:CHAR
   currkey:CHAR
   prevkey:CHAR
ENDOBJECT

PROC input(rk) OF rkf
   self.prevkey := self.currkey
   self.currkey := rk
ENDPROC

PROC get(filter) OF rkf
   DEF temp
   IF filter AND RKFF_NOREP
      IF self.currkey = self.prevkey THEN RETURN RKF_NOKEY
   ENDIF

   IF filter AND RKFF_NOUP
      IF self.currkey > 127 THEN RETURN RKF_NOKEY
   ENDIF

   IF filter AND RKFF_NODOWN
      IF filter < 128 THEN RETURN RKF_NOKEY
   ENDIF

   IF filter AND RKFF_HEXNUM
      temp := self.currkey
      IF temp > 127 THEN temp := temp - 128
      IF (temp < 10) AND (temp > 0) THEN RETURN temp
      SELECT temp
      CASE 10
         RETURN 0
      CASE 32
         RETURN 10
      CASE 53
         RETURN 11
      CASE 51
         RETURN 12
      CASE 34
         RETURN 13
      CASE 18
         RETURN 14
      CASE 35
         RETURN 15
      DEFAULT
         RETURN RKF_NOKEY
      ENDSELECT
   ENDIF

   IF filter AND RKFF_DECNUM
      temp := self.currkey
      IF temp > 127 THEN temp := temp - 128
      IF (temp < 10) AND (temp > 0) THEN RETURN temp
      RETURN RKF_NOKEY
   ENDIF

ENDPROC self.currkey

