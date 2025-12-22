|##########|
|#MAGIC   #|GLLFFJFL
|#PROJECT #|"MCCWheelDemo"
|#PATHS   #|"StdProject"
|#LINK    #|""
|#GUIDE   #|""
|#STACK   #|"4096"
|#FLAGS   #|xx---x--xxx-xxx-----------------
|#USERSW  #|--------------------------------
|#USERMASK#|--------------------------------
|#SWITCHES#|x----xxxxx-xx---
|##########|
IMPLEMENTATION MODULE MCCWheel;

FROM MuiO         AS mui IMPORT All;
FROM MCCWheelDispatcher  IMPORT wheelMCC;
FROM Intuition           IMPORT SetAttrs, BoopsiTags;

PROCEDURE MakeWheelObject (tags : LIST OF WheelTags) : GroupObject;
BEGIN
  RETURN NewCustomObjectA (wheelMCC.class, NIL, MuiTagAPtr(tags[0]'PTR));
END MakeWheelObject;

END MCCWheel.
