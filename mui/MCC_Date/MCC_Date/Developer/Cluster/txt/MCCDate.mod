|##########|
|#MAGIC   #|GDJAFDEM
|#PROJECT #|"Mui"
|#PATHS   #|"StdProject"
|#LINK    #|""
|#GUIDE   #|""
|#STACK   #|"4096"
|#FLAGS   #|xx---x--xxx--xx-----------------
|#USERSW  #|--------------------------------
|#USERMASK#|--------------------------------
|#SWITCHES#|xx----xxxx-xx---
|##########|
IMPLEMENTATION MODULE MCCDate;

FROM MuiO IMPORT NewObjectA, MuiTagAPtr, DoMethodRef;


PROCEDURE MakeDateObjectA (tags : DateTagAPtr) : DateObject;

BEGIN
  RETURN NewObjectA (cDate, MuiTagAPtr(tags));
END MakeDateObjectA;


PROCEDURE MakeDateObject (tags : LIST OF DateTags) : DateObject;

BEGIN
  RETURN NewObjectA (cDate, MuiTagAPtr(tags[0]'PTR));
END MakeDateObject;

END MCCDate.
