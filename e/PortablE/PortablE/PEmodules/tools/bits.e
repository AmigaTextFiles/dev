/* A re-implementation of the 'tools/bits' module, by Chris Handley on 07-07-2008.
   Based upon documention for bits.m v1.0 (07-Jun-96).
*/

PROC bitset(value,bit) IS Shl(%1,bit) OR value

PROC bitclear(value,bit) IS Not(Shl(%1,bit)) AND value

PROC bittest(value,bit) IS Shr(value, bit) AND %1 !!RANGE 0 TO 1
->alternative implementation: PROC bittest(value,bit) IS IF Shl(%1,bit) AND value THEN 1 ELSE 0

PROC bitchange(value,bit) IS IF bittest(value,bit) THEN bitclear(value,bit) ELSE bitset(value,bit)

PROC bitdset(value,bit,dep) IS IF dep THEN bitset(value,bit) ELSE bitclear(value,bit)

CONST SWAP_LONG=0, SWAP_HIGH=1, SWAP_LOW=2, SWAP_INNER=3, SWAP_OUTER=4, SWAPMAX=5

PROC swap(value,what)
	DEF newValue
	SELECT SWAPMAX OF what
	CASE SWAP_LONG  ; newValue := Shl(value AND $0000FFFF,16) OR Shr(value AND $FFFF0000,16)
	CASE SWAP_HIGH  ; newValue := Shl(value AND $00FF0000, 8) OR Shr(value AND $FF000000, 8) OR (value AND $0000FFFF)
	CASE SWAP_LOW   ; newValue := Shl(value AND $000000FF, 8) OR Shr(value AND $0000FF00, 8) OR (value AND $FFFF0000)
	CASE SWAP_INNER ; newValue := Shl(value AND $0000FF00, 8) OR Shr(value AND $00FF0000, 8) OR (value AND $FF0000FF)
	CASE SWAP_OUTER ; newValue := Shl(value AND $000000FF,24) OR Shr(value AND $FF000000,24) OR (value AND $00FFFF00)
	DEFAULT         ; newValue := value
	ENDSELECT
ENDPROC newValue

CONST SIZE_BYTE=8, SIZE_WORD=16, SIZE_LONG=32

PROC bintostr(value,size,str:ARRAY OF CHAR)
	DEF i
	FOR i := 0 TO size-1 DO str[i] := "0" + bittest(value,size-1-i) !!CHAR
	str[size] := 0
ENDPROC str

PROC strtobin(str:ARRAY OF CHAR,size)
	DEF value
	DEF i, bit:CHAR
	value := 0
	i := 0
	WHILE bit := str[i++]
		value := Shl(value,1) OR (bit - "0")
	ENDWHILE IF i >= size
ENDPROC value
