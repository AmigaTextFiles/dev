|##########|
|#MAGIC   #|GMGFGEJI
|#PROJECT #|"MCCWheelLib"
|#PATHS   #|"StdProject"
|#LINK    #|""
|#GUIDE   #|""
|#STACK   #|"4096"
|#FLAGS   #|xx---x--xxx-xxx-----------------
|#USERSW  #|--------------------------------
|#USERMASK#|--------------------------------
|#SWITCHES#|x--x-xxxxx-xx---
|##########|
IMPLEMENTATION MODULE MCCWheel;

FROM MuiO         AS mui IMPORT All;
FROM Intuition           IMPORT SetAttrs, BoopsiTags;

$$IF Library THEN
  $$RangeChk    := FALSE
  $$OverflowChk := FALSE
  $$ReturnChk   := FALSE
  $$StrZeroChk  := FALSE
  $$StackChk    := FALSE
  $$NilChk      := FALSE
$$END

PROCEDURE MakeWheelObject (tags : LIST OF WheelTags) : GroupObject;
BEGIN
  RETURN NewObjectA (cWheel, MuiTagAPtr(tags[0]'PTR));
END MakeWheelObject;

END MCCWheel.
