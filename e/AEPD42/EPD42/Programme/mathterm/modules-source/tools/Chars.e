OPT MODULE
OPT EXPORT

PROC isUpCase(ascii) IS (ascii>="A") AND (ascii<="Z")
PROC isLowCase(ascii) IS (ascii>="a") AND (ascii<="z") 
PROC isDigit(ascii) IS (ascii>="0") AND (ascii<="9")
PROC isAlpha(ascii) IS isUpCase(ascii) OR isLowCase(ascii)
