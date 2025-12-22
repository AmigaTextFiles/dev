OPT POINTER
MODULE 'target/PE/base'

->Replacement for AmigaE's OstrCmp(), which (possibly erratically) seems to incorrectly think these two characters are the same:
-> "A" = $41 = 065 = %01000001
-> "«" = $AB = 171 = %10101011
PROC OstrCmp(string1:ARRAY OF CHAR, string2:ARRAY OF CHAR, max=ALL, string1Offset=0, string2Offset=0) RETURNS sign:RANGE -1 TO 1
	DEF order:INT, char1:CHAR, index
	
	string1 := string1Offset*SIZEOF CHAR + string1
	string2 := string2Offset*SIZEOF CHAR + string2
	
	index := 0
	IF (index < max) OR (max=ALL)
		REPEAT
			char1 := string1[index]
			order := string2[index] - char1		->sign indicates order
			
			index++
		UNTIL (order<>0) OR (char1=0) OR ((index >= max) AND (max<>ALL))	->char1=0 catches case where both strings are same length
	ELSE
		order := 0
	ENDIF
	
	sign := Sign(order)
ENDPROC

->This is like OstrCmp() but it does not care about letter case
PROC OstrCmpNoCase(string1:ARRAY OF CHAR, string2:ARRAY OF CHAR, max=ALL, string1Offset=0, string2Offset=0) RETURNS sign:RANGE -1 TO 1
	DEF order:INT, char1:CHAR, char2:CHAR, index
	
	string1 := string1Offset*SIZEOF CHAR + string1
	string2 := string2Offset*SIZEOF CHAR + string2
	
	index := 0
	IF (index < max) OR (max=ALL)
		REPEAT
			char1:=string1[index]
			char2:=string2[index]
			
			IF (char1>="a") AND (char1<="z") THEN char1 := char1 - "a" + "A"
			IF (char2>="a") AND (char2<="z") THEN char2 := char2 - "a" + "A"
			
			order:=char2 - char1	->sign indicates order
			
			index++
		UNTIL (order<>0) OR (char1=0) OR ((index >= max) AND (max<>ALL))	->char1=0 catches case where both strings are same length
	ELSE
		order := 0
	ENDIF
	
	sign := Sign(order)
ENDPROC
