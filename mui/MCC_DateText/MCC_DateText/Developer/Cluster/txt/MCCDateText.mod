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
IMPLEMENTATION MODULE MCCDateText;

FROM MuiO IMPORT NewObjectA, MuiTagAPtr, DoMethodRef;


PROCEDURE MakeDateTextObjectA (tags : DateTextTagAPtr) : DateTextObject;

BEGIN
  RETURN NewObjectA (cDateText, MuiTagAPtr(tags));
END MakeDateTextObjectA;


PROCEDURE MakeDateTextObject (tags : LIST OF DateTextTags) : DateTextObject;

BEGIN
  RETURN NewObjectA (cDateText, MuiTagAPtr(tags[0]'PTR));
END MakeDateTextObject;

END MCCDateText.
