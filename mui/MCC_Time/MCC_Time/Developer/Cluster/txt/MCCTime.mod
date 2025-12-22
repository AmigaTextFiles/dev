|##########|
|#MAGIC   #|GBIIIMLA
|#PROJECT #|"MuiImport"
|#PATHS   #|"StdProject"
|#LINK    #|""
|#GUIDE   #|""
|#STACK   #|"4096"
|#FLAGS   #|xx---x--xxx--xx-----------------
|#USERSW  #|--------------------------------
|#USERMASK#|--------------------------------
|#SWITCHES#|xx----xxxx-xx---
|##########|
IMPLEMENTATION MODULE MCCTime;

FROM MuiO IMPORT NewObjectA, MuiTagAPtr, DoMethodRef;


PROCEDURE MakeTimeObjectA (tags : TimeTagAPtr) : TimeObject;

BEGIN
  RETURN NewObjectA (cTime, MuiTagAPtr(tags));
END MakeTimeObjectA;


PROCEDURE MakeTimeObject (tags : LIST OF TimeTags) : TimeObject;

BEGIN
  RETURN NewObjectA (cTime, MuiTagAPtr(tags[0]'PTR));
END MakeTimeObject;


METHOD Increase   (o : TimeObject);

BEGIN
  DoMethodRef (o,MsgRoot:(mTimeIncrease));
END Increase;


METHOD Decrease   (o : TimeObject);

BEGIN
  DoMethodRef (o,MsgRoot:(mTimeDecrease));
END Decrease;


METHOD SetCurrent (o : TimeObject);

BEGIN
  DoMethodRef (o,MsgRoot:(mTimeSetCurrent));
END SetCurrent;

END MCCTime.
