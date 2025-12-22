|##########|
|#MAGIC   #|GBIIIMKM
|#PROJECT #|"MuiImport"
|#PATHS   #|"StdProject"
|#LINK    #|""
|#GUIDE   #|""
|#STACK   #|"4096"
|#FLAGS   #|xx---x--xxx---x-----------------
|#USERSW  #|--------------------------------
|#USERMASK#|--------------------------------
|#SWITCHES#|xx----xxxx-xx---
|##########|
IMPLEMENTATION MODULE MCCDateString;

FROM MuiO IMPORT NewObjectA, MuiTagAPtr, DoMethodRef;


PROCEDURE MakeDateStringObjectA (tags : DateStringTagAPtr) : DateStringObject;

BEGIN
  RETURN NewObjectA (cDateString, MuiTagAPtr(tags));
END MakeDateStringObjectA;


PROCEDURE MakeDateStringObject (tags : LIST OF DateStringTags) : DateStringObject;

BEGIN
  RETURN NewObjectA (cDateString, MuiTagAPtr(tags[0]'PTR));
END MakeDateStringObject;

END MCCDateString.
