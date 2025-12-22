OPT MODULE

EXPORT CONST RKF_ERR=-80
EXPORT SET RKF_NOKEYCODEREP, RKF_NOKEYUP, RKF_NOKEYDOWN


OBJECT rkfilter
PRIVATE
   rkeyrep:INT
   filter:LONG
   temp:LONG
ENDOBJECT

EXPORT PROC rkfilter_new()
   DEF rkf:PTR TO rkfilter
   rkf:=FastNew(SIZEOF rkfilter)
   rkf.rkeyrep:=-1
ENDPROC rkf

EXPORT PROC rkfilter_end(rkf:PTR TO rkfilter)
   FastDispose(rkf, SIZEOF rkfilter)
ENDPROC

EXPORT PROC rkfilter_add(rkf:PTR TO rkfilter, newfilter)
   rkf.filter:=rkf.filter OR newfilter
ENDPROC rkf.filter

EXPORT PROC rkfilter_chk(rkf:PTR TO rkfilter, filter)
   rkf.temp:=rkf.filter AND filter
   IF rkf.temp=filter THEN RETURN TRUE ELSE RETURN FALSE
ENDPROC

EXPORT PROC rkfilter_del(rkf:PTR TO rkfilter, filter)
   rkf.filter:=rkf.filter AND Not(filter)
ENDPROC

EXPORT PROC rkfilter_toggle(rkf, filter)
   IF rkfilter_chk(rkf, filter)=FALSE
      rkfilter_add(rkf, filter)
      RETURN 1
   ELSE
      rkfilter_del(rkf, filter)
      RETURN NIL
   ENDIF
ENDPROC

EXPORT PROC rkfilter(rkf:PTR TO rkfilter, rkcode)
   rkf.temp:=rkf.filter AND RKF_NOKEYCODEREP
   IF (rkcode=rkf.rkeyrep) AND (rkf.temp=RKF_NOKEYCODEREP)
      rkf.rkeyrep:=rkcode
      RETURN RKF_ERR
   ENDIF
   rkf.rkeyrep:=rkcode

   rkf.temp:=rkf.filter AND RKF_NOKEYUP
   IF (rkf.temp=RKF_NOKEYUP) AND (rkcode>127) THEN RETURN RKF_ERR

   rkf.temp:=rkf.filter AND RKF_NOKEYDOWN
   IF (rkf.temp=RKF_NOKEYDOWN) AND (rkcode<128) THEN RETURN RKF_ERR
ENDPROC rkcode
