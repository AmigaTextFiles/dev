/*==========================================================================+
| word.e                                                                    |
| various byte/word/long/float conversions                                  |
+--------------------------------------------------------------------------*/

OPT MODULE

/*-------------------------------------------------------------------------*/

EXPORT PROC sbyte(byte)
	MOVE.L	byte,D0
	EXT.W	D0
	EXT.L	D0
ENDPROC D0

EXPORT PROC sword(word)
	MOVE.L	word,D0
	EXT.L	D0
ENDPROC D0

EXPORT PROC f2sbyte(float)
	DEF x
	x := !   128.0 * float !
	IF x >   127 THEN x :=   127 ELSE IF x <   -128 THEN x :=   -128
ENDPROC x AND   $FF

EXPORT PROC f2sword(float)
	DEF x
	x := ! 32768.0 * float !
	IF x > 32767 THEN x := 32767 ELSE IF x < -32768 THEN x := -32768
ENDPROC x AND $FFFF

EXPORT PROC sbyte2f(byte) IS byte ! /   128.0

EXPORT PROC sword2f(word) IS word ! / 32768.0

/*--------------------------------------------------------------------------+
| END: word.e                                                               |
+==========================================================================*/
