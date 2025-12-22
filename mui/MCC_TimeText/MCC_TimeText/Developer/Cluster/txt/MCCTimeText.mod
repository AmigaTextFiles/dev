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
IMPLEMENTATION MODULE MCCTimeText;

FROM MuiO IMPORT NewObjectA, MuiTagAPtr, DoMethodRef;


PROCEDURE MakeTimeTextObjectA (tags : TimeTextTagAPtr) : TimeTextObject;

BEGIN
  RETURN NewObjectA (cTimeText, MuiTagAPtr(tags));
END MakeTimeTextObjectA;


PROCEDURE MakeTimeTextObject (tags : LIST OF TimeTextTags) : TimeTextObject;

BEGIN
  RETURN NewObjectA (cTimeText, MuiTagAPtr(tags[0]'PTR));
END MakeTimeTextObject;


END MCCTimeText.
