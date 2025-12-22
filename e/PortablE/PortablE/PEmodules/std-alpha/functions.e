/* stuff for functional programming */
OPT NATIVE

FUNC funcParam0empty() IS EMPTY
FUNC funcParam0     () OF funcParam0empty RETURNS value IS EMPTY

FUNC funcParam1empty(p1) IS EMPTY
FUNC funcParam1     (p1) OF funcParam1empty RETURNS value IS EMPTY

FUNC funcParam2empty(p1, p2) IS EMPTY
FUNC funcParam2     (p1, p2) OF funcParam2empty RETURNS value IS EMPTY

FUNC funcParam3empty(p1, p2, p3) IS EMPTY
FUNC funcParam3     (p1, p2, p3) OF funcParam3empty RETURNS value IS EMPTY

FUNC funcParam4empty(p1, p2, p3, p4) IS EMPTY
FUNC funcParam4     (p1, p2, p3, p4) OF funcParam4empty RETURNS value IS EMPTY

FUNC funcParam5empty(p1, p2, p3, p4, p5) IS EMPTY
FUNC funcParam5     (p1, p2, p3, p4, p5) OF funcParam5empty RETURNS value IS EMPTY

FUNC funcParam6empty(p1, p2, p3, p4, p5, p6) IS EMPTY
FUNC funcParam6     (p1, p2, p3, p4, p5, p6) OF funcParam6empty RETURNS value IS EMPTY

FUNC funcParam7empty(p1, p2, p3, p4, p5, p6, p7) IS EMPTY
FUNC funcParam7     (p1, p2, p3, p4, p5, p6, p7) OF funcParam7empty RETURNS value IS EMPTY

FUNC funcParam8empty(p1, p2, p3, p4, p5, p6, p7, p8) IS EMPTY
FUNC funcParam8     (p1, p2, p3, p4, p5, p6, p7, p8) OF funcParam8empty RETURNS value IS EMPTY


PROC Fmap(function:PTR TO funcParam1, list:LIST)
	DEF i
	FOR i := 0 TO ListLen(list)-1 DO list[i] := function(list[i])
ENDPROC list

PROC Freduce(function:PTR TO funcParam2, list:ILIST, init)
	DEF i, sum
	sum := init
	FOR i := 0 TO ListLen(list)-1 DO sum := function(sum, list[i])
ENDPROC sum
