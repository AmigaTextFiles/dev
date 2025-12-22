|##########|
|#MAGIC   #|GGBAEEAJ
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
IMPLEMENTATION MODULE MCCTimeString;

FROM MuiO IMPORT NewObjectA, MuiTagAPtr, DoMethodRef;


PROCEDURE MakeTimeStringObjectA (tags : TimeStringTagAPtr) : TimeStringObject;

BEGIN
  RETURN NewObjectA (cTimeString, MuiTagAPtr(tags));
END MakeTimeStringObjectA;


PROCEDURE MakeTimeStringObject (tags : LIST OF TimeStringTags) : TimeStringObject;

BEGIN
  RETURN NewObjectA (cTimeString, MuiTagAPtr(tags[0]'PTR));
END MakeTimeStringObject;


END MCCTimeString.
