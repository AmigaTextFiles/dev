OPT MODULE
SET PAD,LEFT,FIELD

EXPORT PROC stringf(str:PTR TO CHAR, format:PTR TO CHAR,
		    dataptr=NIL:PTR TO LONG)
DEF tempstr[80]:ARRAY, left, right,
    ch:REG,