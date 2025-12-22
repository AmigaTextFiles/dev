|##########|
|#MAGIC   #|FLPFCHAC
|#PROJECT #|"MCCTableGroupLib"
|#PATHS   #|"StdProject"
|#LINK    #|""
|#GUIDE   #|""
|#STACK   #|"4096"
|#FLAGS   #|xx-x-x--xxx-xxx-----------------
|#USERSW  #|--------------------------------
|#USERMASK#|--------------------------------
|#SWITCHES#|x--x-xxxxx-xx---
|##########|
IMPLEMENTATION MODULE MCCTableGroup;

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

(*
  seit spezielle SetTableAttrs-Prozedur verwendet wird,
  die forward an Table-Kinder verhindert,
  wird auch dieses Modul von der MCC eingebunden

LIBRARY IntuitionBase BY -648
  PROCEDURE SetTableAttrs (object IN A0 : GroupObject;
                           tags   IN A1 : LIST OF TableGroupTags);
*)

PROCEDURE SetTableAttrs (object : GroupObject;
                         tags   : LIST OF TableGroupTags);
BEGIN
  FORGET SetAttrs (object, MuiTags.groupForward : false, MOREA : tags[0]'PTR);
END SetTableAttrs;

PROCEDURE MakeTableGroupObject (tags : LIST OF TableGroupTags) : GroupObject;
BEGIN
  RETURN NewObjectA (cTableGroup, MuiTagAPtr(tags[0]'PTR));
END MakeTableGroupObject;

END MCCTableGroup.
