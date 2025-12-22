|##########|
|#MAGIC   #|FPIAEPCC
|#PROJECT #|"Mui"
|#PATHS   #|"StdProject"
|#LINK    #|""
|#GUIDE   #|""
|#STACK   #|"4096"
|#FLAGS   #|xx---x--xxx---x-----------------
|#USERSW  #|--------------------------------
|#USERMASK#|--------------------------------
|#SWITCHES#|xx----xxxx-xx---
|##########|
IMPLEMENTATION MODULE MCCMonthNavigator;

FROM MuiO IMPORT NewObjectA, MuiTagAPtr, DoMethodRef;


PROCEDURE MakeMonthNavigatorObjectA (tags : MonthNavigatorTagAPtr) : MonthNavigatorObject;

BEGIN
  RETURN NewObjectA (cMonthNavigator, MuiTagAPtr(tags));
END MakeMonthNavigatorObjectA;


PROCEDURE MakeMonthNavigatorObject (tags : LIST OF MonthNavigatorTags) : MonthNavigatorObject;

BEGIN
  RETURN NewObjectA (cMonthNavigator, MuiTagAPtr(tags[0]'PTR));
END MakeMonthNavigatorObject;


METHOD Update (o : MonthNavigatorObject);

BEGIN
  DoMethodRef (o,MsgRoot:(mMonthNavigatorUpdate));
END Update;

END MCCMonthNavigator.
